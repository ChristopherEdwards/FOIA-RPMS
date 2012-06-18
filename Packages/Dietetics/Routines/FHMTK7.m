FHMTK7 ; HISC/NCA - Update Diet Restrictions ;12/6/00  15:14
 ;;5.0;Dietetics;**27,30,35**;Oct 11, 1995
 ; Update the Diet Restrictions For All Inpatients
 R !!,"Update All Diet Related Information for Patients? Y // ",X:DTIME Q:'$T!(X["^")
 S:X="" X="Y" D TR^FH I $P("YES",X,1)'="",$P("NO",X,1)'="" W *7,!,"  Answer YES or NO" G FHMTK7
 S ANS=X?1"Y".E Q:'ANS
 F W1=0:0 S W1=$O(^FHPT("AW",W1)) Q:W1'>0  F DFN=0:0 S DFN=$O(^FHPT("AW",W1,DFN)) Q:DFN<1  S ADM=$G(^FHPT("AW",W1,DFN)) D:ADM PAT,STORD,SFMENU  ;P30
 Q
STORD ;Update Standing orders for a patient, P30
 D SO^FHMTK8
 Q
SFMENU ;Update SF Menu for a patient, P30
 D SF^FHMTK8
 Q
PAT ; Update Restrictions for a patient
 S FHORD=$P($G(^FHPT(DFN,"A",ADM,0)),"^",2) I FHORD<1 S DPAT="" G UPD
 S Z=$G(^FHPT(DFN,"A",ADM,"DI",FHORD,0)),FHOR=$P(Z,"^",2,6) I "^^^^"[FHOR S DPAT="" G UPD
 S DPAT=$O(^FH(111.1,"AB",FHOR,0)) G:DPAT="" UPD
 Q:'$D(^TMP($J,+DPAT))
 ;
UPD ; Update Pattern
 S (COM,PP)=""
 F SP=0:0 S SP=$O(^FHPT(DFN,"P",SP)) Q:SP<1  S M2=$G(^(SP,0)) I $P(M2,"^",4)="Y" D
 .S FP=+M2 I $D(^FH(111.1,+DPAT,"RES","B",FP)) Q
 .D PURG Q
 F R1=0:0 S R1=$O(^FH(111.1,+DPAT,"RES",R1)) Q:R1<1  S M2=$G(^(R1,0)),FP=+M2 I FP D
 .S SP=$O(^FHPT(DFN,"P","B",FP,0)) I 'SP D ADD Q
 .I $P($G(^FHPT(DFN,"P",SP,0)),"^",2)=$P(M2,"^",2) Q
 .D CHG Q
 G FIL
CHG ; Change the Diet Restrictions
 S MEAL=$P(M2,"^",2)
 I $P($G(^FHPT(DFN,"P",SP,0)),"^",4)="Y" S M2=MEAL G CHG1 ;diet related
 Q:MEAL=""
 S M1=$P($G(^FHPT(DFN,"P",SP,0)),"^",2) Q:M1=""  S:M1="A" M1="BNE"
 S M2="" F LP=1:1:$L(MEAL) I M1'[$E(MEAL,LP) S M2=M2_$E(MEAL,LP)
 Q:M2=""
 S M1=M1_M2,M2="" S:M1["B" M2="B" S:M1["N" M2=M2_"N" S:M1["E" M2=M2_"E"
CHG1 S $P(^FHPT(DFN,"P",SP,0),"^",2)=M2
 S PP=" Mod 1 "_$P(^FH(115.2,+FP,0),"^",1)_" ("_M2_")"_" (D)" D SET
 Q
ADD ; Add the Diet Restriction
 S MEAL=$P($G(M2),"^",2) Q:MEAL=""
 K DIC,DD,DO S DIC="^FHPT(DFN,""P"",",DIC(0)="L",DLAYGO=115,DA(1)=DFN,X=+FP
A1 L +^FHPT(DFN,"P",0)
 I '$D(^FHPT(DFN,"P",0)) S ^FHPT(DFN,"P",0)="^115.09PA^^"
 S NUM=$P(^FHPT(DFN,"P",0),"^",3)+1
 S $P(^FHPT(DFN,"P",0),"^",3)=NUM
 L -^FHPT(DFN,"P",0) I $D(^FHPT(DFN,"P",NUM,0)) G A1
 S DINUM=NUM D FILE^DICN S SP=+Y K DIC,DLAYGO,DINUM
 S $P(^FHPT(DFN,"P",+SP,0),"^",2,4)=MEAL_"^^Y",PP=" Add 1 "_$P(^FH(115.2,+FP,0),"^",1)_" ("_$P(FP,"^",2)_")"_" (D)" D SET
 Q
PURG ; Purge the Old Restrictions
 S M1=$P($G(^FHPT(DFN,"P",SP,0)),"^",2) Q:M1=""  S:M1="A" M1="BNE"
 K DIK S DA(1)=DFN,DA=+SP,DIK="^FHPT("_DA(1)_",""P""," D ^DIK K DIK,DA S PP=" Del 1 "_$P(^FH(115.2,+FP,0),"^",1)_" ("_M1_")"_" (D)" D SET Q
SET I $L(COM)+$L(PP)>120 S EVT="P^O^^"_$E(COM,2,999) D ^FHORX S COM=""
 S COM=COM_PP
 Q
FIL ; File the Event
 I COM'="" S EVT="P^O^^"_$E(COM,2,999) D ^FHORX
 Q
