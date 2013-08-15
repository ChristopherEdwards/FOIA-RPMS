BJPNPDET ;GDIT/HS/BEE-Prenatal Care Module Utility 2 Calls ; 08 May 2012  12:00 PM
 ;;1.0;PRENATAL CARE MODULE;;Dec 06, 2012;Build 61
 ;
 Q
 ;
DET(DATA,PIP) ;EP - BJPN PROBLEM DETAIL
 ;
 ;This RPC returns the problem detail for a Problem entry (including paste deletes)
 ;
 ;Input:
 ; PIP - Pointer to Prenatal Problem file entry
 ;
 NEW UID,II,TMP,REC,PLIEN,DFN,TERM,PIPIEN
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPDET",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S TMP=$NA(^TMP("BJPNPDT1",UID))
 K @TMP
 ;
 S II=0,REC=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPDET D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define Header
 S @DATA@(II)="T01024REPORT_TEXT"_$C(30)
 ;
 I $G(PIP)="" G XDET
 ;
 ;Retrieve Problem Pointer
 S PLIEN=$$GET1^DIQ(90680.01,PIP_",",.03,"I") I PLIEN="" G XDET
 ;
 ;Retrieve DFN
 S DFN=$$GET1^DIQ(90680.01,PIP_",",.02,"I") I DFN="" G XDET
 ;
 S TERM=$$GET1^DIQ(90680.02,PLIEN_",",.02,"E")
 ;
 ;Loop through all instances of problem (including deletes)
 S PIPIEN="" F  S PIPIEN=$O(^BJPNPL("AC",DFN,PLIEN,PIPIEN)) Q:'PIPIEN  D
 . ;
 . NEW VDT
 . ;Step through all V OB entries for PIPIEN
 . S REC=0,VDT="" F  S VDT=$O(^AUPNVOB("AE",DFN,PIPIEN,VDT)) Q:VDT=""  D
 .. ;
 .. NEW VFIEN
 .. S VFIEN="" F  S VFIEN=$O(^AUPNVOB("AE",DFN,PIPIEN,VDT,VFIEN)) Q:VFIEN=""  D
 ... ;
 ... NEW ALMDT,LMDT,LMBY,OEDT,OEBY,AIEN
 ... ;
 ... ;Pull LMDT
 ... S ALMDT=$$GET1^DIQ(9000010.43,VFIEN_",",1218,"I")
 ... S:ALMDT="" ALMDT=$$GET1^DIQ(9000010.43,VFIEN_",",1216,"I")
 ... ;
 ... ;Loop through audit history
 ... S AIEN=0 F  S AIEN=$O(^AUPNVOB(VFIEN,22,AIEN)) Q:'AIEN  D
 .... ;
 .... NEW DA,IENS,RCNT,DA,IENS,ATYP,AVAL,VALUE,RCNT,VIEN
 .... ;
 .... S DA(1)=VFIEN,DA=AIEN,IENS=$$IENS^DILF(.DA)
 .... S ATYP=$$GET1^DIQ(9000010.4311,IENS,".01","I")
 .... S AVAL=$$GET1^DIQ(9000010.4311,IENS,".02","I")
 .... ;
 .... ;Define Line
 .... S VALUE=$$VALUE(VFIEN,ATYP,AVAL)
 .... ;
 .... ;Date/User Handling
 .... I AVAL=1216 S OEDT=VALUE Q
 .... I AVAL=1217 S OEBY=VALUE Q
 .... I AVAL=1218 S LMDT=VALUE Q
 .... I AVAL=1219 S LMBY=VALUE Q
 .... ;
 .... ;Log entry
 .... F RCNT=1:1:$L(VALUE,$C(28)) S REC=REC+1,@TMP@(ALMDT,REC)=$P(VALUE,$C(28),RCNT)
 ... ;
 ... ;Log Date/User
 ... I $G(LMDT)]"" S REC=REC+1,@TMP@(ALMDT,REC)=LMDT
 ... I $G(LMBY)]"" S REC=REC+1,@TMP@(ALMDT,REC)=LMBY
 ... I $G(OEDT)]"" S REC=REC+1,@TMP@(ALMDT,REC)=OEDT
 ... I $G(OEBY)]"" S REC=REC+1,@TMP@(ALMDT,REC)=OEBY
 ... ;
 ... ;Visit Date
 ... S VIEN=$$GET1^DIQ(9000010.43,VFIEN,.03,"I")
 ... S REC=REC+1,@TMP@(ALMDT,REC)="  *Visit Date: "_$$FMTE^BJPNPRL($$GET1^DIQ(9000010,VIEN_",",.01,"I"))
 ... ;
 ... ;Insert blank line
 ... S REC=REC+1,@TMP@(ALMDT,REC)=""
 ;
 ;Assemble Header
 S II=II+1,@DATA@(II)="SNOMED Term: "_TERM_$C(13)_$C(10)
 S II=II+1,@DATA@(II)=$C(13)_$C(10)
 ;
 ;Current Info
 S II=II+1,@DATA@(II)="CURRENT INFORMATION"_$C(13)_$C(10)
 S II=II+1,@DATA@(II)=$C(13)_$C(10)
 S II=II+1,@DATA@(II)="  *Provider Text: "_$$GET1^DIQ(90680.01,PIP_",",.05,"E")_$C(13)_$C(10)
 S II=II+1,@DATA@(II)="  *Priority: "_$$GET1^DIQ(90680.01,PIP_",",.06,"E")_$C(13)_$C(10)
 S II=II+1,@DATA@(II)="  *Scope: "_$$GET1^DIQ(90680.01,PIP_",",.07,"E")_$C(13)_$C(10)
 S II=II+1,@DATA@(II)="  *Status: "_$$GET1^DIQ(90680.01,PIP_",",.08,"E")_$C(13)_$C(10)
 S II=II+1,@DATA@(II)="  *Definitive EDD: "_$$FMTE^BJPNPRL($$GET1^DIQ(90680.01,PIP_",",.09,"I"))_$C(13)_$C(10)
 S II=II+1,@DATA@(II)="  *Current Note: "_$$GET1^DIQ(90680.01,PIP_",",3,"E")_$C(13)_$C(10)
 S II=II+1,@DATA@(II)=$C(13)_$C(10)
 S II=II+1,@DATA@(II)="PROBLEM HISTORY"_$C(13)_$C(10)
 S II=II+1,@DATA@(II)=$C(13)_$C(10)
 ;
 ;Loop through results and format
 NEW VDT
 S VDT="" F  S VDT=$O(@TMP@(VDT),-1) Q:VDT=""  D
 . NEW REC
 . S REC="" F  S REC=$O(@TMP@(VDT,REC)) Q:REC=""  D
 .. S II=II+1,@DATA@(II)=@TMP@(VDT,REC)_$C(13)_$C(10)
 S II=II+1,@DATA@(II)=$C(30)
 ;
