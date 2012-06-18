BTIULO10 ; MSC/IHS/MGH - Outside Meds ;25-Sep-2009 10:41;MGH
 ;;1.0;TEXT INTEGRATION UTILITIES;**1006**;NOV 04, 2004
 Q
 ;
 ; Created Outside med object
 ;
ACTHMMD(DFN) ; EP Logic taken from PSOP2 retrieve non-VA meds
 ;
 Q:$G(DFN)="" "No DFN"
 Q:'$D(^DPT(DFN,0)) "No patient"
 Q:'$O(^PS(55,DFN,"NVA",0)) "No Outside Medications"
 N HOMMD,CNT,MCNT,OUTMED,PPP,NVA,NVAOR,PCNT
 K PQT S CNT=0,PCNT=1
 K ^TMP($J,"ACTIVE-OUTSIDE-MEDS")
 S HOMMD="^TMP($J,""ACTIVE-OUTSIDE-MEDS"")"
 S CNT=CNT+1
 S @HOMMD@(CNT,0)="   Active OUTSIDE Medications"
 S CNT=CNT+1
 S @HOMMD@(CNT,0)="==============================================="
 S MCNT=0
 F PPP=0:0 S PPP=$O(^PS(55,DFN,"NVA",PPP)) Q:'PPP!($G(PQT))  S NVAOR=^PS(55,DFN,"NVA",PPP,0),NVA=1 D
 .;
 .Q:'$P(NVAOR,"^")
 .Q:$P(NVAOR,"^",7)
 .S MCNT=MCNT+1
 .S OUTMED=MCNT_")  "_$S($P(NVAOR,"^",2):$P($G(^PSDRUG(+$P(NVAOR,"^",2),0)),"^"),1:$P($G(^PS(50.7,$P(NVAOR,"^"),0)),"^")_" "_$P($G(^PS(50.606,+$P($G(^(0)),"^",2),0)),"^"))
 .S OUTMED=OUTMED_"    Date Documented: "_$E($P(NVAOR,"^",10),4,5)_"/"_$E($P(NVAOR,"^",10),6,7)_"/"_$E($P(NVAOR,"^",10),2,3)
 .S CNT=CNT+1,@HOMMD@(CNT,0)=OUTMED
 .I $P(NVAOR,"^",3)'="" S CNT=CNT+1,@HOMMD@(CNT,0)="      Dosage: "_$P(NVAOR,"^",3)_$S($P(NVAOR,"^",5)'="":", Schedule: "_$P(NVAOR,"^",5),1:" ")
 .;S CNT=CNT+1,@HOMMD@(CNT,0)="Status: "_$S($P(NVAOR,"^",7):"Discontinued ("_$E($P(NVAOR,"^",7),4,5)_"/"_$E($P(NVAOR,"^",7),6,7)_"/"_$E($P(NVAOR,"^",7),2,3)_")",1:"Active")
 .;S CNT=CNT+1,@HOMMD@(CNT,0)=" "
 .Q
 I $D(^TMP($J,"ACTIVE-OUTSIDE-MEDS",4)) Q "~@"_$NA(@HOMMD)
 E  Q "No Home Medications"
 Q
 ;
 ; *****************************
 ; removes trailing spaces from text
 ; i.e : "have a nice daysssss"
 ; result: "have a nice day"
 ;
STRIP(TXT) ;
 N MSCNT
 Q:$L(TXT)<2 ""
 F MSCNT=46:-1:1 Q:$E(TXT,MSCNT)'=" "  D
 . S TXT=$E(TXT,1,$L(TXT)-1)
 Q TXT
PAPWC(DFN,TARGET) ;EP; -- returns last pap date and result and result text
 N N,Y,BW,DATE,LINE,L
 S CNT=0
 I $P(^DPT(DFN,0),U,2)="M" Q ""
 S N=0 F  S N=$O(^BWPCD("C",DFN,N)) Q:'N  D
 .S Y=$G(^BWPCD(N,0))
 .I $P(Y,U,4)=1 S DATE=$P(Y,U,12) D
 ..S BW("PAP",9999999-DATE)=DATE_U_$P(Y,U,5)_U_N
 I '$D(BW("PAP")) Q "No PAP on record"
 S N=$O(BW("PAP",0)) I 'N Q "No PAP on record"
 S N=BW("PAP",N)
 S LINE="Last PAP: "_$$FMTE^XLFDT(+N,"5D")
 S LINE=LINE_"  Result - "_$$GET1^DIQ(9002086.31,$P(N,U,2),.01)
 S LINE=LINE_" ("_$$GET1^DIQ(9002086.1,$P(N,U,3),.14)_")"
 S CNT=CNT+1
 S @TARGET@(CNT,0)=LINE
 N WP,IENS,LINE
 S IENS=$P(N,U,3)_","
 S WP=$$GET1^DIQ(9002086.1,IENS,1.01,"Z","WP")
 S L=0
 F  S L=$O(WP(L)) Q:L=""  D
 .S CNT=CNT+1
 .S LINE=$G(WP(L,0))
 .I L=1 S LINE="Results: "_LINE
 .S @TARGET@(CNT,0)=LINE
 Q "~@"_$NA(@TARGET)
