BJPNCPIP ;GDIT/HS/BEE-Prenatal Care Module Problem Handling Calls ; 08 May 2012  12:00 PM
 ;;2.0;PRENATAL CARE MODULE;**7,8**;Feb 24, 2015;Build 25
 ;
 Q
 ;
CDEL(DATA,DESCID,DFN) ;EP - BJPN CAN DELETE
 ;
 ;Determine whether problem can be deleted from the PIP/IPL
 ;
 NEW UID,II,CONCID,PRBIEN,PIPIEN,CDEL,PSTATUS,TMP
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNCPIP",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNCPIP D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S @DATA@(II)="T00001CAN_DELETE^T00001PIP_STATUS"_$C(30)
 ;
 ;Input validation
 I $G(DESCID)="" S II=II+1,@DATA@(II)="-1^MISSING DESCID"_$C(30) G XCDEL
 I $G(DFN)="" S II=II+1,@DATA@(II)="-1^MISSING DFN"_$C(30) G XCDEL
 ;
 ;Get the Concept ID
 S CONCID=$P($$DESC^BSTSAPI(DESCID_"^^1"),U) I CONCID="" S II=II+1,@DATA@(II)="-1^COULD NOT FIND CONCEPT ID"_$C(30) G XDEL
 ;
 ;Locate the PIP entry
 S (PIPIEN,PRBIEN,PSTATUS)=""
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
 . S BPIEN="" F  S BPIEN=$O(^BJPNPL("F",DFN,PRBIEN,BPIEN)) Q:BPIEN=""  D  Q:PIPIEN
 .. NEW DEL
 .. ;
 .. ;Skip deletes
 .. S DEL=$$GET1^DIQ(90680.01,BPIEN_",",2.01,"I") I DEL]"" Q
 .. ;
 .. ;Set the PIPIEN
 .. S PIPIEN=BPIEN
 .. S PSTATUS=$$GET1^DIQ(90680.01,BPIEN_",",.08,"I")
 ;
 ;Quit if no PIP entry found
 I ($G(PIPIEN)="")!($G(PRBIEN)="") S II=II+1,@DATA@(II)="-1^COULD NOT FIND PROBLEM ON PIP"_$C(30) G XCDEL
 ;
 ;Pull the IPL information - Determine if problem can be deleted
 D COMP^BJPNUTIL(DFN,UID,"",PRBIEN)
 S TMP=$NA(^TMP("BJPNIPL",UID))  ;Define compiled data reference
 ;
 ;Reset Can Delete flag
 D
 . NEW GGO,CGO,TGO,VGO,CPGSTS
 . ;Reset Can Delete flag
 . S CDEL="Y"
 . ;
 . ;Get Goal notes
 . S GGO="" F  S GGO=$O(@TMP@("G",PRBIEN,GGO)) Q:GGO=""  D  Q:CDEL=""
 .. ;
 .. ;Look for inactive or active goals
 .. S CPGSTS=$P($G(@TMP@("G",PRBIEN,GGO,0)),U,6)
 .. I (CPGSTS="I")!(CPGSTS="A") S CDEL="" Q
 . ;
 . ;Get Care Plans
 . S CGO="" F  S CGO=$O(@TMP@("C",PRBIEN,CGO)) Q:CGO=""  D  Q:CDEL=""
 .. ;
 .. ;Look for inactive or active Care Plans
 .. S CPGSTS=$P($G(@TMP@("C",PRBIEN,CGO,0)),U,6)
 .. I (CPGSTS="I")!(CPGSTS="A") S CDEL="" Q
 . ;
 . ;Look for Treatment/Regimen
 . S TGO=$O(@TMP@("T",PRBIEN,"")) I TGO]"" S CDEL=""
 . ;
 . ;Look for V Visit Instruction
 . S VGO=$O(@TMP@("I",PRBIEN,"")) I VGO]"" S CDEL=""
 . ;
 . ;Ever a POV - needed for deleting permission
 . I $O(^AUPNPROB(PRBIEN,14,"B",""))]"" S CDEL=""
 . I $O(^AUPNPROB(PRBIEN,15,"B",""))]"" S CDEL=""
 ;
 ;Quit if not allowed to delete
 S II=II+1,@DATA@(II)=CDEL_U_PSTATUS_$C(30)
 ;
