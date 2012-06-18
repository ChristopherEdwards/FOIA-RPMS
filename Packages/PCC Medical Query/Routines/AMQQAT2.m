AMQQAT2 ; IHS/CMI/THL - FILE AND TAXONOMY ATTRIBUTE ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
FQ S DIC("A")="Which Fileman file: "
 S DIC(0)="AEQ"
 S DIC=1
 D ^DIC
 K DIC
 I Y=-1,X'="",$E(X)=U S AMQQQUIT="" Q
 I Y=-1 Q
 I AMQQCCLS="P",+Y=2!(+Y=9000001) W !,"I assume that ALL patients are members of this file...Try another attribute.",*7,! Q
 D CHECK
 I '$D(AMQQFFLD) G FQ
 D FSET
EXIT K AMQQFFLD,AMQQCHTT,AMQQRNDN,AMQQCRFG,AMQQFFIL,AMQQFFLD,AMQQFGBL,AMQQFPC,AMQQFSBS,AMQQFXR,%,I,N,Z
 Q
 ;
CHECK K AMQQFFLD
 F X=0:0 S X=$O(^DD(+Y,"IX",X)) Q:'X  S %=$P(^DD(+Y,X,0),U,2) I %["P2"!(%["P9000001") D C1 I $D(AMQQFFLD) Q
 I '$D(AMQQFFLD) W !,"Sorry...I cannot find any patient fields in this file which are indexed" Q
 W !!,"OK, I'll check the ",$P(^DD(+Y,X,0),U)," field of this file."
 Q
 ;
C1 F Z=0:0 S Z=$O(^DD(+Y,X,1,Z)) Q:'Z  I $P(^(Z,0),U,3)="" S AMQQFFLD=X,AMQQFFIL=+Y,AMQQFXR=$P(^(0),U,2) Q
 Q
 ;
FSET S AMQQFGBL=^DIC(AMQQFFIL,0,"GL")
 S AMQQCHRT=$E(AMQQFGBL,2,99)_";"_AMQQFXR
 S %=$P(^DD(AMQQFFIL,AMQQFFLD,0),U,4)
 S AMQQFSBS=$P(%,";")
 S AMQQFPC=$P(%,";",2)
 S DIR(0)="SO^1:Look for patients entered in the file;2:Look for patients not entered in the file;3:Take a random sample of patients entered in the file;4:Count the number of patients in the file"
 S DIR("A")="Your choice"
 S DIR("B")="1"
 S DIR("?")=""
 D ^DIR
 K DIR
 I $E(Y)=U S AMQQQUIT="" Q
 I Y=4 D FCOUNT K ^UTILITY("AMER TEMP",$J) G FSET
 I Y=3 D FRAND Q
 I Y=2 S AMQQLINK=177
 W !!
 Q
 ;
FCOUNT I IOST["C-" W !!!,"Counting...",!
 S A=AMQQFGBL_""""_AMQQFXR_""",X)"
 S %=0
 K ^UTILITY("AMQQ TEMP",$J)
 F X=0:0 S X=$O(@A) Q:'X  I '$D(^UTILITY("AMQQ TEMP",$J,X)) S ^(X)="",%=%+1 W:IOST["C-" $C(13),% I $D(AMQQFFFG) S ^UTILITY("AMQQ FTEMP",$J,%,X)=""
 S AMQQCHTT=%
 Q
 ;
FRAND W !!
 D WAIT^DICD
 S AMQQFFFG=""
 D FCOUNT
 K AMQQFFFG
 W $C(13),"        ",$C(13),"There are ",AMQQCHTT," patients in this file"
 W !!!
 S AMQQRNDN=AMQQCHTT\2
 S AMQQCRFL=""
 D CNP1^AMQQAT1
 I IOST["C-" W !!,"Collecting a random sample",!
 K ^UTILITY("AMQQ FRAND",$J,AMQQATN)
 S AMQQCHRT=AMQQCHRT_";"_$J_";"_AMQQCHNN_";"_AMQQCHTT_";"_AMQQUATN,I=0,N=AMQQCHTT-1
 S AMQQLINK=178
FR1 ; ENTRY POINT FROM STUFF
 F  Q:I=AMQQCHNN  S Y=$R(N)+1,Z=$O(^UTILITY("AMQQ FTEMP",$J,Y,"")) I Z,'$D(^UTILITY("AMQQ FRAND",$J,AMQQUATN,Z)) S ^(Z)="",I=I+1 W:IOST["C-" $C(13),I
 K ^UTILITY("AMQQ FTEMP",$J),AMQQRNDN,^UTILITY("AMQQ TEMP",$J),AMQQCHNN,AMQQCHTT
 Q
 ;
STUFF ; ENTRY POINT FROM METADICTIONARY
 N AMQQFGBL,AMQQFXR,AMQQUATN,AMQQFFFG
 S AMQQFGBL=U_%(1)
 S AMQQFXR=%(2)
 S AMQQCHNN=%(4)
 S AMQQUATN=%(5)
 S AMQQFFFG=""
 D FCOUNT
 I IOST["C-" W !! D WAIT^DICD W !!
 S N=AMQQCHTT-1
 S I=0
 D FR1
 K %
 Q
 ;
