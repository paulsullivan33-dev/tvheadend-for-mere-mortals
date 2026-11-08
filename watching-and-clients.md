# Watching and clients

Outcome: television on a screen —
played through the server's own HTTP
door and measured — and an honest map
of the other client doors the lab did
not open.

## Playing a channel over HTTP

A channel's stream address is
`/stream/channel/<channel uuid>`, with
a **profile** chosen by query string.
The lab fetched eight seconds of its
channel with the `pass` profile —
pass means the stream travels
unchanged, exactly as received:

```
curl http://127.0.0.1:18091/stream/channel/<uuid>?profile=pass
```

Eight seconds of a live stream does
not end on its own; the lab stopped
the fetch with a timeout, on purpose,
and kept what arrived (transcript
`tvheadend-lab/transcripts/t06-map-and-play.txt`):

```
-rw-rw---- 1 root root 952K ... playback.ts
```

`ffprobe` on the captured bytes finds
the same two streams the fixture was
born with — MPEG-2 video, MP2 audio —
now delivered by TVHeadend rather
than read from the file. 952K in eight
seconds is the stream's real rate,
roughly a megabit a second with
overhead. The chain from chapter 2 is
closed: file, mux, service, channel,
player.

Any player that opens HTTP streams —
VLC, mpv, a browser-based player, most
smart-TV apps via the playlist from
chapter 7 — can use this door. The
playlist is the polite way in: hand
the player `/playlist/channels` and
it learns the channels as a list,
refreshing addresses itself.

## The HTSP door, documented only

**HTSP**, on the second port (9982 by
default, 19091 in the lab), is
TVHeadend's own protocol: a binary,
conversational door built for real
clients. Kodi's TVHeadend add-on is
the canonical user — it browses
channels and the guide, watches live,
and creates and deletes recordings
through HTSP, and it learns about
changes (a recording finished, a
schedule appeared) as they happen
rather than by polling.

The lab's evidence for HTSP is
deliberately modest and says so: the
server log records the listener
starting on 127.0.0.1:19091, the
socket sits in the listening list, and
a TCP connection to it succeeds
(transcript
`tvheadend-lab/transcripts/t04-first-run.txt`).
Speaking the protocol needs a real
client; no Kodi ran in this lab, so
HTSP conversations are described from
the project's documentation and not
claimed as tested. The same applies to
TVHeadend's SAT>IP server side: the
capabilities list in `/api/serverinfo`
advertises `satip_server`, and no
SAT>IP client was available to test
it against.

## Subscriptions: the word for watching

Every viewer, recorder, and scan is a
**subscription** in TVHeadend's
vocabulary — the log lines in later
chapters ("DVR: ... subscribing on
channel ...") use the same word for a
recording as for a person watching.
Subscriptions compete for inputs: two
viewers of services on the same mux
share one tune, while services on
different muxes need an input each.
The status endpoint
`/api/status/inputs` shows live tunes;
during the lab's playback it reported
the IPTV input tuned to the lab mux
with one subscription attached. When
a household outgrows its tuners, this
is the arithmetic that bites — and it
is a limit of physics and hardware,
not of the relay. Chapter 16 states
it as a rule.

Check: play your channel for a few
seconds through its stream address and
measure what arrives. A growing file
(or a playing picture) at roughly your
stream's bitrate means the whole chain
works. Nothing arriving is a
subscription problem; chapter 17
starts there.
