ABSPOSK ; IHS/FCS/DRS - winnow POS data ;   
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
SILENT(LOGSONLY) ;EP - do it silently, as in taskmanned task
 ; $G(LOGSONLY)=1 if you are winnowing log files only.
 ; Invoked sporadically at random from transaction completion in ABSPOSU
 N SILENT S SILENT=1
MAIN ;EP - show progress
 L +^TMP($T(+0)):0 Q:'$T  ; only one winnower at a time
 ; (this protects against the case where two or more of these happen
 ;  to be scheduled at random throughout the day)
 D  ; log files
 . N X S X=$G(^ABSP(9002313.99,1,"WINNOW LOGS"))
 . D INIT^ABSPOSL(DT+.5,1)
 . S X=DT+.5_U_$P(X,U,1,9) ; shift old down one spot and put new in
 . S ^ABSP(9002313.99,1,"WINNOW LOGS")=X
 ; NEW the vars commonly used
 N IEN,AGE,BILLSYS,TESTING,ISILCAR,NENTRIES,OLDPCT,COUNT
 S ISILCAR=$$ISILCAR^ABSPOSB ; some algorithms vary if you have ILC A/R
 D AGES ; set AGE(field name)=value
 D BILLSYS ; set BILLSYS=which billing system interface (internal)
 S TESTING=$P($G(^ABSP(9002313.99,1,"WINNOW TESTING")),U)
 I TESTING D LOG("Just testing; nothing will actually be deleted.")
 E  D LOG("This is for real; we may really delete some data.")
 ; The order of these files is important!  Certain things won't be
 ; deleted if the things pointed to them are still around.
 I $G(LOGSONLY) G LOGS
 D LOGHDG(9002313.57),INIFOR(9002313.57)
 D 57 ; 9002313.57 Billing
 D LOGHDG(9002313.59),INIFOR(9002313.59)
 D 59 ; 9002313.59 Working
 D LOGHDG(9002313.03),INIFOR(9002313.03)
 D 03 ; 9002313.03 Responses
 D LOGHDG(9002313.02),INIFOR(9002313.02)
 D 02 ; 9002313.02 Claims
 D LOGHDG(9002313.51),INIFOR(9002313.51)
 D 51 ; 9002313.51 Input
 D LOGHDG(9002313.511),INIFOR(9002313.511)
 D 511 ; 9002313.511 Override
 D LOGHDG("COMBINS"),INIFOR(9002313.1)
 D COMBINS ; combined insurance
