BEX5ENV ;IHS/CMI/DAY - BEX Patch 5 Environment Check ; 12 Mar 2012  4:20 PM
 ;;1.0;BEX TELEPHONE REFILL SYSTEM;**1,2,4,5**;MAR 12, 2012;Build 1
 ;
 ;
 ;this routine will check for the existence of patch 4, a BEX core patch
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
 I '$O(^DIC(9.4,BEXGI,22,BEXVI,"PAH","B",4,0)) D
 . W !!,"You need BEX patch 4 to continue",!
 . S XPDQUIT=1
 Q
 ;
