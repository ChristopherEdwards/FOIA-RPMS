AMQQ200 ; IHS/CMI/THL - SLC ISC/GIS - CONVERSION TO FILE #200 ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
NEW N X,Y,Z,%,DIRUT,DIROUT,DTOUT,DUOUT
 I $P(^AMQQ(8,DUZ(2),0),U,6) Q  ; CONVERSION WAS DONE PREVIOUSLY
 I '$O(^VA(200,0)) Q  ; FILE #200 NOT PRESENT
 I '$P($G(^AUTTSITE(1,0)),U,22) Q  ; PCC FILE CONVERSION NOT COMPLETE
 W !!!,*7,"Hmmm, it appears that you have not upgraded Q-Man to recognize file #200, the"
 W !,"***  NEW PERSON FILE  ***"
 W !!
 S DIR(0)="Y"
 S DIR("A")="Let's do the upgrade now, OK"
 S DIR("B")="YES"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I Y D DIE,META
EXIT ;
 Q
 ;
DIE S DIE="^AMQQ(8,"
 S DA=DUZ(2)
 S DR=".06///1"
 D ^DIE
 K DIE,DR,DA,DIC
 ; SET FLAG IN Q-MAN SITE PARAM FILE TO INDICATE FILE #200 CONVERSION
 Q
 ;
STUFF ; DEVELOPERS UTILITY TO STUFF ENTRIES INTO THE QMAN FILE 200 CONVERSION FILE
 N X,Y,Z,%,I S I=0
 S X="^AMQQ(0)" F  S X=$Q(@X) Q:X'?1"^AMQQ(".E  Q:+$P(X,"(",2)>5  D
 . S %=@X I %'["DIC(16,",%'["DIC(6,",%'["DIC(3," Q
 . S Z=$P(X,U,2),I=I+1
 . W !,X,!,%,!
 S $P(^AMQQ(8.1,0),U,3,4)=(I_U_I)
 Q
 ;
META ; METADICTIONARY CONVERSION
 F X=0:0 S X=$O(^AMQQ(8.1,X)) Q:'X  S Y=U_^(X,0),Z=^(1) S @Y=Z
 Q
 ;
RERUN ;EP;TO RERUN FILE 200 CONVERSION
 I $G(^DD(9000010.06,.01,0))'[200 D  Q
 .Q:$D(ZTSK)!$D(ZTQUEUED)
 .W !!,"File 200 conversion has not been done on this system."
 .H 3
 S $P(^AMQQ(8,DUZ(2),0),U,6)=""
 D NEW
 Q