XDET K @TMP
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
VALUE(VFIEN,ATYP,AVAL) ;EP - Retrieve field value
 ;
 I $G(VFIEN)="" Q ""
 I $G(ATYP)="" Q ""
 I $G(AVAL)="" Q ""
 ;
 S VALUE=""
 ;
 ;Audit Header
 I ATYP="C" Q AVAL
 ;
 ;SNOMED Term
 I AVAL=".12" D  Q VALUE
 . NEW PKIEN,TERM
 . S PKIEN=$$GET1^DIQ(9000010.43,VFIEN_",",.12,"I") Q:PKIEN=""
 . S VALUE="  *Set SNOMED Term to: "_$$GET1^DIQ(90680.02,PKIEN_",",.02,"E")
 ;
 ;Used as POV
 I AVAL=".05" D  Q VALUE
 . NEW POV
 . S POV=$$GET1^DIQ(9000010.43,VFIEN_",",.05,"E")
 . S VALUE="  *Set As POV set to: "_$S(POV]"":POV,1:"No")
 ;
 ;Priority
 I AVAL=".06" D  Q VALUE
 . NEW PRI
 . S PRI=$$GET1^DIQ(9000010.43,VFIEN_",",.06,"E")
 . S VALUE="  *Priority set to: "_$S(PRI]"":PRI,1:"<Not Set>")
 ;
 ;Provider Text
 I AVAL=".07" D  Q VALUE
 . NEW PTX
 . S PTX=$$GET1^DIQ(9000010.43,VFIEN_",",.07,"E")
 . S VALUE="  *Provider Text set to: "_$S(PTX]"":PTX,1:"<Not Set>")
 ;
 ;Scope
 I AVAL=".08" D  Q VALUE
 . NEW SCO
 . S SCO=$$GET1^DIQ(9000010.43,VFIEN_",",.08,"E")
 . S VALUE="  *Scope set to: "_$S(SCO]"":SCO,1:"<Not Set>")
 ;
 ;Status
 I AVAL=".09" D  Q VALUE
 . NEW STS
 . S STS=$$GET1^DIQ(9000010.43,VFIEN_",",.09,"E")
 . S VALUE="  *Status set to: "_$S(STS]"":STS,1:"<Not Set>")
 ;
 ;DEDD
 I AVAL=".1" D  Q VALUE
 . NEW DEDD
 . S DEDD=$$GET1^DIQ(9000010.43,VFIEN_",",.1,"E")
 . S VALUE="  *Definitive EDD set to: "_$S(DEDD]"":DEDD,1:"<Not Set>")
 ;
 ;Provider Narrative
 I AVAL=".11" D  Q VALUE
 . NEW PNAR
 . S PNAR=$$GET1^DIQ(9000010.43,VFIEN_",",.11,"E")
 . S VALUE="  *Provider Narrative set to: "_$S(PNAR]"":PNAR,1:"<Not Set>")
 ;
 ;Original Entry Date
 I AVAL="1216" D  Q VALUE
 . NEW OEDT
 . S OEDT=$$GET1^DIQ(9000010.43,VFIEN_",",1216,"I")
 . S OEDT=$$FMTE^BJPNPRL(OEDT)
 . S VALUE="  *Original Entry Date: "_OEDT
 ;
 ;Original Entered By
 I AVAL="1217" D  Q VALUE
 . NEW OEBY
 . S OEBY=$$GET1^DIQ(9000010.43,VFIEN_",",1217,"E")
 . S VALUE="  *Original Entered By: "_OEBY
 ;
 ;Last Modified Dt
 I AVAL="1218" D  Q VALUE
 . NEW LMDT
 . S LMDT=$$GET1^DIQ(9000010.43,VFIEN_",",1218,"I")
 . S LMDT=$$FMTE^BJPNPRL(LMDT)
 . S VALUE="  *Entry Modified On: "_LMDT
 ;
 ;Last Modified By
 I AVAL="1219" D  Q VALUE
 . NEW LMBY
 . S LMBY=$$GET1^DIQ(9000010.43,VFIEN_",",1219,"E")
 . S VALUE="  *Entry Modified By: "_LMBY
 ;
 ;Problem Deleted By
 I AVAL="2.01" D  Q VALUE
 . NEW PDBY
 . S PDBY=$$GET1^DIQ(9000010.43,VFIEN_",",2.01,"E")
 . S VALUE="  *Problem Deleted By: "_$S(PDBY]"":PDBY,1:"<Not Set>")
 ;
 I AVAL="2.02" D  Q VALUE
 . NEW PDDT
 . S PDDT=$$GET1^DIQ(9000010.43,VFIEN_",",2.02,"I")
 . S PDDT=$$FMTE^BJPNPRL(PDDT)
 . S VALUE="  *Problem Deleted On: "_$S(PDDT]"":PDDT,1:"<Not Set>")
 ;
 ;Delete Code
 I AVAL="2.03" D  Q VALUE
 . NEW DCOD
 . S DCOD=$$GET1^DIQ(9000010.43,VFIEN_",",2.03,"E")
 . S VALUE="  *Problem Delete Reason: "_$S(DCOD]"":DCOD,1:"<Not Set>")
 ;
 ;Delete Reason
 I AVAL="2.04" D  Q VALUE
 . NEW DRSN
 . S DRSN=$$GET1^DIQ(9000010.43,VFIEN_",",2.04,"E")
 . S VALUE="  *Problem Delete Reason: "_$S(DRSN]"":DRSN,1:"<Not Set>")
 ;
 ;Problem Note Additions
 I $P(AVAL,":")=2100,$P(AVAL,":",4)'="D" D  Q VALUE
 . NEW NOTE,DA,IENS
 . S DA(1)=VFIEN,DA=$P(AVAL,":",2),IENS=$$IENS^DILF(.DA)
 . S VALUE=$$GET1^DIQ(9000010.431,IENS,.01,"E")
 . S:VALUE]"" VALUE="  *Note Added: "_VALUE
 ;
 ;Problem Note Deletions
 I $P(AVAL,":")=2100,$P(AVAL,":",4)="D" D  Q VALUE
 . NEW NOTE,DA,IENS,VAL
 . S VALUE=""
 . S DA(1)=$P(AVAL,":",2),DA=$P(AVAL,":",3),IENS=$$IENS^DILF(.DA)
 . S VAL=$$GET1^DIQ(9000010.431,IENS,.01,"E")
 . S:VAL]"" VALUE="  *Note Deleted: "_VAL
 . ;
 . ;Deleted On
 . S VAL=$$FMTE^BJPNPRL($$GET1^DIQ(9000010.431,IENS,2.02,"I"))
 . S:VAL]"" VALUE=VALUE_$S(VALUE]"":$C(28),1:"")_"  *Note Deleted On: "_VAL
 . ;
 . ;Deleted By
 . S VAL=$$GET1^DIQ(9000010.431,IENS,2.01,"E")
 . S:VAL]"" VALUE=VALUE_$S(VALUE]"":$C(28),1:"")_"  *Note Deleted By: "_VAL
 . ;
 . ;Delete Code
 . S VAL=$$GET1^DIQ(9000010.431,IENS,2.03,"E")
 . S:VAL]"" VALUE=VALUE_$S(VALUE]"":$C(28),1:"")_"  *Note Deletion Code: "_VAL
 . ;
 . ;Delete Reason
 . S VAL=$$GET1^DIQ(9000010.431,IENS,2.04,"E")
 . S:VAL]"" VALUE=VALUE_$S(VALUE]"":$C(28),1:"")_"  *Note Deletion Reason: "_VAL
 ;
 Q AVAL
 ;
