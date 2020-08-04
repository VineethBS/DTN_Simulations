#!/usr/bin/python3

import pandas as pd
import numpy as np
import SprayWait
import sys

configuration = pd.read_excel(sys.argv[1], index_col=0)
number_scenarios = configuration.shape[1]

for scenario in range(number_scenarios):
    scenario_params = configuration[scenario]
    if scenario_params.numRuns == 0:
        continue

    results_outfile = open(scenario_params.fileName, "w")
    results_outfile.write("Run,NumSources,CommnArrivalRate,ArrivalRate,NumCopies,NumRelays,RelayBuffer,MeetingRate")
    for s in range(scenario_params.numSources):
        results_outfile.write(",Source%uArrival,Source%uService,Source%uAvgQLength,Source%uAvgDelay" % (s,s,s,s))
    results_outfile.write("\n")

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
                        list_packet_arrivalrates = [scenario_params.commonArrivalRate] * (scenario_params.numSources - 1)
                        list_packet_arrivalrates.insert(0, arrival_rate)
                        
                        SprayWait.Simulation(scenario_params.numSources, list_packet_arrivalrates, number_copies, \
                                             number_relays, scenario_params.relayBufferSize, meeting_rate, \
                                             scenario_params.maxRuntime, scenario_params.traceFileName)
                        
                        results_outfile.write("%u,%u,%f,%f,%u,%u,%u,%f" % (run, scenario_params.numSources, \
                                              scenario_params.commonArrivalRate, arrival_rate, number_copies, \
                                              number_relays, scenario_params.relayBufferSize, meeting_rate))
                        
                        trace = pd.read_csv(scenario_params.traceFileName, header = None)
                        
                        for s in range(scenario_params.numSources):
                            trace_forsource = trace[(trace[0] == "Source") & (trace[1] == s)]
                            sim_arrivalrate = trace_forsource[trace_forsource[3] == "Arrival"].shape[0] / scenario_params.maxRuntime
                            sim_servicerate = trace_forsource[trace_forsource[3] == "Service"].shape[0] / scenario_params.maxRuntime
                            sim_queuelengths = trace_forsource[5][:-1].values
                            sim_timedurations = trace_forsource[2].diff()[1:].values
                            sim_avgqueuelength = np.sum(sim_queuelengths * sim_timedurations) / scenario_params.maxRuntime
                            sim_avgdelay = sim_avgqueuelength / sim_arrivalrate
                            results_outfile.write(",%f,%f,%f,%f" % \
                                                  (sim_arrivalrate, sim_servicerate, sim_avgqueuelength, sim_avgdelay))
                            
                        results_outfile.write("\n")

    results_outfile.close()
