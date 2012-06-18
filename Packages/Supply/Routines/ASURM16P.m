ASURM16P ; IHS/ITSC/LMH - REPORT 16 STATION MONTHLY SUB-SUB-ACTIVITY ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;;Y2K/OK AEF/2970311
 ;This routine produces report #16, Station Monthly Sub-Sub-Activity
 ;Report
 ;
EN ;EP -- MAIN ENTRY POINT (USER INTERACTIVE)
 ;
 N ASUDT,ASUTYP
 D ^XBKVAR,HOME^%ZIS
 D SELXTRCT^ASUUTIL G QUIT:'$G(ASUDT)
 W !,*7,"THIS REPORT REQUIRES 132 COLUMNS!"
 S (ZTSAVE("ASUDT"),ZTSAVE("ASUTYP"))=""
 D QUE^ASUUTIL("DQ^ASURM16P",.ZTSAVE,"SAMS RPT #16 - STATION MONTHLY SUB-SUB-ACTIVITY REPORT")
 D QUIT
 Q
EN1(ASUDT,ASUTYP)  ;EP
 ;----- ENTRY POINT CALLED BY ^ASURMSTD (NON-USER INTERACTIVE)
 ;
 ;
DQ ;EP -- QUEUED JOB STARTS HERE
 ;
 ;
 ;      ASUDT  =  report extract date or month
 ;      ASUTYP =  type of report, I=individual extract, M=monthly
 ;
 N ASU,ASUD
 D ^XBKVAR
 D GET,PRT,QUIT
 Q
 ;
