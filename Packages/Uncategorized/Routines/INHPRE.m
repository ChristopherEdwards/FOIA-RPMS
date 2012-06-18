INHPRE ;JSH; 13 Sep 1999 15:22;Interface - PreInit routine
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
EN ;Pre-init for subsystem
 S X="ERR^INHPRE",@^%ZOSF("TRAP")
 N INTITLE
 W !!,"Running Generic Interface Pre-Init..."
 D ENV^UTIL,ROU
 D BACKUP("4604 Inst")
 W !!
 ;
 Q
 ;
BACKUP(INTITLE) ;Backup control files
 ;
 I $D(^UTILITY("INSAVE",INTITLE)) D
 .  W !,"Backing up previous save of GIS environmental data for ",INTITLE,!
 .  N TTLSUB S TTLSUB=INTITLE_" PREV"
 .  M ^UTILITY("INSAVE",TTLSUB)=^UTILITY("INSAVE",INTITLE)
 K ^UTILITY("INSAVE",INTITLE)
 W !!,"Backing up GIS environmental data",!
 I '$$BACKUP^INHSYSUL(INTITLE) W !!,"Backup of GIS control files not complete!!!",!!
 Q
 ;
ROU ;Load routines in non CHCS v4.2 systems
 Q
 ;
 ;see if installing on non CHCS v4.2 system
 Q:$$SC^INHUTIL1
 W !!,"Performing non CHCS v4.2 initialization"
 N %S,%D,I,%S1,%D1
 S %S="INHUTSRD^INHUTDT^INHUTIL^INHDIPZ3^INHDWPR"
 S %D="UTSRD^UTDT^UTIL^DIPZ3^DWPR"
 W !!,"I will save the following routines:",!
 F I=1:1:$L(%S,"^") S %S1=$P(%S,"^",I),%D1=$P(%D,"^",I) W !,%S1_" ... will be saved as ... "_%D1
 W !!,"Do you wish to do this" S %="" D YN^DICN Q:%'=1
 F I=1:1:$L(%S,"^") S %S1=$P(%S,"^",I),%D1=$P(%D,"^",I) X "ZL @%S1 ZS @%D1" W !,%S1_" ... saved as ... "_%D1
 Q
 ;
ERR ;Error exit point
 W !,"Unexpected error occured in GIS Pre-Init routine:"
 W !,?5,$$GETERR^%ZTOS,!
 Q
