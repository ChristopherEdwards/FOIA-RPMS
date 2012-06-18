BCHFORM ; IHS/TUCSON/LAB - ASSIGN UNIQUE FORM # ;  [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
 ;
 ;Called from a cross reference in CHR Record.
 ;Generates next form # for a chr on a particular date.
 ;
EN ;EP - called from xbnew
 S DIE="^BCHR(",DA=%,DR=".25///"_%1 D ^DIE
 Q
SET1 ;EP - called form data dictionary cross reference
 Q:$P(^BCHR(DA,0),U,3)=""
 Q:$P(^BCHR(DA,0),U,2)=""
 NEW %1 S (%,%1)="" F  S %=$O(^BCHR("AF",$P(^BCHR(DA,0),U,3),$P(^(0),U,2),$P(X,"."),%)) Q:%'=+%  S %1=%
 ;call xbnew
 S %1=%1+1,%=DA
 D ^XBNEW("EN^BCHFORM:%;%1")
 Q
KILL1 ;EP
 Q:$P(^BCHR(DA,0),U,3)=""
 Q:$P(^BCHR(DA,0),U,2)=""
 Q:$P(^BCHR(DA,0),U,25)=""
 K ^BCHR("AF",$P(^BCHR(DA,0),U,3),$P(^(0),U,2),$P(X,"."),$P(^(0),U,25),DA)
 Q
SET2 ;EP - called form data dictionary cross reference
 Q:$P(^BCHR(DA,0),U,3)=""
 Q:$P(^BCHR(DA,0),U)=""
 NEW %1 S (%,%1)="" F  S %=$O(^BCHR("AF",$P(^BCHR(DA,0),U,3),X,$P($P(^(0),U),"."),%)) Q:%'=+%  S %1=%
 ;call xbnew
 S %1=%1+1,%=DA
 D ^XBNEW("EN^BCHFORM:%;%1")
 Q
KILL2 ;EP
 Q:$P(^BCHR(DA,0),U,3)=""
 Q:$P(^BCHR(DA,0),U)=""
 Q:$P(^BCHR(DA,0),U,25)=""
 K ^BCHR("AF",$P(^BCHR(DA,0),U,3),X,$P($P(^(0),U),"."),$P(^(0),U,25),DA)
 Q
SET3 ;EP - called form data dictionary cross reference
 Q:$P(^BCHR(DA,0),U)=""
 Q:$P(^BCHR(DA,0),U,2)=""
 NEW %1 S (%,%1)="" F  S %=$O(^BCHR("AF",X,$P(^BCHR(DA,0),U,2),$P($P(^(0),U),"."),%)) Q:%'=+%  S %1=%
 ;call xbnew
 S %1=%1+1,%=DA
 D ^XBNEW("EN^BCHFORM:%;%1")
 Q
KILL3 ;EP
 Q:$P(^BCHR(DA,0),U)=""
 Q:$P(^BCHR(DA,0),U,2)=""
 Q:$P(^BCHR(DA,0),U,25)=""
 K ^BCHR("AF",X,$P(^BCHR(DA,0),U,2),$P($P(^(0),U),"."),$P(^(0),U,25),DA)
 Q
