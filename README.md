## docker-blueiris

This is a Container for BlueIris based on [jshridha/docker-blueiris](https://github.com/jshridha/docker-blueiris)

This also bumps the resolution up to 1920x1080 by default and limits the STDOUT logging.  This is a WIP as I learn more about WINE and blueiris.

This container runs:

* Xvfb - X11 in a virtual framebuffer
* x11vnc - A VNC server that scrapes the above X11 server
* [noNVC](https://kanaka.github.io/noVNC/) - A HTML5 canvas vnc viewer
* Fluxbox - a small window manager
* WINE - to run Windows executables on linux
* blueiris.exe - official Windows BlueIris

```
docker run -d \
  --name="blueiris" \
  -p 8080:8080 \
  -p 5900:5900 \
  -p 81:81 \
  -v /path/to/data:/root/prefix32:rw \
  --log-opt max-size=5m --log-opt max-file=2 \
  leonowski/docker-blueiris
  ```

* The "/path/to/data" can be a docker volume or a local path.  It's probably best to use a local path on your host so you can drop things in it if you need to.  I also included cifs-utils so you can mount cifs from inside the container (note:  You will have to run the container privileged to be able to mount cifs)

## Advanced Options

BlueIris version 5 is supported by default. If you'd like to run BlueIris 4, set the environmental variable:
```BLUEIRIS_VERISION=4```


# Known Issues:
* Saving and restoring settings backup via the BlueIris interface does not work!
* Another issue is that the UI3 interface (served on port 81 by default) does not get extracted by the installer.  unzip package is added to image to extract the ui3.zip file after installation.
