Media Manager
=============

A series of docker containers to allow full automation of media management.

Role Variables
--------------

| Variable             | Description                                         | Required | Default |
| -------------------- | --------------------------------------------------- | :------: | ------- |
| `TZ`                 | Timezone                                            | - [ ]    | `America/New_York` |
| `PUID`               | User ID                                             | - [ ]    | `1000` |
| `PGID`               | Group ID                                            | - [ ]    | `1000` |
| `PIA_USER`           | username for PIA VPN                                | - [x]    |  |
| `PIA_PASS`           | password for PIA VPN                                | - [x]    |  |
| `DOWNLOAD_FOLDER`    | Folder where completed torrents are downloaded      | - [ ]    | `/mnt/downloads` |
| `CONFIG_FOLDER`      | Folder containing all persistent configuration data | - [ ]    | `~/.config` |
| `MEDIA_FOLDER`       | base folder for all media content                   | - [ ]    | `/mnt/media` |
| `MOVIE_FOLDER`       | folder for 1080p movies                             | - [ ]    | `{{ MEDIA_FOLDER }}/movies` |
| `MOVIE_ANIME_FOLDER` | folder for anime movies                             | - [ ]    | `{{ MEDIA_FOLDER }}/movies-anime` |
| `MOVIE_4k_FOLDER`    | folder for movies in 4k                             | - [ ]    | `{{ MEDIA_FOLDER }}/movies-4k` |
| `TV_FOLDER`          | folder for TV Shows 1080p or lower                  | - [ ]    | `{{ MEDIA_FOLDER }}/tv` |
| `TV_ANIME_FOLDER`    | folder for Anime TV Shows                           | - [ ]    | `{{ MEDIA_FOLDER }}/tv-anime` |
| `TV_4K_FOLDER`       | folder for TV Shows in 4k                           | - [ ]    | `{{ MEDIA_FOLDER }}/tv-4k` |

Dependencies
------------

* Docker module

Example Playbook
----------------

Required vars
```yaml
- hosts: media-managers
  include_roles:
    - name: media-manager
      vars:
        PIA_USER: "username-here"
        PIA_PASS: "password-here"
```

All variables
```yaml
- hosts: media-managers
  include_roles:
    - name: media-manager
      vars:
        PIA_USER: "username-here"
        PIA_PASS: "password-here"
        TZ: "America/New_York"
        PUID: "1000"
        PGID: "1000"
        DOWNLOAD_FOLDER: "/mnt/downloads"
        CONFIG_FOLDER: "~/.config"
        MEDIA_FOLDER: "/mnt/content"
        MOVIE_FOLDER: "/mnt/content/movies"
        MOVIE_4K_FOLDER: "/mnt/content/movies-4k"
        MOVIE_ANIME_FOLDER: "/mnt/content/movies-anime"
        TV_FOLDER: "/mnt/content/tv"
        TV_4K_FOLDER: "/mnt/content/tv-4k"
        TV_ANIME_FOLDER: "/mnt/content/tv-anime"
```

License
-------

BSD
