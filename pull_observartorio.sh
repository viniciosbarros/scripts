#!/bin/bash


SAIDA="output.txt"
PAGEE="http://g1.globo.com/ciencia-e-saude/blog/observatorio/1.html"

DATE=`date +"%s"`
mkdir /tmp/tmp_obs_$DATE
home_html="observatorio.html"


pushd /tmp/tmp_obs_$DATE
	
	wget -O file.html $PAGEE &> /dev/null
	POST_LINK=$(grep "h2" file.html | sed 's/\\<a/\n/g' | sed 's/\"/\n/g' | head -n2 | tail -n1)
	POST_PAGE=$(echo $POST_LINK | sed 's/\// /g' | awk '{ print $NF }')
	
	wget $POST_LINK &> /dev/null

	IMG_LINK=`grep -i 'jpg\|png\|gif' $POST_PAGE | grep img | sed 's/src=\"/\n/g' | sed 's/\"/\n/g' | grep http | tail -1`
	
	# echo $IMG_LINK
	
	wget $IMG_LINK -O image.file &> /dev/null

	eog image.file &

	html2text $POST_PAGE > $SAIDA


	CONT=$(cat $SAIDA | wc -l)
	#echo $CONT
	UPP=1
	flag=0

	while [[ $UPP -lt $CONT ]]; do

		# echo $UPP
		sed -n "$UPP"p $SAIDA | grep "__veja_todos_os_posts" &> /dev/null
		if [[ $? -eq 0 ]]; then
			flag=1
			#echo "flag up"
		fi

		if [[ $flag -eq 1 ]]; then
			sed -n "$UPP"p $SAIDA
			# sed -n "$UPP"p $SAIDA | text2wave | aplay
		fi
		
		sed -n "$UPP"p $SAIDA | grep "FECHAR"	&> /dev/null
		if [[ $? -eq 0 ]]; then
			flag=0
			#echo "flag down"
		fi

		UPP=$(( $UPP + 1 ))

	done

popd




