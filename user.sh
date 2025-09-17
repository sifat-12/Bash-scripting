echo "Enter the username: "
read username 

echo "Enter the comment for username: "
read fullname

echo "Enter the shell of user: "
read usershell 

echo "Enter UID- "
read uid

echo "Enter gid- "
read gid 

if id "$username" &>/dev/null; then 
	echo "user $username already exixts " 

else 
	useradd -m -c "$fullname" -s $usershell -u $uid -g $gid $username
	echo "user $username created successfully."

	echo "now Emter your passwd for $username password: "
	passwd $username 

fi
