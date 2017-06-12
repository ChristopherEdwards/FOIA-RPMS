BJPNGNOT ;GDIT/HS/BEE-Prenatal Care Module Get Note Detail for PIP ; 08 May 2012  12:00 PM
 ;;2.0;PRENATAL CARE MODULE;**4,8**;Feb 24, 2015;Build 25
 ;
 Q
 ;
NOTES(DATA,DFN,PR,API,TYPE,NOCMP,VIEN) ;EP - BJPN GET PROB NOTES
 ;
 ;Get BJPN CARE PLANS, GOALS, VISIT INSTRUCTIONS
 ;
 ;This RPC returns notes entered for problems on the PIP
 ;
 ;Input:  DFN - Patient IEN
 ;         PR - Problem IEN(s)
 ;        API - 1 if called from an API (Optional)
 ;       TYPE - (C) Care Plans, (G) Goals, (I) Visit Instructions, 
 ;              (O) OB Notes, (T) Treatment Plan/Education, null for All
 ;      NOCMP - (1) Do not recompile data (called by PIP call)
 ;       VIEN - If passed in, limit visit instructions returned to that visit
 ;
 S DFN=$G(DFN),PR=$G(PR),API=$G(API),TYPE=$G(TYPE),NOCMP=$G(NOCMP)
 I TYPE'="",TYPE'="C",TYPE'="G",TYPE'="I",TYPE'="T",TYPE'="O" S BMXSEC="Invalid TYPE value" Q
 ;
 NEW UID,II,PIPIEN,SORT,PC,PARY,NEDT,TMP,SIGN,LTYPE,C8,C9
 S UID=$S(API=1:$J,$G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNGNOT",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 S VIEN=$G(VIEN)
 ;
 ;Define delimiters
 S C8=$C(28),C9=$C(29)
 ;
 ;Assemble TYPE list
 S LTYPE=$S(TYPE="":"GCIOT",1:TYPE) S:LTYPE["T" LTYPE=LTYPE_"E"
 ;
 ;Assemble Problem List Array
 I $G(PR)]"" F II=1:1:$L(PR,$C(28)) S PC=$P(PR,$C(28),II) I PC]"" S PARY(PC)=""
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPRL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define Header
 S @DATA@(II)="I00010PIPIEN^I00010PRBIEN^T00001PREGNANT^T04096NOTES"_$C(30)
 ;
 ;Verify DFN
 I DFN="" G XNOTES
 ;
 ;Definitive EDD date range check
 D GETPAR^CIAVMRPC(.NEDT,"BJPN POST DEDD DAYS","SYS",1,"I","")
 ;
 ;If blank default to 70
 I +$G(NEDT)<1 S NEDT=70
 ;
 ;Call EHR API and format results into usable data - skip if flag and already compiled
 S TMP=$NA(^TMP("BJPNIPL",UID))  ;Define compiled data reference
 I '$G(NOCMP)!($O(@TMP@(""))="") D COMP^BJPNUTIL(DFN,UID)
 ;
 ;Array(n)=Type (G OR C) [1] ^ C Plan IEN [2] ^ Prob IEN [4] ^ Who entered [4] ^ Date Entered [5] ^ Status [6] ^ SIGN FLAG [7]
 ;  =~t [1] ^ Text of the item [2]
 ;Array(n)="I" [1] ^ Instr IEN[2] ^ Prob IEN [3] ^ Vst Date [4] ^ Facility [5] ^ Prv IEN [6] ^ Location [7] ^ Entered Dt [8] ^ Visit IEN [9] ^V cat [10] ^ Locked [11] ^ Prov Name [12] ^ signed [13]
 ;  =~t [1] ^Text of the item [2]
 ;Array(n)="O" [1] ^ Instr IEN[2] ^ Prob IEN [3] ^ Vst Date [4] ^ Facility [5] ^ Prv IEN [6] ^ Location [7] ^ Entered Dt [8] ^ Visit IEN [9] ^V cat [10] ^ Locked [11] ^ Prov Name [12] ^ signed [13]
 ;  =~t [1] ^Text of the item [2]
 ;Array(n)="T" [1] ^ TR IEN[2] ^ SNOMED term [3] ^ Prob IEN  [4] ^ Vst Date [5] ^ Facility [6] ^ Prv IEN [7] ^ Location [8] ^ Entered Dt [9] ^ Visit IEN [10] ^ V Cat [11] ^Locked [12] ^ Prov name [13]
 ;Array(n)="E" [1] ^ Topic [2] ^ Date [3]
 ;
 ;Loop through problem list and pull goals and care plans
 S PIPIEN="" F  S PIPIEN=$O(^BJPNPL("D",DFN,PIPIEN)) Q:PIPIEN=""  D
 . ;
 . ;Only include selected problems
 . I $D(PARY),'$D(PARY(PIPIEN)) Q
 . ;
 . NEW CNT,MDT,BGO,PRBIEN,ITYPE,TYPE,NOTES,DEL
 . ;
 . ;Get IPL pointer
 . S PRBIEN=$$GET1^DIQ(90680.01,PIPIEN_",",".1","I") Q:PRBIEN=""
 . ;
 . ;Skip deletes
 . S DEL=$$GET1^DIQ(90680.01,PIPIEN_",",2.01,"I") Q:DEL]""  ;PIP Delete
 . S DEL=$$GET1^DIQ(9000011,PRBIEN_",",2.02,"I") I DEL]"" D  Q  ;IPL Delete
 .. ;
 .. ;If deleted on IPL, need to delete in PIP
 .. NEW BJPNUPD,ERROR
 .. S BJPNUPD(90680.01,PIPIEN_",",2.01)=$$GET1^DIQ(9000011,PRBIEN_",",2.01,"I") ;Deleted By
 .. S BJPNUPD(90680.01,PIPIEN_",",2.02)=$$GET1^DIQ(9000011,PRBIEN_",",2.02,"I") ;Del Dt/Tm
 .. S BJPNUPD(90680.01,PIPIEN_",",2.03)=$$GET1^DIQ(9000011,PRBIEN_",",2.03,"I") ;Del Rsn
 .. S BJPNUPD(90680.01,PIPIEN_",",2.04)=$$GET1^DIQ(9000011,PRBIEN_",",2.04,"I") ;Del Other
 .. D FILE^DIE("","BJPNUPD","ERROR")
 . ; 
 . ;Reset Array variable
 . S NOTES=""
 . ;
 . ;Loop through by each TYPE
 . F ITYPE=1:1:$L(LTYPE) S TYPE=$E(LTYPE,ITYPE) D
 .. ;Loop through compiled results for type
 .. S BGO="" F  S BGO=$O(@TMP@(TYPE,PRBIEN,BGO),-1) Q:BGO=""  D
 ... ;
 ... NEW APIRES,VISIT,DEDD,BRNG,ERNG,NIEN,X1,X2,X,VDT
 ... NEW DTTM,MDBY,ILMBY,NOTE,NSTS,SIGN,ACT
 ... ;
 ... S SIGN=""
 ... S APIRES=$G(@TMP@(TYPE,PRBIEN,BGO,0)) Q:APIRES=""
 ... ;
 ... ;Pull Visit - If V VISIT INSTRUCTIONS/V OB (GOALS and CARE PLANS are not visit driven)
 ... S (VISIT,VDT)=""
 ... I (TYPE="I")!(TYPE="O") S VISIT=$P(APIRES,U,9),VDT=$P(APIRES,U,4)
 ... S:TYPE="T" VISIT=$P(APIRES,U,10),VDT=$P(APIRES,U,5)
 ... I TYPE="E" D
 .... NEW VEDIEN
 .... S VEDIEN=$P(APIRES,U,6) Q:VEDIEN=""
 .... S VISIT=$$GET1^DIQ(9000010.16,VEDIEN_",",.03,"I")
 .... S VDT=$$GET1^DIQ(9000010,VISIT,.01,"I")
 ... ;
 ... ;Filter on visit
 ... ;BJPN*2.0*4;Do not filter on visit
 ... ;I ((TYPE="I")!(TYPE="T")!(TYPE="E")),VIEN]"",VIEN'=VISIT Q
 ... ;
 ... ;Note IEN (Pointer to entry)
 ... I TYPE'="E" S NIEN=$P(APIRES,U,2)
 ... E  S NIEN=$P(APIRES,U,6)
 ... Q:NIEN=""
 ... ;
 ... ;Pull Definitive EDD
 ... S DEDD=$$GET1^DIQ(90680.01,PIPIEN_",",.09,"I")
 ... S X1=DEDD,X2=-280 D C^%DTC S BRNG=X
 ... S X1=DEDD,X2=NEDT D C^%DTC S ERNG=X
 ... ;
 ... ;Get note date/time entered and by - V VISIT INSTRUCTIONS
 ... S (DTTM,ILMBY)=""
 ... I TYPE="I" D
 .... S DTTM=$$GET1^DIQ(9000010.58,NIEN_",",1216,"I")
 .... S ILMBY=$$GET1^DIQ(9000010.58,NIEN_",",1217,"I")
 .... S SIGN=$P(APIRES,U,13)
 ... ;
 ... ;Get note date/time entered and by - V OB
 ... I TYPE="O" D
 .... S DTTM=$$GET1^DIQ(9000010.43,NIEN_",",1216,"I")
 .... S ILMBY=$$GET1^DIQ(9000010.43,NIEN_",",1217,"I")
 .... S SIGN=$P(APIRES,U,13)
 ... ;
 ... ;Get note date/time entered and by - CARE PLAN
 ... I TYPE'="I",TYPE'="O",TYPE'="T",TYPE'="E" D
 .... NEW IENS,DA
 .... S DA=$O(^AUPNCPL(NIEN,11,"B","A",""),-1) Q:DA=""
 .... S DA(1)=NIEN,IENS=$$IENS^DILF(.DA)
 .... S DTTM=$$GET1^DIQ(9000092.11,IENS,".03","I")
 .... S ILMBY=$$GET1^DIQ(9000092.11,IENS,".02","I")
 .... S SIGN=$P(APIRES,U,7)
 ... ;
 ... ;Get treatment plan date/time and by - V TREATMENT/REGIMEN
 ... I TYPE="T" D
 .... S DTTM=$$GET1^DIQ(9000010.61,NIEN_",",1216,"I")
 .... S ILMBY=$$GET1^DIQ(9000010.61,NIEN_",",1217,"I")
 ... ;
 ... ;Get education plan date/time and by - V PATIENT ED
 ... I TYPE="E" D
 .... S DTTM=$$GET1^DIQ(9000010.16,NIEN_",",1216,"I")
 .... S ILMBY=$$GET1^DIQ(9000010.16,NIEN_",",1217,"I")
 ... ;
 ... Q:DTTM=""
 ... S MDBY=$$GET1^DIQ(200,ILMBY_",",".01","E")
 ... ;
 ... ;Get Note
 ... I TYPE="T" S NOTE=$P($G(@TMP@(TYPE,PRBIEN,BGO,0)),U,14)
 ... E  I TYPE="E" S NOTE=$P(APIRES,U,2)
 ... E  D
 .... S NOTE=""
 .... NEW NIEN
 .... S NIEN=0 F  S NIEN=$O(@TMP@(TYPE,PRBIEN,BGO,NIEN)) Q:NIEN=""  D
 ..... NEW NNT,L
 ..... S NNT=$P($G(@TMP@(TYPE,PRBIEN,BGO,NIEN)),U,2)
 ..... S L=$E(NOTE,$L(NOTE))
 ..... S NOTE=NOTE_$S(NOTE]"":$C(13)_$C(10),1:"")_NNT
 ... Q:NOTE=""
 ... ;
 ... ;Note Status
 ... S NSTS="A"
 ... I DEDD]"",DTTM'<BRNG,DTTM'>ERNG S NSTS="C"
 ... I ((TYPE="G")!(TYPE="C")),$P(APIRES,U,6)="A" S NSTS="C"
 ... ;
 ... ;Set Inactive Goals/Care Plans
 ... S ACT=""
 ... I ((TYPE="G")!(TYPE="C")),$P(APIRES,U,6)'="A" S ACT="(i) ",NSTS="A"
 ... ;
 ... ;Determined signed/unsigned
 ... S SIGN=$S(TYPE="T":"",SIGN]"":"S",1:"U")
 ... ;
 ... ;Set up record
 ... S NOTES=NOTES_$S(NOTES]"":C8,1:"")_$S(TYPE="E":"T",1:TYPE)_C9_NIEN_C9_VISIT_C9_VDT_C9_NSTS_C9_$$FMTE^BJPNPRL($P(DTTM,"."),"5ZD")_C9_MDBY_C9_ACT_NOTE_C9_ILMBY_C9_SIGN
 . ;
 . ;Log entry
 . S II=II+1,@DATA@(II)=PIPIEN_U_PRBIEN_U_U_NOTES_$C(30)
 ;
