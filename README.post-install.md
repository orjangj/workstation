# Post installation

## Wifi

```bash
nmcli dev wifi list
nmcli dev wifi connect SSID --ask  # Enter password when prompted
```

## Bluetooth headset

```bash
bluetoothctl
scan on  # Wait for device to show up
scan off
trust MACADDR
pair MACADDR
connect MACADDR
```

### Fedora
Making dnf faster by adding the following entries to `/etc/dnf/dnf.conf`:
```bash
max_parallel_downloads=10  # Default is 3
```
