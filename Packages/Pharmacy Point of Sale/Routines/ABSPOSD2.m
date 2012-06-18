ABSPOSD2 ; IHS/FCS/DRS - NCPDP DUR overrides ;  [ 09/03/2002  11:10 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**6**;JUN 21, 2001
 Q
 ; EDIT is called from the menu in ABSPOSO1,
 ;   typically reached from the pharmacy package's call
 ;   to OVERRIDE^ABSPOSO
 ; GET511 is called from ABSPOSCD during claim construction
 ;
 ; This routine will be responsible for prompting for
 ; and retaining the now repeating DUR segment values
 ; for the NCPDP 5.1 format.
 ;
EDIT(DURIEN) ;EP called from ABSPOSO1 (menu option)
 ;
 ; Make sure the entry exists in the subfile.
 ; Create an empty one if necessary.
 ;
 N DIE,DA,DR,DIDEL,DTOUT
 S DA=DURIEN
 S DIE=9002313.473
 S DR=1
 D ^DIE
 ;
 ;
 Q
 ;
 ;
NEW() ;EP -  create new entry in 9002313.473
 F  Q:$$FLOCK  Q:'$$IMPOSS^ABSPOSUE("L","RTI","interlock on new DUR rec create",,"NEW",$T(+0))
 ;
 N FLAGS,FDA,IEN,MSG,FN,X,NEWREC
 S FN=9002313.473
 D NEW1^ABSPOSO2
 D FUNLOCK
 ;
 Q NEWREC
 ;
 ;
CHKDUR(DURIEN) ;EP this should be the last step - we
 ; need to check the DUR entry, if nothing was input
 ; let's get rid of it.
 ;
 N SUBR,FNDREC
 ;
 S SUBR=0    ;starting point for review
 S FNDREC=1  ;assume we need to delete-reset if we find values
 F  S SUBR=$O(^ABSP(9002313.473,DURIEN,1,SUBR)) Q:'+SUBR  D
 . N CHKR
 . S CHKR=""
 . S CHKR=$TR($P($G(^ABSP(9002313.473,DURIEN,1,SUBR,0)),U,2,7),"^")
 . S:CHKR'="" FNDREC=0
 . D:CHKR="" DELSUB(DURIEN,SUBR)
 ;
 I FNDREC D
 . D DELREC(DURIEN)
 . S DURIEN=""
 ;
 Q DURIEN
 ;
DELSUB(DLIEN,DLSUB) ; delete subrecord - no valid information
 ;
 N FDA,MSG
 ;
 S FDA(9002313.4731,DLSUB_","_DLIEN_",",.01)="@"
DE3 D FILE^DIE("E","FDA","MSG")     ;delete the record
 Q:'$D(MSG)   ;successful deletion
 ;
 ; delete unsuccessful
 K ^TMP("ABSP",$J,"ABSPOSD2",$J,"DELSUB")
 S ^TMP("ABSP",$J,"ABSPOSD2",$J,"DELSUB")=$$ERRHDR
 D ZWRITE^ABSPOS("IEN","FDA","MSG")
 G DE3:$$IMPOSS^ABSPOSUE("FM","TR1",,,"DELSUB",$T(+0))
 Q
 ;
DELREC(DLIEN) ;delete record - no valid information
 ;
 N FDA,MSG
 ;
 S FDA(9002313.473,DLIEN_",",.01)="@"
DEL3 D FILE^DIE("E","FDA","MSG")     ;delete the record
 Q:'$D(MSG)   ;successful deletion
 ;
 ; delete unsuccessful
 K ^TMP("ABSP",$J,"ABSPOSD2",$J,"DELREC")
 S ^TMP("ABSP",$J,"ABSPOSD2",$J,"DELREC")=$$ERRHDR
 D ZWRITE^ABSPOS("IEN","FDA","MSG")
 G DEL3:$$IMPOSS^ABSPOSUE("FM","TR1",,,"DELREC",$T(+0))
 Q
 ;
NEWSUB(DURIEN) ;EP FROM ABSPOSIH
 ; establish blank lines for new DUR override entries
 ; on NEW POS claims (from page 20 on ABSP DATA INPUT)
 ;(block ABSP INPUT 5.1 DUR INPUT)
 ;
 N REC,LASTREC,CNT,FDA,RECNUM,REP,SAVNUM
 S (CNT,LASTREC,SAVNUM,REC)=0
 ;
 F  S REC=$O(^ABSP(9002313.473,DURIEN,1,REC)) Q:'+REC  D
 . S SAVNUM=$P($G(^ABSP(9002313.473,DURIEN,1,REC,0)),"^")
 . S:SAVNUM>LASTREC LASTREC=SAVNUM
 . S CNT=CNT+1
 ;
 S:LASTREC>91 LASTREC=55  ;rec # lmt 99- 55 is random
 S ENDCNT=9-CNT   ;tie to the rep num on screen blk
 ;
 F REP=1:1:ENDCNT  D
 . S RECNUM=LASTREC+REP
 . N FDA,IEN
 . S FDA(9002313.4731,"+1,"_DURIEN_",",.01)=RECNUM
 . D UPDATE^DIE("E","FDA","IEN")
 ;
 ;
 ;
 Q
 ;
FLOCK() L +^ABSP(9002313.473):300 Q $T
FUNLOCK L -^ABSP(9002313.473) Q
ERRHDR() Q "ERROR AT $H="_$H_" FOR $J="_$J
