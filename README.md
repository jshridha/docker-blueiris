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
  --name="BlueIris" \
  -p 8080:8080 \
  -p 5900:5900 \
  -p 81:81 \
  -v /path/to/data:/root/prefix32:rw \
  jshridha/blueiris
  ```

## Advanced Options

BlueIris version 5 is supported by default. If you'd like to run BlueIris 4, set the environmental variable:
```BLUEIRIS_VERISION=4```


# Known Issues:
* Saving and restoring settings backup via the BlueIris interface does not work!
