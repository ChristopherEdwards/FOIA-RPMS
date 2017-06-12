APSPAUTO ;IHS/CIA/PLS - Auto Release Prescription ;27-May-2014 10:23;PLS
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1002,1006,1008,1013,1014,1015,1017,1018**;Sep 23, 2004;Build 21
 ; This routine contains code from PSODISP and PSODISPS.
 ; Call to OREL^PSOCMOPB was changed to include one parameter.
AUTOREL ; EP
 N APSPZRP,APSP1,PSRH,PSIN,APSPRXP,POERR,APSPREL
 S APSPREL=$$GET1^DIQ(9009033,+PSOSITE,314,"I")
 ;S APSPZRP=$G(PSORX("PSOL",1))
 ;I $G(VEXRX)
 S APSPZRP=$G(PPL)
 ;IHS/MSC/PLS - 6/15/09 - Added PSOPULL for suspense processing
 ;              7/07/09 - Added PSOSUSPR for suspense processing
 I $G(PSOFROM)="NEW"!($G(PSOFROM)="REFILL")!($G(PSOFROM)="FAST")!($D(PCOMH))!($G(PSOPULL))!($G(PSOSUSPR))!($G(PSOFROM)="PARTIAL")&($D(^XUSEC("PSORPH",DUZ))) D
 .Q:$G(APSPZRP)']""
 .F APSP1=1:1 Q:$P(APSPZRP,",",APSP1)=""  S RXP=$P(APSPZRP,",",APSP1) D
 ..S PSRH=DUZ,PSIN=$P($G(^PS(59.7,1,49.99)),"^",2)
 ..S APSPRXP=RXP
 ..D:APSPREL AC(1)  ; 1=Don't Print info lines ; Call conditional on AUTORELEASE Flag set to YES
 ..I $G(PSOFROM)'="PARTIAL" D
 ...; IHS/CIA/PLS - 02/02/05 - Added check for prescription status
 ...;IHS/MSC/PLS - 04/01/2014 - Added check for existing POS entry
 ...D
 ....N REF
 ....S REF=$O(^PSRX(APSPRXP,1,$C(1)),-1)
 ....Q:$$STATCHK^APSPLBL(APSPRXP)
 ....Q:$$EXISTPOS(APSPRXP,REF)
 ....D CALLPOS^APSPFUNC(APSPRXP,REF,"A")
 Q
 ; Returns presence of Prescription/Refill in Point Of Sale
EXISTPOS(RXIEN,RFIEN) ;EP-
 N RES
 S RES=0
 I '$$TEST^APSQBRES("ABSPOSRX") D
 .S RES=$$STATUS59^ABSPOSRX(RXIEN,$G(RFIEN,0))'=""
 Q RES
AC(APSPNOP) ; EP - Autorelease prescription
 N DA,DR,DIE,X,X1,X2,Y,CX,PX,REC,DIR,YDT,REC,RDUZ,DIRUT,PSOCPN,PSOCPRX,YY
 N QDRUG,QTY,TYPE,XTYPE,DUOUT,OUT
AC1 W:'$G(APSPNOP) ! S PSIN=+$P($G(^PS(59.7,1,49.99)),"^",2)
BC ;
 K MAN  I $D(DISGROUP),$D(BINGNAM),($D(BINGDIV)!$D(BNGPDV)!$D(BNGRDV)),($D(BINGRO)!$D(BINGRPR)) D
 .D REL^PSOBING1
 .K BINGNAM,BINGDIV,BINGRO,BINGRPR,BNGPDV,BNGRDV
 Q:$G(POERR)
 K ISUF,DIR,LBL,LBLP
 I $D(^PSRX(RXP,0)) D  G BC1
 .S PSOLOUD=1 D:$P($G(^PS(55,+$P(^PSRX(+RXP,0),"^",2),0)),"^",6)'=2 EN^PSOHLUP($P(^PSRX(+RXP,0),"^",2)) K PSOLOUD