XCDEL S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
CPSTS(DATA,DESCID,DFN) ;EP - BJPN PICK LIST TOGGLE STATUS
 ;
 ;Toggle a problem status from the pick list
 ;
 NEW UID,II,CONCID,PRBIEN,PIPIEN,STS,%,NOW,NSTS,BJPNUPD,IPLUPD,DIC,DA,DLAYGO,X,Y,IENS,PIP,ERROR
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNCPIP",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNCPIP D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define Header
 S @DATA@(II)="T00005RESULT^T00150ERROR_MESSAGE"_$C(30)
 ;
 ;Input validation
 I $G(DESCID)="" S II=II+1,@DATA@(II)="-1^MISSING DESCID"_$C(30) G XCPSTS
 I $G(DFN)="" S II=II+1,@DATA@(II)="-1^MISSING DFN"_$C(30) G XCPSTS
 ;
 ;Get the Concept ID
 S CONCID=$P($$DESC^BSTSAPI(DESCID_"^^1"),U) I CONCID="" S II=II+1,@DATA@(II)="-1^COULD NOT FIND CONCEPT ID"_$C(30) G XCPSTS
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
 . S BPIEN="" F  S BPIEN=$O(^BJPNPL("F",DFN,PRBIEN,BPIEN)) Q:BPIEN=""  D  Q:PIPIEN
 .. NEW DEL
 .. ;
 .. ;Skip deletes
 .. S DEL=$$GET1^DIQ(90680.01,BPIEN_",",2.01,"I") I DEL]"" Q
 .. ;
 .. ;Set the PIPIEN
 .. S PIPIEN=BPIEN
 ;
 ;Quit if no PIP entry found
 I ($G(PIPIEN)="")!($G(PRBIEN)="") S II=II+1,@DATA@(II)="-1^COULD NOT FIND PROBLEM ON PIP"_$C(30) G XCPSTS
 ;
 D NOW^%DTC S NOW=%
 ;
 ;Get the problem (IPL) IEN
 S PRBIEN=$$GET1^DIQ(90680.01,PIPIEN_",",.1,"I") I PRBIEN="" S II=II+1,@DATA@(II)="-1^INVALID IPL POINTER"_$C(30) G XCPSTS
 ;
 ;Get the current status
 S STS=$$GET1^DIQ(90680.01,PIPIEN_",",.08,"I")
 I STS'="A",STS'="I" S STS="I"  ;Default to "A" if null
 ;
 ;Define new values
 I STS="A" S NSTS="I",PIP="@"
 I STS="I" S NSTS="A",PIP=1
 S BJPNUPD(90680.01,PIPIEN_",",.08)=NSTS
 S BJPNUPD(9000011,PRBIEN_",",.19)=PIP
 S IPLUPD(9000011,PRBIEN_",",.03)=NOW
 S IPLUPD(9000011,PRBIEN_",",.14)=DUZ
 ;
 ;Add the IPL PIP flag
 S DIC="^BJPNPL("_PIPIEN_",5,"
 S DA(1)=PIPIEN
 S DLAYGO="90680.015",DIC("P")=$P(^DD(90680.01,5,0),U,2),DIC(0)="LOX"
 S X=NOW
 K DO,DD D FILE^DICN
 I +Y=-1 S II=II+1,@DATA@(II)="-1^Could not add PIP column history" G XCPSTS
 ;
 ;Add the User/PIP value
 S DA(1)=PIPIEN,DA=+Y,IENS=$$IENS^DILF(.DA)
 S BJPNUPD(90680.015,IENS,".02")=$S(PIP=1:1,1:0)
 S BJPNUPD(90680.015,IENS,".03")=DUZ
 ;
 D FILE^DIE("","BJPNUPD","ERROR")
 I $D(ERROR) S II=II+1,@DATA@(II)="-1^Status PIP update change failed"_$C(30) G XCPSTS
 D FILE^DIE("","IPLUPD","ERROR")
 I $D(ERROR) S II=II+1,@DATA@(II)="-1^Status IPL update change failed"_$C(30) G XCPSTS
 ;
 ;Broadcast update
 ;BJPN*2.0*7;Removed PPL
 ;D FIREEV^BJPNPDET("","PCC."_DFN_".PPL")
 D FIREEV^BJPNPDET("","PCC."_DFN_".PIP")
 ;
 S II=II+1,@DATA@(II)="1^"_$C(30)
 ;
