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
        x_rto = []
    
        last_rto_seen = 0
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
            elif p['type'] == 'rto':
                if p['rto'] > last_rto_seen:
                    x_rto.append(p['time'])
                    last_rto_seen += 1
    

    fig, axs = plt.subplots(2)   

    plt.title(sys.argv[1])


    for rto in x_rto:
         axs[0].axvline(x=rto, color='r')
    axs[0].plot(x_cwnd, y_cwnd, label='cwnd')
    axs[0].plot(x_flight_size, y_flight_size, label='flight_size')
    
    axs[0].set(xlabel='time (us)', ylabel='byte')
    axs[0].grid()
    axs[0].legend()
    
    axs[1].plot(x_mtu, y_mtu, label='mtu')
    
    axs[1].set(xlabel='time (us)', ylabel='byte')
    axs[1].grid()
    axs[1].legend()
    
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
            
