BTPWPSNP ;VNGT/HS/BEE-Get the Patient CMET Snapshot Events ; 21 Sep 2009  12:00 PM
 ;;1.0;CARE MANAGEMENT EVENT TRACKING;;Feb 07, 2011
 ;
GET(DATA,CNT,SRC,DFNLST) ; EP - BTPW GET PATIENT SNAPSHOT
 ; Input parameters
 ;   CNT   - Count of # of records to return
 ;   SRC   - Values to continue search on
 ;   DFN   - Patient DFN
 ;
 NEW UID,II,CMIEN,RESULT,HDR,QFL,CT,DFN,DP,DSTRT,DFND
 ;
 ;NEW COMM,BJ,CIN,RESULT,QFL,CT,VALUE,WHEN,WHO,TRN,STAGE,HDR,CLOSE,STATE,CATLST
 ;NEW FDUE,NDUE,PCOM,PREV,PRVIEN,RDUE,OSTATE,CMIEN,TMFRAME,BDT,EDT,CAT,COMM,COMMTX
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BTPWPSNP",UID))
 K @DATA
 I $G(DT)=""!($G(U)="") D DT^DICRW
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BTPWPEVT D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ;Convert from possible DFN list array
 I DFNLST="" D
 . N LIST,BN
 . S LIST="",BN=""
 . F  S BN=$O(DFNLST(BN)) Q:BN=""  S LIST=LIST_DFNLST(BN)
 . S DFNLST=LIST
 ;
 ;Initialize/save original values
 S SRC=$G(SRC,"")
 S CNT=+$G(CNT)
 ;
 ;Define Header
 D HDR
 S @DATA@(0)=HDR_$C(30)
 ;
 S QFL=0
 ;
 ;Pull the last record info
 S DSTRT=1,DFN=$P(SRC,$C(29),2) I DFN]"" F DFND=1:1:$L(DFNLST,$C(29)) I $P(DFNLST,$C(29),DFND)=DFN S DSTRT=DFND
 S CMIEN=$P(SRC,$C(29),1)
 ;
 S CT=0,QFL=0
 ;
 ;Loop through index (at selected point) and retrieve records
 I DFNLST]"" F DP=DSTRT:1:$L(DFNLST,$C(28)) S DFN=$P(DFNLST,$C(28),DP) D  Q:QFL
 . F  S CMIEN=$O(^BTPWP("AE",DFN,"O",CMIEN)) Q:CMIEN=""  D  Q:QFL
 .. ;
 .. ;Get Event Information
 .. D SNG(CMIEN,.RESULT) I RESULT="" Q
 .. S SRC=CMIEN_$C(29)_DFN
 .. S CT=CT+1 I CNT'=0,CT=CNT S QFL=1
 .. S II=II+1,@DATA@(II)=RESULT_U_SRC_$C(30)
 ;
DONE ;
 I II=0,'$D(@DATA@(II)) S:$E(HDR,$L(HDR))="^" HDR=$E(HDR,1,$L(HDR)-1) S @DATA@(II)=HDR_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
HDR ;
 S HDR="I00010HIDE_CMIEN^I00010HIDE_VISIT_IEN^T00040CATEGORY^I00010HIDE_DFN^D00030PROC_DATE^T00060PROCEDURE^T01024FINDINGS"
 S HDR=HDR_"^T01024FOLLOW_UPS^T01024NOTIFICATIONS^T01024HIDE_SEARCH"
 Q
 ;
