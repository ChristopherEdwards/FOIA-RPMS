ABPAMAIN ;PACKAGE STARTUP ROUTINE;[ 07/25/91  11:26 AM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
 ;--------------------------------------------------------------------
 ;PROCEDURE TO PROCESS SYSTEM START-UP PROCEDURES
 D ^ABPAVAR W @ABPAROFF,@IOF S ABPAHD1="MASTER MENU" D HEADER
 Q
 ;--------------------------------------------------------------------
EOP ;PROCEDURE TO PROCESS CLEARING CRT TO END OF PAGE
 I $D(ABPAEOP)=1 I ABPAEOP'["[K" W @ABPAEOP
 I $D(ABPAEOP)=1 I ABPAEOP["[K" X ABPAEOP
 Q
 ;--------------------------------------------------------------------
PAUSE ;PROCEDURE TO PROCESS CRT PAUSE
 S IOP=$I D ^%ZIS K IOP W !! S DX=0,DY=22 X XY
 I $D(ABPAMESS)=0 D
 .S ABPAMESS="...Press any key to continue...",DY=23 X XY
 I $D(ABPAMESS(2))'=1 S DY=23 X XY
 D EOP W:IOST["QUME" ! W @ABPARON,ABPAMESS,@ABPAROFF,"  "
 I $D(ABPAMESS(2))=1 W !,ABPAMESS(2),"  "
 R *X:DTIME K ABPAMESS S ABPAX=$C(X)
 Q
 ;---------------------------------------------------------------------
DTCVT ;PROCEDURE TO PROCESS FILEMAN DATE CONVERSION
 ;REQUIRES 'ABPA("DTIN")' BE DEFINED
 ;RETURNS 'ABPA("DTOUT")' IN MM/DD/YY FORMAT
 S ABPA("DTOUT")=+$E(ABPA("DTIN"),4,5)_"/"_+$E(ABPA("DTIN"),6,7)_"/"
 S ABPA("DTOUT")=ABPA("DTOUT")_+$E(ABPA("DTIN"),2,3)
 Q
 ;---------------------------------------------------------------------
HEADER ;PROCEDURE TO WRITE SCREEN HEADINGS
 ;REQUIRES 'ABPATLE' BE DEFINED
 K ABPA("HD") S ABPA("HD",1)=ABPATLE
 F I=1:1 Q:$D(@("ABPAHD"_I))'=1  S ABPA("HD",I+1)=@("ABPAHD"_I)
 D ^ABPAHD
 Q
 ;---------------------------------------------------------------------
QUEUED ;PROCEDURE TO PROCESS TASK MANAGER REQUEST MESSAGE
 ;REQUIRES 'ZTSK' BE DEFINED
 K ABPAMESS S ABPAMESS="REQUEST QUEUED!  Task Number: "_ZTSK
 S ABPAMESS(2)="... Press any key to continue ... " D PAUSE
 Q
