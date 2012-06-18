ASUUTIL ; IHS/ITSC/LMH - VARIOUS UTILITY SUBROUTINES USED BY SAMS REPORTS ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;;Y2K/OK AEF/2970311
 ;This routine contains various utilities used by the SAMS reports
 ;
 ;
WRITE16(X)         ;EP
 ;----- WRITES DATA COLUMNS FOR REPORTS 16,17,18
 ;
 ;      X        =  data to be printed, passed by calling routine
 ;      ASUPC    =  piece of X to print
 ;      ASUCOL   =  column to print data in
 ;
 N ASUCOL,ASUPC,I,J
 S ASUPC=1
 F J="CU MO","Y-T-D" D
 . W ?13,J
 . S ASUCOL=4
 . F I=1:1:7 S ASUCOL=ASUCOL+16 W ?ASUCOL,$S('+$P(X,U,ASUPC):"",1:$J($P(X,U,ASUPC),12,2)) S ASUPC=ASUPC+1
 . W !
 Q
 ;
HDR16(ASUDT,ASUTYP,ASUPAGE,ASUHDR,ASUOUT)        ;EP
 ;----- WRITES REPORT HEADERS FOR REPORTS 16,17,18
 ;
 ;      ASUDT   =  report date or month
 ;      ASUTYP  =  report type, "I"=individual, "M"=monthly
 ;      ASUPAGE =  report page number
 ;      ASUHDR  =  array containing report header segments
 ;      ASUOUT  =  '^' to escape controller
 ;
 N %,DIR,X,Y
 I $E(IOST)="C",$G(ASUPAGE) S DIR(0)="E" D ^DIR K DIR I 'Y S ASUOUT=1 Q
 S ASUPAGE=$G(ASUPAGE)+1
 W @IOF
 W ASUHDR(1)," FOR ",$S(ASUTYP="M":"MONTH ",ASUTYP="I":"EXTRACT DATE ",1:"")
 S Y=ASUDT X ^DD("DD") W Y
 W ?116,"PAGE ",$J(ASUPAGE,6)
 I $G(ASUHDR(2))]"" W !,$G(ASUHDR(2))
 I $G(ASUHDR(3))]"" W !,$G(ASUHDR(3))
 W !!,ASUHDR(4),?23,"PURCHASED",?36,"UNREQ/EXCESS",?55,"DONATIONS",?75,"STORE",?87,"PURCHASED",?100,"UNREQ/EXCESS",?119,"DONATIONS"
 W !,ASUHDR(5),?24,"RECEIPTS",?36,"RECEIVED FOR",?52,"RECEIVED FOR",?76,"ROOM",?88,"RECEIPTS",?100,"RECEIVED FOR",?116,"RECEIVED FOR"
 W !,ASUHDR(6),?27,"STOCK",?43,"STOCK",?59,"STOCK",?74,"ISSUES",?84,"DIRECT ISSUE",?100,"DIRECT ISSUE",?116,"DIRECT ISSUE"
 W !
 Q
 ;
SELXTRCT ;EP -- SELECT INDIVIDUAL EXTRACT DATE OR EXTRACT MONTH FOR REPORTS
 ;
 ;      Returns  ASUTYP  =  type of report where:
 ;                          I = individual extract
 ;                          M = monthly
 ;               ASUDT   =  extract date or month
 ;
 N DIR,X,Y
 S DIR(0)="S^M:ALL EXTRACTS FOR A MONTH;I:ONE INDIVIDUAL EXTRACT DATE"
 D ^DIR
 S ASUTYP=Y
 I ASUTYP="I" D INDIV
 I ASUTYP="M" D MONTH
 Q
