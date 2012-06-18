BLRRLEDI ;cmi/flag/maw - BLR REFERENCE LAB LEDI UTILITIES ;6/22/2010 7:51:37 AM
 ;;5.2T;IHS LABORATORY;**1027**;NOV 01, 1997;Build 9
 ;
 ;
 ;
ORD(OR,PAT) ;-- lets create the order stub here
 I $O(^BLRRLO("B",OR,0)) Q $O(^BLRRLO("B",OR,0))
 N FDA,FIENS,FERR
 S FIENS=""
 S FDA(9009026.3,"+1,",.01)=OR
 S FDA(9009026.3,"+1,",.04)=PAT
 D UPDATE^DIE("","FDA","FIENS","FERR(1)")
 I $D(FERR(1)) W !,"Error adding order number "_OR_" to Reference Lab Order file" Q ""
 Q $G(FIENS(1))
 ;
ACC(AC,OR,PAT,CDT) ;-- add the accession number to the order
 N FI,FIENS,FDA,FERR,ORI
 I '$G(CDT) S CDT=DT
 S FI=$O(^BLRRLO("B",OR,0))
 I '$G(FI) S FI=$$ORD(OR,PAT)
 I '$G(FI) Q ""
 S FIENS=FI_","
 S FDA(9009026.33,"+2,"_FIENS,.01)=AC
 D UPDATE^DIE("","FDA","FIENS","FERR(1)")
 I $D(FERR(1)) W !,"Error adding accession number "_AC_" to Order "_OR_" in the Reference Lab Order file" Q ""
 Q $G(FI)
 ;
DX(OR) ;-- lets add/edit diagnosis here
 N ORI
 S ORI=$O(^BLRRLO("B",OR,0))
 I $O(^BLRRLO(ORI,1,"B",0)) S BLRDXS=1
 S DA(1)=ORI
 S DIC(0)="AELMQZ"
 S DIC("A")="Enter ICD Diagnosis code for billing: "
 S DIC="^BLRRLO("_ORI_",1,"
 D ^DIC
 Q:Y<0
 S BLRDXS=1
 D DX(OR)  ;allow adding until they ^ out
 Q
 ;
CLIENT(OR,AC) ;client account number
 N BLRCLCNT
 S BLRCLCNT=$$CLCNT(DUZ(2))
 I $G(BLRCLCNT)=1 D
 . S BLRRL("CLIENT")=$O(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RLCA","B",""))
 . I $G(BLRRL("CLIENT"))="" S BLRRL("CLIENT")=$P($G(^BLRRL(BLRRL("RL"),0)),U,13)
 I $G(BLRCLCNT)>1 D
 . W !,"Please select the appropriate account number for this accession"
 . N BLRRLD
 . S BLRRLD=0 F  S BLRRLD=$O(BLRCLA(BLRRLD)) Q:'BLRRLD  D
 .. W !,BLRRLD_") "_$G(BLRCLA(BLRRLD))
 . K DIR
 . S DIR(0)="N^1:"_$G(BLRCLCNT),DIR("A")="Which account number for this accession "
 . D ^DIR
 . Q:$D(DIRUT)
 . S BLRRL("CLIENT")=$G(BLRCLA(+Y))
 . S BLRRLCLT=BLRRL("CLIENT")
 I $G(BLRRL("CLIENT"))="" D CLIENT(OR,AC)
 S BLRRLCLA=1
 N FDA,FIENS,FERR,FI
 S FI=$O(^BLRRLO("B",OR,0))
 S FIENS=FI_","
 S FDA(9009026.3,FIENS,.03)=$G(BLRRL("CLIENT"))
 D FILE^DIE("K","FDA","FERR(1)")
 I $D(FERR(1)) W !,"Error adding client account number "_$G(BLRRL("CLIENT"))_" to Order "_OR_" in the Reference Lab Order file" Q ""
 Q $G(FI)
 ;
CLCNT(DZ2) ;-- get the number of client account numbers to see if we need to prompt
 N BLRRLDA,BLRCLC
 S BLRCLC=0
 S BLRRLDA=0 F  S BLRRLDA=$O(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DZ2),"RLCA","B",BLRRLDA)) Q:BLRRLDA=""  D
 . S BLRCLC=BLRCLC+1
 . S BLRCLA(BLRCLC)=BLRRLDA
 Q +$G(BLRCLC)
 ;
