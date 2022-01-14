## CISCO IOS-XE Switch RTR STIG V2R1 Released 23 Apr 2021

$CreateCSV = "Yes" ## Yes or no
$CSVPath = "C:\temp\Switch-Configs\Allswitchcompliance.csv"


## ASK QUESTIONS FOR INPUT/OUTPUT DIRECTORY #####################
$Configdirectory = read-host "Please provide the directory path for where each Cisco IOS-XE Switch RTR configuration file is located"

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
$Vuln220986 = “V-220986", “Not_Reviewed”, “null“, "CatTwo"
$Vuln220987 = “V-220987", “Not_Reviewed”, “null“, "CatTwo"
$Vuln220988 = “V-220988", “Not_Reviewed”, “null“, "CatTwo"
$Vuln220989 = “V-220989", “Not_Reviewed”, “null“, "CatTwo"
$Vuln220990 = “V-220990", “Not_Reviewed”, “null“, "CatTwo"
$Vuln220991 = “V-220991", “Not_Reviewed”, “null“, "CatThree"
$Vuln220992 = “V-220992", “Not_Reviewed”, “null“, "CatThree"
$Vuln220993 = “V-220993", “Not_Reviewed”, “null“, "CatTwo"
$Vuln220994 = “V-220994", “Not_Reviewed”, “null“, "CatTwo"
$Vuln220995 = “V-220995", “Not_Reviewed”, “null“, "CatTwo"
$Vuln220996 = “V-220996", “Not_Reviewed”, “null“, "CatOne"
$Vuln220997 = “V-220997", “Not_Reviewed”, “null“, "CatTwo"
$Vuln220998 = “V-220998", “Not_Reviewed”, “null“, "CatTwo"
$Vuln220999 = “V-220999", “Not_Reviewed”, “null“, "CatThree"
$Vuln221000 = “V-221000", “Not_Reviewed”, “null“, "CatTwo"
$Vuln221001 = “V-221001", “Not_Reviewed”, “null“, "CatThree"
$Vuln221002 = “V-221002", “Not_Reviewed”, “null“, "CatTwo"
$Vuln221003 = “V-221003", “Not_Reviewed”, “null“, "CatThree"
$Vuln221004 = “V-221004", “Not_Reviewed”, “null“, "CatTwo"
$Vuln221005 = “V-221005", “Not_Reviewed”, “null“, "CatTwo"
$Vuln221006 = “V-221006", “Not_Reviewed”, “null“, "CatThree"
$Vuln221007 = “V-221007", “Not_Applicable”, “null“, "CatOne"
$Vuln221008 = “V-221008", “Not_Applicable”, “null“, "CatTwo"
$Vuln221009 = “V-221009", “Not_Applicable”, “null“, "CatTwo"
$Vuln221010 = “V-221010", “Not_Applicable”, “null“, "CatTwo"
$Vuln221011 = “V-221011", “Not_Applicable”, “null“, "CatOne"
$Vuln221012 = “V-221012", “Not_Applicable”, “null“, "CatTwo"
$Vuln221013 = “V-221013", “Not_Applicable”, “null“, "CatTwo"
$Vuln221014 = “V-221014", “Not_Applicable”, “null“, "CatTwo"
$Vuln221015 = “V-221015", “Not_Applicable”, “null“, "CatTwo"
$Vuln221016 = “V-221016", “Not_Applicable”, “null“, "CatThree"
$Vuln221017 = “V-221017", “Not_Applicable”, “null“, "CatThree"
$Vuln221018 = “V-221018", “Not_Applicable”, “null“, "CatTwo"
$Vuln221019 = “V-221019", “Not_Applicable”, “null“, "CatTwo"
$Vuln221020 = “V-221020", “Not_Applicable”, “null“, "CatTwo"
$Vuln221021 = “V-221021", “Not_Applicable”, “null“, "CatThree"
$Vuln221022 = “V-221022", “Not_Applicable”, “null“, "CatTwo"
$Vuln221023 = “V-221023", “Not_Applicable”, “null“, "CatTwo"
$Vuln221024 = “V-221024", “Not_Applicable”, “null“, "CatTwo"
$Vuln221025 = “V-221025", “Not_Applicable”, “null“, "CatTwo"
$Vuln221026 = “V-221026", “Not_Applicable”, “null“, "CatTwo"
$Vuln221027 = “V-221027", “Not_Applicable”, “null“, "CatTwo"
$Vuln221028 = “V-221028", “Not_Applicable”, “null“, "CatThree"
$Vuln221029 = “V-221029", “Not_Applicable”, “null“, "CatThree"
$Vuln221030 = “V-221030", “Not_Applicable”, “null“, "CatTwo"
$Vuln221031 = “V-221031", “Not_Applicable”, “null“, "CatThree"
$Vuln221032 = “V-221032", “Not_Applicable”, “null“, "CatThree"
$Vuln221033 = “V-221033", “Not_Applicable”, “null“, "CatThree"
$Vuln221034 = “V-221034", “Not_Applicable”, “null“, "CatThree"
$Vuln221035 = “V-221035", “Not_Applicable”, “null“, "CatThree"
$Vuln221036 = “V-221036", “Not_Applicable”, “null“, "CatTwo"
$Vuln221037 = “V-221037", “Not_Applicable”, “null“, "CatOne"
$Vuln221038 = “V-221038", “Not_Applicable”, “null“, "CatOne"
$Vuln221039 = “V-221039", “Not_Applicable”, “null“, "CatTwo"
$Vuln221040 = “V-221040", “Not_Applicable”, “null“, "CatTwo"
$Vuln221041 = “V-221041", “Not_Applicable”, “null“, "CatOne"
$Vuln221042 = “V-221042", “Not_Applicable”, “null“, "CatOne"
$Vuln221043 = “V-221043", “Not_Applicable”, “null“, "CatThree"
$Vuln221044 = “V-221044", “Not_Applicable”, “null“, "CatTwo"
$Vuln221045 = “V-221045", “Not_Applicable”, “null“, "CatThree"
$Vuln221046 = “V-221046", “Not_Applicable”, “null“, "CatTwo"
$Vuln221047 = “V-221047", “Not_Applicable”, “null“, "CatOne"
$Vuln221048 = “V-221048", “Not_Applicable”, “null“, "CatTwo"
$Vuln221049 = “V-221049", “Not_Applicable”, “null“, "CatTwo"
$Vuln221050 = “V-221050", “Not_Applicable”, “null“, "CatThree"
$Vuln221051 = “V-221051", “Not_Applicable”, “null“, "CatThree"
$Vuln221052 = “V-221052", “Not_Reviewed”, “null“, "CatTwo"
$Vuln221053 = “V-221053", “Not_Applicable”, “null“, "CatTwo"
$Vuln221054 = “V-221054", “Not_Applicable”, “null“, "CatTwo"
$Vuln221055 = “V-221055", “Not_Applicable”, “null“, "CatThree"
$Vuln221056 = “V-221056", “Not_Applicable”, “null“, "CatThree"
$Vuln221057 = “V-221057", “Not_Applicable”, “null“, "CatThree"
$Vuln221058 = “V-221058", “Not_Applicable”, “null“, "CatThree"
$Vuln221059 = “V-221059", “Not_Applicable”, “null“, "CatTwo"
$Vuln221060 = “V-221060", “Not_Applicable”, “null“, "CatThree"
$Vuln221061 = “V-221061", “Not_Applicable”, “null“, "CatTwo"
$Vuln221062 = “V-221062", “Not_Applicable”, “null“, "CatTwo"
$Vuln221063 = “V-221063", “Not_Applicable”, “null“, "CatTwo"
$Vuln221064 = “V-221064", “Not_Applicable”, “null“, "CatTwo"
$Vuln221065 = “V-221065", “Not_Applicable”, “null“, "CatTwo"
$Vuln221066 = “V-221066", “Not_Applicable”, “null“, "CatThree"
$Vuln221067 = “V-221067", “Not_Applicable”, “null“, "CatThree"
$Vuln221068 = “V-221068", “Not_Applicable”, “null“, "CatThree"
$Vuln221069 = “V-221069", “Not_Applicable”, “null“, "CatThree"
$Vuln237750 = "V-237750", “NotAFinding”, “null“, "CatTwo"
$Vuln237752 = “V-237752", “Not_Applicable”, “null“, "CatThree"
$Vuln237756 = “V-237756", “Not_Applicable”, “null“, "CatTwo"
$Vuln237759 = “V-237759", “Not_Applicable”, “null“, "CatTwo"
$Vuln237762 = “V-237762", “Not_Applicable”, “null“, "CatTwo"
$Vuln237764 = “V-237764", “Not_Applicable”, “null“, "CatTwo"
$Vuln237766 = “V-237766", “Not_Applicable”, “null“, "CatTwo"
$Vuln237772 = “V-237772", “Not_Applicable”, “null“, "CatTwo"
$Vuln237774 = “V-237774", “Not_Applicable”, “null“, "CatTwo"
$Vuln237776 = “V-237776", “Not_Applicable”, “null“, "CatTwo"
$Vuln237778 = “V-237778", “Not_Applicable”, “null“, "CatTwo"



