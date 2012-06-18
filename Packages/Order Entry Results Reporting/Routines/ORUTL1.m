ORUTL1 ; slc/dcm - OE/RR Utilities ;6/7/91  08:47
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**11,66**;Dec 17, 1997
LOC ;Hospital Location Look-up
 N DIC,ORIA,ORRA
 S DIC=44,DIC(0)="AEQM",DIC("S")="I '$P($G(^(""OOS"")),""^"")"
 D ^DIC
 I Y<1 Q
 I $D(^SC(+Y,"I")) S ORIA=+^("I"),ORRA=$P(^("I"),U,2)
 I $S('$D(ORIA):0,'ORIA:0,ORIA>DT:0,ORRA'>DT&(ORRA):0,1:1) W $C(7),!,"  This location has been inactivated.",! K ORL G LOC
 Q
QUE(ZTRTN,ZTDESC,ZTSAVE,ORIOPTR,ZTDTH,%ZIS,QUE,ECHO,ORION) ;Device Handling
IO ;This entry point replaced by QUE, but left for backwards compatibility
 Q:'$D(ZTRTN)
 N IO,ION,IOP,IOPAR,IOT,ZTSK,ZTIO,POP
 I $G(QUE),'$L($G(ORIOPTR)) Q
 I $L($G(ORIOPTR)),$G(QUE),$D(ORION) S ZTIO=ORION G IOQ
 S:'($D(%ZIS)#2) %ZIS="Q"
 I $G(QUE) S:%ZIS'["Q" %ZIS=%ZIS_"Q" S %ZIS("S")="I $S($G(^%ZIS(2,+$G(^(""SUBTYPE"")),0))'[""C-"":1,1:0)",%ZIS("B")=""
 I $L($G(ORIOPTR)) S IOP=ORIOPTR
 D ^%ZIS
 I POP S OREND=1 Q
 S ZTIO=ION
IOQ I $G(QUE)!$D(IO("Q")) D  Q
 . S:'$D(ZTSAVE) ZTSAVE("O*")=""
 . D ^%ZTLOAD
 . I $D(ZTSK),'$D(ECHO) W !,"REQUEST QUEUED"
 . I '$D(ZTSK) S OREND=1
 . D ^%ZISC
 D @ZTRTN
 D ^%ZISC
 Q
