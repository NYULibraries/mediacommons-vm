#!/bin/bash

xdpyinfo -display :10 >/dev/null 2>&1 && (exit 0) || sudo Xvfb :10 -ac >/dev/null 2>&1 &

exit 0
