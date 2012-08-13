INHSZ0 ;JSH; 29 Jan 92 09:47;Interface Script compiler (cont'd)
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
L G L^INHSZ1
 ;
GETLINE ;Returns next line of code in array LINE
 K LINE N I
 S CALL(CALL,0)=$O(^INRHS(CALL(CALL),1,CALL(CALL,0))) Q:'CALL(CALL,0)
 S LINE=^INRHS(CALL(CALL),1,CALL(CALL,0),0) I LINE["|CR|" S LINE=$$LBTB^UTIL($P(LINE,"|CR|")) Q
 S I=0
G1 S CALL(CALL,0)=$O(^INRHS(CALL(CALL),1,CALL(CALL,0))) G:'CALL(CALL,0) GQ S I=I+1,LINE(I)=^(CALL(CALL,0),0) G GQ:LINE(I)["|CR|",G1
GQ S:I LINE(I)=$P(LINE(I),"|CR|")
 S LINE=$$LB^UTIL(LINE) Q
 ;
QCHK ;Add code to check for errors and quit
 S A=" I $G(INSTERR) Q $S($G(INREQERR)>INSTERR:INREQERR,1:INSTERR)" D L
 Q
 ;
SYNTAX(%L,%P) ;Check syntax of a line using pattern match
 ;%L = string to check    %P = pattern match
 I $G(%P)="" Q 1
 I %L?@%P Q 1
 D ERROR("Statement syntax error.",1) Q 0
 ;
ERROR(%M,%L) ;Report an error
 ;%M = message   %L = print line (1=yes, 0=no)
 N I
 S ER=1
 W *7,!!,"ERROR: ",%M Q:'$G(%L)
EDISP W !,LINE I $D(LINE)>9 F I=1:1 Q:'$D(LINE(I))  W LINE(I)
 Q
 ;
WARN(%M,%L) ;Report a warning
 ;%M = message    %L = print line (0=no, 1=yes)
 W *7,!!,"WARNING: ",%M
 S WARN=$G(WARN)+1 G:$G(%L) EDISP
 Q
 ;
