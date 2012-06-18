ASURMDBL ; IHS/ITSC/LMH - MANAGEMENT SUPPLY DATA BOOK REPORT L ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;;Y2K/OK/AEF/2970423
 ;This routine produces the Management Supply Databook Report L
 ;Receipt Values by Major Sources of Supply
 ;
 ;
EN ;EP -- MAIN ENTRY POINT (USER INTERACTIVE)
 ;
 N ASUDT,ASUTYP
 D ^XBKVAR,HOME^%ZIS
 D SELXTRCT^ASUUTIL G QUIT:'$D(ASUDT)
 W !,*7,"THIS REPORT REQUIRES 132 COLUMNS!"
 S ZTSAVE("ASUDT")="",ZTSAVE("ASUTYP")=""
 D QUE^ASUUTIL("DQ^ASURMDBL",.ZTSAVE,"SAMS DATABOOK REPORT L")
 D QUIT
 Q
EN1(ASUDT,ASUTYP)  ;EP
 ;----- ENTRY POINT CALLED BY ^ASURMSTD (NON-USER INTERACTIVE)
 ;
DQ ;EP -- QUEUED JOB STARTS HERE      
 ;
 ;      ASUDT  =  report extract date or month
 ;      ASUTYP =  type of report, I=individual, M=monthly
 ;
 D ^XBKVAR
 D:'$D(^XTMP("ASUR","RDBL")) GET
 D PRT,QUIT
 Q
GET ;EP ; GATHER DATA
 ;
 ;      Builds ^XTMP("ASUR","RDBL") global to sort and store
 ;      transaction totals
 ;
 ;      ASU      = array containing beginning, ending fiscal dates
 ;      ASU0     = file to get data from
 ;      ASU1     = extracted date in 'AX' crossreference
 ;      ASU2     = internal file entry number
 ;      ASUD     = array containing transaction data
 ;      ASUPC    = piece in ^TMP global to put the count in
 ;
 N ASU,ASU0,ASU1,ASU2,ASUD,ASUPC
 K ^XTMP("ASUR","RDBL")
 D FPP^ASUUTIL1(ASUDT)
 I ASUTYP="M" S ASUDT=$$LDOM^ASUUTIL1(ASUDT)
 F ASU0=2,7 D
 . S ASU1=ASU("DT","BEG2")-1
 . F  S ASU1=$O(^ASUTH(ASU0,"AX",ASU1)) Q:'ASU1  Q:ASU1>ASUDT  D
 . . S ASU2=0 F  S ASU2=$O(^ASUTH(ASU0,"AX",ASU1,ASU2)) Q:'ASU2  D
 . . . D DATA16^ASUUTIL(ASU0,ASU2)
 . . . S ASUPC=0
 . . . I ASU1'<ASU("DT","BEG")&(ASU1'>ASU("DT","END")) S ASUPC=1
 . . . I ASU1'<ASU("DT","BEG1")&(ASU1'>ASU("DT","END1")) S ASUPC=3
 . . . I ASU1'<ASU("DT","BEG2")&(ASU1'>ASU("DT","END2")) S ASUPC=5
 . . . I ASUPC,ASU0=2 S ASUPC=ASUPC+1
 . . . D SET
 Q
SET ;----- SETS TOTALS IN ^TMP GLOBAL
 ;
 I '$D(^XTMP("ASUR","RDBL","SRC",ASUD("AREA"),ASUD("ACCNAM"),ASUD("STA"),0)) D SRC(ASUD("AREA"),ASUD("ACCNAM"),ASUD("STA"))
 S $P(^XTMP("ASUR","RDBL","IHS",ASUD("AREA"),ASUD("ACCNAM"),ASUD("STA"),0),U,ASUPC)=$P($G(^XTMP("ASUR","RDBL","IHS",ASUD("AREA"),ASUD("ACCNAM"),ASUD("STA"),0)),U,ASUPC)+ASUD("VAL")
 S $P(^XTMP("ASUR","RDBL","IHS",ASUD("AREA"),ASUD("ACCNAM"),ASUD("STA"),ASUD("SRC"),0),U,ASUPC)=$P($G(^XTMP("ASUR","RDBL","IHS",ASUD("AREA"),ASUD("ACCNAM"),ASUD("STA"),ASUD("SRC"),0)),U,ASUPC)+ASUD("VAL")
 Q
