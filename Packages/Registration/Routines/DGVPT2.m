DGVPT2 ;ALB/MRL - DG POST-INIT (CHECK FOR UNPROTECTED PIMS FILES); 01 OCT 88
 ;;5.3;Registration;;Aug 13, 1993
 W !!,">>> Checking to see if any PIMS files are unprotected...",!
 S (F,F1)=0 F I=0:0 S F=$O(^DIC(9.4,"C","DG",F)) Q:F=""  I $D(^DIC(9.4,F,0)),$P(^(0),"^",1)="REGISTRATION" S F1=F Q
 I F1 S F=0 F I=0:0 S F=$O(^DIC(9.4,F1,4,F)) Q:F=""  I $D(^(F,0)) S X=+^(0) D CHK
 F X=2,48,391 D CHK
 I '$O(DGF(0)) W !!,">>> No unprotected files found..." G Q
 S X="DD^DELETE^LAYGO^READ^WRITE"
 S F=0 F I=0:0 S F=$O(DGF(F)) Q:F=""  W !,$P(DGF(F),"^",6)," (#",F,") has no " S (C,C1,C2)=0 X "F I2=1:1:5 I $P(DGF(F),""^"",I2) S C1=C1+1" F I1=1:1:5 S C=C+1 I $P(DGF(F),"^",I1) S C2=C2+1 W $P(X,"^",C),$S(C2=C1:".",1:",")
 W !!,">>> Please note that this information is provided for informational purposes",!?4,"only.  Lack of file protection does not necessarily indicate a problem since",!?4,"need and level of protection is determined by the local facility."
Q K F,F1,I,I1,DGF,X,C,C1,C2 Q
 Q
CHK S C=0 F I1="DD","DEL","LAYGO","RD","WR" S C=C+1 I $S('$D(^DIC(+X,0,I1)):1,^(I1)']"":1,1:0) S $P(DGF(X),"^",C)=1
 I $D(DGF(X)) S $P(DGF(X),"^",6)=$S($D(^DIC(+X,0)):$E($P(^(0),"^",1),1,30),1:"FILE NAME UNKNOWN")
 Q
