## Cisco IOS XE Router RTR V2R2 - Release Date: 23 Apr 2021





$CreateCSV = "Yes" ## Yes or no
$CSVPath = "C:\temp\Switch-Configs\Allswitchcompliance.csv"


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
"service udp-small-servers",
"service pad"

)





## END GLOBAL VARIABLES SECTION #####

$SwitchComplianceObj = @()


Foreach ($SingleSwitch in $AllSwitchConfigs){


write-host -Foregroundcolor Cyan "Working on $SingleSwitch"

$TotalCatIII = 0
$TotalCatII = 0
$TotalCatI = 0
$OpenCatIII = 0
$OpenCatII = 0
$OpenCatI = 0


## The below in this format:  Vuln_ID, Status, Comments


$Vuln216641 = “V-216641", “Not_Reviewed”, “null“, "CatTwo"
$Vuln216644 = “V-216644", “NotAFinding”, “GRE Tunnel in use“, "CatTwo"
$Vuln216645 = "V-216645", "NotAFinding", "GRE Tunnel in use", "CatTwo"
$Vuln216646 = “V-216646", “Not_Reviewed”, “null“, "CatThree"
$Vuln216647 = “V-216647", “Not_Reviewed”, “null“, "CatThree"
$Vuln220993 = “V-220993", “Not_Reviewed”, “null“, "CatThree"
$Vuln216649 = “V-216649", “Not_Reviewed”, “null“, "CatTwo"
$Vuln216650 = “V-216650", “Not_Reviewed”, “null“, "CatTwo"
$Vuln216651 = “V-216651", “Not_Reviewed”, “null“, "CatOne"
$Vuln216652 = “V-216652", “Not_Reviewed”, “null“, "CatTwo"
$Vuln216653 = “V-216653", “Not_Reviewed”, “null“, "CatTwo"
$Vuln216654 = “V-216654", “Not_Reviewed”, “null“, "CatThree"
$Vuln216655 = “V-216655", “Not_Reviewed”, “null“, "CatTwo"
$Vuln216656 = “V-216656", “Not_Reviewed”, “null“, "CatTwo"
$Vuln216657 = “V-216657", “Not_Reviewed”, “null“, "CatTwo"
$Vuln216658 = “V-216658", “Not_Reviewed”, “null“, "CatThree"
$Vuln216659 = “V-216659", “Not_Reviewed”, “null“, "CatTwo"
$Vuln216660 = “V-216660", “Not_Reviewed”, “null“, "CatTwo"
$Vuln216661 = “V-216661", “Not_Reviewed”, “null“, "CatThree"
## DIVIDER -- Not applicable coming up! Warning, there are a few that are not N/A.



$Vuln216662 = "V-216662" , "Not_Applicable" , "null", "CatOne"
$Vuln216663 = "V-216663" , "Not_Applicable" , "null", "CatTwo"
$Vuln216664 = "V-216664" , "Not_Applicable" , "null", "CatTwo"
$Vuln216665 = "V-216665" , "Not_Applicable" , "null", "CatTwo"
$Vuln216666 = "V-216666" , "Not_Applicable" , "null", "CatOne"
$Vuln216667 = "V-216667" , "Not_Applicable" , "null", "CatOne"
$Vuln216668 = "V-216668" , "Not_Applicable" , "null", "CatThree"
$Vuln216669 = "V-216669" , "Not_Applicable" , "null", "CatThree"
$Vuln216670 = "V-216670" , "Not_Applicable" , "null", "CatTwo"
$Vuln216671 = "V-216671" , "Not_Applicable" , "null", "CatTwo"
$Vuln216672 = "V-216672" , "Not_Applicable" , "null", "CatTwo"
$Vuln216673 = "V-216673" , "Not_Applicable" , "null", "CatThree"
$Vuln216674 = "V-216674" , "Not_Applicable" , "null", "CatThree"
$Vuln216675 = "V-216675" , "Not_Applicable" , "null", "CatThree"
$Vuln216676 = "V-216676" , "Not_Applicable" , "null", "CatTwo"
$Vuln216677 = "V-216677" , "Not_Applicable" , "null", "CatTwo"
$Vuln216678 = "V-216678" , "Not_Applicable" , "null", "CatTwo"
$Vuln216679 = "V-216679" , "Not_Applicable" , "null", "CatTwo"
$Vuln216680 = "V-216680" , "Not_Applicable" , "null", "CatTwo"
$Vuln216681 = "V-216681" , "Not_Applicable" , "null", "CatTwo"
$Vuln216682 = "V-216682" , "Not_Applicable" , "null", "CatTwo"
$Vuln216683 = "V-216683" , "Open", "Not enough fiber for out of band management", "CatTwo"


$Vuln216684 = "V-216684" , "Not_Reviewed", "null", "CatTwo"
$Vuln216685 = "V-216685" , "Not_Applicable" , "null", "CatThree"
$Vuln216686 = "V-216686" , "Not_Applicable" , "null", "CatThree"
$Vuln216687 = "V-216687" , "Not_Applicable" , "null", "CatTwo"
$Vuln216688 = "V-216688" , "Not_Applicable" , "null", "CatTwo"
$Vuln216689 = "V-216689" , "Not_Applicable" , "null", "CatTwo"
$Vuln216690 = "V-216690" , "Not_Applicable" , "null", "CatTwo"
$Vuln216691 = "V-216691" , "Not_Applicable" , "null", "CatTwo"
$Vuln216692 = "V-216692" , "Not_Applicable" , "null", "CatThree"
$Vuln216693 = "V-216693" , "Not_Applicable" , "null", "CatThree"
$Vuln216694 = "V-216694" , "Not_Applicable", "null", "CatTwo"
$Vuln216695 = "V-216695" , "Not_Applicable", "null", "CatThree"
$Vuln216696 = "V-216696" , "Not_Applicable", "null", "CatThree"
$Vuln216697 = "V-216697" , "Not_Applicable" , "null", "CatThree"
$Vuln216698 = "V-216698" , "Not_Applicable" , "null", "CatThree"
$Vuln216699 = "V-216699" , "Not_Applicable" , "null", "CatThree"


## 700s
$Vuln216700 = "V-216700" , "Not_Applicable" , "null", "CatTwo"
$Vuln216701 = "V-216701" , "Not_Applicable" , "null", "CatOne"
$Vuln216702 = "V-216702" , "Not_Applicable" , "null", "CatOne"
$Vuln216703 = "V-216703" , "Not_Applicable" , "null", "CatTwo"
$Vuln216704 = "V-216704" , "Not_Applicable" , "null", "CatTwo"
$Vuln216705 = "V-216705" , "Not_Applicable" , "null", "CatOne"
$Vuln216706 = "V-216706" , "Not_Applicable" , "null", "CatOne"
$Vuln216707 = "V-216707" , "Not_Applicable" , "null", "CatThree"
$Vuln216708 = "V-216708" , "Not_Applicable" , "null", "CatTwo"
$Vuln216709 = "V-216709" , "Not_Applicable" , "null", "CatThree"
$Vuln216710 = "V-216710" , "Not_Applicable" , "null", "CatTwo"
$Vuln216711 = "V-216711" , "Not_Applicable" , "null", "CatOne"
$Vuln216712 = "V-216712" , "Not_Applicable" , "null", "CatTwo"

$Vuln216714 = "V-216714" , "Not_Applicable" , "null", "CatThree"
$Vuln216715 = "V-216715" , "Not_Applicable" , "null", "CatThree"
$Vuln216716 = "V-216716" , "Not_Applicable", "null", "CatTwo"
$Vuln216717 = "V-216717" , "Not_Applicable" , "null", "CatTwo"
$Vuln216718 = "V-216718" , "Not_Applicable" , "null", "CatTwo"
$Vuln216719 = "V-216719" , "Not_Applicable" , "null", "CatThree"
$Vuln216720 = "V-216720" , "Not_Applicable" , "null", "CatThree"
$Vuln216721 = "V-216721" , "Not_Applicable" , "null", "CatThree"
$Vuln216722 = "V-216722" , "Not_Applicable" , "null", "CatThree"
$Vuln216723 = "V-216723" , "Not_Applicable" , "null", "CatTwo"
$Vuln216724 = "V-216724" , "Not_Applicable" , "null", "CatThree"
$Vuln216725 = "V-216725" , "Not_Applicable" , "null", "CatTwo"
$Vuln216726 = "V-216726" , "Not_Applicable" , "null", "CatTwo"
$Vuln216727 = "V-216727" , "Not_Applicable" , "null", "CatTwo"
$Vuln216728 = "V-216728" , "Not_Applicable" , "null", "CatTwo"
$Vuln216729 = "V-216729" , "Not_Applicable" , "null", "CatTwo"
$Vuln216730 = "V-216730" , "Not_Applicable" , "null", "CatThree"
$Vuln216731 = "V-216731" , "Not_Applicable" , "null", "CatThree"
$Vuln216732 = "V-216732" , "Not_Applicable" , "null" , "CatThree"
$Vuln216733 = "V-216733" , "Not_Applicable" , "null" , "CatThree"

## 900s
$Vuln216994 = "V-216994" , "NotAFinding" , "GRE Tunneling in use", "CatTwo"
$Vuln216995 = "V-216995" , "NotAFinding" , "GRE Tunneling in use", "CatTwo"
$Vuln216996 = "V-216996" , "Not_Reviewed" , "null", "CatTwo"
$Vuln216997 = "V-216997" , "Not_Applicable" , "null", "CatOne"
$Vuln216998 = "V-216998" , "Not_Applicable" , "null", "CatTwo"
$Vuln216999 = "V-216999" , "Not_Applicable" , "null", "CatThree"
$Vuln217000 = "V-217000" , "Not_Applicable" , "null", "CatTwo"
$Vuln217001 = "V-217001" , "Not_Applicable" , "null", "CatTwo"


$Vuln229031 = "V-229031", “NotAFinding”, “null“, "CatTwo"

$Vuln230039 = "V-230039", “Not_Applicable”, “null“, "CatThree"

$Vuln230042 = "V-230042", “Not_Applicable”, “null“, "CatTwo"
$Vuln230045 = "V-230045", “Not_Applicable”, “null“, "CatTwo"
$Vuln230048 = "V-230048", “Not_Applicable”, “null“, "CatTwo"

$Vuln230051 = "V-230051", “Not_Applicable”, “null“, "CatTwo"

$Vuln230146 = "V-230146", “Not_Applicable”, “null“, "CatTwo"
$Vuln230150 = "V-230150", “Not_Applicable”, “null“, "CatTwo"
$Vuln230153 = "V-230153", “Not_Applicable”, “null“, "CatTwo"
$Vuln230156 = "V-230156", “Not_Applicable”, “null“, "CatTwo"
$Vuln230159 = "V-230159", “Not_Applicable”, “null“, "CatTwo"


[XML]$BlankConfig = Get-content $BlankFilePath ## Save blank checklist to xml object

$SwitchConfig = Get-content $SingleSwitch ## Gets the content of the switch congiguration

$Hostname = $SingleSwitch.BaseName ## Gets the basename of the switch config file, so we have a proper way to name the output file



## Formatting the final directory + filepath for output
if ($OutputDirPath[-1] -eq "\"){
$OutputDestination = $OutputDirPath + $Hostname + ".ckl"
$ShortDestination = $OutputDirPath + $TodayDate + "-Router-RTR_Compliance-Quick-Results" + ".txt"
}
else {
$OutputDestination = $OutputDirPath + "\" + $Hostname + ".ckl"
$ShortDestination = $OutputDirPath + "\" + $TodayDate + "-Router-RTR_Compliance-Quick-Results" + ".txt"
}

## REMINDERS -------------------------------------------
# Switchconfig = Content of switch config              |
# OutputDestination = FULL filepath for output file    |
# BlankConfig = Blank checklist full filepath [XML]    |

## -----------------------------------------------------



write-output "Quick Glance at Hostname $Hostname on $Date" >> $ShortDestination ## Write this to a quick-results file, which is a quick overview/glance of how each switch stands per configuration.


## BEGIN STIG PROCESS

## GLOBAL STIG VARIABLES

$Accesslists = $Switchconfig | Select-string "ip access-list" -Context 0,35 | where {$_ -notlike "*Applicable*" -and $_ -notlike "*log-update*"}

$Eachinterface = $SwitchConfig | Select-String "GigabitEthernet" -Context 0,25

$Keychain = $Switchconfig | Select-String "key-string" -Context 1,3

$AuxLine = $SwitchConfig | Select-String "line aux 0" -Context 0,2


$Scavenger = $SwitchConfig | Select-String "class-map match-any AutoQos-4.0-Output-Scavenger-Queue" -Context 0,1



## END GLOBAL STIG VARIABLES



## V-216641 - The Cisco switch must be configured to enforce approved authorizations for controlling the flow of information within the network based on organization-defined information flow control policies.

Foreach ($AccList in $Accesslists){

if ($Acclist -like "*permit *" -or $Acclist -like "*deny*"){

$Vuln216641[1] = "NotAFinding"
$Vuln216641[2] = "IP access lists are configured to enforce approved authorizations."


}
else {

$Vuln216641[1] = "Open"
$Vuln216641[2] = "Missing allow or deny traffic for specific protocols for each access-list."

write-output "Missing allow or deny traffic config in ip-access list here for V-216641:`n
 $Acclist `n" >> $ShortDestination

break


}


}




## V-216644 - The Cisco switch must be configured to use encryption for routing protocol authentication.

<#

if ($Switchconfig -like "*ip ospf authentication message-digest*" -and $Switchconfig -like "*ip ospf message-digest-key*"){

$Vuln216644[1] = "NotAFinding"
$Vuln216644[2] = "ospf key is encrypted"

}
else {


$Vuln216644[1] = "Open"
$Vuln216644[2] = "Switch is not using encryption for ospf key"

write-output "Missing ip ospf authentication message-digest for key encryption for V-216644" >> $ShortDestination

}


#>

## V-216645 - The Cisco switch must be configured to authenticate all routing protocol messages using NIST-validated FIPS 198-1 message authentication code algorithm.

### In the meantime, networking team has GRE Tunnels setup between each router. Hardcoding as Not A Finding
### In the future, we will need to check for 'crypto map' in this interface config



<#

foreach ($Key in $Keychain){

if ($Key -like "*cryptographic-algorithm hmac-sha-256*"){

$Vuln216645[1] = "NotAFinding"
$Vuln216645[2] = "Each key is using FIPS 198-1 HMAC to authenticate routing protocol messages"

}


else {

$Vuln216645[1] = "Open"
$Vuln216645[2] = "Each key is not using FIPS 198-1 HMAC to authenticate routing protocol messages"

write-output "Missing cryptographic-algorithm hmac-sha-256 for V-216645 here: $Key" >> $ShortDestination

break
}

}

if ($Key -eq $null -or $Keychain -eq $null){

$Vuln216645[1] = "Open"
$Vuln216645[2] = "Each key is not using FIPS 198-1 HMAC to authenticate routing protocol messages"

write-output "Missing OSPF key-chain for V-216645 " >> $ShortDestination

}

#>




## V-216646 - The Cisco switch must be configured to have all inactive layer 3 interfaces disabled.

Foreach ($Interface in $Eachinterface){

if (($Interface -like "*DISABLED*" -or $Interface -like "*disabled*") -and $Interface -notlike "*shutdown*"){

$Vuln216646[1] = "Open"
$Vuln216646[2] = "There is a disabled interface that's not been shutdown"

write-output "There is a disabled interface that's not been shutdown for V-216646 here: `n
$Interface `n" >> $ShortDestination
break

}

else {

$Vuln216646[1] = "NotAFinding"
$Vuln216646[2] = "All disabled interfaces have been shut down accordingly."

}

}


## V-216647 - The Cisco switch must be configured to have all non-essential capabilities disabled.

Foreach ($Line in $Nonessential){


if ($Line -in $SwitchConfig){


$Vuln216647[1] = "Open"
$Vuln216647[2] = "Nonessential item included in switch config"
write-output "Nonessential item included in config for V-216647 here: $Line" >> $ShortDestination
break

}
else {

$Vuln216647[1] = "NotAFinding"
$Vuln216647[2] = "Nonessential items are not  included in switch config"


}


} ## end foreach line item





## V-220993 - The Cisco switch must not be configured to have any feature enabled that calls home to the vendor.

if ($Switchconfig -like "*service call-home*"){

$Vuln216996[1] = "Open"
$Vuln216996[2] = "Call home feature is enabled"
write-output "Call-home feature enabled on switch, when it shouldn't be for V-216996" >> $ShortDestination

}
else {

$Vuln216996[1] = "NotAFinding"
$Vuln216996[2] = "Call home feature disabled"

}


## V-216649 - The Cisco switch must not be configured to have any zero-touch deployment feature enabled when connected to an operational network.

if ($SwitchConfig -like "*boot network*"){

$Vuln216649[1] = "Open"
$Vuln216649[2] = "Boot network is enabled and should be disabled"
write-output "Boot network needs to be disabled for V-216649" >> $ShortDestination

}
else {

$Vuln216649[1] = "NotAFinding"
$Vuln216649[2] = "Boot network is disabled"

}



## V-216650 - The Cisco switch must be configured to protect against or limit the effects of denial-of-service (DoS) attacks by employing control plane protection.

if ($SwitchConfig -like "*class-map*" -and $SwitchConfig -like "*match access-group*"){

$Vuln216650[1] = "NotAFinding"

}
else {

$Vuln216650[1] = "Open"
$Vuln216650[2] = "Missing class-map and match access-group configs"

write-output "Missing class-map and match access-group configs for V-216650" >> $ShortDestination

}








## V-216653

if ($SwitchConfig -like "*no ip gratuitous-arps*"){

$Vuln216653[1] = "NotAFinding"
$Vuln216653[2] = "ip gratuitous arps is disabled."


}

else {

$Vuln216653[1] = "Open"
$Vuln216653[2] = "ip gratuitous arps is configured when it should be disabled."

write-output "ip gratuitous-arps should not be configured for V-216653" >> $ShortDestination


}


##V-216654 - The Cisco switch must be configured to have IP directed broadcast disabled on all interfaces.

foreach ($Interface in $Eachinterface){

if ($Interface -notlike "*DISABLED*" -and $Interface -notlike "*switchport mode trunk*" -and $Interface -notlike "*vlan 999*" -and $Interface -notlike "*shutdown*"){

if ($Interface -like "*ip directed-broadcast*"){


$Vuln216654[1] = "Open"
$Vuln216654[2] = "ip directed-broadcast is in interface configuration and should not be."
write-output "Remove ip-directed broadcast for V-216654 here: `n
 $Interface `n" >> $ShortDestination
break

} ## end if

else {

$Vuln216654[1] = "NotAFinding"
$Vuln216654[2] = "ip directed-broadcast not found for any configured interfaces."

} ## end else


} ## end of if interface isnt a trunk port and not disabled



} ## end of foreach interface






## V-216655

foreach ($Interface in $Eachinterface){

if ($Interface -notlike "*DISABLED*" -and $Interface -notlike "*switchport mode trunk*" -and $Interface -notlike "*vlan 999*" -and $Interface -notlike "*shutdown*"){

if ($Interface -like "*ip address 129*" -or $Interface -like "*ip address 10*"){

if ($Interface -notlike "*no ip unreachables*"){

$Vuln216655[1] = "Open"
$Vuln216655[2] = "Missing no ip unreachables config in external interface"
write-output "Missing no ip unreachables for V-216655 here: `n
 $Interface `n" >> $ShortDestination
break

} ################# end if

else {

$Vuln216655[1] = "NotAFinding"
$Vuln216655[2] = "no ip unreachables configured for all external interfaces"

} ################# end else



} ## end of if interface has ip address configuration. which can tell us which external interfaces there are

} ## end of if interface isnt a trunk port and not disabled

} ## end of foreach interface













## V-216656

foreach ($Interface in $Eachinterface){

if ($Interface -notlike "*DISABLED*" -and $Interface -notlike "*switchport mode trunk*" -and $Interface -notlike "*vlan 999*" -and $Interface -notlike "*shutdown*"){

if ($Interface -like "*ip address 129*" -or $Interface -like "*ip address 10*"){

if ($Interface -like "*ip mask-reply*"){

$Vuln216656[1] = "Open"
$Vuln216656[2] = "ip mask-reply is in interface configuration and should not be."
write-output "Remove ip mask-reply for V-216656 here: `n
$Interface `n" >> $ShortDestination
break

} ################# end if

else {

$Vuln216656[1] = "NotAFinding"
$Vuln216656[2] = "ip mask-reply not found for any configured interfaces."

} ################# end else



} ## end of if interface has ip address configuration. which can tell us which external interfaces there are

} ## end of if interface isnt a trunk port and not disabled

} ## end of foreach interface




## V-216657 - The Cisco switch must be configured to have Internet Control Message Protocol (ICMP) redirect messages disabled on all external interfaces.

foreach ($Interface in $Eachinterface){

if ($Interface -notlike "*DISABLED*" -and $Interface -notlike "*switchport mode trunk*" -and $Interface -notlike "*vlan 999*" -and $Interface -notlike "*shutdown*"){

if ($Interface -like "*ip address 129*" -or $Interface -like "*ip address 10*"){

if ($Interface -notlike "*no ip redirects*"){

$Vuln216657[1] = "Open"
$Vuln216657[2] = "Missing no ip redirects config in external interface"
write-output "Missing no ip redirects for V-216657 here: `n
 $Interface `n" >> $ShortDestination
break

} ################# end if

else {

$Vuln216657[1] = "NotAFinding"
$Vuln216657[2] = "no ip redirects configured for all external interfaces"

} ################# end else



} ## end of if interface has ip address configuration. which can tell us which external interfaces there are

} ## end of if interface isnt a trunk port and not disabled

} ## end of foreach interface




## V-216658 - The Cisco switch must be configured to log all packets that have been dropped at interfaces via an ACL.

Foreach ($AccList in $AccessLists){


if ($AccList -notlike "*log-update*" -and $AccList -notlike "*permit 1.1.1.1*" -and $AccList -notlike "*Not-Applicable*"){

if ($AccList -notlike "*deny * log*"){

$Vuln216658[1] = "Open"
$Vuln216658[2] = "Access list missing deny log statement"

$Vuln216659[1] = "Open"
$Vuln216659[2] = "Access list missing deny log statement"

$Vuln216660[1] = "Open"
$Vuln216660[2] = "Access list missing deny log statement"

write-output "Missing deny log statement for V-216658, 04, 05 here: `n
 $AccList `n"  >> $ShortDestination
break
}
else {


$Vuln216658[1] = "NotAFinding"
$Vuln216658[2] = "Each access list is configured to log all packets that have been dropped."

$Vuln216659[1] = "NotAFinding"
$Vuln216659[2] = "Each access list is configured to log all packets that have been dropped."

$Vuln216660[1] = "NotAFinding"
$Vuln216660[2] = "Each access list is configured to log all packets that have been dropped."


}

} ## if not log access list

} ## end foreach









## V-216661

if ($Auxline -like "*no exec*"){

$Vuln216661[1] = "NotAFinding"
$Vuln216661[2] = "line aux 0 is disabled."

}
else {

$Vuln216661[1] = "Open"
$Vuln216661[2] = "line aux 0 is not disabled."
write-output "Missing no exec for line aux 0 for V-216661 here: $Auxline" >> $ShortDestination


}





## V-216716 - The Cisco switch must be configured to enforce a Quality-of-Service (QoS) policy to limit the effects of packet flooding denial-of-service (DoS) attacks.

<#
if ($Scavenger -like "*match dscp cs1*"){

$Vuln216716[1] = "NotAFinding"
$Vuln216716[2] = "Class map has been configured for the Scavenger class"
}

else {

$Vuln216716[1] = "Open"
$Vuln216716[2] = "Class map has not been configured for the Scavenger class"

write-output "Missing match dscp cs1 on Scavenger class for V-216716 here: $Scavenger" >> $ShortDestination


}

#>





## V-216684 - The Cisco router providing connectivity to the Network Operations Center (NOC) must be configured to forward all in-band management traffic via an IPsec tunnel.


Foreach ($Interface in $Eachinterface){

if ($Interface -like "*interface GigabitEthernet0/0/0*"){

if ($Interface -like "*crypto map*"){

$Vuln216684[1] = "NotAFinding"
$Vuln216684[2] = "Crypto map on in-band management interface configured"

}
else {


$Vuln216684[1] = "Open"
$Vuln216684[2] = "Missing crypto map on in-band management interface"

write-output "Missing crypto map on interface for V-216684 here:`n
 $Interface" >> $ShortDestination
break

}





}



}



