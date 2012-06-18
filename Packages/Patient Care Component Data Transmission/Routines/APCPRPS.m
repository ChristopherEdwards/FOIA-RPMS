APCPRPS ; IHS/TUCSON/LAB - PCC Operational Summary AUGUST 14, 1992 ; [ 09/08/99 7:40 AM ]
 ;;2.0;IHS PCC DATA EXTRACTION SYSTEM;**1,3**;APR 03, 1998
 ;IHS/CMI/LAB - changed TMP to XTMP
 ;
START ;
 W:$D(IOF) @IOF
 W !,"**********          PCC DATA TRANSMISSION REPORT          **********",!
 W !!,"This report will list all visits that did not generate",!,"a statistical record to be sent to the data center.",!! ;IHS/CMI/LAB
LOG ;
 S APCPRPS("LOG")=""
 K DIC S DIC="^APCPLOG(",DIC(0)="AEQM" D ^DIC I Y<0 G XIT
 S APCPRPS("LOG")=+Y
 I '$D(^APCPLOG(APCPRPS("LOG"),21)) W !!,"Visit data has already been purged!!" G LOG
 S X=^APCPLOG(APCPRPS("LOG"),0),APCPRPS("RUN BEGIN")=$P(X,U),APCPRPS("RUN END")=$P(X,U,2),APCPRPS("COUNT")=$P(X,U,6),APCPRPS("ORIG TX DATE")=$P($P(X,U,3),".")
 S Y=APCPRPS("RUN BEGIN") X ^DD("DD") S APCPRPS("PRINT BEGIN")=Y
 S Y=APCPRPS("RUN END") X ^DD("DD") S APCPRPS("PRINT END")=Y
 S APCPRPS("VISITS")=$P(^APCPLOG(APCPRPS("LOG"),21,0),U,4)
 W !!,"Log entry ",APCPRPS("LOG"),", was for date range ",APCPRPS("PRINT BEGIN")," through",!,APCPRPS("PRINT END")," and generated ",APCPRPS("COUNT")," transactions from ",APCPRPS("VISITS")," visits."
 W !!
ZIS ;
 S XBRC="PROCESS^APCPRPS",XBRP="^APCPRPS1",XBRX="XIT^APCPRPS",XBNS="APCP"
 D ^XBDBQUE
 D XIT
 Q
PROCESS ; Entry point for Taskman
 S APCPJOB=$J,APCPBTH=$H
 K ^XTMP("APCPRPS",APCPJOB,APCPBTH)
 S ^XTMP("APCPRPS",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"PCC DATA TRANS REPORT"
V ;
 S APCPRPS("V")=0 F  S APCPRPS("V")=$O(^APCPLOG(APCPRPS("LOG"),21,APCPRPS("V"))) Q:APCPRPS("V")'=+APCPRPS("V")  D PROC
 Q
PROC ;
 Q:$P(^APCPLOG(APCPRPS("LOG"),21,APCPRPS("V"),0),U,5)  ;quit if main tx generated
 Q:'$D(^AUPNVSIT(APCPRPS("V")))  ;quit if no visit record
 S ^("TOTAL")=$S($D(^XTMP("APCPRPS",APCPJOB,APCPBTH,"GEN","TOTAL")):(+^("TOTAL")+1),1:1)
 S ^XTMP("APCPRPS",APCPJOB,APCPBTH,"VISITS",APCPRPS("V"))=""
 Q
XIT ;
 K DA,DIE,DIC,DIR
 K APCPRPS,APCPS,APCDOVRR,APCPJOB,APCPBTH
 Q
