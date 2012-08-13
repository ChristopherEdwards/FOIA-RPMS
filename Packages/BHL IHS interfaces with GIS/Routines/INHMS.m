INHMS ;JSH,DJL; 17 Jan 96 10:03;Interface - Message Search
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
SEARCH ; Search/List/Output INTHU messages that match a search criteria 
 ; MODULE NAME: SEARCH ( Interface Message Search Routine )
 ; DESCRIPTION: Prompts the user for search criteria to be used
 ;              to find matches in the Interface Message Queue
 ;              file (^INTHU). The user is presented with a list
 ;              of matching items which can be selectively expanded
 ;              or printed(user chosen device). The user is then
 ;              brought back to the Search Criteria menu and can
 ;              continue with another search or exit with the F10 key.
 ; RETURN = none
 ; PARAMETERS = none
 ; CODE BEGINS
 N INDA,INQUIT,INFNDNAM,INSELECT,INPARM2
 S INFNDNAM="INMSGS" N @INFNDNAM
 ; Create the list processor help text
 S INPARM2("INHELP")="N INHELP D BLDHELP^INHMS3(.INHELP),SRCHHELP^INHMS3(.INHELP)"
 ; Create the list processor TITLE text
 S INPARM2("TITLE")="W ?IOM-$L(""Interface Message Search"")/2,""Interface Message Search"""
 F  S INFNDNAM="INMSGS" S INQUIT=$$BGNSRCH(.INFNDNAM,1,.INDA,.INPARM2) Q:$S(INQUIT=0:0,INQUIT=4:0,1:1)  D:$O(@INFNDNAM@(0)) POST^INHMS2(INFNDNAM) K @INFNDNAM
 D:+INDA INKINDA(INDA)
 Q
 ;
