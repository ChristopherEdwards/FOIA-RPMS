BDGP1003 ;IHS/ITSC/LJF - PRE & POST INSTALL, ENVIRON CHECK FOR PATCH 1003
 ;;5.3;PIMS;**1003**;MAY 28, 2004
 ;
CKENV ; environment check code
 ;Prevents "Disable Options..." and "Move Routines..." questions
 S XPDDIQ("XPZ1")=0,XPPDIQ("XPZ2")=0
 ;
 ; now check for patch 1002
 S PATCH="PIMS*5.3*1002"
 I '$$PATCH(PATCH) D
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
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
PRE ;EP;
CLEAN ; clean out ADT ITEM file before restoring data
 NEW X
 S X=0 F  S X=$O(^BDGITM(X)) Q:'X  K ^BDGITM(X)
 K ^BDGITM("B")
 S $P(^BDGITM(0),U,3,4)="0^0"
 Q
 ;
POST ;EP; post install code
 D STUFF,KILLID,CDEF,PATCHES,FORM,DSFIX,BULL
 Q
 ;
STUFF ; stuff new "Print A Sheet at Admission" parameter to 1
 ; and reset days to delinquency if greater than 30
 D BMES^XPDUTL("Initializing new ADT parameters . . .")
 NEW DA,DIE,DR
 S DA=0 F  S DA=$O(^BDGPAR(DA)) Q:'DA  D
 . I $$GET1^DIQ(9009020.1,DA,.16)="" D
 . . S DIE="^BDGPAR(",DR=".16///1" D ^DIE
 . I $$GET1^DIQ(9009020.1,DA,.12)>30 D
 . . S DIE="^BDGPAR(",DR=".12///30" D ^DIE
 Q
 ;
KILLID ; remove VA identifier from file 45.7
 D BMES^XPDUTL("Removing VA identifier from file 45.7 . . .")
 K ^DD(45.7,0,"ID",1)    ;Exemption from SAC #2.2.3.2.7 pending
 Q
 ;
CDEF ; mark awaiting transcription entries under Admin grouping
 D BMES^XPDUTL("Marking ""AWAITING TRANS"" deficiencies to ADMIN group . . .")
 NEW BDGI,DA,DIE,DR
 S DIE="^BDGCD(",DR=".03///ADM"
 F BDGI="AWAITING TRANS NS","AWAITING TRANS OR" D
 . S DA=$O(^BDGCD("B",BDGI,0)) Q:'DA
 . D ^DIE
 Q
 ;
FORM ; update line 4 in ADT FORM - IHS format
 D BMES^XPDUTL("Updating line 4 in IHS Clinical Record Brief format . . .")
 NEW DIE,DA,DR
 S DIE="^BDGFRM(1,""LINE"",4,""ITEM""," S DA(2)=1,DA(1)=4
 S DA=$O(^BDGFRM(1,"LINE",4,"ITEM","B",15,0))
 I DA S DR=".03///Community Code;.04///20" D ^DIE
 S DA=$O(^BDGFRM(1,"LINE",4,"ITEM","B",23,0))
 I DA S DR=".03///Admtg Ward;.04///15" D ^DIE
 S DA=$O(^BDGFRM(1,"LINE",4,"ITEM","B",22,0))
 I DA S DR=".03///Admtg Provider;.04///25" D ^DIE
 Q
 ;
DSFIX ; find and fix any old day surgery entries without zero nodes
 D BMES^XPDUTL("Fixing any day surgery entries with errors . . .")
 NEW IEN S IEN=0
 F  S IEN=$O(^ADGDS(IEN)) Q:'IEN  I '$D(^ADGDS(IEN,0)) D
 . S ^ADGDS(IEN,0)=IEN,^ADGDS("B",IEN,IEN)=""
 . W !?5,"Entry for patient #",$$HRCN^BDGF2(IEN,DUZ(2))," fixed."
 Q
 ;
BULL ; send bulletins to appropriate users
 D BMES^XPDUTL("Sending bulletins to users . . .")
 NEW XMB,USER,XMDT,XMY
 S XMB="BDG PATCH 1003",XMDT=$$NOW^XLFDT
 S USER=0 F  S USER=$O(^XUSEC("DGZSYS",USER)) Q:'USER  S XMY(USER)=""
 D ^XMB
 ;
 S XMB="BSD PATCH 1003",XMDT=$$NOW^XLFDT
 K XMY S USER=0 F  S USER=$O(^XUSEC("SDZAC",USER)) Q:'USER  S XMY(USER)=""
 D ^XMB
 Q
 ;
PATCHES ; mark package file entry with old PIMS patch #s required by CSV
 D BMES^XPDUTL("Adding VA patch #s to patch history . . .")
 NEW PKG,VER,COUNT,PATCH,DA,DIC,X,Y
 F NMSP="DG","SD" D
 . S PKG=$O(^DIC(9.4,"C",NMSP,0)) Q:'PKG  D
 . . S VER=$O(^DIC(9.4,PKG,22,"B","5.3",0)) Q:VER<1
 . . F COUNT=1:1 S PATCH=$P($T(OLDPATCH+COUNT),";;",2) Q:PATCH=""  D
 . . . Q:$P($T(OLDPATCH+COUNT),";;",3)'=NMSP              ;check namespace
 . . . I $D(^DIC(9.4,PKG,22,VER,"PAH","B",PATCH)) Q       ;already in file
 . . . S DIC="^DIC(9.4,"_PKG_",22,"_VER_",""PAH"","
 . . . S DA(2)=PKG,DA(1)=VER,DIC(0)="L"
 . . . S DIC("P")=$P(^DD(9.49,1105,0),U,2)
 . . . S X=PATCH,DIC("DR")=".02///"_DT_";.03///`"_DUZ
 . . . D ^DIC
 Q
 ;
OLDPATCH ;;
 ;;158 SEQ #0;;DG
 ;;190 SEQ #0;;DG
 ;;309 SEQ #0;;DG
 ;;397 SEQ #364;;DG
 ;;441 SEQ #386;;DG
 ;;418 SEQ #416;;DG
 ;;493 SEQ #430;;DG
 ;;512 SEQ #447;;DG
 ;;199 SEQ #220;;SD
 ;;258 SEQ #245;;SD
 ;;254 SEQ #247;;SD
 ;;296 SEQ #259;;SD
