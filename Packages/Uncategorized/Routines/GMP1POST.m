GMP1POST ;ISC-SLC/MJC;Post init for GMP*2*3 ;;9-1-95 4:23pm
 ;;2.0;Problem List;**3**;Aug 25, 1994
 ;
 H 2 D ^GMP1ONIT H 2
 W !,".....Installing LIST TEMPLATES",! D ^GMP1L H 1
 W !!,"Setting parameter to check for duplicate entries..."
 W !!,"If you do not want the duplicate entry check please use the"
 W !,"[GMPL SITE PARAMETER EDIT] option to disable this check."
 S $P(^GMPL(125.99,1,0),U,6)=1
 W !!,"All done."
 Q
