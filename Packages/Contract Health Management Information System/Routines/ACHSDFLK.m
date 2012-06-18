ACHSDFLK ; IHS/ITSC/PMF - DEFERRAL LOOKUP ;  [ 04/19/2002  9:30 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**18**;JUN 11, 2001
 ;ACHS*3.1*4 whole routine is new for this patch
 ;ACHS*3.1*18 4/1/2010;IHS/OIT/ABK;Change every occurrance of Deferred to Unmet Need
 ;
 K ACHDLKER,DFN
 S DIWL=5,DIWR=75,DIWF="W"
 N DONE S DONE=0
 ;
 ;keep asking them for a deferral until we get DONE
 ;DONE can mean we got one, or we are ready to quit
 F  D  Q:DONE
 . D GETDEF
 . I $D(ACHDLKER) S DONE=1 Q
 . I ACHSA="" S (ACHDLKER,DONE)=1 Q
 . D PP
 . Q
 ;
 K DIC
 Q
 ;
 ;
GETDEF ;get a deferral, either by number or by patient
 W !!
 K DFN,DIC,Y S ACHSA=""
 ;{ABK, 3/31/10}S DIR("A")="Enter the DEFERRAL NUMBER or PATIENT"
 ;{ABK, 3/31/10}S DIR("?")="Enter either the deferral number or a Patient Identifier (Name, HRN, SSN, DOB)"
 S DIR("A")="Enter the UNMET NEED NUMBER or PATIENT"
 S DIR("?")="Enter either the unmet need number or a Patient Identifier (Name, HRN, SSN, DOB)"
 S DIR(0)="FO" D ^DIR K DIR
 ;
 ;now the responses.  if quit, quit.
 Q:$D(DIRUT)
 ;
 ;see if the input is a real, full deferral case number
 ;if so, X will not be null after this
 S X="",X=$O(^ACHSDEF(DUZ(2),"D","B",Y,""))
 ;
 ;if they entered a blank space or a deferral number, use
 ;^DIC to load info
 I Y=" "!X S X="" D GETDEF2("EMZ",Y) Q:ACHSA'=""  W "  ","??" G GETDEF
 ;
 ;first, try patient lookup for registered patients
 S X=Y,DIC="^AUPNPAT(",DIC(0)="EM",AUPNLK("ALL")=1
 D ^DIC
 ;
 ;if that didn't work, try looking up unregistered patients
 ;if it works, stop, if it doesn't go back to the top
 I +Y<0 D  Q:ACHSA'=""  W "  ","??" G GETDEF
 . D GETDEF2("EMZ",X)
 . ;I +Y<1 S ACHDLKER="" G END
 . ;S ACHSA=+Y
 ;
 ;if we DID find a registered patient, submit that and get deferral
 S PATDAT=$G(^DPT(+Y,0))
 I PATDAT="" G GETDEF
 D GETDEF2("EMZ",$P(PATDAT,U,1))
 I +Y<0 W "  ","??" G GETDEF
 S ACHSA=+Y
 ;
 Q
 ;
GETDEF2(DIC0,X) ;
 ;use ^DIC to get a deferral case.
 ;input:   DIC0   the value to give DIC(0)
 ;         X      the input value for ^DIC, not manditory
 S X=$G(X)
 K DIC
 S DIC="^ACHSDEF("_DUZ(2)_",""D"","
 S DIC(0)=DIC0
 ;{ABK, 3/31/10}S DIC("A")="Enter the deferral NUMBER or PATIENT: "
 S DIC("A")="Enter the unmet need NUMBER or PATIENT: "
 S DIC("S")="I $P($G(^(0)),U)'[""#"""
 S DA(1)=DUZ(2)
 ;
 ;3/28/02  pmf  experimenting with DIC("W")
 S DIC("W")="W $E($P(^(0),U,2),4,5),""/"",$E($P(^(0),U,2),6,7),""/"",($E($P(^(0),U,2),1,3)+1700)"
 ;
 D ^DIC
 Q:+Y<0
 S ACHSA=+Y
 Q
 ;
PP ;
 S Y(0)=$G(Y(0))
 G P0:$P(Y(0),U,5)'="Y"!($P(Y(0),U,6)']"")
 G P0:'$D(^DPT($P(Y(0),U,6),0))
 S DFN=$P(Y(0),U,6)
 G P1
 ;
P0 ;
 I $P(Y(0),U,7)="" G NAMERR
 ;
P1 ;
 W !!,"You have chosen "_ACHDOCT_" document ",$P(Y(0),U),!!
 G P2:'$D(DFN)
 W $P($G(^DPT(DFN,0)),U),!
 S A=$G(^DPT(DFN,.11))
 W $P(A,U),!,$P(A,U,4)
 S ACHDST=$P(A,U,5)
 I ACHDST]"",$D(^DIC(5,ACHDST,0)) W " ",$P($G(^DIC(5,ACHDST,0)),U,2)
 W " ",$P(A,U,6),!!
 G P3
 ;
P2 ;
 S A=$G(^ACHSDEF(DUZ(2),"D",ACHSA,10))
 W $P(A,U),!,$P(A,U,2),!,$P(A,U,3)
 S ACHDST=$P(A,U,4)
 I ACHDST]"",$D(^DIC(5,ACHDST,0)) W " ",$P($G(^DIC(5,ACHDST,0)),U,2)
 W " ",$P(A,U,5),!!
P3 ;
 W "Date of service ",$$FMTE^XLFDT($$DN^ACHS(0,4)),!!
 S %=$$DIR^ACHS("Y","Is this correct","YES","Did you select the correct document?","",2)
 I $D(DTOUT)!$D(DUOUT) S ACHDLKER="",DONE=1
 I % S DONE=1
 Q
 ;
NAMERR ;
 W !!,*7,"No valid PATIENT NAME in this file.",!,"No letter may be printed until a valid patient is entered.",!!
 Q
 ;
