# What TVHeadend is

By the end of this chapter you can say,
in one sentence, what TVHeadend does
with television — and state the one
rule that decides whether it can help
you at all.

## The problem it sits in the middle of

Television reaches a home through
hardware and feeds that were never
designed for a house full of screens.
A tuner card receives one broadcaster's
bundle at a time. A network stream
arrives as an address most players
cannot open on their own. Nothing in
that chain keeps a list of channels,
knows what is on tonight, or saves a
programme for later.

**TVHeadend** (the project spells its
server "Tvheadend") is a program that
takes that job over. It is a **TV
streaming server** and **recorder**
for Linux. It connects to inputs —
broadcast tuners for terrestrial,
cable, and satellite television,
network tuners, satellite-over-IP
boxes, and plain **IPTV** streams
(television carried over a network as
data) — and it republishes what they
carry as channels that ordinary
players on your network can watch,
with a programme guide and a
**DVR** (digital video recorder) that
keeps programmes as files.

Its own package description, from the
repository index the lab downloaded
(transcript
`tvheadend-lab/transcripts/t01-download-extract-version.txt`),
says it in two lines: "Tvheadend is a
TV streaming server and digital video
recorder" supporting DVB, IPTV,
SAT>IP, and HDHomeRun inputs. This
guide's lab ran version
**4.3-2937~g0589ce006**.

## The rule: a post room, not a broadcaster

TVHeadend does not make television. It
receives finished streams, sorts them,
and passes them on — to a player now,
or to a file for later. So:

> **TVHeadend only ever relays what a
> tuner or a stream hands it — it is a
> post room, not a broadcaster: no
> signal in means no television out,
> and every recording is just a stream
> it was given, kept.**

Every chapter leans on this rule,
because it predicts both the successes
and the failures:

- A **scan** (chapter 6) can only find
  the services a stream actually
  carries. The lab's stream carried
  one invented service, and exactly
  one service is what the scan found.
- A **recording** (chapter 10) can
  only keep what arrives during its
  window. Asked for 30 seconds of a
  short file stream that was nearly
  spent, TVHeadend reported success —
  and the file it kept measured about
  11 seconds, because that is what it
  was given.
- The **programme guide** (chapter 9)
  can only show data a source sent.
  The lab's stream sent none, so the
  guide held zero events. An empty
  guide was the correct result.

A post room metaphor also keeps the
responsibility straight. TVHeadend
will faithfully relay a broken,
encrypted, or mislabelled stream,
because relaying is the job. What
comes in is a question about your
inputs, your aerial, and your rights
to the content — chapters 15 and 16
keep returning to that line.

## Where it comes from

TVHeadend is a free, open-source
project at tvheadend.org. The 4.3 line
is its current rolling release,
published as packages for Debian and
Ubuntu systems through the project's
own repository, and as source. It is
most often paired with **Kodi**, the
media-centre program, whose TVHeadend
client speaks TVHeadend's own **HTSP**
protocol; other players reach it over
plain HTTP. This guide runs everything
on one machine, talking to itself on
loopback, exactly as the series'
other labs do.

Check: say what TVHeadend takes in,
what it hands out, and then say the
rule out loud once. If you can do all
three, you have this chapter.