[XML]$BlankConfig = Get-content $BlankFilePath ## Save blank checklist to xml object

$SwitchConfig = Get-content $SingleSwitch ## Gets the content of the switch congiguration

$Hostname = $SingleSwitch.BaseName ## Gets the basename of the switch config file, so we have a proper way to name the output file



## Formatting the final directory + filepath for output
if ($OutputDirPath[-1] -eq "\"){
$OutputDestination = $OutputDirPath + $Hostname + ".ckl"
$ShortDestination = $OutputDirPath + $TodayDate + "-Switch-RTR_Compliance-Quick-Results" + ".txt"
}
else {
$OutputDestination = $OutputDirPath + "\" + $Hostname + ".ckl"
$ShortDestination = $OutputDirPath + "\" + $TodayDate + "-Switch-RTR_Compliance-Quick-Results" + ".txt"
}

## REMINDERS -------------------------------------------
# Switchconfig = Content of switch config              |
# OutputDestination = FULL filepath for output file    |
# BlankConfig = Blank checklist full filepath [XML]    |

## -----------------------------------------------------



write-output "Quick Glance at Hostname $Hostname on $Date`n" >> $ShortDestination ## Write this to a quick-results file, which is a quick overview/glance of how each switch stands per configuration.


## BEGIN STIG PROCESS

