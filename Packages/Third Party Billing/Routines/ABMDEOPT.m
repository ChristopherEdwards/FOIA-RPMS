ABMDEOPT ; IHS/ASDST/DMJ - EDIT PAGE OPTIONS ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR,TPF - v2.5 p8 - added code for pending status (12)
 ;
SEL ;EP for Page Commands, Desired Action Controller
 I $D(ABMP("DDL")),$D(ABMP("QUIT")) S Y="Q" G XIT
 I $D(ABMP("DDL")) S Y="N" G XIT
 I $E("IOST")'="C",IOST'="",IO'="",IO'=IO(0) S Y="N" G XIT
 S:'$D(ABMP("DFLT")) ABMP("DFLT")=""
 K %P,DIR S DIR(0)="F^1:9"
 S (DIR("B"),ABMO("DFLT"))=$S(ABMP("DFLT")]"":ABMP("DFLT"),ABMP("OPT")'["N":"B",1:"N")
 S DIR("A")="Desired ACTION ("
 S DIR("?",1)=" Choose from one of the following actions:"
 S DIR("?",2)=" "
 F ABMO("CTR")=3:1 S ABMO("TXT")=$E(ABMP("OPT"),ABMO("CTR")-2) Q:ABMO("TXT")=""  D
 .I $D(ABMP("VIEWMODE")),"NVBJQ"'[ABMO("TXT") Q
 .S DIR("?",ABMO("CTR"))=$P($T(@ABMO("TXT")),";;",2),DIR("A")=DIR("A")_$P($T(@ABMO("TXT")),";;",3)_"/"
 S DIR("?",ABMO("CTR"))=" "
 S DIR("?")=" Enter First Character of the Desired Action."
 S DIR("A")=$P(DIR("A"),"/",1,$L(DIR("A"),"/")-1)_")"
 D ^DIR K DIR
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S:X="" Y=ABMO("DFLT")
 S Y=$$UPC^ABMERUTL(Y)
 I $D(ABMP("VIEWMODE")),"NBVJQ"'[$E(Y) W *7 G SEL
 I $E(X)="?" D ^ABMDEHLP G SEL
 I '+$E(Y),'+$E(Y,2),$E(Y,2)'=0 S Y=$E(Y)
 I ABMP("SCRN")=0,"Aa"[Y S (X,Y)="C"
 I "Pp"[Y,(ABMZ("PG")=0) S (X,Y)="F"
 I $A(Y,1)>96&($A(Y,1)<123) S Y=$C($A(Y,1)-32)_$E(Y,2,99)
 I ABMP("OPT")[$E(Y) K ABMP("DFLT") G XIT
 I +Y,$D(ABMZ("NUM")),Y<(ABMZ("NUM")+1) K ABMP("DFLT") S Y="E"_+Y G XIT
 W *7 G SEL
 ;
N ;;     Next - Go on to the Next Edit Screen;;Next
A ;;     Add  - Add a New Entry;;Add
D ;;     Del  - Delete an Existing Entry;;Del
S ;;     Seq  - Modify the Prioity Sequence;;Seq
P ;;     Pick - Pick Insurer to Bill;;Pick
E ;;     Edit - Edit Information in the Current Screen;;Edit
V ;;     View - Display Detailed Information;;View
C ;;     Appr - Approve Claim for Billing;;Appr
J ;;     Jump - Jump to a desired Edit Screen;;Jump
B ;;     Back - Backup to the previous Edit Screen;;Back
Q ;;     Quit - Stop Editing the Data of this Claim;;Quit
M ;;     Mode - Change mode of export for this page;;Mode
F ;;     Pend - Pend the claim and enter Pend Status;;Pend
 ;
FLDS ;EP for Field Edit Controller
 S ABMO("Y")=+$E(Y,2,3) I ABMO("Y")>0&(ABMO("Y")<(ABMP("FLDS")+1)) S Y=ABMO("Y") G EJ
 W ! S DIR(0)="LO^1:"_ABMP("FLDS"),DIR("A")="Desired FIELDS",DIR("B")="1-"_ABMP("FLDS") D ^DIR K DIR
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
EJ S ABMP("FLDS")=Y
 G XIT
 ;
XIT K ABMO,ABMP("OPT")
 Q
 ;
JUMP S ABM("EX")=$E(X,3)_$E(X,2) I $T(@ABM("EX"))]"" S ABMP("SCRN")=$E(X,2),ABM("EX")=$P($T(@ABM("EX")),$E(X,3)_$E(X,2)_" ",2),X=$E(X,2,3) X ABM("EX") Q
