#!/bin/sh
# vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=sh textwidth=0

# gridvis-desktop
# This is a wrapper script to start the gridvis-desktop.
# The gridvis-desktop need Java version 7 to work propably. So
# especially on systems with a also installed openjdk-6-jre we need to
# ensure the starter script use the correct JDK_HOME. By this the user
# can use the 'update-alternatives' mechanism and let this point to the
# openjdk-6-jre.

# getting the architecture we are running
ARCH=`dpkg --print-architecture`

# testing if $USER is a member of the group 'gridvis-desktop'
getent group gridvis-desktop | grep $USER > /dev/null
GETENT_RET=$(echo $?)

### text fields ###
TITLE="GridVis Desktop Starting Check"

# trying to get the DE
if [ "${XDG_CURRENT_DESKTOP}" = "" ]; then
    DESKTOP=$(echo "${XDG_DATA_DIRS}" | sed 's/.*\(xfce\|kde\|gnome\).*/\1/')
else
    DESKTOP=${XDG_CURRENT_DESKTOP}
fi

# convert to lower case shell safe
DESKTOP=`echo "$DESKTOP" | tr '[:upper:]' '[:lower:]'`

NOGROUP_MESSAGE="\
Could't find the user '$USER' in the group 'gridvis-desktop'!
Please ensure your membership of this group.

You can add yourself to the group 'gridvis-desktop' by running the
command 'adduser $USER gridvis-desktop' with superuser rights. After
executing this command you have to relogin to make changes running."

NOACCESS_MESSAGE="\
Unable to access the data directory '/var/lib/GridVisDesktop'!
The programm has to place data there like projects and the license information.

You propably have forgotten to relogin after adding your membership
to the group 'gridvis-desktop'?"

# checking if we are in the group 'gridvis-desktop'
if [ "${GETENT_RET}" != 0 ]; then
    case "${DESKTOP}" in
        gnome|GNOME|xfce|XFCE)
            zenity --info --title "${TITLE}" --text "${NOGROUP_MESSAGE}"
            FAIL=1
        ;;

        kde|KDE)
            kdialog --title "${TITLE}" --msgbox "${NOGROUP_MESSAGE}"
            FAIL=1
        ;;

        *)
            logger -i -p warning -s "$0: Couldn't find a desktop notifier, please check your memberchip to group 'gridvis-deskop'!"

    esac

# then checking the accessibility of /var/lib/GridVisProjects
elif [ ! -w /var/lib/GridVisProjects ] && [ "${GETENT_RET}" = 0 ]; then
    case "${DESKTOP}" in
        gnome|GNOME|xfce|XFCE)
            zenity --info --title "${TITLE}" --text "${NOACCESS_MESSAGE}"
            FAIL=1
        ;;

        kde|KDE)
            kdialog --title "${TITLE}" --msgbox "${NOACCESS_MESSAGE}"
            FAIL=1
        ;;

        *)
            logger -i -p warning -s "$0: Couldn't find a desktop notifier, please ensure you have relogin after adding '$USER' to group 'gridvis-desktop'!"

    esac
fi

if [ "${FAIL}" = 1 ];then
    exit
fi

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
