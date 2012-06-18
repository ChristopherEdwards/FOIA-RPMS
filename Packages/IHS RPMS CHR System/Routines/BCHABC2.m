BCHABC2 ; IHS/TUCSON/LAB - EDIT/DELETE PCC VISIT FROM CHR RECORD ;  [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
 ;
 ;If a CHR Record is edited, this routine is called to modify
 ;or create the associated PCC visit.
 ;All V Files are deleted, the visit entry modified and the
 ;V File entries recreated.
 ;
E ;EP - edited a chr record
 I '$G(BCHEV("VFILES",9000010)) S BCHEV("TYPE")="A" D A^BCHABCH Q  ;no pcc visit ever created to edit, act like add
 S BCHVSIT=BCHEV("VFILES",9000010)
 D DELVFS
 I $P(^AUPNVSIT(BCHVSIT,0),U,11) S BCHEV("TYPE")="A" D A^BCHABCH Q  ;if pcc visit gone get rid of 15th, v file multiple and then act like add
 ;if not deleted, do visit mod and then re-add vfiles
 S APCDALVR("APCDVSIT")=BCHVSIT
 S APCDALVR("APCDATMP")="[APCDALVR 9000010 (MOD)]"
 D VISIT^BCHABCH
 D ^APCDALVR
 I $D(APCDALVR("APCDAFLG")) S BCHQUIT=28 D VSERROR^BCHABCH Q
 D VFILES^BCHABC1
 S BCHV("9000010")=BCHVSIT
 D COMPLETE^BCHALD
 Q
D ;EP chr visit deleted
 I '$G(BCHEV("VFILES",9000010)) Q  ;no visit to begin with
 S BCHVSIT=BCHEV("VFILES",9000010)
 D DELVFS
 Q
DELVFS ;delete vfiles
 S BCHF=0 F  S BCHF=$O(BCHEV("VFILES",BCHF)) Q:BCHF'=+BCHF  D
 .S BCHN=0 F  S BCHN=$O(BCHEV("VFILES",BCHF,BCHN)) Q:BCHN'=+BCHN  S DA=BCHN,DIK=^DIC(BCHF,0,"GL") D ^DIK
 .K DA,DIK
 .Q
 I '$P(^AUPNVSIT(BCHVSIT,0),U,9),'$P(^(0),U,11) S APCDVDLT=BCHVSIT D ^APCDVDLT K APCDVDLT ;if no dependent entries delete visit
 K BCHF,BCHN,BCHVDLT
 Q