SNG(CMIEN,RESULT) ; Get the basic record information for a single record
 NEW DFN,PNAM,PCOM,TDATA,PROC,PROCNM,CAT,STATUS,HRN,DOB,AGE,SEX,PRCDT,RES,PEV,FND,FUP,NOT,STATE,WHO,WHEN,VISIT
 NEW FNDT,FLDT,NODT
 ;
 S TDATA=$G(^BTPWP(CMIEN,0)),DFN=$P(TDATA,U,2),PCOM="",PNAM=$P(^DPT(DFN,0),"^",1)
 ;
 ;Community check
 S PCOM=$$GET1^DIQ(9000001,DFN_",",1117,"I")
 I PCOM'="" S PCOM=$$GET1^DIQ(9000001,DFN_",",1117,"E")  ;Community
 ;
 S PROC=$P(TDATA,U,1),PROCNM=$P(^BTPW(90621,PROC,0),U,1)  ;Procedure/Name (Event)
 S CAT=$$CAT^BTPWPDSP(PROC)  ;Category
 S HRN=$$HRNL^BQIULPT(DFN)   ;HRN
 S DOB=$$FMTE^BQIUL1($$GET1^DIQ(2,DFN_",",.03,"I")) ;DOB
 S AGE=$$AGE^BQIAGE(DFN,,1)  ;Age
 S SEX=$$GET1^DIQ(2,DFN_",",.02,"I")  ;Sex
 S PRCDT=$$FMTE^BQIUL1($P(TDATA,U,3))  ;Event Date
 S VISIT=$P(TDATA,U,4)
 ;
 S RES=$$LNK^BTPWPTRG(CMIEN,.06)  ;Result
 ;
 S PEV=$P(TDATA,U,11) S:'PEV PEV=""  ;Preceding Event
 ;
 ;Findings
 S FND="",FNDT=$$GET1^DIQ(90620,CMIEN_",",1.05,"I") D
 . N FIEN,FNODE,FVAL,FFLG,FSTR
 . ;
 . ;Look for findings
 . S (FFLG,FIEN)=0,FSTR="" F  S FIEN=$O(^BTPWP(CMIEN,10,FIEN)) Q:'FIEN  D
 .. ;
 .. ;Skip ENTERED IN ERROR
 .. I $$GET1^DIQ(90620.01,FIEN_","_CMIEN_",",.08,"I")="Y" Q
 .. ;
 .. S FNODE=$G(^BTPWP(CMIEN,10,FIEN,0))
 .. S FVAL=$P($$GET1^DIQ(90620.01,FIEN_","_CMIEN_",",.01,"E"),"@")_"   "_$$GET1^DIQ(90620.01,FIEN_","_CMIEN_",",.02,"E"),FFLG=1
 .. S FSTR=FSTR_$S(FSTR]"":$C(13)_$C(10),1:"")_FVAL
 . I FFLG=1 S FND="CHECK"_$C(28)_"FINDING DATE   FINDING VALUE"_$C(13)_$C(10)_FSTR Q
 . ;
 . ;If no findings, check for past due
 . I FFLG=0 D
 .. I FNDT]"",FNDT<DT S FND="TICKLER"_$C(28)_"DUE DATE"_$C(13)_$C(10)_$P($$GET1^DIQ(90620,CMIEN_",",1.05,"E"),"@")
 ;
 ;Follow Ups
 S FUP="",FNDT=$$GET1^DIQ(90620,CMIEN_",",1.06,"I") D
 . N FIEN,FNODE,FVAL,FFLG,FSTR,FLUN
 . ;
 . ;Look for follow-up needed
 . S FLUN=$$GET1^DIQ(90620,CMIEN_",",1.11,"I") I FLUN="N" S FUP="N/A"_$C(28)_"Follow-up Not Recommended" Q
 . ;
 . ;Look for follow ups
 . S (FFLG,FIEN)=0,FSTR="" F  S FIEN=$O(^BTPWP(CMIEN,12,FIEN)) Q:'FIEN  D
 .. ;
 .. ;Skip ENTERED IN ERROR
 .. I $$GET1^DIQ(90620.012,FIEN_","_CMIEN_",",.07,"I")="Y" Q
 .. ;
 .. S FNODE=$G(^BTPWP(CMIEN,12,FIEN,0))
 .. S FVAL=$P($$GET1^DIQ(90620.012,FIEN_","_CMIEN_",",.01,"E"),"@")_"    "_$$GET1^DIQ(90620.012,FIEN_","_CMIEN_",",.02,"E"),FFLG=1
 .. S FSTR=FSTR_$S(FSTR]"":$C(13)_$C(10),1:"")_FVAL
 . I FFLG=1 S FUP="CHECK"_$C(28)_"FOLLOWUP DATE   FOLLOW UP"_$C(13)_$C(10)_FSTR Q
 . ;
 . ;If no follow ups, check for past due
 . I FFLG=0 D
 .. I FNDT]"",FNDT<DT S FUP="TICKLER"_$C(28)_"DUE DATE"_$C(13)_$C(10)_$P($$GET1^DIQ(90620,CMIEN_",",1.06,"E"),"@")
 ;
 S NOT="",FNDT=$$GET1^DIQ(90620,CMIEN_",",1.07,"I") D
 . N FIEN,FNODE,FVAL,FFLG,FSTR
 . ;
 . ;Look for notifications
 . S (FFLG,FIEN)=0,FSTR="" F  S FIEN=$O(^BTPWP(CMIEN,11,FIEN)) Q:'FIEN  D
 .. ;
 .. ;Skip ENTERED IN ERROR
 .. I $$GET1^DIQ(90620.011,FIEN_","_CMIEN_",",.09,"I")="Y" Q
 .. ;
 .. S FNODE=$G(^BTPWP(CMIEN,11,FIEN,0))
 .. S FVAL=$P($$GET1^DIQ(90620.011,FIEN_","_CMIEN_",",.01,"E"),"@")_"      "_$$GET1^DIQ(90620.011,FIEN_","_CMIEN_",",.02,"E"),FFLG=1
 .. S FSTR=FSTR_$S(FSTR]"":$C(13)_$C(10),1:"")_FVAL
 . I FFLG=1 S NOT="CHECK"_$C(28)_"NOTIFICATION DT   NOTIFICATION"_$C(13)_$C(10)_FSTR Q
 . ;
 . ;If no notifications, check for past due
 . I FFLG=0 D
 .. I FNDT]"",FNDT<DT S NOT="TICKLER"_$C(28)_"DUE DATE"_$C(13)_$C(10)_$P($$GET1^DIQ(90620,CMIEN_",",1.07,"E"),"@")
 ;
 S STATE=$$GET1^DIQ(90620,CMIEN_",",1.01,"E")  ;STATE
 S WHO=$$GET1^DIQ(90620,CMIEN_",",1.1,"E")  ;LAST MODIFIED BY
 S WHEN=$$FMTE^BQIUL1($$GET1^DIQ(90620,CMIEN_",",1.09,"I"))  ;LAST MODIFIED DATE
 ;
 S RESULT=CMIEN_U_VISIT_U_CAT_U_DFN_U_PRCDT_U_PROCNM_U_FND_U_FUP_U_NOT
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 S II=II+1,@DATA@(II)=$C(31)
 Q
