PSORESK1 ;BHAM ISC/SAB - return to stock continued ;17-Jan-2014 11:18;DU
 ;;7.0;OUTPATIENT PHARMACY;**9,201,1018**;DEC 1997;Build 21
 ;IHS/MSC/MGH entry point CHECK ADDED 01/07/2014
HP W !!,"Wand the barcode number of the Rx or manually key in",!,"the number below the barcode or the Rx number."
 W !,"The barcode number format is - 'NNN-NNNNNNN'",!!,"Press 'ENTER' to process Rx or ""^"" to quit"
 Q
STAT S RX0=^PSRX(RXP,0),RX2=^PSRX(RXP,2),J=RXP S $P(RX0,"^",15)=$P($G(^PSRX(RXP,"STA")),"^") D ^PSOFUNC
 W !!,$C(7),$C(7),"Rx status of "_ST_" and cannot be returned to stock.",! K RX0,ST Q
CP D NOW^%DTC S PSODT=%
 S PSOCPRX=$P(^PSRX(RXP,0),"^") S PSO=1,PSODA=RXP,PSOPAR7=$G(^PS(59,PSOSITE,"IB")) W !!,"Attempting to remove copay charges",! D RXED^PSOCPA
 I COPAYFLG=0 W !!,"Reason must be entered. Rx "_$P(^PSRX(RXP,0),"^")_" not returned to stock.",!
 ;PFS: send Rx info to external billing system when copay and no copay.
 Q
ACT S IFN=0 F I=0:0 S I=$O(^PSRX(RXP,"A",I)) Q:'I  S IFN=I
 I $G(PSOWHERE) S COM=$G(COM)_" (Released by CMOP)"
 I +$G(PSOPFS) S:$P(PSOPFS,"^",3)'="" COM=$G(COM)_" (External Billing Charge ID: "_$P(PSOPFS,"^",3)_")"
 D NOW^%DTC S IFN=IFN+1,^PSRX(RXP,"A",0)="^52.3DA^"_IFN_"^"_IFN,^PSRX(RXP,"A",IFN,0)=%_"^I^"_DUZ_"^"_$S(XTYPE="O":0,$G(TYPE)'<0&($G(TYPE)<6)&(XTYPE):TYPE,$G(TYPE)>5&(XTYPE):(TYPE+1),1:6)_"^"_COM
 K DA Q
CMOP ;original released by CMOP?  Called by PSORESK
 S PSXREL=$P($G(^PSRX(RXP,2)),"^",13)
 I $G(PSXREL),($D(^PSRX("AR",PSXREL,RXP,0))) W !!,$C(7),"Rx # "_$P(^PSRX(RXP,0),"^")_":",?20," Was dispensed by the CMOP and may not be returned"
 I  W !,?20," to stock at this facility." Q
 K PSXREL
 Q
CMOP1 ; REFILL released by CMOP?  Called by PSORESK
 I +$G(XTYPE) S PSXREL=$P($G(^PSRX(RXP,1,TYPE,0)),"^",18)
 I $G(PSXREL),($D(^PSRX("AR",PSXREL,RXP,TYPE))) W !!,"REFILL # "_TYPE_":",?20," Was dispensed by the CMOP and may not be returned"
 I  W !,?20," to stock at this facility." Q
 K PSXREL
 Q
CHECK(RX) ;IHS/MSC/MGH Check and update the expiration date as needed
 N EXP,OLDEXP,REF,REMFILL
 S OLDEXP=$$GET1^DIQ(52,RX,26,"I")
 S REF=$$GET1^DIQ(52,RX,9)
 I REF=0 S EXP=$$CHANGE(RX)    ;This is an original fill, change expiration date back after RTS
 E  D
 .S REMFILL=$$RMNRFL^APSPFUNC(RX)
 .I REMFILL>1 S EXP=OLDEXP     ;There are still more refills left, keep original expiration date
 .E  S EXP=$$CHANGE(RX)        ;One or no fills left, change expiration date back after RTS
 Q EXP
CHANGE(RX) ;Change the expiration date back based on issue date and other logic
 N EXPDTE,CS,DRG,EXTEXP,ISSDT
 S DRG=$$GET1^DIQ(52,RX,6,"I")
 S CS=$$ISSCH^APSPFNC2(DRG,"2345")
 S $P(CS,U,2)=$$ISSCH^APSPFNC2(DRG,"2")
 S EXTEXP=$$GET1^DIQ(50,DRG,9999999.08,"I")
 S ISSDT=$$GET1^DIQ(52,RX,1,"I")
 S X2=$S(EXTEXP:EXTEXP,$P(CS,U,2):184,CS:184,1:366)
 S EXPDTE=$$FMADD^XLFDT(ISSDT,X2)
 Q EXPDTE
