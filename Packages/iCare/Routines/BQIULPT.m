BQIULPT ;PRXM/HC/ALA-Patient Data Utilities ; 17 Oct 2005  3:17 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;**1**;Feb 07, 2011;Build 5
 ;
 ; This is a utility program containing special function calls
 ; needed for patient demographic data.
 Q
 ;
HRN(DFN) ;EP -- Patient Health Record Number
 ;
 ;Description
 ;  Returns the patient's health record number
 ;Input
 ;  DFN - Patient internal entry number
 ;  DUZ(2) - Assumes DUZ(2) exists since it's defined by
 ;           signing on to the system as the user's default
 ;           facility
 ;Output
 ;  HRN - Health Record number for the user's default
 ;        facility
 ;
 I $G(DUZ(2))="" Q ""
 I $G(DFN)="" Q ""
 ;
 NEW HRN
 S HRN=$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2)
 I $P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,3)'="" S HRN="*"_HRN
 Q HRN
 ;
HRNL(DFN) ;EP -- List of HRNs for a patient
 NEW HRN,LOC,HDATA,ABR,VAL,ULOC,DVAL
 S LOC=0,VAL=""
 S DVAL=$$HLK(DUZ(2)),DVAL=$$TKO^BQIUL1(DVAL,"-")
 I DVAL'="" S VAL=VAL_DVAL_";"
 F  S LOC=$O(^AUPNPAT(DFN,41,LOC)) Q:'LOC  D
 . Q:LOC=DUZ(2)
 . S DVAL=$$HLK(LOC),DVAL=$$TKO^BQIUL1(DVAL,"-")
 . I DVAL'="" S VAL=VAL_DVAL_";"
 Q $$TKO^BQIUL1(VAL,";")
 ;
HLK(ULOC) ; EP - Get HRN data for a location
 NEW HDATA,IACT
 S HDATA=$G(^AUPNPAT(DFN,41,ULOC,0))
 S HRN=$P(HDATA,U,2),IACT=$P(HDATA,U,3)
 I HRN="" Q ""
 ;S ABR=$P($G(^AUTTLOC(ULOC,1)),U,2)
 S ABR=$P(^AUTTLOC(ULOC,0),U,7)
 I IACT'="" S HRN="*"_HRN
 Q HRN_"-"_ABR
 ;
DPCP(DFN) ;EP -- Get patient's designated primary care provider
 ;
 ;Description
 ;  Checks the 'Designated Provider Management System' first
 ;  for the patient's primary care provider, otherwise it
 ;  checks the Patient file.
 ;Input
 ;  DFN - Patient internal entry number
 ;Output
 ;  DPCPN^DPCPNM
 ;    DPCPN  - Primary Care Provider internal entry number
 ;    DPCPNM - Primary Care Provider Name
 ;
 NEW DPCAT,DPIEN,DPCPN,DPCPNM
 S DPCPN=""
 S DPCAT=$O(^BDPTCAT("B","DESIGNATED PRIMARY PROVIDER",""))
 I DPCAT'="" D
 . S DPIEN=$O(^BDPRECN("AA",DFN,DPCAT,""))
 . I DPIEN="" Q
 . S DPCPN=$$GET1^DIQ(90360.1,DPIEN_",",.03,"I")
 . S DPCPNM=$$GET1^DIQ(90360.1,DPIEN_",",.03,"E")
 I DPCPN'="" Q DPCPN_"^"_DPCPNM
 ;
 S DPCPN=$$GET1^DIQ(9000001,DFN_",",.14,"I")
 S DPCPNM=$$GET1^DIQ(9000001,DFN_",",.14,"E")
 Q DPCPN_"^"_DPCPNM
 ;
