BMCRCHK ; IHS/PHXAO/TMJ - Check Provisional Primary DX ;
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ;This routine checks to insure at least one of the DX's is Primary
 ;If no Primary Dx exists or more than one Do DX OF BMCMOD
 ;to edit existing DX's
 ;
START ;Order through the RCIS DX Gbl
 Q:'$D(^BMCDX("AD",BMCRIEN))
 K BMCDX
 D DXCHK
 D DXMSG
 D END
 Q
 ;
DXCHK ;Check Diagnosis Entries
 S BMCDXASK=0
 S BMCDXCT=0
 S BMCDX=""
 F  S BMCDX=$O(^BMCDX("AD",BMCRIEN,BMCDX)) Q:BMCDX'=+BMCDX  D
 .I $P(^BMCDX(BMCDX,0),U,5)="P" S BMCDXCT=BMCDXCT+1
 .Q
 Q
DXMSG ;Check if Primary DX Exists
 I BMCDXCT=0 W !!,"WARNING-No Primary Diagnosis exists for this Referral-Please enter a Primary DX",!,$C(7) H 5 S BMCDXASK=1
 E  I BMCDXCT>1 W !!,"Multiple Primary Diagnosis exist for this Referral-Only one please",!,$C(7) H 5 S BMCDXASK=1
 ;H 5
 Q
END ;Kill Variables
 K BMCDX,BMCDXIEN,BMCDXCT
 Q
 ;
