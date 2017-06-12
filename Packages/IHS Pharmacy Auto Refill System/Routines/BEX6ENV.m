BEX6ENV ;IHS/CMI/DAY - BEX Patch 6 Environment Check ; 19 Apr 2015  11:17 AM
 ;;1.0;BEX TELEPHONE REFILL SYSTEM;**6**;APR 20, 2015;Build 7
 ;
 ;
 ;this routine will check for the existence of patch 5, a BEX core patch
 ;
 ;
PCHK ;-- check for previous patch
 K XPDQUIT
 S BEXGI=$O(^DIC(9.4,"B","BEX AUDIOCARE TELEPHONE REFILL",0))
 I '$G(BEXGI) D  Q
 . S XPDQUIT=1
 . W !!,"You need the Audiocare Telephone Refill System, Version 1.0, aborting",!
 S BEXVI=$O(^DIC(9.4,BEXGI,22,"B","1.0",0))
 I '$G(BEXVI) D  Q
 . S XPDQUIT=1
 . W !!,"You need the Audiocare Telephone Refill System, Version 1.0, aborting",!
 I '$O(^DIC(9.4,BEXGI,22,BEXVI,"PAH","B",5,0)) D
 . W !!,"You need BEX patch 5 to continue",!
 . S XPDQUIT=1
 Q
 ;