XNOTES S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
SCHK(DATA,PRIEN,EXCVIEN) ;EP - BJPN CHECK PRB STATUS
 ;
 ;This RPC accepts an IPL problem IEN and returns whether the scope can be changed.
 ;The scope can only be changed to prior if there is no VI, OB, TR, ED for the current
 ;pregnancy.
 ;
 ;Input:  PRIEN - Problem IEN
 ;       EXCVIEN - Exclude VIEN in POV check
 ;
 NEW UID,II,DEL,CSCP,CDEL,DFN,TMP,BGO,API,GGO,CGO,CPGSTS,NEDT,BRNG,ERNG,DEDD
 NEW VGO,VOB,VTR,VED,VTYPE,APIRES,PIPIEN,X,SIEN,STATUS,RET,NIEN,PIEN
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNGNOT",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNGNOT D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Verify PRIEN was entered
 I $G(PRIEN)="" G XSCHK
 S EXCVIEN=$G(EXCVIEN)
 ;
 S DFN=$$GET1^DIQ(9000011,PRIEN_",",.02,"I")
 ;
 ;Preset to yes
 S CSCP="Y",CDEL="Y^"
 ;Set up Header
 S @DATA@(II)="T00001ALLOW_PRIOR^T00001CAN_DELETE^T01024CANNOT_DELETE_REASON"_$C(30)
 ;
 ;Check if problem deleted
 S DEL=$$GET1^DIQ(9000011,PRIEN_",",2.02,"I") I DEL]"" S II=II+1,@DATA@(II)="^^Problem has already been deleted"_$C(30) G XSCHK
 ;
 ;Definitive EDD date range check
 D GETPAR^CIAVMRPC(.NEDT,"BJPN POST DEDD DAYS","SYS",1,"I","")
 ;
 ;If blank default to 70
 I +$G(NEDT)<1 S NEDT=70
 ;
 ;Pull the PIPIEN and DEDD, Pregnancy Window
 S (DEDD,BRNG,ERNG,PIPIEN)=""
 S PIEN="" F  S PIEN=$O(^BJPNPL("E",PRIEN,PIEN),-1) Q:PIEN=""  D  I PIPIEN]"" Q
 . Q:$$GET1^DIQ(90680.01,PIEN_",",2.01,"I")]""  ;Exclude deletes
 . S PIPIEN=PIEN
 ;
 I PIPIEN]"" D
 . NEW X1,X2,X
 . S DEDD=$$GET1^DIQ(90680.01,PIPIEN_",",.09,"I")
 . S X1=DEDD,X2=-280 D C^%DTC S BRNG=X
 . S X1=DEDD,X2=NEDT D C^%DTC S ERNG=X
 ;
 ;The following code was adapted from CHK^BGOPROB2. Rather than make that call it was placed here
 ;so that extra code could be inserted to check for VI/OB in the pregnancy window
 ;
 ;CHK(RET,PRIEN) ;Check to see if it is OK to delete a problem
 ;Check and see if there are any V Care Plan entries for this problem
 ;If there are, the problem cannot be deleted Patch 13&14
 S RET=1
 I +$O(^AUPNPROB(+PRIEN,14,"B",0))!(+$O(^AUPNPROB(+PRIEN,15,"B",0))) D
 . NEW PTTYP
 . ;
 . S CDEL="^Problem has been used for a visit and cannot be deleted. Check Problem Details.",RET=-1
 . ;
 . F PTTYP=14,15 D  Q:CSCP=""
 .. NEW VIEN
 .. ;
 .. ;Loop through visits on problem for I/O types
 .. S VIEN="" F  S VIEN=$O(^AUPNPROB(+PRIEN,PTTYP,"B",VIEN)) Q:VIEN=""  D  I CSCP="" Q
 ... ;
 ... ;Filter out visit if it was just unchecked
 ... I EXCVIEN>0,EXCVIEN=VIEN Q
 ... ;
 ... NEW NSTS,DTTM
 ... ;Check if POV in pregnancy window
 ... S NSTS="A"
 ... S DTTM=$$GET1^DIQ(9000010,VIEN,".01","I")
 ... I DEDD]"",DTTM'<BRNG,DTTM'>ERNG S NSTS="C"
 ... I NSTS="C" S CSCP=""
 ;
 ;Look for care plan or Goal
 S X=0 I RET=1 F  S X=$O(^AUPNCPL("B",+PRIEN,X)) Q:X=""!(+RET<0)  D
 . S SIEN=$C(0) S SIEN=$O(^AUPNCPL(X,11,SIEN),-1)
 . S STATUS=$P($G(^AUPNCPL(X,11,SIEN,0)),U,1)
 . I STATUS'="E" S CDEL="^Care Plan entries are stored. Check Problem Details. Problem cannot be deleted",RET=-1
 ;
 ;Look for visit instructions
 S NIEN=0 F  S NIEN=$O(^AUPNVVI("B",+PRIEN,NIEN)) Q:NIEN=""!(CSCP="")  D
 . NEW NSTS,DTTM
 . I $$GET1^DIQ(9000010.58,X,.06,"I")=1 Q
 . I RET=1 S CDEL="^Visit instructions are stored. Check Problem Details. Problem cannot be deleted",RET=-1
 . ;
 . S NSTS="A"
 . S DTTM=$$GET1^DIQ(9000010.58,NIEN_",",1216,"I")
 . I DEDD]"",DTTM'<BRNG,DTTM'>ERNG S NSTS="C"
 . I NSTS="C" S CSCP=""
 ;
 ;Look for OB notes
 I CSCP="Y" S NIEN=0 F  S NIEN=$O(^AUPNVOB("B",+PRIEN,NIEN)) Q:NIEN=""!(CSCP="")  D
 . NEW NSTS,DTTM
 . I $$GET1^DIQ(9000010.43,NIEN,.06,"I")=1 Q
 . I RET=1 S CDEL="^OB notes are stored. Check Problem Details. Problem cannot be deleted",RET=-1
 . ;
 . S NSTS="A"
 . S DTTM=$$GET1^DIQ(9000010.43,NIEN_",",1216,"I")
 . I DEDD]"",DTTM'<BRNG,DTTM'>ERNG S NSTS="C"
 . I NSTS="C" S CSCP=""
 ;
 S II=II+1,@DATA@(II)=CSCP_U_CDEL_$C(30)
 ;
