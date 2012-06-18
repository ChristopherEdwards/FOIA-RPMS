FHCTF5 ; IOFO/REL - Check Inpatients for Monitors ;26-Jan-2004 11:24;PLS
 ;;5.0;Dietetics;**29,32**;Oct 11, 1995
 ; Modified - IHS/CIA/PLS - 01/26/04 -
 D NOW^%DTC S NOW=% D CLR
 F WRD=0:0 S WRD=$O(^FH(119.6,WRD)) Q:WRD<1  S FHDUZ=$P($G(^(WRD,0)),"^",2) F DFN=0:0 S DFN=$O(^FHPT("AW",WRD,DFN)) Q:DFN<1  S ADM=^(DFN) D PAT
 K %,A1,A2,ADM,BMI,CLR,DA,DD,DFN,DIC,DTE,FHDUZ,FHOR,FHORD,FHTF
 K GMRVSTR,HT,L,LST,MONIFN,MONTX,N,NOW,PX,STOP,TF,WRD,WT,X,X0,Y
 Q
PAT ;; Check a patient
 S Y=^DPT(DFN,0),NAM=$P(Y,"^",1),SEX=$P(Y,"^",2),DOB=$P(Y,"^",3)
 S AGE="" I DOB'="" S AGE=$E(NOW,1,3)-$E(DOB,1,3)-($E(NOW,4,7)<$E(DOB,4,7))
P0 ; Calculate BMI
 ; IHS/CIA/PLS - 01/26/04 - Redirect to V Measurements
 ;S GMRVSTR="WT" D EN6^GMRVUTL S WT=$P(X,"^",8)  ;COMM'D OUT IHS/PLS
 ;S GMRVSTR="HT" D EN6^GMRVUTL S HT=$P(X,"^",8)  ;COMM'D OUT IHS/PLS
 S WT=$$VITAL^CIAVIHVT(DFN,"WT") ; IHS/PLS - redirect to PCC
 S HT=$$VITAL^CIAVIHVT(DFN,"HT") ; IHS/PLS - redirect to PCC
 S BMI="" I WT,HT S A2=HT*.0254,BMI=+$J(WT/2.2/(A2*A2),0,1)
 I $G(BMI)=""!($G(BMI)'<21) G P1
 S MONTX="Monitor: BMI < 21",DTE=NOW
 S N=$O(^FHPT(DFN,"A",ADM,"MO","B",MONTX,""),-1) I 'N D FIL G P1
 ; Check if been 30 days
 S LST=$P($G(^FHPT(DFN,"A",ADM,"MO",N,0)),"^",2)
 S X=$$FMDIFF^XLFDT(DTE,LST,3) I X>30 D FIL
P1 ; Check for current Tubefeeding
 S TF=$P($G(^FHPT(DFN,"A",ADM,0)),"^",4) I 'TF G P2
 S MONTX="Monitor: On Tubefeeding",DTE=NOW
 S N=$O(^FHPT(DFN,"A",ADM,"MO","B",MONTX,""),-1) I 'N D FIL G P2
 ; Check if been 7 days
 S LST=$P($G(^FHPT(DFN,"A",ADM,"MO",N,0)),"^",2)
 S X=$$FMDIFF^XLFDT(DTE,LST,3) I X>7 D FIL
P2 ; Check for Hyperals
 S MONTX="",DTE=NOW
 F STOP=NOW:0 S STOP=$O(^PS(55,DFN,"IV","AIT","H",STOP)) Q:STOP<1  F DA=0:0 S DA=$O(^PS(55,DFN,"IV","AIT","H",STOP,DA)) Q:DA<1  D
 .S X0=$P($G(^PS(55,DFN,"IV",DA,0)),"^",2) I X0>NOW Q
 .S MONTX="Monitor: On Hyperals" Q
 D:MONTX'="" FIL
P3 ; Check for Serum Albumin
 S MONTX="",PX=6 D LAB^FHASM4 I $D(^TMP($J,"LRTST")) D
 .F L=0:0 S L=$O(^TMP($J,"LRTST",L)) Q:L<1  S Y=$TR($P(^(L),"^",6)," ","") I Y'?1A.E,Y<3.2 S MONTX="Monitor: Albumin < 3.2",DTE=$P(^(L),"^",7) Q
 .Q
 G:MONTX="" P4
 S N=$O(^FHPT(DFN,"A",ADM,"MO","B",MONTX,""),-1) I 'N D FIL G P4
 ; Check if same test
 S LST=$P($G(^FHPT(DFN,"A",ADM,"MO",N,0)),"^",2) I DTE>LST D FIL
P4 ; Check for NPO+Clr Liq > 3 days
 S A1=NOW,DTE=NOW
 F  D  Q:'A1
 .S A1=$O(^FHPT(DFN,"A",ADM,"AC",A1),-1) Q:'A1
 .S FHORD=$P($G(^FHPT(DFN,"A",ADM,"AC",A1,0)),"^",2) I 'FHORD S A1="" Q
 .S FHOR=$G(^FHPT(DFN,"A",ADM,"DI",FHORD,0))
 .I $P(FHOR,"^",7)="N" S DTE=A1 Q
 .I $P(FHOR,"^",2)=CLR S DTE=A1 Q
 .S A1="" Q
 I DTE'<NOW G P5
 S X=$$FMDIFF^XLFDT(NOW,DTE,3) G:X<3 P5
 S MONTX="Monitor: NPO+Clr Liq > 3 days",DTE=NOW
 S N=$O(^FHPT(DFN,"A",ADM,"MO","B",MONTX,""),-1) I 'N D FIL G P5
 ; Check if been 3 days
 S LST=$P($G(^FHPT(DFN,"A",ADM,"MO",N,0)),"^",2)
 S X=$$FMDIFF^XLFDT(NOW,LST,3) I X>3 D FIL
P5 ; Done
 Q
CLR ; Find Clear Liquid
 S CLR=$O(^FH(111,"B","CLEAR LIQUID",0)) Q:CLR
 S CLR=$O(^FH(111,"C","CLEAR LIQUID",0)) Q:CLR
 S CLR=$O(^FH(111,"C","CLR LIQ",0)) Q:CLR
 S CLR=$O(^FH(111,"C","CL",0)) Q:CLR
 Q
FIL ; File Monitor
 L +^FHPT(DFN,"A",ADM,"MO",0)
 I '$D(^FHPT(DFN,"A",ADM,"MO",0)) S ^FHPT(DFN,"A",ADM,"MO",0)="^115.11^^"
 L -^FHPT(DFN,"A",ADM,"MO",0)
 K DIC,DD,DO,DINUM S DIC="^FHPT(DFN,""A"",ADM,""MO"",",DIC(0)="L",DA(1)=ADM,DA(2)=DFN,DLAYGO=115,X=MONTX D FILE^DICN K DIC,DLAYGO
 Q:Y<1  S MONIFN=+Y
 S $P(^FHPT(DFN,"A",ADM,"MO",MONIFN,0),"^",2)=DTE,^FHPT(DFN,"A",ADM,"MO","AC",DTE,MONIFN)=""
 S FHTF=DTE_"^M^"_MONTX_"^"_DFN_"^"_ADM_"^"_MONIFN
 D:FHDUZ FILE^FHCTF2 Q
