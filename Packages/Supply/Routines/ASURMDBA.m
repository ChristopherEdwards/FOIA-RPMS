ASURMDBA ; IHS/ITSC/LMH - MANAGEMENT SUPPLY DATA BOOK REPORT A ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;;Y2K/OK AEF/2970324
 ;This routine produces the Management Supply Data Book Report A
 ;Records Processed into the Supply Accounting and Management System
 ;
 ;
EN ;EP -- MAIN ENTRY POINT (USER INTERACTIVE)      
 ;
 N ASUDT,ASUTYP
 D ^XBKVAR,HOME^%ZIS
 D SELXTRCT^ASUUTIL G QUIT:'$D(ASUDT)
 W !,*7,"THIS REPORT REQUIRES 132 COLUMNS!"
 S ZTSAVE("ASUDT")="",ZTSAVE("ASUTYP")=""
 D QUE^ASUUTIL("DQ^ASURMDBA",.ZTSAVE,"SAMS MGMT SUPPLY DATABOOK REPORT A")
 D QUIT
 Q
EN1(ASUDT,ASUTYP)  ;EP
 ;----- ENTRY POINT CALLED BY ^ASURMSTD (NON-USER INTERACTIVE)
 ;
DQ ;EP -- QUEUED JOB STARTS HERE
 ;
 ;      ASUDT  = report extract date or month
 ;      ASUTYP = type of report, I=individual, M=monthly
 ;
 D ^XBKVAR
 D:'$D(^XTMP("ASUR","RDBA")) GET
 D PRT,QUIT
 Q
GET ;EP ; GATHER DATA
 ;
 ;      Builds ^XTMP("ASUR","RDBA") global to sort and store
 ;      transaction counts
 ;
 ;      ASU      =  array containing beginning, ending fiscal dates
 ;      ASU1     =  extracted date in 'AX' crossreference
 ;      ASU2     =  internal file entry number
 ;      ASUD     =  array containing transaction data
 ;      ASUREV   =  array containing transaction reverse codes
 ;      ASUPC    =  which piece in the ^TMP global to put the count in
 ;
 N ASU,ASU1,ASU2,ASUD,ASUPC,ASUREV
 K ^XTMP("ASUR","RDBA")
 D FPP^ASUUTIL1(ASUDT)
 I ASUTYP="M" S ASUDT=$$LDOM^ASUUTIL1(ASUDT)
 D REV
 S ASU1=ASU("DT","BEG2")-1
 F  S ASU1=$O(^ASUH("AX",ASU1)) Q:'ASU1  Q:ASU1>ASUDT  D
 . S ASU2=0 F  S ASU2=$O(^ASUH("AX",ASU1,ASU2)) Q:'ASU2  D
 . . D DATA16^ASUUTIL(ASU2)
 . . S ASUPC=0
 . . I ASU1'<ASU("DT","BEG")&(ASU1'>ASU("DT","END")) S ASUPC=0
 . . I ASU1'<ASU("DT","BEG1")&(ASU1'>ASU("DT","END1")) S ASUPC=3
 . . I ASU1'<ASU("DT","BEG2")&(ASU1'>ASU("DT","END2")) S ASUPC=6
 . . I '$D(ASUREV(ASUD("TRANS"))),ASUD("STATUS")'="R" S ASUPC=ASUPC+1
 . . I $D(ASUREV(ASUD("TRANS"))),ASUD("STATUS")'="R" S ASUPC=ASUPC+2
 . . I ASUD("STATUS")="R" S ASUPC=ASUPC+3
 . . D SET
 Q
SET ;----- SETS COUNTS IN ^TMP GLOBAL
 ;
 S $P(^XTMP("ASUR","RDBA","IHS",ASUD("AREA"),ASUD("ACCNAM"),0),U,ASUPC)=$P($G(^XTMP("ASUR","RDBA","IHS",ASUD("AREA"),ASUD("ACCNAM"),0)),U,ASUPC)+1
 S $P(^XTMP("ASUR","RDBA","IHS",ASUD("AREA"),ASUD("ACCNAM"),ASUD("STA"),0),U,ASUPC)=$P($G(^XTMP("ASUR","RDBA","IHS",ASUD("AREA"),ASUD("ACCNAM"),ASUD("STA"),0)),U,ASUPC)+1
 Q
PRT ;----- PRINTS THE REPORT
 ;
 ;      ASUDATA  =  temporary data storage
 ;      ASUL     =  array used for loop counters
 ;      ASUOUT   =  '^' to escape controller
 ;      ASUPAGE  =  report page number
 ;
 N ASUL,ASUOUT,ASUPAGE
 I '$D(^XTMP("ASUR","RDBA")) W !!,"NO DATA FOR DATABOOK REPORT A" Q
 S ASUOUT=0
 D LOOPS
 Q
LOOPS ;----- LOOPS THROUGH THE ^TMP("ASU",$J,"ASURMDBA") GLOBAL AND PRINTS
 ;      THE REPORT
 ;
