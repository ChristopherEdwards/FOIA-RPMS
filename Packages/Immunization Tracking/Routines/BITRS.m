BITRS ;IHS/CMI/MWR - TRANSFORM X INTO REQD CASE; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  UTILITY: TRANSFORMS X INTO MIXED CASE OR UPPERCASE.
 ;
 ;
 ;----------
T(X) ;EP
 ;---> Translate word to mixed case.
 ;
 Q:"^ "[$G(X) X
 N BIWORD,I
 ;
 ;---> Remove leading inappropriate characters if present.
 F  Q:$E(X)'?1P  S X=$E(X,2,99)
 ;
 ;---> Change first letter to uppercase.
 S BIWORD=$E(X)
 I BIWORD?1L S BIWORD=$C($A($E(BIWORD))-32)
 ;
 ;---> Do following characters.
 F I=2:1:$L(X) D CHAR
 ;
 ;
 ;---> Remove trailing space or quote.
 ;F  Q:""" "'[$E(BIWORD,$L(BIWORD)) S BIWORD=$E(BIWORD,1,($L(BIWORD)-1))
 ;---> CodeChange for v7.1 - IHS/CMI/MWR 12/01/2000:
 ;---> Next line, handle word with leading space.
 F  Q:(""" "'[$E(BIWORD,$L(BIWORD)))!($L(BIWORD)=0)  D
 .S BIWORD=$E(BIWORD,1,($L(BIWORD)-1))
 ;
 ;
 Q BIWORD
 ;
 ;
 ;----------
CHAR ;EP
 ;---> If this character is uppercase and previous character is
 ;---> not punctuation (except for an apostrophy) or a space,
 ;---> then change character to lowercase.
 ;
 I ($E(X,I)?1U)&(($E(X,I-1)'?1P)!($E(X,I-1)="'")) D  Q
 .S BIWORD=BIWORD_$C($A($E(X,I))+32)
 ;
 ;
 ;---> If this character is lowercase and previous character is
 ;---> punctuation (but not an apostrophy) or a space, then change
 ;---> character to uppercase.
 ;
 I $E(X,I)?1L,$E(X,I-1)?1P,$E(X,I-1)'="'" D  Q
 .S BIWORD=BIWORD_$C($A($E(X,I))-32) Q
 ;
 ;
 ;---> Add character to BIWORD string without modification.
 ;---> "\" placed before a letter forces it to be uppercase;
 ;---> HERE REMOVE ANY "\"'s.
 I $E(X,I)'="\" S BIWORD=BIWORD_$E(X,I)
 Q
 ;
 ;
 ;----------
UP(X) ;EP
 ;---> Translate any lowercase letters to uppercase.
 ;---> Leave all other characters untouched.
 ;
 Q:"^ "[$G(X) X
 N BICHAR,BIWORD,I S BIWORD=""
 ;
 F I=1:1:$L(X) D  S BIWORD=BIWORD_BICHAR
 .S BICHAR=$E(X,I)
 .Q:(($A(BICHAR)<97)!($A(BICHAR)>122))
 .S BICHAR=$C($A(BICHAR)-32)
 ;
 Q BIWORD
 ;
 ;
 ;----------
LOW(X) ;EP
 ;---> Translate any uppercase letters to lowercase.
 ;---> Leave all other characters untouched.
 ;
 Q:"^ "[$G(X) X
 N BICHAR,BIWORD,I S BIWORD=""
 ;
 F I=1:1:$L(X) D  S BIWORD=BIWORD_BICHAR
 .S BICHAR=$E(X,I)
 .Q:(($A(BICHAR)<65)!($A(BICHAR)>90))
 .S BICHAR=$C($A(BICHAR)+32)
 ;
 Q BIWORD
