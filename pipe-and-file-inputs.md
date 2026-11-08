# Pipe and file inputs

Outcome: the three shapes an IPTV mux
address can take, which of them can
feed a recorder, and the looping pipe
that turned this lab's finite file
into an endless broadcast.

## An IPTV mux is an address, and the scheme is the meaning

Chapter 5 created a mux with a
`file://` URL. That was one of three
shapes worth knowing:

- **`file://`** — read a transport
  stream file from disk. Real uses:
  testing (this lab), a loop of
  in-house content, a stream archived
  to disk. Character: finite. It
  starts, it plays, it ends, and it
  does not rewind for the next
  subscriber.
- **`pipe://`** — run a program and
  read the transport stream from its
  standard output. The program is
  yours: an ffmpeg conversion, a
  receiver tool, a generator.
  Character: as endless as the program
  is. Add the mux's **respawn** option
  and TVHeadend restarts the program
  if it exits.
- **`http://`, `https://`, `udp://`** —
  fetch a stream from the network:
  the shape real IPTV services and
  home stream relays use. Character:
  endless while the source serves.
  **The lab never used these.** Its
  rules forbid pointing the server at
  external streams, and no other
  machine in the lab served one. They
  are documented here from the
  project's documentation, and nothing
  in this guide claims a result for
  them.

## The lab's pipe

The lab's wrapper script is six lines
of substance
(`tvheadend-lab/drivers/serve-test-stream.sh`):
ffmpeg reads the fixture with
`-stream_loop -1` (loop forever) and
`-re` (at the stream's natural rate —
without it, ffmpeg would pour the
file down the pipe as fast as disk
allows, and "live" would be a flood),
copies the codecs untouched, writes
the fixture's service name and
provider back into the new stream's
tables, and emits a transport stream
to standard output. The mux URL became
`pipe://` plus the script's path, with
respawn on.

Two operational facts the lab learned
and kept:

1. **Restart after changing the pipe.**
   Editing the mux URL on a live
   server left the mux stuck with a
   bad service instance during
   exploration; the same change plus a
   restart produced, within seconds,
   the log line `spawn: Executing
   ".../serve-test-stream.sh"`, a live
   ffmpeg process owned by TVHeadend,
   and a scan reading `scan_state 3
   scan_result 1 num_svc 1` — ACTIVE,
   **OK**, one service (transcript
   `tvheadend-lab/transcripts/t09-pipe-and-recording.txt`).
2. **The pipe's stream is a new
   stream.** The service found on it
   carries the same name and provider
   only because the script writes them
   in. A pipe that re-encodes or
   re-muxes decides its own tables;
   check them with a scan rather than
   assuming the input file's identity
   survives. The lab's playback from
   the pipe mux measured 540K in eight
   seconds — a slightly different rate
   than the file mux's, because a
   re-wrapped stream is a different
   object. It recorded in full
   (chapter 10), which was the point.

## Choosing a shape

Ask one question: *when the recorder
tunes at 3 a.m., will anything be
coming out of this address?* A live
network source: yes. A pipe whose
program loops, generates, or receives:
yes, and respawn covers its crashes.
A file: only if nobody and nothing
has drained it first — fine for a
scan, fine for a demo, a trap for a
schedule. Most "my recordings are
empty" stories in IPTV households are
this question answered wrong, with
the recorder — the faithful post room
— blamed for the silence it was
handed.

Check: point a mux at each shape you
intend to use and subscribe twice, an
hour apart — play it, then check it
again. The shape is right for
recording only if the second
subscription gets a stream as surely
as the first.
