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
  --init \
  --restart=always \
  -e TZ=America/Los_Angeles \
  -p 8080:8080 \
  -p 5900:5900 \
  -p 81:81 \
  -v /path/to/data:/home/wineuser/prefix:rw \
  --log-opt max-size=5m --log-opt max-file=2 \
  jshridha/blueiris
  ```
* **NOTES:**

* The container must be run in privileged mode for the first run to allow installation of the Visual C++ components. The privileged flag can be removed after the first run.
* TZ must be specified in order to get correct time in the Windows environment.
* --init option is required as a separate script now runs inside to check if BlueIris.exe is running and kills PID 1 to stop the container.
* The `/path/to/data` can be a docker named volume or a local path.  Set permissions for local path to 777 with `chmod 777 /path/to/data`.  It's probably best to use a local path on your host so you can drop things in it if you need to.  `/home/wineuser/prefix` in the container is the wine prefix environment.  This is the persistent data.  It can be used in normal mode and in service mode.
* The container runs as user `wineuser` with uid `1000`.  

* As Wine/BlueIris is running as a non-root user in the container, the Blue Iris Web Server cannot be exposed externally on port 81. Use a non privileged port (above 1024), for example 1025, to expose the web server externally. To do this, change the port in the settings dialog in Blue Iris to a port above 1024 and change the mapping from ``-p 81:81`` to ``-p 81:1025`` .

* Service mode allows you to run blueiris as a service only.  This will disable all the GUI related processes from running.  To run in service mode, you first have to run in normal mode, allow an install to happen, and configure your blue iris server the way you need it to be.  After you're done and no longer need to make changes, destroy the conatiner and re-launch it with the command `-c /etc/supervisor/conf.d/supervisord-service.conf`
* Blue Iris alerts allow you to run various things including shell commands.  Wine allows you to run scripts in the Linux environment and this container has been set up to allow you to do that.  See https://wiki.winehq.org/FAQ#How_do_I_launch_native_applications_from_a_Windows_application.3F
* Example docker run also has log output size limited.  This will help the container storage layer from getting out of control.

## Advanced Options

BlueIris version 5 is supported by default. If you'd like to run BlueIris 4, set the environmental variable:
```BLUEIRIS_VERISION=4```

The default resolution is 1024x768x24. If you need to change the resolution set the environmental variable:
`RESOLUTION=1920x1080x24` or `RESOLUTION=1440x768x24` etc

# Known Issues:
* Saving and restoring settings backup via the BlueIris interface does not work!
