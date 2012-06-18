BLRLUAC2 ;  IHS/OIT/MKK - IHS LRUPAC 2, reports ; [ 05/15/11  7:50 AM ]
 ;;5.2;IHS LABORATORY;**1030**;NOV 01, 1997
 ;;
 ;; Emulates the Lab accession and test counts Report, Part 2
 ;;
EP ; EP - Menu of Reports
 NEW LAB60IEN,L60DESC,LOOPER,SPECTYPE,SPECNAME
 NEW HEADER,LINES,MAXLINES,PG,QFLG,HEDONE
 NEW LRLDT,LRSDT,SELRAAAB,XTMPNODE
 NEW DIRTRICK,ENDMSG
 NEW BLRMMENU,BLRVERN
 NEW DATETIME
 ;
 S DATETIME=-1
 F  Q:DATETIME=0  D
 . Q:$$GTIMEDT<1
 . ;
 . D OUTINITV               ; Initialize MENU variables
 . D MENUDRFM^BLRGMENU("Lab accession and test counts","Report Selection")   ; Main Menu driver
 . K BLRMMENU
 ;
 Q
 ;
OUTINITV ; EP -- Initialization of variables
 S BLRVERN=$P($P($T(+1),";")," ")
 D ADDTMENU^BLRGMENU("F61REPT^BLRLUAC6","Topography File Counts")
 D ADDTMENU^BLRGMENU("F6160RPT^BLRLUAC4","Topography File & Laboratory Tests Counts")
 D ADDTMENU^BLRGMENU("F60SREPT^BLRLUAC5","Laboratory Test Counts")
 D ADDTMENU^BLRGMENU("F44REPT^BLRLUAC5","Location File Counts")
 D ADDTMENU^BLRGMENU("F4460RPT^BLRLUAC3","Location File & Laboratory Tests Counts")
 D ADDTMENU^BLRGMENU("FILE4RPT^BLRLUAC7","Institution File Counts")
 D ADDTMENU^BLRGMENU("F460REPT^BLRLUAC7","Institution File & Laboratory Tests Counts")
 D ADDTMENU^BLRGMENU("REPTERRC^BLRLUAC8","Compilation Errors")
 ;
 I $G(^VA(200,DUZ,0))'["KRING,MI" Q
 D ADDTMENU^BLRGMENU("BLRRTNS^BLRLUAC2","BLR Routines That Emulate LRUPAC Routines")
 Q
 ;
GTIMEDT() ; EP - Set the DATETIME variable
 NEW ARR,CNT,COL,DASHER,DTT,EXTDTT,LRAADESC,OUTARRAY
 NEW SELLRAA,SELSTR,SORTVAR,START,STOP,STR,VARIOUS,WIDE,WOT
 ;
 D ^XBFMK
 S (DTT,CNT,COL,WIDE)=0,ARR=1,SELSTR=""
 D SETARRAY
 ;
 D OUTHEAD
 ;
 I $D(WOT)<1 D  Q 0
 . D HEADERDT^BLRGMENU
 . W !,?4,"No Compiled Data exists.",!
 . D PRESSKEY^BLRGMENU(9)
 . S DATETIME=0
 ;
 S DATETIME=-1
 F  Q:DATETIME>-1  D
 . D HEADERDT^BLRGMENU
 . D ^XBFMK
 . S DIR(0)=SELSTR
 . S DIR("A")="Enter Response (1-"_$O(WOT(""),-1)_")"
 . S ARR=0,CNT=5
 . F  S ARR=$O(VARIOUS(ARR))  Q:ARR=""  D
 .. S DIR("L",CNT)=$G(VARIOUS(ARR))
 .. S CNT=CNT+1
 . S DIR("L",1)="Select one of the Date/Time Compilations below:"
 . S DIR("L",2)=""
 . S DIR("L",3)="            Compiled          Acc Area                Begin Date     End Date"
 . S DIR("L",4)="         -------------------  "_DASHER_"----------     ----------"
 . S DIR("L")=""
 . D ^DIR
 . ;
 . I +$G(DIRUT) S DATETIME=0  Q
 . ;
 . S DATETIME=+$G(WOT(+$G(Y)))
 ;
 I DATETIME<1 Q 0
 ;
 Q 1
 ;
