BEX2ENV ;cmi/anchorage/maw - BEX Patch 2 Environment Check [ 03/02/2010  11:03 AM ]
 ;;1.0;BEX TELEPHONE REFILL SYSTEM;**1,2,4**;DEC 01, 2009
 ;
 ;
 ;this routine will check for the existence of patch 1, a BEX core patch
 ;
 ;
ELEVEN ;-- check for patch 11
 K XPDQUIT
 S BEXGI=$O(^DIC(9.4,"B","BEX AUDIOCARE TELEPHONE REFILL",0))
 I '$G(BEXGI) D  Q
 . S XPDQUIT=1
 . W !!,"You need the Audiocare Telephone Refill System, Version 1.0, aborting",!
 S BEXVI=$O(^DIC(9.4,BEXGI,22,"B","1.0",0))
 I '$G(BEXVI) D  Q
 . S XPDQUIT=1
 . W !!,"You need the Audiocare Telephone Refill System, Version 1.0, aborting",!
 I '$O(^DIC(9.4,BEXGI,22,BEXVI,"PAH","B",1,0)) D
 . W !!,"You need BEX patch 1 to continue",!
 . S XPDQUIT=1
 Q
 ;
