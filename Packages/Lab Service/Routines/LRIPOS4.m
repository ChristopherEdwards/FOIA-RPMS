LRIPOS4 ;DALISC/FSH - LR POST INIT CONTINUED
 ;;5.2;LR;;NOV 01, 1997
 ;
 ;;5.2;LAB SERVICE;;Sep 27, 1994
 ;;LAB SERVICE;;
EN ; Rename 'LR' routines that were distributed on the tape to their
 ; proper 'SR' namespace
 W !!,"Moving exported 'LR' routines into Surgery name space.",!!
 S X="LROSPLG" X ^%ZOSF("TEST")
 I '$T W !!?5,"Can't find LROSPLG routine  - renaming ABORTED ",!,"CONTACT YOUR ISC ",! G LA
 S A="LR",B="SR"
 F J="OSPLG","OSPLG1","OSPLG2" X "ZL @(A_J) W !,""Loading "",A_J ZS @(B_J) W ?20,""Saving as "",B_J"
 W !!,"All routines restored ",!!
 ;
LA ;Update the AUTOMATED LAB INSTRUMENTS package file entry to the
 ;correct version number, if the LA init was not run
 N LA94,LADA,LADATE,X,Y
 S LA94=$O(^DIC(9.4,"C","LA",0))
 I 'LA94 D  QUIT
 . W !!,?5,"*** Could not find 'AUTOMATED LAB INSTRUMENTS' in your ***"
 . W !,?5,"*** package file, using the 'LA' namespace. You will   ***"
 . W !,?5,"*** need to manually update your PACKAGE file with the ***"
 . W !,?5,"*** correct version number (5.2).                      ***"
 I $O(^DIC(9.4,"C","LA",LA94)) D  QUIT
 . W !!,?5,"*** Found two entries in your PACKAGE file with the ***"
 . W !,?5,"*** namespace 'LA'.  You will need to update the    ***"
 . W !,?5,"*** correct AUTOMATED LAB INSTRUMENTS entry with    ***"
 . W !,?5,"*** the current version number (5.2).               ***"
 Q:$G(^DIC(9.4,LA94,"VERSION"))="5.2"
 W !!,?5,"Updating your AUTOMATED LAB INSTRUMENTS entry in the package"
 W !,?5,"file with the correct current version number (5.2)..."
 S X=$P($T(+2),";",6) ;get date distributed
 D ^%DT
 Q:'Y
 S LADATE=Y
 K DD,DO,DIC
 S DIC(0)="L",DLAYGO=9.4,DA(1)=LA94,DIC="^DIC(9.4,"_DA(1)_",22,"
 S DIC("P")=$P(^DD(9.4,22,0),"^",2)
 S X="5.2",DINUM=X
 D FILE^DICN ;add 5.2 version to multiple in PACKAGE file
 S LADA=+Y
 S DIE="^DIC(9.4,",DA=LA94,DR="13////5.2"
 D ^DIE ;update CURRENT VERSION
DIE K DIC,DIE,DA,DR
 S DA(1)=LA94,DA=LADA
 S DIE="^DIC(9.4,"_DA(1)_",22,"
 S DR="1////"_LADATE_";2////"_DT
 D ^DIE ;update DATE DISTRIBUTED and DATE INSTALLED AT THIS SITE
 QUIT
