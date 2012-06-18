ASUUCLEN ; IHS/ITSC/LMH - USED TO CLEAN UP VARIABLES ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine cleans up arrays left over from transactions entered 
 ;while in SCREENMAN.  This routine is called for an OPTION (menu) as
 ;it exits the entry screen.
EN ;EP ;PRIMARY ENTRY POINT
 N TYPE S TYPE=""
 S TYPE=$O(ASUT(TYPE))
 I TYPE="DUE" D DUE
 I TYPE="IDX" D IDX
 Q
DUE ;
 K ASUL(11),ASUL(17)
 Q
IDX ;
 Q
