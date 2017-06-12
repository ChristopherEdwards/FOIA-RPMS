BJPNPCHK ;GDIT/HS/BEE-Prenatal Care Module Duplicate Problem Checking ; 08 May 2012  12:00 PM
 ;;2.0;PRENATAL CARE MODULE;**7**;Feb 24, 2015;Build 53
 ;
 Q
 ;
PCHECK(DATA,DFN,CONCID,VIEN,DESCID,LAT,PRBIEN,PIPIEN) ;EP - BJPN CHECK FOR PROBLEM
 ;
 ;This RPC checks to see if a particular SNOMED CT/Laterality or its equivalent concept is on a patient's
 ;PIP or IPL.
 ;
 ;Input parameter:
 ;  DFN   - Patient DFN
 ; CONCID - The Concept ID to lookup
 ;   VIEN - Visit IEN
 ; DESCID - Description Id (Required if CONCID is null)
 ;    LAT - Laterality (Optional) - The internal attribute|laterality value
 ; PRBIEN - The problem IEN of the problem being modified (if applicable)
 ; PIPIEN - The PIP IEN of the problem being modified (if applicable)
 ;
 ;Input checks
 S LAT=$G(LAT)
 S PRBIEN=+$G(PRBIEN)
 S PIPIEN=+$G(PIPIEN)
 I $G(DFN)="" S BMXSEC="Missing patient DFN value" G XPCHECK
 I $G(CONCID)="" S BMXSEC="Missing Concept ID" G XPCHECK
 I $G(DESCID)="" S BMXSEC="Missing Description ID" G XPCHECK
 I $G(VIEN)="" S BMXSEC="Missing VIEN value" G XPCHECK
 I $G(DUZ(2))="" S BMXSEC="DUZ(2) is not properly defined" G XPCHECK
 ;
 NEW UID,II,NXTPRB,EQCN,CENT,ITYPE,TMP,TII,EXFND,PCNC,PDSC,PNXT,EXMNOPRB
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPCHK",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 ;Get current problem information
 S (PCNC,PDSC,PNXT)="" I +PRBIEN D
 . S PCNC=$$GET1^DIQ(9000011,PRBIEN_",",80001,"I")  ;Current concept id
 . S PDSC=$$GET1^DIQ(9000011,PRBIEN_",",80002,"I")  ;Current description id
 . S PNXT=$$GET1^DIQ(9000011,PRBIEN_",",.07,"I") ;Next Problem Value
 ;
 S (II,TII)=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPCHK D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define Header
 S @DATA@(0)="T00030CONC_ID^T00025INT_LATERALITY^T00030DESC_ID^T00500DESC_TERM^I00010PRBIEN^I00010PIPIEN^T00001PATIENT_TYPE"
 S @DATA@(0)=@DATA@(0)_"^T00050NEXT_PRB^T00001EXACT_MATCH^T00040EXT_LATERALITY^T00015ICD^T00030STATUS"
 S @DATA@(0)=@DATA@(0)_"^T00001PROMPT_LATERALITY^T00500PROVIDER_NARRATIVE^T00001LATERALIZED_CONCEPT"_$C(30)
 ;
 ;Call BSTS to find the equivalent concepts
 D EQUIV^BSTSAPI("EQCN",CONCID_U_LAT)
 I $O(EQCN(""))="" G XPCHECK
 ;
 ;Get the next problem number
 D
 . NEW RET
 . D NEXTID^BGOPROB(.RET,DFN)
 . S NXTPRB=RET
 ;
 ;Get the visit type
 S ITYPE=$$GET1^DIQ(9000010,VIEN_",",.07,"I")
 S ITYPE=$S(ITYPE="H":"H",1:"A")
 ;
 ;Now loop through the returned values and look for them
 S (EXMNOPRB,EXFND)=0,CENT="" F  S CENT=$O(EQCN(CENT)) Q:CENT=""  D
 . ;
 . NEW ENOD,ECNC,FND,ELAT,F,EEXT,LATCNC
 . ;
 . ;Pull the returned record
 . S ENOD=EQCN(CENT) Q:$TR(ENOD,U)=""
 . S ECNC=$P(ENOD,U)
 . S ELAT=$P(ENOD,U,2)
 . S EEXT=$P(ENOD,U,3)
 . S FND=0
 . ;
 . ;For first concept return laterality
 . S LATCNC="" I CENT=1,$P(ENOD,U,4)=1 S LATCNC="Y"
 . ;
 . ;Have laterality - Look in "ASLT" cross reference
 . I $TR(ELAT,"|")]"" D
 .. ;
 .. NEW PIEN
 .. S PIEN="" F  S PIEN=$O(^AUPNPROB("ASLT",DFN,ECNC,ELAT,PIEN)) Q:PIEN=""  S F=$$GPROB(.TMP,PIEN,ENOD,ITYPE,.EXFND,.TII,LATCNC) S:F FND=1
 . ;
 . ;No laterality - Look in "APCT" cross reference
 . I $TR(ELAT,"|")="" D
 .. ;
 .. NEW PIEN
 .. S PIEN="" F  S PIEN=$O(^AUPNPROB("APCT",DFN,ECNC,PIEN)) Q:PIEN=""  S F=$$GPROB(.TMP,PIEN,ENOD,ITYPE,.EXFND,.TII,LATCNC) S:F FND=1
 . ;
 . ;If not found, return entry
 . I FND=0,CONCID=ECNC,LAT=ELAT D
 .. ;
 .. NEW PDST,EXLAT,ICD,DSTS,DDATA,PRMLST,PMLT
 .. S PRMLST="" I $P(ELAT,"|",2)]"" S PRMLST="LAT="_$P(ELAT,"|",2)
 .. S DDATA=$$DESC^BSTSAPI(DESCID_"^^1^^^"_PRMLST)
 .. S PDST=$P(DDATA,U,2)
 .. ;
 .. ;Get external laterality
 .. S EXLAT="" I $TR(ELAT,"|")]"" S EXLAT=$$CVPARM^BSTSMAP1("LAT",$P(ELAT,"|"))_"|"_$$CVPARM^BSTSMAP1("LAT",$P(ELAT,"|",2))
 .. ;
 .. ;Get ICD, default status and prompt laterality
 .. S ICD=$P(DDATA,U,3)
 .. S DSTS=$P(DDATA,U,7)
 .. S PMLT=$P(DDATA,U,6)
 .. ; 
 .. ;No match found - log that entry can be used
 .. S TII=$G(TII)+1,TMP(TII)=ECNC_U_ELAT_U_DESCID_U_PDST_U_0_U_0_U_ITYPE_U_NXTPRB_U_EEXT_U_EXLAT_U_ICD_U_DSTS_U_$S(PMLT:"Y",1:"")_U_U_LATCNC
 .. I EEXT S EXMNOPRB=1  ;Track if an exact match
 ;
 ;Loop through results - eliminate others if exact match found
 S TII="" F  S TII=$O(TMP(TII)) Q:'TII  D
 . ;
 . NEW TNODE
 . S TNODE=TMP(TII)
 . ;
 . ;Special logic for exact match found on IPL - Only include it
 . I $D(TMP("EXACT")) D  Q
 .. ;
 .. NEW EXNODE
 .. ;
 .. ;Get the exact match
 .. S EXNODE=TMP(TMP("EXACT"))
 .. ;
 .. ;If not an exact match do not include
 .. I '$P(TNODE,U,9) Q
 .. ;
 .. ;Passed in problem is the same as the exact match problem
 .. ;
 .. I +PRBIEN,PRBIEN=$P(EXNODE,U,5) D  Q
 ... ;
 ... ;The user switched to the equivalent concept - update original
 ... ;passed in problem info with new SNOMED/laterality information
 ... I $P(TNODE,U,9)=1,$P(TNODE,U,5)=0 D  Q
 .... NEW I
 .... S EXNODE=TMP(TMP("EXACT"))
 .... F I=5:1:9 S $P(TNODE,U,I)=$P(EXNODE,U,I)
 .... S II=II+1,@DATA@(II)=TNODE_$C(30)
 ... ;
 ... ;The user picked the same concept - return original
 ... I $P(TNODE,U,9)=1,TMP("EXACT")=TII D  Q
 .... Q:CONCID'=$P(TNODE,U)  ;Concept not the same
 .... Q:LAT'=$P(TNODE,U,2)  ;Laterality not the same
 .... S TNODE=TMP(TMP("EXACT"))
 .... S II=II+1,@DATA@(II)=TNODE_$C(30)
 .. ;
 .. ;No passed in problem or not a match with exact
 .. ;
 .. ;If exact match, allow - GUI will utilize IPL problem returned
 .. I TMP("EXACT")=TII D  Q
 ... S TNODE=TMP(TMP("EXACT"))_$C(30)
 ... S II=II+1,@DATA@(II)=TNODE
 . ;
 . ;Problem edit - changed SNOMED and it isn't a match on IPL
 . ;update entry with passed in problem information
 . I +PRBIEN,$P(TNODE,U,5)="" D  Q
 .. S $P(TNODE,U,5)=PRBIEN
 .. S $P(TNODE,U,6)=PIPIEN
 .. S $P(TNODE,U,7)=ITYPE
 .. S $P(TNODE,U,8)=PNXT
 .. S II=II+1,@DATA@(II)=TNODE_$C(30)
 . ;
 . ;Not an exact match on IPL, exact found by BSTS and edit fill entries
 . I +PIPIEN,EXMNOPRB D  Q   ;Edit and an exact match was saved
 .. I $P(TNODE,U,9) D  ;This is the exact match
 ... S $P(TNODE,U,5)=PRBIEN
 ... S $P(TNODE,U,6)=PIPIEN
 ... S $P(TNODE,U,7)=ITYPE
 ... S $P(TNODE,U,8)=PNXT
 ... S II=II+1,@DATA@(II)=TNODE_$C(30)
 . ;
 . ;No exact matches - save related ones
 . S II=II+1,@DATA@(II)=TNODE_$C(30)
 ;
