# ASUS VivoBook display color configuration

Reproducible X11 display configuration for the ASUS VivoBook X530FN/S530FN panel AUO B156HTN06.1 on connector `eDP-1-1`, 1920x1080 at 60.06 Hz.

The correction is a neutral RGB gamma/contrast curve with factor 1.35. It changes all three channels equally, so it does not add a color cast or crush black detail. The installer also copies the ASUS sRGB and P3 ICC profiles; sRGB is the recommended profile for this panel. It does not lock brightness; brightness remains under the user’s control.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/idruvau5/asus-vivobook-display-color/v0.1.0/install.sh -o /tmp/install-asus-display.sh
bash /tmp/install-asus-display.sh
```

The installer compiles the XRandR helper and enables a user service that reapplies the curve every five seconds. Change `DISPLAY_OUTPUT` in the service for another X11 connector. This is for X11; Wayland requires a compositor color-management path.
