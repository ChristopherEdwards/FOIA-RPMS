BWDIAGS ;IHS/ANMC/MWR - RES/DIAG SYNONYM ADD/EDIT/PRINT;15-Feb-2003 21:50;PLS
 ;;2.0;WOMEN'S HEALTH;**8**;MAY 16, 1996
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  ADD/EDIT/PRINT/PURGE SYNONYMS FOR BW RESULTS/DIAGNOSIS FILE.
 ;;
 ;
EDITSYN ;EP
 ;---> EDIT SYNONYMS FOR RESULTS/DIAGNOSIS.
 ;---> CALLED BY OPTION "BW EDIT RES/DIAG SYNONYMS".
 D SETVARS^BWUTL5
 F  D  Q:$G(Y)<0
 .D TITLE^BWUTL5("EDIT SYNONYMS FOR RESULTS/DIAGNOSIS FILE")
 .D TEXT1
 .D DIC^BWFMAN(9002086.31,"QEMA",.Y,"   Select RESULT/DIAGNOSIS: ")
 .Q:Y<0
 .D DIE^BWFMAN(9002086.31,".3;.31",+Y,1,.BWPOP)
 .S:BWPOP Y=-1
 W @IOF
 D KILLALL^BWUTL8
 Q
 ;
PRINTSYN ;EP
 ;---> CALLED BY OPTION "BW PRINT RES/DIAG SYNONYMS".
 D SETVARS^BWUTL5
 S DIC="^BWDIAG("
 S FLDS="[BW PRINT RES/DIAG SYNONYMS]"
 S BY=.01,(FR,TO)=""
 D EN1^DIP
 D KILLALL^BWUTL8
 Q
 ;
 ;
TEXT1 ;EP
 ;;You may enter a synonym for each Result/Diagnosis.  The synonym will
 ;;allow the Result/Diagnosis to be called up by typing only a few
 ;;characters.  Synonyms should be unique and less than 6 characters.
 ;;
 ;;For example, "C1" might be used for CIN I/mild dysplasia; "C2" for
 ;;CIN II/moderate dysplasia; "C3" for CIN III/severe dysplasia,
 ;;and so on.
 ;;
 ;;
 S BWTAB=5,BWLINL="TEXT1" D PRINTX
 Q
 ;
PRINTX ;EP
 N I,T,X S T="" F I=1:1:BWTAB S T=T_" "
 F I=1:1 S X=$T(@BWLINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
