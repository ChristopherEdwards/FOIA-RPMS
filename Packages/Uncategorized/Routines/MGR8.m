MGR8 ;DEMO STUFF [ 08/07/2001  11:45 AM ]
 ;
START ; ROUTINE ENTRY POINT
 ;
 S X=2,Y=3
 S Z=X+Y
 W "Ahead groove factor five!",!
 W ?5,X,?10,Y,?15,Z,!
END ; CLEAN UP VARIABLES
 K X,Y,Z  Q