BC1 ;
 I +$P($G(^PSRX(+RXP,"PKI")),"^") D  Q:$G(POERR)  G BC
 .I $G(SPEED) W:'$G(APSPNOP) !!?7,$C(7),$C(7),"Rx# "_$P(^PSRX(RXP,0),"^") S PSOLIST=4
 .W:'$G(APSPNOP) !!,?7,"UNABLE TO RELEASE - THIS ORDER MUST BE RELEASED THROUGH THE OUTPATIENT",!,?7,"RX'S [PSD OUTPATIENT] OPTION IN THE CONTROLLED SUBSTANCE MENU"
 ;IHS/MSC/PLS - 10/23/07 - Suppress Delete Prescription prompt.
 ;I +$P($G(^PSRX(+RXP,"STA")),"^")=13!(+$P($G(^PSRX(+RXP,0)),"^",2)=0) W:$G(APSPNOP) !?7,$C(7),$C(7),"    PRESCRIPTION IS A DELETED PRESCRIPTION NUMBER" Q
 I +$P($G(^PSRX(+RXP,"STA")),"^")=13!(+$P($G(^PSRX(+RXP,0)),"^",2)=0) Q
 ;drug stocked in Drug Acct Location?
 S PSODA(1)=$S($D(^PSD(58.8,+$O(^PSD(58.8,"AOP",+PSOSITE,0)),1,+$P(^PSRX(RXP,0),U,6))):1,1:0)
 I $P(^PSRX(RXP,2),"^",13) S Y=$P(^PSRX(RXP,2),"^",13) X ^DD("DD") S OUT=1 D  K OUT Q
 .W:'$G(APSPNOP) !!?7,$C(7),$C(7),$S($G(SPEED):"Rx# "_$P(^PSRX(RXP,0),"^"),1:"Original prescription")_" was last released on "_Y,!?7,"Checking for unreleased refills/partials " D REF
