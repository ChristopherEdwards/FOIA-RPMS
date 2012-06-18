XBCOUNT ; IHS/ADC/GTH - COUNT ENTRIES IN FILEMAN FILE ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; This routine counts primary entries in a FileMan file and
 ; corrects the 0th node.
 ;
START ;
 NEW ANS,CTR,FILE,GBL,L,NXT
 W !,"This program counts primary entries for a FileMan file.",!
LOOP ;
 W !
 S DIC=1,DIC(0)="AE"
 D ^DIC
 G:Y<0 EOJ
 S FILE=+Y
ENT ;
 I '$D(^DIC(FILE,0,"GL")) W !!,"DIC file entry invalid or does not exist!",! G LOOP
 S GBL=^DIC(FILE,0,"GL")
 I '$D(@($S($E(GBL,$L(GBL))="(":$E(GBL,1,$L(GBL)-1),1:$E(GBL,1,$L(GBL)-1)_")"))) W !!,"Bad global!!",! G LOOP
 S GBL=GBL_"NXT)"
 S (XBHI,NXT,CTR)=0
 F L=0:0 S NXT=$O(@(GBL)) Q:NXT'=+NXT  S XBHI=NXT,CTR=CTR+1 W:'(CTR#50) "."
 W !!,"FileMan file ",FILE," contains ",CTR," entries.  High DFN=",XBHI,!
 S NXT="",XBX=$O(@(GBL)),XBX=^(0),XBY=$P(XBX,U,4),XBX=$P(XBX,U,3)
 W !,"The 0th node says ",XBY,", ",XBX," respectively."
 I CTR'=XBY!(XBHI'=XBX) W !,"  Do you want me to fix it? (Y/N) Y//" R ANS:$G(DTIME,999) I "Y"[$E(ANS) S NXT=0,$P(@(GBL),U,3)=XBHI,$P(^(0),U,4)=CTR W "  Done"
 G LOOP
 ;
EOJ ;
 KILL ANS,XBHI,XBX,XBY,CTR,DIC,FILE,GBL,L,NXT
 Q
 ;