LOGS D LOGHDG("LOG FILES"),INIFOR("LOG FILES")
 D LOGFILES ; Log files in ^ABSPECP("LOG",
 D RELSLOT^ABSPOSL
 L -^TMP($T(+0))
 Q
INIFOR(F)          ;
 S COUNT=0,OLDPCT=""
 I +F=F D
 . I F=9002313.02 S NENTRIES=$P(^ABSPC(0),U,4)
 . E  I F=9002313.03 S NENTRIES=$P(^ABSPR(0),U,4)
 . E  I F=9002313.1 S NENTRIES=$P(^ABSPCOMB(0),U,4)
 . E  S NENTRIES=$P(^ABSP(F,0),U,4)
 E  D
 . ; note: percentages will be off for the log files
 . I F="LOG FILES" S NENTRIES=$P(^ABSPECP("LOG","LAST SLOT"),U)
 Q
LOGHDG(FILE)       ;
 N X ;
 D LOGLINES
 I FILE="COMBINS" S FILE=9002313.1 ; renumbered since original rou
 I +FILE=FILE D
 . S X="Winnowing file "_FILE_": "_$P(^DIC(FILE,0),U)
 E  D
 . I FILE="LOG FILES" S X="Winnowing "_FILE
 D LOG(X)
 D LOGLINES
 Q
 ; Instead of going by indexes, just scan the entire file.
 ; There may be some without the date field set, for example.
 ; We don't want those hanging around forever.
 ;
03 ; 9002313.03 Responses
 S IEN=0 F  S IEN=$O(^ABSPR(IEN)) Q:'IEN  D 03^ABSPOSK1,PCT
 D LOGDONE
 Q
02 ; 9002313.02 Claims
 S IEN=0 F  S IEN=$O(^ABSPC(IEN)) Q:'IEN  D 02^ABSPOSK1,PCT
 D LOGDONE
 Q
51 ; 9002313.51 Input
 S IEN=0 F  S IEN=$O(^ABSP(9002313.51,IEN)) Q:'IEN  D 51^ABSPOSK1,PCT
 D LOGDONE
 Q
511 ; 9002313.511 Override
 S IEN=0
 F  S IEN=$O(^ABSP(9002313.511,IEN)) Q:'IEN  D 511^ABSPOSK1,PCT
 D LOGDONE
 Q
57 ; 9002313.57 Billing
 S IEN=0 F  S IEN=$O(^ABSPTL(IEN)) Q:'IEN  D 57^ABSPOSK1,PCT
 D LOG("Fixing 9002313.57 indexes...") D FIX57IDX^ABSPOSK2
 D LOGDONE
 Q
59 ; 9002313.59 Working
 S IEN=0 F  S IEN=$O(^ABSPT(IEN)) Q:'IEN  D 59^ABSPOSK1,PCT
 D LOGDONE
 Q
LOGFILES ; ^ABSPECP("LOG",
 S IEN=0
 F  S IEN=$O(^ABSPECP("LOG",IEN)) Q:'IEN  D LOGFILES^ABSPOSK1,PCT
 D LOGDONE
 Q
COMBINS ; ^ABSPCOMB(
 ; Our POS combined insurance can be winnowed because
 ; we don't keep any pointers to combined insurance.
 ; This is different in A/R, I think.
 S IEN=0
 F  S IEN=$O(^ABSPCOMB(IEN)) Q:'IEN  D COMBINS^ABSPOSK1,PCT
 D LOGDONE
 Q
PCT Q:'NENTRIES  Q:$G(SILENT)  S COUNT=COUNT+1
 N X S X=COUNT/NENTRIES*100+.5\1 S:X=101 X=100
 I X'=OLDPCT W @IOBS,@IOBS,@IOBS,@IOBS,@IOBS,$J(X,3),"% " S OLDPCT=X
 Q
LOGDONE D LOG("Done with this part.") Q
LOG(X) D LOG^ABSPOSL(X)
 I '$G(SILENT) U $P W X,!
 Q
LOGLINES N X S X=$J("",60),X=$TR(X," ","=") D LOG(X) Q
GET99(FIELD)       ; ^ABSP(9002313.99,1,"WINNOWING")
 ; field numbers #2341.nn
AGES ; set AGE(field name) = value for field numbers 2341.nn
 I $G(^ABSP(9002313.99,1,"WINNOW"))?."^" D
 . ; Set some defaults if nothing has been explicitly set.
 . N X S X="400^100^100^100^31^366^31^366^100^100^366^0"
 . S ^ABSP(9002313.99,1,"WINNOW")=X
 N FIELD S FIELD=2341
 F  S FIELD=$O(^DD(9002313.99,FIELD)) Q:FIELD'<2342  Q:'FIELD  D
 . N NAME,DEST D FIELD^DID(9002313.99,FIELD,,"LABEL","DEST")
 . S NAME=$G(DEST("LABEL"))
 . I NAME="" D
 . . D ZWRITE^ABSPOS("FIELD","DEST")
 . . D IMPOSS^ABSPOSUE("FM","TI","FIELD^DID(9002313.99 failed on field "_FIELD,,"AGES",$T(+0))
 . N VALUE S VALUE=$$GET1^DIQ(9002313.99,"1,",FIELD)
 . I VALUE="" S VALUE=365+365+366 ; 3 years
 . S AGE(NAME)=VALUE
 . D LOG("AGE("_NAME_")="_VALUE)
 Q
BILLSYS ; set BILLSYS= which billing system you're interfacing to
 S BILLSYS=$$GET1^DIQ(9002313.99,"1,",170.01)
 D LOG("BILLSYS="_BILLSYS)
 Q
