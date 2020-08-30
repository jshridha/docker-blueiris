## docker-blueiris

This is a Container for BlueIris based on [solarkennedy/wine-x11-novnc-docker
](https://github.com/solarkennedy/wine-x11-novnc-docker)

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
  --privileged \
  -p 8080:8080 \
  -p 5900:5900 \
  -p 81:81 \
  -v /path/to/data:/root/prefix:rw \
  --log-opt max-size=5m --log-opt max-file=2 \
  jshridha/blueiris
  ```

* The "/path/to/data" can be a docker volume or a local path.  It's probably best to use a local path on your host so you can drop things in it if you need to.  Also included is cifs-utils so you can mount cifs from inside the container (note:  You will have to run the container privileged to be able to mount cifs)

* Example docker run also has log output size limited.  This will help the container storage layer from getting out of control.

* **NOTE:** The container must be run in privileged mode for the first run to allow installation of the Visual C++ components. The privileged flag can be removed after the first run.

## Advanced Options

BlueIris version 5 is supported by default. If you'd like to run BlueIris 4, set the environmental variable:
```BLUEIRIS_VERISION=4```

The default resolution is 1024x768x24. If you need to change the resolution set the environmental variable:
`RESOLUTION=1920x1080x24` or `RESOLUTION=1440x768x24` etc

# Known Issues:
* Saving and restoring settings backup via the BlueIris interface does not work!
* Another issue is that the UI3 interface (served on port 81 by default) does not get extracted by the installer.  unzip package is added to image to extract the ui3.zip file after installation.
