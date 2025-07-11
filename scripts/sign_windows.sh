#!/bin/bash

# Get the version from pubspec.yaml
version=$(grep 'version:' ../pubspec.yaml | sed -n 's/version: \([0-9]\+\.[0-9]\+\.[0-9]\+.*\)/\1/p')

if [ -z "$version" ]; then
   echo "Version not found in pubspec.yaml."
   exit 1
fi

input_file='../dist/client_side.exe'
private_key_file='../dsa_priv.pem'
# Get the DSA signature
dsaSignature=$(openssl dgst -sha1 -binary "$input_file" | openssl dgst -sha1 -sign "$private_key_file" | openssl enc -base64)

if [ -z "$dsaSignature" ]; then
   echo "DSA signature not found."
   exit 1
fi

# Define the XML file to update
xmlFile="../dist/appcast.xml"

# if the file exists, remove it
if [ -f "$xmlFile" ]; then
   rm "$xmlFile"
fi

   cat <<EOL > "$xmlFile"
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle">
    <channel>
        <title>app</title>
        <description>Most recent updates to app</description>
        <language>en</language>
        <item>
            <title>Version $version</title>
            <pubDate>$(date -R)</pubDate>
            <enclosure url="https://localhost:7280/download/client_side.exe"
                       sparkle:dsaSignature="$dsaSignature"
                       sparkle:version="$version"
                       sparkle:os="windows"
                       length="0"
                       type="application/octet-stream"
                       sparkle:installerArguments="/SILENT /SP- /RUNAFTER"/>
            <sparkle:criticalUpdate></sparkle:criticalUpdate>
        </item>
    </channel>
</rss>
EOL
    echo "Created XML file: $xmlFile"