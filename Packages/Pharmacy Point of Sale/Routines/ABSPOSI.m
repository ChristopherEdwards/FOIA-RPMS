ABSPOSI ; IHS/FCS/DRS - Data entry w/ScreenMan ;   [ 09/12/2002  10:10 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,6,23**;JUN 21, 2001
 ; This calls ScreenMan for an entry in file 9002313.51
 ;------------------------------------------------
 ;IHS/SD/lwj  7/17/03  patch 6
 ; Cache does NOT react the same as MSM when you are in screen man
 ; and you call FULL^VALM1 prior to updating the record.  Changed
 ; the sequence of when FULL^VALM1 is called in the ALL1 subroutine.
 ; Also added another temp global to track the DUR overrides - if
 ; the claim is not filed, we need to delete the empty records
 ; so that the claim is not contaminated.
 ;---------------------------------------------------------------
 ;
ALL ; This entry point does data entry and submits the claims, both.
 ; This is what we'll call from the ListManager menu.
 DO FULL^VALM1 ; List manager had set scroll regions
 I $$OLDSTYLE G ^ABSPOSIV
ALL1 ;EP - ABSPOSIV branches back here if user decides he wants Screenman
 N INPUTIEN S INPUTIEN=$$NEW
 ;D TERM^VALM0 ; sets terminal characteristics ; not in LM docum'n
 I INPUTIEN D
 . ;IHS/SD/lwj 07/17/03 nxt line moved two down - seq off for Cache
 . ;D FULL^VALM1 ; full screen - we might do I/O
 . D FILE^ABSPOSIZ(INPUTIEN) ; send them to POS or to paper
 . ;IHS/SD/lwj 07/17/03 moved screen refresh to next line
 . D FULL^VALM1 ; full screen - we might do I/O
 . N NODISPLY S NODISPLY=1 D UPD^ABSPOS6A ; so your new claims show up
 . N % W ! R %:1
 E  D
 . ;IHS/SD/lwj 7/17/03 patch 6 kill DUR overrides that are empty
 . D NOCLM^ABSPOSIH
 . ;end changes
 . ;
 . ;IHS/SD/RLT - 06/21/07 - 10/18/07 - Patch 23
 . ; kill empty DIAGNOSIS CODE
 . D NOCLM^ABSPOSII
 . ;
 . W "Because of <PF1> Q,",!
 . W "These charges and claims are NOT filed and processed.",!
 . W ! R %:3
 W !
 S VALMBCK="R" ; tell List Manager to Refresh
 ;
 ;IHS/SD/lwj 7/17/03 patch 6 - kill the temp global for the DUR over
 K ^TMP("ABSPOSIH",$J)
 ;
 ;IHS/SD/RLT - 06/21/07 - 10/18/07 - Patch 23
 ; kill temp global for DIAGNOSIS CODE
 K ^TMP("ABSPOSII",$J)
 ;
 Q
 ;
 ; Usually, for a new input session, $$NEW^ABSPOSI 
 ;   It returns the IEN of the session
 ;
 ; D ^ABSPOSI -> TEST^ABSPOSI  for testing and development
 ;
 ; If you need to edit an existing session, $$MYSCREEN^ABSPOSI(IEN)
 ; That's probably not going to be used, but it's here if you need it.
 ;
 Q
NEW() ;EP - from ABSPOSI
 Q $$MYSCREEN(-1)
 Q
MYSCREEN(DA)       ; returns IEN of input if <PF1>E (or the equivalent) was used
 ; if the user quits out (<PF1>Q or the equivalent), returns 0^IEN
 N DDSFILE,DR,DDSPAGE,DDSPARM
 N DDSCHANG,DDSSAVE,DIMSG,DTOUT
 ;
 ;IHS/SD/lwj 7/17/03 patch 6 - kill the temp global for the DUR over
 K ^TMP("ABSPOSIH",$J)
 ;
 ;IHS/SD/RLT - 06/21/07 - 10/18/07 - Patch 23
 ; kill temp global for DIAGNOSIS CODE
 K ^TMP("ABSPOSII",$J)
 ;
 S DDSFILE=9002313.51 ; PEC/MIS INPUT file
 S DR="[ABSP INPUT 1]"
 I DA'>0 D
 . S DA=$$NEWREC(,,2)
 . D INIT(DA)
 S DDSPARM="CS"
 D ^DDS
 Q:'$Q
 I $G(DDSSAVE) Q DA
 E  Q 0_U_DA
TEST ;
 W "NEW^ABSPOSI returns ",$$NEW^ABSPOSI
 W "Outputs:",!
 D ZWRITE^ABSPOS("DDSCHANG","DDSSAVE","DIMSG","DTOUT")
 D GL
 Q:$Q DA Q
ISEMPTY(DA)        ; true if PRESCRIPTIONS multiple count >0, false if not
 Q $P($G(^ABSP(9002313.51,DA,2,0)),U,4)>0
FN() Q 9002313.51
FNPRESC()          Q 9002313.512
FNINS() Q 9002313.522
NEWREC(NMULT,NINS,ORIGIN) ;EP - from ABSPOSIV - a new PEC/MIS INPUT record
 ; NMULT = how many multiples to initialize (opt, defaults to 9)
 ; NINS = how many insurance lines to init for each one (opt, def to 5)
 ; ORIGIN = pointer to 9002313.516
 N FDA,IEN,MSG,FN,NEW S FN=$$FN,NEW="+999999,"
 N FNPRESC,FNINS S FNPRESC=$$FNPRESC,FNINS=$$FNINS
 S FDA(FN,NEW,.01)="NOW"
 S FDA(FN,NEW,.03)=$P(^ABSP(9002313.516,ORIGIN,0),U)
 N I F I=1000:1000:1000*$S($D(NMULT):NMULT,1:9) D
 . N X S X="+"_I_","_NEW
 . S FDA(FNPRESC,X,.01)=I/1000
 . N J F J=1:1:$S($D(NINS):NINS,1:5) D
 . . S FDA(FNINS,"+"_(I+J)_","_X,.01)=J
 . . ; ex:          +3002,+3000,+999999, for 2nd ins in 3rd presc
 N STOP F  D  Q:STOP
 . D UPDATE^DIE("E","FDA","IEN","MSG")
 . I '$D(MSG),$G(IEN(999999)) S STOP=1 Q
 . D ZWRITE^ABSPOS("MSG","IEN")
 . S STOP='$$IMPOSS^ABSPOSUE("FM","TRI","UPDATE^DIE failed",,"NEWREC",$T(+0))
 Q IEN(999999)
INIT(IEN) ;EP - from ABSPOSIV - initialize record IEN
 N FDA,MSG,FN S FN=$$FN,IEN=IEN_","
 S FDA(FN,IEN,.02)=DUZ ; USER
 D
 . N ARR,I,Y
 . D GET515(DUZ,.ARR) ; get this user's settings, apply defaults
 . S Y=$G(ARR(1)) ; we're interested in the ASK ones in the 1 subscript
 . F I=1:1:4 I $P(Y,U,I)="" S $P(Y,U,I)=0 ; defaults for default
 . F I=1:1:4 S FDA(FN,IEN,I/100+1)=$P(Y,U,I) ; ASK INS, etc.
 . S Y=$G(ARR(100)) ; and in the 100 subscript,
 . ; piece 1 - should we default the NDC # - the default default is YES
 . ; defaults for the default
 . F I=1:1:1 I $P(Y,U,I)="" S $P(Y,U,I)=$S(I=1:1,1:0)
 . F I=1:1:1 S FDA(FN,IEN,I/100+100)=$P(Y,U,I)
 N STOP F  D  Q:STOP
 . D FILE^DIE("","FDA","MSG")
 . I '$D(MSG) S STOP=1 Q
 . D ZWRITE^ABSPOS("MSG")
 . S STOP='$$IMPOSS^ABSPOSUE("FM","TRI","FILE^DIE failed",,"INIT",$T(+0))
 Q:$Q '$D(MSG) Q  ;='0=1 if success, ='nonzero=0 if failure
DELALL ; delete all records ; good for testing
 N FN S FN=$$FN I FN'=9002313.51 D  Q  ; must be that file
 . D IMPOSS^ABSPOSUE("P","TI",,,"DELALL",$T(+0))
 W !,"Deleting all records from file ",FN
 N IEN F  S IEN=$O(^ABSP(FN,0)) Q:'IEN  Q:'$$DELETE(IEN)  W "."
 W ! D GL
 Q
GL ; quickie global list good for testing
 N FN S FN=$$FN
 N X M X=^ABSP(FN)
 D ZWRITE^ABSPOS("X")
 Q
DELETE(IEN)        ; delete record IEN
 N FDA,MSG,FN S FN=$$FN,IEN=IEN_","
 S FDA(FN,IEN,.01)="@"
 D FILE^DIE("E","FDA","MSG")
 I $D(MSG) D ZWRITE^ABSPOS("MSG")
 I $D(MSG) Q 0
 Q 1
GENINSTR ; general instructions, in the FORM-level pre-action for Block 2C
 N AR
 S AR(1)="Use   <PF1> E   to SUBMIT the claims"
 S AR(1)=AR(1)_",    <PF1> Q to QUIT and cancel"
 ;S AR(2)="Use   <PF1> Q   to QUIT without submitting claims."
 ;S AR(3)="Use     ??     to get extra help on a question."
 D HLP^DDSUTL(.AR)
 Q
OLDSTYLE()         ; return true if DUZ wants old style input
 ; if this user has a specific setting, go with it
 N X D GET515(DUZ,.X)
 Q $P($G(X(0)),U,3)
GET515(USER,DEST) ;EP - from ABSPOSIV ; call as GET515(USER,.DESTINATION)
 ; where .DESTINATION is undefined coming in.
 ; set DEST(*) = copy of the .515 in effect,
 ; with defaults overlaid as needed
 I $D(DEST) D  Q
 . D IMPOSS^ABSPOSUE("P","TI",,,"GET515",$T(+0))
 D GET515A(USER,.DEST)
 I $P($G(DEST(0)),U,2) D  ; if this user inherits from another, 
 . N ARR
 . D GET515A(USER,.ARR) ; then get that user's settings
 . D GET515B(.DEST,.ARR) ; fill in any that need defaults
 D
 . N ARR
 . D GET515A(1,.ARR) ; likewise, inherit from user #1
 . D GET515B(.DEST,.ARR)
 Q
GET515A(USER,DEST) ; grab copy of the record for this user
 N IEN S IEN=$O(^ABSP(9002313.515,"B",USER,0)) Q:'IEN
 M DEST=^ABSP(9002313.515,IEN) ; DEST(0), DEST(1), etc. are set now
 Q
GET515B(A,B)       ; fill in defaults in A as needed, from B
 N X,Y,I,S S S=""
 F  S S=$O(B(S)) Q:S=""  D
 . S X=B(S) F I=1:1:$L(X,U) S Y=$P(X,U,I) I Y]"" D
 . . I $P($G(A(S)),U,I)="" S $P(A(S),U,I)=Y ; not def, so fill default
 Q
