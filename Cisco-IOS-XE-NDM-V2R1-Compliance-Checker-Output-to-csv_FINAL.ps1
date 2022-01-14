## Most recent STIG: 
###            Cisco IOS-XE Switch NDM STIG - V2R1 - Released: Oct 2020



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
$Configdirectory = read-host "Please provide the directory path for where each Cisco IOS-XE Switch configuration file is located"

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

write-host -Foregroundcolor Cyan "Working on $SingleSwitch"


$TotalCatIII = 0
$TotalCatII = 0
$TotalCatI = 0
$OpenCatIII = 0
$OpenCatII = 0
$OpenCatI = 0

## The below in this format:  Vuln_ID, Status, Comments
$Vuln220518 = “V-220518”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220519 = “V-220519”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220520 = “V-220520”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220521 = “V-220521”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220522 = “V-220522”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220523 = “V-220523”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220524 = “V-220524”, “NotAFinding”, “Configured in Cisco ISE”, "CatTwo" ## Configured in Cisco ISE, hence why it's hardcoded as notafinding
$Vuln220525 = “V-220525”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220526 = “V-220526”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220527 = “V-220527”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220528 = “V-220528”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220529 = “V-220529”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220530 = “V-220530”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220531 = “V-220531”, “Not_Applicable”, “null“, "CatTwo" ## Not Applicable (persistent logging not enabled)
$Vuln220532 = “V-220532”, “Not_Applicable”, “null“, "CatTwo" ## Not Applicable (persistent logging not enabled)
$Vuln220533 = “V-220533”, “Not_Applicable”, “null“, "CatTwo" ## Not Applicable (persistent logging not enabled)
$Vuln220534 = “V-220534”, “Not_Reviewed”, “null“, "CatOne"
$Vuln220535 = “V-220535”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220536 = “V-220536”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220537 = “V-220537”, “NotAFinding”, “Handled in Cisco ISE", "CatTwo" ## Handled in ISE
$Vuln220538 = “V-220538”, “NotAFinding”, “Handled in Cisco ISE“, "CatTwo" ## Handled in ISE
$Vuln220539 = “V-220539”, “NotAFinding”, “Handled in Cisco ISE“, "CatTwo" ## Handled in ISE
$Vuln220540 = “V-220540”, “NotAFinding”, “Handled in Cisco ISE“, "CatTwo" ## Handled in ISE
$Vuln220541 = “V-220541”, “NotAFinding”, “Handled in Cisco ISE“, "CatTwo" ## Handled in ISE
$Vuln220542 = “V-220542”, “Open”, “Unable to configure in ISE“ 
$Vuln220543 = “V-220543”, “Not_Reviewed”, “null“, "CatOne"
$Vuln220544 = “V-220544”, “Not_Reviewed”, “null“, "CatOne" 
$Vuln220545 = “V-220545”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220546 = “V-220546”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220547 = “V-220547”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220548 = “V-220548”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220549 = “V-220549”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220550 = “V-220550”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220551 = “V-220551”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220552 = “V-220552”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220553 = “V-220553”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220554 = “V-220554”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220555 = “V-220555”, “Not_Reviewed”, “null“, "CatOne"
$Vuln220556 = “V-220556”, “Not_Reviewed”, “null“, "CatOne"
$Vuln220557 = “V-220557”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220558 = “V-220558”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220559 = “V-220559”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220560 = “V-220560”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220561 = “V-220561”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220563 = “V-220563”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220564 = “V-220564”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220565 = “V-220565”, “Not_Reviewed”, “null“, "CatOne"
$Vuln220566 = “V-220566”, “NotAFinding”, “Switch Configs are backed up to Solarwinds“, "CatTwo" ## Probably handled in ISE. Has to do with backing up configs. Either ISE or Orion does this
$Vuln220567 = “V-220567”, “Not_Reviewed”, “null“, "CatTwo"
$Vuln220568 = “V-220568”, “Not_Reviewed”, “null“, "CatOne"
$Vuln220569 = “V-220569”, “NotAFinding”, “null", "CatOne" ## Supported version of Cisco IOS, managed by Networking Team




[XML]$BlankConfig = Get-content $BlankFilePath ## Save blank checklist to xml object

$SwitchConfig = Get-content $SingleSwitch ## Gets the content of the switch congiguration

$Hostname = $SingleSwitch.BaseName ## Gets the basename of the switch config file, so we have a proper way to name the output file

