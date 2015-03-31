BARPST ; IHS/SD/LSL - PAYMENT BATCH POSTING JAN 15,1997 ; 07/14/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**6,7,13,15,19,21,22,23**;OCT 26, 2005;Build 38
 ;;
 ; IHS/SD/LSL - 07/31/2002 - V1.7 - NOIS HQW-0302-100213
 ;     Modified BATW to also display batch name.
 ; 
 ; IHS/SD/SDR 6/4/09 HEAT5219 BAR*1.8*13
 ;     Restrict sites from posting batches prior to 01/01/09, 
 ;     (effective at sites 07/01/09)
 ;
 ; IHS/SD/TMM 12/21/09 M3  HEAT9506 BAR*1.8*15
 ;                         Restrict sites from posting batches prior to 2 quarters 
 ;                         ago.  (effective 1/1/10) 
 ;
 ; IHS/SD/TMM 12/21/09 M4  BAR*1.8*19
 ;                         Lockdown date not working correctly for batches in 12/2009.
 ; P.OTT SEP 2012 HEAT#83479 FIXING BUG IF DATA IS MISSING IN I $D(^BAREDI("I",DUZ(2),BAR,0))
 ; *********************************************************************
 ;
EN ;EP -  lookup collection id
 D ^BARVKL0
 S BARESIG=""
 D SIG^XUSESIG
 Q:X1=""  ;elec signature test
 S BARESIG=1
 D RAYGO
 ; -------------------------------
 ;
ENTRY ;
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) G FINISH  ;IS SESSION STILL OPEN
 I '$D(BARUSR) D INIT^BARUTL
 W !!
 K DIC,BARCOL
 S DIC="^BARCOL(DUZ(2),"
 S DIC(0)="SAEZQM"
 S DIC("A")="Select Batch: "
 S DIC("S")="I $P(^(0),U,3)=""P""&($G(BARUSR(29,""I""))=$P(^(0),U,10))"
 S DIC("W")="D BATW^BARPST"
 K DD,DO
 D ^DIC
 K DIC
 I Y'>0 G FINISH
 I '$$CKDATE^BARPST(+Y,1,"SELECT A/R COLLECTION BATCH") G ENTRY  ;DISALLOW POSTING TO OLD BATCHES;MRS;BAR*1.8*6 DD 4.2.4
 S BARCOL=+Y
 S BARCOL(0)=Y(0)
 D BBAL(BARCOL)
 ; -------------------------------
 ;
ITEM ;
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) G FINISH  ;IS SESSION STILL OPEN
 W !!
 K BARITM
 S DA(1)=BARCOL
 S DIC="^BARCOL(DUZ(2),"_DA(1)_",1,"
 S DIC(0)="AEMQZ"
 S DIC("W")="D DICW^BARPST"
 S DIC("A")="Select Batch Item: "
 S DIC("S")="I $P(^(0),U,17)'=""C""&($P(^(0),U,17)'=""R"")"
 K DD,DO
 D ^DIC
 K DIC
 I +Y<1 G ENTRY
 S BARITM=+Y
 S BARITM(0)=Y(0)
 D IBAL(BARITM)
 ; -------------------------------
 ;
GETSUB ;
 K BAREOB
 I $P(BARITM(0),U,17)'="E" G GETPAT
 I '+$P(^BAR(90052.06,DUZ(2),DUZ(2),0),U,2) G GETPAT
 W !!
 S DA(2)=+BARCOL
 S DA(1)=+BARITM
 D ^XBSFGBL(90051.1101601,.BARGL)
 S DIC=$P(BARGL,"DA,",1)
 S DIC(0)="AEMQZ"
 S DIC("W")="W ?20,$J($P(^(0),U,2),8,2)"
 S DIC("A")="Select Visit Location: "
 K DD,DO
 D ^DIC
 K DIC
 I +Y<1 D  G ITEM
 .W !!!
 .W "Select Batch: "_$P(BARCOL(0),U,1)
 .S Y=BARCOL
 .D BATW1,BBAL(BARCOL)
 .Q
 S BAREOB=+Y
 S BAREOB(0)=Y(0)
 D EBAL(BAREOB)
 ; -------------------------------
 ;
