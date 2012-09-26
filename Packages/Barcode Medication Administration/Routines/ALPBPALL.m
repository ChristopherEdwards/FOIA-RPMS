ALPBPALL ;OIFO-DALLAS MW,SED,KC-PRINT 3-DAY MAR BCMA BACLUP REPORT FOR ALL WARDS ;01/01/03
 ;;2.0;BAR CODE MED ADMIN;**17**;May 2002
 ;
 ; based on original code by FD@NJHCS, May 2002
 ; 
 W !,"Inpatient Pharmacy Orders for all wards"
 ;
 ; get all or just current orders?...
 S DIR(0)="SA^A:ALL;C:CURRENT"
 S DIR("A")="Report [A]LL or [C]URRENT orders? "
 S DIR("B")="CURRENT"
 S DIR("?")="[A]LL=all orders in the file, [C]URRENT=orders not yet expired."
 W ! D ^DIR K DIR
 I $D(DIRUT) K DIRUT,DTOUT,X,Y Q
 S ALPBOTYP=Y
 ;
 ; print how many days MAR?...
 S DIR(0)="NA^1:7"
 S DIR("A")="Print how many days MAR? "
 S DIR("B")=$$DEFDAYS^ALPBUTL()
 S DIR("?")="The default is shown; you may choose 3 or 7."
 W ! D ^DIR K DIR
 I $D(DIRUT) K ALPBOTYP,DIRUT,DTOUT,X,Y Q
 S ALPBDAYS=+Y
 ;
 ; BCMA Med Log info for how many days?...
 S X1=$$DT^XLFDT()
 S X2=-3
 D C^%DTC
 S DIR(0)="DA^::EXP"
 S DIR("B")=$$FMTE^XLFDT(X)
 S DIR("A")="Select beginning date for BCMA Medication Log history: "
 S DIR("A",1)=" "
 S DIR("?")="want only current day's entries, enter 'T' for today."
 S DIR("?",1)="Select a date (in the past) from which you wish to see"
 S DIR("?",2)="any BCMA Medication Log entries for each of this patient's"
 S DIR("?",3)="orders.  The default date shown is 3 days ago.  If you"
 D ^DIR K DIR
 I $D(DIRUT) K ALPBOTYP,DIRUT,DTOUT,X,Y Q
 S ALPBMLOG=Y
 ;
 S %ZIS="Q"
 S %ZIS("B")=$$DEFPRT^ALPBUTL()
 I %ZIS("B")="" K %ZIS("B")
 W ! D ^%ZIS K %ZIS
 I POP K POP Q
 ;
 ; output not queued...
 I '$D(IO("Q")) D
 .U IO
 .D DQ
 .I IO'=IO(0) D ^%ZISC
 ;
 ; set up the task...
 I $D(IO("Q")) D
 .S ZTRTN="DQ^ALPBPALL"
 .S ZTDESC="PSB INPT PHARM ORDER FOR ALL WARDS"
 .S ZTIO=ION
 .S ZTSAVE("ALPBMLOG")=""
 .S ZTSAVE("ALPBOTYP")=""
 .S ZTSAVE("ALPBDAYS")=""
 .D ^%ZTLOAD
 .D HOME^%ZIS
 .W !,$S($G(ZTSK):"Task number "_ZTSK_" queued.",1:"ERROR -- NOT QUEUED!")
 .K IO("Q"),ZTSK
 K ALPBDAYS,ALPBMLOG,ALPBOTYP
 Q
 ;
