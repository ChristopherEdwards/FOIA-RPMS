NUR13PST ; HCIOFO/MD-Post-Init for Patch 13 ;3/10/98
 ;;4.0;NURSING SERVICE;**13**;Apr 25, 1997
 S NURY=$P($G(^DIC(213.9,1,0)),U,2) G QUIT:$G(NURY)=""
 G:$D(^%ZIS(1,NURY)) QUIT
 I $G(NURY)="" D BMES^XPDUTL("A printer device should entered in the NURS PARAMETER (#213.9) CNO PRINTER (#2) Field.")
 I '$D(^%ZIS(1,"B",NURY)) S DIE=213.9,DA=1,DR="2///@" D ^DIE K DIE G QUIT D BMES^XPDUTL("INVALID DATA has been removed from NURS PARAMETER (#213.9) File CNO PRINTER (#2) Field which is now NULL.")
 D BMES^XPDUTL("Updating NURS PARAMETER (#213.9) File CNO PRINTER (#2) Field to DEVICE File pointer...")
 S NURX=$O(^%ZIS(1,"B",NURY,0)),DIE=213.9,DA=1,DR="2///^S X=NURX" D ^DIE K DIE
QUIT K DA,DR,NURY,NURX
 D BMES^XPDUTL("Done")
 Q
 ;
