INHUTC4 ;KN,bar; 15 Sep 97 14:41; Interface Message/Error Search 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;;COPYRIGHT 1997 SAIC
 ;
 ; 
 ; MODULE NAME: Interface Message/Error Search (INHUTC4)
 ;
 ; PURPOSE:
 ; The purpose of the Interface Message/Error Search module is to 
 ; provide User/Programmer a generic search functionality into files
 ; ^INTHU and ^INTHER.
 ;
 ; DESCRIPTION:
 ; This module contains three sub-modules: INHUTC4, INHUTC5 and INHUTC6.
 ;
DISPLAY(INOPT,INMSGFND) ; Interactive output using DWL
 ;
 ; Description: The function Interactive search DISPLAY is performed
 ;  the search interactively in the increment of matching 
 ;  records.  Also, the DISPLAY uses List Processor DWL 
 ;  to present user with a list of matching records for
 ;  selection and expanding or printing.
 ;  Furthermore, this function has capability to allow for
 ;  programmer to override the List Processor by assigning
 ;  value to the option array INOPT.  The search criteria
 ;  is defined in INSRCH array and found records will be 
 ;  returned in INMSGFND array.
 ;
 ; Return: 
 ;  0 = No error found (the program completed properly)
 ;  1 = No message to search (no message found)
 ;  2 = User stop the search (user abort DWL)
 ;          
 ; Parameters:
 ;   INOPT    = Array of option values passed by reference.
 ;   INMSGFND = A NAME of an array in which to build a list(in
 ;              subscript/selection order) of the selected items IEN's
 ;              into ^INTHU or ^INTHER.
 ;
 ; Code begins:
 N X,Y,INL,INQUIT,IND,INMSGSZ,INNODE,INSRCHCT,INTYPE,INST,INRET,INSRCH
 N DWL,DWLB,DWLMK,DWLMK1,DWLHOT,DWLR,DWLRF,XGABESCF,XBABPOP
 ;
 ; ---------- Retrieve Search criteria --------
 I '$D(INSRCH) S INX=$$GATHER^INHUTC6($G(INOPT("CRITERIA")),.INSRCH) Q:'INX 1
 S INTYPE=INSRCH("TYPE"),INST=$$UPCASE^%ZTF($E(INTYPE))_$$DNCASE^%ZTF($E(INTYPE,2,$L(INTYPE))),INMSGSZ=0,INRET=0
 ;
 I '$$SC^INHUTIL1 D  G IHSJUMP
 .S DWLRF="INL"
 .D EN^INHUTC52(.INSRCH)
 .;VA List processor expands/displays within itself, so set quit
 .S:'$D(INOPT("LIST","HOT")) INRET=2
 ; ---------- Init ListMan Title --------------
 ; Set up the default DWL title - ;bar; set app and func?
 S:'$D(INOPT("LIST","TITLE")) X="Interface "_INST_" Search",X=$J("",IOM-$L(X)/2)_X,X=X_$J("",IOM-$L(X)),INOPT("LIST","TITLE")="W """_X_""""
 ;
 ; ---------- Transaction Specific ------------
 I INTYPE="TRANSACTION" D
 . ; determine scope of search and warn user if needed
 . S INMSGSZ=$$SRCHSIZE^INHMS4(.INSRCH) Q:INMSGSZ<0
 . ; Create the list processor help text
 . S:'$D(INOPT("LIST","HELP")) INOPT("LIST","HELP")="N INHELP D BLDHELP^INHMS3(.INHELP),SRCHHELP^INHMS3(.INHELP)"
 . S DWL("TITLE")=INOPT("LIST","TITLE")_" D INHTITLE^INHMS3(INMSGSZ,.INSRCH)"
 ;
 ; ---------- Error Specific ------------------
 I INTYPE="ERROR" D
 . ; determine scope of search and warn user if needed
 . S INMSGSZ=$$SRCHSIZE^INHERR4(.INSRCH,"^INTHER(""B"")")
 . S:'$D(INOPT("LIST","HELP")) INOPT("LIST","HELP")="N INHELP D BLDHELP^INHERR3(.INHELP),SRCHHELP^INHERR3(.INHELP)"
 . S DWL("TITLE")=INOPT("LIST","TITLE")_" D INHTITLE^INHERR3(INMSGSZ,.INSRCH)"
 ;
 ; ---------- Search Size ----------------------
 ; check for user abort or no records to search
 Q:INMSGSZ<0 2
 ;IHS branch
 I 'INMSGSZ,$$SC^INHUTIL1 D MS^DWD("No "_INST_"s to Search") S X=$$CR^UTSRD Q 1
 S INOPT("SRCHSIZE")=INMSGSZ
 ;
 ; ---------- Init ListMan Hot Keys ------------
 I $D(INOPT("LIST","HOT"))>9 D
 . S INNODE="" F  S INNODE=$O(INOPT("LIST","HOT",INNODE)) Q:'INNODE  S DWLHOT(INNODE)=INOPT("LIST","HOT",INNODE)
 . S DWL("TITLE")=DWL("TITLE")_" D HOTTITLE^INHOU2"
 ;
 ; ---------- DWL set up, save the display list in array DWLRF
 S DWL="GFEWZ",DWLRF="INL",DWLB="0^2^17^78"
 S:'$L($G(INOPT("LIST","HELP"))) DWL=DWL_"H"
 ; If expand in error search, then the display window is smaller for more titles
 I INTYPE="TRANSACTION",$G(INSRCH("INEXPAND")) S DWLB="0^3^16^78"
 I INTYPE="ERROR",$G(INSRCH("INEXPAND")) S DWLB="0^5^15^78"
 ;
 ; --------- set up "more" functionality --------
 S DWL("MORE")=$S($D(INOPT("LIST","MORE")):INOPT("LIST","MORE"),1:"FIND^INHUTC5(.INQUIT,.INOPT,.DWLRF,.INSRCH)")
 S INOPT("DISPFORMAT")=$G(INOPT("DISPFORMAT"),"D BLDSTR^INHUTC4(INM,INSRCH(""INFNDCT""),.INIEN,.INSRCH)")
 S INOPT("MAXFND")=$G(INOPT("MAXFND"),20),(INOPT("INSRCHCT"),INOPT("INFNDCT"))=0
 S INSRCHCT=0 D @DWL("MORE")
 I INQUIT=4 S INRET=2 G CLEAN
 I INQUIT=3,$G(INOPT("INFNDCT"))=0 S INRET=1 G CLEAN
 ;
 ; ---------- Set up default print template -----
 S:'$D(INOPT("PRINT")) INOPT("PRINT")="INH "_$S(INTYPE="TRANSACTION":"MESSAGE",1:INTYPE)_" DISPLAY"
 ;
 ; ---------- Call ListMan
 F  D ^DWL Q:$$QUITDWL^INHMS3($G(DWLR))  S:DWL'["K" DWL=DWL_"K" D  Q:$D(@DWLRF)<10
 .  I DWLR="E" D EXPAND^INHERR1(INOPT("PRINT"),INSRCH("FILENUM"))
 .  ; Let user get help, and hot key if any
 .  I DWLR="?" X INOPT("LIST","HELP")
 .  I DWLR["H",$D(INOPT("LIST","HOT"))>9,($D(DWLMK)) N INHOTOPT S INHOTOPT="" F  S INHOTOPT=$O(INOPT("LIST","HOT",INHOTOPT)) Q:'INHOTOPT  D
 .. I DWLR[$P(INOPT("LIST","HOT",INHOTOPT),U,2) X INOPT("LIST","HOT",INHOTOPT,"ACTION")
 ; If user abort DWL, then set the return value, quit and clear screen
 I DWLR["^" S INRET=2 G CLEAN
IHSJUMP ;IHS logic jumps here to bypass CHCS Listman calls
 I $D(INOPT("LIST","HOT"))>9,$D(DWLMK) N INHOTOPT S INHOTOPT=$O(INOPT("LIST","HOT","")) X INOPT("LIST","HOT",INHOTOPT,"ACTION")
 ; Action-Bar to be called if a name was passed and system is not IHS.
 I $L($G(INOPT("LIST","BAR"))),$$SC^INHUTIL1 D ABASK^XGABAR(INOPT("LIST","BAR")) S INOPT("LIST","BAR","XGABESCF")=XGABESCF,INOPT("LIST","BAR","XGABPOP")=XGABPOP
 ; build the selection-ordered list in @INMSGFND (^UTILITY if needed)
 ; build it from 'DWLMK' because 'DWLMK1' is not reliable after the
 ; EXPAND functionality has been exercized.
 I $D(DWLMK) D
 . S:DWLRF[U INMSGFND="^UTILITY(""INS"","_$J_")" K @INMSGFND
 . S INNODE=0 F  S INNODE=$O(DWLMK(INNODE)) Q:INNODE=""  S @INMSGFND@(DWLMK(INNODE))=@DWLRF@(INNODE,0)
CLEAN ; cleanup vars and the selection array
 K:$D(@DWLRF) @DWLRF
 M INOPT("INSRCH")=INSRCH
 D CLEAR^DW
 Q INRET
 ;
BLDSTR(INDA,INSEQ,DWLRF,INSRCH) ; Build text to display in ListMan screen
 ;
 ; input: INDA   =  ien of record found
 ;        INSEQ  =  list sequence number
 ;        DWLRF  =  name of list storage array
 ;        INSRCH =  search criteria array
 ; return:
 ;        Build entries of text into DWLRF array
 ;
 N INETBL,INMTBL
 I INSRCH("TYPE")="TRANSACTION" D
 . S @DWLRF@(INSEQ)=$$INMSGSTR^INHMS2(INDA,"","")
 . I $G(INSRCH("INEXPAND")) S %=$$INMSGSTR^INHMS2(INDA,"",$G(INSRCH("INEXPAND"))) I $L(%) S @DWLRF@(INSEQ+.1)=%
 I INSRCH("TYPE")="ERROR" D
 . M INETBL=INSRCH("INETBL"),INMTBL=INSRCH("INMTBL")
 . S @DWLRF@(INSEQ)=$$INMSGSTR^INHERR3(INDA,"",$G(INSRCH("INEXPAND")))
 . ; show the expanded listing date only if EXPAND and a MESSAGE exists
 . D:$G(INSRCH("INEXPAND"))
 .. S %=$$INMSGSTR^INHERR3(INDA,"",$G(INSRCH("INEXPAND")),2) S:$L(%) @DWLRF@((INSEQ+.1))=%
 .. S %=$$INMSGSTR^INHERR3(INDA,"",$G(INSRCH("INEXPAND")),3) S:$L(%) @DWLRF@((INSEQ+.2))=%
 . S %=$$INMSGSTR^INHERR3(INDA,"",$G(INSRCH("INEXPAND")),1) S:$L(%) @DWLRF@((INSEQ+.3))=%
 ; make first line selectable, INDA is used to pass the ien to the selected array later
 S @DWLRF@(INSEQ,0)=INDA
 Q
 ;
