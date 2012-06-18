BHLIN2I ; cmi/sitka/maw - BHL File Inbound IN2 Segment ;
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;this routine will file the inbound IN2 segment.  It is called from
 ;BHLIN1I
 ;
 Q
 ;
FILE ;-- file the IN2 segment
 N BHLR
 S BHLR="IN2"
 D @BHLIT
 Q
 ;
MCD ;-- file medicaid info
 Q:'$G(BHLMCDE)
 S BHLMCN=$G(@BHLTMP@(BHLDA,8))
 S BHLFL=9000004,BHLFLD=.13,BHLX=BHLMCDE,BHLVAL=BHLMCN X BHLDIE
 Q
 ;
MCR ;-- file medicare info
 ;there is none at this time
 Q
 ;
PI ;-- file private insurance info   
 Q:'$G(BHLPH)
 S BHLEMP=$G(@BHLTMP@(BHLDA,3))
 S BHLFL=9000003.1,BHLFLD=.16,BHLX=BHLPH,BHLVAL=BHLEMP X BHLDIE
 Q
 ;
