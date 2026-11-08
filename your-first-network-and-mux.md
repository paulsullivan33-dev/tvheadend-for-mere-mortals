# Your first network and mux

Outcome: one IPTV network and one mux
whose address is a file on the same
machine — the smallest television
source that is still a real one.

## The fixture: a stream the lab made

Every later chapter depends on there
being something to relay, so the lab
made its own (transcript
`tvheadend-lab/transcripts/t03-test-stream.txt`).
One ffmpeg command produced a
20-second **MPEG transport stream** —
the container format broadcast
television travels in — holding a test
pattern and a 440 Hz tone:

```
ffmpeg -f lavfi -i testsrc2=size=320x240:rate=25 \
  -f lavfi -i sine=frequency=440:sample_rate=48000 -t 20 \
  -c:v mpeg2video -b:v 400k -c:a mp2 -b:a 96k \
  -metadata service_name="Harbour Light Test" \
  -metadata service_provider="Fictional Workshop" \
  -mpegts_original_network_id 1 \
  -mpegts_transport_stream_id 1 -mpegts_service_id 1 \
  -f mpegts harbour-light.ts
```

`ffprobe` reads it back as one
programme, service name *Harbour Light
Test*, provider *Fictional Workshop*,
with two streams: MPEG-2 video at
320x240 and MP2 audio. Those codecs
are the plain broadcast classics —
deliberately boring, because the point
is TVHeadend, not the stream. The
names are invented; no broadcaster was
involved in any way. The file is in
the lab at
`tvheadend-lab/fixtures/harbour-light.ts`.

## The network

In the web interface this is
Configuration, DVB Inputs, Networks,
Add, type **IPTV Network**. The lab
did the same operation through the
API, because API calls can be kept as
evidence:

```
POST /api/mpegts/network/create
  class=iptv_network
  conf={"enabled":true,
        "networkname":"Lab Loopback Network",
        "skipinitscan":false}
```

The answer is the new network's ID:
`{"uuid":"e14dfc4a9298ceb544d1c94cf298b447"}`
(the ID itself is random per run; the
shape is the point). A network is a
container: it holds muxes of one kind
and lends them its settings. An IPTV
network needs no tuner and no adapter
assignment — its inputs are addresses.

## The mux

One mux, one address. In the interface:
Muxes, Add, choose the network, and
the form asks for a **URL**. The lab:

```
POST /api/mpegts/network/mux_create
  uuid=<network uuid>  class=iptv_mux
  conf={"iptv_url":"file:///.../tvheadend-lab/fixtures/harbour-light.ts",
        "iptv_muxname":"Harbour Light Mux",
        "name":"Harbour Light Mux", "enabled":1}
```

The URL scheme is the mux's whole
character. `file://` tells the IPTV
input to read a file from disk; later
chapters meet `pipe://` (chapter 11)
and the network schemes (http, udp)
that real IPTV sources use and this
lab never pointed anywhere. A new mux
is born wanting a scan: its first poll
in transcript
`tvheadend-lab/transcripts/t05-network-and-file-scan.txt`
reads `scan_state 1` (pending),
`num_svc 0`, and placeholder IDs
`onid 65536 tsid 65536` — it knows its
address and nothing else. Everything
it is about to learn has to come from
the stream itself. That is chapter 6.

One caution the guide owes you early:
creating the network through the
general save endpoint does not work —
the create endpoints above are the
doors the web interface itself uses,
found by reading its code. More than
one lab hour has been lost, in
projects like this one, to a polite
`400 Bad Request` from the wrong door.

Check: list your networks and muxes
(the interface's Networks and Muxes
tabs, or `/api/mpegts/network/grid`
and `/api/mpegts/mux/grid`). One
enabled network, one enabled mux, and
the mux's URL is a stream you control.
