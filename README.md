# Rclone Mount w/ Uploader

## Inital Setup

```sh
mkdir -p /opt/appdata/uploader/keys
```

Copy your rclone file to ``/opt/appdata/uploader``
Use the following to fix the service file paths

```sh
OLDPATH=/opt/appdata/pgblitz/keys/
sed -i "s#${OLDPATH}#/config/keys/#g" /opt/appdata/uploader/rclone.conf
```

Copy your Service Account keys to ``/opt/appdata/uploader/keys``

## Running the container

```sh
 docker run -d \
 --name uploader \
 -v /opt/appdata/uploader:/config \
 -v /mnt/unionfs:/unionfs:shared \
 -v /mnt/move:/move \
 --cap-add SYS_ADMIN \
 --device /dev/fuse \
 --security-opt apparmor:unconfined \
 --privileged=true \
 -e PUID=1000 \
 -e PGID=1000 \
 physk/rclone-mergerfs:latest
```

By default a webserver is spawned on port ``8080`` (internal)
which has the Tracker UI (you can disable this using ``-e "DISABLE_WEB=true"``)
You can use traefik to bind this to a domain using the following in your command

```sh
 -l "traefik.enable=true" \
 -l "traefik.frontend.redirect.entryPoint=https" \
 -l "traefik.frontend.rule=Host:tracker.example.com" \
 -l "traefik.port=8080"
```

otherwise you will need to use ``-p 56664:8080``

## Enviroment Vars

| VAR | Default |
| ------ | ------ |
| PUID | 911 |
| PGID | 911 |
| DISABLE_TDRIVE1 | false |
| DISABLE_TDRIVE2 | false |
| DISABLE_GDRIVE | false |
| DISABLE_MERGERFS | false |
| DISABLE_WEB | false |
| MOVE_BASE | / |
| ENCRYPTED | false |
| ADDITIONAL_IGNORES | null |
| DISABLE_UNIONFS_CHOWN | false |
| DIR_CACHE_TIME | 2m |
| VFS_READ_CHUNK_SIZE | 96M |
| VFS_CACHE_MAX_AGE | 675h |
| VFS_READ_CHUNK_SIZE_LIMIT | 1G |
| VFS_CACHE_MODE | writes |
| BUFFER_SIZE | 48M |
| RC_ENABLED | false |
| RC_ADDR | 0.0.0.0:25975 |
| RC_USER | user |
| RC_PASS | xxx |
| POLL_INTERVAL | 5m |

``RC_ADDR``, ``RC_USER``, ``RC_PASS`` are required if you set ``RC_ENABLED``
The RC commands only apply to the team drive mount.

## Uploader

Uploader will look for remotes in the ``rclone.conf``
starting with ``PG``, ``GD``, ``GS`` to upload with

Default files to be ignored by Uploader are

``! -name '*partial~'``
``! -name '*_HIDDEN~'``
``! -name '*.fuse_hidden*'``
``! -name '*.lck'``
``! -name '*.version'``
``! -path '.unionfs-fuse/*'``
``! -path '.unionfs/*'``
``! -path '*.inProgress/*'``

You can add additional ignores using the ENV ``ADDITIONAL_IGNORES`` e.g.

```sh
-e "ADDITIONAL_IGNORES=! -path '*/SocialMediaDumper/*' ! -path '*/test/*'"
```

## Docker-Compose

```yaml
version: "3"
services:
  uploader:
    container_name: uploader
    image: physk/rclone-mergerfs:latest
    privileged: true
    cap_add:
      - SYS_ADMIN
    devices:
      - "/dev/fuse"
    security_opt:
      - "apparmor:unconfined"
    volumes:
      - "/opt/appdata/uploader:/config"
      - "/mnt/unionfs:/unionfs:shared"
      - "/mnt/move:/move"
    enviroment:
      - "PUID=${PUID}"
      - "PGID=${PUID}"
    labels:
      - "traefik.enable=true"
      - "traefik.frontend.redirect.entryPoint=https"
      - "traefik.frontend.rule=Host:tracker.example.com"
      - "traefik.port=8080"
    networks:
      - traefik_proxy
    restart: unless-stopped
```
