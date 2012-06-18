BTPWHIST ;VNGT/HS/BEE-CMET History ; 04 Feb 2009  2:55 PM
 ;;1.0;CARE MANAGEMENT EVENT TRACKING;;Feb 07, 2011
 Q
 ;
AUD(DATA,CMIEN) ;EP - BTPW EVENT AUDIT HISTORY
 ;
 ;This RPC returns any field changes recorded for a particular event
 ;
 ;Input:  CMIEN - Event IEN
 ;
 NEW UID,II,MDTTM,FLD,I
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BTPWHIST",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BTPWHIST D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="D00030BTPWLMDT^T00030BTPWLMBY^T00030BTPWCFLD^I00010BTPWENTR^T04096BTPWNVAL^T04096BTPWPVAL"_$C(30)
 ;
 ;Verify Event IEN was passed
 I CMIEN="" G DONE
 ;
 ;Load FLD array
 F I=1:1 S FLD=$P($T(FLDS+I),";;",2,99) Q:FLD=""  S FLD($P(FLD,";"),$P(FLD,";",2))=$P(FLD,";",3,99)
 ;
 ;
 S MDTTM="" F  S MDTTM=$O(^BTPWP(CMIEN,5,"B",MDTTM),-1) Q:MDTTM=""  D
 . ;
 . N MODDT,MIEN
 . S MODDT=$$FMTE^BQIUL1(MDTTM)
 . ;
 . S MIEN="" F  S MIEN=$O(^BTPWP(CMIEN,5,"B",MDTTM,MIEN),-1) Q:MIEN=""  D
 .. ;
 .. N USER,FILFLD,FILE,FIELD,FNAME,FTYPE,PFILE,VTYPE,CUR,PRV,ENTRY,EXEC
 .. ;
 .. S USER=$$GET1^DIQ(90620.05,MIEN_","_CMIEN_",",".02","I")
 .. I USER>0 S USER=$$GET1^DIQ(90620.05,MIEN_","_CMIEN_",",".02","E")
 .. S FILFLD=$$GET1^DIQ(90620.05,MIEN_","_CMIEN_",",".03","E")
 .. S FILE=$P(FILFLD,":")
 .. S FIELD=$P(FILFLD,":",2)
 .. S ENTRY="" I FILE["." S ENTRY=$P($P(FILFLD,":",3),",")
 .. S FLD=$G(FLD(FILE,FIELD)) Q:FLD=""
 .. S FNAME=$P(FLD,";") S:FNAME="" FNAME=FILE_":"_FIELD
 .. S FTYPE=$P(FLD,";",2)
 .. S PFILE=$P(FLD,";",3)
 .. S EXEC=$P(FLD,";",4)
 .. S VTYPE=$$GET1^DIQ(90620.05,MIEN_","_CMIEN_",",".04","I")
 .. S (CUR,PRV)=""
 .. ;
 .. ;Get regular field current/previous values
 .. I VTYPE="R" D
 ... ;
 ... N X
 ... ;
 ... ;Current Value
 ... S CUR=$$GET1^DIQ(90620.05,MIEN_","_CMIEN_",",102,"E")
 ... I CUR]"",FTYPE="S" S CUR=$$STC^BQIUL2(FILE,FIELD,CUR)
 ... I CUR]"",FTYPE="D" S CUR=$$FMTE^BQIUL1(CUR)
 ... I CUR]"",FTYPE="P" S CUR=$$GET1^DIQ(PFILE,CUR_",",".01","E")
 ... I CUR]"",FTYPE="X" S X=CUR X EXEC S CUR=X
 ... ;
 ... ;Previous Value
 ... S PRV=$$GET1^DIQ(90620.05,MIEN_","_CMIEN_",",101,"E")
 ... I PRV]"",FTYPE="S" S PRV=$$STC^BQIUL2(FILE,FIELD,PRV)
 ... I PRV]"",FTYPE="D" S PRV=$$FMTE^BQIUL1(PRV)
 ... I PRV]"",FTYPE="P" S PRV=$$GET1^DIQ(PFILE,PRV_",",".01","E")
 ... I PRV]"",FTYPE="X" S X=PRV X EXEC S PRV=X
 .. ;
 .. ;Get word processing current/previous values
 .. I VTYPE="W" D
 ... ;
 ... ;Current Value
 ... N CVAR,WP,SIEN
 ... S CVAR=$$GET1^DIQ(90620.05,MIEN_","_CMIEN_",",4,"","WP")
 ... S SIEN=0 F  S SIEN=$O(WP(SIEN)) Q:'SIEN  D
 .... S CUR=CUR_$S(CUR]"":" ",1:"")_WP(SIEN)
 ... K CVAR,WP,SIEN
 ... ;
 ... ;Previous Value
 ... N CVAR,WP,SIEN
 ... S CVAR=$$GET1^DIQ(90620.05,MIEN_","_CMIEN_",",3,"","WP")
 ... S SIEN=0 F  S SIEN=$O(WP(SIEN)) Q:'SIEN  D
 .... S PRV=PRV_$S(PRV]"":" ",1:"")_WP(SIEN)
 ... K CVAR,WP,SIEN
 .. ;
 .. S II=II+1,@DATA@(II)=MODDT_U_USER_U_FNAME_U_ENTRY_U_CUR_U_PRV_$C(30)
 ;
