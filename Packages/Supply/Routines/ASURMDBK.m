ASURMDBK ; IHS/ITSC/LMH - MANAGEMENT SUPPLY DATA BOOK REPORTS K SERIES ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;;Y2K/OK/AEF/2970411
 ;This routine produces the Management Supply Data Book Reports K1-K7
 ;
EN ;EP -- MAIN ENTRY POINT (USER INTERACTIVE)
 ;
 N ASUDT,ASURPT,ASUTYP
 D ^XBKVAR,HOME^%ZIS
 D K^ASURMDBK G QUIT:$G(ASURPT)']""
 D SELXTRCT^ASUUTIL G QUIT:'$D(ASUDT)
 W !,*7,"THIS REPORT REQUIRES 132 COLUMNS!"
 S (ZTSAVE("ASUDT"),ZTSAVE("ASUTYP"),ZTSAVE("ASURPT"))=""
 D QUE^ASUUTIL("DQ^ASURMDBK",.ZTSAVE,"SAMS MGMT SUPPLY DATABOOK REPORT K")
 D QUIT
 Q
EN1(ASUDT,ASUTYP,ASURPT)     ;EP
 ;----- ENTRY POINT CALLED BY ^ASURMSTD (NON-USER INTERACTIVE)
 ;
DQ ;EP -- QUEUED JOB STARTS HERE
 ;
 ;      ASUDT  = report extract date or month
 ;      ASUTYP = type of report, I=individual, M=monthly
 ;      ASURPT = which reports, i.e., K1, K2, K3, K4, K5, K6, K7
 ;
 D ^XBKVAR
 D:'$D(^XTMP("ASUR","RDBK")) GET
 D PRT,QUIT
 Q
GET ;EP ; GATHER DATA
 ;
 ;      Builds ^XTMP("ASUR","RDBK") global to sort and store
 ;      transaction amounts
 ;
 ;      ASU     =  array containing beginning, ending fiscal dates
 ;      ASU0    =  transaction type
 ;      ASU1    =  extracted date in 'AX' crossreference
 ;      ASU2    =  internal file entry number
 ;      ASUD    =  array containing transaction data
 ;      ASUPC   =  the piece in ^TMP global to put the total in
 ;
 N ASU,ASU0,ASU1,ASU2,ASUD,ASUPC
 K ^XTMP("ASUR","RDBK")
 D FPP^ASUUTIL1(ASUDT)
 I ASUTYP="M" S ASUDT=$$LDOM^ASUUTIL1(ASUDT)
 S ASU1=ASU("DT","BEG2")-1
 F  S ASU1=$O(^ASUH("AX",ASU1)) Q:'ASU1  Q:ASU1>ASUDT  D
 . S ASU2=0 F  S ASU2=$O(^ASUH("AX",ASU1,ASU2)) Q:'ASU2  D
 . . S ASUD("TRANS")=$P($G(^ASUH(ASU2,1)),U),ASU0=$E(ASUD("TRANS")) S:ASU0=0 ASU0=7
 . . I ASU0'=3&(ASU0'=7) Q
 . . D DATA16^ASUUTIL(ASU2)
 . . S ASUPC=0
 . . I ASU1'<ASU("DT","BEG")&(ASU1'>ASU("DT","END")) S ASUPC=0
 . . I ASU1'<ASU("DT","BEG1")&(ASU1'>ASU("DT","END1")) S ASUPC=2
 . . I ASU1'<ASU("DT","BEG2")&(ASU1'>ASU("DT","END2")) S ASUPC=4
 . . I ASU0=3 S ASUPC=ASUPC+1
 . . I ASU0=7 S ASUPC=ASUPC+2
 . . S ASUD("ACC")=+$P(ASUD("ACC"),".",2)
 . . D SET
 Q
