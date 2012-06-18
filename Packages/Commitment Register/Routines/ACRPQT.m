ACRPQT ; GENERATED FROM 'ACR REQUEST FOR QUOTATION' PRINT TEMPLATE (#3964) ; 09/29/09 ; (FILE 9002196, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3964,"DXS")
 S I(0)="^ACRDOC(",J(0)=9002196
 W ?0 D ^ACRFSSPO K DIP K:DN Y
 W ?11 I $E($G(IOST),1,2)="C-" W @IOF K DIP K:DN Y
 W ?22 I $E($G(IOST),1,2)="P-",$Y>1 W @IOF K DIP K:DN Y
 W ?33 X DXS(1,9) K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 I $E($G(IOST),1,2)="C-" W "ARMS REF: ",$P($G(^ACRDOC(D0,0)),U,6),"/",D0 K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "REQUEST FOR QUOTATIONS | Notice of Small Bus Set-Aside on reverse"
 I 1 S DC=$S($D(DC)#2:DC+1,1:1) K DIP K:DN Y
 D N:$X>66 Q:'DN  W ?66 W "|PAGE OF PAGES"
 D N:$X>0 Q:'DN  W ?0 W "(This is not an ORDER) |   |  | is  |  | is not applicable"
 D N:$X>66 Q:'DN  W ?66 W "|"
 W ?69 S X=$S($D(DC)#2:DC,1:"") K DIP K:DN Y W X
 D N:$X>73 Q:'DN  W ?73 W "|"
 W:$D(ACRPOPG) ?77,ACRPOPG K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "1. REQUEST NO."
 D N:$X>15 Q:'DN  W ?15 W "|2. DATE ISSUED"
 D N:$X>32 Q:'DN  W ?32 W "|3. REQUISITION NO."
 D N:$X>54 Q:'DN  W ?54 W "|4. CERT NAT DEF | RATING"
 D N:$X>15 Q:'DN  W ?15 W "|"
 S X=$G(^ACRDOC(D0,"PO")) D N:$X>19 Q:'DN  W ?19 S Y=$P(X,U,1) D DT
 D N:$X>32 Q:'DN  W ?32 W "|"
 S X=$G(^ACRDOC(D0,0)) D N:$X>36 Q:'DN  W ?36,$E($P(X,U,1),1,17)
 D N:$X>54 Q:'DN  W ?54 W "|"
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "5. ISSUED BY:"
 D N:$X>54 Q:'DN  W ?54 W "|6. DELIVER BY (DATE)"
 D N:$X>3 Q:'DN  W ?3 W "USPHS INDIAN HEALTH SERVICE"
 D N:$X>54 Q:'DN  W ?54 W "|"
 S X=$G(^ACRDOC(D0,"PO")) D N:$X>58 Q:'DN  W ?58 S Y=$P(X,U,12) D DT
 S X=$G(^ACRDOC(D0,"POIO")) D N:$X>3 Q:'DN  W ?3 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>54 Q:'DN  W ?54 W "|"
 D N:$X>3 Q:'DN  W ?3 X DXS(2,9.2) S X=$P(DIP(101),U,1) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>54 Q:'DN  W ?54 W "|"
 D N:$X>3 Q:'DN  W ?3 X DXS(3,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>54 Q:'DN  W ?54 W "|"
 D N:$X>3 Q:'DN  W ?3 X DXS(4,9.2) S X=$P(DIP(101),U,3) S D0=I(0,0) K DIP K:DN Y W X
 W ", "
 X DXS(5,9.3) S X=$P(DIP(201),U,2) S D0=I(0,0) K DIP K:DN Y W X
 W " "
 X DXS(6,9.2) S X=$P(DIP(101),U,5) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>54 Q:'DN  W ?54 W "|"
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "5B.FOR INFORMATION CALL:"
 D N:$X>34 Q:'DN  W ?34 W "FAX-"
 X DXS(7,9.2) S X=$P(DIP(101),U,8) S D0=I(0,0) K DIP K:DN Y W $E(X,1,15)
 D N:$X>54 Q:'DN  W ?54 W "|7. DELIVERY"
 S X=$G(^ACRDOC(D0,"PA")) D N:$X>3 Q:'DN  W ?3 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^ACRPA(Y,0))#2:$P(^(0),U),1:Y) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>34 Q:'DN  W ?34 W "FON-"
 X DXS(8,9.2) S X=$P(DIP(101),U,6) S D0=I(0,0) K DIP K:DN Y W $E(X,1,15)
 D N:$X>54 Q:'DN  W ?54 W "|"
 S X=$G(^ACRDOC(D0,"PO")) D N:$X>58 Q:'DN  W ?58 S Y=$P(X,U,9) W:Y]"" $S($D(DXS(17,Y)):DXS(17,Y),1:Y)
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "8. TO:"
 W ?8 W:$E($G(ACREIN))=1 ?$X+2,ACREIN K DIP K:DN Y
 D N:$X>44 Q:'DN  W ?44 W "| 9. DESTINATION"
 S X=$G(^ACRDOC(D0,"PO")) D N:$X>3 Q:'DN  W ?3 S Y=$P(X,U,5) S Y=$S(Y="":Y,$D(^AUTTVNDR(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>44 Q:'DN  W ?44 W "|"
 D N:$X>3 Q:'DN  W ?3 X DXS(9,9.2) S X=$P(DIP(101),U,1) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>44 Q:'DN  W ?44 W "|"
 D N:$X>3 Q:'DN  W ?3 X DXS(10,9.2) S X=$P(DIP(101),U,10) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>44 Q:'DN  W ?44 W "|"
 D N:$X>3 Q:'DN  W ?3 X DXS(11,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 W ", "
 X DXS(12,9) K DIP K:DN Y W X
 W " "
 X DXS(13,9.2) S X=$P(DIP(101),U,4) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>44 Q:'DN  W ?44 W "|"
 D N:$X>3 Q:'DN  W ?3 W "PHONE-"
 X DXS(14,9.2) S X=$P(DIP(101),U,9) S D0=I(0,0) K DIP K:DN Y W $E(X,1,15)
 W ?11 W "FAX-"
 X DXS(15,9.2) S X=$P(DIP(101),U,14) S D0=I(0,0) K DIP K:DN Y W $E(X,1,15)
 D N:$X>44 Q:'DN  W ?44 W "|"
 D PAUSE^ACRFWARN K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "10.Please furnish quotations to the"
 D N:$X>39 Q:'DN  W ?39 W "|11. Business classification"
 D N:$X>3 Q:'DN  W ?3 W "Issuing Office on or before"
 D N:$X>39 Q:'DN  W ?39 W "|"
 S X=$G(^ACRDOC(D0,"PO")) D N:$X>3 Q:'DN  W ?3 S Y=$P(X,U,12) D DT
 D N:$X>39 Q:'DN  W ?39 W "|"
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 I $D(ACRPOL),ACRPOL>5 W "12.SCHEDULE (SEE SCHEDULE OF ITEM(S) 1" K DIP K:DN Y
 I $D(ACRPOL),ACRPOL>5 W:ACRJ>1 " THROUGH ",ACRJ K DIP K:DN Y
 I $D(ACRPOL),ACRPOL>5 W " ON CONTINUATION SHEET)" K DIP K:DN Y
 W ?11 I $D(ACRPOL),ACRPOL<6 D PAUSE^ACRFWARN K DIP K:DN Y
 D N:$X>19 Q:'DN  W ?19 I $D(ACRPOL),ACRPOL<6 W "12.SCHEDULE OF SUPPLIES/SERVICES" K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 X DXS(16,9) K DIP K:DN Y
 I $D(ACRPOL),ACRPOL<6 S ACRDOCDA=D0,ACRDOC=$P(^ACRDOC(D0,0),U,2) D DISPLAY^ACRFSS12 K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 I $D(ACRPOL),ACRPOL<6 D PAUSE^ACRFWARN K DIP K:DN Y
 D N:$X>15 Q:'DN  W ?15 W "|10 CALENDAR DAY|20 CALENDAR DAY|30 CALENDAR DAY|   CALENDAR DAY"
 D N:$X>0 Q:'DN  W ?0 W "13.PROMPT PAY"
 D N:$X>15 Q:'DN  W ?15 W "|"
 D N:$X>31 Q:'DN  W ?31 W "|"
 D N:$X>47 Q:'DN  W ?47 W "|"
 D N:$X>63 Q:'DN  W ?63 W "|"
 D N:$X>3 Q:'DN  W ?3 W "DISCOUNT"
 D N:$X>15 Q:'DN  W ?15 W "|"
 D N:$X>29 Q:'DN  W ?29 W "% |"
 D N:$X>45 Q:'DN  W ?45 W "% |"
 D N:$X>61 Q:'DN  W ?61 W "% |"
 D N:$X>78 Q:'DN  W ?78 W "%"
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "14.NAME & ADDRESS OF QUOTER"
 D N:$X>34 Q:'DN  W ?34 W "|15. SIGNATURE OF PERSON AUTHOR-"
 D N:$X>66 Q:'DN  W ?66 W "|16. DATE OF"
 D N:$X>34 Q:'DN  W ?34 W "|    IZED TO SIGN QUOTATION"
 D N:$X>66 Q:'DN  W ?66 W "|    QUOTATION"
 D N:$X>34 Q:'DN  W ?34 W "|"
 D N:$X>66 Q:'DN  W ?66 W "|"
 D N:$X>34 Q:'DN  W ?34 W "|"
 D N:$X>66 Q:'DN  W ?66 W "|"
 D N:$X>34 Q:'DN  W ?34 W "|-------------------------------|-------------"
 D N:$X>34 Q:'DN  W ?34 W "|17. NAME & TITLE OF SIGNER"
 D N:$X>66 Q:'DN  W ?66 W "|18. PHONE NO."
 D N:$X>34 Q:'DN  W ?34 W "|"
 D N:$X>66 Q:'DN  W ?66 W "|"
 D N:$X>34 Q:'DN  W ?34 W "|"
 D N:$X>66 Q:'DN  W ?66 W "|"
 G ^ACRPQT1
