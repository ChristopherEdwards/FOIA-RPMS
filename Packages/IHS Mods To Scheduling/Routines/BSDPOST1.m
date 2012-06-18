BSDPOST1 ; IHS/ANMC/LJF - SCHEDULING POST INIT CONT. ;  [ 04/09/2004  11:09 AM ]
 ;;5.3;PIMS;;APR 26, 2002
 ;
WAIT ;EP; copy waiting list data into new file structure
 ; ^ASDWL -> ^BSDWL   old data kept until future patch
 Q:$O(^BSDWL(0))   ;already data in new file
 D BMES^XPDUTL("Copying Waiting List data to new file...")
 ;
 NEW OLD,NEW,OLD1,NEW1,DATA,DIK
 S OLD=0 F  S OLD=$O(^ASDWL(OLD)) Q:'OLD  D
 . Q:$G(^ASDWL(OLD,0))=""          ;bad entry
 . S NEW=$G(NEW)+1                 ;ien for new entry in new file
 . S $P(^BSDWL(0),U,3)=NEW,$P(^BSDWL(0),U,4)=$P(^BSDWL(0),U,4)+1
 . S ^BSDWL(NEW,0)=^ASDWL(OLD,0)   ;set zero node
 . ;
 . Q:'$O(^ASDWL(OLD,1,0))          ;no patients for entry
 . S ^BSDWL(NEW,1,0)="^9009017.11P"  ;set zero node
 . ;
 . ; loop thru patient multiple
 . S (OLD1,NEW1)=0 F  S OLD1=$O(^ASDWL(OLD,1,OLD1)) Q:'OLD1  D
 .. S DATA=$G(^ASDWL(OLD,1,OLD1,0)) Q:DATA=""    ;quit if bad entry
 .. S NEW1=NEW1+1,^BSDWL(NEW,1,NEW1,0)=""        ;set zero node
 .. S $P(^BSDWL(NEW,1,0),U,3)=NEW1               ;update multiple node
 .. S $P(^BSDWL(NEW,1,0),U,4)=$P(^BSDWL(NEW,1,0),U,4)+1
 .. ;
 .. ; move data items to new locations
 .. S $P(^BSDWL(NEW,1,NEW1,0),U,1,3)=$P(DATA,U,1,3)
 .. S $P(^BSDWL(NEW,1,NEW1,0),U,5,6)=$P(DATA,U,6,7)
 .. Q:$P(DATA,U,4)=""                            ;quit if no comments
 .. S ^BSDWL(NEW,1,NEW1,1,0)="^9009017.111^1^1"
 .. S ^BSDWL(NEW,1,NEW1,1,1,0)=$P(DATA,U,4)      ;comments now wp field
 ;
 ; index new file
 S DIK="^BSDWL(" D IXALL^DIK
 K X S X=$$REPEAT^XLFSTR(" ",20)_"Done" D MES^XPDUTL(.X)
 Q
 ;
 ;
PARAM ;EP; copy scheduling parameters from file 40.8 to 9009020.2
 ; copy from ^DG(40.8 -> ^BSDPAR (which points back to 40.8 dinumed)
 ; old data will be left in 40.8 until a future patch
 Q:$O(^BSDPAR(0))    ;already has data
 D BMES^XPDUTL("Copying scheduling parameters to IHS file...")
 ;
 NEW DIV,DATA,I,DIK
 S DIV=0 F  S DIV=$O(^DG(40.8,DIV)) Q:'DIV  D
 . S DATA=$G(^DG(40.8,DIV,"IHS")) Q:DATA=""
 . ;
 . ; now copy items into new locations
 . S ^BSDPAR(DIV,0)=DIV,$P(^BSDPAR(0),U,3)=DIV
 . S $P(^BSDPAR(0),U,4)=$P(^BSDPAR(0),U,4)+1
 . F I="1;2","2;16","3;3","4;4","5;5","6;6","8;8","9;19","11;11","12;12","15;15","16;13" S $P(^BSDPAR(DIV,0),U,$P(I,";",2))=$P(DATA,U,+I)
 ;
 ; new index new file
 S DIK="^BSDPAR(" D IXALL^DIK
 K X S X=$$REPEAT^XLFSTR(" ",20)_"Done" D MES^XPDUTL(.X)
 Q
 ;
PCMM ;EP; set up PCMM files for GIU workstation
 D BMES^XPDUTL("Setting up PCMM files - Server side...")
 ;
 NEW DD,DO,DIC,X,Y,DINUM,DLAYGO
 I '$D(^SCTM(404.44,1,0)) D     ;pcmm parameter file
 . K DD,DO S DIC="^SCTM(404.44,",DLAYGO=404.44,DIC(0)="L"
 . S (X,DINUM)=1,DIC("DR")="12///0;13///1;14///30;15///2500;16///14"
 . D FILE^DICN
 . I Y<1 K X S X="PCMM Parameter File Error!" D MES^XPDUTL(.X)
 ;
 I '$D(^SCTM(404.46,"B","1.2.2.0",1)) D   ;pcmm client patch
 . K DD,DO,DIC,DINUM S DIC="^SCTM(404.46,",DLAYGO=404.46,DIC(0)="L"
 . S X="1.2.2.0",DIC("DR")=".02///1;.03///3000412"
 . D FILE^DICN
 . I Y<1 K X S X="PCMM Client Patch File Error!" D MES^XPDUTL(.X)
 ;
 S BDGC=$O(^SCTM(404.46,"B","1.2.2.0",0)) Q:'BDGC
 ;
 I '$D(^SCTM(404.45,"B","1.2.2.0",1)) D   ;pcmm server patch
 . K DD,DO,DIC,DINUM S DIC="^SCTM(404.45,",DLAYGO=404.45,DIC(0)="L"
 . S X="SD*5.3*204",DIC("DR")=".02///"_BDGC_";.03///3000412;.04///1"
 . D FILE^DICN
 . I Y<1 K X S X="PCMM Server Patch File Error!" D MES^XPDUTL(.X)
 ;
 K X S X=$$REPEAT^XLFSTR(" ",20)_"Done" D MES^XPDUTL(.X)
 ;
 ;IHS/ITSC/LJF 4/9/2004 added subroutine below
CANCEL ;EP; inactivate old Cancellaton Reason "SHERI"
 NEW DIE,DA,DR
 S DA=$O(^SD(409.2,"B","SHERI",0)) Q:'DA
 S DIE=409.2,DR="4///INACTIVE" D ^DIE
 Q
