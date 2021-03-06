#!/bin/bash

DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0
emulationStationConfig='/etc/emulationstation/es_systems.cfg'
networkInterfacesConfigLocation="/etc/network/interfaces"
wpaSupplicantLocation="/etc/wpa_supplicant/wpa_supplicant.conf"

display_result() {
  whiptail --title "$1" \
	--backtitle "PiAssist" \
    --clear \
    --msgbox "$result" 0 0
}

#########
#Shows the network menu options
#########

# showNetworkMenuOptions() {
	# stayInNetworkMenu=true
	# while $stayInNetworkMenu; do
		# exec 3>&1
		# networkMenuSeleciton=$(whiptail \
			# --backtitle "PiAssist" \
			# --title "System Information" \
			# --clear \
			# --cancel-button "Back" \
			# --menu "Please select:" $HEIGHT $WIDTH 3 \
			# "1" "Display Network Information" \
			# "2" "Scan for WiFI Networks (Root Required)" \
			# "3" "Connect to WiFi Network (Root Required)" \
			# 2>&1 1>&3)
		# exit_status=$?
		# case $exit_status in
			# $DIALOG_CANCEL)
			  # stayInNetworkMenu=false
			  # ;;
			# $DIALOG_ESC)
			  # stayInNetworkMenu=false
			  # ;;
		# esac
		# case $networkMenuSeleciton in
			# 0 )
			  # stayInNetworkMenu=false
			  # ;;
			# 1 )
				# result=$(ifconfig)
				# display_result "Network Information"
				# ;;
			# 2 )
				# currentUser=$(whoami)
				# if [ $currentUser == "root" ] ; then
					# ifconfig wlan0 up
					# #result=$(iwlist wlan0 scan | grep ESSID | sed 's/ESSID://g;s/"//g;s/^ *//;s/ *$//')
					# result=$(iwlist wlan0 scan | grep ESSID | awk -F \" '{print $2}')
					# display_result "WiFi Networks"
				# else
					# result=$(echo "You have to be running the script as root in order to scan for WiFi networks. Please try using sudo.")
					# display_result "WiFi Network"
				# fi
				# ;;
			# 3 )
				# currentUser=$(whoami)
				# if [ $currentUser == "root" ] ; then
					# ifconfig wlan0 up
					# wlanScanResults="$(iwlist wlan0 scan | awk '/IE: WPA/ || /ESSID:/ || /IE: IEEE/ || /Encryption/')"
					# wifiNetworkList=()  # declare list array to be built up
					# ssidList=$(echo "$wlanScanResults" | grep ESSID | sed 's/.*://;s/"//;s/"//') # get list of available SSIDs
					# while read -r line; do
						# wifiNetworkList+=("$line" "$line") # append each SSID to the wifiNetworkList array
					# done <<< "$ssidList" # feed in the ssidList to the while loop
					# wifiNetworkList+=(Other Other) # append an "Other" option to the wifiNetworkList array
					# wifiSSID=$(whiptail --notags --backtitle "PiAssist" --menu "Select WiFi Network" 20 80 10 "${wifiNetworkList[@]}" 3>&1 1>&2 2>&3) # display whiptail menu listing out available SSIDs
					# exit_status=$?
					# wifiNetworkActuallySelected=true
					# case $exit_status in
						# $DIALOG_CANCEL)
						  # wifiNetworkActuallySelected=false
						  # ;;
						# $DIALOG_ESC)
						  # wifiNetworkActuallySelected=false
						  # ;;
					# esac
					
					# #if [ "$wifiSSID" == "Other" ] ; then
					# #	wifiSSID=$(whiptail --title "WiFi Network SSID" --backtitle "PiAssist" --inputbox "Enter the SSID of the WiFi network you would like to connect to:" 0 0 2>&1 1>&3);
					# #fi
					
					# if [ $wifiNetworkActuallySelected == true ] && [ "$wifiSSID" != "" ] ; then
					# #if [ "$wifiSSID" != "" ] ; then
						# actuallyConnectToWifi=false
						# networkInterfacesConfigLocation="/etc/network/interfaces"
						# wpaSupplicantLocation="/etc/wpa_supplicant/wpa_supplicant.conf"
						
						# if (whiptail --title "Create Backup?" --yesno "Would you like to create a backup of your current network interfaces config?" 0 0) then
							# if [ ! -f $networkInterfacesConfigLocation"_bak" ] || [ ! -f $wpaSupplicantLocation"_bak" ] ; then
								# cp $networkInterfacesConfigLocation $networkInterfacesConfigLocation"_bak"
								# cp $wpaSupplicantLocation $wpaSupplicantLocation"_bak"
							# else
								# if (whiptail --title "Overwrite Backup?" --yesno "A backup currently exists. Do you want to overwrite it?" 0 0) then
									# cp $networkInterfacesConfigLocation $networkInterfacesConfigLocation"_bak"
									# cp $wpaSupplicantLocation $wpaSupplicantLocation"_bak"
								# fi
								# actuallyConnectToWifi=true
							# fi		
						# else
							# actuallyConnectToWifi=true
						# fi
						# if [ $actuallyConnectToWifi == true ] ; then
							# ssidLineNumber=$(echo "$wlanScanResults" | awk '/"'"$wifiSSID"'"/ {print NR; exit}')
							# encryptionKey=$(echo "$wlanScanResults" | awk 'NR > "'"$ssidLineNumber"'" && /Encryption/ {print; exit}' | sed 's/Encryption key://' | sed -e 's/^[[:space:]]*//')
							# encryptionKeyLineNumber=$(echo "$wlanScanResults" | awk 'NR > "'"$ssidLineNumber"'" && /ESSID/  {print NR; exit}')
							# encryptionUsed=$(echo "$wlanScanResults" | awk 'NR > "'"$ssidLineNumber"'" && NR < "'"$encryptionKeyLineNumber"'" && /IE:/ {print; exit}')							
							
							# #if other ask for encryption type
							# if [ "$wifiSSID" == "Other" ] ; then
								# wifiSSID=$(whiptail --title "WiFi Network SSID" --backtitle "PiAssist" --inputbox "Enter the SSID of the WiFi network you would like to connect to:" 0 0 2>&1 1>&3);
								# encryptionUsed=$(whiptail --backtitle "PiAssist" --radiolist "Select ROM Folders" 0 0 0 "WPA" "" on "WEP" "" off "Open" "" off 3>&1 1>&2 2>&3)
							# fi
							
							# #if wifi ssid already exists in the wpa_supplicant.conf alert the user and don't continue
							# #this will be replaced by removing that specific configuration in the future
							# if grep -q "ssid=\"$wifiSSID\"" "$wpaSupplicantLocation"; then
								# result=$(echo "The wifi ssid is already in the wpa_supplicant file. You will have to manually delete it from the /etc/wpa_supplicant/wpa_supplicant.conf file if you want to update the WiFi connection information. This will be automated in the future.")
								# display_result "WiFi Network"
							# else
								# #if if wep or wpa/wpa2, ask for password
								# if [[ $encryptionKey == "on" ]] ; then							
									# wifiPassword=$(whiptail --title "WiFi Network Password" --backtitle "PiAssist" --passwordbox "Enter the password of the WiFi network you would like to connect to:" 10 70 2>&1 1>&3);
									# if [ ! "$wifiPassword" == "" ] ; then
										# #if wpa/wpa2
										# if [[ $encryptionUsed == *"WPA"* ]]; then
											# #echo -e 'auto lo\n\niface lo inet loopback\niface eth0 inet dhcp\n\nallow-hotplug wlan0\nauto wlan0\niface wlan0 inet dhcp\n\twpa-ssid "'$wifiSSID'"\n\twpa-psk "'$wifiPassword'"' > $networkInterfacesConfigLocation
											# echo -e 'auto lo\n\niface lo inet loopback\niface eth0 inet dhcp\n\nallow-hotplug wlan0\nauto wlan0\niface wlan0 inet manual\nwpa-roam /etc/wpa_supplicant/wpa_supplicant.conf\niface default inet dhcp' > $networkInterfacesConfigLocation
											# echo -e '\nnetwork={\n\tssid="'$wifiSSID'"\n\tpsk="'$wifiPassword'"\n}\n' >> $wpaSupplicantLocation
										# #else wep
										# else
											# echo -e 'auto lo\n\niface lo inet loopback\niface eth0 inet dhcp\n\nallow-hotplug wlan0\nauto wlan0\niface wlan0 inet manual\nwpa-roam /etc/wpa_supplicant/wpa_supplicant.conf\niface default inet dhcp' > $networkInterfacesConfigLocation
											# echo -e '\nnetwork={\n\tssid="'$wifiSSID'"\n\tkey_mgmt=NONE\n\twep_tx_keyidx=0\n\twep_key0='$wifiPassword'\n}\n' >> $wpaSupplicantLocation
										# fi
									# fi
								# #else wifi network is open, then go ahead and add network to wpa_supplicant
								# else
									# echo -e 'auto lo\n\niface lo inet loopback\niface eth0 inet dhcp\n\nallow-hotplug wlan0\nauto wlan0\niface wlan0 inet manual\nwpa-roam /etc/wpa_supplicant/wpa_supplicant.conf\niface default inet dhcp' > $networkInterfacesConfigLocation
									# echo -e '\nnetwork={\n\tssid="'$wifiSSID'"\n\tkey_mgmt=NONE\n}\n' >> $wpaSupplicantLocation
								# fi
								
								# ifdown wlan0 > /dev/null 2>&1
								# ifup wlan0 > /dev/null 2>&1
								
								# inetAddress=$(ifconfig wlan0 | grep "inet addr.*")
								# if [ "$inetAddress" != "" ] ; then
									# result=$(echo "You are now connected to $wifiSSID.")
									# display_result "WiFi Network"
								# else
									# result=$(echo "There was an issue trying to connect to $wifiSSID. Please ensure you typed the SSID and password correctly.")
									# display_result "WiFi Network"
								# fi
							# fi
						# fi
					# fi
				# else
					# result=$(echo "You have to be running the script as root in order to connect to a WiFi network. Please try using sudo.")
					# display_result "WiFi Network"
				# fi
			# ;;
		# esac
	# done
