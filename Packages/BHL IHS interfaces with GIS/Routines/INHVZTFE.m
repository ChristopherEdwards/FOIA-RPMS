%ZTFE ;SLT; 6 Oct 94 15:13;%ZTFE for DSM - error handler utility
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;All implementation-specific code must be flagged with ';***'.
 ;This version is for VAX DSM.
 N %,N,R,L,T
 W !,"Available functions in library ^"_$T(+0)
 S N=0 F %=2:1 S R=$T(+%) Q:R=""  D
 .S L=$P(R," "),T=$E(R,$F(R," "),999)
 .I L]"",$E(T)=";" W !!,$P(L,"("),?10,"(",$P(L,"(",2,99) S N=1
 .I N,$E(T)=";" W !?5,T Q
 .S N=0
 Q
 ;the end
ETYPE(IPS) ;check certain error conditions
 ;input:
 ;  IPS --> (req,pbv) input parameter string
 ;    valid codes:
 ;      C: CTRAP
 ;      A: ALLOC
 ;      N: NOSYS
 ;      D: DSTDB
 ;      O: DSM-E-READERR or DSM-E-DEVALLOC
 ;      V:
 ;output:
 ;  1: error found
 ;  0: error not found
 I IPS["C",$ZE["CTRAP" Q 1  ; cks for CTRAP & CTRAPERR in DSM 6.3
 I IPS["A",$ZE["ALLOC" Q 1
 I IPS["N",$ZE["NOSYS" Q 1  ; NOSYS err may not exist in DSM 6.3
 I IPS["D",$ZE["DSTDB" Q 1  ; DSTDB err may not exist in DSM 6.3
 I IPS["O",(($ZE["DSM-E-READERR")!($ZE["DSM-E-DEVALLOC")) Q 1
 ;I IPS["V" Q 1
 Q 0
 ;
