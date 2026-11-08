# Access and users

Outcome: who can do what to a
TVHeadend server — the account model,
the wide-open first run judged
plainly, and the settings a real
household should make before anyone
else connects.

## The model

TVHeadend's access control lives in
**access entries**: records that match
a username and password, an address
range, or both, and grant a bundle of
rights. The bundles that matter, in
the vocabulary the interface uses:

- **Streaming** — may watch and listen
  (the HTTP and HTSP doors).
- **Video recorder** — may create,
  edit, and delete recordings, in
  plain and advanced flavours.
- **Administration** — may change
  configuration: networks, muxes,
  users, everything in this guide.
- **Web interface** — may use the
  browser UI at all.

An entry can also limit which
channels, tags, and DVR profiles its
holder sees, which is how a household
gives children a smaller television
than the full one. Users are managed
under Configuration, Access Entries;
passwords are set there and stored in
the configuration folder.

## The first-run entry, judged

The lab ran with `-C`, and its server
created what the log calls a "default
wide open access controle entry":
no username, no password, all rights,
from anywhere. The guide keeps this
front and centre rather than tidying
it away, because it is the state a
surprised number of real installs are
found in. The properties of that
entry, stated flatly:

- On the lab's loopback binding, its
  audience was one machine, briefly.
  Acceptable for a lab, chosen on
  purpose.
- On a home network binding, its
  audience is everything on the
  network — including anything
  compromised or merely curious.
- On any port forwarded to the
  internet, it is a public
  administration panel for a program
  that can run pipe commands
  (chapter 11) as the server's user.
  There is no reading of that sentence
  that ends well.

Creating the first real account —
an administration entry with a name
and a strong password — and then
deleting or narrowing the wide-open
entry, is the documented first-run
wizard's whole job, and chapter 4's
warning is the standing instruction:
do it before the server serves anyone
else. The lab did not create accounts:
with `-C` and loopback it had no
audience to protect, so account
creation here is **documented only**,
described from the interface and the
documentation, and the wide-open entry
is the only access state this guide
claims to have run.

## Two practical notes

**The server's user is the pipe's
user.** TVHeadend normally runs as its
own `hts` account on a packaged
install; the lab ran it as the lab's
own user inside its namespace.
Whichever account runs the server is
the account whose files pipe programs
can read and whose folders the DVR
writes. Access entries control people
at the doors; they do not shrink what
the server itself can reach.

**Forgotten passwords are a
filesystem task.** Because accounts
live in the configuration folder, the
documented recovery is to edit or
reset the access configuration there
(or start once with `-C` on a trusted
network and fix the entries) — one
more reason the configuration folder
from chapter 2 is worth knowing by
sight.

Check: open Configuration, Access
Entries on your server. Count the
entries that grant administration,
and name the humans each one is for.
If any entry grants administration to
"anyone, no password", you are still
in first-run state — fix it before
anything else in this guide matters.