CM(DFN) ;EP -- Get patient's case manager
 ;
 ;Description
 ;  Check the 'Designated Provider Management System' for a
 ;  Case Manager, if there isn't one where look then?**
 ;Input
 ;  DFN - Patient internal entry number
 ;Output
 ;  CMGRN - Case Manager internal entry number
 NEW DPCAT,DPIEN,CMGRN,CMGRNM
 S CMGRN=""
 S DPCAT=$O(^BDPTCAT("B","CASE MANAGER",""))
 I DPCAT'="" D
 . S DPIEN=$O(^BDPRECN("AA",DFN,DPCAT,""))
 . I DPIEN="" Q
 . S CMGRN=$$GET1^DIQ(90360.1,DPIEN_",",.03,"I")
 . S CMGRNM=$$GET1^DIQ(90360.1,DPIEN_",",.03,"E")
 I CMGRN'="" Q CMGRN_"^"_CMGRNM
 Q CMGRN
 ;
BPD(DFN,VWIEN) ;EP - Get patient's provider from DSPM
 NEW PROV,VCODE,VCAT,VDN,VDESC,VALUE
 S VCODE=$P(^BQI(90506.1,VWIEN,0),U,1),VCAT=$E(VCODE,4,$L(VCODE))
 S VDN=$O(^BDPTCAT("C",VCAT,"")),VDESC=$P(^BDPTCAT(VDN,0),U,1)
 D ALLDP^BDPAPI(DFN,VDESC,.VALUE)
 I '$D(VALUE) Q ""
 Q $P(VALUE(VDESC),U,2)_"^"_$P(VALUE(VDESC),U,1)
 ;
LVD(DFN) ;EP -- Get patient's last visit
 ;Input
 ;  DFN - Patient internal entry number
 ;
 NEW VIEN,LVISIT,QFL,LVSDT
 S VIEN="",LVISIT="",QFL=0,LVSDT=""
 S LVSDT=$O(^AUPNVSIT("AA",DFN,LVSDT)) I LVSDT="" Q LVISIT
 F  S VIEN=$O(^AUPNVSIT("AA",DFN,LVSDT,VIEN)) Q:VIEN=""  D  Q:QFL
 . I $$GET1^DIQ(9000010,VIEN,.11,"I")=1 Q
 . S LVISIT=VIEN,QFL=1
 Q LVISIT
 ;
LVDT(DFN) ;EP -- Get patient's last visit date/time
 ;Input
 ;  DFN - Patient internal entry number
 ;
 NEW VIEN
 S VIEN=$$LVD(.DFN)
 I VIEN="" Q ""
 Q $$FMTE^BQIUL1($$GET1^DIQ(9000010,VIEN_",",.01,"I"))
 ;
LVC(DFN) ;EP -- Get patient's last visit clinic
 ;Input
 ;  DFN - Patient internal entry number
 NEW VIEN,CST
 S VIEN=$$LVD(.DFN)
 I VIEN="" Q ""
 S CST=$$GET1^DIQ(9000010,VIEN_",",.08,"I")
 I CST="" Q ""
 Q $$GET1^DIQ(9000010,VIEN_",",.08,"E")_" "_$$GET1^DIQ(40.7,CST_",",1,"E")
 ;
LVP(DFN) ;EP -- Get patient's last visit primary provider
 ;Input
 ;  DFN - Patient internal entry number
 NEW VIEN,PRV
 S VIEN=$$LVD(.DFN)
 I VIEN="" Q ""
 S PRV=$$PRIMVPRV^PXUTL1(VIEN)
 I PRV=0 Q ""
 Q $$GET1^DIQ(200,PRV_",",.01,"E")
 ;
LVDN(DFN) ;EP -- Get patient's last visit POV narratives
 ;Input
 ;  DFN - Patient internal entry number
 NEW VIEN,TEXT,IEN,POVN
 S VIEN=$$LVD(.DFN),TEXT="",IEN=""
 I VIEN="" Q ""
 F  S IEN=$O(^AUPNVPOV("AD",VIEN,IEN)) Q:IEN=""  D
 . S POVN=$$GET1^DIQ(9000010.07,IEN_",",".019","E")
 . I $L(TEXT)+$L(POVN)>250 Q
 . S TEXT=TEXT_POVN_$C(13)_$C(10)
 Q $$TKO^BQIUL1(TEXT,$C(13)_$C(10))
 ;
