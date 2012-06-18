ABMURBCH ; IHS/SD/SDR - 3PB/UFMS Resend Batch option   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; New routine - v2.5 p12 SDD item 4.9.2.6
 ;
 Q
START ;START HERE   
 W !
 S ABMLOC=$$FINDLOC^ABMUCUTL
 S DIC("S")="I $P($G(^ABMUTXMT(Y,0)),U,4)=ABMLOC"
 S DIC="^ABMUTXMT("
 S DIC(0)="AEMQ"
 S DIC("A")="Select export date: "
 D ^DIC
 K DIC
 Q:Y<0
 S ABMP("XMIT")=+Y
 D BDISPLAY^ABMUCUTL(ABMP("XMIT"))
 W !!
 S DIR(0)="YO"
 S DIR("A")="Would you like to continue and add these bills to the next export file?"
 S DIR("B")="N"
 D ^DIR K DIR
 I +Y'=1 Q  ;do not send batch
 D REQBTCH^ABMUCUTL(ABMP("XMIT"))  ;add to user session for transmission
 S DIR(0)="E"
 D ^DIR
 K DIR
 K ABMP
 Q
