BWPATCH8 ;IHS/CMI/LAB - BW PATCH 8 ;30-Jun-2003 22:42;PLS
 ;;2.0;WOMEN'S HEALTH;**8**;MAY 16, 1996
 ;
 ;
ENV ; Check for duplicate RACE file entries
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 S XPDENV=1,(XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 N RVAL,IEN,DUP
 S RVAL=0 F  S RVAL=$O(^DIC(10,"B",RVAL)) Q:RVAL=""  D
 .S IEN=$O(^DIC(10,"B",RVAL,0))
 .S:$O(^DIC(10,"B",RVAL,IEN))>0 DUP=1
 D:$G(DUP) MES("THERE ARE DUPLICATE RACE VALUES IN THE RACE FILE!",1)
 Q
 ;
PRE ;
 N DIK,DA
 S XPDENV=1,(XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ; Set Wise Woman Flag
 ; If flag =0 the fix in the post-init will not be run.
 S @XPDGREF@("WW")=$D(^BWPN(39,0))
 ; Purge entries in BW General Retrieval Items File
 D MES("Preparing BW GENERAL RETRIEVAL ITEMS File for new entries...")
 S DIK="^BWGRI("
 S DA=0 F  S DA=$O(^BWGRI(DA)) Q:'DA  D
 .D ^DIK
 D MES("Preparing BW RACE (NBCCEDP) for updates...")
 S DIK="^BWRACE("
 S DA=0 F  S DA=$O(^BWRACE(DA)) Q:'DA  D
 .D ^DIK
 Q
POST ; Converts (seeds) the new field CDC RESULTS OF PAP TEST (2001) (#.241) based on the existing
 ; field CDC RESULTS OF PAP TEST (1991) (#.24) (old field name CDC EQUIV SCREENING PAP DX) in
 ; file BW RESULTS/DIAGNOSIS (#9002086.31) to handle 2001 Bethesda System Categories.
 ;
 N FDA,BWDA,BWDIE,X,Y,TXT,BWRIEN
 D MES("Resolving Race File Pointers in BW RACE MAPPINGS (NBCCEDP) File.")
 K ^BWRACE("B")
 S BWRIEN=0
 F  S BWRIEN=$O(@XPDGREF@("RACEPTRS",BWRIEN)) Q:BWRIEN<1  D
 .S TXT=@XPDGREF@("RACEPTRS",BWRIEN)
 .D MES("Processing entry: "_BWRIEN_" =  "_TXT)
 .S $P(^BWRACE(BWRIEN,0),U)=$O(^DIC(10,"B",TXT,0))
 ; Re-index "B" x-ref of BW RACE MAPPINGS File
 S DIK="^BWRACE(",DIK(1)=".01^B" D ENALL^DIK
 ;
 S BWDA=0
 F  S BWDA=$O(^BWDIAG(BWDA)) Q:'BWDA  D
 . S X=+$P(^BWDIAG(BWDA,0),"^",24)
 . I X<1 Q
 . S Y=$S(X=2:1,X=3:2,X=4:3,X=7:8,X=14:7,1:X)
 . S FDA(1,9002086.31,BWDA_",",.241)=Y
 . D FILE^DIE("","FDA(1)","BWDIE(1)")
 . D CLEAN^DILF
 ;
 ; Set Bethesda 1991 (#.51) and 2001 (#.52) start dates in BW SITE file.
 ; Set MDE version to 4.1 if no value is defined.
 S BWDA=0
 F  S BWDA=$O(^BWSITE(BWDA)) Q:'BWDA  D
 . S X=$P(^BWSITE(BWDA,0),"^",17)
 . I X<1 S X=2910101
 . S FDA(2,9002086.02,BWDA_",",.51)=X
 . S FDA(2,9002086.02,BWDA_",",.52)=3021001
 . S:'$$GET1^DIQ(9002086.02,BWDA,.18,"I") FDA(2,9002086.02,BWDA_",",.18)=41
 . D FILE^DIE("","FDA(2)","BWDIE(2)")
 . D CLEAN^DILF
 ; Importing Race into BW Patient File
 D MES("Importing Patient Race...")
 D START^BWUCVRC
 ; Add procedure type to existing Wise Woman Procedures if needed
 Q:'@XPDGREF@("WW")  ;Site has not WW Procedures to correct
 D MES("Repairing Wise Woman procedures...")
 S BWDA=0
 F  S BWDA=$O(^BWPCD(BWDA)) Q:'BWDA  D
 .Q:'$D(^BWPCD(BWDA,4))  ; Not a Wise Woman procedure
 .W "."
 .I '$P(^BWPCD(BWDA,0),U,4) D
 ..W ":"
 ..S $P(^BWPCD(BWDA,0),U,4)=39
 Q
 ; Display message in MSG and optionally set quit flag to QUIT
MES(MSG,QUIT) ;
 D BMES^XPDUTL("  "_$G(MSG))
 S:$G(QUIT) XPDQUIT=QUIT
 Q
 ; Pre-Transport global for BW RACE file mappings
PRETRAN ;
 N IEN,VAL,TXT
 S IEN=0
 F  S IEN=$O(^BWRACE(IEN)) Q:IEN<1  D
 .S VAL=$P(^BWRACE(IEN,0),U),TXT=$$GET1^DIQ(10,VAL,.01,"E")
 .S @XPDGREF@("RACEPTRS",IEN)=TXT
 Q