MONTH ;----- SELECT MONTH FOR REPORT
 ;
 ;      Returns  ASUDT  =  extract month picked by user
 ;
 ;               ASU1   =  internal entry number of extract date in
 ;                         ASULOG EXTRACT file
 ;
 N ASU1,DIC,X,Y
 K ASUDT
 S DIC="^ASUML(",DIC(0)="AEMQ",DIC("A")="Select MONTH: "
 D ^DIC
 Q:+Y'>0
 S ASUDT=$P(^ASUML(+Y,0),U)
 Q
DAYS(ASUDT)        ;EP
 ;----- GETS ALL EXTRACT DATES BELONGING TO THE CHOSEN MONTH
 ;
 ;      Returns ASUDT("DXTRACT") = array containing extract dates
 ;              ASUDT("MXTRACT") = extract month
 ;
 ;      ASUDT  =  the month entry in the ASULOG EXTRACT file
 ;      ASU0   =  internal entry number of month in ASULOG EXTRACT file
 ;      ASU1   =  internal entry of extract date in ASULOG EXTRACT file
 ;      ASU2   =  extract date
 ;
 N ASU0,ASU1,ASU2
 S ASUDT("MXTRACT")=ASUDT
 S ASU0=$O(^ASUML("B",ASUDT,0))
 S ASU1=0 F  S ASU1=$O(^ASUML(+ASU0,1,ASU1)) Q:'ASU1  D
 . S ASU2=$P(^ASUML(+ASU0,1,ASU1,0),U)
 . S ASUDT("DXTRACT",ASU2)=""
 Q
INDIV ;----- SELECT ONE INDIVIDUAL EXTRACT/CLOSEOUT DATE FOR REPORTS
 ;
 ;      Returns ASUDT = extract date for report
 ;
 ;      ASUX    =  array used to store extract dates for display
 ;      ASU1    =  file number for example:
 ;                 2 = ASUTUL RECEIPTS
 ;                 3 = ASUTUL ISSUES
 ;                 7 = ASUTUL DIRECT ISSUES
 ;      ASU2    =  transaction date in the 'AX' crossreference
 ;      ASUDT   =  date picked by user
 ;      ASUOUT  =  '^' escape controller
 ;
 N ASU1,ASU2,ASUOUT,ASUX,DIR,%DT,X,Y
 K ASUDT
 F ASU1=1:1:7 D AX(ASU1)
 S %DT="AEPX",%DT("A")="Select EXTRACT DATE: "
 S ASUOUT=0 F  D  Q:ASUOUT
 . D ^%DT
 . I Y'>0 S ASUOUT=1 Q
 . S ASUDT=Y
 . I $D(ASUX(ASUDT)) S ASUOUT=1 Q
 . K ASUDT
 . W *7," ??"
 . S DIR(0)="Y",DIR("A")=" Do you want the entire EXTRACT DATE list",DIR("B")="YES"
 . D ^DIR
 . I Y D LIST
 Q
 ;
AX(ASU1) ;EP -- BUILDS LIST OF EXTRACT DATES
 ;
 ;      Returns ASUX array containing extract dates
 ;
 ;      ASU1  =  file to get dates from, where for example:
 ;               2 = ASUTUL RECEIPTS
 ;               3 = ASUTUL ISSUES
 ;               7 = ASUTUL DIRECT ISSUES
 ;      ASU2  =  extract date in 'AX' crossreference
 ;
 N ASU2
 S ASU2=0 F  S ASU2=$O(^ASUH("AX",ASU2)) Q:'ASU2  D
 . S:'$D(ASUX(ASU2)) ASUX(ASU2)=$$EXTDATE^ASUUTIL1(ASU2)
 Q
 ;