# }

function list_wifi() { 
	local line 
	local essid 
	local type 
	while read line; do 
		[[ "$line" =~ ^Cell && -n "$essid" ]] && echo -e "$essid\n$type" 
		[[ "$line" =~ ^ESSID ]] && essid=$(echo "$line" | cut -d\" -f2) 
		[[ "$line" == "Encryption key:off" ]] && type="open" 
		[[ "$line" == "Encryption key:on" ]] && type="wep" 
		[[ "$line" =~ ^IE:.*WPA ]] && type="wpa" 
	done < <(iwlist wlan0 scan | grep -o "Cell .*\|ESSID:\".*\"\|IE: .*WPA\|Encryption key:.*") 
	echo -e "$essid\n$type" 
} 


showNetworkMenuOptions() {
	stayInNetworkMenu=true
	while $stayInNetworkMenu; do
		exec 3>&1
		networkMenuSeleciton=$(whiptail \
			--backtitle "PiAssist" \
			--title "System Information" \
			--clear \
			--cancel-button "Back" \
			--menu "Please select:" $HEIGHT $WIDTH 3 \
			"1" "Display Network Information" \
			"2" "Scan for WiFI Networks" \
			"3" "Connect to WiFi Network" \
			2>&1 1>&3)
		exit_status=$?
		case $exit_status in
			$DIALOG_CANCEL)
			  stayInNetworkMenu=false
			  ;;
			$DIALOG_ESC)
			  stayInNetworkMenu=false
			  ;;
		esac
		case $networkMenuSeleciton in
			0 )
			  stayInNetworkMenu=false
			  ;;
			1 )
				result=$(ifconfig)
				display_result "Network Information"
				;;
			2 )
				ifconfig wlan0 up
				#result=$(iwlist wlan0 scan | grep ESSID | sed 's/ESSID://g;s/"//g;s/^ *//;s/ *$//')
				result=$(iwlist wlan0 scan | grep ESSID | awk -F \" '{print $2}')
				display_result "WiFi Networks"
				;;
			3 )
				
				local line
				local essid
				local type
				while read line; do
					[[ "$line" =~ ^Cell && -n "$essid" ]] #&& echo -e "$essid\n$type"
					[[ "$line" =~ ^ESSID ]] && essid=$(echo "$line" | cut -d\" -f2)
					[[ "$line" == "Encryption key:off" ]] && type="open"
					[[ "$line" == "Encryption key:on" ]] && type="wep"
					[[ "$line" =~ ^IE:.*WPA ]] && type="wpa"
				done < <(iwlist wlan0 scan | grep -o "Cell .*\|ESSID:\".*\"\|IE: .*WPA\|Encryption key:.*")
				
				local essids=() 
				local types=() 
				local options=()
				i=0 
				while read essid; read type; do 
					essids+=("$essid") 
					types+=("$type") 
					options+=("$i" "$essid") 
					((i++)) 
				done < <(list_wifi)
				options+=("H" "Hidden ESSID")
				
				local cmd=(whiptail --backtitle "PiAssist" --menu "Please choose the network you would like to connect to" 22 76 16) 
				choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty) 
				[[ -z "$choice" ]] && return 

				local hidden=0 
				if [[ "$choice" == "H" ]]; then 
					cmd=(whiptail --backtitle "PiAssist" --inputbox "Please enter the ESSID" 10 60) 
					essid=$("${cmd[@]}" 2>&1 >/dev/tty) 
					[[ -z "$essid" ]] && return 
					cmd=(whiptail --backtitle "PiAssist" --nocancel --menu "Please choose the WiFi type" 12 40 6) 
					options=( 
						wpa "WPA/WPA2" 
						wep "WEP" 
						open "Open" 
					) 
					type=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty) 
					hidden=1 
				else 
					essid=${essids[choice]} 
					type=${types[choice]} 
				fi

				if [[ "$type" == "wpa" || "$type" == "wep" ]]; then 
					local key="" 
					cmd=(whiptail --backtitle "PiAssist" --title "WiFi Network Password" --passwordbox "Please enter the WiFi key/password for $essid" 10 63) 
					local key_ok=0 
					while [[ $key_ok -eq 0 ]]; do 
						key=$("${cmd[@]}" 2>&1 >/dev/tty) 
						key_ok=1 
						if [[ ${#key} -lt 8 || ${#key} -gt 63 ]] && [[ "$type" == "wpa" ]]; then
							result=$("Password must be between 8 and 63 characters")
							display_result "Network Information"
							key_ok=0 
						fi 
						if [[ -z "$key" && $type == "wep" ]]; then
							result=$("Password cannot be empty")
							display_result "Network Information"
							key_ok=0 
						fi 
					done 
				fi
				
				local wpa_config 
				wpa_config+="\tssid=\"$essid\"\n" 
				case $type in 
					wpa) 
						wpa_config+="\tpsk=\"$key\"\n" 
						;; 
					wep) 
						wpa_config+="\tkey_mgmt=NONE\n" 
						wpa_config+="\twep_tx_keyidx=0\n" 
						wpa_config+="\twep_key0=$key\n" 
						;; 
					open) 
						wpa_config+="\tkey_mgmt=NONE\n" 
					;; 
				esac 
 
				[[ $hidden -eq 1 ]] &&  wpa_config+="\tscan_ssid=1\n"
				
				#if wifi ssid already exists in the wpa_supplicant.conf alert the user and don't continue
				#this will be replaced by removing that specific configuration in the future
				if grep -q "$essid" "$wpaSupplicantLocation"; then
					result=$(echo "The wifi ssid is already in the wpa_supplicant file. You will have to manually delete it from the /etc/wpa_supplicant/wpa_supplicant.conf file if you want to update the WiFi connection information. This will be automated in the future.")
					display_result "WiFi Network"
				else
					echo -e 'auto lo\n\niface lo inet loopback\niface eth0 inet dhcp\n\nallow-hotplug wlan0\nauto wlan0\niface wlan0 inet manual\nwpa-roam /etc/wpa_supplicant/wpa_supplicant.conf\niface default inet dhcp' > $networkInterfacesConfigLocation
					echo -e '\nnetwork={\n'"$wpa_config"'}\n' >> $wpaSupplicantLocation
					
					ifup wlan0 &>/dev/null 
					local id="" 
					i=0 
					while [[ -z "$id" && $i -lt 20 ]]; do 
						sleep 1 
						id=$(iwgetid -r) 
						((i++)) 
					done
					
					result=$(echo "Unable to connect to network $essid. If you have an ethernet cord currently plugged in, the WiFi will not be utilized until that is unplugged. This could be the reason for not being able to connect to the WiFi network.")
					[[ -z "$id" ]] && display_result "Network Information"
				fi
				;;
		esac
	done
}

