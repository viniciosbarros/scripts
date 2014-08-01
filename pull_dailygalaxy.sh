#!/bin/bash


SAIDA="output.txt"
PAGEE="http://www.dailygalaxy.com/"
IMA_VIEWER="eog"

DATE=`date +"%s"`
mkdir /tmp/tmp_obs_$DATE



pushd /tmp/tmp_obs_$DATE
	
	wget $PAGEE &> /dev/null
	
	POST_LINK=$(grep "h3" index.html | head -n 1 | sed 's/\"/\n/g' | head -n 4 | tail -n 1)
	# POST_PAGE=$(echo $POST_LINK | sed 's/\// /g' | awk '{ print $NF }')


	#echo $POST_LINK
	wget -O file.html $POST_LINK &> /dev/null
	html2text file.html > $SAIDA


	CONT=$(cat $SAIDA | wc -l)
	#echo $CONT
	UPP=1
	flag=0


	while [[ $UPP -lt $CONT ]]; do

		# echo $UPP
		sed -n "$UPP"p $SAIDA | grep "****** The_Daily_Galaxy_--Great_Discoveries_Channel:_Sci,_Space,_Tech ******" &> /dev/null
		if [[ $? -eq 0 ]]; then
			flag=1
		#	echo "flag up"
		fi

		if [[ $flag -eq 1 ]]; then
			sed -n "$UPP"p $SAIDA
			# sed -n "$UPP"p $SAIDA | text2wave | aplay &> /dev/null
		fi
		
		sed -n "$UPP"p $SAIDA | grep "**** Comments ****" &> /dev/null
		if [[ $? -eq 0 ]]; then
			flag=0
		#	echo "flag down"
		fi

		UPP=$(( $UPP + 1 ))

	done


	IMG_LINK=`grep "\.a/" file.html | sed 's/href\=\"/\n/g' | sed 's/\"/\n/g' | grep http `
	IMG_NAME=`echo $IMG_LINK | sed 's/\// /g' | awk '{ print $NF }'`
	
	#echo " LINK-link $IMG_LINK"
	#echo " LINK-img $IMG_NAME"	

	#grep "\.a/" file.html | sed 's/href\=\"/\n/g' | sed 's/\"/\n/g' | grep http | xargs -P 5 -I _URL_ wget -nc _URL_ &> /dev/null
	
	wget -nc $IMG_LINK &> /dev/null

	$IMA_VIEWER $IMG_NAME &

popd




