# The programme guide

Outcome: a clear account of where
guide data comes from and how it
reaches a channel — ending with the
lab's empty guide, which is a correct
result and not an error.

## What the guide is made of

The **EPG** (electronic programme
guide) is a database of events: this
channel, this programme, these start
and stop times. TVHeadend writes none
of it. **Grabber** modules fetch it
from sources, and each channel is
linked to guide data by name and ID
matching. The startup log reads like a
roll call of the grabbers the build
ships (transcript
`tvheadend-lab/transcripts/t07-epg.txt`):
over-the-air modules for several
countries' broadcasts, the generic
**EIT** grabber (event information
tables carried inside streams
themselves), OpenTV modules, the PSIP
module for North American broadcasts,
and an **XMLTV** module for external
listings files — the format most
paid and community listings services
publish.

When a mux tunes, TVHeadend registers
it for over-the-air grabbing. The lab
heard that happen for its own mux:

```
epggrab: Harbour Light Mux in Lab Loopback Network - registering mux for OTA EPG
```

## The lab's guide: zero events, on purpose

The lab then asked the guide what it
held:

```
GET /api/epg/events/grid
{"totalCount":0,"entries":[]}
```

Zero, and correctly zero. The fixture
stream contains PAT, PMT, and SDT
tables — enough to name and play a
service — but no EIT tables: ffmpeg
was never asked to write any programme
events into it, so there was nothing
for the EIT grabber to grab. The chain
worked end to end and delivered
emptiness, faithfully. That is chapter
1's rule in its purest form, and this
guide keeps the result rather than
staging a populated guide it did not
earn.

What would have filled it, in a real
household, in rough order of effort:

- **The streams themselves.** Real
  broadcast muxes carry EIT data, and
  the same tune that plays a channel
  harvests its listings. Nothing extra
  to run; the guide is only as good as
  what broadcasters send, which varies
  from excellent to a bare title.
- **An XMLTV file.** A listings
  provider (or a community source)
  publishes a file; an XMLTV grabber
  program fetches it on a schedule,
  and TVHeadend imports it and matches
  entries to channels. This is the
  route most cable and IPTV households
  end up on, because network streams
  often carry little or no EIT.
- **In-stream proprietary systems**
  (OpenTV and friends), which the
  matching modules handle for the
  platforms that use them.

## Guide data is also recording data

The guide is not decoration. Scheduled
recordings (chapter 10) are guide
events with a record flag, automatic
recording rules search the guide, and
a channel with no guide data can only
be recorded by hand, by clock — which
is exactly what the lab does in the
next chapter, because its guide is
empty. When a household complains that
"recording by series" does nothing,
the fault is here nine times in ten:
no events, nothing to match, nothing
to schedule. Check the guide before
you blame the recorder.

Everything in this chapter beyond the
registration log line and the zero
count is **documented only**: no
XMLTV file was imported, no real
stream's EIT was received, and no
populated guide was screenshotted or
quoted. The lab could have invented
listings; it chose the honest zero.

Check: query `/api/epg/events/grid`
on your server. The count is either
events your sources actually sent, or
zero — and now you know which of your
inputs should have sent them.