XCPSTS S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
DEL(DATA,VIEN,PIPIEN,DCODE,DRSN,DELIPL) ;BJPN DELETE PIP PROBLEM
 ;
 ;Delete prenatal problem from PIP and IPL
 ;
 NEW UID,II,%,NOW,PRUPD,ERROR,RSLT,DFN,PROC,DTTM,VFL,VPUPD,PRBIEN,DIC,DA,X,Y,DLAYGO
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNCPIP",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNCPIP D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S @DATA@(II)="T00010RESULT^T00150ERROR_MESSAGE"_$C(30)
 ;
 ;Input validation
 I $G(VIEN)="" S II=II+1,@DATA@(II)="-1^MISSING VISIT IEN"_$C(30) G XDEL
 I $G(PIPIEN)="" S II=II+1,@DATA@(II)="-1^MISSING PIPIEN"_$C(30) G XDEL
 S DELIPL=$G(DELIPL)
 I $$GET1^DIQ(90680.01,PIPIEN_",",".01","I")="" S II=II+1,@DATA@(II)="-1^INVALID PIPIEN"_$C(30) G XDEL
 I $$GET1^DIQ(90680.01,PIPIEN_",",2.01,"I")]"" S II=II+1,@DATA@(II)="-1^PROBLEM ALREADY DELETED"_$C(30) G XDEL
 S DCODE=$G(DCODE,""),DRSN=$G(DRSN,"")
 ;
 D NOW^%DTC S NOW=%
 ;
 ;Retrieve DFN
 S DFN=$$GET1^DIQ(9000010,VIEN_",",".05","I") I DFN="" S II=II+1,@DATA@(II)="-1^INVALID VISIT"_$C(30) G XDEL
 ;
 ;Get the problem (IPL) IEN
 S PRBIEN=$$GET1^DIQ(90680.01,PIPIEN_",",.1,"I") I PRBIEN="" S II=II+1,@DATA@(II)="-1^INVALID IPL POINTER"_$C(30) G XDEL
 ;
 ;Mark as deleted - PIP
 S RSLT="1"
 S PRUPD(90680.01,PIPIEN_",",2.01)=DUZ
 S PRUPD(90680.01,PIPIEN_",",2.02)=NOW
 S PRUPD(90680.01,PIPIEN_",",2.03)=DCODE
 S PRUPD(90680.01,PIPIEN_",",2.04)=DRSN
 S PRUPD(9000011,PRBIEN_",",.19)="@"  ;Remove from PIP column in IPL
 I $D(PRUPD) D FILE^DIE("","PRUPD","ERROR")
 I $D(ERROR) S RSLT="-1^PIP DELETE FAILED",II=II+1,@DATA@(II)=RSLT_$C(30) G XDEL
 ;
 ;
 ;Add the IPL PIP flag history
 S DIC="^BJPNPL("_PIPIEN_",5,"
 S DA(1)=PIPIEN
 S DLAYGO="90680.015",DIC("P")=$P(^DD(90680.01,5,0),U,2),DIC(0)="LOX"
 S X=NOW
 K DO,DD D FILE^DICN
 I +Y=-1 S II=II+1,@DATA@(II)="-1^Could not add PIP column history" G XDEL
 ;
 ;Mark as deleted - IPL
 S RSLT="1"
 I $G(DELIPL)=1 D  I RSLT'=1 G XDEL
 . NEW IPLUPD
 . S IPLUPD(9000011,PRBIEN_",",.12)="D"
 . S IPLUPD(9000011,PRBIEN_",",2.01)=DUZ
 . S IPLUPD(9000011,PRBIEN_",",2.02)=NOW
 . S IPLUPD(9000011,PRBIEN_",",2.03)=DCODE
 . S IPLUPD(9000011,PRBIEN_",",2.04)=DRSN
 . S IPLUPD(9000011,PRBIEN_",",.03)=NOW
 . S IPLUPD(9000011,PRBIEN_",",.14)=DUZ
 . D FILE^DIE("","IPLUPD","ERROR")
 . I $D(ERROR) S RSLT="-1^IPL DELETE FAILED",II=II+1,@DATA@(II)=RSLT_$C(30)
 ;
 S II=II+1,@DATA@(II)="1^"_$C(30)
 ;
 ;Broadcast update
 ;BJPN*2.0*7;Remove PPL alert
 ;D FIREEV^BJPNPDET("","PCC."_DFN_".PPL")
 D FIREEV^BJPNPDET("","PCC."_DFN_".PIP")
 ;
