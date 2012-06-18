ABPADETC ; DETAILED CLAIM DISPLAY; [ 07/25/91  7:34 AM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
 ;;MODIFICATION OF COMPILED TEMPLATE: ABPA/DETAILED/CLAIM/DISPLAY
 K DIPTDFN S DIPTDFN=$O(^DIPT("B","ABPA/DETAILED/CLAIM/DISPLAY",""))
 I +DIPTDFN'>0 K DIPTDFN Q
 Q:$D(^DIPT(+DIPTDFN,"DXS"))=0  D ^%AUCLS S DC=1 K DXS G BEGIN
N W !
T W:$X ! I '$D(DIOT(2)),DN,$D(IOSL),$S('$D(DIWF):1,$P(DIWF,"B",2):$P(DIWF,"B",2),1:1)+$Y'<IOSL,$D(^TMP($J,1))#2,^(1)?1U1P1E.E X ^(1)
 Q
DT I Y W $P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC",U,$E(Y,4,5))_" " W:Y#100 $J(Y#100\1,2)_"," W Y\10000+1700 W:Y#1 "  "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12) Q
 W Y Q
M D @DIXX
 Q
BEGIN ;
 S:'$D(DN) DN=1
 I $D(DXS)<9 F X=0:0 S X=$O(^DIPT(+DIPTDFN,"DXS",X)) Q:'X  S Y=$O(^(X,"")) F X=X:0 Q:Y=""  S DXS(X,Y)=^(Y),Y=$O(^(Y))
 I $D(DXS(2,9))=1 D
 .S DXS(2,9)=$P(DXS(2,9),"X=X_Y_"")""")
 .S DXS(2,9)=DXS(2,9)_"X=X_$S(Y]"""":Y,1:""NO SSN ON FILE"")_"")"""
 W ?0 W "==============================================================================="
 D N:$X>0 Q:'DN  W ?0 S X=DT S X=X S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W X
 S X=ABPATLE,X=$J("",$S($D(DIWR)+$D(DIWL)=2:DIWR-DIWL+1,$D(IOM):IOM,1:80)-$L(X)\2-$X)_X K DIP K:DN Y W X
 D N:$X>71 Q:'DN  W ?71 W "Page:"
 D N:$X>77 Q:'DN  W ?77 S X=$S($D(DC)#2:DC,1:"") K DIP K:DN Y W $E(X,1,2)
 D N:$X>0 Q:'DN  W ?0 X DXS(1,9.2) S X=$E($P(X,".",2)_"0000",1,4),%=X>1159 S:X>1259 X=X-1200 S X=X\100_":"_$E(X#100+100,2,3)_" "_$E("AP",%+1)_"M" K DIP K:DN Y W X
 S X="*** CLAIM DETAIL DISPLAY ***",X=$J("",$S($D(DIWR)+$D(DIWL)=2:DIWR-DIWL+1,$D(IOM):IOM,1:80)-$L(X)\2-$X)_X K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "==============================================================================="
 F Y=0:0 Q:$Y>5  W !
 D N:$X>9 Q:'DN  W ?16 W "Patient Name:"
 D N:$X>31 Q:'DN  W ?31 X DXS(2,9) K DIP K:DN Y W X
 F Y=0:0 Q:$Y>6  W !
 D N:$X>9 Q:'DN  W ?20 W "Facility:"
 S X=$S($D(^ABPVAO(D0,0)):^(0),1:"") D N:$X>31 Q:'DN  W ?31 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^AUTTLOC(Y,0))#2:$P(^(0),U,1),1:Y) S Y=$S(Y="":Y,$D(^DIC(4,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 F Y=0:0 Q:$Y>7  W !
 D N:$X>8 Q:'DN  W ?8 W "Health Record Number:"
 D N:$X>31 Q:'DN  W ?31,$E($P(X,U,3),1,10)
 F Y=0:0 Q:$Y>8  W !
 S I(1)=1,J(1)=9002270.21 F D1=0:0 Q:$N(^ABPVAO(D0,1,D1))'>0  X:$D(DSC(9002270.21)) DSC(9002270.21) S D1=ABPAC1-1,D1=$N(^(D1)) Q:D1'>0  D:$X>0 T Q:'DN  D A1 S D1=999999999
 G A1R
A1 ;
 F Y=0:0 Q:$Y>8  W !
 D N:$X>9 Q:'DN  W ?13 W "Date of Service:"
 D N:$X>31 Q:'DN  W ?31 S DIP(1)=$S($D(^ABPVAO(D0,1,D1,0)):^(0),1:"") S X=$P(DIP(1),U,1) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W X
 F Y=0:0 Q:$Y>9  W !
 S DXS(3,"A")="ADJUSTMENT",DXS(3,"D")="DENTAL"
 S DXS(3,"I")="INPATIENT (HOSPITAL ONLY)",DXS(3,"O")="OUTPATIENT"
 S DXS(3,"P")="INPATIENT (PHYSICIAN ONLY)"
 D N:$X>9 Q:'DN  W ?18 W "Visit Type:"
 S X=$S($D(^ABPVAO(D0,1,D1,0)):^(0),1:"") D N:$X>31 Q:'DN  W ?31 S Y=$P(X,U,4) W:Y]"" $S($D(DXS(3,Y)):DXS(3,Y),1:Y)
 F Y=0:0 Q:$Y>10  W !
 D N:$X>9 Q:'DN  W ?14 W "Days or Visits:"
 D N:$X>31 Q:'DN  W ?31,$E($P(X,U,5),1,10)
 F Y=0:0 Q:$Y>11  W !
 D N:$X>9 Q:'DN  W ?11 W "Insurance Company:"
 D N:$X>31 Q:'DN  W ?31 S Y=$P(X,U,6) S Y=$S(Y="":Y,$D(^AUTNINS(Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,30)
 F Y=0:0 Q:$Y>12  W !
 D N:$X>9 Q:'DN  W ?8 W "Policy Holder's Name:"
 D N:$X>31 Q:'DN  W ?31,$E($P(X,U,8),1,30)
 F Y=0:0 Q:$Y>13  W !
 D N:$X>9 Q:'DN  W ?15 W "Policy Number:"
 D N:$X>31 Q:'DN  W ?31,$E($P(X,U,9),1,15)
 F Y=0:0 Q:$Y>14  W !
 D N:$X>9 Q:'DN  W ?17 W "Bill Amount:"
 S XSAV=X,X=$P(X,U,7) D COMMA^%DTC F I=0:0 Q:$E(X,1)'=" "  S X=$E(X,2,99)
 D N:$X>31 Q:'DN  W ?31,X S X=XSAV K XSAV
 D T Q:'DN  D N W ?0 W "==============================================================================="
 D N:$X>0 Q:'DN  W ?0 W "Bill Transmitted:"
 W ?18 S DIP(1)=$S($D(^ABPVAO(D0,1,D1,0)):^(0),1:"") S X=$P(DIP(1),U,12) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K:DN Y W X
 S DIP=^ABPVAO(D0,1,D1,0) W "   Bill ID: ",$P(DIP,"^",2)
 W ?47,"Current Status: ",$P(DIP(1),U,17) S DIP=$P(DIP(1),U,17)
 W $S(DIP="O":"PEN",DIP="PA":"AYMENTS APPLIED",DIP="C":"LOSED",1:"???")
 K DIP D N:$X>0 Q:'DN  W ?0 W "==============================================================================="
 Q
A1R ;
 K Y,DXS I $D(ABPA("CDEL"))=0 D PAUSE^ABPAMAIN
 Q
HEAD ;
 W !,"--------------------------------------------------------------------------------",!!
