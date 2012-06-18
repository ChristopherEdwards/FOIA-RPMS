ABSPOSUT ; IHS/FCS/DRS - POS utilities - testing modem ; 
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
 ; D DIR to get a directory of available tests
DIR ;
 N I,X F I=1:1 S X=$T(+I) Q:X=""  D
 . I X'?1"TEST".E Q
 . I $P(X," ")="TESTINIT" Q
 . I $P(X," ")="TESTDONE" Q
 . I $P(X,"(")="TESTID" Q
 . W X,!
 Q
 ; DEST = pointer to dial out, 9002313.55
 ; IO = the IO device associated with DEST
 ; SLOT = pointer to logging in ^ABSPECP("LOG",...)
 ; ISOPEN is true if device is open (and close needed on exit)
 ; ECHO is true so LOG^ABSPOSL(SLOT) echoes to your screen as well
 ; D PRINT in this routine prints what's in SLOT
 ; or later you can DO PRINTLOG^ABSPOSL(SLOT)
 ; All tests finish via TESTDONE label.
GETDEST ;
 N DIC,X,Y,DTIME,DLAYGO,DINUM
 S DIC=9002313.55,DIC(0)="AENZ"
 D ^DIC W !
 I Y<0 S DEST="" Q
 S DEST=+Y
 S IO=$$IO^ABSPOSA(DEST)
 Q
TESTINIT I '$D(DEST) D GETDEST Q:'DEST
 S ECHO=1,ISOPEN=0
 D INIT^ABSPOSL()
 S SLOT=$$GETSLOT^ABSPOSL
 W "Logging is to slot ",SLOT,"; D PRINT to display it again",!
 D LOG("Testing dial out #"_DEST_" "_$P(^ABSP(9002313.55,DEST,0),U)_" on device "_IO)
 S SLOT=$$GETSLOT^ABSPOSL
 Q
TESTID(X) D LOG("This is "_X_U_$T(+0)_": "_$P($T(@X)," ",2,255)) Q
OPEN ; do all the OPENing here so it sets ISOPEN
 ; sets X = zero if success, nonzero if failure
 I ISOPEN D
 . D LOG("apparently the device we're opening is already open")
 . D LOG("So close it first...")
 . D CLOSE
 S X=$$OPEN^ABSPOSAB(DEST)
 I 'X S ISOPEN=1
 E  D LOG("OPEN failed, error code ="_X)
 Q
CLOSE S X=$$CLOSE^ABSPOSAB(DEST)
 I 'X S ISOPEN=0
 E  D LOG("CLOSE failed, error code ="_X)
 Q
PRINT D PRINTLOG^ABSPOSL(SLOT)
 W "(This came from the log file in ^ABSPECP(""LOG"",",SLOT,")",!
 Q
LOG(X) D LOG^ABSPOSL(X,ECHO) Q
GETCMD(X)          ;
 I X="ECHO OFF" Q "E0"
 I X="RESET"!(X="ATZ") Q "Z"
 I X="GET STATUS" Q "I0"
 D IMPOSS^ABSPOSUE("P","TI","Bad command "_X,,"GETCMD",$T(+0))
 Q
COMMAND(X)         ;issue a command directly to the modem
 I X'?1"AT".E S X="AT"_X
 D LOG("Issue modem command "_X)
 U IO W X,$C(13)
 Q
READ(TIMEOUT,EXPECT) ; read result of a modem command
 ; returns true if expected string found, false if not
 ; and sets X=0 if expected string found, nonzero if not found
 ; (beware - opposite meanings!)
 I '$D(EXPECT) S EXPECT=""
 S X='$$READ1(EXPECT)
 I EXPECT]"",X D LOG("Did not receive expected string "_EXPECT_" in timeout "_TIMEOUT)
 Q:$Q 'X Q
READ1(EXPECT)      ; expecting EXPECT string (null if nothing particular)
 N RESULT ; TRUE if expected string seen, FALSE if not
 N X,I,J,T,FIRST S FIRST=1
 S X(0)="start at ",T(0)=$H
 F I=1:1:100 R X(I):TIMEOUT Q:'$T  S T(I)=$H
 K X(I) S I=I-1 ; the one it timed out on
 F J=1:1:I D
 . I X(J)="" S X(J)="null"
 . S X="at "_T(J)_": "_X(J)
 . N I F I=$L(X):-1:1 I $E(X,I)?1C D
 . . S X=$E(X,1,I-1)_"\"_$A(X,I)_$E(X,I+1,$L(X))
 . D LOG("X("_J_")="_X)
 I I=100 D LOG("OVERFLOW reading modem's response to command!")
 N % S %="" F J=1:1:I S %=%_X(J)
 Q %[EXPECT
TESTDONE I ISOPEN D CLOSE^ABSPOSAB(DEST)
 N MSG I X D
 . S MSG="Test FAILED, X="_X
 E  S MSG="Test SUCCEEDED"
 D LOG(MSG)
 D RELSLOT^ABSPOSL
 U $P W "D PRINT",U,$T(+0)," or D PRINTLOG^ABSPOSL(",SLOT,") to see log file again.",!
 Q
TEST1 ; open / use / close
 D TESTINIT Q:'DEST
 D TESTID("TEST1")
 D OPEN I X G TESTDONE
 D LOG("Testing the USE command")
 U IO
 D LOG^ABSPOSL("The USE command works okay")
 D CLOSE
 G TESTDONE
 Q
TEST2 ; test a simple command - ATE0, echo off
 D TESTINIT Q:'DEST  D TESTID("TEST2")
 D OPEN I X G TESTDONE
 D COMMAND("E0"),READ(10,"OK")
 G TESTDONE
TEST3 ; test the software reset using the ATZ
 D TESTINIT Q:'DEST  D TESTID("TEST3")
 D OPEN I X G TESTDONE
 S X=$$ATZ^ABSPOSAB(DEST)
 G TESTDONE
TEST4 ; test the modem status command 
 D TESTINIT Q:'DEST  D TESTID("TEST4")
 D OPEN I X G TESTDONE
 S X=$$MODEMSTS^ABSPOSAB(DEST)
 G TESTDONE
TEST5 ; test dialing and connecting
 D TESTINIT Q:'DEST  D TESTID("TEST5")
 S X=$$CONNECT^ABSPOSAA(DEST) I X G TESTDONE
 S ISOPEN=1
 S X=$$WAITCHAR^ABSPOSAW(DEST,$C(5),30) ; ENQ expected
 G TESTDONE
