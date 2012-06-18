BDGP1004 ;IHS/ITSC/LJF - PRE & POST INSTALL, ENVIRON CHECK FOR PATCH 1004
 ;;5.3;PIMS;**1004**;MAY 28, 2004
 ;
CKENV ; environment check code
 ;Prevents "Disable Options..." and "Move Routines..." questions
 S XPDDIQ("XPZ1")=0,XPPDIQ("XPZ2")=0
 ;
 ; now check for patch 1003
 NEW PATCH S PATCH="PIMS*5.3*1003"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 ;
 ; check for test version of patch 1003
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
 D UB92,BHLFIX,ABWL,CRBFIX,ICDATES,BULL
 Q
 ;
UB92 ; convert Discharge UB92 set of codes to pointer
 ; only IEN 10 for mental health facility needs to be changed
 ; no xrefs on either file (405 or V Hosp)
 Q:$D(^BDGX("P1004"))             ;don't run again, if done already
 D BMES^XPDUTL("Converting Discharge UB92 pointers . . .")
 NEW IEN
 S IEN=0 F  S IEN=$O(^DGPM(IEN)) Q:'IEN  D
 . Q:$P($G(^DGPM(IEN,"IHS")),U,7)'=10
 . S $P(^DGPM(IEN,"IHS"),U,7)=65
 ;
 S IEN=0 F  S IEN=$O(^AUPNVINP(IEN)) Q:'IEN  D
 . Q:$P($G(^AUPNVINP(IEN,61)),U,3)'=10
 . S $P(^AUPNVINP(IEN,61),U,3)=65
 S ^BDGX("P1004")=$$NOW^XLFDT   ;set date/time stamp
 Q
 ;
BHLFIX ; fix sequence for old, no longer supported PYXIS call in ADT event driver
 ; PYXIS routine changes value of DGPMCA
 NEW EVENT,ITEM,DIE,DA,DR
 S ITEM=$O(^ORD(101,"B","BHL PYXIS ADT",0)) Q:'ITEM
 D BMES^XPDUTL("Updating PYXIS sequence in ADT Event Driver . . .")
 S EVENT=$O(^ORD(101,"B","BDGPM MOVEMENT EVENTS",0)) Q:'EVENT
 ;
 S DA=$O(^ORD(101,EVENT,10,"B",ITEM,0)) Q:'DA
 S DA(1)=EVENT,DIE="^ORD(101,"_EVENT_",10,"
 S DR="3///999"    ;reset sequence to very last
 D ^DIE
 Q
 ;
ABWL ; run all cross-references for Waiting List so new AB xref is built
 ;running all xrefs because AB is on a subfile and ENALL^DIK won't do all entries
 ;
 D BMES^XPDUTL("Re-indexing Waiting List File . . .")
 S DIK="^BSDWL(" D IXALL^DIK
 Q
 ;
CRBFIX ; adjust the captions fo the E-Code line on distributed A Sheet forms
 NEW DA,DR,DIE,ECODE
 D BMES^XPDUTL("Fixing E-Code captions on A Sheet Forms . . .")
 S ECODE=$O(^BDGITM("B","E-CODES LINE",0)) I 'ECODE D  Q
 . D BMES^XPDUTL("> > > ERROR!  Cannot find E-Code Item; Contact IHS Help Desk! < < < ")
 ;
 S DA(2)=$O(^BDGFRM("B","IHS CLINICAL RECORD BRIEF",0))
 I DA(2) D
 . S DA(1)=$O(^BDGFRM(DA(2),"LINE","B",16,0)) Q:'DA(1)
 . S DA=$O(^BDGFRM(DA(2),"LINE",DA(1),"ITEM","B",ECODE,0)) Q:'DA
 . S DIE="^BDGFRM("_DA(2)_",""LINE"","_DA(1)_",""ITEM"","
 . S DR=".03///^S X=""40 Injury Date  41 Alleged Injury Cause     42&43 E-Codes & Place of Occurrence""" D ^DIE
 ;
 K DA,DR,DIE
 S DA(2)=$O(^BDGFRM("B","ANMC CLINICAL RECORD BRIEF",0))
 I DA(2) D
 . S DA(1)=$O(^BDGFRM(DA(2),"LINE","B",20,0)) Q:'DA(1)
 . S DA=$O(^BDGFRM(DA(2),"LINE",DA(1),"ITEM","B",ECODE,0)) Q:'DA
 . S DIE="^BDGFRM("_DA(2)_",""LINE"","_DA(1)_",""ITEM"","
 . S DR=".03///^S X=""Injury Date    Alleged Injury Cause         E-Codes & Place of Occurrence""" D ^DIE
 Q
 ;
ICDATES ; stuff IC date parameters if not currently filled in
 D BMES^XPDUTL("Updating Incomplete Chart Date Parameters . . .")
 NEW DIE,DA,DR
 S DIE="^BDGPAR(",DA=$$DIV^BSDU
 F FIELD=201:1:208 I $$GET1^DIQ(9009020.1,DA,FIELD)="" D
 . S DR=FIELD_"///1" D ^DIE
 Q
 ;
BULL ; send bulletins to appropriate users
 D BMES^XPDUTL("Sending bulletins to users . . .")
 NEW XMB,USER,XMDT,XMY
 S XMB="BDG PATCH 1004 BED CONTROL",XMDT=$$NOW^XLFDT
 S USER=0 F  S USER=$O(^XUSEC("DGZADT",USER)) Q:'USER  S XMY(USER)=""
 D ^XMB
 ;
 K XMB,USER,XMDT,XMY
 S XMB="BDG PATCH 1004 ICE",XMDT=$$NOW^XLFDT
 S USER=0 F  S USER=$O(^XUSEC("DGZPCC",USER)) Q:'USER  S XMY(USER)=""
 D ^XMB
 ;
 K XMB,USER,XMDT,XMY
 S XMB="BDG PATCH 1004 WAIT LIST",XMDT=$$NOW^XLFDT
 S USER=0 F  S USER=$O(^XUSEC("SDZWAIT",USER)) Q:'USER  S XMY(USER)=""
 S USER=0 F  S USER=$O(^XUSEC("SDZAC",USER)) Q:'USER  S XMY(USER)=""
 D ^XMB
 Q
