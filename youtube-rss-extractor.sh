#!/bin/bash

read input
url_file=$1
sed_edit_1="s/^.*channelId\\\" content=\\\"//p" 
sed_edit_2="s/\">.*$//p"
base_rss_url="feeds/videos.xml?channel_id="
base_youtube_url="https://www.youtube.com/"


check_input () {
	#echo "Analyserar URL: $input"
	echo "Analyzing URL: $input"
	if [[ $(echo $input | grep ^$base_youtube_url) ]]
	then
		#echo "Extraherar kanal-ID..."
		echo "Extracting channel-ID..."
                #channel_id=$(wget -O - --quiet https://www.youtube.com/watch?v=zlmuKtyhDKg | sed -n -e 's/^.*data-channel-external-id="//p' | sed -n -e 's/".*$//p')
                channel_id=$(wget --quiet -O - $input | sed -n -e "$sed_edit_1" | head -n1 | sed -n -e "$sed_edit_2")
                #echo "Kanal-ID: $channel_id"
                echo "Channel-ID: $channel_id"
		channel_rss_url="$base_youtube_url$base_rss_url$channel_id"
	
	else
		#echo "Ej godtagbar URL"
		echo "Not and acceptable URL"
		exit 1
	fi

	channel_name=$(wget -O - --quiet  $channel_rss_url | grep title -m 1 | cut -c 9- | rev | cut -c 9- | rev)

	if [[ $channel_name ]]
	then
		#echo "Importerar kanalen \"$channel_name\" med kanal-ID: $channel_id"
		echo "Importing channel \"$channel_name\" with channel-ID: $channel_id"
		check_file
	else
		#echo "Kanalen existerar ej"
		echo "The channel does not exist"
		exit 1
	fi
}

write_rss_url () {
	#echo "Skriver kanalen till filen..."
	echo "Writing channel to file..."
	echo $channel_rss_url \"$channel_name\" >> $url_file
}

check_file () {
	if [[ $(grep $channel_rss_url $url_file) ]]
	then
		if [[ $(grep "$channel_rss_url \"$channel_name\"" $url_file) ]]
		then
			#echo "Kanalen \"$channel_name\" finns redan."
			echo "The channel \"$channel_name\" already exists."
		else
			#echo "Kanalen \"$channel_name\" finns redan men är inte namngiven."
			echo "The channel \"$channel_name\" already exists but is not name tagged."
			line_number=$(grep $channel_rss_url $url_file -n | cut -f1 -d:)
			sed -i "$line_number d" $url_file
			write_rss_url
		fi
	else
		#echo "Kanalen \"$channel_name\" finns ej i filen."
		echo "The channel \"$channel_name\" is not in the file."
		write_rss_url
	fi
}

check_input
exit 0



