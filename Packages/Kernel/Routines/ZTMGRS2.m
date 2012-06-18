ZTMGRS2 ;SF/RWF SET UP THE MGR ACCOUNT FOR THE SYSTEM ;09/10/2002  17:13 [ 08/24/2004  11:37 AM ]
 ;;8.0;KERNEL;**1010**;Jul 10, 1995
 Q
RELOAD ;Reload any patched routines
 N %D,%S,I,OSMAX,U,X,X1,X2,Y,Z1,Z2,ZTOS,ZTMODE,SCR
 I ^%ZOSF("OS")["MSM" S ZTOS=1
 I ^%ZOSF("OS")["OpenM" S ZTOS=2
 I '$G(ZTOS) D  Q
 .W !,"Operating system not found or not supported.",!
 W !!,"Kernel version 8.0 patch #1010",!,"Renaming routines"
 S SCR="I $P($T(+2^@X),"";"",5)=ZPCHL"
 D @ZTOS
 W !,"ALL DONE"
 Q
 ;
1 ;;MSM-PC/PLUS, MSM for NT or UNIX
 S %S(1)="ZISTCPS^**78,118,127,225**"
 S %S(2)="ZIS^**18,23,69,112,199,191,1008**"
 S %S(3)="ZIS2^**69,104,112,118,136,241**"
 D MOVE
 Q
2 ;;OpenM-NT, Cache/NT, Cache/VMS
 S %S(1)="ZIS4ONT^**34,59,69,191,278,293**"
 S %S(2)="ZISFONT^**34,191,271,1010**"
 S %S(3)="ZISTCPS^**78,118,127,225**"
 S %S(4)="ZIS^**18,23,69,112,199,191,1008**"
 S %S(5)="ZIS2^**69,104,112,118,136,241**"
 S %S(6)="ZOSVONT^**34,94,107,118,136,215,293,1010**"
 D MOVE
 Q
MOVE ;
 S I=0
 F  S I=$O(%S(I)) Q:'I  D
 .S X=$P(%S(I),"^",1)
 .S ZPCHL=$P(%S(I),"^",2)
 .S Y=$T(^@X)
 .S Y=$P(Y," ",1)
 .W !,"Routine: ",X
 .Q:'(X]"")
 .Q:'(Y]"")
 .Q:'($T(^@X)]"")
 .X SCR Q:'$T
 .W ?20,"  Loaded, "
 .X "ZL @X ZS @Y"
 .W ?20,"Saved as ",Y
 Q
