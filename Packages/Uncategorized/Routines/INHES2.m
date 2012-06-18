INHES2 ;KN; 9 Sep 96 13:51; Calling routine for the INHES Module. 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; MODULE NAME: INTERFACE ERROR SUMMARY (INHES2)
 ;
 ;
INSUM(INSRCH,INAR) ;Summary routine
 ; 
 ; Description: 
 ; The INSUM is used to search global ^INTHER Interface Error File 
 ; from the start date to the end/date.  It will group the error 
 ; messages according to the text length, report the count for each 
 ; group.  It also collects details for the first and last occurences 
 ; of each group occurs and of error messages such as: Transaction type,
 ; Message ID, Error loc, Destination and Background process.
 ;
 ; Return: None
 ;
 ; Parameters:  
 ; INSRCH = Array of criteria
 ; INAR   = Array of IEN
 ; 
 ; Code begins:  
 N INKA
 S INRVSRCH=$G(INSRCH("INORDER"))
 S INKA="INARDET"
 ; get the count, first and last occurence IEN
 D INSUMP(.INSRCH,.INAR,.INKA)
 ; INKD is the display array
 ; INKD is the array that contains the error text and all the details
 ; for the first and last occurences. 
 S INKD="INARDIS"
 ; get all the details message and store in display array INKD
 D GETERR(.INKA,.INKD)
 W:($P(IOST,"-")["C") @IOF D HSET^INHES,HEADER^INHES
 ; display summary report
 S INX="" F  S INX=$O(@INKD@(INX)) Q:INX=""  D
 . D NP Q:$G(DUOUT)  W !,$G(@INKD@(INX)),?7,INX
 . F INJ=1:1:2  D
 .. Q:'$D(@INKD@(INX,INJ))
 .. I INRVSRCH=0 D NP Q:$G(DUOUT)  W !?5,$S(INJ=1:"Latest",INJ=2:"Earliest")," occurence: ",$G(@INKD@(INX,INJ)),?45,$E($G(@INKD@(INX,INJ,4)),1,30)
 .. I INRVSRCH=1 D NP Q:$G(DUOUT)  W !?5,$S(INJ=1:"Earliest",INJ=2:"Latest")," occurence: ",$G(@INKD@(INX,INJ)),?45,$E($G(@INKD@(INX,INJ,4)),1,30)
 .. D NP Q:$G(DUOUT)  W !?5,$E($G(@INKD@(INX,INJ,1)),1,30),?45,$E($G(@INKD@(INX,INJ,2)),1,30)
 .. D NP Q:$G(DUOUT)  W !?5,$E($G(@INKD@(INX,INJ,3)),1,30),?45,$E($G(@INKD@(INX,INJ,5)),1,30),!
 K @INKA,INKA,@INKD,INKD
 ; Display the total report
 D NP Q:$G(DUOUT)  W !!,"TOTAL ERROR : ",$G(INSRCH("FOUND")),"  TOTAL SEARCH : ",$G(INSRCH("TOTAL"))
 ; call function to display the "end of report"
 W !!,$J("",30)_"*** End of Report ***"
 I ($P(IOST,"-")["C")&('$D(IO("Q")))&(IO=IO(0))&(INPAGE>0) Q:$G(DUOUT)  W ! D ^UTSRD("Press <RETURN> to continue or ^ to Quit;;;;;;;0;;;;DTIME;;X","","",1) S:(X=1)!(X=2) DUOUT=1
 Q:$G(DUOUT)
 Q
 ;
NP ; New page
 I $Y>(IOSL-5) D HEADER^INHES
 Q
 ; The function SEARCH is reused code from the INHERR
SEARCH ; Search/List/Output INTHER errors that match a search criteria 
 ; Module Name: SEARCH ( Interface Error Search Routine )
 ;
 ; Description: Prompts the user for search criteria to be used
 ;              to find matches in the Interface Error File
 ;              file (^INTHER). The user is presented with a list
 ;              of matching items which can be selectively expanded
 ;              or printed(user chosen device). The user is then
 ;              brought back to the Search Criteria menu and can
 ;              continue with another search or exit with the F10 key.
 ; Return: none
 ; Parameters: none
 ;
 ; Code begins
 N INDA,INQUIT,INFNDNAM,INSELECT,INPARM2
 S INFNDNAM="INMSGS" N @INFNDNAM
 ; Create the list processor help text
 S INPARM2("HELP")="N INHELP D BLDHELP^INHERR3(.INHELP),SRCHHELP^INHERR3(.INHELP)"
 ; Create the list processor TITLE text
 S INPARM2("TITLE")="W ?IOM-$L(""Interface Error Summary"")/2,""Interface Error Summary"""
 F  S INFNDNAM="INMSGS" S INQUIT=$$BGNSRCH^INHERR(.INFNDNAM,1,.INDA,.INPARM2,1) Q:$S(INQUIT=0:0,INQUIT=4:0,1:1)  D:$O(@INFNDNAM@(0)) POST^INHERR2(INFNDNAM,"INH ERROR DISPLAY",4003) K @INFNDNAM
 D:+INDA INKINDA^INHMS(INDA)
 Q
 ;
GETERR(INKA,INKD) ; get error messages
 ; 
 ; Description: The GETERR is used to given the IEN for the first and 
 ;  last occurance in INKA array, get details for the error
 ;   messages such as: Transaction Type, Destination, Message
 ;  ID, Error location, Background process and store in 
 ;   display array INKD parameter.
 ; Return: None
 ; 
 ; Parameters: 
 ;  INKA = array of IEN for the first and last occuence
 ; INKD = display array
 ;
 ; Code begins:
 ; loop through INKA array to get all info and convert date 
 S INT="" F  S INT=$O(@INKA@(INT)) Q:INT=""  D
 .F INJ=1:1:2  D
 .. Q:'$D(@INKA@(INT,INJ))  S INIEN=$G(@INKA@(INT,INJ)),@INKD@(INT)=$G(@INKA@(INT))
 ..; acquire the .01 field for errors and messages
 .. S INERRTXT=$G(^INTHER(INIEN,0)),INMSGTXT=$S(+$P(INERRTXT,U,4):$G(^INTHU($P(INERRTXT,U,4),0)),1:"")
 ..; get the date
 .. S Y=$P(^INTHER(INIEN,0),"^") D DD^%DT S @INKD@(INT,INJ)=$G(Y)
 ..; transaction type
 .. S INETTYPE=$S(+$P(INERRTXT,U,2):+$P(INERRTXT,U,2),+$P(INMSGTXT,U,11):+$P(INMSGTXT,U,11),1:"None") S:+INETTYPE @INKD@(INT,INJ,1)=$P($G(^INRHT(INETTYPE,0)),U)
 ..; error location
 .. S INELOC=$S(+$P(INERRTXT,U,5):+$P(INERRTXT,U,5),1:"None") S:+INELOC @INKD@(INT,INJ,2)=$P($G(^INTHERL(INELOC,0)),U)
 ..; destination
 .. S INEDEST=$S(+$P(INERRTXT,U,9):+$P(INERRTXT,U,9),+$P(INMSGTXT,U,2):+$P(INMSGTXT,U,2),1:"None") S:+INEDEST @INKD@(INT,INJ,3)=$P($G(^INRHD(INEDEST,0)),U)
 .. S @INKD@(INT,INJ,4)=$S($L($P(INMSGTXT,U,5)):$P(INMSGTXT,U,5),1:"None")
 ..; background process
 .. S INBGDPR=$S(+$P(INERRTXT,U,11):+$P(INERRTXT,U,11),1:"None") S:+INBGDPR @INKD@(INT,INJ,5)=$P($G(^INTHPC(INBGDPR,0)),U)
 ..; Merge to file if array too large
 .. I $S<20000 N INTMPY S INTMPY=INKD,INKD="^UTILITY($J,""INAD"")" K @INKD M @INKD=@INTMPY K @INTMPY,INTMPY
 Q
 ;
INSUMP(INSRCH,INAR,INKA) ;Summary routine
 ; 
 ; Description: The INSUM is used to search global ^INTHER Interface 
 ;  Error File.  Get the count for each group of the 
 ;  error messages according to select text length.  It
 ;  also calculate the count, save the IEN for the first
 ;  and the last occurence for each group of the messages.
 ; 
 ; Return: None
 ;
 ; Parameters:  
 ; INSRCH = Array of the criteria
 ; INAR   = Array of IEN
 ;       INKA   = Array of count, ien for the first and last occurence
 ; 
 ; Code begins:  
 N INT,INTIM,INENODE
 S INEXLN=$G(INSRCH("TEXTLEN"))
 ; INKA is an array that contains the error count for each group 
 ; and also the first and last occurences IEN.
 ; Maximum text lenght is 120 due to system restriction for MERGE 
 I $G(INEXLN)>120 S INEXLN=120
 ;INX is ien from inar array
 S INT=0
 F  S INT=$O(@INAR@(INT)) Q:'INT  D
 .; Loop through multiple node and concat the error message text
 . S INENODE=0,OK=1,INX=$G(@INAR@(INT)),INTXT=""
 . F  S INENODE=$O(^INTHER(INX,2,INENODE)) Q:'INENODE!'OK  D
 .. S INLV=$G(^INTHER(INX,2,INENODE,0))
 .. S:$L(INTXT)+$L(INLV)>120 OK=0 Q:'OK
 .. S INTXT=$G(INTXT)_INLV
 . S INTXT=$$UPCASE^%ZTF($E(INTXT,1,$G(INEXLN)))
 . I INTXT="" S INTXT="No Error Text"
 .; store in display array INKA, if memory is full, merge to ^UTILITY
 . I $S<20000 N INTMPY S INTMPY=INKA,INKA="^UTILITY($J,""INAC"")" K @INKA M @INKA=@INTMPY K @INTMPY,INTMPY
 . S @INKA@(INTXT)=$G(@INKA@(INTXT))+1
 .; save the ien of first and last occurance
 . I '$D(@INKA@(INTXT,1)) S @INKA@(INTXT,1)=INX
 . E  S @INKA@(INTXT,2)=INX
 Q
