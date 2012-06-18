ABSPOSD3 ; IHS/SD/RLT - DIAGNOSIS CODE ;  [ 06/21/2007  11:10 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**23**;JUN 21, 2007
 Q
 ; EDIT is called from the menu in ABSPOSO1,
 ;   typically reached from the pharmacy package's call
 ;   to OVERRIDE^ABSPOSO
 ;
 ; This routine is responsible for prompting and retaining
 ; the repeating DIGANOSIS CODES in the CLINICAL segment.
 ;
EDIT(DIAGIEN) ;EP called from ABSPOSO1 (menu option)
 ;**Don't believe this is needed for DIAGNOSIS CODE.
 ;**Left code from DUR just in case.
 ; Make sure the entry exists in the subfile.
 ; Create an empty one if necessary.
 ;
 N DIE,DA,DR,DIDEL,DTOUT
 S DA=DIAGIEN
 S DIE=9002313.491
 S DR=1
 D ^DIE
 ;
 Q
 ;
NEW() ;EP -  from ABSPOSII create new entry in 9002313.491
 F  Q:$$FLOCK  Q:'$$IMPOSS^ABSPOSUE("L","RTI","interlock on new DIAG rec create",,"NEW",$T(+0))
 ;
 N FLAGS,FDA,IEN,MSG,FN,X,NEWREC
 S FN=9002313.491
 D NEW1^ABSPOSO2
 D FUNLOCK
 ;
 Q NEWREC
 ;
 ;
CHKDIAG(DIAGIEN) ;EP    from ABSPOSII
 ;last step - delete if nothing entered
 ;
 N SUBR,FNDREC,CHKR
 ;
 S SUBR=0    ;starting point for review
 S FNDREC=1  ;assume we need to delete-reset if we find values
 F  S SUBR=$O(^ABSP(9002313.491,DIAGIEN,1,SUBR)) Q:'+SUBR  D
 . ;S CHKR=$TR($P($G(^ABSP(9002313.491,DIAGIEN,1,SUBR,0)),U,2,3),"^")
 . S CHKR=$P($G(^ABSP(9002313.491,DIAGIEN,1,SUBR,0)),U,3)
 . S:CHKR'="" FNDREC=0
 . D:CHKR="" DELSUB(DIAGIEN,SUBR)
 ;
 I FNDREC D
 . D DELREC(DIAGIEN)
 . S DIAGIEN=""
 ;
 Q DIAGIEN
 ;
DELSUB(DLIEN,DLSUB) ; delete subrecord - no valid information
 ;
 N FDA,MSG
 ;
 S FDA(9002313.4911,DLSUB_","_DLIEN_",",.01)="@"
DE3 D FILE^DIE("E","FDA","MSG")     ;delete the record
 Q:'$D(MSG)   ;successful deletion
 ;
 ; delete unsuccessful
 K ^TMP("ABSP",$J,"ABSPOSD3",$J,"DELSUB")
 S ^TMP("ABSP",$J,"ABSPOSD3",$J,"DELSUB")=$$ERRHDR
 D ZWRITE^ABSPOS("IEN","FDA","MSG")
 G DE3:$$IMPOSS^ABSPOSUE("FM","TR1",,,"DELSUB",$T(+0))
 Q
 ;
DELREC(DLIEN) ;delete record - no valid information
 ;
 N FDA,MSG
 ;
 S FDA(9002313.491,DLIEN_",",.01)="@"
DEL3 D FILE^DIE("E","FDA","MSG")     ;delete the record
 Q:'$D(MSG)   ;successful deletion
 ;
 ; delete unsuccessful
 K ^TMP("ABSP",$J,"ABSPOSD3",$J,"DELREC")
 S ^TMP("ABSP",$J,"ABSPOSD3",$J,"DELREC")=$$ERRHDR
 D ZWRITE^ABSPOS("IEN","FDA","MSG")
 G DEL3:$$IMPOSS^ABSPOSUE("FM","TR1",,,"DELREC",$T(+0))
 Q
 ;
NEWSUB(DIAGIEN) ;EP FROM ABSPOSII
 ; establish blank lines for new DIAG override entries
 ; on NEW POS claims (from page 20 on ABSP DATA INPUT)
 ;(block ABSP INPUT 5.1 DIAG INPUT)
 ;
 N REC,LASTREC,CNT,FDA,RECNUM,REP,SAVNUM
 S (CNT,LASTREC,SAVNUM,REC)=0
 ;
 F  S REC=$O(^ABSP(9002313.491,DIAGIEN,1,REC)) Q:'+REC  D
 . S SAVNUM=$P($G(^ABSP(9002313.491,DIAGIEN,1,REC,0)),"^")
 . S:SAVNUM>LASTREC LASTREC=SAVNUM
 . S CNT=CNT+1
 ;
 S:LASTREC>91 LASTREC=55  ;rec # lmt 99- 55 is random
 S ENDCNT=9-CNT   ;tie to the rep num on screen blk
 ;
 F REP=1:1:ENDCNT  D
 . S RECNUM=LASTREC+REP
 . N FDA,IEN
 . S FDA(9002313.4911,"+1,"_DIAGIEN_",",.01)=RECNUM
 . D UPDATE^DIE("E","FDA","IEN")
 ;
 Q
 ;
FLOCK() L +^ABSP(9002313.491):300 Q $T
FUNLOCK L -^ABSP(9002313.491) Q
ERRHDR() Q "ERROR AT $H="_$H_" FOR $J="_$J
