BMCRCHK1 ; IHS/PHXAO/TMJ - Check Provisional Primary Procedures PX ;
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ;This routine checks to insure at least one of the PX's is Primary
 ;If no Primary Px exists or more than one Do PROC OF BMCMOD
 ;to edit existing PX's
 ;
START ;Order through the RCIS PX Gbl
 Q:'$D(^BMCPX("AD",BMCRIEN))
 K BMCPX
 D PXCHK
 D PXMSG
 D END
 Q
 ;
PXCHK ;Check Procedure Entries
 S BMCPXASK=0
 S BMCPXCT=0
 S BMCPX=""
 F  S BMCPX=$O(^BMCPX("AD",BMCRIEN,BMCPX)) Q:BMCPX'=+BMCPX  D
 .I $P(^BMCPX(BMCPX,0),U,5)="P" S BMCPXCT=BMCPXCT+1
 .Q
 Q
PXMSG ;Check if Primary PX Exists
 I BMCPXCT=0 W !!,"WARNING-No Primary Procedure exists for this Referral-Please enter a Primary PX",!,$C(7) H 5 S BMCPXASK=1
 E  I BMCPXCT>1 W !!,"Multiple Primary Procedure exist for this Referral-Only one please",!,$C(7) H 5 S BMCPXASK=1
 ;H 5
 Q
END ;Kill Variables
 K BMCPX,BMCPXIEN,BMCPXCT
 Q
 ;
