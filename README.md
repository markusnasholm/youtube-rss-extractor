# youtube-rss-extractor

## Description
Extracts the channel RSS feed from any valid URL on stdin and writes it to a file along with the channel name if it does not already exist.

This script is intended for use with newsboat or similar RSS readers, allowing simple adding of new youtube channels.

## Usage

    $ youtube-rss-extractor URL_FILE <<< URL

or

    $ echo URL | youtube-rss-extractor URL_FILE

## Example

    $ youtube-rss-extractor $HOME/.newsboat/urls <<< https://www.youtube.com/user/PewDiePie 
