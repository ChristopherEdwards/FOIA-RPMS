ABMDFRA ; IHS/ASDST/DMJ - FLAT RATE ADJUSTMENT ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p12 - UFMS
 ;   If user isn't logged into cashiering session they can't do
 ;   this option
 ;
START ;START
 I $P($G(^ABMDPARM(DUZ(2),1,4)),U,15)=1 D  Q:+$G(ABMUOPNS)=0
 .S ABMUOPNS=$$FINDOPEN^ABMUCUTL(DUZ)
 .I +$G(ABMUOPNS)=0 D  Q
 ..W !!,"* * YOU MUST SIGN IN TO BE ABLE TO PERFORM BILLING FUNCTIONS! * *",!
 ..S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 W !!,"This option will adjust the amount billed field for all claims"
 W !,"for the insurer and visit type you select beginning with the date"
 W !,"you select to reflect a new flat rate.",!
 W !,"An adjustment will then be passed to the A/R system.",!
 S DIC="^ABMNINS(DUZ(2),",DIC(0)="AEMQ" D ^DIC Q:+Y<0  S ABMINS=+Y
 S DIC="^ABMNINS(DUZ(2),ABMINS,1,",DIC(0)="AEMQ" D ^DIC Q:+Y<0  S ABMVTYP=+Y
 S DIR(0)="D" D ^DIR K DIR Q:'Y  S ABMDATE=Y
 S DIR(0)="N",DIR("A")="Enter Old Rate " D ^DIR K DIR S ABMORAT=Y
 W !!,"I am going to adjust the amount billed field for all bills with visit date ",!,$$MDT^ABMDUTL(ABMDATE)
 W "or later for insurer ",$P(^AUTNINS(ABMINS,0),U),", visit type ",ABMVTYP,", billed at"
 W !,"the old rate of ",ABMORAT,"."
 S ABMFLAT=$$FLAT^ABMDUTL(ABMINS,ABMVTYP,ABMDATE)
 W !!,"NOTE: The flat rate for this insurer, visit type, and date is $",ABMFLAT,".",!
 D PRO Q:Y'=1
 S ABMCOUNT=0
 S ABMI=ABMDATE-.5 F  S ABMI=$O(^ABMDBILL(DUZ(2),"AD",ABMI)) Q:'ABMI  D
 .S ABMJ=0 F  S ABMJ=$O(^ABMDBILL(DUZ(2),"AD",ABMI,ABMJ)) Q:'ABMJ  D
 ..D ONE
 W !!,"Finished - ",ABMCOUNT," bills changed.",!!
 S DIR(0)="E" D ^DIR K DIR
 K ABMFLAT,ABMVTYP,ABMDATE,ABMINS,ABMZERO,ABMCOUNT,ABMOLD,ABMI,ABMJ,ABMAO
 Q
ONE ;EP - one bill
 S DA=ABMJ
 S ABMZERO=^ABMDBILL(DUZ(2),DA,0)
 Q:$P(ABMZERO,"^",7)'=ABMVTYP
 Q:$P(ABMZERO,"^",8)'=ABMINS
 S ABMDAYS=$P($G(^ABMDBILL(DUZ(2),DA,7)),"^",3)
 S:+ABMDAYS<2 ABMDAYS=1
 S ABMOLD=$P(^ABMDBILL(DUZ(2),DA,2),U)
 S ABMOTOT=ABMORAT*ABMDAYS
 Q:ABMOLD'=ABMOTOT
 S ABMNEW=ABMFLAT*ABMDAYS
 Q:ABMOLD=ABMNEW
 S $P(^ABMDBILL(DUZ(2),DA,2),U)=ABMNEW
 S:$P(^ABMDBILL(DUZ(2),DA,2),"^",3)=ABMOLD $P(^(2),"^",3)=ABMNEW
 S ^ABMDBILL(DUZ(2),DA,"AF",$H,.21)=DUZ_"^"_ABMOLD
 W "."
 S ABMCOUNT=ABMCOUNT+1
 S ABMFR("ADJ AMT")=ABMNEW-ABMOLD
 S ABMFR("USER")=DUZ
 S ABMFR("ARLOC")=$P(^ABMDBILL(DUZ(2),DA,2),"^",6)
 I ABMFR("ARLOC")="" D
 .S ABMFR("ARLOC")=$$FIND(DA)
 .I ABMFR("ARLOC")="" Q
 .S DIE="^ABMDBILL(DUZ(2),",DR=".26///"_ABMFR("ARLOC")
 .D ^DIE
 S ABMFR("TRAN TYPE")=503
 S ABMTEST=$$EN^BARFRAPI(.ABMFR)
 Q
PRO ;PROCEED
 W !
 S DIR(0)="Y",DIR("A")="Proceed",DIR("B")="NO" D ^DIR K DIR
 Q
FIND(DA) ;find bill in A/R
 S ABMARLOC=""
 S ABMNAME=$P(^ABMDBILL(DUZ(2),DA,0),U),ABMLOC=$P(^(0),"^",3)
 N I
 S I=0
 F  S I=$O(^BARBL(I)) Q:'I  D
 .Q:ABMARLOC'=""
 .S ABMNXT=$O(^BARBL(I,"B",ABMNAME))
 .Q:ABMNXT'[ABMNAME
 .S ABMIEN=$O(^BARBL(I,"B",ABMNXT,0))
 .I $P(^BARBL(I,ABMIEN,0),"^",17)=DA S ABMARLOC=I_","_ABMIEN
 Q ABMARLOC
