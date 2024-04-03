#!/bin/sh

# ----------------------------------------------
# 
# created by WATANUKI0401
# reference list
# RED Hat: deployment_guide 26.2.5
# URL: https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/5/html/deployment_guide/s3-ftp-vsftpd-conf
#
# ----------------------------------------------

FILE="./vsftpd/vsftpd.conf"

# use IPv4 or IPv6
# ------------------
# listen=YES
# listen_ipv6=NO
# ------------------
read -p "Which can it use IPv4 or IPv6?(4/6): " mode

# Allow anonymous FTP?
# ---------------------
# anonymous_enable=NO
# ---------------------
read -p "Allow anonymous access.(y/n): " ano_en

# Allow to access local users?
# NOTE: allow to connect local users by written "/etc/passwd"
# -------------------
# local_enable=YES
# -------------------
read -p "Allow use local users?.(y/n): " use_lo 

# PAM service name (should not to change service name)
# -------------------------
# pam_service_name=vsftpd
# -------------------------
# This isn't recommended to change name.
# read -p "What do you use PAM-service name?" service

# login mode(Access restrictions)
# enable options    YES: enable       NO: disable
# deny options      YES: Black list   NO: White list
# -----------------------
# userlist_enable=YES
# userlist_deny=NO
# -----------------------
read -p "Do you use list restrictions?(y/n): " list_en
if [ "$list_en" = "y" ]; then
    read -p "Do you use whitelists or blacklists?(w/b): " list_mode
fi

# Use chroot() jail
# ------------------------------
# chroot_list_enable=YES
# allow_writeable_chroot=YES
# ------------------------------
read -p "Use chroot()?(y/n): " chroot_en

# chroot list addr
# -------------------------------------------
# chroot_list_file=/etc/vsftpd/chroot_list
# -------------------------------------------
# File addr are fixed by docker.

# created dir and file umask
# -----------------
# local_umask=022
# -----------------
read -p "What permission do you use?(default:022): " umask

# use local time
# --------------------
# use_localtime=YES
# --------------------
read -p "Do you use localtime stamp?(y/n): " local_time

# use FTP command?
# ------------------
# write_enable=YES
# ------------------
read -p "Use FTP commands?(y/n): " write_en 

# take logs?
# ------------------------ 
# xferlog_enable=YES
# log_ftp_protocol=YES
# xferlog_std_format=NO
# ------------------------
read -p "Take log?(y/n): " logger

# session life
# --------------------------
# idle_session_timeout=600
# --------------------------
read -p "Session timeout seconds.(def:300): " session_timeout

# transport data life
# ----------------------------
# data_connection_timeout=60
# ----------------------------
read -p "Connection timeout seconds.(def:300)" connect_timeout

# use passive mode connection
# -----------------
# pasv_enable=YES
# -----------------
read -p "Enable Passive mode access?(y/n): " pasv_mode_en

# PASV mode: useing ports
# ---------------------
# pasv_min_port=60001
# pasv_max_port=60010
# ---------------------
if [ "$pasv_mode_en" = "y" ]; then
    read -p "use port number?(Syntax: min max): " min_port max_port
fi

# ASCII mangling is a horrible feature of the protocol.
# ---------------------------
# ascii_upload_enable=YES
# ascii_download_enable=YES
# ---------------------------


if [ -f "$FILE" ]; then
    while true; do
        read -p "Are you sure you want to delete vsftpd.comf?(y/n): " rmf
        case $rmf in
            [Yy]* ) rm ./vsftpd/vsftpd.conf; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi

touch $FILE

# mode select
echo "# Use listen IP version" >> $FILE
if [ "$mode" = "4" ]; then
    echo "listen=YES\nlisten_ipv6=NO\n" >> $FILE
elif [ "$mode" = "6" ]; then
    echo "listen=NO\nlisten_ipv6=YES\n" >> $FILE
else
    echo "[listen] select error"
    exit
fi

