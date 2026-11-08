# Recording

Outcome: a recording made and
measured — two, in fact. One window
asked for 30 seconds and kept about
11; one asked for 35 and kept 34.45.
This chapter explains both, because
the difference between them is the
most useful lesson in the guide.

## First, tell the DVR where to write

A fresh TVHeadend's default DVR
configuration has no storage folder
set, and startup says so in a warning
the lab kept: the output directory
"is not yet configured... Defaulting
to "/home/hatch"". A recorder that
writes into a home directory by
default is a surprise nobody needs.
In the interface: Configuration,
Recording, DVR Profiles, set
**Storage path**. The lab set its DVR
profile's storage to a scratch folder
through the API (`POST
/api/idnode/save` with the profile's
`storage` field; transcript
`tvheadend-lab/transcripts/t08-recording-file-fails.txt`)
and verified the new value read back.

## A manual recording

With an empty guide (chapter 9), there
are no events to click Record on, so
the lab created a **manual entry**: a
channel, a start, a stop, a title.

```
POST /api/dvr/entry/create
  conf={"enabled":true, "channel":"<channel uuid>",
        "start":<epoch>, "stop":<epoch>,
        "title":{"eng":"Harbour Light Recording Test"}}
```

At the appointed time the DVR
subscribes — the log uses the same
word as for a viewer, with weight 500,
a recorder's priority — and writes
the stream to the storage folder under
the profile's name pattern.

## Recording one: the window says 30, the file says 11

The first lab recording ran against
the **file mux** from chapter 5: a
30-second window on a channel whose
whole stream is a 20-second file. The
finished record looks like success
(transcript t08):

```
disp_title  = Harbour Light Recording Test
duration    = 30
filesize    = 750308
status      = Completed OK
errors      = 0
data_errors = 0
```

Then measure the file itself, as this
guide keeps insisting:

```
duration=10.930022
size=750308
```

About **11 seconds** of programme in
a 30-second recording with zero
reported errors. Both statements are
true. The recorder tuned, received
what the one-shot file stream had
left to give in that window — the
stream had already been read by the
scan and by playback, and a file does
not rewind itself for each new
subscription — wrote it faithfully,
and closed on schedule. And in
exploration, before the final run,
the same attempt failed outright
twice: "Recording unable to start...
No input detected", ending "Time
missed" (kept in
`tvheadend-lab/drivers/file-recording-failures-excerpt.txt`).
Same cause, harsher day: nothing left
to give at all.

This is chapter 1's rule with a
stopwatch. A recording is not a
promise of a programme; it is a kept
stream. The DVR's own counters count
streaming errors, not
disappointments, so *verify recordings
by their contents*, the way this
chapter does.

## Recording two: an endless stream keeps the whole window

Chapter 11 rebuilds the mux as a
**pipe** that loops the fixture
forever. Same channel, same manual
method, a 35-second window (transcript
`tvheadend-lab/transcripts/t09-pipe-and-recording.txt`):

```
disp_title  = Harbour Light Recording Test
duration    = 35
errors      = 0
data_errors = 0
status      = Completed OK
```

and the file this time:

```
duration=34.450022    size 2.6 MB
```

34.45 of 35 seconds, the small
shortfall being start-up and
measurement edges. When the stream
keeps coming, the recording keeps
everything. The recorder did not
change between the two runs. The
input did.

## Beyond manual entries — documented only

Real households mostly record by
**guide event** (click a programme),
by **autorec** rules (record anything
matching a title or series), and by
**timerec** (a channel, a clock
window, repeating days). All three
are entry points to the same DVR the
lab drove by hand; the lab's guide
was empty and its patience finite, so
only the manual route is claimed as
run. Post-recording behaviour —
retention days, removing watched
recordings, filename patterns like the
`$t$n.$x` pattern in the lab's profile
— is configuration this guide read
but did not exercise.

Check: after any recording, do two
things. Read the finished entry
(status, errors), and probe the file
(duration, streams). Only believe the
recording when both agree with the
window you asked for.
