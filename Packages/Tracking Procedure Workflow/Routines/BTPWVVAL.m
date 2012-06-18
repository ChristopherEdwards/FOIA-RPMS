BTPWVVAL ;VNGT/HS/ALA-CMET VDEF Validation Program ; 03 Nov 2009  5:46 PM
 ;;1.0;CARE MANAGEMENT EVENT TRACKING;;Feb 07, 2011
 ;
VAL(DATA,VFILE,PARMS) ;EP -- BTPW VFILE DATA VALIDATION
 ;
 ;Input
 ;  VFILE - The vfile number or name
 ;  PARMS - The parameters being checked for validation
 ;
 NEW UID,II,BQ,LIST,BN,PDATA,NAME,VALUE,HDR,CODN,VALID,VALFLD,BI,VFLD,TYPE,X,RESULT
 NEW VFIEN,MSG,HNDLR,IEN
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BTPWVVAL",UID))
 K @DATA
 S II=0,MSG=""
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BTPWVVAL D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 S VFILE=$G(VFILE,"") I VFILE="" S BMXSEC="RPC Failed: No Vfile selected" Q
 S VFIEN=$$FIND1^DIC(90506.3,"","MO",VFILE,"","","ERROR")
 ;
 S @DATA@(II)="I00010RESULT^T00100MSG^T00001HANDLER^I00010IEN"_$C(30)
 ; Get list of parameters
 S PARMS=$G(PARMS,"")
 I PARMS="" D
 . S LIST="",BN=""
 . F  S BN=$O(PARMS(BN)) Q:BN=""  S LIST=LIST_PARMS(BN)
 . K PARMS
 . S PARMS=LIST
 . K LIST
 ;
 I PARMS="" S II=II+1,@DATA@(II)="1^"_$G(MSG)_U_$G(HNDLR)_U_$G(IEN)_$C(30) G DONE
 ; Parse parameters
 F BQ=1:1:$L(PARMS,$C(28)) D  Q:$G(BMXSEC)'=""
 . S PDATA=$P(PARMS,$C(28),BQ) Q:PDATA=""
 . S NAME=$P(PDATA,"=",1),VALUE=$P(PDATA,"=",2,99)
 . S @NAME=VALUE
 . ; If value is BQIDFN, it exists at the PCC Visit level not individual
 . ; V File level.
 . I VFILE'=9000010&(NAME="BQIDFN"!(NAME="APCDDATE")) Q
 . S CODN=$O(^BQI(90506.3,VFIEN,10,"AC",NAME,""))
 . I CODN="" S BMXSEC="RPC Failed: Parameter does not exist for this Vfile" Q
 . I $G(VALID)="" S VALID=$P($G(^BQI(90506.3,VFIEN,10,CODN,2)),U,2)
 . I $G(VALFLD)="" S VALFLD=$P($G(^BQI(90506.3,VFIEN,10,CODN,2)),U,1)
 ;
 ; Check that values exist for all fields needed for the validation
 F BI=1:1:$L(VALFLD,";") S VFLD=$P(VALFLD,";",BI) D
 . I VFLD["*" S VFLD=$$STRIP^XLFSTR(VFLD,"*") Q
 . I $G(@VFLD)="" S BMXSEC="RPC Failed: Missing validation value for "_VFLD
 I $G(BMXSEC)'="" Q
 ;
 S VALID=$TR(VALID,"~","^"),RESULT=0
 ; Execute the validation tag
 D @VALID
 S II=II+1,@DATA@(II)=RESULT_U_$G(MSG)_U_$G(HNDLR)_U_$G(IEN)_$C(30)
 ; Clean up validation variables
 F BI=1:1:$L(VALFLD,";") D
 . S VFLD=$P(VALFLD,";",BI),VFLD=$$STRIP^XLFSTR(VFLD,"*")
 . K @VFLD
 ;
DONE ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
SIG(BTPWSIGN) ;EP - Signature validation
 D SIGCHK^BMXRPC3(.RESULT,BTPWSIGN)
 I RESULT=0 S RESULT=-1,MSG="Signature not validated" Q
 S RESULT=1
 Q
