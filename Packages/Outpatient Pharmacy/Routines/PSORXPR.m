PSORXPR ;BHAM ISC/SAB - view individual prescription ;23-Jan-2009 10:41;PLS
 ;;7.0;OUTPATIENT PHARMACY;**131,1008**;DEC 1997
 ;Reference to ^PS(55 supported by DBIA 2228
 ;Reference ^PSDRUG( supported by DBIA 221
 ;Reference to ^SC supported by DBIA 10040
 ;Reference to ^PSXVIEW supported by DBIA 2204
 ; Modified - IHS/CIA/PLS - 01/08/04 - Lines GET+1,EN+1,PR+8
 ;            IHS/MSC/PLS - 03/13/08 - Added line PR+20
 ;                          01/23/09 - Added line PR+21
GET S RX0=^PSRX(DA,0),J=DA,$P(RX0,"^",15)=+$G(^("STA")),RX2=$G(^(2)),R3=$G(^(3)),RTN=$G(^("TN")) S (DFN,P0)=+$P(RX0,"^",2) S:$D(^DPT(P0,0)) P0=^(0) S FFX=0
 ; IHS/CIA/PLS - 01/08/04 - Setup IHS variables
 N R9999999,P9999999
 S R9999999=$G(^PSRX(DA,9999999))
 I $G(PSOFROM)="RETURN" S APSPX9=$P(RX0,"^")
 S APSPRXX=$P(RX0,U,6),APSP=DA
 D:APSPMAN=1 EP1^APSPMAN1
 S:APSPMAN=2 APSPMM="",APSPD=$P($G(RX2),"^",11),APSPL=""
 I APSPMAN=""!(APSPMAN=3) S (APSPMM,APSPD,APSPL)=""
 S PSDIV=$S($D(^PS(59,+$P(RX2,"^",9),0)):$P(^(0),"^")_" ("_$P(^(0),"^",6)_")",1:"UNKNOWN"),PSDIV=$E(PSDIV,1,28),PSEXDT=$P(RX2,"^",6),PSEXDT=$S(PSEXDT]"":$E(PSEXDT,4,5)_"/"_$E(PSEXDT,6,7)_"/"_$E(PSEXDT,2,3),1:"UNKNOWN")
PR D STAT^PSOFUNC I 'ST0,$D(^PS(52.4,"AREF",DFN,DA)) S ST="UNPRINTED"
 ;S:$G(PSLSTVER)&($P($G(^PSRX(+$G(PSONV),"STA")),"^")=4) ST="PENDING DUE TO DRUG INTERACTION"
 D PID^VADPT W @IOF,"RX: ",$P(RX0,"^"),?20,"PATIENT: "_$P(P0,"^")_" (",VA("PID")_") ",!,"STATUS: "_ST_"   "_$S($P($G(^PSRX(DA,"IB")),"^")]"":"CO-PAY STATUS",1:"") I ($D(PS)#2),PS="DISCONTINUE",ST["DISCONTINUE" S PS="REINSTATE"
 ;W @IOF,!,"RX: ",$P(RX0,"^"),?20,"PATIENT: ",$P(P0,"^")," (",$P(P0,"^",9),") ",!,"STATUS: ",ST_"   "_$S($P($G(^PSRX(DA,"IB")),"^")]"":"CO-PAY STATUS",1:"") I ($D(PS)#2),PS="DISCONTINUE",ST["DISCONTINUE" S PS="REINSTATE"
 I $G(PKI1)!($G(PKI)) N PKIT D  W !,PKIT
 .I '$D(IORVON) S X="IORVOFF;IORVON" D ENDR^%ZISS S PKIT=IORVON_PKIE_IORVOFF K IORVOFF,IORVON,X Q
 .S PKIT=IORVON_PKIE_IORVOFF
 S MED=+$P(RX0,"^",6),M1="" S:$D(^PSDRUG(MED,0)) M1=^(0) W !,$S($P(M1,"^",3)["S":"      ITEM: ",1:"      DRUG: "),$S(RTN'="":RTN,1:$P(M1,"^"))_$S('$D(^("I")):"",^("I")']"":"",1:" - (inactivated)")
 ; IHS/CIA/PLS - 01/08/04 - Output Manufacturer info
 I APSPMAN=1!(APSPMAN=2) W !,"Manufacturer: "_APSPMM,?40,"Mfg Expiration Date: "_$E(APSPD,4,5)_"/"_$E(APSPD,2,3)
 W !?6," NDC: ",$P(RX2,U,7)
 W ?$X+2,"("_$P(R9999999,U,6)_")"
 W ?$X+2,"("_$P(RX0,U,17)_")"
 W:$P(R9999999,U,14)]"" ?$X+2,"TRIPLICATE# "_$P(R9999999,U,14)
 W !?6," QTY: ",$P(RX0,"^",7),"     ",$S($P(RX0,"^",8)?1N.N:$P(RX0,"^",8),1:"??")," DAY SUPPLY"
 ; IHS/CIA/PLS - 01/08/04 - Output NDC, AWP, Release Date and Triplicate #
 W !?6," NDC: ",$P(RX2,U,7)
 W ?$X+2,"("_$P(R9999999,U,6)_")"
 W ?$X+2,"("_$P(RX0,U,17)_")"
 W:$P(R9999999,U,14)]"" ?$X+2,"TRIPLICATE# "_$P(R9999999,U,14)
 W !,"SUBSTITUTION : "_$$GET1^DIQ(52,DA,9999999.25)  ;IHS/MSC/PLS - 03/13/08
 W !,"CASH DUE: "_$$GET1^DIQ(52,DA,9999999.26)  ; IHS/MSC/PLS - 01/23/09 - Added Cash Due output
 ; IHS/CIA/PLS - 01/08/04 - End IHS output
 K FSIG,BSIG I $P($G(^PSRX(DA,"SIG")),"^",2) D FSIG^PSOUTLA("R",DA,66) F PSREV=1:1 Q:'$D(FSIG(PSREV))  S BSIG(PSREV)=FSIG(PSREV)
 K FSIG,PSREV I '$P($G(^PSRX(DA,"SIG")),"^",2) D EN3^PSOUTLA1(DA,66)
 W !?7,"SIG: ",$G(BSIG(1))
 I $O(BSIG(1)) F PSREV=1:0 S PSREV=$O(BSIG(PSREV)) Q:'PSREV  W !?12,$G(BSIG(PSREV))
 K BSIG,PSREV
 S II=J D LAST^PSORFL W !?4,"LATEST: ",RFLL,?37,"# OF REFILLS: ",$P(RX0,"^",9) S PL=0 D:$O(^PSRX(DA,1,0))  W "  REMAINING: ",$P(RX0,"^",9)-PL K IFN
 .S IFN=0 F  S IFN=$O(^PSRX(DA,1,IFN)) Q:'IFN  S PL=PL+1
DTT S DTT=$P(RX0,"^",13) D DAT W !?4,"ISSUED: ",DAT
 S PHYS=$S($D(^VA(200,+$P(RX0,"^",4),0)):$P(^(0),"^"),1:"UNKNOWN") W ?41,"PROVIDER: "_PHYS S DTT=$P(RX2,"^")\1
 I $P(R3,"^",3),$D(^VA(200,+$P(R3,"^",3),0)) W !?41,"COSIGNER: "_$P($G(^VA(200,$P(R3,"^",3),0)),"^")
 D DAT W !?4,"LOGGED: ",DAT,?43,"CLINIC: ",$S($D(^SC(+$P(RX0,"^",5),0)):$P(^(0),"^"),1:"NOT ON FILE")
 W !?3,"EXPIRES: ",PSEXDT,?41,"DIVISION: ",PSDIV,!?7,"CAP: ",$P("NON-^","^",$S($D(^PS(55,DFN,0)):+$P(^(0),"^",2),1:0)),"SAFETY",?42,"ROUTING: " S X=$F("MWI",$P(RX0,"^",11))-1 W:X $P("MAIL^WINDOW^INPATIENT","^",X)
 W !?2,"ENTRY BY: ",$S($D(^VA(200,$P(RX0,"^",16),0)):$P(^(0),"^"),1:$P(RX0,"^",16)) W:$P(RX2,"^",10) ?38,"VERIFIED BY: ",$S($D(^VA(200,$P(RX2,"^",10),0)):$P(^(0),"^"),1:$P(RX2,"^",10))
 G:$D(PSOZVER) REM W !!,"FILLED: "_RFL,?20,"PHARMACIST: "_$S($D(^VA(200,+$P(RX2,"^",3),0)):$P(^(0),"^"),1:""),?52,"LOT #: "_$P(RX2,"^",4)
 W !," DISPENSED: "_$S($P(RX2,"^",5):$E($P(RX2,"^",5),4,5)_"/"_$E($P(RX2,"^",5),6,7)_"/"_$E($P(RX2,"^",5),2,3),1:"")
 W ?$X+10,$S($P(RX2,"^",15):" RETURNED TO STOCK: "_$E($P(RX2,"^",15),4,5)_"/"_$E($P(RX2,"^",15),6,7)_"/"_$E($P(RX2,"^",15),2,3),1:" RELEASED: "_$S($P(RX2,"^",13):$E($P(RX2,"^",13),4,5)_"/"_$E($P(RX2,"^",13),6,7)_"/"_$E($P(RX2,"^",13),2,3),1:""))
REM W:$P($G(^PSRX(DA,3)),"^",7)]"" !?3,"REMARKS: ",$P($G(^PSRX(DA,3)),"^",7) W:$P($G(^PSRX(DA,"D")),"^")]"" !,"DELETION COMMENT: "_$P(^("D"),"^")
 D:$G(^PSRX(DA,"H"))]""&($G(ST)="HOLD") HLD^PSORXPR1
 W ! D:PL RF^PSORXPR1 G Q:$D(DIRUT)  D PAR^PSORXPR1 G Q:$D(DIRUT)