1 ;----- LOOP THROUGH THE AREA SUBSCRIPT
 ;
 S ASUL(1)="" F  S ASUL(1)=$O(^XTMP("ASUR","RDBA","IHS",ASUL(1))) Q:ASUL(1)']""  D  Q:ASUOUT
 . Q:ASUL(1)=0
 . D 2 Q:ASUOUT
 Q
2 ;----- LOOP THROUGH THE ACCOUNT SUBSCRIPT
 ;
 N ASUDATA
 S ASUL(2)="" F  S ASUL(2)=$O(^XTMP("ASUR","RDBA","IHS",ASUL(1),ASUL(2))) Q:ASUL(2)']""  D  Q:ASUOUT
 . Q:ASUL(2)=0
 . D HDR Q:ASUOUT
 . D 3 Q:ASUOUT
 . I $Y>(IOSL-5) D HDR Q:ASUOUT
 . S ASUDATA=^XTMP("ASUR","RDBA","IHS",ASUL(1),ASUL(2),0)
 . W !,"TOTAL"
 . D WRITE(ASUDATA)
 Q
3 ;----- LOOP THROUGH THE STATION SUBSCRIPT
 ;
 N ASUDATA
 S ASUL(3)="" F  S ASUL(3)=$O(^XTMP("ASUR","RDBA","IHS",ASUL(1),ASUL(2),ASUL(3))) Q:ASUL(3)']""  D  Q:ASUOUT
 . Q:ASUL(3)=0
 . I $Y>(IOSL-5) D HDR Q:ASUOUT
 . S ASUDATA=^XTMP("ASUR","RDBA","IHS",ASUL(1),ASUL(2),ASUL(3),0)
 . W !,$E(ASUL(3),1,20)
 . D WRITE(ASUDATA)
 Q
WRITE(X) ;----- WRITES DATA
 ;
 ;      X = contains the data to be written
 ;
 N ASUX
 W ?24,$J($P(X,U),8),?34,$J($P(X,U,2),8),?44,$J($P(X,U,3),8)
 S ASUX=$$PRCNT($P(X,U)+$P(X,U,2),$P(X,U,3))
 I +ASUX'=0 W ?54,$J(ASUX,4,1)
 W ?61,$J($P(X,U,4),8),?71,$J($P(X,U,5),8),?81,$J($P(X,U,6),8)
 S ASUX=$$PRCNT($P(X,U,4)+$P(X,U,5),$P(X,U,6))
 I +ASUX'=0 W ?91,$J(ASUX,4,1)
 W ?98,$J($P(X,U,7),8),?108,$J($P(X,U,8),8),?118,$J($P(X,U,9),8)
 S ASUX=$$PRCNT($P(X,U,7)+$P(X,U,8),$P(X,U,9))
 I +ASUX'=0 W ?128,$J(ASUX,4,1)
 W !
 Q
HDR ;----- WRITES REPORT HEADER
 ;
 N %,DIR,X,Y
 I $E(IOST)="C",$G(ASUPAGE) S DIR(0)="E" D ^DIR K DIR I 'Y S ASUOUT=1 Q
 S ASUPAGE=$G(ASUPAGE)+1
 W @IOF
 W "MANAGEMENT SUPPLY DATA BOOK FOR "
 S Y=ASUDT X ^DD("DD") W $P(Y," ")," ",$P(Y,",",2)
 W !,"AREA ",ASUL(1)
 W !!,"A. RECORDS PROCESSED INTO THE SUPPLY ACCOUNTING AND MANAGEMENT SYSTEM (SAMS)"
 W !?3,"Category: ",ASUL(2)
 W !!?29,"CURRENT FISCAL YEAR",?66,"PREVIOUS FISCAL YEAR",?103,"PREV-PREV FISCAL YEAR"
 W !?25,"Number   Number     Number      %",?62,"Number   Number     Number      %",?99,"Number   Number     Number      %"
 W !,"STATION",?25,"Regular  Reversal   Rejects   Rej",?62,"Regular  Reversal   Rejects   Rej",?99,"Regular  Reversal   Rejects   Rej"
 W !
 Q
REV ;----- SETS UP REVERSAL TRANSACTION CODE ARRAY
 ;
 ;      Returns AUSREV array containing SAMS reversal transaction codes
 ;
 K ASUREV
 F ASUREV="3J","3K","3M","3O","0K","0M","0N","0O","2K","2M","2N","2O","2P","3P","1K","1M","1N","1O" S ASUREV(ASUREV)=""
 Q
PRCNT(X,Y)         ;
 ;----- CALCULATES PERCENT OF REJECTS
 ;
 I +X=0 Q ""
 Q (Y/X)*100
 ;
QUIT ;CLEAN UP VARIABLES, CLOSE DEVICE, QUIT
 ;
 K ZTSAVE
 K ^XTMP("ASUR","RDBA")
 I $G(ASUK("PTRSEL"))]"" W @IOF Q
 D ^%ZISC
 Q
