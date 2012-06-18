ABMDE5C ; IHS/ASDST/DMJ - PAGE 5C - DIAGNOSIS-Prov Narrative ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 S ABMA("C")=0,ABMA("D")="",$P(ABMA("D"),".",80)=""
 S ABMA=0 F ABMA("I")=1:1 S ABMA=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,ABMA)) Q:'ABMA  D V1
 I ABMA("I")>1!(ABMA("C")>0) W !,ABMA("D"),!
 G XIT
V1 ; view
 S ABMA("V")="" F ABMA("J")=1:1 S ABMA("V")=$O(^AUPNVPOV("AD",ABMA,ABMA("V"))) Q:'ABMA("V")  D POV
 Q
 ;
POV I $D(^AUPNVPOV(ABMA("V"),0)) S ABMA(0)=^(0)
 E  Q
 Q:'$D(^AUPNVSIT(ABMA,0))  S ABMA("X")=$P(^AUPNVSIT(ABMA,0),U) D DT
 S ABMA("C")=ABMA("C")+1
 I ABMA("C")=1&(ABMA("I")=1) G SUB
 W !,ABMA("X")
 K ABMU S ABMU("TXT")=$P(^AUTNPOV($P(ABMA(0),U,4),0),U),ABMU("LM")=10,ABMU("RM")=79
 D ^ABMDWRAP
 Q
 ;
SUB W !,"VISIT DT",?30,"PROVIDER'S NARRATIVE"
 W !,"--------",?10,"---------------------------------------------------------------------"
 Q
 ;
XIT K ABMA
 Q
 ;
DT ;dated conversion
 I ABMA("X")]"" S ABMA("X")=$$HDT^ABMDUTL(ABMA("X"))
 Q
