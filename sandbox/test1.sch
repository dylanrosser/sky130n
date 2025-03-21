v {xschem version=3.4.6 file_version=1.2}
G {}
K {}
V {}
S {}
E {}
N 300 -280 300 -240 {lab=C}
N 300 -370 300 -340 {lab=B}
N 300 -450 300 -430 {lab=A}
N 300 -450 530 -450 {lab=A}
N 530 -450 530 -360 {lab=A}
N 530 -300 530 -180 {lab=0}
N 530 -180 530 -170 {lab=0}
N 300 -170 530 -170 {lab=0}
N 300 -180 300 -170 {lab=0}
C {res.sym} 530 -330 0 0 {name=R1
value=1k
footprint=1206
device=resistor
m=1}
C {capa-2.sym} 300 -400 0 0 {name=C1
m=1
value=50n
footprint=1206
device=polarized_capacitor}
C {ind.sym} 300 -310 0 0 {name=L1
m=1
value=10m
footprint=1206
device=inductor}
C {vsource_arith.sym} 300 -210 0 0 {name=E1 VOL="'3*cos(time*time*time*1e11)'"}
C {lab_pin.sym} 530 -450 0 1 {name=p1 sig_type=std_logic lab=A}
C {lab_pin.sym} 530 -170 0 1 {name=p2 sig_type=std_logic lab=0



}
C {code.sym} 670 -370 0 0 {name=stimuli
only_toplevel=false
value="
.tran 10n 2000u uic
.save all
"}
C {title.sym} 180 -40 0 0 {name=l3 author="Dylan Rosser"}
C {lab_pin.sym} 300 -360 0 1 {name=p3 sig_type=std_logic lab=B}
C {lab_pin.sym} 300 -260 0 1 {name=p4 sig_type=std_logic lab=C}
