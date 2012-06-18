APSQDRDU ;BHAM/ISC/SAB/ENM/POC - DUPLICATE DRUG AND CLASS CHECKER  
 ;;6.0;IHS PHARMACY MODIFICATIONS;**3**;FEB 20, 2001
 ;;6.0;OUTPATIENT PHARMACY;**4,15,58,84,135,137,144**;09/03/97
 S EN="INVEN" D ^APSQSHOW ;ADDED NEXT 4 LINES IHS/OKCAO/POC
 D EN^APSQDRDU
 K AZOSD
 Q
EN S $P(PSONULN,"-",79)="-",DNM=""
 ;F  S DNM=$O(AZOSD(DNM)) Q:DNM=""  I $P(AZOSD(DNM),"^")'=$G(PSORENW("OIRXN")) D  Q:$G(PSORX("DFLG"))
 F  S DNM=$O(AZOSD(DNM)) Q:DNM=""  D  Q:$G(PSORX("DFLG"))
 .D:PSODRUG("NAME")=$P(DNM,"^")&('$P($G(PSOPAR),"^",2))&($P($G(PSOPAR),"^",16))&('$D(^XUSEC("PSORPH",DUZ))) DUP Q:$G(PSORX("DFLG"))
 .D:PSODRUG("NAME")=$P(DNM,"^")&($D(^XUSEC("PSORPH",DUZ))) DUP Q:$G(PSORX("DFLG"))
 .I PSODRUG("VA CLASS")]"",$E(PSODRUG("VA CLASS"),1,4)=$E($P(AZOSD(DNM),"^",5),1,4),PSODRUG("NAME")'=$P(DNM,"^") D CLS
 G EXIT
DOSE ;I '$D(PSOCLOZ) G EXIT
 S DIR(0)="N^12.5:3000:1",DIR("A")="CLOZAPINE dosage (mg/day) ? " D ^DIR K DIR I $D(DTOUT)!($D(DUOUT)) G EXIT
 S PSOCD=X
 I PSOCD#25=0,PSOCD'<12.5,PSOCD<900 S PSONEW("SAND")=PSOCD_"^"_$G(PSOLR)_"^"_$G(PSOLDT) G EXIT
 I PSOCD#12.5 S DIR(0)="Y",DIR("B")="NO",DIR("A")=PSOCD_" is an unusual dose.  Are you sure " D ^DIR K DIR G EXIT:$D(DTOUT),EXIT:$D(DUOUT) I X'="Y" G DOSE
 I PSOCD>900 S DIR(0)="Y",DIR("A")="Recommended maximum daily dose is 900. Are you sure " D ^DIR K DIR G EXIT:$D(DTOUT),EXIT:$D(DUOUT) I X'="Y" G DOSE
 S PSONEW("SAND")=PSOCD_"^"_$G(PSOLR)_"^"_$G(PSOLDT)
EXIT K CAN,DA,DIR,DNM,DUPRX0,ISSD,J,LSTFL,MSG,PHYS,PSOCLC,PSONULN,REA,RFLS,RX0,RX2,RXN,RXREC,ST,Y,ZZ,ACT,PSOCLOZ,PSOLR,PSOLDT,PSOCD
 Q
DUP S:$P(AZOSD(DNM),"^",2)<10 DUP=1 W !,PSONULN,!,*7,"DUPLICATE DRUG "_$P(DNM,"^")_" in Prescription: ",$P(^PSRX(+AZOSD(DNM),0),"^")
 S RXREC=+AZOSD(DNM),MSG="Cancelled During "_$S('$G(PSONV):"New Prescription Entry",1:"Verification")_" - Duplicate Drug"
DATA S DUPRX0=^PSRX(RXREC,0),RFLS=$P(DUPRX0,"^",9),ISSD=$P(^PSRX(RXREC,0),"^",13),RX0=DUPRX0,RX2=^PSRX(RXREC,2)
 W !!,$J("Status: ",24) S J=RXREC D STAT^PSOFUNC W ST K RX0,RX2 W ?40,$J("Issued: ",24),$E(ISSD,4,5),"/",$E(ISSD,6,7),"/",$E(ISSD,2,3)
 W !,$J("SIG: ",24),$P(DUPRX0,"^",10),!,$J("QTY: ",24),$P(DUPRX0,"^",7),?40,$J("# of refills: ",24),RFLS S PHYS=$S($D(^VA(200,+$P(DUPRX0,"^",4),0)):$P(^(0),"^"),1:"UNKNOWN")
 W !,$J("Provider: ",24),PHYS,?40,$J("Refills remaining: ",24),RFLS-$S($D(^PSRX(RXREC,1,0)):$P(^(0),"^",4),1:0)
 S LSTFL=+^PSRX(RXREC,3) W !?40,$J("Last filled on: ",24),$E(LSTFL,4,5),"/",$E(LSTFL,6,7),"/",$E(LSTFL,2,3)
 W !,PSONULN,! I $P($G(^PS(53,+$P($G(PSORX("PATIENT STATUS")),"^"),0)),"^")["AUTH ABS",'$P(PSOPAR,"^",5) W !,"PATIENT ON AUTHORIZED ABSENSE!" Q
ASKCAN Q:$P(AZOSD(DNM),"^",2)>10
 S DIR("A")=$S($P(AZOSD(DNM),"^",2)=12:"REINSTATE",1:"CANCEL")_" RX # "_$P(^PSRX(+AZOSD(DNM),0),"^"),DIR(0)="Y",DIR("?")="Enter Y to "_$S($P(AZOSD(DNM),"^",2)=12:"reinstate",1:"cancel")_" this RX."
 D ^DIR K DIR S DA=RXREC S ACT=$S($D(SPCANC):"Reinstated during Rx cancel.",1:$S($P(AZOSD(DNM),"^",2)=12:"Reinstated",1:"Cancelled")_" while "_$S('$G(PSONV):"entering",1:"verifying")_" new RX")
 I 'Y W *7," -Prescription was not "_$S($P(AZOSD(DNM),"^",2)=12:"reinstated",1:"cancelled")_"..." S:'$D(PSOCLC) PSOCLC=DUZ S MSG=ACT,REA=$S($P(AZOSD(DNM),"^",2)=12:"R",1:"C") S:$G(DUP) PSORX("DFLG")=1 K DUP Q
 S PSOCLC=DUZ,MSG=$S($G(MSG)]"":MSG,1:ACT_" During New RX "_$S('$G(PSONV):"Entry",1:"Verification")_" - DUPLICATE RX"),REA=$S($P(AZOSD(DNM),"^",2)=12:"R",1:"C")
 S PSCAN($P(^PSRX(DA,0),"^"))=DA_"^"_REA D CAN^PSOCAN W "  RX has been "_ACT_"." S $P(AZOSD(DNM),"^",2)=$S($P(AZOSD(DNM),"^",2)=12:0,1:12)
 K DUP Q
CLS S MSG="Cancelled During "_$S('$G(PSONV):"New Prescription Entry",1:"Verification")_" - Duplicate Class" W !,PSONULN
 W !?5,*7,"*** SAME CLASS *** OF DRUG FOR "_$P(DNM,"^"),!,"CLASS: "_$P(AZOSD(DNM),"^",5) S CAN=$P(AZOSD(DNM),"^",2)'<11!($P(AZOSD(DNM),"^",2)=1) S RXREC=+AZOSD(DNM) Q
 ;WE DON'T CARE ABOUT THIS FOR OUTSIDE DRUGS IHS/OKCAO/POC D:$P(PSOPAR,"^",10) DATA
 Q
