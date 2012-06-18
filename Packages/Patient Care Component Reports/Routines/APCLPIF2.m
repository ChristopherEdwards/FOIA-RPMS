APCLPIF2 ; IHS/CMI/LAB - INFANT FEEDING REPORT #1 ;
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
 W !! S XBRP="PRINT^APCLPIF2",XBRC="PROC^APCLPIF2",XBRX="EOJ^APCLPIF2",XBNS="APCL"
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
 S ^XTMP("APCLPIF2",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"INFANT FEEDING REPORT"
 S (APCLD1,APCLD2,APCLD3,APCLD4,APCLD5)=""
 K APCLPVCD F X=1:1:5 S APCLPVCD(X)="0^0^0^0^0"
 S APCLDOB=$$FMADD^XLFDT(APCLBDOB,-1),DFN=0
 F  S APCLDOB=$O(^DPT("ADOB",APCLDOB)) Q:APCLDOB=""!(APCLDOB>APCLEDOB)  D
 .S DFN=0 F  S DFN=$O(^DPT("ADOB",APCLDOB,DFN)) Q:DFN'=+DFN  D
 ..;birth stats
 ..;S APCLBS=$P($G(^AUPNBMSR(DFN,0)),U,15)
 ..;B-13
 ..Q:$$DEMO^APCLUTL(DFN,$G(APCLDEMO))
 ..S APCLBDAY=0,APCLEDAY=13,APCLI=1 D PROC1
 ..S APCLBDAY=14,APCLEDAY=41,APCLI=2 D PROC1
 ..S APCLBDAY=42,APCLEDAY=119,APCLI=3 D PROC1
 ..S APCLBDAY=120,APCLEDAY=179,APCLI=4 D PROC1
 ..S APCLBDAY=180,APCLEDAY=239,APCLI=5 D PROC1
 ..Q
 .Q
 Q
PROC1 ;
 S APCLBVD=$$FMADD^XLFDT(APCLDOB,APCLBDAY)
 S APCLEVD=$$FMADD^XLFDT(APCLDOB,APCLEDAY)
 D PCV
 I APCLGAH=1 S $P(APCLPVCD(APCLI),U,1)=$P(APCLPVCD(APCLI),U,1)+1 D
 .;I $D(APCLINF)!(APCLBS]"") S $P(APCLD0,U,2)=$P(APCLD0,U,2)+1
 .I $D(APCLINF) S $P(APCLPVCD(APCLI),U,2)=$P(APCLPVCD(APCLI),U,2)+1
 .S (G,Y)=0 F  S Y=$O(APCLINF(Y)) Q:Y'=+Y!(G)  I APCLINF(Y)=1 S G=1
 .;I 'G,APCLBS]"",APCLBS>1 S G=1
 .I G S $P(APCLPVCD(APCLI),U,4)=$P(APCLPVCD(APCLI),U,4)+1
 .S (G,Y)=0 F  S Y=$O(APCLINF(Y)) Q:Y'=+Y!(G)  I APCLINF(Y)'=5 S G=1 S $P(APCLPVCD(APCLI),U,3)=$P(APCLPVCD(APCLI),U,3)+1
 .I 'G S (G,Y)=0 F  S Y=$O(APCLINF(Y)) Q:Y'=+Y!(G)  I APCLINF(Y)=5 S G=1 S $P(APCLPVCD(APCLI),U,5)=$P(APCLPVCD(APCLI),U,5)+1
 .;I 'G,APCLBS]"",APCLBS>1 S G=1
 .Q
 Q
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  PRESS ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 K APCLTS,APCLS,APCLM,APCLET
 K ^XTMP("APCLPIF2",APCLJ,APCLH),APCLJ,APCLH
 Q
 ;
PCV ;
 ;get all visits in date range
 ;table all infant feeding in time range
 S APCLGAH=0
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
 I G S APCLGAH=1
 Q
 ;
