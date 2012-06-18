BARPST2 ; IHS/SD/LSL - PAYMENT PATIENT SELECTION JAN 15,1997 ; 05/07/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**4,14**;OCT 26, 2005
 ;
 ; ** patient a/r lookup based on from/thru dos
 ; ** called from ^BARPST
 ; ** BARPASS = PATDFN^BEGDOS^ENDDOS
 ; ** builds an array that includes all entries from a/r that meet the
 ;    criteria.
 ;     - If Bill was 'CLOSED' then not displayed - not found in 3P system
 ;     - If Bill was 'CANCELED' and current amount due is 0 - not displayes, already worked
 ;
 ; *********************************************************************
 ;
EN(BARPASS)        ; EP
 ; Pat/BIll lookup
 N DIC,DIQ,DR,BARBLV,BARDT,BARPAT,BARBEG,BAREND,BARHIT,BARCNT
 K ^BARTMP($J)
 Q:+BARPASS=0
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
 F  S BARDT=$O(^BARBL(DUZ(2),"ABC",BARPAT,BARDT)) Q:'BARDT!(BARDT>BAREND)  D
 .S BARBDA=0
 .F  S BARBDA=$O(^BARBL(DUZ(2),"ABC",BARPAT,BARDT,BARBDA)) Q:'BARBDA  D
 ..S DA=BARBDA
 ..D EN^XBDIQ1
 ..S BARCNT=BARCNT+1
 ..I BARBLV(16)'="CLOSED" D
 ...S ^BARTMP($J,BARBDA,BARCNT)=BARDT_U_BARBLV(.01)_U_BARBLV(13)_U_BARBLV(3)_U_BARBLV(15)_U_U_U_BARBLV(16)
 ...S ^BARTMP($J,"B",BARCNT,BARBDA)=""
 ..I (BARBLV(16)="3P CANCELLED")&(BARBLV(15)=0) D
 ...K ^BARTMP($J,BARBDA,BARCNT)
 ...;K ^BARTMP($J,BARCNT,BARBDA)
 ...K ^BARTMP($J,"B",BARCNT,BARBDA)  ;IHS/SD/TPF 9/24/2009 H5512
 ...S BARCNT=BARCNT-1
 ..I BARBLV(16)="CLOSED" S BARCNT=BARCNT-1
 ..K BARBLV
 Q BARCNT
 ; *********************************************************************
 ;
HIT(BARPASS) ; EP
 ; ** display a/r bills found
 N BARBDA,BARLIN,BARREC,BARBLO
 S (BARBDA,BARPG,BARSTOP)=0
 D HEAD
 F  S BARBDA=$O(^BARTMP($J,BARBDA)) Q:'BARBDA  D  Q:BARSTOP
 .S BARLIN=$O(^BARTMP($J,BARBDA,""))
 .S BARREC=^BARTMP($J,BARBDA,BARLIN)
 .S BARBLO=$P(BARREC,U,2)
 .I $D(^BARTR(DUZ(2),"AM4",+BARBLO)) S BARBLO="m"_BARBLO
 .S BARSTOP=$$CHKLINE(0)
 .Q:BARSTOP
 .S BARCMSG="      "
 .S:$P(BARREC,U,8)="3P CANCELLED" BARCMSG="3P CAN"
 .;start new code IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 .S BARTPB=$$FIND3PB^BARUTL(DUZ(2),BARBDA)
 .S:$G(BARTPB)'="" BARSTAT=$P($G(^ABMDBILL($P(BARTPB,","),$P(BARTPB,",",2),0)),U,4)
 .;end new code IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 .W !,$J(BARLIN,3)
 .W ?6,$$SDT^BARDUTL($P(BARREC,U,1))
 .;W ?18,BARBLO,?25,BARCMSG  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 .W ?18,BARBLO_$S($G(BARSTAT)="X":"*",1:""),?25,BARCMSG  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 .W ?32,$J($P(BARREC,U,3),8,2)
 .W ?44,$E($P(BARREC,U,4),1,23)
 .W ?70,$J($P(BARREC,U,5),8,2)
 ;
EXIT ;
 Q
 ; *********************************************************************
 ;
HEAD ;
 W $$EN^BARVDF("IOF"),!
 N BARPTNAM
 S BARPG=BARPG+1
 S BARPTNAM=$P(^DPT(+BARPASS,0),U,1)
 I $D(^BARTR(DUZ(2),"AM5",+BARPASS)) S BARPTNAM="(msg) "_BARPTNAM
 W "Claims for "_BARPTNAM_"  from "_$$SDT^BARDUTL($P(BARPASS,U,2))_" to "_$$SDT^BARDUTL($P(BARPASS,U,3))
 W ?(IOM-15),"Page: "_BARPG,!!
 ;D SUBHD(.BARCOL,.BARITM,BARPMT)           ;BAR*1.8*4 DD 4.1.7.2
 D SUBHD(.BARCOL,.BARITM,$G(BARPMT))        ;BAR*1.8*4 DD 4.1.7.2
 W !!?32,"Billed",?70,"Current"
 W !,"Line #",?8,"DOS",?18,"Claim #",?32,"Amount",?44,"Billed To",?70,"Balance"
 S BARDSH=""
 S $P(BARDSH,"-",IOM)=""
 W !,BARDSH
 ;
EHEAD ;
 Q
 ; *********************************************************************
 ;
 ; changes needed for the Collection Batch DD update (triggers)
