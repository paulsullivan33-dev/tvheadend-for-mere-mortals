# Installing TVHeadend

Outcome: TVHeadend on the machine,
proved by the version check every
route must pass — and an honest
account of the route this guide ran,
the crash it hit first, and the routes
it only read about.

## The check

However TVHeadend arrives, the proof
is one command:

```
tvheadend --version
```

The lab's copy answers (transcript
`tvheadend-lab/transcripts/t01-download-extract-version.txt`):

```
./extracted/usr/bin/tvheadend: version 4.3-2937~g0589ce006
```

Capture `--help` too before trusting
any of it; the lab kept the full text
(`tvheadend-lab/transcripts/t02-help.txt`),
and every flag the later chapters use —
`--http_port`, `--htsp_port`,
`--bindaddr`, `-c` for the
configuration folder, `-C` for first
run — is in it, spelled as shown there.

## The route the lab used: the project's package, extracted

The project publishes its current 4.3
line through its own package
repository (hosted on Cloudsmith). For
Ubuntu 24.04, codename **noble**, the
repository index offered, as its first
entry:

```
Package: tvheadend
Version: 4.3-2937~g0589ce006~noble
Filename: pool/noble/main/t/tv/tvheadend_4.3-2937~g0589ce006~noble/tvheadend_4.3-2937~g0589ce006~noble_amd64.deb
Size: 17546778
SHA256: 548dc5522fc05b8c37173e3546d91266cb9d5207eea1c35d5a7b44c101c919d0
```

The lab downloaded that single `.deb`
file — 17,546,778 bytes, and the
download's SHA256 matched the index
exactly — then **extracted** it with
`dpkg-deb -x` instead of installing
it. Nothing was registered with the
system package manager, and no service
was created.

An extracted binary has to find its
libraries itself. `ldd` reported
exactly two missing:

```
libdvbcsa.so.1 => not found
libpcre.so.3 => not found
```

Both are ordinary Ubuntu noble
packages (`libdvbcsa1` and `libpcre3`,
the very dependencies the index entry
names). The lab downloaded those two
`.deb` files with `apt-get download`,
extracted them the same way, and put
their library folders on
`LD_LIBRARY_PATH`. After that,
`ldd` reported a not-found count of
zero, and the version check above
passed. The machine's own apt sources,
for the record, held no TVHeadend
package at all (transcript
`tvheadend-lab/transcripts/t00-environment.txt`).

## The crash that taught the data-file lesson

The first attempt to run the extracted
binary failed, and the failure is kept
on record
(`tvheadend-lab/drivers/first-attempt-crash-excerpt.txt`).
The server opened both of its
listeners, then:

```
[ ALERT] profile: no default streaming profile! reinstall data files
[ ALERT] CRASH: Signal: 6 in PRG: ./extracted/usr/bin/tvheadend (4.3-2937~g0589ce006)
```

The binary looks for its data tree —
web interface, default profiles,
scan lists — at the compiled-in
absolute path `/usr/share/tvheadend`.
An extracted copy in a scratch folder
is not there, and without its data
files the server gives up. On a normal
install this never happens, because
the package puts the files where the
binary expects them. The lab's answer
was to run the server inside a private
**mount namespace** — a per-process
view of the filesystem — and
bind-mount the extracted data tree
over that path inside the namespace
only (`tvheadend-lab/drivers/run-in-namespace.sh`).
The host system kept nothing but an
empty mount-point directory, which
the lab removed again afterwards. If
you install the package properly, skip
this paragraph entirely; it is a
lab-extraction problem, not a
TVHeadend problem.

## The other routes, honestly labelled

- **Install the same repository
  properly.** The project's download
  page offers a setup script that adds
  the repository to apt, after which
  `apt install tvheadend` does what
  the lab did by hand, plus system
  integration. The lab verified the
  repository's contents and used its
  package; it did not run the setup
  script or install system-wide.
- **Docker.** The project and the
  well-known linuxserver image both
  publish TVHeadend containers. This
  machine has the Docker client (29.1.3)
  but **no running daemon** —
  `docker info` answers "failed to
  connect to the docker API at
  unix:///var/run/docker.sock" — so
  the container route could not be
  tested here at all (transcript t00).
  Documented only.
- **Building from source.** The
  project's source needs a long list
  of development libraries that this
  machine does not have. With the
  package route working, the lab did
  not attempt it. Documented only, by
  deliberate timebox rather than by
  failure.

Check: `tvheadend --version` prints
4.3-something, and `ldd` (for an
extracted copy) reports nothing "not
found". If both hold, chapter 4 starts
the server.