## V-216995 - 

<#

Foreach ($Key in $Keychain){

if ($Key -like "*accept-lifetime * infinite*" -or $Key -like "*send-lieftime * infinite*"){

$Vuln216995[1] = "Open"
$Vuln216995[2] = "Key lifetime should not be more than 180 days"

write-output "key-string should not have a lifespan of more than 180 days for V-216995 here: $Key" >> $ShortDestination
break

}
else {

$Vuln216995[1] = "NotAFinding"
$Vuln216995[2] = "Key lifetime is configured properly, and has a lifespan of less than 180 days."


}

} ## end foreach key

if ($Key -eq $null -or $Keychain -eq $null){

$Vuln216995[1] = "Open"
$Vuln216995[2] = "Each key is not using FIPS 198-1 HMAC to authenticate routing protocol messages. Missing key-chain"

write-output "Missing OSPF key chain and send/receive lifetime dates for V-216995" >> $ShortDestination

}



#>




## V-216994


<#

if ($Switchconfig -like "*ip ospf authentication key-chain*"){

$Vuln216994[1] = "NotAFinding"
$Vuln216994[2] = "ip ospf authentication configured properly on switch"

}
else {


$Vuln216994[1] = "Open"
$Vuln216994[2] = "ip ospf authentication key-chain not configured on switch"

write-output "Missing ip ospf authentication key-chain for V-216994" >> $ShortDestination

}


