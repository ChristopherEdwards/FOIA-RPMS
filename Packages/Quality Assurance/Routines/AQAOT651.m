AQAOT651 ; GENERATED FROM 'AQAO LONG DISPLAY' PRINT TEMPLATE (#1271) ; 05/13/96 ; (continued)
 G BEGIN
N W !
T W:$X ! I '$D(DIOT(2)),DN,$D(IOSL),$S('$D(DIWF):1,$P(DIWF,"B",2):$P(DIWF,"B",2),1:1)+$Y'<IOSL,$D(^UTILITY($J,1))#2,^(1)?1U1P1E.E X ^(1)
 S DISTP=DISTP+1,DILCT=DILCT+1 D:'(DISTP#100) CSTP^DIO2
 Q
DT I $G(DUZ("LANG"))>1,Y W $$OUT^DIALOGU(Y,"DD") Q
 I Y W $P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC",U,$E(Y,4,5))_" " W:Y#100 $J(Y#100\1,2)_"," W Y\10000+1700 W:Y#1 "  "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12) Q
 W Y Q
M D @DIXX
 Q
BEGIN ;
 S:'$D(DN) DN=1 S DISTP=$G(DISTP),DILCT=$G(DILCT)
 D N:$X>50 Q:'DN  W ?50 W "Rev Date: "
 S Y=$P(X,U,8) D DT
 D N:$X>0 Q:'DN  W ?0 W "Adv Outcome Risk: "
 S Y=$P(X,U,11) S Y(0)=Y S:Y]"" Y=$P(^AQAO1(3,Y,0),U)_"   "_$P(^(0),U,2) W $E(Y,1,30)
 D N:$X>47 Q:'DN  W ?47 W "Occ Outcome: "
 S X=$G(^AQAOC(D0,1)) S Y=$P(X,U,7) S Y(0)=Y S:Y]"" Y=$P(^AQAO1(3,Y,0),U)_"   "_$P(^(0),U,4) W $E(Y,1,30)
 D N:$X>9 Q:'DN  W ?9 W "Finding: "
 X DXS(15,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>41 Q:'DN  W ?41 X DXS(16,9.2) S DIP(3)=X S X=1,DIP(4)=X S X="",X=$S(DIP(2):DIP(3),DIP(4):X) K DIP K:DN Y W X
 S X=$G(^AQAOC(D0,1)) S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^AQAO1(2,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,50)
 D N:$X>52 Q:'DN  W ?52 W "Action: "
 X DXS(17,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 X DXS(18,9.5) S DIP(6)=X S X=",",X=$P(DIP(6),X) S Y=X,X=DIP(5),X=X_Y,X=$S(DIP(2):DIP(3),DIP(4):X) K DIP K:DN Y W $E(X,1,10)
 S I(1)="""IADDRV""",J(1)=9002167.03 F D1=0:0 Q:$O(^AQAOC(D0,"IADDRV",D1))'>0  X:$D(DSC(9002167.03)) DSC(9002167.03) S D1=$O(^(D1)) Q:D1'>0  D:$X>52 T Q:'DN  D H1
 G H1R
H1 ;
 D N:$X>66 Q:'DN  W ?66 X DXS(19,9.3) S DIP(2)=X S X=",",X=$P(DIP(2),X) K DIP K:DN Y W $E(X,1,10)
 Q
H1R ;
 D N:$X>1 Q:'DN  W ?1 W "Review Comments: "
 S I(1)="""1RC""",J(1)=9002167.06 F D1=0:0 Q:$O(^AQAOC(D0,"1RC",D1))'>0  S D1=$O(^(D1)) D:$X>20 T Q:'DN  D I1
 G I1R
I1 ;
 S X=$G(^AQAOC(D0,"1RC",D1,0)) S DIWL=20,DIWR=78 D ^DIWP
 Q
I1R ;
 D 0^DIWW K DIP K:DN Y
 D ^DIWW
 S I(1)="""REV""",J(1)=9002167.01 F D1=0:0 Q:$O(^AQAOC(D0,"REV",D1))'>0  X:$D(DSC(9002167.01)) DSC(9002167.01) S D1=$O(^(D1)) Q:D1'>0  D:$X>19 NX^DIWW D J1
 G J1R
J1 ;
 D T Q:'DN  D N D N:$X>4 Q:'DN  W ?4 W "Review Level: "
 S X=$G(^AQAOC(D0,"REV",D1,0)) S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AQAO(7,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,4)
 D N:$X>23 Q:'DN  W ?23 W "by "
 S Y=$P(X,U,2) S C=$P(^DD(9002167.01,.02,0),U,2) D Y^DIQ:Y S C="," W $E(Y,1,22)
 D N:$X>50 Q:'DN  W ?50 W "Rev Date: "
 S Y=$P(X,U,4) D DT
 D N:$X>0 Q:'DN  W ?0 W "Adv Outcome Risk: "
 S Y=$P(X,U,11) S Y(0)=Y S:Y]"" Y=$P(^AQAO1(3,Y,0),U)_"   "_$P(^(0),U,2) W $E(Y,1,30)
 D N:$X>47 Q:'DN  W ?47 W "Occ Outcome: "
 S X=$G(^AQAOC(D0,"REV",D1,0)) S Y=$P(X,U,6) S Y(0)=Y S:Y]"" Y=$P(^AQAO1(3,Y,0),U)_"   "_$P(^(0),U,4) W $E(Y,1,30)
 D N:$X>9 Q:'DN  W ?9 W "Finding: "
 X DXS(20,9.2) S DIP(101)=$S($D(^AQAO(8,D0,0)):^(0),1:"") S X=$P(DIP(101),U,2) S D0=I(0,0) S D1=I(1,0) K DIP K:DN Y W X
 D N:$X>52 Q:'DN  W ?52 W "Action: "
 X DXS(21,9.2) S DIP(101)=$S($D(^AQAO(6,D0,0)):^(0),1:"") S X=$P(DIP(101),U,2) S D0=I(0,0) S D1=I(1,0) K DIP K:DN Y W X
 X DXS(22,9.5) S DIP(6)=X S X=",",X=$P(DIP(6),X) S Y=X,X=DIP(5),X=X_Y,X=$S(DIP(2):DIP(3),DIP(4):X) K DIP K:DN Y W $E(X,1,10)
 S I(2)="""ADDRV""",J(2)=9002167.12 F D2=0:0 Q:$O(^AQAOC(D0,"REV",D1,"ADDRV",D2))'>0  X:$D(DSC(9002167.12)) DSC(9002167.12) S D2=$O(^(D2)) Q:D2'>0  D:$X>52 T Q:'DN  D A2
 G A2R