XPCHECK S II=$G(II)+1,@DATA@(II)=$C(31)
 ;
 Q
 ;
GPROB(TMP,PIEN,ENOD,ITYPE,EXFND,TII,LATCNC) ;Set up return entry for problem
 ;
 I +$G(PIEN)=0 Q 0
 ;
 ;Skip deleted problems
 I $$GET1^DIQ(9000011,PIEN_",",2.02,"I")]"" Q 0
 ;
 NEW PCNC,PDSC,PDST,PNXT,PIPIEN,PFND,PPIEN,EEXT,PLAT,EXLAT,ICD,DSTS,DDATA,PRMLST,PMLT,PNAR
 ;
 ;If matching concept id and no laterality passed in, filter out those with laterality
 S PLAT=$$GET1^DIQ(9000011,PIEN_",",.22,"I") ;Laterality
 I $P(ENOD,U,2)="",PLAT]"" Q 0
 ;
 S PCNC=$$GET1^DIQ(9000011,PIEN_",",80001,"I") ;Concept ID
 S PDSC=$$GET1^DIQ(9000011,PIEN_",",80002,"I") ;Description ID
 S PNAR=$$GET1^DIQ(9000011,PIEN_",",.05,"E")  ;Provider narrative
 S PDST=$P($$DESC^BSTSAPI(PDSC_"^^1"),U,2) ;Description Term
 S PNXT=$$GET1^DIQ(9000011,PIEN_",",.07,"I") ;Next Problem Value
 S EEXT=$P(ENOD,U,3)
 S EXFND=1  ;Record that an exact IPL match was found
 ;
 ;Locate PIP entry
 S PFND=0,(PPIEN,PIPIEN)="" F  S PPIEN=$O(^BJPNPL("E",PIEN,PPIEN)) Q:PPIEN=""  D  Q:PFND
 . ;
 . ;Skip deletes
 . I $$GET1^DIQ(90680.01,PPIEN_",",2.01,"I")]"" Q
 . ;
 . ;Found a match
 . S PFND=1,PIPIEN=PPIEN
 ;
 ;Get external laterality
 S EXLAT="" I $TR(PLAT,"|")]"" S EXLAT=$$CVPARM^BSTSMAP1("LAT",$P(PLAT,"|"))_"|"_$$CVPARM^BSTSMAP1("LAT",$P(PLAT,"|",2))
 ;
 ;Get ICD and default status
 S PRMLST="" I $P(PLAT,"|",2)]"" S PRMLST="LAT="_$P(PLAT,"|",2)
 S DDATA=$$DESC^BSTSAPI(DESCID_"^^1^^^"_PRMLST)
 ;
 ;Get ICD, default status, and prompt laterality
 S ICD=$P(DDATA,U,3)
 S DSTS=$P(DDATA,U,7)
 S PMLT=$P(DDATA,U,6)
 ;
 ;Save the entry
 S TII=$G(TII)+1,TMP(TII)=PCNC_U_PLAT_U_PDSC_U_PDST_U_PIEN_U_$S(PIPIEN]"":PIPIEN,1:0)_U_ITYPE_U_PNXT_U_EEXT_U_EXLAT_U_ICD_U_DSTS_U_$S(PMLT:"Y",1:"")_U_PNAR_U_LATCNC
 I EEXT S TMP("EXACT")=TII ;Record if this was an exact match
 ;
 Q 1
 ;
