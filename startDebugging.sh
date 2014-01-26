#!/bin/bash
# This is a program that enables and disables Google Glass ADB Wireless



function enableWifiADB {
	
	tcp_port="" #Default Port
	glass_IP="" #Default IP address
		
	function getGlassIP {
		
			function askUser {
				echo "===========================================================";
				adb shell netcfg
				echo "";
				echo "===========================================================";
				echo "[?] Enter the IP address of Glass [wlan0 - UP -- xxx.xxx.xx.xxx]"
				echo "-----------------------------------------------------------";
				read ipAddress
				echo "===========================================================";
				echo "[?] Are you sure this is the IP > $ipAddress"
				echo "-----------------------------------------------------------";
				echo "[1]. Yes";
				echo "[2]. No";
				echo "-----------------------------------------------------------";
				read response
			}
			askUser	
			if [ $response = 1 ]; then
				echo Using IP Address > $ipAddress
				glass_IP=$ipAddress
				setupTCPconnection
			elif [ $response = 2 ]; then
				getGlassIP
			else
				getGlassIP
			fi
	}
	
	function setupTCPconnection {
		
		function getPort (){
			
			if [ -z "$1" ]; then
				tcp_port=5555
				echo "Using default TCP port: $tcp_port";
			else
				echo "Configuring connection with custom TCP port: $1";
				tcp_port=$1
			fi
		}
		
		echo "[?] Enter Port number for connection";
		echo "-----------------------------------------------------------";
		echo "Input custom port or use 1 for default (5555)";
		echo "-----------------------------------------------------------";
		read portNumber
		if [ $portNumber = "1" ]; then
			getPort
			echo $tcp_port;
			startTCPconnection
			
		else
			getPort portNumber
			echo "Using Port = $tcp_port";
			startTCPconnection
		fi
	}
	function startTCPconnection {
		echo "Setting up connection...";
		adb tcpip $tcp_port
		adb connect $glass_IP
	}
	function enableShellAccess {
			echo "Do you want to enable ADB SHELL access with Glass";
			echo "-----------------------------------------------------------";
			echo "[1]. Yes";
			echo "[2]. No";
			echo "-----------------------------------------------------------";
				read response
					if [ $reponse = 1 ]; then
						adb shell
					else
						echo "You can more start developing with Glass wirelessly";
					fi		
	}

	echo "";
	echo "Starting...";
	sleep 1s
	echo "===========================================================";
	adb devices
	echo "===========================================================";
	echo "[?] Do you see Glass as an active ADB device? (1 or 2)"
	echo "-----------------------------------------------------------";
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
	echo "Disabling now...";
	sleep 1s
	echo "";
	adb usb
	sleep 1s
	echo "Done...";
	echo "";
	echo "===========================================================";
	echo "Do you want to Exit now?";
	read response
	if [ $response = yes ]; then
		echo "Thanks for using this tool!!!";
		echo "";
		echo "Exiting application...";
		exit
	else
		echo "Restarting application...";
		echo "";
		echo "";
		echo "";
		echo "";
		echo "";
		echo "";
		echo "";
		echo "";
		bash startDebugging.sh
		echo "";
	fi
}
function exitApp {
	echo "Exiting application...";
	exit
}
function whatDoUwant {
	echo "===========================================================";
	echo "Do you want to restart the tool? (Yes / No)";
	read response
	if [ $response = yes ]; then
		echo "Restarting application...";
		bash startDebugging.sh
		echo "";
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
			adb wait-for-device 
			adb devices
			echo "===========================================================";
			echo "Do you see Glass now? (Yes / No)"
			echo "-----------------------------------------------------------";
			echo "[1]. Yes";
			echo "[2]. No";
			echo "-----------------------------------------------------------";
			read response
			if [ $response = 2 ]; then
				echo "Strange, Try the following steps";
				sleep 5s
				echo "Exiting now........bye";
				exit
			else
				enableWifiADB
			fi
	}
function startADBconnection {
			echo $port_number;
			echo $glass_IP;	
}

#MainActivity - start
sleep 1s
echo " _________________________________________________________";
echo "|                                                         |";
echo "|          [ GOOGLE GLASS // ADB Wireless tool ]          |";
sleep 1s
echo "|                                                         |";
echo "|             { Developed by Jaison Brooks }              |";
sleep 1s
echo "|_________________________________________________________|";
echo "";
echo "===========================================================";
echo "[?] Please choose one of the following options.";
echo "-----------------------------------------------------------";
echo "[1]. Enable ADB Wireless";
echo "[2]. Disable ADB Wireless";
echo "[3]. Exit";
echo "-----------------------------------------------------------";
read startingSelection
if [ $startingSelection = 1 ]; then
	#Enable ADB Wireless
	enableWifiADB
			
elif [ $startingSelection = 2 ]; then
	#Disable ADB Wireless
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