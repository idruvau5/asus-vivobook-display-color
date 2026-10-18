#include <X11/Xlib.h>
#include <X11/extensions/Xrandr.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
static double clamp(double x){return x<0?0:x>1?1:x;}
int main(int argc, char **argv){
 Display*d=XOpenDisplay(NULL); if(!d)return 1; Window w=DefaultRootWindow(d);
 XRRScreenResources*r=XRRGetScreenResourcesCurrent(d,w); if(!r)return 2;
 for(int i=0;i<r->noutput;i++){
  XRROutputInfo*o=XRRGetOutputInfo(d,r,r->outputs[i]);
  if(!o)continue;
  const char *target = argc > 1 ? argv[1] : getenv("DISPLAY_OUTPUT"); if (!target) target = "eDP-1-1";
  if(o->connection==RR_Connected && strcmp(o->name,target)==0 && o->crtc){
   XRRCrtcGamma*g=XRRGetCrtcGamma(d,o->crtc); if(g){
    double contrast=1.35;
    for(int n=0;n<g->size;n++){
     double x=(double)n/(g->size-1), y=clamp((x-0.5)*contrast+0.5);
     unsigned short v=(unsigned short)(y*65535.0+0.5);
     g->red[n]=v; g->green[n]=v; g->blue[n]=v;
    }
    XRRSetCrtcGamma(d,o->crtc,g); XRRFreeGamma(g);
   }
  }
  XRRFreeOutputInfo(o);
 }
 XFlush(d); XRRFreeScreenResources(r); XCloseDisplay(d); return 0;
}
