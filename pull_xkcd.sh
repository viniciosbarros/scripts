#!/bin/bash
#
#
#	Vinicios barros - vinicios.barros@ieee.org
#
#	This script has the hability to pull the png files from xkcd.com (http://xkcd.com/)
#
#
#	parameters supported:
#
#						(No parameter) 		Just pull the last comic released
#							-n 		Only shows the last comic number
#							-r 		Do the pull for a randon comic
#						  <number>		Do the pull for a specific id number of a comic
#							-1 		Pull the last but one
#							-h 		Show this help menu


function menu(){
echo "
This is a script to pull a xkcd comic file:

To Use:

	No parameter 	Just pull the last comic released
	-n		Only shows the last comic number
	-r		Do the pull for a randon comic
	<number>	Do the pull for a specific id number of a comic
	- <number>	Pull the last minus <number>
	
	-h
	?
	--help		Show this help menu



contact: vinicios.barros@ieee.org"
}

#IMAGE_VIEWER="eog"
IMAGE_VIEWER="feh"

pushd /tmp &> /dev/null

if [ $# -gt 0 ]; then
	if [ $1 == "-n" ]; then
		wget http://xkcd.com/ -O xkcd.html &> /dev/null		|| exit 3
		numero=$(grep "Permanent link" xkcd.html | sed -e  's/[^0-9]//g')
		echo "Last Update number: $numero"
		exit
	elif [ $1 == "-r" ]; then
		wget http://xkcd.com/ -O xkcd.html &> /dev/null		|| exit 3
		numero=$(grep "Permanent link" xkcd.html | sed -e  's/[^0-9]//g')
		rrand=`echo $((RANDOM % $numero))`
		echo "Random: $rrand"
		wget http://xkcd.com/$rrand &> /dev/null || exit 3
		mv $rrand xkcd.html			|| exit 4
		texto_alt=$(grep 'png.*title' xkcd.html | sed -e s'/title=/\n/' | grep alt | sed -e s'/alt=/\n/' | sed -n '1p')
	elif [[ $1 == "-" ]]; then
		wget http://xkcd.com/ -O xkcd.html &> /dev/null		|| exit 3
		numero=$(grep "Permanent link" xkcd.html | sed -e  's/[^0-9]//g')
		anterior=$(echo "$numero - $2" | bc)
		echo "#$anterior"
		wget http://xkcd.com/$anterior -O xkcd.html &> /dev/null || exit 3
		texto_alt=$(grep 'png.*title' xkcd.html | sed -e s'/title=/\n/' | grep alt | sed -e s'/alt=/\n/' | sed -n '1p')
	elif [[ $1 == "-h" || $1 == "--help" ]]; then
		menu
		exit
	elif [ $1 == "?" ]; then
		menu
		exit
	else
		wget http://xkcd.com/$1	&> /dev/null	|| exit 3
		mv $1 xkcd.html			|| exit 4
		texto_alt=$(grep 'png.*title' xkcd.html | sed -e s'/title=/\n/' | grep alt | sed -e s'/alt=/\n/' | sed -n '1p')
	fi
elif [ $# -eq 0 ]; then
	wget http://xkcd.com/ -O xkcd.html &> /dev/null	|| exit 3
	numero=$(grep "Permanent link" xkcd.html | sed -e  's/[^0-9]//g')
	texto_alt=$(grep 'png.*title' xkcd.html  | sed -e s'/title=/\n/' | grep alt | sed -e s'/alt=/\n/' | sed -n '1p')
	echo "#$numero"
fi


echo $texto_alt

file=$(grep -oP "(?<=src=\")[^\"]+(?=\")"  xkcd.html | grep comics) || exit 2
name_file=$(echo $file | sed -e 's/\//\ /g' | awk '{print $NF}')

wget http://imgs.xkcd.com/comics/$name_file &> /dev/null
cp $name_file ~/comics/

if [ -e xkcd* ]; then
	rm xkcd*
fi

xdg-open /tmp/$name_file &

echo "http://imgs.xkcd.com/comics/$name_file"

popd &> /dev/null
