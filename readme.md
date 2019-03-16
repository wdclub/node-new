## Docker Ether-1 Service Node © cryon.io 2019

Docker template for Ether1 Service nodes.

*Created and maintained with support from [Ether-1 Project](https://ether1.org/), Ether-1 Community and VPS provider - [WebAge](https://clients.webage.online/order/main/packages/Kernel-based%20Virtual%20Machine/?group_id=6).*

ETHO Donations: `0x46Ff451710Dd245040098c2F308CA55A373ff2cE`

[Quickstart Guide](https://github.com/cryon-io/docker-etho-sn/wiki/Quick-Start-with-ANS)

## Prerequisites 

1. 64-bit installation
2. 3.10 or higher version of the Linux kernel (latest is recommended)

(If you run on VPS provider, which uses OpenVZ, setup requires at OpenVZ 7)

## Setup ANS (AUTONOMOUS NODE SYSTEM - recommended)

1. - `git clone "https://github.com/cryon-io/ans.git" [path] && cd [path] && chmod +x ./ans` # replace path with directory you want to store node in
   or 
   - `wget https://github.com/cryon-io/ans/archive/master.zip && unzip -o master.zip && mv ./ans-master [path] && cd [path] && chmod +x ./ans`
2. one of commands below depending of your preference (run as *root* or use *sudo*)
    - `./ans --full --node=ETHO_SN` # full setup of Ether1 SNN for current user
    - `./ans --full --user=[user] --node=ETHO_SN --auto-update-level=[level]` # full setup of Ether1 SN for defined user (directory location and structure is preserved) sets specified auto update level (Refer to Autoupdates)
3.  logout, login and check node status
    - `./ans --node-info` #     
4. register your ETHO node https://nodes.ether1.org/login.php
    - Instructions: [Ether-1 SN/MN Step 2](https://nodes.ether1.org/debiansetup.html)

## Manual Setup (non ANS)

Recommended only for advance users. Guide - [Manual Setup](https://github.com/cryon-io/docker-etho-sn/wiki/Manual-Setup).
