BQIRRPT ;PRXM/HC/ALA-Reports List ; 17 Oct 2007  6:24 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
EN(DATA,REG) ;EP -- BQI REPORT LIST
 ;
 ; Input
 ;  REG - Include reports for the passed register
 ;  
 NEW UID,BQII,RPTNM,IEN,DESC,DN,DIS,DEF,RPC,RGIEN,TYP,NOP,TAX,TXCK
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIRRPT",UID))
 K @DATA
 ;
 S BQII=0,REG=$G(REG,"")
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIRRPT D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(BQII)="T00030REPORT_NAME^T00040RPC^T00040DEFINITION^T00001DISPLAY_TYPE^T00030REPORT_TYPE^T00001NO_PARAMETER^T00030TAX_CHECK"_$C(30)
 ;
 S RPTNM=""
 F  S RPTNM=$O(^BQI(90506.6,"B",RPTNM)) Q:RPTNM=""  D
 . ;Temporary Check for Asthma Action Plan - Does not exist before BJPC 2.0
 . I RPTNM="Asthma Action Plan",$$VERSION^XPDUTL("BJPC")<2.0 Q
 . S IEN=""
 . F  S IEN=$O(^BQI(90506.6,"B",RPTNM,IEN)) Q:IEN=""  D
 .. I $P(^BQI(90506.6,IEN,0),U,4)=1 Q
 .. S RPC=$P(^BQI(90506.6,IEN,0),U,2)
 .. S DEF=$$GET1^DIQ(90506.6,IEN_",",.03,"E")
 .. ; Temporary check for BJPC 2.0 which includes new Patient Wellness Handout with associated type
 .. I RPTNM="Patient Wellness Handout" D
 ... S RESULT=$$VERSION^XPDUTL("BJPC") S RESULT=$S(RESULT<2.0:0,1:1)
 ... I 'RESULT S DEF=""
 .. S DIS=$$GET1^DIQ(90506.6,IEN_",",.05,"I")
 .. S TYP=$$GET1^DIQ(90506.6,IEN_",",.06,"E")
 .. S NOP=$$GET1^DIQ(90506.6,IEN_",",.07,"I")
 .. S TAX=$$GET1^DIQ(90506.6,IEN_",",.08,"E")
 .. S BQII=BQII+1,@DATA@(BQII)=RPTNM_"^"_RPC_"^"_DEF_"^"_DIS_"^"_TYP_"^"_NOP_"^"_TAX_$C(30)
 ;
 ; ** If including a register, pull those reports **
 I REG'="" D
 . S RGIEN=$O(^BQI(90507,"B",REG,""))
 . S IEN=0
 . F  S IEN=$O(^BQI(90507,RGIEN,20,IEN)) Q:'IEN  D
 .. I $P(^BQI(90507,RGIEN,20,IEN,0),U,4)=1 Q
 .. S RPTNM=$P(^BQI(90507,RGIEN,20,IEN,0),U,1)
 .. S RPC=$P(^BQI(90507,RGIEN,20,IEN,0),U,2)
 .. NEW DA,IENS,TYP
 .. S DA(1)=RGIEN,DA=IEN,IENS=$$IENS^DILF(.DA)
 .. S DEF=$$GET1^DIQ(90507.02,IENS_",",.03,"E")
 .. S TYP=$$GET1^DIQ(90507.02,IENS_",",.05,"E")
 .. S DIS=$$GET1^DIQ(90507.02,IENS_",",.06,"I")
 .. S NOP=$$GET1^DIQ(90507.02,IENS_",",.07,"I")
 .. S TXCK=$$GET1^DIQ(90507.02,IENS_",",.08,"I")
 .. S TAX="" I TXCK S TAX=$P(^BQI(90507,RGIEN,0),U,1)
 .. S BQII=BQII+1,@DATA@(BQII)=RPTNM_"^"_RPC_"^"_DEF_"^"_DIS_"^"_TYP_"^"_NOP_"^"_TAX_$C(30)
 S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
 ;
ERR ;Error trap
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(BQII),$D(DATA) S BQII=BQII+1,@DATA@(BQII)=$C(31)
 Q
