es# 🖥️ Linux System Monitoring Tool (Bash Script)

A lightweight **system monitoring tool** built entirely using **Bash scripting**.  
It provides real-time insights into CPU usage, memory utilization, disk usage, running processes, and network statistics — directly from your terminal.

---

## 🚀 Features

- 📊 **CPU Monitoring:** Shows live CPU usage and load averages  
- 💾 **Memory Usage:** Displays used, free, and available memory  
- 🧱 **Disk Usage:** Reports filesystem usage and available space  
- 📡 **Network Statistics:** Displays data sent and received on active interfaces  
- ⚙️ **Process Information:** Lists top resource-consuming processes  
- 🧠 **System Info:** Shows system uptime, kernel version, and logged-in users  

---

## 🛠️ Requirements

This script is designed to work on **any Linux distribution** with standard command-line utilities.  
Ensure that the following tools are available (most are preinstalled by default):

```bash
bash
top
free
df
ifconfig or ip
uptime
uname
who
```

- Make the Script executable

```bash
chmod +x system-monitoring-tool.sh
```

### ⚙️ Script Structure

```perl
linux-system-monitor/
├── system-monitoring-tool.sh     # Main monitoring script
├── README.md             # Project documentation
└── LICENSE               # License (optional)
```

### 🧰 Technologies Used

- **Language**: Bash
- **Core Utilities**: ```top```, ```ps```, ```awk```,```grep```, ```sed```, ```df```, ```free```, ```uptime```, ```ifConfig/ip```
- **Platform**: Linux

### Example Output

```bash
[1m==========================================[0m
[1m     🖥️  ADVANCED SYSTEM MONITORING TOOL [0m
[1m==========================================[0m

CPU Usage:      [32m71.4%[0m
Memory Usage:   [32m38%[0m
Disk Usage:     10%
Temperature:    N/A
Battery:        Discharging (28%)
Network:        RX: bytes TX: bytes
Uptime:         up 19 minutes

Top 5 CPU-consuming processes:
    PID COMMAND         %CPU %MEM
  10142 ps              1000  0.0
   6983 code            75.7  3.5
   8372 code            45.5  3.7
   7254 code            33.6  1.3
   6649 chrome          24.4  3.8
------------------------------------------
```