#########
#Shows the bluetooth menu options
#########

showBluetoothMenuOptions() {
	stayInBluetoothMenu=true
	while $stayInBluetoothMenu; do
		exec 3>&1
		bluetoothMenuSeleciton=$(whiptail \
			--backtitle "PiAssist" \
			--title "System Information" \
			--clear \
			--cancel-button "Back" \
			--menu "Please select:" $HEIGHT $WIDTH 5 \
			"1" "Install Bluetooth Packages" \
			"2" "Remove Bluetooth Packages" \
			"3" "Connect Bluetooth Device" \
			"4" "Remove Bluetooth Device" \
			"5" "Display Registered & Connected Bluetooth Devices" \
			2>&1 1>&3)
		exit_status=$?
		case $exit_status in
			$DIALOG_CANCEL)
			  stayInBluetoothMenu=false
			  ;;
			$DIALOG_ESC)
			  stayInBluetoothMenu=false
			  ;;
		esac
		case $bluetoothMenuSeleciton in
			0 )
				stayInBluetoothMenu=false
				;;
			1 )
				packageInstalled=false
				bluetoothInstalled=$(dpkg -l bluetooth 2>&1)
				if [ "$bluetoothInstalled" == 'dpkg-query: no packages found matching bluetooth' ] ; then
					packageInstalled=true
				fi
				bluezutilsInstalled=$(dpkg -l bluez-utils 2>&1)
				if [ "$bluezutilsInstalled" == "dpkg-query: no packages found matching bluez-utils" ] ; then
					packageInstalled=true
				fi
				bluemanInstalled=$(dpkg -l blueman 2>&1)
				if [ "$bluemanInstalled" == "dpkg-query: no packages found matching blueman" ] ; then
					packageInstalled=true
				fi
				if [ $packageInstalled == false ] ; then
					result=$(echo "You already have all of the necessary packages installed.")
					display_result "Bluetooth"
				else
					#install packages then ask to reboot
					apt-get -qq update > /dev/null && apt-get -qq install bluetooth blueman bluez-utils >/dev/null & # Run in background, with output redirected
					pid=$! # Get PID of background command
					
					i=1
					sp="/-\|"
					echo -n 'Installing Bluetooth Packages '
					while kill -0 $pid  # Signal 0 just tests whether the process exists
					do
						printf "\r${sp:i%${#sp}:1} Installing Bluetooth Packages ${sp:i++%${#sp}:1}"
						sleep 0.5
					done
					
					if (whiptail --title "Reboot?" --yesno "Missing packages were installed. Your Pi needs to be rebooted. Okay to Reboot?" 0 0) then
						clear
						shutdown -r now
						exit
					fi
				fi
				;;
			2 )
				
				apt-get remove --purge bluetooth blueman bluez-utils					
				apt-get clean
				
				result=$(echo "All bluetooth packages have been removed")
				display_result "Bluetooth"
				;;
			3 )
				echo "Scanning..."
				bluetoothDeviceList=$(hcitool scan --flush | sed -e 1d)
				if [ "$bluetoothDeviceList" == "" ] ; then
					result="No devices were found. Ensure device is on and try again."
					display_result "Connect Bluetooth Device"
				else
					result_file=$(mktemp)
					trap "rm $result_file" EXIT
					readarray devs < <(hcitool scan | tail -n +2 | awk '{print NR; print $0}')
					dialog --clear --menu "Select device" 20 80 15 "${devs[@]}" 2> $result_file
					exit_status=$?
					deviceAcutallySelected=true
					case $exit_status in
						$DIALOG_CANCEL)
						  deviceAcutallySelected=false
						  ;;
						$DIALOG_ESC)
						  deviceAcutallySelected=false
						  ;;
					esac
					if [ $deviceAcutallySelected == true ] ; then
						arrayResult=$(<$result_file)
						#answer={devs[$((arrayResult+1))]}
						answer=${devs[$arrayResult+($arrayResult -1)]}
						
						bluetoothMacAddress=($answer)
						
						exec 5>&1
						step1=$(bluez-simple-agent hci0 "$bluetoothMacAddress" >&5)
						step2=$(bluez-test-device trusted "$bluetoothMacAddress" yes >&5)
						step3=$(bluez-test-input connect "$bluetoothMacAddress" >&5)
						
						step1Successful=true
						if [ "$step1" != "" ] && [ "$step1" != "Creating device filed: org.bluez.Error.AlreadyExists: Already Exists" ]; then
							$step1Successful=false;
						fi
						
						step2Successful=true
						if [ "$step2" != "" ]; then
							$step2Successful=false;
						fi
						
						step3Successful=true
						if [ "$step3" != "" ]; then
							$step3Successful=false;
						fi
						
						if [ $step1Successful ] && [ $step2Successful ] && [ $step3Successful ] ; then
							result="Bluetooth device has been connected"
							display_result "Connect Bluetooth Device"
						else
							result="An error occurred connecting to the bluetooth device."
							display_result "Connect Bluetooth Device"
						fi
					fi
				fi
				;;
			4 )				
				bluetoothDeviceList=$(bluez-test-device list)
				if [ "$bluetoothDeviceList" == "" ] ; then
					result="There are no devices to remove."
					display_result "Remove Bluetooth Device"
				else
					result_file=$(mktemp)
					trap "rm $result_file" EXIT
					readarray devs < <(bluez-test-device list | awk '{print NR; print $0}')
					dialog --clear --menu "Select device" 20 80 15 "${devs[@]}" 2> $result_file
					exit_status=$?
					deviceAcutallySelected=true
					case $exit_status in
						$DIALOG_CANCEL)
						  deviceAcutallySelected=false
						  ;;
						$DIALOG_ESC)
						  deviceAcutallySelected=false
						  ;;
					esac
					if [ $deviceAcutallySelected == true ] ; then
						arrayResult=$(<$result_file)
						#answer={devs[$((arrayResult+1))]}
						answer=${devs[$arrayResult+($arrayResult -1)]}
						bluetoothMacAddress=($answer)
						
						if [ "$bluetoothMacAddress" != "" ] ; then
							removeBluetoothDevice=$(bluez-test-device remove $bluetoothMacAddress)
							if [ "$removeBluetoothDevice" == "" ] ; then
								result="Device Removed"
								display_result "Removing Bluetooth Device"
							else
								result="An error occured removing the bluetooth device. Please ensure you typed the mac address correctly."
								display_result "Removing Bluetooth Device"
							fi
						fi
					fi
				fi
				;;
			5 )
				registeredDevices="There are no registered devices"
				if [ "$(bluez-test-device list)" != "" ] ; then
					registeredDevices=$(bluez-test-device list)
				fi
				activeConnections="There are no active connections"
				if [ "$(hcitool con)" != "Connections:" ] ; then
					activeConnections=$(hcitool con | sed -e 1d)
				fi
									
				result=$(echo ""; echo "Registered Devices:"; echo ""; echo "$registeredDevices"; echo ""; echo ""; echo "Active Connections:"; echo ""; echo "$activeConnections")
				display_result "Registered Devices & Active Connections"
				;;
		esac
	done
}

