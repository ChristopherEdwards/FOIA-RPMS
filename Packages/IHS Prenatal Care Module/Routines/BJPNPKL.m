BJPNPKL ;GDIT/HS/BEE-Prenatal Care Module Pick List ; 08 May 2012  12:00 PM
 ;;2.0;PRENATAL CARE MODULE;**3,7**;Feb 24, 2015;Build 53
 ;
 Q
 ;
LST(DATA,FAKE) ;EP - BJPN GET PICK LISTS
 ;
 ;This RPC returns top level entries from the BGO SNOMED PREFERENCES file (#90362.34)
 ;
 NEW UID,II,IEN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPKL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPKL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S @DATA@(II)="I00010HIDDEN_PLIEN^T00030PICK_LISTS^T00001SET_POV"_$C(30)
 ;
 S IEN=0 F  S IEN=$O(^BGOSNOPR(IEN)) Q:'IEN  D
 . ;
 . NEW NAME,POV
 . ;
 . ;Only include PIP Pick Lists
 . I '$$GET1^DIQ(90362.34,IEN_",",".09","I") Q
 . ;
 . ;Skip if it doesn't have any entries
 . I '+$O(^BGOSNOPR(IEN,1,0)) Q
 . ;Name
 . S NAME=$$GET1^DIQ(90362.34,IEN_",",".01","E") Q:NAME=""
 . ;
 . ;Return whether to allow POV Set
 . S POV=$$GET1^DIQ(90362.34,IEN_",","1.1","I")
 . ;
 . S II=II+1,@DATA@(II)=IEN_U_NAME_U_POV_$C(30)
 ;
 S II=II+1,@DATA@(II)=$C(31)
 ;
 Q
 ;
SNO(DATA,DFN) ;EP - BJPN GET SNOMED TERMS
 ;
 ;This RPC returns entries from the BJPN SNOMED TERMS file (#90680.02)
 ;If the DFN is supplied, it returns whether the patient has that problem
 ;on their PIP
 ;
 ;Input: DFN (Optional) - Patient DFN
 ;
 S DFN=$G(DFN)
 ;
 NEW UID,II,PSTS,RFEDD,PREDD,ICD
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPRL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPKL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S @DATA@(II)="I00010HIDDEN_PKIEN^T00150SNOMED_TERM^T00250FULL_NAME^T00025CONCEPT_ID^T00001PIP^T00010ICD"_$C(30)
 ;
 S TRM="" F  S TRM=$O(^BJPN(90680.02,"C",TRM)) Q:TRM=""  D
 . S IEN="" F  S IEN=$O(^BJPN(90680.02,"C",TRM,IEN)) Q:IEN=""  D
 .. NEW TRM,FSPNM,CAT,CIEN,IENS,CONC,FREQ,PIP,PLIEN,ICIEN
 .. ;
 .. ;SNOMED TERM
 .. S TRM=$$GET1^DIQ(90680.02,IEN_",",.02,"E") Q:TRM=""
 .. ;
 .. ;FULLY SPECIFIED NAME
 .. S FSPNM=$$GET1^DIQ(90680.02,IEN_",",3,"E")
 .. ;
 .. ;CONCEPT ID
 .. S CONC=$$GET1^DIQ(90680.02,IEN_",",.07,"E") Q:CONC=""
 .. ;
 .. ;Code on Problem List
 .. S PIP="N"
 .. I DFN]"" S PLIEN="" F  S PLIEN=$O(^BJPNPL("AC",DFN,IEN,PLIEN)) Q:PLIEN=""  D
 ... NEW DEL
 ... I $$GET1^DIQ(90680.01,PLIEN_",",2.01,"I")]"" Q
 ... S PIP="Y"
 .. ;
 .. ;Pull the ICD-9
 .. S ICD=""
 .. S ICIEN=0 F  S ICIEN=$O(^BJPN(90680.02,IEN,1,ICIEN)) Q:'ICIEN  D
 ... ;
 ... NEW ICD9,ICDTP,DA,IENS
 ... S DA(1)=IEN,DA=ICIEN,IENS=$$IENS^DILF(.DA)
 ... S ICD9=$$GET1^DIQ(90680.21,IENS,.01,"E") Q:ICD9=""
 ... S ICDTP=$$GET1^DIQ(90680.21,IENS,.02,"I") I ICDTP'=1 Q
 ... S ICD=ICD_$S(ICD]"":";",1:"")_ICD9
 .. S:ICD="" ICD=".9999"
 .. ;
 .. S II=II+1,@DATA@(II)=IEN_U_TRM_U_FSPNM_U_CONC_U_PIP_U_ICD_$C(30)
 ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