SET ;----- SETS TOTALS IN ^TMP GLOBAL
 ;
 S $P(^XTMP("ASUR","RDBK","IHS",ASUD("AREA"),ASUD("ACC"),0),U,ASUPC)=$P($G(^XTMP("ASUR","RDBK","IHS",ASUD("AREA"),ASUD("ACC"),0)),U,ASUPC)+ASUD("VAL")
 S $P(^XTMP("ASUR","RDBK","IHS",ASUD("AREA"),999,0),U,ASUPC)=$P($G(^XTMP("ASUR","RDBK","IHS",ASUD("AREA"),999,0)),U,ASUPC)+ASUD("VAL")
 S $P(^XTMP("ASUR","RDBK","IHS",ASUD("AREA"),ASUD("ACC"),ASUD("STA"),0),U,ASUPC)=$P($G(^XTMP("ASUR","RDBK","IHS",ASUD("AREA"),ASUD("ACC"),ASUD("STA"),0)),U,ASUPC)+ASUD("VAL")
 S $P(^XTMP("ASUR","RDBK","IHS",ASUD("AREA"),999,ASUD("STA"),0),U,ASUPC)=$P($G(^XTMP("ASUR","RDBK","IHS",ASUD("AREA"),999,ASUD("STA"),0)),U,ASUPC)+ASUD("VAL")
 Q
PRT ;----- PRINTS THE DATA
 ;
 ;      ASUDATA  =  temporary data storage
 ;      ASUL     =  array used for loop counters
 ;      ASUOUT   =  '^' to escape controller
 ;      ASUPAGE  =  report page number
 ;
 N ASUL,ASULIST,ASUOUT,ASUPAGE
 S ASUOUT=0
 D K1,LOOPS
 Q
LOOPS ;----- LOOPS THROUGH THE ^XTMP("ASUR","RDBK") GLOBAL AND PRINTS
 ;      THE REPORT
 ;
1 ;----- LOOP THROUGH THE AREA SUBSCRIPT
 ;
 S ASUL(1)="" F  S ASUL(1)=$O(^XTMP("ASUR","RDBK","IHS",ASUL(1))) Q:ASUL(1)']""  D  Q:ASUOUT
 . Q:ASUL(1)=0
 . D 2
 Q
2 ;----- LOOP THROUGH THE REPORT NUMBER SUBSCRIPT
 ;
 N ASUDATA,I
 F I=1:1:$L(ASURPT,",") S ASUL(2)=$P(ASURPT,",",I) D  Q:ASUOUT
 . D HDR Q:ASUOUT
 . I '$D(^XTMP("ASUR","RDBK","IHS",ASUL(1),ASUL(2))) D  Q
 . . W !!,"NO DATA FOR DATA BOOK REPORT ",ASULIST(2,ASUL(2))
 . D 3 Q:ASUOUT
 . I $Y>(IOSL-5) D HDR Q:ASUOUT
 . W !!,"TOTAL"
 . S ASUDATA=^XTMP("ASUR","RDBK","IHS",ASUL(1),ASUL(2),0)
 . D WRITE(ASUDATA)
 Q
3 ;----- LOOP THROUGH THE STATION SUBSCRIPT
 ;
 N ASUDATA
 S ASUL(3)="" F  S ASUL(3)=$O(^XTMP("ASUR","RDBK","IHS",ASUL(1),ASUL(2),ASUL(3))) Q:ASUL(3)']""  D  Q:ASUOUT
 . Q:ASUL(3)=0
 . I $Y>(IOSL-5) D HDR Q:ASUOUT
 . S ASUDATA=^XTMP("ASUR","RDBK","IHS",ASUL(1),ASUL(2),ASUL(3),0)
 . W !!,$E(ASUL(3),1,15)
 . D WRITE(ASUDATA)
 Q
