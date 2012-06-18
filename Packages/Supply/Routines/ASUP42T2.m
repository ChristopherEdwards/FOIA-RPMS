ASUP42T2 ; 06/05/2000  2:49 PM ]  
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;
 ;****************************************************************
 ;***** This subroutine will reactivate the following options *******
 ;***** ASU03JCPBO,ASU527SDRP,ASU5270DRP,ASU5271DRP,ASU5173DRP ***
 ;************ ASU826PPIB, ASU024TRCT & ASU036TISS *************** 
 ;****************************************************************
FIXOPTNS ;
 S DIE="^DIC(19,"             ;Set up option file
 S ASUMENU=0
 F  S ASUMENU=$O(^DIC(19,ASUMENU)) S TEMP=^DIC(19,ASUMENU,0) Q:'ASUMENU  D
 .I ($P(TEMP,U)="ASU024TRCT")!($P(TEMP,U)="ASU03JCPBO")!($P(TEMP,U)="ASU5270DRP")!($P(TEMP,U)="ASU527SDRP")!($P(TEMP,U)="ASU5271DRP")!($P(TEMP,U)="ASU5173DRP")!($P(TEMP,U)="ASU826PPIB")!($P(TEMP,U)="ASU034TISS")!($P(TEMP,U)="ASU036TISS")  D
 ..I $P(TEMP,U,3)'=""  D
 ...S DA=ASUMENU
 ...S DR="2///@"
 ...D ^DIE
FIXHIST ;
 ;***************************************************************
 ;*** This subroutine will delete and reindex the corrupt******** 
 ;*********************** ASUH records. *************************
 ;***************************************************************
 ;
 S ASUHCRPT=0
 F  S ASUHCRPT=$O(^ASUH(ASUHCRPT)) Q:'ASUHCRPT  D
 .I ASUHCRPT["." S DA=ASUHCRPT,DIK="^ASUH(" D ^DIK
