BJPNPRUT ;GDIT/HS/BEE-Prenatal Care Module Problem Handling Calls ; 08 May 2012  12:00 PM
 ;;1.0;PRENATAL CARE MODULE;;Dec 06, 2012;Build 61
 ;
 Q
 ;
DEL(DATA,VIEN,PIPIEN,DCODE,DRSN) ;BJPN DELETE PIP PROBLEM
 ;
 ;Delete prenatal problem from PIP (and remove from V OB)
 ;
 NEW UID,II,%,NOW,PRUPD,ERROR,RSLT,DFN,PROC,DTTM,VFL,VPUPD
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPRUT",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPRUT D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S @DATA@(II)="T00010RESULT^T00150ERROR_MESSAGE"_$C(30)
 ;
 ;Input validation
 I $G(VIEN)="" S II=II+1,@DATA@(II)="-1^MISSING VISIT IEN"_$C(30) G XDEL
 I $G(PIPIEN)="" S II=II+1,@DATA@(II)="-1^MISSING PIPIEN"_$C(30) G XDEL
 I $$GET1^DIQ(90680.01,PIPIEN_",",".01","I")="" S II=II+1,@DATA@(II)="-1^INVALID PIPIEN"_$C(30) G XDEL
 I $$GET1^DIQ(90680.01,PIPIEN_",",2.01,"I")]"" S II=II+1,@DATA@(II)="-1^PROBLEM ALREADY DELETED"_$C(30) G XDEL
 S DCODE=$G(DCODE,""),DRSN=$G(DRSN,"")
 ;
 ;Check for latest note
 I $$GET1^DIQ(90680.01,PIPIEN_",",3,"E")]"" S II=II+1,@DATA@(II)="-1^PROBLEMS WITH NOTES CANNOT BE DELETED"_$C(30) G XDEL
 ;
 D NOW^%DTC S NOW=%
 ;
 ;Technical Note
 S VFL("TNOTE")="Problem Deleted From PIP"
 ;
 ;Retrieve DFN
 S DFN=$$GET1^DIQ(9000010,VIEN_",",".05","I") I DFN="" S II=II+1,@DATA@(II)="-1^INVALID VISIT"_$C(30) G XDEL
 ;
 ;Mark as deleted
 S RSLT="1"
 S PRUPD(90680.01,PIPIEN_",",2.01)=DUZ
 S PRUPD(90680.01,PIPIEN_",",2.02)=NOW
 S PRUPD(90680.01,PIPIEN_",",2.03)=DCODE
 S PRUPD(90680.01,PIPIEN_",",2.04)=DRSN
 ;
 I $D(PRUPD) D FILE^DIE("","PRUPD","ERROR")
 I $D(ERROR) S RSLT="-1^DELETE FAILED",II=II+1,@DATA@(II)=RSLT_$C(30) G XDEL
 ;
 ;Mark all V PRENATAL entries as deleted
 S DTTM="" F  S DTTM=$O(^AUPNVOB("AE",DFN,PIPIEN,DTTM)) Q:DTTM=""  D
 . NEW VPIEN
 . S VPIEN="" F  S VPIEN=$O(^AUPNVOB("AE",DFN,PIPIEN,DTTM,VPIEN)) Q:VPIEN=""  D
 .. ;
 .. ;Quit if already deleted
 .. Q:($$GET1^DIQ(9000010.43,VPIEN_",",2.01,"I")]"")
 .. ;
 .. Q:$D(PROC(VPIEN))
 .. S PROC(VPIEN)=""
 .. ;
 .. S VPUPD(9000010.43,VPIEN_",",2.01)=DUZ
 .. S VPUPD(9000010.43,VPIEN_",",2.02)=NOW
 .. S VPUPD(9000010.43,VPIEN_",",2.03)=DCODE
 .. S VPUPD(9000010.43,VPIEN_",",2.04)=DRSN
 .. I $D(VPUPD) D FILE^DIE("","VPUPD","ERROR")
 .. I $D(ERROR) S RSLT="-1^V OB DELETE FAILED",II=II+1,@DATA@(II)=RSLT_$C(30)
 ;
 ;Create final V OB visit entry to record the delete
 S VFL("DFN")=DFN
 S VFL("VIEN")=VIEN
 S VFL("PRIORITY")=$$GET1^DIQ(90680.01,PIPIEN_",",.06,"I") ;Priority
 S VFL("SCOPE")=$$GET1^DIQ(90680.01,PIPIEN_",",.07,"I") ;Scope
 S VFL("PTEXT")=$$GET1^DIQ(90680.01,PIPIEN_",",.05,"I") ;Provider Text
 S VFL("STATUS")=$$GET1^DIQ(90680.01,PIPIEN_",",.08,"I") ;Status
 S VFL("DEDD")=$$GET1^DIQ(90680.01,PIPIEN_",",.09,"I") ;Definitive EDD
 S VFL("OEDT")=NOW
 S VFL("OEBY")=DUZ
 S VFL("LMDT")=NOW
 S VFL("LMBY")=DUZ
 S VFL("DEBY")=DUZ
 S VFL("DEDT")=NOW
 S VFL("DECD")=DCODE
 S VFL("DERN")=DRSN
 S VFL("TNOTE",2.01)=""
 S VFL("TNOTE",2.02)=""
 I DCODE]"" S VFL("TNOTE",2.03)=""
 I DRSN]"" S VFL("TNOTE",2.04)=""
 S VFL("TNOTE",1218)=""
 S VFL("TNOTE",1219)=""
 ;
 ;Log V OB entry
 S RSLT=$$VFILE^BJPNVFIL(PIPIEN,.VFL) I +RSLT="-1" S II=II+1,@DATA@(II)="-1^V OB SAVE FAILED"
 ;
 S II=II+1,@DATA@(II)="1^"_$C(30)
 ;
