BIPOST ;IHS/CMI/MWR - POST-INIT ROUTINE; OCT 15, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  PATCH 1: Comment out unnecessary post-install routines.  START+14
 ;;  PATCH 2: Set older Flu's to Inactive.  START+19
 ;
 ;
 ;----------
START ;EP
 ;---> Update software after KIDS installation.
 ;
 D SETVARS^BIUTL5 S BIPOP=0
 ;S IOP=$I D ^%ZIS
 ;
 W !!!?3,"Please hold..."
 ;
 ;---> Reindex any Listman Hidden Menus.
 D LISTMENU^BIUTLFIX
 ;---> Standardize the Vaccine Table.
 D RESTAND^BIRESTD()
 ;
 ;********** PATCH 2, v8.4, OCT 15,2010, IHS/CMI/MWR
 ;---> Comment out unnecessary post-install routines.
 ;
 ;---> Set NOS (and a couple other) vaccines to Inactive.
 ;N N F N=105,108,110,113,122,124,130,131,139,142,149,155,157,195 D
 ;---> Set older Flu's to Inactive.
 ;N N F N=108,148,149,229 D
 ;.S $P(^AUTTIMM(N,0),U,7)=1
 ;.S $P(^BITN(N,0),U,7)=1
 ;
 ;F N=200,205,212,213,214,218,228,234,238,239 D
 ;.S $P(^AUTTIMM(N,0),U,7)=1
 ;.S $P(^BITN(N,0),U,7)=1
 ;
 ;---> Set the following vaccines (Comvax) to Active.
 N N F N=167,224,225,237 D
 .S $P(^AUTTIMM(N,0),U,7)=0
 .S $P(^BITN(N,0),U,7)=0
 ;
 ;---> Reset Display Order of Vaccine Groups in BI TABLE VACCINE GROUP File #9002084.93.
 ;S $P(^BISERT(1,0),"^",2)=1
 ;S $P(^BISERT(2,0),"^",2)=3
 ;S $P(^BISERT(3,0),"^",2)=4
 ;S $P(^BISERT(4,0),"^",2)=6
 ;S $P(^BISERT(5,0),"^",2)=5
 ;S $P(^BISERT(6,0),"^",2)=7
 ;S $P(^BISERT(7,0),"^",2)=8
 ;S $P(^BISERT(8,0),"^",2)=2
 ;S $P(^BISERT(9,0),"^",2)=9
 ;S $P(^BISERT(10,0),"^",2)=10
 ;S $P(^BISERT(11,0),"^",2)=12
 ;S $P(^BISERT(12,0),"^",2)=90
 ;S $P(^BISERT(13,0),"^",2)=99
 ;S $P(^BISERT(14,0),"^",2)=95
 ;S $P(^BISERT(15,0),"^",2)=85
 ;S $P(^BISERT(16,0),"^",2)=15
 ;S $P(^BISERT(17,0),"^",2)=18
 ;S $P(^BISERT(18,0),"^",2)=11
 S $P(^BISERT(18,0),"^",5)=0
 ;
 ;---> Standardize the VT-100 Codes in the Terminal Type File.
 ;D ^BIVT100
 ;---> Set new Immserve Path.
 ;NO NEW IMMPATH FOR Imm v8.5.
 D IMMPATH
 ;---> Check and fix any Lot Numbers with a Status of null.
 D NULLACT^BILOT1
 ;---> Reindex killed globals.
 ;D REINDEX
 ;---> Update Taxonomies.
 ;D ^BITX
 ;---> Reindex BI Letter Sample and BI Table Manufactures Files.
 ;D REINDLS
 ;---> Update "Last Version Fully Installed" Field in BI SITE PARAMETER File.
 N N S N=0 F  S N=$O(^BISITE(N)) Q:'N  S $P(^BISITE(N,0),"^",15)=$$VER^BILOGO
 ;
 D TEXT2,DIRZ^BIUTL3()
 D TEXT1,DIRZ^BIUTL3()
 ;
 D EXIT
 Q
 ;
 ;
 ;----------
EXIT ;EP
 D KILLALL^BIUTL8(1)
 Q
 ;
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;         - This concludes the Post-Initialization program. -
 ;;
 ;;                       * CONGRATULATIONS! *
 ;;
 ;;          You have successfully installed Immunization v8.5.
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 W @IOF
 D PRINTX("TEXT1")
 Q
 ;**********
 ;
 ;
 ;----------
TEXT2 ;EP
 ;;
 ;;
 ;;
 ;;
 ;;                             * NOTE! *
 ;;
 ;;    Do not forget to complete the Immserve part of the installation!!
 ;;
 ;;                             * NOTE! *
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 W @IOF
 D PRINTX("TEXT2")
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 ;---> Print text at specified line label.
 ;
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
 ;
 ;
 ;----------
IMMPATH ;EP
 ;---> Update path for new Immserve files.
 N N,X,Y S Y=$$VERSION^%ZOSV(1) D
 .I Y["Windows" S X="C:\Program Files\Immserve85\" Q
 .I Y["UNIX" S X="/usr/local/immserve85/"
 ;
 S N=0
 F  S N=$O(^BISITE(N)) Q:'N  D
 .S $P(^BISITE(N,0),"^",18)=X
 Q
 ;
 ;
 ;----------
REINDEX ;EP
 ;---> Not called.  Programmer to use if KIDS fails to index these files.
 ;
 N DIK
 F DIK="^BINFO(","^BILETS(","^BIVT100(","^BIERR(","^BINFO(","^BIEXPDD(","^BISERT(","^BICONT(" D
 .D IXALL^DIK
 .S DIK="^BISERT(" D IXALL^DIK
 Q
 ;
 ;
KEYS ;EP
 ;---> Clean up subordinate keys (there should be none).
 N X,Y
 F X="BIZ EDIT PATIENTS","BIZ MANAGER","BIZMENU" D
 .S Y=$O(^DIC(19.1,"B",X,0)) K @("^DIC(19.1,"""_Y_""",3)")
 Q
 ;
 ;
REINDLS ;EP
 ;---> Reindex BI LETTER SAMPLE File.
 N X,Y
 S DIK="^BILETS("
 D IXALL^DIK
 S DIK="^BIMAN("
 D IXALL^DIK
 Q
