INHOU2 ;DJL; 25 Aug 97 11:03;Interface Message Requeue Utilities 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
BLDHELP(INREQHLP)  ; Construct the array containing the HELP text
 ; MODULE NAME: BLDHELP ( Construct the array of text used for HELP )
 ; DESCRIPTION: Constructs an array on assending numeric nodes containing
 ;              up to 78 characters per line. No realistic limit exists
 ;              on the number of nodes.
 ; RETURN = none
 ; PARAMETERS:
 ;          INREQHLP = The array variable to load the text into.
 ; CODE BEGINS
 ; the following line can be used to limit strings to 78 characters.
 ; HHHHHHHHHHxxxxxxxxxXxxxxxxxxxXxxxxxxxxxxXxxxxxxxxxxXxxxxxxxxxxXxxxxxxxxxxXxxxxxxxxxxXxxxxxxxx
 S INREQHLP(1)="Displayed is a list of the Messages that matched the search criteria"
 S INREQHLP(1,0)=""
 S INREQHLP(2)="you selected in the previous screen. Select only those messages which will"
 S INREQHLP(2,0)=""
 S INREQHLP(3)="be acted upon the same way. Use the HOT KEYS to select the action to be"
 S INREQHLP(3,0)=""
 S INREQHLP(4)="taken for the selected items. Explainations follow for available actions:"
 S INREQHLP(4,0)=""
 S INREQHLP(5)="EXISTING: Processing will continue using existing message information."
 S INREQHLP(5,0)=""
 S INREQHLP(6)="SINGLE: You will be prompted for information used in processing all messages."
 S INREQHLP(6,0)=""
 S INREQHLP(7)="UNIQUE: You will be prompted for information used in processing each message."
 S INREQHLP(7,0)=""
 S INREQHLP(8)="Functionality found in the Interface Message Search tool is also available."
 S INREQHLP(8,0)=""
 S INREQHLP(9)="After processing the selected items you will be returned to an abbreviated"
 S INREQHLP(9,0)=""
 S INREQHLP(10)="list of remaining messages to be processed. The program is terminated when"
 S INREQHLP(10,0)=""
 S INREQHLP(11)="all items have been processed or <RETURN> is entered with no items selected."
 S INREQHLP(11,0)=""
 S INREQHLP(12)="Press <RETURN> to continue:"
 S INREQHLP(12,0)=""
 Q
 ;
REQONE(INLIST,INPARM2) ; display the list processor with one selected item
 ; MODULE NAME: REQONE ( to preselect and display one message )
 ; DESCRIPTION: Displays the message in INLIST as a preselected item
 ;              in the list processor.
 ; RETURN = none
 ; PARAMETERS:
 ;          INLIST = The array variable containing the item to list.
 ;          INPARM2 = Structure containing information about actions
 ;                    available
 ; CODE BEGINS
 N INL,INNODE,DWLHOT,DWLRF,DWLB,DWLR,DWL,DWLMK,DWLMK1,DWLMK2
 Q:'$D(INLIST)
 ; build the displayable array for list processor
 S INNODE=$O(INLIST(""),-1),INL(INNODE,0)=INLIST(INNODE),INL(INNODE)=$$INMSGSTR^INHMS2(INL(INNODE,0)),INL(INNODE,9,0,"MK")="",DWLMK(INNODE)=INNODE
 I '$$SC^INHUTIL1 D  Q
 .D GOHOT2^INHOU5(.INLIST,"INL")
 ; Setup the Hot-Key paramters to be called if set in INPARM2 structure.
 I $D(INPARM2("LIST","HOT"))>9 S INNODE="" F  S INNODE=$O(INPARM2("LIST","HOT",INNODE)) Q:'INNODE  S DWLHOT(INNODE)=INPARM2("LIST","HOT",INNODE)
 I $D(INPARM2("LIST","HOT"))>9 S:$G(INPARM2("LIST","TITLE"))'["HOTTITLE^INHOU2" INPARM2("LIST","TITLE")=$G(INPARM2("LIST","TITLE"))_" D HOTTITLE^INHOU2"
 ; setup the title used in the list processor
 S DWL="FEWK",DWL("TITLE")=INPARM2("LIST","TITLE"),DWLRF="INL",DWLB="0^2^17^78",$P(@DWLRF,U,2)=0
 S:'$L($G(INPARM2("LIST","INHELP"))) DWL=DWL_"H"
 F  D ^DWL Q:$$QUITDWL^INHMS3($G(DWLR))  S:DWL'["K" DWL=DWL_"K" D  Q:$D(DWLMK)<10
 .  I DWLR="E" D EXPAND^INHMS1
 .  I DWLR="?" X INPARM2("LIST","INHELP")
 .  I DWLR["H",$D(INPARM2("LIST","HOT"))>9,($D(DWLMK)) N INHOTOPT S INHOTOPT="" F  S INHOTOPT=$O(INPARM2("LIST","HOT",INHOTOPT)) Q:'INHOTOPT  D
 ..    I DWLR[$P(INPARM2("LIST","HOT",INHOTOPT),U,2) X INPARM2("LIST","HOT",INHOTOPT,"ACTION")
 I DWLR["^" K DWLMK,DWLMK1
 I $D(INPARM2("LIST","HOT"))>9,($D(DWLMK)) N INHOTOPT S INHOTOPT=$O(INPARM2("LIST","HOT","")) X INPARM2("LIST","HOT",INHOTOPT,"ACTION")
 ; Action-Bar to be called if a name was passed.
 ;I $L($G(INPARM2("BAR"))) D ABASK^XGABAR(INPARM2("BAR")) S INPARM2("BAR","XGABESCF")=XGABESCF,INPARM2("BAR","XGABPOP")=XGAB
 Q
 ;
HOTTITLE ; Write a title line from WITHIN the requeue list processor
 N DWLMSG,INTEMPX,INTEMPY
 D HOTSET^DWL S INTEMPX=IOX,INTEMPY=IOY,IOX=0,IOY=23 X IOXY W DWLMSG S IOX=INTEMPX,IOY=INTEMPY X IOXY
 Q
 ;
