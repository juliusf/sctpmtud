#!/usr/bin/env python3

import os
import sys
import json
import matplotlib.pyplot as plt



def main():

    with open(sys.argv[1]) as json_file:
        data = json.load(json_file)
        x_cwnd = []
        y_cwnd = []
        x_flight_size = []
        y_flight_size = []
        x_mtu = []
        y_mtu = [] 
        x_min_mtu = []
        y_min_mtu = []
        x_trtx = []
        x_rtt = []
        y_rtt = []
        x_rto = []
        y_rto = []
        last_trtx_seen = 0
        for p in data:
            if p['type'] == 'cwnd':
                x_cwnd.append(p['time'])
                y_cwnd.append(p['cwnd'])
            elif p['type'] =='flight_size':
                x_flight_size.append(p['time'])
                y_flight_size.append(p['flight_size'])
            elif p['type'] == 'mtu':
                x_mtu.append(p['time'])
                y_mtu.append(p['mtu'])
            elif p['type'] == 'min_mtu':
                x_min_mtu.append(p['time'])
                y_min_mtu.append(p['min_mtu'])
            elif p['type'] == 'trtx':
                if p['trtx'] > last_trtx_seen:
                    x_trtx.append(p['time'])
                last_trtx_seen =  p['trtx']
            elif p['type'] == 'rtt':
                x_rtt.append(p['time'])
                y_rtt.append(p['rtt'] / 1000)
            elif p['type'] == 'rto':
                x_rto.append(p['time'])
                y_rto.append(p['rto'])

    fig, axs = plt.subplots(3)   

    plt.title(sys.argv[1])


    for rtx in x_trtx:
         axs[0].axvline(x=rtx, color='r')
    axs[0].plot(x_cwnd, y_cwnd, label='cwnd')
    axs[0].plot(x_flight_size, y_flight_size, label='flight_size')
    
    axs[0].set(xlabel='time (us)', ylabel='byte')
    axs[0].grid()
    axs[0].legend()
    
    axs[1].plot(x_mtu, y_mtu, label='mtu')
    axs[1].plot(x_min_mtu, y_min_mtu, label='min_mtu')
    
    axs[1].set(xlabel='time (us)', ylabel='byte')
    axs[1].grid()
    axs[1].legend()
    
    axs[2].plot(x_rtt, y_rtt, label='rtt')
    axs[2].plot(x_rto, y_rto, label='rto')
    axs[2].set(xlabel='time (us)', ylabel='time (ms)')
    axs[2].grid()
    axs[2].legend()


    plt.show()

if __name__ == "__main__":
    try:
        main()
    except json.JSONDecodeError:
        print("json is broken. trying to fix")
        file = open(sys.argv[1], 'r+')
        all_lines = file.readlines()
        if all_lines[-1] != "]":
            if all_lines[-1][-1] != "\n":
                del all_lines[-1]
            all_lines.append(']')
            file.close()
            file = open(sys.argv[1], 'w')
            for line in all_lines:
                file.write(line)
            file.close()
            main()
        else:
            print("something else is broken!")
            sys.exit(-1)
            
