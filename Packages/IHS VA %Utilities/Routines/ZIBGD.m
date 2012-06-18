ZIBGD ; IHS/ADC/GTH - DIRECTORY OF SELECTED GLOBALS ; [ 12/29/2004  11:25 AM ]
 ;;3.0;IHS/VA UTILITIES;**9,10**;FEB 07, 1997
 ;XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Cache' mods.
 ;
 ;  This routine displays a selected range or sub-set
 ;  of the global directory.
 ;
 ;  Save, or copy, to the MGR uci as %ZIBGD, or %AZGD.
 ;
 ;  Thanks to Don Enos, OHPRD, for the original routine.
 ;
 ; I $G(^%ZOSF("OS"))'["MSM" W $C(7),!,"Sorry....",!,"Operating System '",$P(^%ZOSF("OS"),"^",1),"' is not supported." Q ;IHS/SET/GTH XB*3*9 10/29/2002
 I $G(^%ZOSF("OS"))'["MSM",'($$VERSION^%ZOSV(1)["Cache") W $C(7),!,"Sorry....",!,"Operating System '",$P(^%ZOSF("OS"),"^",1),"' is not supported." Q  ;IHS/SET/GTH XB*3*9 10/29/2002
 ;
 ;Begin New Code;IHS/SET/GTH XB*3*9 10/29/2002
 I $$VERSION^%ZOSV(1)["Cache" D CA Q
 ;End New Code;IHS/SET/GTH XB*3*9 10/29/2002
MSM ; Micronetics
 D ^%GSEL
 G:%GSEL=0 MSMQ
 S %GSN=1
 D ^%GSEL2
 G MSM ;IHS/SET/GTH XB*3*9 10/29/2002
MSMQ ;
 KILL %GN,%GSEL,%GSN,%GTEMP,%I,%J1
 Q
 ;
 ;Begin New Code;IHS/SET/GTH XB*3*9 10/29/2002
CA ;
 ;D ^%GSET     ;TASSC/MFD obsolete
 S %G=$$Select^%GSETNS    ;TASSC/MFD new call
 G:%G=0 CAQ
 NEW ZIBI,ZIBNAM
 S ZIBNAM=""
 F ZIBI=0:1 S ZIBNAM=$O(^%utility($J,ZIBNAM)) Q:ZIBNAM=""   W:'(ZIBI#8) ! W ZIBNAM_$J("",9-$L(ZIBNAM))              ;TASSC/MFD changed UTILITY to %utility for Cache
 W !,?5,ZIBI," Globals",!
 KILL ZIBI,ZIBNAM
 G CA
 ;
CAQ ;
 K %G,%JO,NSPNAM
 Q
 ;End New Code;IHS/SET/GTH XB*3*9 10/29/2002
