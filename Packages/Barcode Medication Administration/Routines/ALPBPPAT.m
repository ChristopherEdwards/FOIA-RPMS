ALPBPPAT ;OIFO-DALLAS MW,SED,KC-PRINT 3-DAY MAR BCBU BACKUP REPORT FOR A SELECTED PATIENT ;01/01/03
 ;;2.0;BAR CODE MED ADMIN;**17**;May 2002
 ; 
 ; NOTE: this routine is designed for hard-copy output.  Output is formatted
 ;       for 132-column printing.
 ;
 F  D  Q:$D(DIRUT)
 .W !!,"Inpatient Pharmacy Orders for a selected patient"
 .S DIR(0)="PAO^53.7:QEMZ"
 .S DIR("A")="Select PATIENT NAME: "
 .D ^DIR K DIR
 .I $D(DIRUT) K X,Y Q
 .S ALPBIEN=+Y
 .S ALPBPTN=Y(0,0)
 .; get all or just current orders?...
 .S DIR(0)="SA^A:ALL;C:CURRENT"
 .S DIR("A")="Report [A]LL or [C]URRENT orders? "
 .S DIR("B")="CURRENT"
 .S DIR("?")="[A]LL=all orders in the file, [C]URRENT=orders not yet expired."
 .W ! D ^DIR K DIR
 .I $D(DIRUT) K DIRUT,DTOUT,X,Y Q
 .S ALPBOTYP=Y
 .;
 .; print how many days MAR?...
 .S DIR(0)="NA^3:7"
 .S DIR("A")="Print how many days MAR? "
 .S DIR("B")=$$DEFDAYS^ALPBUTL()
 .S DIR("?")="The default is shown; you may select 3 or 7."
 .W ! D ^DIR K DIR
 .I $D(DIRUT) K ALPBOTYP,DIRUT,DTOUT,X,Y Q
 .S ALPBDAYS=+Y
 .;
 .; BCMA Med Log info for how many days?...
 .W !,"BCMA Medication Log history:"
 .S ALPBMLOG=$$MLRANGE^ALPBUTL(ALPBIEN)
 .I $P(ALPBMLOG,U)="" D
 ..W " this patient has no history on file."
 ..S ALPBMLOG=""
 .I $P(ALPBMLOG,U)'="" D  I $D(DIRUT) K ALPBMLOG,ALPBOTYP,DIRUT,DTOUT,X,Y Q
 ..I $P(ALPBMLOG,U,2)="" D
 ...W !,"This patient has Log history only for ",$$FMTE^XLFDT($P(ALPBMLOG,U))
 ...S DIR("B")=$$FMTE^XLFDT($P(ALPBMLOG,U))
 ..; if there is a range of Med Log dates...
 ..I $P(ALPBMLOG,U,2)'="" D
 ...W !," First Log history date is ",$$FMTE^XLFDT($P(ALPBMLOG,U))
 ...W !,"  Last Log history date is ",$$FMTE^XLFDT($P(ALPBMLOG,U,2))
 ...; set default retrieval date to last date in the range-1...
 ...S X1=$P(ALPBMLOG,U,2)
 ...S X2=-1
 ...D C^%DTC
 ...S DIR("B")=$$FMTE^XLFDT(X)
 ..S DIR(0)="DA^"_$P(ALPBMLOG,U)_":"_$S($P(ALPBMLOG,U,2)'="":$P(ALPBMLOG,U,2),1:"")_":EP"
 ..S DIR("A")="Select start date for reporting Log history: "
 ..S DIR("A",1)=" "
 ..D ^DIR K DIR
 ..I $D(DIRUT) Q
 ..S ALPBMLOG=Y
 .;
 .S %ZIS="Q"
 .S %ZIS("B")=$$DEFPRT^ALPBUTL()
 .I %ZIS("B")="" K %ZIS("B")
 .W ! D ^%ZIS K %ZIS
 .I POP D  Q
 ..K ALPBIEN,ALPBPTN,POP
 .;
 .; output not queued...
 .I '$D(IO("Q")) D
 ..U IO
 ..D DQ
 ..I IO'=IO(0) D ^%ZISC
 .;
 .; set up the Task...
 .I $D(IO("Q")) D
 ..S ZTRTN="DQ^ALPBPPAT"
 ..S ZTIO=ION
 ..S ZTDESC="PSB INPT PHARM ORDERS FOR "_ALPBPTN
 ..S ZTSAVE("ALPBDAYS")=""
 ..S ZTSAVE("ALPBIEN")=""
 ..S ZTSAVE("ALPBMLOG")=""
 ..S ZTSAVE("ALPBOTYP")=""
 ..D ^%ZTLOAD
 ..D HOME^%ZIS
 ..W !!,$S(+$G(ZTSK):"Task "_ZTSK_" queued.",1:"ERROR: NOT QUEUED!")
 ..K IO("Q"),ZTSK
 .;
 .K ALPBDAYS,ALPBIEN,ALPBMLOG,ALPBOTYP,ALPBPTN,X,Y
 K DIRUT,DTOUT,X,Y
 Q
 ;
DQ ; output entry point...
 K ^TMP($J)
 ;
 ; set report date...
 S ALPBRDAT=$$DT^XLFDT()
 S ALPBPT(0)=$G(^ALPB(53.7,ALPBIEN,0))
 M ALPBPT(1)=^ALPB(53.7,ALPBIEN,1)
 S ALPBPG=1
 D HDR^ALPBFRMU(.ALPBPT,ALPBPG,.ALPBHDR)
 F I=1:1:ALPBHDR(0) W !,ALPBHDR(I)
 K ALPBHDR
 ;
 ; loop through orders and sort by order status...
 S ALPBOIEN=0
 F  S ALPBOIEN=$O(^ALPB(53.7,ALPBIEN,2,ALPBOIEN)) Q:'ALPBOIEN  D
 .M ALPBDATA=^ALPB(53.7,ALPBIEN,2,ALPBOIEN)
 .; if report type is "C"urrent and stop date is less than
 .; report date, quit...
 .I ALPBOTYP="C" D  Q:'$D(ALPBDATA)
 ..I $G(ALPBDATA(1))="" K ALPBDATA Q
 ..I $P(ALPBDATA(1),U,2)<ALPBRDAT K ALPBDATA
 .S ALPBORDN=$P(ALPBDATA(0),U)
 .S ALPBOST=$$STAT2^ALPBUTL1($P($G(ALPBDATA(1),"XX"),U,3))
 .S ^TMP($J,ALPBOST,ALPBORDN)=ALPBOIEN
 .K ALPBDATA,ALPBOST
 ;
 ; loop through the sorted orders...
 S ALPBOST=""
 F  S ALPBOST=$O(^TMP($J,ALPBOST)) Q:ALPBOST=""  D
 .S ALPBORDN=""
 .F  S ALPBORDN=$O(^TMP($J,ALPBOST,ALPBORDN)) Q:ALPBORDN=""  D
 ..S ALPBOIEN=^TMP($J,ALPBOST,ALPBORDN)
 ..M ALPBDATA=^ALPB(53.7,ALPBIEN,2,ALPBOIEN)
 ..W !
 ..D F132^ALPBFRM1(.ALPBDATA,ALPBDAYS,ALPBMLOG,.ALPBFORM)
 ..; paginate?...
 ..I $Y+ALPBFORM(0)=IOSL!($Y+ALPBFORM(0)>IOSL) D
 ...W @IOF
 ...S ALPBPG=ALPBPG+1
 ...D HDR^ALPBFRMU(.ALPBPT,ALPBPG,.ALPBHDR)
 ...F I=1:1:ALPBHDR(0) W !,ALPBHDR(I)
 ...W !
 ...K ALPBHDR
 ..F I=1:1:ALPBFORM(0) W !,ALPBFORM(I)
 ..K ALPBDATA,ALPBFORM
 ;
 ; print footer at end of this patient's record...
 D FOOT^ALPBFRMU
 ;
 K ALPBDAYS,ALPBMLOG,ALPBOIEN,ALPBORDN,ALPBOST,ALPBOTYP,ALPBPG,ALPBPT,ALPBRDAT,^TMP($J)
 I $D(ZTQUEUED) S ZTREQ="@"
 ;
 ; write form feed at end if output device is a printer...
 I $E(IOST)="P" W @IOF
 Q
