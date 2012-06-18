AZHLSC ; IHS/ADC/GTH:KEU:JN - DRIVER FOR SAC CHECKER ;  [ 07/01/1999  7:05 AM ]
 ;;5.0;AZHLSC;;JUL 10, 1996
 ;
 ; New to 4.3X:
 ; 1) Changed message in techniques:
 ;   ;If checking for background, $D(ZTQUEUED) recommended instead of $D(ZTSK).
 ; 2) Added check of 4-slash-stuff of .01 field to AZHLSCT.
 ;
 NEW AZHL,AZHLNMSP,AZHLPIEN,AZHLROOT,AZHLTERM,AZHLOPTN,DIC,DIK
 ;
 D HOME^%ZIS
 S:$D(DUZ)#2-1 DUZ=0 S:$D(DUZ(0))#2-1 DUZ(0)=""
 I '$D(DTIME) S DTIME=999
 K %DT D NOW^%DTC S DT=X,U="^"
 ;
0 W !!!?4,$P($T(@"AZHLSC"+1),";",4)," v ",$P($T(@"AZHLSC"+1),";",3),!
 D EN^AZHLSCA I AZHLSC4I=1 G 01
 X ^%ZOSF("RSEL")
01 K AZHLSC4I S Y=0 I $D(^DIC(9.4)) S DIC=9.4,DIC(0)="AEMNQZ" D ^DIC
 I Y<1,$O(^UTILITY($J,""))="" Q
 S (AZHLROOT,AZHLNMSP,AZHLPIEN)=""
 I Y>0 S AZHLROOT=DIC_+Y_",",AZHLNMSP=$P(Y(0),U,2),AZHLPIEN=+Y
 ;
1 W !!?10 D PKG
2 F I=1:1:3,16:1:19 W !?10,$J(I,3),"   ",$P($T(@"RTNS"+I),";",4)
 R !!?15,"Select :  16 // ",AZHLOPTN:DTIME G:'$T!(AZHLOPTN=U) END S:AZHLOPTN="" AZHLOPTN=16
 F AZHLOPTN(1)=1:1:3,16:1:19 I AZHLOPTN=AZHLOPTN(1) G DEVICE:AZHLOPTN(1)<17 D ^AZHLSCS:AZHLOPTN(1)=17,^AZHLSCFV:AZHLOPTN(1)=18,^AZHLSCT:AZHLOPTN(1)=19 G 0
 W "  ??",*7 G 0
 ;
DEVICE W !!,"Report will be QUEUE'd if device other than HOME selected.",! K IOP,%ZIS S %ZIS="NQM",%ZIS("B")="" D ^%ZIS K %ZIS I POP W !,*7,"No device specified." G END
 S AZHLTERM=0,IOP=ION_";"_IOST_$S($D(IO("DOC")):";"_IO("DOC"),1:";"_IOM_";"_IOSL)
 I IO=IO(0),"C"[$E(IOST),$D(IO("Q"))#2 W !,"Can't Q to home device." K IO("Q") G DEVICE
 I IO'=IO(0),'$D(IO("Q")) W !!,"Report being QUEUE'd to run now for you." S IO("Q")=1,ZTDTH=$H
 I '$D(IO("Q")) S AZHLTERM=('$D(IO("S"))&(IO=IO(0))) D ^%ZIS G START
 S ZTRTN="START^AZHLSC",ZTIO=IOP,ZTDESC="SAC of "_AZHLNMSP_" package." F G="AZHLOPTN","AZHLPIEN","AZHLNMSP","AZHLTERM","^UTILITY($J," S ZTSAVE(G)=""
 K IO("Q") D ^%ZTLOAD,HOME^%ZIS
END K ^UTILITY($J),AZHLGFCX,ZTSK,IOP,%ZIS,^TMP($J)
 Q
START ;EP - From TaskMan
 D GFCX
 U IO W !!,"*+*+*+*   IHS STANDARDS AND CONVENTIONS (SAC)   *+*+*+*",! D PKG,BEG
 I AZHLOPTN=16 D  G ST1
 .F AZHLOPTN=1:1:3 D @("^AZHLSC"_AZHLOPTN)
 .Q
 D @("^AZHLSC"_AZHLOPTN)
ST1 W !!!,$P($T(@"AZHLSC"+1),";",4)," v ",$P($T(@"AZHLSC"+1),";",3) D FIN
 I $D(ZTSK) S ZTREQ="@" K AZHLGFCX Q
 D END
 G 0
GFCX ;EP
 S AZHLGFCX="I $T(+1)'[""GENERATED FROM"",$T(+1)'[""COMPILED XREF"",$P($T(+1),"" "",2,99)'?1""; ;""2N1""/""2N1""/""2N.E"
 Q
PKG ;EP
 G:'$D(AZHLPIEN) P1 I 'AZHLPIEN W !,"PACKAGE not selected.",!
 E  W !,"Package : ",AZHLNMSP," - ",$P(^DIC(9.4,$O(^DIC(9.4,"C",AZHLNMSP,0)),0),U),", v ",$S($D(^DIC(9.4,$O(^DIC(9.4,"C",AZHLNMSP,0)),"VERSION")):^("VERSION"),1:"none"),!
P1 W ! S %="" F  S %=$O(^UTILITY($J,%)) Q:%=""  W $E(%_"          ",1,10) W:$X>(IOM-9) !
 Q
BEG ;EP
 W !,"Beginning " D DD W !!
 Q
FIN ;EP
 W " completed " D DD
 W:"C"'[$E(IOST) @IOF D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@"
 Q
NPKG ;EP
 W !?10,"Not checked.  No PACKAGE selected."
 Q
NRTN ;EP
 W !?10,"Not checked.  No routines selected."
 Q
TTL(X) ;EP
 W !!,X,!,$E("------------------------------------------------------------------",1,$L(X))
 Q
DD D NOW^%DTC S Y=$P("JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC"," ",$S($E(%,4,5):$E(%,4,5),1:0))_" "_$S($E(%,6,7):$E(%,6,7)_", ",1:"")_($E(%,1,3)+1700)_$S(%[".":"."_$P(%,".",2),1:"")
 I Y["." S Y=$P(Y,".")_"@"_$E(Y_0,14,15)_":"_$E(Y_"000",16,17)_$S($E(Y,18,19):":"_$E(Y_0,18,19),1:"")
 W Y,!
 Q
RTNS ;
 ;;1;GENERAL PROGRAMMING STANDARDS & CONVENTIONS
 ;;2;M LANGUAGE PROGRAMMING STANDARDS & CONVENTIONS
 ;;3;INTERFACE PROGRAMMING STANDARDS & CONVENTIONS
 ;;4;;
 ;;5;;
 ;;6;
 ;;7;
 ;;8;
 ;;9;
 ;;10;
 ;;11;
 ;;12;
 ;;13;
 ;;14;
 ;;
 ;;;ALL SACs (All The Above)
 ;;;Spell Checker
 ;;;Q-Able Field Verifier
 ;;;Techniques