SETARRAY ; EP -- Setup selection array
 F  S DTT=$O(^BLRLUPAC(DTT))  Q:DTT<1  D
 . Q:$D(^BLRLUPAC(DTT,"COMPILED"))<1     ; If no data on COMPILED node, still compiling -- skip.
 . ;
 . S EXTDTT=$$UP^XLFSTR($$FMTE^XLFDT(DTT,"5MPZ"))
 . S EXTDTT=$P(EXTDTT," ")_$J($P(EXTDTT," ",2,3),9)
 . ;
 . S SORTVAR=$O(^BLRLUPAC(DTT,"COMPILED"))
 . S STR=$G(^BLRLUPAC(DTT,SORTVAR))
 . S SELLRAA=$P(STR,"^")
 . ;
 . D FIND^DIC(68,,,,SELLRAA,,,,,"OUTARRAY")
 . S LRAADESC=SELLRAA_" "_$G(OUTARRAY("DILIST",1,1))
 . I $L(LRAADESC)>WIDE S WIDE=$L(LRAADESC)
 . ;
 . S START=$$FMTE^XLFDT($P(STR,"^",2),"5DZ")
 . S STOP=$$FMTE^XLFDT($P(STR,"^",3),"5DZ")
 . ;
 . S CNT=CNT+1
 . S COL=COL+1
 . ;
 . I CNT>1 S SELSTR=SELSTR_";"_CNT_":"
 . I CNT<2 S SELSTR="SO^"_CNT_":"
 . ;
 . S ARR=ARR+1
 . S STR=$J("",1)_$$LJ^XLFSTR(LRAADESC,24)_$$LJ^XLFSTR(START,15)_STOP
 . S VARIOUS(ARR)=$J("",5)_$J(CNT,2)_") "_$$LJ^XLFSTR(EXTDTT,20)_STR
 . S WOT(CNT)=DTT
 . ;
 ;
 ; Dashes for widest Accession description
 S DASHER=$$LJ^XLFSTR($TR($J("",WIDE)," ","-"),24)
 Q
 ;
OUTHEAD ; EP -- Reset HEADER array & Display
 K HEADER
 S HEADER(1)="Lab Accession and Test Counts"
 S HEADER(2)="Report Selection"
 ;
 Q
 ;
ENDLOOP ; EP -- User ENDs LOOP
 S:+$G(DIRUT) ENDMSG="No Selection or FileMan Exit."
 S:+$G(Y)<0 ENDMSG="Invalid Selection."
 D PROGEND(ENDMSG)
 S LOOPER="STOP"
 Q
 ;
BADJUJU ; EP -- Should never get here, but, if a user does, it's BAD ... VERY BAD.
 D PROGEND("EXTREMELY Invalid Input.")   ; Distinctive message.
 S LOOPER="STOP"
 Q
 ;
