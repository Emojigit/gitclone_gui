#!/bin/bash
# Gitclone GUI
# Rewrite https://github.com/Emojigit/gitclone with bash and add GUI feature
# Requre zenity to run

log () {
	echo "[$1] $2"
}
log Action "Starting Gitclone GUI"
WILL_DIR=`zenity --entry --text "Whitch dir do you want to clone?\nDefault: $HOME" --title "Enter Clone dir" `
if [ "$?" -eq 0 ]; then
	log Action "Prepare to cd"
else
	log Action "Pressed Cancel, Interrupted."
	exit 1
fi
cd $WILL_DIR
if [ "$?" -eq 0 ]; then
	log Action "Enter the main clone part."
else
	log Action "cd to $WILL_DIR Failed, Show error message then exit"
	zenity --error --text="Can't cd to dir"
	exit 1
fi
log Action "cd to $PWD"
while /bin/true; do
	REPO_NAME=`zenity --entry --text "Please Enter Git Repo URL" --title "Enter Git Repo URL"`
	if [ "$?" -eq 0 ]; then
		log Action "Prepare to clone"
	else
		log Action "Pressed Cancel, Interrupted."
		exit 1
	fi
	if [ -z "$REPO_NAME" ]; then
		log Info "No Clone URL, Exit"
		exit 1
	fi
	git clone $REPO_NAME | zenity --progress --pulsate --auto-close --auto-kill
	if [ "${PIPESTATUS[0]}" -eq 0 ]; then
		log Info "Clone Success"
		STAT="successed"
	else
		log Action "Cloe Failed"
		STAT="failed"
	fi
	log Info "Clone Finished"
	zenity --question --text="Clone $STAT. Do you want to clone another repo?" --title "Clone Finished" --width=600
	if [ "$?" -eq 0 ]; then
		log Action "Repeating Clone"
	else
		log Action "GitClone App Finished"
		exit 0
	fi
done
