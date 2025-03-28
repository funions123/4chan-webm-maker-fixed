4chan-external-sound-webm-maker
================
A handy little script that automates most steps involved in creating external audio webm's for the 4chan imageboard. It automatically respects 4chan's filesize limitation for webm's and calculates optimal settings for maximum quality. A five year old could make webm's with this.

Meant to be used with 4chan External Sounds (https://greasyfork.org/en/scripts/31045-4chan-external-sounds)

Fixed by funions123

Features
--------
- Ultra lightweight portable setup. No messing around with libraries and no install required.
- No bloat, just a scriptfile, no unecessary GUI, no heavyweight libraries to run it, no bloated functionality that nobody ever uses.
- Simple drag and drop action. No messing around with the command line or arguments.
- All dependencies included. No extra stuff to download and mess with.
- Automatic quality settings to attempt to max out file size limitations on 4chan
  - Read: "Tries to make it look as good as possible".
- Easy on-screen prompts to change offset and length of webm rendering. No editing necessary to extract "that one good part".
- Simplified resolution setup. Simply put in the desired vertical resolution ( ie. 720 ) and the script does the rest. Maintains aspect ratio aswell of course.
- Automagically uploads the audio track to catbox.moe and tags the webm with external sound.

Usage
-----
1. Download and put the script somewhere. Unzip the ffmpeg.zip into the same folder as the batch script file. (this is zipped due to github filesize constraints)
2. Drag and drop a video file on it.
3. Follow the on-screen instructions.

Dependencies
------------
- ffmpeg ( included ) ( updated to latest ffmpeg version as of 3/22/2025 )
