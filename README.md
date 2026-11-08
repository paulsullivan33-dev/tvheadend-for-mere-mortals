# TVHeadend for Mere Mortals

Television arrives at a house in the
wrong shape. A tuner card, a satellite
box, an aerial, a network stream — each
speaks its own dialect, none of them
speak "every screen in the home", and
none of them remember what was on while
you were out. **TVHeadend** is the
server that sits in the middle: it takes
television in from tuners and streams,
gives it a channel list, a programme
guide and a recorder, and hands it back
out over your network to the players you
already have.

One rule governs everything it does,
and this guide states it in chapter 1
and keeps pointing back to it:
**TVHeadend only ever relays what a
tuner or a stream hands it — it is a
post room, not a broadcaster.** No
signal in means no television out, and
every recording is just a stream it was
given, kept. The lab behind this guide
proved the rule both ways. A scan of a
stream the lab made itself found a real
service and turned it into a channel. A
recording asked to keep 30 seconds of a
short, one-shot file stream was closed
by TVHeadend as a success — and the file
it kept held about 11 seconds, because
that is all the stream had left to give.

The lab ran the real thing:
**Tvheadend 4.3-2937~g0589ce006**, the
project's own Ubuntu noble package,
downloaded as a `.deb`, checked against
the repository's published SHA256, and
extracted — never installed — on an
Ubuntu 24.04 machine. Against it the
lab generated a fictional 20-second
test stream with ffmpeg (a test pattern,
a tone, and invented service metadata),
created an IPTV network and a mux
pointing at that file, watched the scan
read the stream's tables and create a
service called *Harbour Light Test*,
mapped that service to a channel,
played the channel back through
TVHeadend's own stream address, and
recorded it twice: once from the file,
where the result fell short in the way
described above, and once from a pipe
that loops the same stream forever,
where a 35-second window produced a
34.45-second recording with zero
errors. The programme guide chapter is
honest about its zero: the fixture
stream carries no guide data, so the
guide stayed empty, and everything
beyond that is labelled documented-only.

What the lab could not do, it did not
fake. This machine has no tuner
hardware and no Docker daemon, so real
broadcast reception and the container
route are described from the project's
documentation and labelled. The lab
never pointed TVHeadend at a real
broadcast source or an external stream:
every byte it handled was a byte the
lab made. `criteria.md` keeps the full
ledger of what was run and what was
only read.

## What this guide covers

- [**What TVHeadend is**](what-tvheadend-is.md) —
  the relay between inputs and screens,
  and the one rule
- [**The moving parts**](the-moving-parts.md) —
  inputs, networks, muxes, services,
  channels, the guide, and the recorder
- [**Installing TVHeadend**](installing-tvheadend.md) —
  the package the lab extracted, the two
  libraries it needed, the crash that
  taught the data-file lesson, and the
  routes the lab did not take
- [**First run and access**](first-run-and-access.md) —
  the first-run flag, the wide-open
  warning it prints, both ports, and
  the version answer that proves it lives
- [**Your first network and mux**](your-first-network-and-mux.md) —
  an IPTV network and a mux whose
  address is a local file, created the
  way the lab created them
- [**Scanning and services**](scanning-and-services.md) —
  how a scan reads a stream's tables,
  the scan states and results, and the
  service a good scan creates
- [**Mapping services to channels**](mapping-services-to-channels.md) —
  the mapper, the channel it makes, and
  the playlist TVHeadend publishes
- [**Watching and clients**](watching-and-clients.md) —
  playing a channel over HTTP, what the
  lab measured, and the HTSP clients
  described from documentation
- [**The programme guide**](the-programme-guide.md) —
  where guide data comes from, why the
  lab's guide is empty, and why that is
  the honest result
- [**Recording**](recording.md) — DVR
  storage, a manual recording, the one
  that fell short, and the one that did not
- [**Pipe and file inputs**](pipe-and-file-inputs.md) —
  the three shapes an IPTV address can
  take, and why an endless stream needs
  a pipe that loops
- [**Access and users**](access-and-users.md) —
  accounts, the first-run shortcut's
  cost, and who may watch, record, or
  administer
- [**Profiles and transcoding**](profiles-and-transcoding.md) —
  the pass profile the lab played and
  recorded with, and why re-encoding is
  a processor question
- [**Real jobs**](real-jobs.md) — a home
  recorder, a household channel list,
  and the lab itself as a test bench
- [**The neighbours**](the-neighbours.md) —
  media servers with DVR features,
  MythTV, and players that need a backend
- [**Limits**](limits.md) — no signal,
  no rights, a guide only as good as
  its source, and one mux per tuner
- [**Troubleshooting**](troubleshooting.md) —
  the crash with no data files, the scan
  that finds nothing, and the recording
  that comes back short
- [**Glossary**](glossary.md) — the
  terms, collected in one place

## What it doesn't cover

Receiving real broadcasts. There is no
tuner in the lab machine, so choosing
an aerial, a dish, or a cable card,
pointing it, and reading real
transmitter lists are described only
where the documentation supports them
and labelled every time. Unscrambling
paid channels is covered only as a
limit, stated plainly: encrypted
channels stay dark without the hardware
and the entitlement, and this guide
does not teach workarounds. Nothing
here touches a real broadcaster's
stream or programme data.

## How to use this guide

Read chapter 1 for the rule and
chapter 2 for the map of parts.
Chapters 3 and 4 get a server running
and checked. Chapters 5 to 8 build the
chain the whole system hangs on —
network, mux, scan, service, channel,
playback — in the order the lab built
it. Chapter 11 is the one to read
before you trust a recording schedule:
it explains why the shape of an input
decides what a recording can keep. The
lab lives in `tvheadend-lab/`: the
fixture stream in `fixtures/`, the
driver scripts in `drivers/`, and every
claim's evidence in `transcripts/`. Its
distilled commands are
`examples/commands.txt` and its notes
`examples/lab-notes.txt`.

---

## Part of the series

This guide is one of the [For Mere Mortals](https://paulsullivan33-dev.github.io/mere-mortals/) guides: plain-language guides to the tools programmers and makers use.

Related guides:

- [Text Processing for Mere Mortals](https://paulsullivan33-dev.github.io/text-processing-for-mere-mortals/)
- [Vim for Mere Mortals](https://paulsullivan33-dev.github.io/vim-for-mere-mortals/)
- [Markdown for Mere Mortals](https://paulsullivan33-dev.github.io/markdown-for-mere-mortals/)

## License

The writing in this guide is licensed under [CC BY 4.0](https://github.com/paulsullivan33-dev/tvheadend-for-mere-mortals/blob/main/LICENSE). Code examples and lab scripts are licensed under the [MIT License](https://github.com/paulsullivan33-dev/tvheadend-for-mere-mortals/blob/main/LICENSE-CODE).