GET ;EP -- GETS THE DATA     
 ;
 ;      Main loop through ASUTRN ISSUE, ASUTRN DIRECT ISSUE, and
 ;      ASUTRN RECEIPTS files
 ;
 ;      ASU("DT","BEG") = beginning date of fiscal year
 ;      ASU("DT","END") = ending date of fiscal year
 ;      ASU("DT","FY")  = fiscal year
 ;      ASU1            = extracted date in 'AX' crossreference
 ;      ASU2            = internal file entry number
 ;      ASUD("TRANS")   = transaction type
 ;      ASUD("STATUS")  = transaction status
 ;         
 N ASU0,ASU1,ASU2
 K ^XTMP("ASUR","R16")
 D DT^ASUUTIL(.ASUDT,ASUTYP)
 Q:'$D(ASUDT("DXTRACT"))
 S (ASU("DT","BEG"),ASU("DT","END"))=$E(ASU("DT","FY"),1,3)
 S ASU("DT","BEG")=ASU("DT","BEG")-1_"0999"
 S ASU("DT","END")=ASU("DT","END")_"0999"
 D TC16^ASUUTIL
 S ASU1=ASU("DT","BEG")
 F  S ASU1=$O(^ASUH("AX",ASU1)) Q:'ASU1  Q:ASU1>ASU("DT","END")  D
 . S ASU2=0 F  S ASU2=$O(^ASUH("AX",ASU1,ASU2)) Q:'ASU2  D
 . . S ASUD("TRANS")=$P($G(^ASUH(ASU2,1)),U),ASU0=$E(ASUD("TRANS")) S:ASU0=0 ASU0=7
 . . I ASU0'=2&(ASU0'=3)&(ASU0'=7) Q
 . . D DATA16^ASUUTIL(ASU2)
 . . Q:'$D(ASU("TC",ASUD("TRANS")))
 . . Q:ASUD("STATUS")=""
 . . Q:"UX"'[ASUD("STATUS")
 . . D SET
 Q
SET ;----- SETS DATA INTO ^XTMP("ASUR","R16") GLOBAL
 ;
 ;      Sorts and totals the transaction data and sets it into the
 ;      ^XTMP("ASUR","R16") global
 ;
 ;      ASU      = array containing dates and transaction codes
 ;      ASUD     = array containing transaction date
 ;      ASU0     = transaction type where:
 ;                 2 = RECEIPTS
 ;                 3 = ISSUES
 ;                 7 = DIRECT ISSUES
 ;      ASU1     = transaction date
 ;      ASUPC    = piece designation in ^TMP global where totals are
 ;                 stored, the piece corresponds to the column on the
 ;                 report
 ;      ASUPCM   = piece in ^TMP global to put monthly totals (1-7)
 ;      ASUPCY   = piece in ^TMP global to put yearly todays (8-14)
 ;      ASUDT("DXTRACT") = array containing extract dates
 ;      ASUD("VAL")      = transaction amount
 ;
 N ASUPC,ASUPCM,ASUPCY
 S ASUPCY=ASU("TC",ASUD("TRANS"))+7
 S ASUPCM=0 S:$D(ASUDT("DXTRACT",ASU1)) ASUPCM=ASU("TC",ASUD("TRANS"))
 F ASUPC=ASUPCM,ASUPCY D
 . S $P(^XTMP("ASUR","R16",2,ASUD("AREA"),ASUD("STA"),ASUD("ACC"),0),U,ASUPC)=$P($G(^XTMP("ASUR","R16",2,ASUD("AREA"),ASUD("STA"),ASUD("ACC"),0)),U,ASUPC)+ASUD("VAL")
 . S $P(^XTMP("ASUR","R16",1,ASUD("AREA"),0),U,ASUPC)=$P($G(^XTMP("ASUR","R16",1,ASUD("AREA"),0)),U,ASUPC)+ASUD("VAL")
 . S $P(^XTMP("ASUR","R16",1,ASUD("AREA"),ASUD("STA"),0),U,ASUPC)=$P($G(^XTMP("ASUR","R16",1,ASUD("AREA"),ASUD("STA"),0)),U,ASUPC)+ASUD("VAL")
 . S $P(^XTMP("ASUR","R16",1,ASUD("AREA"),ASUD("STA"),ASUD("SST"),0),U,ASUPC)=$P($G(^XTMP("ASUR","R16",1,ASUD("AREA"),ASUD("STA"),ASUD("SST"),0)),U,ASUPC)+ASUD("VAL")
 . S $P(^XTMP("ASUR","R16",1,ASUD("AREA"),ASUD("STA"),ASUD("SST"),ASUD("SSA"),0),U,ASUPC)=$P($G(^XTMP("ASUR","R16",1,ASUD("AREA"),ASUD("STA"),ASUD("SST"),ASUD("SSA"),0)),U,ASUPC)+ASUD("VAL")
 . S $P(^XTMP("ASUR","R16",1,ASUD("AREA"),ASUD("STA"),ASUD("SST"),ASUD("SSA"),ASUD("ACC"),0),U,ASUPC)=$P($G(^XTMP("ASUR","R16",1,ASUD("AREA"),ASUD("STA"),ASUD("SST"),ASUD("SSA"),ASUD("ACC"),0)),U,ASUPC)+ASUD("VAL")
 Q
PRT ;----- PRINT THE DATA
 ;
 ;      ASUL         =  loop counter array
 ;      ASUPAGE      =  report page number
 ;      ASUOUT       =  '^' to escape controller
 ;      ASUDATA      =  temporary data storage
 ;      ASUD("ACC")  =  general ledger account number
 ;      ASUHDR       =  array containing report header segments
 ;
 N ASUL,ASUPAGE,ASUOUT,ASUHDR
 S ASUOUT=0
 I '$D(^XTMP("ASUR","R16")) W !!,"NO DATA FOR REPORT 16" Q
 ;
 S ASUHDR(1)="REPORT #16 STATION MONTHLY SUB-SUB-ACTIVITY REPORT"
 S ASUHDR(2)="AREA "_ASUD("AREA")
 S ASUHDR(3)="STAT "_ASUD("STA")
 S ASUHDR(4)="SUB  SUB  A"
 S ASUHDR(5)="STA  SUB  C"
 S ASUHDR(6)="CDE  ACT  C"
 ;
 D LOOPS
 Q
LOOPS ;----- LOOPS THROUGH ^XTMP("ASUR","R16") GLOBAL AND PRINTS
 ;      THE REPORT
 ;
1 ;----- LOOP THROUGH THE AREA SUBSCRIPT
 ;
 S ASUL(1)="" F  S ASUL(1)=$O(^XTMP("ASUR","R16",1,ASUL(1))) Q:ASUL(1)']""  D  Q:ASUOUT
 . Q:ASUL(1)=0
 . I $G(ASUPAGE)>1 D HDR16^ASUUTIL(ASUDT,ASUTYP,.ASUPAGE,.ASUHDR,.ASUOUT)
 . D 2 Q:ASUOUT
 Q
2 ;----- LOOP THROUGH THE STATION SUBSCRIPT
 ;
 N ASUDATA
 S ASUL(2)="" F  S ASUL(2)=$O(^XTMP("ASUR","R16",1,ASUL(1),ASUL(2))) Q:ASUL(2)']""  D  Q:ASUOUT
 . Q:ASUL(2)=0
 . I $G(ASUPAGE)>1 D HDR16^ASUUTIL(ASUDT,ASUTYP,.ASUPAGE,.ASUHDR,.ASUOUT)
 . D 3 Q:ASUOUT
 . D HDR16^ASUUTIL(ASUDT,ASUTYP,.ASUPAGE,.ASUHDR,.ASUOUT)
 . S ASUD("ACC")="" F  S ASUD("ACC")=$O(^XTMP("ASUR","R16",2,ASUL(1),ASUL(2),ASUD("ACC"))) Q:ASUD("ACC")']""  D  Q:ASUOUT
 . . I $Y>(IOSL-5) D HDR16^ASUUTIL(ASUDT,ASUTYP,.ASUPAGE,.ASUHDR,.ASUOUT) Q:ASUOUT
 . . W !,"ALL ACCT ",$P(ASUD("ACC"),".",2)
 . . S ASUDATA=^XTMP("ASUR","R16",2,ASUL(1),ASUL(2),ASUD("ACC"),0)
 . . D WRITE16^ASUUTIL(ASUDATA)
 . I $Y>(IOSL-5) D HDR16^ASUUTIL(ASUDT,ASUTYP,.ASUPAGE,.ASUHDR,.ASUOUT) Q:ASUOUT
 . W !,"STA TOTAL"
 . S ASUDATA=^XTMP("ASUR","R16",1,ASUL(1),ASUL(2),0)
 . D WRITE16^ASUUTIL(ASUDATA)
 Q
3 ;----- LOOP THROUGH THE SUB-STATION SUBSCRIPT
 ;
 S ASUL(3)="" F  S ASUL(3)=$O(^XTMP("ASUR","R16",1,ASUL(1),ASUL(2),ASUL(3))) Q:ASUL(3)']""  D  Q:ASUOUT
 . Q:ASUL(3)=0
 . D HDR16^ASUUTIL(ASUDT,ASUTYP,.ASUPAGE,.ASUHDR,.ASUOUT)
 . D 4 Q:ASUOUT
 Q
4 ;----- LOOP THROUGH THE SUB-SUB-ACTIVITY SUBSCRIPT
 ;
 S ASUL(4)="" F  S ASUL(4)=$O(^XTMP("ASUR","R16",1,ASUL(1),ASUL(2),ASUL(3),ASUL(4))) Q:ASUL(4)']""  D  Q:ASUOUT
 . Q:ASUL(4)=0
 . D 5 Q:ASUOUT
 Q
5 ;----- LOOP THROUGH THE GENERAL LEDGER ACCOUNT SUBSCRIPT
 ;
 N ASUDATA
 S ASUL(5)="" F  S ASUL(5)=$O(^XTMP("ASUR","R16",1,ASUL(1),ASUL(2),ASUL(3),ASUL(4),ASUL(5))) Q:ASUL(5)']""  D  Q:ASUOUT
 . Q:ASUL(5)=0
 . S ASUDATA=^XTMP("ASUR","R16",1,ASUL(1),ASUL(2),ASUL(3),ASUL(4),ASUL(5),0)
 . I $Y>(IOSL-5) D HDR16^ASUUTIL(ASUDT,ASUTYP,.ASUPAGE,.ASUHDR,.ASUOUT)
 . W !?1,$S(ASUL(3)="UNK":"",1:$P(ASUL(3)," ")),?6,$S(ASUL(4)="UNK":"",1:ASUL(4)),?10,$P(ASUL(5),".",2)
 . D WRITE16^ASUUTIL(ASUDATA)
 Q
QUIT ;----- CLEAN UP VARIABLES, CLOSE DEVICE, QUIT
 ;
 K ZTSAVE
 K ^XTMP("ASUR","R16")
 I $G(ASUK("PTRSEL"))]"" W @IOF Q
 D ^%ZISC
 Q
