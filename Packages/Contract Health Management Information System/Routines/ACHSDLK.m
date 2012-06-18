ACHSDLK ; IHS/ITSC/PMF - DENIAL LOOKUP ;  [ 10/31/2003  11:41 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**18**;JUNE 11, 2001
 ;ACHS*3.1*1 expand prompt for denial number to include patient name
 ;ACHS*3.1*3 added search for non registered patients
 ;           Overhauled routine structure so that THIS ALL LOOKS NEW
 ;ACHS*3.1*4 include issue and service dates on line display
 ;ACHS*3.1*6 3.28.03 IHS/SET/FCJ Not able to look up non reg patients
 ;           format problems on display
 ;
 ;12/20/01   pmf
 ;I have saved off this routine to ACHSDLKS if we need to roll back or
 ;check against the previous version.
 ;
 ;
 K ACHDLKER,DFN
 S DIWL=5,DIWR=75,DIWF="W"
 N DONE S DONE=0
 ;
 ;keep asking them for a denial until we get DONE
 ;DONE can mean we got one, or we are ready to quit
 F  D  Q:DONE
 . D GETDEN
 . I $D(ACHDLKER) S DONE=1 Q
 . I ACHSA="" S (ACHDLKER,DONE)=1 Q
 . D PP
 . Q
 ;
 K DIC
 Q
 ;
 ;
GETDEN ;get a denial, either by number or by patient
 W !!
 K DFN,DIC,Y S ACHSA=""
 S DIR("A")="Enter the DENIAL NUMBER or PATIENT"
 S DIR("?")="Enter either the denial number or a Patient Identifier (Name, HRN, SSN, DOB)"
 S DIR(0)="FO" D ^DIR K DIR
 ;
 ;now the responses.  if quit, quit.
 Q:$D(DIRUT)
 ;
 ;see if the input is a real, full denial case number
 ;if so, X will not be null after this
 S X="",X=$O(^ACHSDEN(DUZ(2),"D","B",Y,""))
 ;
 ;if they entered a blank space or a denial number, use
 ;^DIC to load info
 I Y=" "!X S X="" D GETDEN2("EMZ",Y) Q:ACHSA'=""  W "  ","??" G GETDEN
 ;
 ;ACHS*3.1*6 3.28.03 IHS/SET/FCJ ADD NXT 4 LINES TO LST DENIAL PATIENTS 
 ;Registered and non-registered
 S X=Y,ACHSTMP=Y ;SAVE VAR FOR RETURN FR GETDEN2
 I X'?1N.N D GETDEN2("EMZ",X)
 I $D(DTOUT)!$D(DUOUT) G GETDEN
 Q:ACHSA'=""
 ;
 ;first, try patient lookup for registered patients
 ;ACHS*3.1*6 3.28.03 IHS/SET/FCJ Y VALUE WAS CHANGED IN CALL TO GETDEN
 ;S X=Y,DIC="^AUPNPAT(",DIC(0)="EM",AUPNLK("ALL")=1 ;ACHS*3.1*6
 S X=ACHSTMP,DIC="^AUPNPAT(",DIC(0)="EM",AUPNLK("ALL")=1 ;ACHS*3.1*6
 D ^DIC
 ;
 ;if that didn't work, try looking up unregistered patients
 ;if it works, stop, if it doesn't go back to the top
 I +Y<0 D  Q:ACHSA'=""  W "  ","??" G GETDEN
 . D GETDEN2("EMZ",X)
 . ;I +Y<1 S ACHDLKER="" G END
 . ;S ACHSA=+Y
 ;
 ;if we DID find a registered patient, submit that and get denial
 S PATDAT=$G(^DPT(+Y,0))
 I PATDAT="" G GETDEN
 D GETDEN2("EMZ",$P(PATDAT,U,1))
 I +Y<0 W "  ","??" G GETDEN
 S ACHSA=+Y
 ;
 K ACHSTMP ;ACHS*3.1*6 3.28.03 IHS/SET/FCJ ADDED K ACHSTMP
 Q
 ;
GETDEN2(DIC0,X) ;
 ;use ^DIC to get a denial case.
 ;input:   DIC0   the value to give DIC(0)
 ;         X      the input value for ^DIC, not manditory
 S X=$G(X)
 K DIC
 S DIC="^ACHSDEN("_DUZ(2)_",""D"","
 S DIC(0)=DIC0
 S DIC("A")="Enter the DENIAL NUMBER or PATIENT: "
 S DIC("S")="I $P($G(^(0)),U)'[""#"""
 S DA(1)=DUZ(2)
 ;
 ;ACHS*3.1*4   3/28/02  pmf  add issue and service date to display
 ;ACHS*3.1*6 3.28.03 IHS/SET/FCJ FIX SPACE DISPLAY
 ;S DIC("W")="W ""ISS: "",$E($P(^(0),U,2),4,5),""/"",$E($P(^(0),U,2),6,7),""/"",($E($P(^(0),U,2),1,3)+1700),""    SERV: "",$E($P(^(0),U,4),4,5),""/"",$E($P(^(0),U,4),6,7),""/"",($E($P(^(0),U,4),1,3)+1700)"  ;  ACHS*3.1*6
 S DIC("W")="W "" ISS: "",$E($P(^(0),U,2),4,5),""/"",$E($P(^(0),U,2),6,7),""/"",($E($P(^(0),U,2),1,3)+1700),""  SRV: "",$E($P(^(0),U,4),4,5),""/"",$E($P(^(0),U,4),6,7),""/"",($E($P(^(0),U,4),1,3)+1700)"  ;  ACHS*3.1*6
 ;
 ;
 D ^DIC
 Q:+Y<0
 S ACHSA=+Y
 Q
 ;
PP ;
 S Y(0)=$G(Y(0))
 G P0:$P(Y(0),U,6)'="Y"!($P(Y(0),U,7)']"")
 G P0:'$D(^DPT($P(Y(0),U,7),0))
 S DFN=$P(Y(0),U,7)
 G P1
 ;
P0 ;
 G NAMERR:'$D(^ACHSDEN(DUZ(2),"D",ACHSA,10))
 G NAMERR:$P($G(^ACHSDEN(DUZ(2),"D",ACHSA,10)),U)']""
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
 S A=$G(^ACHSDEN(DUZ(2),"D",ACHSA,10))
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
