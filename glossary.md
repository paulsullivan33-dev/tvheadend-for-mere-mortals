# Glossary

By the end of this chapter the guide's
vocabulary is in one place, defined
the way the guide used it.

**Access entry.** A rule in
TVHeadend's access control matching a
user, a password, and an address range
to a bundle of rights: streaming,
recording, administration, web
interface.

**API.** The server's machine-readable
web interface under `/api/`, used by
the web UI itself and by this guide's
lab for networks, muxes, mapping, and
the DVR.

**Autorec.** An automatic recording
rule that searches guide data for
matches — a title, a series — and
schedules recordings by itself.

**Channel.** The viewer-facing entry:
a name and number backed by one or
more services. Playlists, the guide,
recordings, and clients all speak of
channels.

**DVB.** Digital Video Broadcasting:
the family of standards behind
terrestrial (DVB-T), cable (DVB-C),
and satellite (DVB-S) television.

**DVR.** Digital video recorder. In
TVHeadend, the side system that
subscribes to a channel for a window
of time and keeps the stream as a
file.

**EIT.** Event information table: the
guide data carried inside a stream
itself, harvested by the EIT grabber.

**EPG.** Electronic programme guide:
the database of what is on which
channel, when — assembled from
grabbers, never written by TVHeadend.

**Grabber.** A module that fetches
guide data from a source: a stream's
own tables, an OpenTV or PSIP system,
or an XMLTV file.

**HTSP.** TVHeadend's own client
protocol (port 9982 by default): the
door Kodi's TVHeadend add-on uses for
live TV, the guide, and recordings.

**IPTV.** Television delivered as
network data. In TVHeadend, an input
kind whose muxes are addresses:
`file://`, `pipe://`, `http://`,
`udp://`.

**Mapping.** The deliberate step that
turns a scanned service into a
channel, done by the service mapper.

**Mux (multiplex).** One carrier: a
broadcast frequency's bundle of
services, or, for IPTV, one stream
address. One mux is one tune.

**Network.** A named container for
muxes of one kind: a broadcast
network for a tuner, an IPTV network
for addresses.

**PAT / PMT / SDT.** The tables inside
a transport stream that describe it:
the PAT lists programmes, the PMT
lists each programme's video and audio
pieces, the SDT carries the human
names.

**Pipe input.** A mux whose program is
run by TVHeadend, the stream read from
the program's standard output.
Respawn restarts a program that exits.

**Profile.** The output rules a
subscription or a recording uses.
`pass` delivers the stream unchanged;
transcoding profiles decode and
re-encode it, at CPU cost.

**Scan.** Opening a mux's stream and
reading its tables to learn what
services it carries. Scan states:
IDLE, PEND, ACTIVE. Scan results:
NONE, OK, FAIL, OK (partial), IGNORE.

**Service.** One programme stream
found inside a mux by a scan, with a
service ID, a name, and component
streams. Not yet a channel.

**Service ID (SID).** The number a
stream's tables use for a service
within its mux. The lab's service was
SID 1.

**Subscription.** Any live use of a
stream: a viewer, a scan, a guide
grab, a recording. TVHeadend's log
uses this one word for all of them.

**Transport stream (TS).** The
container format broadcast television
travels in: 188-byte packets
multiplexing video, audio, and tables.
The `.ts` files in the lab are this.

**Tuner.** Hardware that receives one
mux at a time from an aerial, dish, or
cable feed and hands its stream to the
server.

**XMLTV.** The common file format for
external programme listings, imported
by TVHeadend's XMLTV grabber and
matched to channels.

Check: pick any three terms and use
each in a true sentence about the lab
— for instance, what its one mux, one
service, and one channel were. If the
sentences come easily, the guide has
done its work.
