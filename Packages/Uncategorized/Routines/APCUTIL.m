APCUTIL ; MENU DRIVER FOR PCIS DEVELOPMENT UTILITIES ; [ 07/29/86  5:12 PM ]
MAINLP W !!,?10,"- - PCIS Development Utilities - -",!!
 F I=1:1 S L=$T(MENU+I) Q:L=""  S L=$P(L,";;",2),L=$P(L,"^",1) W $J(I,2),". ",L,!
 W !
 S NL=I-1
ASK W "Select 1-",NL,": " R A,!
 I A'=""&(A'?1N.N!((A<1)!(A>NL))) G ASK
 I A'="" S R=$P($T(MENU+A),"^",2,99) D @R G MAINLP
 K I,L,NL,R,A
 W !,"B y e . . .",!
 Q
 ;
MENU ; MENU TEXT IN FORM:  TEXT^ROUTINE
 ;;Test ICD9 Diagnosis code lookup^D^APCUTICD
 ;;Test ICD9 Procedure code lookup^P^APCUTICD
 ;;Add to OTHER KEYWORDS field of ICD9 diagnosis file^DX^APCUADDK
 ;;Add to OTHER KEYWORDS field of ICD9 procedure file^OP^APCUADDK
 ;;Find ICD Diagnosis codes with selected OTHER KEYWORD^^APCUOKCK
