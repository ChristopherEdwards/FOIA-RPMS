BKMVF4 ;PRXM/HC/JGH - Auto-Populate Register using Q-Man ; 07 Jun 2005  11:41 AM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
 ;
GETTEMP() ; Select Q-Man template
 ; Output variables:  TEMPLATE, TEMPNAME must not be newed here
 N DIC,DTOUT,DUOUT,X,Y,DA,DD,DR,DINUM,D,DLAYGO,DIADD
 S (TEMPLATE,TEMPNAME)=""
 S DIC("A")="Select template: "
 S DIC=.401
 S DIC(0)="AEMQZ"
 D ^DIC
 I $D(DTOUT)!$D(DUOUT)!($G(Y)<1) Q 0
 S TEMPLATE=+Y,TEMPNAME=$P(Y,"^",2)
 Q 1
 ;
GETTRGT() ; Select Populate Candidate File or Register with Active
 ; Output variables:  TEMPLATE, TEMPNAME must not be newed here
 N DIR,DTOUT,DUOUT,X,Y,GETTRGT
 S GETTRGT=""
 D ^XBFMK
 S DIR(0)="SO^C:HMS Candidate for Individual Review and Acceptance;R:HMS Register with ACTIVE Status"
 D ^DIR I $D(DTOUT)!$D(DUOUT) Q GETTRGT
 S GETTRGT=$G(Y)
 Q GETTRGT
 ;
PRCTEMP ; EP - Register Populate template.
 N REGISTER,DIR,X,Y,TEMPLATE,DFN,BKMIEN,IGNORE,BKCIEN,STATUS,BKMPOPDT,TEMPNAME
 N BKMTRGT,BKMCIEN,DIK,DIE
 S REGISTER=$$HIVIEN^BKMIXX3()
 I REGISTER="" Q
 I '$$VALID^BKMIXX3(DUZ) Q
 I '$$GETTEMP Q
 ; Determine if the user wants to populate the candidate list or the register
 S BKMTRGT=$$GETTRGT
 I BKMTRGT="" Q
 I BKMTRGT'="R",BKMTRGT'="C" Q
 W !!,"Do you wish to populate the "_$S(BKMTRGT="C":"candidate list",1:"register")_" with data from :"_TEMPNAME
 S DIR(0)="Y",DIR("B")="YES"
 D ^DIR
 I $D(DTOUT)!$D(DUOUT)!(Y=0) W @IOF G PRCTEMP
 W !,"Populating the "_$S(BKMTRGT="C":"candidate list",1:"register")_" using template: "_TEMPNAME
 W !,"Please wait ..."
 Q:TEMPLATE=""
 S DFN=0
 F  S DFN=$O(^DIBT(TEMPLATE,1,DFN)) Q:DFN=""  W "." D
 . ; Quit, if registry entry exists
 . Q:$O(^BKM(90451,"B",DFN,""))'=""
 . ; Populate register with ACTIVE status
 . I BKMTRGT="R" D  Q
 . . ; Create register entry
 . . I $$ADD(DFN),$O(^BKM(90451.2,"B",DFN,""))'="" D
 . . . S BKMCIEN=$O(^BKM(90451.2,"B",DFN,""))
 . . . ; Delete the candidate record
 . . . S DIK="^BKM(90451.2,",DA=BKMCIEN D ^DIK
 . I BKMTRGT'="C" Q
 . ; Quit, if candidate entry exists and target is candidate list
 . Q:$O(^BKM(90451.2,"B",DFN,""))'=""
 . ; Create candidate entry
 . S BKMPOPDT=$E($$NOW^XLFDT(),1,12)
 . D NPAT^BKMVFAP1(DFN)
 . ; Update entry with Q-MAN template
 . S DA=$G(BKCIEN)
 . Q:DA=""
 . S DIE="^BKM(90451.2,"
 . S DR=".02////"_TEMPLATE
 . L +^BKM(90451.2,DA):0 I $T D ^DIE L -^BKM(90451.2,DA) Q
 W !,"Population completed." H 2
 Q
 ;
ADD(BKMDFN) ; -- add patient to HMS register with ACTIVE status
 N BKMHIV,BKMIEN,BKMREG,BKMVUP,BKMIENS,BKMOK
 S BKMOK=0
 D ^XBFMK ; Kills off a lot of Fileman variables
 ; Add HMS Register entry
 S BKMHIV=$$HIVIEN^BKMIXX3()
 I BKMHIV="" Q BKMOK
 S BKMIEN=$$BKMIEN^BKMIXX3(BKMDFN)   ; BKMIEN and BKMREG are used by the routine BKMVAUD
 I BKMIEN="" S BKMIEN=$$ADDPAT^BKMVCD(BKMDFN) ; Create entry in iCare registry for patient.
 I BKMIEN="" Q BKMOK
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 I BKMREG="" S BKMREG=$$ADDREG^BKMVCD(BKMIEN,BKMHIV) ; Create HMS register entry for patient.
 I BKMREG="" Q BKMOK
 ; Success
 S BKMOK=1
 ; Enter audit entry for the NEW record
 D NEW^BKMVAUDN(BKMIEN,BKMREG,DUZ)
 ;
 D EN^BKMVAUD ; Start audit log
 K BKMVUP
 S BKMIENS=BKMREG_","_BKMIEN_","
 S BKMVUP(90451.01,BKMIENS,.02)=DT
 S BKMVUP(90451.01,BKMIENS,.025)=DUZ
 S BKMVUP(90451.01,BKMIENS,.5)="A"  ; ACTIVE
 S BKMVUP(90451.01,BKMIENS,.75)=DT
 S BKMVUP(90451.01,BKMIENS,.8)=DUZ
 D FILE^DIE("I","BKMVUP")
 K BKMVUP
 D POST^BKMVAUD ; End audit log
 ;
 D ^XBFMK ; Kills off a lot of Fileman variables
 Q BKMOK
 ;
 ;
