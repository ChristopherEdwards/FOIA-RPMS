ACRPTRG ; GENERATED FROM 'ACR TRAINING 350' PRINT TEMPLATE (#3867) ; 09/29/09 ; (FILE 9002196, MARGIN=80)
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
 I $D(DXS)<9 M DXS=^DIPT(3867,"DXS")
 S I(0)="^ACRDOC(",J(0)=9002196
 I $E($G(IOST),1,2)="C-" W "ARMS REF: ",$P(^ACRDOC(D0,0),U,6),"/",D0 K DIP K:DN Y
 W ?0 S ACRDOCDA=D0 K DIP K:DN Y
 D N:$X>19 Q:'DN  W ?19 W "DEPARTMENT OF HEALTH AND HUMAN SERVICES"
 D N:$X>0 Q:'DN  W ?0 W "INDIAN HEALTH SERVICE - TRAINING NOMINATION & AUTHORIZATION # "
 S X=$G(^ACRDOC(D0,0)) W ?64,$E($P(X,U,1),1,13)
 D N:$X>46 Q:'DN  W ?46 W "DHHS #: "
 W $$EXPDN^ACRFUTL(D0) K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "-----------------------  SECTION A - TRAINEE DATA  -----------------------------"
 D N:$X>0 Q:'DN  W ?0 W "TRAINEE.....:"
 S X=$G(^ACRDOC(D0,"TRNG")) W ?15 S Y=$P(X,U,2) S Y=$S(Y="":Y,$D(^ACRAU(Y,0))#2:$P(^(0),U),1:Y) S Y=$S(Y="":Y,$D(^VA(200,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,35)
 D N:$X>46 Q:'DN  W ?46 W "SOC SEC NO.:"
 W ?60 W $$PSSN^ACRFUTL($P($G(^ACRDOC(D0,"TRNG")),U,2),$G(DUZ),$G(IOST),$G(ACRSSNOK)) K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "PAY PLAN....:"
 W ?15 X DXS(1,9.2) S DIP(101)=$G(X) S X=$P(DIP(102),U,3),X=X S X=X S D0=I(0,0) K DIP K:DN Y W X
 W "-"
 X DXS(2,9.2) S X=$P(DIP(101),U,4) S D0=I(0,0) K DIP K:DN Y W X
 W ?26 W:$P($G(^ACRAU(+$P($G(^ACRDOC(D0,"TRNG")),U,2),1)),U,8)]"" "SERIES: " K DIP K:DN Y
 X DXS(3,9.2) S X=$P(DIP(101),U,8) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>46 Q:'DN  W ?46 W "APPOINTMENT:"
 W ?60 X DXS(4,9.2) S DIP(101)=$S($D(^ACRAU(D0,1)):^(1),1:"") S X=$P($P(DIP(102),$C(59)_$P(DIP(101),U,7)_":",2),$C(59)) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W "POSITN TITLE:"
 S X=$G(^ACRDOC(D0,"TRNG")) W ?15,$E($P(X,U,6),1,23)
 D N:$X>46 Q:'DN  W ?46 W "PRIOR NON-"
 D N:$X>0 Q:'DN  W ?0 W "ORGANIZATION:"
 W ?15 S Y=$P(X,U,3) S Y=$S(Y="":Y,$D(^AUTTPRG(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>46 Q:'DN  W ?46 W "GOV'T TRNG.:"
 S X=$G(^ACRDOC(D0,"TRNG3")) W ?60 S Y=$P(X,U,10) W:Y]"" $J(Y,5,0)
 D N:$X>0 Q:'DN  W ?0 W "CONT SERVICE:  YEARS:"
 S X=$G(^ACRDOC(D0,"TRNG")) W ?23 S Y=$P(X,U,7) W:Y]"" $J(Y,3,0)
 W ?28 W "MONTHS:"
 W ?37 S Y=$P(X,U,8) W:Y]"" $J(Y,3,0)
 D N:$X>46 Q:'DN  W ?46 W "PHONE......:"
 D N:$X>0 Q:'DN  W ?0 W "-----------------------  SECTION B - COURSE DATA  ------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "TRAINING HOURS:  DUTY:"
 W ?24 S Y=$P(X,U,9) W:Y]"" $J(Y,5,0)
 D EN2^ACRFCLM K DIP K:DN Y
 D N:$X>46 Q:'DN  W ?46 W "TUITION & FEES:"
 W ?63 W $J(ACR4,10) K DIP K:DN Y
 D N:$X>13 Q:'DN  W ?13 W "NON-DUTY:"
 S X=$G(^ACRDOC(D0,"TRNG")) W ?24 S Y=$P(X,U,10) W:Y]"" $J(Y,5,0)
 D N:$X>46 Q:'DN  W ?46 W "BOOKS & OTHER.:"
 W ?63 W $J(ACR5,10) K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "TRAINING PERIOD: FROM:"
 S X=$G(^ACRDOC(D0,"TRNG")) W ?24 S Y=$P(X,U,11) D DT
 D N:$X>46 Q:'DN  W ?46 W "TRAVEL........:"
 W ?63 W $J(ACR1,10) K DIP K:DN Y
 D N:$X>19 Q:'DN  W ?19 W "TO:"
 S X=$G(^ACRDOC(D0,"TRNG")) W ?24 S Y=$P(X,U,12) D DT
 D N:$X>46 Q:'DN  W ?46 W "PER DIEM......:"
 W ?63 W $J(ACR2,10) K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "TRAVEL ORDER NUMBER..:"
 S X=$G(^ACRDOC(D0,"TRNGTO")) W ?24 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^ACRDOC(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,17)
 D N:$X>46 Q:'DN  W ?46 W "OTHER TRANS...:"
 W ?63 W $J(ACR3,10) K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "PRE-PAY TRAINING EXP.:"
 S X=$G(^ACRDOC(D0,"TRNG4")) W ?24 S Y=$P(X,U,12) D DT
 D N:$X>46 Q:'DN  W ?46 W "TOTAL.........:"
 W ?63 W $J(ACR6,10) K DIP K:DN Y
 D PAUSE^ACRFWARN K DIP K:DN Y
 I $E($G(IOST),1,2)="C-" W @IOF K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "TRAINING COURSE TITLE:"
 S X=$G(^ACRDOC(D0,"TRNG")) W ?24,$E($P(X,U,18),1,44)
 D N:$X>0 Q:'DN  W ?0 W "EMPLOYEE'S TRAINING NEED:"
 D NEED^ACRFSSRC K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "HOW CONTENT RELATES TO TRAINING NEED:"
 D RELATE^ACRFSSRC K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "SEND PAYMENT TO:"
 S X=$G(^ACRDOC(D0,"TRNG3")) D N:$X>19 Q:'DN  W ?19 S Y=$P(X,U,1) S Y=$S(Y="":Y,$D(^AUTTVNDR(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 D N:$X>54 Q:'DN  W ?54 W "EIN.:"
 W ?61 X DXS(5,9.2) S X=$P(DIP(101),U,13) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>19 Q:'DN  W ?19 X DXS(6,9.2) S X=$P(DIP(101),U,1) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>54 Q:'DN  W ?54 W "ATTN:"
 W ?61 X DXS(7,9.2) S X=$P(DIP(101),U,5) S D0=I(0,0) K DIP K:DN Y W $E(X,1,18)
 D N:$X>19 Q:'DN  W ?19 X DXS(8,9.2) S X=$P(DIP(101),U,10) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>19 Q:'DN  W ?19 X DXS(9,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 W "  "
 X DXS(10,9.3) S X=$P(DIP(201),U,2) S D0=I(0,0) K DIP K:DN Y W X
 W "  "
 X DXS(11,9.2) S X=$P(DIP(101),U,4) S D0=I(0,0) K DIP K:DN Y W X
 I '+$G(^ACRDOC(D0,"TRNG3")) D NSVEND^ACRFJS K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "The VENDOR must ensure the CONFIDENTIALITY of THIS INFORMATION in accordance"
 D N:$X>0 Q:'DN  W ?0 W "with the provisions of THE PRIVACY ACT, Public Law 93-579, as amended."
 D N:$X>0 Q:'DN  W ?0 W "See attachments:  Terms & Conditions, Payments & Billing Instructions"
 D N:$X>0 Q:'DN  W ?0 W "--------------------------------------------------------------------------------"
 D N:$X>0 Q:'DN  W ?0 W "LOCATION OF TRNG:"
 S X=$G(^ACRDOC(D0,"TRNG4")) W ?19,$E($P(X,U,6),1,40)
 D N:$X>19 Q:'DN  W ?19,$E($P(X,U,7),1,40)
 D N:$X>19 Q:'DN  W ?19,$E($P(X,U,8),1,20)
 W ", "
 S Y=$P(X,U,9) S Y=$S(Y="":Y,$D(^DIC(5,Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,30)
 W "  "
 W ?0,$E($P(X,U,10),1,10)
 D N:$X>0 Q:'DN  W ?0 W "CODING:"
 D N:$X>53 Q:'DN  W ?53 W "|SELF-"
 D N:$X>69 Q:'DN  W ?69 W "|SKILL CODE"
 D N:$X>0 Q:'DN  W ?0 W "PURPOSE:"
 S X=$G(^ACRDOC(D0,"TRNG3")) W ?10 S Y=$P(X,U,6) S Y=$S(Y="":Y,$D(^ACRTP(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,1)
 D N:$X>13 Q:'DN  W ?13 W "|TYPE:"
 W ?21 S Y=$P(X,U,7) S Y=$S(Y="":Y,$D(^ACRTT(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,1)
 D N:$X>24 Q:'DN  W ?24 W "|SOURCE:"
 W ?34 S Y=$P(X,U,8) S Y=$S(Y="":Y,$D(^ACRTS(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,1)
 D N:$X>37 Q:'DN  W ?37 W "|SPEC INT:"
 W ?49 S Y=$P(X,U,9) S Y=$S(Y="":Y,$D(^ACRTSI(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,1)
 D N:$X>53 Q:'DN  W ?53 W "|SPONSORED:"
 W ?66 S DIP(1)=$S($D(^ACRDOC(D0,"TRNG")):^("TRNG"),1:"") S X=$P(DIP(1),U,21),X=X K DIP K:DN Y W $E(X,1,1)
 D N:$X>69 Q:'DN  W ?69 W "|"
 S X=$G(^ACRDOC(D0,"TRNG")) W ?72 S Y=$P(X,U,22) S Y=$S(Y="":Y,$D(^ACRTSC(Y,0))#2:$P(^(0),U),1:Y) W $E(Y,1,4)
 D PAUSE^ACRFWARN K DIP K:DN Y
 I $E($G(IOST),1,2)="C-" W @IOF K DIP K:DN Y
 D ^ACRFPSS K DIP K:DN Y
 D ^ACRFPAPV K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W "|----------------------  SECTION E - PROCUREMENT DATA  ------------------------|"
 D N:$X>0 Q:'DN  W ?0 W "---  SEND INVOICE TO:  ---"
 G ^ACRPTRG1
