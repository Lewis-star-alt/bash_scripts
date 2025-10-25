#!/bin/bash

echo "=== $(hostname) - $(date) ==="
echo "User: $USER | Uptime: $(uptime -p)"
echo ""

# Диски
echo -e "\033[1;34m=== Disk Usage ===\033[0m"
df -h | grep -v tmpfs | awk 'NR==1 {print}
NR>1 { 
    usage = $5+0
    if (usage > 90) printf "\033[1;31m"    # красный если >90%
    else if (usage > 80) printf "\033[1;33m" # желтый если >80%
    print $0 "\033[0m"
}'

# Память
echo -e "\n\033[1;34m=== Memory Usage ===\033[0m"
free -h

# Процессы
echo -e "\n\033[1;34m=== Top 5 CPU Processes ===\033[0m"
ps aux --sort=-%cpu | head -6