## Formatting the final directory + filepath for output
if ($OutputDirPath[-1] -eq "\"){
$OutputDestination = $OutputDirPath + $Hostname + ".ckl"
$ShortDestination = $OutputDirPath + $TodayDate + "-iOS-XE-NDM-Switch_Compliance-Quick-Results" + ".txt"
}
else {
$OutputDestination = $OutputDirPath + "\" + $Hostname + ".ckl"
$ShortDestination = $OutputDirPath + "\" + $TodayDate + "-iOS-XE-NDM-Switch_Compliance-Quick-Results" + ".txt"
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

$Accesslists = $Switchconfig | Select-string "ip access-list" -Context 0,12



## V-220518
if ($Eachvty -like "*session-limit*"){

$Vuln220518[1] = "NotAFinding"
$Vuln220518[2] = "Max-Connections was found in Switch Configuration as well as Session limit was found in both vty occurences"

}

else {

$Vuln220518[1] = "Open"
$Vuln220518[2] = "Missing session-limit parameter in line vty"

write-output "Missing session-limit parameter in line vty for V-220518" >> $ShortDestination

}




## V-220519-220522
if ($Switchconfig -like "*logging enable*"){

$Vuln220519[1] = "NotAFinding"
$Vuln220520[1] = "NotAFinding"
$Vuln220521[1] = "NotAFinding"
$Vuln220522[1] = "NotAFinding"
$Vuln220530[1] = "NotAFinding"
$Vuln220545[1] = "NotAFinding"
$Vuln220559[1] = "NotAFinding"
$Vuln220561[1] = "NotAFinding"



$Vuln220519[2] = "logging enable configured"
$Vuln220520[2] = "logging enable configured"
$Vuln220521[2] = "logging enable configured"
$Vuln220522[2] = "logging enable configured"
$Vuln220530[2] = "logging enable configured"
$Vuln220545[2] = "logging enable configured"
$Vuln220559[2] = "logging enable configured"
$Vuln220561[2] = "logging enable configured"


}
else {

$Vuln220519[1] = "Open"
$Vuln220520[1] = "Open"
$Vuln220521[1] = "Open"
$Vuln220522[1] = "Open"
$Vuln220530[1] = "Open"
$Vuln220545[1] = "Open"
$Vuln220559[1] = "Open"
$Vuln220561[1] = "Open"

$Vuln220519[2] = "logging enable not configured"
$Vuln220520[2] = "logging enable not configured"
$Vuln220521[2] = "logging enable not configured"
$Vuln220522[2] = "logging enable not configured"
$Vuln220530[2] = "logging enable not configured"
$Vuln220545[2] = "logging enable not configured"
$Vuln220559[2] = "logging enable not configured"
$Vuln220561[2] = "logging enable not configured"

write-output "Missing logging enable in Switch configuration for V-220519-74, V-220533, V-220545, V-220559, V-220561" >> $ShortDestination


}




## V-220523
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

$Vuln220523[1] = "Open"
$Vuln220523[2] = "Access-class must be configured on BOTH line VTYs"
write-output "Missing access-class assignment for each VTY in Switch configuration for V-220523 here: $SingleVTY" >> $ShortDestination

}
else {

$Vuln220523[1] = "NotAFinding"
$Vuln220523[2] = "ACL configured for each line vty"
}








## V-220525
if ($Switchconfig -like "*You are accessing a U.S. Government (USG) Information System (IS)*"){

$Vuln220525[1] = "NotAFinding"
$Vuln220525[2] = "Banner configured"

}
else {

$Vuln220525[1] = "Open"
write-output "Missing the standard DoD Banner in Switch Configuration for V-220525" >> $ShortDestination
$Vuln220525[2] = "Banner not configured"


}



## V-220526
if ($Switchconfig -like "*logging userinfo*"){

$Vuln220526[1] = "NotAFinding"
$Vuln220526[2] = "Logging userinfo found in switch config"

}
else {

$Vuln220526[1] = "Open"
$Vuln220526[2] = "Logging userinfo not found in switch configuration"

write-output "Missing Logging Userinfo from Switch Configuration for V-220526" >> $ShortDestination

}


## V-220527

if ($Switchconfig -like "*login on-failure log*" -and $Switchconfig -like "*login on-success log*"){

$Vuln220527[1] = "NotAFinding"
$Vuln220560[1] = "NotAFinding"


$Vuln220527[2] = "login on-failure log and login on-success log both configured"
$Vuln220560[2] = "login on-failure log and login on-success log both configured"


}
else {

$Vuln220527[1] = "Open"
$Vuln220527[2] = "Login on-failure log and login on-success log both need to be configured"

$Vuln220560[1] = "Open"
$Vuln220560[2] = "Login on-failure log and login on-success log both need to be configured"

write-output "Missing Login on-failure log and login on-success log for V-220527, V-220560" >> $ShortDestination


}


