ASURMDBH ; IHS/ITSC/LMH - MANAGEMENT SUPPLY DATABOOK REPORT H ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;;Y2K/OK/AEF/2970429
 ;This routine produces the Management Supply Databook Report H
 ;Receiving Documents and Line Items Received
 ;
 ;
EN ;EP -- MAIN ENTRY POINT (USER INTERACTIVE)
 ;
 N ASUDT,ASUTYP
 D ^XBKVAR,HOME^%ZIS
 D SELXTRCT^ASUUTIL G QUIT:'$D(ASUDT)
 W !,*7,"THIS REPORT REQUIRES 132 COLUMNS!"
 S ZTSAVE("ASUDT")="",ZTSAVE("ASUTYP")=""
 D QUE^ASUUTIL("DQ^ASURMDBH",.ZTSAVE,"SAMS DATABOOK REPORT H")
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
 D:'$D(^XTMP("ASUR","RDBH")) GET
 D PRT,QUIT
 Q
GET ;EP ; GATHER DATA
 ;
 ;      Builds ^XTMP("ASUR","RDBH") global to sort and total
 ;      documents and line items
 ;
 D SORT,COUNT
 Q
SORT ;----- SORTS THE DATA    
 ;
 ;      Sets sorted data into ^XTMP("ASUR","RDBH","A") global
 ;
 ;      ASU     = array containing beginning, ending fiscal dates
 ;      ASU0    = transaction type
 ;      ASU1    = extracted date in 'AX' crossreference
 ;      ASU2    = internal file entry number
 ;      ASUD    = array containing transaction data
 ;      ASUPC   = piece in ^TMP global to store the count in
 ;
 N ASU,ASU0,ASU1,ASU2,ASUD,ASUPC
 K ^XTMP("ASUR","RDBH")
 D FPP^ASUUTIL1(ASUDT)
 I ASUTYP="M" S ASUDT=$$LDOM^ASUUTIL1(ASUDT)
 S ASU1=ASU("DT","BEG2")-1
 F  S ASU1=$O(^ASUH("AX",ASU1)) Q:'ASU1  Q:ASU1>ASUDT  D
 . S ASU2=0 F  S ASU2=$O(^ASUH("AX",ASU1,ASU2)) Q:'ASU2  D
 . . S ASUD("TRANS")=$P($G(^ASUH(ASU2,1)),U),ASU0=$E(ASUD("TRANS")) S:ASU0=0 ASU0=7
 . . I ASU0'=3&(ASU0'=7) Q
 . . D DATA16^ASUUTIL(ASU2)
 . . S ASUPC=0
 . . I ASU1'<ASU("DT","BEG")&(ASU1'>ASU("DT","END")) S ASUPC=2
 . . I ASU1'<ASU("DT","BEG1")&(ASU1'>ASU("DT","END1")) S ASUPC=6
 . . I ASU1'<ASU("DT","BEG2")&(ASU1'>ASU("DT","END2")) S ASUPC=10
 . . I ASUPC,ASU0=7 S ASUPC=ASUPC+2
 . . D SET1
 Q
SET1 ;----- SORTS DATA IN ^TMP GLOBAL
 ;
 S ^XTMP("ASUR","RDBH","A","IHS",ASUD("AREA"),ASUD("ACCNAM"),ASUD("STA"),ASUPC,ASU2,0)=""
 S ^XTMP("ASUR","RDBH","A","IHS",ASUD("AREA"),ASUD("ACCNAM"),ASUD("STA"),ASUPC-1,ASUD("VOUCH"),0)=""
 Q
