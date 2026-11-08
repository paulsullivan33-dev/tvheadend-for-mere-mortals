# The neighbours

Outcome: where TVHeadend sits among
the programs a household might pick
instead — characterised from what each
is for, not benchmarked, since the lab
ran only one of them.

## Media servers that also record: Plex, Jellyfin, Emby

The big media servers organise the
films and programmes you *have*;
several also grew live-TV and DVR
features fed by network tuners. Their
centre of gravity is the library and
the polished app on every platform.
If your television life is mostly a
library, with some live viewing on the
side, they are the natural home.
TVHeadend's centre of gravity is the
other end: the inputs. More tuner
kinds, more mux-level control, guide
plumbing, and recording rules — and a
comparatively plain face. The two
meet happily in practice: a common
pattern is TVHeadend receiving and
recording, and a media server (or
Kodi) presenting. This guide covers
TVHeadend's half of that pattern.

## MythTV

The other long-lived open-source DVR:
a full home-theatre system with its
own frontend, its own guide handling,
and decades of tuner support. MythTV
is a bigger, more integrated
commitment — backend and frontend as
one project, a database underneath,
scheduling of real sophistication.
TVHeadend is narrower and lighter: a
server only, expecting Kodi or other
clients to be the face. Households
choose between them on how much
system they want to own, not on which
"wins" — they record the same
television.

## VDR and the tuner specialists

**VDR** (Video Disk Recorder) is the
quiet veteran of Linux satellite and
terrestrial recording, close to the
hardware, plugin-extended. Satellite
households in particular may find
their exact card and CAM arrangements
best covered there. TVHeadend covers
the same ground with a more
network-first, client-server shape.

## The players are not rivals

**Kodi**, **VLC**, and friends appear
in this guide as clients, and it is
worth saying plainly that they do not
substitute for a backend: a player can
open a stream address, but it does not
scan muxes, hold a guide, arbitrate
tuners, or record while you sleep.
Kodi alone on a television plus
TVHeadend behind it is the standard
pairing precisely because each does
its own half.

## The broadcast world's own relays

Network tuners (HDHomeRun) and
SAT>IP boxes are hardware neighbours:
they turn an aerial or dish signal
into network streams a house can use
directly — and TVHeadend is also
their most common customer, adding the
guide, mapping, and recording they do
not carry themselves. Choosing one
does not close the TVHeadend question;
it usually opens it.

Check: name your need in one
sentence — library first, inputs
first, integrated system, or just a
player. The sentence picks the
neighbourhood; this guide's tool owns
the "inputs first, server only"
house.
