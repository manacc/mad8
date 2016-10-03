
**** Mad 8.51.16 **** 
**** Feb-21-2007 **** 

This package provides mad 8. This mad version includes a patch from W. Decking (DESY). It implements an exact Rosenzweig-Serrafin Matrix to be consistent with elegant at low energies.

To run this under windows it is necessary to set the DICT environment variable to your mad8.dict file. For more information read ReadMe.txt and ReadMe_SLAC.txt or the mad 8 for windows homepage (1).


**** building from sources **** 

You can build this version from the sources using gnu make. There are 8 targets:
  make mad8.exe              ; build windows version
  make mad.doom              ; build linux version with doom
  make mad.doom.noplot       ;  - without plotting
  make mad.standard          ; build without doom
  make mad.standard.noplot   ;  - without plotting
  make clean                 ; cleanup directory
  make doc                   ; extract documentation from the archive
  make rmdoc                 ; delete documentation

You need a cygwin environment to build this version under windows. It depends on the Intel Fortran Compiler V9.1 and the link.exe utility from Microsoft. See inside Makefile for more information.

**** files **** 

files/madpackage_SLAC.tgz           - original mad package from SLAC
files/cernmath.lib.tar.bz2          - library with cern and math functions
                                      build with intel fortran 9.1
files/mad8.ss_mad8.51.16wd_.patch   - patch from W. Decking
Makefile                            - make file
ReadMe_DESY.txt                     - this file
dict                                - necessary dictionary (copy)
mad8.dict                           - necessary dictionary
mad8.exe                            - mad 8 executable for windows
mad8s                               - mad 8 executable for linux (cosmos)

**** versions **** 

Feb-21-2007:
  this is the first version
  package build by S. Meykopff (DESY)
  
  
**** more information **** 
  
(1) Mad 8 for windows homepage:
http://project-madwindows.web.cern.ch/project-madwindows/MAD-8/default.htm