GETXTMPV(SORT,SELRAAB,LRSDT,LRLDT,BADMSG) ; EP -- Get data from ^BLRLUPAC( & set Variables
 S STR=$G(^BLRLUPAC(DATETIME,SORT))
 S SELRAAAB=$P(STR,"^")
 S LRSDT=+$P(STR,"^",2)
 S LRLDT=+$P(STR,"^",3)
 ;
 I $L(SELRAAAB)<1!(LRSDT<1)!(LRLDT<1) D  Q "Q"
 . I $L($G(BADMSG))>0 D   ; If BADMSG string exists
 .. W !!,?4,BADMSG,!
 .. D PRESSKEY^BLRGMENU(9)
 ;
 Q "OK"
 ;
TOTALS(TOTAL) ; EP
 W ?64,$TR($J("",11)," ","-")
 W !
 W ?14,"TOTALS"
 W ?64,$J($FN(+$G(TOTAL),","),11)
 W !
 Q
 ;
HEADONE(HEDONE) ; EP 
 D HEADERDT^BLRGMENU
 D ^XBFMK
 S DIR("A")="One Header Line ONLY"
 S DIR("B")="NO"
 S DIR(0)="YO"
 D ^DIR
 S HEDONE=$S(+$G(Y)=1:"YES",1:"NO")
 ;
 Q
 ;
HEADONE2(HEDONE) ; EP -- Don't put header before asking question
 W !
 D ^XBFMK
 S DIR("A")="One Header Line ONLY"
 S DIR("B")="NO"
 S DIR(0)="YO"
 D ^DIR
 S HEDONE=$S(+$G(Y)=1:"YES",1:"NO")
 ;
 Q
 ;
PROGEND(MSG) ; EP -- Routine Ends 
 W !,?4,MSG,"  Routine Ends.",!
 D PRESSKEY^BLRGMENU(9)
 D V^LRU
 Q
 ;
BLRRTNS ; EP - List ALL Routines that make up the BLR version of the LRUPAC series
 NEW BLRVERN,BLRVERN2,CNT,HEADER,WOTRTNS
 NEW DATETIME,RTN,RTNDESC,RTNLINES,RTNPATCH,RTNSIZE
 ;
 D BLRRTNSI
 ;
 D BLRRTNSR
 Q
 ;
BLRRTNSI ; EP - Initialization
 S BLRVERN=$TR($P($T(+1),";")," ")
 S BLRVERN2="BLRRTNS"
 ;
 S HEADER(1)="IHS Laboratory"
 S HEADER(2)="IHS Version of LRUPAC Series"
 S HEADER(3)=" "
 ;
 S $E(HEADER(4),11)=$TR($$CJ^XLFSTR("@Last@Edit@",14)," @","= ")
 S $E(HEADER(4),27)="%ZOSF"
 S $E(HEADER(4),35)="#"
 ;
 S HEADER(5)="Routine"
 S $E(HEADER(5),13)="Date"
 S $E(HEADER(5),20)="Time"
 S $E(HEADER(5),28)="Size"
 S $E(HEADER(5),34)="Lns"
 S $E(HEADER(5),38)="Ptch"
 S $E(HEADER(5),44)="Line 1 Description"
 ;
 S CNT=0
 Q
 ;
BLRRTNSR ; EP - Report
 D HEADERDT^BLRGMENU
 ;
 S RTN="BLRLUAC"
 F  S RTN=$O(^ROUTINE(RTN))  Q:RTN=""!($E(RTN,1,7)'="BLRLUAC")  D
 . D BLRRTNSL(RTN)
 ;
 W !,?4,"Number of routines = ",CNT,!
 D PRESSKEY^BLRGMENU(10)
 Q
 ;
BLRRTNSL(RTN) ; EP - Report
 D BLRRTNSB(RTN)
 ;
 W $E(RTN,1,9)
 W ?10,$TR($$HTE^XLFDT(DATETIME,"2MZ"),"@"," ")
 W ?25,$J($FN(RTNSIZE,","),6)
 W ?32,$J(RTNLINES,4)
 W ?37,RTNPATCH
 W ?43,$E(RTNDESC,1,(IOM-43))
 W !
 S CNT=CNT+1
 Q
 ;
BLRRTNSB(RTN) ; EP - Breakout Data
 S DATETIME=$G(^ROUTINE(RTN,0))
 D JUSTSIZE(RTN,.RTNSIZE)
 S RTNLINES=+$G(^ROUTINE(RTN,0,0))
 ;
 ; Routine Description
 S RTNDESC=$P($G(^ROUTINE(RTN,0,1)),";",2)
 I RTNDESC["-" S RTNDESC=$P(RTNDESC,"-",2,99)
 S RTNDESC=$P($$TRIM^XLFSTR(RTNDESC,"L"," "),"[",1)
 ;
 S RTNPATCH=$P($P($G(^ROUTINE(RTN,0,2)),";",5),"*",3)
 S RTNPATCH=$RE($P($RE(RTNPATCH),",",1))
 Q
 ;
JUSTSIZE(RTN,Y) ; EP
 NEW AZHL,AZHL0,G,XCNP
 S G="NEW I ZL @X X ^%ZOSF(""SIZE"")"
 S X=RTN
 S (AZHL,X)=RTN
 K Z
 S (AZHL0,X)=AZHL
 S DIF="^TMP($J,""Z"","
 S XCNP=0
 X "X ^%ZOSF(""LOAD""),G"
 Q
