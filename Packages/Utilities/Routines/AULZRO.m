%AULZRO ; LISTS 0TH NODES [ 11/17/87  10:40 AM ]
 ;
 W !,"This routine lists the 0th nodes of FileMan files by a range",!,"of file numbers."
 ;
LO R !!,"Enter low  file number: ",AULZLO G:AULZLO="" EOJ G:AULZLO'=+AULZLO ERR
HI R !,"Enter high file number: ",AULZHI S:AULZHI="" AULZHI=AULZLO G:AULZHI'=+AULZHI!(AULZHI<AULZLO) ERR
 W !
 S AULZFILE=(AULZLO-.00000001) F AULZL=0:0 S AULZFILE=$O(^DIC(AULZFILE)) Q:AULZFILE>AULZHI!(AULZFILE'=+AULZFILE)  S AULZG="" I $D(^DIC(AULZFILE,0,"GL")) S AULZG=^("GL") D HI2
 G LO
HI2 ;
 S AULZX=$L(AULZG),AULZX=$E(AULZG,1,AULZX-1)_$S($E(AULZG,AULZX)=",":",0)",1:"(0)") S AULZZN="<DOES NOT EXIST>" S:$D(@AULZX) AULZZN=^(0)
 W !,AULZFILE,?15,AULZX,?35,AULZZN
 Q
ERR W !!,"File numbers must be canonic, and the ending file must not be < than the",!,"  beginning file!",!
EOJ ;
 K AULZLO,AULZHI,AULZFILE,AULZL,AULZG,AULZX,AULZZN
 Q
