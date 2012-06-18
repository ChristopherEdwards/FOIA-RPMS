ABPVZMM ;FACILITY PVT-INS PACKAGE STARTUP ROUTINE;[ 06/03/91  2:45 PM ]
 ;;2.0;FACILITY PVT-INS TRACKING;*0*;IHS-OKC/KJR;AUGUST 7, 1991
 ;PROCEDURE TO PROCESS SYSTEM STARTUP TASKS
 D ^%AUCLS,^ABPVVAR W @ABPVROFF,@FF
 K ABPV("HD") S ABPV("HD",1)=ABPVTLE
 S ABPV("HD",2)="MASTER MENU" D ^ABPVHD
 Q
 ;--------------------------------------------------------------------
EOP ;TO PROCEDURE PROCESS CLEARING CRT TO END OF PAGE
 I $D(ABPVEOP)=1 I ABPVEOP'["[K" W @ABPVEOP
 I $D(ABPVEOP)=1 I ABPVEOP["[K" X ABPVEOP
 Q
 ;--------------------------------------------------------------------
PAUSE ;PROCEDURE TO PROCESS CRT PAUSE
 S IOP=$I D ^%ZIS K IOP W ! S DX=0,DY=22 X XY
 I $D(ABPVMESS)=0 D
 .S ABPVMESS="...Press any key to continue...",DY=23 X XY
 I $D(ABPVMESS(2))'=1 S DY=23 X XY
 D EOP W:IOST["QUME" ! W @ABPVRON,ABPVMESS,@ABPVROFF,"  "
 I $D(ABPVMESS(2))=1 W !,ABPVMESS(2),"  "
 R *X:DTIME G:'$T PAUSE K ABPVMESS S ABPVX=$C(X)
 Q
 ;--------------------------------------------------------------------
YN ;PROCEDURE TO PROCESS 'YES/NO' DECISION
 S DIR(0)="Y" S:$D(ABPVMESS)=1 DIR("A")=ABPVMESS W *7 D ^DIR
 Q
 ;---------------------------------------------------------------------
SCREEN ;PROCEDURE TO WRITE SCREEN HEADING
 K ABPV("HD") S ABPV("HD",1)=ABPVTLE,ABPV("HD",2)=X D ^ABPVHD
 Q