SUBHD(BARCOL,BARITM,BARPMT) ; EP
 Q:'$D(BARCOL)                          ;BAR*1.8*4 DD 4.1.7.2
 ; ** display batch and item headers
 K BARCLV,BARITV,BAREOV
 N DA,DIC,DIQ,DR
 S DIC=90051.01
 S DIQ="BARCLV("
 S DR=".01;15:18;21"
 S DA=+BARCOL
 D EN^XBDIQ1
 ;
 S DIC=90051.1101
 S DIQ="BARITV("
 S DR=".01;18;19;101;103;105"
 S DA=+BARITM
 S DA(1)=+BARCOL
 D EN^XBDIQ1
 ;
 I +$G(BAREOB) D
 . S DIC=90051.1101601
 . S DIQ="BAREOV("
 . S DR=".01;2;3;4;5"
 . S DA=+BAREOB
 . S DA(2)=+BARCOL
 . S DA(1)=+BARITM
 . D EN^XBDIQ1
 ;
 W "Batch  : "_$E($P(BARCLV(.01),"-",1),1,19)
 W ?27,"Item   : "_BARITV(.01)
 I +$G(BAREOB) W ?50,"Location: "_BAREOV(.01)
 W !,"Amount : "_$J(BARCLV(15),8,2)
 ; changes needed for the Collection Batch DD update (triggers)
 W ?27,"Amount : "_$J(BARITV(101),8,2)
 I +$G(BAREOB) W ?50,"  Amount : "_$J(BAREOV(2),8,2)
 W !,"Posted : "_$J(BARCLV(16)+BARPMT,8,2)
 ; changes needed for the Collection Batch DD update (triggers)
 W ?27,"Posted : "_$J(BARITV(18)+BARPMT,8,2)
 I +$G(BAREOB) W ?50,"  Posted : "_$J(BAREOV(3)+BARPMT,8,2)
 W !,"Unalloc: "_$J(BARCLV(21),8,2)
 W ?27,"Unalloc: "_$J(BARITV(105),8,2)
 I +$G(BAREOB) W ?50,"  Unalloc: "_$J(BAREOV(5),8,2)
 W !
 ;
B1 ;
 W "Balance: "_$J(BARCLV(17)-BARPMT,8,2)
 W ?27,"Balance: "_$J(BARITV(19)-BARPMT,8,2)
 ;
B2 ;
 I +$G(BAREOB) W ?50,"  Balance: "_$J(BAREOV(4)-BARPMT,8,2)
 Q
 ; *********************************************************************
 ;
HIT1(BARPASS) ; EP
 ; ** display a/r bills found
 N BARHIT,BARLIN,BARREC,BARBLO
 S (BARTPAY,BARTADJ,BARHIT,BARPG,BARSTOP)=0
 D HEAD1
 F  S BARHIT=$O(^BARTMP($J,BARHIT)) Q:'BARHIT  DO  Q:BARSTOP
 .S BARLIN=$O(^BARTMP($J,BARHIT,""))
 .S BARREC=^BARTMP($J,BARHIT,BARLIN)
 .S BARBLO=$P(BARREC,U,2) I $D(^BARTR(DUZ(2),"AM4",+BARBLO)) S BARBLO="m"_BARBLO
 .S BARTPAY=BARTPAY+$P(BARREC,U,6)
 .S BARTADJ=BARTADJ+$P(BARREC,U,7)
 .S BARSTOP=$$CHKLINE(1) Q:BARSTOP
 .S BARCMSG="      "
 .S:$P(BARREC,U,8)="3P CANCELLED" BARCMSG="3P CAN"
 .;start new code IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 .S BARTPB=$$FIND3PB^BARUTL(DUZ(2),BARHIT)
 .S:$G(BARTPB)'="" BARSTAT=$P($G(^ABMDBILL($P(BARTPB,","),$P(BARTPB,",",2),0)),U,4)
 .;end new code IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 .W !,$J(BARLIN,3),?6,$$SDT^BARDUTL($P(BARREC,U,1)),?18,BARBLO
 .W:($G(BARSTAT)="X") "*"  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.7.1
 .W ?25,BARCMSG
 .W ?32,$J($P(BARREC,U,3),8,2)
 .W ?49,$J($P(BARREC,U,6),8,2)
 .W ?60,$J($P(BARREC,U,7),8,2)
 .W ?71,$J($P(BARREC,U,5),8,2)
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
 W ?(IOM-15),"Page: "_BARPG,!!
 D SUBHD^BARPST2(.BARCOL,.BARITM,$G(BARPMT))
 W !!?40,"Billed",?50,"Current",?61,"Current",?72,"Current"
 W !,"Line #",?8,"DOS",?18,"Claim #",?40,"Amount",?50,"Paymnts",?62,"Adjust",?72,"Balance"
 S BARDSH=""
 S $P(BARDSH,"-",IOM)=""
 W !,BARDSH
 Q
 ; *********************************************************************
 ;
CHKLINE(BARHD) ;
 ; Q 0 = CONTINUE
 ; Q 1 = STOP
 N X
 I ($Y+5)<IOSL Q 0
 W !?(IOM-15),"continued==>"
 D EOP^BARUTL(0)
 I 'Y Q 1
 I BARHD=0 D HEAD
 I BARHD=1 D HEAD1
 ;
ECHKLINE ;
 Q 0
