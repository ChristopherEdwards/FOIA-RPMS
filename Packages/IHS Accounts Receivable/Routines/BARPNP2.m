BARPNP2 ; IHS/SD/LSL - POSTING PATIENT LOOKUP ; 05/02/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**4**;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 11/08/02 - V1.7 - NOIS CNA-1102-110028
 ;       If when looping through ABC x-ref, there is no data for the bill,
 ;       k the x-ref and q
 ;
 ; ********************************************************************
 ;
 ; verify Status of Bill,
 ;  If the bill was 'CLOSED' not displayed - no 3P bill found
 ;  If the bill was 'CANCELED' and Current bill amount is 0  not displayed - has already been worked
 ;** patient a/r lookup based on from/thru dos
 ;** called from ^BARPST
 ;** BARPASS = PATDFN^BEGDOS^ENDDOS
 ;** builds an array that includes all entries from a/r that meet the
 ;   criteria.
 ; *********************************************************************
 ;
EN(BARPASS)        ;EP - pat/bills lookup
 N DIC,DIQ,DR,BARBLV,BARDT,BARPAT,BARBEG,BAREND,BARHIT,BARCNT
 K ^BARTMP($J)
 S BARCNT=0
 I (+$G(BARPASS)=0) Q 0
 S BARPAT=+BARPASS
 S BARBEG=$P(BARPASS,U,2)
 S BAREND=$P(BARPASS,U,3)
 S X1=BARBEG
 S X2=-1
 D C^%DTC
 S BARDT=X
 S DIC="^BARBL(DUZ(2),"
 S DR=".01;3;13;15;16"
 S DIQ="BARBLV("
 S BARCNT=0
 F  S BARDT=$O(^BARBL(DUZ(2),"ABC",BARPAT,BARDT)) Q:'BARDT!(BARDT>BAREND)  DO
 . S BARBDA=0
 . F  S BARBDA=$O(^BARBL(DUZ(2),"ABC",BARPAT,BARDT,BARBDA)) Q:'BARBDA  DO
 .. I '$D(^BARBL(DUZ(2),BARBDA)) K ^BARBL(DUZ(2),"ABC",BARPAT,BARDT,BARBDA) Q
 .. S DA=BARBDA D EN^XBDIQ1
 .. S BARCNT=BARCNT+1
 .. I BARBLV(16)'="CLOSED" D
 ... S ^BARTMP($J,BARBDA,BARCNT)=BARDT_U_BARBLV(.01)_U_BARBLV(13)_U_BARBLV(3)_U_BARBLV(15)_U_U_U_BARBLV(16)
 ... S ^BARTMP($J,"B",BARCNT,BARBDA)=""
 .. I (BARBLV(16)="3P CANCELLED")&(BARBLV(15)=0) D
 ... K ^BARTMP($J,BARBDA,BARCNT)
 ... K ^BARTMP($J,"B",BARCNT,BARBDA)
 ... S BARCNT=BARCNT-1
 .. I BARBLV(16)="CLOSED" S BARCNT=BARCNT-1
 .. K BARBLV
 Q BARCNT
 ; *********************************************************************
 ;
HIT(BARPASS) ;EP - ** display a/r bills found
 N BARBDA,BARLIN,BARREC,BARBLO
 S (BARBDA,BARPG,BARSTOP)=0
 D HEAD
 F  S BARBDA=$O(^BARTMP($J,BARBDA)) Q:'BARBDA  DO  Q:BARSTOP
 .S BARLIN=$O(^BARTMP($J,BARBDA,""))
 .S BARREC=^BARTMP($J,BARBDA,BARLIN)
 .S BARBLO=$P(BARREC,U,2) I $D(^BARTR(DUZ(2),"AM4",+BARBLO)) S BARBLO="m"_BARBLO
 .S BARSTOP=$$CHKLINE(0) Q:BARSTOP
 .S BARCMSG="      "
 .S:$P(BARREC,U,8)="3P CANCELLED" BARCMSG="3P CAN"
 .;start new code IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 .S BARTPB=$$FIND3PB^BARUTL(DUZ(2),BARBDA)
 .S:$G(BARTPB)'="" BARSTAT=$P($G(^ABMDBILL($P(BARTPB,","),$P(BARTPB,",",2),0)),U,4)
 .;end new code IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 .W !,BARLIN
 .W ?6,$$SDT^BARDUTL($P(BARREC,U,1))
 .W ?18,BARBLO
 .W:($G(BARSTAT)="X") "*"  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 .W ?25,BARCMSG
 .W ?32,$J($P(BARREC,U,3),8,2)
 .W ?44,$E($P(BARREC,U,4),1,23)
 .W ?70,$J($P(BARREC,U,5),8,2)
 Q
 ; *********************************************************************
 ;
