# Limits

By the end of this chapter you can
recite what TVHeadend cannot do —
each limit stated with the evidence or
the reasoning that backs it.

## It cannot invent signal

A scan of a quiet mux finds nothing, a
subscription to a dead stream receives
nothing, and a recording of silence is
a file of silence — or, as chapter 10
measured, a file of whatever fragment
arrived: 30 seconds requested, about
11 seconds kept, zero errors reported.
Reception problems — aerial, dish,
cable, source server — stay reception
problems. TVHeadend reports them
honestly and fixes none of them.

## It cannot invent rights

A service whose stream is encrypted
arrives encrypted. TVHeadend can work
with legitimate decryption hardware
and card clients where they exist
(conditional-access support is part of
the project), but a channel you have
no entitlement to stays dark, and DRM
protected sources stay closed. That is
not a missing feature and this guide
does not treat it as one: the relay
passes what it is given, and what it
is given for a paid channel, without
the subscription story, is a locked
parcel. The lab's one service was
unencrypted (`encrypted: false` in its
record); no encrypted stream was
tested, and none would have opened
without the hardware and entitlement
to match.

## The guide is only as good as its source

Chapter 9's empty guide is the small
version of a general truth: listings
come from broadcasters' tables or
external files, their quality is the
source's quality, and matching them to
channels is name-and-number plumbing
that can silently mismatch. A
recording schedule built on a bad
guide records the wrong thing
punctually.

## One mux at a time per tuner

A tuner receives one mux — one
frequency's bundle — at a time. Two
viewers on services inside that bundle
share the tune; a viewer, a
recording, and a scan asking for three
different muxes need three inputs'
worth of hardware. IPTV inputs relax
this to bandwidth and stream-count
limits, but every input has a number,
and subscriptions queue or fail when
it is exceeded. The lab's IPTV input
ran two threads and never felt the
limit; the limit is stated from the
architecture, not from a lab failure.

## Transcoding is a CPU question

Chapter 13 in one line: re-encoding is
bought with processor, per stream,
continuously. "Supports transcoding"
on a feature list says nothing about
your box at your household's peak.

## It is a server, not a player, a library, or a source

No part of TVHeadend films anything,
stores a media library, or repairs a
bad stream's picture. Within its
remit it is complete; outside it, it
does not pretend. And its remit is
bounded by the rule this guide opened
with, which is the limit under all
the others: **no signal in means no
television out.**

Check: for any planned TVHeadend job,
name its input, its rights, its guide
source, and its tuner arithmetic. If
one of the four has no answer, you
have found the limit that will find
you first.
