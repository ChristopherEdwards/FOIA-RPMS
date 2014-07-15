BARPNP2 ; IHS/SD/LSL - POSTING PATIENT LOOKUP ; 05/02/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**4,23**;OCT 26, 2005
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
 ;HEAT93190 DEC 2012 P.OTTIS NOHEAT MARK DUPLICATE BILLS
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
 N BARBDA,BARLIN,BARREC,BARBLO,BAREIN1,BAREIN2,BARDPTR
 S (BARBDA,BARPG,BARSTOP)=0
 D HEAD
 F  S BARBDA=$O(^BARTMP($J,BARBDA)) Q:'BARBDA  DO  Q:BARSTOP
 . S BARLIN=$O(^BARTMP($J,BARBDA,""))
 . S BARREC=^BARTMP($J,BARBDA,BARLIN)
 . S BARBLO=$P(BARREC,U,2) I $D(^BARTR(DUZ(2),"AM4",+BARBLO)) S BARBLO="m"_BARBLO
 . S BARSTOP=$$CHKLINE(0) Q:BARSTOP
 . S BARCMSG="      "
 . S:$P(BARREC,U,8)="3P CANCELLED" BARCMSG="3P CAN"
 . S BARTMP=$$DUPLBILL($P(BARREC,U,2)) I BARTMP>0 D  ;-------->P.OTT MARK DUPLICATE BILLS
 . . S BAREIN1=$P(BARTMP,"^",2)
 . . S BAREIN2=$P(BARTMP,"^",3)
 . . S BARDPTR=$P(BARTMP,"^",4)
 . . I BARDPTR=3 S BARBLO="?"_BARBLO Q
 . . I BARBDA=BAREIN1,BARDPTR=1 S BARBLO="!"_BARBLO Q  ;! = ORPHANT (NO DATA IN 3PB)
 . . I BARBDA=BAREIN2,BARDPTR=2 S BARBLO="!"_BARBLO Q  ;d = DUPLICATE (CORRECT ONE)
 . . I BARBDA=BAREIN1 S BARBLO="d"_BARBLO Q
 . . I BARBDA=BAREIN2 S BARBLO="d"_BARBLO Q
 . ;---------------------------------------------------------< P.OTT
 . ;start new code IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 . S BARTPB=$$FIND3PB^BARUTL(DUZ(2),BARBDA)
 . S:$G(BARTPB)'="" BARSTAT=$P($G(^ABMDBILL($P(BARTPB,","),$P(BARTPB,",",2),0)),U,4)
 . ;end new code IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 . W !,BARLIN
 . W ?6,$$SDT^BARDUTL($P(BARREC,U,1))
 . W ?18,BARBLO
 . W:($G(BARSTAT)="X") "*"  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 . W ?25,BARCMSG
 . W ?32,$J($P(BARREC,U,3),8,2)
 . W ?44,$E($P(BARREC,U,4),1,23)
 . W ?70,$J($P(BARREC,U,5),8,2)
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
 N BARHIT,BARLIN,BARREC,BARBLO,BAREIN1,BAREIN2,BARDPTR
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
 . S BARTMP=$$DUPLBILL($P(BARREC,U,2)) I BARTMP>0 D  ;-------->P.OTT MARK DUPLICATE BILLS
 . . S BAREIN1=$P(BARTMP,"^",2)
 . . S BAREIN2=$P(BARTMP,"^",3)
 . . S BARDPTR=$P(BARTMP,"^",4)
 . . I BARDPTR=3 S BARBLO="?"_BARBLO Q
 . . I BARHIT=BAREIN1,BARDPTR=1 S BARBLO="!"_BARBLO Q  ;! = ORPHANT (NO DATA IN 3PB)
 . . I BARHIT=BAREIN2,BARDPTR=2 S BARBLO="!"_BARBLO Q  ;d = DUPLICATE (CORRECT ONE)
 . . I BARHIT=BAREIN1 S BARBLO="d"_BARBLO Q
 . . I BARHIT=BAREIN2 S BARBLO="d"_BARBLO Q
 . ;---------------------------------------------------------< P.OTT
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
DUPLBILL(BARBN) ;CHECK FOR DUPLICATE BILLS
 ; IF THE BILL# IS A DUPLICATE RETURNS: 1^EIN1^EIN2^PTR (PTR POINTS TO THE 'ORPHANT' EIN1 or EIN2)
 ;NEW BAREIN1,BAREIN2,BAR3PEIN,BARDUZ3P,BARAPP1,BARAPP2,BARRET
 S BAREIN1=$O(^BARBL(DUZ(2),"B",BARBN,"")) I BAREIN1="" Q -1 ;0  ;NO DATA - WE DON'T CARE
 S BAREIN2=$O(^BARBL(DUZ(2),"B",BARBN,BAREIN1)) I BAREIN2="" Q -2 ;0 ;ONLY 1 BILL - NO DUPS
 ;TAKE 1ST OF THE PAIR
 S BARRET="1^"_BAREIN1_"^"_BAREIN2_"^"
 S BAR3PEIN=$P($G(^BARBL(DUZ(2),BAREIN1,0)),"^",17)
 S BARDUZ3P=$P($G(^BARBL(DUZ(2),BAREIN1,0)),"^",22)
 I BAR3PEIN="" Q -3 ;0  ;NO DATA
 I BARDUZ3P="" Q -4 ;0  ;NO DATA
 ;
 S BARAPP1=0 I '$D(^ABMDBILL(BARDUZ3P,BAR3PEIN,0)) S BARAPP1=1 ;OK
 ;TAKE 2ND OF THE PAIR
 S BAR3PEIN=$P($G(^BARBL(DUZ(2),BAREIN2,0)),"^",17)
 S BARDUZ3P=$P($G(^BARBL(DUZ(2),BAREIN2,0)),"^",22)
 I BAR3PEIN="" Q -5  ; 0  ;NO DATA
 I BARDUZ3P="" Q -6   ;0  ;NO DATA
 ;
 S BARAPP2=0 I '$D(^ABMDBILL(BARDUZ3P,BAR3PEIN,0)) S BARAPP2=1 ;OK
 I BARAPP1+BARAPP2=1 D  Q BARRET
 . I BARAPP1=1 S BARRET=BARRET_1
 . I BARAPP2=1 S BARRET=BARRET_2
 Q BARRET_3 ;IF BOTH BILLS NOT FOUND IN 3PB 