XDEL S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
UPD(DATA,VIEN,PIPIEN,PARMS) ;EP - BJPN UPDATE PROBLEM
 ;
 ;Input:
 ; VIEN   - Visit IEN
 ; PIPIEN - PIP problem IEN
 ; PARMS - Format var1=value_$c(28)_var2=value...
 ;         TRM - Snomed Term(Pointer to 90680.02)
 ;         STS - Status (A/I)
 ;         SCO - Scope (A/C)
 ;         PRI - Priority (L/M/H)
 ;         PTX - Provider Text
 ;         EDD - Definitive EDD (Date)
 ;        NOTE - New note
 ;
 NEW UID,II,NOW,%,BJPNUP,EDD,LMBY,LMDT,PRI,SCO,STS,PTX,SNWCT,SNWTR1,SNWTR2
 NEW BQ,NOTE,VFL,TRM,FND
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPRUT",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPRUT D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Re-assemble possible array
 S PARMS=$G(PARMS,"")
 I PARMS="" D
 . NEW LIST,BN
 . S LIST="",BN=""
 . F  S BN=$O(PARMS(BN)) Q:BN=""  S LIST=LIST_PARMS(BN)
 . K PARMS
 . S PARMS=LIST
 . K LIST
 ;
 ;Define variables
 S (TRM,STS,SCO,NOTE,PRI,PTX,EDD)=""
 ;
 F BQ=1:1:$L(PARMS,$C(28)) D
 . NEW PDATA,NAME,VALUE
 . S PDATA=$P(PARMS,$C(28),BQ) Q:PDATA=""
 . S NAME=$P(PDATA,"=",1),VALUE=$P(PDATA,"=",2,99)
 . I VALUE="" S VALUE="@"
 . S @NAME=VALUE
 ;
 S @DATA@(II)="T00005RESULT^I00010VFIEN^T00150ERROR_MESSAGE"_$C(30)
 ;
 ;Get current date/time
 D NOW^%DTC S NOW=%
 ;
 ;Technical Note
 S VFL("TNOTE")="Updated Problem Entry"
 ;
 ;Pull existing fields first
 ;
 ;Patient DFN/Visit IEN
 S DFN=$$GET1^DIQ(90680.01,PIPIEN_",",.02,"I")
 S VFL("DFN")=DFN
 S VFL("VIEN")=VIEN
 ;
 ;Handle updates
 ;
 ;Make sure code isn't assigned already
 I TRM]"" D  I FND=1 S II=II+1,@DATA@(II)="-1^^PATIENT ALREADY HAS PROBLEM IN THEIR PIP"_$C(30) G XUPD
 . ;
 . NEW IEN
 . ;
 . ;Check for Duplicate Entry
 . S FND=0,IEN="" F  S IEN=$O(^BJPNPL("AC",DFN,TRM,IEN)) Q:IEN=""  D
 .. ;
 .. ;Skip Deletes
 .. Q:($$GET1^DIQ(90680.01,IEN_",","2.01","I")]"")
 .. S FND=1
 ;
 ;SNOMED Concept ID
 I TRM]"" S VFL("TNOTE",.12)="",SNWCT=$$GET1^DIQ(90680.02,TRM_",",.01,"I")
 I TRM="" S SNWCT=$$GET1^DIQ(90680.01,PIPIEN_",",.01,"I")
 S VFL("CONC")=SNWCT
 S BJPNUP(90680.01,PIPIEN_",",".01")=SNWCT
 ;
 ;SNOMED Term 1
 I TRM]"" S SNWTR1=TRM
 I TRM="" S SNWTR1=$$GET1^DIQ(90680.01,PIPIEN_",",.03,"I")
 S VFL("SNO")=SNWTR1
 S BJPNUP(90680.01,PIPIEN_",",".03")=SNWTR1
 ;
 ;SNOMED Term 2
 S SNWTR2=$$GET1^DIQ(90680.01,PIPIEN_",",.04,"I")
 ;
 ;Priority
 I PRI]"" S VFL("TNOTE",.06)=""
 I PRI="" S PRI=$$GET1^DIQ(90680.01,PIPIEN_",",.06,"I")
 S VFL("PRIORITY")=PRI
 S BJPNUP(90680.01,PIPIEN_",",.06)=PRI
 ;
 ;Scope
 I SCO]"" S VFL("TNOTE",.08)=""
 I SCO="" S SCO=$$GET1^DIQ(90680.01,PIPIEN_",",.07,"I")
 S VFL("SCOPE")=SCO
 S BJPNUP(90680.01,PIPIEN_",",.07)=SCO
 ;
 ;Status
 I STS]"" S VFL("TNOTE",.09)=""
 I STS="" S STS=$$GET1^DIQ(90680.01,PIPIEN_",",.08,"I")
 S VFL("STATUS")=STS
 S BJPNUP(90680.01,PIPIEN_",",.08)=STS
 ;
 ;Definitive EDD
 I EDD]"" S VFL("TNOTE",.1)=""
 I EDD]"" S EDD=$$DATE(EDD)
 I EDD="" S EDD=$$GET1^DIQ(90680.01,PIPIEN_",",.09,"I")
 S VFL("DEDD")=EDD
 S BJPNUP(90680.01,PIPIEN_",",.09)=EDD
 ;
 ;Last Modified Date
 S LMDT=NOW
 S VFL("LMDT")=LMDT
 S VFL("TNOTE",1218)=""
 S BJPNUP(90680.01,PIPIEN_",",1.03)=LMDT
 ;
 ;Last Modified By
 S LMBY=DUZ
 S VFL("LMBY")=LMBY
 S VFL("TNOTE",1219)=""
 S BJPNUP(90680.01,PIPIEN_",",1.04)=LMBY
 ;
 ;Provider text
 I PTX]"" D
 . NEW DIC,DLAYGO,X,Y
 . S VFL("TNOTE",.07)=""
 . S VFL("TNOTE",.11)=""
 . ;
 . ;Update the V POV file entry
 . D UPDPOV(VIEN,PIPIEN,PTX)
 . ;
 . S DIC(0)="LX",DIC="^AUTNPOV(",DLAYGO=9999999.27,X=PTX
 . D ^DIC
 . S PTX=+Y S:PTX=-1 PTX=""
 I PTX="" S PTX=$$GET1^DIQ(90680.01,PIPIEN_",",.05,"I")
 S BJPNUP(90680.01,PIPIEN_",",.05)=PTX
 S VFL("PTEXT")=PTX
 ;
 ;Current Note
 I $G(NOTE)]"" D
 . S VFL("TNOTE",2100)=""
 . S BJPNUP(90680.01,PIPIEN_",",3)=NOTE
 . S VFL("NOTE")=NOTE
 ;
 ;Update entry
 I $D(BJPNUP) D FILE^DIE("","BJPNUP","ERROR")
 I $D(ERROR) S II=II+1,@DATA@(II)="-1^^UPDATE PROBLEM PROCESS FAILED"_$C(30) G XUPD
 ;
 ;Log V OB entry
 S RSLT=$$VFILE^BJPNVFIL(PIPIEN,.VFL) I +RSLT="-1" S II=II+1,@DATA@(II)="-1^^V OB SAVE FAILED" G XUPD
 S II=II+1,@DATA@(II)="1^"_RSLT_"^"_$C(30)
 ;
