#!/bin/bash

# Bash Script to Analyze Network Traffic

# Input: Path to the Wireshark pcap file
# capture input from terminal.

# Function to extract information from the pcap file
analyze_traffic() {

    # Use tshark or similar commands for packet analysis.
    # Hint: Consider commands to count total packets, filter by protocols (HTTP, HTTPS/TLS),
    # extract IP addresses, and generate summary statistics.

    declare -i HTTP_Packets=`tshark -r ${1}  -Y "http" | wc -l`
    declare -i Packets=`tshark -r  ${1}| wc -l `
    declare -i TLS_Packets=`tshark -r  ${1} -Y "tls" | wc -l `
    

    # Output analysis summary
    echo "----- Network Traffic Analysis Report -----"
    # Provide summary information based on your analysis
    # Hints: Total packets, protocols, top source, and destination IP addresses.
    echo "1. Total Packets: $Packets"
    echo ""
    echo "2. Protocols:"
    echo "   - HTTP: $HTTP_Packets packets"
    echo "   - HTTPS/TLS: $TLS_Packets packets"
    echo ""

    # Extract the Src/Dst IP through tshark command

    tshark -nr ${1} -T fields -e ip.src  > source.csv
    tshark -nr ${1} -T fields -e ip.dst  > destination.csv

    # Create Temp files 

    touch source_notdup.txt
    touch destination_notdup.txt

    # Delete Duplicate lines
    
    awk '!seen[$0]++' source.csv | tail --line 5 > source_notdup.txt
    awk '!seen[$0]++' destination.csv | tail --line 5 > destination_notdup.txt

#################################################################
    echo "3. Top 5 Source IP Addresses:"
    echo ""

    # Provide the top source IP addresses

    cat source_notdup.txt| while read p; do
        echo "$p : `cat source.csv | grep "${p}" | wc -l`  Packets" 
    done 
    echo ""

#################################################################
    echo "4. Top 5 Destination IP Addresses:"
    echo ""

    # Provide the top destination IP addresses
    
    cat destination_notdup.txt| while read p; do
        echo "$p : `cat destination.csv | grep "${p}" | wc -l`  Packets" 
    done

#################################################################
    echo ""
    echo "----- End of Report -----"

    # Remove all temp files

    rm -f  destination_notdup.txt  source_notdup.txt destination.csv source.csv
    #destination.csv source.csv
}

# Run the analysis function
### pass the path of .pcap file

analyze_traffic ${1}
