- [TITLE:](#title)
- [CONTAINS:](#contains)
- [NOTES:](#notes)
- [PLEASE NOTE:](#please-note)
- [AUDIO FILE FORMATS:](#audio-file-formats)
- [PLAYLIST FORMATS:](#playlist-formats)
- [SETUP:](#setup)

### TITLE: 
Haoting Media Player

This is cloned from the Sox Media Player.  (https://www.mobileread.com/forums/showthread.php?t=329588).
This has been added some features as Update Playlist, Play All Files, Play Single File

### CONTAINS: 
KUAL extension to play media on newer kindles with USB or BT audio

### NOTES:
This is the second release of this KUAL package which includes Sox and all
dependencies.

Scripts are included for playing both local and intenet media supported by Sox.
KUAL menu entries show examples of using the scripts and can be used as a model
for adding custom menu items.

### PLEASE NOTE: 
Sox does NOT support AAC!  Any attempts to play AAC will fail.

Per Sox:

### AUDIO FILE FORMATS: 
8svx aif aifc aiff aiffc al amb amr-nb amr-wb anb au avr awb caf cdda cdr cvs cvsd cvu dat dvms f32 f4 f64 f8 fap flac fssd gsm gsrt hcom htk ima ircam la lpc lpc10 lu mat mat4 mat5 maud mp2 mp3 nist ogg paf prc pvf raw s1 s16 s2 s24 s3
                    s32 s4 s8 sb sd2 sds sf sl sln smp snd sndfile sndr sndt sou
                    sox sph sw txw u1 u16 u2 u24 u3 u32 u4 u8 ub ul uw vms voc
                    vorbis vox w64 wav wavpcm wv wve xa xi
### PLAYLIST FORMATS: 
m3u pls

All media played in one call to Sox must be the same format, rate, channels and
depth.  This is due to the limited interface provided to the audio support.

Sox expects files to play in /mnt/us/music, which is the music directory seen
when the kindle is plugged into a computer.

Internet radio must include the stream format as Sox does not autodetect this
for a stream.

Function has not been tested on USB audio, as I don't have one, but I expect it
will work there as well.  Behavior on older Kindles is unknown.

### SETUP:

Follow instructions to pair your bluetooth device with your kindle.  Place any
music files or audio books you want to play in the music directory.  For any
internet streams you want to play you must edit the menu.json file following
the example streams included.

Expect problems if you attempt to play media without your bluetooth active and
connected to your device.  I have also found that the bluetooth can be flaky at
times and you may find your playback pausing and your kindle unresponsive until
it gets itself back to normal.

Thanks to geek1011, NiLuJe, trcm and yparitcher for their assistance.  Thanks
to PoP for his assistance in getting pw3 support working.

Dave