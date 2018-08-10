#!/bin/bash

scp ./retrieve-xp-results.sh benni@sparks-vm35.i3s.unice.fr:~/
ssh benni@sparks-vm35.i3s.unice.fr '~/retrieve-xp-results.sh'
