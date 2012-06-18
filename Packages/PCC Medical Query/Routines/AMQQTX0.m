AMQQTX0 ; IHS/CMI/THL - SAVE OR RESTORE A TAXONOMY GROUP ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
NAME I $D(AMQQXX) G EXIT
 S (%,X)=""
 F  S X=$O(^UTILITY("AMQQ TAX",$J,AMQQURGN,X)) Q:X=""  S %=%+1 I %=2 Q
 I %<2 G EXIT
 W !!,"Want to save this ",AMQQTNAR," group for future use"
 S %=2
 D YN^DICN
 S:$D(DTOUT) %Y=U
 K DTOUT
 I %=0 W !!,"This group will be saved as a taxonomy for future use when entered as a value",!,"using the ""[Name of Group"" syntax." G NAME
 I $E(%Y)=U S AMQQQUIT="" G EXIT
 I "nN"[$E(%Y) G EXIT
 D RNAME
EXIT K X,AMQQTGNO,ATXFLG,%,%Y,A,B,I,N,T,Z
 Q
 ;
RNAME R !,"Group name: ",X:DTIME E  S X=U
 I X=U S AMQQQUIT="" Q
 I X="" Q
 I X["(ST)" W !!,"The (ST) is Q-Man's designation for a ""Standard Taxonomy"".",!,"You may not create a standard taxonomy.  Please select another name.",!,*7 G RNAME
 S ATXFLG=""
 S DIC="^ATXAX("
 S DIC(0)="EQL"
 S DLAYGO=9002226
 D ^DIC
 K DIC,DLAYGO
 I Y=-1 G RNAME
 I '$P(Y,U,3),DUZ'=$P(^ATXAX(+Y,0),U,5) W !!,X," already exists and cannot be overwritten except by its creator",!!,*7 G RNAME
 I '$P(Y,U,3) D OWRITE Q:$D(AMQQQUIT)  I "Nn"[$E(%Y) G RNAME
 S (AMQQTDFN,AMQQTGNO)=+Y
 S DIE="^ATXAX("
 S DA=AMQQTGNO
 S DR=".05////"_DUZ_";.08////0;.09////"_DT_";.12////"_AMQQLINK_";.13////"_(AMQQTAXT=2)_";.15////"_+$P($G(@(AMQQTLOK_"0)")),U,2)_";1101" D ^DIE
 I AMQQTAXT=2 D RSTUFF G OEXIT
 D STUFF
 I $D(DTOUT) K DTOUT S AMQQQUIT="" Q
 Q
 ;
OWRITE S AMQQTGNA=$P(Y,U,2),AMQQTGNO=+Y
 W !!,X," already exists.  Want to overwrite" S %=2 D YN^DICN
 I $D(DTOUT) K DTOUT S %Y=U
 I %Y=U S AMQQQUIT="" G OEXIT
 I "Nn"[$E(%Y) G OEXIT
 S DA=+Y
 S DIK="^ATXAX("
 D ^DIK
 K DIK,DA
 S ATXFLG=""
 S DIC="^ATXAX("
 S DIC(0)="L"
 S DINUM=AMQQTGNO
 S X=AMQQTGNA
 S DIADD=1
 S DIC("DR")=".01;.02"
 S DLAYGO=9002226
 D ^DIC
 S %Y="Y"
OEXIT K DIC,DIADD,AMQQTGNA,DLAYGO
 Q
 ;
STUFF S X=""
 F I=1:1 S X=$O(^UTILITY("AMQQ TAX",$J,AMQQURGN,X)) Q:X=""  S ^ATXAX(AMQQTGNO,21,I,0)=X,^ATXAX(AMQQTGNO,21,"B",$E(X,1,30),I)="",^ATXAX(AMQQTGNO,21,"AA",X,X)=""
 G ST1
RSTUFF S X=""
 F I=1:1 S X=$O(@AMQQHILO@(X)) Q:X=""  S Y=@AMQQHILO@(X),^ATXAX(AMQQTGNO,21,I,0)=X_U_Y,^ATXAX(AMQQTGNO,21,"AA",X,Y)="",^ATXAX(AMQQTGNO,21,"B",$E(X,1,30),I)=""
ST1 S I=I-1
 S ^ATXAX(AMQQTGNO,21,0)="^9002226.02101^"_I_U_I
 K X,Y,Z,I
 Q
 ;
RESTORE ; ENTRY POINT FROM AMQQTX SUBROUTINES
 N AMQQTGNO,AMQQTGIT
 S X=$E(X,2,99)
 S AMQQB=($E(X,$L(X))="]")
 I AMQQB S X=$E(X,1,$L(X)-1)
 S DIC("S")="I $P(^(0),U,12)=AMQQLINK"
 S DIC="^ATXAX("
 S DIC(0)="EQ"
 I $D(AMQQNECO)!$D(AMQQDF) S DIC(0)=$S($D(AMQQECHO):"MQEZ",$D(AMQQDF):"MO",1:"")
 E  I $D(AMQQXX) S DIC(0)="EQS"
 D ^DIC
 K DIC
 I Y=-1 Q
 I Y'=-1,'AMQQB,'$D(AMQQDF) W "]"
REST ;EP;TO RESTORE VALUES FROM A TAXONOMY
 Q:$G(Y)<1
 Q:'$D(^ATXAX(+Y,0))  S AMQQTAXN=$P(^(0),U)_U_+Y
 K AMQQSHNO,AMQQB S AMQQTGIT="" I AMQQTAXT'=2 D
 .I AMQQLINK=302 S AMQQTGIT="S X=$P(^AUTTHF(X,0),U)"
 .E  I $D(^AMQQ(1,AMQQLINK,4,1,1)) S AMQQTGIT=^(1)
 I AMQQTAXT=2 D RES1 I 1
 E  S AMQQTGNO="" F  S AMQQTGNO=$O(^ATXAX(+Y,21,"AA",AMQQTGNO)) Q:AMQQTGNO=""  S ^UTILITY("AMQQ TAX",$J,AMQQURGN,AMQQTGNO)="" I '$D(AMQQXX),'$D(AMQQDF) D SHOW
 K AMQQTJMP
 I '$D(AMQQDF) W:'$D(ZTQUEUED) !! K AMQQSHNO,Z,T
 S AMQQTGFG=""
 Q
 ;
SHOW Q:$D(AMQQSHOW)
 I '$D(AMQQSHNO) S AMQQSHNO=0 W !!,"Members of ",X," Taxonomy =>",!
 N %,X,Z
 S Z=AMQQTGNO
 I $D(AMQQTJMP) W "." Q
 I AMQQTAXT'=2 S X=AMQQTGNO X AMQQTGIT S Z=X
 W !
 S AMQQSHNO=AMQQSHNO+1
 I AMQQSHNO>1,AMQQSHNO#(IOSL-4)=1 R "<>",%:DTIME W $C(13) I $E(%)=U W !,"OK" S AMQQTJMP="" Q
 W Z
 Q
 ;
RES1 S %=""
 F  S %=$O(^ATXAX(+Y,21,"AA",%)) Q:%=""  S A=$O(^(%,"")) D RES2
 K A,B,AMQQTGNO,N
 Q
 ;
RES2 S AMQQTGNO=%
 S @AMQQHILO@(%)=A
 I %'=A S AMQQTGNO=%_"- "_A
 S B=$O(@AMQQTGBL@("BA",%,""))
 I B S ^UTILITY("AMQQ TAX",$J,AMQQURGN,+B)="" I '$D(AMQQXX),'$D(AMQQDF) D SHOW
 K AMQQTJMP
 S N=%
 F  S N=$O(@AMQQTGBL@("BA",N)) Q:N=""  Q:N]A  S B=$O(^(N,"")) I B S ^UTILITY("AMQQ TAX",$J,AMQQURGN,B)=""
 Q
 ;