XDEL S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
STS(DATA,PIPIEN,VIEN) ;EP - BJPN TOGGLE STATUS
 ;
 ;Toggle the PIP status of a problem
 ;
 NEW UID,II,STS,RESULT,PRBIEN,NSTS,PIP,BJPNUPD,ERROR,DFN,IPLUPD
 NEW DIC,DA,DLAYGO,X,Y,IENS
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNCPIP",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNCPIP D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define Header
 S @DATA@(II)="T00005RESULT^T00150ERROR_MESSAGE"_$C(30)
 ;
 ;Input validation
 I $G(VIEN)="" S II=II+1,@DATA@(II)="-1^MISSING VISIT IEN"_$C(30) G XSTS
 I $G(PIPIEN)="" S II=II+1,@DATA@(II)="-1^MISSING PIPIEN"_$C(30) G XSTS
 ;
 D NOW^%DTC S NOW=%
 ;
 ;Get the problem (IPL) IEN
 S PRBIEN=$$GET1^DIQ(90680.01,PIPIEN_",",.1,"I") I PRBIEN="" S II=II+1,@DATA@(II)="-1^INVALID IPL POINTER"_$C(30) G XSTS
 S DFN=$$GET1^DIQ(9000011,PRBIEN_",",.02,"I")
 ;
 ;Get the current status
 S STS=$$GET1^DIQ(90680.01,PIPIEN_",",.08,"I")
 I STS'="A",STS'="I" S STS="I"  ;Default to "A" if null
 ;
 ;Define new values
 I STS="A" S NSTS="I",PIP="@"
 I STS="I" S NSTS="A",PIP=1
 S BJPNUPD(90680.01,PIPIEN_",",.08)=NSTS
 S BJPNUPD(9000011,PRBIEN_",",.19)=PIP
 S IPLUPD(9000011,PRBIEN_",",.03)=NOW
 S IPLUPD(9000011,PRBIEN_",",.14)=DUZ
 ;
 ;Add the IPL PIP flag
 S DIC="^BJPNPL("_PIPIEN_",5,"
 S DA(1)=PIPIEN
 S DLAYGO="90680.015",DIC("P")=$P(^DD(90680.01,5,0),U,2),DIC(0)="LOX"
 S X=NOW
 K DO,DD D FILE^DICN
 I +Y=-1 S II=II+1,@DATA@(II)="-1^Could not add PIP column history" G XSTS
 ;
 ;Add the User/PIP value
 S DA(1)=PIPIEN,DA=+Y,IENS=$$IENS^DILF(.DA)
 S BJPNUPD(90680.015,IENS,".02")=$S(PIP=1:1,1:0)
 S BJPNUPD(90680.015,IENS,".03")=DUZ
 ;
 D FILE^DIE("","BJPNUPD","ERROR")
 I $D(ERROR) S II=II+1,@DATA@(II)="-1^Status PIP update change failed"_$C(30) G XSTS
 D FILE^DIE("","IPLUPD","ERROR")
 I $D(ERROR) S II=II+1,@DATA@(II)="-1^Status IPL update change failed"_$C(30) G XSTS
 ;
 ;Broadcast update
 ;BJPN*2.0*7;Remove PPL alert since it has been removed
 ;D FIREEV^BJPNPDET("","REFRESH")
 ;D FIREEV^BJPNPDET("","PCC."_DFN_".PPL")
 D FIREEV^BJPNPDET("","PCC."_DFN_".PIP")
 ;
 S II=II+1,@DATA@(II)="1^"_$C(30)
 ;
