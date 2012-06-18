ABMDRFE2 ; IHS/ASDST/DMJ - CPT Management Reports ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;
 K DIR,ABMU S ABMM("SUB")="CPT-ICD-FEE LISTING" D ^ABMDBAN
LOW S DIC="^ICPT(",DIC(0)="QEAM",DIC("A")="Select Low CPT CODE: " D ^DIC
 G XIT:$D(DTOUT)!$D(DUOUT)!(X=""),LOW:+Y<1 S ABM(1)=(+Y-1)
HIGH S DIC="^ICPT(",DIC(0)="QEAM",DIC("A")="Select High CPT CODE: " D ^DIC
 G XIT:$D(DTOUT)!$D(DUOUT)!(X=""),HIGH:+Y<1 S ABM(2)=+Y
W1 W !!! S %ZIS="Q",%ZIS("B")="",%ZIS("A")="Output DEVICE: " D ^%ZIS G:'$D(IO)!$G(POP) XIT
 S ABM("IOP")=ION G:$D(IO("Q")) QUE
 I IO'=IO(0),$E(IOST)'="C",'$D(IO("S")),$P($G(^ABMDPARM(1,0)),U,13)="Y" W !!,"As specified in the 3P Site Parameters File FORCED QUEUEING is in effect!",! G QUE
PRQUE ;EP - Entry Point for Taskman
 U IO
 D HD
 S ABM=ABM(1) F  S ABM=$O(^ICPT(ABM)) Q:'ABM!(ABM>ABM(2))  D
 .Q:$P($$CPT^ABMCVAPI(ABM,""),U,7)=1  ;CSV-c
 .I $Y>(IOSL-7) D HD
 .I $D(^ABMDFEE(11,11,ABM,0)) S ABMU(1)="?122"_U_$J($FN($P(^(0),U,2),",",2),9)
 .E  I $D(^ABMDFEE(1,15,ABM,0)) S ABMU(1)="?122"_U_$J($FN($P(^(0),U,2),",",2),9)
 .E  I $D(^ABMDFEE(1,17,ABM,0)) S ABMU(1)="?122"_U_$J($FN($P(^(0),U,2),",",2),9)
 .E  I $D(^ABMDFEE(1,19,ABM,0)) S ABMU(1)="?122"_U_$J($FN($P(^(0),U,2),",",2),9)
 .E  I $D(^ABMDFEE(1,23,ABM,0)) S ABMU(1)="?122"_U_$J($FN($P(^(0),U,2),",",2),9)
 .;start CSV-c
 .S ABMU("TXT")=""
 .D IHSCPTD^ABMCVAPI($P(ABM("X0"),U),ABMZCPTD,"","")
 .S ABMU("CP")=0
 .F  S ABMU("CP")=$O(ABMZCPTD(ABMU("CP"))) Q:'$D(ABMZCPTD(ABMU("CP")))  D
 ..S ABMU("TXT")=ABMU("TXT")_ABMZCPTD(ABMU("CP"))_" "
 .;end CSV-c
 .S ABMU("TXT")=ABM_" - "_ABMU("TXT")
 .;start CSV-c
 .S ABM(3)=0
 .F I=1:1 S ABM(3)=$O(^ICPT(ABM,"ICD",ABM(3))) Q:'ABM(3)  Q:'$D(^ICD0(ABM(3),0))  S ABMU("2TXT",I)=$P($$ICDOP^ABMCVAPI(ABM(3),""),U,2)_" - "_$E($P($$ICDOP^ABMCVAPI(ABM(3),""),U,5),1,42)
 .;end CSV-c
 .I $D(ABMU("2TXT",1)) S ABMU("2TXT")=ABMU("2TXT",1),ABMU("2LM")=70,ABMU("2RM")=120,ABMU("2TAB")=-6
 .S ABMU("LM")=0,ABMU("RM")=65,ABMU("TAB")=-10
 .D PRTTXT
 ;
XIT K ABM
 I '$D(DTOUT)!'$D(DTOUT)!'$D(DIROUT),$E(IOST)="C",'$D(IO("S")) W ! S DIR(0)="FO",DIR("A")="(REPORT COMPLETE)" D ^DIR I 1
 D ^%ZISC
 Q
 ;
PRTTXT ; UTIL FOR WRAP-AROUND
 W !
 S ABMU("TAB")=$S($D(ABMU("TAB")):ABMU("TAB"),1:0),ABMU("LNG")=ABMU("RM")-ABMU("LM")
 I $D(ABMU("2TXT")) S ABMU("2TAB")=$S($D(ABMU("2TAB")):ABMU("2TAB"),1:0),ABMU("2LNG")=ABMU("2RM")-ABMU("2LM")
 F ABMU("Q")=1:1 Q:(ABMU("TXT")=""!("    "[ABMU("TXT")))&'$D(ABMU("2TXT"))  D PRTTXT2
QIT K ABMU
 Q
 ;
PRTTXT2 K ABMU("FLG") I $L(ABMU("TXT"))<ABMU("LNG") S ABMU("F")=ABMU("TXT"),ABMU("TXT")="" G PRTTXT3
 S ABMU("FLG")="" F ABMU("C")=ABMU("LNG"):-1:1 S ABMU("L")=$E(ABMU("TXT"),ABMU("C")) Q:ABMU("L")=" "!(ABMU("L")="-")!(ABMU("L")="\")!(ABMU("L")=",")!(ABMU("L")="/")
 S ABMU("F")=$E(ABMU("TXT"),1,ABMU("C")-1),ABMU("TXT")=$E(ABMU("TXT"),ABMU("C")+1,255)
 K:"    "[ABMU("TXT")!(ABMU("TXT")="")!(ABMU("TXT")=" ") ABMU("FLG")
 ;
PRTTXT3 I $D(ABMU("2TXT")) D 2
 W ?ABMU("LM"),ABMU("F") I $D(ABMU("2TXT")) W ?ABMU("2LM"),ABMU("2F")
 I ABMU("Q")=1 F ABMU("I")=1:1 Q:'$D(ABMU(ABMU("I")))  W @$P(ABMU(ABMU("I")),U),$P(ABMU(ABMU("I")),U,2)
 W:$D(ABMU("FLG")) ! S ABMU("LM")=ABMU("LM")-ABMU("TAB"),ABMU("LNG")=ABMU("LNG")+ABMU("TAB"),ABMU("TAB")=0
 I $D(ABMU("2TXT")) S ABMU("2LM")=ABMU("2LM")-ABMU("2TAB"),ABMU("2LNG")=ABMU("2LNG")+ABMU("2TAB"),ABMU("2TAB")=0
 Q
 ;
2 I $D(ABMU("2TXT",ABMU("Q"))) S ABMU("2F")=ABMU("2TXT",ABMU("Q")),ABMU("FLG")=""
 E  K ABMU("2TXT")
 Q
 ;
HD W @IOF
 W "CPT",?70,"ICD          CORRESPONDING",?126,"FEE"
 W !,"CODE  -       CPT DESCRIPTION",?70,"CODE  -      ICD DESCRIPTION",?124,"AMOUNT"
 S ABM("H")="",$P(ABM("H"),"=",132)="" W !,ABM("H")
 Q
 ;
QUE K IO("Q") S ZTRTN="PRQUE^ABMDRFEE",ZTDESC="CPT REPORT" F ABM="DUZ(2)","DUZ(0)","ABM(" S ZTSAVE(ABM)=""
 D ^%ZTLOAD W:$D(ZTSK) !,"REQUEST QUEUED!",!
 G XIT