## GLOBAL STIG VARIABLES

$Accesslists = $Switchconfig | Select-string "ip access-list" -Context 0,35

$Eachinterface = $SwitchConfig | Select-String "GigabitEthernet" -Context 0,25

$Keychain = $Switchconfig | Select-String "key-string" -Context 1,3

$AuxLine = $SwitchConfig | Select-String "line aux 0" -Context 0,2


$Scavenger = $SwitchConfig | Select-String "class-map match-any AutoQos-4.0-Output-Scavenger-Queue" -Context 0,1



## END GLOBAL STIG VARIABLES



## V-220986 - The Cisco switch must be configured to enforce approved authorizations for controlling the flow of information within the network based on organization-defined information flow control policies.

Foreach ($AccList in $Accesslists){

if ($Acclist -like "*permit * log*" -or $Acclist -like "*permit tcp*" -or $Acclist -like "*permit udp*" -or $Acclist -like "*ip tcp*" -or $Acclist -like "*ip udp*"){

$Vuln220986[1] = "NotAFinding"


}
else {

$Vuln220986[1] = "Open"
$Vuln220986[2] = "Missing allow or deny traffic for specific protoclols for each access-list."

write-output "Missing config here for V-220986: `n $Acclist" >> $ShortDestination

break


}


}





## V-220987

if ($Switchconfig -like "*ip ospf authentication key-chain*"){

$Vuln220987[1] = "NotAFinding"
$Vuln220987[2] = "ip ospf authentication configured properly on switch"

}
else {


$Vuln220987[1] = "Open"
$Vuln220987[2] = "ip ospf authentication key-chain not configured on switch"

write-output "Missing ip ospf authentication key-chain for V-220987" >> $ShortDestination

}


## V-220988 - The Cisco switch must be configured to use keys with a duration not exceeding 180 days for authenticating routing protocol messages.


Foreach ($Key in $Keychain){

if ($Key -like "*accept-lifetime * infinite*" -or $Key -like "*send-lieftime * infinite*"){

$Vuln220988[1] = "Open"
$Vuln220988[2] = "Key lifetime should not be more than 180 days"

write-output "key-string should not have a lifespan of more than 180 days for V-220988 here:`n $Key" >> $ShortDestination
break

}
else {

$Vuln220988[1] = "NotAFinding"
$Vuln220988[2] = "Key lifetime is configured properly, and has a lifespan of less than 180 days."


}



} ## end fofreach key






## V-220989 - The Cisco switch must be configured to use encryption for routing protocol authentication.