PKCHECK(DATA,VIEN,CONCID,LAT,PKLIST) ;EP - BJPN CHECK PICKLIST PROBLEM
 ;
 ;This RPC checks to see if a particular SNOMED CT is on a patient's
 ;PIP or IPL.
 ;
 ;Input parameter:
 ;   VIEN - Visit IEN
 ; CONCID - Concept Id
 ;    LAT - Laterality Attribute|Value
 ; PKLIST - The IEN of the Pick List used
 ;
 ;Input checks
 I $G(VIEN)="" S BMXSEC="Missing VIEN value" G XPKCHECK
 I $G(CONCID)="" S BMXSEC="Missing Concept ID" G XPKCHECK
 S PKLIST=$G(PKLIST)
 S LAT=$G(LAT)
 ;
 NEW UID,II,PRBIEN,PIPIEN,EQCN,CENT,FOUND,ITYPE,DFN,DFSTS
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNPCHK",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNPCHK D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Get the DFN
 S DFN=$$GET1^DIQ(9000010,VIEN_",",.05,"I")
 ;
 ;Define Header
 S @DATA@(0)="I00010PRBIEN^I00010PIPIEN^T00050NEXT_PRB^T00001PATIENT_TYPE^T00030STATUS^T00001PIP_STATUS"_$C(30)
 ;
 ;Call BSTS to find the equivalent concepts
 D EQUIV^BSTSAPI("EQCN",CONCID_U_LAT)
 ;
 ;Return blank if no findings
 I $O(EQCN(""))="" D  G XPKCHECK
 . S II=II+1,@DATA@(II)="0^0^^^^"_$C(30)
 ;
 ;Now loop through the returned values and look for an exact match
 S FOUND="0^0^^^^",CENT="" F  S CENT=$O(EQCN(CENT)) Q:CENT=""  D  I +FOUND Q
 . ;
 . NEW ENOD,ECNC,ELAT
 . ;
 . ;Pull the returned record
 . S ENOD=EQCN(CENT) Q:$TR(ENOD,U)=""
 . ;
 . ;Quit if not exact match
 . I $P(ENOD,U,3)'=1 Q
 . ;
 . ;Pull concept ID and laterality
 . S ECNC=$P(ENOD,U) Q:ECNC=""
 . S ELAT=$P(ENOD,U,2)
 . ;
 . ;Have laterality - Look in "ASLT" cross reference
 . I $TR(ELAT,"|")]"" D
 .. ;
 .. NEW PIEN
 .. S PIEN="" F  S PIEN=$O(^AUPNPROB("ASLT",DFN,ECNC,ELAT,PIEN)) Q:PIEN=""  S FOUND=$$FPROB(PIEN,ENOD) I +FOUND Q
 . ;
 . ;No laterality - Look in "APCT" cross reference
 . I $TR(ELAT,"|")="" D
 .. ;
 .. NEW PIEN
 .. S PIEN="" F  S PIEN=$O(^AUPNPROB("APCT",DFN,ECNC,PIEN)) Q:PIEN=""  S FOUND=$$FPROB(PIEN,ENOD) I +FOUND Q
 ;
 ;Get the next problem number
 I 'FOUND D
 . NEW RET
 . D NEXTID^BGOPROB(.RET,DFN)
 . S $P(FOUND,U,3)=RET
 ;
 ;Get the visit type
 S ITYPE=$$GET1^DIQ(9000010,VIEN_",",.07,"I")
 S ITYPE=$S(ITYPE="H":"H",1:"A")
 S $P(FOUND,U,4)=ITYPE
 ;
 ;Update Frequency Counter if straight add
 I $P(FOUND,U)=0,+$G(PKLIST)>0,+$G(CONCID)>0 D
 . NEW PKEN,COUNT,IENS,DA,FUPD,ERROR
 . S PKEN=$O(^BGOSNOPR(PKLIST,1,"B",CONCID,"")) Q:PKEN=""
 . S DA(1)=PKLIST,DA=PKEN,IENS=$$IENS^DILF(.DA)
 . S COUNT=+$$GET1^DIQ(90362.342,IENS,.03,"I")+1
 . S FUPD(90362.342,IENS,.03)=COUNT
 . D FILE^DIE("","FUPD","ERROR")
 ;
 ;Get the default status
 I $P(FOUND,U)=0 S DFSTS=$P($$CONC^BSTSAPI(CONCID),U,9),$P(FOUND,U,5)=DFSTS
 ;
 ;Define output
 S II=II+1,@DATA@(II)=FOUND_$C(30)
