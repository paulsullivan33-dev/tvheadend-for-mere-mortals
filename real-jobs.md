# Real jobs

Outcome: three jobs assembled from the
parts this guide actually built, with
a clear line between the steps that
were run and the steps a real
household adds.

## Job 1: the lab bench — test any stream before it earns a network

This job is the lab itself, and it is
fully run. A stream you are offered —
a camera that outputs a transport
stream, a relay a friend runs, a file
a device produced — can be judged in
ten minutes without disturbing a
working server:

1. Save or generate a sample of the
   stream (chapter 5's ffmpeg recipe
   makes one from nothing).
2. Point a scratch network's mux at it
   with `file://` and scan (chapter 6).
   The service record — name, codecs,
   encryption flag — is the stream's
   true identity card.
3. Map and play it (chapters 7, 8).
   If it plays as a channel, it will
   behave as one on the real server.
4. Record a minute from a `pipe://`
   version (chapters 10, 11) and probe
   the file.

What this job cannot judge: whether
the stream survives Tuesdays, whether
its guide data is honest, and whether
its source tolerates being subscribed
to all day. Those are weeks of
watching, not minutes of scanning.

## Job 2: the home recorder

The canonical TVHeadend household,
assembled from guide parts, with the
unrun steps named:

1. A tuner or a network source feeds
   one or more networks. *Documented
   only in this guide — the lab had no
   tuner and pointed at no network
   source.*
2. Muxes are scanned; services are
   found, named by their own tables.
   *Run — chapter 6, on the lab's
   stream.*
3. Services are mapped to the channels
   the household actually watches, with
   numbers and tags. *Run — chapter 7.*
4. Guide data flows in from the
   streams' own tables or an XMLTV
   source. *Documented only — chapter 9
   explains why the lab's guide is
   empty and what would fill it.*
5. Recordings happen by guide event
   and autorec rule; the DVR writes to
   a storage folder chosen on purpose.
   *Run by manual entry — chapter 10.
   Event and rule recording are
   documented only.*
6. Kodi on the televisions speaks
   HTSP; phones and browsers use the
   playlist. *Documented only for the
   clients; the doors were run —
   chapters 4 and 8.*

The lesson the lab adds to this
classic job is small and worth the
whole exercise: when a recording
disappoints, probe the file and read
the finished entry before blaming
anything (chapter 10), and remember
that inputs have shapes (chapter 11).

## Job 3: an in-house channel

A pipe mux does not care what program
feeds it. A small organisation's
noticeboard loop, a training video on
repeat, a generated information
channel — rendered to a transport
stream by ffmpeg (or any tool that
writes one), served through a wrapper
like `serve-test-stream.sh`, becomes
a channel indistinguishable from any
other: in the playlist, in the guide's
channel list, recordable. *Run in the
lab in miniature:* the test pattern is
nobody's noticeboard, but the pipeline
— generator, pipe, mux, channel,
recording — is identical and was
exercised end to end. The content is
your department; TVHeadend remains,
as ever, the post room.

Check: pick the job nearest yours and
walk its steps, marking each one
"ran in the lab", "documented only",
or "needs my hardware". That marked
list is your honest plan, and it is
shorter than you feared.
