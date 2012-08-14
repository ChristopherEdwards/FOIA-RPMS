BTPWRMDR ;VNGT/HS/ALA-CMET Reminders ; 13 Nov 2009  1:49 PM
 ;;1.0;CARE MANAGEMENT EVENT TRACKING;;Feb 07, 2011
 ;
 ;
PAT(DATA,DFN) ; EP -- BTPW GET CMET REMINDERS BY PAT
 ; Input
 ;   DFN - Patient internal entry number
 ;
 NEW UID,II,ERROR,BQIDFN,EVT,EVDT,CMIEN,EVNAM,LAST
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BTPWRMDR",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BTPWRMDR D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 D HDR
 S BQIDFN=$G(DFN,"")
 I BQIDFN="" S BMXSEC="No patient selected" Q
 ;
 S EVT=""
 F  S EVT=$O(^BTPWP("AG",BQIDFN,EVT)) Q:EVT=""  D
 . S EVDT=""
 . F  S EVDT=$O(^BTPWP("AG",BQIDFN,EVT,EVDT)) Q:EVDT=""  D
 .. S CMIEN=""
 .. F  S CMIEN=$O(^BTPWP("AG",BQIDFN,EVT,EVDT,CMIEN)) Q:CMIEN=""  D
 ... S EVNAM=$P(^BTPW(90621,EVT,0),U,1),LAST="",VISIT=""
 ... S LSUPD=$P($G(^BTPWP(CMIEN,1)),U,2)\1
 ... S LSTN=$P(^BTPWP(CMIEN,0),U,11) I LSTN'="" D
 .... I $P(^BTPWP(LSTN,0),U,1)=EVT S LAST=$P($G(^BTPWP(LSTN,0)),U,3),VISIT=$P(^(0),U,4) Q
 ... I LAST="" D
 .... S LAST=$O(^XTMP("BTPWPRC",BQIDFN,EVT,""),-1) I LAST="" Q
 .... S PRI=""
 .... F  S PRI=$O(^XTMP("BTPWPRC",BQIDFN,EVT,LAST,PRI)) Q:PRI=""  D
 ..... S VIS=""
 ..... F  S VIS=$O(^XTMP("BTPWPRC",BQIDFN,EVT,LAST,PRI,VIS)) Q:VIS=""  I VIS'="~" S VISIT=VIS Q
 ... S CODE="CMET_"_EVT,EVDT=EVDT\1
 ... S II=II+1,@DATA@(II)="CMET^"_$$CAT^BTPWPDSP(EVT)_U_CODE_U_EVNAM_U_$$FMTE^BQIUL1(LAST)_U
 ... S @DATA@(II)=@DATA@(II)_$$FMTE^BQIUL1(EVDT)_U_$$FMTE^BQIUL1(EVDT)_U_$$FMTE^BQIUL1(LSUPD)_U_VISIT_U_$C(30)
 ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)="-1"_$C(30)
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
HDR ; Header
 S @DATA@(II)="T00030CATEGORY^T00030CLIN_GROUP^T00015REM_CODE^T00050REM_DESC^D00010REM_LAST^"
 S @DATA@(II)=@DATA@(II)_"T00040REM_NEXT^D00010REM_DUE^D00030LAST_UPDATED^I00010VISIT_IEN^I00003DISPLAY_ORDER"_$C(30)
 Q
 ;
REC(BQIDFN) ; EP - Get records
 S EVT=""
 F  S EVT=$O(^BTPWP("AG",BQIDFN,EVT)) Q:EVT=""  D
 . S EVDT=""
 . F  S EVDT=$O(^BTPWP("AG",BQIDFN,EVT,EVDT)) Q:EVDT=""  D
 .. S CMIEN=""
 .. F  S CMIEN=$O(^BTPWP("AG",BQIDFN,EVT,EVDT,CMIEN)) Q:CMIEN=""  D
 ... S EVNAM=$P(^BTPW(90621,EVT,0),U,1),LAST=$$FMTE^BQIUL1($P($G(^BTPW(90621,EVT,1)),U,2))
 ... S II=II+1,@DATA@(II)="CMET^"_$$CAT^BTPWPDSP(EVT)_U_U_EVNAM_U_U_U_$$FMTE^BQIUL1(EVDT)_U_LAST_U_U_$C(30)
 Q
 ;
