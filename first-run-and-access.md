# First run and access

Outcome: a running server on loopback,
its web door answering, its version
confirmed over the wire — and a clear
look at the shortcut that makes a
first run easy and a public run
dangerous.

## The lab's starting line

The lab started its extracted server
like this (the namespace wrapper from
chapter 3 supplies the data files):

```
tvheadend -C -c <scratch>/config \
  --bindaddr 127.0.0.1 \
  --http_port 18091 --htsp_port 19091
```

Three choices in that line matter:

- **`-c`** names the configuration
  folder. Fresh and empty, on purpose:
  everything the server learns, it
  learns in front of you.
- **`--bindaddr 127.0.0.1`** with the
  two port flags moves both doors —
  web from 9981 to **18091**, HTSP from
  9982 to **19091** — and keeps them on
  loopback. A real install serving a
  home binds to the home network
  instead; the lab serves only itself.
- **`-C`** is first-run mode, and the
  next section is about nothing else.

The log's opening lines are the doors
opening (transcript
`tvheadend-lab/transcripts/t04-first-run.txt`):

```
[   INFO] http: Starting HTTP server 127.0.0.1:18091
[   INFO] htsp: Starting HTSP server 127.0.0.1:19091
```

## What -C really does

`--help` says it without decoration:
if no user account exists, `-C`
creates one "with no username and no
password", and warns to "use with care
as it will allow world-wide
administrative access to your
Tvheadend installation until you
create or edit the access control".
The first run shows the warning made
real:

```
[WARNING] access: Created default wide open access controle entry
```

(the spelling of "controle" is the
server's own). On loopback, for one
lab session, that trade is fine: no
login stands between the lab's
requests and the API answers the later
chapters quote. On any network other
people can reach, it is not fine, and
chapter 12 covers making real
accounts. Treat `-C` the way you would
a ladder left against an open window:
useful for the first entry, removed
before you walk away.

## Proof it lives

Three checks, all in transcript t04:

1. The web door answers. `GET /`
   returns a redirect to the interface:
   `HTTP/1.1 302 Found`, `Server:
   HTS/tvheadend`, `Location: /gui/`.
2. The API answers with the version:
   `{"sw_version":"4.3-2937~g0589ce006","api_version":20,"name":"Tvheadend",...}`
   — the same version the binary
   reported, now over the wire, with
   API version 20.
3. Both ports are listening sockets on
   127.0.0.1, and the HTSP port accepts
   a TCP connection. HTSP itself is a
   binary protocol, not something
   `curl` speaks; the lab verified the
   door is open and left the protocol
   conversation to real clients
   (chapter 8, documented for Kodi).

Startup also loads the bundled
scan-file lists — the log counts "DVB-T
- loaded 46 regions with 1171
networks" among them. Those lists are
how a tuner knows what frequencies to
try in your region. The lab never used
them: it had no tuner and scanned a
stream, not the air. They are named
here so the log line is not a mystery
later.

Check: fetch `/api/serverinfo` from
your server and read the version back.
If the number over the wire matches
the number from `--version`, your
server is up and it is the one you
installed.
