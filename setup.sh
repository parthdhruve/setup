#!/bin/bash
{ echo -n "source " & echo `readlink -f ./bash/.bashrc.mine`; } >> ~/.bash_profile