DONE ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
RLOG(VAR,USER,DTTM,DESC) ;EP -- Log Change to Tracked File - Regular fields
 ;
 N FIELD,FILE,IEN,ERROR
 ;
 ;Process each entry
 S FILE="" F  S FILE=$O(VAR(FILE)) Q:FILE=""  S IEN="" F  S IEN=$O(VAR(FILE,IEN)) Q:IEN=""  S FIELD="" F  S FIELD=$O(VAR(FILE,IEN,FIELD)) Q:FIELD=""  D
 . ;
 . N BHIST,CV,DA,DIC,DLAYGO,FILFLD,NV,X,Y
 . ;
 . ;Get New Value
 . S NV=VAR(FILE,IEN,FIELD)
 . ;
 . ;Pull current value
 . S CV=$$GET1^DIQ(FILE,IEN,FIELD,"I")
 . ;
 . ;File/Field
 . S FILFLD=FILE_":"_FIELD
 . ;
 . ;Quit if no difference in value
 . I NV=CV!((NV="@")&(CV="")) Q
 . ;
 . ;Pull Event IEN
 . S DA(1)=$P(IEN,",",$L(IEN,",")-1)
 . ;
 . ;Define new entry
 . S DIC="^BTPWP("_DA(1)_",5,"
 . S DIC(0)="L"
 . S X=DTTM S:X="" X=$$NOW^XLFDT()
 . S DLAYGO=90505.05,DIC(0)="L",DIC("P")=DLAYGO
 . I '$D(^BTPWP(DA(1),5,0)) S ^BTPWP(DA(1),5,0)="^90620.05DA^^"
 . K DO,DD D FILE^DICN
 . S DA=+Y
 . ;
 . ;Set up data
 . S BHIST(90620.05,DA_","_DA(1)_",",".02")=USER
 . S BHIST(90620.05,DA_","_DA(1)_",",".03")=FILFLD_":"_IEN
 . S BHIST(90620.05,DA_","_DA(1)_",",".04")="R"
 . S BHIST(90620.05,DA_","_DA(1)_",",".05")=DESC
 . S BHIST(90620.05,DA_","_DA(1)_",","101")=CV
 . S BHIST(90620.05,DA_","_DA(1)_",","102")=NV
 . ;
 . ;Save History
 . I $D(BHIST) D FILE^DIE("","BHIST","ERROR")
 ;
 Q
 ;
