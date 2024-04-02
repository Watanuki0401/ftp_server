#!/bin/sh

# ----------------------------------------------
# 
# created by WATANUKI0401
# reference list
# RED Hat: deployment_guide 26.2.5
# URL: https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/5/html/deployment_guide/s3-ftp-vsftpd-conf
#
# ----------------------------------------------

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


touch ./vsftpd/vsftpd.conf

# mode select
if [ "$mode" = "4" ]; then
    echo "listen=YES\nlisten_ipv6=NO\n" >> ./vsftpd/vsftpd.conf
elif [ "$mode" = "6" ]; then
    echo "listen=NO\nlisten_ipv6=YES\n" >> ./vsftpd/vsftpd.conf
else
    echo "error"
fi