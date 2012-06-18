AMQQQE1 ; IHS/CMI/THL - AMQQQE SUBROUTINE...GETS OVERFLOW ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
CHKOUT I $D(DTOUT)+$D(DUOUT)+(Y=-1)+(Y="") K DIRUT,DUOUT,DTOUT S AMQQQUIT="" Q
 Q
 ;
IMPORT ; ENTRY POINT FROM AMQQQE
 S DIR(0)="PO^1:EMQ"
 S DIR("A")="Enter file name"
 S DIR("?")="Enter the name of the file which has the word processing field."
 D ^DIR
 K DIR
 D CHKOUT
 I  Q
 S AMQQEFIL=Y
 S DIR(0)="PO^DD("_+Y_",:EMQ"
 S DIR("A")="Enter field name"
 S DIR("?")="Enter the name of the word processing field which has the script to be imported."
 D ^DIR
 K DIR
 D CHKOUT
 I  Q
 S AMQQEFLD=Y
 S DIR(0)="PO^"_+AMQQEFIL_":EMQ"
 S DIR("A")="Enter source file script name"
 S DIR("?")="Enter source file script name"
 D ^DIR
 K DIR
 D CHKOUT I  Q
 S AMQQESN=Y
 S DIR(0)="FO^3:30"
 S DIR("A")="Enter the new script name"
 S DIR("B")=$P(AMQQESN,U,2)
 S DIR("?")="You may enter a new name or press RETURN to keep the old one."
 D ^DIR
 K DIR
 D CHKOUT
 I  Q
 S AMQQETN=Y
 S X=AMQQETN
 D CR1^AMQQQE
 I Y=-1 Q
 S AMQQETE=Y
 D STUFF
 S Y=AMQQETE
 D COMPILE^AMQQQE
 K AMQQEFLD,AMQQEFIL,AMQQETE,AMQQESN,AMQQETN,%,Z,G,X
 Q
 ;
STUFF S %=+$P(^DD(+AMQQEFIL,+AMQQEFLD,0),U,4)
 S G=^DIC(+AMQQEFIL,0,"GL")_+AMQQESN_","_%_")"
 S Z="^AMQQ(2,"_+AMQQETE_",1)"
 S @Z@(0)=@G@(0)
 F X=0:0 S X=$O(@G@(X)) Q:'X  S @Z@(X,0)=@G@(X,0)
 Q
 ;
COPY ; ENTRY POINT FROM AMQQQE
C1 S AMQQESN=Y
 S DIR(0)="FO^3:30"
 S DIR("A")="Enter the new script name"
 D ^DIR
 K DIR
 D CHKOUT
 I  Q
 S (X,AMQQETN)=Y
 D CR1^AMQQQE
 I Y=-1 Q
 S AMQQETN=Y
 F N=1,2 D CRAM
 K AMQQESN,AMQQETN,Z,G,%,X
 W !!!,"Copy successfully completed.",!!
 S DIR(0)="E"
 D ^DIR
 K DIR
 Q
 ;
CRAM S G="^AMQQ(2,"_+AMQQESN_",N)"
 S Z="^AMQQ(2,"_+AMQQETN_",N)"
 I '$D(@G) Q
 S @Z@(0)=@G@(0)
 F X=0:0 S X=$O(@G@(X)) Q:'X  S @Z@(X,0)=@G@(X,0)
 Q
 ;
EDIT ; ENTRY POINT FROM AMQQQE
 S AMQQEE=Y
 D CHK^AMQQQE
 I  D FIX Q
 W !!!
 S DA=+AMQQEE
 S DR=5
 S DIE="^AMQQ(2,"
 D ^DIE
 K DIC,DIE,DA,DR,DO
 S Y=AMQQEE
 D COMPILE^AMQQQE
 K AMQQEE
 Q
 ;
FIX W !!,"This script was created by someone else.  If you want to edit it, you must"
 W !,"first copy it into a new name."
 W !!,"Want to copy it"
 S %=0
 D YN^DICN
 D CHKOUT
 I  Q
 I "Nn"[$E(%Y) Q
 W !!
 S Y=AMQQEE
 D C1
 Q
 ;
PURGE ; ENTRY POINT FROM AMQQQE
 D CHK^AMQQQE
 I  W !!,"Sorry...You cannot remove a script that was written by another person.",!!!!,*7 S DIR(0)="E" D ^DIR K DIR Q
 W !,"Are you sure you want to remove ",$P(Y,U,2)
 S %=0
 D YN^DICN
 D CHKOUT
 I  Q
 I "nN"[$E(%Y) Q
 S DA=+Y
 S DIK="^AMQQ(2,"
 D ^DIK
 K DIK,DA,DIC,%,%Y,X,Y
 W !!,"Script cancelled....",!
 Q
 ;
RUN ; ENTRY POINT FROM AMQQQE
 S AMQQYY=Y
 I '$P($G(^AMQQ(2,+Y,2,0)),U,4) W !!,"Sorry, for some reason I can't find the compiled version of this script!?!",!!!,*7 H 3 Q
 K AMQV,^UTILITY("AMQQ",$J),^UTILITY("AMQQ TAX",$J)
 D RESTORE^AMQQCMPS
 I '$D(AMQV(1)) Q
 S AMQQCCLS=$E($P(AMQV(0),"AMQQCCLS=""",2))
 I '$D(AMQQSURV) S AMQQCPLF="" K AMQV("OPTION") D OUTPUT^AMQQOPT K AMQQCPLF
 I $D(AMQQSURV) X AMQV(0) Q
 I $D(AMQQQUIT) Q
 I Y=-1,$G(AMQV("OPTION"))'="" D DOIT^AMQQCMPL Q
 I Y=-1 Q
 S AMQV("OPTION")=$P("LIST^PRINT^COUNT^COHORT^STORE^RMAN",U,Y)
 D DOIT^AMQQCMPL
 Q
 ;
EXTERNAL ; ENTRY POINT FOR EXTERNAL SCRIPT DRIVER
 D VAL^AMQQQ
 I $D(AMQQFAIL) Q
 Q
