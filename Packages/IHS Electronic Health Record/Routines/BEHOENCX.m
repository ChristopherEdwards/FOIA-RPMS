BEHOENCX ;MSC/IND/DKM - Encounter Context Support ;07-Jul-2011 17:28;PLS
 ;;1.1;BEH COMPONENTS;**005003,005004,005007**;Sep 18, 2007;Build 1
 ;=================================================================
 ; RPC: Fetch visit data given visit file IEN
 ; Returns hosp loc^visit date^service category^dfn^visit id^locked
GETVISIT(DATA,IEN) ;EP
 N VSIT,DLM
 S (DLM,DATA)=""
 Q:$$LOOKUP^VSIT(IEN,"I",0)<1
 Q:$G(VSIT("DEL"))
 F VSIT="LOC","VDT","SVC","PAT","VID" S DATA=DATA_DLM_VSIT(VSIT),DLM=U
 S DATA=DATA_U_$$ISLOCKED(IEN)
 Q
 ; RPC: Fetch visit IEN given visit id
VID2IEN(DATA,VID) ;EP
 S DATA=$$VID2IEN^VSIT(VID)
 Q
 ; RPC: Return IEN of hospital location
LOCIEN(DATA,LOC) ;EP
 S DATA=$$FIND1^DIC(44,"","QX",LOC)
 Q
 ; RPC: Return values for specified encounter
 ;   DFN   = Patient IEN
 ;   VSTR  = Visit string (extended)
 ;   PRV   = Provider
 ;   CREATE= -1=Always, 0=never, 1=If not found
 ;   Return value =
 ;        1       2       3       4        5       6        7       8      9
 ;     LOCNAME^LOCABBR^ROOMBED^PROVIEN^PROVNAME^VISITIEN^VISITID^LOCKED^ERRORTXT
FETCH(DATA,DFN,VSTR,PRV,CREATE) ;EP
 N IEN,X,FETCH
 S PRV=+$G(PRV)
 S FETCH=$$GET^XPAR("ALL","BEHOENCX PROV ENC FETCH")
 I 'PRV,$$ISPROV^BEHOUSCX S PRV=DUZ
 S IEN=$$VSTR2VIS(DFN,.VSTR,.CREATE,PRV)
 I IEN>0,'PRV,FETCH D
 .D GETPRV2(.X,IEN,1)
 .S PRV=+$O(X(0))
 S DATA=$P($G(^SC(+VSTR,0)),U,1,2)
 S $P(DATA,U,3)=$P($G(^DPT(DFN,.101)),U)
 S $P(DATA,U,4)=PRV
 S $P(DATA,U,5)=$P($G(^VA(200,PRV,0)),U)
 I IEN>0 S $P(DATA,U,6)=IEN,$P(DATA,U,7)=$P($G(^AUPNVSIT(IEN,150)),U),$P(DATA,U,8)=$$ISLOCKED(IEN)
 E  S $P(DATA,U,9)=$P(IEN,U,2)
 Q
 ; RPC: Return location info
 ;   Returns 0 node of HOSPITAL LOCATION file for specified entry.
LOCINFO(DATA,LOC) ;
 Q $G(^SC(+LOC,0))
 ; Find a visit
 ;   DFN = Patient IEN
 ;   DAT = Visit date/time
 ;   CAT = Service category
 ;   LOC = Value to compare (location or stop code)
 ;   CRE = Force create?
 ;   PRV = Provider IEN to restrict search (optional)
 ;   ELC = Encounter location (optional)
 ; Returns one of:
 ;   If found or created: visit ien
 ;   If not found: 0
 ;   If error: -1^error message
