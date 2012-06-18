ABSPOS6D ; IHS/FCS/DRS - user screen subrous ;   
 ;;1.0;PHARMACY POINT OF SALE;**14,18,37,38,40,41**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;IHS/SD/RLT - 8/24/06 - Patch 18
 ;  Changed code so rejected reversals can be resubmitted.
 Q
PRINTALL ; protocol ABSP P1 PRINT ALL ; print all patients' results
 N IO I '$$DEVICE G PRINT99
 U $P D:IO=$P FULL^VALM1 U IO
 D PRINTHDR
 N A S A="" F  S A=$O(@VALMAR@(A)) Q:'A  D PRINTA(A)
 G PRINT9
PRINTHDR ; print a header
 W VALM("TITLE")," "
 N %,%H,%I,X,Y D NOW^%DTC S Y=% X ^DD("DD") W Y,!!
 N A S A="" F  S A=$O(VALMHDR(A)) Q:A=""  W VALMHDR(A),!
 W !
 Q
PRINTA(A) ; print line A
 ; How could you tell whether this is a patient line or a prescription
 ; line?  And which patient or prescription is represented?
 ; Look at @DISPLINE(n)=patname or patname^rxi
 ; Look at @VALMIDX@(n,patien), @VALMIDX@(n,patien,rxien)
 I '$D(IOM) N IOM S IOM=80
 N X D
 .I $D(@VALMAR@(A,0)) S X=@VALMAR@(A,0)
 .E  S X="(? Line "_A_" is missing?)"
 .F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,$L(X)-1)
 .N M,N S M=32,N=IOM-M
 .W $E(X,1,IOM),! S X=$E(X,IOM+1,$L(X))
 .F  Q:X=""  W ?M-3,"...",$E(X,1,N),! S X=$E(X,N+1,$L(X))
 Q
PRINT ; protocol ABSP P1 PRINT PATIENT ; print a patient's results
 ; More aptly, it's "print selected lines"
 W !,"Enter the line numbers you wish to print.  For example,",!
 W "enter    3-7     to print lines 3 through 7.",!
 N IEN D SELECPAT(.IEN) ; select a patient(s)
 I $D(IEN)<10 G PRINT99 ; none selected
 N IO I '$$DEVICE G PRINT99
 U $P D:IO=$P FULL^VALM1 U IO
 D PRINTHDR
 N A S A="" F  S A=$O(IEN(A)) Q:A=""  D PRINTA(A)
PRINT9 ; joined here from PRINTALL,CLAIMLOG
 D BYE^ABSPOSU5 ; this does DO ^%ZISC to close IO for you
PRINT99 ; joined here from PRINTALL,CLAIMLOG
 D ANY^ABSPOS2A ;PRESSANY^ABSPOSU5()
PRINT999 S VALMBCK="R" ;$S(VALMCC:"",1:"R")
 Q
MAKERXI ; IEN(*)=line numbers  we want to convert to prescription numbers
 ; builds RXI(*)="" or maybe data, ignore whatever you get on right side
 S IEN="" F  S IEN=$O(IEN(IEN)) Q:IEN=""  D MRXI
 Q
MRXI S RXI=$P(@DISPLINE@(IEN),U,2)
 I RXI S RXI(RXI)="" Q  ; a prescription detail line; take just the one
 ; else it's a patient line - take all of this patient's prescrip's
 N PAT S PAT=$P(@DISPLINE@(IEN),U)
 M RXI=@DISP@(PAT) ; merge in all of the patient's prescriptions
 Q  ; with RXI(*) array set up
CLAIMLOG ; protocol ABSP P1 CLAIM LOG
 W !,"Enter the line numbers for which you wish to print claim logs.",!
 N IEN D SELECPAT(.IEN) ; select prescription(s) or patients
 I $D(IEN)<10 G PRINT99
 N IO I '$$DEVICE G PRINT99
 U $P D:IO=$P FULL^VALM1 U IO
 N RXI D MAKERXI ; IEN(*) -> converted to RXI(*)
 ; now RXI(*) is the array of RXI's we want to print logs for
 S RXI="" F  S RXI=$O(RXI(RXI)) Q:RXI=""  D CLAIMLOG^ABSPOS6M(RXI,IO)
 ;D BYE^ABSPOSU5
 G PRINT9
RECEIPT ; protocol ABSP P1 RECEIPT ; print receipts
 W !,"Enter the line numbers for which you wish to print ",$$NAME^ABSPOS6E(3),".",!
 N IEN D SELECPAT(.IEN) ; select prescription(s) or patients
 I $D(IEN)<10 G PRINT99
 N IO I '$$DEVICE G PRINT99
 U $P D:IO=$P FULL^VALM1
 N RXI D MAKERXI ; IEN(*) -> converted to RXI(*)
 D RECEIPTS^ABSPOS6E(.RXI,IO)
 D BYE^ABSPOSU5
 G PRINT9
