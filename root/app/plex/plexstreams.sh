#!/bin/sh

preffile="/config/Preferences.xml"

if [ -f "${preffile}" ]; then
    PLEX_HOST=$(wget -qO- http://ipecho.net/plain | xargs echo)
    # shellcheck disable=SC2002
    PLEX_TOKEN=$(cat "/config/Preferences.xml" | sed -e 's;^.* PlexOnlineToken=";;' | sed -e 's;".*$;;' | tail -1)
    PLEX_PLAYS=$(curl --silent "http://${PLEX_HOST}:32400/status/sessions" -H "X-Plex-Token: $PLEX_TOKEN" | xmllint --xpath 'string(//MediaContainer/@size)' -)

    if [ "${PLEX_PLAYS}" -eq "1" ]; then
        echo "20M" >/app/plex/bwlimit.plex
    elif [ "${PLEX_PLAYS}" -eq "2" ]; then
        echo "18M" >/app/plex/bwlimit.plex
    elif [ "${PLEX_PLAYS}" -eq "3" ]; then
        echo "16M" >/app/plex/bwlimit.plex
    elif [ "${PLEX_PLAYS}" -eq "4" ]; then
        echo "14M" >/app/plex/bwlimit.plex
    elif [ "${PLEX_PLAYS}" -eq "5" ]; then
        echo "12M" >/app/plex/bwlimit.plex
    elif [ "${PLEX_PLAYS}" -eq "6" ]; then
        echo "10M" >/app/plex/bwlimit.plex
    elif [ "${PLEX_PLAYS}" -gt "6" ]; then
        echo "8M" >/app/plex/bwlimit.plex
    else
        echo "50M" >/app/plex/bwlimit.plex
    fi
else
    echo "50M" >/app/plex/bwlimit.plex
fi