XUPD S II=II+1,@DATA@(II)=$C(31)
 ;
 Q
 ;
ANOTE(VFIEN,NOTE,NEDT,NEBY) ;EP - Add note to V OB entry
 ;
 NEW DIC,DLAYGO,X,Y,VNIEN,DA
 ;
 I $G(VFIEN)="" Q "-1"
 I $G(NOTE)="" Q "-1"
 ;
 ;Pull Modified Date/By
 S:$G(NEDT)="" NEDT=$$GET1^DIQ(9000010.43,VFIEN_",",1218,"I")
 S:$G(NEBY)="" NEBY=$$GET1^DIQ(9000010.43,VFIEN_",",1219,"I")
 ;
 ;Add new entry
 S DIC="^AUPNVOB("_VFIEN_",21,",DA(1)=VFIEN
 S DLAYGO=9000010.431,DIC("P")=DLAYGO,DIC(0)="LOX"
 S X=NOTE
 S DIC("DR")=".02////"_NEDT_";.03////"_NEBY
 ;
 K DO,DD D FILE^DICN
 ;
XANOTE Q +Y
 ;
DATE(DATE) ;EP - Convert standard date/time to a FileMan date/time
 ;Input
 ;  DATE - In a standard format
 ;Output
 ;  -1 is if it couldn't convert to a FileMan date
 ;  otherwise a standard FileMan date
 NEW %DT,X,Y
 I DATE[":" D
 . I DATE["/",$L(DATE," ")=3 S DATE=$P(DATE," ",1)_"@"_$P(DATE," ",2)_$P(DATE," ",3) Q
 . I $L(DATE," ")=3 S DATE=$P(DATE," ",1,2)_"@"_$P(DATE," ",3)
 . I $L(DATE," ")>3 S DATE=$P(DATE," ",1,3)_"@"_$P(DATE," ",4,99)
 S %DT="TS",X=DATE D ^%DT
 I Y=-1 S Y=""
 ;
 Q Y
 ;
UFREQ(PRIEN,PLIEN) ;EP - UPDATE FREQUENCY FOR ENTRY
 ;
 ;Input:
 ;      PRIEN - Problem Pointer
 ;      PLIEN - Pick List Pointer (Master if Null)
 ;
 S PRIEN=$G(PRIEN) Q:PRIEN=""
 S PLIEN=$G(PLIEN)
 ;
 NEW IEN,DA,IENS,FREQ,ERROR,FRQUPD
 ;
 ;Handle Master_List Updates
 S:PLIEN="" PLIEN=$O(^BJPN(90680.03,"B","Master_List",""))
 Q:PLIEN=""
 ;
 ;Locate entry
 S IEN=$O(^BJPN(90680.03,PLIEN,1,"AC",PRIEN,"")) Q:IEN=""
 ;
 ;Pull existing frequency count
 S DA(1)=PLIEN,DA=IEN,IENS=$$IENS^DILF(.DA)
 S FREQ=+$$GET1^DIQ(90680.031,IENS,".03","I")
 S FREQ=FREQ+1
 ;
 ;Save updated frequency
 S FRQUPD(90680.031,IENS,".03")=FREQ
 D FILE^DIE("","FRQUPD","ERROR")
 ;
 Q
 ;
 ;
CLSMBR(DATA,USER,CLASS) ;BJPN USR CLASS MEMBER
 ;
 ;Returns whether user is a member of the specified class
 ;
 ;Input:
 ;  USER - The user to check (DUZ value)
 ; CLASS - The class to check in
 ;
 NEW UID,II,MBR,ERR
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPRUT",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPRUT D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S @DATA@(II)="I00001MEMBER^T00100ERROR_MESSAGE"_$C(30)
 ;
 ;Input validation
 I $G(USER)="" S II=II+1,@DATA@(II)="0^MISSING USER"_$C(30) G XCLS
 I $G(CLASS)="" S II=II+1,@DATA@(II)="0^MISSING USER CLASS"_$C(30) G XCLS
 ;
 ;Perform lookup
 S MBR=$$ISA(USER,CLASS,.ERR)
 ;
 I MBR=0 S II=II+1,@DATA@(II)="0^"_$G(ERR)_$C(30)
 E  S II=II+1,@DATA@(II)=MBR_$C(30)
 ;
XCLS S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ISA(USER,CLASS,ERR) ; Boolean - Is USER a Member of CLASS?
 NEW USRY,USRI
 I $S(CLASS="USER":1,CLASS=+$O(^USR(8930,"B","USER",0)):1,1:0) S USRY=1 G ISAX
 I '+USER S USER=+$O(^VA(200,"B",USER,0))
 I +USER'>0 S ERR="INVALID USER" Q 0
 I '+CLASS S CLASS=+$O(^USR(8930,"B",CLASS,0))
 I +CLASS'>0 S ERR="INVALID USER CLASS" Q 0
 ; If USER is a member of CLASS return true
 S USRY=0
 I +$D(^USR(8930.3,"AUC",USER,CLASS)) D
 . N USRMDA
 . S USRMDA=0
 . F  S USRMDA=+$O(^USR(8930.3,"AUC",USER,CLASS,USRMDA)) Q:((+USRMDA'>0)!(USRY))  D
 .. S USRY=+$$CURRENT(USRMDA)
 I USRY Q USRY
 ; Otherwise, check to see if user is a member of any subclass of CLASS
 S USRI=0
 F  S USRI=$O(^USR(8930,+CLASS,1,USRI)) Q:+USRI'>0!+$G(USRY)  D
 . NEW USRSUB S USRSUB=+$G(^USR(8930,+CLASS,1,USRI,0)) Q:+USRSUB'>0
 . S USRY=$$ISA(USER,USRSUB) ; Recurs to find members of subclass
ISAX Q +$G(USRY)
 ;
CURRENT(MEMBER) ; Boolean - Is Membership current?
 NEW USRIN,USROUT,USRY
 S USRIN=+$P($G(^USR(8930.3,+MEMBER,0)),U,3)
 S USROUT=+$P($G(^USR(8930.3,+MEMBER,0)),U,4)
 I USRIN'>DT,$S(USROUT>0&(USROUT'<DT):1,USROUT=0:1,1:0) S USRY=1
 E  S USRY=0
 Q USRY
 ;
UPDPOV(VIEN,PIPIEN,PTX) ;EP - Update the POV entry with the new provider text
 ;
 NEW PKIEN,ICIEN,ICD,POV,DFN,CD
 ;
 ;Pull Pick List entry
 S PKIEN=$$GET1^DIQ(90680.01,PIPIEN_",",.03,"I") I PKIEN="" Q
 ;
 ;Get the DFN
 S DFN=$$GET1^DIQ(9000010,VIEN,.05,"I") Q:DFN=""
 ;
 ;Locate the current POV entry (entries)
 ;
 ;Pull the ICD-9(s)
 S ICIEN=0 F  S ICIEN=$O(^BJPN(90680.02,PKIEN,1,ICIEN)) Q:'ICIEN  D
 . ;
 . NEW ICD9,ICDTP,DA,IENS
 . S DA(1)=PKIEN,DA=ICIEN,IENS=$$IENS^DILF(.DA)
 . S ICD9=$$GET1^DIQ(90680.21,IENS,.01,"I") Q:ICD9=""
 . S ICDTP=$$GET1^DIQ(90680.21,IENS,.02,"I") I ICDTP'=1 Q
 . S ICD(ICD9)=$$GET1^DIQ(90680.21,IENS,.01,"E")
 ;
 ;Check for .9999
 I '$D(ICD) D
 . NEW DIC,X,Y
 . S DIC="^ICD9(",DIC(0)="XMO",X=".9999" D ^DIC I +Y<0 Q
 . S ICD(+Y)=".9999"
 ;
 S POV=""
 S ICIEN="" F  S ICIEN=$O(^AUPNVPOV("AD",VIEN,ICIEN)) Q:ICIEN=""  D
 . NEW ICDCD,VPNARR,SNOMED
 . S VPNARR=$P($$GET1^DIQ(9000010.07,ICIEN_",",.04,"E"),"|")
 . S SNOMED=$$GET1^DIQ(90680.01,PIPIEN_",",.03,"I") Q:SNOMED=""
 . S SNOMED=$$GET1^DIQ(90680.02,SNOMED_",",.02,"E") Q:SNOMED=""
 . ;
 . ;Check for normal code match
 . S ICDCD=$$GET1^DIQ(9000010.07,ICIEN_",",.01,"I") Q:ICDCD=""
 . I $D(ICD(ICDCD)),SNOMED=VPNARR S POV=POV_$S(POV]"":";",1:"")_ICIEN Q
 . ;
 . Q
 ;
 ;Loop through current entries and replace the provider narrative
 F CD=1:1:$L(POV,";") I $P(POV,";",CD)]"" D
 . ;
 . NEW RET,N,INP
 . D GET^BGOVPOV(.RET,VIEN_U_$P(POV,";",CD))
 . S N=$G(@RET@(1))
 . S INP=$P(N,U)_U_$P(N,U,19)_U_"`"_$P(N,U,17)_U_DFN_U_$P($P(N,U,7),"| ")_"| "_PTX
 . S $P(INP,U,6)=$P(N,U,10) ;Stage
 . S $P(INP,U,7)=$$STC(9000010.07,.06,$P(N,U,8)) ;Modifier
 . S $P(INP,U,8)=$$STC(9000010.07,.07,$P(N,U,12)) ;Cause
 . S $P(INP,U,9)=$S($P(N,U,11)="REVISIT":2,1:1) ;Visit/Revisit
 . S $P(INP,U,10)=$P($P(N,U,14),"~",2) ;E-Code
 . S $P(INP,U,11)=$P($P(N,U,15),"~",2) ;Injury Place
 . S $P(INP,U,12)=$S($P(N,U,16)="PRIMARY":"P",1:"S") ;Primary/Secondary
 . S $P(INP,U,13)=$$FMTE^XLFDT($P(N,U,13),2) ;Injury Date
 . S $P(INP,U,14)=$$FMTE^XLFDT($P(N,U,9),2) ;Date of Onset
 . S $P(INP,U,16)=$P(N,U,21) ;Asthma
 . D SET^BGOVPOV(.RET,INP)
 ;
 Q
 ;
STC(FIL,FLD,VAL) ; EP - Find a code for a set of code value
 ;  Input Parameters
 ;    FIL = FileMan File Number
 ;    FLD = FileMan Field Number
 ;    VAL = Value
 ;
 NEW VEDATA,VEQFL,VEVL,VALUE,I
 S VEDATA=$P(^DD(FIL,FLD,0),U,3),VEQFL=0
 ;
 F I=1:1 S VEVL=$P(VEDATA,";",I) Q:VEVL=""  D  Q:VEQFL
 . S VALUE=$P(VEVL,":",1) I VAL=$P(VEVL,":",2) S VEQFL=1
 ;
 Q VALUE