EDIT(DATA,DFN) ;EP - BJPN CAN EDIT PIP
 ;
 ;This RPC returns whether the PIP can be edited
 ;
 ;Input:
 ; DFN - Patient IEN
 ;
 NEW UID,II,KEY,RET,X1,X2,X
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPDET",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPDET D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define Header
 S @DATA@(II)="T00001CAN_EDIT^T00100VIEW_ONLY_REASON"_$C(30)
 ;
 ;Key Check
 S KEY=0 D
 . I $$HASKEY^CIAVCXUS("ORES",DUZ) S KEY=1 Q
 . I $$HASKEY^CIAVCXUS("PROVIDER",DUZ) S KEY=1 Q
 . I $$HASKEY^CIAVCXUS("ORELSE",DUZ) S KEY=1 Q
 . I $$HASKEY^CIAVCXUS("BGOZ PROBLEM LIST EDIT",DUZ) S KEY=1 Q
 . I $$HASKEY^CIAVCXUS("BGOZ VIEW ONLY",DUZ) S KEY=1
 I KEY=0 S II=II+1,@DATA@(II)="1^USER DOES NOT HOLD THE APPROPRIATE KEY(S) TO VIEW/EDIT"_$C(30) G XEDIT
 ;
 ;Parameter check
 I $$HASKEY^CIAVCXUS("@BJPN DISABLE PRENATAL EDITING",DUZ) D  G XEDIT
 . S II=II+1,@DATA@(II)="3^USER OR USER CLASS FOUND IN BJPN DISABLE PRENATAL EDITING"_$C(30)
 ;
 ;BGOZ VIEW ONLY key check
 I $$HASKEY^CIAVCXUS("BGOZ VIEW ONLY",DUZ) S II=II+1,@DATA@(II)="2^USER HOLDS THE BGOZ VIEW ONLY KEY"_$C(30) G XEDIT
 ;
 ;Definitive EDD checks
 ;
 S DEDD=$$DEDD(DFN)
 S:DEDD="" DEDD=$$GET1^DIQ(9000017,DFN_",",1311,"I")
 I DEDD="" D  G XEDIT
 . S II=II+1,@DATA@(II)="4^NO CURRENT OR PAST DEFINITIVE EDD FOUND"_$C(30)
 ;
 ;Definitive EDD date range check
 D GETPAR^CIAVMRPC(.RET,"BJPN POST DEDD DAYS","SYS",1,"I","")
 ;
 ;If blank default to 70
 I +RET<1 S RET=70
 ;
 ;Check range
 S X1=DEDD,X2=-280 D C^%DTC
 I DEDD>0,DT<X S II=II+1,@DATA@(II)="5^TODAYS DATE IS EARLIER THAN ALLOWABLE EDIT RANGE"_$C(30) G XEDIT
 S X1=DEDD,X2=RET D C^%DTC
 I DEDD>0,DT>X S II=II+1,@DATA@(II)="6^TODAYS DATE IS GREATER THAN ALLOWABLE POST RANGE"_$C(30) G XEDIT
 ;
 S II=II+1,@DATA@(II)="0^"_$C(30)
 ;
