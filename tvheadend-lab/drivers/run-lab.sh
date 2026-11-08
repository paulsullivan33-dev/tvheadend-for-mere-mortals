#!/bin/bash
# The TVHeadend lab driver: one run, t00 to t09, evidence in
# ../transcripts/. Everything talks to 127.0.0.1 only.
# Web interface 18091, HTSP 19091. Nothing is installed
# system-wide: the .deb is extracted into scratch, its two
# missing libraries are extracted beside it, and the server
# runs in a private mount namespace (see run-in-namespace.sh).
set -u
LAB="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
T="$LAB/transcripts"
export TVH_SCRATCH="$HOME/workspace/.batch-351-363/scratch-tvheadend"
SCRATCH="$TVH_SCRATCH"
export TVH_LDLIBS="$SCRATCH/extracted-libs/usr/lib/x86_64-linux-gnu:$SCRATCH/extracted-libs/lib/x86_64-linux-gnu"
B="http://127.0.0.1:18091"
DEBVER="4.3-2937~g0589ce006~noble"
DEBFILE="tvheadend_${DEBVER}_amd64.deb"
mkdir -p "$T" "$SCRATCH/run" "$SCRATCH/recordings"
rm -f "$SCRATCH"/recordings/*.ts "$SCRATCH"/playback*.ts
TVH_PID=""

start_server() {
  mkdir -p /usr/share/tvheadend "$SCRATCH/config"
  setsid "$LAB/drivers/run-in-namespace.sh" > "$SCRATCH/run/server-console.log" 2>&1 < /dev/null &
  TVH_PID=$!
  echo "$TVH_PID" > "$SCRATCH/run/server.pid"
  for i in $(seq 1 30); do
    curl -s -m 2 "$B/api/serverinfo" > /dev/null 2>&1 && return 0
    sleep 1
  done
  echo "SERVER DID NOT ANSWER"; return 1
}
stop_server() {
  [ -n "$TVH_PID" ] && kill "$TVH_PID" 2>/dev/null
  for i in $(seq 1 10); do
    curl -s -m 1 "$B/api/serverinfo" > /dev/null 2>&1 || break
    sleep 1
  done
  TVH_PID=""
}
jqget() { python3 -c "import json,sys; $1"; }

echo "=== t00 environment ==="
{
  echo "date: $(date -Is)"; echo; echo "--- os ---"; lsb_release -a 2>/dev/null
  echo; echo "--- docker client, but no daemon (route 2 cannot run here) ---"
  docker info 2>&1 | tail -n 3; timeout 10 docker run --rm hello-world 2>&1
  echo; echo "--- ffmpeg (generates the lab stream) ---"; ffmpeg -version 2>&1 | head -n 1
  echo; echo "--- tvheadend in this machine's own apt sources ---"
  apt-cache policy tvheadend; echo "(empty answer: no package)"
} > "$T/t00-environment.txt" 2>&1
cat "$T/t00-environment.txt"

echo "=== t01 download, extract, libraries, version ==="
{
  cd "$SCRATCH" || exit 1
  echo "--- the project repository's noble package index (first entry) ---"
  curl -sL "https://dl.cloudsmith.io/public/tvheadend/tvheadend/deb/ubuntu/dists/noble/main/binary-amd64/Packages" -o Packages-noble.txt
  awk '/^Package: tvheadend/{f=1} f{print} f&&/^$/{exit}' Packages-noble.txt
  echo "--- download the .deb itself (no install) ---"
  curl -sL "https://dl.cloudsmith.io/public/tvheadend/tvheadend/deb/ubuntu/pool/noble/main/t/tv/tvheadend_${DEBVER}/$DEBFILE" -o tvheadend.deb -w "HTTP %{http_code} size %{size_download}\n"
  echo "sha256 (compare with SHA256 in the index entry above):"; sha256sum tvheadend.deb
  echo "--- extract, do not install ---"
  rm -rf extracted; mkdir extracted; dpkg-deb -x tvheadend.deb extracted && echo "dpkg-deb -x: OK"
  ls -lh extracted/usr/bin/tvheadend
  echo "--- ldd as extracted: two libraries missing ---"
  ldd extracted/usr/bin/tvheadend | grep "not found"
  echo "--- fetch those two libraries as .debs from Ubuntu noble, extract too ---"
  apt-get download libdvbcsa1 libpcre3 2>&1 | grep -E "^Get"
  ls -lh libdvbcsa1_*.deb libpcre3_*.deb
  rm -rf extracted-libs; for d in libdvbcsa1_*.deb libpcre3_*.deb; do dpkg-deb -x "$d" extracted-libs; done
  echo "--- ldd with the extracted libraries on LD_LIBRARY_PATH ---"
  LD_LIBRARY_PATH="$TVH_LDLIBS" ldd extracted/usr/bin/tvheadend | grep -c "not found" | sed 's/^/not-found count: /'
  echo "--- version ---"
  LD_LIBRARY_PATH="$TVH_LDLIBS" ./extracted/usr/bin/tvheadend --version
} > "$T/t01-download-extract-version.txt" 2>&1
cat "$T/t01-download-extract-version.txt"

echo "=== t02 help ==="
LD_LIBRARY_PATH="$TVH_LDLIBS" "$SCRATCH/extracted/usr/bin/tvheadend" --help > "$T/t02-help.txt" 2>&1
head -n 5 "$T/t02-help.txt"

echo "=== t03 the fictional test stream ==="
{
  echo "ffmpeg makes a 20-second MPEG-TS: test pattern + 440 Hz tone,"
  echo "MPEG-2 video + MP2 audio, service metadata as shown."
  ffmpeg -y -v error -f lavfi -i testsrc2=size=320x240:rate=25 \
    -f lavfi -i sine=frequency=440:sample_rate=48000 -t 20 \
    -c:v mpeg2video -b:v 400k -c:a mp2 -b:a 96k \
    -metadata service_name="Harbour Light Test" \
    -metadata service_provider="Fictional Workshop" \
    -mpegts_original_network_id 1 -mpegts_transport_stream_id 1 \
    -mpegts_service_id 1 -f mpegts "$LAB/fixtures/harbour-light.ts"
  ls -lh "$LAB/fixtures/harbour-light.ts"
  echo "--- ffprobe: the programme and its two streams ---"
  ffprobe -v error -show_programs -show_entries stream=codec_name,codec_type,width,height \
    "$LAB/fixtures/harbour-light.ts" 2>/dev/null | grep -vE "DISPOSITION|SIDE_DATA|\[/|^$"
} > "$T/t03-test-stream.txt" 2>&1
cat "$T/t03-test-stream.txt"

echo "=== t04 first run ==="
rm -rf "$SCRATCH/config"
{
  echo "--- kept failure: the first attempt, without the data files visible ---"
  echo "Run during exploration, binary extracted but /usr/share/tvheadend not"
  echo "bind-mounted. The server started its HTTP and HTSP listeners, then:"
  cat "$LAB/drivers/first-attempt-crash-excerpt.txt"
  echo "Lesson kept in chapter 3: the binary needs its data tree at the"
  echo "compiled-in path; the namespace bind mount in run-in-namespace.sh"
  echo "is how this lab supplies it without installing the package."
  echo
  echo "--- the real first run (fresh config, -C first-run mode) ---"
} > "$T/t04-first-run.txt"
start_server
{
  sleep 3
  echo "--- server log, the lines the chapters quote ---"
  grep -aE "Starting HTTP server|Starting HTSP server|wide open|START: HTS|scanfile: DVB-T" "$SCRATCH/run/server-console.log" | head -n 8
  echo; echo "--- GET / (the web interface answers with a redirect) ---"
  curl -s -i "$B/" | head -n 12
  echo; echo "--- GET /api/serverinfo ---"
  curl -s "$B/api/serverinfo"; echo
  echo; echo "--- listening sockets: web and HTSP, loopback only ---"
  ss -tlnp | grep -E "18091|19091"
  echo; echo "--- HTSP port accepts a TCP connection ---"
  (exec 3<>"/dev/tcp/127.0.0.1/19091") 2>/dev/null && echo "TCP connect to 127.0.0.1:19091: OK" || echo "TCP connect FAILED"
} >> "$T/t04-first-run.txt" 2>&1
cat "$T/t04-first-run.txt"

echo "=== t05 IPTV network and the file mux scan ==="
{
  echo "--- create the network: POST /api/mpegts/network/create ---"
  curl -s -X POST "$B/api/mpegts/network/create" \
    --data-urlencode 'class=iptv_network' \
    --data-urlencode 'conf={"enabled":true,"networkname":"Lab Loopback Network","skipinitscan":false}'
  echo
  NET=$(curl -s "$B/api/mpegts/network/grid?start=0&limit=10" | jqget "print(json.load(sys.stdin)['entries'][0]['uuid'])")
  echo "network uuid: $NET"
  echo "--- create the mux, URL = the fixture file: POST /api/mpegts/network/mux_create ---"
  curl -s -X POST "$B/api/mpegts/network/mux_create" \
    --data-urlencode "uuid=$NET" --data-urlencode 'class=iptv_mux' \
    --data-urlencode "conf={\"iptv_url\":\"file://$LAB/fixtures/harbour-light.ts\",\"iptv_muxname\":\"Harbour Light Mux\",\"name\":\"Harbour Light Mux\",\"enabled\":1}"
  echo
  echo "--- poll the mux while it scans (scan_state/scan_result decoded in t05b) ---"
  for i in $(seq 1 20); do
    sleep 3
    LINE=$(curl -s "$B/api/mpegts/mux/grid?start=0&limit=10" | jqget "e=json.load(sys.stdin)['entries'][0]; print('scan_state',e['scan_state'],'scan_result',e['scan_result'],'num_svc',e['num_svc'],'onid',e['onid'],'tsid',e['tsid'])")
    echo "poll $i: $LINE"
    echo "$LINE" | grep -q "num_svc 1" && break
  done
  echo "--- the service the scan created ---"
  curl -s "$B/api/mpegts/service/grid?start=0&limit=999999" | python3 -m json.tool
  echo "--- the scan, in the server's own words (table handlers) ---"
  grep -aE "tbl-base: (pat|pmt|sdt)" "$SCRATCH/run/server-console.log" | grep -E "sid|nicename|type" | head -n 8
} > "$T/t05-network-and-file-scan.txt" 2>&1
cat "$T/t05-network-and-file-scan.txt"
{
  MUX=$(curl -s "$B/api/mpegts/mux/grid?start=0&limit=10" | jqget "print(json.load(sys.stdin)['entries'][0]['uuid'])")
  echo "The two scan fields are enumerations. From /api/idnode/load for this mux:"
  curl -s "$B/api/idnode/load?uuid=$MUX" | jqget "
for p in json.load(sys.stdin)['entries'][0]['params']:
    if p['id'] in ('scan_state','scan_result'): print(p['id'], '=', p.get('enum'))"
} > "$T/t05b-scan-enums.txt" 2>&1
cat "$T/t05b-scan-enums.txt"

echo "=== t06 map the service, publish the playlist, play the channel ==="
{
  SVC=$(curl -s "$B/api/mpegts/service/grid?start=0&limit=10" | jqget "print(json.load(sys.stdin)['entries'][0]['uuid'])")
  echo "--- map service $SVC to a channel: POST /api/service/mapper/save ---"
  curl -s -X POST "$B/api/service/mapper/save" \
    --data-urlencode "node={\"uuid\":\"00000000000000000000000000000000\",\"services\":[\"$SVC\"]}"
  echo
  echo "--- the mapper runs as its own task; poll the channel grid until it lands ---"
  for i in $(seq 1 15); do
    sleep 2
    N=$(curl -s "$B/api/channel/grid?start=0&limit=10" | jqget "print(json.load(sys.stdin)['total'])")
    echo "poll $i: channels = $N"
    [ "$N" = "1" ] && break
  done
  grep -a "service-mapper" "$SCRATCH/run/server-console.log" | tail -n 2
  echo "--- the channel grid now ---"
  curl -s "$B/api/channel/grid?start=0&limit=999999" | python3 -m json.tool
  echo "--- the playlist Tvheadend publishes for its channels ---"
  curl -s "$B/playlist/channels"
  echo "--- play the channel for 8 seconds through /stream/channel/<uuid> ---"
  CH=$(curl -s "$B/api/channel/grid?start=0&limit=10" | jqget "print(json.load(sys.stdin)['entries'][0]['uuid'])")
  timeout 8 curl -s "$B/stream/channel/$CH?profile=pass" -o "$SCRATCH/playback.ts"
  echo "curl stopped by the 8-second timeout (a live stream does not end); bytes received:"
  ls -lh "$SCRATCH/playback.ts"
  ffprobe -v error -show_entries stream=codec_name,codec_type -of csv "$SCRATCH/playback.ts" 2>/dev/null
} > "$T/t06-map-and-play.txt" 2>&1
cat "$T/t06-map-and-play.txt"

echo "=== t07 EPG: a grabber registers, but the fixture carries no guide data ==="
{
  echo "--- server log: the mux is registered for over-the-air EPG ---"
  grep -a "registering mux for OTA EPG" "$SCRATCH/run/server-console.log" | head -n 2
  grep -a "epggrab: module" "$SCRATCH/run/server-console.log" | head -n 6
  echo "--- GET /api/epg/events/grid: what the guide actually holds ---"
  curl -s "$B/api/epg/events/grid?start=0&limit=10"; echo
  echo "The fixture stream contains no EIT (event information) tables, so"
  echo "the honest count is zero. Chapter 9 keeps EPG beyond this labelled."
} > "$T/t07-epg.txt" 2>&1
cat "$T/t07-epg.txt"

echo "=== t08 a recording against the one-shot file mux falls short ==="
{
  DVR=$(curl -s "$B/api/dvr/config/grid?start=0&limit=10" | jqget "print(json.load(sys.stdin)['entries'][0]['uuid'])")
  echo "--- point the DVR at scratch storage first (its default was the home folder) ---"
  curl -s -X POST "$B/api/idnode/save" \
    --data-urlencode "node={\"uuid\":\"$DVR\",\"storage\":\"$SCRATCH/recordings\"}"
  echo; curl -s "$B/api/dvr/config/grid?start=0&limit=10" | jqget "print('storage now:', json.load(sys.stdin)['entries'][0]['storage'])"
  CH=$(curl -s "$B/api/channel/grid?start=0&limit=10" | jqget "print(json.load(sys.stdin)['entries'][0]['uuid'])")
  NOW=$(date +%s); START=$((NOW+5)); STOP=$((NOW+35))
  echo "--- create a manual DVR entry, $START to $STOP (30 seconds) ---"
  curl -s -X POST "$B/api/dvr/entry/create" \
    --data-urlencode "conf={\"enabled\":true,\"channel\":\"$CH\",\"start\":$START,\"stop\":$STOP,\"title\":{\"eng\":\"Harbour Light Recording Test\"},\"comment\":\"lab manual recording, file mux\"}"
  echo; echo "waiting 70 seconds for the attempt to play out..."
  sleep 70
  echo "--- the finished-recording record (selected fields) ---"
  curl -s "$B/api/dvr/entry/grid_finished?start=0&limit=10" | jqget "
e=json.load(sys.stdin)['entries'][0]
for k in ('disp_title','duration','filesize','status','sched_status','errors','data_errors','filename'): print(k,'=',e[k])"
  echo "--- but measure the file itself: how much programme is actually in it? ---"
  for f in "$SCRATCH"/recordings/*.ts; do
    echo "$f"; ffprobe -v error -show_entries format=duration,size -of default=noprint_wrappers=1 "$f" 2>/dev/null
  done
  echo; echo "--- files in the recordings folder ---"; ls -la "$SCRATCH/recordings/"
  echo "--- the server log tells the story ---"
  grep -aE "DVR: Harbour|Recording unable|No input source available for subscription \"DVR|End of program" "$SCRATCH/run/server-console.log" | tail -n 6
  echo "--- exploration kept the other outcome of the same attempt (twice) ---"
  cat "$LAB/drivers/file-recording-failures-excerpt.txt"
  echo "Verdict, measured: the window asked for 30 seconds. Tvheadend closed"
  echo "this run as Completed OK with zero errors, yet the kept file holds"
  echo "about 10 seconds of programme (ffprobe above) - the one-shot file"
  echo "had only that much left to give when the recorder tuned to it. In"
  echo "exploration the same attempt failed outright, twice, with No input"
  echo "detected / Time missed (lines above). A file is not a broadcast:"
  echo "it does not keep coming. Chapter 10 tells both halves."
} > "$T/t08-recording-file-fails.txt" 2>&1
cat "$T/t08-recording-file-fails.txt"

echo "=== t09 the pipe mux: endless stream, scan OK, recording completes ==="
{
  MUX=$(curl -s "$B/api/mpegts/mux/grid?start=0&limit=10" | jqget "print(json.load(sys.stdin)['entries'][0]['uuid'])")
  echo "--- rewrite the mux URL as a pipe that loops the fixture forever ---"
  python3 - "$MUX" "$LAB/drivers/serve-test-stream.sh" <<'PYEOF'
import sys, json, urllib.request, urllib.parse
mux, script = sys.argv[1], sys.argv[2]
node = {"uuid": mux, "iptv_url": "pipe://" + script, "iptv_respawn": True}
data = urllib.parse.urlencode({"node": json.dumps(node)}).encode()
print(urllib.request.urlopen("http://127.0.0.1:18091/api/idnode/save", data).read().decode())
PYEOF
  curl -s "$B/api/mpegts/mux/grid?start=0&limit=10" | jqget "e=json.load(sys.stdin)['entries'][0]; print('mux URL now:', e['iptv_url']); print('respawn:', e['iptv_respawn'])"
  echo "--- restart the server (a mid-flight URL edit left the mux in a"
  echo "    bad-service state during exploration; a restart spawns the pipe) ---"
} > "$T/t09-pipe-and-recording.txt" 2>&1
stop_server; start_server
{
  sleep 10
  echo "--- the pipe process Tvheadend spawned ---"
  ps aux | grep "[s]tream_loop" | sed 's/  */ /g' | cut -c1-160
  grep -aE "spawn: Executing" "$SCRATCH/run/server-console.log" | tail -n 1
  echo "--- poll the mux scan (result 1 = OK, see t05b) ---"
  for i in $(seq 1 25); do
    sleep 3
    LINE=$(curl -s "$B/api/mpegts/mux/grid?start=0&limit=10" | jqget "e=json.load(sys.stdin)['entries'][0]; print('scan_state',e['scan_state'],'scan_result',e['scan_result'],'num_svc',e['num_svc'])")
    echo "poll $i: $LINE"
    echo "$LINE" | grep -q "scan_result 1" && break
  done
  echo "--- the service found on the pipe (same fictional name) ---"
  curl -s "$B/api/mpegts/service/grid?start=0&limit=10" | jqget "e=json.load(sys.stdin)['entries'][0]; print(e['svcname'],'/',e['provider'],'/ sid',e['sid'],'/ encrypted',e['encrypted'])"
  echo "--- play the channel again, 8 seconds ---"
  CH=$(curl -s "$B/api/channel/grid?start=0&limit=10" | jqget "print(json.load(sys.stdin)['entries'][0]['uuid'])")
  timeout 8 curl -s "$B/stream/channel/$CH?profile=pass" -o "$SCRATCH/playback-pipe.ts"
  ls -lh "$SCRATCH/playback-pipe.ts"
  echo "--- record 35 seconds from the endless stream ---"
  BASE=$(curl -s "$B/api/dvr/entry/grid_finished?start=0&limit=99" | jqget "print(json.load(sys.stdin)['total'])")
  echo "finished recordings already on the books: $BASE (the short file-mux one)"
  NOW=$(date +%s); START=$((NOW+5)); STOP=$((NOW+40))
  REC=$(curl -s -X POST "$B/api/dvr/entry/create" \
    --data-urlencode "conf={\"enabled\":true,\"channel\":\"$CH\",\"start\":$START,\"stop\":$STOP,\"title\":{\"eng\":\"Harbour Light Recording Test\"},\"comment\":\"lab manual recording, pipe mux\"}" | jqget "print(json.load(sys.stdin)['uuid'])")
  echo "new entry uuid: $REC"; echo "waiting for this recording to finish..."
  for i in $(seq 1 30); do
    sleep 4
    DONE=$(curl -s "$B/api/dvr/entry/grid_finished?start=0&limit=99" | jqget "print(json.load(sys.stdin)['total'])")
    [ "$DONE" = "$((BASE+1))" ] && break
  done
  echo "polls taken: $i, finished total now: $DONE"
  echo "--- the finished record for THIS entry ---"
  curl -s "$B/api/dvr/entry/grid_finished?start=0&limit=99" | REC="$REC" jqget "
import os
for e in json.load(sys.stdin)['entries']:
    if e['uuid'] == os.environ['REC']:
        for k in ('disp_title','duration','errors','data_errors','status','filename'): print(k, '=', e[k])"
  echo "--- measure this recording's file ---"
  REC_FILE=$(curl -s "$B/api/dvr/entry/grid_finished?start=0&limit=99" | REC="$REC" jqget "
import os
for e in json.load(sys.stdin)['entries']:
    if e['uuid'] == os.environ['REC']: print(e['filename'])")
  ls -lh "$REC_FILE"
  ffprobe -v error -show_entries stream=codec_name,codec_type -show_entries format=duration -of default=noprint_wrappers=1 "$REC_FILE" 2>/dev/null
  echo "--- both recordings side by side ---"; ls -lh "$SCRATCH/recordings/"
  echo "--- the server's verdict ---"
  grep -aE "End of program: Completed OK" "$SCRATCH/run/server-console.log" | tail -n 1
} >> "$T/t09-pipe-and-recording.txt" 2>&1
cat "$T/t09-pipe-and-recording.txt"

stop_server
rmdir /usr/share/tvheadend 2>/dev/null
echo "=== lab run complete; server stopped, mount point removed ==="