ACT I $O(^PSRX(DA,"A",0)) D CON:$Y>20 G Q:$D(DIRUT) D H1 F N=0:0 S N=$O(^PSRX(DA,"A",N)) Q:'N  S P1=^(N,0),DTT=P1\1 D A1 Q:$D(DIRUT)
 G Q:$D(DIRUT) I $O(^PSRX(DA,"L",0)) D:$Y>20 CON Q:$D(DIRUT)  D L1 F L1=0:0 S L1=$O(^PSRX(DA,"L",L1)) Q:'L1  S LBL=^PSRX(DA,"L",L1,0),DTT=$P(^(0),"^") D DAT,LG Q:$D(DIRUT)
 N X S X="PSXVIEW" X ^%ZOSF("TEST") K X I $T D ^PSXVIEW
 G Q
LG I $Y>20 D CON Q:$D(DIRUT)  D L1
 W !,L1,?3,DAT,?14,$S($P(LBL,"^",2):"REFILL "_$P(^PSRX(DA,"L",L1,0),"^",2),1:"ORIGINAL"),?40,$P($G(^VA(200,+$P(^(0),"^",4),0)),"^"),!,"COMMENTS: "_$P(^PSRX(DA,"L",L1,0),"^",3)
 Q
A1 D CON:$Y>20 Q:$D(DIRUT)  D H1:FFX,DAT W !,N,?3,DAT,?14
 S X=$P(P1,"^",2),X=$F("HUCELPRWSIVDABX",X)-1 W:X $P("HOLD^UNHOLD^DISCONTINUED ^EDIT^RENEWED^PARTIAL^REINSTATE^REPRINT^SUSPENSE^RETURNED^INTERVENTION^DELETED^DRUG INTERACTION^PROCESSED^X-INTERFACE^","^",X)
 W ?25 S X=+$P(P1,"^",4) W $S(X>0&(X<6):"REFILL "_X,X=6:"PARTIAL",X>6:"REFILL "_(X-1),1:"ORIGINAL") W ?40,$S($D(^VA(200,+$P(P1,"^",3),0)):$P(^(0),"^"),1:$P(P1,"^",3))
 W:$P(P1,"^",5)]"" !,"COMMENTS: ",$P(P1,"^",5) Q