REVERSE ; protocol ABSP P1 REVERSE CLAIM ; reverse selected claims
 W "Select the line(s) with the paid claim(s) you wish to REVERSE.",!
 N IEN D SELECPAT(.IEN) ; select which ones to reverse
 N RXI D MAKERXI ; IEN(*) -> converted to RXI(*)
 D FULL^VALM1
 N REVTOTAL,REVELECT,ERRCOUNT S (REVTOTAL,REVELECT,ERRCOUNT)=0
 S RXI="" F  S RXI=$O(RXI(RXI)) Q:RXI=""  D
 . N X S X=$$REVERS59(RXI,0)
 . I X D
 . . S REVTOTAL=REVTOTAL+1
 . . I X>.5 S REVELECT=REVELECT+1
 . E  D
 . . W "Cannot reverse ",RXI,! S ERRCOUNT=ERRCOUNT+1
 W REVTOTAL," claim reversal",$S(REVTOTAL'=1:"s",1:"")," in progress.",!
 I ERRCOUNT D
 . W "Some claim(s) could not be reversed because only paper claims",!
 . W "and Payable electronic claims can be reversed.",!
 I REVELECT D TASK^ABSPOSQ1 ; task up a packetizer
 D ANY^ABSPOS2A ;D PRESSANY^ABSPOSU5()
 N NODISPLY S NODISPLY=1 D UPD^ABSPOS6A
 S VALMBCK="R"
 ;S VALMBCK=""
 Q
REVERS59(IEN59,WANTQ2)    ;EP - called here from ABSPOSRB too
 ; IEN59 as usual; $G(WANT2Q)=TRUE if you want packetizer started
 ; Returns 0 if no, no reversal, it's unreversable
 ; Returns 0.5 if it's a paper claim that was reversed
 ; Returns IEN of reversal claim if electronic claim submitted for
 ;   reversal.
 N OLDSLOT S OLDSLOT=$$GETSLOT^ABSPOSL
 D SETSLOT^ABSPOSL(IEN59)
 D LOG^ABSPOSL("Reversal - begin")
 N RESULT S RESULT=$$CATEG^ABSPOSUC(IEN59)
 ;IHS/SD/RLT - 8/24/06 - Patch 18 - begin
 ;I RESULT'="PAPER",RESULT'="E PAYABLE",RESULT'="E DUPLICATE" Q:$Q 0 Q
 ;IHS/OIT/CASSEVERN/RAN - 02/07/2011 - Patch 41 - Allow "E CAPTURED" to be reversed.
 ;I RESULT'="PAPER",RESULT'="E PAYABLE",RESULT'="E DUPLICATE",RESULT'="E REVERSAL REJECTED" Q:$Q 0 Q
 I RESULT'="PAPER",RESULT'="E PAYABLE",RESULT'="E DUPLICATE",RESULT'="E REVERSAL REJECTED",RESULT'="E CAPTURED" Q:$Q 0 Q
 ;IHS/SD/RLT - 8/24/06 - Patch 18 - end
 I RESULT="PAPER REVERSAL"!(RESULT="E REVERSAL ACCEPTED") Q:$Q 0 Q
 ; Okay, reversal is permitted
 D  ; stamp new starting time
 . N DIE,DR,DA S DIE=9002313.59,DA=IEN59,DR="15///NOW;7///NOW" D ^DIE
 D LOG59A^ABSPOSQB ; and log contents of 9002313.59
 D PREVISLY^ABSPOSIZ(IEN59) ; bracket result text with [Previously: ]
 I RESULT="PAPER" D  Q:$Q 0.5 Q
 . D REVERSP(IEN59) ; reverse the paper claim
 . D RELSLOT^ABSPOSL,SETSLOT^ABSPOSL(OLDSLOT)
 ; Here, reversal of electronic claim:
 N CLAIMIEN S CLAIMIEN=$P(^ABSPT(IEN59,0),U,4) ; the claim
 N POS S POS=$P(^ABSPT(IEN59,0),U,9) ; and position therein
 N REV S REV=$$REVERSE^ABSPECA8(CLAIMIEN,POS) ; construct reversal
 D  ;S $P(^ABSPT(IEN59,4),U)=REV ; mark claim with reversal
 . N DIE,DR,DA S DIE=9002313.59,DA=IEN59,DR="401////"_REV D ^DIE
 D LOG^ABSPOSL("Reversal claim `"_REV_" "_$P(^ABSPC(REV,0),U))
 N ABSBRXI S ABSBRXI=IEN59 D SETSTAT^ABSPOSU(30) ; waiting to packetize
 I $G(WANTQ2) D TASK^ABSPOSQ1
 D RELSLOT^ABSPOSL,SETSLOT^ABSPOSL(OLDSLOT)
 Q:$Q REV Q
REVERSP(IEN59)     ; reverse the given paper claim
 N ABSBRXI,OLDSLOT,X,MSG S MSG="Reversed paper claim"
 S $P(^ABSPT(IEN59,4),U,3)=1
 S ABSBRXI=IEN59
 D SETRESU^ABSPOSU(1,MSG)
 D LOG59^ABSPOSL(MSG,IEN59)
 D SETSTAT^ABSPOSU(99)
 Q
RESUBMIT ; protocol ABSP P1 RESUBMIT ; resubmit a claim shown on your screen
 W "Select the line(s) with the claim(s) you wish to RESUBMIT.",!
 N IEN D SELECPAT(.IEN) ; gives IEN(*)
 N RXI D MAKERXI ; IEN(*) -> converted to RXI(*)
 D FULL^VALM1
 N REVCOUNT S REVCOUNT=0
 N IEN59 S IEN59="" F  S IEN59=$O(RXI(IEN59)) Q:IEN59=""  D
 .N X S X=$$RESULT59^ABSPOSRX(IEN59)
 .;IHS/OIT/CASSEVERN/RAN - 02/07/2011 - Patch 41 - Add "E CAPTURED" to types to be reversed.
 .;I X="E PAYABLE"!(X="E DUPLICATE")!(X="E REVERSAL REJECTED") D  Q
 .I X="E PAYABLE"!(X="E DUPLICATE")!(X="E REVERSAL REJECTED")!(X="E CAPTURED") D  Q
 ..;W "`",IEN59," is Payable; you must REVERSE it first.",!
 ..W "`",IEN59," will be REVERSED first, then Resubmitted.",!
 ..S $P(^ABSPT(IEN59,1),U,12)=1
 ..D REVERS59(IEN59,1)
 .I X="PAPER" D  Q
 ..W "`",IEN59," will be REVERSED first, then Resubmitted.",!
 ..S $P(^ABSPT(IEN59,1),U,12)=1
 ..D REVERS59(IEN59)
 .D RESUB1(IEN59)
 .;D PREVISLY^ABSPOSIZ(IEN59)
 .W "Resubmitted `",IEN59,! H 1
 D TASK^ABSPOSIZ ; task up a "gathering claim info" job
 D ANY^ABSPOS2A ;D PRESSANY^ABSPOSU5()
 N NODISPLY S NODISPLY=1 D UPD^ABSPOS6A
 S VALMBCK="R"
 Q
RESUB1(IEN59,MIN)        ;EP - from ABSPOSU
 ; resubmit one entry in .59 ; caller responsible for
 ; starting up  D TASK^ABSPOSIZ
 ; Also called here from ABSPOSU, for reverse-and-resubmit action
 ;Kill pointers of previous submissions and reversals
 N DIE,DR,DA S DIE=9002313.59,DA=IEN59
 S DR="" N I F I=3,4,401:1:403,301:1:302,801:1:803 D
 . S:DR]"" DR=DR_";" S DR=DR_I_"///@"
 . S DR=DR_";15///NOW;7///NOW" ; stamp new starting time, too
 ;S DR=DR_";6///"_DUZ ;IHS/OIT/CNI/SCR 033010 - update 'Updated By User' for CPR report patch 38
 S DR=DR_";6///`"_DUZ ;IHS/OIT/CNI/RAN 091710 - corrected 'Updated By User' input to properly use INTERNAL value patch 40
 I '$G(MIN) D  ; ABSP*1.0T7*11 this whole block
 . F I=10,11,1.05:.01:1.08,1.13,601:1:603,701:1:703 S DR=DR_";"_I_"///@"
 . ;IHS/OIT/SCR 11/20/08 delete new 'incentive amount submitted' field also
 . ;I '$P($G(^ABSPT(DA,5)),U,6) F I=501:1:505 S DR=DR_";"_I_"///@"
 . I '$P($G(^ABSPT(DA,5)),U,6) F I=501,502,503,505,507 S DR=DR_";"_I_"///@"
 D ^DIE
 D PREVISLY^ABSPOSIZ(IEN59) ; bracket result text with "[Previously: ]"
 ; Reset status
 N ABSBRXI S ABSBRXI=IEN59 D SETSTAT^ABSPOSU(0)
 Q
