INHI ;FRW ; 8 Jan 96 10:38; Edit WP fields using CR
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
EDSCR(INDA) ;Edit script
 ;INDA - IEN
 K ^DIJU($J,"DWW")
 W @IOF
 W "SCRIPT: ",$P($G(^INRHS(INDA,0)),U,1),!,"SCRIPT TEXT:",!
 D ^DWWA("^INRHS(INDA,1)",0,2,80,20,10,1)
REED D ^DWWA("^INRHS(INDA,1)",0,2,80,20,1,1)
 S %=$$YN^UTSRD("OK to file? ;1") I '% K ^DIJU($J,"DWW") D CLEAR^DW Q
 ;IF NOT OK THEN 
 ;   ASK IF WANT TO CONTINUE EDITTING
 ;   IF WANT TO CONTINUE EDITTING THEN
 ;       GOTO REED
 ;   IF NOT WANT TO EDIT THEN
 ;       QUIT
 K ^INRHS(INDA,1)
 D WP^DWEF
 K ^DIJU($J,"DWW")
 D CLEAR^DW
 Q
 ;
EDMES(INDA) ;Edit message text
 K ^DIJU($J,"DWW")
 W @IOF
 W !,"Message Text:",!
 D ^DWWA("^INTHU(INDA,3)",0,2,80,20,10,1)
REEDM D ^DWWA("^INTHU(INDA,3)",0,2,80,20,1,1)
 S %=$$YN^UTSRD("OK to file? ;1") I '% K ^DIJU($J,"DWW"),DWFILE D CLEAR^DW Q
 ;IF NOT OK THEN 
 ;   ASK IF WANT TO CONTINUE EDITTING
 ;   IF WANT TO CONTINUE EDITTING THEN
 ;       GOTO REED
 ;   IF NOT WANT TO EDIT THEN
 ;       QUIT
 K ^INTHU(INDA,3)
 D WP^DWEF
 K ^DIJU($J,"DWW")
 D CLEAR^DW
 S DWFILE=1
 Q
 ;