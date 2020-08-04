#!/usr/bin/python3
# CHANGE: 12-07-2019 - enforce FIFO order of service at the source instead of the arbitrary order of service
# CHANGE: 09-07-2019 - self-monitoring of the source queue - if the average source queue length is large then we can exit early
# CHANGE: 26-06-2019 - inclusion of instantaneous packet feedback.

# Simulator for the Source Spray and Wait protocol for a single source destination pair
# Note that this implements the spray and wait protocol as detailed in the WiOpt paper and is different from 
# the protocol implementation in other folders (which assumes that the same relay can hold multiple copies of a packet)
import simpy
import numpy
import sys

# Control variables for logging/tracing output
SOURCE_TRACE = 1
DESTINATION_TRACE = 0
RELAY_TRACE = 0
PACKET_TRACE = 1

# Magic number (arbitrary) for controlling exit from the simulation
AVERAGE_QUEUE_EXIT = 500

# Source Class
# - Models the source node 
# - There is a Poisson arrival process of packets at the source node, with rate arrival_rate
# - The source is assumed to hold zero packets at the start of the simulation
# - The packets flowing from a particular source to a destination are identified by the unique flow_id
# - Each packet for a source is identified by a unique packet_id (which starts from zero) which is
# - incremented whenever a new packet arrives
# - Each source also contains a queue which is implemented as a dictionary; each dictionary element is a tuple
# - consisting of the packet_id and the number of service stages
class Source:
    def __init__(self, env, arrival_rate, number_copies, outputfile, max_buffersize):
        self.env = env
        self.action = env.process(self.run())
        self.arrival_rate = arrival_rate
        self.queue = {}
        self.packet_id_queue = []
        self.packet_id = 0
        self.number_copies = number_copies
        self.outputfile = outputfile
        self.max_buffersize = max_buffersize
        self.average_queue = 0
        self.average_queue_n = 1
        
        if SOURCE_TRACE:
            self.outputfile.write('Source,Initialization,0,0\n')
    # copies a packet from the source to the met relay
    # the packet is copied based on whether the relay already has a copy of the packet or not, for which
    # the relay object is taken as an input.
    def serve_packet(self, relay):
        queue_length = len(self.queue)
        if queue_length > 0: # if queue length is > 0 then compare the packet_ids in the relay's queue with what we have
            packet_ids_in_relayqueue = set(relay.queue) # the set of packet_ids in the relay's queue
            packet_ids_yet_to_copy = set(self.queue.keys()) - packet_ids_in_relayqueue # the set to copy
            if len(packet_ids_yet_to_copy) > 0: # if all packets in source are there in the relay
                for id in self.packet_id_queue: # sort the packet_ids in the FIFO order of their arrival, packet_id_queue update is assumed to be correct
                    if id in packet_ids_yet_to_copy:
                        packet_id_to_copy = id
                        break

                if self.queue[packet_id_to_copy] < self.number_copies: # if number of copies already made is less than the max number
                    if SOURCE_TRACE:
                        self.outputfile.write('Source,PktCopy,%f,%u\n' % (self.env.now, packet_id_to_copy))
                    if PACKET_TRACE:
                        if self.queue[packet_id_to_copy] == 1:
                            self.outputfile.write('Packet,SRPktFirstCopy,%f,%u\n' % (self.env.now, packet_id_to_copy))
                        self.outputfile.write('Packet,SRPktCopy,%f,%u\n' % (self.env.now, packet_id_to_copy))
                    self.queue[packet_id_to_copy] = self.queue[packet_id_to_copy] + 1
                    return packet_id_to_copy # we return the packed_id which needs to be copied to the relay
                else:
                    if PACKET_TRACE:
                        if self.queue[packet_id_to_copy] == 1:
                            self.outputfile.write('Packet,SRPktFirstCopy,%f,%u\n' % (self.env.now, packet_id_to_copy))
                        self.outputfile.write('Packet,SRPktCopy,%f,%u\n' % (self.env.now, packet_id_to_copy))
                        self.outputfile.write('Packet,SRPktLastCopy,%f,%u\n' % (self.env.now, packet_id_to_copy))
                    del(self.queue[packet_id_to_copy])
                    self.packet_id_queue.remove(packet_id_to_copy)
                    return packet_id_to_copy
            else:
                return -1
        else:
            return -1

    # whenever the delivery of a packet occurs, this is called from the destination, so that if this packet exists in queue
    # it is deleted to make space for other packets
    def delete_packet_on_delivery(self, packet_id):
        if packet_id in self.queue.keys():
            del self.queue[packet_id]
            self.packet_id_queue.remove(packet_id)
            if SOURCE_TRACE:
                self.outputfile.write('Source,PktDeleted,%f,%u\n' % (self.env.now, packet_id))
        
    def run(self):
        while True:
            next_arrival_epoch = numpy.random.exponential(1.0 / self.arrival_rate)
            yield self.env.timeout(next_arrival_epoch)
            # when a new arrival happens we increment the unique packet_id and add that to the queue with the service stage set to 0
            # if the number of packets in the queue buffer is <= max_buffersize
            if PACKET_TRACE:
                self.outputfile.write('Packet,PktArrival,%f,%u\n' % (self.env.now, 0))

            self.average_queue = ((self.average_queue_n - 1.0) * self.average_queue + len(self.queue)) / self.average_queue_n
            self.average_queue_n = self.average_queue_n + 1
            if self.average_queue > AVERAGE_QUEUE_EXIT:
                raise Exception("Unstable")
            if len(self.queue) < self.max_buffersize:
                self.packet_id = self.packet_id + 1
                self.queue[self.packet_id] = 1
                self.packet_id_queue.append(self.packet_id)
                if SOURCE_TRACE:
                    self.outputfile.write('Source,Arrival,%f,%u\n' % (self.env.now, self.packet_id))
            else:
                if SOURCE_TRACE:
                    self.outputfile.write('Source,Drop,%f,%u\n' % (self.env.now, 0))
                    
            
