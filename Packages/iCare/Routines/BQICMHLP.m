BQICMHLP ;VNGT/HS/ALA-Care Mgmt Help ; 15 Apr 2009  3:57 PM
 ;;2.3;ICARE MANAGEMENT SYSTEM;;Apr 18, 2012;Build 59
 ;
EN(DATA,TYPE) ; EP -- BQI GET CARE MGMT HELP TEXT
 ; Input
 ;   TYPE - type of measures to list see table 90506.5 for list
 ;
 NEW UID,II,CMCOD,CODE,IEN,ORD,TTYPE,AVHELP
 ;
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQICMHLP",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQICMLST D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="T00050CARE^T00015CODE^T01024REPORT_TEXT"_$C(30)
 S TYPE=$G(TYPE,"")
 I TYPE'="" D   G DONE
 . I TYPE'?.N S CMCOD=$$FIND1^DIC(90506.5,"","B",TYPE,"","","ERROR")
 . I TYPE?.N S CMCOD=TYPE
 . ;
 . S TTYPE=$P($G(^BQI(90506.5,CMCOD,0)),U,2)
 . I TTYPE'="" D RET
 . ;
 . ;Get care management columns
 . D CMGT
 ;
 S TTYPE=""
 F  S TTYPE=$O(^BQI(90506.5,"C",TTYPE)) Q:TTYPE=""  D
 . S CMCOD=$O(^BQI(90506.5,"C",TTYPE,""))
 . S INACTIVE=$$GET1^DIQ(90506.5,CMCOD_",",.1,"I") Q:INACTIVE
 . S IEN=$O(^BQI(90506.1,"AD",TTYPE,""))
 . I IEN="" D CMGT Q
 . D RET
 ;
DONE ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
RET ;
 ; Check for Alternate Display Order first
 S ORD=""
 F  S ORD=$O(^BQI(90506.1,"AF",TTYPE,ORD)) Q:ORD=""  D
 . S IEN=""
 . F  S IEN=$O(^BQI(90506.1,"AF",TTYPE,ORD,IEN)) Q:IEN=""  D GETDATA(IEN)
 ;
 ; Check for normal display order
 S ORD=""
 F  S ORD=$O(^BQI(90506.1,"AD",TTYPE,ORD)) Q:ORD=""  D
 . S IEN=""
 . F  S IEN=$O(^BQI(90506.1,"AD",TTYPE,ORD,IEN)) Q:IEN=""  D GETDATA(IEN)
 Q
 ;
CMGT ; Additional Care Mgmt columns
 NEW KEY,DXCL,FDATA,CAT,REQ,SRC
 S KEY=$P(^BQI(90506.5,CMCOD,0),U,12)
 I KEY'="",'$$KEYCHK^BQIULSC(KEY,DUZ) Q
 S TYPE=$P(^BQI(90506.5,CMCOD,0),U,1)
 S DXCL=0
 F  S DXCL=$O(^BQI(90506.5,CMCOD,10,DXCL)) Q:'DXCL  D
 . S CODE=$P(^BQI(90506.5,CMCOD,10,DXCL,0),U,1)
 . S VHELP="",VN=0
 . F  S VN=$O(^BQI(90506.5,CMCOD,10,DXCL,4,VN)) Q:'VN  D
 .. S VHELP=VHELP_^BQI(90506.5,CMCOD,10,DXCL,4,VN,0)_$C(10)
 . ;
 . S VHELP=$$TKO^BQIUL1(VHELP,$C(10))
 . I $G(AVHELP)'="" S VHELP=AVHELP
 . ;
 . S II=II+1,@DATA@(II)=TYPE_U_CODE_U_VHELP_$C(30)
 . ;
 ;Get locally created care management columns if associated with a dx tag
 NEW DXTN
 S DXTN=$P($G(^BQI(90506.5,CMCOD,0)),U,11) I DXTN="" Q
 S DXCL=0
 F  S DXCL=$O(^BQI(90506.2,DXTN,6,DXCL)) Q:'DXCL  D
 . S CODE=$P(^BQI(90506.2,DXTN,6,DXCL,0),U,1)
 . S VHELP="",VN=0
 . F  S VN=$O(^BQI(90506.2,DXTN,6,DXCL,4,VN)) Q:'VN  D
 .. S VHELP=VHELP_^BQI(90506.2,DXTN,6,DXCL,4,VN,0)_$C(10)
 . ;
 . S VHELP=$$TKO^BQIUL1(VHELP,$C(10))
 . I $G(AVHELP)'="" S VHELP=AVHELP
 . ;
 . S II=II+1,@DATA@(II)=TYPE_U_CODE_U_VHELP_$C(30)
 Q
 ;
GETDATA(RIEN) ;EP - Get the reminder help text
 NEW VHELP,FILE,FIELD,NAME,BQIHELPW,BN,VN,KEY
 I $$GET1^DIQ(90506.1,RIEN_",",.1,"I")=1 Q
 S KEY=$$GET1^DIQ(90506.1,RIEN_",",3.1,"E")
 I KEY'="",'$$KEYCHK^BQIULSC(KEY,DUZ) Q
 S TYPE=$$GET1^DIQ(90506.1,RIEN_",",3.01,"E")
 S CODE=$P(^BQI(90506.1,RIEN,0),U,1) I CODE="" Q
 S VHELP="",VN=0
 F  S VN=$O(^BQI(90506.1,RIEN,4,VN)) Q:'VN  D
 . S VHELP=VHELP_^BQI(90506.1,RIEN,4,VN,0)_$C(10)
 ;
 S VHELP=$$TKO^BQIUL1(VHELP,$C(10))
 I $G(AVHELP)'="" S VHELP=AVHELP
 ;
 S II=II+1,@DATA@(II)=TYPE_U_CODE_U_VHELP_$C(30)
 Q
