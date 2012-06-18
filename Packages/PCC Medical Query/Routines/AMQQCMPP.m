AMQQCMPP ;IHS/CMI/THL - MANAGES PRINTED REPORTS ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ; CALLS TASKMAN
 ;-----
RUN N AMQQRV,AMQQNV,AMQQXV
 S (AMQQRV,AMQQNV)="AMQQXV"
 S AMQQXV=""
 I '$D(AMQQFFF) D SUP I $D(AMQQQUIT) Q
 I $D(^XUSEC("AMQQZRPT",DUZ)) S DIR("A")="Enter name of person requesting report",DIR(0)="P^200:AQEM",DIR("B")=$P(@AMQQ200(3)@(DUZ,0),U) D ^DIR S:Y>0 AMQQUSR=+Y K Y,DIRUT,DUOUT,DTOUT,DIR I '$D(AMQQUSR) S AMQQQUIT=1 Q
 D DEV
 I $D(AMQQQUIT) Q
 I '$D(IO("Q")) U IO D TASK D ^%ZISC G EXIT
 S ZTRTN="TASK^AMQQCMPP"
 S ZTIO=ION
 S ZTDTH="NOW"
 S ZTDESC="QUERY UTILITY REPORT"
QUEUE ;F I=1:1 S %=$P("AMQV(;AMQQ200(;AMQQRV;AMQQSUPF;AMQQNV;AMQQFFF;AMQQXV;AMQQUSR;^UTILITY(""AMQQ"",$J,;^UTILITY(""AMQQ RAND"",$J,;^UTILITY(""AMQQ TAX"",$J,",";",I) Q:%=""  S ZTSAVE(%)=""
 F I=1:1 S %=$P("AMQV(;AMQQ200(;AMQQ*;AMQQRV;AMQQSUPF;AMQQNV;AMQQFFF;AMQQXV;AMQQUSR;^UTILITY(""AMQQ"",$J,;^UTILITY(""AMQQ RAND"",$J,;^UTILITY(""AMQQ TAX"",$J,",";",I) Q:%=""  S ZTSAVE(%)="" ;PATCH XXX
 D ^%ZTLOAD
 D ^%ZISC
 W !!,$S($D(ZTSK):"Request queued!",1:"Request cancelled!"),!!!
 H 3
EXIT K X,Y,%,AMQQSUPF,I,AMQQUSR
 W @IOF
 Q
 ;
DEV W !
 S %ZIS="QM"
 S %ZIS("B")=""
 D ^%ZIS
 S AMQQIOP=IO
 I POP S AMQQQUIT="" Q
 D PRINT^AMQQSEC E  W "  <= Not a secure device!!",*7 G DEV
 I $D(IO("Q")),IO=IO(0) W !!,"You can not queue a job to a slave printer..Try again",!!,*7 G DEV
 Q
 ;
TASK I '$D(AMQQFFF) D COVER I $D(AMQQQUIT) Q
 X AMQV(0)
 I '$D(AMQQFFF) W !,"Total: ",+$G(AMQQTOT)
 I $E(IOST,1,2)="C-" S DIR(0)="E" D ^DIR K DIR,DUOUT,DTOUT,DIRUT
 W @IOF
 I $D(ZTQUEUED) D EXIT2^AMQQKILL S ZTREQ="@"
 Q
 ;
COVER ; - EP -
 S %=""
 S $P(%,"*",79)=""
 W !!!!,%,! K AMQQQUIT
 W "**   WARNING...The following report may contain CONFIDENTIAL PATIENT DATA.  **"
 W !,"** You are accountable for keeping the report in a SECURE AREA at all times.**"
 W !,"**            SHRED the report as soon as it is no longer needed.           **"
 W !,"**            PRIVACY ACT violators are subject to a $5000 fine!            **"
 W !,%
CV1 S %=$P(@AMQQ200(3)@(DUZ,0),U)
 S %=$P(%,",",2,9)_" "_$P(%,",") D
 .W !!,"This report ",$S('$D(AMQQUSR)!($G(AMQQUSR)=DUZ):"requested",1:"printed")," by ",%
 .I $D(AMQQUSR),AMQQUSR'=DUZ D
 ..S %=$P(@AMQQ200(3)@(AMQQUSR,0),U)
 ..S %=$P(%,",",2,9)_" "_$P(%,",")
 ..W " and requested by ",%
 W !,"Date of report: "
 S Y=DT
 X ^DD("DD")
 W Y
 W !!
 F %=0:0 S %=$O(^UTILITY("AMQQ",$J,"LIST",%)) Q:'%  W ! X ^(%)
 I $E(IOST,1,2)="C-" W !! S DIR(0)="E" D ^DIR K DIR I $D(DUOUT)+$D(DTOUT) K DUOUT,DTOUT,DIRUT S AMQQQUIT=""
 Q
 ;
COUNT ; ENTRY POINT FROM AMQQCMPL
 N AMQQRV,AMQQNV,AMQQXV
 S (AMQQRV,AMQQNV)="AMQQXV"
 S AMQQXV=""
 D DEV
 I $D(AMQQQUIT) Q
 I '$D(IO("Q")) U IO D TASKC D ^%ZISC Q
 S ZTRTN="TASKC^AMQQCMPP"
 S ZTIO=ION
 S ZTDTH="NOW"
 S ZTDESC="Q-MAN COUNT"
 D QUEUE
 Q
 ;
TASKC S AMQQH1=$H
 I $E(IOST,1,2)'="P-" W !!!!,"COUNTING....",!
 E  W !!!! D CV1 W !!!
 X AMQV(0)
 I $E(IOST,1,2)="C-" W $C(13),?9,$C(13)
 W "Total: ",+$G(AMQQTOT)
 S X1=AMQQH1
 S X2=$H
 D ELT^AMQQCMP0
 W !,"Search time: ",X
 I $E(IOST,1,2)="C-" W !!! S DIR(0)="E" D ^DIR K DIR,DIRUT,DUOUT,DTOUT
 K AMQQH1,X1,X2
 W @IOF
 I $D(ZTQUEUED) D EXIT2^AMQQKILL S ZTREQ="@"
 Q
 ;
SUP W !!,"Want to suppress patient names and only print the chart no."
 S %=2
 D YN^DICN
 I %Y=U S AMQQQUIT="" K %Y Q
 I $D(DUOUT)+$D(DTOUT) K DTOUT,DUOUT S AMQQQUIT="" Q
 I "Nn"[$E(%Y) K %Y Q
 S AMQQSUPF=""
 K %Y
 Q
 ;