XEDIT S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
DEDD(DFN) ;EP - Return Last Definitive EDD
 ;
 NEW PIPIEN,DEDD
 ;
 I $G(DFN)="" Q ""
 ;
 ;Loop through problems and find last DEDD
 S (DEDD,PIPIEN)="" F  S PIPIEN=$O(^BJPNPL("D",DFN,PIPIEN)) Q:'PIPIEN  D  Q:DEDD
 . ;
 . ;Skip deletes
 . I $$GET1^DIQ(90680.01,PIPIEN_",",2.01,"I")]"" Q
 . ;
 . ;Pull DEDD
 . S DEDD=$$GET1^DIQ(90680.01,PIPIEN_",",.09,"I")
 Q DEDD
 ;
FIREEV(DATA,TYPE,STUB,LST,AID,XUSER) ;EP - BJPN FIRE EHR EVENT
 ;
 ;This RPC will fire the passed event in EHR
 ;
 ;Input:
 ; TYPE - Event Type to Broadcast (ex. PCC.<dfn>.PIP)
 ; STUB - Event Stub (optional)
 ; LST  - Recipient List (optional)
 ; AID  - Application ID (optional)
 ; XUSER - If 1, do not include user in event fire
 ;
 NEW UID,II,TOT
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPDET",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S TYPE=$G(TYPE),STUB=$G(STUB),AID=$G(AID),XUSER=$G(XUSER)
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPDET D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define Header
 S @DATA@(II)="I00100EVENTS_FIRED"_$C(30)
 ;
 ;Verify type
 I TYPE="" S II=II+1,@DATA@(II)="0"_$C(30) G XEV
 ;
 ;Check if Excluding Current User
 I XUSER D
 . NEW SUB,Z,DZ
 . D GETSUBSC^CIANBEVT(.SUB,TYPE)
 . F Z=0:0 S Z=$O(@SUB@(Z)) Q:'Z  D
 .. S DZ=$P($G(@SUB@(Z)),U,4)
 .. K @SUB@(Z)
 .. I DZ=DUZ Q
 .. S:DZ]"" LST("DUZ",DZ)=""
 ;
 ;Return Events Fired
 S TOT=$$BRDCAST^CIANBEVT(TYPE,STUB,.LST,AID)
 S II=II+1,@DATA@(II)=TOT_$C(30)
 ;