FNDVIS(DFN,DAT,CAT,LOC,CRE,PRV,ELC) ;PEP - Find a visit
 N IN,OUT,IEN,DIF
 S IN("PAT")=DFN
 S IN("VISIT DATE")=DAT
 S IN("VISIT TYPE")=$S(CAT="E":"O",1:$S($G(DUZ("AG"))="I":$$GET1^DIQ(9001000,DUZ(2),.04,"I"),1:$$GET^XPAR("ALL","BEHOENCX VISIT TYPE")))
 S IN("SRV CAT")=CAT
 S IN("TIME RANGE")=60
 S IN("USR")=DUZ
 S:$G(LOC) IN("HOS LOC")=LOC
 S:$G(XQY) IN("APCDOPT")=XQY
 S:$G(PRV) IN("PROVIDER")=PRV
 S ELC=$G(ELC)
 I $L(ELC),ELC'=+ELC D
 .S IN("APCDOLOC")=ELC
 .S ELC=$$GET^XPAR("ALL","BEHOENCX OTHER LOCATION")
 S IN("SITE")=$S(ELC:ELC,$P($G(^SC(+$G(LOC),0)),U,4):$P(^(0),U,4),1:DUZ(2))
 I 'CRE S IN("NEVER ADD")=1
 E  I CRE<0 S IN("FORCE ADD")=1
 I $G(DUZ("AG"))="I" D
 .D GETVISIT^BSDAPI4(.IN,.OUT)
 E  D GETVISIT^BEHOENC1(.IN,.OUT)
 Q:'OUT(0) $S(OUT(0)[U:"-1^"_$P(OUT(0),U,2),1:0)
 S IEN=0,DIF=999999
 F  S IEN=$O(OUT(IEN)) Q:'IEN  D
 .I OUT(IEN)="ADD" D
 ..N VSTR
 ..S VSTR=$$VIS2VSTR(DFN,IEN)
 ..D BRDCAST^CIANBEVT("PCC."_DFN_".VST",VSTR)
 ..D:$G(PRV) UPDPRV(,DFN,VSTR,PRV)
 .S:$$ABS(OUT(IEN))<DIF DIF=$$ABS(OUT(IEN)),IEN(0)=IEN
 Q IEN(0)
 ; Return absolute value
ABS(X) Q $S(X<0:-X,1:X)
 ; Return a visit ien from a visit string (create if necessary)
 ;   DFN    = Patient IEN
 ;   VSTR   = Visit string
 ;   CREATE = Create flag
 ;            0 = Don't create
 ;           >0 = Create if not found
 ;           <0 = Always create
 ;   PRV    = Provider IEN to restrict visit search (optional)
VSTR2VIS(DFN,VSTR,CREATE,PRV) ;PEP - Convert visit string to visit IEN
 N IEN,DAT,CAT,LOC,FLG,VSIT,LP
 S LOC=+VSTR,DAT=+$P(VSTR,";",2),CAT=$P(VSTR,";",3),IEN=+$P(VSTR,";",4),CREATE=+$G(CREATE)
 I 'IEN,CREATE'<0 S IEN=$$FNDVIS(DFN,DAT,CAT,LOC,0,.PRV)
 I 'IEN,CREATE'<0 S IEN=$$FNDVIS(DFN,DAT,CAT,LOC,0)
 I 'IEN,CREATE S IEN=$$FNDVIS(DFN,DAT,CAT,LOC,CREATE,.PRV)
 S:IEN>0 VSTR=$$VIS2VSTR(DFN,IEN,.IEN),$P(VSTR,";")=LOC
 Q IEN
 ; Return a visit string given visit ien
VIS2VSTR(DFN,IEN,ERR) ;PEP - Convert visit IEN to visit string
 N VSTR
 S VSTR=$G(^AUPNVSIT(+IEN,0))
 I '$L(VSTR) S ERR="-1^Visit does not exist"
 E  I $P(VSTR,U,5)'=DFN S ERR="-1^Visit does not belong to current patient",VSTR=""
 E  S VSTR=$P(VSTR,U,22)_";"_+VSTR_";"_$P(VSTR,U,7)_";"_IEN
 Q VSTR
 ; RPC: Return a list of appointments
 ; APPTTIME^LOCIEN^LOCNAME^EXTSTATUS
