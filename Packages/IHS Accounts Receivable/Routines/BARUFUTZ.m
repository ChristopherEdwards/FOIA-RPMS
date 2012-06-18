BARUFUTZ ; IHS/SD/TPF - UTILITY TO CLEAR TRANSMITTED FLAGS ; 12/12/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**10**;OCT 26, 2005
 ;NEW ROUTINE ;MRS:BAR*1.8*10 D148-2
 Q
 ;
EN ;EP; CLEAR TRANSMITTED FLAGS TO ALLOW RE-TRANSMISSION
 ; ********************************************************************
 K BAR
 N BARFILE,UDUZ,BARID,BARN
 S BARFILE=$$FILE                        ;GET FILE NAME
 I BARFILE=0 D MSG(0) Q
 ;
 D SESS(BARFILE)                         ;BUILD ARRAY OF SESSIONS
 I '$D(BAR) D MSG(2) Q
 ;
 S UDUZ=0
 F  S UDUZ=$O(BAR(UDUZ)) Q:'UDUZ  D
 .S BARID=0
 .F  S BARID=$O(BAR(UDUZ,BARID)) Q:BARID=""  D
DIAG ..W !,UDUZ,"@",BARID,"@"
 ..S BARN=0
 ..F  S BARN=$O(BAR(UDUZ,BARID,BARN)) Q:'BARN  D
 ...S BARFNM=BAR(UDUZ,BARID,BARN)
 ...W BARFNM
 ...D CLEAR(UDUZ,BARID)                  ;CLEAR FLAGS
 ...K ^BARSESS(DUZ(2),"FN",BARFNM,BARID,UDUZ,BARN)   ;CLEAR "FN" CROSS-REFERENCE
 W !,"SESSIONS CLEARED "
 D EOP^BARUTL(1)
 Q
 ;
SESS(BARFILE) ;FIND UDUZ AND SESSIONS IN FILE
 ;Example of FN cross-reference
 ;^BARSESS(1575,"FN","835_232101_20081031_122246",3081031.122134,835,1)
 N BARFN,BARID,BARZ,BARN
 I '$D(^BARSESS(DUZ(2),"FN")) D MSG(1) Q
 S BARFN=0                                  ;ABREVIATED FILE NAME
 F  S BARFN=$O(^BARSESS(DUZ(2),"FN",BARFN)) Q:'BARFN  D
 .Q:BARFILE'[BARFN                          ;NOT CORRECT FILE
 .S BARID=0                                 ;SESSION ID
 .F  S BARID=$O(^BARSESS(DUZ(2),"FN",BARFN,BARID)) Q:BARID=""  D
 ..S BARZ=0                                 ;UDUZ OF CASHIER
 ..F  S BARZ=$O(^BARSESS(DUZ(2),"FN",BARFN,BARID,BARZ)) Q:'BARZ  D
 ...S BARN=0                                ;MULTIPLE IDEX
 ...F  S BARN=$O(^BARSESS(DUZ(2),"FN",BARFN,BARID,BARZ,BARN)) Q:'BARN  D
 ....S BAR(BARZ,BARID,BARN)=BARFN           ;RE-ORDER
 Q
 ; ********************************************************************
 ;
DELSFLG(UDUZ,SESSID,DA) ;EP - DELETE SESSION 'TRANSMITTED DATE' FLAG
 ;
 K DIR,DIE,DR,DIC
 S DA(2)=UDUZ
 S DA(1)=SESSID
 S DR=".04///@"
 S DIE="^BARSESS(DUZ(2),"_DA(2)_",11,"_DA(1)_",2,"
 D ^DIE
 Q
 ; ********************************************************************
 ;
DELFLG(DA) ;EP - DELETE SESSION 'TRANSMITTED DATE' FLAG
 ;
 K DIR,DIE,DR,DIC
 S DR="602///@"
 S DIE="^BARTR(DUZ(2),"
 D ^DIE
 Q
 ; ********************************************************************
 ;