#########
#Shows the controller options menu
#########

showControllerMenuOptions() {
	stayInControllerMenu=true
	while $stayInControllerMenu; do
		exec 3>&1
		controllerMenuSeleciton=$(whiptail \
			--backtitle "PiAssist" \
			--title "Controller" \
			--clear \
			--cancel-button "Back" \
			--menu "Please select:" $HEIGHT $WIDTH 3 \
			"1" "Configure Game Controller for RetroArch Emulators" \
			"2" "Setup PS3 Controller over Bluetooth - Work in Progress" \
			2>&1 1>&3)
		exit_status=$?
		case $exit_status in
			$DIALOG_CANCEL)
			  stayInControllerMenu=false
			  ;;
			$DIALOG_ESC)
			  stayInControllerMenu=false
			  ;;
		esac
		case $controllerMenuSeleciton in
			0 )
			  stayInControllerMenu=false
			  ;;
			1 )
				
				joyconfigLocation="/opt/retropie/configs/all/retroarch.cfg"
				if (whiptail --title "Create Backup?" --yesno "Would you like to create a backup of your current retroarch config?" 0 0) then
					if [ ! -f $joyconfigLocation"_bak" ] ; then
						cp $joyconfigLocation $joyconfigLocation"_bak"
					else
						if (whiptail --title "Overwrite Backup?" --yesno "A backup currently exists. Do you want to overwrite it?" 0 0) then
							cp $joyconfigLocation $joyconfigLocation"_bak"
						fi
						/opt/retropie/emulators/retroarch/retroarch-joyconfig -o $joyconfigLocation
					fi		
				else
					/opt/retropie/emulators/retroarch/retroarch-joyconfig -o $joyconfigLocation
				fi
				;;
			2 )
				
				if [ command -v >/dev/null 2>&1 || ] ; then
					wget http://www.pabr.org/sixlinux/sixpair.c
					gcc -o sixpair sixpair.c -lusb
					
					wget http://sourceforge.net/projects/qtsixa/files/QtSixA%201.5.1/QtSixA-1.5.1-src.tar.gz
					tar xfvz QtSixA-1.5.1-src.tar.gz
					cd QtSixA-1.5.1/sixad
					make
					mkdir -p /var/lib/sixad/profiles
					checkinstall
					
					update-rc.d sixad defaults
					
					echo "enable_leds 1" >> /var/lib/sixad/profiles/default
					echo "enable_joystick 1" >> /var/lib/sixad/profiles/default
					echo "enable_input 0" >> /var/lib/sixad/profiles/default
					echo "enable_remote 0" >> /var/lib/sixad/profiles/default
					echo "enable_rumble 1" >> /var/lib/sixad/profiles/default
					echo "enable_timeout 0" >> /var/lib/sixad/profiles/default
					echo "led_n_auto 1" >> /var/lib/sixad/profiles/default
					echo "led_n_number 1" >> /var/lib/sixad/profiles/default
					echo "led_anim 1" >> /var/lib/sixad/profiles/default
					echo "enable_buttons 1" >> /var/lib/sixad/profiles/default
					echo "enable_sbuttons 1" >> /var/lib/sixad/profiles/default
					echo "enable_axis 1" >> /var/lib/sixad/profiles/default
					echo "enable_accel 0" >> /var/lib/sixad/profiles/default
					echo "enable_accon 0" >> /var/lib/sixad/profiles/default
					echo "enable_speed 0" >> /var/lib/sixad/profiles/default
					echo "enable_pos 0" >> /var/lib/sixad/profiles/default
					
					if (whiptail --title "Reboot?" --yesno "Missing prerequisites were installed. Your Pi needs to be rebooted. Okay to Reboot?" 0 0) then
						shutdown -r now
					fi
				fi
				
				result=$(echo "Please plugin the PS3 controller you would like to pair via USB.")
				display_result "PS3 Controller"
				
				./sixpair

				if [ status sixad ] ; then
					service sixad start
				fi
				;;
		esac
	done
}

