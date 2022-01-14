# STIG-Cisco-Switch-Router-Compliance-Checks_v2
This is the newest (and last) version of Cisco switch or router DISA STIG compliance scripts.

NEW ADDITIONS:
- Total CCRI score per device will now be calculated
- Capability to output all STIG compliance results for each type of device to a centralized file. This file will display STIG CCRI score, Device Name, STIG Title, and the total amount of CAT (I,II,III) items that are open

REQUIREMENTS:
- Switch or router .config or .txt files (filename extension must be .config or .txt)
- Blank STIG checklist (if you are going to be creating other checklists based off each device's results)
- Powershell

HOW TO USE:
- Open script in Powershell ISE
- Set the $CreateCSV variable to yes or no, if you want a .csv file output
- Set the $CSVPath variable to the filepath for the output .csv file (filename and extension included)
- Execute script, follow prompts

You will be prompted for the following:
- Filepath of blank STIG checklist (including filename and extension)
- Directory where switch/router configuration files are stored
- If you want to create STIG checklists for each network device
- Output directory path

**NOTE**: By default, these scripts will attempt to output a centralized .CSV file to your `C:\Temp\` directory. Set this to "No" at the top of the script if you want to disable this feature. 


SUMMARY:

Each script should be ran against a directory of switch or router configurations to determine their STIG compliance for the associated checklist.

The switch/router configuration will be cross-referenced by a blank STIG .ckl file supplied by the user (user will be prompted upon running script).

The output will be a 'Quick Glance' text file where you can quickly look for what each individual switch is missing in terms of STIG items. You can optionally also create STIG checklists for each of the individual switches.

This is a great way of tracking switch or router STIG compliance for all of the most recent DISA STIGs.

**Supported STIG checklists:**

CISCO IOS L2S Switch STIG V2R2 - Release Date: 23 Jul 2021

CISCO IOS NDM Switch STIG V2R3 - Release Date: 23 Jul 2021

CISCO IOS-XE Switch L2S STIG V2R2 - Release Date: 23 Jul 2021

Cisco IOS-XE Switch NDM STIG V2R3 - Release Date: 23 Jul 2021

Cisco IOS-XE Router NDM STIG V2R3 - Release Date: 23 Jul 2021

Cisco IOS-XE Router RTR STIG V2R2 - Release Date: 23 Apr 2021

CISCO IOS-XE Switch RTR STIG V2R2 - Release Date: 23 Jul 2021