HEAD ;
 W $$EN^BARVDF("IOF"),!
 N BARPTNAM
 Q:'+$G(BARPASS)
 S BARPG=BARPG+1
 S BARPTNAM=$P(^DPT(+BARPASS,0),U,1)
 I $D(^BARTR(DUZ(2),"AM5",+BARPASS)) S BARPTNAM="(msg) "_BARPTNAM
 W "Claims for "_BARPTNAM_"  from "_$$SDT^BARDUTL($P(BARPASS,U,2))_" to "_$$SDT^BARDUTL($P(BARPASS,U,3))
 W ?(IOM-15),"Page: "_BARPG
 W !!
 W ?32,"Billed",?70,"Current"
 W !
 W "Line #",?8,"DOS",?18,"Claim #",?32,"Amount",?44,"Billed To",?70,"Balance"
 S BARDSH="",$P(BARDSH,"-",IOM)=""
 W !,BARDSH
 Q
 ; *********************************************************************
 ;
HIT1(BARPASS) ;EP - ** display a/r bills found
 N BARHIT,BARLIN,BARREC,BARBLO
 S (BARTPAY,BARTADJ,BARHIT,BARPG,BARSTOP)=0
 D HEAD1
 F  S BARHIT=$O(^BARTMP($J,BARHIT)) Q:'BARHIT  D  Q:BARSTOP
 .S BARLIN=$O(^BARTMP($J,BARHIT,""))
 .S BARREC=^BARTMP($J,BARHIT,BARLIN)
 .S BARBLO=$P(BARREC,U,2)
 .I $D(^BARTR(DUZ(2),"AM4",+BARBLO)) S BARBLO="m"_BARBLO
 .S BARTPAY=BARTPAY+$P(BARREC,U,6)
 .S BARTADJ=BARTADJ+$P(BARREC,U,7)
 .S BARSTOP=$$CHKLINE(1) Q:BARSTOP
 .S BARCMSG="      "
 .S:$P(BARREC,U,8)="3P CANCELLED" BARCMSG="3P CAN"
 .;start new code IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 .S BARTPB=$$FIND3PB^BARUTL(DUZ(2),BARHIT)
 .S:$G(BARTPB)'="" BARSTAT=$P($G(^ABMDBILL($P(BARTPB,","),$P(BARTPB,",",2),0)),U,4)
 .;end new code IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 .W !,BARLIN
 .W ?6,$$SDT^BARDUTL($P(BARREC,U,1))
 .W ?18,BARBLO
 .W:($G(BARSTAT)="X") "*"  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 .W ?25,BARCMSG
 .W ?32,$J($P(BARREC,U,3),8,2)
 .W ?44,$J($P(BARREC,U,6),8,2)
 .W ?56,$J($P(BARREC,U,7),8,2)
 .W ?70,$J($P(BARREC,U,5),8,2)
 Q
 ; *********************************************************************
 ;
HEAD1 ;
 W $$EN^BARVDF("IOF"),!
 N BARPTNAM
 S BARPG=BARPG+1
 S BARPTNAM=$P(^DPT(+BARPASS,0),U,1)
 I $D(^BARTR(DUZ(2),"AM5",+BARPASS)) S BARPTNAM="(msg) "_BARPTNAM
 W "Claims for "_BARPTNAM_"  from "_$$SDT^BARDUTL($P(BARPASS,U,2))_" to "_$$SDT^BARDUTL($P(BARPASS,U,3))
 W ?(IOM-15),"Page: "_BARPG
 W !!?32,"Billed",?44,"Current",?56,"Current",?70,"Current"
 W !,"Line #",?8,"DOS",?18,"Claim #",?32,"Amount",?44,"Payments",?56,"Adjust.",?70,"Balance"
 S BARDSH=""
 S $P(BARDSH,"-",IOM)=""
 W !,BARDSH
 Q
 ; *********************************************************************
 ;
CHKLINE(BARHD) ;EP
 ; Q 0 = CONTINUE
 ; Q 1 = STOP
 N X
 I ($Y+5)<IOSL Q 0
 W !?(IOM-15),"continued==>"
 D EOP^BARUTL(0)
 I 'Y Q 1
 I BARHD=0 D HEAD
 I BARHD=1 D HEAD1
 Q 0
