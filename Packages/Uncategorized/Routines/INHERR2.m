INHERR2 ;DJL; 27 Oct 95 11:44;Interface - Error Search
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
LIST(INQUIT,IND,INSRCH,DWLRF,INRVSRCH,INL,INSRCHCT) ; Build the error array
 ; MODULE NAME: LIST ( Build the list of matching errors )
 ; DESCRIPTION: 
 ; loop through the errors from date-start to date-end and
 ; give the user a progress indicator
 ; PARAMETERS:
 ;    INQUIT(PBV) = 0 = The program completed properly
 ;             1 = No matching errors were found
 ;    IND(PBV) = The starting time/date of the search set from information
 ;          in INSRCH and determined by INRVSRCH flag
 ;    INSRCH(PBR) = Array for holding search criteria information
 ;    DWLRF(PBV) = Settings for the Display Processor
 ;    INRVSRCH(PBV) = Flag set user indicating direction of the search
 ;          -1 = (default)a reverse listing order. Newest to Oldest
 ;           0 = a forward search listing order. Oldest to Newest
 ;    INL(PBR) = Array used to load with error items matching the criteria
 ;    INSRCHCT(PBV) = The combined count of error items searched
 ; CODE BEGINS
 N INM,INFNDCT,INBLKCT,INNOMORE,INDSPSZ,DWLR,INETBL,INMTBL
 S INDSPSZ=1000 ; max. num. of msg. for disp. progress
 S INFNDCT=$P(@DWLRF,U,2),INBLKCT=INFNDCT+19 ; INBLKCT=num. of msg./win.
 ; build the set-of-code tables for MSGTEST usage
 D CODETBL^INHERR3("INETBL",4003,.1),CODETBL^INHERR3("INMTBL",4001,.03)
 S:'IND IND=$O(^INTHER("B",IND),INRVSRCH)
 F  Q:$S('IND:1,(INRVSRCH>-1)&(IND>INSRCH("INEND")):1,(INRVSRCH=-1)&(IND<INSRCH("INSTART")):1,1:0)!(INFNDCT>(INBLKCT))  D  S IND=$O(^INTHER("B",IND),INRVSRCH)
 .  S INM="" F  S INM=$O(^INTHER("B",IND,INM),INRVSRCH) Q:'INM  D
 ..    D MSGTEST(INM,.DWLRF,.INSRCH,.INSRCHCT,.INFNDCT) I '(INSRCHCT#20) D MS^DWD("SEARCHING...  ERRORS SEARCHED: "_INSRCHCT_"   ERRORS FOUND: "_INFNDCT)
 I '$O(@DWLRF@(0)) D MS^DWD("No Errors Found.") S INQUIT=$$CR^UTSRD,INQUIT=1 Q
 ; check for completion of search to terminate 'more' functionality
 S INNOMORE=0 S:$S('IND:1,(INRVSRCH>-1)&(IND>INSRCH("INEND")):1,(INRVSRCH=-1)&(IND<INSRCH("INSTART")):1,1:0) INNOMORE=1,$P(@DWLRF,U,2)=0
 S:'INNOMORE $P(@DWLRF,U,2)=INFNDCT
 S INQUIT=0
 Q
 ;
MSGTEST(INEIEN,INLIST,INSRCH,INSRCHCT,INFNDCT) ; Add matching error to array
 ; MODULE NAME: MSGTEST ( Interface Error Match Criteria Test )
 ; DESCRIPTION: Tests the error for matches to values passed in third
 ;              parameter array nodes and addes the IEN to the second
 ;              parameter array. Updates counters accordingly.
 ; RETURN = none
 ; PARAMETERS:
 ;    INEIEN(PBV)= IEN into ^INTHER
 ;    INLIST(PBR) = The NAME of the array to add items found
 ;    INSRCH(PBR) = The array of items to find
 ;    INSRCHCT(PBR) = The count of errors searched
 ;    INFNDCT(PBR) = The count of errors found
 ; CODE BEGINS
 N INTEMPX,INTEMPY,INMAXSZ,INMIEN
 S INMAXSZ=100,INTEMPX=$G(^INTHER(INEIEN,0)),INSRCHCT=INSRCHCT+1
 S INMIEN=$P(INTEMPX,U,4),INTEMPY=$G(^INTHU(+INMIEN,0))
 ; Checking the Interface Error file
 I INSRCH("INDEST")]"" I $P(INTEMPX,U,9)'=INSRCH("INDEST")&($P(INTEMPY,U,2)'=INSRCH("INDEST")) Q
 I INSRCH("INORIG")]"" I $P(INTEMPX,U,2)'=INSRCH("INORIG")&($P(INTEMPY,U,11)'=INSRCH("INORIG")) Q
 I $D(INSRCH("INERLOC")),INSRCH("INERLOC")]"",$P(INTEMPX,U,5)'=INSRCH("INERLOC") Q
 I $D(INSRCH("INERSTAT")),INSRCH("INERSTAT")]"",$P(INTEMPX,U,10)'=INSRCH("INERSTAT") Q
 I $D(INSRCH("INTEXT"))>9 Q:'$$INERSRCH^INHERR1(.INSRCH,INEIEN,INSRCH("INTYPE"))
 ; Checking the Interface Message file
 I $G(INSRCH("INMSGSTART")) Q:($P(INTEMPY,U)<INSRCH("INMSGSTART"))
 I $G(INSRCH("INMSGSTART")) Q:($P(INTEMPY,U)>INSRCH("INMSGEND"))
 I INSRCH("INID")]"" Q:$P(INTEMPY,U,5)'=INSRCH("INID")
 I INSRCH("INDIR")]"" Q:$P(INTEMPY,U,10)'=INSRCH("INDIR")
 I INSRCH("INSTAT")]"" Q:$P(INTEMPY,U,3)'=INSRCH("INSTAT")
 I INSRCH("INSOURCE")]"" Q:$E($P(INTEMPY,U,8),1,$L(INSRCH("INSOURCE")))'=INSRCH("INSOURCE")
 I INSRCH("INPAT")]"" Q:'INMIEN  Q:'$$INMSPAT^INHMS1(INMIEN,INSRCH("INPAT"))
 ; move the found-items array to ^UTILITY if it's getting too large
 ; kill the new ^UTILITY space incase it already exists prior to merg
 I INFNDCT>INMAXSZ,(INLIST'[U) N INTEMPY S INTEMPY=INLIST,INLIST="^UTILITY(""INL"","_$J_"_"_DUZ_"_"_$P($H,",",2)_")" K @INLIST M @INLIST=@INTEMPY K @INTEMPY,INTEMPY
 S @INLIST@(INSRCHCT)=$$INMSGSTR^INHERR3(INEIEN,"",$G(INSRCH("INEXPAND"))),@INLIST@(INSRCHCT,0)=INEIEN,INFNDCT=INFNDCT+1
 I '$G(INSRCH("INEXPAND")) S @INLIST@((INSRCHCT+.1))=$$INMSGSTR^INHERR3(INEIEN,"",$G(INSRCH("INEXPAND")),1) K:'$L(@INLIST@((INSRCHCT+.1))) @INLIST@((INSRCHCT+.1))
 ; show the expanded listing date only if EXPAND and a MESSAGE exists
 D:$G(INSRCH("INEXPAND"))
 . S @INLIST@((INSRCHCT+.1))=$$INMSGSTR^INHERR3(INEIEN,"",$G(INSRCH("INEXPAND")),2) K:'$L(@INLIST@((INSRCHCT+.1))) @INLIST@((INSRCHCT+.1))
 D:+INMIEN&($G(INSRCH("INEXPAND")))
 . S @INLIST@((INSRCHCT+.2))=$$INMSGSTR^INHERR3(INEIEN,"",$G(INSRCH("INEXPAND")),3) K:'$L(@INLIST@((INSRCHCT+.2))) @INLIST@((INSRCHCT+.2))
 I $G(INSRCH("INEXPAND")) S @INLIST@((INSRCHCT+.3))=$$INMSGSTR^INHERR3(INEIEN,"",$G(INSRCH("INEXPAND")),1) K:'$L(@INLIST@((INSRCHCT+.3))) @INLIST@((INSRCHCT+.3))
 Q
 ;
DWLTITLE(INEXPAND) ; Write the title
 W !,"  Date/Time           Error Status     Error Location"
 W:INEXPAND !,"    Transaction Type                          Destination"
 W:INEXPAND !,"    Message Date/Time     Message ID            Message Status"
 W !,"         Error Text"
 Q
 ; 
POST(INNAME,INTEMPLT,INFILE) ; Disply/Print
 ; MODULE NAME: POST ( Post-action logic on List Processor field )
 ; DESCRIPTION: Display/print using template passed on file passed 
 ; RETURN = none
 ; PARAMETERS:
 ;    INNAME(PBV) = A NAME of an Array of IEN's into the file of items
 ;            selected for displaying/printing
 ;    INTEMPLT(PBV) = Print template to use
 ;    INFILE(PBV) = The file to use
 ;
 ; CODE BEGINS
 N X,I,DIC,DR,DHD,DW,DWCP,INIO,DIE,DA
 I $O(@INNAME@(0)) D
 . D CLEAR^DW
 . S %ZIS="N" D ^%ZIS Q:POP  S INIO=IO,IOP=ION_";"_IOST_";"_IOM_";"_IOSL
 . S I=0 F  S I=$O(@INNAME@(I)) Q:'I  S DA(@INNAME@(I))=""
 . S DR=INTEMPLT,DIC=INFILE,DHD="@" D PRTLIST^DWPR
 . S:INIO=IO X=$$CR^UTSRD
 Q
 ;