XSCHK S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
LVI(PRBIEN,TMP,VGO,BRNG,CDEL) ;Return latest visit instruction
 ;
 ;Since an instruction is on file, cannot delete
 S CDEL=""
 ;
 NEW INST,ND,BY,WHEN,NIEN,DTTM
 S INST=""
 S ND=$G(@TMP@("I",PRBIEN,VGO,0))
 S BY=$P(ND,U,12)
 S WHEN=$P(ND,U,8)
 S NIEN=$P(ND,U,2)
 S DTTM=$$GET1^DIQ(9000010.58,NIEN_",",1216,"I")
 I DTTM'<BRNG D
 . S INST=$P($G(@TMP@("I",PRBIEN,VGO,1)),U,2)
 . I INST]"",BY]"" S INST=INST_$C(13)_$C(10)_"Modified by: "_BY_" "_WHEN
 Q INST
 ;
LOB(PRBIEN,TMP,VOB,BRNG,CDEL) ;Return latest OB Note
 ;
 ;Since an OB is on file, cannot delete
 S CDEL=""
 ;
 NEW OB,ND,BY,WHEN,NIEN,DTTM
 S OB=""
 S ND=$G(@TMP@("O",PRBIEN,VOB,0))
 S BY=$P(ND,U,12)
 S WHEN=$P(ND,U,8)
 S NIEN=$P(ND,U,2)
 S DTTM=$$GET1^DIQ(9000010.43,NIEN_",",1216,"I")
 I DTTM'<BRNG D
 . S OB=$P($G(@TMP@("O",PRBIEN,VOB,1)),U,2)
 . I OB]"",BY]"" S OB=OB_$C(13)_$C(10)_"Modified by: "_BY_" "_WHEN
 Q OB
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S II=II+1,@DATA@(II)=$C(31)
 Q