PRINT ;EP - called from xbdbque
 S APCLQ=0
 D COVER
 Q:APCLQ
 D HEADER
 W !,"BREASTFEEDING STATISTICS",!
 W !?45,"AGE INTERVALS"
 W !?25,"Birth",?37,"2-5wks",?49,"2 mos",?61,"4 mos",?71,"6 mos"
 W !?14,"Days",?25,"B-13",?37,"14-41",?49,"42-119",?61,"120-179",?71,"180-239"
 W !?20,$$REPEAT^XLFSTR("-",58)
 W !!,"w/visit"
 ;S APCLPVCD(1)=1001_U_247_U_245_U_66_U_100
 ;S APCLPVCD(2)=1231_U_99_U_23_U_66_U_44
 ;S APCLPVCD(3)=13_U_11_U_3_U_9_U_9
 ;S APCLPVCD(4)=103_U_45_U_32_U_22_U_11
 ;S APCLPVCD(5)=100_U_100_U_22_U_100_U_100
 W ?20,$$RJ^XLFSTR($P(APCLPVCD(1),U,1),5)
 W ?33,$$RJ^XLFSTR($P(APCLPVCD(2),U,1),5)
 W ?45,$$RJ^XLFSTR($P(APCLPVCD(3),U,1),5)
 W ?57,$$RJ^XLFSTR($P(APCLPVCD(4),U,1),5)
 W ?68,$$RJ^XLFSTR($P(APCLPVCD(5),U,1),5)
 W !,"w/data recorded"
 W ?20,$$RJ^XLFSTR($P(APCLPVCD(1),U,2),5)
 I $P(APCLPVCD(1),U,1) S X=($P(APCLPVCD(1),U,2)/$P(APCLPVCD(1),U,1))*100 W ?27,$J(X,5,1)
 I '$P(APCLPVCD(1),U,1) W ?29,$J("0.0",4,1)
 W ?33,$$RJ^XLFSTR($P(APCLPVCD(2),U,2),5)
 I $P(APCLPVCD(2),U,1) S X=($P(APCLPVCD(2),U,2)/$P(APCLPVCD(2),U,1))*100 W ?40,$J(X,5,1)
 I '$P(APCLPVCD(2),U,1) W ?40,$J("0.0",4,1)
 W ?45,$$RJ^XLFSTR($P(APCLPVCD(3),U,2),5)
 I $P(APCLPVCD(3),U,1) S X=($P(APCLPVCD(3),U,2)/$P(APCLPVCD(3),U,1))*100 W ?52,$J(X,5,1)
 I '$P(APCLPVCD(3),U,1) W ?52,$J("0.0",4,1)
 W ?57,$$RJ^XLFSTR($P(APCLPVCD(4),U,2),5)
 I $P(APCLPVCD(4),U,1) S X=($P(APCLPVCD(4),U,2)/$P(APCLPVCD(4),U,1))*100 W ?63,$J(X,5,1)
 I '$P(APCLPVCD(4),U,1) W ?63,$J("0.0",4,1)
 W ?68,$$RJ^XLFSTR($P(APCLPVCD(5),U,2),5)
 I $P(APCLPVCD(5),U,1) S X=($P(APCLPVCD(5),U,2)/$P(APCLPVCD(5),U,1))*100 W ?75,$J(X,5,1)
 I '$P(APCLPVCD(5),U,1) W ?75,$J("0.0",4,1)
 W !,"Any Breastfeeding",?20,$$RJ^XLFSTR($P(APCLPVCD(1),U,3),5)
 I $P(APCLPVCD(1),U,2) S X=($P(APCLPVCD(1),U,3)/$P(APCLPVCD(1),U,2))*100 W ?27,$J(X,5,1)
 I '$P(APCLPVCD(1),U,2) W ?27,$J("0.0",6,1)
 W ?33,$$RJ^XLFSTR($P(APCLPVCD(2),U,3),5)
 I $P(APCLPVCD(2),U,2) S X=($P(APCLPVCD(2),U,3)/$P(APCLPVCD(2),U,2))*100 W ?40,$J(X,5,1)
 I '$P(APCLPVCD(2),U,2) W ?40,$J("0.0",4,1)
 W ?45,$$RJ^XLFSTR($P(APCLPVCD(3),U,3),5)
 I $P(APCLPVCD(3),U,2) S X=($P(APCLPVCD(3),U,3)/$P(APCLPVCD(3),U,2))*100 W ?52,$J(X,5,1)
 I '$P(APCLPVCD(3),U,2) W ?52,$J("0.0",4,1)
 W ?57,$$RJ^XLFSTR($P(APCLPVCD(4),U,3),5)
 I $P(APCLPVCD(4),U,2) S X=($P(APCLPVCD(4),U,3)/$P(APCLPVCD(4),U,2))*100 W ?63,$J(X,5,1)
 I '$P(APCLPVCD(4),U,2) W ?63,$J("0.0",4,1)
 W ?68,$$RJ^XLFSTR($P(APCLPVCD(5),U,3),5)
 I $P(APCLPVCD(5),U,2) S X=($P(APCLPVCD(5),U,3)/$P(APCLPVCD(5),U,2))*100 W ?75,$J(X,5,1)
 I '$P(APCLPVCD(5),U,2) W ?75,$J("0.0",4,1)
 W !,"Excl Breastfeeding",?20,$$RJ^XLFSTR($P(APCLPVCD(1),U,4),5)
 I $P(APCLPVCD(1),U,2) S X=($P(APCLPVCD(1),U,4)/$P(APCLPVCD(1),U,2))*100 W ?27,$J(X,5,1)
 I '$P(APCLPVCD(1),U,2) W ?27,$J("0.0",6,1)
 W ?33,$$RJ^XLFSTR($P(APCLPVCD(2),U,4),5)
 I $P(APCLPVCD(2),U,2) S X=($P(APCLPVCD(2),U,4)/$P(APCLPVCD(2),U,2))*100 W ?40,$J(X,5,1)
 I '$P(APCLPVCD(2),U,2) W ?40,$J("0.0",4,1)
 W ?45,$$RJ^XLFSTR($P(APCLPVCD(3),U,4),5)
 I $P(APCLPVCD(3),U,2) S X=($P(APCLPVCD(3),U,4)/$P(APCLPVCD(3),U,2))*100 W ?52,$J(X,5,1)
 I '$P(APCLPVCD(3),U,2) W ?52,$J("0.0",4,1)
 W ?57,$$RJ^XLFSTR($P(APCLPVCD(4),U,4),5)
 I $P(APCLPVCD(4),U,2) S X=($P(APCLPVCD(4),U,4)/$P(APCLPVCD(4),U,2))*100 W ?63,$J(X,5,1)
 I '$P(APCLPVCD(4),U,2) W ?63,$J("0.0",4,1)
 W ?68,$$RJ^XLFSTR($P(APCLPVCD(5),U,4),5)
 I $P(APCLPVCD(5),U,2) S X=($P(APCLPVCD(5),U,4)/$P(APCLPVCD(5),U,2))*100 W ?75,$J(X,5,1)
 I '$P(APCLPVCD(5),U,2) W ?75,$J("0.0",4,1)
 W !,"Formula Only",?20,$$RJ^XLFSTR($P(APCLPVCD(1),U,5),5)
 I $P(APCLPVCD(1),U,2) S X=($P(APCLPVCD(1),U,5)/$P(APCLPVCD(1),U,2))*100 W ?27,$J(X,5,1)
 I '$P(APCLPVCD(1),U,2) W ?27,$J("0.0",6,1)
 W ?33,$$RJ^XLFSTR($P(APCLPVCD(2),U,5),5)
 I $P(APCLPVCD(2),U,2) S X=($P(APCLPVCD(2),U,5)/$P(APCLPVCD(2),U,2))*100 W ?40,$J(X,5,1)
 I '$P(APCLPVCD(2),U,2) W ?40,$J("0.0",4,1)
 W ?45,$$RJ^XLFSTR($P(APCLPVCD(3),U,5),5)
 I $P(APCLPVCD(3),U,2) S X=($P(APCLPVCD(3),U,5)/$P(APCLPVCD(3),U,2))*100 W ?52,$J(X,5,1)
 I '$P(APCLPVCD(3),U,2) W ?52,$J("0.0",4,1)
 W ?57,$$RJ^XLFSTR($P(APCLPVCD(4),U,5),5)
 I $P(APCLPVCD(4),U,2) S X=($P(APCLPVCD(4),U,5)/$P(APCLPVCD(4),U,2))*100 W ?63,$J(X,5,1)
 I '$P(APCLPVCD(4),U,2) W ?63,$J("0.0",4,1)
 W ?68,$$RJ^XLFSTR($P(APCLPVCD(5),U,5),5)
 I $P(APCLPVCD(5),U,2) S X=($P(APCLPVCD(5),U,5)/$P(APCLPVCD(5),U,2))*100 W ?75,$J(X,5,1)
 I '$P(APCLPVCD(5),U,2) W ?75,$J("0.0",4,1)
 W !
 D DONE
 Q
