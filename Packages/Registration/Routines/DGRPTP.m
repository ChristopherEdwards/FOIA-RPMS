DGRPTP ;ALB/RMO - Print 10-10T Registration;06 JAN 1997 2:56 pm
 ;;5.3;Registration;**108**;08/13/93
 ;
QUE(DFN,DFN1,DGIO) ;Queue 10-10T print
 ; Input  -- DFN      Patient IEN
 ;           DFN1     Disposition multiple IEN  (optional)
 ;           DGIO     Registration printer array
 ; Output -- None
 N %,ZTDESC,ZTIO,ZTRTN,ZTSAVE,ZTSK
 S ZTDESC="PRINT 10-10T"_$S($G(DFN1):" - FROM REGISTRATION",1:"")
 S ZTRTN="EN^DGRPTP"
 S ZTSAVE("DFN")=DFN
 S:$G(DFN1)'="" ZTSAVE("DFN1")=DFN1
 S ZTIO=DGIO(10)
 D NOW^%DTC S ZTDTH=%
 D ^%ZTLOAD
 W:$D(ZTSK) "   (Task: ",ZTSK,")"
 Q
 ;
ENDEV(DFN,DFN1) ;Entry point to ask device before printing 10-10T
 ; Input  -- DFN      Patient IEN
 ;           DFN1     Disposition multiple IEN  (optional)
 ; Output -- None
 S DGPGM="EN^DGRPTP"
 S DGVAR="DFN"_$S($G(DFN1)'="":"^DFN1",1:"")
 W !!?5,*7,"This output requires 132 column output to a PRINTER."
 W !?5,"Output to SCREEN will be unreadable."
 D ZIS^DGUTQ G Q:POP
 ;
EN ;Entry point to print a 10-10T
 ; Input  -- DFN      Patient IEN
 ;           DFN1     Disposition multiple IEN  (optional)
 ;           DGOPT    Registration variable     (optional)
 ; Output -- None
 N DGLNE,DGNAM,DGPGE,DGSSN
 U IO
 D SETUP(DFN,.DGNAM,.DGSSN,.DGLNE,.DGPGE)
 I $$FIRST^DGUTL G Q  ;first heading of report utility
 D EN^DGRPTP1(DFN,$G(DFN1),DGNAM,DGSSN,.DGLNE,DGPGE)
Q D ENDREP^DGUTL ;end report utility
 I '$D(DGOPT) D CLOSE^DGUTQ ;close device
 Q
 ;
SETUP(DFN,DGNAM,DGSSN,DGLNE,DGPGE) ;Set-up print variables
 ; Input  -- DFN      Patient IEN
 ; Output -- DGNAM    Patient name
 ;           DGSSN    Patient ssn
 ;           DGLNE    Line format array
 ;           DGPGE    Page number
 N X
 S DGLNE("ULC")=$S('($D(IOST)#2):"-",IOST["C-":"-",1:"_")
 S DGLNE("D")="",DGLNE("DD")="",DGLNE("UL")=""
 S $P(DGLNE("D"),"-",131)="",$P(DGLNE("DD"),"=",131)="",$P(DGLNE("UL"),DGLNE("ULC"),131)=""
 S DGNAM=$P($G(^DPT(DFN,0)),U,1),X=$P($G(^(0)),U,9)
 S DGSSN=$S(X'="":$E(X,1,3)_"-"_$E(X,4,5)_"-"_$E(X,6,10),1:"")
 S DGPGE=0
 Q
 ;
HD(DGNAM,DGSSN,DGLNE) ;Print header
 ; Input  -- DGNAM    Patient name
 ;           DGSSN    Patient ssn
 ;           DGLNE    Line format array
 ; Output -- None
 W @IOF,!,DGNAM,?116,DGSSN,!,DGLNE("DD")
 Q
 ;
FT(DFN,DFN1,DGLNE,DGPGE) ;Print footer
 ; Input  -- DFN      Patient IEN
 ;           DFN1     Disposition multiple IEN  (optional)
 ;           DGLNE    Line format array
 ;           DGPGE    Page number
 ; Output -- None
 N DGCLK,DGDIS,Y,%
 W !,DGLNE("DD")
 S DGDIS(0)=$G(^DPT(DFN,"DIS",+$G(DFN1),0))
 S Y=$P(DGDIS(0),U,1) X ^DD("DD") W !,"Reg Date/Time: ",Y
 D NOW^%DTC S Y=% X ^DD("DD") W ?52,"PRINTED: ",Y
 S DGCLK=$P(DGDIS(0),U,5)
 W ?98,"Clerk: ",$S($P($G(^VA(200,+DGCLK,0)),U,2)'="":$P(^(0),U,2)_"/"_DGCLK,DGCLK:"unk/"_DGCLK,1:"")
 W !!!!,"AUTOMATED VA FORM 10-10T",?120,"PAGE: ",DGPGE
 Q
