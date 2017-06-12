BLRRLEVN ;cmi/anch/maw - BLR Reference Lab Non LEDI Manifest Build ; 03-Dec-2014 11:21 ; MAW
 ;;5.2;IHS LABORATORY;**1034,1036,1037**;NOV 01, 1997;Build 4
 ;
 Q
 ;
SHIPMAN(ORD,RE) ;-- get data needed for HL7 message and manifest
 N LA7RT,AA,AD,AN,TEST,LDFN,IDT,SPEC,SAMP,ORDN,OA,ON,BLROI,ADA,ACC,AREA,URG,ODT,CDT,ORDP,AC
 N LOC,OPI,FLG,PRT,RL
 S PRT=0
 S BLROI=$O(^BLRRLO("B",ORD,0))
 S ADA=0 F  S ADA=$O(^BLRRLO(BLROI,3,ADA)) Q:'ADA  D
 . S FLG=0
 . S AC=$P($G(^BLRRLO(BLROI,3,ADA,0)),U)  ;p1036
 . S FLG=$P($G(^BLRRLO(BLROI,3,ADA,0)),U,2)  ;p1036
 . I '$G(RE) Q:$G(FLG)  ;p1036 quit if already accessioned
 . I '$G(RE) D SETFLG(BLROI,ADA)  ;p1036 set the flag as accessioned
 . S LA7RT=$Q(^LRO(68,"C",AC))
 . S AA=$QS(LA7RT,4)
 . S AD=$QS(LA7RT,5)
 . S AN=$QS(LA7RT,6)
 . S ACC=$G(^LRO(68,AA,1,AD,1,AN,.2))
 . S ORDN=$Q(^LRO(69,"C",ORD))
 . S OA=$QS(ORDN,4)
 . S ON=$QS(ORDN,5)
 . S ODT=$P($G(^LRO(69,OA,1,ON,0)),U,5)
 . ;S CDT=+$G(^LRO(69,OA,1,ON,1))
 . S CDT=+$G(^LRO(68,AA,1,AD,1,AN,3))  ;draw time p1036
 . S ORDP=$$ORDP(OA,ON)
 . S TEST=$$TEST(AA,AD,AN)
 . S URG=$P(TEST,U,2)
 . S TEST=$P(TEST,U)
 . S LDFN=$P($G(^LRO(68,AA,1,AD,1,AN,0)),U)
 . S IDT=$P($G(^LRO(68,AA,1,AD,1,AN,3)),U,5)
 . S SPEC=$P($G(^LR(LDFN,"CH",IDT,0)),U,5)
 . S SAMP=$$SAMP(AA,AD,AN,SPEC)
 . ;S SAMP=$P($G(^LRO(69,OA,1,ON,0)),U,3)
 . S LOC=$P($G(^LRO(69,OA,1,ON,0)),U,9)
 . S OPI=+$P($G(^LRO(69,OA,1,ON,0)),U,6)
 . S AREA=$P($G(^LAB(60,TEST,8,$S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),0)),U,2)
 . S RL=$P($G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL")),U)
 . Q:'$$NOMAP^BLRRLEVT(RL,TEST,LOC)  ;p1036 dont ship or print a non mapped test
 . D BLRVARS(BLROI,ORD,AC,ACC,CDT,TEST,SAMP,SPEC,ORDP,AREA,URG,ODT,LOC,OPI)
 . S X="BLR REFLAB ACCESSION A TEST",DIC=101 D EN^XQOR
 . S PRT=1
 . Q
 I $G(PRT) D
 . W !,"Printing Shipping Manifests for Reference Lab..."
 . W !,"Printing manifest for order # "_ORD
 . D PRT^BLRSHPM(RE)
 D KVAR
 Q
 ;
BLRVARS(OI,OR,UID,ACC,CD,TS,SM,SP,OP,AR,UG,OD,LC,PI)   ; Setup the variables for manifest and message
 ;set all BLR VARS call TMPSET before manifest
 K BLRRL,BLRRLC
 S BLRRL("PAT")=$P($G(^BLRRLO(OI,0)),U,4)  ;patient
 S BLRRL("ACC")=ACC  ;accession number
 S BLRRL("UID")=UID  ;unique id
 I $G(BLROPT)="ADDCOL" S LRUID=UID  ;LRUID doens't get reset correctly on collection list
 S BLRRL("CDT")=CD   ;collection date
 S BLRRL("LRTS")=TS  ;test
 S BLRRL("ORDP")=OP  ;ordering provider
 S BLRRL("SAMP")=SM  ;collection sample
 I SP S BLRRL("SRC")=$P($G(^LAB(61,SP,0)),U)  ;specimen
 S BLRRL("RL")=+$G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL"))  ;ref lab site
 S BLRRL("RLE")=$P($G(^BLRRL(BLRRL("RL"),0)),U)  ;external name
 S BLRRL("TNAME")=$P($G(^LAB(60,TS,0)),U)  ;get test name
 S BLRRL("ABBR")=$P($G(^LRO(68,AR,0)),U,11)  ;get area abbr
 S BLRRL("TST")=TS  ;get test ien
 S BLRRL("TCODEE")=$$CODE^BLRRLEVT(BLRRL("RL"),TEST)  ;lookup test code
 S BLRRL("TCODE")=$P(BLRRL("TCODEE"),U)  ;test code
 S BLRRL("SHIPCOND")=$P(BLRRL("TCODEE"),U,2)  ;shipping condition
 S BLRRL("TCNM")=BLRRL("TCODE")_U_BLRRL("TNAME")  ;test arry
 I $G(BLRRL("RLE"))="LABCORP" D
 . S BLRRL("TCNM")=BLRRL("TCNM")_"^L"
 S BLRRL("URGHL")=$S($G(UG):$P($G(^LAB(62.05,UG,0)),U,4),1:"")  ;urgency
 S BLRRL("URG")=UG  ;urgency
 S BLRRL("ODT")=OD  ;order date
 S BLRRL("ORD")=OR  ;order
 S BLRRL("LOC")=$$GET1^DIQ(44,LC,.01)  ;ordering location
 S BLRRL("CLIENT")=$P($G(^BLRRLO(OI,0)),U,3)
 S BLRRL("BILL TYPE")=$$GET1^DIQ(9009026.3,OI,.05)
 S BLRRL("ORDPNM")=$$GET1^DIQ(200,PI,.01)
 S BLRRL("ORDPNPI")=$$GET1^DIQ(200,PI,41.99)
 S BLRRL("ORDPUPIN")=$$GET1^DIQ(200,PI,9999999.08)
 S (BLRTS,BLRTSTDA)=TS
 D ADDDX^BLRRLHL2(OR)
 I $E($G(BLRRL("BILL TYPE")),1,1)="T" D
  . S PAT=BLRRL("PAT")
 . S LRORD=OR
 . S LRUID=UID
 . D INS^BLRRLHL(BLRRL("PAT"),1)
 . K PAT  ;,LRORD,LRUID
 I $E($G(BLRRL("BILL TYPE")),1,1)="P" D  ;p1037
 . D PATBILL^BLRRLHL(TS)
 N BDA,BLRCM,RSC,QS,RS,AOD
 S BDA=0 F  S BDA=$O(BLRRL(BDA)) Q:BDA=""  D
 . S BLRRL(TS,BDA)=$G(BLRRL(BDA))
 S BLRCM=0 F  S BLRCM=$O(^BLRRLO(OI,4,BLRCM)) Q:'BLRCM  D
 . Q:$P(^BLRRLO(OI,4,BLRCM,0),U)'=TS
 . S AOD=$G(^BLRRLO(OI,4,BLRCM,0))
 . S RSC=$P(AOD,U,5)
 . S QS=$P(AOD,U,3)
 . S RS=$P(AOD,U,4)
 . S BLRRL(TS,"COMMENT",BLRCM)=RSC_U_QS_U_RS
 . S BLRRL("COMMENT",BLRCM)=RSC_U_QS_U_RS
 D TMPSET^BLRRLEVT(.BLRRL)
 Q
 ;
SAMP(A,D,N,SPC) ;-- get collection sample
 N SAM,SDA
 S SAM=""
 S SDA=0 F  S SDA=$O(^LRO(68,A,1,D,1,N,5,SDA)) Q:'SDA!($G(SAM))  D
 . ;I $P($G(^LRO(68,A,1,D,1,N,5,SDA,0)),U)=SPC D  Q
 . S SAM=$P($G(^LRO(68,A,1,D,1,N,5,SDA,0)),U,2)
 Q SAM
 ;
TEST(A,D,N) ;-- get the test based on acc passed in
 N TDA,TST
 S TST=""
 S TDA=0  F  S TDA=$O(^LRO(68,A,1,D,1,N,4,TDA)) Q:'TDA  D
 . S TST=+$G(^LRO(68,A,1,D,1,N,4,TDA,0))
 . S URG=$P($G(^LRO(68,A,1,D,1,N,4,TDA,0)),U,2)
 Q TST_U_URG
 ;
ORDP(OA,ON) ;-- get the ordering provider based on order number
 N PRV,PRVI,PRVE,NPI,UPIN,PTYP
 S PTYP=$S($P($G(^BLRSITE($S($G(BLRALTDZ):BLRALTDZ,1:DUZ(2)),"RL")),U,19)="N":"N",1:"U")
 S PRVI=+$P($G(^LRO(69,OA,1,ON,0)),U,6)
 S PRVE=$$VAL^XBDIQ1(200,PRVI,.01)
 S UPIN=$$VAL^XBDIQ1(200,PRVI,9999999.08)
 S NPI=$$VAL^XBDIQ1(200,PRVI,41.99)  ;cmi/maw 2/26/2008 NPI
 S PRVE=$P(PRVE,",")_"^"_$P($P(PRVE,",",2)," ")
 S PRV=$S(PTYP="N":NPI,1:UPIN)_"^"_PRVE
 S $P(PRV,U,8)=PTYP
 Q PRV
 ;
KVAR  ;-- kill off remaining variables not needed
 K AGINS,AGINSN1,AGINSNN,BLRINSS,BLRRDA,BLRTS,BLRTSTDA,DFN,INSCNT,INSGEND,DOB,SEX
 K BLRRL,INA
 K ^TMP("BLRRL",$J)
 Q
 ;
PRTLC(ORD,ACC,DF,LOC,ODT,PRV,TST) ;-- printout the lab collect information
 N NM,CHT,RLOC,ORDT,PRVE,TSTE,ICD,ICDE,OI,RDX
 S OI=$O(^BLRRLO("ACC",ACC,0))
 S NM=$$GET1^DIQ(2,DF,.01)
 S CHT=$$HRN^AUPNPAT(DF,DUZ(2))
 S RLOC=LOC
 S ORDT=$$FMTE^XLFDT(ODT)
 S PRVE=$$GET1^DIQ(200,PRV,.01)
 S TSTE=$$GET1^DIQ(60,TST,.01)
 S ICD=$O(^BLRRLO(OI,1,"B",0))
 S RDX=""
 I $D(^ICDS(0)),ICD]"" S RDX=$$ICDDX^ICDEX(ICD,DT)
 I '$D(^ICDS(0)),ICD]"" S RDX=$$ICDDX^ICDCODE(ICD,DT)
 S ICDE=$P(RDX,U,2)_"-"_$P(RDX,U,4)
 U IO
 W !!,"Information for this accession:"
 W !,NM,?35,CHT,?50,"Requesting Loc: "_RLOC
 W !,"Date Ordered: "_ORDT,?50,"UID: "_ACC
 W !,"Lab Order # "_ORD,?40,"Provider: "_PRVE
 W !,?3,TSTE
 W !,?10,"DX: "_ICDE
 W !!
 Q
 ;
