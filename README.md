# useful-scripts
A set of my "must have" scripts.

1) To save anaconda envs go to your favourite dir and launch the backup script.

2) Uninstall anaconda:

uninstall anaconda
rm -rf ~/anaconda3
conda uninstall
rm -rf ~/anaconda
Edit ~/.bash_profileand remove the anaconda directory from your PATH environment variable.
edit .bashrc or .profile or .bash_profile. Remove the following hidden files and directories in the home directory:.condarcand .conda

If one of my scripts failes due to the bash related issues (/bin/bash^M: bad interpreter: No such file or directory) please run in the terminal:

sed -i -e 's/\r$//' scriptname.sh

Enjoy!
