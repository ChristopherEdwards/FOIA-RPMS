ASURM15P ; IHS/ITSC/LMH - REPORT 15 MONTHLY COST REPORT ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;;Y2K/OK AEF/2970311
 ;This routine produces report #15, Monthly Cost Report
 ;
 ;
EN ;EP -- MAIN ENTRY POINT (USER INTERACTIVE)
 ;
 N ASUDT,ASUTYP
 D ^XBKVAR,HOME^%ZIS
 D SELXTRCT^ASUUTIL G QUIT:'$D(ASUDT)
 W !,*7,"THIS REPORT REQUIRES 132 COLUMNS!"
 S ZTSAVE("ASUDT")="",ZTSAVE("ASUTYP")=""
 D QUE^ASUUTIL("DQ^ASURM15P",.ZTSAVE,"SAMS RPT #15 - MONTHLY COST REPORT")
 D QUIT
 Q
EN1(ASUDT,ASUTYP)  ;EP
 ;----- ENTRY POINT CALLED BY ^ASURMSTD (NON-USER INTERACTIVE)
 ;
DQ ;EP -- QUEUED JOB STARTS HERE
 ;
 ;      ASUDT  =  report extract date or month
 ;      ASUTYP =  type of report, I=individual extract, M=monthly
 ;
 N ASU,ASUD
 D ^XBKVAR
 D GET,PRT,QUIT
 Q
GET ;EP ; GATHER DATA
 ;
 ;      Main loop through ASUTRN ISSUE and ASUTRN DIRECT ISSUE files
 ;
 ;      ASU("DT","BEG") = beginning date of fiscal year 
 ;      ASU("DT","END") = ending date of fiscal year
 ;      ASU("DT","FY")  = fiscal year
 ;      ASU("TC")       = array containing allowable transaction codes
 ;      ASU0            = transaction type where:
 ;                        3 = ISSUE
 ;                        7 = DIRECT ISSUE
 ;      ASU1            = extracted date in 'AX' crossreference
 ;      ASU2            = internal file entry number
 ;      ASUD("TRANS")   = transaction type
 ;      ASUD("STATUS")  = transaction status
 ;
 N ASU0,ASU1,ASU2,ASUI
 K ^XTMP("ASUR","R15")
 D DT^ASUUTIL(.ASUDT,ASUTYP)
 Q:'$D(ASUDT("DXTRACT"))
 S (ASU("DT","BEG"),ASU("DT","END"))=$E(ASU("DT","FY"),1,3)
 S ASU("DT","BEG")=(ASU("DT","BEG")-1)_"0999"
 S ASU("DT","END")=ASU("DT","END")_"0999"
 F ASUI=32,33,"3K","3L" S ASU("TC",ASUI)=""
 S ASU1=ASU("DT","BEG")
 F  S ASU1=$O(^ASUH("AX",ASU1)) Q:'ASU1  Q:ASU1>ASU("DT","END")  D
 . S ASU2=0 F  S ASU2=$O(^ASUH("AX",ASU1,ASU2)) Q:'ASU2  D
 . . S ASUD("TRANS")=$P($G(^ASUH(ASU2,1)),U),ASU0=$E(ASUD("TRANS")) S:ASU0=0 ASU0=7
 . . I ASU0'=3&(ASU0'=7) Q
 . . I ASU0=3 Q:'$D(ASU("TC",ASUD("TRANS")))
 . . D DATA16^ASUUTIL(ASU2)
 . . Q:ASUD("STATUS")=""
 . . Q:"UX"'[ASUD("STATUS")
 . . D SET
 Q