LVPN(DFN) ;EP -- Get patient's last visit provider narratives
 ;Input
 ;  DFN - Patient internal entry number
 NEW VIEN,TEXT,IEN,PRVN
 S VIEN=$$LVD(.DFN),TEXT="",IEN=""
 I VIEN="" Q ""
 F  S IEN=$O(^AUPNVPOV("AD",VIEN,IEN)) Q:IEN=""  D
 . S PRVN=$$GET1^DIQ(9000010.07,IEN_",",".04","E")
 . I $L(TEXT)+$L(PRVN)>250 Q
 . S TEXT=TEXT_PRVN_$C(13)_$C(10)
 Q $$TKO^BQIUL1(TEXT,$C(13)_$C(10))
 ;
NAD(DFN) ;EP -- Get patient's next appt date
 ;Input
 ;  DFN - Patient internal entry number
 NEW NAPTM
 S NAPTM=$$NOW^XLFDT()
 Q $$FMTE^BQIUL1($O(^DPT(DFN,"S",NAPTM)))
 ;
NAPT(DFN) ;EP -- Get patient's next appt
 ;Input
 ;  DFN - Patient internal entry number
 NEW NAPTM
 S NAPTM=$$NOW^XLFDT()
 Q $O(^DPT(DFN,"S",NAPTM))
 ;
NAC(DFN) ;EP -- Get patient's next appt date's clinic
 ;Input
 ;  DFN - Patient internal entry number
 ;
 NEW NAPTM,IENS,DA,NAN,CSTCD,CST
 S NAPTM=$$NAPT(DFN)
 I NAPTM="" Q ""
 S DA(1)=DFN,DA=NAPTM,IENS=$$IENS^DILF(.DA)
 S NAN=$$GET1^DIQ(2.98,IENS,.01,"I")
 I NAN="" Q ""
 S CST=$$GET1^DIQ(44,NAN_",",8,"I"),CSTCD=""
 I CST'="" S CSTCD=$$GET1^DIQ(40.7,CST_",",1,"E")
 Q $$GET1^DIQ(2.98,IENS,.01,"E")_" "_CSTCD
 ;
NAPV(DFN) ;EP -- Get patient's next appt provider
 ;Input
 ;  DFN - Patient internal entry number
 ;
 NEW NAPTM,IENS,DA,NAN,CSTCD,CST,PRNAME,PRNM,PRN
 S NAPTM=$$NAPT(DFN)
 I NAPTM="" Q ""
 S DA(1)=DFN,DA=NAPTM,IENS=$$IENS^DILF(.DA)
 S NAN=$$GET1^DIQ(2.98,IENS,.01,"I")
 I NAN="" Q ""
 S PRNAME=$$GET1^DIQ(44,NAN_",",16,"E")
 I PRNAME="" D
 . S PRN=0
 . F  S PRN=$O(^SC(NAN,"PR",PRN)) Q:'PRN  D
 .. I $P($G(^SC(NAN,"PR",PRN,0)),U,2)=1 D
 ... S PRNM=$P($G(^SC(NAN,"PR",PRN,0)),U,1)
 ... S PRNAME=$$GET1^DIQ(200,PRNM_",",.01,"E")
 Q PRNAME
 ;
SENS(DFN) ;EP -- Is patient sensitive flag
 ;Input
 ;  DFN - Patient internal entry number
 NEW FLAG
 S FLAG=+$P($G(^DGSL(38.1,+DFN,0)),"^",2)
 S FLAG=$S(FLAG=1:"Y",1:"N")
 Q FLAG
 ;
