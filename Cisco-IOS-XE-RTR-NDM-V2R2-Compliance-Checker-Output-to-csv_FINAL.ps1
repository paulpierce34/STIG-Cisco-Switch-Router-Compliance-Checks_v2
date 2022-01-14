## Most recent STIG: 
###            Cisco IOS-XE Router NDM STIG - V2R3 - Released: 23 Jul 2021



## PURPOSE: The purpose of this script is to keep track of STIG items for Cisco IOS Switch NDM to ensure compliance



## HOW SCRIPT WORKS: Script searches through switch configuration files, one at a time, and cross-references the config to the most recent NDM STIG checklist for Cisco IOS Devices. Script then outputs results to .txt file and optionally creates checklists.

##                   Files Output:
##                   1.) Quick Glance .txt file which summarizes the compliance for each switch.
##                   2.) (Optional) - Checklists for each switch configuration


## HOW TO USE: 

### Step 1: Run script, follow prompts
### Step 2: If you answer YES to checklist creation, a different checklist will be created for each switch configuration
### Step 3: Script will also generate a "Quick Glance" file which is a .txt file that gives you a quick way to view how compliant each switch configuration is. 




$CreateCSV = "Yes" ## Yes or no
$CSVPath = "C:\temp\Switch-Configs\Allswitchcompliance.csv"



$ScriptSummary = write-host -ForegroundColor Cyan "`n`nThis script makes ZERO changes to any switch configurations, and is used solely for tracking compliance. This script searches through switch configuration files, one at a time, and cross-references the config to the most recent NDM STIG checklist for Cisco IOS Devices. Script then outputs results to .txt file and optionally creates checklists.`n`n"
Pause




## ASK QUESTIONS FOR INPUT/OUTPUT DIRECTORY #####################
$Configdirectory = read-host "Please provide the directory path for where each Cisco IOS-XE Router configuration file is located"

if (test-path $Configdirectory){

$BlankFilePath = read-host "Please provide the FULL filepath for where the blank STIG is found (must include filename i.e. C:\temp\blank.ckl)"


}
else {


write-host -foregroundcolor Red "Unable to validate the following directory path provided exists: $Configdirectory. Terminating script...."
break

}

## Test to make sure the blank file path is BOTH a file, and a valid path
if (test-path $BlankFilePath -PathType Leaf){

$OutputDirPath = read-host "Please provide the directory path for file output"

$CreateCKL = read-host "Would you like for this script to create checklists for each switch configuration? Type yes (or y)  or no (or n)"

}
else {

write-host -foregroundcolor Red "The path provided: $BlankFilePath either doesn't include the FULL filepath (including filename) or is an invalid path. Terminating script..."
break
}
## END ASK QUESTIONS FOR INPUT/OUTPUT DIRECTORY #####################
if (test-path $OutputDirPath){

##continue


}
else {

write-host -foregroundcolor Red "It looks like the output directory path provided does not exist. $OutputDirPath   Terminating script..."
break
}

## GLOBAL VARIABLES #####

$TodayDate = Get-Date -Format yyyyMMdd
$Date = Get-date

$Nonessential = @(

"boot network",
"ip boot server",
"ip bootp server",
"ip dns server",
"ip identd",
"ip finger",
"ip http server",
"ip rcmd rcp-enable",
"ip rcmd rsh-enable",
"service config",
"service finger",
"service tcp-small-servers",
"service udp-small-servers"

)

## Adding the wildcard character to the config directory, so the $AllSwitchConfigs variable can use the -include switch for get-childitem. In order to use this switch, you need a wildcard at the end of the path, or the -recurse switch.
$AllConfigsPlusWildcard = $Configdirectory + "\" + "*"

$AllSwitchConfigs = Get-childitem -Path $AllConfigsPlusWildcard -include *.txt, *.config ## Gets all of the .txt configuration files for each switch





## XML Settings to replicate those of STIGViewer #######################################################################################################################
$XMLSettings = New-Object -TypeName System.XML.XMLWriterSettings
$XMLSettings.Indent = $true;
$XMLSettings.IndentChars = "`t"
$XMLSettings.NewLineChars="`n"
$XMLSettings.Encoding = New-Object -TypeName System.Text.UTF8Encoding -ArgumentList @($false)
$XMLSettings.ConformanceLevel = [System.Xml.ConformanceLevel]::Document
### End of STIGViewer settings ########################################################################################################################################



