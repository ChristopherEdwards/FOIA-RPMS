%ZTFE ;SLT; 10 Dec 97 12:26; MSM/Windows NT version of %ZTFE - error handler utility
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;CHCS TLS_4603; GEN 1; 21-MAY-1999
 ;COPYRIGHT 1997 SAIC
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
 ;      C: INRPT - system interupt
 ;      A: PGMOV - memory allocation error
 ;      N: NOSYS - non-existent system through DDP
 ;      D: DSTDB - network link failure during DDP data transfer
 ;      O: NOPEN - attempt to use an unopened device
 ;      V: NODEV - open undefined device
 ;output:
 ;  1: error found
 ;  0: error not found
 I IPS["C",$ZE["INRPT" Q 1
 I IPS["A",$ZE["PGMOV" Q 1
 I IPS["N",$ZE["NOSYS" Q 1
 I IPS["D",$ZE["DSTDB" Q 1
 I IPS["O",$ZE["NOPEN" Q 1
 I IPS["V",$ZE["NODEV" Q 1
 Q 0
 ;