PICK(DATA,PLIEN,DFN) ;EP - BJPN GET PICK LIST
 ;
 ;This RPC returns entries from the BGO SNOMED PREFERENCES file (#90362.34).
 ;It will return all SNOMED entries for a particular Pick List Entry.
 ;
 ;If the DFN is supplied, it returns whether the patient has that Concept ID
 ;
 ;Input: PLIEN (Optional) - Pick List IEN (Master if null)
 ;       DFN (Optional) - Patient DFN
 ;
 S DFN=$G(DFN)
 S PLIEN=$G(PLIEN)
 ;
 NEW UID,II,TRM,IEN,PRBLST
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPKL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 S II=0
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPKL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S @DATA@(II)="T00025DESC_ID^T00150SNOMED_TERM^T00250FULL_NAME^T00025CONCEPT_ID^I00010FREQ^T00010PIP^T00010ICD"
 S @DATA@(II)=@DATA@(II)_"^T00001DISABLE^T00020DEF_STS^T00001CLASS^T00040GROUP^T00001PROMPT_LATERALITY"_$C(30)
 ;
 ;First get a list of the current PIP items
 I DFN]"" D
 . NEW PRBIEN
 . S PRBIEN="" F  S PRBIEN=$O(^BJPNPL("F",DFN,PRBIEN)) Q:PRBIEN=""  D
 .. NEW BPIEN
 .. S BPIEN="" F  S BPIEN=$O(^BJPNPL("F",DFN,PRBIEN,BPIEN)) Q:BPIEN=""  D
 ... NEW DEL,CONCID,DESCID
 ... ;
 ... ;Skip deletes
 ... S DEL=$$GET1^DIQ(90680.01,BPIEN_",",2.01,"I") Q:DEL]""  ;PIP Delete
 ... S DEL=$$GET1^DIQ(9000011,PRBIEN_",",2.02,"I") I DEL]"" D  Q  ;IPL Delete
 .... ;
 .... ;If deleted on IPL, need to delete in PIP
 .... NEW BJPNUPD,ERROR
 .... S BJPNUPD(90680.01,BPIEN_",",2.01)=$$GET1^DIQ(9000011,PRBIEN_",",2.01,"I") ;Deleted By
 .... S BJPNUPD(90680.01,BPIEN_",",2.02)=$$GET1^DIQ(9000011,PRBIEN_",",2.02,"I") ;Del Dt/Tm
 .... S BJPNUPD(90680.01,BPIEN_",",2.03)=$$GET1^DIQ(9000011,PRBIEN_",",2.03,"I") ;Del Rsn
 .... S BJPNUPD(90680.01,BPIEN_",",2.04)=$$GET1^DIQ(9000011,PRBIEN_",",2.04,"I") ;Del Other
 .... D FILE^DIE("","BJPNUPD","ERROR")
 ... ;
 ... ;Get the IPL Concept ID and Description ID
 ... S CONCID=$$GET1^DIQ(9000011,PRBIEN_",",80001,"I") Q:CONCID=""
 ... S DESCID=$$GET1^DIQ(9000011,PRBIEN_",",80002,"I") Q:DESCID=""
 ... ;
 ... ;Save the problem entry into array
 ... S PRBLST(CONCID)=DESCID
 ;
 ;Process list passed in
 I +PLIEN D LIST(+PLIEN,.PK,0)
 ;
 ;Process all lists
 I 'PLIEN D
 . NEW PLIEN,PK
 . S PLIEN=0 F  S PLIEN=$O(^BGOSNOPR(PLIEN)) Q:'PLIEN  D
 .. ;
 .. ;Filter out non-PIP pick lists
 .. Q:'$$GET1^DIQ(90362.34,PLIEN_",",.09,"I")
 .. ;
 .. ;Assemble the list
 .. D LIST(+PLIEN,.PK,1)
 ;.. NEW CTIEN,SMDSTR
 ;.. S CTIEN=0 F  S CTIEN=$O(^BGOSNOPR(+PLIEN,1,CTIEN)) Q:'CTIEN  D
 ;... NEW CONCID,DESC,DESCTM,DA,IENS,FREQ,FNAME,ICD,PIP,DISABLE
 ;... S DA(1)=+PLIEN,DA=CTIEN,IENS=$$IENS^DILF(.DA)
 ;... S DESC=$$GET1^DIQ(90362.342,IENS,".02","I") Q:DESC=""
 ;... ;
 ;... ;Quit if already set
 ;... Q:$D(PK(DESC))
 ;... ;
 ;... S CONCID=$$GET1^DIQ(90362.342,IENS,".01","I") Q:CONCID=""
 ;... S DESCTM=$$GET1^DIQ(90362.342,IENS,"6","I") Q:DESCTM=""
 ;... S FREQ=$$GET1^DIQ(90362.342,IENS,".03","I") S:FREQ="" FREQ=0
 ;... S SMDSTR=$$CONC^BSTSAPI(CONCID_"^^"_DT_"^1")
 ;... S FNAME=$P(SMDSTR,U,2)
 ;... S ICD=$P(SMDSTR,U,5)
 ;... ;
 ;... ;Code on PIP?
 ;... S PIP="N",DISABLE=""
 ;... I DFN]"" D
 ;.... Q:'$D(PRBLST(CONCID))
 ;.... ;
 ;.... ;Mark as on PIP
 ;.... S PIP="Y"
 ;.... ;
 ;.... ;Disable if not the same synonym
 ;.... I DESC'=PRBLST(CONCID) S DISABLE="Y"
 ;... ;
 ;... ;Save the entry
 ;... S II=II+1,@DATA@(II)=DESC_U_DESCTM_U_FNAME_U_CONCID_U_FREQ_U_PIP_U_ICD_U_DISABLE_U_STS_U_CLASS_U_GROUP_U_LAT_$C(30)
 ;... ;
 ;... ;Flag entry so it will only be sent once
 ;... S PK(DESC)=""
 ;