FLG(USR,PANEL,DFN) ;EP -- Get flag indicator for a specific user and panel
 ;Input
 ;  DFN - Patient internal entry number
 ;  USR - User internal entry number
 ;  PANEL - Panel internal entry number
 ;
 NEW BQIPREF,FLG
 D RET^BQIFLAG(USR,.BQIPREF)
 S FLG=$$FPAT^BQIFLAG(DFN,USR,.BQIPREF)
 S FLG=$S(FLG>0:"Y",1:"")
 Q FLG
 ;
MFLAG(USR,PANEL,DFN) ;EP -- Get manual flag
 ;Input
 ;  DFN - Patient internal entry number
 ;  USR - User internal entry number
 ;  PANEL - Panel internal entry number
 NEW DA,IENS,MFLG
 S MFLG=""
 I $G(USR)="" Q MFLG
 I $G(PANEL)="" Q MFLG
 I $G(DFN)="" Q MFLG
 S DA(2)=USR,DA(1)=PANEL,DA=DFN,IENS=$$IENS^DILF(.DA)
 S MFLG=$$GET1^DIQ(90505.04,IENS,.02,"I")
 Q MFLG
 ;
PADD(USR,PANEL,DFN) ;EP -- Get patient added to panel date/time
 ;Input
 ;  DFN - Patient internal entry number
 ;  USR - User internal entry number
 ;  PANEL - Panel internal entry number
 NEW DA,IENS,ADDTM
 S ADDTM=""
 I $G(USR)="" Q ADDTM
 I $G(PANEL)="" Q ADDTM
 I $G(DFN)="" Q ADDTM
 S DA(2)=USR,DA(1)=PANEL,DA=DFN,IENS=$$IENS^DILF(.DA)
 S ADDTM=$$GET1^DIQ(90505.04,IENS,.04,"I")
 I ADDTM="" S ADDTM=$$GET1^DIQ(90505.04,IENS,.07,"I")
 Q $$FMTE^BQIUL1(ADDTM)
 ;
