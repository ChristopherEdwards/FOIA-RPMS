ABMDRUTL ; IHS/ASDST/DMJ - Report Utility ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
ZIS ;EP for selecting device
 W !!! S %ZIS="PQ",%ZIS("B")="",%ZIS("A")="Output DEVICE: " D ^%ZIS I $G(POP)!'$D(IO) S DUOUT="" Q
 S:ION["HOST" %ZIS("IOPAR")=IOPAR
 S ABM("IOP")=ION_";"_IOST_";"_$S($D(ABM(132)):132,1:80)_";"_IOSL
 I $D(ABM(132)) D ^ABMDR16 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ;
 I $E(IOST)="C"!$D(IO("S"))!$D(IO("Q")) Q
 I $P($G(^ABMDPARM(DUZ(2),1,0)),U,13)="Y" W !!,"As specified in the 3P Site Parameters File FORCED QUEUEING is in effect!",! S IO("Q")=1 Q
 ;
 Q:$D(ABM("FAST"))
 W !!,"NOTE: This report might take considerable time to run, putting a large demand",!,"on the computer processor, which could adversely impact the response time on"
 W !,"other users. Thus, it is recommended that this report be queued to run at a time",!,"of limited activity. Contact your Site Manager for assistance with queueing."
 ;
 W !! K DIR S DIR(0)="Y",DIR("A")="Do you wish to QUE this REPORT (Y/N)",DIR("B")="Y" D ^DIR K DIR I $G(Y) S IO("Q")="" Q
 D WAIT^DICD
 Q
 ;
PAZ ;EP to pause report
 I '$D(IO("Q")),$E(IOST)="C",'$D(IO("S")) D
 .F  W ! Q:$Y+3>IOSL
 .K DIR S DIR(0)="E" D ^DIR K DIR
 Q
 ;
POUT ;EP for exiting report
 K:$D(ABM("SUBR")) ^TMP(ABM("SUBR"),$J)
 D KILL^%ZTLOAD
 K ABMY,ABMP,ABM,IO("Q"),POP,DIR,DUOUT,DTOUT,ZTSK,DIROUT,DIRUT,%ZIS
 Q
 ;
QUE ;EP for queuing
 F ABM="DUZ(2)","DUZ(0)","ABM(","ABMY(","ABMP(","%ZIS(" S ZTSAVE(ABM)=""
 D ^%ZTLOAD W:$D(ZTSK) !,"REQUEST QUEUED!  Task Number: ",ZTSK,!
 D ^%ZISC
 K ZTSK,ZTDESC,ZTSAVE,ZTRTN,IO("Q")
 Q
 ;
LOOP ;EP for Looping thru Bill File
 S ABMP("X")=$S($G(ABMY("DT"))="V":"AD",$G(ABMY("DT"))="A":"AP",$G(ABMY("DT"))="X":"AX",$G(ABMY("DT"))="P":"AE",$D(ABMY("INS")):"AJ",$D(ABMY("PAT")):"D",1:1)
 I ABMP("X") D  Q
 .S ABM=0 F  S ABM=$O(^ABMDBILL(DUZ(2),ABM)) Q:'ABM  D @("DATA^"_ABMP("RTN"))
 I $G(ABMY("DT"))]"","APV"[ABMY("DT") S ABMP("DT")=ABMY("DT",1)-.5 D  Q
 .F  S ABMP("DT")=$O(^ABMDBILL(DUZ(2),ABMP("X"),ABMP("DT"))) Q:'ABMP("DT")!(ABMP("DT")>(ABMY("DT",2)+.5))  D
 ..S ABM="" F  S ABM=$O(^ABMDBILL(DUZ(2),ABMP("X"),ABMP("DT"),ABM)) Q:'ABM  D @("DATA^"_ABMP("RTN"))
 I $G(ABMY("DT"))="X" S ABMP("DT")=ABMY("DT",1)-.5 D  Q
 .F  S ABMP("DT")=$O(^ABMDTXST(DUZ(2),"B",ABMP("DT"))) Q:'ABMP("DT")!(ABMP("DT")>(ABMY("DT",2)+.5))  D
 ..S ABMP("DTD")=0 F  S ABMP("DTD")=$O(^ABMDTXST(DUZ(2),"B",ABMP("DT"),ABMP("DTD"))) Q:'ABMP("DTD")  D
 ...S ABM=0 F  S ABM=$O(^ABMDBILL(DUZ(2),"AX",ABMP("DTD"),ABM)) Q:'ABM  D @("DATA^"_ABMP("RTN"))
 S ABMP("DT")=ABMY("DT",1)-1  D
 .S ABM="",ABMP("RI")=$S(ABMP("X")="AJ":ABMY("INS"),1:ABMY("PAT")) F  S ABM=$O(^ABMDBILL(DUZ(2),ABMP("X"),ABMP("RI"),ABM)) Q:'ABM  D @("DATA^"_ABMP("RTN"))
 Q
