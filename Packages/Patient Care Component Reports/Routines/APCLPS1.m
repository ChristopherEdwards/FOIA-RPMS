APCLPS1 ; IHS/CMI/LAB - prescription cost report ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;Thanks to Pat Cox who wrote the original code for this report.
 ;
 S APCLL(1)=$$CTR($$USR)
 S APCLL(2)=$$CTR($$LOC())
 S APCLL(3)=$$CTR("PRESCRIPTION COST REPORT",80)
 S APCLL(4)=" "
 S APCLL(5)="This report can be used by a site to determine prescription cost"
 S APCLL(6)="for a user specified group of patients for a specified date"
 S APCLL(7)="range.  The report will allow sites to prepare for the Medicare"
 S APCLL(8)="Part D Prescription Drug Coverage that begins in January 2006."
 S APCLL(9)=""
 D EN^DDIOL(.APCLL)
 K APCLL
DATES K APCLED,APCLBD
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Date"
 D ^DIR Q:Y<1  S APCLBD=Y
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Date"
 D ^DIR Q:Y<1  S APCLED=Y
 ;
 I APCLED<APCLBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 ;
 ;
INS ;
 K APCLINS
 K DIR
 S DIR(0)="S^I:With INSURANCE (Medicare, Medicaid or Private Insurance);N:With NO Insurance"
 S DIR("A")="Do want to include patients",DIR("B")="I" KILL DA D ^DIR
 KILL DIR
 I $D(DIRUT) G DATES
 S APCLINS=Y
 I APCLINS="N" G SOURCE
