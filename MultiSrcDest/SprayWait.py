#!/usr/bin/python3
# Simulator for the Source Spray and Wait protocol

import simpy
import numpy

# Control variables for logging/tracing output
SOURCE_TRACE = 1
RELAY_TRACE = 0

# Source Class
# - Models the source node 
# - There is a Poisson arrival process of packets at the source node, with rate arrival_rate
# - The source is assumed to hold initial_queue_length number of packets at the start of the simulation
# - The packets flowing from a particular source to a destination are identified by the unique flow_id

class Source:
    def __init__(self, env, arrival_rate, initial_queue_length, flow_id, number_copies, outputfile):
        self.env = env
        self.action = env.process(self.run())
        self.arrival_rate = arrival_rate
        self.queue_length = initial_queue_length
        self.flow_id = flow_id
        self.number_copies = number_copies
        self.service_stage = 1
        self.outputfile = outputfile
        
        if SOURCE_TRACE:
            self.outputfile.write('Source,%u,0,Initialization,%u,%u\n' % (self.flow_id, self.service_stage, self.queue_length))
                    
    def serve_packet(self):
        if self.queue_length > 0:
            if self.service_stage < self.number_copies:
                self.service_stage = self.service_stage + 1
                if SOURCE_TRACE:
                    self.outputfile.write('Source,%u,%f,Service,%u,%u\n' % \
                                          (self.flow_id, self.env.now, self.service_stage, self.queue_length))
                return self.flow_id
            
            else:                                    
                self.queue_length = self.queue_length - 1
                self.service_stage = 1
                if SOURCE_TRACE:
                    self.outputfile.write('Source,%u,%f,Service,%u,%u\n' % \
                                          (self.flow_id, self.env.now, self.service_stage, self.queue_length))
                return self.flow_id
        else:
            return -1
        
    def run(self):
        while True:
            next_arrival_epoch = numpy.random.exponential(1.0 / self.arrival_rate)
            yield self.env.timeout(next_arrival_epoch)
            self.queue_length = self.queue_length + 1            
            if SOURCE_TRACE:
                self.outputfile.write('Source,%u,%f,Arrival,0,%u\n' % (self.flow_id, self.env.now, self.queue_length))

# Destination class
# - Models the destination for a flow id
# - Currently only updates the number of delivered packet copies
# - TODO: Modify to count only the number of unique packets

class Destination:
    def __init__(self, flow_id):
        self.flow_id = flow_id
        self.number_of_delivered_packets = 0
        
    def deliver_packet(self):
        self.number_of_delivered_packets = self.number_of_delivered_packets + 1        

# Relay class
# - Models the relay
# - The relay meets both sources and destinations
# - Each source or destination meeting process is modelled separately
# - When the relay meets a source, if the relay's queue length is less than the maximum buffer size of the relay then a packet is served from the source to the relay

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
                packet_id = src.serve_packet()
                if not packet_id == -1:
                    self.queue.insert(0, packet_id)
                    if RELAY_TRACE:
                        self.outputfile.write('Relay,%u,%f,SourceMeeting,%u,%u\n' % (self.relay_id, self.env.now, src.flow_id, len(self.queue)))
            
    def meet_destination(self, dest):
        while True:
            next_meeting_time = numpy.random.exponential(1.0 / self.meeting_rate)
            yield self.env.timeout(next_meeting_time)
            
            if dest.flow_id in self.queue:
                del self.queue[self.queue.index(dest.flow_id)]
                dest.deliver_packet()
                if RELAY_TRACE:
                    self.outputfile.write('Relay,%u,%f,DestinationMeeting,%u,%u\n' % (self.relay_id, self.env.now, dest.flow_id, len(self.queue)))


# Simulation
def Simulation(number_sources, list_packet_arrivalrates, number_copies, number_relays, \
               relay_buffersize, relay_meetingrate, sim_maxruntime, outputfile_name):
    
    outputfile = open(outputfile_name, "w")
    env = simpy.Environment()

    sources = []
    destinations = []
    for i in range(number_sources):
        sources.insert(0, Source(env, list_packet_arrivalrates[i], 0, i, number_copies, outputfile))
        destinations.insert(0, Destination(i))

    relays = []
    for i in range(number_relays):
        relays.insert(0, Relay(env, i, relay_meetingrate, relay_buffersize, sources, destinations, outputfile))

    env.run(until=sim_maxruntime)
    outputfile.close()
