PSODISP ;BIR/SAB-MANUAL BARCODE RELEASE FUNCTION ;15-Feb-2008 10:54;SM
 ;;7.0;OUTPATIENT PHARMACY;**15,71,131,1006**;DEC 1997
 ;Reference to $$SERV^IBARX1 supported by DBIA 2245
 ;Reference to ^PSD(58.8 supported by DBIA 1036
 ;Reference to ^PS(55 supported by DBIA 2228
 ;Reference to ^PSDRUG supported by DBIA 221
 ;Reference to ^PSDRUG("AQ" supported by DBIA 3165
 ;Reference to ^XTMP("PSA" supported by DBIA 1036
 ;Reference to ^PS(59.7 supported by DBIA 694
 ; Modified - IHS/CIA/PLS - 08/26/04 - BATCH+11
AC K CX,PSODA,PSODT,PSRH,DA,DR,DIE,X,X1,X2,Y,RXP,CX,PX,REC,DIR,YDT,REC,RDUZ,DIRUT,PSOCPN,PSOCPRX,YY,QDRUG,QTY,TYPE,XTYPE,DUOUT
 K ^UTILITY($J,"PSOPCE") S PSOPCECT=1
 I '$D(PSOPAR) D ^PSOLSET I '$D(PSOPAR) W $C(7),!!,?5,"Site Parameters must be defined to use the Release option!",! G EXIT
 S Y=$G(^PS(59,PSOSITE,"IB")),PSOIBSS=$$SERV^IBARX1(+Y) I 'PSOIBSS D IBSSR^PSOUTL I 'PSOIBFL D   G EXIT
 .W $C(7),!!,"The IB SERVICE/SECTION defined in your site parameter file is not valid.",!,"You will not be able to release any medication until this is corrected!",!
AC1 W !! S PSIN=+$P($G(^PS(59.7,1,49.99)),"^",2)
 S DIC("S")="I $D(^XUSEC(""PSORPH"",+Y))",DIC("A")="Enter PHARMACIST: ",DIC="^VA(200,",DIC(0)="QEAM" D ^DIC G:"^"[X EXIT K DIC G:$D(DTOUT)!($D(DUOUT))!($D(DIRUT))!(Y=-1) EXIT S PSRH=+Y
 ;check for Drug Acct background job K8 & K7.1
 S X="PSA IV ALL LOCATIONS",DIC(0)="MZ",DIC=19.2 D ^DIC I Y=-1 K DIC,X,Y G BC
 I $P($G(Y(0)),U,2)>DT S PSODA=1 S:'$P($G(^XTMP("PSA",0)),U,2) $P(^(0),U,2)=DT G BC
 S X="PSA IV ALL LOCATIONS",DIC(0)="MZ",DIC=19 D ^DIC K DIC,X G:Y=-1 BC
 K DIQ,PSA S DA=+Y,DIC=19,DIQ="PSA",DR=200,DIQ(0)="IN" D EN^DIQ1
 I '$D(PSA(19,DA,200,"I")) K DIC,DA,X,Y,DIQ G BC
 I PSA(19,DA,200,"I")>DT S PSODA=1 S:'$P($G(^XTMP("PSA",0)),U,2) $P(^(0),U,2)=DT
 K PSA,DIC,DA,X,Y,DIQ
BC ;
 K MAN I $D(DISGROUP),$D(BINGNAM),($D(BINGDIV)!$D(BNGPDV)!$D(BNGRDV)),($D(BINGRO)!$D(BINGRPR)) D REL^PSOBING1 K BINGNAM,BINGDIV,BINGRO,BINGRPR,BNGPDV,BNGRDV
 Q:$G(POERR)  W !! K CMOP,ISUF,DIR,LBL,LBLP S DIR("A")="Enter/Wand PRESCRIPTION number",DIR("?")="^D HELP^PSODISP",DIR(0)="FO" D ^DIR
 I $D(DIRUT)!($D(DTOUT))!($D(DUOUT)) K DIRUT,DTOUT,DUOUT G AC1
 I X'["-" D BCI W:'$G(RXP) !,"INVALID PRESCRIPTION NUMBER" G:'$G(RXP) BC S MAN=1 G BC1
 I X["-",$P(X,"-")'=$P($$SITE^VASITE(),"^",3) W !?7,$C(7),$C(7),"   INVALID STATION NUMBER !!",$C(7),$C(7),! G BC
 I X["-" S RXP=$P(X,"-",2) I '$D(^PSRX(+$G(RXP),0))!($G(RXP)']"") W !?7,$C(7),$C(7),$C(7),"   NON-EXISTENT PRESCRIPTION" G BC
 I $D(^PSRX(RXP,0)) D  G BC1
 .S PSOLOUD=1 D:$P($G(^PS(55,+$P(^PSRX(+RXP,0),"^",2),0)),"^",6)'=2 EN^PSOHLUP($P(^PSRX(+RXP,0),"^",2)) K PSOLOUD
 W !?7,$C(7),$C(7),$C(7),"   IMPROPER BARCODE FORMAT" G BC
BC1 ;
 I +$P($G(^PSRX(+RXP,"PKI")),"^") D  Q:$G(POERR)  G BC
 .I $G(SPEED) W !!?7,$C(7),$C(7),"Rx# "_$P(^PSRX(RXP,0),"^") S PSOLIST=4
 .W !!,?7,"UNABLE TO RELEASE - THIS ORDER MUST BE RELEASED THROUGH THE OUTPATIENT",!,?7,"RX'S [PSD OUTPATIENT] OPTION IN THE CONTROLLED SUBSTANCE MENU"
 I +$P($G(^PSRX(+RXP,"STA")),"^")=13!(+$P($G(^PSRX(+RXP,0)),"^",2)=0) W !?7,$C(7),$C(7),"    PRESCRIPTION IS A DELETED PRESCRIPTION NUMBER" Q:$G(POERR)  D DCHK G BC
 I +$P($G(^PSRX(+RXP,"STA")),"^"),$S($P(^("STA"),"^")=2:0,$P(^("STA"),"^")=5:0,$P(^("STA"),"^")=11:0,$P(^("STA"),"^")=12:0,$P(^("STA"),"^")=14:0,$P(^("STA"),"^")=15:0,1:1) D STAT^PSODISPS Q:$G(POERR)  D DCHK G BC
 ;drug stocked in Drug Acct Location?
 S PSODA(1)=$S($D(^PSD(58.8,+$O(^PSD(58.8,"AOP",+PSOSITE,0)),1,+$P(^PSRX(RXP,0),U,6))):1,1:0)
 I $P(^PSRX(RXP,2),"^",13) S Y=$P(^PSRX(RXP,2),"^",13) X ^DD("DD") S OUT=1 D  K OUT Q:$G(POERR)  D DCHK G BC
 .W !!?7,$C(7),$C(7),$S($G(SPEED):"Rx# "_$P(^PSRX(RXP,0),"^"),1:"Original prescription")_" was last released on "_Y,!?7,"Checking for unreleased refills/partials " D REF
BATCH ;
 I $P(^PSRX(RXP,2),"^",15),'$P(^(2),"^",14) S RESK=$P(^(2),"^",15)  W !!?5,"Rx# "_$P(^PSRX(RXP,0),"^")_" Original Fill returned to stock on "_$E(RESK,4,5)_"/"_$E(RESK,6,7)_"/"_$E(RESK,2,3),! G REF
 S PSOCPN=$P(^PSRX(RXP,0),"^",2),QTY=$P($G(^PSRX(RXP,0)),"^",7),QDRUG=$P(^PSRX(RXP,0),"^",6)
 ;original
 I '$P($G(^PSRX(RXP,2)),"^",13),+$P($G(^(2)),"^",2)'<PSIN S RXFD=$P(^(2),"^",2) D  D:$G(LBLP) UPDATE I $G(ISUF) D UPDATE G REF
 .S SUPN=$O(^PS(52.5,"B",RXP,0)) I SUPN,$D(^PS(52.5,"C",RXFD,SUPN)),$G(^PS(52.5,SUPN,"P"))'=1,'$P($G(^(0)),"^",5) S ISUF=1 Q
 .I $D(^PSDRUG("AQ",QDRUG)) K CMOP D OREL^PSOCMOPB K CMOP I $G(ISUF) K ISUF,CMOP Q
 .F LBL=0:0 S LBL=$O(^PSRX(RXP,"L",LBL)) Q:'LBL  I '+$P(^PSRX(RXP,"L",LBL,0),"^",2),'$P(^(0),"^",5),$P(^(0),"^",3)'["INTERACTION" S LBLP=1
 .; IHS/MSC/PLS - 10/22/07 - suppress inventory mgmt if autofinished Rx.
 .;Q:'$G(LBLP)  S:$D(^PSDRUG(QDRUG,660.1)) ^PSDRUG(QDRUG,660.1)=^PSDRUG(QDRUG,660.1)-QTY
 .Q:'$G(LBLP)  S:$D(^PSDRUG(QDRUG,660.1)) ^PSDRUG(QDRUG,660.1)=^PSDRUG(QDRUG,660.1)-$S($P($G(^PSRX(RXP,999999921)),U,3):0,1:QTY)
 .D NOW^%DTC S DIE="^PSRX(",DA=RXP,DR="31///"_%_";23////"_PSRH_";32.1///@;32.2///@",PSODT=% D ^DIE K DIE,DR,DA,LBL
 .D EN^PSOHLSN1(RXP,"ZD")
 .D CALLPOS^APSPFUNC(RXP,+$O(^PSRX(RXP,1,$C(1)),-1),"A")  ;IHS/CIA/PLS - 08/26/04 - Call Point Of Sale
 .;S ^UTILITY($J,"PSOPCE",PSOPCECT)=RXP_"^"_$G(QTY)_"^"_+QDRUG_"^1^0^"_PSODT S PSOPCECT=PSOPCECT+1 I PSOPCECT>100 D PCE
 .;if appropriate update ^XTMP("PSA", for Drug Acct
 .I $G(PSODA),$G(PSODA(1)),'$D(^PSRX("AR",+PSODT,+RXP,0)) S ^XTMP("PSA",+PSOSITE,+QDRUG,+DT)=$G(^XTMP("PSA",+PSOSITE,+QDRUG,+DT))+QTY
REF ;release refills and partials
 K LBLP,IFN F XTYPE=1,"P" K IFN D QTY^PSODISPS
 S:'XTYPE $P(^PSRX(RXP,"TYPE"),"^")=0
 Q:+$G(OUT)!($G(POERR))  D DCHK G BC
UPDATE I $G(ISUF) W $C(7),!!?7,"Prescription "_$P(^PSRX(RXP,0),"^")_" - Original Fill on Suspense !",!,$C(7) Q
 ; I +$G(^PSRX(RXP,"IB")) S PSOCPRX=$P(^PSRX(RXP,0),"^") D CP^PSOCP
 S PSOCPRX=$P(^PSRX(RXP,0),"^") D CP^PSOCP
 W !?7,"Prescription Number "_$P(^PSRX(RXP,0),"^")_" Released"
 ;initialize bingo board variables
 I $G(LBLP),$P(^PSRX(RXP,0),"^",11)["W" S BINGRO="W",BINGNAM=$P(^PSRX(RXP,0),"^",2),BINGDIV=$P(^PSRX(RXP,2),"^",9)
 Q
EXIT ;D PCE
 K PSOPCECT,OUT,RX2,RXFD,RESK,ISUF,SUPN,%,DIC,IFN,J,DA,DR,DIE,X,X1,X2,Y,RXP,CX,PX,REC,DIR,YDT,REC,RDUZ,DIRUT,PSOCPN,PSOCPRX,PSOIBSS,PSOIBFL,PSOIBLP,PSOIBST,YY,QDRUG,QTY,TYPE,XTYPE,DUOUT,PSRH,XX,Y,PSIN,MAN
 Q
HELP W !!,"Wand the barcode number of the prescription or manually key in",!,"the number below the barcode or the prescription number.",!,"The barcode number should be of the format - 'NNN-NNNNNNN'"
 Q
BCI S RXP=0
RXP S RXP=$O(^PSRX("B",X,RXP)) I $P($G(^PSRX(+RXP,"STA")),"^")=13 G RXP ;GET RECORD NUMBER FROM SCRIPT NUMBER
 Q
DCHK ;checks for duplicate
 Q:'$G(MAN)
 I $D(DISGROUP),$D(BINGNAM),($D(BINGDIV)!$D(BNGPDV)!$D(BNGRDV)),($D(BINGRO)!$D(BINGRPR)) D REL^PSOBING1 K BINGNAM,BINGDIV,BINGRO,BINGRPR,BNGPDV,BNGRDV
 S RXP=$O(^PSRX("B",$P(^PSRX(RXP,0),"^"),RXP)) I 'RXP K POERR,MAN Q
 I $P($G(^PSRX(RXP,"STA")),"^")=13 G DCHK
 I $D(DISGROUP),$D(BINGNAM),($D(BINGDIV)!$D(BNGPDV)!$D(BNGRDV)),($D(BINGRO)!$D(BINGRPR)) D REL^PSOBING1 K BINGNAM,BINGDIV,BINGRO,BINGRPR,BNGPDV,BNGRDV
 W !!,"Duplicate Rx # "_$P(^PSRX(RXP,0),"^")_" found."
 S POERR=1 D BC1^PSODISP
 I $D(DISGROUP),$D(BINGNAM),($D(BINGDIV)!$D(BNGPDV)!$D(BNGRDV)),($D(BINGRO)!$D(BINGRPR)) D REL^PSOBING1 K BINGNAM,BINGDIV,BINGRO,BINGRPR,BNGPDV,BNGRDV
 G DCHK
 Q
PCE ;Update PCE
 Q
 ;Q:'$D(^UTILITY($J,"PSOPCE"))
 ;S ZTSAVE("^UTILITY($J,""PSOPCE"",")="",ZTIO="",ZTDTH=$H,ZTDESC="Update PCE with Outpatient Releases",ZTRTN="MSG^PSORDS" D ^%ZTLOAD
 ;K ^UTILITY($J,"PSOPCE") S PSOPCECT=1 Q
