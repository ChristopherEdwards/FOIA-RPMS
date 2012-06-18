BTPWPCLO ;VNGT/HS/ALA-Close Event ; 20 Oct 2009  3:46 PM
 ;;1.0;CARE MANAGEMENT EVENT TRACKING;**1**;Feb 07, 2011;Build 37
 ;
 ;
VAL(DATA,CLIST) ;EP -- BTPW VALIDATE CLOSE EVENT
 ; Input
 ;    CLIST - List of tracked items that are being closed
 ; Output
 ;    RESULT   - 1 is okay to proceed, -1 cannot proceed 
 ;    MSG      - Message to display for either a 'W' or an 'O'
 ;    HANDLER  - 'W' is a warning message to be displayed, 'O' is an override
 ;    CMET_IEN - Record that passed or failed.
 NEW UID,II,BQI,LIST,BN,ANSWR,MESG,RES,MSG,VAL,ANSWF,ANSWN,CMIEN,HNDLR
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BTPWPCLO",UID))
 K @DATA
 S II=0,MSG=""
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BTPWPCLO D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="I00010RESULT^T00100MSG^T00001HANDLER^I00010CMET_IEN"_$C(30)
 ;
 I $D(CLIST)>1 D
 . S LIST="",BN=""
 . F  S BN=$O(CLIST(BN)) Q:BN=""  S LIST=LIST_CLIST(BN)
 . K CLIST S CLIST=LIST
 I $G(CLIST)'="" D
 . F BQI=1:1 S CMIEN=$P(CLIST,$C(28),BQI) Q:CMIEN=""  D
 .. S ANSWR=$$FND(CMIEN),MESG="",MSG="",HNDLR="" K VAL
 .. S RES=$P(ANSWR,U,1),MSG=$P(ANSWR,U,2),VAL(RES)=$G(VAL(RES))_MSG_"; "
 .. S ANSWF=$$FOL(CMIEN)
 .. S RES=$P(ANSWF,U,1),MSG=$P(ANSWF,U,2),VAL(RES)=$G(VAL(RES))_MSG_"; "
 .. S ANSWN=$$NOT(CMIEN)
 .. S RES=$P(ANSWN,U,1),MSG=$P(ANSWN,U,2),VAL(RES)=$G(VAL(RES))_MSG_"; "
 .. S RES=$O(VAL(""))
 .. I RES=-1 S MESG=$$TKO^BQIUL1(VAL(RES),"; "),HNDLR="O"
 .. S II=II+1,@DATA@(II)=RES_"^"_$G(MESG)_U_$G(HNDLR)_U_$G(CMIEN)_$C(30)
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
FND(CMIEN) ;EP - Findings complete?
 NEW FN,FNDATA,FND
 S (FN,FND)=0 F  S FN=$O(^BTPWP(CMIEN,10,FN)) Q:'FN  D  Q:FND
 . I $$GET1^DIQ(90620.01,FN_","_CMIEN_",",".01","I")="" Q  ;Bad Entry
 . I $$GET1^DIQ(90620.01,FN_","_CMIEN_",",".08","I")="Y" Q  ;Entered-in-Error
 . S FND=1
 I FND=0 Q "-1"_U_"No findings found"
 Q "1^"
 ;
FOL(CMIEN) ;EP - Followup complete?
 NEW FN,FOL,FNDATA
 ;
 ;First check if follow-up is needed
 S FN=$$GET1^DIQ(90620,CMIEN_",",1.11,"I") I FN="N" Q "1^"
 S (FN,FOL)=0 F  S FN=$O(^BTPWP(CMIEN,12,FN)) Q:'FN  D  Q:FOL
 . I $$GET1^DIQ(90620.012,FN_","_CMIEN_",",".01","I")="" Q  ;Bad Entry
 . I $$GET1^DIQ(90620.012,FN_","_CMIEN_",",".07","I")="Y" Q  ;Entered-in-Error
 . S FOL=1
 I FOL=0 Q "-1"_U_"No followup found"
 Q "1^"
 ;
NOT(CMIEN) ;EP - Notification complete?
 NEW FN,NOT,FNDATA
 S (FN,NOT)=0 F  S FN=$O(^BTPWP(CMIEN,11,FN)) Q:'FN  D  Q:NOT
 . I $$GET1^DIQ(90620.01,FN_","_CMIEN_",",".01","I")="" Q  ;Bad Entry
 . I $$GET1^DIQ(90620.01,FN_","_CMIEN_",",".09","I")="Y" Q  ;Entered-in-Error
 . S NOT=1
 I NOT=0 Q "-1"_U_"No Notifications found"
 Q "1^"