APPTLST(DATA,DFN) ;EP
 N VASD,I
 S VASD("F")=$$HTFM^XLFDT($H-30,1)
 S VASD("T")=$$HTFM^XLFDT($H+1,1)_".2359"
 S VASD("W")="123456789"
 D SDA^VADPT
 S I=0
 F  S I=$O(^UTILITY("VASD",$J,I)) Q:'I  D
 .S DATA(I)=$P(^UTILITY("VASD",$J,I,"I"),U,1,2)_U_$P(^("E"),U,2,3)
 K ^UTILITY("VASD",$J)
 Q
 ; RPC: Return a list of admissions
 ; VSTR^LOCNAME^ADMDATE^TYPE^LOCKED
ADMITLST(DATA,DFN,BEG,END) ;EP
 N TIM,MOV,CNT,IDT,IDT2
 S CNT=0,TIM=""
 S:'$G(BEG) BEG=2000000
 S:'$G(END) END=DT
 S IDT2=9999999-(BEG\1)+.9,IDT=9999999-(END\1)
 F  Q:'IDT!(IDT>IDT2)  D  S IDT=$O(^DGPM("ATID1",DFN,IDT))
 .S MOV=0 F  S MOV=$O(^DGPM("ATID1",DFN,IDT,MOV)) Q:MOV'>0  D
 ..S X=$$ADMITINF(DFN,MOV)
 ..S:X CNT=CNT+1,DATA(CNT)=X
 Q
 ; RPC: Return current admission info
 ; VSTR^LOCNAME^ADMDATE^TYPE^LOCKED
ADMITCUR(DATA,DFN) ;EP
 S DATA=$$ADMITINF(DFN,+$G(^DPT(DFN,.105)))
 Q
 ; Return admission info
 ; VSTR^LOCNAME^ADMDATE^TYPE^LOCKED
ADMITINF(DFN,MOV) ;EP
 N VIEN,VSTR,LLOC,XLOC,HLOC,CMOV,AMOV,DMOV,LMOV,MTIM,XTYP,X0
 S X0=$G(^DGPM(+MOV,0))
 Q:$P(X0,U,3)'=DFN ""
 S MTIM=$P(X0,U),DMOV=$P(X0,U,17),VIEN=$P(X0,U,27)
 S:'$D(^AUPNVSIT(+VIEN,0)) VIEN=""
 S CMOV=+$G(^DPT(DFN,.102)),AMOV=+$G(^(.105))
 S XTYP=$P($G(^DG(405.1,+$P(X0,U,4),0)),U)
 I MOV=AMOV,CMOV'=AMOV,$D(^DGPM(CMOV,0)) S LMOV=CMOV
 E  S LMOV=MOV
 D AL2(MOV,.XLOC,.HLOC),AL2(LMOV,.LLOC,.HLOC):LMOV'=MOV
 I $L($G(LLOC)),LLOC'=XLOC S XLOC=XLOC_" ("_LLOC_")"
 S VSTR=HLOC_";"_MTIM_";H;"_VIEN
 Q VSTR_U_XLOC_U_MTIM_U_XTYP_U_$$ISLOCKED(VIEN)
 ; Return ward location name and associated hospital location ien for movement
AL2(MOV,WLOC,HLOC) ;
 S WLOC=+$P($G(^DGPM(MOV,0)),U,6),WLOC=$P($G(^DIC(42,WLOC,0)),U),HLOC=+$G(^(44))
 Q
 ; RPC: Get discharge movement information
DISCHRG(DATA,DFN,ADMITDT) ;EP
 N VAIP
 S DATA=DT
 Q:'$G(ADMITDT)
 S VAIP("D")=ADMITDT
 D 52^VADPT
 S:VAIP(17) DATA=+VAIP(17,1)
 Q
 ; Returns true if active hospital location
 ; LOC = IEN of hospital location
 ; DAT = optional date to check (defaults to today)
