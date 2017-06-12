BJPNSPOV ;GDIT/HS/BEE-Prenatal Care Module POV Handling ; 08 May 2012  12:00 PM
 ;;2.0;PRENATAL CARE MODULE;**4,6,7**;Feb 24, 2015;Build 53
 ;
 Q
 ;
POV(DATA,INP,QUAL,INJ) ;EP - BJPN SET POV
 ;
 ;Set the problem as the POV for the visit
 ;
 ;Input parameters
 ;  INP = VPOV IEN [1] 28 Visit IEN [2] 28 Problem IEN [3] 28 Patient IEN [4] 28 Prov Text [5] 28 Descriptive CT [6] 28
 ;        SNOMED CT [7] 28 ICD code [8] 28 Primary/Secondary [9] 28 Provider IEN [10] 28 asthma control [11] 28 Abnormal Findings [12]
 ;        28 Laterality Attribute|Qualifier [13]
 ;  QUAL = Q[1] 28 TYPE [2] 28 IEN (If edit)  [3] 28 SNOMED [4] 28 BY [5] 28 WHEN [6] 28 DEL [7]
 ;  INJ  = Cause DX[1] 28 Injury Code [2] 28 Injury Place [3] 28 First/Revisit [4] 28 Injury Dt [5] 28 Onset Date [6]
 ;
 ;Return value: SUCCESS^VPOV IEN^ERROR MESSAGE
 ;1^VPOV IEN - Success
 ;-1^^Error Message
 ;
 NEW UID,II,RET,RESULT,PPRV,VIEN,DXCAUSE,ZTQUEUED,POVIEN,ICD,AF
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BJPNSPOV",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 ;Set ZTQUEUED - which fixes an error in the save with data getting displayed to the screen
 S ZTQUEUED=""
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BJPNSPOV D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 ;Define Header
 S @DATA@(II)="T00005RESULT^T00010POV_IEN^T00150ERROR_MESSAGE"_$C(30)
 ;
 ;Translate the incoming data delimiters
 S INP=$TR($G(INP),$C(28),"^")
 S QUAL=$TR($G(QUAL),$C(28),"^")
 S INJ=$TR($G(INJ),$C(28),"^")
 ;
 ;Only allow one ICD
 S ICD=$P(INP,U,8) I ICD["|" S $P(INP,U,8)=$P(ICD,"|")
 ;
 ;Make sure provider IEN is populated
 S VIEN=$P(INP,U,2)
 ;Default saved by to DUZ
 ;S PPRV=$P(INP,U,10)
 S PPRV=DUZ
 I PPRV="" S PPRV=$$PPRV^BJPNPKL(VIEN)
 S $P(INP,U,10)=PPRV
 ;
 ;Populate Q By/Date
 I $G(QUAL)]"" D
 . NEW %
 . I $P(QUAL,U,5)]"" Q
 . S $P(QUAL,U,5)=DUZ
 . D NOW^%DTC
 . S $P(QUAL,U,6)=%
 ;
 ;BJPN*2.0*6;Handle abnormal findings
 ;Convert AF from text to SNOMED
 S AF=$P(INP,U,12) S:AF="" AF="@"
 I AF]"",AF'="@" S AF=$O(^BSTS(9002318.6,"D","AF",AF,""))
 S $P(INP,U,12)=""
 ;
 ;Convert Dx Cause to uppercase
 S $P(INJ,U)=$$UPPER($P(INJ,U))
 ;
 ;Convert Injury Date
 S $P(INJ,U,5)=$$DATE^BJPNPRUT($P(INJ,U,5))
 ;
 ;Convert Onset Date
 S $P(INJ,U,6)=$$DATE^BJPNPRUT($P(INJ,U,6))
 ;
 ;Make the EHR POV call
 ;
 ;Process adds
 S RESULT=""
 I $TR($P(INP,U),$C(29))="" D
 . D SET^BGOVPOV(.RET,INP,QUAL,INJ,AF)
 . ;
 . ;Format output
 . I +RET>0 S RESULT="1^"_+RET
 . E  S RESULT="-1^^"_$P(RET,U,2)
 ;
 ;Process edits
 I $TR($P(INP,U),$C(29))]"" D
 . NEW LIST,PC,PVIEN
 . S PVIEN=$P(INP,U)  ;Clear PVIENs
 . S $P(INP,U,8)=""  ;Clear ICD
 . S LIST=""
 . F PC=1:1:$L(PVIEN,$C(29)) I $P(PVIEN,$C(29),PC)]"" S LIST(PC-1)=$P(PVIEN,$C(29),PC)
 . S $P(INP,U)=""
 . D EDIT^BGOVPOV3(.RET,INP,.LIST,QUAL,INJ,AF)
 . ;
 . ;Format output
 . I +$P(RET,";",2)>0 S RESULT="1^"_+$P(RET,";",2)
 . E  S RESULT="-1^^"_$P(RET,U,2)
 ;
 S II=II+1,@DATA@(II)=RESULT_$C(30)
 ;
XPOV S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
UPPER(X) ;Convert to uppercase
 Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S II=II+1,@DATA@(II)=$C(31)
 Q
