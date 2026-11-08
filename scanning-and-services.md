# Scanning and services

Outcome: a finished scan, one real
service where before there was only an
address — and the vocabulary to read
any scan result TVHeadend reports.

## What a scan actually does

A scan is TVHeadend opening a mux's
stream and reading its **tables** —
the small, repeating data structures
inside a transport stream that
describe the stream itself. The lab's
scan, in the server's own log
(transcript
`tvheadend-lab/transcripts/t05-network-and-file-scan.txt`),
is the whole broadcast model in nine
lines:

```
tbl-base: sdt: onid 0001 (1) tsid 0001 (1)
tbl-base: pat:  sid 0001 (1) on pid 1000 (4096)
tbl-base: pmt: sid 0001 (1)
tbl-base: pmt:  pid 0100 estype 2
tbl-base: pmt:    type MPEG2VIDEO position 0
tbl-base: pmt:  pid 0101 estype 3
tbl-base: pmt:    type MPEG2AUDIO position 1
tbl-base: sdt:  nicename Lab Loopback Network/Harbour Light Mux/Harbour Light Test
```

- The **PAT** (programme association
  table) lists the programmes: one,
  service ID 1, described by table
  PID 4096.
- The **PMT** (programme map table)
  lists that programme's pieces: PID
  256 is MPEG-2 video, PID 257 is
  MPEG audio.
- The **SDT** (service description
  table) carries the human names:
  network, mux, and the service name
  *Harbour Light Test* — the metadata
  ffmpeg wrote, arriving back through
  a scan. The stream described itself;
  TVHeadend invented nothing.

## Reading a scan's progress

Two fields on the mux report progress,
and both are enumerations the API
itself defines (transcript
`tvheadend-lab/transcripts/t05b-scan-enums.txt`):

- `scan_state`: 0 IDLE, 1 PEND
  (queued), 2 IDLE PEND, 3 ACTIVE
  (tuned right now).
- `scan_result`: 0 NONE, 1 OK, 2 FAIL,
  3 OK (partial), 4 IGNORE.

The lab polls the file mux four times,
three seconds apart: `PEND / NONE /
num_svc 0`, three times — then `ACTIVE
/ num_svc 1, onid 1 tsid 1`. The real
IDs replaced the 65536 placeholders
the moment the tables were read, and
the service count is the proof that
matters: a scan that finds nothing is
not a slow scan, it is an answer about
the stream. Notice the result field
still reads NONE in that last poll —
the mux was still tuned (ACTIVE, doing
guide duty, chapter 9) and the result
is written as scans settle. Judge a
scan by the services it created, then
by the result; the pipe mux in
chapter 11 shows the settled pair,
`scan_result 1` (OK) with `num_svc 1`.

## The service, whole

The scan's product, from
`/api/mpegts/service/grid`, is a
service record: name *Harbour Light
Test*, provider *Fictional Workshop*,
`sid 1`, service type 1 (television),
`encrypted: false`, on network *Lab
Loopback Network*, mux *Harbour Light
Mux* — and `channel: []`, an empty
list. That empty list is the honest
state of the world: the service
exists, it can be tuned, and no viewer
can see it yet, because services are
not channels. Mapping is a separate,
deliberate step, and it is next.

A failure note, since this chapter is
where failures live: had the fixture
been a text file renamed `.ts`, the
scan would have queued, tuned, found
no tables, and finished FAIL with zero
services, and the log would show the
input opening and silence where the
table lines are. The scan cannot fix
the stream. Chapter 1's rule again:
it relays — and reports — what it is
handed.

Check: after a scan, count the
services on your mux (`num_svc` on the
mux, or the Services tab). If the
count and the names match what your
stream claims to carry, the scan told
the truth, and you are ready to map.
