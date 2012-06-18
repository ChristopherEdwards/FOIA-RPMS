%AUCOUNT ; COUNT ENTIRES IN FILEMAN FILE [ 10/08/86  2:27 PM ]
 W !,"This program counts primary entries for a FileMan file.",!
LOOP ;
 W !
 S DIC=1,DIC(0)="AE" D ^DIC
 G:Y<0 EOJ
 S FILE=+Y
 I '$D(^DIC(FILE,0,"GL")) W !!,"DIC file entry invalid or does not exist!",! G LOOP
 S GBL=^DIC(FILE,0,"GL")
 I '$D(@($S($E(GBL,$L(GBL))="(":$E(GBL,1,$L(GBL)-1),1:$E(GBL,1,$L(GBL)-1)_")"))) W !!,"Bad global!!",! G LOOP
 S GBL=GBL_"NXT)"
 S (AUHI,NXT,CTR)=0
 F L=0:0 S NXT=$O(@(GBL)) Q:NXT'=+NXT  S AUHI=NXT,CTR=CTR+1 W:'(CTR#50) "."
 W !!,"FileMan file ",FILE," contains ",CTR," entries.  High DFN=",AUHI,!
 S NXT="",AUX=$O(@(GBL)),AUX=^(0),AUY=$P(AUX,U,4),AUX=$P(AUX,U,3)
 I CTR'=AUY!(AUHI'=AUX) W !,"The 0th node says ",AUY,", ",AUX," respectively.",!,"  Do you want me to fix it? (Y/N) Y//" R ANS I "Y"[$E(ANS) S $P(^(0),U,3)=AUHI,$P(^(0),U,4)=CTR W "  Done"
 G LOOP
 ;
EOJ ;
 K ANS,AUHI,AUX,AUY,CTR,DIC,DIC(0),FILE,GBL,L,NXT
 Q
