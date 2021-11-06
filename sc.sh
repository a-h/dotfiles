#!/bin/bash
killall -9 ssh-agent gpg-agent
for keystub in $(gpg2 --with-keygrip --list-secret-keys adrianhesketh@hushmail.com | grep Keygrip | awk '{print $3}'); do rm /Users/adrian/.gnupg/private-keys-v1.d/$keystub.key; done;
gpg2 --card-status
eval $(gpgconf --launch gpg-agent)
ssh-add -l
exit 0