BTP(OR,BT) ;-- file the bill type
 N FI,FIENS,FDA,FERR
 S FI=$O(^BLRRLO("B",OR,0))
 S FIENS=FI_","
 I $G(BT)-"" S BT="C"
 S FDA(9009026.3,FIENS,.05)=BT
 D FILE^DIE("K","FDA","FERR(1)")
 I $D(FERR(1)) W !,"Error adding bill type "_BT_" to Order "_OR_" in the Reference Lab Order file" Q ""
 Q $G(FI)
 ;
BILL(BTP,OR,AC,CDT) ;-- this is where we ask billing type
 N BT,ORI
 I '$G(CDT) S CDT=$P($G(^BLRRLO($O(^BLRRLO("B",OR,0)),0)),U,6)
 I '$G(CDT) S CDT=DT
 I BTP'="T" D  Q
 . S BT=$$BTP(OR,BTP)
 S DIR(0)="S^C:Client;T:Third Party;P:Patient"
 S DIR("A")="Which Party is Responsible for Billing: "
 S DIR("B")=$P($G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL")),U,15)
 D ^DIR
 S BLRRL("BILL TYPE")=Y(0)
 S BT=$$BTP(OR,$G(Y))
 I $D(DIRUT) S BLRRL("BILL TYPE")="Client"
 K DIR
 I $E(BLRRL("BILL TYPE"),1,1)="T" D
 . S ORI=$O(^BLRRLO("B",OR,0))
 . I $O(^BLRRLO(ORI,1,"B",0)) S BLRDXS=1
 . D INS(OR,AC,DFN,CDT,0)
 I $E(BLRRL("BILL TYPE"),1,1)="T",'$G(BLRDXS) W !,"You must select an ICD Diagnosis if Bill Type is Third Party" D DX(OR)
 I $E(BLRRL("BILL TYPE"),1,1)="T",'$G(BLRINSS) W !,"You must select an Insurer if Bill Type is Third Party" D BILL(BTP,OR,AC)
 S BLRINS=1
 Q
 ;
INS(OR,AC,PAT,CD,ED) ;-- lets get a list of selectable insurances for the patient and if set for auto select pick the first one in sequence
 ;we must also setup the BLRRL insurance array and diagnosis array for GIS
 N INSS,BT,BDA,BDAC,BLRRLDA,BLRNUM
 S BDAC=0
 S DFN=PAT
 D ^AGINS
 I '$D(AGINS(1)) D  Q
 . W !,"Patient has No Insurance on file, changing Bill Type to Patient"
 . S BT=$$BTP(OR,"P")
 I $P($G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL")),U,21) D  Q  ;get flag for insurance
 . W !,"Now applying Sequenced Insurer to Accession"
 . I '$G(CD) S CD=DT
 . D SEQINS(.AGINS,PAT,CD)
 . I '$D(BLRSEQ(1)) D  Q
 .. W !,"Patient Insurance has not been Sequenced, changing Bill Type to Patient"
 .. S BT=$$BTP(OR,"P")
 . S BDA=0 F  S BDA=$O(BLRSEQ(BDA)) Q:'BDA!(BDAC>3)  D
 .. S BDAC=BDAC+1
 .. S INSS=$TR($G(BLRSEQ(BDA)),"^","~")  ;have to switch to ~ for filing
 .. D UPINS(OR,AC,PAT,INSS)
 S BLRRLDA=0 F  S BLRRLDA=$O(AGINS(BLRRLDA)) Q:'BLRRLDA  D
 . S BLRNUM=BLRRLDA
 . W !,BLRRLDA_")"_$P(AGINS(BLRRLDA),U)
 . W ?30,"Policy #: "_$P(AGINS(BLRRLDA),U,9)
 . W ?50,"Elg/Exp Date: "_$S($P(AGINS(BLRRLDA),U,5)>0:$$FMTE^XLFDT($P(AGINS(BLRRLDA),U,5)),1:"")_"/"_$S($P(AGINS(BLRRLDA),U,6)>0:$$FMTE^XLFDT($P(AGINS(BLRRLDA),U,6)),1:"")
 S DIR(0)="N"_$S(ED:"O",1:"")_"^1:"_+$G(BLRNUM),DIR("A")="Select the insurer for this accession: "
 D ^DIR
 Q:$D(DIRUT)
 Q:Y<0
 S BLRINS=+Y
 S INSS=$TR($G(AGINS(BLRINS)),"^","~")  ;have to switch to ~ for filing
 D UPINS(OR,AC,PAT,INSS)
 Q
 ;
UPINS(O,A,P,S) ;-- update the entry in the BLR REFERENCE LAB ORDER/ACCESSION file
 N FI,FDA,FIENS,FERR
 S FI=$O(^BLRRLO("B",O,0))
 I '$G(FI) S FI=$O(^BLRRLO("ACC",A,0))
 S FIENS=FI_","
 S FDA(9009026.32,"+2,"_FIENS,.01)=S
 D UPDATE^DIE("","FDA","FIENS","FERR(1)")
 I $D(FERR(1)) W !,"Error adding insurance to Order "_OR_" in the Reference Lab Order file"
 S BLRINSS=1
 Q
 ;
SEQINS(BINS,PT,RLCDT) ;-- lets go through sequencing insurers
 Q:'$O(BINS(""))
 N BDA
 S BDA=0 F  S BDA=$O(BINS(BDA)) Q:'BDA  D
 . N BINI,SEQ,POLI
 . S BINI=$P(BINS(BDA),U,2)
 . S POLI=$P(BINS(BDA),U,9)
 . S SEQ=$$FNDSEQ(BINI,PT,POLI,RLCDT)
 . Q:'SEQ
 . S BLRSEQ(SEQ)=$G(BINS(BDA))
 Q
 ;
FNDSEQ(BN,PTI,POL,CDT) ;-- find the category prioritization
 N SQDA,EFF,SQPRI
 S EFF=$O(^AUPNICP("EFF",PTI,"M",""),-1)
 I '$G(EFF) Q ""
 S SQDA=0 F  S SQDA=$O(^AUPNICP("EFF",PTI,"M",EFF,SQDA)) Q:'SQDA!($G(SQPRI))  D
 . N SQDATA,SQPAT,SQPOL,SQINS
 . S SQDATA=$G(^AUPNICP(SQDA,0))
 . S SQPAT=$P(SQDATA,U,2)
 . S SQINS=$P(SQDATA,U,3)
 . S SQPOL=$P(SQDATA,U,10)
 . Q:SQPAT'=PTI
 . Q:SQINS'=BN
 . Q:SQPOL'=POL
 . S SQPRI=$P(SQDATA,U,5)
 Q $G(SQPRI)
 ;
EORD ;-- Edit the Order
 K DIC,DIE
 N DATA,ORD,ACC,PAT,CDT
 S DIC(0)="AEMQZ"
 S DIC("A")="Edit insurance/billing information for which order number: "
 S DIC="^BLRRLO("
 D ^DIC
 Q:Y<0
 S DIE=DIC
 S DA=+Y
 S DR=".03;.05;1"
 D ^DIE
 S DATA=$G(^BLRRLO(DA,0))
 S ORD=$P(DATA,U)
 S ACC=$P(DATA,U,2)
 S PAT=$P(DATA,U,4)
 S CDT=$P(DATA,U,6)
 D COINS(DA)
 D INS(ORD,ACC,PAT,CDT,1)
 D EORD
 Q
 ;
COINS(IN) ;-- clean out insurances before reselecting
 N BDA
 S DIK="^BLRRLO("_IN_",2,"
 S DA(1)=IN
 S BDA=0 F  S BDA=$O(^BLRRLO(IN,2,BDA)) Q:'BDA  D
 . S DA=BDA
 . D ^DIK
 Q
 ;
