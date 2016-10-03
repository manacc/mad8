# Manchester Accelerator Physics - MAD8-DESY
A copy of the MAD8 code derived from an archived copy at DESY.

MAD8 is the predecessor of MADX (don't ask about MAD9), but has fallen out of use a bit and is quite difficult to find.

The version here should compile under linux. Other OS's may vary; it is probably easier to use our Docker image, located [here](https://hub.docker.com/r/manacc/mad8/).

If you do decide to compile this yourself, there are a few hardcoded paths that can't be fixed. 
The three libraries (libpacklib.a, libkernlib.a, libmathlib.a) must be placed in the directory /cern/new/lib before attempting to compile.

Everything hosted here can be found elsewhere online. This repository is a central place to keep the required parts together in case any of them ceases to be hosted elsewhere.

For example, the CERN libraries are [here](http://cernlib.web.cern.ch/cernlib/download/2006b_x86_64-slc5-gcc43-opt/lib/) and the MAD8 source is [here](http://www.desy.de/fel-beam/mad8/index.html).

As far as we could tell there were no licensing restrictions on these files. 
