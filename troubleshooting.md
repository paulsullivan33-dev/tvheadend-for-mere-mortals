# Troubleshooting

Outcome: the failures this lab
actually met, in the order a new
installer meets them, each with the
evidence that identifies it and the
fix that closed it.

## The server crashes at startup, complaining about data files

**Seen in the lab.** Log lines:
`profile: no default streaming profile!
reinstall data files`, then a crash
record. Cause: the binary cannot see
its data tree at `/usr/share/tvheadend`
— a property of extracted or
hand-copied binaries, not of packaged
installs. Fix: install the package
properly, or do what the lab did and
supply the tree at that path (chapter
3's namespace story). If a packaged
install prints this, the package is
genuinely broken; reinstall it.

## Version answers, web door silent — or the reverse

Check the two listeners separately.
The log prints one line for HTTP and
one for HTSP at startup; `ss -tlnp`
shows which exist; `/api/serverinfo`
is the web door's smallest answer. A
server answering the API but not
starting HTSP, or bound to an address
you are not asking, is a flags
problem: read your starting line
(`--bindaddr`, `--http_port`,
`--htsp_port`) before reading anything
else. Chapter 4's transcript is the
healthy shape.

## Everything returns 400, or the API ignores your create

The interface's create operations use
dedicated endpoints —
`/api/mpegts/network/create`,
`/api/mpegts/network/mux_create` —
with `class` and a JSON `conf` as
separate fields. Posting the same
intent to the general
`/api/idnode/save` (which expects a
node object with a real ID, the form
the mapper and the DVR settings use)
returns a polite `400 Bad Request`
and creates nothing. The lab met this
exact wall twice. If a call fails,
imitate the web interface: its own
code is shipped with the server and
names every door it uses.

## A scan finds zero services

Work the chain from the stream
outward. Probe the source itself
(`ffprobe` on a file; play the address
in a player): no PAT/PMT/SDT in the
source means no scan can find a
service, full stop. Then read the
scan fields (chapter 6): stuck at PEND
means queued behind another tune;
FAIL means tuned and found nothing
usable; a service count that matches
the source's own claims means the scan
is fine and your problem is downstream
— mapping, usually. A scan is a report
on the stream; believe it.

## The mapper "did nothing"

It runs as a background task. The
channel can land seconds after the
request returns; the log's
`service-mapper: ...: success` line
and the channel grid are the truth,
in that order. Poll before concluding
(chapter 7's transcript polls: 0, then
1).

## A recording is missing, short, or "Time missed"

Three different diseases, one symptom
family. Read the finished entry and
probe the file, as chapter 10
teaches:

- **No input detected / Time missed**:
  at recording time the input produced
  nothing. Check what the input *is* —
  a drained file, a dead source, a
  tuner busy elsewhere.
- **Completed OK but short**: the
  input gave out mid-window. The entry
  counts errors in the stream, not
  minutes missing from it; the file's
  measured duration is the verdict.
- **Wrong folder entirely**: the DVR
  profile's storage was never set and
  the recording went to the default —
  the home directory warning at
  startup (chapter 10) names it.

## The guide is empty

Chapter 9: your sources sent nothing,
or the XMLTV import is not matched to
channels. An empty guide with healthy
channels is a data problem, never a
tuning problem. Fix the source; do
not rescan the muxes.

## Playback is black, silent, or the wrong programme

With `profile=pass`, the server
relabels, at most; it does not repair.
Probe what you captured and compare
its streams with the service record's
PIDs. A stream that is wrong at the
service is wrong at the source — the
post room delivered the parcel it was
handed.

Check: for whatever brought you here,
find its log line or its API record
before changing anything. Every
failure in this chapter was diagnosed
from evidence the server had already
written down.
