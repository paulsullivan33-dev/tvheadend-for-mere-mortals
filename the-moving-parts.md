# The moving parts

By the end of this chapter you can
name the chain a picture travels —
input, network, mux, service, channel —
and place the guide, the recorder, and
the two doors clients use.

## The chain

TVHeadend's whole design is one chain,
and every screen in its web interface
is a view of one link:

1. **Input.** Something that can
   deliver a stream: a tuner device, a
   network tuner, or an IPTV input that
   opens an address. The lab had no
   tuner hardware; its input was the
   built-in IPTV input, and the server
   log reports it plainly: "iptv: Using
   2 input thread(s)".
2. **Network.** A named source of
   television of one kind: one
   broadcast network for a tuner, or
   one IPTV network for a set of
   stream addresses. The lab created
   one, called *Lab Loopback Network*.
3. **Mux.** Short for multiplex: one
   carrier of streams. On broadcast
   television a mux is one frequency
   carrying several channels at once.
   On IPTV a mux is one stream address.
   One mux, one carrier's worth of
   television at a time — that fact
   drives the limits in chapter 16.
4. **Service.** One programme stream
   found inside a mux, with its video,
   audio, and name. A scan creates
   services; nothing is a channel yet.
   The lab's scan created exactly one:
   *Harbour Light Test*, service ID 1,
   provider *Fictional Workshop*
   (transcript
   `tvheadend-lab/transcripts/t05-network-and-file-scan.txt`).
5. **Channel.** The viewer-facing
   entry: a name, a number, and one or
   more services behind it. Services
   become channels only when something
   **maps** them (chapter 7). Channels
   are what playlists, guides, and
   recordings talk about.

Negative space matters here: a service
nobody maps is invisible to viewers,
and a channel whose services all stop
arriving is a name with nothing behind
it — the rule from chapter 1, wearing
a different hat.

## The two side systems

**The programme guide** (EPG,
electronic programme guide) hangs off
the side of the chain. Grabber modules
collect listings — from tables inside
the streams themselves, or from
external files in XMLTV format — and
attach them to channels. TVHeadend
creates no listings of its own.

**The DVR** also hangs off the side.
Give it a channel and a window of
time, and it subscribes to that
channel's stream and writes what
arrives to disk, in a storage folder
you choose, under a profile you pick.
Chapter 10 is its story, including the
day it kept 11 seconds of a 30-second
request.

## The two doors out

Clients reach TVHeadend two ways:

- **HTTP**, the ordinary web door, on
  port 9981 by default: the web
  interface itself, channel playlists,
  and stream addresses such as
  `/stream/channel/<id>`. The lab used
  this door for everything.
- **HTSP**, TVHeadend's own protocol,
  on port 9982 by default: the richer
  door used by Kodi's TVHeadend
  client, which can browse the guide,
  set recordings, and watch changes
  arrive live.

The lab moved both doors: web to
127.0.0.1:18091 and HTSP to
127.0.0.1:19091, loopback only, as
series labs do. The server log's first
lines are those two doors opening
(transcript
`tvheadend-lab/transcripts/t04-first-run.txt`).

## Where the state lives

Everything above is stored as small
files in one **configuration folder**:
networks and muxes under `input/`, DVR
settings under `dvr/`, access entries
under `accesscontrol/`. Point the
server at a different folder and it is
a different server. The lab kept its
folder in scratch space, never in a
home directory, and created it fresh —
the log line "no configuration,
loading defaults" is what an empty
folder sounds like.

Check: walk the chain aloud from a
tuner to a viewer's screen, naming all
five links, and say which door the
viewer used. If you can, the rest of
the guide is detail.