INST ;
 K APCLITYP
 W !,"Please select the insurance types that the patient must have to be"
 W !,"included in the report.  For example, if you want patients with Medicare"
 W !,"enter 1, if you want patients with both Medicare and Medicaid, enter 1,2."
 W !
 W !?10,"1   Medicare"
 W !?10,"2   Medicaid"
 W !?10,"3   Private Insurance"
 S DIR(0)="L^1:3",DIR("A")="Enter Insurance Types that the Patient must have",DIR("B")="1" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G INS
 I Y[1 S APCLITYP("M")=""
 I Y[2 S APCLITYP("C")=""
 I Y[3 S APCLITYP("P")=""
 ;
SOURCE  ;SOURCE OF DOLLAR AMOUNT AWP OR ACTUAL ACQUISTION COST
 S APCLSRC=""
 K DIR
 S DIR("?")=" "
 S DIR("?",1)="AVERAGE WHOLESALE PRICE IS THE AWP TIMES THE QTY FOR THE PRESCRIPTION"
 S DIR("?",2)="ACTUAL ACQUISITION PRICE IS THE UNIT PRICE TIMES THE QTY FOR THE PRESCRIPTION"
 S DIR("?",3)="BILLED PRICE IS THE ACTUAL AMOUNT THE POINT OF SALE PACKAGE BILLED FOR THE RX"
 S DIR("?",4)="THIS BILLED PRICE INCLUDES THE DISPENSING FEE"
 S DIR("?",5)="RECEIVED PRICE IS THE PRICE THAT WAS ACTUALLY PAID FROM THE VENDOR"
 S DIR(0)="S^A:AVERAGE WHOLESALE PRICE;P:ACTUAL ACQUISITION PRICE;B:POS BILLED PRICE;R:POS RECEIVED PRICE"
 S DIR("A")="ENTER THE COST TO USE IN CALCULATING COSTS"
 D ^DIR K DIR
 I $D(DTOUT)!($D(DUOUT)) G INS
 I "APBR"'[Y G SOURCE
 S APCLSRC=Y
 ;
DOLLAR ;
 S APCLDOLL=""
 K DIR
 S DIR(0)="N^::2"
 S DIR("A")="ENTER THE DOLLAR TRIGGER AMOUNT/MINIMUM TOTAL PRESCRIPTION COST"
 D ^DIR K DIR
 I $D(DTOUT)!($D(DUOUT)) G SOURCE
 I +Y'>0 G DOLLAR
 S APCLDOLL=+Y
 ;
DSPDN ;
 S APCLDDN=""
 K DIR
 S DIR(0)="Y",DIR("A")="Do you wish to display the drug names on the list",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DOLLAR
 S APCLDDN=Y
 ;
SORT ;
 S APCLSORT=""
 K DIR
 S DIR(0)="S^P:Patient Name;H:Health Record (Chart) Number;I:Insurance Type;C:Total Prescription COST"
 S DIR("A")="How would you like the report sorted",DIR("B")="P" D ^DIR K DIR
 I $D(DIRUT) G DSPDN
 S APCLSORT=Y
 ;
ZIS ; call xbdbque
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G SORT
 S XBRP="PRINT^APCLPS1",XBRC="PROC^APCLPS1",XBRX="EOJ^APCLPS1",XBNS="APCL"
 D ^XBDBQUE
 D EOJ
 Q
 ;
EOJ ;
 D EN^XBVK("APCL")
 D ^XBFMK
 Q
 ;
PROC ;
 S APCLBTH=$H,APCLJOB=$J
 K ^XTMP("APCLPS1",APCLJOB,APCLBTH)
 D XTMP^APCLOSUT("APCLPS1","PRESCRIPTION COST REPORT")
 ;first get list of all patients with cost equal to less than APCLDOLL
 S APCLSD=$$FMADD^XLFDT(APCLBD,-1)
 F  S APCLSD=$O(^PSRX("AD",APCLSD)) Q:(APCLSD="")!(APCLSD>APCLED)  D
 .S APCLRXIN=0 F  S APCLRXIN=$O(^PSRX("AD",APCLSD,APCLRXIN)) Q:APCLRXIN=""  D
 ..S APCLRXFL="" F  S APCLRXFL=$O(^PSRX("AD",APCLSD,APCLRXIN,APCLRXFL)) Q:APCLRXFL'=+APCLRXFL  D
 ...S APCLRX0=^PSRX(APCLRXIN,0)  Q:$$DEMO^APCLUTL($P(APCLRX0,U,2),$G(APCLDEMO))
 ...D ENP^XBDIQ1(52,APCLRXIN,"2;7;17;13;32.1;31;100;9999999.06","APCLRX(","I")
 ...D:+APCLRXFL ENP^XBDIQ1(52.1,APCLRXIN_","_APCLRXFL,"1;1.2;14;17;9999999.06","APCLRXR(","I")
 ...;B "L+"
 ...Q:APCLRX(100,"I")=13  ;DELETED
 ...I '+APCLRXFL D  ;ORIGINAL RX
 ....Q:APCLRX(31,"I")']""  ;NOT RELEASED
 ....Q:APCLRX(32.1,"I")]""  ;RETURNED TO STOCK
 ....;HERE COMES THE POS STUFF
 ....D
 .....S APCLABSP=APCLRXIN_".00001"
 .....S APCLABSI=$O(^ABSPTL("B",APCLABSP,""),-1)  ;THE LAST IEN FOR THIS ENTRY IN ABSP LOG OF TRANSACTIONS
 .....I '+APCLABSI S APCLBCOS=0,APCLCCOS=0 Q  ;APCLBCOS IS THE BILLED POS AND APCLCCOS IS COLLECTED COST
 .....D ENP^XBDIQ1(9002313.57,APCLABSI,"505;14;4","APCLPTL(","I")  ;4=RESPONSE 14=POS IN CLAIM,505=TOTAL PRICE
 .....S APCLBCOS=APCLPTL(505)  ;TOTAL PRICE BILLED
 .....I '+APCLPTL(4,"I") S APCLCCOS=0 Q
 .....D ENP^XBDIQ1(9002313.0301,APCLPTL(4,"I")_","_APCLPTL(14,"I"),509,"ABSPR(")
 .....S APCLCCOS=+$TR(ABSPR(509),"$ ","")  ;TOTAL PRICE ACTUALLY RECEIVED
 ....S APCLCOST=$S(APCLSRC="A":APCLRX(9999999.06),APCLSRC="B":APCLBCOS,APCLSRC="R":APCLCCOS,APCLSRC="P":APCLRX(17),1:""),QTY=APCLRX(7),APCLTCOS=$S("AP"[APCLSRC:APCLCOST*QTY,1:APCLCOST)
 ....;I HATE THIS BUT OF APCLSRC IS B OR R APCLCOST IS FOR FULL AMOUNT NO NEED TO MULTIPLY BY QTY
 ...I +APCLRXFL D  ;ITS A REFILL
 ....Q:APCLRXR(17,"I")']""  ;NOT RELEASED
 ....Q:APCLRXR(14,"I")]""  ;RETURNED TO STOCK
 ....;HERE COMES THE POS STUFF
 ....D
 .....S APCLSUFF=.00001+(+APCLRXFL*.0001)  ;GET THE SUFFIX TO ADD
 .....S APCLABSP=APCLRXIN_APCLSUFF
 .....S APCLABSI=$O(^ABSPTL("B",APCLABSP,""),-1)  ;THE LAST IEN FOR THIS ENTRY IN ABSP LOG OF TRANSACTIONS
 .....I '+APCLABSI S APCLBCOS=0,APCLCCOS=0 Q  ;APCLBCOS IS THE BILLED POS AND APCLCCOS IS COLLECTED COST
 .....D ENP^XBDIQ1(9002313.57,APCLABSI,"505;14;4","APCLPTL(","I")  ;4=RESPONSE 14=POS IN CLAIM,505=TOTAL PRICE
 .....S APCLBCOS=APCLPTL(505)  ;TOTAL PRICE BILLED
 .....I '+APCLPTL(4,"I") S APCLCCOS=0 Q
 .....D ENP^XBDIQ1(9002313.0301,APCLPTL(4,"I")_","_APCLPTL(14,"I"),509,"ABSPR(")
 .....S APCLCCOS=+$TR(ABSPR(509),"$ ","")  ;TOTAL PRICE ACTUALLY RECEIVED
 ....;S APCLCOST=$S(APCLSRC="A":APCLRXR(9999999.06),1:APCLRXR(1.2)),QTY=APCLRXR(1),APCLTCOS=APCLCOST*QTY
 ....S APCLCOST=$S(APCLSRC="A":APCLRX(9999999.06),APCLSRC="B":APCLBCOS,APCLSRC="R":APCLCCOS,APCLSRC="P":APCLRX(17),1:""),QTY=APCLRX(7),APCLTCOS=$S("AP"[APCLSRC:APCLCOST*QTY,1:APCLCOST)
 ...Q:'$G(APCLTCOS)  ;NOT GOT ONE
 ...S APCLDFN=APCLRX(2,"I")
 ...S APCLPINS=$$INSTD(APCLDFN,APCLSD,APCLINS,.APCLITYP) I 'APCLPINS K APCLTCOS Q  ;quit if the patient did not have insurance on this prescription date
 ...S APCLSV="" D GETSORT I APCLSV="" S APCLSV="--"
 ...S ^(0)=$G(^XTMP("APCLPS1",APCLJOB,APCLBTH,APCLSV,APCLRX(2,"I"),0))+APCLTCOS
 ...S ^XTMP("APCLPS1",APCLJOB,APCLBTH,APCLSV,APCLRX(2,"I"),"DRUGS",$$VAL^XBDIQ1(52,APCLRXIN,6))=""
 ...F X=2:1:4 I $P(APCLPINS,U,X)]"" S ^XTMP("APCLPS1",APCLJOB,APCLBTH,APCLSV,APCLDFN,"INS",$P(APCLPINS,U,X))=""
 ...K APCLTCOS
 ;now loop through and eliminate anyone without the dollar amt specified
 S APCLSV="" F  S APCLSV=$O(^XTMP("APCLPS1",APCLJOB,APCLBTH,APCLSV)) Q:APCLSV=""  D
 .S APCLDFN=0 F  S APCLDFN=$O(^XTMP("APCLPS1",APCLJOB,APCLBTH,APCLSV,APCLDFN)) Q:APCLDFN'=+APCLDFN  D
 ..I ^XTMP("APCLPS1",APCLJOB,APCLBTH,APCLSV,APCLDFN,0)<APCLDOLL K ^XTMP("APCLPS1",APCLJOB,APCLBTH,APCLSV,APCLDFN)
 Q
 ;
 ;
GETSORT ;
 S APCLSV=""
 I APCLSORT="P" S APCLSV=$P(^DPT(APCLDFN,0),U)
 I APCLSORT="H" S APCLSV=$$HRN^AUPNPAT(APCLDFN,DUZ(2))
 I APCLSORT="C" S APCLSV=APCLTCOS
 I APCLSORT="I" D
 .I $$MCR^AUPNPAT(APCLDFN,APCLSD) S APCLSV="Mcare"
 .I $$MCD^AUPNPAT(APCLDFN,APCLSD) S APCLSV=APCLSV_$S(APCLSV="":"",1:"/")_"Mcaid"
 .I $$PI^AUPNPAT(APCLDFN,APCLSD) S APCLSV=APCLSV_$S(APCLSV="":"",1:"/")_"PI"
 .I APCLSV="" S APCLSV="No Insurance"
 Q
INSTD(P,D,I,T) ;
 I $G(P)="" Q 0
 I $G(D)="" Q 0
 NEW MCD,MCR,PI
 S MCD=$$MCD(P,D)
 S MCR=$$MCR(P,D)
 S PI=$$PI(P,D)
 I I="N",($P(MCD,U)+$P(MCR,U,1)+$P(PI,U,1)) Q 0  ;pt has ins and they want ones that don't
 I I="N",'($P(MCD,U)+$P(MCR,U,1)+$P(PI,U,1)) Q 1_"^No insurance"  ;want pts with no insurance and this patient has no insurance
 I $D(T("M")),'MCR Q 0
 I $D(T("P")),'PI Q 0
 I $D(T("C")),'MCD Q 0
 Q 1_U_$S(MCR:$P(MCR,U,2),1:"")_U_$S(MCD:$P(MCD,U,2),1:"")_U_$S(PI:$P(PI,U,2),1:"")
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:IO'=IO(0)
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 W !
 S DIR("A")="End of Report.  Press Enter",DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
PRINT ;EP - called from xbdbque
 ;
 S APCLPG=0 K APCLQUIT
 I '$D(^XTMP("APCLPS1",APCLJOB,APCLBTH)) D HEADER W !!,"No data to report.",! G DONE
 D HEADER
 S APCLSV="" F  S APCLSV=$O(^XTMP("APCLPS1",APCLJOB,APCLBTH,APCLSV)) Q:APCLSV=""!($D(APCLQUIT))  D
 .S APCLDFN=0 F  S APCLDFN=$O(^XTMP("APCLPS1",APCLJOB,APCLBTH,APCLSV,APCLDFN)) Q:APCLDFN'=+APCLDFN!($D(APCLQUIT))  D
 ..I $Y>(IOSL-4) D HEADER Q:$D(APCLQUIT)
 ..W !,$P(^DPT(APCLDFN,0),U)
 ..W ?32,$$HRN^AUPNPAT(APCLDFN,DUZ(2))
 ..S APCLI="",APCLC=0 F  S APCLI=$O(^XTMP("APCLPS1",APCLJOB,APCLBTH,APCLSV,APCLDFN,"INS",APCLI)) Q:APCLI=""!($D(APCLQUIT))  D
 ...S APCLC=APCLC+1
 ...W:APCLC>1 ! W ?41,APCLI
 ...I APCLC=1 W ?70,$FN(^XTMP("APCLPS1",APCLJOB,APCLBTH,APCLSV,APCLDFN,0),"",2)
 ..Q:'APCLDDN
 ..S APCLD="" F  S APCLD=$O(^XTMP("APCLPS1",APCLJOB,APCLBTH,APCLSV,APCLDFN,"DRUGS",APCLD)) Q:APCLD=""!($D(APCLQUIT))  D
 ...W !?3,APCLD
 D DONE
 Q
HEADER ;EP
 G:'APCLPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
HEADER1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",APCLPG,!
 W !,$$CTR("***  PRESCRIPTION COST REPORT  ***",80),!
 S X="Prescription Dates: "_$$FMTE^XLFDT(APCLBD)_" to "_$$FMTE^XLFDT(APCLED) W $$CTR(X,80),!
 S X="Source: "_$S(APCLSRC="A":"AVERAGE WHOLESALE PRICE",APCLSRC="P":"ACTUAL ACQUISITION PRICE",APCLSRC="B":"POS BILLED PRICE",APCLSRC="R":"POS RECEIVED PRICE",1:"??") W $$CTR(X,80),!
 S X="Dollar Trigger Amount: "_APCLDOLL W $$CTR(X,80),!
 S X=$S(APCLINS="N":"Patient's with NO Insurance",1:"")
 I X="" D
 .I $D(APCLITYP("M")) S X="Mcare"
 .I $D(APCLITYP("C")) S X=X_$S(X="":"",1:"/")_"Mcaid"
 .I $D(APCLITYP("P")) S X=X_$S(X="":"",1:"/")_"PI"
 S X="Insurance: "_X W $$CTR(X,80),!
 W !," Name",?32,"Chart #",?41,"Eligibility Dates",?70,"Total Rx",!?70,"Costs"
 W !,$TR($J("",80)," ","-")
 Q
DONE ;
 K ^XTMP("APCLPS1",APCLJOB,APCLBTH)
 D EOP
 Q
MCR(P,D) ;EP - Is patient P medicare eligible on date D.  1 = yes, 0 = no.
 ; I = IEN in ^AUPNMCR multiple.
 I '$G(P) Q 0
 I '$G(D) Q 0
 NEW I,Y
 S Y=0,U="^"
 I '$D(^DPT(P,0)) G MCRX
 I $P(^DPT(P,0),U,19) G MCRX
 I '$D(^AUPNPAT(P,0)) G MCRX
 I '$D(^AUPNMCR(P,11)) G MCRX
 I $D(^DPT(P,.35)),$P(^(.35),U)]"",$P(^(.35),U)<D G MCRX
 S I=0
 F  S I=$O(^AUPNMCR(P,11,I)) Q:I'=+I  D
 . Q:$P(^AUPNMCR(P,11,I,0),U)>D
 . I $P(^AUPNMCR(P,11,I,0),U,2)]"",$P(^(0),U,2)<D Q
 . S Y=1_U_"MCR: "_$$DATE($P(^AUPNMCR(P,11,I,0),U,1))_"-"_$$DATE($P(^AUPNMCR(P,11,I,0),U,2))
 .Q
