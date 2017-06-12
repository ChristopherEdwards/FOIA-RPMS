APCM2AEQ ; IHS/CMI/LAB - IHS MU ;
 ;;1.0;MU PERFORMANCE REPORTS;**7**;MAR 26, 2012;Build 15
 ;;;;;;Build 3
 ;
SAVEDEL ;EP
 I APCMPTYP="P" Q
 I APCMDELT="S" D SCREEN K ^TMP($J) Q
 ;call xbgsave to create output file
 K ^TMP($J,"SUMMARYDEL")
 S XBGL="APCMDATA"
 L +^APCMDATA:300 E  W:'$D(ZTQUEUED) "Unable to lock global" Q
 K ^APCMDATA ;NOTE: kill of unsubscripted export global
 S X=0 F  S X=$O(^TMP($J,"APCMDEL",X)) Q:X'=+X  S ^APCMDATA(X)=^TMP($J,"APCMDEL",X)
 D
 .S XBFLT=1,XBFN=APCMDELF_".txt",XBMED="F",XBTLE="MU PERFORMANCE REPORT DELIMITED OUTPUT",XBQ="N",XBF=0
 .D ^XBGSAVE
 .K XBFLT,XBFN,XBMED,XBTLE,XBE,XBF
 L -^APCMDATA
 K ^APCMDATA ;NOTE: kill of unsubscripted export global
 K ^TMP($J)
 Q
 ;
SCREEN ;
 S X=0 F  S X=$O(^TMP($J,"APCMDEL",X)) Q:X'=+X  W !,^TMP($J,"APCMDEL",X)
 Q
