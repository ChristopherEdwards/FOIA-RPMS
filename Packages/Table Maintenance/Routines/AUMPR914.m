AUMPR914 ;IHS/OIT/FCJ - AUM v 9.1 patch 4 pre-init ;
 ;;9.1;TABLE MAINTENANCE;**4**;SEP 17,2008
 ;
 ;This is the pre-init for AUM*9.1*4
 ;This routine should only be called at START by KIDS as the pre-init
 ; for AUM*9.1*4.
 ;
 Q
 ;
START ;EP
 ;D CLEANALL
 D REINDX
 ;
CLR ;clear out old codes from AUM DATA created by earlier patches
 S I=0
CLR2 ;I already set
 F  S I=$O(^AUMDATA(I)) Q:'I  D
 .K ^AUMDATA(I)
 F I=3,4 D
 .S $P(^AUMDATA(0),"^",I)=0
 Q
 ;
REINDX ;Reindex files used to match entries
 S DIK(1)=".08^C",DIK="^AUTTCOM(" D ENALL^DIK    ;Reindex the STCTYCOM-Community file
 K DIK
 S DIK(1)=".04^C",DIK="^AUTTCTY(" D ENALL^DIK    ;Reindex the STCTY-County
 K DIK
 S DIK(1)=".04^C",DIK="^AUTTSU(" D ENALL^DIK     ;reindex the ASU-Service Unit
 K DIK
 S DIK(1)=".12^C",DIK="^AUTTLOC(" D ENALL^DIK   ;reindex the ASUFAC code-Location file
 K DIK
 Q
 ;
CLEANALL ; PRE-INIT: Remove Control Characters from globals
 D CLEANALL^AUMPREDC        ;DIC
 D CLEANALL^AUMPRECN        ;COUNTY
 D CLEANALL^AUMPREA         ;AREA
 D CLEANALL^AUMPRESU        ;SU
 D CLEANALL^AUMPRECM        ;COMMUNITY
 Q