HEADER ;EP
 G:'APCLPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQ=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?33,$$FMTE^XLFDT(DT),?68,"Page ",APCLPG,!
 W $$CTR($P(^DIC(4,DUZ(2),0),U),80),!
 W !,$$CTR("INFANT BREASTFEEDING STATISTICS, as of "_$$FMTE^XLFDT(APCLEDOB),80),!
 S X="Patients born "_$$FMTE^XLFDT(APCLBDOB)_" - "_$$FMTE^XLFDT(APCLEDOB) W $$CTR(X,80),!
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
 ;;being breast fed at the following age intervals:
 ;;  Birth-13 days, 2-4 weeks (14-41 days), 2 months (42-199 days),
 ;;  4 months (120-179 days) and 6 months (180-239 days)
 ;;
 ;;You will select the "as of" date (report end date) and the communities you
 ;;want to report on.  The report first identifies all patients who are ages
 ;;12-23 months on the "as of" date you defined.
 ;;
 ;;The report calculates the infants to report on from this initial population.
 ;;
 ;;  Breastfeeding statistics:
 ;;
 ;;   Denominator:  Number of Infants with a visit - patients who had at least
 ;;   one visit to a primary care clinic during the age intervals defined above.
 ;;  
 ;;   Numerators:
 ;;   1.  infants with feeding data - any patient with a visit with any infant
 ;;   feeding choice documented during the age intervals defined above.
 ;;   2.  infants breastfeeding - of the patients with feeding data (numerator
 ;;   #1), those with ANY infant feeding choice that includes breastfeeding
 ;;   (e.g., NOT formula only).  The report looks chronologically at all visits
 ;;   in the timeframe with feeding documentation and counts the patient as
 ;;   meeting the numerator as soon as the first feeding choice that includes
 ;;   breastfeeding is found.
 ;;  
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
 ;;  one visit to a primary care clinic during the age intervals defined above.
 ;;  
 ;;  Numerators:
 ;;  1.  with feeding data - any patient with a visit with any infant
 ;;  feeding choice documented during the age intervals defined above.
 ;;  2.  breastfeeding - of the patients with feeding data (numerator
 ;;  #1), those with ANY infant feeding choice that includes breastfeeding
 ;;  (e.g., NOT formula only).  The report looks chronologically at all visits
 ;;  in the timeframe with feeding documentation and counts the patient as
 ;;  meeting the numerator as soon as the first feeding choice that includes
 ;;  breastfeeding is found.
 ;;  
 ;;
 ;;END