Q K ST0,RFL,RFLL,RFL1,ST,II,J,N,PHYS,L1,DIRUT,PSDIV,PSEXDT,MED,M1,FFX,DTT,DAT,RX0,RX2,R3,RTN,SIG,STA,P1,PL,P0,Z0,Z1,EXDT,IFN,DIR,DUOUT,DTOUT
 K LBL,I,RFDATE,%H,%I K:$G(PS)="VIEW" DFN Q
H1 I FFX W @IOF
 W !!,"ACTIVITY LOG:",!,"#",?3,"DATE",?14,"REASON",?25,"RX REF",?40,"INITIATOR OF ACTIVITY",! F I=1:1:79 W "="
 S FFX=0 W ! Q
L1 I FFX W @IOF
 W !!,"LABEL LOG:",!,"#",?3,"DATE",?14,"RX REF",?40,"PRINTED BY",! F I=1:1:79 W "="
 S FFX=0 W ! Q
CON Q:$D(PSOAC)  K DTOUT,DIRUT,DUOUT,DIR S DIR(0)="E" D ^DIR S FFX=1 Q
 Q
DAT S DAT="",DTT=DTT\1 Q:DTT'?7N  S DAT=$E(DTT,4,5)_"/"_$E(DTT,6,7)_"/"_$E(DTT,2,3)
 Q
EN ; Entry Point for PSORXED
 S APSPLTYP=""   ; IHS/CIA/PLS - 01/08/04 - IHS Setup
 D PSORXPR K PHYS,RFDATE,RFL,RFL1,ST,ST0,RFLL
 Q