WLOG(NCOM,FILFLD,IEN,USER,DTTM,DESC) ;EP -- Log Change to Tracked File - Word Processing field
 ;
 N BHIST,CCOM,CHG,CVAR,DA,DIC,DLAYGO,FIELD,FILE,I,LST,NVAR,X,Y,ERROR
 ;
 S FILE=$P(FILFLD,":")
 S FIELD=$P(FILFLD,":",2)
 ;
 ;Set up comment reference variable
 I '$D(NCOM(1)) S NVAR="@"
 E  S NVAR="NCOM"
 ;
 ;Process Save Comment
 ;
 ;Pull current value
 S CVAR=$$GET1^DIQ(FILE,IEN,FIELD,"","CCOM")
 ;
 S CHG=0,LST=""
 S I="" F  S I=$O(CCOM(I)) Q:I=""  S LST=I I CCOM(I)'=$G(NCOM(I)) S CHG=1 Q
 I CHG=0 I $O(NCOM(LST))]"" S CHG=1
 ;
 ;No change to comments
 I CHG=0 Q
 ;
 ;Pull Event IEN
 S DA(1)=$P(IEN,",",$L(IEN,",")-1)
 ;
 ;Define new entry
 S DIC="^BTPWP("_DA(1)_",5,"
 S DIC(0)="L"
 S X=DTTM S:X="" X=$$NOW^XLFDT()
 S DLAYGO=90505.05,DIC(0)="L",DIC("P")=DLAYGO
 I '$D(^BTPWP(DA(1),5,0)) S ^BTPWP(DA(1),5,0)="^90620.05DA^^"
 K DO,DD D FILE^DICN
 S DA=+Y
 ;
 ;Set up data
 S BHIST(90620.05,DA_","_DA(1)_",",".02")=USER
 S BHIST(90620.05,DA_","_DA(1)_",",".03")=FILFLD_":"_IEN
 S BHIST(90620.05,DA_","_DA(1)_",",".04")="W"
 S BHIST(90620.05,DA_","_DA(1)_",",".05")=DESC
 ;
 ;Save History
 I $D(BHIST) D FILE^DIE("","BHIST","ERROR")  ;New Comments
 ;
 ;Save comments
 D WP^DIE(90620.05,DA_","_DA(1)_",",3,"",CVAR)  ;Save current comments
 D WP^DIE(90620.05,DA_","_DA(1)_",",4,"",NVAR)  ;Save new comments
 Q
 ;
DLOG(FILE,IENS,USER,DTTM,DESC) ;EP -- Log Deleted Entry Values to History
 ;
 N COM,VAL,RHIST,FIELD
 ;
 ;Pull existing field information
 D GETS^DIQ(FILE,IENS,"**","I","VAL")
 ;
 S FIELD="" F  S FIELD=$O(VAL(FILE,IENS,FIELD)) Q:FIELD=""  I FIELD'=1 S RHIST(FILE,IENS,FIELD)=""
 ;
 ;Save regular field history
 D RLOG(.RHIST,USER,DTTM,DESC)
 ;
 ;Save comment field history
 S COM(1)=""
 D WLOG(.COM,FILE_":1",IENS,USER,DTTM,DESC)
 ;
 Q
 ;
