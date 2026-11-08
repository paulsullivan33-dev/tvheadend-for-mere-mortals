# Profiles and transcoding

Outcome: what a streaming profile is,
which one every lab measurement used,
and why the profiles that change the
picture are a processor budget, not a
setting to tick.

## A profile is the shape of the output

When a client subscribes, it picks a
**profile**: the rules for what leaves
the server. The profiles exist because
"the stream as received" is not always
what a player can play or a network
can carry. The kinds a standard
install offers:

- **pass** — the stream exactly as
  received, only re-wrapped if the
  client needs a different container
  around it. No picture or sound is
  decoded. This is the cheap profile,
  and the honest one for measurement.
- **htsp** — the pass stream served
  through the HTSP protocol for
  TVHeadend's own clients.
- **matroska** and other container
  profiles — the same content in a
  `.mkv` or web-friendly wrapping.
- **Transcoding profiles** — the
  stream decoded and re-encoded to
  chosen codecs, sizes, and bitrates.
  The startup log shows the machinery
  being registered: codec profiles
  named `webtv-h264`, `webtv-vp8`,
  `webtv-aac`, `webtv-vorbis` in the
  lab's run, built from the encoder
  library the package links.

Every number in this guide was
produced with `profile=pass`: the
952K playback (chapter 8) and both
recordings (chapter 10) are the
received stream, untouched. That is a
deliberate choice. It makes the
measurements mean something simple —
what came in is what was kept — and
it keeps chapter 1's rule visible:
with pass, the post room re-labels
the parcel, at most, and never opens
it.

## Transcoding is a CPU question

Re-encoding live television is
arithmetic at broadcast speed. One
high-definition stream re-encoded in
software can occupy several modern
CPU cores, continuously, for as long
as anyone watches. So "can TVHeadend
transcode" is really three questions:

1. Can this build do it? It needs the
   encoder library; the lab's build
   registered the codecs above at
   startup, so the machinery exists
   in this build.
2. Can this machine do it **while
   doing everything else** — recording
   two muxes, serving three viewers,
   and whatever else the box is for?
   That is a measurement on your
   hardware, not a feature list.
3. Does the client need it? Modern
   players decode the common broadcast
   codecs themselves. Transcoding
   earns its cost mainly for old
   players, small screens on slow
   links, and codecs a client cannot
   touch.

The lab ran **no transcoding
profile**: its client was a file
download and its codecs (MPEG-2, MP2)
were chosen to be trivially playable.
Transcoding quality, bitrate ladders,
and hardware acceleration are
therefore documented only here, and
any guide that quotes you a
transcoding result owes you the
machine it was measured on. Profiles
also exist on the recording side —
the DVR profile in chapter 10 chose
both a storage folder and an output
profile — and the same logic applies:
pass keeps what arrived; anything
else spends processor to change it.

Check: play a channel twice, once
with `profile=pass` and once with a
transcoding profile if your build
offers one, and watch the server's
CPU while each plays. The difference
between those two numbers is the
entire content of this chapter, on
your hardware, in one minute.
