SRONON0 ;BIR/ADM - NON-O.R. PROCEDURE REPORT ; [ 09/22/99  6:40 AM ]
 ;;3.0; Surgery ;**38,48,86,88**;24 Jun 93
 ;
 ; Reference to ^ECC(723 supported by DBIA #205
 ; Reference to ^PSDRUG supported by DBIA #221
 ;
 U IO F X=0:.1:1.1,"NON" S SRTN(X)=$S($D(^SRF(SRTN,X))#2:^(X),1:"")
 S ICD=$P($G(^SRF(SRTN,34)),"^",2) I ICD S ICD=$P(^ICD9(ICD,0),"^")
 D HDR^SRONON G:SRSOUT END^SRONON1 W !,"Med. Specialty: ",$E($P(^ECC(723,$P(^SRF(SRTN,"NON"),"^",8),0),"^"),1,25)
 S SRLOC="",SRL=$P(^SRF(SRTN,"NON"),"^",2) S:SRL SRLOC=$E($P(^SC(SRL,0),"^"),1,25) W ?44,"Location: "_SRLOC
 D UL G:SRSOUT END^SRONON1 W !,"Principal Diagnosis:",!,?3,$P($G(^SRF(SRTN,33)),U,2),?50,"ICD9 CODE: ",ICD S SRPOST=1
PROV D UL G:SRSOUT END^SRONON1 W !,"Provider: " S Z=$P(SRTN("NON"),U,6) D N W $E(Z,1,30)
 S X=$P($G(^SRF(SRTN,0)),"^",12) I X'="" S SRSTATUS=$S(X="I":"INPATIENT",1:"OUTPATIENT") W ?50,"Patient Status: ",SRSTATUS
 D UL G:SRSOUT END^SRONON1 W !,"Attending: " S Z=$P(SRTN("NON"),"^",7) D N W $E(Z,1,28)
 S X=$P(SRTN(.1),"^",16),SRATT=$S(X=0:"0. STAFF",X=1:"1. ATTENDING IN O.R.",X=2:"2. ATTENDING IN O.R. SUITE",X=3:"3. ATTENDING NOT PRESENT,",1:"") W ?40,"Att Code: "_SRATT W:X=3 !,?50,"BUT AVAILABLE"
ANES D UL G:SRSOUT END^SRONON1 S SRTN(.3)=$S('$D(^SRF(SRTN,.3)):"",1:^SRF(SRTN,.3)) W !,"Attend Anesth: " S Z=$P(SRTN(.3),U,4) D N W $E(Z,1,30)
 W !,"Anesthesia Supervisor Code: ",$S($P(SRTN(.3),"^",6)="":"",1:$P(^SRO(132.95,$P(SRTN(.3),"^",6),0),"^",1))
 D UL G:SRSOUT END^SRONON1 W !,"Anesthetist: " S Z=$P(SRTN(.3),U,1) D N W $E(Z,1,30)
 K V,V1,V2 D UL G:SRSOUT END^SRONON1 W !,"Anesthesia Technique:" F V=0:0 S V=$O(^SRF(SRTN,6,V)) Q:'V  S Y=$P(^(V,0),U),C=$P(^DD(130.06,.01,0),"^",2) D:Y'="" Y^DIQ W !,?5,Y W:$P(^SRF(SRTN,6,V,0),U,3)="Y" "  (PRINCIPAL)" D DRUG
 D TECH I $E(SRTECH,1,2)'="NO" W !!,"Diagnostic/Therapeutic (Y/N): " S Z=$P($G(^SRF(SRTN,31)),"^",9),Z=$S(Z="N":"NO",Z="Y":"YES",1:"") W Z
 D UL G:SRSOUT END^SRONON1 S SRTN(.2)=$S($D(^SRF(SRTN,.2)):^(.2),1:"") W !,"Anes Begin:" S Y=$P(SRTN(.2),U,1) X ^DD("DD") W ?13,Y,?40,"Anes End:" S Y=$P(SRTN(.2),U,4) X ^DD("DD") W ?51,Y
 D UL G:SRSOUT END^SRONON1 W !,"Proc Begin:" S Y=$P(SRTN("NON"),U,4) X ^DD("DD") W ?13,Y,?40,"Proc End:" S Y=$P(SRTN("NON"),U,5) X ^DD("DD") W ?51,Y
 D UL G:SRSOUT END^SRONON1 W !,"Procedure(s) Performed:"
 D:$Y>(IOSL-10) UL W !,"  Principal: " D PRIN
 I $O(^SRF(SRTN,13,0)) D OTHER
 I $O(^SRF(SRTN,22,0)) D UL W !,"Medications: " S (MED,CNT)=0 F  S MED=$O(^SRF(SRTN,22,MED)) Q:'MED!(SRSOUT)  S CNT=CNT+1 D MED
 G ^SRONON1
MED ; medications
 I $Y+13>IOSL D FOOT^SRONON Q:SRSOUT  D:$E(IOST)="P" HDR^SRONON D UL
 S DRUG=^SRF(SRTN,22,MED,0),DRUG=$P(^PSDRUG(DRUG,0),"^") W:CNT>1 ! W !,?2,DRUG
 S ADM=0 F  S ADM=$O(^SRF(SRTN,22,MED,1,ADM)) Q:'ADM!SRSOUT  D MED1
 Q
MED1 ; more medication info
 I $Y+12>IOSL D FOOT^SRONON Q:SRSOUT  D:$E(IOST)="P" HDR^SRONON D UL
 S MM=^SRF(SRTN,22,MED,1,ADM,0),Y=$P(MM,"^") D D^DIQ S TIME=$P(Y,"@")_"  "_$P(Y,"@",2)
 S DOSE=$P(MM,"^",2),X=$P(MM,"^",3) S ORBY=$S(X:$P(^VA(200,X,0),"^"),1:"")
 S X=$P(MM,"^",4) S ADBY=$S(X:$P(^VA(200,X,0),"^"),1:"")
 S Y=$P(MM,"^",5),C=$P(^DD(130.34,4,0),"^",2) D:Y'="" Y^DIQ S ROUTE=Y
 S COMMENT=$P(MM,"^",6)
 W !,?4,"Time Administered: "_TIME,!,?6,"Route: "_ROUTE,?45,"Dosage: "_DOSE W:ORBY'="" !,?6,"Ordered By: "_ORBY W:ADBY'="" !,?6,"Administered By: "_ADBY
 W:COMMENT'="" !,?6,"Comments: "_COMMENT
 Q
UL I $Y>(IOSL-10) D FOOT^SRONON Q:SRSOUT  D HDR^SRONON Q:SRSOUT  I 1
 E  I SRT="UL" D UL1
Q Q:SRT="UL"  I $Y>(IOSL-10) D FOOT^SRONON Q:SRSOUT  D HDR^SRONON Q:SRSOUT  I 1
 Q
UL1 I '$D(SRNIGHT),IO(0)=IO,'$D(ZTQUEUED) W !
 W $C(13) F X=1:1:79 W "_"
 Q
DRUG Q:$P(^SRF(SRTN,6,V,0),"^")="N"
 W !,?8,"Agents:" F V1=0:0 S V1=$O(^SRF(SRTN,6,V,V1)) Q:'V1  F V2=0:0 S V2=$O(^SRF(SRTN,6,V,V1,V2)) Q:'V2  I $D(^(V2,0)) S T=^(0) W ?16,$S(+T=0:"",$D(^PSDRUG(+T,0)):$P(^(0),U),1:"UNKNOWN") W:$P(T,"^",2) "   "_$P(T,"^",2)_" mg" W !
 Q
CPT K ^UTILITY($J,"W") D:$Y>(IOSL-10) UL W !,?5,"Procedure Code Comments:" S SRCOM=0 F  S SRCOM=$O(^SRF(SRTN,13,OTH,1,SRCOM)) Q:'SRCOM!SRSOUT  S X=^SRF(SRTN,13,OTH,1,SRCOM,0),DIWL=5,DIWR=70,DIWF="N" D ^DIWP
 Q:SRSOUT  I $D(^UTILITY($J,"W")) F V=1:1:^UTILITY($J,"W",DIWL) D:$Y>(IOSL-10) UL G:SRSOUT END^SRONON W !,?DIWL,^UTILITY($J,"W",DIWL,V,0)
 K ^UTILITY($J,"W")
 Q
LOOP ; break procedure if greater than 65 characters
 S SROPS(M)="" F LOOP=1:1 S MM=$P(SRP," "),MMM=$P(SRP," ",2,200) Q:MMM=""  Q:$L(SROPS(M))+$L(MM)'<65  S SROPS(M)=SROPS(M)_MM_" ",SRP=MMM
 Q
N S Z=$S(Z="":Z,$D(^VA(200,Z,0)):$P(^(0),U,1),1:Z) Q
TECH N SRT D TECH^SROPRIN
 Q
PRIN ; print principal procedure information
 S SROPER=$P(^SRF(SRTN,"OP"),"^"),X=$P(^("OP"),"^",2),Z=$S(X:$$CPT^ICPTCOD(X),1:"^NOT ENTERED"),SRCPT=$P(Z,"^",2)_"  "_$P(Z,"^",3)
 I $P($G(^SRF(SRTN,30)),"^")&$P($G(^SRF(SRTN,.2)),"^",10) S SROPER="** ABORTED ** "_SROPER
 K SROPS,MM,MMM S:$L(SROPER)<65 SROPS(1)=SROPER I $L(SROPER)>64 S SRP=SROPER_"  " F M=1:1 D LOOP Q:MMM=""
 W SROPS(1) I $D(SROPS(2)) D:$Y>(IOSL-10) UL W !,?13,SROPS(2) I $D(SROPS(3)) D:$Y>(IOSL-10) UL W !,?13,SROPS(3)
 D:$Y>(IOSL-10) UL W !,?4,"CPT Code: "_SRCPT K SRCPT
 S SRI=0,SRX="Modifiers: -" F  S SRI=$O(^SRF(SRTN,"OPMOD",SRI)) Q:'SRI  D
 .S SRZ=$P(^SRF(SRTN,"OPMOD",SRI,0),"^"),SRY=$$MOD^ICPTMOD(SRZ,"I")
 .D:$Y>(IOSL-10) UL W !,?5,SRX_$P(SRY,"^",2)_" "_$E($P(SRY,"^",3),1,59)
 .S SRX="           -"
 Q
OTHER ; other procedures
 D:$Y>(IOSL-10) UL W ! S (OTH,CNT)=0 F  S OTH=$O(^SRF(SRTN,13,OTH)) Q:'OTH  S CNT=CNT+1 D OTH
 Q
OTH S OTHER=$P(^SRF(SRTN,13,OTH,0),"^"),X=$P($G(^SRF(SRTN,13,OTH,2)),"^"),Z=$S(X:$$CPT^ICPTCOD(X),1:"^NOT ENTERED"),SRCPT=$P(Z,"^",2)_"  "_$P(Z,"^",3)
 D:$Y>(IOSL-10) UL W !,"  Other: "_OTHER D:$Y>(IOSL-10) UL W !,?4,"CPT Code: "_SRCPT K SRCPT
 S SRI=0,SRX="Modifiers: -" F  S SRI=$O(^SRF(SRTN,13,OTH,"MOD",SRI)) Q:'SRI  D
 .S SRZ=$P(^SRF(SRTN,13,OTH,"MOD",SRI,0),"^"),SRY=$$MOD^ICPTMOD(SRZ,"I")
 .D:$Y>(IOSL-10) UL W !,?5,SRX_$P(SRY,"^",2)_" "_$E($P(SRY,"^",3),1,59)
 .S SRX="           -"
 I $P($G(^SRF(SRTN,13,OTH,2)),"^"),$O(^SRF(SRTN,13,OTH,1,0)) D CPT
 Q