BATCH ;
 I $P(^PSRX(RXP,2),"^",15),'$P(^(2),"^",14) S RESK=$P(^(2),"^",15)  W:'$G(APSPNOP) !!?5,"Rx# "_$P(^PSRX(RXP,0),"^")_" Original Fill returned to stock on "_$E(RESK,4,5)_"/"_$E(RESK,6,7)_"/"_$E(RESK,2,3),! G REF
 S PSOCPN=$P(^PSRX(RXP,0),"^",2),QTY=$P($G(^PSRX(RXP,0)),"^",7),QDRUG=$P(^PSRX(RXP,0),"^",6)
 ;original
 I '$P($G(^PSRX(RXP,2)),"^",13),+$P($G(^(2)),"^",2)'<PSIN S RXFD=$P(^(2),"^",2) D  D:$G(LBLP) UPDATE Q:+$G(OUT)  I $G(ISUF) D UPDATE G REF
 .S SUPN=$O(^PS(52.5,"B",RXP,0)) I SUPN,$D(^PS(52.5,"C",RXFD,SUPN)),$G(^PS(52.5,SUPN,"P"))'=1,'$P($G(^(0)),"^",5) S ISUF=1 Q
 .I $D(^PSDRUG("AQ",QDRUG)) K CMOP D OREL^PSOCMOPB(RXP) K CMOP I $G(ISUF) K ISUF,CMOP Q
 .F LBL=0:0 S LBL=$O(^PSRX(RXP,"L",LBL)) Q:'LBL  I '+$P(^PSRX(RXP,"L",LBL,0),"^",2),'$P(^(0),"^",5),$P(^(0),"^",3)'["INTERACTION" S LBLP=1
 .; IHS/MSC/PLS - 10/22/07 - suppress inventory mgmt if autofinished Rx.
 .;Q:'$G(LBLP)  S:$D(^PSDRUG(QDRUG,660.1)) ^PSDRUG(QDRUG,660.1)=^PSDRUG(QDRUG,660.1)-QTY
 .Q:'$G(LBLP)  S:$D(^PSDRUG(QDRUG,660.1)) ^PSDRUG(QDRUG,660.1)=^PSDRUG(QDRUG,660.1)-$S($P($G(^PSRX(RXP,999999921)),U,3):0,1:QTY)
 .D NOW^%DTC S DIE="^PSRX(",DA=RXP,DR="31///"_%_";23////"_PSRH_";32.1///@;32.2///@",PSODT=% D ^DIE K DIE,DR,DA,LBL
 .D EN^PSOHLSN1(RXP,"ZD")
 .;if appropriate update ^XTMP("PSA", for Drug Acct
 .I $G(PSODA),$G(PSODA(1)),'$D(^PSRX("AR",+PSODT,+RXP,0)) S ^XTMP("PSA",+PSOSITE,+QDRUG,+DT)=$G(^XTMP("PSA",+PSOSITE,+QDRUG,+DT))+QTY
REF ;release refills and partials
 K LBLP,IFN F XTYPE=1,"P" K IFN D QTY
 S:'XTYPE $P(^PSRX(RXP,"TYPE"),"^")=0
 D:$G(OUT) ADJEXPDT  ;IHS/MSC/PLS - 07/15/2013
 Q:+$G(OUT)!($G(POERR))
UPDATE I $G(ISUF) W:'$G(APSPNOP) $C(7),!!?7,"Prescription "_$P(^PSRX(RXP,0),"^")_" - Original Fill on Suspense !",!,$C(7) Q
 ; I +$G(^PSRX(RXP,"IB")) S PSOCPRX=$P(^PSRX(RXP,0),"^") D CP^PSOCP
 S PSOCPRX=$P(^PSRX(RXP,0),"^") D CP^PSOCP
 ;IHS/MSC/PLS - 10/13/2011
 ;IHS/MSC/PLS - 07/15/2013 - Changed to new EP
 ;I 1 D
 ;.N APSPEXPD,DIE,DA,DR
 ;.S APSPEXPD=$$EXPDT(RXP,1)
 ;.I APSPEXPD D
 ;..S DIE="^PSRX(",DA=RXP,DR="26///"_APSPEXPD D ^DIE
 D ADJEXPDT
 W:'$G(APSPNOP) !?7,"Prescription Number "_$P(^PSRX(RXP,0),"^")_" Released"
 ;initialize bingo board variables
 I $G(LBLP),$P(^PSRX(RXP,0),"^",11)["W" S BINGRO="W",BINGNAM=$P(^PSRX(RXP,0),"^",2),BINGDIV=$P(^PSRX(RXP,2),"^",9)
 S OUT=1
 Q
RXP S RXP=$O(^PSRX("B",X,RXP)) I $P($G(^PSRX(+RXP,"STA")),"^")=13 G RXP ;GET RECORD NUMBER FROM SCRIPT NUMBER
 Q
 ;
QTY S PSOCPN=$P(^PSRX(RXP,0),"^",2),QDRUG=$P(^PSRX(RXP,0),"^",6) K LBLP
 F YY=0:0 S YY=$O(^PSRX(RXP,XTYPE,YY)) Q:'YY  D:$P($G(^PSRX(RXP,XTYPE,YY,0)),"^")'<PSIN  K ISUF,LBLP
 .S RXFD=$E($P(^PSRX(RXP,XTYPE,YY,0),"^"),1,7),SUPN=$O(^PS(52.5,"B",RXP,0)) I SUPN,$D(^PS(52.5,"C",RXFD,SUPN)),$G(^PS(52.5,SUPN,"P"))'=1,$G(XTYPE) S ISUF=1 Q
 .I XTYPE=1,($D(^PSDRUG("AQ",QDRUG))) K CMOP D RREL^PSOCMOPB(RXP,YY) K CMOP Q:$G(ISUF)
 .I $P(^PSRX(RXP,XTYPE,YY,0),"^",$S($G(XTYPE):18,1:19))]""!($P(^(0),"^",16)) K IFN Q
 .F LBL=0:0 S LBL=$O(^PSRX(RXP,"L",LBL)) Q:'LBL  I $P(^PSRX(RXP,"L",LBL,0),"^",2)=$S('XTYPE:(99-YY),1:YY) S LBLP=1
 .Q:'$G(LBLP)  S IFN=YY S:$G(^PSDRUG(QDRUG,660.1))]"" QTY=$P(^PSRX(RXP,XTYPE,YY,0),"^",4),^PSDRUG(QDRUG,660.1)=^PSDRUG(QDRUG,660.1)-QTY
 .D NOW^%DTC I XTYPE=1 S DIE="^PSRX("_RXP_","_XTYPE_",",DA(1)=RXP,DA=YY,DR=17_"///"_%,^PSRX($S($G(XTYPE):"AL",1:"AM"),%,RXP,YY)="",$P(^PSRX(RXP,XTYPE,YY,0),"^",5)=PSRH
 .I XTYPE="P" S DA(1)=RXP,DIE="^PSRX("_DA(1)_",""P"",",DA=YY,DR=8_"///"_%,^PSRX($S($G(XTYPE):"AL",1:"AM"),%,RXP,YY)="",$P(^PSRX(RXP,XTYPE,YY,0),"^",5)=PSRH
 .L +^PSRX(RXP):20 D ^DIE K DIE,DR L -^PSRX(RXP) K DA
 .K PSODISPP S:$G(XTYPE)="P" PSODISPP=1 D EN^PSOHLSN1(RXP,"ZD") K PSODISPP
 .K:XTYPE ^PSRX("ACP",$P($G(^PSRX(RXP,0)),"^",2),$P($G(^PSRX(RXP,1,YY,0)),"^"),YY,RXP)
 .I XTYPE,$G(IFN),'$G(ISUF) S PSOCPRX=$P(^PSRX(RXP,0),"^") D CP^PSOCP
 .;if appropriate update ^XTMP("PSA", for Drug Acct.
 .I $G(PSODA),$G(PSODA(1)),'$D(^PSRX("AR",+PSODT,+RXP,YY)) D
 ..S ^XTMP("PSA",+PSOSITE,+QDRUG,DT)=$G(^XTMP("PSA",+PSOSITE,+QDRUG,DT))+$P($G(^PSRX(RXP,XTYPE,YY,0)),"^",4)
 .;initialize bingo board variables
 .I $G(IFN),$P($G(^PSRX(RXP,XTYPE,IFN,0)),"^",2)["W" S BINGRPR="W",BNGPDV=$P(^PSRX(RXP,XTYPE,IFN,0),"^",9),BINGNAM=$P($G(^PSRX(RXP,0)),"^",2)
 K IFN
 Q
ADJEXPDT ;EP-
 ;IHS/MSC/PLS - 10/13/2011
 N APSPEXPD,DIE,DA,DR
 S APSPEXPD=$$EXPDT(RXP,1)
 I APSPEXPD D
 .S DIE="^PSRX(",DA=RXP,DR="26///"_APSPEXPD D ^DIE
 Q
 ; Return updated expiration date
EXPDT(RX,AUTO,RDT) ;EP-
 ;CHECK FOR CALCULATED EXPIRATION DATE < CURRENT EXPIRATION DATE.
 N RES,NREF,RX0,DS,RFCNT,EXTEXP,DE,CS,OEXPDT,ISSDT
 S CS=0
 S AUTO=$G(AUTO,0)
 S RDT=+$G(RDT)  ;Release date
 S:'RDT RDT=DT   ;Default to today
 S RX0=^PSRX(RX,0)
 ; Quit if not autorelease, prescription has been released and no remaining dispenses
 I 'AUTO,$P($G(^PSRX(RX,2)),U,13),'$$RMNRFL^APSPFUNC(RX) Q 0
 S ISSDT=$P(RX0,U,13)
 S DE=+$$GET1^DIQ(50,$P(RX0,U,6),3)
 I DE>1,DE<6 S CS=1 S:DE=2 $P(CS,U,2)=1
 S RES=0
 S NREF=+$P(RX0,U,9)
 S DS=+$P(RX0,U,8)
 S EXTEXP=$$GET1^DIQ(50,$P(RX0,U,6),9999999.08)
 S X2=$S(EXTEXP:EXTEXP,$P(CS,U,2):184,CS:184,1:366)
 S OEXPDT=$$FMADD^XLFDT(ISSDT,X2)
 S DS=$S(EXTEXP:EXTEXP,1:DS)
 I $$FMADD^XLFDT(RDT,DS)'<OEXPDT S RES=0
 E  I 'NREF S RES=1
 E  D
 .S RFCNT=$O(^PSRX(RX,1,$C(1)),-1)
 .S RES=$S(RFCNT=NREF:1,1:0)  ; not eligible for change in expiration date
 Q $S(RES:$$FMADD^XLFDT(RDT,DS),1:0)
