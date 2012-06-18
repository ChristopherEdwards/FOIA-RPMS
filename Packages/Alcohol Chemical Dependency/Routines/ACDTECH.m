ACDTECH ;IHS/ADC/EDE/KML - TECHNICAL DOCUMENTATION;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
1 ; The following routines kill the specified scratch and temp
 ; globals:
 ;
 ; DIR+14^ACDPIMP kills ^ACDPTMP
 ; RDX+7^ACDPIMP1 kills ^ACDP1TMP
 ; K+1^ACDPIMP1 kills ^ACDPTMP
 ; EXTR+2^ACDPOST kills ^ACDGTMP, ^ACDVTMP, ^ACDPTMP, ^ACDG1TMP
 ;                      ^ACDV1TMP, ^ACDP1TMP
 ; K+2^ACDPOST2 kills ^ACDGTMP4, ^ACDGTMP5
 ; EN+10^ACDPSAVE kills ^ACDPTMP
 ; EN+36^ACDPSAVE kills ^ACDPTMP
 ; K+2^ACDPSRV0 kills ^ACDPMESS
 ; RDX+7^ACDPSRV2 kills ^ACDP1TMP
 ; V+17^ACDTX5 kills ^ACDGTMP
 ; DIR+14^ACDVIMP kills ^ACDV1TMP
 ; EN+15^ACDVIMP1 kills ^ACDV1TMP
 ; EN+10^ACDVSAVE kills ^ACDVTMP
 ; VIS+15^ACDVSAVE kills ^ACDVTMP
 ; K+2^ACDVSRV0 kills ^ACDVMESS
 ; EN+10^ACDVSRV2 kills ^ACDV1TMP
 ;
2 ; The following routine kills the specified file globals as part
 ; of a post initialization routine.  These globals must be restored
 ; from the host file acd_0400.g
 ;
 ; CLN+4^ACDPOST kills ^ACDDRUG, ^ACDCOMP, ^ACDSERV, ^ACDPROB,
 ;                     ^ACDLOT, ^ACDPREV, ^ACDCASH, ^ACDCCT, ^ACDJBDT,
 ;                     ^ACDPLEX, ^ACDSTFC