#########
#Shows the menu that will display various system information
#########

showSystemInfoOptions() {
	stayInSystemInfoMenu=true
	while $stayInSystemInfoMenu; do
		exec 3>&1
		systemInfoMenuSeleciton=$(whiptail \
			--backtitle "PiAssist" \
			--title "System Information" \
			--clear \
			--cancel-button "Back" \
			--menu "Please select:" $HEIGHT $WIDTH 3 \
			"1" "Display System Information" \
			"2" "Display Disk Space" \
			"3" "Display Home Space Utilization" \
			2>&1 1>&3)
		exit_status=$?
		case $exit_status in
			$DIALOG_CANCEL)
			  stayInSystemInfoMenu=false
			  ;;
			$DIALOG_ESC)
			  stayInSystemInfoMenu=false
			  ;;
		esac
		case $systemInfoMenuSeleciton in
			0 )
			  stayInSystemInfoMenu=false
			  ;;
			1 )
				result=$(echo "Hostname:  $HOSTNAME\n"; echo "Uptime:"; uptime | sed 's/,.*//'; echo "\nLoad Average: "; uptime | grep -o "load.*" | cut -c 15-; echo "\nTemperature: "; vcgencmd measure_temp | cut -c 6-)
				display_result "System Information"
				;;
			2 )
			  result=$(df -h)
			  display_result "Disk Space"
			  ;;
			3 )
			  if [[ $(id -u) -eq 0 ]]; then
				result=$(du -sh /home/* 2> /dev/null)
				display_result "Home Space Utilization (All Users)"
			  else
				result=$(du -sh $HOME 2> /dev/null)
				display_result "Home Space Utilization ($USER)"
			  fi
			  ;;
		esac
	done
}

#########
#Updates and adds the individual menu entries within the emulation station PiAssist section
#########

addAndUpdateEmulationStationEntries() {
	#Download Theme from GitHub and place it in the emulation station themes directory (/etc/emulationstation/themes/simple)
	piassitThemeLocation="/etc/emulationstation/themes/simple/piassist/"
	mkdir "$piassitThemeLocation" > /dev/null 2>&1
	mkdir "$piassitThemeLocation"art/ > /dev/null 2>&1
	wget https://raw.githubusercontent.com/Death259/PiAssist/master/Emulation%20Station%20Theme/piassist/theme.xml -q -O "$piassitThemeLocation"/theme.xml
	wget https://raw.githubusercontent.com/Death259/PiAssist/master/Emulation%20Station%20Theme/piassist/art/piassist.png -q -O "$piassitThemeLocation"/art/piassist.png
	wget https://raw.githubusercontent.com/Death259/PiAssist/master/Emulation%20Station%20Theme/piassist/art/piassist_pixelated.png -q -O "$piassitThemeLocation"/art/piassist_pixelated.png

	mkdir /home/pi/PiAssist/ > /dev/null 2>&1
	find /home/pi/PiAssist/ -name "*.sh" -delete
	touch "/home/pi/PiAssist/Launch PiAssist.sh"
	touch "/home/pi/PiAssist/Update PiAssist.sh"
	touch "/home/pi/PiAssist/Backup Save Files to Dropbox.sh"
	touch "/home/pi/PiAssist/Restore Save Files from Backup.sh"
	touch "/home/pi/PiAssist/Change Splash Screen.sh"

	chown -R pi:pi /home/pi/PiAssist/
}

#########
#Adds separate menu and menu options within emulation station
#########

addPiAssistToEmulationStation() {
	
	if grep -q piassist "$emulationStationConfig"; then
		result="PiAssist has already been added to Emulation Station"
		display_result "Add PiAssist to Emulation Station"
	else
		piassistConfigLocation="/home/pi/piassist_es.cfg"
		cat > "$piassistConfigLocation" << EOF
  </system>
  <system>
    <name>piassist</name>
    <fullname>PiAssist</fullname>
    <path>~/PiAssist/</path>
    <extension>.sh</extension>
    <command>sudo /home/pi/PiAssist.sh %ROM%</command>
    <platform/>
    <theme>piassist</theme>
EOF
		sed -i "/<theme>pcengine<\/theme>/r $piassistConfigLocation" "$emulationStationConfig"
		rm "$piassistConfigLocation"
		
		addAndUpdateEmulationStationEntries

		result=$(echo "PiAssist has been added to the Emulation Station menu")
		display_result "Add PiAssist to Emulation Station"				
	fi
}

#########
#Show power menu options
#########

showPowerMenuOptions() {
	stayInPowerOptionsMenu=true
	while $stayInPowerOptionsMenu; do
		exec 3>&1
		powerOptionsMenuSeleciton=$(whiptail \
			--backtitle "PiAssist" \
			--title "Power Menu" \
			--clear \
			--cancel-button "Back" \
			--menu "Please select:" $HEIGHT $WIDTH 2 \
			"1" "Shutdown" \
			"2" "Reboot" \
			2>&1 1>&3)
		exit_status=$?
		case $exit_status in
			$DIALOG_CANCEL)
			  stayInPowerOptionsMenu=false
			  ;;
			$DIALOG_ESC)
			  stayInPowerOptionsMenu=false
			  ;;
		esac
		case $powerOptionsMenuSeleciton in
			0 )
			  stayInPowerOptionsMenu=false
			  ;;
			1 )
				shutdown -h now
				exit
				;;
			2 )
				shutdown -r now
				exit
				;;
		esac
	done
}

#########
#Update PiAssist from GitHub
##Download the latest version of the script
##Create update script and run it
##Have the update script also update the Emulation Station menu entries
#########

updatePiAssist() {
	echo "Updating PiAssist..."
	homeDirectory="/home/pi"
	if ! wget -q https://raw.githubusercontent.com/Death259/PiAssist/master/PiAssist.sh -O "$homeDirectory/PiAssist.sh.new" ; then
		result="An error occurred downloading the update."
		display_result "Update PiAssist"
	else
		chmod +x "$homeDirectory/PiAssist.sh.new"
		cat > "$homeDirectory/updateScript.sh" << EOF
#!/bin/bash
if mv "PiAssist.sh.new" "PiAssist.sh"; then
  rm -- \$0
  chown -R pi:pi PiAssist.sh
  ./PiAssist.sh "Update Emulation Station Entries"
  whiptail --title "Update Completed" --msgbox "Update Completed. You need to restart the script." 0 0
  clear
else
  whiptail --title "Update Failed!" --msgbox "There was an issue updating the script" 0 0
  clear
fi
EOF
		exec /bin/bash "$homeDirectory/updateScript.sh"
		exit
	fi
}

#########
#Backup game saves and save states to dropbox
##Take all save files and save states and tar them and gzip them up
##Upload zip file to dropbox
#########

gameSavesFileName="GameSaves.tar.gz"
backupEmulatorSaveFilesToDropBox() {
	wget https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh -q -O /home/pi/PiAssist/dropbox_uploader.bsh
	chmod +x /home/pi/PiAssist/dropbox_uploader.bsh

	if [[ -e /home/pi/.dropbox_uploader ]]; then
		/home/pi/PiAssist/dropbox_uploader.bsh
	fi

	#find /home/pi/RetroPie/roms/ -iname '*.srm' -o -iname '*.bsv' -o -iname '*.sav' | while read line; do
	#	remotePath="$(basename "$(dirname "$line")")"/"${line##*/}"
	#	/home/pi/PiAssist/dropbox_uploader.bsh upload "$line" "$remotePath"
	#done
	
	romLocations=$(grep "<path>" /etc/emulationstation/es_systems.cfg | sed "s/<path>//g" | sed "s/<\/path>//g" | sed "s/~/\/home\/pi/g")
	
	find $romLocations \( -iname '*.srm' -o -iname '*.bsv' -o -iname '*.sav' -o -iname '*.state' \) -print0 | tar -czvf "$gameSavesFileName" --null -T -
	#find /home/pi/RetroPie/roms/ \( -iname '*.srm' -o -iname '*.bsv' -o -iname '*.sav' -o -iname '*.state' \) -print0 | tar -czvf "$gameSavesFileName" --null -T -
	/home/pi/PiAssist/dropbox_uploader.bsh upload "$gameSavesFileName" "$gameSavesFileName"
	rm "$gameSavesFileName"

	result="All known saved files have been backed up."
	display_result "Saved Files Backed Up"
}

