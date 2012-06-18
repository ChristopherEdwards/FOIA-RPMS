APCLPIF1 ; IHS/CMI/LAB - INFANT FEEDING REPORT #1 ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
 ;
EP ;EP - called from option interactive
 D EOJ
 W:$D(IOF) @IOF
 S APCLTEXT="INTROT" F APCLJ=1:1 S APCLX=$T(@APCLTEXT+APCLJ) Q:$P(APCLX,";;",2)="END"  D
 .S APCLT=$P(APCLX,";;",2)
 .I $Y>(IOSL-2) K DIR S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR W:$D(IOF) @IOF
 .W !,APCLT
ENDDATE ;
 S APCLED=""
 W !!
 S DIR(0)="D^::EPX",DIR("A")="Enter the As of Date to calculate the patient's age" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EOJ Q
 S APCLED=Y
 S APCLBDOB=$$FMADD^XLFDT(APCLED,-1)
 S APCLBDOB=($E(APCLBDOB,1,3)-2)_$E(APCLBDOB,4,7)
 S APCLEDOB=($E(APCLBDOB,1,3)+1)_$E(APCLED,4,7)
CMMNTS ;
 K APCLCOMM S APCLCOMT=""
 S DIR(0)="S^O:One particular Community;A:All Communities;S:Selected Set of Communities (Taxonomy)",DIR("A")="List patients who live in",DIR("B")="A" K DA D ^DIR K DIR
 I $D(DIRUT) G ENDDATE
 S APCLCOMT=Y
 I APCLCOMT="A" G ZIS
 I APCLCOMT="O" D  G:'$D(APCLCOMM) CMMNTS  G ZIS
 .S DIC="^AUTTCOM(",DIC(0)="AEMQ",DIC("A")="Which COMMUNITY: " D ^DIC K DIC
 .Q:Y=-1
 .S APCLCOMM($P(^AUTTCOM(+Y,0),U))=""
 S X="COMMUNITY",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" S APCLERR=1 Q
 D PEP^AMQQGTX0(+Y,"APCLCOMM(")
 I '$D(APCLCOMM) G CMMNTS
 I $D(APCLCOMM("*")) K APCLCOMM G CMMNTS
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G CMMNTS
 W !!,"Patients with the following birthdates with be reviewed in this"
 W !,"report:  ",$$FMTE^XLFDT(APCLBDOB)," - ",$$FMTE^XLFDT(APCLEDOB),!
 W !,"Patients from the following communities will be included:"
 I APCLCOMT="A" W !?5,"All communities"
 I APCLCOMT'="A" W !?3 S X=0 F  S X=$O(APCLCOMM(X)) Q:X=""  W " ",X
 W !! S XBRP="PRINT^APCLPIF1",XBRC="PROC^APCLPIF1",XBRX="EOJ^APCLPIF1",XBNS="APCL"
 D ^XBDBQUE
 Q
EOJ ;
 D ^XBFMK
 K DIC,DIR
 D EN^XBVK("APCL")
 Q
 ;
PROC ;
 S APCLJ=$J,APCLH=$H
 S ^XTMP("APCLPIF1",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"INFANT FEEDING REPORT"
 S APCLD0=""
 S APCLD6=""
 S APCLDOB=$$FMADD^XLFDT(APCLBDOB,-1),DFN=0
 F  S APCLDOB=$O(^DPT("ADOB",APCLDOB)) Q:APCLDOB=""!(APCLDOB>APCLEDOB)  D
 .S DFN=0 F  S DFN=$O(^DPT("ADOB",APCLDOB,DFN)) Q:DFN'=+DFN  D
 ..;birth stats
 ..Q:$$DEMO^APCLUTL(DFN,$G(APCLDEMO))
 ..S APCLPCV0=""
 ..S APCLBVD=APCLDOB
 ..;S APCLBS=$P($G(^AUPNBMSR(DFN,0)),U,15)
 ..S APCLEVD=$$FMADD^XLFDT(APCLDOB,179)
 ..S APCL06=0
 ..D PCV
 ..I APCLPCV0 S $P(APCLD0,U,1)=$P(APCLD0,U,1)+1 D
 ...;I $D(APCLINF)!(APCLBS]"") S $P(APCLD0,U,2)=$P(APCLD0,U,2)+1
 ...I $D(APCLINF) S $P(APCLD0,U,2)=$P(APCLD0,U,2)+1
 ...S (G,Y)=0 F  S Y=$O(APCLINF(Y)) Q:Y'=+Y!(G)  I APCLINF(Y)'=5 S G=1
 ...;I 'G,APCLBS]"",APCLBS>1 S G=1
 ...I G S $P(APCLD0,U,3)=$P(APCLD0,U,3)+1
 ..;SIX MONTHS
 ..S APCLPCV6=0
 ..S APCLBVD=$$FMADD^XLFDT(APCLDOB,180)
 ..S APCLEVD=$$FMADD^XLFDT(APCLDOB,365)
 ..S APCL06=6
 ..D PCV
 ..I APCLPCV6 S $P(APCLD6,U,1)=$P(APCLD6,U,1)+1 D
 ...;I $D(APCLINF)!(APCLBS]"") S $P(APCLD6,U,2)=$P(APCLD6,U,2)+1
 ...I $D(APCLINF) S $P(APCLD6,U,2)=$P(APCLD6,U,2)+1
 ...S (G,Y)=0 F  S Y=$O(APCLINF(Y)) Q:Y'=+Y!(G)  I APCLINF(Y)'=5 S G=1
 ...;I 'G,APCLBS]"",APCLBS>180 S G=1
 ...I G S $P(APCLD6,U,3)=$P(APCLD6,U,3)+1
 ..Q
 .Q
 Q
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  PRESS ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 K APCLTS,APCLS,APCLM,APCLET
 K ^XTMP("APCLPIF1",APCLJ,APCLH),APCLJ,APCLH
 Q
 ;