DEVICE() ;EP - device selection for POS
 ; want to provide a convenient default
 N DEFAULT S DEFAULT="HOME"
 N DEVICE S DEVICE=$$DEVICE^ABSPOSU8(DEFAULT)
 I 'DEVICE Q ""
 Q DEVICE
CANCEL ; protocol ABSP P1 CANCEL CLAIM 
 N LINE
 W !,"Select prescription to cancel by line number.  Hurry!"
 D SELECPAT(.LINE)
 I $O(LINE(""))="" W !,"None selected for cancellation",! G CAN99
 S LINE="" F  S LINE=$O(LINE(LINE)) Q:LINE=""  D
 .N PAT,RXI S PAT=$P(@DISPLINE@(LINE),U),RXI=$P(@DISPLINE@(LINE),U,2)
 .I RXI D CANC5^ABSPOS6L Q
 .; else patient was selected; cancel all of this patient's claims
 .S RXI="" F  S RXI=$O(@DISP@(PAT,RXI)) Q:RXI=""  D CANC5^ABSPOS6L
 W !,"Cancellation requests made." H 1
CAN99 D ANY^ABSPOS2A ;D PRESSANY^ABSPOSU5()
 N NODISPLY DO UPD^ABSPOS6A S VALMBCK="R"
 Q