MCRX ;
 Q Y
 ;
 ;----------
 ; MCD:     Input -  P = DFN
 ;                   D = Date
 ;          Output - 1 = Yes, patient is/was MCaid eligible on date D.
 ;                   0 = No, or unable.
 ;
 ;      Examples: I $$MCD^AUPNPAT(DFN,2930701)
 ;                S AGMCD=$$MCD^AUPNPAT(DFN,DT)
 ;
MCD(P,D) ;EP - Is patient P medicaid eligible on date D.
 ; I = IEN.
 ; J = Node 11 IEN in ^AUPNMCD.
 I '$G(P) Q 0
 I '$G(D) Q 0
 NEW I,J,Y
 S Y=0,U="^"
 I '$D(^DPT(P,0)) G MCDX
 I $P(^DPT(P,0),U,19) G MCDX
 I '$D(^AUPNPAT(P,0)) G MCDX
 I $D(^DPT(P,.35)),$P(^(.35),U)]"",$P(^(.35),U)<D G MCDX
 S I=0 F  S I=$O(^AUPNMCD("B",P,I)) Q:I'=+I  D
 .Q:'$D(^AUPNMCD(I,11))
 .S J=0 F  S J=$O(^AUPNMCD(I,11,J)) Q:J'=+J  D
 ..Q:J>D
 ..I $P(^AUPNMCD(I,11,J,0),U,2)]"",$P(^(0),U,2)<D Q
 ..S Y=1_U_"MCD: "_$$DATE($P(^AUPNMCD(I,11,J,0),U,1))_"-"_$$DATE($P(^AUPNMCD(I,11,J,0),U,2))
 ..Q
 .Q
 ;
