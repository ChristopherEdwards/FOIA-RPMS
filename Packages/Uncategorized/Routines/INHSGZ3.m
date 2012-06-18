INHSGZ3 ; FRW ; 30 Mar 94 10:57; HL7 utilities
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
COMP() ;Return HL7 component separator
 Q:$L($G(SUBDELIM)) SUBDELIM
 Q "\"
 ;
FIELD() ;Return HL7 field separator
 Q:$L($G(DELIM)) DELIM
 Q "^"
 ;
SUBCOMP() ;Subcomponent separator
 Q ""
 ;
REP() ;Repetition separator
 Q "|"
 ;
