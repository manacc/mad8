
# makefile for mad 8 / desy edition with patch from W.Decking (Desy)
# working under desy/linux (cosmos)
# working under windows using cygwin+intel fortran 9.1+ microsoft link.exe
#
# call under windows:
#  make mad8.exe 
#
# call unter linux:
#  make mad.doom 
#  make mad.doom.noplot
#  make mad.standard
#  make mad.standard.noplot
#
# cleanup with:
#  make clean
#
# building docs with:
#  make doc
#
# removing docs with:
#  make rmdoc
#
# first version based on the slac makefile
# Feb. 21 2007 Sascha Meykopff (Desy)
#

  SYS=linux
  FCOMP=gfortran-4.4
  FCOPTS=-Wno-globals -m64 -O3
#  CERN=/cern/2002/lib
  CERN=/cern/new/lib
  Xlib=/usr/lib/x86_64-linux-gnu/
  LIBS=$(CERN)/libmathlib.a $(CERN)/libpacklib.a $(CERN)/libkernlib.a \
       $(Xlib)/libX11.a $(Xlib)/libxcb.a $(Xlib)/libXau.a $(Xlib)/libXdmcp.a  -lnsl -lm -lc
  ASTLIB=
  GCC_FLAGS=-g -m64 -ansi -Wall -D_SWAP_ -D_LINUX_ -D__LINUX__ 
  MPACK=files/madpackage_SLAC.tgz
  AST=./astuce
  
# intel fortran compiler 9.1:
  FCOMPWIN=ifort.exe
  FOPTSWIN=/nologo /c
# this is the path to microsoft link.exe in cygwin style:
# you can't use gnu link, beware it's in the path!
  VISUALCLINK="/C/Program Files/Microsoft Visual Studio 8/VC/bin/link.exe"
  
astuce.f:
	tar xfzO $(MPACK) madpackage/astuce.f > astuce.f

astuce: astuce.f
	$(FCOMP) $(FCOPTS) -o astuce astuce.f $(ASTLIB)

mad8.dict:
	tar xfzO $(MPACK) madpackage/mad8.dict > mad8.dict

dict: mad8.dict
	chmod -x mad8.dict
	cp mad8.dict dict
  
doom.c:
	tar xfzO $(MPACK) madpackage/doom.c > doom.c 
	
doom.h:
	tar xfzO $(MPACK) madpackage/doom.h > doom.h
	
doomex.h:
	tar xfzO $(MPACK) madpackage/doomex.h > doomex.h
	
doom.o: doom.c doom.h doomex.h
	$(CC) $(GCC_FLAGS) -c -o doom.o doom.c

doom_newdb.c:
	tar xfzO $(MPACK) madpackage/doom_newdb.c > doom_newdb.c 

doom_newdb: doom_newdb.c doom.o
	$(CC) $(GCC_FLAGS) -o doom_newdb doom_newdb.c doom.o -lm -lc

gxx11.ss:
	tar xfzO $(MPACK) madpackage/gxx11.ss > gxx11.ss

gxx11.f: gxx11.ss astuce
	$(AST) -s gxx11.ss -f gxx11.f -d fortran

gxx11.o: gxx11.f
	$(FCOMP) -c $(FCOPTS) gxx11.f

gxx11c.c: gxx11.ss astuce
	$(AST) -s gxx11.ss -f gxx11c.c -d c

gxx11c.o: gxx11c.c
	$(CC) $(GCC_FLAGS) -c gxx11c.c	

mad8.ss:
	tar xfzO $(MPACK) madpackage/mad8.ss > mad8.ss
	patch -p0 mad8.ss <  files/mad8.ss_mad8.51.16wd_.patch

mad.doom.f: mad8.ss astuce
	$(AST) -s mad8.ss -f mad.doom.f -d $(SYS),unix,doom,desy

mad.doom.o: mad.doom.f
	$(FCOMP) $(FCOPTS) -c -o mad.doom.o mad.doom.f
	
mad.doom: mad.doom.o doom.o gxx11.o gxx11c.o dict
	$(FCOMP) $(FCOPTS) -o mad.doom mad.doom.o doom.o gxx11.o gxx11c.o $(LIBS) -lm -lc
	mv mad.doom mad8d
	
mad.doom.noplot.f: mad8.ss astuce
	$(AST) -s mad8.ss -f mad.doom.noplot.f -d unix,doom,noplot,desy
	
mad.doom.noplot.o: mad.doom.noplot.f
	$(FCOMP) $(FCOPTS) -c -o mad.doom.noplot.o mad.doom.noplot.f
	