SRC(X1,X2,X3)      ;
 ;----- SETS UP SOURCE CODE ARRAY BY AREA, STATION
 ;
 ;      X1  =  area passed by calling routine
 ;      X2  =  account passed by calling routine
 ;      X3  =  station passed by calling routine
 ;      X4  =  source code
 ;
 N X4
 S X4=0 F  S X4=$O(^ASUL(5,X4)) Q:'X4  D
 . S ^XTMP("ASUR","RDBL","SRC",X1,X2,X3,0)=""
 . S ^XTMP("ASUR","RDBL","IHS",X1,X2,X3,$P(^ASUL(5,X4,0),U),0)=""
 Q
PRT ;----- PRINTS THE DATA
 ;
 ;      ASUDATA  =  temporary data storage
 ;      ASUDATA2 =  temporary data storage
 ;      ASUL     =  array used for loop counters
 ;      ASUOUT   =  '^' to escape controller
 ;      ASUPAGE  =  report page number
 ;
 N ASUL,ASUOUT,ASUPAGE
 I '$D(^XTMP("ASUR","RDBL")) W !!,"NO DATA FOR DATABOOK REPORT L" Q
 S ASUOUT=0
 D LOOPS
 Q
 ;
LOOPS ;----- LOOPS THROUGH THE ^XTMP("ASUR","RDBK") GLOBAL AND PRINTS
 ;      THE REPORT
 ;
1 ;----- LOOP THROUGH THE AREA SUBSCRIPT
 ;
 N ASUDATA,ASUDATA2
 S ASUL(1)="" F  S ASUL(1)=$O(^XTMP("ASUR","RDBL","IHS",ASUL(1))) Q:ASUL(1)']""  D  Q:ASUOUT
 . D 2 Q:ASUOUT
 Q
2 ;----- LOOP THROUGH THE ACCOUNT SUBSCRIPT
 ;
 S ASUL(2)="" F  S ASUL(2)=$O(^XTMP("ASUR","RDBL","IHS",ASUL(1),ASUL(2))) Q:ASUL(2)']""  D  Q:ASUOUT
 . Q:ASUL(2)=0
 . D 3 Q:ASUOUT
 Q
3 ;----- LOOP THROUGH THE STATION SUBSCRIPT
 ;
 N ASUDATA,ASUDATA2
 S ASUL(3)="" F  S ASUL(3)=$O(^XTMP("ASUR","RDBL","IHS",ASUL(1),ASUL(2),ASUL(3))) Q:ASUL(3)']""  D  Q:ASUOUT
 . D HDR(ASUL(1),ASUL(2),ASUL(3)) Q:ASUOUT
 . D 4 Q:ASUOUT
 . I $Y>(IOSL-5) D HDR(ASUL(1),ASUL(2),ASUL(3)) Q:ASUOUT
 . W !!,"TOTAL RECEIPTS"
 . S (ASUDATA,ASUDATA2)=^XTMP("ASUR","RDBL","IHS",ASUL(1),ASUL(2),ASUL(3),0)
 . D WRITE(ASUDATA,ASUDATA2)
 Q
4 ;----- LOOP THROUGH THE SOURCE CODE SUBSCRIPT
 ;
 N ASUDATA,ASUDATA2
 S ASUDATA2=^XTMP("ASUR","RDBL","IHS",ASUL(1),ASUL(2),ASUL(3),0)
 S ASUL(4)="" F  S ASUL(4)=$O(^XTMP("ASUR","RDBL","IHS",ASUL(1),ASUL(2),ASUL(3),ASUL(4))) Q:ASUL(4)']""  D  Q:ASUOUT
 . Q:ASUL(4)=0
 . S ASUDATA=^XTMP("ASUR","RDBL","IHS",ASUL(1),ASUL(2),ASUL(3),ASUL(4),0)
 . I $Y>(IOSL-5) D HDR(ASUL(1),ASUL(2),ASUL(3)) Q:ASUOUT
 . W !!,ASUL(4)
 . D WRITE(ASUDATA,ASUDATA2)
 Q
