AICDPREI ;CREATED BY AUBPI ON JUL 2,1990 ;
 ;;3.51;IHS ICD/CPT lookup & grouper;;MAY 30, 1991
 ;
TEST ; CHECK IF THIS VERSION ALREADY INSTALLED
 W !!,"- - - PREINIT FOR AICD PRE-VERSION 3.3 ONLY !! - - -",!
 S X=$O(^DIC(9.4,"C","AICD","")) I X,$D(^DIC(9.4,X,"VERSION")),^("VERSION")'<3.3 W !,*7,"Version 3.3 already installed - preINIT not run.",! Q
 ;
ASK ;
 W !
 W !,"This preINIT routine will"
 W !," Delete the ICD DX INACTIVATION CONTROL file"
 W !," Delete the ICD OP INACTIVATION CONTROL file"
 W !," Delete the options AICD INACT DX and AICD INACT OP"
 W !,"  and remove them from the AICDUSER menu option"
 W !," Delete the AICDCVT1 and AICDNACT routines"
 W !," Delete and reinstall the data dictionaries for files 80 and 80.1"
 W !
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="YES" D ^DIR K DIR
 I 'Y W !,*7,"PreINIT cancelled.",! Q
 W !
 ;
WORK ;
 D DELFILS
 D DELOPTS
 D DELRTNS
 D DELDICTS
 ;
DONE ;
 W !!,"Done with preinit!",!
 Q
 ;
DELFILS ; DELETE FILES
 W !,"Deleting ICD DX INACTIVATION CONTROL"
 S DIU=9001011,DIU(0)="D" D EN^DIU2
 W !,"Deleting ICD OP INACTIVATION CONTROL"
 S DIU=9001012,DIU(0)="D" D EN^DIU2
 Q
 ;
DELOPTS ; DELETE OPTIONS AND REMOVE FROM MENU 
 S AICDM=$O(^DIC(19,"B","AICDUSER",""))
 F AICDX="DX","OP" S AICDX="AICD INACT "_AICDX S (AICDOP,DA)=$O(^DIC(19,"B",AICDX,"")) I DA D DELOPT
 K AICDX,AICDM
 Q
DELOPT S DIK="^DIC(19," W !,"Deleting ",AICDX," option" D ^DIK S DA(1)=AICDM,DA=$O(^DIC(19,AICDM,10,"B",AICDOP,"")) I DA,DA(1) S DIK="^DIC(19,"_DA(1)_",10," D ^DIK
 Q
 ;
DELRTNS ; DELETE ROUTINES
 S X=$P(^DD("OS",^DD("OS"),0),U)
 I (X'["MICRONETICS"),(X'["DSM") W !,*7,"Use system utilities to delete routines AICDCVT1 and AICDNACT" R !,"Press RETURN to continue ...",X:300 Q
 W !,"Deleting routine AICDCVT1"
 X "ZR  ZS AICDCVT1"
 W !,"Deleting routine AICDNACT"
 X "ZR  ZS AICDNACT"
 Q
 ;
DELDICTS ;
 K ^UTILITY("AUDSET",$J) F AUBPI=1:1 S AUBPIX=$P($T(Q+AUBPI),";;",2) Q:AUBPIX=""  S AUBPIY=$P(AUBPIX,"=",2,99),AUBPIX=$P(AUBPIX,"=",1) S @AUBPIX=AUBPIY
 K AUBPI,AUBPIX,AUBPIY D EN2^%AUKD
Q Q
 ;;^UTILITY("AUDSET",$J,80)=S^S
 ;;^UTILITY("AUDSET",$J,80.1)=S^S
 ;;^UTILITY("AUDSET",$J,80.2)=S^S
 ;;^UTILITY("AUDSET",$J,80.3)=S^S
 ;;^UTILITY("AUDSET",$J,9001010)=S^S