## V-220528
if ($Switchconfig -like "*service timestamps log datetime localtime*" -or $Switchconfig -like "*service timestamps debug datetime localtime*" -or $Switchconfig -like "*service timestamps log datetime*" -or $Switchconfig -like "*service timestamps log datetime msec localtime*"){

$Vuln220528[1] = "NotAFinding"
$Vuln220528[2] = "service timestamps log datetime localtime configured"

}
else {

$Vuln220528[1] = "Open"
$Vuln220528[2] = "Service timestamps datetime localtime missing from switch configuration."
write-output "Missing Service Timestamps Datetime Localtime from switch configuration for V-220528" >> $ShortDestination

}


## V-220529

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

$Vuln220529[1] = "NotAFinding"
$Vuln220529[2] = "Each access list is configured to produce audit records"

}
else {

$Vuln220529[1] = "Open"
$Vuln220529[2] = "Each access list is not configured to produce audit records."

write-output "Missing deny log statement to produce audit records for V-220529 here: $List" >> $ShortDestination

}




<#  COMMENTED OUT
if ($Switchconfig -like "*deny * log*"){

$Vuln220529[1] = "NotAFinding"

}
else {

$Vuln220529[1] = "Open"
$Vuln220529[2] = "Missing log parameter after deny statement"
write-output "Missing log parameter after deny statement for V-220529" >> $ShortDestination

}

#>  #END COMMENT






## V-220530 - Logging enable, logic built above in 220519

## V-220531 - 5   all Not_Applicable


## V-220534

$Notessential = $False

foreach ($LineItem in $Nonessential){

if ($Lineitem -in $SwitchConfig){

$Vuln220534[1] = "Open"
$Vuln220534[2] = "$LineItem found in Switch configuration"
write-output "** CAT I **: Nonessential items: $LineItem are included in switch configuration. Should be removed for V-220534" >> $ShortDestination
break


}
else {

$Notessential = "NotAFinding"
## 

}
if ($Notessential -match "NotAFinding"){

$Vuln220534[1] = "NotAFinding"
$Vuln220534[2] = "Non-essential items are missing from config"

}


} ## End of foreach-LineItem



## V-220535


if ($SwitchConfig -like "*username * privilege*"){


$Vuln220535[1] = "NotAFinding"



}
else {

$Vuln220535[1] = "Open"
$Vuln220535[2] = "Missing username configuration"
write-output "Missing local account configuration, indicated by the strings username and privilege for V-220535" >> $ShortDestination

}


## V-220536

if ($Switchconfig -like "*ip ssh version 2*" -and $Switchconfig -like "*ip ssh server algorithm encryption *256* *192* *128*"){

$Vuln220536[1] = "NotAFinding"
$Vuln220536[2] = "Found ip ssh version 2 and FIPS 140-2 compliant encryption algorithms in switch configuration"

}
else {

$Vuln220536[1] = "Open"
$Vuln220536[2] = "Unable to find ip ssh server algorithm encryption aes256-ctr aes192-ctr aes128-ctr or ip ssh version 2 in Switch Configuration."
write-output "Missing ip ssh version 2 or ip ssh server algirthm encryption standards are not FIPS 140-2 compliant for V-220536" >> $ShortDestination


}

## V-220537 - 94 are all handled in ISE




## V-220543

if ($SwitchConfig -like "*enable secret*"){

$Vuln220543[1] = "NotAFinding"
$Vuln220543[2] = "Enable Secret is in switch configuration"

}
else {

$Vuln220543[1] = "Open"
$Vuln220543[2] = "Missing Enable Secret in switch config"
write-output "** CAT I **: Missing enable secret for V-220543" >> $ShortDestination


}



## V-220544
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

$Vuln220544[1] = "Open"
$Vuln220544[2] = "Missing exec-timeout on either line vtys or line con 0"
write-output "** CAT I **: Missing exec-timeout for V-220544 here: $Singlevty " >> $ShortDestination

}
else {

$Vuln220544[1] = "NotAFinding"
$Vuln220544[2] = "Exec-timeout is configured"
}



## V-220545 -- Another logging enable one. Handled at beginning of script

## V-220546

