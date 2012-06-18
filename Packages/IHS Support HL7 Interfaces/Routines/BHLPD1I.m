BHLPD1I ; cmi/sitka/maw - BHL Process Inbound PD1 Segment ;
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;this routine will file data from the inbound PD1 segment
 ;
PROCESS ;-- this is the processing event
 S BHLDA=0 F  S BHLDA=$O(@BHLTMP@(BHLDA)) Q:BHLDA=""  D
 . S BHLP=$G(@BHLTMP@(BHLDA,4))
 . S BHLPN=$P(BHLP,"~",2)
 . S DIC=200,DIC(0)="MXZ",X=BHLPN D ^DIC
 . I Y<0 S BHLPN=""
 . S BHLFL=9000001,BHLFLD=.14,BHLVAL=BHLPN,BHLX=BHLPAT X BHLDIE
 Q
 ;
