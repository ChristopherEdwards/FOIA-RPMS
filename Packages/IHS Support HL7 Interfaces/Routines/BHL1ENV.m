BHL1ENV ;cmi/flag/maw - BHL Generic Environment Check [ 10/10/2002  10:44 PM ]
 ;;3.01;BHL IHS Interfaces with GIS;**2**;OCT 15, 2002
 ;
 ;        
 ;
 ;this routine will serve as a generic kids environment check
 ;it will look for the appropriate patches to be installed
 ;
CHK ;-- check the following patch(s) to make sure they are there
 K XPDQUIT
 S BHLGI=$O(^DIC(9.4,"B","GENERIC INTERFACE SYSTEM",0))
 I '$G(BHLGI) D  Q
 . S XPDQUIT=1
 . W !!,"You need the Generic Interface System version 3.01, aborting",!
 S BHLVI=$O(^DIC(9.4,BHLGI,22,"B",3.01,0))
 I '$G(BHLVI) D  Q
 . S XPDQUIT=1
 . W !!,"You need the Generic Interface System version 3.01, aborting",!
 I '$O(^DIC(9.4,BHLGI,22,BHLVI,"PAH","B",1,0)) D
 . W !!,"You need all GIS patches through patch 1 to continue",!
 . S XPDQUIT=1
 . K BHLGI,BHLVI
 Q
 ;