mad.doom.noplot: mad.doom.noplot.o doom.o dict
	$(FCOMP) $(FCOPTS) -o mad.doom.noplot mad.doom.noplot.o doom.o $(LIBS) -lm -lc
	mv mad.doom.noplot mad8dnp
	
mad.standard.f: mad8.ss astuce
	$(AST) -s mad8.ss -f mad.standard.f -d unix,standard,slac,desy
	
mad.standard.o: mad.standard.f
	$(FCOMP) $(FCOPTS) -c -o mad.standard.o mad.standard.f
	
mad.standard: mad.standard.o gxx11.o gxx11c.o dict
	$(FCOMP) $(FCOPTS) -o mad.standard mad.standard.o gxx11.o gxx11c.o $(LIBS) -lm -lc
	mv mad.standard mad8s
	
mad.standard.noplot.f: mad8.ss astuce
	$(AST) -s mad8.ss -f mad.standard.noplot.f -d unix,standard,slac,noplot,desy
	
mad.standard.noplot.o: mad.standard.noplot.f
	$(FCOMP) $(FCOPTS) -c -o mad.standard.noplot.o mad.standard.noplot.f
	
mad.standard.noplot: mad.standard.noplot.o dict
	$(FCOMP) $(FCOPTS) -o mad.standard.noplot mad.standard.noplot.o $(LIBS) -lm -lc
	mv mad.standard.noplot mad8snp

mad.windows.f: mad8.ss astuce
	$(AST) -s mad8.ss -f mad.windows.f -d standard,slac,windows,desy
	
gxx11.windows.f: gxx11.ss astuce
	$(AST) -s gxx11.ss -f gxx11.windows.f -d fortran,noterm,windows,comment

mad.windows.obj: mad.windows.f
	$(FCOMPWIN) $(FOPTSWIN) mad.windows.f

gxx11.windows.obj: gxx11.windows.f
	$(FCOMPWIN) $(FOPTSWIN) gxx11.windows.f

cernmath.lib:
	tar xfjO files/cernmath.lib.tar.bz2 >cernmath.lib

mad8.exe: gxx11.windows.obj mad.windows.obj cernmath.lib mad8.dict
	$(VISUALCLINK) /out:mad8.exe gxx11.windows.obj mad.windows.obj cernmath.lib

c6t.h:
	tar xfzO $(MPACK) madpackage/c6t.h > c6t.h

c6t.c:
	tar xfzO $(MPACK) madpackage/c6t.c > c6t.c

c6t: c6t.c c6t.h doom.o
	$(CC) $(GCC_FLAGS) -o c6t c6t.c doom.o -lm -lc

SXF_in.c:
	tar xfzO $(MPACK) madpackage/SXF_in.c > SXF_in.c
	
SXF_in: SXF_in.c doom.o
	$(CC) $(GCC_FLAGS) -o SXF_in SXF_in.c doom.o -lm -lc

SXF_ex.c:
	tar xfzO $(MPACK) madpackage/SXF_ex.c > SXF_ex.c
	
SXF_ex: SXF_ex.c doom.o
	$(CC) $(GCC_FLAGS) -o SXF_ex SXF_ex.c doom.o -lm -lc

get_corr3.f:
	tar xfzO $(MPACK) madpackage/get_corr3.f > get_corr3.f
	
get_corr3: get_corr3.f doom.o
	$(FCOMP) $(FCOPTS) -o get_corr3 get_corr3.f doom.o $(LIBS) -lm -lc

clean:
	rm -f *.c *.h *.ss *.f *.o *.obj astuce astuce.exe cernmath.lib

doc:
	tar xfz $(MPACK) madpackage/mad8_lcav.pdf madpackage/mad8_phys.pdf madpackage/mad8_prog.pdf madpackage/mad8_user.pdf madpackage/madpackage.Read_Me madpackage/madpackage_SLAC.Read_Me
	mv madpackage/mad8_lcav.pdf ./
	mv madpackage/mad8_phys.pdf ./
	mv madpackage/mad8_prog.pdf ./
	mv madpackage/mad8_user.pdf ./
	mv madpackage/madpackage.Read_Me ./ReadMe.txt
	mv madpackage/madpackage_SLAC.Read_Me ./ReadMe_SLAC.txt
	rmdir  --ignore-fail-on-non-empty madpackage

rmdoc:
	rm -f mad8_lcav.pdf mad8_phys.pdf mad8_prog.pdf mad8_user.pdf ReadMe.txt ReadMe_SLAC.txt


