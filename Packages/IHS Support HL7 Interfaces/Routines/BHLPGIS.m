BHLPGIS ; cmi/flag/maw - BHL Purge Dynamic GIS Files ;
 ;;3.01;BHL IHS Interfaces with GIS;**1**;JUN 01, 2002
 ;
 ;
 ;this routine will purge all entries in the following globals
 ;^INTHL7M, ^INTHL7F, ^INTHL7S, ^INTRHT, ^INRHD, ^INTHPC, ^INRHS
 ;it should only be used if no modifications were made to the 
 ;original GIS system
 ;
MAIN ;ep - this is the main routine driver
 D LOOP
 D EOJ
 Q
 ;
LOOP ;-- loop through the globals and call DIK
 F BHLFNUM=4000,4004,4005,4006,4010,4011,4012 D  Q:'BHLFNUM
 . S BHLGL=$P($G(^DIC(BHLFNUM,0,"GL")),"(")
 . S BHLGLE=$G(^DIC(BHLFNUM,0,"GL"))
 . S BHLDA=0 F  S BHLDA=$O(@BHLGL@(BHLDA)) Q:'BHLDA  D
 .. D DIK(BHLGLE,BHLDA)
 Q
 ;
DIK(FNM,DA) ;-- kill the entry
 S DIK=FNM D ^DIK
 K DIK,DA
 Q
 ;
EOJ ;-- kill variables
 D ^XBFMK
 D EN^XBVK("BHL")
 Q
 ;
