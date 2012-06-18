AICDTIL ; IHS/OHPRD/ACC - MENU DRIVER FOR ICD MANAGEMENT UTILITIES ;
 ;;3.51;IHS ICD/CPT lookup & grouper;;MAY 30, 1991
 ;
 D ^AUKVAR ; FOR NON-KERNEL ENVIRONMENTS ONLY
MAINLP W !!,?10,"- - PCIS Development Utilities - -",!!
 F I=1:1 S L=$T(MENU+I) Q:L=""  S L=$P(L,";;",2),L=$P(L,"^",1) W $J(I,2),". ",L,!
 W !
 S N=I-1
ASK W "Select 1-",N,": " R A:$S($D(DTIME):DTIME,1:300),!
 I A'=""&(A'?1N.N!((A<1)!(A>N))) G ASK
 I A'="" S R=$P($T(MENU+A),"^",2,99) D @R G MAINLP
 K I,L,N,R,A
 W !,"B y e . . .",!
 Q
 ;
MENU ; MENU TEXT IN FORM:  TEXT^ROUTINE
 ;;Test ICD9 Diagnosis code lookup^D^AICDTICD
 ;;Test ICD9 Procedure code lookup^P^AICDTICD
 ;;Add to OTHER KEYWORDS field of ICD9 diagnosis file^DX^AICDADK
 ;;Add to OTHER KEYWORDS field of ICD9 procedure file^OP^AICDADK
 ;;Print ICD Diagnosis file in code order^EN^AICDPRTD
 ;;Print ICD Procedure file in code order^EN^AICDPRTO