#########
#Restore save files and save states from a dropbox backup
#########

restoreFromBackupOfEmulatorSaveFilesFromDropBox() {
	wget https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh -q -O /home/pi/PiAssist/dropbox_uploader.bsh
	chmod +x /home/pi/PiAssist/dropbox_uploader.bsh

	if [[ -e /home/pi/.dropbox_uploader ]]; then
		/home/pi/PiAssist/dropbox_uploader.bsh
	fi
	
	/home/pi/PiAssist/dropbox_uploader.bsh download /"$gameSavesFileName"
	if [[ -e "$gameSavesFileName" ]]; then
		tar -zxvf "$gameSavesFileName" -C / #--strip-components=2 -C /home/pi/
		rm "$gameSavesFileName"
		
		result="All save files have been restored from backup."
		display_result "Restoring Save Files"
	else
		result="Unable to locate the save file backup. Please ensure that the backup name matches $gameSavesFileName."
		display_result "Restoring Save Files"
	fi
}

#########
#Shows the menu that allows users to change the splash screen
#########

showChangeSplashScreenMenu() {
	splashscreenDirectory='/home/pi/RetroPie-Setup/supplementary/splashscreens/'

	stayInPowerOptionsMenu=true
	while $stayInPowerOptionsMenu; do
		exec 3>&1
		systemInfoMenuSeleciton=$(whiptail \
			--backtitle "PiAssist" \
			--title "Power Menu" \
			--clear \
			--cancel-button "Back" \
			--menu "Please select:" $HEIGHT $WIDTH 2 \
			"1" "Set Individual Splash Screen" \
			"2" "Use Splash Screen Randomizer (Thanks sur0x)" \
			2>&1 1>&3)
		exit_status=$?
		case $exit_status in
			$DIALOG_CANCEL)
			  stayInPowerOptionsMenu=false
			  ;;
			$DIALOG_ESC)
			  stayInPowerOptionsMenu=false
			  ;;
		esac
		case $systemInfoMenuSeleciton in
			0 )
			  stayInPowerOptionsMenu=false
			  ;;
			1 )				
				if [ -e /etc/init.d/splashscreen.sh ]; then
					rm /etc/init.d/splashscreen.sh
					update-rc.d splashscreen.sh remove
				fi
				
				if [[ -d "/opt/retropie/supplementary/splashscreen" ]] ; then
					splashscreenDirectory="/opt/retropie/supplementary/splashscreen"
				fi
				
				splashscreenList=$(find $splashscreenDirectory \( -iname '*.png' -o -iname '*.jpg' \) | awk '{print $0; print $0;}')					
				splashScreenChosen=$(whiptail --notags --backtitle "PiAssist" --menu "Select Splash Screen" 20 0 10 $splashscreenList 3>&1 1>&2 2>&3)
				exit_status=$?
				splashScreenAcutallySelected=true
				case $exit_status in
					$DIALOG_CANCEL)
					  splashScreenAcutallySelected=false
					  ;;
					$DIALOG_ESC)
					  splashScreenAcutallySelected=false
					  ;;
				esac
				if [ $splashScreenAcutallySelected == true ] ; then					
					echo "$splashScreenChosen" > "/etc/splashscreen.list"
					
					result="The splashscreen has been changed to $splashScreenChosen."
					display_result "SplashScreen Changed"
				fi
				;;
			2 )
			cat > /etc/init.d/splashscreen.sh << \EOF
