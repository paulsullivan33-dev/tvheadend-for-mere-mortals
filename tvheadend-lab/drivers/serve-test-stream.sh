#!/bin/bash
# Serve the lab's fictional test stream forever, in real time.
#
# Tvheadend runs this script as a "pipe://" input for the mux.
# ffmpeg loops the 20-second fixture file at its natural rate
# (-re, -stream_loop -1) and writes an endless MPEG transport
# stream to standard output, which Tvheadend reads from the pipe.
# The service name and provider written into the stream's
# service description table are the fixture's fictional ones,
# so a scan of this pipe finds the same service as a scan of
# the file itself.
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
exec ffmpeg -v error -re -stream_loop -1 \
  -i "$HERE/fixtures/harbour-light.ts" -c copy \
  -metadata service_name="Harbour Light Test" \
  -metadata service_provider="Fictional Workshop" \
  -mpegts_original_network_id 1 -mpegts_transport_stream_id 1 \
  -mpegts_service_id 1 -f mpegts pipe:1
