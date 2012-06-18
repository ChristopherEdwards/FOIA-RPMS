BARPUC2 ; IHS/SD/LSL - UNALLOCATED PATIENT LOOKUP ; 01/26/2009 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**17**;OCT 26, 2005
 ;
 ;** patient a/r lookup based on from/thru dos
 ;** called from ^BARPST
 ;** BARPASS = PATDFN^BEGDOS^ENDDOS
 ;** builds an array that includes all entries from a/r that meet the
 ;   criteria.
 ; *********************************************************************
 ;
EN(BARPASS)        ;EP
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
 S DR=".01;3;13;15"
 S DIQ="BARBLV("
 S BARCNT=0
 F  S BARDT=$O(^BARBL(DUZ(2),"ABC",BARPAT,BARDT)) Q:'BARDT!(BARDT>BAREND)  D
 . S BARBDA=0
 . F  S BARBDA=$O(^BARBL(DUZ(2),"ABC",BARPAT,BARDT,BARBDA)) Q:'BARBDA  D
 .. S DA=BARBDA
 .. D EN^XBDIQ1
 .. S BARCNT=BARCNT+1
 .. S ^BARTMP($J,BARBDA,BARCNT)=BARDT_U_BARBLV(.01)_U_BARBLV(13)_U_BARBLV(3)_U_BARBLV(15)
 .. S ^BARTMP($J,"B",BARCNT,BARBDA)=""
 .. K BARBLV
 Q BARCNT
 ; *********************************************************************
 ;
HIT(BARPASS) ;
 ; ** display a/r bills found
 N BARBDA,BARLIN,BARREC,BARBLO
 S (BARBDA,BARPG,BARSTOP)=0
 D HEAD
 F  S BARBDA=$O(^BARTMP($J,BARBDA)) Q:'BARBDA  D  Q:BARSTOP
 . S BARLIN=$O(^BARTMP($J,BARBDA,""))
 . S BARREC=^BARTMP($J,BARBDA,BARLIN)
 . S BARBLO=$P(BARREC,U,2)
 . I $D(^BARTR(DUZ(2),"AM4",+BARBLO)) S BARBLO="m"_BARBLO
 . S BARSTOP=$$CHKLINE(0) Q:BARSTOP
 . W !,BARLIN
 . W ?6,$$SDT^BARDUTL($P(BARREC,U,1))
 . W ?18,BARBLO
 . W ?32,$J($P(BARREC,U,3),8,2)
 . W ?44,$E($P(BARREC,U,4),1,23)
 . W ?70,$J($P(BARREC,U,5),8,2)
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
 W ?(IOM-15),"Page: "_BARPG
 W !!?32,"Billed",?70,"Current"
 W !,"Line #",?8,"DOS",?18,"Claim #",?32,"Amount",?44,"Billed To",?70,"Balance"
 S BARDSH=""
 S $P(BARDSH,"-",IOM)=""
 W !,BARDSH
 Q
 ; *********************************************************************
 ;
HIT1(BARPASS) ; EP
 ; ** display a/r bills found
 N BARHIT,BARLIN,BARREC,BARBLO
 S (BARTPAY,BARTADJ,BARHIT,BARPG,BARSTOP)=0
 D HEAD1
 F  S BARHIT=$O(^BARTMP($J,BARHIT)) Q:'BARHIT  D  Q:BARSTOP
 . S BARLIN=$O(^BARTMP($J,BARHIT,""))
 . S BARREC=^BARTMP($J,BARHIT,BARLIN)
 . S BARBLO=$P(BARREC,U,2)
 . I $D(^BARTR(DUZ(2),"AM4",+BARBLO)) S BARBLO="m"_BARBLO
 . S BARTPAY=BARTPAY+$P(BARREC,U,6)
 . S BARTADJ=BARTADJ+$P(BARREC,U,7)
 . S BARSTOP=$$CHKLINE(1) Q:BARSTOP
 . W !,BARLIN
 . W ?6,$$SDT^BARDUTL($P(BARREC,U,1))
 . W ?18,BARBLO
 . W ?32,$J($P(BARREC,U,3),8,2)
 . W ?44,$J($P(BARREC,U,6),8,2)
 . W ?56,$J($P(BARREC,U,7),8,2)
 . W ?70,$J($P(BARREC,U,5),8,2)
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
 Q 0
  ; Begin new code BAR*1.8*17 ADD COMMENTS ENTRY TO PUC ITEMS
 ; - per Adrian 2/12/10 PKD:BAR*1.8.17 2/12/10
ITMSG  ;
 ;BAR1.8*17 PKD 2/24/2010
 W !!!,"Create a New Message for: "
 W !!,"Credit",?10,"Account",?42,"Batch",?71,"Item"
 W !?8,"TRANS DATE",?32,"ALLOW CAT",?46,"TDN",?68,"STATUS"
 W !
 S BARDSH=""
 S $P(BARDSH,"-",80)="" W BARDSH
 ;
 W $J(BARTX(2),8,2)
 W ?10,$E(BARTX(6),1,30),?42,BARTX(14)
 W ?71,BARTX(15)  ;coll. item
 S D0=BARTX(6,"I")
 I D0']"" D  Q    ;MRS:BAR*1.8*7 IM30586
 .W !,"** ERROR--MISSING ALLOCATION INFO "
 .D EOP^BARUTL(1)
 S BARALLC=$$VALI^BARVPM(8)
 S Y=$P(BARTX("ID"),":") D DD^%DT
 W !?8,Y,?32,$P($T(@BARALLC),";;",2)
 W ?46
 W $S($G(BARTX(17))'="":BARTX(17),$$GET1^DIQ(90051.1101,BARTX(15,"I")_","_BARTX(14,"I")_",",20,"E")'="":$$GET1^DIQ(90051.1101,BARTX(15,"I")_","_BARTX(14,"I")_",",20,"E"),1:"<NO TDN>")
 W ?68,$S($O(^BAR(90052,"D",BARTX(14),0))'="":"LETTER",1:"")
 ;
 K DIE,DIC,DA,DIR
 S DA(1)=BARTX(14,"I"),DA=BARTX(15,"I")
 S DR=107  ; SubFile ITEMS in A/R Collect Batch - Question #107:  PUC comments
 S DIE="^BARCOL("_DUZ(2)_","_DA(1)_",1,"
 D ^DIE
 Q
 ;
PRTQ ; Ask whether to print comments on Letters to Finance 1.8.17 2/25/10 PKD
 Q:$G(^BARCOL(DUZ(2),BARTX(14,"I"),1,BARTX(15,"I"),7,0))=""
 K DIR
 W !!,?31,"**Messages Exist**",!
 S DIR("A")="Do you want them to print on the letter? ",DIR("B")="YES",DIR(0)="YOA"
 D ^DIR
 I Y=1 S BARPRTQ=1
 Q
