APCLNJ2 ; IHS/CMI/LAB - E-CODE CLINIC VISITS BY DATE RANGE/BY AGE/VISIT TYPE ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;This report is to be used to list Injury visits by clinic/by age
 ;
 W:$D(IOF) @IOF W !!?21,"INJURY SURVEILLANCE SUMMARY REPORT"
 W !,?34,"(E-CODES)",!
 W !!,"This report will COUNT visits which have an injury diagnosis.  The user",!,"can select which visits to count based on any of the following criteria:",!
 W ?15,"- Visit date",!?15,"- Clinic of Visit",!?15,"- Service Category of Visit",!?15,"- Type of Visit",!?15,"- Location of Encounter",!?15,"- Age Range",!
 W !,"The visit counts are summarized by the following 18 E-Code Categories:",!!,?2,"Motor Vehicles..Boat/Water..Air Transport..Accidental Poison..Environmental..",!
 W ?2,"Stings/Venons..Falls..Fire/Flame..Animal Vites..Drowning/Sub..Cutting/Piercing",!
 W ?2,"Fire Arms..Sports Injury..Suicide..Assault..Child Abuse..Undetermined..Other..",!
 W !,?2,"**Detailed information for each E-Code Range is outlined in the User Manual**",!!
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Visit Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S APCLBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCLBD_":DT:EP",DIR("A")="Enter ending Visit Date:  " S Y=APCLBD D DD^%DT S Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCLED=Y
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
 ;
 ;
LOC ;
 K APCLLOC,APCLLOCT
 W ! S DIR(0)="YO",DIR("A")="Include visits from ALL Locations",DIR("B")="Yes"
 S DIR("?")="If you wish to include visits from ALL locations answer Yes.  If you wish to list visits for only one location of encounter enter NO."
 D ^DIR K DIR
 G:$D(DIRUT) BD
 I Y=1 G TYPE
LOC1 ;enter location
 S X="LOCATION OF ENCOUNTER",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"APCLLOCT(")
 I '$D(APCLLOCT) G LOC
 I $D(APCLLOCT("*")) K APCLLOCT
TYPE ;
 K APCLTYP,APCLTYPT
 W ! S DIR(0)="YO",DIR("A")="Include ALL Visit Types",DIR("B")="Yes"
 S DIR("?")="If you wish to include all Visit Types (IHS,CONTRACT,638,etc) answer Yes.  If you wish to list visits for only one visit type enter NO."
 D ^DIR K DIR
 G:$D(DIRUT) LOC
 I Y=1 G SC
TYPE1 ;
 S X="VISIT TYPE",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"APCLTYPT(")
 I '$D(APCLTYPT) G TYPE
 I $D(APCLTYPT("*")) K APCLTYPT
SC ;
 K APCLSCT
 K APCLSC,APCLSCT W ! S DIR(0)="YO",DIR("A")="Include ALL Visit Service Categories",DIR("B")="Yes"
 S DIR("?")="If you wish to include all visit service categories (Ambulatory,Hospitalization,etc) answer Yes.  If you wish to list visits for only one service category enter NO." D ^DIR K DIR
 G:$D(DIRUT) BD
 I Y=1 G CLINIC
SC1 ;enter sc
 S X="SERVICE CATEGORY",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"APCLSCT(")
 I '$D(APCLSCT) G SC
 I $D(APCLSCT("*")) K APCLSCT
CLINIC ;
 K APCLCLNT
 W ! S DIR(0)="Y",DIR("A")="Include visits to ALL clinics",DIR("B")="Yes" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) SC
 I Y=1 G AGE
CLINIC1 ;
 S X="CLINIC",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"APCLCLNT(")
 I '$D(APCLCLNT) G CLINIC
 I $D(APCLCLNT("*")) K APCLCLNT
AGE ;Age Screening
 K APCLAGE,APCLAGET
 W ! S DIR(0)="YO",DIR("A")="Would you like to restrict the report by Patient age range",DIR("B")="NO"
 S DIR("?")="If you wish to include visits from ALL age ranges, anwser No.  If you wish to list visits for only patients within a particular age range, enter Yes."
 D ^DIR K DIR
 G:$D(DIRUT) CLINIC
 I 'Y G ZIS
 ;
AGER ;Age Screening
 W !
 S DIR(0)="FO^1:7",DIR("A")="Enter an Age Range (e.g. 5-12,1-1)" D ^DIR
 I Y="" W !!,"No age range entered." G AGE
 I Y'?1.3N1"-"1.3N W !!,$C(7),$C(7),"Enter a numeric range in the format nnn-nnn. e.g. 0-5, 0-99, 5-20." G AGER
 S APCLAGET=Y
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G AGE
 S XBRC="^APCLNJ21",XBRP="^APCLNJ22",XBNS="APCL",XBRX="XIT^APCLNJ2"
 D ^XBDBQUE
XIT K Y,APCLBD,APCLED,APCLCL,APCLICD,APCLBICD,APCLEICD,ZTSK,ZTQUEUED,%DT,APCLBT,APCLSD,APCLJOB,APCLPROV,APCLFOUN,APCLDFN,APCLCLNT,APCLLOCT,APCLSCT,APCLTYPT,APCLAGE,APCLAGET
 K APCL65,APCLBD,APCLCLS,APCLED,APCLFPV,APCLFVS,APCLIOM,APCLMCR,DA,DFN,%DT,%T,%Y,APCLAGE,G,POP,AMQQTAX,AMQQTDFN,APCLBDD,APCLEDD,APCLFR,APCLPA,APCLPOV,APCLSC,APCLTYPE
 K APCLNAME,APCLNAR,APCLPRC,APCLPRV,APCLPS,APCLPTOT,APCLPV,APCLSTR
 K APCLSTOP,APCLVDFN,APCLVDT,APCLVPOV,APCLVPRC,APCLVRV,APCLVTOT,Y
 K DIC,DOB,DR,APCLHRCN,I,LKPRINT,SEX,APCLSTR,X,APCLCLX,APCLCL,APCLPGRD
 K AMQQATN,AMQQCOMP,AMQQCTXS,AMQQLINK,AMQQTAX
 K APCLVGRA,APCLPAGE,APCLICD,APCLBICD,APCLEICD,APCLPV,APCLPRC,APCLFLG
 K APCLCIEN,APCLCNTR,APCLET,APCLGOT,APCLGTOT,APCLTAX,APCLTXN,APCLX,APCLY,APCLTEXT,APCLPER,APCLALC,APCLATOT,APCLZ
 Q
