ABSPOSC4 ; IHS/FCS/DRS - installation testing ;    
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
 ; Send the NEBRASKA MEDICAID test claim
 ; Special naming assumptions:
 ; 1. Insurer file has NEBRASKA MEDICAID
 ; 2. Formats file has NEBRASKA MEDICAID
 ; 3. Certification file has NEBRASKA MEDICAID TEST
 ;
THETEST ;EP - option
 W !
 W !
 W "This is a test of the send-and-receive mechanism.",!
 W "It sends a test claim to an insurer.",!
 W "The claim should be rejected; it is only a test claim",!
 W "and the data is made-up.",!
 W !
 W "This test should be done ONLY on a QUIET Point of Sale system.",!
 W "There are theoretically possible conflicts with live processing,",!
 W "which seem minor.  Time has not permitted a comprehensive analysis.",!!
 H 1
 N INSNAME S INSNAME="NEBRASKA MEDICAID"
 ;W "Running the complete test, using ",INSNAME,!
 ;
 ; May need to uncomment the following line for some special cases.
 ;S DIALOUT=$O(^ABSP(9002313.55,"B","RESERVED - DO NOT USE",0))
 ;
 N RESULT S RESULT=$$TEST1()
 I RESULT D
 . W "The test succeeded!",!
 E  D
 . W "The test failed!",!
 Q