SET ;----- SETS DATA INTO ^XTMP("ASUR","R15") GLOBAL
 ;
 ;      Sorts and totals the transaction data and sets it into the
 ;      ^XTMP("ASUR","R15") global
 ;
 ;      ASU      = array containing dates and transaction codes
 ;      ASUD     = array containing transaction data
 ;      ASU0     = transaction type where:
 ;                 3 = ISSUE
 ;                 7 = DIRECT ISSUE
 ;      ASU1     = transaction date
 ;      ASUPC    = piece designation in ^TMP global where totals are put
 ;                 corresponding to report columns where:
 ;                 1 = current month stock issue total
 ;                 2 = fiscal year stock issue total
 ;                 3 = direct issue current month stock issue total
 ;                 4 = direct issue fiscal year direct issue total
 ;                 5 = fuel oil current month total
 ;                 6 = fuel oil fiscal year total
 ;      ASUPCM   = month piece (1, 3, or 5)
 ;      ASUPCY   = fiscal year piece (2, 4, or 6)
 ;      ASUOOT  = root of ^XTMP("ASUR","R15") global for data
 ;      ASUGLOB  = the ^XTMP("ASUR","R15") where data is stored
 ;      ASUX     = ^TMP global subscript
 ;      ASU("DXTRACT") = array containing extract dates
 ;      ASU("OBJ")     = transaction object class code
 ;      ASU("VAL")     = transaction amount
 ;
 N ASUGLOB,ASUPC,ASUPCM,ASUPCY,ASUOOT,ASUX
 I $D(ASUDT("DXTRACT",ASU1)) D
 . I ASU0=3 S ASUPCM=1,ASUPCY=2
 . I ASU0=7,ASUD("OBJ")'="268H" S ASUPCM=3,ASUPCY=4
 . I ASU0=7,ASUD("OBJ")="268H" S ASUPCM=5,ASUPCY=6
 I '$D(ASUDT("DXTRACT",ASU1)) D
 . I ASU0=3 S ASUPCM=0,ASUPCY=2
 . I ASU0=7,ASUD("OBJ")'="268H" S ASUPCM=0,ASUPCY=4
 . I ASU0=7,ASUD("OBJ")="268H" S ASUPCM=0,ASUPCY=6
 F ASUPC=ASUPCM,ASUPCY D
 . S ASUOOT="^TMP(""ASUR"","_$J_",""R15"","
 . F ASUX="AREA","STA","SST","USR","CAN","ACC" D
 . . S ASUOOT=ASUOOT_"ASUD("_""""_ASUX_""""_"),"
 . . S ASUGLOB=ASUOOT_"0)"
 . . S $P(@ASUGLOB,U,ASUPC)=$P($G(@ASUGLOB),U,ASUPC)+ASUD("VAL")
 . I ASU0=7,ASUD("OBJ")'="248H",ASUPC'=ASUPCY D
 . . S ASUOOT=ASUOOT_"ASUD("_""""_"OBJ"_""""_"),"
 . . S ASUGLOB=ASUOOT_"0)"
 . . S $P(@ASUGLOB,U,ASUPC)=$P($G(@ASUGLOB),U,ASUPC)+ASUD("VAL")
 Q
