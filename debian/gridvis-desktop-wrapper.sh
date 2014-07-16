#!/bin/sh

# gridvis-desktop
# This is a wrapper script to start the gridvis-desktop.
# The gridvis-desktop need Java version 7 to work propably. So
# especially on systems with a also installed openjdk-6-jre we need to
# ensure the starter script use the correct JDK_HOME. By this the user
# can use the 'update-alternatives' mechanism and let this point to the
# openjdk-6-jre.

# getting the architecture we are running
ARCH=`dpkg --print-architecture`

# the default starter for the gridvis-desktop
if [ ! -f /usr/lib/gridvis-desktop/bin/gridvis ]; then
    # exit if the starter doesn't exist
    exit 1;
else
    # setting the value
    GRIDVIS_DESKTOP_STARTER="/usr/lib/gridvis-desktop/bin/gridvis"
fi

# finally starting gridvis-desktop
jdkhome="/usr/lib/jvm/java-7-openjdk-$ARCH" $GRIDVIS_DESKTOP_STARTER
