# CCA Feature

This repo provides a vscode dev container feature which includes a simulation environment and related pre-built assets that allow you to launch applications inside a simulated CCA realm.  
If you don't know what dev containers or features are, I encourage you to read the following articles first:

- https://code.visualstudio.com/docs/devcontainers/containers
- https://code.visualstudio.com/blogs/2022/09/15/dev-container-features

The current operating model is you can add the feature to an existing dev container which you are using to develop your feature.

## Goal

Build an environment which runs without buildroots to allow for easy development and test of CCA environments by leveraging u-root
and virtio 9p backmounts.  For more information on any of these environments see the links session at the end of this document.

## How to add the feature to an existing dev container

Add the following feature line to your existing devcontainer's .devcontainer.json:

"features": {
  "ghcr.io/ericvh/cca-cpu-feature/cca:0.1.0": {}
}

and then use vs-code Dev Container: Rebuild Container

Once things come back up, you can start a simulation and launch a realm that will have your
workspace backmounted by executing /usr/local/share/cca/fvp-cca in a terminal.  In the following example,
I started with the rust example dev container with the hello world application already
built in the dev container but not packaged into a docker image or a disk image.

(please note the simulation console is being piped through screen, so interact with it appropriately)

```
vscode ➜ /workspaces/vscode-remote-try-rust (main) $ /usr/local/share/cca/fvp-cca 
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
NOTICE:  Booting Trusted Firmware
NOTICE:  BL1: v2.7(debug):v2.8-rc0-dirty
NOTICE:  BL1: Built : 14:33:34, May 25 2023
INFO:    BL1: RAM 0x4035000 - 0x403c000
INFO:    Loading image id=31 at address 0x4001010
INFO:    Image id=31 loaded: 0x4001010 - 0x400120c
INFO:    FCONF: Config file with image ID:31 loaded at address = 0x4001010
INFO:    Loading image id=24 at address 0x4001300
INFO:    Image id=24 loaded: 0x4001300 - 0x40015e4
INFO:    FCONF: Config file with image ID:24 loaded at address = 0x4001300
INFO:    BL1: Loading BL2
...
[    3.728354] IP-Config: Got DHCP answer from 172.20.51.254, my address is 172.20.51.1
[    3.728481] IP-Config: Complete:
[    3.728541]      device=eth0, hwaddr=00:02:f7:ef:00:03, ipaddr=172.20.51.1, mask=255.255.255.0, gw=172.20.51.254
[    3.728697]      host=172.20.51.1, domain=, nis-domain=(none)
[    3.728786]      bootserver=172.20.51.254, rootserver=172.20.51.254, rootpath=
[    3.728842]      nameserver0=172.20.51.254
[    3.729977] ALSA device list:
[    3.730040]   No soundcards found.
[    3.730358] uart-pl011 1c090000.serial: no DMA platform data
[    3.743467] Freeing unused kernel memory: 7936K
[    3.748545] Run /init as init process
2023/05/25 15:13:08 Welcome to u-root!
                              _
   _   _      _ __ ___   ___ | |_
  | | | |____| '__/ _ \ / _ \| __|
  | |_| |____| | | (_) | (_) | |_
   \__,_|    |_|  \___/ \___/ \__|

[    3.857174] cgroup: Unknown subsys name 'net_cls'
Mounting namespace from host....
starting Realm....be patient
  # lkvm run -k /usr/local/share/cca/Image.guest -m 256 -c 1 --name guest-155
[    1.771459] cacheinfo: Unable to detect cache hierarchy for CPU 0
[    1.887378] loop: module loaded
[    1.891146] tun: Universal TUN/TAP device driver, 1.6
[    1.937226] net eth0: Fail to set guest offload.
...
[    2.275399] IP-Config: Got DHCP answer from 192.168.33.1, my address is 192.168.33.15
[    2.278951] IP-Config: Complete:
[    2.279844]      device=eth0, hwaddr=02:15:15:15:15:15, ipaddr=192.168.33.15, mask=255.255.255.0, gw=192.168.33.1
[    2.284045]      host=192.168.33.15, domain=, nis-domain=(none)
[    2.287297]      bootserver=192.168.33.1, rootserver=0.0.0.0, rootpath=
[    2.287347]      nameserver0=192.168.33.1
[    2.298609] Freeing unused kernel memory: 1088K
[    2.302580] Run /init as init process
1970/01/01 00:00:02 Welcome to u-root!
                              _
   _   _      _ __ ___   ___ | |_
  | | | |____| '__/ _ \ / _ \| __|
  | |_| |____| | | (_) | (_) | |_
   \__,_|    |_|  \___/ \___/ \__|

[    3.422419] cgroup: Unknown subsys name 'net_cls'
Mounting namespace from host....
root@192:/# /workspaces/vscode-remote-try-rust/target/debug/hello_remote_world
Hello, VS Code Remote - Containers!
```

The CCA realm (root@192) has the namespace of the originating dev container (or launch environment)
from the originating vscode dev container mounted (this includes /workspaces, /home, as well
as /usr, /bin, and /lib) -- so you can run all executables just like you would in your
devcontainer.

This should allow you to develop your own code in whatever language you like and run it inside
the enclave.

Everything in the scripts is run from inside screen, so use screen key combos for scrollback, etc.
There are other screens inside the FVP container which have the RMM console, debug console, and FVP console itself.

## Future

- automatic adding of tasks to your vscode configuration to allow launch of application inside enclave using vscode commands instead of using the terminal
- vscode extension to allow visualization and management of multiple simulation environments in a similar fashion to VMs or docker containers
- write better documentation (patches gladly accepted)

## Links

- https://github.com/u-root/u-root
- https://github.com/u-root/cpu
- https://www.arm.com/architecture/security-features/arm-confidential-compute-architecture