GETPAT ;
 ; ** get patient and dos range
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) G FINISH  ;IS SESSION STILL OPEN
 S BARPASS=$$EN^BARPST1()
 I +BARPASS=0 D  G ITEM
 .I +$G(^BARVSIT(4))>0!(+$G(BARCLIT(19))>0) D
 ..K DIR
 ..S DIR(0)="Y"
 ..S DIR("A")="Do you want to POST any of the unposted balance to UNALLOCATED CASH"
 ..S DIR("B")="NO"
 ..D ^DIR
 ..K DIR
 ..I Y'=1 Q
 ..D UNALC^BARPST7(+BARCL("ID"),+BARCLIT("ID"),+$G(BARVSIT("ID")))
 .W !!!,"Select Batch: "_$P(BARCOL(0),U,1)
 .S Y=BARCOL
 .D BATW1,BBAL(BARCOL)
 .Q
 S BARCNT=$$EN^BARPST2(BARPASS)
 I 'BARCNT D  G GETPAT
 .W *7
 .W "No bills found in this date range!"
 .D EOP^BARUTL(1)
 .D TOP^BARPST1(0)
 D EN^BARPST3
 D TOP^BARPST1(0)
 G GETPAT
 ; *********************************************************************
 ;
BATW ;EP - dic DIC("W")
 ;
BATW1 ;
 N X,DA,DIC,DIQ,XB,DR
 K BARCL
 S DA=+Y
 S DR=".01;4;8;15;16;17"
 S DIQ="BARCL("
 S DIC="^BARCOL(DUZ(2),"
 D EN^XBDIQ1
 W ?20,$E(BARCL(.01),1,35),?58,$E(BARCL(8),1,20)
 Q
 ; *********************************************************************
 ;
BBAL(BARCOL) ;EP
 ; ** display batch posting balance and total
 N DA,DIC,DIQ,XB,DR
 K BARCL
 S DA=BARCOL
 S DR="15:17"
 S DIQ="BARCL("
 S DIC="^BARCOL(DUZ(2),"
 D EN^XBDIQ1
 W !?5,"===> Total Posted: $ "_$J(BARCL(16),0,2)
 W ?37,"===> Remaining Balance: $ "_$J(BARCL(17),0,2)
 Q
 ; *********************************************************************
 ;
DICW ;EP -  help display on item lookup
 Q:$G(DZ)'["?"
 D ^XBNEW("DICW1^BARPST:Y;BARCOL*")
 Q
 ; *********************************************************************
 ;
DICW1 ;EP
 K BARCLIT
 N DIC,DA,DR,DIQ
 Q:'+Y
 S (DA,BARITDA)=+Y
 S DIQ="BARCLIT("
 S DIQ(0)="I"
 S DIC=90051.1101
 S DA(1)=+BARCOL
 S DR="2;2.5;7;11;101"
 D EN^XBDIQ1
 W ?7,$J($E(BARCLIT(11),1,9),10)
 W:$L(BARCLIT(11))>9 "*"
 W ?18,$J(BARCLIT(101),8,2),?28,BARCLIT(7),?58,$E($G(BARCLIT(2.5)),1,2)
 Q
 ; *********************************************************************
 ;
IBAL(BARITM) ;EP
 ; ** display item balance and posting total
 K BARCLIT
 N DIC,DA,DR,DIQ
 Q:'+BARITM
 S (DA,BARITDA)=+BARITM
 S DA(1)=+BARCOL
 S DIC=90051.1101
 S DIQ="BARCLIT("
 S DR="18;19;101"
 D EN^XBDIQ1
 W !?3,"===> Item Total Posted: $ "_$J(BARCLIT(18),0,2)
 W ?42,"===> Item Remaining Balance: $ "_$J(BARCLIT(19),0,2)
 Q
 ; *********************************************************************
 ;