SLOG(RIEN,CMIEN,DTTM,USER,DESC) ;EP - Log Status Changes to History
 ;
 N CV,FILFLD,IEN,PVIEN,ERROR
 S (PVIEN,CV)="",FILFLD="90620:.08"
 S IEN=0 F  S IEN=$O(^BTPWQ(RIEN,2,IEN)) Q:'IEN  D
 . N BHIST,SDATA,NV,LDTTM,LUSER,DA,DIC,DLAYGO,X,Y
 . S SDATA=$G(^BTPWQ(RIEN,2,IEN,0))
 . S NV=$P(SDATA,U,2) ;Status value
 . S LDTTM=$P(SDATA,U,4)   ;Status changed date/time
 . S LUSER=$P(SDATA,U,3) ;Status changed by
 . ;
 . ;Define new entry
 . S DA(1)=CMIEN
 . S DIC="^BTPWP("_DA(1)_",5,"
 . S DIC(0)="L"
 . S X=LDTTM S:X="" X=$$NOW^XLFDT()
 . S DLAYGO=90505.05,DIC(0)="L",DIC("P")=DLAYGO
 . I '$D(^BTPWP(DA(1),5,0)) S ^BTPWP(DA(1),5,0)="^90620.05DA^^"
 . K DO,DD D FILE^DICN
 . S DA=+Y
 . ;
 . ;Set up data
 . S BHIST(90620.05,DA_","_DA(1)_",",".02")=LUSER
 . S BHIST(90620.05,DA_","_DA(1)_",",".03")=FILFLD_":"_CMIEN
 . S BHIST(90620.05,DA_","_DA(1)_",",".04")="R"
 . S BHIST(90620.05,DA_","_DA(1)_",",".05")=DESC
 . S BHIST(90620.05,DA_","_DA(1)_",","101")=CV
 . S BHIST(90620.05,DA_","_DA(1)_",","102")=NV
 . ;
 . ;Save History
 . I $D(BHIST) D FILE^DIE("","BHIST","ERROR")
 . ;
 . ;Save Status Comments
 . D SWLOG(RIEN,CMIEN,IEN,PVIEN)
 . ;
 . ;Save New Value to Current
 . S CV=NV,PVIEN=IEN
 ;
 K BHIST,DA,DIC,ERROR
 ;
 ;Log current status change
 ;
 N BHIST,DA,DIC,CVAR,PVWP,NVAR,NWP,CHG,LST,I,ERROR
 ;Define new entry
 S DA(1)=CMIEN
 S DIC="^BTPWP("_DA(1)_",5,"
 S DIC(0)="L"
 S X=DTTM S:X="" X=$$NOW^XLFDT()
 S DLAYGO=90505.05,DIC(0)="L",DIC("P")=DLAYGO
 I '$D(^BTPWP(DA(1),5,0)) S ^BTPWP(DA(1),5,0)="^90620.05DA^^"
 K DO,DD D FILE^DICN
 S DA=+Y
 ;
 ;Set up data
 S BHIST(90620.05,DA_","_DA(1)_",",".02")=USER
 S BHIST(90620.05,DA_","_DA(1)_",",".03")=FILFLD_":"_CMIEN
 S BHIST(90620.05,DA_","_DA(1)_",",".04")="R"
 S BHIST(90620.05,DA_","_DA(1)_",",".05")="Event Tracked"
 S BHIST(90620.05,DA_","_DA(1)_",","101")=CV
 S BHIST(90620.05,DA_","_DA(1)_",","102")="T"
 ;
 ;Save History
 I $D(BHIST) D FILE^DIE("","BHIST","ERROR")
 K BHIST,ERROR
 ;
 ;Log current Event Comment Change
 ;
 N BHIST,ERROR
 S FILE=90620
 S FIELD=4
 ;
 ;Pull previous history value
 I PVIEN]"" S CVAR=$$GET1^DIQ(90629.02,PVIEN_","_RIEN_",",1,"","PVWP")
 ;
 ;Pull current history value
 S NVAR=$$GET1^DIQ(90629,RIEN_",",3,"","NWP")
 ;
 S CHG=0,LST=""
 S I="" F  S I=$O(PVWP(I)) Q:I=""  S LST=I I PVWP(I)'=$G(NWP(I)) S CHG=1 Q
 I CHG=0 I $O(NWP(LST))]"" S CHG=1
 ;
 ;No change to comments
 I CHG=0 Q
 ;
 ;Pull Event IEN
 S DA(1)=CMIEN
 ;
 ;Define new entry
 S DIC="^BTPWP("_DA(1)_",5,"
 S DIC(0)="L"
 S X=DTTM S:X="" X=$$NOW^XLFDT()
 S DLAYGO=90505.05,DIC(0)="L",DIC("P")=DLAYGO
 I '$D(^BTPWP(DA(1),5,0)) S ^BTPWP(DA(1),5,0)="^90620.05DA^^"
 K DO,DD D FILE^DICN
 S DA=+Y
 ;
 ;Set up data
 S BHIST(90620.05,DA_","_DA(1)_",",".02")=USER
 S BHIST(90620.05,DA_","_DA(1)_",",".03")="90620:4:"_CMIEN
 S BHIST(90620.05,DA_","_DA(1)_",",".04")="W"
 S BHIST(90620.05,DA_","_DA(1)_",",".05")="Event Tracked"
 ;
 ;Save History
 I $D(BHIST) D FILE^DIE("","BHIST","ERROR")  ;New Comments
 ;
 ;Save comments
 D WP^DIE(90620.05,DA_","_DA(1)_",",3,"",CVAR)  ;Save current comments
 D WP^DIE(90620.05,DA_","_DA(1)_",",4,"",NVAR)  ;Save new comments
 Q
 ;
