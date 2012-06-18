ABSPOSID ; IHS/FCS/DRS - the fill date field ;   [ 09/12/2002  10:11 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,10**;JUN 21, 2001
 ;
 ; This should be used for prescriptions (and postage) only,
 ; not charges associated with a visit.  It's tied to the prescription
 ; file.  Besides, a visit lookup has already figured out the date,
 ; implicitly, just by having chosen a visit.
 ;
 ; At the Fill Date field, the user may type:
 ;   An exact date, if you know the exact date of the refill.
 ;   FIND   to see a list of refill dates and then type it in.
 ;
 ; Unlike the Prescription field and ABSPOSI1,
 ; the EFFECTS here are quite simple and are handled from 
 ; inside the VALID logic.
 ;----------------------------------------------------------------------
 ;IHS/SD/lwj 03/10/04 patch 10
 ; Routine adjusted to call ABSPFUNC to retrieve
 ; the Prescription Refill NDC value.  At some
 ; point the call needs to be modified to call APSPFUNC.
 ; See ABSPFUNC for details on why call was done.
 ;----------------------------------------------------------------------
 ;
 Q
VALID ; VALID is the Data Validation action for the field.
 ; It may cause more dialogue.
 ; It might reset X and DDSEXT.  (stored in .06, DATE DISP)
 ; If it does this, and this RXR is different from the one
 ; chosen in $$GET^DDSVAL(DIE,.DA,1.02), then other side effects
 ; need to happen:  (EFFECTS, called from here in VALID, unlike 
 ;  ABSPOSI1, where it's two separate steps)
 ;   
 ;D MSGWAIT("We are in VALID^"_$T(+0)_" with X="_$G(X)_", DDSEXT="_$G(DDSEXT))
 N RXI S RXI=$$GET^DDSVAL(DIE,.DA,1.01,,"I") ; point to ^PSRX
 N RXR,OLDRXR S OLDRXR=$$GET^DDSVAL(DIE,.DA,1.02) K RXR
 D PROCESS(X) ; will set RXR or DDSERROR
 I $D(RXR) D
 . I RXR=OLDRXR D  ; no change, be sure original data is still in place
 . . S (X,DDSEXT)=DDSOLD
 . E  D  ; changed!
 . . N Y S Y=$$FILL(RXI,RXR) ; update date displayed in this field
 . . X ^DD("DD")
 . . S (X,DDSEXT)=$P(Y,",")
 . . D EFFECTS ; and carry out some side effects
 E  D  ; no input; make sure original data is unchanged
 . S (X,DDSEXT)=DDSOLD
 ;D PUT^DDSVAL(DIE,.DA,.06,DDSEXT) ; why do we have to do this?
 ; ^^ it doesn't work if you do it here.
 ;  But we put it into the POST ACTION ON CHANGE
 ;D MSGWAIT("On the way out, we have set X="_$G(X)_" and DDSEXT="_$G(DDSEXT))
 Q
 ;
 ;
PROCESS(X) ;  validate input and return transformed value 
 ; Returns -1 if error and sets DDSERROR
 ;D MSGWAIT("We are in PROCESS^"_$T(+0)_" with X="_$G(X))
 K DDSERROR
VAL1 I 0 ; ELSE each possibility:
 E  I $$UPPER(X)=$E("FIND",1,$L(X)) D
 . W @IOF
 . W $$GET^DDSVAL(DIE,.DA,.04)
 . W "   ",$$GET^DDSVAL(DIE,.DA,.05),!
 . N X S X=$$LOOKUP
 . I "^^"[X S DDSERROR=2
 . S RXR=X
 . D REFRESH^DDSUTL
 E  D
 . N %DT S %DT="P" D ^%DT ; giving Y
 . I Y=-1 S DDSERROR=3 Q
 . ; but it must be a valid fill/refill date for the prescription
 . I Y=$P(^PSRX(RXI,2),U,2) S RXR=0 Q  ; Date of first fill
 . I $D(^PSRX(RXI,1,"B",Y)) S RXR=$O(^PSRX(RXI,1,"B",Y,0)) Q
 . S DDSERROR=4 Q  ; valid date, but not for this prescription
 ;E  D  ; if it didn't hit any of the recognized cases:
 ;. S X=-1,DDSERROR=999
 I $G(DDSERROR) D HELP
 Q
FILL(RXI,RXR) ; return fill date, internal form
 I '$G(RXR) Q $P(^PSRX(RXI,2),U,2)
 Q $P(^PSRX(RXI,1,RXR,0),U)
LOOKUP() ; Choosing which fill date you're processing for
 ; Returns Pointer to refill, = 0 if first fill
 ; Returns "" if no selection made
 N RXI S RXI=$$GET^DDSVAL(DIE,.DA,1.01,,"I")
 I '$O(^PSRX(RXI,1,0)) D  Q 0
 . W "There are no refills.",!
 F  D  Q:X]""
 . S X=$$LOOK2() I X S X=0 Q  ; want to use first fill date
 . S X=$$LOOK3()
 . S:X=U X="" ; back up to $$LOOK2() again
 S:X=U X="" ; backing out; no selection made
 Q X
LOOK2() ; Want to use the first fill date?
 ; If yes, returns >0, = internal form of that date
 ; If no, returns ""
 ; If timeout or "^", returns "^"
 N DDS ; so that ^DIR thinks it's outside Screenman
 N PROMPT,DFLT,OPT,TIMEOUT,X,Y
 S Y=$$FILL(RXI) X ^DD("DD")
 S PROMPT="Use "_Y_", which was the first fill date"
 S DFLT="NO",OPT=0,TIMEOUT=60
 S X=$$YESNO^ABSPOSU3(PROMPT,DFLT,OPT,TIMEOUT)
 Q $S(X:$$FILL(RXI),X=0:"",1:"^")
LOOK3() ; selection from among all the refill dates
 ; Returns "^" if none selected (timeout or ^)
 ; Returns pointer to refill (NOTE! pointer, not date) otherwise
 N DDS ; so that ^DIR thinks it's outside Screenman
 N DIR,DA,X,Y,DTOUT,DUOUT,DIRUT,DIROUT
 S DIR(0)="PA^PSRX("_RXI_",1,",DA(1)=RXI
 S DIR("A")="Select which refill date: "
 D LOOK31
 D ^DIR
 I $D(DIRUT) Q "^"
 I 'Y Q "^"
 Q +Y
LOOK31 ; set up DIR("A",#)=several most recent refill dates
 ; List them all - the most we've seen at Sitka is 12 refills
 N Y,MAX,N,X,TOT S MAX=10,N=0,X="",TOT=$P(^PSRX(RXI,1,0),U,4)
 S DIR("A",1)="Refill dates for this prescription include:"
 S N=2,DIR("A",2)="" ; row # currently being filled
 F  S X=$O(^PSRX(RXI,1,"B",X),-1) Q:X=""  D  Q:N=MAX
 . S Y=X X ^DD("DD")
 . I '$D(DIR("B")) S DIR("B")=Y ; default to most recent refill
 . S Y=$E(Y_"    ",1,14)
 . I $L(DIR("A",N))>65 S N=N+1,DIR("A",N)=""
 . S DIR("A",N)=DIR("A",N)_Y
 . ;I N+1=MAX,TOT>MAX S N=N+1,DIR("A",N)="And more.  Type ? for a complete list."
 Q
FULLSCRE ; adapted from FULL^VALM1
 S IOTM=1,IOBM=IOSL W IOSC W @IOSTBM W IORC Q
HELP ;
 N AR,N S N=0
 D HELP1("To choose a different refill,")
 D HELP1("type the date of the refill here.")
 D HELP1("Or, type F or FIND to get a lookup dialogue.")
 D HLP^DDSUTL(.AR)
 Q
HELP1(X) S N=N+1,AR(N)=X Q
MSGWAIT(X) ;EP - from ABSPOSI2,ABSPOSI8
 N AR S AR(1)=X
 ; ,AR(2)="$$EOP" 
 D HLP^DDSUTL(.AR)
 D HLP^DDSUTL("$$EOP")
 Q
EFFECTS ; side effects of putting a value in the Fill Date field
 D PUT^DDSVAL(DIE,.DA,.06,DDSEXT) ; it doesn't seem to take, if here
 ; so we put it in the POST ACTION ON CHANGE
 ;
 N NDC
 ;IHS/SD/lwj 03/10/04 patch 10 nxt line rmkd out, new line added
 ;I RXR S NDC=$P(^PSRX(RXI,1,RXR,0),U,13)
 I RXR S NDC=$$NDCVAL^ABSPFUNC(RXI,RXR)  ;patch 10
 E  S NDC=$P(^PSRX(RXI,2),U,7)
 ;IHS/SD/lwj 03/10/04 patch 10 end change
 I NDC]"" D PUT^DDSVAL(DIE,.DA,.03,NDC)
 D PUT^DDSVAL(DIE,.DA,1.02,RXR)
 D PUT^DDSVAL(DIE,.DA,1.06,$$VISIT(RXI,RXR),,"I")
 Q
MMMDD(Y) ;EP
 X ^DD("DD") Q $P(Y,",")
UPPER(X) Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
VISIT(RXI,RXR)     ;
 N VISIT
 I $G(RXR) S VISIT=$P($G(^PSRX(RXI,1,RXR,999999911)),U)
 E  S VISIT=$P($G(^PSRX(RXI,999999911)),U)
 I VISIT S VISIT=$P($G(^AUPNVMED(VISIT,0)),U,3)
 Q VISIT