if ($Switchconfig -like "*ip ospf authentication message-digest*" -and $Switchconfig -like "*ip ospf message-digest-key*"){

$Vuln220989[1] = "NotAFinding"
$Vuln220989[2] = "ospf key is encrypted"

}
else {


$Vuln220989[1] = "Open"
$Vuln220989[2] = "Switch is not using encryption for ospf key"

write-output "Missing ip ospf authentication message-digest for key encryption for V-220989" >> $ShortDestination

}


## V-220990 - The Cisco switch must be configured to authenticate all routing protocol messages using NIST-validated FIPS 198-1 message authentication code algorithm.

foreach ($Key in $Keychain){


if ($Key -like "*cryptographic-algorithm hmac-sha-256*"){

$Vuln220990[1] = "NotAFinding"
$Vuln220990[2] = "Each key is using FIPS 198-1 HMAC to authenticate routing protocol messages"

}

else {

$Vuln220990[1] = "Open"
$Vuln220990[2] = "Each key is not using FIPS 198-1 HMAC to authenticate routing protocol messages"

write-output "Missing cryptographic-algorithm hmac-sha-256 for V-220990 here: `n $Key" >> $ShortDestination

break
}



}


## V-220991 - The Cisco switch must be configured to have all inactive layer 3 interfaces disabled.

Foreach ($Interface in $Eachinterface){

if (($Interface -like "*DISABLED*" -or $Interface -like "*disabled*") -and $Interface -notlike "*shutdown*"){

$Vuln220991[1] = "Open"
$Vuln220991[2] = "There is a disabled interface that's not been shutdown"

write-output "There is a disabled interface that's not been shutdown for V-220991 here:`n $Interface" >> $ShortDestination
break

}

else {

$Vuln220991[1] = "NotAFinding"
$Vuln220991[2] = "All disabled interfaces have been shut down accordingly."

}

}


## V-220992 - The Cisco switch must be configured to have all non-essential capabilities disabled.

Foreach ($Line in $Nonessential){


if ($Line -in $SwitchConfig){


$Vuln220992[1] = "Open"
$Vuln220992[2] = "Nonessential item included in switch config"
write-output "Nonessential item included in config for V-220992 here:`n $Line" >> $ShortDestination
break

}
else {

$Vuln220992[1] = "NotAFinding"
$Vuln220992[2] = "Nonessential items are not  included in switch config"


}


} ## end foreach line item





## V-220993 - The Cisco switch must not be configured to have any feature enabled that calls home to the vendor.

if ($Switchconfig -like "*call-home*" -and $Switchconfig -notlike "*no call-home*"){

$Vuln220993[1] = "Open"
$Vuln220993[2] = "Call home feature is enabled"
write-output "Call-home feature enabled on switch, when it shouldn't be for V-220993" >> $ShortDestination

}
else {

$Vuln220993[1] = "NotAFinding"
$Vuln220993[2] = "Call home feature disabled"

}


## V-220994 - The Cisco switch must not be configured to have any zero-touch deployment feature enabled when connected to an operational network.

if ($SwitchConfig -like "*boot network*"){

$Vuln220994[1] = "Open"
$Vuln220994[2] = "Boot network is enabled and should be disabled"
write-output "Boot network needs to be disabled for V-220994" >> $ShortDestination

}
else {

$Vuln220994[1] = "NotAFinding"
$Vuln220994[2] = "Boot network is disabled"

}



## V-220995 - The Cisco switch must be configured to protect against or limit the effects of denial-of-service (DoS) attacks by employing control plane protection.

if ($SwitchConfig -like "*class-map*" -and $SwitchConfig -like "*match access-group*"){

$Vuln220995[1] = "NotAFinding"

}
else {

$Vuln220995[1] = "Open"
$Vuln220995[2] = "Missing class-map and match access-group configs"

write-output "Missing class-map and match access-group configs for V-220995" >> $ShortDestination

}








## V-220998

if ($SwitchConfig -like "*no ip gratuitous-arps*"){

$Vuln220998[1] = "NotAFinding"
$Vuln220998[2] = "ip gratuitous arps is disabled."


}

else {

$Vuln220998[1] = "Open"
$Vuln220998[2] = "ip gratuitous arps is configured when it should be disabled."

write-output "ip gratuitous-arps should not be configured for V-220998" >> $ShortDestination


}


##V-220999 - The Cisco switch must be configured to have IP directed broadcast disabled on all interfaces.

