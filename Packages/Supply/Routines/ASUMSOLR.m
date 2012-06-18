ASUMSOLR ; IHS/ITSC/LMH - ONLINE STATION MASTER REVIEW ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;;Y2K/OK AEF/2970626
 ;
 ;This routine allows display of the Station Master file.
 ;
 ;      Program variables:
 ;      ASUAR   =  area internal number
 ;      ASUIDX  =  index internal number
 ;      ASUL(   =  array containing area and station data
 ;      ASUMS(  =  array containing station master data
 ;      ASUMX(  =  array containing index master data
 ;      ASUOUT  =  escape controller
 ;      ASUSTA  =  station internal number
 ;      ASUTXT  =  holds text to be printed
 ;      ASUY    =  holds user input
 ;
EN1 ;EP -- MAIN ENTRY POINT FOR DATA DISPLAY
 ;
 N ASUEP
 S ASUEP=1
 D START(ASUEP)
 D QUIT
 Q
EN2 ;EP -- ENTRY POINT TO EDIT PURCHASE ORDER DUE IN DATES
 ;
 N ASUEP
 S ASUEP=2
 D START(ASUEP)
 D QUIT
 Q
 ;
START(ASUEP)       ;
 ;----- START THE PROGRAM
 ;
 N ASUOUT
 F  D  Q:$G(ASUOUT)
 . N ASUAR,ASUF,ASUK,ASUMX,ASUMS,ASUS,ASUSTA,ASUV,X,Y,ZTSAVE
 . S ASUSTA=ASUL(2,"STA","E#")
 . D ^XBKVAR,HOME^%ZIS
 . K ^TMP("ASU",$J,"IDX")
 . D SETUP(.ASUL,.ASUAR,.ASUOUT) Q:$G(ASUOUT)
 . D IDX(ASUAR,ASUSTA)
 . I '$D(^TMP("ASU",$J,"IDX")) S ASUOUT=1 Q
 . I $G(ASUEP)=2 D  Q
 . . D DISP(ASUSTA,ASUEP)
 . . H 2
 . S ZTSAVE("^TMP(""ASU"",$J,""IDX"",")="",(ZTSAVE("ASUEP"),ZTSAVE("ASUSTA"))=""
 . D QUE^ASUUTIL("DQ^ASUMSOLR",.ZTSAVE,"SAMS - ONLINE STATION MASTER REVIEW")
 Q
 ;
SETUP(ASUL,ASUAR,ASUOUT)     ;
 ;----- GET ACCOUNTING POINT OR AREA INTERNAL NUMBER
 ;
 W @IOF
 W !?5,"S.A.M.S  S.T.A.T.I.O.N  M.A.S.T.E.R  O.N.L.I.N.E  R.E.V.I.E.W",!!
 I $G(ASUL(1,"AR","E#"))']"" D ^ASUVAR I $D(DTOUT)!($D(DUOUT))!($D(DIROUT)) Q
 I $G(ASUL(1,"AR","E#"))']"" W !,"UNABLE TO FIND ACCOUNTING POINT" S ASUOUT=1 Q
 S ASUAR=ASUL(1,"AR","E#")
 Q
IDX(ASUAR,ASUSTA)  ;
 ;----- GETS INDEX NUMBERS
 ;
 N ASUOUT
 F  D  Q:$G(ASUOUT)
 . N ASUY
 . K ^TMP("ASU",$J,"IDX")
 . D GET(.ASUY,.ASUOUT)
 . Q:$G(ASUOUT)
 . D BLD(ASUY,ASUAR,ASUSTA)
 . I $D(^TMP("ASU",$J,"IDX")) S ASUOUT=1 Q
 . W !!,"You have not selected any valid items for this station.",!
 Q
GET(ASUY,ASUOUT)   ;
 ;----- PROMPTS USER FOR INDEX NUMBERS
 ;
 N DIR,X,Y
 S DIR(0)="FA"
 S DIR("A")="Enter INDEX(S): "
 S DIR("?")="Enter ONE index, a RANGE using '-', or ANY NUMBER of index numbers separated by ','"
 D ^DIR
 I Y["^"!($D(DUOUT))!($D(DTOUT)) S ASUOUT=1 Q
 S ASUY=Y
 Q
BLD(ASUY,ASUAR,ASUSTA)       ;
 ;----- BUILDS INDEX NUMBER ARRAY
 ;
 ;      Stores index numbers in ^TMP("ASU",$J,"IDX") global
 ;
 N ASUX,I
 F I=1:1:$L(ASUY,",") D
 . S ASUX=$P(ASUY,",",I)
 . I ASUX["-" D RANGE($P(ASUX,"-"),$P(ASUX,"-",2),ASUAR,ASUSTA) Q
 . S ASUX=$$PAD(ASUX,6)
 . I $L(ASUX)<8 S ASUX=ASUAR_ASUX
 . Q:$E(ASUX,1,2)'=ASUAR
 . I $D(^ASUMX(ASUX)),$D(^ASUMS(ASUSTA,1,ASUX)) S ^TMP("ASU",$J,"IDX",ASUX)=""
 Q
RANGE(X,Y,ASUAR,ASUSTA)      ;
 ;----- BUILDS ARRAY CONTAINING RANGE OF INDEX NUMBERS
 ;
 ;      X       =  starting number
 ;      Y       =  ending number
 ;
 Q:X>Y
 S X=$$PAD(X,6),Y=$$PAD(Y,6)
 I $L(X)<8 S X=ASUAR_X
 I $L(Y)<8 S Y=ASUAR_Y
 Q:$E(X,1,2)'=ASUAR
 S X=X-1 F  S X=$O(^ASUMX(X)) Q:X']""  Q:X>Y  Q:$E(X,1,2)'=ASUAR  D
 . I $D(^ASUMS(ASUSTA,1,X)) S ^TMP("ASU",$J,"IDX",X)=""
 Q
 ;
DQ ;EP -- QUEUED JOB STARTS HERE
 ;
 D DISP(ASUSTA,ASUEP)
 D QUIT
 Q
DISP(ASUSTA,ASUEP) ;
 ;----- DISPLAYS INDEX ITEM DATA
 ;
 N ASUIDX,ASUMS,ASUMX,ASUOUT
 D ^ASUVAR I $D(DTOUT)!($D(DUOUT))!($D(DIROUT)) Q  ;DFM P1 9/3/98
 S ASUIDX=0 F  S ASUIDX=$O(^TMP("ASU",$J,"IDX",ASUIDX)) Q:'ASUIDX  D WRITE(ASUSTA,ASUIDX,.ASUMS,ASUEP,.ASUOUT) Q:$G(ASUOUT)
 Q
WRITE(ASUSTA,ASUIDX,ASUMS,ASUEP,ASUOUT)          ;
 ;----- WRITES OUTPUT
 ;
 N DIR,X,Y
 D SEGS(ASUSTA,ASUIDX,ASUEP)
 I $G(ASUEP)=2 D EDIT(ASUSTA,ASUIDX,.ASUMS,ASUEP)
 I $E(IOST)="C" S DIR(0)="E" D ^DIR I 'Y S ASUOUT=1
 Q
SEGS(ASUSTA,ASUIDX,ASUEP)         ;
 ;----- WRITES DATA SEGMENTS
 ;
 S ASUMS("E#","STA")=ASUSTA
 S (ASUMS("E#","IDX"),ASUMX("E#","IDX"))=ASUIDX
 D ^ASUMXDIO,^ASUMSTRD I ASUMS("E#","IDX")[999999 W @(IOF) W !,"INDEX ",$G(ASUMX("DELIX"))," FOR ",$G(ASUMX("DELDS"))," DELETED ",$E($G(ASUMX("DELDT")),2,3),"-",$E($G(ASUMS("DELDT")),4,5) Q
 D HDR(ASUSTA),ID(.ASUMX),SS(.ASUMS,ASUEP),OV(.ASUMS,ASUEP),DI(.ASUMS),DD(.ASUMS,ASUEP)
 Q
HDR(ASUSTA)        ;
 ;----- WRITES HEADER
 ;
 W @IOF
 N ASUTXT
 ;D STA^ASULARST(ASUSTA)
 W !,"*****"
 S ASUTXT="S T A T I O N  M A S T E R  E N T R Y  F O R"
 W ?(IOM-$L(ASUTXT))/2,ASUTXT
 W ?IOM-5,"*****"
 W !,"*****"
 S ASUTXT=$G(ASUL(2,"STA","CD"))_" - "_$G(ASUL(2,"STA","NM"))
 W ?(IOM-$L(ASUTXT))/2,ASUTXT
 W ?IOM-5,"*****"
 Q
ID(ASUMX)          ;
 ;----- WRITES INDEX ITEM DATA
 ;
 W !?(IOM-46)/2,"************** INDEX ITEM DATA ***************"
 W !,"DESCR:",?9,$G(ASUMX("DESC",1)),?41,$G(ASUMX("DESC",2))
 W !,"INDEX:" I $G(ASUMX("IDX"))]"" W ?9,$E(ASUMX("IDX"),1,5)_"."_$E(ASUMX("IDX"),6)
 W ?19,"ACCOUNT:",?29,$G(ASUMX("ACC"))
 W ?34,"DTESTB:" I $G(ASUMX("ESTB"))]"" W ?42,$E(ASUMX("ESTB"),2,3)_"/"_$E(ASUMX("ESTB"),4,5)
 W ?49,"OBJSUB:" I $G(ASUMX("SOBJ"))]"" W ?57,$S(ASUMX("SOBJ")[".":ASUMX("SOBJ"),1:$E(ASUMX("SOBJ"),1,2)_"."_$E(ASUMX("SOBJ"),3,4))
 W ?64,"CATGRY:",?74,$G(ASUMX("CAT"))
 W !,"NSN:" I $G(ASUMX("NSN"))]"" W ?9,$S($L(ASUMX("NSN"))=13:$E(ASUMX("NSN"),1,4)_"-"_$E(ASUMX("NSN"),5,6)_"-"_$E(ASUMX("NSN"),7,9)_"-"_$E(ASUMX("NSN"),10,13),1:ASUMX("NSN"))
 W ?34,"STA U/I:",?44,$G(ASUMX("AR U/I"))
 Q
SS(ASUMS,ASUEP)    ;
 ;----- WRITES STATION STATISTICS
 ;
 Q:$G(ASUEP)=2
 W !?(IOM-46)/2,"************* STATION STATISTICS *************"
 W !,"QTY OH:" I $G(ASUMS("QTY","O/H"))]"" W ?8,$J(ASUMS("QTY","O/H"),7)
 W ?19,"VALUE:" I $G(ASUMS("VAL","O/H"))]"" W ?25,$J(ASUMS("VAL","O/H"),12,2)
 W ?39,"LSTISS:" I $G(ASUMS("LSTISS")) W ?47,$E(ASUMS("LSTISS"),2,3)_"/"_$E(ASUMS("LSTISS"),4,5)
 W ?54,"DUEOUT:" I $G(ASUMS("D/O","QTY"))]"" W ?64,$J(ASUMS("D/O","QTY"),7)
 W ?72,"SLC:",?78,$G(ASUMS("SLC"))
 Q
