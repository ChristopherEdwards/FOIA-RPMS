APCDACP1 ; IHS/CMI/LAB - print list of accepted pov's ;
 ;;2.0;IHS PCC SUITE;**1**;MAY 14, 2009
 ;
 W !!,"PLEASE NOTE:  The IHS Direct Inpatient System no longer requires"
 W !,"the use of the ACCEPT command so this option is no longer necessary and"
 W !,"will be eliminated in a future patch.",!!
 S APCDPG=0
 D @("P"_APCDT)
 D XIT
 I $E(IOST)="C",IO=IO(0) S DIR(0)="E" D ^DIR K DIR
 W:$D(IOF) @IOF
 Q
P1 ;
 S APCDACCT=1,APCDTITL="POV" D V Q
P2 ;
 S APCDACCT=2,APCDTITL="PROCEDURE" D V Q
P3 ;
 S APCDACCT=3,APCDTITL="HOSPITALIZATION" D V Q
P4 ;
 D P1
 Q:$D(APCDQUIT)
 D P2
 Q:$D(APCDQUIT)
 D P3
 Q:$D(APCDQUIT)
 Q
V ;
 D HEAD
 I '$D(^XTMP("APCDACP",$J,APCDTITL)) W !!,"There are no visits on or after ",$S(APCDX="P":"Posting",APCDX="Visit":"",1:"Posting")," date " S Y=APCDBD D DT^DIO2 S Y="" W !,"with an ACCEPTED "_APCDTITL_".",! Q
 S APCDV=0 F  S APCDV=$O(^XTMP("APCDACP",$J,APCDTITL,APCDV)) Q:APCDV'=+APCDV!$D(APCDQUIT)  D PRN1,ER
 Q
ER S APCDE=0 F  S APCDE=$O(^XTMP("APCDACP",$J,APCDTITL,APCDV,APCDE)) Q:APCDE=""!($D(APCDQUIT))  D @APCDACCT
 Q
 ;
HEAD ;
 I 'APCDPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCDQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF
 S APCDPG=APCDPG+1
 W !,"PCC DATA ENTRY ACCEPT COMMAND REPORT",?70,"Page: ",APCDPG,!
 W !,"REPORT OF ",APCDTITL,"'S FOR ",$S(APCDX="P":"POSTING",APCDX="V":"VISIT",1:"POSTING")," DATE RANGE: " S Y=APCDBD D DT^DIO2 S Y="" W " THROUGH " S Y=APCDED D DT^DIO2 S Y=""
 Q
PRN1 ;
 I $Y>(IOSL-10) D HEAD Q:$D(APCDQUIT)
 S APCDVR=^AUPNVSIT(APCDV,0) S:'$P(APCDVR,U,6) $P(APCDVR,U,6)=0
 S APCDPAT=$P(APCDVR,U,5),APCDHRN="" S:$D(^AUPNPAT(APCDPAT,41,APCDSITE,0)) APCDHRN=$P(^AUPNPAT(APCDPAT,41,APCDSITE,0),U,2)
 S Y=APCDPAT D ^AUPNPAT
 I AUPNDOB]"" S X2=AUPNDOB,X1=$P((+APCDVR),".") D ^%DTC S AUPNDAYS=X
 S Y=AUPNDOB X ^DD("DD") S APCDDOB=Y
 S Y=+APCDVR X ^DD("DD") S APCDRD=Y
 W !!," Date: [",APCDRD,"] Name: [",$P(^DPT($P(APCDVR,U,5),0),U),"]    Sex: ",AUPNSEX,"]"
 W !," HRN:  [",$S(APCDHRN]"":APCDHRN,1:"NONE"),"] Date of Birth: [",APCDDOB,"] Age in Days: [",AUPNDAYS,"]"
 Q
 ;