foreach ($Interface in $Eachinterface){

if ($Interface -notlike "*DISABLED*" -and $Interface -notlike "*switchport mode trunk*" -and $Interface -notlike "*vlan 999*" -and $Interface -notlike "*shutdown*"){

if ($Interface -like "*ip directed-broadcast*"){


$Vuln220999[1] = "Open"
$Vuln220999[2] = "ip directed-broadcast is in interface configuration and should not be."
write-output "Remove ip-directed broadcast for V-220999 here: `n $Interface" >> $ShortDestination
break

} ## end if

else {

$Vuln220999[1] = "NotAFinding"
$Vuln220999[2] = "ip directed-broadcast not found for any configured interfaces."

} ## end else


} ## end of if interface isnt a trunk port and not disabled



} ## end of foreach interface






## V-221000

foreach ($Interface in $Eachinterface){

if ($Interface -notlike "*DISABLED*" -and $Interface -notlike "*switchport mode trunk*" -and $Interface -notlike "*vlan 999*" -and $Interface -notlike "*shutdown*"){

if ($Interface -like "*ip address 129*" -or $Interface -like "*ip address 10*"){

if ($Interface -notlike "*no ip unreachables*"){

$Vuln221000[1] = "Open"
$Vuln221000[2] = "Missing no ip unreachables config in external interface"
write-output "Missing no ip unreachables for V-221000 here: `n $Interface" >> $ShortDestination
break

} ################# end if

else {

$Vuln221000[1] = "NotAFinding"
$Vuln221000[2] = "no ip unreachables configured for all external interfaces"

} ################# end else



} ## end of if interface has ip address configuration. which can tell us which external interfaces there are

} ## end of if interface isnt a trunk port and not disabled

} ## end of foreach interface













## V-221001

foreach ($Interface in $Eachinterface){

if ($Interface -notlike "*DISABLED*" -and $Interface -notlike "*switchport mode trunk*" -and $Interface -notlike "*vlan 999*" -and $Interface -notlike "*shutdown*"){

if ($Interface -like "*ip address 129*" -or $Interface -like "*ip address 10*"){

if ($Interface -like "*ip mask-reply*"){

$Vuln221001[1] = "Open"
$Vuln221001[2] = "ip mask-reply is in interface configuration and should not be."
write-output "Remove ip mask-reply for V-221001 here: `n $Interface" >> $ShortDestination
break

} ################# end if

else {

$Vuln221001[1] = "NotAFinding"
$Vuln221001[2] = "ip mask-reply not found for any configured interfaces."

} ################# end else



} ## end of if interface has ip address configuration. which can tell us which external interfaces there are

} ## end of if interface isnt a trunk port and not disabled

} ## end of foreach interface




## V-221002 - The Cisco switch must be configured to have Internet Control Message Protocol (ICMP) redirect messages disabled on all external interfaces.

foreach ($Interface in $Eachinterface){

if ($Interface -notlike "*DISABLED*" -and $Interface -notlike "*switchport mode trunk*" -and $Interface -notlike "*vlan 999*" -and $Interface -notlike "*shutdown*"){

if ($Interface -like "*ip address 129*" -or $Interface -like "*ip address 10*"){

if ($Interface -notlike "*no ip redirects*"){

$Vuln221002[1] = "Open"
$Vuln221002[2] = "Missing no ip redirects config in external interface"
write-output "Missing no ip redirects for V-221002 here: `n $Interface" >> $ShortDestination
break

} ################# end if

else {

$Vuln221002[1] = "NotAFinding"
$Vuln221002[2] = "no ip redirects configured for all external interfaces"

} ################# end else



} ## end of if interface has ip address configuration. which can tell us which external interfaces there are

} ## end of if interface isnt a trunk port and not disabled

} ## end of foreach interface




## V-221003 - The Cisco switch must be configured to log all packets that have been dropped at interfaces via an ACL.

Foreach ($AccList in $AccessLists){

if ($AccList -notlike "*log-update*" -and $AccList -notlike "*permit 1.1.1.1*" -and $AccList -notlike "*Not-Applicable*"){

if ($AccList -notlike "*deny * log*"){

$Vuln221003[1] = "Open"
$Vuln221003[2] = "Access list missing deny log statement"

$Vuln221004[1] = "Open"
$Vuln221004[2] = "Access list missing deny log statement"

$Vuln221005[1] = "Open"
$Vuln221005[2] = "Access list missing deny log statement"

write-output "Missing deny log statement for V-221003, 04, 05 here:`n $AccList" >> $ShortDestination
break
}
else {


$Vuln221003[1] = "NotAFinding"
$Vuln221003[2] = "Each access list is configured to log all packets that have been dropped."

$Vuln221004[1] = "NotAFinding"
$Vuln221004[2] = "Each access list is configured to log all packets that have been dropped."

$Vuln221005[1] = "NotAFinding"
$Vuln221005[2] = "Each access list is configured to log all packets that have been dropped."


}

}

} ## end foreach









