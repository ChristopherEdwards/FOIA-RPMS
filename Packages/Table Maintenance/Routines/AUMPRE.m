AUMPRE ;IHS/OIT/NKD - AUM v 10.3 pre-init 11/29/2011 ;
 ;;12.0;TABLE MAINTENACE;**1**;SEP 27,2011;Build 1
 ;
 ; This is the pre-init for AUM 10.1. It strips all control chars
 ; out of multiple globals prior to the install of the patch.
 ;
 ; 2008 04 18-20 Rick Marshall created routines to
 ; clear out control characters found in the ^AICD globals in both
 ; values and subscripts. Chris Saddler addapted the routines to
 ; other files listed below
 ;
 QUIT  ; This routine should not be called at the top or anywhere
 ; else. It is only to be called at START by KIDS as the pre-init
 ; for AUM patches.
 ;
CLEANALL ; PRE-INIT: Remove Control Characters from globals
 ;
 D CLEANALL^AUMPREDC    ;DIC
 D CLEANALL^AUMPRECN    ;COUNTY
 D CLEANALL^AUMPREA     ;AREA
 D CLEANALL^AUMPRESU    ;SU
 D CLEANALL^AUMPRECM    ;COMMUNITY
 D CLEANALL^AUMPREST
 ;
 QUIT  ; end of CLEANALL
 ;
START ;EP
 D CLEANALL
 ;
CLR ;clear out old codes from AUM DATA created by earlier patches
 S I=0
CLR2 ;I already set
 F  S I=$O(^AUMDATA(I)) Q:'I  D
 .K ^AUMDATA(I)
 F I=3,4 D
 .S $P(^AUMDATA(0),"^",I)=0
 Q