BGNSRCH(INMSGFND,INKINDA,INDA,INPARM2) ; Begin a search
 ; MODULE NAME: BGNSRCH ( Programmers entry point )
 ; DESCRIPTION: Same fuctionality as SEARCH^INHMS but only executes
 ;              a single pass. This would be useful for a programmers
 ;              interface because an array is loaded with the selected
 ;              items and could be used for other processing needs. An
 ;              Action-Bar can be added to the process by setting the 
 ;              fourth parameter to the name of the Action-Bar.
 ; RETURN = 0 = "CONTINUE" The program completed properly
 ;          1 = "EXIT"     The user exited ^DWC
 ;          2 = "SYSTEM"   The incorrect system
 ;          3 = "CREATION" The entry to store the search criteria could
 ;               not be created
 ;          4 = "CRITERIA" The required search criteria was not entered
 ; PARAMETERS:
 ;     INMSGFND = A NAME of an array in which to build a list(in
 ;                subscript/selection order) of the selected items IEN's
 ;                 into ^INTHU
 ;     INKINDA = Flag used to initiate the call to INKINDA(INDA) to do
 ;               cleanup of the ^DIZ global if set to 0 after the search
 ;               or let the calling routine call INKINDA(INDA).
 ;     INDA = Set to the node into ^DIZ(4001.1) where the selected
 ;            search criteria is setup.
 ;     INPARM2 = Structure nodes as follows:
 ;        "HELP" = Executable M code used for the List Processor HELP
 ;        "TITLE" = Executable M code use for the List Processor Title
 ;        "BAR" = A NAME of an Action-Bar to be called immediately after
 ;               all the items in the list have been selected. The
 ;               structure passed is to be updated with the XGABESCF and
 ;               XGABPOP nodes upon exiting. The calling routine must
 ;               evaluate the appropriate structure nodes to determine
 ;               the action to be taken
 ;        "BAR","XGABESCF" & "BAR","XGABPOP" set after bar is run
 ;        "HOT",x ="string indicating the function of the key^ret. value"
 ;        "HOT",x,"ACTION" ="Executable M code used on key selection)"
 ; CODE BEGINS
 N X,Y,INTEMP,DWLR,DWLRF,INL,INQUIT,INUQUIT,IND,INNODE,INSRCH,INM,INSRCHCT,INRVSRCH
 N DIC,DWL,DWLB,DIE,DWN,INERRTYP,DWLMK,DWLMK1,DWLMK2,DWLMSG,DWLHOT,DIPA,INMSGSZ,XGABESCF,XBABPOP
 S INKINDA=$G(INKINDA),INDA=$G(INDA)
 S INERRTYP("CONTINUE")=0,INERRTYP("EXIT")=1,INERRTYP("SYSTEM")=2,INERRTYP("CREATION")=3,INERRTYP("CRITERIA")=4
 I '$$SC^INHUTIL1 D ERR^INHMS2("Incorrect system type! This routine option is not available on this system.") Q INERRTYP("SYSTEM")
 ; create ^DIZ file if 1) single pass calling 
 ;                     2) multi-pass and INDA is not yet created
 I 'INDA S X=$J_"_"_DUZ_"_"_$P($H,",",2),DIC=4001.1,DIC(0)="L",DLAYGO=4001.1 D ^DIC S INDA=+Y I +Y<0 D ERR^INHMS2("Unable to create file "_X_" Interface Message Search Failed") Q INERRTYP("CREATION")
 S DA=INDA
 ; set the listing order default=Newest to Oldest
 S:'$D(^DIZ(4001.1,INDA,11)) ^DIZ(4001.1,INDA,11)=0
 ; set the expanded display default=NO
 S:'$D(^DIZ(4001.1,INDA,12)) ^DIZ(4001.1,INDA,12)=0
 ;  Force ^DWC to ask to file then Preset the fields for another search
 S DWASK=""
 S DIE=4001.1,DWN="INH MESSAGE SEARCH" D ^DWC
 I '$D(DWFILE) S INUQUIT=1 D:'INKINDA INKINDA(INDA) Q INERRTYP("EXIT")
 I '$G(^DIZ(4001.1,INDA,1)) D ERR^INHMS2("START DATE search criteria was not entered.","",1) D:'INKINDA INKINDA(INDA) Q INERRTYP("CRITERIA")
 D GATHER^INHMS4(.INSRCH,INDA,.IND,.INRVSRCH)
 S INMSGSZ=$$SRCHSIZE^INHMS4(.INSRCH) Q:INMSGSZ<0 INERRTYP("CONTINUE") I 'INMSGSZ D MS^DWD("No Messages to Search") S X=$$CR^UTSRD D:'INKINDA INKINDA(INDA) Q INERRTYP("CONTINUE")
 ; Setup the Hot-Key paramters to be called if set in INPARM2 structure.
 I $D(INPARM2("HOT"))>9 S INNODE="" F  S INNODE=$O(INPARM2("HOT",INNODE)) Q:'INNODE  S DWLHOT(INNODE)=INPARM2("HOT",INNODE)
 I $D(INPARM2("HOT"))>9 S INPARM2("TITLE")=$G(INPARM2("TITLE"))_" D HOTTITLE^INHOU2"
 ; setup the title used in the list processor
 S:$G(DWL("TITLE"))'["INHTITLE^INHMS3" DWL("TITLE")=$G(INPARM2("TITLE"))_" D INHTITLE^INHMS3(INMSGSZ,.INSRCH)"
 S DWL="GFEW",DWLRF="INL",DWL("MORE")="LIST^INHMS2(.INQUIT,.IND,.INSRCH,.DWLRF,INRVSRCH,.INL,.INSRCHCT)",DWLB="0^2^17^78",$P(@DWLRF,U,2)=0
 S INSRCHCT=0 D LIST^INHMS2(.INQUIT,.IND,.INSRCH,.DWLRF,INRVSRCH,.INL,.INSRCHCT) I INQUIT D:'INKINDA INKINDA(INDA) K @DWLRF Q INERRTYP("CONTINUE")
 S:'$L($G(INPARM2("INHELP"))) DWL=DWL_"H"
 F  D ^DWL Q:$$QUITDWL^INHMS3($G(DWLR))  S:DWL'["K" DWL=DWL_"K" D  Q:$D(@DWLRF)<10
 .  I DWLR="E" D EXPAND^INHMS1
 .  I DWLR="?" X INPARM2("INHELP")
 .  I DWLR["H",$D(INPARM2("HOT"))>9,($D(DWLMK)) N INHOTOPT S INHOTOPT="" F  S INHOTOPT=$O(INPARM2("HOT",INHOTOPT)) Q:'INHOTOPT  D
 ..    I DWLR[$P(INPARM2("HOT",INHOTOPT),U,2) X INPARM2("HOT",INHOTOPT,"ACTION")
 I DWLR["^" K DWLMK,DWLMK1
 I $D(INPARM2("HOT"))>9,$D(DWLMK) N INHOTOPT S INHOTOPT=$O(INPARM2("HOT","")) X INPARM2("HOT",INHOTOPT,"ACTION")
 ; Action-Bar to be called if a name was passed.
 I $L($G(INPARM2("BAR"))) D ABASK^XGABAR(INPARM2("BAR")) S INPARM2("BAR","XGABESCF")=XGABESCF,INPARM2("BAR","XGABPOP")=XGABPOP
 ;
 ; build the selection-ordered list in @INMSGFND (^UTILITY if needed)
 ; build it from 'DWLMK' because 'DWLMK1' is not reliable after the
 ; EXPAND functality has been exercized.
 I $D(DWLMK) D
 .  K @INMSGFND
 .  I DWLRF[U S INMSGFND="^UTILITY(""INL"","_$J_"_"_DUZ_"_"_$P($H,",",2)_")" K @INMSGFND
 .  S INNODE=0 F  S INNODE=$O(DWLMK(INNODE)) Q:INNODE=""  S @INMSGFND@(DWLMK(INNODE))=@DWLRF@(INNODE,0)
 D:'INKINDA INKINDA(INDA)
 ; cleanup the array built as list for ^DWL(could be in global(expand))
 K:$D(@DWLRF) @DWLRF Q INERRTYP("CONTINUE")
 ;
INKINDA(INDA) ; Clean-up search criteria storage data
 ; MODULE NAME: INKINDA ( Search Criteria Clean-up Routine )
 ; DESCRIPTION: Cleans up the Search Criteria Data in the ^DIZ global
 ;              by using the ^DIK routine.
 ; RETURN = none
 ; PARAMETERS:
 ;    INDA = Unique IEN into ^DIZ used to store Search Criteria Data
 ; CODE BEGINS
 S INDA=$G(INDA)
 I $D(^DIZ(4001.1,+INDA)) N X,DA,DIK S DA=INDA,DIK="^DIZ(4001.1," D ^DIK
 Q
 ;