PRT ;----- PRINTS THE DATA
 ;
 ;      ASUL(         =  loop counter array
 ;      ASUPAGE       =  report page number
 ;      ASUTOT("ACC") =  array where GL account totals are stored
 ;      ASUOUT        =  '^' to continue controller
 ;      ASUDATA       =  temporary data storage
 ;
 N ASUL,ASUPAGE,ASUOUT,ASUTOT
 S ASUOUT=0
 I '$D(^XTMP("ASUR","R15")) W !!,"NO DATA FOR REPORT 15" Q
 D LOOPS
 Q
LOOPS ;----- Loops 1-7 loop through the ^XTMP("ASUR","R15") global and
 ;      print the report
 ;
1 ;----- LOOP THROUGH THE AREA SUBSCRIPT
 ;
 N ASUDATA
 S ASUL(1)="" F  S ASUL(1)=$O(^XTMP("ASUR","R15",ASUL(1))) Q:ASUL(1)']""  D  Q:ASUOUT
 . Q:ASUL(1)=0
 . D 2 Q:ASUOUT
 . S ASUDATA=^XTMP("ASUR","R15",ASUL(1),0)
 . I $Y>(IOSL-5) D HDR Q:ASUOUT
 . W !!,"AREA ",ASUL(1)," TOTALS"
 . D WRITE(ASUDATA)
 Q
2 ;----- LOOP THROUGH THE STATION SUBSCRIPT
 ;
 N ASUDATA
 S ASUL(2)="" F  S ASUL(2)=$O(^XTMP("ASUR","R15",ASUL(1),ASUL(2))) Q:ASUL(2)']""  D  Q:ASUOUT
 . Q:ASUL(2)=0
 . D HDR
 . D 3 Q:ASUOUT
 . S ASUDATA=^XTMP("ASUR","R15",ASUL(1),ASUL(2),0)
 . I $Y>(IOSL-5) D HDR Q:ASUOUT
 . W !,"STATION ",ASUL(2)," TOTALS"
 . D WRITE(ASUDATA)
 Q
3 ;----- LOOP THROUGH THE SUB-STATION SUBSCRIPT
 ;
 N ASUDATA
 S ASUL(3)="" F  S ASUL(3)=$O(^XTMP("ASUR","R15",ASUL(1),ASUL(2),ASUL(3))) Q:ASUL(3)']""  D  Q:ASUOUT
 . Q:ASUL(3)=0
 . I $G(ASUPAGE)>1 D HDR
 . D 4 Q:ASUOUT
 . S ASUDATA=^XTMP("ASUR","R15",ASUL(1),ASUL(2),ASUL(3),0)
 . I $Y>(IOSL-5) D HDR Q:ASUOUT
 . W !,"SUB-STATION ",ASUL(3)," TOTALS"
 . D WRITE(ASUDATA)
 . W !
 Q
4 ;----- LOOP THROUGH THE USER SUBSCRIPT
 ;
 N ASUDATA,ASUI
 S ASUL(4)="" F  S ASUL(4)=$O(^XTMP("ASUR","R15",ASUL(1),ASUL(2),ASUL(3),ASUL(4))) Q:ASUL(4)']""  D  Q:ASUOUT
 . Q:ASUL(4)=0
 . D 5 Q:ASUOUT
 . S ASUI="" F  S ASUI=$O(ASUTOT("ACC",ASUL(3),ASUL(4),ASUI)) Q:ASUI']""  D  Q:ASUOUT
 . . S ASUDATA=ASUTOT("ACC",ASUL(3),ASUL(4),ASUI)
 . . I $Y>(IOSL-5) D HDR Q:ASUOUT
 . . W !?25,ASUI,?31,"TOTAL"
 . . D WRITE(ASUDATA)
 . S ASUDATA=^XTMP("ASUR","R15",ASUL(1),ASUL(2),ASUL(3),ASUL(4),0)
 . I $Y>(IOSL-5) D HDR Q:ASUOUT
 . W !?8,"USER CODE TOTALS"
 . D WRITE(ASUDATA)
 . W !
 Q
5 ;----- LOOP THROUGH THE CAN SUBSCRIPT
 ;
 N ASUDATA
 S ASUL(5)="" F  S ASUL(5)=$O(^XTMP("ASUR","R15",ASUL(1),ASUL(2),ASUL(3),ASUL(4),ASUL(5))) Q:ASUL(5)']""  D  Q:ASUOUT
 . Q:ASUL(5)=0
 . D 6 Q:ASUOUT
 . S ASUDATA=^XTMP("ASUR","R15",ASUL(1),ASUL(2),ASUL(3),ASUL(4),ASUL(5),0)
 . I $Y>(IOSL-5) D HDR Q:ASUOUT
 . W !?17,"CAN TOTALS"
 . D WRITE(ASUDATA)
 . W !
 Q
6 ;----- LOOP THROUGH THE GL ACCOUNT SUBSCRIPT
 ;
 N ASUDATA,ASUI
 S ASUL(6)="" F  S ASUL(6)=$O(^XTMP("ASUR","R15",ASUL(1),ASUL(2),ASUL(3),ASUL(4),ASUL(5),ASUL(6))) Q:ASUL(6)']""  D  Q:ASUOUT
 . Q:ASUL(6)=0
 . D 7 Q:ASUOUT
 . S ASUDATA=^XTMP("ASUR","R15",ASUL(1),ASUL(2),ASUL(3),ASUL(4),ASUL(5),ASUL(6),0)
 . F ASUI=1:1:6 D
 . . S $P(ASUTOT("ACC",ASUL(3),ASUL(4),ASUL(6)),U,ASUI)=$P($G(ASUTOT("ACC",ASUL(3),ASUL(4),ASUL(6))),U,ASUI)+$P(ASUDATA,U,ASUI)
 . I $Y>(IOSL-5) D HDR Q:ASUOUT
 . W !?2,$E(ASUL(3),1,2),?8,ASUL(4),?17,ASUL(5),?25,ASUL(6),?31,"TOTAL"
 . D WRITE(ASUDATA)
 Q
7 ;----- LOOP THROUGH THE SUBOBJECT SUBSCRIPT
 ;
 N ASUDATA
 S ASUL(7)="" F  S ASUL(7)=$O(^XTMP("ASUR","R15",ASUL(1),ASUL(2),ASUL(3),ASUL(4),ASUL(5),ASUL(6),ASUL(7))) Q:ASUL(7)']""  D  Q:ASUOUT
 . Q:ASUL(7)=0
 . S ASUDATA=^XTMP("ASUR","R15",ASUL(1),ASUL(2),ASUL(3),ASUL(4),ASUL(5),ASUL(6),ASUL(7),0)
 . I $Y>(IOSL-5) D HDR Q:ASUOUT
 . W !?2,$E(ASUL(3),1,2),?8,ASUL(4),?17,ASUL(5),?25,ASUL(6),?38,$J($P(ASUDATA,U),10,2),?66,$S(ASUL(7)="268H":"",1:$E(ASUL(7),3,4))
 . W ?70,$J($P(ASUDATA,U,3),10,2),?84,$J($P(ASUDATA,U,4),10,2),?104,$J($P(ASUDATA,U,5),10,2),?118,$J($P(ASUDATA,U,6),10,2)
 Q
WRITE(X) ;----- WRITES TOTALS
 ;
 W ?38,$J($P(X,U),10,2),?52,$J($P(X,U,2),10,2),?70,$J($P(X,U,3),10,2),?84,$J($P(X,U,4),10,2),?104,$J($P(X,U,5),10,2),?118,$J($P(X,U,6),10,2)
 Q
HDR ;----- WRITES REPORT HEADER
 ;
 N %,DIR,X,Y
 I $E(IOST)="C",$G(ASUPAGE) S DIR(0)="E" D ^DIR K DIR I 'Y S ASUOUT=1 Q
 S ASUPAGE=$G(ASUPAGE)+1
 W @IOF
 W "REPORT #15 MONTHLY COST REPORT FOR ",$S(ASUTYP="M":"MONTH ",ASUTYP="I":"EXTRACT DATE ",1:"")
 S Y=ASUDT X ^DD("DD") W Y
 W ?116,"PAGE  ",$J(ASUPAGE,6)
 W !,"AREA ",$G(ASUL(1)),!,"STAT ",$G(ASUL(2))
 W !!,"SUB",?18,"COMMON",?27,"G L",?33,"STOCK ISSUES-OBJECT CLASS 26",?65,"DIRECT ISSUES-OBJECT CLASS 26",?101,"FUEL OIL OBJ-SUBOBJ 26.8H"
 W !,"STAT",?8,"USER",?14,"ACCOUNTING",?26,"ACCT",?34,"CURRENT MONTH",?54,"YEAR-TO-",?66,"CURRENT MONTH",?87,"YEAR-TO-",?100,"CURRENT MONTH",?121,"YEAR-TO-"
 W !,"CODE",?8,"CODE",?18,"NUMBER",?27,"NO.",?32,"SUBOBJ",?43,"VALUE",?52,"DATE VALUE",?64,"SUBOBJ",?75,"VALUE",?85,"DATE VALUE",?97,"SUBOBJ",?109,"VALUE",?119,"DATE VALUE"
 W !
 Q
QUIT ;----- CLEAN UP VARIABLES, CLOSE DEVICE, QUIT
 ;
 K ZTSAVE
 K ^XTMP("ASUR","R15")
 I $G(ASUK("PTRSEL"))]"" W @IOF Q
 D ^%ZISC
 Q
