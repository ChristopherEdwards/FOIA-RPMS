ALPBPWRD ;OIFO-DALLAS MW,SED,KC-PRINT 3-DAY MAR BCMA BCBU REPORT FOR A SELECTED WARD ;01/01/03
 ;;2.0;BAR CODE MED ADMIN;**17**;May 2002
 ; 
 ; NOTE: this routine is designed for hard-copy output.  Output is formatted
 ;       for 132-column printing.
 ; 
 F  D  Q:$D(DIRUT)
 .W !,"Inpatient Pharmacy Orders for a selected ward"
 .S DIR(0)="FAO^2:10"
 .S DIR("A")="Select WARD: "
 .S DIR("?")="^D WARDLIST^ALPBUTL(""C"")"
 .D ^DIR K DIR
 .I $D(DIRUT) Q
 .D WARDSEL^ALPBUTL(Y,.ALPBSEL)
 .I +$G(ALPBSEL(0))=0 D  Q
 ..W $C(7)
 ..W "  ??"
 ..D WARDLIST^ALPBUTL("C")
 ..K ALPBSEL
 .I +$G(ALPBSEL(0))=1 D
 ..S ALPBWARD=ALPBSEL(1)
 ..W "   ",ALPBWARD
 ..K ALPBSEL
 .I +$G(ALPBSEL(0))>1 D  I $D(DIRUT) K DIRUT,DTOUT,X,Y Q
 ..S ALPBX=0
 ..F  S ALPBX=$O(ALPBSEL(ALPBX)) Q:'ALPBX  W !?2,$J(ALPBX,2),"  ",ALPBSEL(ALPBX)
 ..K ALPBX
 ..S DIR(0)="NA^1:"_ALPBSEL(0)
 ..S DIR("A")="Select Ward from the list (1-"_ALPBSEL(0)_"): "
 ..W ! D ^DIR K DIR
 ..I $D(DIRUT) K ALPBSEL Q
 ..S ALPBWARD=ALPBSEL(+Y)
 ..K ALPBSEL
 .;
 .; get all or just current orders?...
 .S DIR(0)="SA^A:ALL;C:CURRENT"
 .S DIR("A")="Report [A]LL or [C]URRENT orders? "
 .S DIR("B")="CURRENT"
 .S DIR("?")="[A]LL=all orders in the file, [C]URRENT=orders not yet expired."
 .W ! D ^DIR K DIR
 .I $D(DIRUT) K ALPBWARD,DIRUT,DTOUT,X,Y Q
 .S ALPBOTYP=Y
 .;
 .; print how many days MAR?...
 .S DIR(0)="NA^1:7"
 .S DIR("A")="Print how many days MAR? "
 .S DIR("B")=$$DEFDAYS^ALPBUTL()
 .S DIR("?")="The default is shown; you may enter 3 or 7."
 .W ! D ^DIR K DIR
 .I $D(DIRUT) K ALPBOTYP,DIRUT,DTOUT,X,Y Q
 .S ALPBDAYS=+Y
 .;
 .; BCMA Med Log info for how many days?...
 .S X1=$$DT^XLFDT()
 .S X2=-3
 .D C^%DTC
 .S DIR(0)="DA^::EXP"
 .S DIR("B")=$$FMTE^XLFDT(X)
 .S DIR("A")="Select beginning date for BCMA Medication Log history: "
 .S DIR("A",1)=" "
 .S DIR("?")="want only current day's entries, enter 'T' for today."
 .S DIR("?",1)="Select a date (in the past) from which you wish to see"
 .S DIR("?",2)="any BCMA Medication Log entries for each of this patient's"
 .S DIR("?",3)="orders.  The default date shown is 3 days ago.  If you"
 .D ^DIR K DIR
 .I $D(DIRUT) K ALPBOTYP,ALPBWARD,DIRUT,DTOUT,X,Y Q
 .S ALPBMLOG=Y
 .;
 .S %ZIS="Q"
 .S %ZIS("B")=$$DEFPRT^ALPBUTL()
 .I %ZIS("B")="" K %ZIS("B")
 .W ! D ^%ZIS K %ZIS
 .I POP D  Q
 ..W $C(7)
 ..K ALPBMLOG,ALPBOTYP,ALPBWARD,POP
 .;
 .; output not queued...
 .I '$D(IO("Q")) D
 ..U IO
 ..D DQ
 ..I IO'=IO(0) D ^%ZISC
 .;
 .; set up the Task...
 .I $D(IO("Q")) D
 ..S ZTRTN="DQ^ALPBPWRD"
 ..S ZTDESC="PSB INPT PHARM ORDERS FOR WARD "_ALPBWARD
 ..S ZTSAVE("ALPBDAYS")=""
 ..S ZTSAVE("ALPBWARD")=""
 ..S ZTSAVE("ALPBMLOG")=""
 ..S ZTSAVE("ALPBOTYP")=""
 ..S ZTIO=ION
 ..D ^%ZTLOAD
 ..D HOME^%ZIS
 ..W !,$S($G(ZTSK):"Task number "_ZTSK_" queued.",1:"ERROR -- NOT QUEUED!")
 ..K IO("Q"),ZTSK
 .K ALPBDAYS,ALPBMLOG,ALPBOTYP,ALPBWARD
 K DIRUT,DTOUT,X,Y
 Q
 ;
