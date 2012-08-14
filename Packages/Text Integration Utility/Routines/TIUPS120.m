TIUPS120 ; SLC/JER - Post-install for TIU*1*120 ; 12-JUL-2001 10:59
 ;;1.0;TEXT INTEGRATION UTILITIES;**120**;Jun 20, 1997
MAIN ; Control Subroutine
 N TIUDAD,TIUCNT,TIUIDT,XPDIDTOT,XPDIDVT S TIUCNT=0,TIUDT=""
 S XPDIDVT=+$G(XPDIDVT)
 D BMES^XPDUTL(" ** FINDING DISCHARGE SUMMARIES THAT SHOULD BE ADDENDA **")
 S ^XTMP("TIUPS120",0)=$$FMADD^XLFDT(DT,90)_U_DT
 S TIUIDT=$$GETSTART
 D GATHER(TIUIDT)
 I '+$O(^XTMP("TIUPS120","DSLIST",0)) D BMES^XPDUTL(" No Aberrant Summaries Found...") Q
 S XPDIDTOT=$P(^XTMP("TIUPS120","DSLIST",0),U),XPDIDVT=+$G(XPDIDVT)
 D UPDATE^XPDID(0)
 S TIUDAD=0
 F  S TIUDAD=$O(^XTMP("TIUPS120","DSLIST",TIUDAD)) Q:+TIUDAD'>0  D
 . N TIUDA S TIUDA=0
 . F  S TIUDA=$O(^XTMP("TIUPS120","DSLIST",TIUDAD,TIUDA)) Q:+TIUDA'>0  D
 . . D FIX(TIUDAD,TIUDA) S TIUCNT=TIUCNT+1
 . . I '(TIUCNT#10) D UPDATE^XPDID(TIUCNT)
 Q
GATHER(TIUIDT) ; Fetch list of summaries to fix
 N TIUDT S TIUDT=""
 F  S TIUDT=$O(^TIU(8925,"F",TIUDT),-1) Q:TIUDT<TIUIDT!'+TIUDT  D
 . N TIUDA S TIUDA=""
 . F  S TIUDA=$O(^TIU(8925,"F",TIUDT,TIUDA),-1) Q:+TIUDA'>0  D
 . . N TIUD0 S TIUD0=$G(^TIU(8925,TIUDA,0))
 . . ; Only process discharge summaries
 . . Q:+$$ISDS^TIULX(+TIUD0)'>0
 . . ; Add cases where >1 summary is entered for the Admission
 . . D ADDLIST(TIUDA)
 . S ^XTMP("TIUPS120","CHKPNT")=TIUDT
 Q
ADDLIST(TIUDA) ; If Multiple Discharge Summaries are present, add to list
 N TIUD0,TIUD12,TIUVSTR,TIUDA1,TIUD01,TIUCNT,COUNT
 S TIUD0=$G(^TIU(8925,TIUDA,0)),TIUD12=$G(^(12))
 S TIUVSTR=$P(TIUD12,U,11)_";"_$P(TIUD0,U,7)_";"_$P(TIUD0,U,13)
 ; Only include cases where >1 summary exists for a Hospitalization
 S COUNT=+$$COUNT(+$P(TIUD0,U,2),+TIUD0,TIUVSTR)
 Q:COUNT'>1
 ; Get the first record in for the pt. and admission in question
 S TIUCNT=0,TIUDA1=""
 F  S TIUDA1=$O(^TIU(8925,"APTLD",+$P(TIUD0,U,2),+TIUD0,TIUVSTR,TIUDA1))  Q:+TIUDA1'>0  D
 . N TIUD01 S TIUD01=$G(^TIU(8925,TIUDA1,0))
 . ; Omit documents that have been deleted or retracted...
 . I +$P(TIUD01,U,5)>13 Q
 . S TIUCNT=TIUCNT+1
 . I TIUCNT=1 S TIUDAD=TIUDA1
 . I TIUDAD'=TIUDA1,'$D(^XTMP("TIUPS120","DSLIST",TIUDAD,TIUDA1)) D
 . . S ^XTMP("TIUPS120","DSLIST",TIUDAD,TIUDA1)=""
 . . S ^XTMP("TIUPS120","DSLIST",0)=+$G(^XTMP("TIUPS120","DSLIST",0))+1
 Q
COUNT(DFN,TTL,VSTR) ; How many are there
 N TIUY,TIUDA S (TIUDA,TIUY)=0
 F  S TIUDA=$O(^TIU(8925,"APTLD",DFN,+TTL,VSTR,TIUDA)) Q:+TIUDA'>0  D
 . N TIUD0 S TIUD0=$G(^TIU(8925,TIUDA,0))
 . ; Omit RETRACTED or DELETED records
 . Q:+$P(TIUD0,U,5)>13
 . S TIUY=TIUY+1
 Q TIUY
FIX(TIUDAD,TIUDA) ; Make TIUDA an addendum of TIUDAD
 N DA,DIE,DR
 S DIE=8925,DA=TIUDA,DR=".01////^S X=81;.06////^S X=TIUDAD"
 D ^DIE
 Q
GETSTART() ; Find out when Patch TIU*1*100 was installed
 N INSTDA,TIUY S INSTDA=""
 S TIUY=+$G(^XTMP("TIUPS120","CHKPNT"))
 I +TIUY>0 G GETSTX
 S INSTDA=$O(^XPD(9.7,"B","TIU*1.0*100",INSTDA),-1)
 S TIUY=+$P($G(^XPD(9.7,INSTDA,1)),U,3)
GETSTX Q TIUY