PCV ;
 ;get all visits in date range
 ;table all infant feeding in time range
 K ^TMP($J,"A"),APCLINF
 S A="^TMP($J,""A"",",B=DFN_"^ALL VISITS;DURING "_$$FMTE^XLFDT(APCLBVD)_"-"_$$FMTE^XLFDT(APCLEVD),E=$$START1^APCLDF(B,A)
 S (X,G,F,S)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:'$D(^AUPNVPRV("AD",V))
 .Q:"SAHO"'[$P(^AUPNVSIT(V,0),U,7)
 .Q:"V"[$P(^AUPNVSIT(V,0),U,3)
 .S B=$$CLINIC^APCLV(V,"C")
 .Q:B=""
 .I $D(^BGPCTRL(3,11,"B",B)) S G=1  ;must be a primary clinic S G=V
 .;table infant feeding choice
 .Q:'$D(^AUPNVIF("AD",V))
 .S Y=0 F  S Y=$O(^AUPNVIF("AD",V,Y)) Q:Y'=+Y  S APCLINF($P($P(^AUPNVSIT(V,0),U),"."))=$$VALI^XBDIQ1(9000010.44,Y,.01)
 .Q
 I G D
 .I APCL06=0 S APCLPCV0=1
 .I APCL06=6 S APCLPCV6=1
 .Q
 Q
 ;
PRINT ;EP - called from xbdbque
 S APCLQ=0
 D COVER
 Q:APCLQ
 D HEADER
 W !,"BREASTFEEDING AT BIRTH",!
 W !?2,"w/visit",?30,$$C($P(APCLD0,U,1),0,6)
 W !?2,"w/data recorded",?30,$$C($P(APCLD0,U,2),0,6)
 I $P(APCLD0,U,1) S X=($P(APCLD0,U,2)/$P(APCLD0,U,1))*100 W ?39,$J(X,6,1)
 I '$P(APCLD0,U,1) W ?39,$J("0.0",6,1)
 W !?2,"Breastfeeding",?30,$$C($P(APCLD0,U,3),0,6)
 I $P(APCLD0,U,2) S X=($P(APCLD0,U,3)/$P(APCLD0,U,2))*100 W ?39,$J(X,6,1)
 I '$P(APCLD0,U,2) W ?39,$J("0.0",6,1)
 W ?55,"75%",?65,"71%",?75,"69%"
 W !!,"BREASTFEEDING AT 6 MONTHS",!
 W !?2,"w/visit",?30,$$C($P(APCLD6,U,1),0,6)
 W !?2,"w/data recorded",?30,$$C($P(APCLD6,U,2),0,6)
 I $P(APCLD6,U,1) S X=($P(APCLD6,U,2)/$P(APCLD6,U,1))*100 W ?39,$J(X,6,1)
 I '$P(APCLD6,U,1) W ?39,$J("0.0",6,1)
 W !?2,"Breastfeeding",?30,$$C($P(APCLD6,U,3),0,6)
 I $P(APCLD6,U,2) S X=($P(APCLD6,U,3)/$P(APCLD6,U,2))*100 W ?39,$J(X,6,1)
 I '$P(APCLD6,U,2) W ?39,$J("0.0",6,1)
 W ?55,"50%",?65,"36%",?75,"32%"
 W !
 D DONE
 Q
HEADER ;EP
 G:'APCLPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQ=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",APCLPG,!
 W $$CTR($P(^DIC(4,DUZ(2),0),U),80),!
 W !,$$CTR("INFANT BREASTFEEDING STATISTICS, as of "_$$FMTE^XLFDT(APCLEDOB),80),!
 S X="Patients born "_$$FMTE^XLFDT(APCLBDOB)_" - "_$$FMTE^XLFDT(APCLEDOB) W $$CTR(X,80),!
 W $TR($J("",80)," ","-"),!
 W !?30,$E($P(^DIC(4,DUZ(2),0),U),1,15),?53,"HP 2010",?63,"NATIONAL",?73,"2003",!?63,"USA RATE",?73,"AI/AN",!
 W ?32,"#",?42,"%",?55,"%",?65,"%",?75,"%",!
 W $TR($J("",80)," ","-"),!
 Q
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQ=1 Q
 W:$D(IOF) @IOF
 W !,$$CTR("COVER PAGE",80)
 W !!,$$CTR($P(^DIC(4,DUZ(2),0),U),80)
 W !,$$CTR("INFANT BREASTFEEDING STATISTICS, as of "_$$FMTE^XLFDT(APCLEDOB),80),!
 S X="Report Run By: "_$P(^VA(200,DUZ,0),U) W !,$$CTR(X,80)
 S X="Date Report Run: "_$$FMTE^XLFDT(DT) W !,$$CTR(X,80),!
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
INTROT ;
 ;;This option will produce a report of how many infants were documented as
 ;;being breast fed at birth and at age 6 months.
 ;;
 ;;You will select the "as of" date (report end date) and the communities you
 ;;want to report on.  The report first identifies all patients who are ages
 ;;12-23 months on the "as of" date you defined.
 ;;
 ;;The report calculates the infants to report on from this initial population.
 ;;
 ;;  BIRTH breastfeeding statistics:
 ;;
 ;;   Denominator:  Number of Infants with a visit - patients who had at least
 ;;   one visit to a primary care clinic between birth and 6 months
 ;;   (ages 1-179 days old).
 ;;  
 ;;   Numerators:
 ;;   1.  infants with feeding data - any patient with a visit with any infant
 ;;   feeding choice documented between birth and 6 months (0-179 days old)
 ;;   2.  infants breastfeeding - of the patients with feeding data (numerator
 ;;   #1), those with ANY infant feeding choice that includes breastfeeding
 ;;   (e.g., NOT formula only).  The report looks chronologically at all visits
 ;;   in the timeframe with feeding documentation and counts the patient as
 ;;   meeting the numerator as soon as the first feeding choice that includes
 ;;   breastfeeding is found.
 ;;  
 ;;   6 MONTH statistics:
 ;;     same as BIRTH except the visits reviewed are those that
 ;;     occured between 180-365 days old
 ;;END
COVER ;;
 S APCLPG=0
 W !,$$CTR("COVER PAGE",80)
 W !!,$$CTR($P(^DIC(4,DUZ(2),0),U),80)
 W !,$$CTR("INFANT BREASTFEEDING STATISTICS, as of "_$$FMTE^XLFDT(APCLEDOB),80)
 S X="Report Run By: "_$P(^VA(200,DUZ,0),U) W !,$$CTR(X,80)
 S X="Date Report Run: "_$$FMTE^XLFDT(DT) W !,$$CTR(X,80)
 W !!,"Population Reviewed:  All patients with birthdates ",$$FMTE^XLFDT(APCLBDOB)," to ",$$FMTE^XLFDT(APCLEDOB)
 W !,"Community of Residence: "
 I APCLCOMT="O" W " ",$O(APCLCOMM(""))
 I APCLCOMT="A" W "  ","All Communities"
 I APCLCOMT="S" S C=0,X="" F  S X=$O(APCLCOMM(X)) Q:X=""  W:C "; " W X S C=C+1
 ;now text
 S APCLTEXT="COVERT" F APCLJ=1:1 S APCLX=$T(@APCLTEXT+APCLJ) Q:$P(APCLX,";;",2)="END"!(APCLQ)  D
 .S APCLT=$P(APCLX,";;",2)
 .I $Y>(IOSL-3) D EOP Q:APCLQ
 .W !,APCLT
 .Q
 Q
COVERT ;;
 ;;
 ;;BIRTH breastfeeding statistics:
 ;;
 ;;  Denominator:  Number of Infants with a visit - patients who had at least
 ;;  one visit to a primary care clinic between birth and 6 months
 ;;  (ages 1-179 days old).
 ;;  
 ;;  Numerators:
 ;;  1.  with feeding data - any patient with a visit with any infant
 ;;  feeding choice documented between birth and 6 months (0-179 days old)
 ;;  2.  breastfeeding - of the patients with feeding data (numerator
 ;;  #1), those with ANY infant feeding choice that includes breastfeeding
 ;;  (e.g., NOT formula only).  The report looks chronologically at all visits
 ;;  in the timeframe with feeding documentation and counts the patient as
 ;;  meeting the numerator as soon as the first feeding choice that includes
 ;;  breastfeeding is found.
 ;;  
 ;;  6 MONTH statistics:
 ;;    same as BIRTH except the visits reviewed are those that
 ;;    occured between 180-365 days old
 ;;
 ;;The report documents the site performance against three national performance
 ;;measures for breastfeeding; Healthy People 2010 goal; National USA rate for
 ;;[YY] from (what report); and 2003 data for American Indian and Alaska
 ;;Natives from (what report).
 ;;
 ;;END