DQ ; output entry point...
 K ^TMP($J)
 ;
 ; set report date...
 S ALPBRDAT=$S(ALPBOTYP="C":$$DT^XLFDT(),1:"")
 ;
 ; loop through ward cross reference in 53.7...
 S ALPBWARD=""
 F  S ALPBWARD=$O(^ALPB(53.7,"AW",ALPBWARD)) Q:ALPBWARD=""  D
 .S ALPBPTN=""
 .F  S ALPBPTN=$O(^ALPB(53.7,"AW",ALPBWARD,ALPBPTN)) Q:ALPBPTN=""  D
 ..S ALPBIEN=0
 ..F  S ALPBIEN=$O(^ALPB(53.7,"AW",ALPBWARD,ALPBPTN,ALPBIEN)) Q:'ALPBIEN  D
 ...D ORDS^ALPBUTL(ALPBIEN,ALPBRDAT,.ALPBORDS)
 ...I +ALPBORDS(0)'>0 K ALPBORDS Q
 ...S ALPBOIEN=0
 ...F  S ALPBOIEN=$O(ALPBORDS(ALPBOIEN)) Q:'ALPBOIEN  D
 ....S ALPBDATA=$G(^ALPB(53.7,ALPBIEN,2,ALPBOIEN,1))
 ....I ALPBOTYP="C"&($P(ALPBDATA,U,2)<ALPBRDAT) K ALPBDATA Q
 ....S ALPBORDN=ALPBORDS(ALPBOIEN)
 ....S ALPBOST=$$STAT2^ALPBUTL1(ALPBORDS(ALPBOIEN,2))
 ....I '$D(^TMP($J,ALPBWARD,ALPBPTN)) S ^TMP($J,ALPBWARD,ALPBPTN)=ALPBIEN
 ....S ^TMP($J,ALPBWARD,ALPBPTN,ALPBOST,ALPBORDN)=ALPBOIEN
 ....K ALPBDATA,ALPBORDN,ALPBOST
 ...K ALPBOIEN,ALPBORDS
 ..K ALPBIEN
 .K ALPBPTN
 K ALPBWARD
 ;
 ; process through out sorted list...
 S ALPBPG=0
 S ALPBWARD=""
 F  S ALPBWARD=$O(^TMP($J,ALPBWARD)) Q:ALPBWARD=""  D
 .S ALPBPTN=""
 .F  S ALPBPTN=$O(^TMP($J,ALPBWARD,ALPBPTN)) Q:ALPBPTN=""  D
 ..S ALPBIEN=+^TMP($J,ALPBWARD,ALPBPTN)
 ..S ALPBPDAT(0)=$G(^ALPB(53.7,ALPBIEN,0))
 ..; paginate between patients...
 ..I ALPBPG=0 D PAGE
 ..S ALPBOST=""
 ..F  S ALPBOST=$O(^TMP($J,ALPBWARD,ALPBPTN,ALPBOST)) Q:ALPBOST=""  D
 ...S ALPBORDN=""
 ...F  S ALPBORDN=$O(^TMP($J,ALPBWARD,ALPBPTN,ALPBOST,ALPBORDN)) Q:ALPBORDN=""  D
 ....S ALPBOIEN=^TMP($J,ALPBWARD,ALPBPTN,ALPBOST,ALPBORDN)
 ....; get and print this order's data...
 ....M ALPBDATA=^ALPB(53.7,ALPBIEN,2,ALPBOIEN)
 ....D F132^ALPBFRM1(.ALPBDATA,ALPBDAYS,ALPBMLOG,.ALPBFORM)
 ....I $Y+ALPBFORM(0)>IOSL D PAGE
 ....S ALPBX=0
 ....F  S ALPBX=$O(ALPBFORM(ALPBX)) Q:'ALPBX  W !,ALPBFORM(ALPBX)
 ....K ALPBDATA,ALPBFORM,ALPBOIEN,ALPBX
 ...K ALPBORDN
 ...; print footer at end of this patient's record...
 ...D FOOT^ALPBFRMU
 ..K ALPBIEN,ALPBPDAT,ALPBOST
 ..S ALPBPG=0
 .K ALPBPTN
 ;
 K ALPBDAYS,ALPBMLOG,ALPBOTYP,ALPBPG,ALPBRDAT,ALPBWARD,^TMP($J)
 I $D(ZTQUEUED) S ZTREQ="@"
 Q
 ;
PAGE ; paginate and print header for a patient...
 W @IOF
 ; increment page count...
 S ALPBPG=ALPBPG+1
 D HDR^ALPBFRMU(.ALPBPDAT,ALPBPG,.ALPBHDR)
 S ALPBX=0
 F  S ALPBX=$O(ALPBHDR(ALPBX)) Q:'ALPBX  W !,ALPBHDR(ALPBX)
 K ALPBHDR,ALPBX
 Q
