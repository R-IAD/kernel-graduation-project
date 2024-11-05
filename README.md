# Kernel Graduation Project
---

## From the Project requirement:
1. Capture network traffic using Wireshark.
2. Develop a Bash script to analyze the captured data.
3. Extract relevant information like total packets, protocols, and top source/destination IP addresses.
4. Generate a summary report based on the analysis.


### After capturing some frames for analysis using
```bash
  sudo tcpdump -i enp0s3 -w network_traffic.pcap
```
## and restoring them in `network_traffic.pcap`





### Get the number of Packets using
```bash
  tshark -r  ${1}| wc -l `
```

### We can apply a certain filter to the capture
```bash
  tshark -r ${1}  -Y "http" | wc -l
```

### Create temp. files to store data
```bash
  touch source_notdup.txt destination_notdup.txt
```

### Extract the Src/Dst IP using tshark command
```bash
  tshark -nr ${1} -T fields -e ip.src  > source.csv
  tshark -nr ${1} -T fields -e ip.dst  > destination.csv
```
### Delete Duplicate lines
```bash
    awk '!seen[$0]++' source.csv | tail --line 5 > source_notdup.txt
    awk '!seen[$0]++' destination.csv | tail --line 5 > destination_notdup.txt
```

### Loop through the file to get data we need 
```bash
    cat destination_notdup.txt| while read p; do
        echo "$p : `cat destination.csv | grep "${p}" | wc -l`  Packets" 
    done
```

### Remove all temp files
```bash
    rm -f  destination_notdup.txt  source_notdup.txt destination.csv source.csv
```