XPKCHECK  S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
 ;Try to find the problem on the IPL/PIP
FPROB(PIEN,ENOD) ;Set up return entry for problem
 ;
 I +$G(PIEN)=0 Q "0^0^"
 ;
 ;Skip deleted problems
 I $$GET1^DIQ(9000011,PIEN_",",2.02,"I")]"" Q "0^0^"
 ;
 NEW PLAT,PFND,PPIEN,PIPIEN,NXTPRB,PSTS
 ;
 ;If matching concept id and no laterality passed in, filter out those with laterality
 S PLAT=$$GET1^DIQ(9000011,PIEN_",",.22,"I") ;Laterality
 I $P(ENOD,U,2)="",PLAT]"" Q "0^0^^^^"
 ;
 ;Locate PIP entry
 S (PIPIEN,PFND)=0,(PSTS,PPIEN)="" F  S PPIEN=$O(^BJPNPL("E",PIEN,PPIEN)) Q:PPIEN=""  D  Q:PFND
 . ;
 . ;Skip deletes
 . I $$GET1^DIQ(90680.01,PPIEN_",",2.01,"I")]"" Q
 . ;
 . ;Found a match
 . S PFND=1,PIPIEN=PPIEN
 . ;
 . ;Get the PIP Status
 . S PSTS=$$GET1^DIQ(90680.01,PIPIEN_",",.08,"E") S:PSTS="Inactive" PSTS=""
 ;
 ;Get next problem
 S NXTPRB=$$GET1^DIQ(9000011,PIEN_",",.07,"I")
 ;
 Q PIEN_U_PIPIEN_U_NXTPRB_U_U_U_PSTS
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S II=II+1,@DATA@(II)=$C(31)
 Q