A2 ;
 D N:$X>66 Q:'DN  W ?66 X DXS(23,9.3) S DIP(2)=X S X=",",X=$P(DIP(2),X) K DIP K:DN Y W $E(X,1,10)
 Q
A2R ;
 D N:$X>1 Q:'DN  W ?1 W "Review Comments: "
 S I(2)="""COMMENT""",J(2)=9002167.11 F D2=0:0 Q:$O(^AQAOC(D0,"REV",D1,"COMMENT",D2))'>0  S D2=$O(^(D2)) D:$X>20 T Q:'DN  D B2
 G B2R
B2 ;
 S X=$G(^AQAOC(D0,"REV",D1,"COMMENT",D2,0)) S DIWL=20,DIWR=78 D ^DIWP
 Q
B2R ;
 D A^DIWW
 Q
J1R ;
 D T Q:'DN  D N D N:$X>5 Q:'DN  W ?5 W "Date Case Closed: "
 S X=$G(^AQAOC(D0,"FINAL")) S Y=$P(X,U,1) D DT
 D N:$X>44 Q:'DN  W ?44 W "Final Review Level: "
 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^AQAO(7,Y,0))#2:$P(^(0),U,1),1:Y) W $E(Y,1,4)
 D N:$X>0 Q:'DN  W ?0 W "Final Risk Assessment: "
 S Y=$P(X,U,3) S Y(0)=Y S:Y]"" Y=$P(^AQAO1(3,Y,0),U)_"   "_$P(^(0),U,2) W $E(Y,1,30)
 D N:$X>45 Q:'DN  W ?45 W "Final Occ Outcome: "
 S X=$G(^AQAOC(D0,"FINAL")) S Y=$P(X,U,7) S Y(0)=Y S:Y]"" Y=$P(^AQAO1(3,Y,0),U)_"   "_$P(^(0),U,4) W $E(Y,1,30)
 G ^AQAOT652