#>



## V-229031 - The Cisco switch must be configured to have Cisco Express Forwarding enabled.


<#
if ($SwitchConfig -like "*ip cef*"){

$Vuln229031[1] = "NotAFinding"
$Vuln229031[2] = "ip cef is enabled"


}
else {

$Vuln229031[1] = "Open"
$Vuln229031[2] = "ip cef is not enabled"
write-output "Missing ip cef in config for V-229031" >> $ShortDestination

}



write-output "`n`n" >> $ShortDestination


#>




### END STIG PROCESS #####



$AllVulnArray = @(
$Vuln216641,
$Vuln216644,
$Vuln216645,
$Vuln216646,
$Vuln216647,
$Vuln216649,
$Vuln216650,
$Vuln216651,
$Vuln216652,
$Vuln216653,
$Vuln216654,
$Vuln216655,
$Vuln216656,
$Vuln216657,
$Vuln216658,
$Vuln216659,
$Vuln216660,
$Vuln216661,
$Vuln216662,
$Vuln216663,
$Vuln216664,
$Vuln216665,
$Vuln216666,
$Vuln216667,
$Vuln216668,
$Vuln216670,
$Vuln216671,
$Vuln216672,
$Vuln216674,
$Vuln216675,
$Vuln216676,
$Vuln216677,
$Vuln216678,
$Vuln216679,
$Vuln216680,
$Vuln216681,
$Vuln216682,
$Vuln216683,
$Vuln216684,
$Vuln216687,
$Vuln216688,
$Vuln216689,
$Vuln216690,
$Vuln216691,
$Vuln216692,
$Vuln216693,
$Vuln216694,
$Vuln216695,
$Vuln216696,
$Vuln216697,
$Vuln216698,
$Vuln216699,
$Vuln216700,
$Vuln216701,
$Vuln216702,
$Vuln216703,
$Vuln216704,
$Vuln216705,
$Vuln216706,
$Vuln216707,
$Vuln216708,
$Vuln216709,
$Vuln216710,
$Vuln216711,
$Vuln216712,
$Vuln216714,
$Vuln216715,
$Vuln216716,
$Vuln216717,
$Vuln216718,
$Vuln216719,
$Vuln216720,
$Vuln216721,
$Vuln216722,
$Vuln216723,
$Vuln216724,
$Vuln216725,
$Vuln216726,
$Vuln216727,
$Vuln216728,
$Vuln216729,
$Vuln216730,
$Vuln216731,
$Vuln216732,
$Vuln216733,
$Vuln216994,
$Vuln216995,
$Vuln216996,
$Vuln216997,
$Vuln216998,
$Vuln216999,
$Vuln217000,
$Vuln217001,
$Vuln229031,
$Vuln230039,
$Vuln230042,
$Vuln230045,
$Vuln230048,
$Vuln230051,
$Vuln230146,
$Vuln230150,
$Vuln230153,
$Vuln230156,
$Vuln230159


) ## end of vulnerability item array















