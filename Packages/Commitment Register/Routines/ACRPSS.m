ACRPSS ; GENERATED FROM 'ACR ORDER FOR SUP/SER' PRINT TEMPLATE (#3918) ; 09/29/09 ; (FILE 9002196, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3918,"DXS")
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
 D N:$X>24 Q:'DN  W ?24 W "ORDER FOR SUPPLIES OR SERVICES"
 I 1 S DC=$S($D(DC)#2:DC+1,1:1) K DIP K:DN Y
 D N:$X>66 Q:'DN  W ?66 W "|PAGE OF PAGES"
 D N:$X>0 Q:'DN  W ?0 W "IMPORTANT: MARK ALL PACKAGES & PAPERS WITH CONTRACT &/OR ORDER NO."
 D N:$X>66 Q:'DN  W ?66 W "|"
 W ?69 S X=$S($D(DC)#2:DC,1:"") K DIP K:DN Y W X
 D N:$X>73 Q:'DN  W ?73 W "|"
 W:$D(ACRPOPG) ?77,ACRPOPG K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "1. DATE OF ORDER"
 D N:$X>19 Q:'DN  W ?19 W "|2. CONTRACT NO."
 D N:$X>39 Q:'DN  W ?39 W "|3. ORDER NO."
 D N:$X>59 Q:'DN  W ?59 W "|4. REQUISITION/REF #"
 S X=$G(^ACRDOC(D0,"PO")) D N:$X>3 Q:'DN  W ?3 S Y=$P(X,U,1) D DT
 D N:$X>19 Q:'DN  W ?19 W "|"
 D N:$X>23 Q:'DN  W ?23,$E($P(X,U,2),1,15)
 D N:$X>39 Q:'DN  W ?39 W "|"
 S X=$G(^ACRDOC(D0,0)) D N:$X>43 Q:'DN  W ?43,$E($P(X,U,2),1,15)
 D N:$X>59 Q:'DN  W ?59 W "|"
 D N:$X>63 Q:'DN  W ?63,$E($P(X,U,1),1,17)
 D N:$X>19 Q:'DN  W ?19 W "|   DHHS NO.  "
 W $$EXPDN^ACRFUTL(D0) K DIP K:DN Y
 D N:$X>59 Q:'DN  W ?59 W "|"
 D REQOFF^ACRFRRPT K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "5. ISSUING OFFICE:"
 D N:$X>39 Q:'DN  W ?39 W "|6. SHIP TO:"
 D N:$X>3 Q:'DN  W ?3 W "USPHS INDIAN HEALTH SERVICE"
 D N:$X>39 Q:'DN  W ?39 W "|   USPHS INDIAN HEALTH SERVICE"
 S X=$G(^ACRDOC(D0,"POIO")) D N:$X>3 Q:'DN  W ?3 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>39 Q:'DN  W ?39 W "|"
 S X=$G(^ACRDOC(D0,"POST")) D N:$X>43 Q:'DN  W ?43 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>3 Q:'DN  W ?3 X DXS(3,9.2) S X=$P(DIP(101),U,1) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>39 Q:'DN  W ?39 W "|"
 D N:$X>43 Q:'DN  W ?43 X DXS(4,9.2) S X=$P(DIP(101),U,1) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>3 Q:'DN  W ?3 X DXS(5,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>39 Q:'DN  W ?39 W "|"
 D N:$X>43 Q:'DN  W ?43 X DXS(6,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>3 Q:'DN  W ?3 X DXS(7,9.2) S X=$P(DIP(101),U,3) S D0=I(0,0) K DIP K:DN Y W X
 W ", "
 X DXS(8,9.3) S X=$P(DIP(201),U,2) S D0=I(0,0) K DIP K:DN Y W X
 W " "
 X DXS(9,9.2) S X=$P(DIP(101),U,5) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>39 Q:'DN  W ?39 W "|"
 D N:$X>43 Q:'DN  W ?43 X DXS(10,9.2) S X=$P(DIP(101),U,3) S D0=I(0,0) K DIP K:DN Y W X
 W ", "
 X DXS(11,9.3) S X=$P(DIP(201),U,2) S D0=I(0,0) K DIP K:DN Y W X
 W " "
 X DXS(12,9.2) S X=$P(DIP(101),U,5) S D0=I(0,0) K DIP K:DN Y W X
 S X=$G(^ACRDOC(D0,"PA")) D N:$X>3 Q:'DN  W ?3 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^ACRPA(Y,0))#2:$P(^(0),U),1:Y) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,20)
 W ?25 W "("
 X DXS(13,9.2) S X=$P(DIP(101),U,6) S D0=I(0,0) K DIP K:DN Y W X
 W ")"
 D N:$X>39 Q:'DN  W ?39 W "|"
 D N:$X>43 Q:'DN  W ?43 W "PHONE:"
 W ?51 X DXS(14,9.2) S X=$P(DIP(101),U,6) S D0=I(0,0) K DIP K:DN Y W X
 W ?62 W:$E($G(ACREIN))=2 ?67,"(",ACREIN,")" K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "7. TO: CONTRACTOR"
 W ?19 W:$E($G(ACREIN))=1 ?$X+2,ACREIN K DIP K:DN Y
 D N:$X>44 Q:'DN  W ?44 W "|8. TYPE OF ORDER"
 S X=$G(^ACRDOC(D0,"PO")) D N:$X>3 Q:'DN  W ?3 S Y=$P(X,U,5) S Y=$S(Y="":Y,$D(^AUTTVNDR(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>44 Q:'DN  W ?44 W "|"
 D N:$X>48 Q:'DN  W ?48 S Y=$P(X,U,6) W:Y]"" $S($D(DXS(28,Y)):DXS(28,Y),1:Y)
 D N:$X>3 Q:'DN  W ?3 X DXS(15,9.2) S X=$P(DIP(101),U,1) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>44 Q:'DN  W ?44 W "|   REFERENCE:"
 D N:$X>3 Q:'DN  W ?3 X DXS(16,9.2) S X=$P(DIP(101),U,10) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>44 Q:'DN  W ?44 W "|"
 S X=$G(^ACRDOC(D0,"POIO")) D N:$X>48 Q:'DN  W ?48,$E($P(X,U,7),1,30)
 D N:$X>3 Q:'DN  W ?3 X DXS(17,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 W ", "
 X DXS(18,9) K DIP K:DN Y W X
 W " "
 X DXS(19,9.2) S X=$P(DIP(101),U,4) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>44 Q:'DN  W ?44 W "|   AUTHORITY:"
 S X=$G(^ACRDOC(D0,"PO")) W ?60 S Y=$P(X,U,22) W:Y]"" $S($D(DXS(29,Y)):DXS(29,Y),1:Y)
 D N:$X>3 Q:'DN  W ?3 W "PHONE:"
 W ?11 X DXS(20,9.2) S X=$P(DIP(101),U,9) S D0=I(0,0) K DIP K:DN Y W X
 I $P($G(^AUTTVNDR(+$P($G(^ACRDOC(D0,"PO")),U,5),19)),U)]"" W " (EFT)" K DIP K:DN Y
 D N:$X>34 Q:'DN  W ?34 W "CUSTOMER ACCT NO.:"
 S X=$G(^ACRDOC(D0,"PO")) W ?54,$E($P(X,U,23),1,20)
 D PAUSE^ACRFWARN K DIP K:DN Y
 D ^ACRFPSS K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "12. FOB POINT"
 D N:$X>19 Q:'DN  W ?19 W "|14. GOV'T B/L NO."
 D N:$X>39 Q:'DN  W ?39 W "|15. DELIVER TO FOB"
 D N:$X>59 Q:'DN  W ?59 W "|16. DISCOUNT TERMS"
 S X=$G(^ACRDOC(D0,"PO")) D N:$X>4 Q:'DN  W ?4 S Y=$P(X,U,9) W:Y]"" $S($D(DXS(30,Y)):DXS(30,Y),1:Y)
 D N:$X>19 Q:'DN  W ?19 W "|"
 D N:$X>24 Q:'DN  W ?24,$E($P(X,U,10),1,10)
 D N:$X>39 Q:'DN  W ?39 W "|    PT ON OR BEFORE|"
 D N:$X>0 Q:'DN  W ?0 W "---------------------------------------"
 D N:$X>39 Q:'DN  W ?39 W "|"
 D N:$X>59 Q:'DN  W ?59 W "|"
 D N:$X>64 Q:'DN  W ?64 S DIP(1)=$S($D(^ACRDOC(D0,"PO")):^("PO"),1:"") S X=$P(DIP(1),U,13),DIP(2)=$G(X) S X=1,DIP(3)=$G(X) S X=15,X=$E(DIP(2),DIP(3),X) K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "13. PLACE INSPECT/ACCPT"
 D N:$X>39 Q:'DN  W ?39 W "|"
 S X=$G(^ACRDOC(D0,"PO")) D N:$X>44 Q:'DN  W ?44 S Y=$P(X,U,12) D DT
 D N:$X>59 Q:'DN  W ?59 W "|"
 D N:$X>64 Q:'DN  W ?64 S DIP(1)=$S($D(^ACRDOC(D0,"PO")):^("PO"),1:"") S X=$P(DIP(1),U,13),DIP(2)=$G(X) S X=16,DIP(3)=$G(X) S X=30,X=$E(DIP(2),DIP(3),X) K DIP K:DN Y W X
 S X=$G(^ACRDOC(D0,"PO")) D N:$X>0 Q:'DN  W ?0 S Y=$P(X,U,11) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>39 Q:'DN  W ?39 W "|"
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 G ^ACRPSS1