EVT(BQIDFN,EVENT,SYS) ; PEP - Return CMET Event information
 ; Input
 ;   BQIDFN - Patient IEN
 ;   EVENT   - CMET Event IEN or CMET Event Name
 ;   SYS    - '1' = EHR for a structure for EHR
 ;
 ;  Output
 ;  SYS = 1 (for EHR) - 0 is no result, 1 is result RESULT_"^"_LAST_"^"_DUE
 ;  SYS not = 1 (for Health Summary) - BLANK is returned for no result
 ;       CMET^BREAST^CMET_24^MAMMOGRAM SCREENING^JAN 14,2008^JAN 13,2009^3090113^OCT 21,2010^2631823^
 ;    where from^category^internal value^event name^last done^next due normal date^next due FileMan date^last updated^visit IEN
 ;  
 NEW EVDT,CMIEN,EVNAM,LAST,VISIT,LSUPD,LSTN,PRI,VIS,CODE,RESULT,EVDUE,EVNT
 S SYS=$G(SYS,0)
 I EVENT'?.N S EVNT=$O(^BTPW(90621,"B",EVENT,"")) I EVNT="" Q "-1^Event "_EVENT_" not found"
 I EVENT?.N S EVNT=EVENT
 S EVDT="",LAST=""
 F  S EVDT=$O(^BTPWP("AG",BQIDFN,EVNT,EVDT)) Q:EVDT=""  D
 . S CMIEN=""
 . F  S CMIEN=$O(^BTPWP("AG",BQIDFN,EVNT,EVDT,CMIEN)) Q:CMIEN=""  D
 .. S EVNAM=$P(^BTPW(90621,EVNT,0),U,1),LAST="",VISIT=""
 .. S LSUPD=$P($G(^BTPWP(CMIEN,1)),U,2)\1
 .. S LSTN=$P(^BTPWP(CMIEN,0),U,11) I LSTN'="" D
 ... I $P(^BTPWP(LSTN,0),U,1)=EVNT S LAST=$P($G(^BTPWP(LSTN,0)),U,3),VISIT=$P(^(0),U,4) Q
 .. I LAST="" D
 ... S LAST=$O(^XTMP("BTPWPRC",BQIDFN,EVNT,""),-1) I LAST="" Q
 ... S PRI=""
 ... F  S PRI=$O(^XTMP("BTPWPRC",BQIDFN,EVNT,LAST,PRI)) Q:PRI=""  D
 .... S VIS=""
 .... F  S VIS=$O(^XTMP("BTPWPRC",BQIDFN,EVNT,LAST,PRI,VIS)) Q:VIS=""  I VIS'="~" S VISIT=VIS Q
 .. S EVDUE=EVDT\1
 ;
 S CODE="CMET_"_EVNT
 I 'SYS D
 . I $G(EVNAM)="" S RESULT="" Q
 . S RESULT="CMET^"_$$CAT^BTPWPDSP(EVNT)_U_CODE_U_EVNAM_U_$$FMTE^BQIUL1(LAST)_U
 . S RESULT=RESULT_$$FMTE^BQIUL1(EVDUE)_U_EVDUE_U_$$FMTE^BQIUL1(LSUPD)_U_VISIT_U
 I SYS D
 . I $G(EVNAM)="" S RESULT=0 Q
 . S RESULT=1_U_$$FMTE^BQIUL1(LAST)_U_$$FMTE^BQIUL1(EVDUE)
 Q RESULT