INHMS2 ;JSH,DJL; 25 Sep 97 13:01;Interface - Message Search
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
LIST(INQUIT,IND,INSRCH,DWLRF,INRVSRCH,INL,INSRCHCT) ; Build the msg. array
 ; MODULE NAME: LIST ( Build the list of matching messages )
 ; DESCRIPTION: 
 ; loop through the messages from date-start to date-end and
 ; give the user a progress indicator
 ; PARAMETERS:
 ;    INQUIT = 0 = The program completed properly
 ;             1 = No matching messages were found
 ;    IND = The starting time/date of the search set from information
 ;          in INSRCH and determined by INRVSRCH flag
 ;    INSRCH = Array for holding search criteria information
 ;    DWLRF = Settings for the Display Processor
 ;    INRVSRCH = Flag set user indicating direction of the search
 ;          -1 = (default)a reverse listing order. Newest to Oldest
 ;           0 = a forward search listing order. Oldest to Newest
 ;    INL = Array used to load with message items matching the criteria
 ;    INSRCHCT = The combined count of message items searched
 ; CODE BEGINS
 N INM,INFNDCT,INBLKCT,INNOMORE,INDSPSZ,DWLR
 S INDSPSZ=1000 ; max. num. of msg. for disp. progress
 S INFNDCT=$P(@DWLRF,U,2),INBLKCT=INFNDCT+19 ; INBLKCT=num. of msg./win.
 S:'IND IND=$O(^INTHU("B",IND),INRVSRCH)
 F  Q:$S('IND:1,(INRVSRCH>-1)&(IND>INSRCH("INEND")):1,(INRVSRCH=-1)&(IND<INSRCH("INSTART")):1,1:0)!(INFNDCT>(INBLKCT))  D  S IND=$O(^INTHU("B",IND),INRVSRCH)
 .  S INM="" F  S INM=$O(^INTHU("B",IND,INM),INRVSRCH) Q:'INM  D
 ..    D MSGTEST(INM,.DWLRF,.INSRCH,.INSRCHCT,.INFNDCT) I '(INSRCHCT#20) D MS^DWD("SEARCHING...  (APPROXIMATE) MESSAGES SEARCHED: "_INSRCHCT_"   MESSSAGES FOUND: "_INFNDCT)
 D MS^DWD("SEARCHING...  (APPROXIMATE) MESSAGES SEARCHED: "_INSRCHCT_"   MESSSAGES FOUND: "_INFNDCT)
 I '$O(@DWLRF@(0)) D MS^DWD("No Messages Found.") S INQUIT=$$CR^UTSRD,INQUIT=1 Q
 ; check for completion of search to terminate 'more' functionality
 S INNOMORE=0 S:$S('IND:1,(INRVSRCH>-1)&(IND>INSRCH("INEND")):1,(INRVSRCH=-1)&(IND<INSRCH("INSTART")):1,1:0) INNOMORE=1,$P(@DWLRF,U,2)=0
 S:'INNOMORE $P(@DWLRF,U,2)=INFNDCT
 S INQUIT=0
 Q
 ;
MSGTEST(INMIEN,INLIST,INSRCH,INSRCHCT,INFNDCT) ; Add matching msg. to array
 ; MODULE NAME: MSGTEST ( Interface Message Match Criteria Test )
 ; DESCRIPTION: Tests the message for matches to values passed in third
 ;              parameter array nodes and addes the IEN to the second
 ;              parameter array. Updates counters accordingly.
 ; RETURN = none
 ; PARAMETERS:
 ;    INMIEN= IEN into ^INTHU
 ;    INLIST = The NAME of the array to add items found
 ;    INSRCH = The array of items to find
 ;    INSRCHCT = The count of messages searched
 ;    INFNDCT = The count of messages found
 ; CODE BEGINS
 N INTEMPX,INMAXSZ
 S INMAXSZ=1100,INTEMPX=$G(^INTHU(INMIEN,0)),INSRCHCT=INSRCHCT+1
 I INSRCH("INDEST")]"",$P(INTEMPX,U,2)'=INSRCH("INDEST") Q
 I INSRCH("INSTAT")]"",$P(INTEMPX,U,3)'=INSRCH("INSTAT") Q
 I INSRCH("INID")]"",$P(INTEMPX,U,5)'=INSRCH("INID") Q
 I INSRCH("INSOURCE")]"",$E($P(INTEMPX,U,8),1,$L(INSRCH("INSOURCE")))'=INSRCH("INSOURCE") Q
 I INSRCH("INDIR")]"",$P(INTEMPX,U,10)'=INSRCH("INDIR") Q
 I INSRCH("INORIG")]"",$P(INTEMPX,U,11)'=INSRCH("INORIG") Q
 I INSRCH("INPAT")]"" Q:'$$INMSPAT^INHMS1(INMIEN,INSRCH("INPAT"))
 I $D(INSRCH("INTEXT"))>9 Q:'$$INMSRCH^INHMS1(.INSRCH,INMIEN,INSRCH("INTYPE"))
 ; move the found-items array to ^UTILITY if it's getting too large
 ; kill the new ^UTILITY space incase it already exists prior to merg
 I INFNDCT>INMAXSZ,(INLIST'[U) N INTEMPY S INTEMPY=INLIST,INLIST="^UTILITY(""INL"","_$J_"_"_DUZ_"_"_$P($H,",",2)_")" K @INLIST M @INLIST=@INTEMPY K @INTEMPY,INTEMPY
 S @INLIST@(INSRCHCT)=$$INMSGSTR(INMIEN,"",""),@INLIST@(INSRCHCT,0)=INMIEN,INFNDCT=INFNDCT+1
 I $G(INSRCH("INEXPAND")) S @INLIST@(INSRCHCT+.1)=$$INMSGSTR(INMIEN,"",$G(INSRCH("INEXPAND")))
 Q
 ;
INMSGSTR(INMSGIEN,INLABEL,INEXPAND) ; Build a string from msg. elements
 ; MODULE NAME: INMSGSTR ( Interface Message Listing String Builder )
 ; DESCRIPTION: Construct a string containing selected fields from
 ;              the message. Used to construct the string which is
 ;              displayed in the List Processor indicating messages
 ;              found to match the search criteria. Or consruct a
 ;              label used to identify the field to be listed.
 ; RETURN = The composite message string or 
 ;          a string indicating error status
 ; PARAMETERS:
 ;    INMSGIEN= IEN into ^INTHU
 ;    INLABEL= Flag to return a string to be used as the title
 ;             containing the field labels used below.
 ;             0/null= no label requested
 ;             1= return the only the label
 ;    INEXPAND= Flag (1/0) to build expanded listing        
 ; CODE BEGINS
 N INTEMP,INTDATE,INMSGID,INDEST,INMSGSTR,INMSGTXT,INDSTNUM,INPATNAM
 S INLABEL=$G(INLABEL),INEXPAND=$G(INEXPAND)
 ; build and return a title string if the flag is set
 I INLABEL,'INEXPAND S $E(INMSGSTR,3,17)="Date/Time",$E(INMSGSTR,23,40)="Message ID",$E(INMSGSTR,55,79)="Destination" Q INMSGSTR
 I INLABEL,INEXPAND S $E(INMSGSTR,3,17)="Date/Time",$E(INMSGSTR,23,37)="Message ID",$E(INMSGSTR,55,67)="Destination",$E(INMSGSTR,87,100)="Patient",$E(INMSGSTR,109,140)="Transaction Type" Q INMSGSTR
 S INMSGTXT=$G(^INTHU(INMSGIEN,0))
 Q:'$L(INMSGTXT) "No Message Information Found"
 S INTDATE=$TR($$CDATASC^%ZTFDT($P(INMSGTXT,U),1,2),":")
 S INMSGID=$P(INMSGTXT,U,5)
 S INDSTNUM=+$P(INMSGTXT,U,2),INDEST="" S:INDSTNUM INDEST=$P($G(^INRHD(INDSTNUM,0)),U)
 I 'INEXPAND S $E(INMSGSTR,1,17)=$E(INTDATE,1,19),$E(INMSGSTR,21,52)=$E(INMSGID,1,30),$E(INMSGSTR,53,79)=$E(INDEST,1,25) Q INMSGSTR
 I INEXPAND D  Q INMSGSTR
 .S INTEMP=$$INMSPAT^INHMS1(INMSGIEN,"",.INPATNAM)
 .S INORGTT=+$P(INMSGTXT,U,11),INOTT="" S:INORGTT INOTT=$P($G(^INRHT(INORGTT,0)),U)
 .S $E(INMSGSTR,5,25)=$E(INPATNAM,1,20),$E(INMSGSTR,27,75)=$E(INOTT,1,45)
 Q ""
 ;
POST(INNAME) ; Disply/Print messages
 ; MODULE NAME: POST ( Post-action logic on List Processor field )
 ; DESCRIPTION: Display/print messages using INH MESSAGE DISPLAY 
 ;              template
 ; RETURN = none
 ; PARAMETERS:
 ;    INNAME= A NAME of an Array of IEN's into ^INTHU of messages
 ;            selected for displaying/printing
 ; CODE BEGINS
 N I,DIC,DR,DHD,DW,DWCP,INIO,DIE,DA
 I $O(@INNAME@(0)) D
 . D CLEAR^DW
 . S %ZIS="N" D ^%ZIS Q:POP  S INIO=IO,IOP=ION_";"_IOST_";"_IOM_";"_IOSL
 . S I=0 F  S I=$O(@INNAME@(I)) Q:'I  S DA(@INNAME@(I))=""
 . S DR="INH MESSAGE DISPLAY",DIC=4001,DHD="@" D PRTLIST^DWPR
 . S:INIO=IO X=$$CR^UTSRD
 Q
 ;
ERR(INMSG,INFSCRN,INCONT) ; Error/Information handler
 ; MODULE NAME: ERR ( Interface Message Error/Information Processor )
 ; DESCRIPTION:  ERR is a multi-functional message display utility for
 ;               handling user notification of errors and other messages
 ; RETURN = none
 ; PARAMETERS:
 ;     INMSG = a string to be displayed
 ;     INFSCRN =  flag to disable/enable the poping of a window
 ;                0=disable(default)
 ;                1=enable
 ;     INCONT = flag to disable/enable continuation prompting
 ;              0=disable(default)
 ;              1=enable
 ; CODE BEGINS
 N INTEMP
 S INMSG=$G(INMSG)
 D:$G(INFSCRN) MESS^DWD(5,10)
 ; org W !,INMSG
 W INMSG
 S:$G(INCONT) INTEMP=$$CR^UTSRD
 Q
 ;
