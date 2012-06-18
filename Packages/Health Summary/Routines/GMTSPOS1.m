GMTSPOS1 ;SLC/SBW - Smart routine installer and Comp. Disabler ;22/MAR/95
 ;;2.7;Health Summary;;Oct 20, 1995
 ;IHS/ITSC/LJF 08/08/2003 changed code to handle patches released since postinit was written
 ;             08/14/2003 bypassed subroutines that no longer work
 ;
PSO ; Controls Outpatient Pharmacy install
 N GMPSOVER
 ;If Health Summary is absent, then quit
 I '$L($T(^PSOHCSUM)) Q
 S GMPSOVER=$$VERSION^XPDUTL("PSO")
 D PSOINST(GMPSOVER)
 Q
PSOINST(VERSION) ; Install routine corresponding to HS version in
 ;                 target account
 ; If the patch is already installed, then quit w/o overwriting
 N DIE,DIF,GMMSG,X,XCN,XCNP
 I VERSION'<6.0 Q
 W !,"** Installing GMTSPSO routine for Outpatient Pharmacy component. **"
 W !,"   Outpatient Pharmacy version ",VERSION," is installed in this account.",!
 S X="GMTSPSZO",XCNP=0,DIF="^UTILITY(""GMTSPSZO""," X ^%ZOSF("LOAD") W !,"Renaming GMTSPSZO as GMTSPSO."
 S X="GMTSPSO",XCN=2,DIE="^UTILITY(""GMTSPSZO""," X ^%ZOSF("SAVE") K ^UTILITY("GMTSPSZO") W "  Done.",!
 Q
 ;******************************************************
SOWK ; Controls Social Work install
 N X,GMMSG
 ; Checks conditions for auto-disable of Social Work component
 I $$VERSION^XPDUTL("SOWK")<3 D
 . S GMMSG="Social Work Service version 3.0 not yet installed"
 . S X="SOCIAL WORK" D DISABLE^GMTSPOST
 I $$VERSION^XPDUTL("SOWK")>2.99 D
 . ;If Social Work extract routine for Health Summary is present, quit
 . I $L($T(^SOWKHSUM)) Q
 . W !,"** Installing SOWKHSUM routine for Social Work Component. **"
 . D SOWKINST
 Q
SOWKINST ; Install SOWKHSUM routine
 N DIE,DIF,GMMSG,X,XCN,XCNP
 S X="GMTSSOWZ",XCNP=0,DIF="^UTILITY(""GMTSSOWZ""," X ^%ZOSF("LOAD") W !,"Renaming GMTSSOWZ as SOWKHSUM."
 S X="SOWKHSUM",XCN=2,DIE="^UTILITY(""GMTSSOWZ""," X ^%ZOSF("SAVE") K ^UTILITY("GMTSSOWZ") W "  Done.",!
 Q
 ;******************************************************
MED ; Controls Medicine 2.0 install and disable 2.2 components
 N X,GMMSG
 ;Checks conditions for auto-disable of Medicine 2.2 components
 I $$VERSION^XPDUTL("MC")<2.2 D
 . S GMMSG="Medicine 2.2 Package not yet installed or available"
 . ;
 . ;IHS/ITSC/LJF 8/8/2003 new components have been released in patches since postinit was written
 . ;F X="MEDICINE ABNORMAL BRIEF","MEDICINE BRIEF REPORT","MEDICINE FULL CAPTIONED","MEDICINE FULL REPORT" D DISABLE^GMTSPOST
 . F X="MEDICINE ABNORMAL BRIEF","MEDICINE BRIEF REPORT","MEDICINE FULL CAPTIONED","MEDICINE FULL REPORT","MEDICINE SUMMARY" D DISABLE^GMTSPOST
 . ;IHS/ITSC/LJF 8/8/2003 end of mods
 . ;
 . ;If Medicine 2.2 not installed, restore 2.0 medicine routines
 . W !,"** Installing GMTSMCPS routine for Medicine 2.0 component. **"
 . D MED2INST
 I $$VERSION^XPDUTL("MC")>2.19 D M22INST
 Q
