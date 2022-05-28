# --- DAILY JOBS ---

# Check for any necessary reboots at 5:00 daily
0 5 * * * ~/rebooter.sh


# --- WEEKLY JOBS ---

# Weekly reboot, schedule on 4:30
30 4 * * 1 ~/reboot-weekly.sh

# Weekly apt update check
0 4 * * 4 ~/update-weekly.sh


# --- MONTHLY JOBS ---
