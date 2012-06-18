BWPATCH6 ;IHS/CMI/LAB - BW PATCH 6 [ 07/27/99  10:55 AM ];15-Feb-2003 22:03;PLS
 ;;2.0;WOMEN'S HEALTH;**6,8**;MAY 16, 1996
 ;
 ;Adds 3 indexes to the bw procedure file
 ;and sets the indexes
 ;
 W !!,"Women's Health Patch 6.",!
 W !,"Adds 3 new indexes to the BW Procedure file for QMAN.",!
 ;
 W !,"I will now reindex 3 indices.  This may take a while.",!
 S DIK="^BWPCD(",DIK(1)=".03^AA^AC" D ENALL^DIK
 S DIK="^BWPCD(",DIK(1)="5.01^AD" D ENALL^DIK
 ;
 NEW X
 S X=$$ADD^XPDMENU("BW MENU-MANAGER'S FUNCTIONS","BW PRINT REPRINT LETTERS","RPL",7)
 I 'X W "Attempt to add General Retrieval to WH Reports Menu Failed" H 3
 ;Adds the general retrieval to the man reports menu
 ;
 NEW X
 S X=$$ADD^XPDMENU("BW MENU-MANAGEMENT REPORTS","BWGR REPORT GENERAL RETRIEVAL","GR",6)
 I 'X W "Attempt to add General Retrieval to WH Reports Menu Failed" H 3
 W !,"All Done"
 Q