#### XML Extraction #####


## Pulls all Vulnerability Numbers
$PreVulns = $BlankConfig.selectNodes("//STIG_DATA[VULN_ATTRIBUTE='Vuln_Num']")
$AfterVulns = $Prevulns.Attribute_data ## All of the vulnerability IDs

## Pulls all of the Statuses
$Allstatus = $BlankConfig.GetElementsByTagName('STATUS')

## Pulls all of the comments
$Allcomments = $BlankConfig.GetElementsByTagName('FINDING_DETAILS')



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
STIG_Title = "Cisco IOS XE Router RTR V2R2"
CCRI_Score = $CCRIScore
} ## end property build




} ## If create csv matches yes




if ($CreateCKL -eq "yes" -or $CreateCKL -eq "y"){

## Creates the XML doc
$XMLWriter = [System.XML.XmlWriter]::Create($OutputDestination, $XMLSettings)  ## creates file at $Destination location with $XMLSettings -- (blank)
$BlankConfig.Save($XMLWriter) ## Saves the extract document changes above to the xml writer object (which follows the validation scheme for STIG viewer)
$XMLWriter.Flush()
$XMLWriter.Dispose()

}



$BlankConfig = $null


### END XML Extraction ###


} ## end of foreach

if ($CreateCSV -match "Yes"){


$SwitchComplianceObj | Select-Object Hostname, Cat_I, Cat_I_Open, Cat_II, Cat_II_Open, Cat_III, Cat_III_Open, CCRI_Score, STIG_Title | Sort-Object Hostname, Cat_I, Cat_I_Open, Cat_II, Cat_II_Open, Cat_III, Cat_III_Open, CCRI_Score, STIG_Title | Export-Csv -Path $CSVPath -NoTypeInformation -Append


}


if (Test-Path $ShortDestination){

write-host -ForegroundColor Green "Successfully created output file: $ShortDestination"

}
else {

## Continue

}
