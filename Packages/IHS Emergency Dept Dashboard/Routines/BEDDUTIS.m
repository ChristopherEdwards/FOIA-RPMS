BEDDUTIS ;VNGT/HS/BEE-BEDD Utility Routine 2 - Cache Calls ; 08 Nov 2011  12:00 PM
 ;;2.0;IHS EMERGENCY DEPT DASHBOARD;**1**;Apr 02, 2014
 ;
 ;This routine is included in BEDD XML 2.0 Patch 1 install and is not in the KIDS
 ; 
 Q
 ;
DC(DFN,OBJID,VIEN,DUZ,SITE,BEDD) ;Disch from BEDD/AMER
 ;
 ;Input:
 ; DFN
 ; OBJID - Pointer to BEDD.EDVISIT
 ; VIEN - Visit IEN
 ; DUZ - User's DUZ
 ; SITE - Site Value
 ;
 NEW EDREF,AMERVSIT
 ;
 S EDREF=##CLASS(BEDD.EDVISIT).%OpenId(OBJID)
 S AMERVSIT=EDREF.AMERVSIT
 ;
 ;Pull Room Value
 S ROOM=EDREF.Room
 ;
 ;Check for Reversed Discharge (will have AMERVSIT)
 I AMERVSIT'="" D
 . NEW %,%H,DCDT,DISP,ESTAT
 . ;
 . ;Discharge Date
 . S %H=EDREF.DCDtH_","_EDREF.DCTmH
 . D YX^%DTC S DCDT=X_%
 . ;
 . ;Disposition
 . S DISP=$G(BEDD("Disp")) ;EDREF.DCDispH
 . ;
 . ;Save new Discharge Date/Time and Disp
 . D DCUPDATE(AMERVSIT,DCDT,DISP)
 . ;
 . I EDREF.DCDocHSDt>0 D
 .. S EDREF.DCDocHEDt=$P($H,",",1)
 .. S EDREF.DCDocHETm=$P($H,",",2)
 . ;
 . ;Update Class Entry
 . S EDREF.DCFlag=1
 . S ESTAT=EDREF.%Save()
 ;
 I EDREF.DCDocHSDt>0 D
 . NEW ESTAT
 . S EDREF.DCDocHEDt=$P($H,",",1)
 . S EDREF.DCDocHETm=$P($H,",",2)
 . S ESTAT=EDREF.%Save()
 S EDREF=""
 ;
 Q:AMERVSIT'=""
 ;
 ;Process Regular Disch
 S U="^"
 D DUZ^XUP(DUZ)
 S:$G(DT)="" DT=$$DT^XLFDT
 ;
 ;Set up AMER ^TMP("AMER" Entries needed for save
 ;
 NEW AMERDFN,AMERPCC,AMERLINE,FMDT,%,%H,AMERDR,AMERDA,STAT
 NEW ERROR,PRCPV,PRCNT,PRMNRS,AMERDUR,AR,X
 ;
 S AMERDFN=DFN,AMERPCC=VIEN,AMERLINE=""
 ;
 ;Reset AMER globals
 K ^TMP("AMER",$J,1),^TMP("AMER",$J,2),^TMP("AMER",$J,3)
 ;
 ;Convert Admission file back to ^TMP entries
 D UTL^AMER0(AMERDFN)
 S ^TMP("AMER",$J,2,1)=AMERDFN
 ;
 S EDREF=##CLASS(BEDD.EDVISIT).%OpenId(OBJID)
 I (EDREF.DCDocHSDt>0) D
 . S EDREF.DCDocHEDt=$P($H,",",1)
 . S EDREF.DCDocHETm=$P($H,",",2)
 ;
 ;Pull Room Value
 S ROOM=EDREF.Room
 ;
 ;Set Injury Information
 S ^TMP("AMER",$J,2,2)=0
 I EDREF.Injury="YES" D
 . S ^TMP("AMER",$J,2,2)=1 ;QD2^AMER2
 . S ^TMP("AMER",$J,2,31)=EDREF.PtInjury.InjLocat ;QD31^AMER2B
 . S ^TMP("AMER",$J,2,32)=EDREF.PtInjury.InjDtTm
 . S ^TMP("AMER",$J,2,33)=EDREF.PtInjury.InjCauseIEN ;QD33^AMER2B
 . S ^TMP("AMER",$J,2,34)=EDREF.PtInjury.InjSet ;QD34^AMER2B
 . S ^TMP("AMER",$J,2,35)=EDREF.PtInjury.SafetyEquip ;QD35^AMER2B
 . I EDREF.PtInjury.WrkRel="YES" S ^TMP("AMER",$J,2,5)=1 ;QD5^AMER2
 . E  S ^TMP("AMER",$J,2,5)=0 ;QD5^AMER2
 . S ^TMP("AMER",$J,2,41)=EDREF.PtInjury.MVCLoc ;QD41^AMER2
 . S ^TMP("AMER",$J,2,42)=EDREF.PtInjury.AtFaultInsurance ;QD42^AMER
 . S ^TMP("AMER",$J,2,43)=EDREF.PtInjury.AtFaultInsPolicy ;QD43^AMER
 ;
 ;ED Consults
 S ^TMP("AMER",$J,2,6)=0 I $$EDCNT(OBJID)>0 S ^TMP("AMER",$J,2,6)=1
 D CONSQRY ;QD6^AMER2
 ;
 ;Procedures
 S PRCNT=$$PRCNT(OBJID)
 I (PRCNT>0) D PROCQ(.PRCPV) ;QD10^AMER3
 I (PRCNT<1) S %=$$OPT^AMER0("NONE","ER PROCEDURES"),^TMP("AMER",$J,2,10,%)=%_U_"NONE"
 ;
 ;Diagnosis
 ;
 ;BEDD v2.0;Do not save diagnosis - now gets saved from PCC
 S ^TMP("AMER",$J,2,12)=$G(BEDD("FinAct")) ;QD14^AMER3 disposition
 S ^TMP("AMER",$J,2,14)=$G(BEDD("Disp")) ;QD14^AMER3 disposition
 S ^TMP("AMER",$J,2,15)=$G(BEDD("WhrTrn")) ;QD15^AMER3 Where Transferred
 S ^TMP("AMER",$J,2,16)=$G(BEDD("DCInst")) ;QD16^AMER3
 S ^TMP("AMER",$J,2,17)=$G(BEDD("DCPrv")) ;QD17^AMER3
 S ^TMP("AMER",$J,2,18)=$G(BEDD("DCNrs")) ;QD18^AMER3
 S %H=EDREF.DCDtH_","_EDREF.DCTmH D YX^%DTC S FMDT=X_%
 S ^TMP("AMER",$J,2,19)=$G(BEDD("DCDtTm")) ;; QD19^AMER3
 S ^TMP("AMER",$J,2,21)=$G(BEDD("AdmPrv")) ;; QD19^AMER3
 S ^TMP("AMER",$J,2,20)=$$CLIN^BEDDUTIU(EDREF.TrgCln) ;;QD20^AMER3
 ;
 S AMERDR(1)=$$DR1^AMERSAV("QA")
 S AMERDR(1)=AMERDR(1)_";.03////"_$P($G(^AMERADM(AMERDFN,0)),U,3)
 S AMERDR(2)=$$DR1^AMERSAV("QD")_";.19////"_$G(DUZ)_";10.1////1"
 ;
 ;Save Injury Information
 D INJ^AMERSAV1
 ;
 ;Save ED Consult Information
 D CONSULT^AMERSAV
 ;
 ;Save - Other info
 D STUFF^AMERSAV(AMERDFN)
 D DRM^AMERSAV
 ;
 ;Remove AMERADM entry
 D KILLADM^AMERSAV
 ;
 ;Put entry in ER VISIT 9009080
 S AMERDA=$$RUN^AMERSAV1
 ;
 ;Log Durations
 ;
 S AR=$$GET1^DIQ(9009080,AMERDA_",",.01,"I")
 ;
 ;Triage Wait
 S X=$$GET1^DIQ(9009080,AMERDA_",",12.2,"I")
 S %=$$DT^AMERSAV1(X,AR,"M") S:%>0 AMERDUR(9009080,AMERDA_",",12.4)=%
 ;
 ;Provider Wait
 S X=$$GET1^DIQ(9009080,AMERDA_",",12.1,"I")
 S %=$$DT^AMERSAV1(X,AR,"M") S:%>0 AMERDUR(9009080,AMERDA_",",12.3)=%
 ;
 ;Duration
 S X=$$GET1^DIQ(9009080,AMERDA_",",6.2,"I")
 S %=$$DT^AMERSAV1(X,AR,"M") S:%>0 AMERDUR(9009080,AMERDA_",",12.5)=%
 I $D(AMERDUR) D FILE^DIE("","AMERDUR","ERROR")
 ;
 ;Log V PROVIDER entries
 S PRMNRS=EDREF.PrmNurse
 D PRV^BEDDUTIU(VIEN,AMERDA,PRMNRS)
 ;
 ;Log V POV entries
 D POV^BEDDUTIU(VIEN,AMERDA)
 ;
 ;Log Consult Providers in V PROVIDER
 D PCCPRV
 ;
 ;Log Procedure Providers in V PROVIDER
 D PRPOV^BEDDUTIU(VIEN,AMERDA,.PRCPV)
 ;
 ;Log Compiled Fields
 D COMP
 ;
 I EDREF.DCDocHSDt>0 D
 . S EDREF.DCDocHEDt=$P($H,",",1),EDREF.DCDocHETm=$P($H,",",2)
 S EDREF.AMERVSIT=AMERDA,EDREF.DCFlag=1
 S STAT=EDREF.%Save()
 S EDREF=""
 ;
 I STAT>1 S RSTAT="Y"
 I STAT=0 S RSTAT="N"
 ;
 ;Save V EMERGENCY VISIT RECORD entry
 D VERENTRY($G(AMERDA),$G(VIEN))
 ;
 ;Clear Room
 D RMRMV^BEDDUTW(OBJID)
 Q STAT
 ;
DCUPDATE(AMERVSIT,DCDT,DISP) ;Discharge Reversed DC
 ;
 NEW AMUPD,ERROR
 ;
 Q:AMERVSIT=""
 ;
 L +^AMERVSIT(AMERVSIT):30 I '$T Q
 ;
 S AMUPD(9009080,AMERVSIT_",",6.1)=DISP
 S AMUPD(9009080,AMERVSIT_",",6.2)=DCDT
 ;
 I $D(AMUPD) D FILE^DIE("","AMUPD","ERROR")
 ;
 L -^AMERVSIT(AMERVSIT)
 Q
 ;
CONSQRY ;Perform Query to Gather ED Consults and store in ^TMP("AMER
 ;
 NEW RS,STATUS
 ;
 S RS=##CLASS(%ResultSet).%New()
 S RS.ClassName="BEDD.EDConsults"
 S RS.QueryName="consPrint"
 S STATUS=RS.Execute(OBJID)
 ;
 ;If none quit
 I STATUS'=1 G XCONS
 ;
 NEW AMERNO
 ;
 S AMERNO=1
 While RS.Next() {
 NEW SERV
 S SERV=RS.Data("ConsultSrv")
 If SERV'="" D
 . NEW %,%H,DTM,CPRV
 . S ^TMP("AMER",$J,2,7,AMERNO,.01)=RS.Data("ConsultSrv")
 . S %H=RS.Data("DateSeen")_","_RS.Data("TimeSeen") S:%H="," %H=""
 . D YX^%DTC S DTM=X_% S:DTM="0" DTM=""
 . S ^TMP("AMER",$J,2,7,AMERNO,.02)=DTM
 . S CPRV=RS.Data("ConsultN")
 . S ^TMP("AMER",$J,2,7,AMERNO,.03)=CPRV
 . S ^TMP("AMER",$J,2,7,AMERNO)=SERV_U_$$GET1^DIQ(9009082.9,SERV_",",".01","I")_U_DTM_U_CPRV_U_$$GET1^DIQ(200,CPRV_",",".01","I")
 . S AMERNO=AMERNO+1
 }
 ;
XCONS S RS=""
 Q
 ;
PROCQ(PRCPV) ;Perform Query to Gather Procedures and store in ^TMP("AMER
 ;
 NEW RS,STATUS,AMERPROC,PRV
 ;
 S RS=##CLASS(%ResultSet).%New()
 S RS.ClassName="BEDD.EDProc"
 S RS.QueryName="procPrint"
 S STATUS=RS.Execute(OBJID)
 ;
 ;Quit if no procedures
 I STATUS'=1 G XPROCQ
 ;
 While RS.Next() {
 ;
 NEW BDT,BTM,EDT,ETM
 S AMERPROC=RS.Data("EDProc")
 S PRV=RS.Data("ProcStf")
 S BDT=RS.Data("ProcDt")
 S BTM=RS.Data("ProcSTm")
 S EDT=RS.Data("ProcEDt")
 S ETM=RS.Data("ProcETm")
 I AMERPROC'="" S ^TMP("AMER",$J,2,10,AMERPROC)=AMERPROC_"^"_RS.Data("EDProcN")
 ;
 ;Track Procedure Provider Info
 I PRV]"" S PRCPV(PRV)=BDT_U_BTM_U_EDT_U_ETM
 }
XPROCQ S RS=""
 Q
 ;
DIAGQ ;EP - Perform Query to Gather Diagnosis and store in ^TMP("AMER
 ;
 ;BEDD v2.0;No longer pulling Dx from BEDD class
 Q
 NEW RS,STATUS,AMERDIAG,CNT,CODE,PRM,PCODE,NAR,PNAR,PFND
 K DIAG
 ;
 S CNT=0,PCODE="",PNAR="",PFND=""
 S RS=##CLASS(%ResultSet).%New()
 S RS.ClassName="BEDD.EDDiagnosis"
 S RS.QueryName="DXPrint"
 S STATUS=RS.Execute(OBJID)
 ;
 ;Quit if no diagnosis
 I STATUS'=1 S RS="" Q
 ;
 While RS.Next() {
	;
 	S CIEN=RS.Data("CodeIEN")
 	S PRM=RS.Data("PrimaryDiag")
 	S NAR=RS.Data("DiagNarrative")
 	S CODE=$$GET1^DIQ(80,CIEN_",",".01","I")
 	;
 	I ((PRM="YES")&(PFND="")) {
	 	S ^TMP("AMER",$J,2,11,.1)=CIEN_U_NAR_" ["_CODE_"]"
	 	S PFND=1
 		}
 	Else {
		S CNT=CNT+1
		S ^TMP("AMER",$J,2,11,CNT)=CIEN_U_NAR_" ["_CODE_"]"	
 	}		
 }
 ;
XDIAGQ S RS=""
 Q
 ;
PCCPRV ;Log Consult Provider(s) in V PROVIDER file
 ;
 NEW RIEN,RIENI,VPROV
 ;
 I $D(^AUPNVPRV("AD",VIEN)) D
 . ;
 . ;Get list of existing entries
 . S RIEN="" F  S RIEN=$O(^AUPNVPRV("AD",VIEN,RIEN)) Q:+RIEN=0  S VPROV($P(^AUPNVPRV(RIEN,0),"^",1))=""
 ;
 Q:$G(AMERDA)=""
 Q:'$D(^AMERVSIT(AMERDA,19))
 ;
 S RIEN="" F  S RIEN=$O(^AMERVSIT(AMERDA,19,"B",RIEN)) Q:RIEN=""  D
 . S RIENI="" F  S RIENI=$O(^AMERVSIT(AMERDA,19,"B",RIEN,RIENI)) Q:RIENI=""  D
 .. ;
 .. NEW RCP,RCDT,IENS,DA
 .. ;
 .. S DA(1)=AMERDA,DA=RIENI,IENS=$$IENS^DILF(.DA)
 .. S RCP=$$GET1^DIQ(9009080.019,IENS,".03","I") Q:RCP=""  ;Cons
 .. S RCDT=$$GET1^DIQ(9009080.019,IENS,".02","I") ;Cons Dtm
 .. ;
 .. I '$D(VPROV(RCP)) D
 ... K DIC,DD,DO,DINUM,X,Y
 ... S DIC="^AUPNVPRV(" S DIC(0)="XML" S X=RCP
 ... S DIC("DR")=".02////"_DFN_";.03////"_VIEN_";.04////S;.05////C;1201////"_RCDT
 ... D FILE^DICN
 ... K DIC,DD,DO,DINUM
 ... S VPROV(RCP)=""
 ;
 Q
 ;
COMP ;Process computed fields
 ;
 NEW AMERDR,AMERDFN,ADMDTM,VSIT,DTM,X,DIC,DD,DO,DIE,DA,DR
 ;
 S (AMERDR(2),AMERDR(12))=""
 ;
 ; REVOLVING DOOR
 S AMERDFN=DFN
 S ADMDTM=$$GET1^DIQ(9009080,AMERDA_",",".01","I")
 ;
 S DTM=0,VSIT="" F  S VSIT=$O(^AMERVSIT("AC",AMERDFN,VSIT)) Q:'VSIT  D
 . ;
 . NEW X
 . S X=$$GET1^DIQ(9009080,VSIT_",",".01","I")
 . I X>DTM,X'>ADMDTM S DTM=X
 ;
 I +DTM]"" D
 . S DTM=$$DT^AMERSAV1(ADMDTM,DTM,"D")
 . I DTM<366 S AMERDR(2)=AMERDR(2)_";8.2////"_DTM
 ;
 ;Injury transport lag
 I $D(^AMERVSIT(AMERDA,3)) D
 . NEW X
 . S X=$$GET1^DIQ(9009080,VSIT_",","3.4","I")
 . Q:'X
 . S DTM=$$DT(ADMDTM,X,"M"),AMERDR(2)=AMERDR(2)_";8.1////"_DTM
 ;
 ;Doctor Wait
 S X=$$GET1^DIQ(9009080,VSIT_",","12.1","I") I X D
 . S DTM=$$DT(X,ADMDTM,"M"),AMERDR(12)=AMERDR(12)_";12.3////"_DTM
 ;
 ;Triage Nurse Wait
 S X=$$GET1^DIQ(9009080,VSIT_",","12.2","I") I X D
 . S DTM=$$DT^AMERSAV1(X,ADMDTM,"M"),AMERDR(12)=AMERDR(12)_";12.4////"_DTM
 ;
 ;Visit Duration
 S X=$$GET1^DIQ(9009080,VSIT_",","6.2","I") I X D
 . S DTM=$$DT^AMERSAV1(X,ADMDTM,"M"),AMERDR(12)=AMERDR(12)_";12.5////"_DTM
 ;
 S DIE="^AMERVSIT(" S DA=AMERDA
 S DR=$P(AMERDR(2),";",2,99)
 D ^DIE
 S DR=$P(AMERDR(12),";",2,99)
 D ^DIE
 Q
 ;
VERENTRY(AMERDFN,AMERPCC) ;Create V EMERGENCY VISIT RECORD entry
 ;
 ;BEDD*2.0*1;Updated to call new AMER update call
 D VER^AMERVER($G(AMERDFN),$G(AMERPCC))
 Q
 ;
 Q:$G(AMERPCC)=""
 Q:$D(^AUPNVER("AD",AMERPCC))
 ;
 NEW IACT,URG,DCDT,MOT,MOA,ENTBY,DISP,DSP,DIC,DD,DO,DINUM,X,Y
 ;
 ;Urgency
 S IACT=$$GET1^DIQ(9009080,AMERDA_",",".24","I"),URG=$S(IACT=1:"E",((IACT=2)!(IACT=3)):"U",1:"N")
 ;
 ;Departure Date/Time
 S DCDT=$$GET1^DIQ(9009080,AMERDA_",","6.2","I")
 ;
 ;Method of Transport
 S ENTBY="",MOA="",MOT=$$GET1^DIQ(9009080,AMERDA_",",".25","I") I MOT'="" D
 . ;
 . ;Means of Arrival
 . S MOT=$$GET1^DIQ(9009083,MOT_",",".01","I")
 . I MOT["WALK" S MOA="W"
 . I MOT["AMBULANCE" S MOA="A"
 . S:MOA="" MOA="O"
 . ;
 . ;Entered ER By
 . I MOT["AMBULANCE" S ENTBY="A"
 . I MOT["WHEEL" S ENTBY="W"
 . I MOT["STRET"  S ENTBY="S"
 ;
 S DIS="",DISP=$$GET1^DIQ(9009080,AMERDA_",","6.1","I") I DISP'="" D
 . S DISP=$$GET1^DIQ(9009083,DISP_",",".01","I")
 . I DISP["HOME" S DIS="D"
 . I DISP["TRANS" S DIS="T"
 . I DISP["ADMIT" S DIS="A"
 . I DISP["LEFT" S DIS="O"
 . I DISP["REGIS" S DIS="O"
 . I DISP["EXPIRED" S DIS="E"
 . I DISP["DEA" S DIS="E"
 ;
 ;File entry
 K DIC,DD,DO,DINUM,X
 S DIC="^AUPNVER(" S DIC(0)="XML" S X="IHS-114 ER"
 S DIC("DR")=".02////"_DFN_";.03////"_AMERPCC_";.04////"_URG_";.05////"_MOA_";.07////"_ENTBY_";.11////"_DIS_";.13////"_DCDT
 D FILE^DICN
 ;
 S $P(^AUPNVER(+Y,0),"^",12)=$E(DISP,1,20)
 K DIC,DD,DO,DINUM,X
 Q
 ;
DT(X,Y,T) ;EP - Calculate Time Difference
 ;
 NEW %,A,B,C,E,%T,%H,%Y
 ;
 I '$G(X)!('$G(Y)) Q ""
 I $G(T)="" S T="M"
 D H^%DTC S A=+%H,B=%T,X=Y
 D H^%DTC S C=+%H,E=%T
 I E>B S B=B+86400,A=A-1
 S %=((A-C)*86400)+(B-E)
 I T="M" S %=%\60
 E  S %=%\86400
 Q %
 ;
PRCNT(OBJID,RET,PROC) ;Get count of procedures for visit
 ;
 ;Input:
 ; OBJID - Pointer to BEDD.EDVISIT entry
 ; RET (Optional) - Whether to return list (1/"")
 ;
 ;Output:
 ; total current procedure entries
 ; PROC Array (Optional) - List of procedure entries
 ;
 NEW RS,STATUS,AMERPROC,CNT,XPROC
 K PROC
 ;
 S RET=$G(RET,"")
 S CNT=0,PROC=0
 S RS=##CLASS(%ResultSet).%New()
 S RS.ClassName="BEDD.EDProc"
 S RS.QueryName="procPrint"
 S STATUS=RS.Execute(OBJID)
 ;
 ;Quit if no procedures
 I STATUS'=1 S RS="" Q 0
 ;
 While RS.Next() {
 ;
 S AMERPROC=RS.Data("EDProc")
 	If (AMERPROC'="") {
		S CNT=CNT+1
	 	If (RET=1) {
		 	S XPROC=$$GET1^DIQ(9009083,AMERPROC_",",".01","I") Q:XPROC=""
	 		S PROC=PROC+1
	 		S PROC(CNT)=XPROC
		}
	 }
 }
XPRCNT S RS=""
 Q CNT
 ;
EDCNT(OBJID,RET,CONS) ;Get count of ED Consults for visit
 ;
 ;Input:
 ; OBJID - Pointer to BEDD.EDVISIT entry
 ; RET (Optional) - Whether to return list (1/"")
 ;
 ;Output:
 ; total current ED Consults entries
 ; CONS Array (Optional) - List of ED Consults
 ;
 NEW RS,STATUS,AMERED,CNT,COTY,CDATE,CTIME,CNS
 K CONS
 ;
 S RET=$G(RET,"")
 S CNT=0,CONS=0
 S RS=##CLASS(%ResultSet).%New()
 S RS.ClassName="BEDD.EDConsults"
 S RS.QueryName="consPrint"
 S STATUS=RS.Execute(OBJID)
 ;
 ;Quit if no procedures
 I STATUS'=1 S RS="" Q 0
 ;
 While RS.Next() {
 ;
 S AMERED=RS.Data("ConsultSrv")
 	If (AMERED'="") {
	 	S CNT=CNT+1
	 	If (RET=1) {
		 	S COTY=$$GET1^DIQ(9009082.9,AMERED_",",".01","I") Q:COTY=""
		 	S CDATE=RS.Data("DateSeen")
		 	S CTIME=RS.Data("TimeSeen")
		 	S CDATE=$TR($$HTE^XLFDT(CDATE_","_CTIME,"5"),"@"," ")
		 	S CNS=RS.Data("ConsultN")
		 	;I CNS]"" S CNS=$$GET1^DIQ(200,CNS_",",".01","I")
		 	S CONS=CONS+1
		 	S CONS(CONS)=COTY_"^"_CDATE_"^"_CNS 
	 	}
 	}	
 }
XEDCNT S RS=""
 Q CNT
 ;
DXCNT(OBJID,RET,DIAG,PRIME) ;Get count of diagnosis for visit
 ;
 ;Input:
 ; OBJID - Pointer to BEDD.EDVISIT entry
 ; RET (Optional) - Whether to return list (1/"")
 ; PRIME (Optional) - Whether to return the Prime Code IEN (1/"")
 ;
 ;Output:
 ; total current DIAG entries
 ; DIAG Array (Optional) - List of diagnosis entries
 ;
 NEW BEDD,VIEN,AMERPOV,CNT,PCODE,PNARR,X,PIEN
 ;
 ;Make sure needed values are defined
 S X="S:$G(U)="""" U=""""" X X
 S X="S:$G(DT)="""" DT=$$DT^XLFDT" X X
 ;
 S BEDD=##CLASS(BEDD.EDVISIT).%OpenId(OBJID)
 ;
 ;Get Visit IEN and date
 S VIEN=BEDD.VIEN I VIEN="" Q 0
 S (BEDD,PCODE,PNAR,PIEN)="",DIAG=0
 ;
 ;Get V POV information
 D POV^AMERUTIL("",VIEN,.AMERPOV)
 ;
 S CNT="" F  S CNT=$O(AMERPOV(CNT)) Q:CNT=""  D
 . NEW CODE,PRM,NARR,ICDIEN
 . S CODE=$P(AMERPOV(CNT),"^")
 . S PRM=$P(AMERPOV(CNT),"^",2) S PRM=$S(PRM="P":"YES",1:"NO")
 . S NARR=$P(AMERPOV(CNT),"^",3)
 . S ICDIEN=$P(AMERPOV(CNT),"^",4)
 . S DIAG=DIAG+1
 . S DIAG(DIAG)=CODE_U_NARR_U_PRM
 . I PRM="YES" S PCODE=CODE,PNAR=NARR,PIEN=ICDIEN
 ;
 ;Save Prime Code at top level
 If $G(PRIME)=1 S DIAG=DIAG_"^"_PCODE_"^"_PNAR_"^"_PIEN
 ;
 Q DIAG
