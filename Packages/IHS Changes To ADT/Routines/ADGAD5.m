ADGAD5 ; IHS/ADC/PDW/ENM - A&D UPDATE ADT CENSUS-TS ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ; Variables PD, RD used by VA G&L routines.
 ;
 N TS,WD
A ; -- main
 D ADU,PED,LOS Q
 ;
ADU ; -- adult ts
 S TS=0 F  S TS=$O(DGTSA(TS)) Q:'TS  D
 . Q:'$$AS  S:'$D(^ADGTX(TS,0)) ^(0)=TS
 . I '$D(^ADGTX(TS,1,RD)) D
 .. S $P(^ADGTX(TS,1,0),U,3,4)=RD_U_($P($G(^(0)),U,4)+1)
 . S ^ADGTX(TS,1,RD,0)=RD_U_$$PRA_U_DGTSA(TS) S:'$D(^(1)) ^(1)=""
 Q
 ;
PED ; -- ped ts
 S TS=0 F  S TS=$O(DGTSP(TS)) Q:'TS  D
 . Q:'$$AS  S:'$D(^ADGTX(TS,0)) ^(0)=TS
 . I '$D(^ADGTX(TS,1,RD)) D
 .. S $P(^ADGTX(TS,1,0),U,3,4)=RD_U_($P($G(^(0)),U,4)+1)
 .. S ^ADGTX(TS,1,RD,0)=RD
 . S ^ADGTX(TS,1,RD,1)=$$PRP_U_DGTSP(TS)
 Q
 ;
LOS ; -- length of stay
 ;--ward
 S WD=0 F  S WD=$O(^ADGWD(WD)) Q:'WD  D
 . S:$D(^ADGWD(WD,1,RD,0))#2 $P(^(0),U,9)=DGLWD(WD)
 . S:$D(^ADGWD(WD,1,RD,0))#2 $P(^(0),U,19)=DGLWD("NB",WD)
 ;--adult
 S TS=0 F  S TS=$O(^ADGTX(TS)) Q:'TS  D
 . Q:'$$AS  S:$D(^ADGTX(TS,1,RD,0))#2 $P(^(0),U,9)=DGLTSA(TS)
 ;--ped
 S TS=0 F  S TS=$O(^ADGTX(TS)) Q:'TS  D
 . Q:'$$AS  S:$D(^ADGTX(TS,1,RD,1))#2 $P(^(1),U,8)=DGLTSP(TS)
 Q
 ;
PRAP() ; -- patients remaining, adult, previous
 Q $P($G(^ADGTX(TS,1,PD,0)),U,2)
 ;
PRA() ; -- patients remaining, adult
 N X S X=$$PRAP+$P(DGTSA(TS),U)-$P(DGTSA(TS),U,2)
 Q X+$P(DGTSA(TS),U,3)-$P(DGTSA(TS),U,4)-$P(DGTSA(TS),U,5)
 ;
PRPP() ; -- patients remaining, ped, previous
 Q $P($G(^ADGTX(TS,1,PD,1)),U)
 ;
PRP() ; -- patients remaining, ped
 N X S X=$$PRPP+$P(DGTSP(TS),U)-$P(DGTSP(TS),U,2)
 Q X+$P(DGTSP(TS),U,3)-$P(DGTSP(TS),U,4)-$P(DGTSP(TS),U,5)
 ;
AS() ; -- admitting service (yes=1, no=0)
 Q $S($P($G(^DIC(45.7,+TS,9999999)),U,3)="Y":1,1:0)