### BEGIN INIT INFO 	
# Provides:          splashscreen 
# Required-Start:     
# Required-Stop:      
# Default-Start:     2 3 4 5 
# Default-Stop:      0 1 6 
# Short-Description: splashscreen randomizer  
### END INIT INFO 
#/bin/bash 
find /home/pi/RetroPie-Setup/supplementary/splashscreens/ \( -iname '*.png' -o -iname '*.jpg' \)  > /home/pi/PiAssist/splashscreens.list
shuf -n 1 /home/pi/PiAssist/splashscreens.list > /etc/splashscreen.list
rm /home/pi/PiAssist/splashscreens.list
EOF
				if [[ -d "/opt/retropie/supplementary/splashscreen" ]] ; then
					sed 's/\/home\/pi\/RetroPie-Setup/\/opt\/retropie/g' /etc/init.d/splashscreen.sh > /etc/init.d/splashscreen.sh
				fi
				
				chmod +x /etc/init.d/splashscreen.sh
				update-rc.d splashscreen.sh defaults 
				if (whiptail --title "Reboot?" --yesno "Splash Screen Randomizer has been Setup. Your Pi needs to be rebooted. Okay to Reboot?" 0 0) then
					clear
					shutdown -r now
					exit
				fi
				;;
		esac
	done
}

function get_rom_information_from_es_systems_config() {
	local line 
	local system_name 
	local path 
	while read line; do 
		[[ "$line" =~ ^\<system\> && -n "$system_name" ]] && echo -e "$system_name\n$path" 
		[[ "$line" =~ ^\<name\> ]] && system_name=$(echo "$line" | cut -d\> -f2 | cut -d\< -f1) 
		[[ "$line" =~ ^\<path\> ]] && path=$(echo "$line" | cut -d\> -f2 | cut -d\< -f1) 
	done < /etc/emulationstation/es_systems.cfg 
	echo -e "$system_name\n$path" 
}

#########
#Show miscellaneous menu options
#########

