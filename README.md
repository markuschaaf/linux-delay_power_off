# linux-delay_power_off
A simple Linux kernel module delaying power-off and restart, to allow
for proper shutdown of devices, e.g. SATA disks.

There is a potential race between SATA disks shutting down and Linux
powering down the platform. Symptoms are increasing SMART counters
like "Power-Off_Retract_Count" or "Unsafe_Shutdown_Count", and
filesystems reporting not being unmounted. (They have, but some sectors
were not written.) See also
https://lore.kernel.org/lkml/20170410232118.GA4816@khazad-dum.debian.net/

## Installation
```console
$ git clone 'https://github.com/markuschaaf/linux-delay_power_off.git'
$ cd linux-delay_power_off
$ sudo make dkms-install
```
Or if you are using an Arch-like distribution:
```console
...
$ make PKGBUILD
$ makepkg -si
```
