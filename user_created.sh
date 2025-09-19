#!/bin/bash
# Script: user_create.sh
# Purpose: Create a user with optional primary & secondary groups

# 1. Take inputs
read -p "Enter Username: " username
read -p "Enter UID (or leave blank): " uid
read -p "Enter Primary Group (leave blank for default): " pgroup
read -p "Enter Secondary Groups (comma-separated, optional): " sgroups
read -p "Enter Default Shell [/bin/bash]: " shell
read -p "Enter Comment (Full Name/Description): " comment
read -p "Enter Home Directory [/home/$username]: " home_dir

# 2. Defaults
[ -z "$shell" ] && shell="/bin/bash"
[ -z "$home_dir" ] && home_dir="/home/$username"

# If only name given (like "zsh"), fix path
if [[ "$shell" != /* ]]; then
    shell="/bin/$shell"
fi

# 3. Build useradd command dynamically
cmd="useradd"

# UID
[ -n "$uid" ] && cmd="$cmd -u $uid"

# Primary Group
if [ -n "$pgroup" ]; then
    if ! getent group "$pgroup" >/dev/null; then
        echo "Primary group '$pgroup' does not exist. Creating..."
        groupadd "$pgroup"
    fi
    cmd="$cmd -g $pgroup"
fi

# Secondary Groups
[ -n "$sgroups" ] && cmd="$cmd -G $sgroups"

# Shell, Comment, Home
cmd="$cmd -s $shell -c \"$comment\" -d $home_dir $username"

# 4. Run command
eval $cmd

# 5. Check success or failure
if [ $? -eq 0 ]; then
    echo "User '$username' created successfully!"
    [ -n "$pgroup" ] && echo "   Primary Group   : $pgroup"
    [ -n "$sgroups" ] && echo "   Secondary Group : $sgroups"
else
    echo " Failed to create user '$username'."
fi

