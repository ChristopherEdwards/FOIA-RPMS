BATBLG ; IHS/CMI/LAB - ;
 ;;1.0;IHS ASTHMA REGISTER;;FEB 19, 2003
 ;
 ;
 W:$D(IOF) @IOF
 W !!,"This option is used to initially populate your register with a pre-defined",!,"set of patients.  If you continue with this option your patient file will"
 W !,"be scanned and all patients within a [user defined] age range living in",!,"[user defined] community with at least two asthma visits (POV with",!,"ICD-9 codes 493.00-493.99) in the past year will be automatically added to the"
 W !,"register with a status of Unreviewed.",!!
 S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EOJ Q
 I 'Y D EOJ Q
COM ;
 K BATCOMM
 S DIR(0)="S^O:One particular Community;A:All Communities;S:Selected Set of Communities (Taxonomy)",DIR("A")="Include patients who live in",DIR("B")="O" K DA D ^DIR K DIR
 G:$D(DIRUT) EOJ
 I Y="A" W !!,"Patients from all communities will be included in the report.",! G AGE
 I Y="O" D  G:'$D(BATCOMM) COM G AGE
 .K BATCOMM
 .S DIC="^AUTTCOM(",DIC(0)="AEMQ",DIC("A")="Which COMMUNITY: " D ^DIC K DIC
 .Q:Y=-1
 .S BATCOMM($P(^AUTTCOM(+Y,0),U))=""
 K BATCOMM S X="COMMUNITY",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" S BATERR=1 Q
 D ^AMQQGTX0(+Y,"BATCOMM(")
 I '$D(BATCOMM) G COM
 I $D(BATCOMM("*")) K BATCOMM G COM
 ;
AGE ;Age Screening
 K BATAGE,BATAGET
 W ! S DIR(0)="YO",DIR("A")="Would you like to restrict the report by Patient age range",DIR("B")="YES"
 S DIR("?")="If you wish to include visits from ALL age ranges, anwser No.  If you wish to include visits for only patients within a particular age range, enter Yes."
 D ^DIR K DIR
 G:$D(DIRUT) COM
 I 'Y G PROCESS
 ;
AGER ;Age Screening
 W !
 S DIR(0)="FO^1:7",DIR("A")="Enter an Age Range (e.g. 5-12,1-1)" D ^DIR
 I Y="" W !!,"No age range entered." G AGE
 I Y'?1.3N1"-"1.3N W !!,$C(7),$C(7),"Enter a numeric range in the format nnn-nnn. e.g. 0-5, 0-99, 5-20." G AGER
 S BATAGET=Y
 ;
 ;
PROCESS ;
 S BATCNT=0
 W !!,"Please be patient while I populate the asthma register, this could take",!,"anywhere from 10 minutes to an hour depending on the size of your patient",!,"database.",!
 S BATB=$$FMTE^XLFDT($$FMADD^XLFDT(DT,-365))
 S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EOJ Q
 I 'Y D EOJ Q
 S BATE=$$FMTE^XLFDT(DT)
 S BATDFN=0 F  S BATDFN=$O(^DPT(BATDFN)) Q:BATDFN'=+BATDFN  D
 .Q:$P(^DPT(BATDFN,0),U,19)
 .S BATAGE=$$AGE^AUPNPAT(BATDFN)
 .I $D(BATAGET),BATAGE>$P(BATAGET,"-",2) Q
 .I $D(BATAGET),BATAGE<$P(BATAGET,"-") Q
 .Q:$$DOD^AUPNPAT(BATDFN)]""
 .I $D(BATCOMM) S C=$P($G(^AUPNPAT(BATDFN,11)),U,18) Q:C=""  I '$D(BATCOMM(C)) Q
 .Q:'$$AST2(BATDFN,BATB,BATE)
 .D ^XBFMK
 .I $D(^BATREG(BATDFN,0)) W !,"Patient ",$P(^DPT(BATDFN,0),U)," already on Register.",! Q
 .S DIC="^BATREG(",(DINUM,X)=BATDFN,DIC(0)="L",DIC("DR")=".02////U",DLAYGO=90181.01,DIADD=1 K DD,DO D FILE^DICN K DIC,DLAYGO,DIADD,DINUM
 .I Y=-1 W !,"error uploading patient dfn ",BATDFN,!
 .S BATCNT=BATCNT+1
 .W ".",BATCNT
 W !!,BATCNT," patients were added to the asthma register."
 D PAUSE
EOJ ;
 K DIR
 D EN^XBVK("BAT")
 Q
PAUSE ;EP
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
AST2(P,B,E) ;EP - return date of last asthma diagnosis
 I $G(P)="" Q 0
 NEW BATX,BATY,I,S,Q
 K BATX
 S BATY="BATX("
 S S=P_"^LAST 2 DX [BAT ASTHMA DIAGNOSES;DURING "_B_"-"_E S Q=$$START1^APCLDF(S,BATY)
 I '$D(BATX(2)) Q ""
 Q 1
