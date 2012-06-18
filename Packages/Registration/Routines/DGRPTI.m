DGRPTI ;ALB/RMO - 10-10T Registration - Interview;21 NOV 1996 8:43 am ; 8/28/00 9:42am
 ;;5.3;Registration;**108,147,175,343**;08/13/93
 ;
EN ;Entry point for DGRPT INTERVIEW protocol
 ; Input  -- DFN      Patient IEN
 ; Output -- VALMBCK  R   =Refresh screen
 N DGRPTOUT
 S VALMBCK=""
 D FULL^VALM1
 D INT(DFN,"",.DGRPTOUT),PAUSE^VALM1:'DGRPTOUT
 D BLD^DGRPTL S VALMBCK="R"
 Q
 ;
INT(DFN,DGNEWPF,DGRPTOUT) ;Interview for 10-10T registration
 ; Input  -- DFN      Patient IEN
 ;           DGNEWPF  New patient added flag
 ;                    1   =New patient added
 ;                    Null=Existing patient
 ; Output -- DGRPTOUT Quit flag
 ;                     0  =No
 ;                    -1  =User entered up-arrow
 ;                    -2  =Timeout
 ;                    -3  =Unable to lock record
 N DG1010TF,DGASKDEV,DGDIV,DGIO
 ;
 D BEGINREG^DGREG(DFN)
 ;
 ;Set the 10-10T registration flag and the quit flag
 S DG1010TF=1,DGRPTOUT=0
 ;
 ;Set up registration parameters
 D SETPAR^DGRPTU(.DGDIV,.DGIO,.DGASKDEV,.DGRPTOUT)
 I DGRPTOUT<0,$$ASKEXT(.DGRPTOUT) G INTQ
 ;
 D CKUPLOAD^DGENUPL3(DFN)
 ;
 ;Edit patient data for 10-10T
 D PAT(DFN,DGNEWPF,.DGRPTOUT)
 I DGRPTOUT<0,$$ASKEXT(.DGRPTOUT) G INTQ
 ;
 ;
 D CKUPLOAD^DGENUPL3(DFN)
 ;
 ;Edit marital information for 10-10T
 D MAR(DFN,.DGRPTOUT)
 I DGRPTOUT<0,$$ASKEXT(.DGRPTOUT) G INTQ
 ;
 ;
 D CKUPLOAD^DGENUPL3(DFN)
 ;
 ;Edit income data for 10-10T
 D INC(DFN,.DGRPTOUT)
 I DGRPTOUT<0,$$ASKEXT(.DGRPTOUT) G INTQ
 ;
 ;
 D CKUPLOAD^DGENUPL3(DFN)
 ;
 ;Edit insurance data for 10-10T
 D INS(DFN,.DGRPTOUT)
 I DGRPTOUT<0,$$ASKEXT(.DGRPTOUT) G INTQ
 ;
 ;Ask if user would like to do a HINQ inquiry
 D HINQ(DFN,.DGRPTOUT)
 I DGRPTOUT<0,$$ASKEXT(.DGRPTOUT) G INTQ
 ;
 ;Invoke consistency checker
 D CONCK(DFN,.DGRPTOUT)
 I DGRPTOUT<0,$$ASKEXT(.DGRPTOUT) G INTQ
 ;
 ;Check for open disposition
 I $D(^DPT("ADA",1,DFN)) D  G INTQ ;exit if open disposition
 . W !!,*7,">>> Patient cannot be registered while there is still an open disposition."
 ;
 ;Register patient
 I $$ASKREG D
 . D EN1010T^DGREG(DFN,DGNEWPF,DGDIV,.DGIO,$G(DGASKDEV),DG1010TF)
 ELSE  D
 . ;Print 10-10T
 . I $$ASKPRT D
 . . I $D(DGIO(10)) D
 . . . D QUE^DGRPTP(DFN,,.DGIO) ;queue 10-10T print
 . . ELSE  D
 . . . D ENDEV^DGRPTP(DFN) ;ask device then print 10-10T
 ;
INTQ D ENDREG^DGREG(DFN)
 Q
 ;
