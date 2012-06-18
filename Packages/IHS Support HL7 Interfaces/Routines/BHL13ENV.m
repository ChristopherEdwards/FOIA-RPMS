BHL13ENV ;cmi/anchorage/maw - BHL Patch 11 Environment Check
 ;;3.01;BHL IHS Interfaces with GIS;**14,15,16**;AUG 01, 2004
 ;
 ;
 ;this routine will check for the existence of patch 11, a GIS core patch
 ;and patch 13 reference lab patch
 ;
ELEVEN ;-- check for patch 11
 K XPDQUIT
 S BHLGI=$O(^DIC(9.4,"B","GENERIC INTERFACE SYSTEM",0))
 I '$G(BHLGI) D  Q
 . S XPDQUIT=1
 . W !!,"You need the Generic Interface System version 3.01, aborting",!
 S BHLVI=$O(^DIC(9.4,BHLGI,22,"B",3.01,0))
 I '$G(BHLVI) D  Q
 . S XPDQUIT=1
 . W !!,"You need the Generic Interface System version 3.01, aborting",!
 I '$O(^DIC(9.4,BHLGI,22,BHLVI,"PAH","B",2,0)) D
 . W !!,"You need all GIS patches through patch 2 to continue",!
 . S XPDQUIT=1
 I '$O(^DIC(9.4,BHLGI,22,BHLVI,"PAH","B",11,0)) D
 . W !!,"You need GIS patch 11 to continue",!
 . S XPDQUIT=1
 I '$O(^DIC(9.4,BHLGI,22,BHLVI,"PAH","B",13,0)) D
 . W !!,"You need GIS patch 13 to continue",!
 . S XPDQUIT=1
 Q
 ;
