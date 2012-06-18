BWCDC ;IHS/ANMC/MWR - INITIAL LOAD OF CDC IDS & FLAGS;15-Feb-2003 21:49;PLS
 ;;2.0;WOMEN'S HEALTH;**8**;MAY 16, 1996
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  FOR FIRST TIME INSTALL OF V 2.0 AT SITES THAT WILL EXPORT TO CDC.
 ;;  ASSIGNS UNIQUE PATIENT IDS, FLAGS ALL PAST APPROPRIATE PROCEDURES.
 ;
FLAGEXP ;EP
 D SETVARS^BWUTL5
 ;---> FLAG ALL APPROPRIATE PROCEDURES FOR CDC EXPORT.
 W !!,"Flagging all appropriate past procedures for CDC export.",!
 ;---> *********************************
 ;---> REMOVE THESE LINES AFTER ANMC.
 ;K ^BWPCD("ACDC")
 ;---> *********************************
 S (BWCOUNT,N)=0
 F  S N=$O(^BWPCD(N)) Q:'N  D
 .S Y=^BWPCD(N,0),BWIEN=$P(Y,U,4)
 .D:$$CDCEXP^BWUTL5(BWIEN,DUZ(2))
 ..W "."
 ..;---> *********************************
 ..;---> UNCOMMENT NEXT QUIT 2 LINES BELOW?
 ..;---> *********************************
 ..;---> QUIT IF IT HAS ALREADY BEEN EXPORTED OR ALREADY FLAGGED.
 ..;Q:$P(Y,U,16)]""  Q:$P(Y,U,17)]""
 ..S DR=".17////1"
 ..D DIE^BWFMAN(9002086.1,DR,N,.BWPOP,1) S:'BWPOP BWCOUNT=BWCOUNT+1
 ;
 W !,BWCOUNT," procedures flagged for CDC export."
 W !,"Done.",!
 D KILLALL^BWUTL8
