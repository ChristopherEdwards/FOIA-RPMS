ABSPOSIV ; IHS/FCS/DRS - Old-style input ;    [ 09/12/2002  10:11 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,10**;JUN 21, 2001
 ; old-style kept for those who want it
 ;EP - Branched to here from ABSPOSI
 ;----------------------------------------------------------------------
 ;IHS/SD/lwj 03/10/04 patch 10
 ; Routine adjusted to call ABSPFUNC to retrieve
 ; the Prescription Refill NDC value.  At some
 ; point the call needs to be modified to call APSPFUNC.
 ; See ABSPFUNC for details on why call was done.
 ;----------------------------------------------------------------------
 ;
 N ABSBRXI,ABSBRXR,ABSBNDC
 N DEFNDCNO D  ; true/false, should we default NDC #?
 . N X D GET515^ABSPOSI(DUZ,.X) S DEFNDCNO=$P($G(X(100)),U)
 N X S X=$$READER(99)
 I X<0 W !,"Because of ""^"", no claims are filed.",! H 3 Q  ; 03/22/2001
 I X="SCREENMAN" G ALL1^ABSPOSI
 N ECHO,ORIGIN S ECHO=1,ORIGIN=3 ; 3 = from old style input
 I $O(ABSBRXI("")) D FILING(ECHO,ORIGIN)
 Q
FILING(ECHO,ORIGIN)       ;EP - from ABSPOSRB
 ; with ABSBRXI(*),ABSBRXR(*) set up
 I '$D(ECHO) S ECHO=1
 I ECHO W "..."
F5 N IEN51 S IEN51=$$NEWREC^ABSPOSI($O(ABSBRXI(" "),-1),0,ORIGIN)
 I ECHO W "..."
 I '$$INIT^ABSPOSI(IEN51) G F5:$$IMPOSS^ABSPOSUE("FM,P","TRI","INIT^ABSPOSI failed",,"FILING",$T(+0)) ; it can't fail
 I ECHO W "..."
 D FILEARAY ; store local arrays into 9002313.51
 I ECHO W "..."
 D FILE^ABSPOSIZ(IEN51,ECHO) ;same FILE^ABSPOSIZ as what Screenman input uses to do filing
 I ECHO W !
 Q
TEST ; testing READER
 S X=$$READER
 W "Returned value from READER was ",X,!
 Q
READER(MAXINPUT) ; Get input for Pharmacy POS.
 ; Returns 0 if all is well, nonzero if there's any problems.
 ; DEFNDC should only be there from my TESTONE entry point
 ;
 W !!,"Scan the prescription and NDC numbers.",!
 W "Press ENTER when done and the claims will be processed.",!
 W "Type ^ to stop without sending claims.",!
 W !
 N INDEX S INDEX=0
 N RETVAL
 I '$D(MAXINPUT) S MAXINPUT=10
 F INDEX=1:1:MAXINPUT S RETVAL=$$READER10 Q:RETVAL<1  I RETVAL>1 D
 .S ABSBRXI(INDEX)=ABSBRXI
 .S ABSBRXR(INDEX)=ABSBRXR
 .S ABSBNDC(INDEX)=ABSBNDC
 W ! ; when you pressed ENTER, it didn't echo.
 I RETVAL<0 Q RETVAL
 I ABSBRXI="SCREENMAN" Q ABSBRXI
READER99 Q 0
 ;
 ; FILEARAY is used by $$READER as well as some testing programs
 ; Moves ABSBRXI(*), ABSBRXR(*), ABSBNDC(*) into the .51 input file,
 ; just as if it had been entered through Screenman via ^ABSPOSI
 ; Later, call to ABPOSIZ will carry it into .59
 ; Needs:  IEN51,ABSBRXI(*),ABSBRXR(*),ABSBNDC(*)
FILEARAY ; TO BE MOVED TO ABSPOSIZ:   D INCSTAT^ABSPOSUD($T(+0),1)
 I 0 W "At FILEARAY with ",! D
 . N A S A="" F  S A=$O(ABSBRXI(A)) Q:'A  D
 . . W A,?5,ABSBRXI(A),?20,ABSBRXR(A),?25,ABSBNDC(A),!
 N I,FDA,MSG,SUBF,IENS S SUBF=9002313.512
 F I=1:1 Q:'$D(ABSBRXI(I))  D
 . N PAT S PAT=$P(^PSRX(ABSBRXI(I),0),U,2)
 . S IENS=I_","_IEN51_","
 . S FDA(SUBF,IENS,.01)=I
 . S FDA(SUBF,IENS,.03)=ABSBNDC(I)
 . S FDA(SUBF,IENS,1.01)=ABSBRXI(I)
 . S FDA(SUBF,IENS,1.02)=ABSBRXR(I)
 . S FDA(SUBF,IENS,1.04)=PAT
 ; next line changed from UPDATE^DIE 09/21/2000
FA5 D FILE^DIE("","FDA","MSG")
 I $D(MSG) D  G F5:$$IMPOSS^ABSPOSUE("FM","TRI","FILE^DIE failed",,"FILEARAY",$T(+0))
 . W !,"Unexpected error in FILEARAY^"_$T(+0),!
 . D ZWRITE^ABSPOS("ABSBRXI","ABSBRXR","ABSBNDC","MSG")
 ; TO BE MOVED TO ABSPOSIZ: D ADDSTAT^ABSPOSUD($T(+0),2,INDEX-1)
 Q
 ;
 ; $$SETRXR used by $$READER10 and maybe by others.
 ; Called from PAT3^ABSPOS15         
SETRXR() Q +$O(^PSRX(ABSBRXI,1,"A"),-1) ;most recent refill ^PSRX(ien,
 ;
 ; $$DEFNDC used by $$READER10/$$GETNDC and maybe others.
DEFNDC() ;EP - from ABSPOSIW, ABSPOSRB
 ;IHS/SD/lwj 03/10/04 patch 10 nxt line rmkd out, new line added
 ;I ABSBRXR Q $P($G(^PSRX(ABSBRXI,1,ABSBRXR,0)),U,13)
 I ABSBRXR Q $$NDCVAL^ABSPFUNC(ABSBRXI,ABSBRXR)  ;patch 10
 E  Q $P($G(^PSRX(ABSBRXI,2)),U,7)
 ;IHS/SD/lwj 03/10/04 patch 10 end change
 ;
READER10() ; Get the inputs
 ; INDEX = which one you're on (1 = first, 2 = second, etc.)
 ; Return -1 if the user wants out
 ; Return 0 if input is complete ("" response to Prescription #)
 ; Return >0,<1 if some kind of problem with input (a try-again)
 ; Return >1 if all is well as good for storage
 ; Sets ABSBRXI,ABSBRXR,ABSBNDC
 ;
 ; Prompt user for "Prescription: "
 ;       Set ABSBRXI=ien for ^PSRX(ien,
 ;
READER11 ; branch back if "SCREENMAN" entered too late
 S ABSBRXI=$$GETRX() ; sets ABSBRXR, too
 I ABSBRXI="SCREENMAN" Q:INDEX=1 ABSBRXI D  G READER11
 . W !,"Typing SCREENMAN has to be done at the very beginning.",!
 . W "For now, you're stuck in this old-style input.",!
 . W "Answer with   ^    to get out without doing anything.",!
 ;
 W !
 I ABSBRXI<1 Q $S(ABSBRXI["^":-1,ABSBRXI="":0,1:0.01)
 ;
 S ABSBNDC=$$GETNDC^ABSPOSIW()
 W !
 ;ZW ABSBNDC
 I 'ABSBNDC W !,"Try again.",! H 2 G READER11 ; 03/22/2001 ;Q 0.04
 ;
READER19 Q ABSBRXI ; return big #, since all is well for storage 
 ; with ABSBRXR, ABSBNDC
 ;
 ; Compute time difference
TDIF(H0,H1)        Q $P(H1,",")-$P(H0,",")*86400+$P(H1,",",2)-$P(H0,",",2)
 ;
GETRX() ;EP - from ABSPOS6L,ABSPOS6M
 ;Prompt - get prescription
 ; Return "" or "^" or "^^" or prescription IEN.
 ; Return -1 (?) if prescription not found.
 ; Returns prescription IEN_"R" if you are requesting a reversal.
 ;     ^^^^ that last part isn't implemented yet.
 N X,Y,PT,DG,DIC
GETRX1 ;
 S X=$$FREETEXT^ABSPOSU2("Prescription: ",,1,1,31,$G(DTIME))
 I "^^"[X Q X    ;Q:X="^" "^"  Q:X="" X
 ;
 S X=$TR(X,"abcdefghijklmnopqrstuvwyxz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 I $E("SCREENMAN",1,$L(X))=X Q "SCREENMAN"
 ;
 ; Bar code labels at ANMC have a prefix, "-", and the internal #
 I X["-" S X=$P(X,"-",2),X="`"_X
 ;
 ; If input was pure numeric, look at parameter to determine whether it
 ; is an internal or external prescription number.  If internal, 
 ; prefix the "`".  See too the "+X" to strip leading zeroes. This
 ; might be the case with a bar code input.
 ; 
 I X?1N.N D
 . I $P($G(^ABSP(9002313.99,1,"INPUT")),U)=0 S X="`"_+X
 . ; else it's an external number; leave it alone
 ;
 ; Maybe typed RX followed by an RX external number
 ;
 I $P(X," ")="RX" S X=+$P(X," ",2)
 ;
 S DIC="^PSRX(",DIC(0)="N" D ^DIC
 I Y<1 D  G GETRX1
 .W !,"INPUT - Prescription "_X_" not found.",!
 S Y=+Y
 S X=$G(^PSRX(Y,0))
 S PT=$P(X,U,2),DG=$P(X,U,6)
 I PT]"" W "  ",$P($G(^DPT(PT,0)),U)
 I DG]"" W "  ",$P($G(^PSDRUG(DG,0)),U)
 S ABSBRXI=Y,ABSBRXR=$$SETRXR
 N IEN59 S IEN59=$$IEN59(ABSBRXI,ABSBRXR,1)
 I $$ISRESUB(IEN59) W !?5 D  G:Y<1 GETRX1
 .I 1 N % D  S Y=$S(%=1:Y,%=0:"",%=-1:Y_"R") Q
 . . S %=$$RESUBMIT(IEN59)
 S Y=+Y
 Q Y
IEN59(A,B,C)       Q A_"."_$TR($J(B,4)," ","0")_C
ISRESUB(IEN59)       ; is this a resubmission of the same prescription/refill?
 Q $D(^ABSPT(IEN59))
RESUBMIT(RXI)          ; return 1 = yes, submit again   0 = no, do not resubmit
 ; return -1 if you want to submit a reversal
 ;
 ; Cases:
 ;    Processing complete
 ;       If it was paid, invite a reversal.
 ;    Processing not complete
 ;       Check for system backlog and how long ago progress was made.
 ;       Maybe disallow resubmitting the claim based on that.
 N RETVAL,X
 W !?5,"This prescription has already been processed thru Point of Sale.",!
 N STATUS S STATUS=$P(^ABSPT(RXI,0),U,2)
 N TIME S TIME=$P(^ABSPT(RXI,0),U,8) ; last update
 N REVERSAL S REVERSAL=$G(^ABSPT(RXI,4))
 N NOW,%,%H,%I,X D NOW^%DTC S NOW=%
 N TIMEDIF S TIMEDIF=$$TIMEDIF^ABSPOSUD(TIME,NOW)
 N TIMEDIFI S TIMEDIFI=$$TIMEDIFI^ABSPOSUD(TIME,NOW)
 N COMPLETE S COMPLETE=STATUS'<99
 I COMPLETE D
 . W "Processing completed ",TIMEDIF," ago.",!
 . W "The result was ",$$RESULT^ABSPOS6B(RXI),!
 . I $$RXPAID^ABSPOSNC(RXI) D
 . . W "Last time, the insurer accepted this claim for payment.",!
 . . W "If you wish to resubmit the claim with different data,",!
 . . W "the paid claim must first be reversed (use the REV option",!
 . . W "to reverse paid claims.)",!
 . . S RETVAL=0 Q
 . . ; This part is not implemented.  It would flag this claim for
 . . ; reversal and save the trouble of going into the REV option
 . . S X=$$YESNO^ABSPOSU3("Do you want to request a REVERSAL? ","NO",0)
 . . S RETVAL=$S(X=1:-1,1:0)
 . . I RETVAL=0 W !?5,"You should NOT resubmit this claim.",!
 . E  D
 . . S X=$$YESNO^ABSPOSU3("Do you want to resubmit the claim? ","YES",0)
 . . S RETVAL=$S(X=1:1,1:0)
 . . W " The claim will",$S(RETVAL:"",1:" NOT")," be resubmitted.",!
 E  D
 . W "This claim did not complete processing!",!
 . W "The last activity was ",TIMEDIF," ago.",!
 . N BACKLOG S BACKLOG=$$BACKLOG^ABSPOSIW ; things waiting to process
 . ; The backlog time (weight it some more) plus a few minutes grace
 . ; period, at least, before allowing re-submit.
 . I TIMEDIFI<1800,BACKLOG>30 D
 . . N % S %=BACKLOG+30\60
 . . W "There is an estimated backlog in the Point of Sale system",!
 . . W "of ",%," minute" W:%>1 "s" W " of processing.",!
 . I BACKLOG*1.5+600>TIMEDIFI D  S RETVAL=0 Q
 . . W "Please wait at least ten minutes before trying ",!
 . . W "to resubmit the claim.  It may be waiting its turn for ",!
 . . W "processing.  Or there may be a larger problem that requires",!
 . . W "technical support attention.",!
 . . S %=$G(^ABSPT(RXI,4))
 . . I $P(%,U),'$P(%,U,2) D  ; reversal submitted but no response
 . . . W !!?10,"REVERSALS: If you just recently submitted a REVERSAL,",!
 . . . W ?10,"you may resubmit the claim as soon as the reversal",!
 . . . W ?10,"has been completed.",!
 . S X=$$YESNO^ABSPOSU3("Are you sure you want to resubmit this claim now? ","NO",0)
 . S RETVAL=$S(X=1:1,1:0)
 Q RETVAL
