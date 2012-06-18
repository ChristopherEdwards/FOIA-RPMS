ADGAD4 ; IHS/ADC/PDW/ENM - A&D UPDATE ADT CENSUS-WARD ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ; Variables PD, RD used by VA G&L routines.
 ;
 N TS,WD
 L +^ADGWD:1 I '$T Q
 L +^ADGTX:1 I '$T Q
A ; -- main
 D LW Q
 ;
LW ; -- loop wards w/activity
 S WD=0 F  S WD=$O(DGWD(WD)) Q:'WD  D
 . S:'$D(^ADGWD(WD,0)) ^(0)=WD,^(1,0)="^9009011.01D"
 . I '$D(^ADGWD(WD,1,RD)) D
 .. S $P(^ADGWD(WD,1,0),U,3,4)=RD_U_($P($G(^(0)),U,4)+1)
 . S ^ADGWD(WD,1,RD,0)=RD_U_$$PR_U_DGWD(WD)
 . S $P(^ADGWD(WD,1,RD,0),U,12)=$$NPR,^(0)=^(0)_U_DGWD("NB",WD)
 . S ^ADGWD("AB",RD,WD,RD)=""
 Q
 ;
PRP() ; -- patients remaining, previous
 Q $P($G(^ADGWD(WD,1,PD,0)),U,2)
 ;
NPRP() ; -- newborn patients remaining, previous
 Q $P($G(^ADGWD(WD,1,PD,0)),U,12)
 ;
PR() ; -- patients remaining
 Q $$PRP+$P(DGWD(WD),U)-$P(DGWD(WD),U,2)+$P(DGWD(WD),U,3)-$P(DGWD(WD),U,4)-$P(DGWD(WD),U,5)
 ;
NPR() ; -- newborn patients remaining
 Q $$NPRP+$P(DGWD("NB",WD),U)-$P(DGWD("NB",WD),U,2)+$P(DGWD("NB",WD),U,3)-$P(DGWD("NB",WD),U,4)-$P(DGWD("NB",WD),U,5)
