# ansible-role-avahi

Configure avahi daemons

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `avahi_user` | User of `avahi-daemon(8)` | `{{ __avahi_user }}` |
| `avahi_group` | Group of `avahi-daemon(8)` | `{{ __avahi_group }}` |
| `avahi_package` | Package name of `avahi` | `{{ __avahi_package }}` |
| `avahi_conf_dir` | Path to configuration directory | `{{ __avahi_conf_dir }}` |
| `avahi_conf_file` | Path to `avahi-daemon.conf(5)` | `{{ avahi_conf_dir }}/avahi-daemon.conf` |
| `avahi_config` | Content of `avahi-daemon.conf(5)`. See below. | `[]` |
| `avahi_daemon_service` | Service name of `avahi-daemon` | `{{ __avahi_daemon_service }}` |
| `avahi_daemon_flags` | Flags to `avahi-daemon(8)` | `{{ __avahi_daemon_flags }}` |
| `avahi_mdns_packages` | List of packages to install for `mdns`. Ignored if the platform does not support it | `{{ __avahi_mdns_package }}` |
| `avahi_nss_switch_file` | Path to `nsswitch.conf(5)`. Ignored if the platform does not support it | `{{ __avahi_nss_switch_file }}` |
| `avahi_nss_switch_hosts` | The value for `hosts` in `nss_switch.conf(5)`. Ignored if the platform does not support it | `files dns mdns` |

## `avahi_config`

This variable is a list of dict.

| Key | Description | Mandatory? |
|-----|-------------|------------|
| `section` | Section name | yes |
| `content` | Content of the section | yes |

## FreeBSD

| Variable | Default |
|----------|---------|
| `__avahi_user` | `avahi` |
| `__avahi_group` | `avahi` |
| `__avahi_package` | `net/avahi-app` |
| `__avahi_conf_dir` | `/usr/local/etc/avahi` |
| `__avahi_daemon_service` | `avahi-daemon` |
| `__avahi_daemon_flags` | `-D` |
| `__avahi_nss_switch_file` | `/etc/nsswitch.conf` |
| `__avahi_mdns_package` | `["dns/nss_mdns"]` |

## OpenBSD

| Variable | Default |
|----------|---------|
| `__avahi_user` | `_avahi` |
| `__avahi_group` | `_avahi` |
| `__avahi_package` | `avahi--` |
| `__avahi_conf_dir` | `/etc/avahi` |
| `__avahi_daemon_service` | `avahi_daemon` |
| `__avahi_daemon_flags` | `""` |
| `__avahi_nss_switch_file` | `""` |

# Dependencies

* `trombik.dbus`

# Example Playbook

```yaml
- hosts: localhost
  roles:
    - role: trombik.dbus
    - ansible-role-avahi
  vars:
    avahi_config:
      - section: server
        content: |
          use-ipv4=yes
          use-ipv6=no
          allow-interfaces=em0
          ratelimit-interval-usec=1000000
          ratelimit-burst=1000
      - section: wide-area
        content: |
          enable-wide-area=yes
      - section: publish
        content: ""
      - section: reflector
        content: ""
      - section: rlimits
        content: |
          rlimit-core=0
          rlimit-data=4194304
          rlimit-fsize=0
          rlimit-nofile=768
          rlimit-stack=4194304
          rlimit-nproc=3
```

# License

```
Copyright (c) 2017 Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# Author Information

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

This README was created by [qansible](https://github.com/trombik/qansible)
