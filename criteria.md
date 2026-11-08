# Writing criteria for this guide

Every "for Mere Mortals" guide is written to the same nine-point
standard, so a reader who trusts one can trust the rest. Here it
is, with the verification notes for this particular guide below.

1. **Fix it first.** Reader outcomes lead, not action items: each
   chapter opens by naming the outcome it delivers, shows a check
   the reader can run to confirm they got it, and a reasonable
   reader finishes able to state what was done, what it means,
   and what to try next.
2. **Plain language.** Short sentences, everyday vocabulary,
   technical terms defined on first use. No slang, and no
   idioms that only make sense in one country — the reader may
   be translating as they go.
3. **No dead ends.** A guide never tells the reader to do
   something it cannot show them how to verify. Every claim a
   reader relies on — an install, a command, an output — is
   something this guide demonstrates or clearly labels
   documented-only below.
4. **Live-verified where it matters.** Procedures are run for
   real in the guide's lab wherever the build machine allows it,
   and the transcripts kept in the repository are the evidence.
   What could not be run is listed honestly below, never
   presented as if it had been.
5. **General audiences.** Nothing in this guide — examples,
   fixtures, names, addresses — is modelled on any particular
   reader or author's real life, network, or organisations.
   The lab's traffic is the lab talking to itself.
6. **Standalone.** A reader needs this guide, its lab, and
   nothing else. Where another guide would genuinely help, it
   is pointed to once, by name, and the chapter still completes
   without it.
7. **Honest about limits.** The limits chapter names what the
   tool cannot do: it cannot invent signal or rights — a dead
   input yields nothing and an encrypted channel stays dark
   without the decryption hardware and the entitlement to it;
   its programme guide is only as good as the source that sent
   the data, and an empty source yields an honestly empty
   guide; one tuner receives one mux — one frequency's worth
   of channels — at a time, so viewers, scans, and recordings
   contend for inputs; and transcoding is a CPU question, not
   a feature checkbox, bought per stream for as long as it
   runs. Its own reports need checking too: a recording can be
   closed as Completed OK with zero errors and still hold a
   fraction of the window it was asked for, because it can
   only keep the stream it was given.
8. **The one rule is in the text, early.** Chapter 1 and the
   README state the rule plainly — *TVHeadend only ever relays
   what a tuner or a stream hands it; it is a post room, not a
   broadcaster: no signal in means no television out, and
   every recording is just a stream it was given, kept* —
   before any procedure depends on it, and later chapters point
   back to it where the rule bites: the scan that finds only
   what the stream carries, the guide that stays empty when no
   data is sent, and the recording that keeps 11 seconds of a
   30-second window because that is what the input had left.
9. **Builds clean.** The site builds with MkDocs in strict mode
   with no warnings, and a fresh reader following the chapters
   in order reaches the stated outcome of each.

## Verification notes for this guide

The build machine is an Ubuntu 24.04 (noble) sandbox.
Tvheadend **4.3-2937~g0589ce006** was the project's official
Ubuntu noble package (`tvheadend_4.3-2937~g0589ce006~noble_amd64.deb`,
17,546,778 bytes) from TVHeadend's own repository on
Cloudsmith; the download's SHA256 matched the repository
index exactly. The package was **extracted** with
`dpkg-deb -x`, never installed. Two libraries the binary
needed were absent (`libdvbcsa.so.1`, `libpcre.so.3`); the
corresponding Ubuntu noble packages were downloaded and
extracted the same way, after which `ldd` reported zero
missing libraries. The extracted binary expects its data
tree at `/usr/share/tvheadend`; the first run without it
crashed (kept on record) and the lab's working runs supplied
the tree inside a private mount namespace instead of
installing anything. The server ran bound to 127.0.0.1
only, web port 18091, HTSP port 19091, with its
configuration in lab scratch, never a home directory.
ffmpeg 8.1.2 generated the fixture stream. The lab is in
`tvheadend-lab/`: the fixture (`fixtures/harbour-light.ts`,
a fictional 20-second MPEG-TS made by ffmpeg: test pattern,
440 Hz tone, MPEG-2 video, MP2 audio, service name "Harbour
Light Test", provider "Fictional Workshop"), driver scripts
(`drivers/run-lab.sh`, `run-in-namespace.sh`,
`serve-test-stream.sh`), and the evidence in
`transcripts/`. All lab traffic was loopback; the server was
never pointed at a real broadcast source or external stream.

Run for real, with transcripts as evidence:

- Version and the full `--help` text (t01, t02), after the
  `ldd` fix above; the flags the guide uses are quoted from
  that help text. The machine's own apt sources hold no
  tvheadend package (t00).
- The Docker route checked and closed: Docker client 29.1.3
  is installed but there is **no daemon** — `docker info`
  and `docker run` both fail to connect to
  /var/run/docker.sock (t00). No container was run.
- The first-attempt crash: without its data tree visible,
  the server started both listeners, logged "profile: no
  default streaming profile! reinstall data files", and
  crashed with signal 6 (kept excerpt in `drivers/`).
- First run with `-C` (t04): log lines for the HTTP server
  on 127.0.0.1:18091 and the HTSP server on 127.0.0.1:19091,
  the "Created default wide open access controle entry"
  warning, `GET /` returning 302 to `/gui/`,
  `/api/serverinfo` returning version 4.3-2937~g0589ce006
  and API version 20, both sockets listening, and a
  successful TCP connect to the HTSP port.
- The fixture stream itself (t03): ffprobe shows one
  programme, service name and provider as generated, two
  streams (mpeg2video 320x240, mp2). File size 1.5 MB.
- Network and mux creation through the API the web
  interface itself uses (t05): `POST
  /api/mpegts/network/create` (class `iptv_network`) and
  `POST /api/mpegts/network/mux_create` (class `iptv_mux`,
  URL `file://` the fixture). Two wrong doors are kept in
  the record: the general save endpoint returns 400 for
  creates, in exploration and as chapter 17 describes.
- The file mux scan (t05): polls go PEND/NONE/0 services to
  ACTIVE with `num_svc 1` and real IDs (onid 1, tsid 1)
  replacing the 65536 placeholders; the log's table lines
  show the PAT naming SID 1 on PID 4096, the PMT naming
  MPEG2VIDEO and MPEG2AUDIO, the SDT naming the service.
  The created service: "Harbour Light Test", provider
  "Fictional Workshop", SID 1, `encrypted: false`, channel
  list empty. The scan state/result enumerations were read
  from the API itself (t05b).
- Mapping (t06): the service mapper is asynchronous — the
  channel grid polled 0, then 1 — and its log line records
  success. The channel: name "Harbour Light Test",
  autoname, enabled, the scanned service in its services
  list, two tags. `GET /playlist/channels` publishes the
  channel with its `/stream/channelid/...` address and
  `profile=pass`.
- Playback (t06): 8 seconds fetched from
  `/stream/channel/<uuid>?profile=pass` arrived as 952K of
  data, identified by ffprobe as mpeg2video + mp2 — the
  fixture's own streams, relayed.
- EPG (t07): the log shows the mux "registering mux for
  OTA EPG" and the grabber modules created at startup;
  `GET /api/epg/events/grid` returned `totalCount 0`. The
  fixture carries no EIT tables, so zero is the measured,
  correct result; nothing was staged to fill it.
- DVR storage set before recording (t08): the default
  profile's unconfigured-storage warning (it defaults to
  the home folder) is in the startup record; the lab set
  the profile's `storage` to the scratch recordings folder
  through the API and read the value back.
