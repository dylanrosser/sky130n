v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 625 -385 625 -345 {lab=Y}
N 545 -315 585 -315 {lab=A}
N 545 -415 545 -315 {lab=A}
N 545 -415 585 -415 {lab=A}
N 625 -365 655 -365 {lab=Y}
N 525 -365 545 -365 {lab=A}
N 625 -475 625 -445 {lab=VDD}
N 625 -285 625 -255 {lab=GND}
N 395 -415 395 -385 {lab=VDD}
N 400 -270 400 -240 {lab=A}
N 395 -325 395 -310 {lab=GND}
N 625 -415 630 -415 {lab=VDD}
N 630 -460 630 -415 {lab=VDD}
N 625 -460 630 -460 {lab=VDD}
N 625 -315 630 -315 {lab=GND}
N 630 -315 630 -270 {lab=GND}
N 625 -270 630 -270 {lab=GND}
N 400 -180 400 -160 {lab=GND}
C {sky130_fd_pr/nfet_01v8.sym} 605 -315 0 0 {name=M3
W=1
L=0.15
nf=1 
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 605 -415 0 0 {name=M1
W=2
L=0.15
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {vdd.sym} 625 -475 0 0 {name=l1 lab=VDD}
C {gnd.sym} 625 -255 0 0 {name=l2 lab=GND}
C {vsource.sym} 395 -355 0 0 {name=V1 value=vdd_1p8v savecurrent=false}
C {vsource.sym} 400 -210 0 0 {name=V2 value=3 savecurrent=false}
C {gnd.sym} 400 -160 0 0 {name=l3 lab=GND}
C {gnd.sym} 395 -310 0 0 {name=l5 lab=GND}
C {vdd.sym} 395 -415 0 0 {name=l7 lab=VDD}
C {lab_wire.sym} 400 -260 0 0 {name=p1 sig_type=std_logic lab=A }
C {lab_wire.sym} 525 -365 0 0 {name=p2 sig_type=std_logic lab=A }
C {lab_wire.sym} 655 -365 0 1 {name=p3 sig_type=std_logic lab=Y }
C {sky130_fd_pr/corner.sym} 25 -640 0 0 {name=CORNER only_toplevel=true corner=tt}
C {title.sym} 160 -30 0 0 {name=l8 author="Dylan Rosser"}
C {simulator_commands_shown.sym} 35 -425 0 0 {name=COMMANDS
simulator=ngspice
only_toplevel=false 
value="
.param vdd_1p8v=1.8
.control
  save all
  dc V2 0 1.8 100m
  write tb_inv.raw
.endc
"}
