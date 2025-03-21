# sky130n
Open Source IP for Skywater 130nm PDK

# From Stefan Schippers Youtube video - Analog simulation with xschem and the skywater 130nm PDK
https://github.com/StefanSchippers/xschem/blob/master/README_MacOS.md
 - instructions are outdated for Apple Silicon

http://web02.gonzaga.edu/faculty/talarico/vlsi/CADToolsOnMac.html

When I got to install ngspice with homebrew I just ran
brew install ngspice
I didn't go through the whole process listed

To install magic I follwed the instructions on the github read me to
install for MacOS with homebrew. I don't know if that worked. These were the instrutctions at the time of writing:

https://github.com/RTimothyEdwards/magic/blob/master/INSTALL_MacOS.md

# TCL9 should be supported soon (Q2 2025)
brew install cairo tcl-tk@8 python3
brew install --cask xquartz
./scripts/configure_mac
# If you have both TCL8 and TCL9 installed you may need to verify TCL8 was selected.
make database/database.h
make -j$(sysctl -n hw.ncpu)
make install # may need sudo depending on your setup

while some online guides say that homebrew installs things in /usr/local
it appears that with apple silicon, opt/homebrew/ is the location 
https://apple.stackexchange.com/questions/437618/why-is-homebrew-installed-in-opt-homebrew-on-apple-silicon-macs

seems like magic got put in usr/local/magic
but when I try to run it it says wish shut down unexpectedly or something like that, moving on for now.

* revisiting magic installation after sucessfully getting xschem
running.
Using the "Without brew" instructions from the magic Readme_macOS,
the first steps are to build tcl and tk for X11, which I have done, and exists on my system at /usr/local/opt/tck-tk

I will use this location when trying to build magic this time:
./configure --with-tcl=/usr/local/opt/tcl-tk/lib \
--with-tk=/usr/local/opt/tcl-tk/lib \
--x-includes=/opt/X11/include \
--x-libraries=/opt/X11/lib \
CFLAGS=-Wno-error=implicit-function-declaration
make
make install

That worked!

to install netgen/ngsolve, i used pip, per there instauctions:
https://ngsolve.org/downloads
pip install --upgrade  ngsolve

Xschem took me a long time to get right. The build instauctions on the
github MacOS read me are correct, there are just a couple of "gotcha's"
I didn't quite understand when starting out. if you install tck-tk with homebrew or macports, this will not work, because macOS is using a different graphics system, so you need to build these from source for Xquartz. The text below is not instructions. It is my notes of everything that I tried while going through this with some revelations made along the way. Eventually, a minor MacOS update (13.2 to 13.7.4), building tcl-tk from source for X11/Xquartz, removing the macports installation of cairo, 15-20 attempts at building Xschem over the course of a few weeks, and a lot of headscratching, reading and coffee I got it to work.

How not to install xschem on MacOS with Apple Silicon
Alas I did at one point do everything written here, so I'm not sure which
of these steps are necessary.
following directions as written for xschem from gonzaga.edu:
sudo port install gawk
brew install macvim
sudo port install gaw
sudo port install dbus

git clone https://github.com/StefanSchippers/xschem.git xschem_git
cd xschem_git
## set prefix to the base directory where xschem and his support files will be installed
## if unspecified default is /usr/local
./configure --prefix=/Users/$(whoami)/opt/xschem

after getting to this point, the configure command failed when checking for Xquarts.
I had to do a clean install of xquartz using homebrew (I forget how I went about it originally)

brew install --cask xquartz

after doing the above I got the configure command to work

The guide from gonzaga says to make these changes to 
CFLAGS=-std=c99 -I/opt/X11/include -I/opt/X11/include/cairo \
-I/opt/local/include -O2
LDFLAGS=-L/opt/X11/lib -L/opt/local/lib -lm -lcairo -ljpeg\
-lX11 -lXrender -lxcb -lxcb-render -lX11-xcb -lXpm -ltcl8.6 -ltk8.6

I made the above changes and the first attempt at make failed.

