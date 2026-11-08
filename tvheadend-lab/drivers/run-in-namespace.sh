#!/bin/bash
# Run the extracted Tvheadend inside a private mount namespace.
#
# The .deb's binary looks for its data files at the absolute path
# /usr/share/tvheadend (that string is compiled in). Rather than
# installing the package system-wide, this script bind-mounts the
# extracted share directory over that path *inside a mount
# namespace only* (unshare -rm). The host system keeps nothing
# but an empty mount-point directory, which run-lab.sh removes
# again at the end.
#
# Required environment:
#   TVH_SCRATCH   scratch dir holding extracted/ and config/
#   TVH_LDLIBS    LD_LIBRARY_PATH value for the extracted libraries
exec unshare -rm bash -c '
  mount --bind "$TVH_SCRATCH/extracted/usr/share/tvheadend" /usr/share/tvheadend || exit 1
  export LD_LIBRARY_PATH="$TVH_LDLIBS"
  exec "$TVH_SCRATCH/extracted/usr/bin/tvheadend" \
    -C -c "$TVH_SCRATCH/config" \
    --bindaddr 127.0.0.1 --http_port 18091 --htsp_port 19091 \
    -d --logfile "$TVH_SCRATCH/run/tvheadend.log"
'
