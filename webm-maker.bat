@echo off

:: Necessary for some loop and branching operations ::
setlocal enabledelayedexpansion
:: Max 4chan file size for webm's, slightly reduced because ffmpeg averages the bitrate and it can become slightly bigger than the max size, even with perfect calculation
set max_file_size=2700

:: Check if script was started with a proper parameter ::
if "%~1" == "" (
	echo This script needs to be run by dragging and dropping a video file on it.
	echo It cannot do anything by itself.
	pause
	goto :EOF
)

:: Hello user ::
echo 4chan webm maker
echo originally by Cephei (with some modification)
echo forked and fixed by funions

:: Time for some setup ::
cd /d "%~dp0"

:: Ask user how big the webm should be ::
echo Please enter webm render resolution.
echo Example: 720 for 720p.
echo Default: Source video resolution.
set /p resolution="Enter: " %=%
if not "%resolution%" == "" (
	set resolutionset=-vf scale=-1:%resolution%
)
echo.

:: Ask user where to start webm rendering in source video ::
echo Please enter webm rendering offset in SECONDS.
echo Example: 31
echo Default: Start of source video.
set /p start="Enter: " %=%
if not "%start%" == "" (
	set startset=-ss %start%
)
echo.

:: Ask user for length of rendering ::
echo Please enter webm rendering length in SECONDS.
echo Example: 15
echo Default: Entire source video.
set /p length="Enter: " %=%
if not "%length%" == "" (
	set lengthset=-t %length%
) else (
	ffmpeg.exe -i %1 2> webm.tmp
	for /f "tokens=1,2,3,4,5,6 delims=:., " %%i in (webm.tmp) do (
		if "%%i"=="Duration" call :calculatelength %%j %%k %%l %%m
	)
	del webm.tmp
	echo Using source video length: !length! seconds
)
echo.

:: Find bitrate that maxes out max filesize on 4chan, defined above ::
set /a bitrate=8*%max_file_size%/%length%
echo Target bitrate: %bitrate%

:: Separate the audio track ::
set audio_name=%~n1.aac
ffmpeg -i %~1 -vn %startset% %lengthset% -acodec copy %audio_name%

:: Upload the audio track to catbox.moe ::
for /F "delims=" %%I in ('curl -F "reqtype=fileupload" -F "fileToUpload=@%audio_name%" https://catbox.moe/user/api.php') do set upload_url=%%I

:: Encode the URL ::
for /f %%N in ('mshta "javascript:code(close(new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1).Write( encodeURIComponent("%upload_url%") )));"') do set upload_url_encoded=%%N

:: Find the target webm name ::
set webm_name="%~n1[sound=%upload_url_encoded%].webm"

:: Two pass encoding because reasons ::
ffmpeg.exe -i "%~1" -c:v libvpx -b:v %bitrate%K -quality best %resolutionset% %startset% %lengthset% -an -sn -threads 0 -f webm -pass 1 -y temp.webm
ffmpeg.exe -i "%~1" -c:v libvpx -b:v %bitrate%K -quality best %resolutionset% %startset% %lengthset% -an -sn -threads 0 -pass 2 -y "%webm_name%"
del ffmpeg2pass-0.log
goto :EOF

:: Helper function to calculate length of video ::
:calculatelength
	for /f "tokens=* delims=0" %%a in ("%3") do set /a s=%%a
	for /f "tokens=* delims=0" %%a in ("%2") do set /a s=s+%%a*60
	for /f "tokens=* delims=0" %%a in ("%1") do set /a s=s+%%a*60*60
	set /a length=s
