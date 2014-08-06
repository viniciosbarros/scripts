#!/bin/bash

#		Jul/2013
#	by vinicios 
#	sudo apt-get install xosd
#

message="** TIME OUT **"	#text in the alert
color="red"					#color of text
showDuring="10"				#seconds showing alert message


# test osd_cat 
if [ ! -e /usr/bin/osd_cat  ]; then 
	echo "ERROR: You need osd_cat application to run this script"; 
	echo "Try: sudo apt-get install xosd"
	echo "then try execute this script again"
	exit 1 ;
fi


function waiter(){

	echo "timer in $1 seconds"
	sleep $1
	echo "$message" | osd_cat -p middle -A center -c $color --font=-*-*-*-*-*-*-*-290-*-*-*-*-iso8859-* -O 5 -d $showDuring &
	echo "$message" | osd_cat -p middle -A left -c $color --font=-*-*-*-*-*-*-*-290-*-*-*-*-iso8859-* -O 5 -d $showDuring &
	echo "$message" | osd_cat -p middle -A right -c $color --font=-*-*-*-*-*-*-*-290-*-*-*-*-iso8859-* -O 5 -d $showDuring &
	echo "$message" | osd_cat -p top -A center -c $color --font=-*-*-*-*-*-*-*-290-*-*-*-*-iso8859-* -O 5 -d $showDuring &
	echo "$message" | osd_cat -p top -A left -c $color --font=-*-*-*-*-*-*-*-290-*-*-*-*-iso8859-* -O 5 -d $showDuring &
	echo "$message" | osd_cat -p top -A right -c $color --font=-*-*-*-*-*-*-*-290-*-*-*-*-iso8859-* -O 5 -d $showDuring &
	echo "$message" | osd_cat -p bottom -A center -c $color --font=-*-*-*-*-*-*-*-290-*-*-*-*-iso8859-* -O 5 -d $showDuring &
	echo "$message" | osd_cat -p bottom -A left -c $color --font=-*-*-*-*-*-*-*-290-*-*-*-*-iso8859-* -O 5 -d $showDuring &
	echo "$message" | osd_cat -p bottom -A right -c $color --font=-*-*-*-*-*-*-*-290-*-*-*-*-iso8859-* -O 5 -d $showDuring &
	eject 
	sleep 60
	eject -t

}

function alarmAt(){

	Hnow=$(date +"%H")
	Mnow=$(date +"%M")
	Hlat=$1
	Mlat=$2
	Htimer=$( echo "$Hlat - $Hnow" | bc )
	Mtimer=$( echo "$Mlat - $Mnow" | bc )
	if [[ $Mtimer -lt 0 ]]; then
		Mtimer=$( echo " 60 + $Mtimer " | bc )
		Htimer=$( echo " $Htimer - 1 "  | bc )
	fi
	if [[ $Htimer -lt 0 ]]; then
		Htimer=$( echo " 24 + $Htimer "  | bc )	
	fi
	secondsTotal=$( echo "( $Htimer * 3600 ) + ( $Mtimer * 60 )" | bc )
	echo "timer in $Htimer h $Mtimer m"
	
	waiter $secondsTotal

}

function alarmInMinutes(){

	secondsTotal=$( echo "( $1 * 60 )" | bc )
	waiter $secondsTotal

}

function alarmInHours(){

	secondsTotal=$( echo "( $1 * 3600 )" | bc )
	waiter $secondsTotal
}


############# MAIN ######################

if [ $# -gt 1 ]; then
	if [[ $1 = "at" ]]; then
		if [ $# -eq 3 ]; then
			alarmAt $2 $3
		else
			echo "Error: Param Number error"
		fi
	elif [[ $1 = "-h" ]]; then
		if [ $# -eq 2 ]; then
			alarmInHours $2
		else
			echo "Error: Param Number error"
		fi
	elif [[ $1 = "-m" ]]; then
		if [ $# -eq 2 ]; then
			alarmInMinutes $2
		else
			echo "Error: Param Number error"
		fi
	elif [[ $1 = "-s" ]]; then
		if [ $# -eq 2 ]; then
			waiter $2
		else
			echo "Error: Param Number error"
		fi
	else
		echo " 'Agua Quente' Error: incorrect options "
	fi
else
	echo " "
	echo " Agua Quente Is a bash function to create a countdown in seconds or in minutes"
	echo " 	or even at determined hour "
	echo " Usage: "
	echo "   $ aguaquente [options] <Time> "
	echo " [options]"
	echo " 	 -s SEC 	- To timer in some SEC seconds"
	echo " 	 -m MIN 	- To timer in some MIN minutes"
	echo " 	 at HOU MIN 	- To timer at the HOU MIN specified"
fi
