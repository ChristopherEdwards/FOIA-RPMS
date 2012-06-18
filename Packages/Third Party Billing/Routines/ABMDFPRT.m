ABMDFPRT ; IHS/ASDST/DMJ - PRINT CONTROL ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;02/08/96 12:27 PM
 ;
 K ABM,ABMP
 ;
SEL ;
 ; Select the form to be exported (printed)
 W !!
 K DIC
 S DIC="^ABMDEXP("
 S DIC(0)="QZEAM"
 S DIC("A")="Select the FORM to be EXPORTED: "
 S DIC("S")="I $P($G(^(1)),U,5)'=""E"""    ; Screen out EMC formats
 D ^DIC
 G XIT:X=""!$D(DUOUT)!$D(DTOUT)
 G SEL:+Y<1
 S (ABMP("EXP"),ABM("FORM"))=+Y    ; IEN to 3P MODE OF EXPORT
 S ABM("F")=Y(0,0)                 ; name of export form
 W !!?8," (NOTE: ",$S($P($G(^ABMDEXP(ABMP("EXP"),1)),U,4):"Plain Paper",1:Y(0,0)_" forms")," should be loaded in the printer.)"
 ;
CHK ;
 ; Loop thru bills with a claim status of approved count those to be 
 ; exported.
 W !!,"Counting..."
 S ABM=""
 S ABM("C")=0                      ; claim counter
 F  S ABM=$O(^ABMDBILL(DUZ(2),"AC","A",ABM)) Q:'ABM  D
 . I '$D(^ABMDBILL(DUZ(2),ABM,0)) K ^ABMDBILL(DUZ(2),"AC","A",ABM) Q
 . ; Quit if status is not approved or reviewed.
 . Q:"RA"'[$P($G(^ABMDBILL(DUZ(2),ABM,0)),U,4)
 . ; count bills with desired mode of export
 . I $P($G(^ABMDBILL(DUZ(2),ABM,0)),U,6)=ABM("FORM") S ABM("C")=ABM("C")+1
 ; If no bills found, display message and exit
 I ABM("C")=0 D  G XIT
 . W !!?5,*7,"There are no Approved ",ABM("F"),"'s to be Printed!",!
 . K DIR
 . S DIR(0)="E"
 . D ^DIR
 I ABM("C")>249 W !!?8,"You have reached the Maximum Number (250) of Forms that can be",!?8,"printed during one job!",!!
 W "  Number of ",ABM("F")," forms awaiting export: ",ABM("C")
 ;
SEL2 ;
 ; Select exclusion parameters, find bills that match specified 
 ; criteria
 S ABM("APPR")=DUZ                 ; Approving official (user)
 S ABM("NODX")=""
 S ABMP("TYP")=2                   ; Insurer type
 D ^ABMDRSEL                       ; Select exclusion parameters
 G XIT:$D(DTOUT)!$D(DUOUT)
 D ^ABMDBCNT                       ; Build ABMY array of selected bills
 ; If no bills found that match the exclusion parameters, ask
 ; them to re-select / exit
 I ABM("C")=0 D  G SEL2:Y=1,XIT
 . W !!?5,*7,"With the EXCLUSION PARAMETERS selected there are no ",ABM("F"),"'s to Print!",!
 . K DIR
 . S DIR(0)="Y"
 . S DIR("B")="Y"
 . S DIR("A")="Do you Wish to RE-SELECT the EXCLUSION PARAMETERS"
 . D ^DIR
 . K DIR
 W !!?5,"Number of "_$P(^ABMDEXP(ABMP("EXP"),0),U)_" forms to be Printed: ",ABM("C")
 ;
ZIS ;
 ; Select output device, call routine to print specified form
 W !!
 S %ZIS("A")="Output DEVICE: "
 S %ZIS="PQ"
 D ^%ZIS
 G:POP XIT
 I IO'=IO(0),IOT'="HFS" D  Q
 .D QUE
 .D HOME^%ZIS
 U IO(0)
 W:'$D(IO("S")) !!,"Printing..."
 U IO
 D PRT
 D WTOT^ABMDFUTL
 D XIT
 Q
 ;
PRT ; Entry point for Taskman
 S ABMAPOK=1
 D @("^"_$P(^ABMDEXP(ABMP("EXP"),0),U,4))   ; do export routine
 W $$EN^ABMVDF("IOF")
 D ^%ZISC
 Q
 ;
XIT ;CLEAN UP AND QUIT
 K ABM,ABMP,POP,ZTSK,IO("Q"),ABMY,DIQ,ABMAPOK
 Q
 ;
QUE ;
 S ZTRTN="PRT^ABMDFPRT"
 S ZTDESC="3RD PARTY BILLING FORMS PRINTING"
 S ZTSAVE("ABM*")=""
 D ^%ZTLOAD
 W:$G(ZTSK) "Task # ",ZTSK," queued."
 Q
