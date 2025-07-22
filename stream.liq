#!/usr/bin/liquidsoap

# Lines starting with # are comments, they are ignored.

# Put the log file in some directory where
# you have permission to write.
log.file.path := "/tmp/radio1.log"
# Print log messages to the console,
# can also be done by passing the -v option to liquidsoap.
log.stdout := true
# Use the telnet server for requests
#settings.server.telnet := true

# A bunch of files and playlists,
# supposedly all located in the same base dir.

security = single("/home/dip16/music/error.mp3")

day     = playlist("/home/dip16/music/playlist_day.pls")
night   = playlist("/home/dip16/music/playlist_night.pls")
#jingles = playlist("~/radio/jingles.pls")
#clock   = single("~/radio/clock.ogg")

# Play user requests if there are any,
# otherwise one of our playlists,
# and the default file if anything goes wrong.
radio = fallback([ request.queue(id="request"),
                    switch([({ 7h-21h }, day),
                            ({ 21h-7h }, night)]),
                    security])

# radio = crossfade(radio, 5)
# Add the normal jingles
#radio = random(weights=[1,5],[ jingles, radio ])
# And the clock jingle
#radio = add([radio, switch([({0m0s},clock)])])


# radio = playlist("/home/dip16/music/playlist_day.pls")
# Add the ability to relay live shows
#radio1 = fallback(track_sensitive=false, [night, security])
#radio = fallback(track_sensitive=false, [crossfade(radio, security, 10.0)])

# Output the full stream in OGG and MP3
out1 = output.icecast(%mp3(bitrate=128),
  host="localhost",
  port=8001,
  password="nirvana7",
  mount="radio128",
  radio,
  description="mp3_128",
  name="dip16mp3",
  genre="various",
  url="dip16mp3128.url")

out2 = output.icecast(%mp3(bitrate=192),
  host="localhost",
  port=8001,
  password="nirvana7",
  mount="radio192",
  radio,
  description="mp3_192",
  name="dip16_mp3_192",
  genre="various",
  url="dip16mp3192.url")

#out3 = output.icecast(%vorbis(quality=1.0),
#  host="localhost",
#  port=8001,
#  password="nirvana7",
#  mount="ogg10",
#  radio,
#  description="ogg_1.0",
#  name="dip16ogg10",
#  genre="various",
#  url="dip16ogg10.url")

#out4 = output.icecast(%ffmpeg(%audio(codec="aac", b="128k")),
#  host="localhost",
#  port=8001,
#  password="nirvana7",
#  mount="rad10",
#  radio,
#  description="aac_1.0",
#  name="dip16",
#  genre="various",
#  url="dip16.url",
 # format="aac",  # Указываем MIME-тип
#  icy_metadata=true  # Указываем, что необходимо отправлять метаданные
# )

#out1
#out2
#out3
#out2

# Output the stream without live in OGG
#output.icecast(%vorbis,
#  host="localhost",port=8001,password="nirvana7",
#  mount="radio_nolive.ogg",radio)