TEST1(DIALOUT) ; returns true if success, false if failure
 ; given INSNAME is insurer name and also format name
 ;  (this is usually not the case!)
 N FMTNAME S FMTNAME=INSNAME
 I '$G(DIALOUT) S DIALOUT=$$DEF5599^ABSPOSA I 'DIALOUT D  Q 0
 . W "Default dialout not set up yet?!",!
 W "Using dial out ",$P(^ABSP(9002313.55,DIALOUT,0),U),!
 N IEN31 S IEN31=$O(^ABSP(9002313.31,"B",INSNAME_" TEST",0))
 I 'IEN31 W "Missing entry in 9002313.31.",! Q 0
 N INSIEN S INSIEN=$$INSFIND
 I 'INSIEN W "Missing ",INSNAME," in INSURER file",! Q 0
 N IEN92 S IEN92=$O(^ABSPF(9002313.92,"B",INSNAME,0))
 I 'IEN92 W "Missing format ",INSNAME," in INSURER file",! Q 0
 ; We need an ABSP INSURER entry.
 ; Possibly may be temporarily created just for the test.
 N IEN4,IEN4ORIG S (IEN4,IEN4ORIG)=$$IEN4FIND
 I 'IEN4 S IEN4=$$IEN4MAKE I 'IEN4 D  Q 0
 . W "Failed to create an ABSP INSURER entry for ",INSNAME,!
 ;
 ; Recap:  we have the following:
 ; IEN4 = pointer to ^ABSPEI(
 ; IEN4ORIG = IEN4 if the entry already existed, false otherwise
 ; IEN92 = pointer to format in ^ABSPF(9002313.92,
 ; INSIEN = pointer to ^AUTNINS(
 ; IEN31 = pointer to test transaction data in ^ABSP(9002313.31,
 ; DIALOUT = pointer to ^ABSP(9002313.55,
 ;
 ; From this point - don't quit without going through the EXIT tag!!
 S RESULT=0 ; reset RESULT=1 if you have success
 ;
 I '$$SETUP31 D  G EXIT ; set insurer pointer and switch
 . W "Failed in SETUP31, trying to set some fields in 9002313.31.",!
 ;
 ; Build the claim packet
 ;
 N IEN02 S IEN02=$$PACKET^ABSPOSC2(IEN31,DIALOUT)
 I 'IEN02 D  G EXIT
 . W "Failed to create claim packet in 9002313.02",!
 ;
 ; Now send it
 ;
 W "Sending the test claim..."
 D RUNTEST^ABSPOSC3(DIALOUT,IEN02)
 W " it's been handed to the background job.",!
 ; 
 ; And finally, wait for the response.
 ; 
 D WAIT
 I '$$RESPONSE D  G EXIT
 . W "No response received (yet)",!
 . D LOG^ABSPOSC2
 ;
 W !,"Yes, response received!",!
 D PRINTRSP
 S RESULT=1
 ;
EXIT I 'IEN4ORIG I '$$IEN4DEL D
 . W "Failed to delete temporary ABSP INSURER entry for ",INSNAME,!
 ;
 I $D(^ABSPECX("POS",DIALOUT,"C")) D  ; kill claim if it's still around
 . Q:'$$LLIST^ABSPOSAP
 . K ^ABSPECX("POS",DIALOUT,"C")
 . D ULLIST^ABSPOSAP
 ;
 Q RESULT
WAIT ; wait for response
 ; either user's decision to stop or we've noticed response rec'd
 W "Wait several seconds for the response - probably about 60 seconds",!
 W " for a modem connection, or 30 seconds for the T1 line.",!
 W "Type Q to Quit; L to view log file of transmission",!
 W "Waiting for response to the test message..."
 N QUIT,SEC S QUIT=0 F SEC=1:1  D  Q:QUIT
 . ;I SEC#3=0 W:$X>65 !?10 W "." ; another dot every three seconds
 . N DIR,X,Y S DIR(0)="SAOM^L:L;Q:Q"
 . S DIR("A")="Q to Quit; L to view Log: ",DIR("T")=5 D ^DIR
 . I Y="" S QUIT=$$RESPONSE Q
 . I Y="Q" S QUIT=1 Q
 . I Y="L" D LOG^ABSPOSC2 Q
 Q
RESPONSE() ; does IEN31 have a response for the generated claim?
 ; returns false if not, else returns IEN in 9002313.03
 Q $O(^ABSPR("B",IEN02,0))
PRINTRSP N L S L=0
 N DIC S DIC=9002313.03
 N FLDS S FLDS="[CAPTIONED]"
 N BY S BY=.01
 N FR,TO S (FR,TO)=$P(^ABSPC(IEN02,0),U)
 N DHD S DHD="@"
 N IOP S IOP="HOME;80;999"
 D EN1^DIP
 Q
DEFDIAL() ; returns IEN to the default dial out
 Q $O(^ABSP(9002313.55,"B","DEFAULT",0))
INSFIND() ; returns IEN to ^AUTNINS, false if not found
 Q $O(^AUTNINS("B",INSNAME,0))
IEN4FIND() ; returns IEN to 9002313.4, false if not found
 Q $O(^ABSPEI("B",$$INSFIND,0))
IEN4MAKE() ; given INSNAME and FMTNAME
 ; return TRUE if successfully created ; FALSE if not
 N FDA,IENARR,MSG,FN,IENS,X S FN=9002313.4,IENS="+1,"
 S X=$O(^AUTNINS("B",INSNAME,0))
 I 'X W !,"Can't find ",INSNAME," in ^AUTNINS",! Q 0
 S (FDA(9002313.4,IENS,.01),IENARR(1))=X
 S X=$O(^ABSPF(9002313.92,"B",FMTNAME,0))
 I 'X W !,"Missing ",FMTNAME," from ^ABSPF(9002313.92)",! Q 0
 S FDA(9002313.4,IENS,100.01)=X
 D UPDATE^DIE(,"FDA","IENARR","MSG")
 I $D(MSG) D ZWRITE^ABSPOS("MSG") Q 0
 Q $G(IENARR(1))
IEN4DEL() ; delete the ABSP INSURER entry (because we temporarily created it)
 ; returns TRUE if successfully deleted
 N FDA,MSG
 S FDA(9002313.4,IEN4_",",.01)=""
 D FILE^DIE(,"FDA","MSG")
 Q '$D(^ABSPEI(IEN4))
SETUP31() ; fill in some fields in the 9002313.31 header ; ret true/false
 N FDA,MSG,FN,IENS S FN=9002313.31,IENS=IEN31_","
 S FDA(FN,IENS,.03)=""
 S FDA(FN,IENS,.04)=IEN4
 S FDA(FN,IENS,.05)=$$SWTYPE^ABSPOSCC(DIALOUT)
 N F401,IENS401
 S F401=$O(^ABSPF(9002313.91,"B",401,0))
 S IENS401=$O(^ABSP(9002313.31,IEN31,1,"B",F401,0))
 I 'IENS401 Q:'$$IMPOSS^ABSPOSUE("DB","TI","IENS401="_IENS401,,"SETUP31",$T(+0))
 S IENS401=IENS401_","_IENS
 S FDA(9002313.311,IENS401,.02)=DT
 N F414,IENS414
 S F414=$O(^ABSPF(9002313.91,"B",414,0))
 S IENS414=$O(^ABSP(9002313.31,IEN31,2,1,1,"B",F414,0))
 S IENS414=IENS414_",1,"_IENS
 S FDA(9002313.3121,IENS414,.02)=DT
 D FILE^DIE(,"FDA","MSG")
 Q '$D(MSG)
