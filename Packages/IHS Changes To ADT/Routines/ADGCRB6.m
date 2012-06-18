ADGCRB6 ; IHS/ADC/PDW/ENM - A SHEET lines 12-14 ; [ 10/16/2000  1:58 PM ]
 ;;5.3;ADMISSION/DISCHARGE/TRANSFER;**3,1008**;MAR 25, 1999
 ;
 ;cmi/anch/maw 12/7/2007 patch 1008 added code set versioning H13,ICD
 ;
A ; -- driver
 I DGDS D H14,L14 Q
 D H12,L12,H13,H14,L14 Q
 ;
H12 ; -- sub heading 12
 W !,DGLIN1,!,"40 Injury Date  41 Alleged Injury Cause"
 W ?41,"42 E-Code",?51,"43 Place of Injury  44 Code",! Q
 ;
L12 ; -- data line 12 (injury data)
 Q:'$D(DGPOVDA)
 W ?3,$$IDT,?17,$P($$ICD,U,2),?44,$P($$ICD,U),?54,$$PLC
 W ?75,$P(DGPOVN0,U,11) Q
 ;
H13 ; -- underlying cause of death
 N DGN11 S DGN11=$G(^AUPNPAT(DFN,11)) ;IHS/DSD/ENM 10/19/99
 N X S X=$P(DGN11,U,14) Q:'X
 W !,DGLIN1,!,"47 Underlying Cause of Death & Code",!
 ;W ?49,$E($P(^ICD9(X,0),U,3),1,16),?67,$P(^(0),U) Q
 W ?49,$E($P($$ICDDX^ICDCODE(X),U,4),1,16),?67,$P($$ICDDX^ICDCODE(X),U,2) Q
 ;
H14 ; -- sub heading 14
 W !,DGLIN1,!,"49 Date Printed",?17,"50 Attending Physician"
 I DGDS W ?42,"50a Phys Code",?62,"51 Printed By",! Q
 W ?42,"50a Phys Code",?58,"51 Admit Clerk/Coder",! Q
 ;
L14 ; -- data line 14
 ;IHS/ITSC/ENM 10/16/2000 "Break Cmd removed"
 W ?4,$E(DT,4,5)_"/"_$E(DT,6,7)_"/"_$E(DT,2,3)
 I DGDS D  Q
 . W ?21,$P($$PRV,U),?47,$P($$PRV,U,2),?66,$P(^VA(200,DUZ,0),U,2),!
 W ?21,$P($$PRV,U),?47,$P($$PRV,U,2),?66,$$ADMCLK,$$CODER,! Q
 ;
IDT() ; -- injury date   
 N Y S Y=$P(DGPOVN0,U,13) Q:'Y "" X ^DD("DD") Q Y
 ;
ICD() ; -- cause of injury
 ;Q $P($G(^ICD9(+$P(DGPOVN0,U,9),0)),U)_U_$P($G(^(0)),U,3)
 Q $P($$ICDDX^ICDCODE(+$P(DGPOVN0,U,9)),U,2)_U_$P($$ICDDX^ICDCODE(+$P(DGPOVN0,U,9)),U,4)
 ;
PLC() ; -- place of injury
 N Y,C S Y=$P(DGPOVN0,U,11) Q:Y="" ""
 S C=^DD(9000010.07,.11,0) D Y^DIQ Q Y
 ;
PRV() ; -- provider name & code
 N X,Y,DA,DGAR,PROV
 S X=0 F  S X=$O(^AUPNVPRV("AD",DGVSDA,X)) Q:'X  D
 . Q:'$D(^AUPNVPRV(X,0))  S:$P(^(0),U,4)="P" DA=+^(0)
 I '$D(DA) Q ""
 I $P(^DD(9000010.06,.01,0),U,2)["200" S PROV=DA
 E  S PROV=$G(^DIC(16,DA,"A3")) I PROV="" Q ""
 K DGAR D ENP^XBDIQ1(200,PROV,".01;9999999.039","DGAR(")
 Q DGAR(.01)_U_DGAR(9999999.039)
 ;
ADMCLK() ; -- admitting clerk
 NEW X
 S X=$P($G(^DGPM(DGFN,"USR")),U) I X="" Q X
 Q $P($G(^VA(200,X,0)),U,2)
 ;
CODEROLD() ; -- coding clerk
 N DGX,DA,PROV,DGAR,ANS
 S DGX=0 F  S DGX=$O(^AUPNVPRV("AD",DGVSDA,DGX)) Q:'DGX!($D(ANS))  D
 . Q:'$D(^AUPNVPRV(DGX,0))  Q:$P(^(0),U,4)="P"  S DA=+^(0)
 . I $P(^DD(9000010.06,.01,0),U,2)["200" S PROV=DA
 . E  S PROV=$G(^DIC(16,DA,"A3")) Q:PROV=""
 . K DGAR D ENP^XBDIQ1(200,PROV,"1;53.5","DGAR(","I")
 . Q:DGAR(53.5)=""
 . Q:$$VAL^XBDIQ1(7,DGAR(53.5,"I"),9999999.01)'="88"
 . S ANS="/"_DGAR(1)
 Q $G(ANS)
 ;
CODER() ;-- coding clerk searhc/maw 4/17/98 
 N DGCD,DGX,DGXIEN
 S DGX=0 F  S DGX=$O(^APCDFORM("AB",DGVSDA,DGX)) Q:DGX=""  D
 . S DGXIEN=$O(^APCDFORM("AB",DGVSDA,DGX,0))
 . I '$D(^APCDFORM(DGX,11,DGXIEN,0)) S DGCD="" Q DGCD
 . S DGCD=$P(^APCDFORM(DGX,11,DGXIEN,0),U,2)
 . S DGCD=$P(^VA(200,DGCD,0),U,2)
 . S DGCD="/"_DGCD
 Q $G(DGCD) ;IHS/DSD/ENM 02/19/99
 ;