IMP(D) ;PEP - which coding system should be used:
 ;RETURN IEN of entry in ^ICDS
 ;1 = ICD9
 ;30 = ICD10
 ;will need to add subroutines for ICD11 when we have that.
 I $G(D)="" S D=DT
 NEW X,Y,Z
 I '$O(^ICDS("F",80,0)) Q 1
 S Y=""
 S X=0 F  S X=$O(^ICDS("F",80,X)) Q:X'=+X  D
 .I $P(^ICDS(X,0),U,4)="" Q   ;NO IMPLEMENTATION DATE?? SKIP IT
 .S Z($P(^ICDS(X,0),U,4))=X
 ;now go through and get the last one before it imp date is greater than the visit date
 S X=0 F  S X=$O(Z(X)) Q:X=""  D
 .I D<X Q
 .I D=X S Y=Z(X) Q
 .I D>X S Y=Z(X) Q
 I Y="" S Y=$O(Z(0)) Q Z(Y)
 Q Y
 ;
SETFLG(OI,AD) ;-- set the flag as accessioned
 N FDA,FIENS,FERR
 S FIENS=AD_","_OI_","
 S FDA(9009026.33,FIENS,.02)=1
 D FILE^DIE("K","FDA","FERR(1)")
 I $D(FERR(1)),$G(LRQUIET) D
 . W !,"Error setting accession flag in the BLR REFERENCE LAB ORDER/ACCESSION file"
 Q
 ;
RESHIP ;-- reship a non ledi order
 N RORD
 S RORD=$$WORD
 Q:'$G(RORD)
 I '$O(^BLRRLO("B",RORD,0)) W !,"Order Number does not exist" Q
 W !,"Reshipping order: "_RORD
 D SHIPMAN(RORD,1)
 Q
 ;
WORD() ;-- reship which order
 S DIR(0)="N",DIR("A")="Enter Order Number"
 D ^DIR
 Q:$D(DIRUT) 0
 I Y<0 Q 0
 Q +$G(Y)
 ;