MCDX ;
 Q Y
 ;
 ;
 ;----------
 ; PI:      Input -  P = DFN
 ;                   D = Date
 ;          Output - 1 = Yes, patient is/was PI eligible on date D.
 ;                   0 = No, or unable.
 ;
 ;      Examples: I $$PI^AUPNPAT(DFN,2930701)
 ;                S AGPI=$$PI^AUPNPAT(DFN,DT)
 ;
PI(P,D) ;EP - Is patient P private insurance eligible on date D. 1= yes, 0=no.
 ; I = IEN
 ; Y = 1:yes, 0:no
 ; X = Pointer to INSURER file.
 I '$G(P) Q 0
 I '$G(D) Q 0
 NEW I,Y,X
 S Y=0,U="^"
 I '$D(^DPT(P,0)) G PIX
 I $P(^DPT(P,0),U,19) G PIX
 I '$D(^AUPNPAT(P,0)) G PIX
 I '$D(^AUPNPRVT(P,11)) G PIX
 I $D(^DPT(P,.35)),$P(^(.35),U)]"",$P(^(.35),U)<D G PIX
 S I=0
 F  S I=$O(^AUPNPRVT(P,11,I)) Q:I'=+I  D
 . Q:$P(^AUPNPRVT(P,11,I,0),U)=""
 . S X=$P(^AUPNPRVT(P,11,I,0),U) Q:X=""
 . Q:$P(^AUTNINS(X,0),U)["AHCCCS"
 . Q:$P(^AUPNPRVT(P,11,I,0),U,6)>D
 . I $P(^AUPNPRVT(P,11,I,0),U,7)]"",$P(^(0),U,7)<D Q
 . S Y=1_U_"PI: "_$$DATE($P(^AUPNPRVT(P,11,I,0),U,6))_"-"_$$DATE($P(^AUPNPRVT(P,11,I,0),U,7))
 .Q
PIX ;
 Q Y
DATE(D) ;EP
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+($E(D,1,3)))
 ;
