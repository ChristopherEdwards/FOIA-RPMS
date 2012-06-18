BDGP1005 ;IHS/OIT/LJF - PRE & POST INSTALL, ENVIRON CHECK FOR PATCH 1005
 ;;5.3;PIMS;**1005**;MAY 28, 2004
 ;
CKENV ; environment check code
 ;Prevents "Disable Options..." and "Move Routines..." questions
 S XPDDIQ("XPZ1")=0,XPPDIQ("XPZ2")=0
 ;
 ; now check for patch 1004
 NEW PATCH S PATCH="PIMS*5.3*1004"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 ;
 ; check for test version of patch 1004
 I $$TEST(PATCH) D  Q
 . W !,"You have a TEST version of "_PATCH_" installed.  Please install the released patch. . ."
 . S XPDQUIT=2
 ;
 Q
PATCH(X) ;return 1 if patch X was installed, X=aaaa*nn.nn*nnnn
 ;copy of code from XPDUTL but modified to handle 4 digit IHS patch numbers
 Q:X'?1.4UN1"*"1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.4N 0
 NEW NUM,I,J
 S I=$O(^DIC(9.4,"C",$P(X,"*"),0)) Q:'I 0
 S J=$O(^DIC(9.4,I,22,"B",$P(X,"*",2),0)),X=$P(X,"*",3) Q:'J 0
 ;check if patch is just a number
 Q:$O(^DIC(9.4,I,22,J,"PAH","B",X,0)) 1
 S NUM=$O(^DIC(9.4,I,22,J,"PAH","B",X_" SEQ"))
 Q (X=+NUM)
 ;
TEST(X) ; return 1 if site is running an iteration version of patch
 NEW IEN
 S IEN=$O(^XPD(9.6,"B",X,0)) I 'IEN Q 1   ;not test version but bad xref
 I $G(^XPD(9.6,IEN,1,1,0))["ITERATION #" Q 1
 Q 0
 ;
PRE ;EP;
 Q
 ;
POST ;EP; post install code
 D AGE,PROT1,PROT2,PREFIX,AUTHBED
 Q
 ;
AGE ; fix code in ADT ITEM to use AGE^AUPNPAT instead of delelted line AGE^BDGF2
 D BMES^XPDUTL("Updating AGE code in ADT ITEMS file . . .")
 NEW IEN,STR,CALL
 S IEN=0 F  S IEN=$O(^BDGITM(IEN)) Q:'IEN  D
 . Q:$G(^BDGITM(IEN,1))'["AGE^BDGF2"
 . S STR=^BDGITM(IEN,1),CALL("AGE^BDGF2")="AGE^AUPNPAT",STR=$$REPLACE^XLFSTR(STR,.CALL)
 . S ^BDGITM(IEN,1)=STR
 Q
 ;
PROT1 ; switch Rx Profiles with Other Reports under BSDAM MENU protocol menu
 NEW PROT,OLD,NEW,IEN,DIE,DA,DR
 S PROT=$O(^ORD(101,"B","BSDAM MENU",0)) Q:'PROT
 S OLD=$O(^ORD(101,"B","BSDAM RX PROFILES",0)) Q:'OLD
 S NEW=$O(^ORD(101,"B","BSDAM OTHER REPORTS",0)) Q:'NEW
 S IEN=$O(^ORD(101,PROT,10,"B",OLD,0)) Q:'IEN
 D BMES^XPDUTL("Switching Rx Profiles for Other Reports under AM . . .")
 ;
 S DIE="^ORD(101,"_PROT_",10,",DA(1)=PROT,DA=IEN
 S DR=".01///`"_NEW_";2///OR"
 D ^DIE
 Q
 ;
PROT2 ; fix entry action for BSDAM ADD ENCOUNTER (only run at check-in)
 NEW X
 S X=$O(^ORD(101,"B","BSDAM ADD ENCOUNTER",0)) Q:'X
 D BMES^XPDUTL("Fixing Scheduling Event Driver - add to file 409.68 only at check-in . . .")
 S ^ORD(101,X,20)="I $G(SDAMEVT)=4 D APPT^SDVSIT(DFN,SDT,SDCL,$G(BSDVSTN))"
 Q
 ;
PREFIX ; remove all additional prefixes to PIMS Package file entry
 NEW PKG,IEN,PFX,DD,DO,DIC,DA,FIRST
 S PKG=$O(^DIC(9.4,"C","PIMS",0)) Q:'PKG
 S DIK="^DIC(9.4,"_PKG_",14,"
 S FIRST=1
 F PFX="BDG","BSD","DG","SD","SC","VADPT" D
 . Q:'$D(^DIC(9.4,PKG,14,"B",PFX))           ;skip if not there
 . I FIRST D BMES^XPDUTL("Adding all Prefixes to PIMS package file entry. . . ") S FIRST=0
 . S DA(1)=PKG,DA=$O(^DIC(9.4,PKG,14,"B",PFX,0)) I DA D ^DIK
 Q
 ;
AUTHBED ; copy authorized bed info to new data structure
 NEW CENI,WARD,DONE,FIELD,BEDS,DIC,DLAYGO,DA,DIE,DR,X,Y
 ; first see if this has already been run
 S DONE=0,WARD=0 F  S WARD=$O(^BDGWD(WARD)) Q:'WARD  Q:DONE  D
 . I $O(^BDGWD(WARD,2,0)) S DONE=1
 Q:DONE
 ;
 D BMES^XPDUTL("Copying authorized bed counts into a multiple . . .")
 ; if not, copy into multiple using census init date
 S CENI=$$GET1^DIQ(43,1,10,"I")   ;census intialization date
 S WARD=0 F  S WARD=$O(^BDGWD(WARD)) Q:'WARD  D
 . F FIELD=102,103,111,112,113,114,115,116,117,118,119 D
 . . S BEDS=$$GET1^DIQ(9009016.5,WARD,FIELD) Q:BEDS<1
 . . S DIC="^BDGWD("_WARD_",2,",DIC(0)="L",DLAYGO=9009015.52
 . . S DA(1)=WARD,X=CENI K DD,DO D FILE^DICN Q:'Y
 . . S DIE=DIC,DA=+Y,DR=".03///"_BEDS_";.02///"_$P($T(@FIELD),";;",2)
 . . D ^DIE
 Q
 ;
FIELD ;;
102 ;;IC;;
103 ;;PC;;
111 ;;AM;;
112 ;;AS;;
113 ;;PM;;
114 ;;PS;;
115 ;;OB;;
116 ;;NB;;
117 ;;TB;;
118 ;;AL;;
119 ;;MH;;