XSTS S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
SCO(DATA,PIPIEN,VIEN) ;EP - BJPN TOGGLE SCOPE
 ;
 ;Toggle the PIP scope of a problem
 ;
 NEW UID,II,SCO,RESULT,PRBIEN,NSCO,BJPNUPD,ERROR,DFN,IPLUPD
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNCPIP",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNCPIP D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define Header
 S @DATA@(II)="T00005RESULT^T00150ERROR_MESSAGE"_$C(30)
 ;
 ;Input validation
 I $G(VIEN)="" S II=II+1,@DATA@(II)="-1^MISSING VISIT IEN"_$C(30) G XSCO
 I $G(PIPIEN)="" S II=II+1,@DATA@(II)="-1^MISSING PIPIEN"_$C(30) G XSCO
 ;
 D NOW^%DTC S NOW=%
 ;
 ;Get the problem (IPL) IEN
 S PRBIEN=$$GET1^DIQ(90680.01,PIPIEN_",",.1,"I") I PRBIEN="" S II=II+1,@DATA@(II)="-1^INVALID IPL POINTER"_$C(30) G XSCO
 S DFN=$$GET1^DIQ(9000011,PRBIEN_",",.02,"I")
 ;
 ;Get the current scope
 S SCO=$$GET1^DIQ(90680.01,PIPIEN_",",.07,"I")
 I SCO'="A",SCO'="C" S SCO="A"
 ;
 ;Define new values
 I SCO="A" S NSCO="C"
 I SCO="C" S NSCO="A"
 S BJPNUPD(90680.01,PIPIEN_",",.07)=NSCO
 S IPLUPD(9000011,PRBIEN_",",.03)=NOW
 S IPLUPD(9000011,PRBIEN_",",.14)=DUZ
 D FILE^DIE("","BJPNUPD","ERROR")
 I $D(ERROR) S II=II+1,@DATA@(II)="-1^Scope change failed"_$C(30) G XSCO
 D FILE^DIE("","IPLUPD","ERROR")
 I $D(ERROR) S II=II+1,@DATA@(II)="-1^Scope change failed"_$C(30) G XSCO
 ;
 ;Broadcast update
 ;D FIREEV^BJPNPDET("","REFRESH")
 ;BJPN*2.0*7;Remove refreshes as being handled by GUI
 ;D FIREEV^BJPNPDET("","PCC."_DFN_".PPL")
 ;D FIREEV^BJPNPDET("","PCC."_DFN_".PIP")
 ;
 S II=II+1,@DATA@(II)="1^"_$C(30)
 ;
XSCO S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S II=II+1,@DATA@(II)=$C(31)
 Q
