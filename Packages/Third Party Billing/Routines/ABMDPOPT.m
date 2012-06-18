ABMDPOPT ; IHS/ASDST/DMJ - PAYMENT OPTIONS ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
SEL ;EP for Page Commands, Desired Action Controller
 K %P,DIR S DIR(0)="FO^1:9"
 S (DIR("B"),ABMO("DFLT"))=$G(ABM("DFLT")) K:DIR("B")="" DIR("B")
 S DIR("A")="Desired ACTION ("
 S DIR("?",1)=" Choose from one of the following actions:"
 S DIR("?",2)=" "
 F ABMO("CTR")=3:1 S ABMO("TXT")=$E(ABM("OPT"),ABMO("CTR")-2) Q:ABMO("TXT")=""  S DIR("?",ABMO("CTR"))=$P($T(@ABMO("TXT")),";;",2),DIR("A")=DIR("A")_$P($T(@ABMO("TXT")),";;",3)_"/"
 S DIR("?",ABMO("CTR"))=" "
 S DIR("?")=" Enter First Character of the Desired Action."
 S DIR("A")=$P(DIR("A"),"/",1,$L(DIR("A"),"/")-1)_")"
 D ^DIR K DIR
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S:X="" Y=ABMO("DFLT")
 S:$E(Y)="Q" DIRUT=""
 I $E(X)="?" G SEL
 I '+$E(Y),'+$E(Y,2),$E(Y,2)'=0 S Y=$E(Y)
 I $A(Y,1)>96&($A(Y,1)<123) S Y=$C($A(Y,1)-32)_$E(Y,2,99)
 I ABM("OPT")[$E(Y) K ABM("DFLT") G XIT
 I +Y,$D(ABM("I")),Y<(ABM("I")+1) K ABM("DFLT") S Y="E"_+Y G XIT
 W *7 G SEL
 ;
A ;;     Add  - Post a New Payment;;Add
D ;;     Del  - Delete an Existing Payment;;Del
E ;;     Edit - Edit an Existing Payment;;Edit
V ;;     View - Display Previous Payment Information;;View
Q ;;     Quit - Exit the Payment Posting Option;;Quit
 ;
XIT K ABMO,ABM("OPT")
 Q