EBAL(BAREOB) ;EP
 ; ** display item balance and posting total
 N DA,DIQ,DIC,DR
 K BARVSIT
 S DA=BAREOB
 S DA(1)=+BARITM
 S DA(2)=+BARCOL
 S DIC=90051.1101601
 S DIQ="BARVSIT("
 S DR="2;3;4"
 D EN^XBDIQ1
 W !?0,"===> Sub-Item Total Posted: $ "_$J(BARVSIT(3),0,2)
 W ?39,"===> Sub-Item Remaining Balance: $ "_$J(BARVSIT(4),0,2)
 Q
 ; *********************************************************************
 ;
FINISH ;
 D ^BARVKL0
 Q
 ; *********************************************************************
 ;
RAYGO ;EP
 ; set roll-over flag
 K BARRAYGO,DIR
 S BARRAYGO=$P($G(^BAR(90052.06,DUZ(2),DUZ(2),0)),"^",13)
 I BARRAYGO="Y" S BARRAYGO=1 Q
 I BARRAYGO="N" S BARRAYGO=0 Q
 S DIR("A")="Roll-over as you post"
 S DIR("B")="NO"
 S DIR(0)="Y"
 S DIR("?")="Enter 'YES' to roll A/R bills back to 3P during posting."
 W !
 D ^DIR
 K DIR
 S BARRAYGO=Y
 Q
 ;