OV(ASUMS,ASUEP)    ;
 ;----- WRITES ORDER/VENDOR DATA
 ;
 Q:$G(ASUEP)=2
 W !?(IOM-46)/2,"************ ORDER / VENDOR DATA *************"
 W !,"VENDOR:",?9,$G(ASUMS("VENAM"))
 W ?39,"ORDER#:",?49,$G(ASUMS("ORD#"))
 W !,"PAMIQ:" I $G(ASUMS("PMIQ")) W ?8,$J(ASUMS("PMIQ"),7)
 W ?19,"CUR RPQ:" I $G(ASUMS("RPQ")) W ?29,$J(ASUMS("RPQ"),7)
 W ?39,"OLD RPQ:" I $G(ASUMS("RPQ-O")) W ?49,$J(ASUMS("RPQ-O"),7)
 W ?61,"SOURCE:",?69,$G(ASUMS("SRC"))
 W !,"LASTPP:" I $G(ASUMS("LPP")) W ?7,$J(ASUMS("LPP"),10,2)
 W ?19,"LEADTIM:",?29,$J($G(ASUMS("LTM")),3,1)
 W ?39,"STDPACK:" I $G(ASUMS("SPQ")) W ?49,$J(ASUMS("SPQ"),7)
 W ?61,"VEN U/I:",?71,$G(ASUMS("VENUI"))
 W !,"EOQ TYP:",?9,$G(ASUMS("EOQ","TP"))
 W ?11,"EOQ TBL:" I $G(ASUMS("EOQ","TB")) W ?19,$J(ASUMS("EOQ","TB"),4)
 W ?24,"MOS MOD:",?34,$G(ASUMS("EOQ","MM"))
 W ?39,"QTY MOD:" I $G(ASUMS("EOQ","QM")) W ?48,$J(ASUMS("EOQ","QM"),7)
 W ?61,"ACT MOD:" I $G(ASUMS("EOQ","AM")) W ?69,$J(ASUMS("EOQ","AM"),7)
 Q