COUNT ;----- COUNTS THE LINE ITEMS AND DOCUMENTS
 ;
 ;      Sets counts into ^XTMP("ASUR","RDBH","B") global
 ;
 N ASUL
 S ASUL(1)="" F  S ASUL(1)=$O(^XTMP("ASUR","RDBH","A","IHS",ASUL(1))) Q:ASUL(1)']""  D
 . S ASUL(2)="" F  S ASUL(2)=$O(^XTMP("ASUR","RDBH","A","IHS",ASUL(1),ASUL(2))) Q:ASUL(2)']""  D
 . . S ASUL(3)="" F  S ASUL(3)=$O(^XTMP("ASUR","RDBH","A","IHS",ASUL(1),ASUL(2),ASUL(3))) Q:ASUL(3)']""  D
 . . . S ASUL(4)="" F  S ASUL(4)=$O(^XTMP("ASUR","RDBH","A","IHS",ASUL(1),ASUL(2),ASUL(3),ASUL(4))) Q:ASUL(4)']""  D
 . . . . S ASUL(5)="" F  S ASUL(5)=$O(^XTMP("ASUR","RDBH","A","IHS",ASUL(1),ASUL(2),ASUL(3),ASUL(4),ASUL(5))) Q:ASUL(5)']""  D
 . . . . . D SET2
 Q
SET2 ;----- SETS COUNTS IN ^TMP GLOBAL
 ;
 S $P(^XTMP("ASUR","RDBH","B","IHS",ASUL(1),ASUL(2),0),U,ASUL(4))=$P($G(^XTMP("ASUR","RDBH","B","IHS",ASUL(1),ASUL(2),0)),U,ASUL(4))+1
 S $P(^XTMP("ASUR","RDBH","B","IHS",ASUL(1),ASUL(2),ASUL(3),0),U,ASUL(4))=$P($G(^XTMP("ASUR","RDBH","B","IHS",ASUL(1),ASUL(2),ASUL(3),0)),U,ASUL(4))+1
 Q
PRT ;----- PRINTS THE DATA
 ;
 ;      ASUDATA = temporary data storage
 ;      ASUL    = array used for loop counters
 ;      ASUOUT  = '^' to escape controller
 ;      ASUPAGE = report page number
 ;
 N ASUL,ASUOUT,ASUPAGE
 I '$D(^XTMP("ASUR","RDBH","B")) W !!,"NO DATA FOR DATABOOK REPORT H" Q
 S ASUOUT=0
 D LOOPS
 Q
LOOPS ;----- LOOPS THROUGH THE ^XTMP("ASUR","RDBH","B") GLOBAL AND PRINTS
 ;      THE REPORT
 ;
1 ;----- LOOP THROUGH THE AREA SUBSCRIPT        
 ;
 S ASUL(1)="" F  S ASUL(1)=$O(^XTMP("ASUR","RDBH","B","IHS",ASUL(1))) Q:ASUL(1)']""  D 2 Q:ASUOUT
 Q
2 ;----- LOOP THROUGH THE ACCOUNT SUBSCRIPT
 ;
 N ASUDATA
 S ASUL(2)="" F  S ASUL(2)=$O(^XTMP("ASUR","RDBH","B","IHS",ASUL(1),ASUL(2))) Q:ASUL(2)']""  D  Q:ASUOUT
 . D HDR(ASUL(1),ASUL(2)) Q:ASUOUT
 . D 3 Q:ASUOUT
 . I $Y>(IOSL-5) D HDR(ASUL(1),ASUL(2))
 . Q:ASUOUT
 . S ASUDATA=^XTMP("ASUR","RDBH","B","IHS",ASUL(1),ASUL(2),0)
 . W !!,"TOTAL"
 . D WRITE(ASUDATA)
 Q
3 ;----- LOOP THROUGH THE STATION SUBSCRIPT
 ;
 N ASUDATA
 S ASUL(3)="" F  S ASUL(3)=$O(^XTMP("ASUR","RDBH","B","IHS",ASUL(1),ASUL(2),ASUL(3))) Q:ASUL(3)']""  D  Q:ASUOUT
 . Q:ASUL(3)=0
 . I $Y>(IOSL-5) D HDR(ASUL(1),ASUL(2))
 . Q:ASUOUT
 . S ASUDATA=^XTMP("ASUR","RDBH","B","IHS",ASUL(1),ASUL(2),ASUL(3),0)
 . W !!,ASUL(3)
 . D WRITE(ASUDATA)
 Q
