addRatshare() {
    export RATSHARE="$(dirname "$(dirname "$BASH_SOURCE")")/share/RAT"
}

addEnvHooks "$hostOffset" addRatshare