showMiscellaneousMenuOptions() {
	stayInMiscellaneousOptionsMenu=true
	while $stayInMiscellaneousOptionsMenu; do
		exec 3>&1
		miscellaneousMenuSeleciton=$(whiptail \
			--backtitle "PiAssist" \
			--title "Miscellaneous" \
			--clear \
			--cancel-button "Back" \
			--menu "Please select:" $HEIGHT $WIDTH 3 \
			"1" "Change Keyboard Language/Configuration" \
			"2" "ROM Scraper Created by SSELPH" \
			"3" "Search for File by File Name" \
			"4" "Backup Emulator Save files to DropBox (Thanks andreafabrizi)" \
			"5" "Restore Save files from Backup on DropBox (Thanks andreafabrizi)" \
			"6" "Change Splash Screen" \
			2>&1 1>&3)
		exit_status=$?
		case $exit_status in
			$DIALOG_CANCEL)
			  stayInMiscellaneousOptionsMenu=false
			  ;;
			$DIALOG_ESC)
			  stayInMiscellaneousOptionsMenu=false
			  ;;
		esac
		case $miscellaneousMenuSeleciton in
			0 )
				stayInMiscellaneousOptionsMenu=false
				;;
			1 )
				dpkg-reconfigure keyboard-configuration
				;;					
			2 )
				
				# Check if emulationstation is running
				if pgrep -f "emulationstation" > /dev/null
				then
					result="Emulation Station cannot be running while scraping roms. Please quit Emulation station and run PiAssist from command line."
					display_result "Rom Scraper"
				else
					scraperVersion=$(wget -qO- https://api.github.com/repos/sselph/scraper/releases/latest | grep tag_name | sed -e 's/.*"tag_name": "\(.*\)".*/\1/')
					#if scraper doesn't exist then download it
					updateScraper=false
					if [ -f /usr/local/bin/scraper ] ; then
						oldVersion=$(scraper -version 2> /dev/null)
						if [ $? -ne 0 ] || [ "$scraperVersion" != "$oldVersion" ] ; then
							if (whiptail --title "Update Scraper?" --yesno "Would you like to update the scraper script?" 0 0) then
								updateScraper=true
							fi
						fi
					fi
					if [ ! -f /usr/local/bin/scraper ] || [ $updateScraper == true ] ; then
						echo "Downloading and Installing Scraper created by SSELPH..."
						#if raspberrypi1 then download the build for raspberrypi1
						if grep -q ARMv7 /proc/cpuinfo ; then
							wget https://github.com/sselph/scraper/releases/download/$scraperVersion/scraper_rpi2.zip -q
							unzip scraper_rpi2.zip scraper -d /usr/local/bin/
							rm scraper_rpi2.zip
						else
							wget https://github.com/sselph/scraper/releases/download/$scraperVersion/scraper_rpi.zip -q
							unzip scraper_rpi.zip scraper -d /usr/local/bin/
							rm scraper_rpi.zip
						fi
					fi
					
					local system_names=() 
					local system_name 
					local paths=() 
					local path
					local options=()
					i=0
					while read system_name; read path; do 
						system_names+=("$system_name") 
						paths+=("$path") 
						options+=("$i" "$system_name" OFF)
						((i++))
					done < <(get_rom_information_from_es_systems_config)
					
					if [[ ${#system_names[@]} -eq 0 ]] ; then
						result="No rom folders were found. Not quite sure how that's possible..."
						display_result "ROM Scraper"
					else
						local cmd=(whiptail --backtitle "PiAssist" --checklist "Select ROM Folders" 22 76 16) 
						choices+=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty) 
						[[ -z "$choices" ]] && return
						
						for choice in $choices
						do
							choice=$(echo $choice | sed 's/"//g')
							gamelist_folder_name=$(echo ${system_names[$choice]})
							romFolder=$(echo ${paths[$choice]} | sed 's/~/\/home\/pi/g')
							gameListXMLLocation="/home/pi/.emulationstation/gamelists/$gamelist_folder_name/gamelist.xml"
							#if mame, then we need to use the mame 
							if [[ $romFolder == *"mame"* ]]; then
								scraper -mame -mame_img "t,m,s" -image_dir="/home/pi/.emulationstation/downloaded_images/$gamelist_folder_name" -image_path="~/.emulationstation/downloaded_images/$gamelist_folder_name" -output_file="$gameListXMLLocation" -rom_dir="$romFolder"
							else
								scraper -image_dir="/home/pi/.emulationstation/downloaded_images/$gamelist_folder_name" -image_path="/home/pi/.emulationstation/downloaded_images/$gamelist_folder_name" -output_file="$gameListXMLLocation" -rom_dir="$romFolder"
							fi
							chown pi:pi "/home/pi/.emulationstation/downloaded_images/$gamelist_folder_name"
							#the scraper doesn't include the opening XML tag that is required
							if grep -q "<?xml" "$gameListXMLLocation" ; then
								#no action needs to occur
								echo "" > /dev/null
							else
								echo '<?xml version="1.0"?>' | cat - "$gameListXMLLocation" > temp && mv temp "$gameListXMLLocation"
							fi
							
							chown pi:pi "$gameListXMLLocation"
							
							find "/home/pi/.emulationstation/downloaded_images/$gamelist_folder_name" -exec chown pi:pi {} +
							
							if [[ -e temp ]]; then
								rm temp
							fi
						done
						
						result="ROMS have been scraped. You can  now get back into Emulation Station."
						display_result "ROM Scraper Created by SSELPH"
					fi
				fi
				;;
				3 )
					fileNameToSearchFor=$(whiptail --title "Search for File by File Name" --backtitle "PiAssist" --inputbox "Enter the file name you would like to search for:" 0 0 2>&1 1>&3);
					searchOptions=$(whiptail --backtitle "PiAssist" --title "Search Options" --checklist \
					"Choose search options:" 0 0 2 \
					"1" "Match Case" OFF \
					"2" "Match Whole Words Only" OFF \
					3>&1 1>&2 2>&3)
					
					findCommand="find /"
					
					if [[ $searchOptions == *"1"* ]] ; then
						findCommand="$findCommand -name "
					else
						findCommand="$findCommand -iname"
					fi
											
					if [[ $searchOptions == *"2"* ]] ; then
						findCommand="$findCommand '$fileNameToSearchFor'"
					else
						findCommand="$findCommand '*$fileNameToSearchFor*'"
					fi
					
					result=$(eval "$findCommand")						
					display_result "Search Results"
				;;
				4 )
					backupEmulatorSaveFilesToDropBox
				;;
				5 )
					restoreFromBackupOfEmulatorSaveFilesFromDropBox
				;;
				6 )
					showChangeSplashScreenMenu
				;;
		esac
	done
}


#########
#Perform actions based on parameters provided to the script. This should generally be from Emulation Station as the %ROM% gets passed in as a parameter.
#########

commandToRun="${1##*/}"
commandToRun="${commandToRun%.*}"
case "$commandToRun" in
	"Update PiAssist" )
		updatePiAssist
	;;
	"Backup Save Files to Dropbox" )
		backupEmulatorSaveFilesToDropBox;
		exit
	;;
	"Update Emulation Station Entries" )
		addAndUpdateEmulationStationEntries;
		exit
	;;
	"Restore Save Files from Backup" )
		restoreFromBackupOfEmulatorSaveFilesFromDropBox;
		exit
	;;
	"Change Splash Screen" )
		showChangeSplashScreenMenu;
		exit
	;;
esac

#########
#Perform dialog functions to present users the GUI
#########

currentUser=$(whoami)
if [ "$currentUser" == "root" ] ; then
	while true; do
	  exec 3>&1
	  maineMenuSelection=$(whiptail \
		--backtitle "PiAssist" \
		--clear \
		--title "Main Menu" \
		--cancel-button "Exit" \
		--menu "Please select:" $HEIGHT $WIDTH 8 \
		"1" "Network (WiFi/Ethernet)" \
		"2" "Bluetooth" \
		"3" "Controller (Retropie Only Currently)" \
		"4" "System Info" \
		"5" "Add PiAssist to Emulation Station" \
		"6" "Power Menu" \
		"7" "Update PiAssist" \
		"8" "Miscellaneous" \
		2>&1 1>&3)
	  exit_status=$?
	  exec 3>&-
	  case $exit_status in
		$DIALOG_CANCEL)
		  clear
		  #echo "Program terminated."
		  exit
		  ;;
		$DIALOG_ESC)
		  clear
		  #echo "Program aborted." >&2
		  exit 1
		  ;;
	  esac
	  case $maineMenuSelection in
		0 )
			clear
			;;
		1 )
			showNetworkMenuOptions
			;;
		2 )
			showBluetoothMenuOptions
			;;
		3 )
			showControllerMenuOptions
			;;
		4 )
			showSystemInfoOptions
			;;
		5 )
			addPiAssistToEmulationStation
			;;
		6 )
			showPowerMenuOptions
			;;
		7 )
			updatePiAssist
			;;
		8 )
			showMiscellaneousMenuOptions
			;;
		esac
	done
else
		result=$(echo "PiAssist has to be running as root. Please try using sudo.")
		display_result "PiAssist"
fi
