#!/usr/bin/python3
#Change 11/07/2019 - exception handling for the Unstable exception caused due to queue self-monitoring

#Runner script for the single source destination scenario when the configuration can also have a list of buffer sizes
import pandas as pd
import numpy as np
import SprayWait
import sys

print("**** " + sys.argv[1])
configuration = pd.read_excel(sys.argv[1], index_col=0)
number_scenarios = configuration.shape[1]

for scenario in range(number_scenarios):
    scenario_params = configuration[scenario]
    if scenario_params.numRuns == 0:
        continue
    # np.random.seed(0)
    print("********** " + str(scenario))
    results_outfile = open(scenario_params.fileName, "w")
    results_outfile.write("Run,NumSources,CommnArrivalRate,ArrivalRate,NumCopies,NumRelays,RelayBuffer,SourceBuffer,MeetingRate")
    results_outfile.write(",AvgQDelay,StdQDelay,AvgDDelay,StdDDelay,FractionDropped\n")
    sourceBufferSize = scenario_params.sourceBufferSize
    for run in range(scenario_params.numRuns + 1):        
        for arrival_rate in np.arange(scenario_params.arrivalRateMin, \
                                      scenario_params.arrivalRateMax + scenario_params.arrivalRateStep, \
                                      scenario_params.arrivalRateStep):
            for meeting_rate in np.arange(scenario_params.meetingRateMin, \
                                          scenario_params.meetingRateMax + scenario_params.meetingRateStep, \
                                          scenario_params.meetingRateStep):
                for number_relays in np.arange(scenario_params.numRelayMin, \
                                               scenario_params.numRelayMax + scenario_params.numRelayStep, \
                                               scenario_params.numRelayStep):
                    for number_copies in np.arange(scenario_params.numCopiesMin, \
                                                   scenario_params.numCopiesMax + scenario_params.numCopiesStep, \
                                                   scenario_params.numCopiesStep):
                        for bufferSize in np.arange(scenario_params.bufferMin, \
                                                     scenario_params.bufferMax + scenario_params.bufferStep, \
                                                     scenario_params.bufferStep):
                            list_packet_arrivalrates = [scenario_params.commonArrivalRate] * (scenario_params.numSources - 1)
                            list_packet_arrivalrates.insert(0, arrival_rate) 

                            try:
                                SprayWait.Simulation(scenario_params.numSources, list_packet_arrivalrates, number_copies, \
                                                     number_relays, bufferSize, sourceBufferSize, meeting_rate, scenario_params.maxRuntime, \
                                                     scenario_params.traceFileName)
                            except:
                                pass
                        
                            results_outfile.write("%u,%u,%f,%f,%u,%u,%u,%u,%f" % (run, scenario_params.numSources, \
                                              scenario_params.commonArrivalRate, arrival_rate, number_copies, \
                                              number_relays, bufferSize, sourceBufferSize, meeting_rate))
                            trace = pd.read_csv(scenario_params.traceFileName, header = None)
                            packet_arrivals = trace[(trace[0] == "Packet") & (trace[1] == "PktArrival")]
                            num_arrivals = len(packet_arrivals)
                            packet_drops = trace[(trace[0] == "Source") & (trace[1] == "Drop")]
                            num_drops = len(packet_drops)
                            packet_arrivals = trace[(trace[0] == "Source") & (trace[1] == "Arrival")]
                            packet_arrivals = packet_arrivals[[2,3]]
                            packet_arrivals = packet_arrivals.groupby([3]).max()
                            packet_arrivals.columns = ["ArrivalTimes"]
                            packet_firstcopy = trace[(trace[0] == "Packet") & (trace[1] == "SRPktFirstCopy")]
                            packet_firstcopy = packet_firstcopy[[2, 3]]
                            packet_firstcopy = packet_firstcopy.groupby([3]).max()
                            packet_firstcopy.columns = ["FirstCopyTimes"]
                            # packet_lastcopy = trace[(trace[0] == "Packet") & (trace[1] == "SRPktLastCopy")] # cannot be used if there is feedback
                            packet_lastcopy = trace[(trace[0] == "Packet") & (trace[1] == "SRPktCopy")]
                            packet_lastcopy = packet_lastcopy[[2, 3]]
                            packet_lastcopy = packet_lastcopy.groupby([3]).max()
                            packet_lastcopy.columns = ["LastCopyTimes"]
                            packet_delivery = trace[(trace[0] == "Packet") & (trace[1] == "RDPktCopy")]
                            packet_delivery = packet_delivery[[2, 3]]
                            packet_delivery = packet_delivery.groupby([3]).min()
                            packet_delivery.columns = ["DeliveryTimes"]
                            packet = packet_arrivals.join([packet_firstcopy, packet_lastcopy, packet_delivery], how = "inner")
                            
                            avgqueueing_delay = (packet["LastCopyTimes"] - packet["ArrivalTimes"]).mean()
                            queueing_delay_sd = (packet["LastCopyTimes"] - packet["ArrivalTimes"]).std()
                            avgdelivery_delay = (packet["DeliveryTimes"] - packet["FirstCopyTimes"]).mean()
                            delivery_delay_sd = (packet["DeliveryTimes"] - packet["FirstCopyTimes"]).std()
                            fraction_dropped = 1.0 * num_drops / num_arrivals

                            results_outfile.write(",%f,%f,%f,%f,%f" % (avgqueueing_delay, queueing_delay_sd, avgdelivery_delay, delivery_delay_sd, fraction_dropped))
                            results_outfile.write("\n")

    results_outfile.close()