ACTLOC(LOC,DAT) ;PEP - Is active location?
 N D0,X
 S X=$G(^SC(LOC,0))
 Q:'$L(X) 0                                                            ; Screen nonexistent entries
 S X=$P($G(^DG(40.8,+$P(X,U,15),0)),U,7)
 I X,X'=DUZ(2) Q 0                                                     ; Screen clinics not in current division
 Q:+$G(^SC(LOC,"OOS")) 0                                               ; Screen OOS entry
 S D0=+$G(^SC(LOC,42)),DAT=$G(DAT,DT)\1
 I D0 D WIN^DGPMDDCF Q 'X                                              ; Check out of svc wards
 S X=$G(^SC(LOC,"I"))
 Q:'X 1                                                                ; No inactivate date
 Q:DAT'<$P(X,U)&($P(X,U,2)=""!(DAT<$P(X,U,2))) 0                       ; Check reactivate date
 Q 1                                                                   ; Must still be active
 ; RPC: Return a set of hospital locations
HOSPLOC(DATA,FROM,DIR,MAX,TYPE,START,END) ;EP
 N IEN,CNT,APT
 S FROM=$G(FROM),DIR=$G(DIR,1),MAX=$G(MAX,44),TYPE=$G(TYPE),CNT=0
 S START=$G(START)\1,END=$G(END)\1
 S:'END END=START
 F  S FROM=$O(^SC("B",FROM),DIR),IEN="" Q:FROM=""  D  Q:CNT'<MAX
 .F  S IEN=$O(^SC("B",FROM,IEN),DIR) Q:'IEN  D
 ..I $$ACTLOC(IEN),$P(^SC(IEN,0),U,3)[TYPE D
 ...I START S APT=$O(^SC(IEN,"S",START-.1))\1 Q:'APT!(APT>END)
 ...S CNT=CNT+1,DATA(CNT)=IEN_U_$P(^SC(IEN,0),U)_U_$S($G(DUZ("AG"))="I":$P($G(^BSDSC(IEN,0)),U,12),1:$P($G(^SC(IEN,0)),U,9))
 Q
 ; RPC: Return a set of clinics
CLINLOC(DATA,FROM,DIR,MAX,START,END) ;EP
 D HOSPLOC(.DATA,.FROM,.DIR,.MAX,"C",.START,.END)
 Q
 ; RPC: Return a set of wards
INPLOC(DATA,FROM,DIR,MAX) ;EP
 D HOSPLOC(.DATA,.FROM,.DIR,.MAX,"W")
 Q
 ; RPC: Return appts/visits for patient
 ;  DFN = Patient IEN
 ;  BEG = Beginning date to search (optional)
 ;        Defaults to BEHOENCX SEARCH RANGE START
 ;  END = Ending date to search (optional)
 ;        Defaults to BEHOENCX SEARCH RANGE END
 ;  LOC = If not specified, return all locations and all active appointments
 ;        If <0, return all locations and all appointments (except checked-in)
 ;        If >0, return only specified location and only active appointments
 ;SCEXC = Contains service category types to exclude (defaults to HXI)
 ; .DATA= List of results in format:
 ;        VSTR^LOCNAME^DATE^STATUS^LOCKED^PRV^PRVNM^STANDALONE
VISITLST(DATA,DFN,BEG,END,LOC,SCEXC) ;EP
 N VAERR,VASD,CNT,IDT,IDT2,STS,DTM,LOCNAM,LOCIEN,VSTR,IEN,LP,XI,XE,X
 S CNT=0,DATA=$$TMPGBL^CIAVMRPC,LOC=+$G(LOC)
 S SCEXC=$G(SCEXC,"XI")  ;p9 removed H
 S:'$G(BEG) BEG=$$DTSTART
 S:'$G(END) END=$$DTSTOP+.9
 ; Return list of visits for a patient
 S IDT2=9999999-(BEG\1)+.9,IDT=9999999-(END\1)
 F  Q:'IDT!(IDT>IDT2)  D  S IDT=$O(^AUPNVSIT("AA",DFN,IDT))
 .F IEN=0:0 S IEN=$O(^AUPNVSIT("AA",DFN,IDT,IEN)) Q:'IEN  D
 ..N PRV
 ..S XI=$G(^AUPNVSIT(IEN,0)),DTM=+XI,LOCIEN=$P(XI,U,22),LOCNAM=$P($G(^SC(+LOCIEN,0),"Unknown"),U),X=$P(XI,U,7)
 ..Q:$P(XI,U,11)                                                       ; Ignore if logically deleted
 ..Q:'LOC&'LOCIEN
 ..Q:LOC>0&(LOC'=LOCIEN)
 ..D GETPRV2(.PRV,IEN,1)
 ..S PRV=$P($G(PRV(+$O(PRV(0)))),U,1,2)
 ..S VSTR=LOCIEN_";"_DTM_";"_X_";"_IEN,STS=$$SET^CIAU(X,$P($G(^DD(9000010,.07,0)),U,3))
 ..S:SCEXC'[X CNT=CNT+1,@DATA@(-DTM,CNT)=VSTR_U_LOCNAM_U_DTM_U_STS_U_$$ISLOCKED(IEN)_U_PRV_U_'$D(^SCE("AVSIT",IEN))
 Q:LOC>0
 ; Get appointments pending check-in
 S VASD("F")=$S(LOC<0:BEG,BEG<DT:DT,1:BEG)
 S VASD("T")=END
 S VASD("W")=$S(LOC<0:123456789,1:1)
 D SDA^VADPT
 S LP=0
 F  S LP=$O(^UTILITY("VASD",$J,LP)) Q:'LP  D
 .S XI=^UTILITY("VASD",$J,LP,"I"),XE=^("E")
 .S DTM=$P(XI,U),LOCIEN=$P(XI,U,2),LOCNAM=$P(XE,U,2)
 .Q:$$CHKDIN(DFN,LOCIEN,DTM)
 .S XI=$G(^DPT(DFN,"S",DTM,0))
 .Q:+XI'=LOCIEN
 .S XI=$P(XI,U,20),STS=$S(LOC<0:$P(XE,U,3),1:"Pending Check-In")
 .I XI,$P($G(^SCE(XI,0)),U,5) Q
 .S VSTR=LOCIEN_";"_DTM_";A"
 .S CNT=CNT+1,@DATA@(-DTM,CNT)=VSTR_U_LOCNAM_U_DTM_U_STS
 K ^UTILITY("VASD",$J)
 Q
 ; Returns true if checked in
CHKDIN(DFN,LOCIEN,DTM) ;
 Q:$G(DUZ("AG"))="I" $$CI^BSDU2(DFN,LOCIEN,DTM)
 Q ''$P($$STATUS^SDAMA308(DFN,DTM,LOCIEN),";",4)
 ; Returns visit lock status:
 ;  -1:  Visit not found
 ;   0:  Visit is not locked
 ;   1:  Visit is locked
ISLOCKED(IEN) ;PEP - Is visit locked?
 N DAT,DAYS,EXPDT
 S DAT=$$VISREFDT(IEN)
 Q:'DAT -1
 ;IHS/MSC/PLS - 02/18/09 - Parameter now holds lock expiration date
 S EXPDT=$$GET^XPAR("USR","BEHOENCX VISIT LOCK OVERRIDE","`"_IEN)
 Q:EXPDT'<$$DT^XLFDT() 0
 D:EXPDT DEL^XPAR("USR","BEHOENCX VISIT LOCK OVERRIDE","`"_IEN)  ; remove expired locked
 ;Q:$$GET^XPAR("USR","BEHOENCX VISIT LOCK OVERRIDE","`"_IEN) 0
 S DAYS=$$GET^XPAR("ALL","BEHOENCX VISIT LOCKED")
 Q $$FMDIFF^XLFDT(DT,DAT)>$S(DAYS<1:1,1:DAYS)
 ; Returns reference date for visit lock check
VISREFDT(IEN) ;
 N ADM,DIS,DAT
 S DAT=$P($G(^AUPNVSIT(+IEN,0)),U,2)
 Q:'DAT ""
 S ADM=$O(^DGPM("AVISIT",IEN,0))
 Q:'ADM DAT
 S DIS=$P($G(^DGPM(ADM,0)),U,17)
 Q $S(DIS:$P($G(^DGPM(DIS,0)),U),1:DT)
 ; RPC: Return providers associated with a visit (by VSTR)
 ; If PRI is set, returns primary only
 ; Returns as DATA(DUZ)=DUZ^Name^Primary^EncDT
GETPRV(DATA,DFN,VSTR,PRI) ;EP
 D GETPRV2(.DATA,$$VSTR2VIS(DFN,VSTR,0),.PRI)
 Q
 ; RPC: Return providers associated with a visit (by IEN)
 ; If PRI is set, returns primary only
 ; Returns as DATA(DUZ)=DUZ^Name^Primary^EncDT
GETPRV2(DATA,IEN,PRI) ;EP
 N LP,ED,PP,PR,X
 K DATA
 S LP=0,IEN=+IEN,PRI=+$G(PRI)
 F  S LP=$O(^AUPNVPRV("AD",IEN,LP)) Q:'LP  D
 .S X=$G(^AUPNVPRV(LP,0)),ED=$P($G(^(12)),U),PP=$P(X,U,4)="P",PR=+X
 .I $P(X,U,3)=IEN,'PRI!PP S DATA(PR)=PR_U_$$GET1^DIQ(200,PR,.01)_U_PP_U_ED
 Q
 ; RPC: Add/Remove providers to/from a visit
UPDPRV(DATA,DFN,VSTR,PRV) ;EP
 N PCC,ACT,PRI,PFG,RTN
 S:$D(PRV)=1 PRV(PRV)="P"
 S PRV="",PFG=0
 F  S PRV=$O(PRV(PRV)) Q:'$L(PRV)  D
 .S ACT=PRV(PRV),PRI=0
 .S:ACT="P" PRI='PFG,ACT="+",PFG=1
 .D ADDPCC("PRV"_ACT_U_PRV_"^^^^"_PRI)
 D:$D(PCC) SAVE^BEHOENPC(.DATA,.PCC)
 Q
 ; RPC: Check visit for missing elements
CHKVISIT(DATA,IEN) ;
 Q:$T(+2^BEHOXQPC)=""
 N RTN,CNT
 S CNT=0
 D NOPOV^BEHOXQPC(.RTN,IEN),CV1("POV")
 D NOEMC^BEHOXQPC(.RTN,IEN),CV1("E&M")
 Q
CV1(DX) S:$D(RTN) CNT=CNT+1,$P(RTN,U)=DX,DATA(CNT)=RTN
 K RTN
 Q
 ; Build PCC array
ADDPCC(X) ;
 S:'$D(PCC) PCC(1)="HDR^^^"_VSTR,PCC(2)="VST^PT^"_DFN
 S PCC($O(PCC(""),-1)+1)=X
 Q
 ;  VST may either be the visit ien or a visitstr
 ;  Optionally returns success indicator
SETCTX(VST) ;PEP - Set the encounter context
 N UID
 S UID=$$GETUID^CIANBUTL
 D:$L(UID) QUEUE^CIANBEVT("CONTEXT.ENCOUNTER",VST,UID)
 Q:$Q ''$L(UID)
 Q
 ; Return FM date given relative date
 ;   DAT = Relative date (e.g., T+1)
 ;   DFL = Default relative date (if DAT is not specified)
TOFM(DAT,DFL) ;
 N %DT,X,Y
 S X=$S(DAT="":DFL,1:DAT),%DT="TS"
 D ^%DT
 Q Y
 ; Return start date for encounters
DTSTART() ;EP
 Q $$TOFM($$GET^XPAR("ALL","BEHOENCX SEARCH RANGE START",1,"I"),"T-365")
 ; Return stop date for encounters
DTSTOP() ;EP
 Q $$TOFM($$GET^XPAR("ALL","BEHOENCX SEARCH RANGE STOP",1,"I"),"T+90")
 ; Return formatted visit detail report
ENINQ(DATA,VIEN) ;
 S DATA=$$TMPGBL^CIAVMRPC
 D CAPTURE^CIAUHFS($TR($$GET^XPAR($$ENT^CIAVMRPC("BEHOENCX DETAIL REPORT"),"BEHOENCX DETAIL REPORT"),"~",U),DATA,80)
 Q
