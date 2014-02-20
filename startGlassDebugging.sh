#!/bin/bash
# This is a program that enables and disables Google Glass ADB Wireless

glassConnection=false
tcp_port="" #Default Port
glass_IP="" #Default IP address


function enableWifiADB {
	
	
		
	function getGlassIP {
		
			function askUser {
				echo "===========================================================";
				adb shell netcfg
				echo "";
				echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
				echo "[?] Enter the IP address assigned to Glass";
				echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
				echo "[*] Enter the IP address that shows up under the section";
				echo "[*] { wlan0 - UP --- xxx.xxx.xxx.xxx }";
				echo "[*] If the IP address is 0.0.0.0, Check WIFI connection and retry";
				echo "-----------------------------------------------------------";
				read ipAddress
				echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
				echo "[?] Using the following IP address > $ipAddress"
				echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
			#	echo "[1]. Yes";
			#	echo "[2]. No";
			#	echo "-----------------------------------------------------------";
			#	read response			
			}
			askUser	
			#if [ $response = 1 ]; then
			glass_IP=$ipAddress
			setupTCPconnection
			#elif [ $response = 2 ]; then
			#	getGlassIP
			#else
			#	getGlassIP
			#fi
	}
		function enableShellAccess {
			echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
			echo "[?] Do you want to enable ADB SHELL access with Glass";
			echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
			echo "[1]. Yes";
			echo "[2]. No";
			echo "-----------------------------------------------------------";
				read responseShell
					if [ $responseShell = 1 ]; then
						adb shell
					else
						echo "You can now start developing with Glass wirelessly";
						echo "";
						echo "";
						echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
						echo "[?] What do you want to do next?";
						echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
						echo "[1]. Disable ADB Wireless";
						echo "[2]. Exit";
						echo "-----------------------------------------------------------";
						read response
							if [ $response = 1 ]; then
								disableWifiADB
							else
								exitApp
							fi
					fi
	}
	
	
	function setupTCPconnection {
		
		function getPort (){
			
			if [ -z "$1" ]; then
				tcp_port=5555
				echo "Using default TCP/IP port: $tcp_port";
			else
				echo "Configuring connection with TCP/IP port: $1";
				tcp_port=$1
			fi
		}
		function startTCPconnection {
			echo "";
			echo "Configuring connection for Glass - $glass_IP:$tcp_port";
			echo "";
			adb tcpip $tcp_port
			echo "Connecting to ADB wirelessly";
			echo "";
			adb connect $glass_IP
			echo "Connected...";
			echo "";
			enableShellAccess
		}
		echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
		echo "[?] Enter the TCP/IP Port you want to use";
		echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
		echo "Please input Port Number or enter 1 to use DEFAULT";
		echo "-----------------------------------------------------------";
		read portNumber
		if [ $portNumber = 1 ]; then
			getPort
			echo "";
			#echo Using Port > $tcp_port;
			#echo "";
			#echo $tcp_port;
			startTCPconnection
		else
			getPort portNumber
			echo "";
			echo Using Port > $tcp_port;
			echo "";
			startTCPconnection
		fi
	}

	echo "";
	echo "Starting...";
	sleep 1s
	echo "===========================================================";
	adb devices
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
	echo "[?] Do you see Glass as an active ADB device? (1 or 2)"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
	echo "[1]. Yes";
	echo "[2]. No";
	echo "-----------------------------------------------------------";
	read glassConnected
		if [ $glassConnected = 1 ]; then
			getGlassIP
		elif [ $glassConnected = 2 ]; then
			restartADB
		fi
}
function disableWifiADB {
	echo "";
	echo "Starting...";
	echo "";
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
	echo "[?] Is Glass connected via USB currently?"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
	echo "[1]. Yes";
	echo "[2]. No";
	echo "-----------------------------------------------------------";
	read response
		if [ $response = 1 ]; then
			echo "";
			echo "Please Disconnect USB cable first";
			echo "";
			sleep 1s
			echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
			echo "[?] Have you Disconnected Glass from USB?"
			echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
			echo "[1]. Yes";
			echo "[2]. No";
			echo "-----------------------------------------------------------";
			read responseDisconnected
			if [ $responseDisconnected = 1 ]; then
				echo "Lets make sure we are still connected to Glass Wirelessly";
				adb connect $glass_IP
				echo "Now lets disconnect";
				adb usb
				echo "Resetting ADB to USB mode";
				sleep 2s
			else 
				echo "Lets start over real quick";
				disableWifiADB
			fi
	
		elif [ $response = 2 ]; then
				echo "Lets make sure we are still connected to Glass Wirelessly";
				adb connect $glass_IP
				echo "Now lets disconnect";
				echo "Resetting ADB to USB mode";
				adb usb
				sleep 2s
		fi
	sleep 1s
	echo "Done...";
	sleep 1s
	echo "";
	echo "Now connect Glass again via USB";
	sleep 2s
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
	echo "[?] Is Glass connected via USB?";
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
	echo "[1]. Yes";
	echo "[2]. No";
	echo "-----------------------------------------------------------";
	read connectedOrNot
	if [ $connectedOrNot = 1 ]; then
		echo "You should now see your Glass ADB serial number below";
		adb devices
		echo "If you see Glass listed as an ADB device, then you are now back in USB mode";
	else
		echo "Well you should connect it real quick";
		sleep 1s
		echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
		echo "[?] What do you want to do next?";
		echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
		echo "[1]. Enable ADB Wireless";
		echo "[2]. Exit";
		echo "-----------------------------------------------------------";
		read response
			if [ $response = 1 ]; then
				enableWifiADB
			else
				exitApp
			fi
	fi
	echo "";
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
	echo "[?] Do you want to Exit the application now?";
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
	read responseExit
	if [ $responseExit = yes ]; then
		echo "Thanks for using this tool!!!";
		echo "";
		echo "Exiting application...";
		echo "";
		echo "";
		echo "";
		echo "bye...";
		exit
	else
		echo "Restarting application...";
		echo "";
		echo "";
		echo "";
		echo "";
		bash startGlassDebugging.sh
		echo "";
	fi
}
function exitApp {
	echo "Exiting application...";
	exit
}
function whatDoUwant {
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
	echo "[?] Do you want to restart the tool? (Yes / No)";
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
	echo "[1]. Yes";
	echo "[2]. No";
	echo "-----------------------------------------------------------";
	read response
	if [ $response = 1 ]; then
		echo "Restarting application...";
		echo "";
		bash startGlassDebugging.sh
		echo "";
	else
		echo "Exiting application...";
		exit
	fi		
}
function restartADB {
			echo "Restarting ADB and attempting to reconnect";		
			adb kill-server
			adb start-server
			echo "Waiting for ADB to find Glass";
			#adb wait-for-device - Not using due to cause extended hang up
			adb devices
			echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
			echo "[?] Do you see Glass now? (Yes / No)"
			echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
			echo "[1]. Yes";
			echo "[2]. No";
			echo "-----------------------------------------------------------";
			read response
			if [ $response = 2 ]; then
				echo "Strange....";
				sleep 2s
				echo "Resetting application...";
				bash startGlassDebugging.sh
			else
				enableWifiADB
				echo "Lets try and connect now";
			fi
	}