This was the error message:
gcc -o xschem icon.o callback.o actions.o move.o check.o clip.o draw.o globals.o  main.o netlist.o hash_iterator.o findnet.o scheduler.o store.o xinit.o  select.o font.o editprop.o save.o paste.o token.o psprint.o node_hash.o  hilight.o options.o vhdl_netlist.o svgdraw.o spice_netlist.o  tedax_netlist.o verilog_netlist.o parselabel.o expandlabel.o  eval_expr.o in_memory_undo.o cairo_jpg.o   -L/opt/X11/lib -L/opt/local/lib -lm -lcairo -ljpeg -lX11 -lXrender -lxcb -lxcb-render -lX11-xcb -lXpm -ltcl8.6 -ltk8.6
ld: library not found for -ltcl8.6
clang: error: linker command failed with exit code 1 (use -v to see invocation)
make[1]: *** [xschem] Error 1
make: *** [all] Error 2

The second time I tried it, I re-ran .configure command and did not make any changes
to the Makefile.conf. It appears to have gotten through the build cleanly...

when I run ./xschem I seem to go into a sort of xschem shell but don't get a GUI

so I assume the installation did not go as required.
So next I repeat the steps again starting from configure
 This time I replace the CFLAGS and LDFLAGS with the above lines but change
 -ltcl8.6 and -ltk8.6 to 8.5 because it seems like that's what the configure command found on my system

 That gave the same result.
 It must have to do with all the different xquarts and tcl-tk installations on my system:

 /opt/homebrew/Cellar/tcl-tk@8/8.6.16/bin
 /opt/homebrew/Cellar/tcl-tk/9.0.1/bin
./homebrew/include/tcl-tk
./homebrew/var/homebrew/linked/tcl-tk
./homebrew/opt/tcl-tk
./homebrew/Cellar/tcl-tk
./homebrew/Cellar/tcl-tk/9.0.1/include/tcl-tk
./homebrew/Cellar/tcl-tk@8/8.6.16/include/tcl-tk

/usr/local/bin/tclsh
/usr/local/bin/tclsh8.6

/usr/local/opt/

usr/X11
usr/X11R6
/usr/X11/bin/Xquartz
/usr/X11/bin/cairo-trace
/usr/X11/include/cairo

/opt/X11/include/cairo

MacOS comes with tcl 8.5 in /usr and this is what the configure command keeps finding
/usr/bin/tclsh8.5



-- Xschem installation debugging notes --
When I run the configure command I get these lines (among others)
Checking for XOpenDisplay... OK ('', '-I/opt/X11/include' and '-L/opt/X11/lib -lX11')
Checking for tk... 8.6... (no tcl) 8.5... OK ('', '' and '-ltcl8.5')
OK ('', ' -I/opt/X11/include' and '-ltcl8.5 -L/opt/X11/lib -ltk8.5')
Checking for awk... OK (awk)
Checking for xpm... OK ('', '-I/opt/X11/include ' and '-L/opt/X11/lib -lX11 -lXpm')
Checking for cairo... OK ('', '-I/opt/local/include/cairo -I/opt/local/include -I/opt/local/include/glib-2.0 -I/opt/local/lib/glib-2.0/include -I/opt/local/include -I/opt/local/include/pixman-1 -I/opt/local/include -I/opt/local/include/freetype2 -I/opt/local/include -I/opt/local/include/libpng16 -I/opt/local/include' and '-L/opt/local/lib -lcairo')

Checking for cairo... OK ('', '-I/opt/local/include/cairo -I/opt/local/include -I/opt/local/include/glib-2.0 -I/opt/local/lib/glib-2.0/include -I/opt/local/include -I/opt/local/include/pixman-1 -I/opt/local/include -I/opt/local/include/freetype2 -I/opt/local/include -I/opt/local/include/libpng16 -I/opt/local/include' and '-L/opt/local/lib -lcairo')
Checking for cairo-xcb... OK ('#include <cairo-xcb.h>\n', '-I/opt/local/include/cairo -I/opt/local/include -I/opt/local/include/glib-2.0 -I/opt/local/lib/glib-2.0/include -I/opt/local/include -I/opt/local/include/pixman-1 -I/opt/local/include -I/opt/local/include/freetype2 -I/opt/local/include -I/opt/local/include/libpng16 -I/opt/local/include' and '-L/opt/local/lib -lcairo')