if ($SwitchConfig -like "*logging enable*" -and $SwitchConfig -like "*logging userinfo*"){

$Vuln220546[1] = "NotAFinding"

}
else {

$Vuln220546[1] = "Open"
$Vuln220546[2] = "Missing logging userinfo or logging enable in config"
write-output "Missing logging userinfo or logging enable in config for V-220546" >> $ShortDestination


}


## V-220547

if ($Switchconfig -like "*logging buffered*"){

$Vuln220547[1] = "NotAFinding"
$Vuln220547[2] = "Logging buffer size configured"

}
else {

$Vuln220547[1] = "Open"
$Vuln220547[2] = "Missing Logging Buffered"
write-output "Missing logging buffered from switch config for V-220547" >> $ShortDestination
}

## V-220548

if ($Switchconfig -like "*logging *trap* critical*"){

$Vuln220548[1] = "NotAFinding"
$Vuln220548[2] = "logging trap critical is configured"

}
else {

$Vuln220548[1] = "Open"
$Vuln220548[2] = "Missing logging trap critical"
write-output "Missing logging trap critical in switch config for V-220548" >> $ShortDestination

}


## V-220549
if ($BothNTP.Length -ge 2){

$Vuln220549[1] = "NotAFinding"
$Vuln220549[2] = "Redundant NTP servers configured"

}
else {

$Vuln220549[1] = "Open"
$Vuln220549[2] = "Missing redundant NTP sources"
write-output "Missing redundant NTP servers for V-220549" >> $ShortDestination

}


## V-220550

if ($SwitchConfig -like "*service timestamps * localtime*"){

$Vuln220550[1] = "NotAFinding"
$Vuln220550[2] = "service timestamps datetime localtime found in switch config"

}
else {

$Vuln220550[1] = "Open"
$Vuln220550[2] = "service timestamps datetime localtime not found in switch config"
write-output "Missing service timestamps datetime localtime from switch config for V-220550" >> $ShortDestination


}

## V-220551


if ($Switchconfig -like "*clock timezone GMT*" -or $Switchconfig -like "*clock timezone EST*" -or $SwitchConfig -like "*service timestamps log datetime * localtime*"){

$Vuln220551[1] = "NotAFinding"
$Vuln220551[2] = "Switch configured to record time stamps that can be mapped to UTC or GMT"

}
else {

$Vuln220551[1] = "Open"
$Vuln220551[2] = "Missing clock timezone GMT or clock timezone EST from config"
write-output "Missing clock timezone GMT or clock timezone EST from config for V-220551" >> $ShortDestination

}

## V-220552, V-220553

if ($Switchconfig -like "*snmp-server group * v3*" -and $SwitchConfig -like "*snmp-server view *V3*" -and $Switchconfig -like "*snmp-server host * 3*"){

$Vuln220552[1] = "NotAFinding"
$Vuln220553[1] = "NotAFinding"

$Vuln220552[2] = "Configured to authenticate SNMP messages using FIPS validated HMAC"
$Vuln220553[2] = "Configured to authenticate SNMP messages using FIPS validated HMAC"

}
else {
$Vuln220552[1] = "Open"
$Vuln220553[1] = "Open"

$Vuln220552[2] = "Missing snmp-server group, view, or host"
$Vuln220553[2] = "Missing snmp-server group, view, or host"

write-output "Missing snmp-server group, view, or host for V-220552 and V-220553" >> $ShortDestination


}

## V-220554

if ($Switchconfig -like "*ntp authentication*"){

$Vuln220554[1] = "NotAFinding"
$Vuln220554[2] = "NTP authentication configured"

}
else {

$Vuln220554[1] = "Open"
$Vuln220554[2] = "Missing ntp authentication"

write-output "Missing ntp authentication in switch config for V-220554" >> $ShortDestination

}


## V-220555

if ($Switchconfig -like "*ip ssh server algorithm mac *hmac* *256*"){

$Vuln220555[1] = "NotAFinding"
$Vuln220555[2] = "ip ssh server algorithm mac hmac FIPS 140-2 compliant"

}
else {
$Vuln220555[1] = "Open"
$Vuln220555[2] = "ip ssh server algorithm neeeds to be FIPS-validated HMAC"
write-output "** CAT I **: Missing ip ssh server algorithm hmac from switch configuration, therefore not FIPS 140-2 compliant for V-220555" >> $ShortDestination

}


## V-220556

if ($Switchconfig -like "*ip ssh server algorithm encryption *256* *192* *128*"){


$Vuln220556[1] = "NotAFinding"

}
else {

$Vuln220556[1] = "Open"
$Vuln220556[2] = "Not seeing ip ssh server algorithm encryption aes256-ctr aes192-ctr aes128-ctr"
write-output "** CAT I **: Missing ip ssh server algorithm encryption aes256-ctr aes192-ctr aes128-ctr for V-220556" >> $ShortDestination

}

