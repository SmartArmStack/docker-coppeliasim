# Docker CoppeliaSim

> [!WARNING]
> These are not official images.\
> They are based on the `EDU` versions of CoppeliaSim used in the SmartArmStack.\
> See: https://www.coppeliarobotics.com

## Current images

| Ubuntu Version | CoppeliaSim Version | Tag             |
|----------------|---------------------|-----------------|
| Noble          | 4.10.0rev0          | `latest`        |
| Noble          | 4.9.0rev6           | `noble_490rev6` |
| Noble          | 4.7.0rev4           | `noble_470rev4` |

## Example docker compose

> [!TIP]
> You can replace `murilomarinho/coppeliasim:latest` with your desired image.

Contents of the `compose.yml`.

```yaml
services:
    coppeliasim:
        image: murilomarinho/coppeliasim:latest
        platform: linux/amd64 # No current build for arm64
        environment:
          DISPLAY: $DISPLAY # x server related
        privileged: true # Needed for some gpu configurations.
        volumes:
          - /tmp/.X11-unix:/tmp/.X11-unix # x server related
          - ~/.Xauthority:/root/.Xauthority # x server related
        network_mode: "host" # x server related
        command: /bin/bash -c "
          cd $$COPPELIASIM_PATH
          && ./coppeliaSim.sh "
```

> [!TIP]
> You can send commandline arguments to `coppeliaSim.sh`
> as defined in the [official documentation](https://manual.coppeliarobotics.com/en/commandLine.htm).

Which can be run in the same directory with

```commandline
xhost +local:root
docker compose up
```