MED2INST ; Install GMTSMCPS routine for med 2.0
 Q   ;IHS/ITSC/LJF 8/14/2003 no longer works
 N DIE,DIF,GMMSG,X,XCN,XCNP
 S X="GMTSMCPZ",XCNP=0,DIF="^UTILITY(""GMTSMCPZ""," X ^%ZOSF("LOAD") W !,"Renaming GMTSMCPZ as GMTSMCPS."
 S X="GMTSMCPS",XCN=2,DIE="^UTILITY(""GMTSMCPZ""," X ^%ZOSF("SAVE") K ^UTILITY("GMTSMCPZ") W "  Done.",!
 Q
M22INST ; Install GMTSMCPS routine for med 2.2
 Q   ;IHS/ITSC/LJF 8/14/2003 no longer works
 W !,"** Installing GMTSMCPS routine for Medicine 2.2 components. **"
 N DIE,DIF,GMMSG,X,XCN,XCNP
 S X="GMTSMCZZ",XCNP=0,DIF="^UTILITY(""GMTSMCZZ""," X ^%ZOSF("LOAD") W !,"Renaming GMTSMCZZ as GMTSMCPS."
 S X="GMTSMCPS",XCN=2,DIE="^UTILITY(""GMTSMCZZ""," X ^%ZOSF("SAVE") K ^UTILITY("GMTSMCZZ") W "  Done.",!
 Q
 ;******************************************************
PL ; Controls Problem List 2.0 install
 ; Checks conditions for auto-disable of Problem List components
 N X,GMMSG
 I $$VERSION^XPDUTL("GMPL")<2 D
 . S GMMSG="Problem List 2.0 Package not yet installed or available"
 . F X="PROBLEM LIST ACTIVE","PROBLEM LIST INACTIVE","PROBLEM LIST ALL" D DISABLE^GMTSPOST
 I $$VERSION^XPDUTL("GMPL")>1.99 D
 . W !,"** Installing GMPLHS routine for Problem List components. **"
 . D PLINST
 Q
PLINST ; Install GMPLHS routine
 N DIE,DIF,GMMSG,X,XCN,XCNP
 W !,"Renaming GMTSPLSZ as GMPLHS."
 S X="GMTSPLSZ",XCNP=0,DIF="^UTILITY(""GMTSPLSZ""," X ^%ZOSF("LOAD") W "."
 S X="GMPLHS",XCN=2,DIE="^UTILITY(""GMTSPLSZ""," X ^%ZOSF("SAVE") K ^UTILITY("GMTSPLSZ") W "  Done."
 Q
CRIHS ;EP; Checks conditions auto-disable of Clinical Reminders
 ;IHS/ITSC/LJF 8/8/2003 added subroutine as clinical reminder components were released in patch #23
 N GMMSG,X
 S X="PXRM" X ^%ZOSF("TEST") Q:$T
 F X="CLINICAL REMINDERS BRIEF","CLINICAL REMINDERS DUE","CLINICAL REMINDERS MAINTENANCE","CLINICAL REMINDERS SUMMARY" S GMMSG="Clinical Reminders not yet available" D DISABLE^GMTSPOST
 Q
 ;
GAFIHS ;EP; Checks conditions for auto-dsable of GAF components
 ;IHS/ITSC/LJF 8/8/2003 added subroutine as clinical reminder components were released in patch #23
 N GMMSG,X
 S X="YSGAFAPI" X ^%ZOSF("TEST") Q:$T
 F X="GLOBAL ASSESSMENT FUNCTIONING" S GMMSG="GAF not yet available" D DISABLE^GMTSPOST
 Q
SCDIHS ;EP; Checks conditions for auto-dsable of Spinal Cord Dysfunction components
 ;IHS/ITSC/LJF 8/8/2003 added subroutine as clinical reminder components were released in patch #23
 N GMMSG,X
 S X="SPNHSO" X ^%ZOSF("TEST") Q:$T
 F X="SPINAL CORD DYSFUNCTION" S GMMSG="Spinal Cord Dysfunction not yet available" D DISABLE^GMTSPOST
 Q
 ;
MAS ;EP; checks if site has PIMS installed so MAS components can stay active
 ;IHS/ITSC/LJF 3/24/2004 added subroutine to disable MAS components
 N GMMSG,X,GMN
 S X="SDAM" X ^%ZOSF("TEST") Q:$T
 S GMN="MAS" F  S GMN=$O(^GMT(142.1,"B",GMN)) Q:GMN'["MAS"  Q:GMN=""  D
 . S X=GMN S GMMSG="PIMS V5.3 not yet installed" D DISABLE^GMTSPOST
 Q