## END GLOBAL VARIABLES SECTION #####


$SwitchComplianceObj = @()


## For each switch configuration file
foreach ($SingleSwitch in $AllSwitchConfigs){

write-host "Working on $Singleswitch..."


$TotalCatIII = 0
$TotalCatII = 0
$TotalCatI = 0
$OpenCatIII = 0
$OpenCatII = 0
$OpenCatI = 0

## The below in this format:  Vuln_ID, Status, Comments
$Vuln215807 = “V-215807”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215808 = “V-215808”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215809 = “V-215809”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215810 = “V-215810”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215811 = “V-215811”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215812 = “V-215812”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215813 = “V-215813”, “NotAFinding”, “Configured in Cisco ISE”, "CatTwo" ## Configured in Cisco ISE, hence why it's hardcoded as notafinding
$Vuln215814 = “V-215814”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215815 = “V-215815”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215816 = “V-215816”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215817 = “V-215817”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215818 = “V-215818”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215819 = “V-215819”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215820 = “V-215820”, “Not_Applicable”, “null“, "CatTwo" ## Not Applicable (persistent logging not enabled)
$Vuln215821 = “V-215821”, “Not_Applicable”, “null“, "CatTwo" ## Not Applicable (persistent logging not enabled)
$Vuln215822 = “V-215822”, “Not_Applicable”, “null“, "CatTwo" ## Not Applicable (persistent logging not enabled)
$Vuln215823 = “V-215823”, “Not_Reviewed”, “null“, "CatOne"
$Vuln215824 = “V-215824”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215825 = “V-215825”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215826 = “V-215826”, “NotAFinding”, “Handled in Cisco ISE", "CatTwo" ## Handled in ISE
$Vuln215827 = “V-215827”, “NotAFinding”, “Handled in Cisco ISE“, "CatTwo" ## Handled in ISE
$Vuln215828 = “V-215828”, “NotAFinding”, “Handled in Cisco ISE“, "CatTwo" ## Handled in ISE
$Vuln215829 = “V-215829”, “NotAFinding”, “Handled in Cisco ISE“, "CatTwo" ## Handled in ISE
$Vuln215830 = “V-215830”, “NotAFinding”, “Handled in Cisco ISE“, "CatTwo" ## Handled in ISE
$Vuln215831 = “V-215831”, “Open”, “Unable to configure in ISE“, "CatTwo" 
$Vuln215832 = “V-215832”, “Not_Reviewed”, “null“, "CatOne"
$Vuln215833 = “V-215833”, “Not_Reviewed”, “null“, "CatOne"
$Vuln215834 = “V-215834”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215835 = “V-215835”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215836 = “V-215836”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215837 = “V-215837”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215838 = “V-215838”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215839 = “V-215839”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215840 = “V-215840”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215841 = “V-215841”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215842 = “V-215842”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215843 = “V-215843”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215844 = “V-215844”, “Not_Reviewed”, “null“, "CatOne"
$Vuln215845 = “V-215845”, “Not_Reviewed”, “null“, "CatOne"
$Vuln215846 = “V-215846”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215847 = “V-215847”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215848 = “V-215848”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215849 = “V-215849”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215850 = “V-215850”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215852 = “V-215852”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215853 = “V-215853”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln215854 = “V-215854”, “Not_Reviewed”, “null“, "CatOne"
$Vuln215855 = “V-215855”, “NotAFinding”, “Switch Configs are backed up to Solarwinds“, "CatTwo" ## Probably handled in ISE. Has to do with backing up configs. Either ISE or Orion does this
$Vuln215856 = “V-215856”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220139 = “V-220139”, “Not_Reviewed”, “null“, "CatOne"
$Vuln220140 = “V-220140”, “NotAFinding”, “null", "CatOne" ## Supported version of Cisco IOS, managed by Networking Team




[XML]$BlankConfig = Get-content $BlankFilePath ## Save blank checklist to xml object

$SwitchConfig = Get-content $SingleSwitch ## Gets the content of the switch congiguration

$Hostname = $SingleSwitch.BaseName ## Gets the basename of the switch config file, so we have a proper way to name the output file

## Formatting the final directory + filepath for output
if ($OutputDirPath[-1] -eq "\"){
$OutputDestination = $OutputDirPath + $Hostname + ".ckl"
$ShortDestination = $OutputDirPath + $TodayDate + "-Router-NDM_Compliance-Quick-Results" + ".txt"
}
else {
$OutputDestination = $OutputDirPath + "\" + $Hostname + ".ckl"
$ShortDestination = $OutputDirPath + "\" + $TodayDate + "-Router-NDM_Compliance-Quick-Results" + ".txt"
}

## REMINDERS -------------------------------------------
# Switchconfig = Content of switch config              |
# OutputDestination = FULL filepath for output file    |
# BlankConfig = Blank checklist full filepath [XML]    |

## -----------------------------------------------------

write-output "Quick Glance at Hostname $Hostname on $Date" >> $ShortDestination ## Write this to a quick-results file, which is a quick overview/glance of how each switch stands per configuration.


## BEGIN STIG CHECK                     ---------------------                      ################################################################
$EachVty = $Switchconfig | Select-String "line vty" -Context 0,7

$ConPort = $Switchconfig | Select-String "line con 0" -Context 0,8

$BothNTP = $Switchconfig | Select-string -Pattern "NTP server"

$Accesslists = $Switchconfig | Select-string "ip access-list" -Context 0,25 | where {$_ -notlike "*log-update*" -and $_ -notlike "*Not-Applicable*"}



## V-215807
if ($Eachvty -like "*session-limit*"){

$Vuln215807[1] = "NotAFinding"
$Vuln215807[2] = "Max-Connections was found in Switch Configuration as well as Session limit was found in both vty occurences"

}

else {

$Vuln215807[1] = "Open"
$Vuln215807[2] = "Missing session-limit parameter in line vty"

write-output "Missing session-limit parameter in line vty for V-215807" >> $ShortDestination

}




## V-215808-215811
if ($Switchconfig -like "*logging enable*"){

$Vuln215808[1] = "NotAFinding"
$Vuln215809[1] = "NotAFinding"
$Vuln215810[1] = "NotAFinding"
$Vuln215811[1] = "NotAFinding"
$Vuln215819[1] = "NotAFinding"
$Vuln215834[1] = "NotAFinding"
$Vuln215848[1] = "NotAFinding"
$Vuln215850[1] = "NotAFinding"



$Vuln215808[2] = "logging enable configured"
$Vuln215809[2] = "logging enable configured"
$Vuln215810[2] = "logging enable configured"
$Vuln215811[2] = "logging enable configured"
$Vuln215819[2] = "logging enable configured"
$Vuln215834[2] = "logging enable configured"
$Vuln215848[2] = "logging enable configured"
$Vuln215850[2] = "logging enable configured"


}
else {

$Vuln215808[1] = "Open"
$Vuln215809[1] = "Open"
$Vuln215810[1] = "Open"
$Vuln215811[1] = "Open"
$Vuln215819[1] = "Open"
$Vuln215834[1] = "Open"
$Vuln215848[1] = "Open"
$Vuln215850[1] = "Open"

$Vuln215808[2] = "logging enable not configured"
$Vuln215809[2] = "logging enable not configured"
$Vuln215810[2] = "logging enable not configured"
$Vuln215811[2] = "logging enable not configured"
$Vuln215819[2] = "logging enable not configured"
$Vuln215834[2] = "logging enable not configured"
$Vuln215848[2] = "logging enable not configured"
$Vuln215850[2] = "logging enable not configured"

write-output "Missing logging enable in Switch configuration for V-215808-74, V-215822, V-215834, V-215848, V-215850" >> $ShortDestination


}




## V-215812
$PlaceholderFour = $True

foreach ($Singlevty in $Eachvty){

if ($Singlevty -like "*access-class*"){

$PlaceholderFour = $True

}
else {

$PlaceholderFour = $False
break


}


} ## end of foreach


if ($PlaceholderFour -eq $False){

$Vuln215812[1] = "Open"
$Vuln215812[2] = "Access-class must be configured on BOTH line VTYs"
write-output "Missing access-class assignment for each VTY in Switch configuration for V-215812 here: $SingleVTY" >> $ShortDestination

}
else {

$Vuln215812[1] = "NotAFinding"
$Vuln215812[2] = "ACL configured for each line vty"
}








## V-215814
if ($Switchconfig -like "*You are accessing a U.S. Government (USG) Information System (IS)*"){

$Vuln215814[1] = "NotAFinding"
$Vuln215814[2] = "Banner configured"

}
else {

$Vuln215814[1] = "Open"
write-output "Missing the standard DoD Banner in Switch Configuration for V-215814" >> $ShortDestination
$Vuln215814[2] = "Banner not configured"


}



## V-215815
if ($Switchconfig -like "*logging userinfo*"){

$Vuln215815[1] = "NotAFinding"
$Vuln215815[2] = "Logging userinfo found in switch config"

}
else {

$Vuln215815[1] = "Open"
$Vuln215815[2] = "Logging userinfo not found in switch configuration"

write-output "Missing Logging Userinfo from Switch Configuration for V-215815" >> $ShortDestination

}


## V-215816

if ($Switchconfig -like "*login on-failure log*" -and $Switchconfig -like "*login on-success log*"){

$Vuln215816[1] = "NotAFinding"
$Vuln215849[1] = "NotAFinding"


$Vuln215816[2] = "login on-failure log and login on-success log both configured"
$Vuln215849[2] = "login on-failure log and login on-success log both configured"


}
else {

$Vuln215816[1] = "Open"
$Vuln215816[2] = "Login on-failure log and login on-success log both need to be configured"

$Vuln215849[1] = "Open"
$Vuln215849[2] = "Login on-failure log and login on-success log both need to be configured"

write-output "Missing Login on-failure log and login on-success log for V-215816, V-215849" >> $ShortDestination


}


## V-215817
if ($Switchconfig -like "*service timestamps log datetime localtime*" -or $Switchconfig -like "*service timestamps debug datetime localtime*" -or $Switchconfig -like "*service timestamps log datetime*" -or $Switchconfig -like "*service timestamps log datetime msec localtime*"){

$Vuln215817[1] = "NotAFinding"
$Vuln215817[2] = "service timestamps log datetime localtime configured"

}
else {

$Vuln215817[1] = "Open"
$Vuln215817[2] = "Service timestamps datetime localtime missing from switch configuration."
write-output "Missing Service Timestamps Datetime Localtime from switch configuration for V-215817" >> $ShortDestination

}


## V-215818

$PlaceholderFive = $True

Foreach ($List in $Accesslists){


if ($List -like "*deny * log*"){

$PlaceholderFive = $True 

}
else {

$PlaceholderFive = $False
break

}

} ## end of foreach

if ($PlaceholderFive -eq $True){

$Vuln215818[1] = "NotAFinding"
$Vuln215818[2] = "Each access list is configured to produce audit records"

}
else {

$Vuln215818[1] = "Open"
$Vuln215818[2] = "Each access list is not configured to produce audit records."

write-output "Missing deny log statement to produce audit records for V-215818 here:`n
 $List `n" >> $ShortDestination

}




<#  COMMENTED OUT
if ($Switchconfig -like "*deny * log*"){

$Vuln215818[1] = "NotAFinding"

}
else {

$Vuln215818[1] = "Open"
$Vuln215818[2] = "Missing log parameter after deny statement"
write-output "Missing log parameter after deny statement for V-215818" >> $ShortDestination

}

#>  #END COMMENT






## V-215819 - Logging enable, logic built above in 215808

## V-215820 - 5   all Not_Applicable


## V-215823

$Notessential = $False

foreach ($LineItem in $Nonessential){

if ($Lineitem -in $SwitchConfig){

$Vuln215823[1] = "Open"
$Vuln215823[2] = "$LineItem found in Switch configuration"
write-output "** CAT I **: Nonessential items: $LineItem are included in switch configuration. Should be removed for V-215823" >> $ShortDestination
break


}
else {

$Notessential = "NotAFinding"
## 

}
if ($Notessential -match "NotAFinding"){

$Vuln215823[1] = "NotAFinding"
$Vuln215823[2] = "Non-essential items are missing from config"

}


} ## End of foreach-LineItem



## V-215824


if ($SwitchConfig -like "*username * privilege*"){


$Vuln215824[1] = "NotAFinding"



}
else {

$Vuln215824[1] = "Open"
$Vuln215824[2] = "Missing username configuration"
write-output "Missing local account configuration, indicated by the strings username and privilege for V-215824" >> $ShortDestination

}


## V-215825

if ($Switchconfig -like "*ip ssh version 2*" -and $Switchconfig -like "*ip ssh server algorithm encryption *256* *192* *128*"){

$Vuln215825[1] = "NotAFinding"
$Vuln215825[2] = "Found ip ssh version 2 and FIPS 140-2 compliant encryption algorithms in switch configuration"

}
else {

$Vuln215825[1] = "Open"
$Vuln215825[2] = "Unable to find ip ssh server algorithm encryption aes256-ctr aes192-ctr aes128-ctr or ip ssh version 2 in Switch Configuration."
write-output "Missing ip ssh version 2 or ip ssh server algirthm encryption standards are not FIPS 140-2 compliant for V-215825" >> $ShortDestination


}

## V-215826 - 94 are all handled in ISE




## V-215832

if ($SwitchConfig -like "*enable secret*"){

$Vuln215832[1] = "NotAFinding"
$Vuln215832[2] = "Enable Secret is in switch configuration"

}
else {

$Vuln215832[1] = "Open"
$Vuln215832[2] = "Missing Enable Secret in switch config"
write-output "** CAT I **: Missing enable secret for V-215832" >> $ShortDestination


}



## V-215833
if ($Conport -like "*exec-timeout*"){
$Placeholder = $True

foreach ($Singlevty in $Eachvty){

if ($Singlevty -like "*exec-timeout*"){

$Placeholder = $True

}
else {

$Placeholder = $False
break


}


} ## end of foreach
}

if ($Placeholder -eq $False){

$Vuln215833[1] = "Open"
$Vuln215833[2] = "Missing exec-timeout on either line vtys or line con 0"
write-output "** CAT I **: Missing exec-timeout here for V-215833:`n 
$Singlevty `n" >> $ShortDestination

}
else {

$Vuln215833[1] = "NotAFinding"
$Vuln215833[2] = "Exec-timeout is configured"
}



## V-215834 -- Another logging enable one. Handled at beginning of script

## V-215835

if ($SwitchConfig -like "*logging enable*" -and $SwitchConfig -like "*logging userinfo*"){

$Vuln215835[1] = "NotAFinding"

}
else {

$Vuln215835[1] = "Open"
$Vuln215835[2] = "Missing logging userinfo or logging enable in config"
write-output "Missing logging userinfo or logging enable in config for V-215835" >> $ShortDestination


}


## V-215836

if ($Switchconfig -like "*logging buffered*"){

$Vuln215836[1] = "NotAFinding"
$Vuln215836[2] = "Logging buffer size configured"

}
else {

$Vuln215836[1] = "Open"
$Vuln215836[2] = "Missing Logging Buffered"
write-output "Missing logging buffered from switch config for V-215836" >> $ShortDestination
}

## V-215837

if ($Switchconfig -like "*logging *trap* critical*"){

$Vuln215837[1] = "NotAFinding"
$Vuln215837[2] = "logging trap critical is configured"

}
else {

$Vuln215837[1] = "Open"
$Vuln215837[2] = "Missing logging trap critical"
write-output "Missing logging trap critical in switch config for V-215837" >> $ShortDestination

}


## V-215838
if ($BothNTP.Length -ge 2){

$Vuln215838[1] = "NotAFinding"
$Vuln215838[2] = "Redundant NTP servers configured"

}
else {

$Vuln215838[1] = "Open"
$Vuln215838[2] = "Missing redundant NTP sources"
write-output "Missing redundant NTP servers for V-215838" >> $ShortDestination

}


## V-215839

if ($SwitchConfig -like "*service timestamps * localtime*"){

$Vuln215839[1] = "NotAFinding"
$Vuln215839[2] = "service timestamps datetime localtime found in switch config"

}
else {

$Vuln215839[1] = "Open"
$Vuln215839[2] = "service timestamps datetime localtime not found in switch config"
write-output "Missing service timestamps datetime localtime from switch config for V-215839" >> $ShortDestination


}

## V-215840


if ($Switchconfig -like "*clock timezone GMT*" -or $Switchconfig -like "*clock timezone EST*" -or $SwitchConfig -like "*service timestamps log datetime * localtime*"){

$Vuln215840[1] = "NotAFinding"
$Vuln215840[2] = "Switch configured to record time stamps that can be mapped to UTC or GMT"

}
else {

$Vuln215840[1] = "Open"
$Vuln215840[2] = "Missing clock timezone GMT or clock timezone EST from config"
write-output "Missing clock timezone GMT or clock timezone EST from config for V-215840" >> $ShortDestination

}

## V-215841, V-215842

if ($Switchconfig -like "*snmp-server group * v3*" -and $SwitchConfig -like "*snmp-server view *V3*" -and $Switchconfig -like "*snmp-server host * 3*"){

$Vuln215841[1] = "NotAFinding"
$Vuln215842[1] = "NotAFinding"

$Vuln215841[2] = "Configured to authenticate SNMP messages using FIPS validated HMAC"
$Vuln215842[2] = "Configured to authenticate SNMP messages using FIPS validated HMAC"

}
else {
$Vuln215841[1] = "Open"
$Vuln215842[1] = "Open"

$Vuln215841[2] = "Missing snmp-server group, view, or host"
$Vuln215842[2] = "Missing snmp-server group, view, or host"

write-output "Missing snmp-server group, view, or host for V-215841 and V-215842" >> $ShortDestination


}

## V-215843

if ($Switchconfig -like "*ntp authentication*"){

$Vuln215843[1] = "NotAFinding"
$Vuln215843[2] = "NTP authentication configured"

}
else {

$Vuln215843[1] = "Open"
$Vuln215843[2] = "Missing ntp authentication"

write-output "Missing ntp authentication in switch config for V-215843" >> $ShortDestination

}


## V-215844

if ($Switchconfig -like "*ip ssh server algorithm mac *hmac* *256*"){

$Vuln215844[1] = "NotAFinding"
$Vuln215844[2] = "ip ssh server algorithm mac hmac FIPS 140-2 compliant"

}
else {
$Vuln215844[1] = "Open"
$Vuln215844[2] = "ip ssh server algorithm neeeds to be FIPS-validated HMAC"
write-output "** CAT I **: Missing ip ssh server algorithm hmac from switch configuration, therefore not FIPS 140-2 compliant for V-215844" >> $ShortDestination

}


## V-215845

if ($Switchconfig -like "*ip ssh server algorithm encryption *256* *192* *128*"){


$Vuln215845[1] = "NotAFinding"

}
else {

$Vuln215845[1] = "Open"
$Vuln215845[2] = "Not seeing ip ssh server algorithm encryption aes256-ctr aes192-ctr aes128-ctr"
write-output "** CAT I **: Missing ip ssh server algorithm encryption aes256-ctr aes192-ctr aes128-ctr for V-215845" >> $ShortDestination

}

## V-215846

if ($SwitchConfig -like "*class-map*" -and $SwitchConfig -like "*match access*"){

$Vuln215846[1] = "NotAFinding"

}
else {

$Vuln215846[1] = "Open"
$Vuln215846[2] = "Missing class-map and match access-group"
write-output "Missing class-map and match access-group from config for V-215846" >> $ShortDestination

}


## V-215847 - 

if ($Switchconfig -like "*logging enable*" -and $SwitchConfig -like "*logging userinfo*"){

$Vuln215847[1] = "NotAFinding"
$Vuln215847[2] = "Logging userinfo and Logging enable both configured"

}
else {

$Vuln215847[1] = "Open"
$Vuln215847[2] = "Logging userinfo and Logging enable are both not configured"

write-output "Logging userinfo and Logging enable are both not configured for V-215847" >> $ShortDestination

}


## V-215849 - handled above

## V-215850 - logging enable, handled above

## V-215852

if ($Switchconfig -like "*login on-success log*"){

$Vuln215852[1] = "NotAFinding"
$Vuln215852[2] = "Login on-success log configured"

}
else {

$Vuln215852[1] = "Open"
$Vuln215852[2] = "Missing login on-success log"
write-output "Missing login on-success log for V-215852" >> $ShortDestination

}


## V-215853

if ($SwitchConfig -like "*logging host*" -and ($SwitchConfig -like "*logging * notifications*" -or $SwitchConfig -like "*logging * informational*" -or $SwitchConfig -like "*logging * critical*")){

$Vuln215853[1] = "NotAFinding"
$Vuln220139[1] = "NotAFinding"

$Vuln215853[2] = "Logging trap configured"
$Vuln220139[2] = ""

}
else {

$Vuln215853[1] = "Open"
$Vuln220139[1] = "Open"
$Vuln215853[2] = "Missing Logging host or logging trap notifications"
$Vuln220139[2] = "Missing Logging host or logging trap notifications"

write-output "** CAT I **: Missing Logging host or logging trap notifications for V-215853 and V-220139" >> $ShortDestination

}



## V-215854
if ($Conport -like "*login authentication*"){
$PlaceholderThree = $True

foreach ($Singlevty in $Eachvty){

if ($Singlevty -like "*login authentication*"){

$PlaceholderThree = $True

}
else {

$PlaceholderThree = $False
break


}


} ## end of foreach
}

if ($PlaceholderThree -eq $False){

$Vuln215854[1] = "Open"
$Vuln215854[2] = "Missing login authentication on either line vtys or line con 0"
write-output "** CAT I **: Missing login authentication for V-215854 here:`n
 $Singlevty `n" >> $ShortDestination

}
else {

$Vuln215854[1] = "NotAFinding"
$Vuln215854[2] = "Login authentication configured"
}


## V-215855 - Not sure yet


## V-215856
if ($Switchconfig -like "*crypto pki trustpoint*"){

$Vuln215856[1] = "NotAFinding"
$Vuln215856[2] = "Crypto PKI Trustpoint from Switch config"

}
else {

$Vuln215856[1] = "Open"
$Vuln215856[2] = "Missing Crypto PKI Trustpoint"
write-output "Missing Crypto PKI Trustpoint from Switch Config" >> $ShortDestination


}





write-output "`n" >> $ShortDestination ## Indent a new line on the output .txt file 


## END STIG CHECK  ##############################################################################################                        ---------------------                      ################################################################


$AllVulnArray = @(
$Vuln215807,
$Vuln215808,
$Vuln215809,
$Vuln215810,
$Vuln215811,
$Vuln215812,
$Vuln215813,
$Vuln215814,
$Vuln215815,
$Vuln215816,
$Vuln215817,
$Vuln215818,
$Vuln215819,
$Vuln215820,
$Vuln215821,
$Vuln215822,
$Vuln215823,
$Vuln215824,
$Vuln215825,
$Vuln215826,
$Vuln215827,
$Vuln215828,
$Vuln215829,
$Vuln215830,
$Vuln215831,
$Vuln215832,
$Vuln215833,
$Vuln215834,
$Vuln215835,
$Vuln215836,
$Vuln215837,
$Vuln215838,
$Vuln215839,
$Vuln215840,
$Vuln215841,
$Vuln215842,
$Vuln215843,
$Vuln215844,
$Vuln215845,
$Vuln215846,
$Vuln215847,
$Vuln215848,
$Vuln215849,
$Vuln215850,
$Vuln215852,
$Vuln215853,
$Vuln215854,
$Vuln215855,
$Vuln215856,
$Vuln220139,
$Vuln220140


)


## This is the section where we will write our findings to each different Vuln ID in the XML file 

### XML Extraction ###

## Pulls all Vulnerability Numbers
$PreVulns = $BlankConfig.selectNodes("//STIG_DATA[VULN_ATTRIBUTE='Vuln_Num']")
$AfterVulns = $Prevulns.Attribute_data ## All of the vulnerability IDs

## Pulls all of the Statuses
$Allstatus = $BlankConfig.GetElementsByTagName('STATUS')

## Pulls all of the comments
$Allcomments = $BlankConfig.GetElementsByTagName('FINDING_DETAILS')





## IF YOU'RE GETTING A CHECKLIST VALIDATION ERROR, CHANCES ARE YOU ARE SAVING THE VARIABLE IMPROPERLY
### I WAS GETTING AN ERROR BECAUSE I HAD A BUNCH OF EMPTY OBJECTS BEING WRITTEN TO THE CHECKLIST

for ($x = 0; $x -lt $AfterVulns.Count; $x++){

if ($AllVulnArray[$x][0] -contains $Aftervulns[$x]){


# write-host $AllVulnArray[$x][0] "matches with " $Aftervulns[$x] Un-Comment if you want to visually see the V- ID's being matched up

$AllStatus[$x].InnerXml = $AllVulnArray[$x][1] # $AllVulnArray[$x][1]  ## Sets the STATUS of the vulnerability to that which is in the above array.
$Allcomments[$x].innerText = $AllVulnArray[$x][2]


} ## end of if-statement

## TOTALS:
$Category = $AllVulnArray[$x][3]

if ($Category -eq "CatThree"){
$TotalCatIII += $Category.Count
}
if ($Category -eq "CatTwo"){
$TotalCatII += $Category.Count
}
if ($Category -eq "CatOne"){
$TotalCatI += $Category.Count

}

## MATH:
$StatusTrack = $AllvulnArray[$x][1]

if ($Category -eq "CatThree" -and $StatusTrack -eq "Open"){
$OpenCatIII += 1
}
if ($Category -eq "CatTwo" -and $StatusTrack -eq "Open"){
$OpenCatII += 1
}
if ($Category -eq "CatOne" -and $StatusTrack -eq "Open"){
$OpenCatI += 1

}

} ## end of for x loop



if ($TotalCatI -eq 0){
$OpenCatI = 0

$CCRIScore = (($OpenCatIII/$TotalCatIII*1*100/15)+($OpenCatII/$TotalCatII*4*100/15))

}
if ($TotalCatII -eq 0){
$OpenCatII = 0

$CCRIScore = (($OpenCatIII/$TotalCatIII*1*100/15)+($OpenCatI/$TotalCatI*10*100/15))

}
if ($TotalCatIII -eq 0){
$OpenCatIII = 0

$CCRIScore = (($OpenCatII/$TotalCatII*4*100/15)+($OpenCatI/$TotalCatI*10*100/15))
}

if ($TotalCatI -eq 0 -and $TotalCatII -eq 0){
$OpenCatI = 0
$OpenCatII = 0

$CCRIScore = (($OpenCatIII/$TotalCatIII*1*100/15))


}
if ($TotalCatI -eq 0 -and $TotalCatIII -eq 0){
$OpenCatI = 0
$OpenCatIII = 0

$CCRIScore = (($OpenCatII/$TotalCatII*4*100/15))



}
if ($TotalCatII -eq 0 -and $TotalCatIII -eq 0){

$OpenCatII = 0
$OpenCatIII = 0

$CCRIScore = (($OpenCatI/$TotalCatI*10*100/15))


}


if ($TotalCatI -ne 0 -and $TotalCatII -ne 0 -and $TotalCatIII -ne 0){

$CCRIScore = (($OpenCatIII/$TotalCatIII*1*100/15)+($OpenCatII/$TotalCatII*4*100/15)+($OpenCatI/$TotalCatI*10*100/15))

}



write-host "Total Cat I: $TotalCatI", "Total Cat II: $TotalCatII", "Total Cat III: $TotalCatIII"
write-host "Total Cat I Open: $OpenCatI", "Total Cat II Open: $OpenCatII", "Total Cat III Open: $OpenCatIII"
write-host -Foregroundcolor Yellow "TOTAL CCRI SCORE: $CCRIScore"


write-output "`n`nDevice Total CCRI Score: $CCRIScore %`n`n" >> $ShortDestination


if ($CreateCSV -match "Yes"){

$SwitchComplianceObj += New-Object PSObject -Property @{

Hostname = $Hostname;
Cat_I = $TotalCatI;
Cat_II = $TotalCatII;
Cat_III = $TotalCatIII;
Cat_I_Open = $OpenCatI;
Cat_II_Open = $OpenCatII;
Cat_III_Open = $OpenCatIII;
STIG_Title = "Cisco IOS-XE RTR NDM V2R2"
CCRI_Score = $CCRIScore
} ## end property build




} ## If create csv matches yes

## If user indicates they want checklists created
if ($CreateCKL -eq "yes" -or $CreateCKL -eq "y"){

## Creates the XML doc
$XMLWriter = [System.XML.XmlWriter]::Create($OutputDestination, $XMLSettings)  ## creates file at $Destination location with $XMLSettings -- (blank)
$BlankConfig.Save($XMLWriter) ## Saves the extract document changes above to the xml writer object (which follows the validation scheme for STIG viewer)
$XMLWriter.Flush()
$XMLWriter.Dispose()

}


$BlankConfig = $null

} ## end of for-loop

if ($CreateCSV -match "Yes"){


$SwitchComplianceObj | Select-Object Hostname, Cat_I, Cat_I_Open, Cat_II, Cat_II_Open, Cat_III, Cat_III_Open, CCRI_Score, STIG_Title | Sort-Object Hostname, Cat_I, Cat_I_Open, Cat_II, Cat_II_Open, Cat_III, Cat_III_Open, CCRI_Score, STIG_Title | Export-Csv -Path $CSVPath -NoTypeInformation -Append


}

if (Test-Path $ShortDestination){

write-host -ForegroundColor Green "Successfully created output file: $ShortDestination"

}
else {

## Continue

}