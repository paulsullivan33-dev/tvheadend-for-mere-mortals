# Mapping services to channels

Outcome: a channel viewers can
actually use, created from the scanned
service — plus the playlist TVHeadend
publishes once a channel exists.

## Why mapping is a step at all

It is tempting to ask why a found
service is not simply a channel. The
separation earns its keep in real
systems: one channel can be backed by
several services (the same programme
from two muxes, a standard and a
high-definition version), a service
can be found and deliberately left
unmapped (test cards, data services,
channels you do not want), and
renaming a channel does not touch the
stream underneath. Mapping is where a
household's television is *curated*,
not merely received.

## The mapping, as the lab did it

In the interface: Configuration,
Channel/EPG, Map services — or select
the service and choose the mapper. The
lab used the mapper's own endpoint:

```
POST /api/service/mapper/save
  node={"uuid":"00000000000000000000000000000000",
        "services":["<service uuid>"]}
```

(The all-zero ID is the service
mapper's own settings object, not a
typo.) The mapper runs as a background
task, which the guide demonstrates
rather than asserts: polling the
channel grid once a second-ish found
`channels = 0` on the first poll and
`channels = 1` on the second, and the
log signed the work (transcript
`tvheadend-lab/transcripts/t06-map-and-play.txt`):

```
service-mapper: Lab Loopback Network/Harbour Light Mux/Harbour Light Test: success
```

The channel that lands is complete:
name *Harbour Light Test* (taken
automatically from the service,
`autoname: true`), `enabled: true`,
its `services` list holding exactly
the scanned service, and two channel
**tags** the mapper created for
sorting and filtering. The service's
own record now names the channel back
— the empty `channel: []` from
chapter 6 is filled.

Mapper options the lab left at their
defaults, and the guide therefore
describes but does not claim to have
exercised: checking availability
before mapping, mapping encrypted
services anyway, merging services with
the same name into one channel, and
tidying names. They exist on the
mapper's form; on a one-service lab
network, none of them had anything to
decide.

## What a channel unlocks

The moment a channel exists, TVHeadend
publishes it. `GET /playlist/channels`
answers an M3U playlist any player can
open:

```
#EXTM3U
#EXTINF:-1 tvg-id="7e134c73b0d7ab4a28226b045582fd11",Harbour Light Test
http://127.0.0.1:18091/stream/channelid/1934365566?profile=pass
```

(the numeric ID differs per server;
the shape is stable). One channel, one
entry, one stream address — that file
is the whole "television service" the
lab set out to build, and chapter 8
plays it. Guide data, recordings, and
client apps all key off the channel,
never off the raw service. When
something viewer-facing looks wrong,
this chapter's boundary is where to
look first: service healthy but
unmapped, or channel mapped to a
service that has gone silent.

Check: fetch the playlist. Your
channel is listed, by name, with a
stream address under your own server.
If the playlist is just `#EXTM3U` and
nothing else, you have services but no
channels — map, then look again.