DQ ; output entry point...
 K ^TMP($J)
 ;
 ; set report date...
 S ALPBRDAT=$S(ALPBOTYP="C":$$DT^XLFDT(),1:"")
 ;
 ; loop through ward cross reference in 53.7...
 S ALPBPTN=""
 F  S ALPBPTN=$O(^ALPB(53.7,"AW",ALPBWARD,ALPBPTN)) Q:ALPBPTN=""  D
 .S ALPBIEN=0
 .F  S ALPBIEN=$O(^ALPB(53.7,"AW",ALPBWARD,ALPBPTN,ALPBIEN)) Q:'ALPBIEN  D
 ..D ORDS^ALPBUTL(ALPBIEN,ALPBRDAT,.ALPBORDS)
 ..I +ALPBORDS(0)'>0 K ALPBORDS Q
 ..I $G(ALPBPDAT(0))="" S ALPBPDAT(0)=$G(^ALPB(53.7,ALPBIEN,0))
 ..S ALPBOIEN=0
 ..F  S ALPBOIEN=$O(ALPBORDS(ALPBOIEN)) Q:'ALPBOIEN  D
 ...S ALPBDATA=$G(^ALPB(53.7,ALPBIEN,2,ALPBOIEN,1))
 ...; if report is for "C"urrent, check stop date and quit if
 ...; stop date is less than report date...
 ...I ALPBOTYP="C"&($P(ALPBDATA,U,2)<ALPBRDAT) K ALPBDATA Q
 ...S ALPBORDN=ALPBORDS(ALPBOIEN)
 ...S ALPBOST=$$STAT2^ALPBUTL1(ALPBORDS(ALPBOIEN,2))
 ...I '$D(^TMP($J,ALPBPTN)) S ^TMP($J,ALPBPTN)=ALPBIEN
 ...S ^TMP($J,ALPBPTN,ALPBOST,ALPBORDN)=ALPBOIEN
 ...K ALPBDATA,ALPBORDN,ALPBOST
 ..K ALPBOIEN,ALPBORDS,ALPBPDAT
 .K ALPBIEN
 K ALPBPTN
 ;
 ; process through our sorted list...
 S ALPBPG=0
 S ALPBPTN=""
 F  S ALPBPTN=$O(^TMP($J,ALPBPTN)) Q:ALPBPTN=""  D
 .S ALPBIEN=^TMP($J,ALPBPTN)
 .S ALPBPDAT(0)=$G(^ALPB(53.7,ALPBIEN,0))
 .I ALPBPG=0 D PAGE
 .S ALPBOST=""
 .F  S ALPBOST=$O(^TMP($J,ALPBPTN,ALPBOST)) Q:ALPBOST=""  D
 ..S ALPBORDN=""
 ..F  S ALPBORDN=$O(^TMP($J,ALPBPTN,ALPBOST,ALPBORDN)) Q:ALPBORDN=""  D
 ...S ALPBOIEN=^TMP($J,ALPBPTN,ALPBOST,ALPBORDN)
 ...; get and print this order's data...
 ...M ALPBDATA=^ALPB(53.7,ALPBIEN,2,ALPBOIEN)
 ...D F132^ALPBFRM1(.ALPBDATA,ALPBDAYS,ALPBMLOG,.ALPBFORM)
 ...I $Y+ALPBFORM(0)=IOSL!($Y+ALPBFORM(0)>IOSL) D PAGE
 ...F ALPBX=1:1:ALPBFORM(0) W !,ALPBFORM(ALPBX)
 ...K ALPBDATA,ALPBFORM,ALPBOIEN,ALPBX
 ..K ALPBORDN
 .K ALPBOST
 .; print footer at end of this patient's record...
 .I $Y+10>IOSL D PAGE
 .W !!
 .D FOOT^ALPBFRMU
 .S ALPBPG=0
 .K ALPBIEN,ALPBPDAT
 ;
 K ALPBDAYS,ALPBMLOG,ALPBOTYP,ALPBPG,ALPBPTN,ALPBRDAT,ALPBWARD,^TMP($J)
 I $D(ZTQUEUED) S ZTREQ="@"
 Q
 ;
PAGE ; print page header for patient...
 W @IOF
 S ALPBPG=ALPBPG+1
 D HDR^ALPBFRMU(.ALPBPDAT,ALPBPG,.ALPBHDR)
 F ALPBX=1:1:ALPBHDR(0) W !,ALPBHDR(ALPBX)
 K ALPBHDR,ALPBX
 Q