GMET(DFN) ;EP -- Get a patient's GPRA MET value
 ;Input
 ;  DFN - Patient internal entry number
 NEW STVW,GMET,GHDR,HDR,VAL,NUM,DEN,BQIDOD
 S GMET="",GHDR="T00003GPRM",STVW=""
 S BQIDOD=$$GET1^DIQ(2,DFN_",",.351,"I")
 F  S STVW=$O(^BQIPAT(DFN,30,"B",STVW)) Q:STVW=""  D
 . D GVAL^BQIGPRA1
 Q $S(BQIDOD'="":"D",GMET=1:"YES",GMET=0:"NO",1:"NDA")
 ;
DCAT(DFN) ;EP -- Get a patient's diagnosis categories
 ;Input
 ;  DFN - Patient internal entry number
 NEW CAT,CATA,LIST,DIEN,STAT,CNAM,DOD
 S DOD=$$GET1^DIQ(2,DFN_",",.351,"I")
 I DOD'="" Q "{D}"  ;Deceased patient
 S CAT=""
 F  S CAT=$O(^BQIREG("C",DFN,CAT)) Q:CAT=""  D
 . S DIEN=""
 . F  S DIEN=$O(^BQIREG("C",DFN,CAT,DIEN)) Q:DIEN=""  D
 .. S CATA=$$GET1^DIQ(90506.2,CAT_",",.07,"E")
 .. S CNAM=$$GET1^DIQ(90506.2,CAT_",",.01,"E")
 .. S STAT=$P(^BQIREG(DIEN,0),U,3)
 .. I STAT="V"!(STAT="S")!(STAT="N") Q
 .. ;I STAT="V"!(STAT="S") S CATA(CATA)="" Q
 .. ;S CATA(CATA)=$S(STAT="A":"*",1:"?")
 .. S CATA(CATA)=" ("_STAT_")"
 ;
 S CAT="",LIST=""
 F  S CAT=$O(CATA(CAT)) Q:CAT=""  S LIST=LIST_CAT_CATA(CAT)_"; "
 S LIST=$E(LIST,1,$L(LIST)-2)
 Q LIST
 ;
REM(DFN,MIEN) ;EP -- Get a patient's reminder value
 ;Input
 ;  DFN  - Patient internal entry number
 ;  MIEN - Reminder my measure internal entry number
 I $G(MIEN)="" Q ""
 NEW TYPE,CODE,TIEN,NAME,PIEN,VALUE,DUDT,VAL,CT,ODT
 S TYPE=$P($G(^BQI(90506.1,MIEN,3)),U,1) I TYPE="" Q ""
 S CODE=$P(^BQI(90506.1,MIEN,0),U,1)
 S TIEN=$P(CODE,"_",2)
 S NAME=$P(^BQI(90506.1,MIEN,0),U,3)
 ;
 S PIEN=$O(^BQIPAT(DFN,40,"B",CODE,"")) I PIEN="" Q ""
 S VALUE=$G(^BQIPAT(DFN,40,PIEN,0))
 S CT=0
 F I=2:1:4 S:$P(VALUE,U,I)'="" CT=CT+1
 I CT=0 Q "N/A"
 S DUDT=$P(VALUE,U,4) S:DUDT="" DUDT=DT
 S ODT=$$FMADD^XLFDT(DT,-30)
 Q $S(DUDT<ODT:"O",DUDT>DT:"F",1:"C")
 ;
OVD(DFN) ; EP - Overdue reminders
 ; Output
 ;   1 if patient has any overdue reminders
 ;   0 if patient does not have any overdue reminders
 NEW TYPE,CODE,TIEN,NAME,PIEN,VALUE,DUDT,VAL,CT,ODT,OVDF
 S MIEN="",OVDF=0
 F  S MIEN=$O(^BQI(90506.1,"AC","R",MIEN)) Q:MIEN=""  D
 . I $P(^BQI(90506.1,MIEN,0),U,10)=1 Q
 . S CODE=$P(^BQI(90506.1,MIEN,0),U,1)
 . S TIEN=$P(CODE,"_",2)
 . S NAME=$P(^BQI(90506.1,MIEN,0),U,3)
 . ;
 . S PIEN=$O(^BQIPAT(DFN,40,"B",CODE,"")) I PIEN="" Q
 . S VALUE=$G(^BQIPAT(DFN,40,PIEN,0))
 . S CT=0
 . F I=2:1:4 S:$P(VALUE,U,I)'="" CT=CT+1
 . I CT=0 S OVDF=0 Q
 . S DUDT=$P(VALUE,U,4) S:DUDT="" DUDT=DT
 . S ODT=$$FMADD^XLFDT(DT,-30)
 . ; If the due date (DUDT) is less then it's overdue
 . S OVDF=$S(DUDT<ODT:1,1:0)
 Q OVDF
 ;
PER(DFN,MIEN) ;EP -- Get a patient's performance value
 ;Input
 ;  DFN  - Patient internal entry number
 ;  MIEN - Reminder my measure internal entry number
 I $G(MIEN)="" Q ""
 NEW TYPE,CODE,TIEN,PIEN,GYR,BQIH,BQIY,NAFLG,DEN,NUM,VER,BQIDOD
 S TYPE=$P($G(^BQI(90506.1,MIEN,3)),U,1) I TYPE="" Q ""
 S CODE=$P(^BQI(90506.1,MIEN,0),U,1)
 S GYR=$P(CODE,"_",1),TIEN=$P(CODE,"_",2)
 ;
 S BQIDOD=$$GET1^DIQ(2,DFN_",",.351,"I")
 S PIEN=$O(^BQIPAT(DFN,30,"B",CODE,""))
 I PIEN="",BQIDOD'="" Q "D"  ;Deceased patient
 I PIEN="" Q "NDA"
 S BQIH=$$SPM^BQIGPUTL()
 S BQIY=$$LKP^BQIGPUTL(GYR)
 D GFN^BQIGPUTL(BQIH,BQIY)
 S VER=$$VERSION^XPDUTL("BGP")
 I VER<8.0 D
 . S SPIEN=$O(^BQI(90508,BQIH,20,BQIY,20,"B",TIEN,""))
 . S NAFLG=+$P(^BQI(90508,BQIH,20,BQIY,20,SPIEN,0),"^",4)
 I VER>7.0 D
 . S NAFLG=$$GET1^DIQ(BQIMEASF,TIEN_",",1704,"I")
 . S NAFLG=$S(NAFLG="Y":1,1:0)
 ;
 S DEN=$P(^BQIPAT(DFN,30,PIEN,0),U,4)
 S NUM=+$P(^BQIPAT(DFN,30,PIEN,0),U,3)
 I DEN="" S VAL=$S(NAFLG=1:0,1:"N/A")
 I DEN D
 . I 'NUM S VAL=$S(NAFLG=1:0,1:"NO"),GMET=0 Q
 . S VAL=$S(NAFLG=1:NUM,1:"YES")
 Q VAL
 ;
CALR(DFN) ;EP - Get community alert flag
 NEW TEMP,ADATE,COMM,CMN
 S ADATE=$$DATE^BQIUL1("T-30")
 ;S ADATE=$$DATE^BQIUL1("T-36M") ;**Temporary for testing**
 ;
 S COMM=$$GET1^DIQ(9000001,DFN_",",1117,"I"),CMN=COMM
 I COMM="" Q "N"
 ; If no alerts for the patient's community, quit
 I $D(^BQI(90507.6,COMM))<1 Q "N"
 S TEMP="BQITMP" K @TEMP
 D FND^BQICASPL
 I $D(@TEMP)>0 K @TEMP Q "Y"
 Q "N"
 ;
POP(DFN) ;EP - Get patient population
 NEW BQZ,GP,VALUE,PPP,RV,QFL,PVAL
 S GP=0
 F  S GP=$O(^BQIPAT(DFN,30,GP)) Q:'GP  D
 . S VALUE=$P(^BQIPAT(DFN,30,GP,0),"^",2)
 . I VALUE="" Q
 . S PPP=$P(VALUE,"|||",1)
 . I PPP="" Q
 . S BQZ(PPP)=""
 ;
 I $D(BQZ)<1 Q ""
 S RV="",QFL=0,PVAL=""
 F  S RV=$O(BQZ(RV),-1) Q:RV=""  D  Q:QFL
 . I $F(RV,"AC")>0 S QFL=1,PVAL="AC" Q
 . I $F(RV,"UP")>0 S QFL=1,PVAL="UP" Q
 Q PVAL
 ;
PFLNG(DFN) ;EP - Get preferred language
 NEW MRDT,MRIEN,IENS,DA,PVAL
 S MRDT=$O(^AUPNPAT(DFN,86,"B",""),-1)
 I MRDT="" Q ""
 S MRIEN=$O(^AUPNPAT(DFN,86,"B",MRDT,""),-1),PVAL=""
 S DA(1)=DFN,DA=MRIEN,IENS=$$IENS^DILF(.DA)
 I $G(VFIEN)'="" S PVAL=$$GET1^DIQ(9000001.86,IENS,.04,"I")_$C(28)_$$GET1^DIQ(9000001.86,IENS,.04,"E")
 I $G(VFIEN)="" S PVAL=$$GET1^DIQ(9000001.86,IENS,.04,"E")
 Q PVAL
 ;
COUN(DFN) ;EP - Get the county of the patient's current community
 NEW COMM
 S COMM=$$GET1^DIQ(9000001,DFN_",",1117,"I") I COMM="" Q ""
 Q $$GET1^DIQ(9999999.05,COMM_",",.02,"E")