## V-220557

if ($SwitchConfig -like "*class-map*" -and $SwitchConfig -like "*match access*"){

$Vuln220557[1] = "NotAFinding"

}
else {

$Vuln220557[1] = "Open"
$Vuln220557[2] = "Missing class-map and match access-group"
write-output "Missing class-map and match access-group from config for V-220557" >> $ShortDestination

}


## V-220558 - 

if ($Switchconfig -like "*logging enable*" -and $SwitchConfig -like "*logging userinfo*"){

$Vuln220558[1] = "NotAFinding"
$Vuln220558[2] = "Logging userinfo and Logging enable both configured"

}
else {

$Vuln220558[1] = "Open"
$Vuln220558[2] = "Logging userinfo and Logging enable are both not configured"

write-output "Logging userinfo and Logging enable are both not configured for V-220558" >> $ShortDestination

}


## V-220560 - handled above

## V-220561 - logging enable, handled above

## V-220563

if ($Switchconfig -like "*login on-success log*"){

$Vuln220563[1] = "NotAFinding"
$Vuln220563[2] = "Login on-success log configured"

}
else {

$Vuln220563[1] = "Open"
$Vuln220563[2] = "Missing login on-success log"
write-output "Missing login on-success log for V-220563" >> $ShortDestination

}


## V-220564

if ($SwitchConfig -like "*logging host*" -and ($SwitchConfig -like "*logging * notifications*" -or $SwitchConfig -like "*logging * informational*" -or $SwitchConfig -like "*logging * critical*")){

$Vuln220564[1] = "NotAFinding"
$Vuln220568[1] = "NotAFinding"

$Vuln220564[2] = "Logging trap configured"
$Vuln220568[2] = ""

}
else {

$Vuln220564[1] = "Open"
$Vuln220568[1] = "Open"
$Vuln220564[2] = "Missing Logging host or logging trap notifications"
$Vuln220568[2] = "Missing Logging host or logging trap notifications"

write-output "** CAT I **: Missing Logging host or logging trap notifications for V-220564 and V-220568" >> $ShortDestination

}



## V-220565
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

$Vuln220565[1] = "Open"
$Vuln220565[2] = "Missing login authentication on either line vtys or line con 0"
write-output "** CAT I **: Missing login authentication for V-220565 here: $Singlevty " >> $ShortDestination

}
else {

$Vuln220565[1] = "NotAFinding"
$Vuln220565[2] = "Login authentication configured"
}


## V-220566 - Not sure yet


## V-220567
if ($Switchconfig -like "*crypto pki trustpoint*"){

$Vuln220567[1] = "NotAFinding"
$Vuln220567[2] = "Crypto PKI Trustpoint from Switch config"

}
else {

$Vuln220567[1] = "Open"
$Vuln220567[2] = "Missing Crypto PKI Trustpoint"
write-output "Missing Crypto PKI Trustpoint from Switch Config" >> $ShortDestination


}





write-output "`n" >> $ShortDestination ## Indent a new line on the output .txt file 


## END STIG CHECK  ##############################################################################################                        ---------------------                      ################################################################


$AllVulnArray = @(
$Vuln220518,
$Vuln220519,
$Vuln220520,
$Vuln220521,
$Vuln220522,
$Vuln220523,
$Vuln220524,
$Vuln220525,
$Vuln220526,
$Vuln220527,
$Vuln220528,
$Vuln220529,
$Vuln220530,
$Vuln220531,
$Vuln220532,
$Vuln220533,
$Vuln220534,
$Vuln220535,
$Vuln220536,
$Vuln220537,
$Vuln220538,
$Vuln220539,
$Vuln220540,
$Vuln220541,
$Vuln220542,
$Vuln220543,
$Vuln220544,
$Vuln220545,
$Vuln220546,
$Vuln220547,
$Vuln220548,
$Vuln220549,
$Vuln220550,
$Vuln220551,
$Vuln220552,
$Vuln220553,
$Vuln220554,
$Vuln220555,
$Vuln220556,
$Vuln220557,
$Vuln220558,
$Vuln220559,
$Vuln220560,
$Vuln220561,
$Vuln220563,
$Vuln220564,
$Vuln220565,
$Vuln220566,
$Vuln220567,
$Vuln220568,
$Vuln220569


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
STIG_Title = "Cisco IOS-XE NDM V2R1"
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