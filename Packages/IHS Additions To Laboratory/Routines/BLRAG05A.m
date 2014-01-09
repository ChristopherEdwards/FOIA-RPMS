BLRAG05A ; IHS/MSC/SAT - SUPPORT FOR LABORATORY ACCESSION GUI RPCS ;
 ;;5.2;IHS LABORATORY;**1031**;NOV 01, 1997;Build 185
 ;
 ; Reference to File #3.5 supported by DBIA #2469
 ;
1 ;
 S U="^" Q:$D(LRLABLIO)
 ;
 N %ZIS,DIR,DIRUT,DTOUT,DUOUT,IOP,LRLABEL,POP,X,Y
 ;
 ; Setup handle for user's "HOME" device.
 D OPEN^%ZISUTL("LRHOME","HOME")
 ;
 S %ZIS("B")="LABLABEL"
 ;
 ; Check if label device assigned to this user's HOME Device file entry.
 I $G(IOS) D
 . S X=$$GET1^DIQ(3.5,IOS_",",101,"E")
 . I $L(X) S %ZIS("B")=X
 ;
 I %ZIS("B")="LABLABEL",$D(^LAB(69.9,1,3.5,+$G(DUZ(2)),0)) D
 . ; Get this division's default printer
 . S %ZIS("B")=$P($G(^LAB(69.9,1,3.5,+DUZ(2),0)),U,3)
 ;I %ZIS("B")="" S %ZIS("B")="LABLABEL"
 ;S %ZIS("A")="Print labels on: ",%ZIS="NQ"
 S IOP=%ZIS("B")
 ; Setup handle for user's LABEL device.
2 D OPEN^%ZISUTL("LRLABEL",IOP)
 ; I POP!(IO=IO(0)) D BD Q
 ;----- BEGIN IHS/OIT/MKK MOD LR*5.2*1022
 ;      If OR half of the above IF statement, (IO=IO(0)), is left in,
 ;      then it is impossible to test printer to the screen.
 I POP D BD Q
 ;----- END IHS/OIT/MKK MOD LR*5.2*1022
 S LRLABLIO=ION_";"_IOST_";"_IOM_";"_IOSL
 I $D(IO("Q")) S LRLABLIO("Q")=1
 I $E(IOST,1)'="P" D  G:Y'=1 2
 . N DIR,DIRUT,DTOUT,DUOUT
 . D USE^%ZISUTL("LRHOME")
 . ;S DIR(0)="YAO",DIR("A",1)="NOT printing on a printer.",DIR("A")="Are you sure?"
 . ;----- BEGIN IHS/OIT/MKK MOD LR*5.2*1022
 . S DIR(0)="YAO"
 . S DIR("A",1)="     NOT printing on a printer."
 . S DIR("A",2)=" "
 . S DIR("A")="     Is this correct? "
 . S DIR("B")="YES"
 . ;----- END IHS/OIT/MKK MOD LR*5.2*1022
 . D ^DIR
 ; Device on another cpu, can't test.
 I $D(IOCPU) D  Q
 . N MSG
 . S MSG="Device "_ION_" is on CPU '"_IOCPU_"' - Unable to test"
 . D USE^%ZISUTL("LRHOME")
 . D EN^DDIOL(MSG,"","!?5")
 . D K
 ;
3 I $D(LRLABLIO("Q")) D K Q
 D USE^%ZISUTL("LRHOME")
 /*
 W !
 K DIR,DIRUT,DTOUT,DUOUT,X,Y
 S DIR(0)="YAO",DIR("A")="Do you wish to test the label printer: ",DIR("B")="NO"
 S DIR("?")="Enter 'YES' if you want to test the printer, 'NO' if you do not."
 D ^DIR
 I $D(DIRUT) D BD Q
 */
 S Y=0
 I Y<1 G K ; Don't want to test; Note: this is not a kill, it is a GO to tag K (SAC catching these as a KILL)
 D OPEN^%ZISUTL("LRLABEL",LRLABLIO)
 I POP D  G 1
 . D USE^%ZISUTL("LRHOME")
 . D EN^DDIOL("Device in use - try later","","!")
 . K LRLABLIO
 N LRAA
 S LRAA=0
 D LBLTYP^LRLABLD
 ;