DISMISS ; protocol ABSP P1 DISMISS ; dismiss a patient from my screen
 ; This is to remove a patient from the display before the usual
 ; time window has expired.  Do it by:
 ; 1. Set @DISMISS nodes to 15 minutes from now, so as to keep
 ;    the patient and prescription off our screen until then.
 ; 2. Zero out the time of last update in @DISP so that the
 ;    winnowing thinks the entry is too old to keep around.
 ; This functionality is provided with the intent to support
 ; dismissing an entire patient's record after all processing
 ; has been completed.  Unusual usage may not have the results
 ; you presume it might have.
DIS0 N IEN,TIME,X,%,%I,%H D NOW^%DTC
 S TIME=$$TADD^ABSPOSUD(%,^TMP("ABSPOS",$J,"TIME"))
 D SELECPAT(.IEN)
 S IEN="" F  S IEN=$O(IEN(IEN)) Q:IEN=""  D
 .N PAT,RXI S PAT=@DISPLINE@(IEN),RXI=$P(PAT,U,2),PAT=$P(PAT,U)
 .S @DISMISS@(PAT)=TIME
 .;I '$D(@DISP@(PAT)) W "DISP=",DISP," and @DISP@(PAT) is undef",! H 2
 .I $D(@DISP@(PAT)) S $P(@DISP@(PAT),U,3)=0
 .;I  W "Now @DISP@(PAT)=",@DISP@(PAT),! H 2
 .W PAT," will be dismissed.",! H 1
 .I RXI D
 ..S @DISMISS@(PAT,RXI)=TIME
 ..I $D(@DISP@(PAT,RXI)) S $P(@DISP@(PAT,RXI),U,3)=0
 ..;W PAT," ",RXI," will be dismissed.",! H 1
DIS9 ; some other functions branch to here to go back to main screen
 N NODISPLY DO UPD^ABSPOS6A S VALMBCK="R"
 Q
SELECPAT(RET) ; Select a patient.  Returns patient IEN(s) in array
 N VALMA,VAMP,VALMI,VALMAT,VALMY
 D EN^VALM2(XQORNOD(0),"O") S VALMI=0 ; allow "O"ptionally answer
 W !
 M RET=VALMY
 Q
CLOSECLM  ;protocol ABSP P1 CLOSE CLAIM
 ;IHS/OIT/SCR 021910 patch 37
 N ABSPIEN,X,%,%I,%H,ABSPDFN,ABSPCLSD,IEN,ABSPTIME
 D NOW^%DTC
 S ABSPTIME=%
 W !,"Select the line(s) with the claim(s) you wish to CLOSE",!
 D SELECPAT(.IEN) ; select prescription(s) or patients - IEN is expected to be defined
 N RXI D MAKERXI ; IEN(*) -> converted to RXI(*)
 ; now RXI(*) is the array of RXI's we want to print logs for
 S RXI="" F  S RXI=$O(RXI(RXI)) Q:RXI=""  S ABSPCLSD=$$CLOSECLM^ABSPOS6N(RXI)
 D ANY^ABSPOS2A
 ;D CLEAN^VALM10
 D EN^ABSPOS6A(DUZ,ABSPTIME)
 ;N NODISPLY S NODISPLY=1 D UPD^ABSPOS6A
 ;S VALMBCK="R"
 Q
OPENCLM  ;Protocol ABSP P1 RE-OPEN CLAIM
 ;IHS/OIT/SCR 021910 patch 37
 N ABSPOPEN
 D FULL^VALM1
 S ABSPOPEN=$$OPENCLM^ABSPOS6N
 D ANY^ABSPOS2A
 N NODISPLY S NODISPLY=1 D UPD^ABSPOS6A
 S VALMBCK="R"
 Q
