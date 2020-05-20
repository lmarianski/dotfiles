#!/bin/bash
stringContains() { [ -z "${2##*$1*}" ]; }

URL="https://www.youtube.com/playlist?list=PLMmEMLANe2IsBwvbFPunsUPs2roH_hqv3"
OUTDIR="$HOME/Muzyka"

REGEX=""

files=($OUTDIR/*)
for file in "${files[@]}"; do
	file=${file#$OUTDIR/}
	file=${file%.*}
	file=${file/\(/\\(}
	file=${file//)/\\)}
	file=${file//./\\.}
	file=${file//[/\\[}
	file=${file//]/\\]}

	# if stringContains 'Passenger' "$file"; then
	# 	file=${file//_/\\|}
	# fi

	# if stringContains 'SHADOW OF WHALES' "$file"; then
	# 	file=${file//_/\\|}
	# fi

	# if stringContains 'Most Epic Music Ever' "$file"; then
	# 	file=${file// -/:}
	# 	file=$(echo $file | sed "s/'/\"/g")
	# fi

	if stringContains 'Critical Role - Your Turn To Roll' "$file"; then
		file="Critical Role - Mighty Nein Intro"
	fi

	REGEX="$REGEX$file|"
done
REGEX="(${REGEX%|})"

if [ "$REGEX" == "(*)" ]; then
	REGEX=""
fi

UNRGX="${REGEX%)}\)"
UNRGX="\(${UNRGX#(}"
UNRGX="($UNRGX)"

youtube-dl $* --reject-title "$REGEX" --prefer-ffmpeg --extract-audio --add-metadata --embed-thumbnail --audio-format mp3 -o "$OUTDIR/%(title)s.%(ext)s" --yes-playlist $URL | sed -r "/$UNRGX/c\[download] Title matched reject pattern. Skipping"

files=($OUTDIR/*)
for file in "${files[@]}"; do

	origFile=$file

	if stringContains 'Passenger' "$file"; then
		file=${file//_/\|}
	fi

	if stringContains 'SHADOW OF WHALES' "$file"; then
		file=${file//_/\|}
	fi

	if stringContains 'Critical Role - Mighty Nein Intro' "$file"; then
		file="$OUTDIR/Critical Role - Your Turn To Roll.mp4"
		ffmpeg -i "$origFile" -metadata title="Your Turn To Roll" -metadata artist="Critical Role" -y "$origFile.tmp.mp3"
		mv "$origFile.tmp.mp3" "$origFile"
	fi

	if stringContains 'Most Epic Music Ever' "$file"; then
		file=${file// -/:}
		file=$(echo $file | sed "s/'/\"/g")
	fi
	mv "$origFile" "$file" 2>/dev/null
done

#notify-send "Synced new music!"