XPICK S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
 ;Now loop through BGO SNOMED PREFERENCES file (#90362.34) for the picklist and return each entry
LIST(PLIEN,PK,ALL) ;
 NEW CTIEN
 S CTIEN=0 F  S CTIEN=$O(^BGOSNOPR(+PLIEN,1,CTIEN)) Q:'CTIEN  D
 . NEW CONCID,DESC,DESCTM,DA,IENS,FREQ,FNAME,ICD,PIP,DISABLE,STS,CLASS,GROUP,LAT,BGON0,BGON1,CSTS,CRSLT,IIEN
 . ;BJPN*2.0*7;Since picklists are so large avoid FileMan calls
 . ;S DA(1)=+PLIEN,DA=CTIEN,IENS=$$IENS^DILF(.DA)
 . ;S DESC=$$GET1^DIQ(90362.342,IENS,".02","I") Q:DESC=""
 . ;S CONCID=$$GET1^DIQ(90362.342,IENS,".01","I") Q:CONCID=""
 . ;S DESCTM=$$GET1^DIQ(90362.342,IENS,"6","I") Q:DESCTM=""
 . ;S FREQ=$$GET1^DIQ(90362.342,IENS,".03","I") S:FREQ="" FREQ=0
 . ;S SMDSTR=$$CONC^BSTSAPI(CONCID_"^^"_DT_"^1")
 . ;S FNAME=$P(SMDSTR,U,2)
 . ;S ICD=$P(SMDSTR,U,5)
 . S BGON0=$G(^BGOSNOPR(+PLIEN,1,CTIEN,0))
 . S BGON1=$G(^BGOSNOPR(+PLIEN,1,CTIEN,1))
 . S DESC=$P(BGON0,U,2) Q:DESC=""
 . S CONCID=$P(BGON0,U,1) Q:CONCID=""
 . S FREQ=$P(BGON0,U,3) S:FREQ="" FREQ=0
 . S GROUP=$P(BGON1,U,2)
 . ;
 . ;If show all do not use groups
 . I ALL S GROUP=""
 . ;
 . I ALL Q:$D(PK(DESC))
 . ;
 . ;Call BSTS to get needed information
 . S CSTS=$$DSCLKP^BSTSAPI("CRSLT",DESC)
 . ;
 . S FNAME=$G(CRSLT(1,"FSN","TRM")) ;FSN
 . S IIEN=0,ICD="" F  S IIEN=$O(CRSLT(1,"ICD",IIEN)) Q:'IIEN  S ICD=ICD_$S(ICD]"":";",1:"")_$G(CRSLT(1,"ICD",IIEN,"COD"))  ;ICD
 . S DESCTM=$G(CRSLT(1,"PRB","TRM"))
 . S LAT=$G(CRSLT(1,"LAT")),LAT=$S(LAT=1:"Y",1:"")
 . ;
 . ;Retrieve the default status
 . ;Cannot use FileMan to retrieve the information because of a bug in the code in the EHR Pick List
 . ;save logic that is saving the values incorrectly
 . S CLASS="",STS=$P(BGON0,U,6)
 . S:STS="Personal History" STS="P"  ;Handle bug in EHR picklist code
 . I STS="P" S CLASS="P"
 . ;
 . ;Custom code to account for EHR bug
 . S STS=$S(STS="A":"Chronic",STS="S":"Sub-acute",STS="I":"Inactive",STS="E":"Episodic",STS="O":"Social/Environmental",STS="P":"Personal History",STS="R":"Admin",1:"Episodic")
 . ;
 . ;For show all use default status
 . I ALL S STS=$G(CRSLT(1,"STS"))
 . ;
 . ;Code on PIP?
 . S PIP="",DISABLE=""
 . I DFN]"" D
 .. Q:'$D(PRBLST(CONCID))
 .. ;
 .. ;Mark as on PIP
 .. S PIP="On PIP"
 .. ;
 .. ;Disable if not the same synonym
 .. I DESC'=PRBLST(CONCID) S DISABLE="Y"
 . ;
 . ;Save the entry
 . S II=II+1,@DATA@(II)=DESC_U_DESCTM_U_FNAME_U_CONCID_U_FREQ_U_PIP_U_ICD_U_DISABLE_U_STS_U_CLASS_U_GROUP_U_LAT_$C(30)
 . ;
 . ;Record that it was found
 . S PK(DESC)=""
 ;
 Q
 ;