After doing a little digging I found this thread about tcl-tk and X11 / Xquartz:
https://github.com/StefanSchippers/xschem/issues/24

notably, this line:
"Xschem can not run with native macOS tcl-tk libraries, as native graphics on macOS is Quartz and not X11, in order to run xschem (which is an X11 application) you need to use the xquartz layer and tcl-tk built and linked with xquartz."

So I think what's going on is: Xschem refuses to find my homebrew installed tcl-tk because it is quartz and not X11. So by trying to avoid the provided instructions (install xquartz, and tcl-tk from source rather then with homebrew), I have created this problem for myself. So let's try again following the rules, and build these from source.

I went through the build from source and left tcl build from a few weeks ago that I think went ok. They should both now be in /usr/local/opt/tcl-tk

The configure command still failed to find tcl8.6 and reports 8.5 but I ignored this message and just chnaged the makefile.conf as indicated by the github readme (its a little different from gonzaga):

CFLAGS=-I/opt/X11/include -I/opt/X11/include/cairo \
-I/usr/local/opt/tcl-tk/include -O2
LDFLAGS=-L/opt/X11/lib -L/usr/local/opt/tcl-tk/lib -lm -lcairo \
-lX11 -lXrender -lxcb -lxcb-render -lX11-xcb -lXpm -ltcl8.6 -ltk8.6

when I ran this I got up to here when running make:

gcc -c -I/opt/X11/include -I/opt/X11/include/cairo -I/usr/local/opt/tcl-tk/include -O2 -o cairo_jpg.o cairo_jpg.c
cairo_jpg.c:48:10: fatal error: 'jpeglib.h' file not found
#include <jpeglib.h>
         ^~~~~~~~~~~
1 error generated.
make[1]: *** [cairo_jpg.o] Error 1
make: *** [all] Error 2

so it seems that the header files in /opt/X11/include/cairo do not include jpeglib.h, which is required by the file cairo_jpg.c while building.

I could find any jpeglib.h anywhere in /usr/*
but I did find it in /opt/local/include/jpeglib.h
which I think implies that it got installed by macports 

so I'm gonna try adding this line : -I/opt/local/include
to the CFLAGS and see what happens.
That certainly did not work:

ld: symbol(s) not found for architecture arm64
clang: error: linker command failed with exit code 1 (use -v to see invocation)
make[1]: *** [xschem] Error 1
make: *** [all] Error 2

So I'm sort of convinced i've got something wrong with cairo or xquartz

... let me try to just copy jpeglib.h from /opt/local/include to /opt/X11/include
hopefully that isn't very naughty
needed sudo

The installation of /opt/X11 is clearly very old (mostly from Jan 2023)

tried make again, now I'm missing jconfig.h
copied that over too
same for jmorecfg.h
so I copied j*h from one to the other

After running some macports installs from gonzaga page
 including all the tcl and cairo and all that, I got a build through
 that launched a gui after a reboot. The build was in the 
/Users/$(whoami)/opt/xschem
The problem with the above install was that it was not responding,
infinite spinny wheel on MacOS

What finally worked:
after so much trial and error it seems what was going wrong at the end was that the xschem installation or possibly the dynamic linker kept picking up the version of cairo installed by macports in /opt/local
instead of the one in /opt/X11 that I needed. 

Running a port uninstall cairo fixed the issue, so I could install using the directions provided by the MacOS read me in Xschem


# Install Sky130 PDK
I'm following the instructions in the Xschem manual but basically here are the steps:

git clone https://github.com/RTimothyEdwards/open_pdks.git
cd open_pdks
./configure --enable-sky130-pdk --enable-sram-sky130 
make
sudo make install
make veryclean


From the manual:
After completing the above steps you can do a test run of xschem and use the Sky130 devices. You need to create
a new empty drectory, create a new xschemrc file with the following content: (source <prefix>/share/pdk/sky130B/libs.tech/xschem/xschemrc) and run xschem:
        mkdir test_xschem_sky130
        cd test_xschem_sky130
        echo 'source /usr/local/share/pdk/sky130B/libs.tech/xschem/xschemrc' > ./xschemrc
        xschem
• If all went well the following welcome page will be shown.

Good to go!!!
I thnk magic is a prerequisite for the pdk install but otherwise this was the easiest step