LIST ;EP -- LIST EXTRACT DATES
 ;
 ;      Lists extract dates found in 'AX' crossreference of SAMS
 ;      transaction files - the list is built in AX^ASUUTIL
 ;
 ;      ASU1    =  extract date, member of ASUX( array
 ;      ASUOUT  =  '^' escape controller
 ;      ASUX    =  array containing extract dates - from AX^ASUUTIL
 ;
 N ASU1,ASUOUT
 S $Y=0
 S ASUOUT=0 W !,"Choose from:"
 S ASU1=0 F  S ASU1=$O(ASUX(ASU1)) Q:'ASU1  D  Q:ASUOUT
 . I $Y>(IOSL-2) D OUT(.ASUOUT) Q:ASUOUT
 . W !?3,ASUX(ASU1)
 Q
 ;
OUT(ASUOUT)        ;EP
 ;----- ISSUES "Enter RETURN to continue or '^' to exit:" PROMPT
 ;
 ;      Returns ASUOUT = '^' escape controller where:
 ;                       0 = continue
 ;                       1 = quit
 ;
 ;
 N DIR,DX,DY,Y
 D HOME^%ZIS
 S DIR(0)="E" D ^DIR I 'Y S ASUOUT=1 Q
 W *13,$J("",50),*13
 S DY=$Y-2,DX=0,$Y=0 X IOXY
 Q
 ;
TC16 ;EP -- SETS UP TRANSACTION CODE ARRAY USED BY REPORTS 16,17,18
 ;
 ;      Returns:
 ;      ASU("TC")  =  array containing allowable transaction codes
 ;                    the value of each member of this array
 ;                    corresponds to the report column where each type
 ;                    of transaction is totaled
 ;
 N I
 K ASU("TC")
 S (ASU("TC",22),ASU("TC","2K"))=1
 F I=24,"2M",26,"2O" S ASU("TC",I)=2
 S (ASU("TC",25),ASU("TC","2N"))=3
 F I=32,33,"3K","3L" S ASU("TC",I)=4
 S (ASU("TC","02"),ASU("TC","0K"))=5
 F I="04","0M","06","0O" S ASU("TC",I)=6
 S (ASU("TC","05"),ASU("TC","0N"))=7
 Q
 ;
DT(ASUDT,ASUTYP)   ;EP
 ;----- SETS UP DATE ARRAYS
 ;
 ;      Returns ASUDT("DXTRACT") = extract date array
 ;              ASUDT("MXTRACT") = extract month
 ;              ASU("DT","FY")   = fiscal year
 ;
 ;      ASUDT   =  extract date or month
 ;      ASUTYP  =  report type, "I"=individual extract, "M"=monthly
 ;      ASU1    =  file to get dates from where for example:
 ;                 2 = ASUTUL RECEIPTS
 ;                 3 = ASUTUL ISSUES
 ;                 7 = ASUTUL DIRECT ISSUES
 N ASU1
 I ASUTYP="I" D
 . F ASU1=1:1:7 D AX(ASU1)
 . I $D(ASUX(ASUDT)) S ASUDT("DXTRACT",ASUDT)=""
 I ASUTYP="M" D DAYS(.ASUDT)
 S ASU("DT","FY")=+$$FY^ASUUTIL1(ASUDT)
 Q
 ;
DATA16(ASU2)  ;EP
 ;----- GETS TRANSACTION DATA USED BY SAMS REPORTS
 ;
 ;      Returns ASUD( array containing transaction data
 ;
 ;      ASUDATA  =  temporary data storage
 ;      ASU0     =  transaction type  where:
 ;                  2 = RECEIPTS
 ;                  3 = ISSUES
 ;                  7 = DIRECT ISSUES
 ;      ASU2     =  internal file entry number
 ;      ASUD     =  array where transaction data is stored
 ;
 N ASUDATA
 K ASUD
 S ASUDATA=$G(^ASUH(ASU2,0))
 S ASUD("STATUS")=$P(ASUDATA,U,10)
 S ASUD("AREA")=$P(ASUDATA,U,2)
 I ASUD("AREA") S ASUD("AREA")=ASUD("AREA")_" "_$P($G(^ASUL(1,ASUD("AREA"),0)),U)
 S:'+ASUD("AREA") ASUD("AREA")="UNK"
 S ASUD("STA")=$P(ASUDATA,U,3)
 I ASUD("STA") S ASUD("STA")=$P($G(^ASUL(2,ASUD("STA"),1)),U)_" "_$P($G(^ASUL(2,ASUD("STA"),0)),U)
 S:'+ASUD("STA") ASUD("STA")="UNK"
 S ASUD("SST")=$P(ASUDATA,U,13)
 I ASUD("SST") S ASUD("SST")=$P($G(^ASUL(18,ASUD("SST"),1)),U)_" "_$P($G(^ASUL(18,ASUD("SST"),0)),U)
 S:'+ASUD("SST") ASUD("SST")="UNK"
 S ASUD("ACC")=$P(ASUDATA,U,4)
 I ASUD("ACC") S ASUD("ACC")=$P($G(^ASUL(9,ASUD("ACC"),0)),U,3)
 S:ASUD("ACC")']"" ASUD("ACC")="UNK"
 S ASUD("ACCNAM")=$O(^ASUL(9,"D",ASUD("ACC"),0))
 I ASUD("ACCNAM") S ASUD("ACCNAM")=$P($G(^ASUL(9,ASUD("ACCNAM"),0)),U)
 I ASUD("ACCNAM")="" S ASUD("ACCNAM")="UNK"
 S ASUD("USR")=$P(ASUDATA,U,14)
 I ASUD("USR") S ASUD("USR")=+$P($G(^ASUL(19,ASUD("USR"),1)),U)
 S:ASUD("USR")']"" ASUD("USR")="UNK"
 S ASUD("SSA")=$P(ASUDATA,U,11)
 S:ASUD("SSA") ASUD("SSA")=$P($G(^ASUL(17,ASUD("SSA"),1)),U)
 S:ASUD("SSA")']"" ASUD("SSA")="UNK"
 S ASUD("SRC")=$P(ASUDATA,U,12)
 I ASUD("SRC") D
 . S ASUD("SRC")=$G(^ASUL(5,ASUD("SRC"),0))
 . I ASUD("SRC")]"" S ASUD("SRC")=$P(ASUD("SRC"),U,2)_" - "_$P(ASUD("SRC"),U)
 I ASUD("SRC")']"" S ASUD("SRC")="UNK"
 S ASUD("DOBJPTR")=$P(ASUDATA,U,17)
 S ASUD("IDXPTR")=$P(ASUDATA,U,5)
 S ASUDATA=$G(^ASUH(ASU2,1))
 S ASUD("TRANS")=$P(ASUDATA,U)
 S ASUD("VAL")=$P(ASUDATA,U,7)
 I "0K^0M^0N^0O^1K^1M^1N^1O^2K^2M^2N^2O^2P^3J^3K^3L^3M^3O^3P^"[ASUD("TRANS")_U S ASUD("VAL")=0-ASUD("VAL")
 S ASUD("VOUCH")=$P(ASUDATA,U,8)
 S:ASUD("VOUCH")']"" ASUD("VOUCH")="UNK"
 S ASUD("CAN")=$P(ASUDATA,U,15)
 S:ASUD("CAN")']"" ASUD("CAN")="UNK"
 S ASUD("OBJ")=$P(ASUDATA,U,17)
 S:ASUD("OBJ")="" ASUD("OBJ")="UNK"
 Q
 ;
QUE(ZTRTN,ZTSAVE,ZTDESC)     ;EP
 ;----- QUEUEING CODE
 ;
 N %ZIS,IO,POP,ZTIO,ZTSK
 S %ZIS="QM" D ^%ZIS Q:POP  ; JDH added M to %ZIS to ask for RM
 I $D(IO("Q")) K IO("Q") S ZTIO=ION_";"_IOST_";"_IOM_";"_IOSL D ^%ZTLOAD I $G(ZTSK) W !,"Task #",$G(ZTSK)," queued"
 E  D @ZTRTN
 Q
