BTPWPUTL ;VNGT/HS/ALA-Event Utility Program ; 21 Aug 2009  10:26 AM
 ;;1.0;CARE MANAGEMENT EVENT TRACKING;;Feb 07, 2011
 ;
 ;
FDUE() ; EP - Findings Due By Timeframe
 NEW VALUE
 S VALUE=$$GET1^DIQ(90628,"1,",1.01,"E")
 D SYS
 Q VALUE
 ;
FLDUE(EVNT,FNDT,TRIEN,TMFRAME) ;EP - Followup Due By Timeframe
 ; Input
 ;  EVNT  - Event type IEN
 ;  FNDT  - Findings Date
 ;  TRIEN - Tracked IEN
 ;  TMFRAME - Timeframe
 ; 
 NEW VALUE,IEN,FLDUE
 S EVNT=$G(EVNT,""),FNDT=$G(FNDT,""),TRIEN=$G(TRIEN,""),TMFRAME=$G(TMFRAME,"")
 S VALUE=$$GET1^DIQ(90628,"1,",1.02,"E") D SYS
 ;
 ; if finding date not input but tracked ien is, get it from tracked event
 I $G(FNDT)="",$G(TRIEN)'="" D
 . S FNDT=$O(^BTPWP(TRIEN,10,"B",""),-1) I FNDT'="" S FNDT=FNDT\1
 ;
 ; if event passed in, get Followup Due By based on event type
 I $G(EVNT)'="",$G(TMFRAME)="" D
 . S IEN=$O(^BTPW(90628,1,2,"B",EVNT,"")) I IEN="" Q
 . S TMFRAME=$P($G(^BTPW(90628,1,2,IEN,0)),U,2)
 ;
 S TMFRAME=$S(TMFRAME="24M":730,TMFRAME="36M":1095,1:365)
 ;
 S FLDUE=$$FMADD^XLFDT(FNDT,TMFRAME)
 Q FLDUE
 ;
DFDUE(TRIEN,TMFRAME) ; EP - Get Findings Due By Date
 ; Input
 ;   TRIEN   - Tracked record IEN
 ;   TMFRAME - Timeframe for findings due by date
 ; 
 NEW EVTDT,FDUE
 S TMFRAME=$G(TMFRAME,"")
 S EVTDT=$P(^BTPWQ(TRIEN,0),U,3)
 I TMFRAME'="" S VALUE=TMFRAME D SYS S TMFRAME=VALUE
 I TMFRAME="" S TMFRAME=$$FDUE()
 S FDUE=$$FMADD^XLFDT(EVTDT,TMFRAME)
 I FDUE<DT S FDUE=DT
 Q FDUE
 ;
NTDUE(TRIEN,TMFRAME) ; EP - Get Notification Due By Date
 ; Input
 ;   TRIEN   - Tracked record IEN
 ;   TMFRAME - Timeframe for notification date
 NEW NDUE,FOLDT
 S TMFRAME=$G(TMFRAME,"")
 ; if timeframe is not passed in get default value from site parameters
 I TMFRAME="" D
 . S VALUE=$$GET1^DIQ(90628,"1,",1.03,"E") D SYS
 . S TMFRAME=VALUE
 ;
 ; notification date is based on the date the Follow-up recommendation is entered
 S FOLDT=$O(^BTPWP(TRIEN,12,"B",""),-1)
 S NDUE=$$FMADD^XLFDT(FOLDT,TMFRAME)
 I NDUE<DT S NDUE=DT
 Q NDUE
 ;
GET(DATA,EVTDT) ;EP -- BTPW GET FINDINGS DUE BY
 NEW UID,II,FDUE,TMFRAME
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BTPWFDUE",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BTPWSCHD D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 ;Convert Date to Internal Value
 S EVTDT=$$DATE^BQIUL1(EVTDT)
 ;
 S @DATA@(II)="D00015FIND_DUEBY"_$C(30)
 S TMFRAME=$$FDUE()
 S FDUE=$$FMADD^XLFDT(EVTDT,TMFRAME)
 I FDUE<DT S FDUE=DT
 S II=II+1,@DATA@(II)=$$FMTE^BQIUL1(FDUE)_$C(30)
 ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
SYS ;EP
 I VALUE="" S VALUE=7
 I VALUE["M" D
 . I VALUE="1M" S VALUE=30 Q
 . I VALUE="2M" S VALUE=60
 Q
 ;
PFIN(PROCN,RESULT) ;EP - Get findings
 ; Input
 ;   PROCN - Procedure IEN
 ; Return RESULT array
 ;
 NEW IEN,II,FIIEN,FIND,INTRP
 S IEN=0,II=0
 F  S IEN=$O(^BTPW(90621,PROCN,6,IEN)) Q:'IEN  D
 . S FIIEN=$P(^BTPW(90621,PROCN,6,IEN,0),U,1)
 . NEW DA,IENS
 . S DA(1)=PROCN,DA=IEN,IENS=$$IENS^DILF(.DA)
 . S FIND=$$GET1^DIQ(90621.06,IENS,.01,"E")
 . S INTRP=$$GET1^DIQ(90621.06,IENS,.02,"E")
 . S II=II+1,RESULT(II)=FIIEN_U_FIND_U_INTRP
 Q
