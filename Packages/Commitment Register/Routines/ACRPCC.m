ACRPCC ; GENERATED FROM 'ACR COMMERCIAL CONTRACT' PRINT TEMPLATE (#3971) ; 09/29/09 ; (FILE 9002196, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3971,"DXS")
 S I(0)="^ACRDOC(",J(0)=9002196
 W ?0 D ^ACRFSSPO K DIP K:DN Y
 W ?11 I $E($G(IOST),1,2)="C-" W @IOF K DIP K:DN Y
 W ?22 I $E($G(IOST),1,2)="P-",$Y>1 W @IOF K DIP K:DN Y
 W ?33 K ACRX I '$D(^ACROBL(D0,"APV")) S ACRX="" K DIP K:DN Y
 W ?44 I '$D(ACRX),$D(^ACROBL(D0,"APV")),$P(^("APV"),U,8)'="A" S ACRX="" K DIP K:DN Y
 W ?55 X DXS(1,9) K DIP K:DN Y
 D N:$X>2 Q:'DN  W ?2 X DXS(2,9) K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 I $E($G(IOST),1,2)="C-" W "ARMS REF: ",$P($G(^ACRDOC(D0,0)),U,6),"/",D0 K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "SOLICITATION/CONTRACT/ORDER FOR COMMERCIAL ITEMS"
 W "|1. REQUISITION NO.|PAGE 1 OF"
 I 1 S DC=$S($D(DC)#2:DC+1,1:1) K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "OFFEROR TO COMPLETE BLOCKS 12,17,23,24, & 30"
 D N:$X>49 Q:'DN  W ?49 W "|"
 S X=$G(^ACRDOC(D0,0)) W ?52,$E($P(X,U,1),1,17)
 D N:$X>73 Q:'DN  W ?73 W "|"
 W:$D(ACRPOPG) ?77,ACRPOPG K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "2. CONTRACT NO."
 D N:$X>19 Q:'DN  W ?19 W "|3. AWARD DATE"
 D N:$X>31 Q:'DN  W ?31 W "|4. ORDER NO."
 D N:$X>49 Q:'DN  W ?49 W "|5. SOLICITATION NO."
 D T Q:'DN  W ?73 W "|6. SOLIC. DATE"
 S X=$G(^ACRDOC(D0,0)) D N:$X>3 Q:'DN  W ?3,$E($P(X,U,2),1,15)
 D N:$X>19 Q:'DN  W ?19 W "|"
 S X=$G(^ACRDOC(D0,"REQ")) W ?22 S Y=$P(X,U,5) D DT
 D N:$X>31 Q:'DN  W ?31 W "|"
 S X=$G(^ACRDOC(D0,"PO")) W ?34,$E($P(X,U,3),1,15)
 D N:$X>49 Q:'DN  W ?49 W "|"
 D N:$X>73 Q:'DN  W ?73 W "|"
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "7. FOR INFORMATION"
 D N:$X>19 Q:'DN  W ?19 W "|a. NAME"
 D N:$X>49 Q:'DN  W ?49 W "|b. PHONE NUMBER"
 D T Q:'DN  W ?73 W "|8. OFFER DUE"
 D N:$X>0 Q:'DN  W ?0 W "   CALL"
 D N:$X>19 Q:'DN  W ?19 W "|"
 S X=$G(^ACRDOC(D0,"PA")) W ?22 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^ACRPA(Y,0))#2:$P(^(0),U),1:Y) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,25)
 D N:$X>49 Q:'DN  W ?49 W "|"
 W ?52 X DXS(3,9.2) S X=$S('$D(^%ZIS(1,+$P(DIP(101),U,2),0)):"",1:$P(^(0),U,1)) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>73 Q:'DN  W ?73 W "|"
 D T Q:'DN  W ?2 S DIP(1)=$S($D(^ACRDOC(D0,"REQ")):^("REQ"),1:"") S X=$P(DIP(1),U,11) S:X X=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3) K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "9. ISSUED BY"
 D N:$X>39 Q:'DN  W ?39 W "|10. ACQUISITION IS"
 D N:$X>59 Q:'DN  W ?59 W "|11. DELIVER TO FOB"
 D T Q:'DN  W ?73 W "|12. DISCOUNT"
 D N:$X>3 Q:'DN  W ?3 W "USPHS INDIAN HEALTH SERVICE"
 D N:$X>39 Q:'DN  W ?39 W "|"
 D N:$X>59 Q:'DN  W ?59 W "|DESTINATION"
 D N:$X>73 Q:'DN  W ?73 W "|"
 S X=$G(^ACRDOC(D0,"PO")) D T Q:'DN  W ?2,$E($P(X,U,13),1,20)
 S X=$G(^ACRDOC(D0,"POIO")) D N:$X>3 Q:'DN  W ?3 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>39 Q:'DN  W ?39 W "|"
 D N:$X>59 Q:'DN  W ?59 W "|"
 D N:$X>73 Q:'DN  W ?73 W "|"
 D N:$X>3 Q:'DN  W ?3 X DXS(4,9.2) S X=$P(DIP(101),U,1) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>39 Q:'DN  W ?39 W "|"
 D N:$X>59 Q:'DN  W ?59 W "|"
 D N:$X>73 Q:'DN  W ?73 W "|"
 D N:$X>3 Q:'DN  W ?3 X DXS(5,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>39 Q:'DN  W ?39 W "|"
 D N:$X>59 Q:'DN  W ?59 W "|"
 D N:$X>73 Q:'DN  W ?73 W "|"
 D N:$X>3 Q:'DN  W ?3 X DXS(6,9.2) S X=$P(DIP(101),U,3) S D0=I(0,0) K DIP K:DN Y W X
 W ", "
 X DXS(7,9.3) S X=$P(DIP(201),U,2) S D0=I(0,0) K DIP K:DN Y W X
 W " "
 X DXS(8,9.2) S X=$P(DIP(101),U,5) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>39 Q:'DN  W ?39 W "|"
 D N:$X>59 Q:'DN  W ?59 W "|"
 D N:$X>73 Q:'DN  W ?73 W "|"
 D N:$X>39 Q:'DN  W ?39 W "|"
 W ?42 W:$E($G(ACREIN))=2 ?67,"(",ACREIN,")" K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "7. TO: CONTRACTOR"
 W ?19 W:$E($G(ACREIN))=1 ?$X+2,ACREIN K DIP K:DN Y
 D N:$X>44 Q:'DN  W ?44 W "|8. TYPE OF ORDER"
 S X=$G(^ACRDOC(D0,"PO")) D N:$X>3 Q:'DN  W ?3 S Y=$P(X,U,5) S Y=$S(Y="":Y,$D(^AUTTVNDR(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>44 Q:'DN  W ?44 W "|"
 D N:$X>48 Q:'DN  W ?48 S Y=$P(X,U,6) W:Y]"" $S($D(DXS(22,Y)):DXS(22,Y),1:Y)
 D N:$X>3 Q:'DN  W ?3 X DXS(9,9.2) S X=$P(DIP(101),U,1) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>44 Q:'DN  W ?44 W "|   REFERENCE:"
 D N:$X>3 Q:'DN  W ?3 X DXS(10,9.2) S X=$P(DIP(101),U,10) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>44 Q:'DN  W ?44 W "|"
 S X=$G(^ACRDOC(D0,"POIO")) D N:$X>48 Q:'DN  W ?48,$E($P(X,U,7),1,30)
 D N:$X>3 Q:'DN  W ?3 X DXS(11,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 W ", "
 X DXS(12,9) K DIP K:DN Y W X
 W " "
 X DXS(13,9.2) S X=$P(DIP(101),U,4) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>44 Q:'DN  W ?44 W "|   AUTHORITY:"
 S X=$G(^ACRDOC(D0,"PO")) W ?60 S Y=$P(X,U,22) W:Y]"" $S($D(DXS(23,Y)):DXS(23,Y),1:Y)
 D N:$X>3 Q:'DN  W ?3 W "PHONE:"
 W ?11 X DXS(14,9.2) S X=$P(DIP(101),U,9) S D0=I(0,0) K DIP K:DN Y W X
 D PAUSE^ACRFWARN K DIP K:DN Y
 D ^ACRFPSS K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "12. FOB POINT"
 D N:$X>19 Q:'DN  W ?19 W "|14. GOV'T B/L NO."
 D N:$X>39 Q:'DN  W ?39 W "|15. DELIVER TO FOB"
 D N:$X>59 Q:'DN  W ?59 W "|16. DISCOUNT TERMS"
 S X=$G(^ACRDOC(D0,"PO")) D N:$X>4 Q:'DN  W ?4 S Y=$P(X,U,9) W:Y]"" $S($D(DXS(24,Y)):DXS(24,Y),1:Y)
 D N:$X>19 Q:'DN  W ?19 W "|"
 D N:$X>24 Q:'DN  W ?24,$E($P(X,U,10),1,10)
 D N:$X>39 Q:'DN  W ?39 W "|    PT ON OR BEFORE|"
 D N:$X>0 Q:'DN  W ?0 W "---------------------------------------"
 D N:$X>39 Q:'DN  W ?39 W "|"
 D N:$X>59 Q:'DN  W ?59 W "|"
 D N:$X>64 Q:'DN  W ?64 S DIP(1)=$S($D(^ACRDOC(D0,"PO")):^("PO"),1:"") S X=$P(DIP(1),U,13),DIP(2)=X S X=1,DIP(3)=X S X=15,X=$E(DIP(2),DIP(3),X) K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "13. PLACE INSPECT/ACCPT"
 D N:$X>39 Q:'DN  W ?39 W "|"
 S X=$G(^ACRDOC(D0,"PO")) D N:$X>44 Q:'DN  W ?44 S Y=$P(X,U,12) D DT
 D N:$X>59 Q:'DN  W ?59 W "|"
 D N:$X>64 Q:'DN  W ?64 S DIP(1)=$S($D(^ACRDOC(D0,"PO")):^("PO"),1:"") S X=$P(DIP(1),U,13),DIP(2)=X S X=16,DIP(3)=X S X=30,X=$E(DIP(2),DIP(3),X) K DIP K:DN Y W X
 S X=$G(^ACRDOC(D0,"PO")) D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,11) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>39 Q:'DN  W ?39 W "|"
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 G ^ACRPCC1
