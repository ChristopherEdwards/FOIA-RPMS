FHWADM ; HISC/REL - Set up admission ;12/4/00  10:35
 ;;5.0;Dietetics;**5,6,25,27**;Oct 11, 1995
 N FHWF S FHWF=$S($D(^ORD(101)):1,1:0)
 I '$D(^FHPT(DFN)) S ^FHPT(DFN,0)=DFN,$P(^FHPT(0),"^",3)=DFN,$P(^FHPT(0),"^",4)=$P(^(0),"^",4)+1
 I '$D(^FHPT(DFN,"A",0)) S ^FHPT(DFN,"A",0)="^115.01^^"
 D NOW^%DTC S (FHX3,X)=$S($D(^DGPM(ADM,0)):$P(^(0),"^",1),1:%)
 I $D(^FHPT(DFN,"A",ADM)) S $P(^(ADM,0),"^",1)=X G:$G(^DPT(DFN,.105))'=ADM KIL G UPD
 S $P(^FHPT(DFN,"A",0),"^",3)=ADM,$P(^(0),"^",4)=$P(^(0),"^",4)+1
 S ^FHPT(DFN,"A",ADM,0)=X_"^^^^^^^^"
 S FHX1=$G(^DPT(DFN,.108)),FHX2=""
 I FHX1 S FHX1=$O(^FH(119.6,"AR",FHX1,0))
 E  S FHX1=$G(^DPT(DFN,.1)) I FHX1'="" S FHX1=$O(^DIC(42,"B",FHX1,0)) S:FHX1 FHX1=$O(^FH(119.6,"AW",FHX1,0))
 S FHX1=$G(^FH(119.6,+FHX1,0))
 S FHX2=$P(FHX1,"^",16),FHX1=$P(FHX1,"^",15) I 'FHX1,FHX2'="Y" G UPD
 S X=$S(FHX3>%:FHX3,1:%)
 S ^FHPT(DFN,"A",ADM,"AC",X,0)=X_"^1",^FHPT(DFN,"A",ADM,"AC",0)="^115.14^"_X_"^1",^FHPT(DFN,"A",ADM,"DI",0)="^115.02A^1^1"
 S $P(^FHPT(DFN,"A",ADM,0),"^",2)=1
 I 'FHX1 S ^FHPT(DFN,"A",ADM,"DI",1,0)="1^^^^^^X^^"_X_"^^"_DUZ_"^"_% S EVT="D^O^1" D ^FHORX G UPD
 S FHX2=$P($G(^FH(111,FHX1,0)),"^",5)
 S ^FHPT(DFN,"A",ADM,"DI",1,0)="1^"_FHX1_"^^^^^^T^"_X_"^^"_DUZ_"^"_%_"^"_FHX2
 S $P(^FHPT(DFN,"A",ADM,0),"^",5)="T" S EVT="D^O^1" D ^FHORX
 I 'FHWF S FHOR=FHX1_"^^^^" D ADD K FHOR G UPD
 S FHNEW="D;"_ADM_";"_1_";"_X_";;;;T;;"_FHX1_";;;;",D1=X,D2="" D NOW^%DTC S NOW=%,FHPV=DUZ,FHOR=FHX1_"^^^^" D DO^FHWOR2
 S $P(^FHPT(DFN,"A",ADM,0),"^",14)="" D WRD D MSG^XQOR("FH EVSEND OR",.MSG) K D1,D2,FHPV,FHNEW,MSG,NOW S $P(^FHPT(DFN,"A",ADM,"DI",1,0),"^",15)=6 D ADD K FHOR G KIL
UPD S $P(^FHPT(DFN,"A",ADM,0),"^",14)="" D WRD G KIL
WRD ; Update Room/Bed & Ward for current admission
 N FHWRD,FHRMB,WARD D DID^FHDPA Q:WARD=""  S ADM=$G(^DPT("CN",WARD,DFN)) Q:'ADM
 I '$D(^FHPT(DFN,"A",ADM,0)) Q
 S WARD=$P(^FHPT(DFN,"A",ADM,0),"^",8),EVT="L^"_$S(WARD:"T",1:"A")_"^^"_WARD_"~"_$P(^(0),"^",9) I WARD'=FHWRD G NEW
 I $P(^FHPT(DFN,"A",ADM,0),"^",9)'=FHRMB S $P(^(0),"^",9)=FHRMB S EVT=EVT_"~"_FHWRD_"~"_FHRMB D ^FHORX
 Q
NEW ; New Ward
 S $P(^FHPT(DFN,"A",ADM,0),"^",8,9)=FHWRD_"^"_FHRMB
 K:WARD ^FHPT("AW",WARD,DFN) I FHWRD S ^FHPT("AW",FHWRD,DFN)=ADM S EVT=EVT_"~"_FHWRD_"~"_FHRMB D ^FHORX
 ; Update Type of Service
 S FHX3=$P($G(^FH(119.6,+FHWRD,0)),"^",10) S:FHX3="" FHX3="TCD" I FHX3[$P(^FHPT(DFN,"A",ADM,0),"^",5) Q
 S FHX3=$S($L(FHX3)=1:FHX3,FHX3["D":"D",1:"C"),$P(^FHPT(DFN,"A",ADM,0),"^",5)=FHX3
 S FHX2=$P(^FHPT(DFN,"A",ADM,0),"^",2) I FHX2,$P($G(^FHPT(DFN,"A",ADM,"DI",+FHX2,0)),"^",8)'="" S $P(^(0),"^",8)=FHX3
 Q
ADD ; Add diet associated Diet Restriction
 D NOW^%DTC S NOW=%
 S DPAT=$O(^FH(111.1,"AB",FHOR,0))
 D UPD^FHMTK7
 K COM,DPAT,EVT,FP,L,LN,LP,LS,M,M1,M2,MEAL,N,NM,NO,NUM,NX,OPAT,P,PP,PNN,PNO,R1,SF,SP,X3,^TMP($J),Z
 Q
KIL K %,%H,%I,FHX1,FHX2,FHX3,FHRMB,FHWRD,X Q
