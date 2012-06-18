ACHSCHLG ; IHS/ITSC/PMF - COMPRESS PRINTING OF HOSPITAL LOG ;   [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 W *7,!!?20,"This report may take awhile to compile."
 W !?9,"It is recommended that you QUEUE your output to a PRINTER."
DEVICE ;Device Selection
 W *7,*7,!!,"This report requires 132 column format."
 K DIR
 S %ZIS="PQ"
 W !
 D ^%ZIS
 I POP W !,"NO DEVICE SELECTED - REQUEST ABORTED!" G END
 K ACHS("PRINT")
 I '$D(^%ZIS(2,IOST(0),12.1))!'$D(^%ZIS(2,IOST(0),5)) G NOCON
 I $G(^%ZIS(2,IOST(0),12.1))=""!($P($G(^%ZIS(2,IOST(0),5)),U)="") G NOCON
 S ACHS("PRINT",16)=$G(^%ZIS(2,IOST(0),12.1)),ACHS("PRINT",10)=$P($G(^%ZIS(2,IOST(0),5)),U)
 W !
 K DIR
 S DIR(0)="Y",DIR("A")="Should Output be in CONDENSED PRINT",DIR("B")="YES"
 D ^DIR
 K DIR
 Q:Y["^"
 I '$G(Y),IOM'=132 D  G END:Y=0,DEVICE:Y=1
 . I $D(ACHS("PRINT",10)) W @ACHS("PRINT",10)
 . W !!!,"You have elected NOT to print in compressed print mode",!,"and the selected printer does not have 132 column capability."
 . K DIR
 . S DIR("A")="Select another printer",DIR(0)="Y",DIR("B")="NO"
 . D ^DIR
 . K DIR
 .Q
 I '$G(Y),IOM=132 W !!,"Please make sure the printer is loaded with 132 column paper."
 S:IOM=80 IOM=132
 S:$D(IO("Q")) IOP="Q;"_ION
 S:'$D(IO("Q")) IOP=ION
 W !!!!
 N L,DIC,FLDS,BY,DIOBEG,DIOEND
 S L=0,DIC="^ACHSF(",FLDS="[ACHSRPTHOSPLOGP]",BY="[ACHSRPTHOSPLOGS]"
 ; S DIOBEG="W @ACHS(""PRINT"",16)",DIOEND="W @ACHS(""PRINT"",10)"
 D EN1^DIP
END ;
 Q
 ;
NOCON ;
 W *7,!!,"===Condensed Print Mode has not been established for this Device.===",!!!!
 I $$DIR^XBDIR("E","Press <RETURN> to Continue")
 G END
 ;