WRITE(X) ;
 ;----- WRITES REPORT DATA COLUMNS
 ;
 W ?18,$J($P(X,U),10,2),?30,$J($$DIV($P(X,U),$P(X,U)+$P(X,U,2)),5,1)
 W ?37,$J($P(X,U,2),10,2),?49,$J($$DIV($P(X,U,2),$P(X,U)+$P(X,U,2)),5,1)
 W ?57,$J($P(X,U,3),10,2),?69,$J($$DIV($P(X,U,3),$P(X,U,3)+$P(X,U,4)),5,1)
 W ?76,$J($P(X,U,4),10,2),?88,$J($$DIV($P(X,U,4),$P(X,U,3)+$P(X,U,4)),5,1)
 W ?96,$J($P(X,U,5),10,2),?108,$J($$DIV($P(X,U,5),$P(X,U,5)+$P(X,U,6)),5,1)
 W ?115,$J($P(X,U,6),10,2),?127,$J($$DIV($P(X,U,6),$P(X,U,5)+$P(X,U,6)),5,1)
 Q
HDR ;----- WRITES REPORT HEADER
 ;
 N %,DIR,X,Y
 I $E(IOST)="C",$G(ASUPAGE) S DIR(0)="E" D ^DIR K DIR I 'Y S ASUOUT=1 Q
 S ASUPAGE=$G(ASUPAGE)+1
 W @IOF
 W "MANAGEMENT SUPPLY DATA BOOK for "
 S Y=ASUDT X ^DD("DD") W $P(Y," ")," ",$P(Y,",",2)
 W !,"AREA ",ASUL(1)
 W !!,ASULIST(2,ASUL(2))," - ","DIRECT ISSUE VALUE versus STOCK ISSUE VALUE"
 W !!?26,"CURRENT FISCAL YEAR",?65,"PREVIOUS FISCAL YEAR",?103,"PREV-PREV FISCAL YEAR"
 W !?18,"DIRECT ISS",?34,"%",?37,"STOCK ISSU",?53,"%",?57,"DIRECT ISS",?73,"%",?76,"STOCK ISSU",?92,"%",?96,"DIRECT ISS",?112,"%",?115,"STOCK ISSU",?131,"%"
 W !,"STATION",?23,"VALUE",?31,"D.I.",?42,"VALUE",?50,"S.I.",?62,"VALUE",?70,"D.I.",?81,"VALUE",?89,"S.I.",?101,"VALUE",?109,"D.I.",?120,"VALUE",?128,"S.I."
 Q
DIV(X1,X2)         ;
 ;----- COMPUTES PERCENT - EXTRINSIC FUNCTION
 ;      call by $$DIV(VALUE1,VALUE2)
 ;
 ;      Returns percentage of first number divided by second number
 ;
 I +X2=0 Q 0
 Q (X1/X2)*100
 ;
K ;----- SELECT THE K REPORTS TO PRINT
 ;
 ;      Allows user to select which K reports to print
 ;
 ;      Returns ASURPT = string containing which reports to print
 ;
 ;      ASULIST  = array containing list of selectable reports
 ;      ASUDATA  = temporary data storage
 ;      ASUCNT   = counter
 ;
 N ASULIST,I
 D K1,K2
 I ASURPT="A" S ASURPT="",I=0 F  S I=$O(ASULIST(2,I)) Q:'I  S ASURPT=ASURPT_$S(ASURPT]"":",",1:"")_I
 Q
K1 ;----- BUILDS SELECTION ARRAYS
 ;
 N ASUDATA,I,J
 F I=1:1 S ASUDATA=$T(KLIST+I) Q:ASUDATA["$$END"  D
 . F J=3:1:5 D
 . . Q:$P(ASUDATA,";",5)']""
 . . S:$P(ASUDATA,";",J)]"" ASULIST(1,$P(ASUDATA,";",J))=$P(ASUDATA,";",5),ASULIST(2,$P(ASUDATA,";",5))=$P(ASUDATA,";",3)_"  "_$P(ASUDATA,";",4),ASULIST(1,$P(ASUDATA,";",3)_"  "_$P(ASUDATA,";",4))=$P(ASUDATA,";",5)
 Q
 ;
