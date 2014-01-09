BCHRNRL ; IHS/CMI/LAB - CHR Report 1 ; 
 ;;2.0;IHS RPMS CHR SYSTEM;;OCT 23, 2012;Build 27
 ;
START ; 
 D INFORM
GETDATES ;
BD ;get beginning date
 S BCHYEARS=0
 W !!,"Please enter the number of years to determine if the patient should be"
 W !,"listed on the report.  For example, if you want all patients who have"
 W !,"been seen in the past 5 years enter 5.",!
 S DIR(0)="N^1:100:0",DIR("A")="List patients seen in the past how many years?",DIR("B")="10" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 S BCHYEARS=Y
 S BCHBD=$$FMADD^XLFDT(DT,-(BCHYEARS*365))
 ;
ZIS ;CALL TO XBDBQUE
 S XBRP="PRINT^BCHRNRL",XBRC="PROC^BCHRNRL",XBRX="XIT^BCHRNRL",XBNS="BCH"
 D ^XBDBQUE
 D XIT
 Q
ERR W $C(7),$C(7),!,"Must be a valid date and be Today or earlier. Time not allowed!" Q
XIT ;
 D EN^XBVK("BCH")
 Q
INFORM ;
 W:$D(IOF) @IOF
 W !?20,"**********  NON-REGISTERED PATIENT LIST  **********"
 W !!,"This report will list all Non-Registered Patients in the CHR Non-Registered"
 W !,"patient file who have been seen in the last N number of years you indicate."
 W !,"The list will be sorted by DOB, NAME, TRIBE, COMMUNITY",!!
 Q
 ;
PROC ;
 S BCHJ=$J,BCHH=$H
 S BCHX=0 F  S BCHX=$O(^BCHRPAT(BCHX)) Q:BCHX'=+BCHX  D
 .Q:'$$LASTV(BCHX,BCHBD)  ;no visit in time period
 .S N=^BCHRPAT(BCHX,0)
 .S D=$P(N,U,2) I D="" S D="BLANK"
 .S S=$$VAL^XBDIQ1(90002.11,BCHX,.03) I S="" S S="BLANK"
 .S T=$$VAL^XBDIQ1(90002.11,BCHX,.05) I T="" S T="BLANK"
 .S C=$$VAL^XBDIQ1(90002.11,BCHX,.06) I C="" S C="BLANK"
 .S ^XTMP("BCHRNRL",BCHJ,BCHH,"DATA",D,$P(^BCHRPAT(BCHX,0),U,1),S,T,C,BCHX)=""
 .Q
 Q
LASTV(P,D) ;EP
 NEW X,Y,Z,G
 S G=0
 S X=0 F  S X=$O(^BCHR("ANRE",P,X)) Q:X'=+X!(G)  D
 .S Y=0 F  S Y=$O(^BCHR("ANRE",P,X,Y)) Q:Y'=+Y!(G)  D
 ..I X<D Q
 ..S G=1
 Q G
PRINT ;EP
 D XTMP^BCHUTIL("BCHRNRL","CHR NON REG PT REPORT")
 D NOW^%DTC S Y=X D DD^%DT S BCHDT=Y
 K BCHQUIT S BCHPG=0
 S Y=BCHBD D DD^%DT S BCHBDD=Y
 I '$D(^XTMP("BCHRNRL",BCHJ,BCHH,"DATA")) D HEAD W !!,"NO PATIENTS TO REPORT",!! G DONE
 D HEAD
 S BCHD="" F  S BCHD=$O(^XTMP("BCHRNRL",BCHJ,BCHH,"DATA",BCHD)) Q:BCHD=""!($D(BCHQUIT))  D
 .S BCHN="" F  S BCHN=$O(^XTMP("BCHRNRL",BCHJ,BCHH,"DATA",BCHD,BCHN)) Q:BCHN=""!($D(BCHQUIT))  D
 ..S BCHS="" F  S BCHS=$O(^XTMP("BCHRNRL",BCHJ,BCHH,"DATA",BCHD,BCHN,BCHS)) Q:BCHS=""!($D(BCHQUIT))  D
 ...S BCHT="" F  S BCHT=$O(^XTMP("BCHRNRL",BCHJ,BCHH,"DATA",BCHD,BCHN,BCHS,BCHT)) Q:BCHT=""!($D(BCHQUIT))  D
 ....S BCHC="" F  S BCHC=$O(^XTMP("BCHRNRL",BCHJ,BCHH,"DATA",BCHD,BCHN,BCHS,BCHT,BCHC)) Q:BCHC=""!($D(BCHQUIT))  D
 .....W !,BCHN
 .....I BCHD'="BLANK" W ?32,$$DATE(BCHD)
 .....I BCHS'="BLANK" W ?42,$E(BCHS)
 .....I BCHT'="BLANK" W ?46,$E(BCHT,1,15)
 .....I BCHC'="BLANK" W ?63,$E(BCHC,1,15)
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  HIT RETURN" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 K ^XTMP("BCHRNRL",BCHJ,BCHH),BCHJ,BCHH
 Q
DATE(D) ;EP
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 ;
HEAD ;
 I BCHPG=0 G HEAD2
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BCHQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF
HEAD2 ;
 S BCHPG=BCHPG+1
 W !,$P(^VA(200,DUZ,0),U,2),?58,BCHDT,?72,"Page ",BCHPG,!
 W $$CTR^BCHRLU($$LOC^BCHRLU),!
 S X="**********  LIST OF NON-REGISTERED PATIENTS  **********" W !,$$CTR^BCHRLU(X,80)
 S X="SEEN BY THE CHR PROGRAM SINCE "_BCHBDD W !,$$CTR^BCHRLU(X,80)
 W !,"NAME",?32,"DOB",?41,"SEX",?46,"TRIBE",?63,"COMMUNITY"
 W !,$TR($J("",80)," ","-"),!
 Q