CKDATE(Z,Q,P) ;EP; NEW; CHECK COLLECTION BATCH DATE ;MRS;BAR*1.8*6 DD 4.2.4
 ;ENTERS WITH: Z = COLLECTION BATCH IEN
 ;             Q = 0=SILENT OR 1=VERBOSE
 ;             P = TYPE (ERA or COLLECTION BATCH CHECK) ALSO CALLED BY BAREDP00
 ;I DUZ=902 Q 1
 N X,Y,BAR
 I '$$IHS^BARUFUT(DUZ(2)) Q 1  ;
 ;;;I '$$IHSERA^BARUFUT(DUZ(2)) Q 1  ;P.OTT
 I Z="",P["COLLECTION" D  Q 0          ;MRS;BAR*1.8*7 IM30386
 .N BARBIL
 .S BARBIL=$$GET1^DIQ(90050.03,BARTX_",",4,"E")
 .W !,"SESSION ID "_UFMSESID_" HAS TRANSACTION "_BARTX
 .W:BARBIL]"" !,"FOR A/R BILL # "_BARBIL
 .W !,"WITH MISSING COLLECTION BATCH, NOTIFY OIT SUPPORT"
 .D EOP^BARUTL(1)
 ;***BEGIN ADD***     ;M3*TMM*12/21/09*ADD
 ;N BARYYY,BARYYY2,BARYYY3,BARMM,BARTMP,BARQTR,BARL1,BARL2,BARL3,BARL4,BARL5,BARL6
 S BARYYY=$E(DT,1,3)
 S BARMM=$E(DT,4,5)
 S BARTMP=+BARMM
 S BARQTR=$P($T(LOCKDOWN+BARTMP),";;",2)     ; quarter dates
 S BARL1=$P(BARQTR,"^",1)                    ;*current month (for current month, use this line of data)
 S BARL2=$P(BARQTR,"^",2)                    ;*last day of month/lock down period
 S BARL3=$P(BARQTR,"^",3)                    ; first day of month after the lock down/cut off date
 S BARL4=$P(BARQTR,"^",4)                    ;*month/quarter lockdown begins (lock down based on quarter, not month)
 S BARL5=$P(BARQTR,"^",5)                    ;*use current(0) or prior year(1)
 S BARL6=$P(BARQTR,"^",6)                    ;*use current(0) or prior year(1)
 S BARYYY2=BARYYY-BARL5
 S BARYYY3=BARYYY-BARL6
 S BARL2=BARYYY2_BARL2                       ;last date of lock down period
 S BARL3=BARYYY3_BARL3                       ;first available date after lock down period
 ;W !,"BARL2=",BARL2
 ;S X=DT>BARL2
 ;W !,"DT>BARL2=",X
 ;W !,"DT=",DT
 ;M4*DEL*TMM*20100714  I DT>BARL2 S BARCDT=BARYYY2_BARL4_"00"
 I DT>BARL2 S BARCDT=$E(BARL3,1,5)_"00"        ;M4*ADD*TMM*20100714
 I DT<BARL3 S BARCDT=3051000                 ;oldest collection date allowed (lockdown date)
 ;W !,"BARCDT=",BARCDT
 S BARL3MM=$E(BARL3,4,5)
 S BARL3DD=$E(BARL3,6,7)
 S BARL3YY=$E(BARL3,1,3)+1700
 S BARL3FMT=BARL3MM_"/"_BARL3DD_"/"_BARL3YY
 ;
 I P["COLLECTION",($P(^BARCOL(DUZ(2),+Z,0),U,4)>BARCDT) Q 1
 ;-------------------------------------REWRITE P.OTT
 I P["ERA" D  I $G(Y)>BARCDT Q 1
 . S Y=0,BAR=$$GETONE(Z) ;W !,"RETURNED BAR=",BAR
 . I 'BAR W !!,"Cannot find filename in A/R EDI IMPORT File" Q
 . S X=$P($P($G(^BAREDI("I",DUZ(2),BAR,0)),U,2),"@",1)  ;RETURN DATE 
 . S %DT="" D ^%DT ;RETURN Y (DATE)
 . QUIT
 ;--------------------------------------
 I P["ERA" D  I $G(Y)>BARCDT Q 1
 .;some files have 30 characters; some have full name; check for both
 .S BAR=$O(^BAREDI("I",DUZ(2),"C",Z,""))
 .S:BAR="" BAR=$O(^BAREDI("I",DUZ(2),"C",$E(Z,1,30),""))
 .I BAR="" W !!,"Cannot find filename in A/R EDI IMPORT File"
 .;end new code HEAT56444
 .Q:BAR=""                                  ;MRS:BAR*1.8*7 IM30386
 .S X=$P($P($G(^BAREDI("I",DUZ(2),BAR,0)),U,2),"@",1)
 .S %DT=""
 .D ^%DT
 I P["ERA",(BAR="") Q  ;bar*1.8*22 SDR HEAT56444
 I Q D
 .W !!,"CANNOT "_P_" OLDER THAN "_$S(DT>BARL2:BARL3FMT,1:"10/01/2005")  ;M3*TMM*12/21/09*ADD
 .D EOP^BARUTL(1)
 Q 0
 ;
GETONE(BARZNAM) ;P.OTT
 NEW BARFN1,BARFN2
 SET BARFN1=BARZNAM,BARFN2=$E(BARZNAM,1,30),CNT=0
 S BAR="" F  S BAR=$O(^BAREDI("I",DUZ(2),"C",BARFN1,BAR)) Q:BAR=""  I $D(^BAREDI("I",DUZ(2),BAR,0)) Q
 I BAR Q BAR
 ;some files have 30 characters; some have full name; check for both
 S BAR="" F  S BAR=$O(^BAREDI("I",DUZ(2),"C",BARFN2,BAR)) Q:BAR=""  I $D(^BAREDI("I",DUZ(2),BAR,0)) Q
 I BAR Q BAR
 Q 0  ;NO DATA FOUND: RETURN ZERO
 ;
LOCKDOWN ;;$T quarter lockdown for posting   ;M3*TMM*12/21/09*ADD TAG
 ;;01^0630^0701^07^1^1
 ;;02^0630^0701^07^1^1
 ;;03^0630^0701^07^1^1
 ;;04^0930^1001^10^1^1
 ;;05^0930^1001^10^1^1
 ;;06^0930^1001^10^1^1
 ;;07^1231^0101^01^1^0
 ;;08^1231^0101^01^1^0
 ;;09^1231^0101^01^1^0
 ;;10^0331^0401^04^0^0
 ;;11^0331^0401^04^0^0
 ;;12^0331^0401^04^0^0
 ;;end of list
 Q