SWLOG(RIEN,CMIEN,NIEN,PVIEN) ;Save Status Comment Field History
 ;
 N BHIST,CHG,CVAR,DA,DIC,DLAYGO,FIELD,FILE,I,LST,NVAR,X,Y,PVWP,NWP,SDATA,LDTTM,LUSER,ERROR
 ;
 S FILE=90620
 S FIELD=4
 ;
 ;Pull previous history value
 I PVIEN]"" S CVAR=$$GET1^DIQ(90629.02,PVIEN_","_RIEN_",",1,"","PVWP")
 ;
 ;Pull current history value
 I NIEN]"" S NVAR=$$GET1^DIQ(90629.02,NIEN_","_RIEN_",",1,"","NWP")
 ;
 S CHG=0,LST=""
 S I="" F  S I=$O(PVWP(I)) Q:I=""  S LST=I I PVWP(I)'=$G(NWP(I)) S CHG=1 Q
 I CHG=0 I $O(NWP(LST))]"" S CHG=1
 ;
 ;No change to comments
 I CHG=0 Q
 ;
 ;Pull Event IEN
 S DA(1)=CMIEN
 ;
 ;Define new entry
 S SDATA=$G(^BTPWQ(RIEN,2,NIEN,0))
 S LDTTM=$P(SDATA,U,4)   ;Status changed date/time
 S LUSER=$P(SDATA,U,3) ;Status changed by
 S DIC="^BTPWP("_DA(1)_",5,"
 S DIC(0)="L"
 S X=LDTTM S:X="" X=$$NOW^XLFDT()
 S DLAYGO=90505.05,DIC(0)="L",DIC("P")=DLAYGO
 I '$D(^BTPWP(DA(1),5,0)) S ^BTPWP(DA(1),5,0)="^90620.05DA^^"
 K DO,DD D FILE^DICN
 S DA=+Y
 ;
 ;Set up data
 S BHIST(90620.05,DA_","_DA(1)_",",".02")=LUSER
 S BHIST(90620.05,DA_","_DA(1)_",",".03")="90620:4:"_CMIEN
 S BHIST(90620.05,DA_","_DA(1)_",",".04")="W"
 S BHIST(90620.05,DA_","_DA(1)_",",".05")="Status Changes"
 ;
 ;Save History
 I $D(BHIST) D FILE^DIE("","BHIST","ERROR")  ;New Comments
 ;
 ;Save comments
 D WP^DIE(90620.05,DA_","_DA(1)_",",3,"",CVAR)  ;Save current comments
 D WP^DIE(90620.05,DA_","_DA(1)_",",4,"",NVAR)  ;Save new comments
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
FLDS ;;
 ;;90620;.07;Date/Time Identified;D;
 ;;90620;.08;Status;X;;S X=$S(X="P":"PENDING",X="N":"NOT TRACKED",X="E":"EXCEPTION",X="S":"SUPERSEDED",X="T":"TRACKED",1:"")
 ;;90620;1.01;Event State;S;
 ;;90620;1.02;Event Tracked Date/Time;D;
 ;;90620;1.03;Event Tracked By;P;200;
 ;;90620;1.04;Close Reason;S;
 ;;90620;1.05;Findings Due By;D;
 ;;90620;1.06;Follow-up Decision Due By;D;
 ;;90620;1.07;Notification Due By;D;
 ;;90620;1.09;Last Modified Date/Time;D;
 ;;90620;1.1;Last Modified By;P;200;
 ;;90620;1.11;Follow-up Recommended?;S;
 ;;90620;3;State Comment;W;
 ;;90620;4;Event Comment;W;
 ;;90620.01;.01;Findings - Date;D;
 ;;90620.01;.02;Findings - Result;P;90620.9;
 ;;90620.01;.03;Findings - Interpretation;S;
 ;;90620.01;.04;Findings - Entered Date/Time;D;
 ;;90620.01;.05;Findings - Entered By;P;200;
 ;;90620.01;.06;Findings - Follow-Up Needed?;S;
 ;;90620.01;.08;Findings - Entered In Error;S;
 ;;90620.01;1;Findings - Comment;W;
 ;;90620.012;.02;Follow-ups - Event;P;90621;
 ;;90620.012;.03;Follow-ups - Date Entered;D;
 ;;90620.012;.04;Follow-ups - Entered By;P;200
 ;;90620.012;.05;Follow-ups - Date Due;D;
 ;;90620.012;.07;Follow-ups - Entered In Error;S;
 ;;90620.012;1;Follow-ups - Comment;W;
 ;;90620.011;.01;Notifications - Date;D;
 ;;90620.011;.02;Notifications - Method;P;90622;
 ;;90620.011;.03;Notifications - Entry Date;D;
 ;;90620.011;.04;Notifications - Entered By;P;200;
 ;;90620.011;.05;Notifications - Document;P;8925;
 ;;90620.011;.06;Notifications - TIU Document;P;8927.1;
 ;;90620.011;.07;Notifications - TIU Template;P;8927;
 ;;90620.011;.09;Notifications - Entered In Error;S;
 ;;90620.011;.1;Notifications - Addendum;P;8925;
 ;;90620.011;1;Notifications - Comment;W;
 ;;