# anonymous acc
echo "# Allow anonymous access" >> $FILE
case $ano_en in
    [Yy]* ) echo "anonymous_enable=NO\n" >> $FILE;;
    [Nn]* ) echo "anonymous_enable=YES\n" >> $FILE;;
    * ) echo "[anonymous] select error"; exit;;
esac

# Allow local user login
echo "# Use local user login" >> $FILE
case $use_lo in
    [Yy]* ) echo "local_enable=YES\n" >> $FILE;;
    [Nn]* ) echo "local_enable=NO\n" >> $FILE;;
    * ) echo "[local user] select error"; exit;;
esac

# PAM service name
echo "# Cannot change. This is service name." >> $FILE
echo "pam_service_name=vsftpd\n" >> $FILE

# login mode
echo "# Access restrictions" >> $FILE
case $list_en in
    [Yy]* ) echo "userlist_enable=YES" >> $FILE;
            case $list_mode in
                [w]* ) echo "userlist_deny=NO\n" >> $FILE;;
                [b]* ) echo "userlist_deny=YES\n" >> $FILE;;
                * ) echo "[Access] error"; exit;;
            esac;
            echo "You should make ./vsftpd/user_list";;
    [Nn]* ) echo "userlist_enable=NO\n" >> $FILE;;
    * ) echo "[Access] select error"; exit;;
esac

# chroot() jail
echo "# chroot() jail" >> $FILE
case $chroot_en in
    [Yy]* ) echo "chroot_list_enable=YES\nallow_writeable_chroot=YES\n" >> $FILE;
            echo "You should make ./vsftpd/chroot_list";;
    [Nn]* ) echo "chroot_list_enable=NO\n" >> $FILE;;
    * ) echo "[chroot] select error"; exit;;
esac

# umask
echo "# Manipulating permissions" >> $FILE
if [ "$umask" = "" ]; then
    echo "[umask] input input"
    exit
else
    echo "local_umask=${umask}\n" >> $FILE
fi

# local time stamp
echo "# Active localtime stamp." >> $FILE
case $local_time in
    [Yy]* ) echo "use_localtime=YES\n" >> $FILE;;
    [Nn]* ) echo "use_localtime=NO\n" >> $FILE;;
    * ) echo "[local time stamp] select error"; exit;;
esac

# FTP command
echo "# Allow FTP commands." >> $FILE
case $write_en in
    [Yy]* ) echo "write_enable=YES\n" >> $FILE;;
    [Nn]* ) echo "write_enable=NO\n" >> $FILE;;
    * ) echo "[FTP commands] select error"; exit;;
esac

# logs
echo "# Allow take logs.\n# It is fixed by docker-compose" >> $FILE
case $logger in
    [Yy]* ) echo "xferlog_enable=YES\nlog_ftp_protocol=YES\nxferlog_std_format=NO\n" >> $FILE;;
    [Nn]* ) echo "xferlog_enable=NO\n" >> $FILE;;
    * ) echo "[logger] select error"; exit;;
esac

# session
echo "# Session lifetime." >> $FILE
if [ "$session_timeout" = "" ]; then
    echo "[Session lifetime] invalid input"
    exit
else
    echo "idle_session_timeout=${session_timeout}\n" >> $FILE
fi

# transport
echo "# Data transport lifetime." >> $FILE
if [ "$connect_timeout" = "" ]; then
    echo "[Data lifetime] invalid input"
    exit
else
    echo "local_umask=${connect_timeout}\n" >> $FILE
fi

# pasv mode select
echo "# PASV mode" >> $FILE
case $pasv_mode_en in
    [Yy]* ) echo "pasv_enable=YES\npasv_min_port=${min_port}\npasv_max_port=${max_port}\n" >> $FILE;;
    [Nn]* ) echo "pasv_enable=NO\n" >> $FILE;;
    * ) echo "[PASV] select error"; exit;;
esac

# ASCII mangling is a horrible feature of the protocol.
echo "# ASCII transmission support." >> $FILE
echo "# You shoud not change this options." >> $FILE
echo "ascii_upload_enable=YES\nascii_download_enable=YES" >> $FILE

echo "complete of generate vsftpd.conf"
