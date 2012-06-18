BIPRE ;IHS/CMI/MWR - PRE-INIT ROUTINE; OCT 15, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  PRE-INIT TO REMOVE PREVIOUS ^DD's, RPC's, Forms, List Templates,
 ;;  and Protocols in the 9002084-9002084.9999 and BI* Spaces.
 ;;  PATCH 1: Change DIU(0)="T" to DIU(0)="S" to preserve local templates: DD+7
 ;;
 ;
 ;----------
MAIN ;EP
 ;---> Pre-init program.
 ;
 D SETVARS^BIUTL5 S BIPOP=0
 S BIPTITL="v"_$$VER^BILOGO_" PRE-INIT PROGRAM"
 ;D PERMISS(.BIPOP) I BIPOP D EXIT Q
 ;S DUZ(0)="@"
 ;
 ;---> Delete all old Error Codes.  Added. vvv83
 D ZGBL^BIUTL8("^BIERR")
 ;W !!,"DO SOMETHING HERE?" R ZZZ
 Q
 ;
 ;
 D DD
 D RPCS
 D FORMS
 D LISTS
 D PROTOCOL
 D CLRGLBS
 D EXIT
 Q
 ;
 ;
 ;----------
PERMISS(BIPOP) ;EP
 ;---> Set up proper permission to delete Data Dictionaries.
 S BIPOP=0
 Q:DUZ(0)["@"
 W !!!! D TITLE^BIUTL5(BIPTITL)
 D TEXT1,DIRZ^BIUTL3 S BIPOP=1
 Q
 ;
 ;
 ;----------
DD ;EP
 ;---> Delete all BI Package Data Dictionaries.
 N N
 D TITLE^BIUTL5(BIPTITL)
 D TEXT2
 ;---> BY DD#.
 ;
 ;********** PATCH 1, v8.2.1, FEB 01,2008, IHS/CMI/MWR
 ;---> PATCH 1: Change DIU(0)="T" to DIU(0)="S" to preserve local templates.
 ;S N=9002083.99999,DIU(0)="T"
 S N=9002083.99999,DIU(0)="S"
 ;**********
 ;
 F  S N=$O(^DD(N)) Q:'+N  Q:N'<9002085  D
 .W !?6,N
 .S DIU=N
 .D EN^DIU2
 ;S N=9999999.14,DIU=N W !?6,N D EN^DIU2  ;IMMUNIZATION (VACCINE TABLE)
 ;S N=9999999.04,DIU=N W !?6,N D EN^DIU2  ;IMM MANUFACTURER
 S N=9999999.41,DIU=N W !?6,N D EN^DIU2  ;IMMUNIZATION LOT
 K DIU
 W !?5,"Data Dictionary deletion complete." H 1
 ;
 F N="ERR","EXPDD","SERT" D
 .D ZGBL^BIUTL8("^BI"_N)
 W !?5,"Old BI standard tables deletion complete." H 1
 ;
 Q
 ;
 ;
 ;----------
RPCS ;EP
 ;---> Delete all RPCs in BI Namespace.
 W !!!?6,"The Pre-Initialization Program is removing all old Remote"
 W !?6,"Procedure Calls.  Please stand by...",!
 S N="BI",DIK="^XWB(8994,"
 F  S N=$O(^XWB(8994,"B",N)) Q:N=""!(N]"BIZZZ")  D
 .S DA=$O(^XWB(8994,"B",N,0))
 .D ^DIK
 Q
 ;
 ;
 ;----------
FORMS ;EP
 ;---> Delete all BI Forms and Blocks.
 W !!!?6,"The Pre-Initialization Program is removing all old Screenman"
 W !?6,"forms and blocks.  Please stand by...",!
 S N="BI",DIK="^DIST(.403,"
 F  S N=$O(^DIST(.403,"B",N)) Q:N=""!(N]"BIZZZ")  D
 .S DA=$O(^DIST(.403,"B",N,0))
 .D ^DIK
 ;
 S N="BI",DIK="^DIST(.404,"
 F  S N=$O(^DIST(.404,"B",N)) Q:N=""!(N]"BIZZZ")  D
 .S DA=$O(^DIST(.404,"B",N,0))
 .D ^DIK
 W !?6,"Screen deletions complete." H 1
 Q
 ;
 ;
 ;----------
LISTS ;EP
 ;---> Delete all LIST Templates in BI Namespace.
 W !!!?6,"The Pre-Initialization Program is removing all old"
 W !?6,"List Templates.  Please stand by...",!
 S N="BI",DIK="^SD(409.61,"
 F  S N=$O(^SD(409.61,"B",N)) Q:N=""!(N]"BIZZZ")  D
 .S DA=$O(^SD(409.61,"B",N,0))
 .D ^DIK
 Q
 ;
 ;
 ;----------
PROTOCOL ;EP
 ;---> Delete all Protocols in BI Namespace.
 W !!!?6,"The Pre-Initialization Program is removing all old Protocols"
 W !?6,"Please stand by...",!
 S N="BI",DIK="^ORD(101,"
 F  S N=$O(^ORD(101,"B",N)) Q:N=""!(N]"BIZZZ")  D
 .S DA=$O(^ORD(101,"B",N,0))
 .D ^DIK
 Q
 ;
 ;
 ;----------
CLRGLBS ;EP
 ;---> Delete globals of standard data that will have data placed
 ;---> in them by KIDS.
 ;---> Delete all old text in BI PACKAGE INFORMATION.
 D ZGBL^BIUTL8("^BINFO")
 ;---> Delete all old Sample Letters.
 D ZGBL^BIUTL8("^BILETS")
 ;---> Delete all old Error Codes.  Added. vvv83
 D ZGBL^BIUTL8("^BIERR")
 ;---> Delete VT-100 Codes.
 D KGBL^BIUTL8("^BIVT100")
 Q
 ;
 ;
 ;----------
TEXT1 ;
 ;;This preinit clears all data dictionaries out of the Immunization
 ;;number space (9002084-9002084.99) before loading the new data
 ;;dictionaries.  In order for this to occur, your DUZ(0) must contain
 ;;the "@".  Your DUZ(0), however, does NOT contain the "@", and the
 ;;SAC standards prevent this program from setting it for you.
 ;;
 ;;You can set your DUZ(0)=@ by entering S DUZ(0)="@" at the programmer
 ;;prompt, or by entering Fileman in programmer mode: enter D P^DI at
 ;;the programmer prompt and then simply press RETURN to back out of it.
 ;;
 ;;After resetting your DUZ(0), you may begin the init process again
 ;;by entering D ^BIINIT at the programmer prompt.
 ;;
 ;;This init will now terminate without having made any changes to the
 ;;current software.
 D PRINTX("TEXT1")
 Q
 ;
 ;
 ;----------
TEXT2 ;
 ;;The Pre-Initialization Program is removing all old Data Dictionaries
 ;;in the 9002084-9002084.9999 number space and old BI standard tables.
 ;;Please stand by...
 ;;
 D PRINTX("TEXT2")
 Q
 ;
 ;
PRINTX(BILINL,BITAB) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
 ;
 ;
 ;----------
EXIT ;EP
 ;---> End of job cleanup.
 D KILLALL^BIUTL8(1)
 Q