## V-221006

if ($Auxline -like "*no exec*"){

$Vuln221006[1] = "NotAFinding"
$Vuln221006[2] = "line aux 0 is disabled."

}
else {

$Vuln221006[1] = "Open"
$Vuln221006[2] = "line aux 0 is not disabled."
write-output "Missing no exec for line aux 0 for V-221006 here:`n $Auxline" >> $ShortDestination


}





## V-221052 - The Cisco switch must be configured to enforce a Quality-of-Service (QoS) policy to limit the effects of packet flooding denial-of-service (DoS) attacks.

if ($Scavenger -like "*match dscp cs1*"){

$Vuln221052[1] = "NotAFinding"
$Vuln221052[2] = "Class map has been configured for the Scavenger class"
}

else {

$Vuln221052[1] = "Open"
$Vuln221052[2] = "Class map has not been configured for the Scavenger class"

write-output "Missing match dscp cs1 on Scavenger class for V-221052 here:`n $Scavenger" >> $ShortDestination


}



## V-237750 - The Cisco switch must be configured to have Cisco Express Forwarding enabled.
<#


if ($SwitchConfig -like "*ip cef*"){

$Vuln237750[1] = "NotAFinding"
$Vuln237750[2] = "ip cef is enabled"


}
else {

$Vuln237750[1] = "Open"
$Vuln237750[2] = "ip cef is not enabled"
write-output "Missing ip cef in config for V-237750" >> $ShortDestination

}

#>

### Temporarily disabled based off what pat libby told me. There's no real way to check if this is enabled on a switch besides running a certain cmd from the switch itself




### END STIG PROCESS #####



$AllVulnArray = @(
$Vuln220986,
$Vuln220987,
$Vuln220988,
$Vuln220989,
$Vuln220990,
$Vuln220991,
$Vuln220992,
$Vuln220993,
$Vuln220994,
$Vuln220995,
$Vuln220996,
$Vuln220997,
$Vuln220998,
$Vuln220999,
$Vuln221000,
$Vuln221001,
$Vuln221002,
$Vuln221003,
$Vuln221004,
$Vuln221005,
$Vuln221006,
$Vuln221007,
$Vuln221008,
$Vuln221009,
$Vuln221010,
$Vuln221011,
$Vuln221012,
$Vuln221013,
$Vuln221014,
$Vuln221015,
$Vuln221016,
$Vuln221017,
$Vuln221018,
$Vuln221019,
$Vuln221020,
$Vuln221021,
$Vuln221022,
$Vuln221023,
$Vuln221024,
$Vuln221025,
$Vuln221026,
$Vuln221027,
$Vuln221028,
$Vuln221029,
$Vuln221030,
$Vuln221031,
$Vuln221032,
$Vuln221033,
$Vuln221034,
$Vuln221035,
$Vuln221036,
$Vuln221037,
$Vuln221038,
$Vuln221039,
$Vuln221040,
$Vuln221041,
$Vuln221042,
$Vuln221043,
$Vuln221044,
$Vuln221045,
$Vuln221046,
$Vuln221047,
$Vuln221048,
$Vuln221049,
$Vuln221050,
$Vuln221051,
$Vuln221052,
$Vuln221053,
$Vuln221054,
$Vuln221055,
$Vuln221056,
$Vuln221057,
$Vuln221058,
$Vuln221059,
$Vuln221060,
$Vuln221061,
$Vuln221062,
$Vuln221063,
$Vuln221064,
$Vuln221065,
$Vuln221066,
$Vuln221067,
$Vuln221068,
$Vuln221069,
$Vuln237750,
$Vuln237752,
$Vuln237756,
$Vuln237759,
$Vuln237762,
$Vuln237764,
$Vuln237766,
$Vuln237772,
$Vuln237774,
$Vuln237776,
$Vuln237778

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
STIG_Title = "Cisco IOS-XE Switch-RTR V2R1"
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