1 ;
 S APCDER=^AUPNVPOV(APCDE,0)
 W !," ",APCDTITL," Code: ["
 ;W $P(^ICD9($P(APCDER,U),0),U),"]   ICD Narrative: [",$P(^ICD9($P(APCDER,U),0),U,3),"]"
 ;I $D(^ICD9($P(APCDER,U),9999999)) W !?6,"ICD Lower Age: [",$P(^ICD9($P(APCDER,U),9999999),U),"] ICD Upper Age: [",$P(^ICD9($P(APCDER,U),9999999),U,2),"] "
 W $P($$ICDDX^ICDCODE($P(APCDER,U),$$VD^APCLV(APCDV)),U,2),"] ICD Narrative: [",$P($$ICDDX^ICDCODE($P(APCDER,U),$$VD^APCLV(APCDV)),U,4),"]"
 S %=$$ICDDX^ICDCODE($P(APCDER,U),$$VD^APCLV(APCDV))
 S (A,B)=""  ;CSV
 I $$VERSION^XPDUTL("BCSV")]"" D  I 1  ;CSV
 .S A=$P(%,U,15),B=$P(%,U,16)  ;CSV
 E  S A=$P($G(^ICD9($P(APCDER,U),9999999)),U),B=$P($G(^ICD9($P(APCDER,U),9999999)),U,2)
 I A]""!(B]"") W !?6,"ICD Lower Age: [",A,"] ICD Upper Age: [",B,"] "
 W !?6 W "Overridden By: ["
 W $P(^VA(200,$P(APCDER,U,14),0),U),"]"
 Q
2 ;
 S APCDER=^AUPNVPRC(APCDE,0)
 W !," ",APCDTITL," Code: ["
 ;W $P(^ICD0($P(APCDER,U),0),U),"]   ICD Narrative: [",$P(^ICD0($P(APCDER,U),0),U,4),"]"
 ;I $D(^ICD0($P(APCDER,U),9999999)) W !?6,"ICD Lower Age: [",$P(^ICD0($P(APCDER,U),9999999),U),"] ICD Upper Age: [",$P(^ICD0($P(APCDER,U),9999999),U,2),"] "
 W $P($$ICDOP^ICDCODE($P(APCDER,U),$$VD^APCLV(APCDV)),U,2),"] ICD Narrative: [",$P($$ICDOP^ICDCODE($P(APCDER,U),$$VD^APCLV(APCDV)),U,5),"]"
 S %=$$ICDOP^ICDCODE($P(APCDER,U),$$VD^APCLV(APCDV))
 S (A,B)=""  ;CSV
 I $$VERSION^XPDUTL("BCSV")]"" D  I 1  ;CSV
 .S A="",B=""  ;CSV
 E  S A=$P($G(^ICD0($P(APCDER,U),9999999)),U),B=$P($G(^ICD0($P(APCDER,U),9999999)),U,2)
 I A]""!(B]"") W !?6,"ICD Lower Age: [",A,"] ICD Upper Age: [",B,"] "
 W !?6 W "Overridden By: ["
 W $P(^VA(200,$P(APCDER,U,9),0),U),"]"
 Q
3 ;
 S APCDER=^AUPNVINP(APCDE,0)
 W !,"     Date of Discharge: ["
 K ^UTILITY("DIQ1",$J)
 S DIC="^AUPNVINP(",DR=".01;.04;.05;.14",DA=APCDE,DIQ(0)="E" D EN^DIQ1 K DIC,DA,DR
 W ^UTILITY("DIQ1",$J,9000010.02,APCDE,.01,"E"),"]"
 S X1=+APCDER,X2=+APCDVR D ^%DTC S:X=0 X=1 W "     Length of Stay [",X,"]"
 W !,"     Adm. Srv.: [",^UTILITY("DIQ1",$J,9000010.02,APCDE,.04,"E"),"]","   Disch. Srv.: [",^UTILITY("DIQ1",$J,9000010.02,APCDE,.05,"E"),"]",!
 K ^UTILITY("DIQ1",$J)
 W ?5 W "Overridden By: ["
 W $P(^VA(200,$P(APCDER,U,14),0),U),"]"
 Q
XIT ; Clean up and exit
 K APCDE,APCDVR,APCDPAT,APCDHRN,APCDV,APCDER,APCDRD,APCDQUIT,APCDDOB
 Q
 ;
