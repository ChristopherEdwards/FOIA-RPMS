INHMS3 ;DJL; 10 Jan 95 15:00;Interface - Message Search
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
BLDHELP(INHLP) ; Construct the array containing the HELP text
 ; MODULE NAME: BLDHELP ( Construct the array of text used for HELP )
 ; DESCRIPTION: Constructs an array on assending numeric nodes containing
 ;              up to 78 characters per line. No realistic limit exists
 ;              on the number of nodes.
 ; RETURN = none
 ; PARAMETERS:
 ;          INHLP = The array variable to load the text into.
 ; CODE BEGINS
 ; the following line can be used to limit strings to 78 characters.
 ; HHHHHHHHHHxxxxxxxxxXxxxxxxxxxXxxxxxxxxxxXxxxxxxxxxxXxxxxxxxxxxXxxxxxxxxxxXxxxxxxxxxxXxxxxxxxx
 S INHLP(1)="Displayed is a list of the Interface Messages that have matched the criteria"
 S INHLP(1,0)=""
 S INHLP(2)="you have selected in the previous screen. Select all messages you are"
 S INHLP(2,0)=""
 S INHLP(3)="interested in and hit the <RETURN> key to select the display device "
 S INHLP(3,0)=""
 S INHLP(4)="(re: printer/slave/etc.). To output or view an individual message"
 S INHLP(4,0)=""
 S INHLP(5)="use the EXPAND key. The EXPAND function will return you to the selection"
 S INHLP(5,0)=""
 S INHLP(6)=" list upon completion. The selection list will return you to the Search"
 S INHLP(6,0)=""
 S INHLP(7)="Criteria entry screen upon completion."
 S INHLP(7,0)=""
 S INHLP(8)="Press <RETURN> to continue:"
 S INHLP(8,0)=""
 Q
 ;
SRCHHELP(INHLPLST) ; Display List Processor style HELP 
 ; MODULE NAME: SRCHHELP ( Display an array of text used for HELP )
 ; DESCRIPTION: Call the list processor to display the array passed
 ;              if it contains a least one sub-node otherwise construct
 ;              a node stating no help is available.
 ; RETURN = none
 ; PARAMETERS:
 ;          INHLPLST = The array of the text into.
 ; CODE BEGINS
 N DWLRF,DWLMK,DWLMK1,DWLB,DWLR,DWL
 S DWL="FWHTZ",DWLRF="INHLPLST",DWLB="0^7^10^78"
 S:$D(INHLPLST)<10 INHLPLST(1)="No HELP is available at this time."
 D ^DWL
 Q
 ;
SRCHSIZE(INSRCH) ; Determine the expected search size
 ; MODULE NAME: SRCHSIZE ( Determine the expected Search Size )
 ; DESCRIPTION: Determine the expected number of message that will
 ;              be searched. Warn of very large searches and provide
 ;              a mechanism to abort the search.
 ;              Uses the Start-Date and End-Date of span to search to
 ;              determine the size(approximate).
 ; RETURNS: -1 = The user aborted the search
 ;          Number of messages in the search
 ; PARAMETERS:
 ;    INSRCH = Array for holding search criteria information
 ; CODE BEGINS
 N INSRCHEN,INSRCHST,INTEMP,INMSGCT,INSIZE,INWRNSZ
 ; INWRNSZ= the water-mark on when to notify the user of the search size
 S INWRNSZ=5000,INSIZE=0,INTEMP=$O(^INTHU("B",INSRCH("INSTART")))
 I INTEMP,(INTEMP<INSRCH("INEND")) S INSRCHST=$O(^INTHU("B",INTEMP,"")),INTEMP=$O(^INTHU("B",INSRCH("INEND")),-1),INSRCHEN=$O(^INTHU("B",INTEMP,""),-1),(INMSGCT,INSIZE)=(INSRCHEN-INSRCHST)+1
 I INTEMP,(INTEMP<INSRCH("INEND")),(INMSGCT>INWRNSZ) D
 .  W !! D ERR^INHMS2("WARNING: Approximate search size="_INMSGCT_" messages. This may take awhile.")
 .  I '$$YN^UTSRD("Do you want to continue with THIS search? ") S INSIZE=-1
 Q INSIZE
 ;
QUITDWL(DWLR) ; handle the quit conditions for a ^DWL loop using DWLR
 N INQUIT
 S INQUIT=1
 ; don't quit if any of the following conditions are true
 I DWLR="E" S INQUIT=0 ; Q INQUIT ; expand
 I DWLR="?" S INQUIT=0 ; Q INQUIT ; help
 I DWLR="^" S INQUIT=1 Q INQUIT ; user exit
 I DWLR="^^" S INQUIT=1 Q INQUIT ; user abort
 I DWLR="M" S INQUIT=0 ; Q INQUIT ; max. num. selected
 I DWLR["H" S INQUIT=0 ; Q INQUIT ; hot key
 I +DWLR>0 S INQUIT=1 Q INQUIT ; return
 Q INQUIT
 ;
INHTITLE(INMSGSZ,INSRCH) ; Write the Search Status line 21 from WITHIN the list proc.
 N INTEMPX,INTEMPY
 S INTEMPX=IOX,INTEMPY=IOY,IOX=0,IOY=21 X IOXY
 W "APPROXIMATE Number of Messages to Search: "_INMSGSZ
 S IOX=INTEMPX,IOY=INTEMPY X IOXY
 W !,$$INMSGSTR^INHMS2("",1,$G(INSRCH("INEXPAND")))
 Q
 ;
