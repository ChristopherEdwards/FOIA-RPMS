ACHSTV ; IHS/ITSC/PMF - test version of routines  [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
        ;;3.1T1;ACHS;;JAN 19, 2001 
 ;
 ; this routine allows the user to turn test versions off
 ;and on.  The routine must first already be defined in
 ;               ^ACHS("TEST VERSION").    Example
 ;
 ;     ^ACHS("TEST VERSION",4)="ACHSFOO^ACHSFOOX^0"
 ;
 ;If it is defined there, the user can set or clear the flag
 ;that says "YES, USE THE TEST VERSION"
 ;
 ;
 N DIR
 ;
 ;first ask which routine
 S DIR(0)="FO^3:32^I '$D(^ACHS(""TEST VERSION"",""B"",X)) K X"
 S DIR("A")="Enter the routine name for testing "
 S DIR("?")="Enter ?? for a list of valid testing routines"
 S DIR("??")="^D LIST^ACHSTV"
 W !! D ^DIR
 I Y=""!(Y["^") Q
 ;
 S ACHSNUM=$O(^ACHS("TEST VERSION","B",Y,""))
 I ACHSNUM="" W !!,"Entry not found.  Please report this to the Support Team" Q
 ;
 S ACHSON=$P($G(^ACHS("TEST VERSION",ACHSNUM,1)),U,3)
 S DIR(0)="SOMB^Y:Yes;N:No"
 I ACHSON S DIR("A")="Test version in use. "
 I 'ACHSON S DIR("A")="Test version NOT in use. "
 S DIR("A")=DIR("A")_"Change? "
 W !! D ^DIR
 ;
 I Y=""!(Y="N") W !!,"No action taken   ",!! D RTRN^ACHS Q
 S $P(^ACHS("TEST VERSION",ACHSNUM,1),U,3)='ACHSON
 W !!,"Change made   ",!! D RTRN^ACHS
 Q
LIST ;
 W !!,"These routines are presently on the test list",!
 S ACHSA="" F  S ACHSA=$O(^ACHS("TEST VERSION","B",ACHSA)) Q:ACHSA=""  W !,?5,ACHSA
 W !
 Q