T ; Print test label
 D USE^%ZISUTL("LRHOME")
 K DIR,DIRUT,DTOUT,DUOUT,X,Y
 W !!,"Using label routine: ",LRLABEL,!
 S DIR(0)="E"
 S DIR("A",1)="Load and position label stock as appropriate for this printer."
 S DIR("A")="Press return when ready"
 D ^DIR
 I Y'=1 D BD Q
 ;
 N I,N,PNM,SSN
 N LRACC,LRBAR,LRBARID,LRCE,LRDAT,LRINFW,LRLLOC,LRPREF,LRAN,LRRB,LRTOP,LRTS,LRUID,LRURG,LRURG0,LRURGA,LRXL
 NEW DOB,SEX            ; IHS/OIT/MKK - LR*5.2*1027
 ;
 ; Set up variables for test label
 S PNM="TEST-LABEL-DO-NOT-USE",SSN="000-00-0000P",LRDAT="XX/XX/XX",LRLLOC="LAB",LRRB=1
 S LRACC="SITE-TEST-LABEL",LRCE="9999999",LRPREF="SMALL "
 S LRTOP="TEST-TUBE",LRTS(1)="Don't-use",LRTS(2)="this-label"
 S LRINFW="Patient-info-field",(LRBARID,LRUID)="0000000000",LRAN="000",I=1,N=1,LRXL=0
 S (LRURG,LRURG0)=1
 S LRURGA=$$URGA^LRLABLD(LRURG0)
 ; ----- BEGIN IHS/OIT/MKK MOD LR*5.2*1022
 S LRAA=0
 S LRAD=0
 S PROV="TEST,PROV"
 S DOB="XX/XX/XX"
 S SEX="X"
 ; ----- END IHS/OIT/MKK MOD LR*5.2*1022
 ;
 D LRBAR^LRLABLD
 D USE^%ZISUTL("LRLABEL"),@LRLABEL
 D USE^%ZISUTL("LRHOME")
 ;
 K DIR,DIRUT,DTOUT,DUOUT,X,Y
 W !
 S DIR(0)="YAO",DIR("A")="Label OK: ",DIR("B")="YES"
 S DIR("?")="Enter 'YES' if label printed correctly, 'NO' if it did not."
 D ^DIR
 I $D(DIRUT) G BD
 I Y=1 G K ;Note: this is not a kill, it is a GO to tag K (SAC catching these as a KILL)
 ;
 K DIR,DIRUT,DTOUT,DUOUT,X,Y
 /*
 W !
 S DIR(0)="YAO",DIR("A")="Test printer again: ",DIR("B")="YES"
 S DIR("?")="Enter 'YES' to test label printing, 'NO' to quit testing."
 D ^DIR
 I $D(DIRUT) G BD
 */
 S Y=0
 I Y=1 G T
 G K ;Note: this is not a kill, it is a GO to tag K (SAC catching these as a KILL)
 ;
BD ; Bad device - abort, timeout, unsuccessful selection
 K LRLABLIO
 D UNL69ERR^BLRAG05D
 D ERR^BLRAGUT("BLRAGP5A: Print error")
K ; Close devices
 D CLOSE^%ZISUTL("LRLABEL")
 D CLOSE^%ZISUTL("LRHOME")
 Q
 ;
BLRTSTL(BLRTSTL) ;collect all tests for each specimen
 ; .BLRTSTL   = (required) If all tests for a given specimen were not selected
 ;                         and passed in, BLRTSTL will be returned with all tests
 ;                         that are associated with the specimens represented in
 ;                         this input.
 ;                   The "TEST POINTERS" portion of this data comes
 ;                   element 39 in the return from BLR ALL NON-ACCESSIONED.
 ;                       List of test pointers with ICD9 pointers for each
 ;                       test/procedure being accessioned separated by ^.
 ;                       Each ^ piece is made up of these pipe pieces:
 ;                       TEST POINTERS | [ICD9_IEN:ICD9_IEN:...] ^ ...
 ;                        Test pointers = pointers to the LAB ORDER ENTRY
 ;                        file 69 - DATE:SPECIMEN:TEST
 ;                       ICD9_IEN - pointer to ICD DIAGNOSIS file 80 
 ;
 N BLRJ,BLRTN
 N BLRTSTA    ;BLRTSTA(<DATE>,<SPECIMEN>,<TEST>)=<ICD9-POINTERS>
 ;            ;BLRTSTA(<DATE>,<SPECIMEN>)=<ICD9-POINTERS>
 N LRODT,LRSN,LRTN
 S BLRTSTL=$G(BLRTSTL)
 K BLRTSTA
 ;put initial tests into the array
 F BLRJ=1:1:$L(BLRTSTL,U) D
 .S LRODT=$P($P($P(BLRTSTL,U,BLRJ),"|",1),":",1)
 .S LRSN=$P($P($P(BLRTSTL,U,BLRJ),"|",1),":",2)
 .S LRTN=$P($P($P(BLRTSTL,U,BLRJ),"|",1),":",3)
 .S BLRTSTA(LRODT,LRSN,LRTN)=$P($P(BLRTSTL,U,BLRJ),"|",2)
 .I $P($P(BLRTSTL,U,BLRJ),"|",2),$G(BLRTSTA(LRODT,LRSN))="" S BLRTSTA(LRODT,LRSN)=$P($P(BLRTSTL,U,BLRJ),"|",2)
 ;add missing tests to the array
 F BLRJ=1:1:$L(BLRTSTL,U) D
 .S LRODT=$P($P($P(BLRTSTL,U,BLRJ),"|",1),":",1)
 .S LRSN=$P($P($P(BLRTSTL,U,BLRJ),"|",1),":",2)
 .S LRTN=0 F  S LRTN=$O(^LRO(69,LRODT,1,LRSN,2,LRTN)) Q:LRTN<1  D
 ..Q:$D(BLRTSTA(LRODT,LRSN,LRTN))
 ..S BLRTSTA(LRODT,LRSN,LRTN)=$G(BLRTSTA(LRODT,LRSN))
 S BLRTSTL=""
 S LRODT=0
 F  S LRODT=$O(BLRTSTA(LRODT)) Q:LRODT'>0  D
 .S LRSN=0 F  S LRSN=$O(BLRTSTA(LRODT,LRSN)) Q:LRSN'>0  D
 ..S LRTN=0 F  S LRTN=$O(BLRTSTA(LRODT,LRSN,LRTN)) Q:LRTN'>0  D
 ...S BLRICD=BLRTSTA(LRODT,LRSN,LRTN)
 ...S:BLRICD="" BLRICD=$G(BLRTSTA(LRODT,LRSN))
 ...S BLRTSTL=BLRTSTL_$S(BLRTSTL'="":"^",1:"")_LRODT_":"_LRSN_":"_LRTN_"|"_BLRICD
 ;
 K BLRTSTA
 Q