- Recording from the file mux (t08): manual entry, 30-second
  window. The finished record says duration 30, status
  "Completed OK", errors 0, data_errors 0, filesize
  750,308 — and ffprobe measures the file at **10.93
  seconds**. Both numbers are quoted; the file was short
  because the one-shot file stream had only that much left
  to give. In exploration the same attempt failed outright
  twice ("Recording unable to start: No input detected",
  ending "Time missed"); those log lines are kept in
  `drivers/file-recording-failures-excerpt.txt`.
- The pipe mux (t09): mux URL rewritten to
  `pipe://` the lab's wrapper script (ffmpeg looping the
  fixture at natural rate, service metadata rewritten),
  respawn on; after a server restart the log shows
  `spawn: Executing` the script, an ffmpeg process owned by
  the server, and the mux at scan_state ACTIVE,
  **scan_result 1 (OK)**, `num_svc 1`, the service found
  again under its fictional name. Playback from the pipe
  mux: 540K in 8 seconds. A mid-flight URL edit without
  the restart left the mux in a bad-service state during
  exploration; the guide says to restart, because that is
  what the lab had to do.
- Recording from the pipe mux (t09): manual entry,
  35-second window, tracked by its own UUID past the
  earlier finished entry. Finished record: duration 35,
  "Completed OK", errors 0, data_errors 0; the file
  measures **34.45 seconds**, 2.6 MB, mpeg2video + mp2.
  Side by side with the file-mux recording (733K, ~11 s),
  it is the guide's central measurement.

Documented only — described from the project's
documentation, `--help`, API forms, or the program's own
interface text, not run, and the text does not claim
otherwise:

- All real broadcast reception: tuners of every kind
  (DVB-T/T2, DVB-C, DVB-S/S2, ATSC, ISDB), aerials and
  dishes, the bundled per-region scan lists (their loading
  was observed in the log; no list was used), network
  tuners (HDHomeRun), and SAT>IP clients and the SAT>IP
  server side (advertised in serverinfo, never connected).
- IPTV muxes over `http://`, `https://`, and `udp://`, and
  IPTV Automatic Networks fed by M3U playlists.
- The Docker route (no daemon on this machine) and
  installing the repository the normal `apt` way,
  including the project's setup script and the packaged
  system service and `hts` user.
- Building from source: not attempted, by the lab's
  timebox, not by failure.
- HTSP conversations and real clients (Kodi and its
  TVHeadend add-on above all): the lab proved the port
  listens and accepts a TCP connection; no client spoke
  the protocol.
- A populated EPG: XMLTV import and matching, OpenTV,
  PSIP, and real streams' EIT. The grabbers exist and the
  mux registered; the only measured guide content is zero.
- Recording by guide event, autorec rules, and timerec;
  retention, removal, and filename-pattern behaviour
  beyond the defaults read from the lab's DVR profile.
- User accounts and narrowed access entries: the only
  access state run is the `-C` wide-open entry, on
  loopback; creating real accounts is described, not run.
- Transcoding profiles in action: the build registered
  its codec machinery at startup (observed in the log);
  every measurement used `profile=pass`, and no
  transcoding profile was run.
- Encrypted services and conditional access: the lab's
  service was unencrypted; descrambling is covered only
  as a stated limit.
- The neighbouring tools in chapter 15 are characterised,
  not benchmarked.

Fixtures are this guide's own and deliberately generic: one
invented test channel with an invented provider, generated
by ffmpeg on the lab machine. No example is modelled on any
real broadcaster, programme, person, network, service, or
organisation.