#function startADBconnection {
#			echo $port_number;
#			echo $glass_IP;
#			VARIABLE="$(adb devices)"
#			if [[ "$VARIABLE" == *"adb"* ]]; then
#			echo "adb command worked";
#			else 
#			echo "Didnt work";
#			sleep 5s
#			fi
#}

#User Interface
sleep 1s
echo " _________________________________________________________";
echo "|                                                         |";
echo "|          [ GOOGLE GLASS // ADB Wireless tool ]          |";
echo "|                                                         |";
sleep 1s
echo "|             { Developed by Jaison Brooks }              |";
sleep 1s
echo "|_________________________________________________________|";
echo "";
echo "===================== Prerequisites =======================";
echo "[*] Connect your Glass via USB";
echo "[*] Enable Debug mode from Glass system menu";
echo "[*] Ensure your Glass ADB driver is installed";
echo "[*] Connect Glass to the same WIFI network as this computer";
echo "===========================================================";
echo "";
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
echo "[?] Start by selecting one of the following options";
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
echo "[1]. Start ADB Wireless";
echo "[2]. Stop ADB Wireless";
echo "[3]. Exit";
echo "-----------------------------------------------------------";
read startingSelection
if [ $startingSelection = 1 ]; then
	#Setup ADB Wireless
	enableWifiADB
			
elif [ $startingSelection = 2 ]; then
	#Start ADB Wireless
	disableWifiADB
		
elif [ $startingSelection = 3 ]; then
	#Just Exit
	exitApp
else
	#Double check what the user wants to do
	whatDoUwant
fi
#MainActivity - end

#read -p "Cleaning Up Source and Restore Previous String Files (y/n)?"
#[ "$REPLY" == "y" ] || adb devices