K2 ;----- ISSUE PROMPTS TO CHOOSE WHICH REPORT(S)
 ;
 N ASUCNT,ASUX,ASUZ,DIR,I,J,X,Y
 W !,"DIRECT ISSUE VALUE versus STOCK ISSUE VALUE Reports:",!
 S I="" F  S I=$O(ASULIST(2,I)) Q:I']""  W !?3,I,?8,ASULIST(2,I)
 S DIR(0)="FA"
 S DIR("A")="Which report(s): "
 S DIR("?")="Enter '??' for more help"
 S DIR("??")="^D KHELP^ASURMDBK"
 D ^DIR
 S ASURPT=Y
 I ASURPT']""!(ASURPT["^") S ASURPT="" Q
 I $L(ASURPT,",")=1&(ASURPT'["-") D  G:ASURPT']"" K2 W "  ",$P(ASULIST(2,ASURPT),"  ",2) Q
 . S ASURPT=$P(ASURPT,",")
 . I $D(ASULIST(1,ASURPT)) S ASURPT=ASULIST(1,ASURPT) Q
 . K ASULIST(3),ASULIST(4)
 . S ASUX="" F  S ASUX=$O(ASULIST(1,ASUX)) Q:ASUX']""  D
 . . I $E(ASUX,1,$L(ASURPT))=ASURPT S ASULIST(3,ASULIST(1,ASUX))=""
 . S ASUCNT=0,ASUX="" F  S ASUX=$O(ASULIST(3,ASUX)) Q:ASUX']""  D
 . . S ASUCNT=ASUCNT+1,ASULIST(4,ASUCNT)=ASULIST(2,ASUX)
 . I '$D(ASULIST(4)) W *7," ??" S ASURPT="" Q
 . I ASUCNT=1 S ASURPT=ASULIST(4,ASUCNT),ASURPT=ASULIST(1,ASURPT) Q
 . K ASURPT
 . W !
 . S (ASUCNT,I)=0 F  S I=$O(ASULIST(4,I)) Q:'I  S ASUCNT=ASUCNT+1 W !?3,I_"  "_ASULIST(4,I)
 . W ! S DIR(0)="NA^1:"_ASUCNT D ^DIR K DIR S ASURPT=Y
 . I 'ASURPT S ASURPT="" Q
 . S ASURPT=ASULIST(4,ASURPT),ASURPT=ASULIST(1,ASURPT)
 S ASUZ=""
 F I=1:1:$L(ASURPT,",") S ASUX=$P(ASURPT,",",I) D
 . Q:ASUX']""
 . I ASUX["-" D
 . . I ASUX["A" S ASUZ=ASUZ_$S(ASUZ]"":",",1:"")_"A" Q
 . . F J=$P(ASUX,"-"):1:$P(ASUX,"-",2) D
 . . . I $D(ASULIST(2,J)) S ASUZ=ASUZ_$S(ASUZ]"":",",1:"")_J
 . I $D(ASULIST(2,ASUX)) S ASUZ=ASUZ_$S(ASUZ]"":",",1:"")_ASUX
 S ASURPT=ASUZ
 I ASURPT["A" S ASURPT="A" Q
 I ASURPT']"" W *7," ??" G K2
 Q
KLIST ;----- K REPORT LIST
 ;;K1;DRUGS;1
 ;;K2;MEDICAL/DENTAL/XRAY;2
 ;;K3;SUBSISTENCE;3
 ;;K4;LABORATORY;4
 ;;K5;OFFICE/ADMINISTRATIVE;5
 ;;K6;OTHER SUPPLIES;9
 ;;K7;TOTAL ALL CATEGORIES;999
 ;;ALL;ALL OF THE ABOVE;A
 ;;$$END
 Q
KHELP ;----- HELP FOR REPORT SELECTION
 ;
 W !!?5,"Select ONE report by number or name, or"
 W !?5,"enter report NUMBERS separated by commas, or select a range of"
 W !?5,"NUMBERS:  for example '1,2,5', or '1-5', or '1,2,5-7',"
 W !?5,"or select 'A' for All."
 W !?5,"DO NOT mix numbers and names.",!
 Q
QUIT ;----- KILL VARIABLES, CLOSE DEVICE, QUIT
 ;
 K ZTSAVE
 K ^XTMP("ASUR","RDBK")
 I $G(ASUK("PTRSEL"))]"" W @IOF Q
 D ^%ZISC
 Q