PPRV(VIEN) ;EP - Retrieve Visit Primary Provider
 ;
 NEW PPRV,IEN
 ;
 I $G(VIEN)="" Q ""
 ;
 S (PPRV,IEN)="" F  S IEN=$O(^AUPNVPRV("AD",VIEN,IEN)) Q:'IEN  D  Q:PPRV]""
 . NEW PTYPE
 . S PTYPE=$$GET1^DIQ(9000010.06,IEN_",",.04,"I") Q:PTYPE'="P"
 . S PPRV=$$GET1^DIQ(9000010.06,IEN_",",.01,"I")
 Q PPRV
 ;
DEL(DATA,VIEN,DESCID,DCODE,DRSN,IPLDEL) ;BJPN PICK LIST PRB DELETE
 ;
 ;Delete prenatal problem from PIP
 ;
 ;Input:
 ; VIEN - Visit IEN
 ; DESCID - Description Id of Problem to Remove
 ; DCODE - Delete Code
 ; DRSN - Delete Reason (if Other)
 ; IPLDEL - Delete IPL entry
 ;
 NEW UID,II,%,DFN,CONCID,PRBIEN,PIPIEN,RSLT
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPKL",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPKL D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S @DATA@(II)="T00010RESULT^T00150ERROR_MESSAGE"_$C(30)
 ;
 ;Input validation
 I $G(VIEN)="" S II=II+1,@DATA@(II)="-1^MISSING VISIT IEN"_$C(30) G XDEL
 I $G(DESCID)="" S II=II+1,@DATA@(II)="-1^MISSING Description ID"_$C(30) G XDEL
 S DCODE=$G(DCODE,""),DRSN=$G(DRSN,"")
 S DFN=$$GET1^DIQ(9000010,VIEN_",",".05","I") I DFN="" S II=II+1,@DATA@(II)="-1^INVALID DFN"_$C(30) G XDEL
 ;
 ;Get the Concept ID
 S CONCID=$P($$DESC^BSTSAPI(DESCID_"^^1"),U) I CONCID="" S II=II+1,@DATA@(II)="-1^COULD NOT FIND CONCEPT ID"_$C(30) G XDEL
 ;
 ;Locate the PIP entry
 S (PIPIEN,PRBIEN)=""
 F  S PRBIEN=$O(^BJPNPL("F",DFN,PRBIEN)) Q:PRBIEN=""  D  Q:PIPIEN
 . NEW BPIEN,IPLCNC,DEL
 . ;
 . ;Skip deletes
 . S DEL=$$GET1^DIQ(9000011,PRBIEN_",",2.02,"I") I DEL]"" Q  ;IPL Delete
 . ;
 . ;Get the Concept Id of the IPL entry - Look for a match
 . S IPLCNC=$$GET1^DIQ(9000011,PRBIEN_",",80001,"I") Q:IPLCNC=""
 . I IPLCNC'=CONCID Q
 . ;
 . ;Verify the PIPIEN is correct
 . S BPIEN="" F  S BPIEN=$O(^BJPNPL("F",DFN,PRBIEN,BPIEN)) Q:BPIEN=""  D
 .. NEW DEL
 .. ;
 .. ;Skip deletes
 .. S DEL=$$GET1^DIQ(90680.01,BPIEN_",",2.01,"I") I DEL]"" Q
 .. ;
 .. ;Set the PIPIEN
 .. S PIPIEN=BPIEN
 ;
 ;Quit if no PIP entry found
 I ($G(PIPIEN)="")!($G(PRBIEN)="") S II=II+1,@DATA@(II)="-1^COULD NOT FIND PROBLEM ON PIP"_$C(30) G XDEL
 ;
 ;Make the call to delete
 D DEL^BJPNCPIP("",VIEN,PIPIEN,DCODE,DRSN,$G(IPLDEL))
 ;
 ;Get the result
 S RSLT=$P($G(^TMP("BJPNCPIP",UID,1)),$C(30))
 S II=II+1,@DATA@(II)=$P(RSLT,U)_U_$P(RSLT,U,2)_$C(30)
 ;
 ;Broadcast update
 ;BJPN*2.0*7;Removed PPL - This call isn't used but made the fix just in case
 D FIREEV^BJPNPDET("","PCC."_DFN_".PPL")
 D FIREEV^BJPNPDET("","PCC."_DFN_".PIP")
 ;
XDEL S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S II=II+1,@DATA@(II)=$C(31)
 Q