WRITE(X1,X2)       ;
 ;----- WRITES DATA
 ;
 N ASUX
 W !?5,$J($P(X1,U),8,2)
 S ASUX=$$PRCNT($P(X1,U)+$P(X1,U,2),$P(X1,U))
 W ?14,$J(ASUX,4,1)
 W ?19,$J($P(X1,U,2),8,2)
 S ASUX=$$PRCNT($P(X1,U)+$P(X1,U,2),$P(X1,U,2))
 W ?28,$J(ASUX,4,1)
 W ?33,$J($P(X1,U)+$P(X1,U,2),8,2)
 S ASUX=$$PRCNT($P(X2,U)+$P(X2,U,2),$P(X1,U)+$P(X1,U,2))
 W ?42,$J(ASUX,4,1)
 W ?48,$J($P(X1,U,3),8,2)
 S ASUX=$$PRCNT($P(X1,U,3)+$P(X1,U,4),$P(X1,U,3))
 W ?57,$J(ASUX,4,1)
 W ?62,$J($P(X1,U,4),8,2)
 S ASUX=$$PRCNT($P(X1,U,3)+$P(X1,U,4),$P(X1,U,4))
 W ?71,$J(ASUX,4,1)
 W ?76,$J($P(X1,U,3)+$P(X1,U,4),8,2)
 S ASUX=$$PRCNT($P(X2,U,3)+$P(X2,U,4),$P(X1,U,3)+$P(X1,U,4))
 W ?85,$J(ASUX,4,1)
 W ?91,$J($P(X1,U,5),8,2)
 S ASUX=$$PRCNT($P(X1,U,5)+$P(X1,U,6),$P(X1,U,5))
 W ?100,$J(ASUX,4,1)
 W ?105,$J($P(X1,U,6),8,2)
 S ASUX=$$PRCNT($P(X1,U,5)+$P(X1,U,6),$P(X1,U,6))
 W ?114,$J(ASUX,4,1)
 W ?119,$J($P(X1,U,5)+$P(X1,U,6),8,2)
 S ASUX=$$PRCNT($P(X2,U,5)+$P(X2,U,6),$P(X1,U,5)+$P(X1,U,6))
 W ?128,$J(ASUX,4,1)
 Q
HDR(X1,X2,X3)      ;
 ;----- WRITES REPORT HEADER
 ;
 ;      X1 = area
 ;      X2 = account
 ;      X3 = station
 ;
 N %,DIR,X,Y
 I $E(IOST)="C",$G(ASUPAGE) S DIR(0)="E" D ^DIR K DIR I 'Y S ASUOUT=1 Q
 S ASUPAGE=$G(ASUPAGE)+1
 W @IOF
 W "MANAGEMENT SUPPLY DATA BOOK for "
 S Y=ASUDT X ^DD("DD") W $P(Y," ")," ",$P(Y,",",2)
 W ?116,"PAGE ",$J(ASUPAGE,6)
 W !,"AREA ",X1
 W !!,"L. RECEIPT VALUES BY MAJOR SOURCES OF SUPPLY"
 W !?3,"Category: ",X2
 W !!,"LOCATION: ",X3
 W !!?16,"CURRENT FISCAL YEAR",?58,"PREVIOUS FISCAL YEAR",?98,"PREVIOUS-PREV FISCAL YEAR"
 W !?7,"DIRECT",?17,"%",?22,"STOCK",?31,"%",?36,"TOTAL",?45,"%",?50,"DIRECT",?60,"%",?65,"STOCK",?74,"%",?79,"TOTAL",?88,"%",?93,"DIRECT",?103,"%",?108,"STOCK",?117,"%",?122,"TOTAL",?131,"%"
 W !?7,"ISSUES",?15,"DIR RECEIPTS",?29,"STK RECEIPTS",?43,"TOT",?50,"ISSUES",?58,"DIR RECEIPTS",?72,"STK RECEIPTS",?86,"TOT",?93,"ISSUES",?101,"DIR RECEIPTS",?115,"STK RECEIPTS",?129,"TOT"
 Q
PRCNT(X,Y)         ;
 ;----- CALCULATES PERCENT
 ;
 I +X=0 Q ""
 Q (Y/X)*100
 ;
QUIT ;----- CLEAN UP VARIABLES, CLOSE DEVICE, QUIT
 ;
 K ZTSAVE
 K ^XTMP("ASUR","RDBL")
 I $G(ASUK("PTRSEL"))]"" W @IOF Q
 D ^%ZISC
 Q