CLEAR(UDUZ,SESSID) ;CLEAR FLAGS
 N TRDATE,BARTMP,BAROK
 S TRDATE=0
 F  S TRDATE=$O(^BARSESS(DUZ(2),UDUZ,11,SESSID,2,TRDATE)) Q:'TRDATE  D
 .S BARTMP=$G(^BARTR(DUZ(2),TRDATE,6))
DIAG1 .W !,"@@@",TRDATE,"@",$P(BARTMP,U),"@",$P(BARTMP,U,2),"@",$P(BARTMP,U,3),"@",$P(BARTMP,U,4)
 .D DELSFLG(UDUZ,SESSID,TRDATE)
 .D DELFLG(TRDATE)
 S BAROK=$$OPEN
 I 'BAROK W "  ",SESSID
 Q
 ; ********************************************************************
 ;
OPEN() K DIC,DIE,DR,DA,DIR
 S DA(1)=UDUZ
 S X=SESSID
 S DIC(0)="X"
 S DIC="^BARSESS(DUZ(2),"_DA(1)_",11,"
 D ^DIC
 Q:Y<0 0
 S X=$$SETSESS(UDUZ,$P(Y,U,2),"RV") Q:X=0 0  ;set this session to REVIEWED STATUS
 Q SESSID
 ; ********************************************************************
 ;
FILE() ;
 N FN,ANS,Z
 K DIR
 S DIR(0)="FO"
 S DIR("?")="Enter a file name e.g. IHS_AR_RPMS_RCV_398_113510_20070806_0847.DAT,"
 S DIR("A")="Enter exact filename "
 D ^DIR
 I $D(DTOUT)!$D(DIROUT)!$D(DUOUT)!(Y="")!(Y=" ") Q 0
 S FN=Y
 S Z="ARE YOU SURE YOU WANT TO CLEAR FLAGS FOR FILE "_FN
 D ASK(Z,.ANS)
 Q:'ANS 0
 Q FN
 ; ********************************************************************
 ;
MSG(Z) ;MESSAGE CENTER
 I Z=0 W !,"FIND CORRECT FILE NAME"
 I Z=1 W !,"FILE NAME COULD NOT BE FOUND IN SESSION FILE"
 I Z=2 W !,"NO SESSIONS FOR FILE NAME, UNABLE TO CLEAR FLAGS"
 D EOP^BARUTL(1)
 Q
 ; ********************************************************************
 ;
SETSESS(UDUZ,SESSID,BARSTAT) ;EP - SET SESSION STATUS 'BARSTAT'
 Q:$G(BARSTAT)=""
 S STATCHG=$$ADDSTAT^BARUFUT(UDUZ,SESSID)  ;CREATE A NEW STATUS CHANGE DATE/TIME
 I +STATCHG<1 D  Q 0
 .W !!,"UNABLE TO MAKE A CHANGE IN STATUS FOR SESSION ID ",SESSID
 .K DIR
 .S DIR(0)="E"
 .D ^DIR
 K DIC,DIE,DR,DA,DIR
 S DA(2)=UDUZ
 S DA(1)=SESSID
 S DA=$P(STATCHG,U)
 S DR=".02///^S X=BARSTAT;.03////^S X=DUZ"
 S DIE="^BARSESS(DUZ(2),"_DA(2)_",11,"_DA(1)_",1,"
 D ^DIE
 K DIC,DIE,DR,DA,DIR
 I $G(MODE)="CASHIER" K UFMSESID
 Q 1
 ; ********************************************************************
 ;
ADDSTAT(UDUZ,SESSID) ; EP - ;CREATE A NEW STATUS CHANGE DATE/TIME
 K DIC,DIE,DR,DA,DIR
 D NOW^%DTC
 S X=%
 S DA(2)=UDUZ
 S DA(1)=SESSID
 S DIC("P")=$P(^DD(90057.11,110101,0),U,2)
 S DIC="^BARSESS(DUZ(2),"_DA(2)_",11,"_DA(1)_",1,"
 S DIC(0)="L"
 D ^DIC
 Q:Y<0 0
 Q Y
 ; ********************************************************************
 ;
ASK(Z,Y) ;
 K DIR
 S DIR(0)="YO"
 S DIR("A")=Z
 S DIR("B")="NO"
 D ^DIR
 Q