WRITE(X) ;----- WRITES DATA
 ;
 I $P(X,U)'="" W ?23,$J($P(X,U),5)
 I $P(X,U,2)'="" W ?29,$J($P(X,U,2),5)
 I +$P(X,U)'=0 W ?36,$J(($P(X,U,2)/$P(X,U)),4,1)
 I $P(X,U,3)'="" W ?41,$J($P(X,U,3),5)
 I $P(X,U,4)'="" W ?47,$J($P(X,U,4),5)
 I +$P(X,U,3)'=0 W ?54,$J(($P(X,U,4)/$P(X,U,3)),4,1)
 I $P(X,U,5)'="" W ?60,$J($P(X,U,5),5)
 I $P(X,U,6)'="" W ?66,$J($P(X,U,6),5)
 I +$P(X,U,5)'=0 W ?73,$J(($P(X,U,6)/$P(X,U,5)),4,1)
 I $P(X,U,7)'="" W ?78,$J($P(X,U,7),5)
 I $P(X,U,8)'="" W ?84,$J($P(X,U,8),5)
 I +$P(X,U,7)'=0 W ?91,$J(($P(X,U,8)/$P(X,U,7)),4,1)
 I $P(X,U,9)'="" W ?97,$J($P(X,U,9),5)
 I $P(X,U,10)'="" W ?103,$J($P(X,U,10),5)
 I +$P(X,U,9)'=0 W ?110,$J(($P(X,U,10)/$P(X,U,9)),4,1)
 I $P(X,U,11)'="" W ?115,$J($P(X,U,11),5)
 I $P(X,U,12)'="" W ?121,$J($P(X,U,12),5)
 I +$P(X,U,11)'=0 W ?128,$J(($P(X,U,12)/$P(X,U,11)),4,1)
 Q
HDR(X1,X2)         ;
 ;----- WRITES HEADER
 ;
 ;      X1  =  area
 ;      X2  =  account
 ;
 N %,DIR,X,Y
 I $E(IOST)="C",$G(ASUPAGE) S DIR(0)="E" D ^DIR K DIR I 'Y S ASUOUT=1 Q
 S ASUPAGE=$G(ASUPAGE)+1
 W @IOF
 W "MANAGEMENT SUPPLY DATA BOOK for "
 S Y=ASUDT X ^DD("DD") W $P(Y," ")," ",$P(Y,",",2)
 W ?116,"PAGE ",$J(ASUPAGE,6)
 W !,"AREA ",X1
 W !!,"H. RECEIVING DOCUMENTS and LINE ITEMS RECEIVED"
 W !?3,"Category: ",X2
 W !!,?31,"CURRENT FISCAL YEAR",?68,"PREVIOUS FISCAL YEAR",?104,"PREV-PREV FISCAL YEAR"
 W !,?25,"Stores Stock",?43,"Direct Issue",?62,"Stores Stock",?80,"Direct Issue",?99,"Stores Stock",?117,"Direct Issue"
 W !,"STATION",?23,"# DOC",?30,"# LI",?37,"AVG",?41,"# DOC",?48,"# LI",?55,"AVG",?60,"# DOC",?67,"# LI",?74,"AVG",?78,"# DOC",?85,"# LI",?92,"AVG",?97,"# DOC",?104,"# LI",?111,"AVG",?115,"# DOC",?122,"# LI",?129,"AVG"
 Q
QUIT ;----- CLEAN UP VARIABLES, CLOSE DEVICE, QUIT
 ;
 K ZTSAVE
 K ^XTMP("ASUR","RDBH")
 I $G(ASUK("PTRSEL"))]"" W @IOF Q
 D ^%ZISC
 Q
