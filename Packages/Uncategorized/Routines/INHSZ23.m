INHSZ23 ;DGH; 9 Apr 99 13:14;NCPDP compiler functions ; 11 Nov 91   6:42 AM
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 4; 4-SEP-1997
 ;COPYRIGHT 1988, 1989, 1990 SAIC
 ;
 ;This routine is to hold specialized logic used only for
 ;compiling NCPDP messages. Currently only has one function.
L G L^INHSZ1
 ;
 ;
LINENC ;For NCPDP, a LINE(NC) script command will preceed the
 ;regular LINE command. The format of this is
 ;LINE NCID FIELD NO=<value>,<value>,etc
 ;This tag sets variables INIDF and INIDV that are used in the
 ;"real" LINE command. Both variables are required for NCPDP
 N %1,%2
 S %1=$$LBTB^UTIL($P(LINE," ",3))
 S INIDF=$P(%1,"="),INIDV=$P(%1,"=",2)
 I 'INIDF D ERROR^INHSZ0("ID FIELD is required for NCPDP.",1) Q
 I '$L(INIDV) D ERROR^INHSZ0("ID FIELD is specified, but ID VALUES have not.",1) Q
 Q
 ;
 ;