XEV S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
AUTHORCK(DATA,PIPIEN,VIEN) ;EP - BJPN CHECK VISIT NOTE AUTHOR
 ;
 ;This RPC returns whether the given user is the author of all notes
 ;for a problem for a visit
 ;
 ;Input:
 ; PIPIEN - Pointer to Prenatal Problem file entry
 ; VIEN - The visit IEN
 ;
 ;Output:
 ; 1 - User is the author of all the specific problem notes for a visit
 ; 0 - User is not the author of all the notes for a problem for a visit
 ;
 S PIPIEN=$G(PIPIEN,""),VIEN=$G(VIEN,"")
 I PIPIEN="" S BMXSEC="INVALID PIP VALUE" Q
 I VIEN=""  S BMXSEC="INVALID VIEN" Q
 ;
 NEW UID,II,DFN,CNT,RESULT
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPDET",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 ;S TMP=$NA(^TMP("BJPNPDET",UID))
 ;K @TMP
 ;
 S II=0,RESULT=1
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPDET D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Header
 S @DATA@(II)="T00001NOTE_AUTHOR"_$C(30)
 ;
 ;Retrieve DFN
 S DFN=$$GET1^DIQ(90680.01,PIPIEN_",",.02,"I") I DFN="" S BMXSEC="INVALID PIPIEN/DFN" Q
 ;
 D NOTES^BJPNPRL("",DFN,PIPIEN,1)
 ;
 ;Loop through and check each note for visit
 S CNT=0 F  S CNT=$O(^TMP("BJPNPRL",$J,CNT)) Q:CNT=""  D
 . NEW NODE,NVIEN,USER
 . S NODE=^TMP("BJPNPRL",$J,CNT)
 . S NVIEN=$P(NODE,U,4) I VIEN'=NVIEN Q
 . S USER=$TR($P(NODE,U,10),$C(30)) I USER=DUZ Q
 . S RESULT=0
 S II=II+1,@DATA@(II)=RESULT_$C(30)
 ;
 ;Cleanup
 K ^TMP("BJPNPRL",$J)
 ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
