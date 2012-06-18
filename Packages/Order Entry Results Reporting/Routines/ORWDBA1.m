ORWDBA1 ;; SLC OIFO/DKK/GSS - Order Dialogs Billing Awarness;[5/3/03 11:45pm] [2/26/04 11:40am]
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**190**;Dec 17, 1997
 ;
 ;Ref to ^DIC(9.4 - DBIA ___
 ;
SCLST(Y,DFN,ORLST) ; main entry for compiling appropriate CI's
 ;
 ;  RPC     =    ORWDBA1 SCLST
 ;  Y       =    Returned value
 ;  DFN     =    Patient IEN
 ;  ORLST   =    List of orders
 ;
 ;D CPLST^ORWDPS4(.Y,DFN,.ORLST) Q
 ;
 ; call for BA/CI
 D CPLSTBA(.Y,DFN,.ORLST)
 Q
 ;
CPLSTBA(TEST,PTIFN,ORIFNS) ; set-up SC/CIs for BA
 ;
 ;  TEST    =  Returned value
 ;  PTIFN   =  Patient IEN
 ;  ORIFNS  =  List of orders
 ;
 S ORI=""
 ;
 ;  GMRC    =  Consult/Request Tracking (#128) - Prosthetics
 ;  LR      =  Lab Services (#26) - Lab
 ;  PSO     =  Outpt Pharmacy (#112) - Outpt Pharmacy (orig. Co-Pay)
 ;  RA      =  Radiology/Nuclear Medicine (#31) - Radiology
 ;
 F I=1:1 S ORPKG=$P("GMRC;LR;PSO;RA",";",I) Q:ORPKG=""  D
 . S ORPKG(+$O(^DIC(9.4,"C",ORPKG,0)))=1  ; ^DIC(9.4) is package file
 ;
 ; get SC/CI for patient (Clinical Indicators: AO,IR,EC,MST,HNC)
 D SCPRE(.DR,DFN)
 ;
 ; set SC/CIs if order is for a package for which BA data is collected
 F  S ORI=$O(ORLST(ORI)) Q:'ORI  S ORD=+ORLST(ORI) D
 . Q:$D(TEST(ORD))!'$D(ORPKG($P(^OR(100,ORD,0),U,14)))
 . S TEST(ORD)=ORLST(ORI)_DR
 Q
 ;
SCPRE(DR,DFN) ; RPC 'ORWDBA1 SCPRE' - Dialog validation, to ask BA questions
 ;
 ;  DR    =  return value
 ;  DFN   =  input patient IEN
 ;
 Q:$G(DFN)=""
 N CPNODE,I,ORX,X
 S (CPNODE,DR,ORX)=""
 ; need a DBIA to use these calls ??? PIMS ???
 S CPNODE=$S($P($G(^DPT(DFN,.3)),U)="Y":1,1:0)  ;SC
 S $P(CPNODE,U,2)=$S('$O(^DGMS(29.11,"C",DFN,"")):0,1:1)  ;MST  29.11 
 S $P(CPNODE,U,3)=$S($P($G(^DPT(DFN,.321)),U,2)="Y":1,1:0)  ;AO
 S $P(CPNODE,U,4)=$S($P($G(^DPT(DFN,.321)),U,3)="Y":1,1:0)  ;IR
 S $P(CPNODE,U,5)=$S($P($G(^DPT(DFN,.322)),U,13)="Y":1,1:0)  ;EC
 S $P(CPNODE,U,6)=$S('$O(^DGNT(28.11,"B",DFN,"")):0,1:1)   ;HNC  28.11
 ;
 S X=$S($P(CPNODE,U)=1:"SC",1:""),DR=$S($L(X):DR_U_X,1:DR)
 S X=$S($P(CPNODE,U,3)=1:"AO",1:""),DR=$S($L(X):DR_U_X,1:DR)
 S X=$S($P(CPNODE,U,4)=1:"IR",1:""),DR=$S($L(X):DR_U_X,1:DR)
 S X=$S($P(CPNODE,U,5)=1:"EC",1:""),DR=$S($L(X):DR_U_X,1:DR)
 S X=$S($P(CPNODE,U,2)=1:"MST",1:""),DR=$S($L(X):DR_U_X,1:DR)
 S X=$S($P(CPNODE,U,6)=1:"HNC",1:""),DR=$S($L(X):DR_U_X,1:DR)
 ;
 ; get SC/CI for patient (CIs include AO,IR,EC,MST,HNC) where
 ;  AO      =  Agent Orange
 ;  IR      =  Ionizing Radiation
 ;  EC      =  Environmental Contaminants
 ;  MST     =  Military Sexual Trauma
 ;  HNC     =  Head and Neck Cancer
 F I="SC","AO","IR","EC","MST","HNC" D
 . I $D(ORX(I)) S DR=DR_U_I_$S($L(ORX(I)):";"_ORX(I),1:"")
 Q
 ;
ORPKGTYP(Y,ORLST) ; Build BA supported packages array
 F I=1:1 S ORPKG=$P("GMRC;LR;PSO;RA",";",I) Q:ORPKG=""  D
 . S ORPKG(+$O(^DIC(9.4,"C",ORPKG,0)))=1  ; ^DIC(9.4) is package file
 S GMRCPROS=+$O(^DIC(9.4,"C","GMRC",0))
 ; see if order is for a package which BA supports (GMRC,LR,PSO,RA)
 D ORPKG1(.Y,.ORLST)
 Q
 ;
ORPKG1(TEST,ORIFNS) ; Order for package BA supports?  TEST(ORI)=1 is YES
 S U="^",ORI=""
 F I=1:1:4 S OIV(I)=$P("PROSTHETICS REQUEST^EYEGLASS REQUEST^CONTACT LENSE REQUEST^HOME OXYGEN REQUEST",U,I)
 F  S ORI=$O(ORIFNS(ORI)) Q:'ORI  S ORD=+ORIFNS(ORI),TEST(ORI)=0 D
 . I $$BASTAT=0 Q  ;BA not used - abort switch set
 . I '$D(^OR(100,ORD,0)) Q  ;invalid order #
 . I $P(^OR(100,ORD,0),U,14)'?.N Q  ;invalid order # or entry
 . I '$D(ORPKG($P(^OR(100,ORD,0),U,14))) Q  ;pkg not supported
 . I $P(^OR(100,ORD,0),U,14)=GMRCPROS D  Q  ;check for Pros consult order
 .. S OIREC=$G(^ORD(101.43,$G(^OR(100,ORD,4.5,1,1)),0)),OIVN=""
 .. F  S OIVN=$O(OIV(OIVN)) Q:OIVN=""  I OIV(OIVN)=$E($P(OIREC,U),1,$L(OIV(OIVN))) S TEST(ORI)=1 Q
 . S TEST(ORI)=1  ;order is for a supported pkg (also note Pros ck above)
 Q
 ;
BASTATUS(Y) ;RPC to retrieve the status of the Billing Awareness software
 ;   Y  =  Returned Value (1=BA usable, 0=BA not-usable)
 S Y=1
 I $G(^ORWDBA1("GO_BA"))="" S Y=0
 Q
 ;
BASTAT() ; Internal version of BASTATUS
 I $G(^ORWDBA1("GO_BA"))="" Q 0
 Q 1
 ;
RCVORCI(Y,DIAG) ;Receive order related Clinical Indicators & Diagnoses from GUI
 ; Store data in ^OR(100,ODN,5)
 ;
 N DXIEN,ODN,ORIEN,SCI,OCT
 ;
 S ODN=""
 ;
 F  S ODN=$O(DIAG(ODN)) Q:ODN=""  D
 . S ORIEN=$P(DIAG(ODN),";",1)
 . ;S ^ZZGARYS("DIAG",ORIEN,ODN)=DIAG(ODN)  ;???DELETE POST TEST
 . S SCI=$$CIGUIGBL($E($P(DIAG(ODN),";",2),3,8))
 . ;S ^ZZGARYS("SCI",ORIEN,ODN)=SCI  ;???DELETE POST TEST
 . S ^OR(100,ORIEN,5)=SCI  ;eventually will not be stored here
 . ;
 . F OCT=3:2 Q:$P(DIAG(ODN),U,OCT)=""  D
 .. S DXIEN=$O(^ICD9("BA",$P(DIAG(ODN),U,OCT)_" ",0))  ;Dx IEN
 .. S ^OR(100,ORIEN,5.1,(OCT\2),0)=DXIEN_"^^^"_SCI
 ;S ^ZZGARYS("RCVORCI",ORIEN)=0  ;???DELETE THIS POST TEST
 S Y=1
 Q
 ;
CIGUIGBL(CIS) ;Convert Clinical Indicators from GUI to Global order & format
 ;
 ; Expect CIS to be in CNUUNC where C=checked, N=not checked, U=unchecked
 ; Output SCI in 1^^^0^0^1 format (reordered for global storage)
 ;
 N CC,CI,CIGBL,CIGUI,CIHL7,J,NCI,SCI
 S SCI="",NCI=6  ;NCI=number of Clinical Indicators
 I $L(CIS)'=NCI Q -1  ;invalid number of indicators
 ; CIGBL is order of CIs in ^OR(100,ORIEN,5) & ^OR(100,ORIEN,5.1,#)
 ; CIGUI is order of CIs from GUI
 S CIGBL="SC^MST^AO^IR^EC^HNC",CIGUI="SC^AO^IR^EC^MST^HNC"
 F J=1:1:NCI S CI=$E(CIS,J),CI($P(CIGUI,U,J))=$S(CI="C":1,CI="U":0,1:"")
 F J=1:1:NCI S SCI=SCI_U_CI($P(CIGBL,U,J))
 Q $P(SCI,U,2,99)
 ;
HL7 ; Define common variables and access either Inpatient (ORWDBA2) or
 ;  Outpatient (ORWDBA3) routine to get PTF and PCE related pointers.
 ;
 ; Input:
 ;  IFN       = Order IEN (file# 100)
 ;
 ; Output:
 ;  ORDGX                        = Pointer to Diagnosis (#80)
 ;  ORAR(ORDFN,"DOS")            = Date Of Service (FM format)
 ;  ORAR(ORDFN,"PAT")            = Patient's IEN (file# 2)
 ;  ORAR(ORDFN,"POS")            = Place of Service
 ;  ORAR(ORDFN,"POV IEN")        = Pointer to V POV (file# 9000010.07)
 ;  ORAR(ORDFN,"USR")            = Ordering Provider
 ;  ORAR(ORDFN,"DGX",ORDGX)
 ;     $P  Description
 ;      1  Diagnosis (ICD9 #)
 ;      2  Diagnosis description
 ;      3  Service Connected (Y/N)
 ;      4  Agent Orange (Y/N)
 ;      5  Ionizing Radiation (Y/N)
 ;      6  Environmental Contaminants (Y/N)
 ;      7  Military Sexual Trauma (Y/N)
 ;      8  Head & Neck Cancer (Y/N)
 ;
 I $$BASTAT=0 Q  ;BA not used
 ;
 N DXIEN,ICD9,OCT,OR0,ORAR,ORDFN,OREC,PTCLAS
 S ORDFN=IFN,OR0=^OR(100,$G(IFN),0)
 S ORAR(ORDFN,"DOS")=$$NOW^XLFDT              ;Order effective D/T
 S ORAR(ORDFN,"PAT")=$P($P(OR0,U,2),";")      ;Patient's IEN
 S ORAR(ORDFN,"POS")=$P($P(OR0,U,10),";")     ;Patient's location (POS
 S ORAR(ORDFN,"USR")=$P($G(OR0),U,4)          ;Ordering provider IEN
 S PTCLAS=$P($G(OR0),U,12)                    ;Patient class
 ;
 S (ICD9,OCT)=""
 ; Go through each diagnosis for the order
 F  S OCT=$O(^OR(100,ORDFN,5.1,OCT)) Q:OCT=""  D
 . S OREC=$G(^OR(100,ORDFN,5.1,OCT,0)) Q:OREC=""
 . S DXIEN=$P(OREC,U) S:DXIEN'="" ICD9=$P($G(^ICD9(DXIEN,0)),U)
 . S ORAR(ORDFN,"DGX",DXIEN)=ICD9_U_$P(^ICD9(DXIEN,0),U,3)_U_$P(OREC,U,3,8)
 . ;
 . ;D @$S("OP^ORWDBA3":PTCLAS="O",1:"IP^ORWDBA2")
 . ;
 . S $P(^OR(100,ORDFN,5.1,OCT,0),U,2)=$G(VPOV)
 . S $P(^OR(100,ORDFN,5.1,OCT,0),U,3)=$G(IEN461)
 ;
 S $P(^OR(100,ORDFN,0),U,3)=$G(VISIT)
 S ^OR(100,ORDFN,5.2,0)=$G(PTCLAS)_U_$G(IEN45)
 ;S ^ZZGARYS("HL7",ORDFN)=0  ;???DELETE POST TEST
 ;
 ;store VISIT and VPOV etc data in ^OR(100  (46.1 & 9000010.07)
 ;set VISIT variable for inclusion in PV1 segment
 ;
 Q
 ;
ORINFO Q  ;defined to avoid error - does nothing - called from ORWDBA3
 ;
DG1(ORDFN,COUNTER,CTVALUE) ; Create DG1 segment(s) & make call for ZCL seg.
 ;
 ;  Input
 ;    ORDFN      Internal Order ID#
 ;    COUNTER    Variable used as counter from calling routine
 ;    CTVALUE    Value of COUNTER when DG1 called
 ;  Output
 ;
 I $$BASTAT=0 Q  ;BA not used
 ;
 N DG13,DXIEN,DXV,FROMFILE,ICD9,OCT,OREC
 ; zero order count variable
 S OCT=0
 ; Get the diagnoses for an order
 F  S OCT=$O(^OR(100,ORDFN,5.1,OCT)) Q:OCT=""  D
 . S OREC=^OR(100,ORDFN,5.1,OCT,0)
 . ; DXIEN=pointer to diagnosis (ICD9) file #80
 . S DXIEN=$P(OREC,U)
 . ; the DXIEN pointer should point to a valid diagnosis (after all is
 . ;   was previously entered .. but just in case things have changed...
 . ; 
 . I DXIEN'="" S DXV=$P($G(^ICD9(DXIEN,0)),U,3),ICD9=$P($G(^ICD9(DXIEN,0)),U)
 . E  S DXV="",ICD9=""
 . S FROMFILE=80
 . S DG13=DXIEN_U_DXV_U_FROMFILE_U_ICD9_U_DXV_U_"ICD9"
 . S CTVALUE=CTVALUE+1
 . S ORMSG(CTVALUE)="DG1"_"|"_OCT_"||"_DG13_"|||||||||||||"
 . D ZCL
 . ;S ^ZZGARYS("DG1",ORDFN,OCT)=ORMSG(CTVALUE)  ;???DELETE POST TEST
 S @COUNTER=CTVALUE
 Q
 ;
ZCL ;create all the ZCL segments (currently 6) for order number OCT
 N SCI,SCIN,TABLE,VALUE
 ; SCI is CI & SC data in SC^MST^AO^IR^EC^HNC order (^OR order)
 S SCI=$P(OREC,U,4,9)
 ; conversion order from ^OR stored data and Table SD008 for HL7 msg
 ; convert so that the ZCL segments will be in Table SD008 order (1-6)
 S TABLE="341526"  ;AO^IR^SC^EC^MST^HNC table SD008 order
 F SCIN=1:1:6 D
 . ; ORMSG counter incremented
 . S CTVALUE=CTVALUE+1
 . ; SC/EI VALUE=0 for no or 1 for yes (only if not req. is it null)
 . S VALUE=$P(SCI,U,$E(TABLE,SCIN))
 . ; for Table SD008: OCT=Set ID, SCIN=O/P Classif. Type, VALUE=Value
 . S ORMSG(CTVALUE)="ZCL|"_OCT_"|"_SCIN_"|"_VALUE
 . ;S ^ZZGARYS("ZCL",ORDFN,OCT,CTVALUE)=ORMSG(CTVALUE)  ;???DELETE
 Q
 ;
PRVKEY(X) ; check for provider key - DO NOT EDIT OR DELETE - DBIA
 Q:'+$G(X) 0
 Q:$D(^XUSEC("ORES",X)) 1
 Q 0