DI(ASUMS)          ;
 ;----- WRITES DUE IN DATA
 ;
 N I
 W !?(IOM-46)/2,"**************** DUE IN DATA *****************"
 F I=1:1:3 D
 . W !,"DUEIN "_I_" PO:",?12,$G(ASUMS("D/I","PO#",I))
 . W ?21,"DT:" I $G(ASUMS("D/I","DT",I)) W ?26,$E(ASUMS("D/I","DT",I),4,7),$E(ASUMS("D/I","DT",I),2,3)
 . W ?34,"QTY:" I $G(ASUMS("D/I","QTY",I)) W ?39,$J(ASUMS("D/I","QTY",I),7)
 . W ?49,"VAL:" I $G(ASUMS("D/I","VAL",I)) W ?54,$J(ASUMS("D/I","VAL",I),10,2)
 . W ?67,"ON72:" I $G(ASUMS("D/I","DTR72",I)) W ?73,$E(ASUMS("D/I","DTR72",I),4,7),$E(ASUMS("D/I","DTR72",I),2,3)
 Q
DD(ASUMS,ASUEP)    ;
 ;----- WRITES DEMAND DATA
 ;
 Q:$G(ASUEP)=2
 N ASUTOT,I,J
 W !?((IOM-46)/2),"***** DEMAND DATA (CALLS & QTY BY MONTH) *****"
 W !?5,"JAN   FEB   MAR   APR   MAY   JUN   JUL   AUG   SEP   OCT   NOV   DEC   TOT"
 W !,"CA"
 S ASUTOT=0
 F I=1:1:12 S J=(I*6)-4 S ASUTOT=ASUTOT+$G(ASUMS("DMD","CALL",I)) W ?J,$J($G(ASUMS("DMD","CALL",I)),6,0)
 W ?74,$J(ASUTOT,6,0)
 W !,"QT"
 S ASUTOT=0
 F I=1:1:12 S J=(I*6)-4 S ASUTOT=ASUTOT+$G(ASUMS("DMD","QTY",I)) W ?J,$J($G(ASUMS("DMD","QTY",I)),6,0)
 W ?74,$J(ASUTOT,6,0),!
 Q