PAT(DFN,DGNEWPF,DGRPTOUT) ;Edit patient data for 10-10T
 ; Input  -- DFN      Patient IEN
 ;           DGNEWPF  New patient added flag
 ; Output -- DGRPTOUT Quit flag
 N DA,DIE,DTOUT,DR,IOINHI,IOINORM,X
 S X="IOINHI;IOINORM" D ENDR^%ZISS
 W !,"---",IOINHI,"Patient: Eligibility, Demographic",IOINORM,"---"
 W !,IOINHI,"   Emergency Contact and Military Service",IOINORM
 ;Check elig prior to permitting edit of name, dob and ssn
 I '$G(DGNEWPF),$$ELGCHK^DGRPTU(DFN) D ID(DFN,.DGRPTOUT) G PATQ:DGRPTOUT<0
 S DA=DFN,DIE="^DPT(",DR="[DGRPT 10-10T REGISTRATION]"
 L +^DPT(DA):0 I $T D
 . D ^DIE L -^DPT(DA)
 . ;DGFIN is used to determine whether or not the user entered
 . ;an up-arrow when calling DIE
 . S DGRPTOUT=$S($D(DTOUT):-2,'$D(DGFIN):-1,1:0)
 ELSE  D
 . W !,"Another user is editing, try later ..."
 . S DGRPTOUT=-3
 K DGFIN
 I $D(DGPHMULT) D EDITPH1^DGRPLE()
 K DGPHMULT
PATQ Q
 ;
ID(DFN,DGRPTOUT) ;Edit patient name, dob and ssn
 ; Input  -- DFN      Patient IEN
 ; Output -- DGRPTOUT Quit flag
 N DA,DIE,DTOUT,DR
 S DA=DFN,DIE="^DPT(",DR="K DGFIN;.01;.03;.09;@98;S DGFIN="""""
 L +^DPT(DA):0 I $T D
 . D ^DIE L -^DPT(DA)
 . S DGRPTOUT=$S($D(DTOUT):-2,'$D(DGFIN):-1,1:0)
 ELSE  D
 . W !,"Another user is editing, try later ..."
 . S DGRPTOUT=-3
 K DGFIN
 Q
 ;
MAR(DFN,DGRPTOUT) ;Edit marital information for 10-10T
 ; Input  -- DFN      Patient IEN
 ; Output -- DGRPTOUT Quit flag
 N DGDEP,DGERR,DGFL,DGINI,DGIRI,DGISDT,DGPRI,DGREL,DGSPFL,DTOUT,IOINHI,IOINORM,X
 ;Set income screening date to last year
 S DGISDT=$$LYR^DGMTSCU1(DT)
 ;
 ;Make sure patient is in the Patient Relation file (#408.12)
 D NEW^DGRPEIS1
 S DGRPTOUT=DGFL
 ;
 ;Set active dependent Patient Relation array DGREL for SPOUSE calls
 D GETREL^DGMTU11(DFN,"VS",DGISDT) G MARQ:'$G(DGREL("V"))
 ;
 S X="IOINHI;IOINORM" D ENDR^%ZISS
 W !!,"---",IOINHI,"Marital",IOINORM,"---"
 ;
 ;Check if patient was married last calendar year
 D SPOUSE^DGRPEIS2
 I $G(DTOUT) S DGRPTOUT=-2
 I DGRPTOUT<0,$$ASKEXT(.DGRPTOUT) G MARQ
 ;
 ;If patient was married last calendar year ask spouse information
 I $G(DGSPFL) D SPOUSE(DFN,.DGREL,.DGRPTOUT)
MARQ Q
 ;
SPOUSE(DFN,DGREL,DGRPTOUT) ;Edit spouse data for 10-10T
 ; Input  -- DFN      Patient IEN
 ;           DGREL    Active dependent array
 ; Output -- DGRPTOUT Quit flag
 N DGFL,DGIPI,DGPRI,IOINHI,IOINORM,X
 S X="IOINHI;IOINORM" D ENDR^%ZISS
 W !!,"---",IOINHI,"Spouse",IOINORM,"---"
 I '$G(DGREL("S")) D
 . ;Add demographic data for spouse
 . D ADD^DGRPEIS(DFN,"S")
 ELSE  D
 . ;Edit demographic data for spouse
 . D EDIT^DGRPEIS(DGREL("S"),"S")
 S DGRPTOUT=DGFL
 Q
 ;
INC(DFN,DGRPTOUT) ;Edit income data for 10-10T
 ; Input  -- DFN      Patient IEN
 ; Output -- DGRPTOUT Quit flag
 N DA,DGDEP,DGFL,DGINC,DIE,DR,DTOUT,IOINHI,IOINORM,X
 ;Get patient's Individual Annual Income file (#408.21) IEN - DGINC("V")
 D ALL^DGMTU21(DFN,"V",DT,"I") G INCQ:'$G(DGINC("V"))
 ;
 S X="IOINHI;IOINORM" D ENDR^%ZISS
 W !!,"---",IOINHI,"Income",IOINORM,"---"
 ;
 ;Edit patient's Last Year's Estimated "Household" Taxable Income
 S DA=DGINC("V"),DIE="^DGMT(408.21,",DR="K DGFIN;.21T;@98;S DGFIN="""""
 L +^DGMT(408.21,DA):0 I $T D
 . D ^DIE L -^DGMT(408.21,DA)
 . S DGRPTOUT=$S($D(DTOUT):-2,'$D(DGFIN):-1,1:0)
 ELSE  D
 . W !,"Another user is editing, try later..."
 . S DGRPTOUT=-3
 K DGFIN
INCQ Q
 ;
INS(DFN,DGRPTOUT) ;Edit insurance data for 10-10T
 ; Input  -- DFN      Patient IEN
 ; Output -- DGRPTOUT Quit flag
 N DTOUT,DUOUT,IBCOV,IOINHI,IOINORM,X
 S X="IOINHI;IOINORM" D ENDR^%ZISS
 W !!,"---",IOINHI,"Insurance",IOINORM,"---"
 ;
 ;Update insurance data
 D
 .I $G(DGPRFLG) D PREG^IBCNBME(DFN) Q
 .D REG^IBCNBME(DFN)
 .Q
 S DGRPTOUT=$S($D(DTOUT):-2,$D(DUOUT):-1,1:0)
 Q
 ;
HINQ(DFN,DGRPTOUT) ;HINQ inquiry
 ; Input  -- DFN      Patient IEN
 ; Output -- DGRPTOUT Quit flag
 N DTOUT,IOINHI,IOINORM,X
 S X="IOINHI;IOINORM" D ENDR^%ZISS
 W !!,"---",IOINHI,"HINQ Inquiry",IOINORM,"---"
 ;
 ;HINQ inquiry
 D HINQ^DG10
 S:$G(DTOUT) DGRPTOUT=-2
 Q
 ;
CONCK(DFN,DGRPTOUT) ;Consistency check
 ; Input  -- DFN      Patient IEN
 ; Output -- DGRPTOUT Quit flag
 N DGCD,DGCHK,DGDAY,DGEDCN,DGER,DGLST,DGNCK,DGRPCOLD,DGSC,DGTYPE,DGVT,IOINHI,IOINORM,VA,X
 S X="IOINHI;IOINORM" D ENDR^%ZISS
 W !!,"---",IOINHI,"Consistency Checker",IOINORM,"---"
 ;
 ;Invoke consistency checker
 S DGEDCN=1 D ^DGRPC
 S:$G(DTOUT) DGRPTOUT=-2
 Q
 ;
ASKREG() ;Ask if user would like to register patient
 ; Input  -- None
 ; Output -- 1=Yes and 0=No
 N DIR,DTOUT,DUOUT,Y
 S DIR("A",1)="At this time you may Register the patient if he or she is present and"
 S DIR("A",2)="seeking care.  Answer 'No' if this was a mail-in application."
 S DIR("A",3)=""
 S DIR("A")="Would you like to Register the patient"
 S DIR("B")="YES",DIR(0)="Y"
 W ! D ^DIR
 Q +$G(Y)
 ;
ASKEXT(DGRPTOUT) ;Ask if user would like to exit interview
 ; Input  -- DGRPTOUT Quit flag
 ; Output -- 1=Yes and 0=No
 ;           DGRPTOUT Quit flag re-set
 N DIR,DTOUT,DUOUT,Y
 ;Timeout
 I DGRPTOUT=-2 D
 . S Y=1
 ELSE  D
 . S DIR("A")="Exit Interview"
 . S DIR("B")="YES",DIR(0)="Y"
 . W ! D ^DIR
 . S:$D(DTOUT)!($D(DUOUT)) Y=1
 S:'Y DGRPTOUT=0
 Q +$G(Y)
 ;
ASKPRT() ;Ask if user would like to print the 10-10T
 ; Input  -- None
 ; Output -- 1=Yes and 0=No
 N DIR,DTOUT,DUOUT,Y
 S DIR("A")="PRINT 10/10T"
 S DIR("B")="YES",DIR(0)="Y"
 W ! D ^DIR
 Q +$G(Y)
