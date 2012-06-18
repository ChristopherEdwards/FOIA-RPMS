APCPRCH ; IHS/TUCSON/LAB - PCC Operational Summary AUGUST 14, 1992 ; [ 04/07/99 9:55 AM ]
 ;;2.0;IHS PCC DATA EXTRACTION SYSTEM;**1**;APR 03, 1998
 ;IHS/CMI/LAB - XTMP
 ;
START ;
 W:$D(IOF) @IOF
 W !,"**********          PCC DATA TRANSMISSION REPORT          **********",!
 W !!,"This report will list all visits that generated a Community Health Activity",!,"record to be sent to the CHA system.",!!
LOG ;
 S APCPRCH("LOG")=""
 K DIC S DIC="^APCPLOG(",DIC(0)="AEQM" D ^DIC I Y<0 G XIT
 S APCPRCH("LOG")=+Y
 I '$D(^APCPLOG(APCPRCH("LOG"),21)) W !!,"Visit data has already been purged!!" G LOG
 S X=^APCPLOG(APCPRCH("LOG"),0),APCPRCH("RUN BEGIN")=$P(X,U),APCPRCH("RUN END")=$P(X,U,2),APCPRCH("COUNT")=$P(X,U,6),APCPRCH("ORIG TX DATE")=$P($P(X,U,3),".")
 S Y=APCPRCH("RUN BEGIN") X ^DD("DD") S APCPRCH("PRINT BEGIN")=Y
 S Y=APCPRCH("RUN END") X ^DD("DD") S APCPRCH("PRINT END")=Y
 S APCPRCH("VISITS")=$P(^APCPLOG(APCPRCH("LOG"),21,0),U,4)
 W !!,"Log entry ",APCPRCH("LOG"),", was for date range ",APCPRCH("PRINT BEGIN")," through",!,APCPRCH("PRINT END")," and generated ",APCPRCH("COUNT")," transactions from ",APCPRCH("VISITS")," visits."
ZIS ;
 W !!
 S Y=DT D DD^%DT S APCPRCH("DTP")=Y
 S XBRC="PROCESS^APCPRCH",XBRP="^APCPRCH1",XBRX="XIT^APCPRCH",XBNS="APCP"
 D ^XBDBQUE
 D XIT
 Q
PROCESS ; Entry point for Taskman
 S APCPJOB=$J,APCPBTH=$H
 K ^XTMP("APCPRCH",APCPJOB,APCPBTH)
 S ^XTMP("APCPRCH",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"PCC DATA TX CHA RPT"
 S APCPRCH("BT")=$H
 S APCDOVRR=1
V ;
 S APCPRCH("V")=0 F  S APCPRCH("V")=$O(^APCPLOG(APCPRCH("LOG"),21,APCPRCH("V"))) Q:APCPRCH("V")'=+APCPRCH("V")!($D(APCPRCH("QUIT")))  D PROC
 Q
PROC ;
 Q:'$P(^APCPLOG(APCPRCH("LOG"),21,APCPRCH("V"),0),U,6)  ;quit if cha tx not generated
 Q:'$D(^AUPNVSIT(APCPRCH("V")))  ;quit if no visit record
 S ^("TOTAL")=$S($D(^XTMP("APCPRCH",APCPJOB,APCPBTH,"GEN","TOTAL")):(+^("TOTAL")+1),1:1)
 S ^XTMP("APCPRCH",APCPJOB,APCPBTH,"VISITS",APCPRCH("V"))=""
 Q
XIT ;
 K DA,DIE,DIC,ZTSK,DIR
 K APCPRCH,APCPS,APCDOVRR,APCPJOB,APCPBTH
 Q
