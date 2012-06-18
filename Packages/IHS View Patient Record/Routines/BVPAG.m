BVPAG ; IHS/ITSC/LJF - VIEW/EDIT PATIENT REGISTRATION ;
 ;;1.0;VIEW PATIENT RECORD;;NOV 17, 2004
 ; Called by protocol BVP DEMOGRAPHICS (Demographics)
 ;DFN already set by BVPMAIN
 ;
 D FULL^VALM1
 I '$D(^XUSEC("AGZMENU",DUZ)) D CHKRHI^AG,^BVPAGV,KILL^AG Q      ;user has access to view only
 ;
 NEW DIR,Y S DIR(0)="NO^1:2",DIR("B")=1,DIR("A")="Select One"
 S DIR("A",1)=""
 S DIR("A",2)="  1. VIEW Registration Data"
 S DIR("A",3)="  2. UPDATE Registration Data"
 D ^DIR K DIR Q:Y<1  I Y=2 D  Q
 . D CLEAR^VALM1,PATNLK^AGEDIT,KILL^AG Q
 ;
 D CHKRHI^AG
 D ^BVPAGV,KILL^AG
 Q
 ;