# Destination class
# - Models the destination for a flow id
# - Currently only updates the number of delivered packet copies
# - TODO: Modify to count only the number of unique packets
class Destination:
    def __init__(self, source):
        self.number_of_delivered_packets = 0
        self.source_of_packets = source

    def set_relays(self, list_of_relays):
        self.list_of_relays = list_of_relays
        
    def deliver_packet(self, packet_id):
        self.source_of_packets.delete_packet_on_delivery(packet_id)
        for r in self.list_of_relays:
            r.delete_packet_on_delivery(packet_id)
        
        self.number_of_delivered_packets = self.number_of_delivered_packets + 1        

# Relay class
# - Models the relay
# - The relay meets both sources and destinations
# - Each source or destination meeting process is modelled separately
# - When the relay meets a source, if the relay's queue length is less than the maximum buffer size of the relay 
# - then a packet is served from the source to the relay, using the serve_packet implementation of the source
# - Each relay also contains a queue which is a list of packet ids
class Relay:
    def __init__(self, env, relay_id, meeting_rate, max_buffersize, list_of_sources, list_of_destinations, outputfile):
        self.env = env
        self.relay_id = relay_id
        self.meeting_rate = meeting_rate
        self.max_buffersize = max_buffersize
        self.list_of_sources = list_of_sources
        self.list_of_destinatons = list_of_destinations
        self.meeting_sources = []
        self.meeting_destinations = []
        self.queue = []
        self.outputfile = outputfile       
        for src, dest in zip(list_of_sources, list_of_destinations):
            self.meeting_sources.insert(0, env.process(self.meet_source(src)))
            self.meeting_destinations.insert(0, env.process(self.meet_destination(dest)))
            
    def meet_source(self, src):
        while True:
            next_meeting_time = numpy.random.exponential(1.0 / self.meeting_rate)
            yield self.env.timeout(next_meeting_time)
            if len(self.queue) < self.max_buffersize:
                packet_id = src.serve_packet(self)
                if not packet_id == -1:
                    self.queue.insert(0, packet_id)
                    if RELAY_TRACE:
                        self.outputfile.write('Relay,%u,%f,SourceMeeting,%u\n' % \
                                              (self.relay_id, self.env.now, len(self.queue)))
    def meet_destination(self, dest):
        while True:
            next_meeting_time = numpy.random.exponential(1.0 / self.meeting_rate)
            yield self.env.timeout(next_meeting_time)
            if len(self.queue) > 0:
            # while len(self.queue) > 0:
                if RELAY_TRACE:
                    self.outputfile.write('Relay,%u,%f,DestinationMeeting,%u\n' % \
                                          (self.relay_id, self.env.now, len(self.queue)))
                
                ## Random order of service
                # random_packet_index = numpy.random.choice(len(self.queue))
                packet_id_to_remove = self.queue[0]
                if PACKET_TRACE:
                    self.outputfile.write('Packet,RDPktCopy,%f,%u\n' % (self.env.now, packet_id_to_remove))
                dest.deliver_packet(packet_id_to_remove)

                # LIFO order of service
                # if PACKET_TRACE:
                #    self.outputfile.write('Packet,RDPktCopy,%f,%u\n' % (self.env.now, self.queue[0]))
                # dest.deliver_packet(self.queue[0])
                
                # del self.queue[0]; # the packet will be deleted when the delete packet on delivery is called, so don't use this here!

    # whenever the delivery of a packet occurs, this is called from the destination, so that if this packet exists in queue
    # it is deleted to make space for other packets
    def delete_packet_on_delivery(self, packet_id):
        if packet_id in self.queue:
            self.queue.remove(packet_id) # unique packet_id so that it can be removed
            if RELAY_TRACE:
                self.outputfile.write('Relay,PktDeleted,%f,%u\n' % (self.env.now, packet_id))

# Simulation
def Simulation(number_sources, list_packet_arrivalrates, number_copies, number_relays, \
               relay_buffersize, source_buffersize, relay_meetingrate, sim_maxruntime, outputfile_name):
    outputfile = open(outputfile_name, "w")
    env = simpy.Environment()
    
    sources = []
    destinations = []
    for i in range(number_sources):
        t_source = Source(env, list_packet_arrivalrates[i], number_copies, outputfile, source_buffersize)
        t_destination = Destination(t_source)
        sources.insert(0, t_source)
        destinations.insert(0, t_destination)

    relays = []
    for i in range(number_relays):
        relays.insert(0, Relay(env, i, relay_meetingrate, relay_buffersize, sources, destinations, outputfile))

    for d in destinations:
        d.set_relays(relays)
    try: 
        env.run(until=sim_maxruntime)
    except:
        outputfile.close()
    outputfile.close()
    
