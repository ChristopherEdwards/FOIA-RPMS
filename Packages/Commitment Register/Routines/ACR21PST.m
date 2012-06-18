ACR21PST ;IHS/OIRM/DSD/AEF - VERSION 2.1 POST INSTALL ROUTINE [ 11/01/2001  10:01 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;;NOV 05, 2001
 ;
EN ;EP -- MAIN ENTRY POINT
 ;
 D ^XBKVAR
 D COMP
 D SYSDEF
 D SCRIPT1
 Q
COMP ;----- COMPILE PRINT TEMPLATES
 ;
 ;      This subroutine recompiles all the compiled ARMS print
 ;      templates
 ;
 N ACRIEN,ACRTEMP,DMAX,X,Y
 D BMES^XPDUTL("Recompiling print templates...")
 S ACRTEMP="ACR"
 F  S ACRTEMP=$O(^DIPT("B",ACRTEMP)) Q:ACRTEMP']""  Q:$E(ACRTEMP,1,3)'="ACR"  D
 . S ACRIEN=0
 . F  S ACRIEN=$O(^DIPT("B",ACRTEMP,ACRIEN)) Q:'ACRIEN  D
 . . S X=$P($G(^DIPT(ACRIEN,"ROU")),U,2)
 . . Q:X']""
 . . S Y=ACRIEN
 . . S DMAX=$$ROUSIZE^DILF
 . . D EN^DIPZ
 Q
SYSDEF ;----- UPDATE SYSTEM DEFAULTS
 ;
 ;      This update copies the Agency Location Code and
 ;      Regional Finance Center code from the 1166 AFP SYSTEM
 ;      PARAMETERS file to the FMS SYSTEM DEFAULTS file.
 ;
 N ACRALC,ACRECS,ACRRFC,ACRSYS,DA,DIE,DR,X,Y
 D BMES^XPDUTL("Updating System Defaults...")
 S ACRSYS=$O(^AFSLPRM(0))
 I 'ACRSYS D  Q
 . D BMES^XPDUTL("Can't locate AGENCY LOCATION CODE or REGIONAL")
 . D BMES^XPDUTL("FINANCE CENTER, please notify developer.")
 S ACRALC=$P($G(^AFSLPRM(ACRSYS,2)),U,2)
 S ACRRFC=$P($G(^AFSLPRM(ACRSYS,2)),U,3)
 S ACRECS="/usr/spool/afsdata/"
 S DA=0
 F  S DA=$O(^ACRSYS(DA)) Q:'DA  D
 . S DIE="^ACRSYS("
 . S DR="402.1///^S X=ACRALC;402.2///^S X=ACRRFC;402.3///^S X=ACRECS"
 . D ^DIE
 Q
SCRIPT1 ;----- INSTALL odocget UNIX SCRIPT
 ;
 ;      Copies UNIX script contained in file acr_0210.s1 to
 ;      /usr/spool/afsdata/odocget
 ;
 N ACRDIR,ACRPATH,X,Y
 D BMES^XPDUTL("Installing odocget UNIX script")
 S X=$$TERMINAL^%HOSTCMD("pwd > acrdir")
 D OPEN^%ZISH("FILE","","acrdir","R")
 I POP D  Q
 . D BMES^XPDUTL("Unable to install 'odocget' UNIX script")
 . D BMES^XPDUTL("Please notify developer")
 U IO
 R X:DTIME
 S ACRDIR=X
 D CLOSE^%ZISH("FILE")
 S X=$$TERMINAL^%HOSTCMD("rm acrdir")
 ;
 S X=$$TERMINAL^%HOSTCMD("find /  acr_0210.s1 > acr1 2>&1")
 S X=$$TERMINAL^%HOSTCMD("cat acr1 | grep acr_0210.s1 > acr2")
 D OPEN^%ZISH("FILE","","acr2","R")
 I POP D  Q
 . D BMES^XPDUTL("Unable to install 'odocget' UNIX script")
 . D BMES^XPDUTL("Please notify developer")
 U IO
 R X:DTIME
 S ACRPATH=X
 S ACRPATH=$P(X,"/",1,$L(X,"/")-1)
 D CLOSE^%ZISH("FILE")
 S X=$$TERMINAL^%HOSTCMD("rm acr1")
 S X=$$TERMINAL^%HOSTCMD("rm acr2")
 ;
 S X=$$TERMINAL^%HOSTCMD("cp "_ACRPATH_"/acr_0210.s1"_" /usr/spool/afsdata/odocget")
 S X=$$TERMINAL^%HOSTCMD("chmod a+x /usr/spool/afsdata/odocget")
 Q
