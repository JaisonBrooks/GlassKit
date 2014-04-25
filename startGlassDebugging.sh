#!/bin/bash
# This is a program that enables and disables Google Glass ADB Wireless

glass_connected=false
tcp_port="" #Default Port
glass_IP="" #Default IP address
user_check=`uname -s` #Checks User initially
os_type="" #Confirmed OS Type


function enableWifiADB {
	
	function getGlassIP {
		
			function askUser {
				echo "===========================================================";
				if [ os_type == "Darwin"]; then
					adb shell netcfg
				else
					adb shell netcfg
				fi
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
				glass_IP=$ipAddress
				echo "-----------------------------------------------------------";
			}
			askUser	
			setupTCPconnection

	} # END of getGlassIP

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
	} # END of enableShellAccess
	
	
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
			startTCPconnection
		else
			getPort portNumber
			echo "";
			echo Using Port > $tcp_port;
			echo "";
			startTCPconnection
		fi

	} # END of setupTCPConnection

	echo "";
	echo "Starting...";
	echo "";
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

} # END of enableWifiADB

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

} # END of disableWifiADB

function exitApp {
	echo "Exiting application...";
	exit

} # END of exitApp

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

} # END of whatDoUwant

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

} # END of restartADB

function checkUSER {
	if (( $user_check == "Darwin" || $user_check == "Linux" ));
	then
		if [ $user_check == "Darwin" ]; then
			os_type="Mac OSX"
		fi

		if [ $user_check == "Linux" ]; then
			os_type="Linux"
		fi
	else
		os_type="Windows/Other"
	fi

}


#User Interface
sleep 1s
checkUSER
echo "|=========================================================|";
echo "|                                                         |";
echo "|          [ GOOGLE GLASS // ADB Wireless tool ]          |";
echo "|                                                         |";
echo "|             { Developed by Jaison Brooks }              |";
echo "|                                                         |";
echo "|=========================================================|";
echo "";
echo "===========================================================";
echo "      Computer OS = $os_type || Connected = $glass_connected";
echo "===========================================================";
echo "";
echo "-------------------> Getting Started <---------------------";
echo "[*] Connect your Glass via USB to current computer";
echo "[*] Enable Debug mode from Glass system menu";
echo "[*] Have your Glass ADB driver installed";
echo "[*] Finally, connect Glass to current Wifi Network";
echo "-----------------------------------------------------------";
echo "";
echo "";
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
echo "[?] What would you like to do?";
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
echo "[1]. Start ADB Wireless";
echo "[2]. Stop ADB Wireless";
echo "[3]. Exit";
echo "-----------------------------------------------------------";
read startingSelection
if [ $startingSelection = 1 ]; then
	enableWifiADB
			
elif [ $startingSelection = 2 ]; then
	disableWifiADB
		
elif [ $startingSelection = 3 ]; then
	exitApp
else
	whatDoUwant
fi
#MainActivity - end