EDIT(ASUSTA,ASUIDX,ASUMS,ASUEP)     ;
 ;----- EDITS PO DUE IN DATE
 ;
 Q:$G(ASUEP)'=2
 N ASUDATA,ASUDTFLD,ASUPOFLD,ASUOUT,DA,DIE,DIR,DR,X,Y
 S ASUPOFLD="19^24^29"
 S ASUDTFLD="20^25^30"
 F  D  Q:$G(ASUOUT)  D SEGS(ASUSTA,ASUIDX,ASUEP)
 . S ASUDATA=^ASUMS(ASUSTA,1,ASUIDX,0)
 . I $P(ASUDATA,U,20)']""&($P(ASUDATA,U,25)']"")&($P(ASUDATA,U,30)']"") S ASUOUT=1 Q
 . S DIR(0)="NO^1:3:0"
 . S DIR("A")="Which Purchase Order Due In Date do you wish to change"
 . D ^DIR K DIR
 . I Y'>0!($D(DUOUT))!($D(DTOUT)) S ASUOUT=1 Q
 . I $P(ASUDATA,U,$P(ASUPOFLD,U,Y))']"" W !!,"NO PURCHASE ORDER IN THIS FIELD",! H 2 Q
 . S DIE="^ASUMS("_ASUSTA_",1,"
 . S DA=ASUIDX
 . S DA(1)=ASUSTA
 . S DR=$P(ASUDTFLD,U,Y)
 . D ^DIE K DA,DIE,DR
 . S DIR(0)="YO"
 . S DIR("A")="Do you wish to edit another Purchase Order Due In Date for this Index"
 . S DIR("B")="NO"
 . D ^DIR K DIR
 . I 'Y S ASUOUT=1
 Q
 ;
PAD(X,Y) ;----- EXTRINSIC FUNCTION TO PAD NUMBER WITH LEADING ZEROS
 ;
 ;      X  =  number to be padded with zeros
 ;      Y  =  target length of number
 ;
 F  Q:$L(X)>(Y-1)  S X="0"_X
 Q X
QUIT ;----- CLEAN UP VARIABLES, CLOSE DEVICES, QUIT
 ;
 K ^TMP("ASU",$J,"IDX")
 D ^%ZISC
 Q