DVNOTES(DATA,PIPIEN,VIEN,DCODE,DRSN) ;EP - BJPN DEL PRB VST NOTES
 ;
 ;This RPC deletes all notes entered for a particular visit for
 ;a specific prenatal problem
 ;
 ;Input:
 ; PIPIEN - Pointer to Prenatal Problem file entry
 ;   VIEN - The visit IEN
 ;  DCODE - Delete Code
 ;   DRSN - Delete Reason
 ;
 ;Output:
 ; 1 - Notes deleted successfully
 ; 0 - Note deletion failed
 ;
 S PIPIEN=$G(PIPIEN,""),VIEN=$G(VIEN,"")
 I PIPIEN="" S BMXSEC="INVALID PIP VALUE" Q
 I VIEN=""  S BMXSEC="INVALID VIEN" Q
 S DCODE=$G(DCODE,"")
 S DRSN=$G(DRSN,"")
 ;
 NEW UID,II,DFN,CNT,RESULT,NOTES
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPDET",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 ;S TMP=$NA(^TMP("BJPNPDET",UID))
 ;K @TMP
 ;
 S II=0,RESULT=1
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPDET D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Header
 S @DATA@(II)="T00001SUCCESS"_$C(30)
 ;
 ;Retrieve DFN
 S DFN=$$GET1^DIQ(90680.01,PIPIEN_",",.02,"I") I DFN="" S BMXSEC="INVALID PIPIEN/DFN" Q
 ;
 D NOTES^BJPNPRL("",DFN,PIPIEN,1)
 ;
 ;Move to local (delete call wipes out results)
 M NOTES=^TMP("BJPNPRL",$J)
 ;
 ;Loop through and delete each note for visit
 S CNT=0 F  S CNT=$O(NOTES(CNT)) Q:CNT=""  D
 . NEW NODE,NVIEN,VFIEN,VNIEN
 . S NODE=NOTES(CNT)
 . S NVIEN=$P(NODE,U,4) I VIEN'=NVIEN Q
 . S VFIEN=$P(NODE,U,2)
 . S VNIEN=$P(NODE,U,3)
 . ;
 . ;Delete each note
 . D DEL^BJPNPUP(DATA,VIEN,VFIEN,VNIEN,DCODE,DRSN) ;BJPN DELETE PRB NOTE
 ;
 S II=II+1,@DATA@(II)=RESULT_$C(30)
 ;
 ;Cleanup
 K ^TMP("BJPNPRL",$J)
 ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S II=II+1,@DATA@(II)=$C(31)
 Q
