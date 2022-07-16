Media Server
============

Mount a Hard drive and a network share and Deploy Plex Media Server in a docker container.

Role Variables
--------------

| Variable          | Description                                         | Required | Default |
| ----------------- | --------------------------------------------------- | :------: | ------- |
| `TZ`              | Timezone                                            | - [ ]    | `America/New_York` |
| `PUID`            | User ID                                             | - [ ]    | `1000` |
| `PGID`            | Group ID                                            | - [ ]    | `1000` |
| `DISK_UUID`       | UUID of disk holding media                          | - [x]    |  |
| `DOWNLOAD_FOLDER` | Folder where completed torrents are downloaded      | - [ ]    | `/mnt/downloads` |
| `CONFIG_FOLDER`   | Folder containing all persistent configuration data | - [ ]    | `~/.config` |
| `MEDIA_FOLDER`    | base folder for all media content                   | - [ ]    | `/mnt/content` |

Dependencies
------------

* Docker module

Example Playbook
----------------

Required vars
```yaml
- hosts: media-servers
  include_roles:
    - name: media
      vars:
        DISK_UUID: "UUID"
```

All variables
```yaml
- hosts: media-servers
  include_roles:
    - name: media
      vars:
        DISK_UUID: "UUID"
        TZ: "America/New_York"
        PUID: "1000"
        PGID: "1000"
        DOWNLOAD_FOLDER: "/mnt/downloads"
        CONFIG_FOLDER: "~/.config"
        MEDIA_FOLDER: "/mnt/content"
```

License
-------

BSD
