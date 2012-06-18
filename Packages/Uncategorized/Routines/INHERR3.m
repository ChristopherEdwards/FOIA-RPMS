INHERR3 ;DJL; 3 Mar 95 15:42;Interface - Error Search
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
 ;          INHLP(PBR) = The array variable to load the text into.
 ; CODE BEGINS
 ; the following line can be used to limit strings to 78 characters.
 ; HHHHHHHHHHxxxxxxxxxXxxxxxxxxxXxxxxxxxxxxXxxxxxxxxxxXxxxxxxxxxxXxxxxxxxxxxXxxxxxxxxxxXxxxxxxxx
 S INHLP(1)="Displayed is a list of the Interface Errors that have matched the criteria"
 S INHLP(1,0)=""
 S INHLP(2)="you have selected in the previous screen. Select all errors you are"
 S INHLP(2,0)=""
 S INHLP(3)="interested in and hit the <RETURN> key to select the display device "
 S INHLP(3,0)=""
 S INHLP(4)="(re: printer/slave/etc.). To output or view an individual error"
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
 ;          INHLPLST(PBR) = The array of the text into.
 ; CODE BEGINS
 N DWLRF,DWLMK,DWLMK1,DWLB,DWLR,DWL
 S DWL="FWHTZ",DWLRF="INHLPLST",DWLB="0^7^10^78"
 S:$D(INHLPLST)<10 INHLPLST(1)="No HELP is available at this time."
 D ^DWL
 Q
 ;
INHTITLE(INMSGSZ,INSRCH) ; Write the Search Status line 21 from WITHIN the list proc.
 ; RETURNS: none
 ; PARAMETERS:
 ;    INMSGSZ(PBV) = Approximate number of items to be searched
 ;    INSRCH(PBR) = Array for holding search criteria information
 ; CODE BEGINS
 N INTEMPX,INTEMPY
 S INTEMPX=IOX,INTEMPY=IOY,IOX=0,IOY=21 X IOXY
 W "APPROXIMATE Number of Errors to Search: "_INMSGSZ
 S IOX=INTEMPX,IOY=INTEMPY X IOXY
 X $$INMSGSTR^INHERR3("",1,$G(INSRCH("INEXPAND")))
 Q
 ;
INMSGSTR(INIEN,INLABEL,INEXPAND,INLEVEL) ; Build a string from msg. elements
 ; MODULE NAME: INMSGSTR ( Interface Error Listing String Builder )
 ; DESCRIPTION: Construct a string containing selected fields from
 ;              the error. Used to construct the string which is
 ;              displayed in the List Processor indicating errors
 ;              found to match the search criteria. Or consruct a
 ;              label used to identify the field to be listed.
 ; RETURN = The composite error string or 
 ;          a string indicating error status
 ; PARAMETERS:
 ;    INIEN(PBV) = IEN into ^INTHER
 ;    INLABEL(PBV) = Flag to return a string to be used as the title
 ;             containing the field labels used below.
 ;             0/null= no label requested
 ;             1= return the only the label
 ;    INEXPAND(PBV) = Flag (1/0) to build expanded listing        
 ;    INLEVEL(PBV) = Flag indicating which level of the listing is to be
 ;              returned.
 ;              "" = level 0 with error time/date, error status, error location
 ;              1  = level 1 with error text
 ;              2  = level 2 with transaction type, destination
 ;              3  = level 3 with message time/date, message ID, message status
 ; CODE BEGINS
 N X,Y,DIC,INNODE,INTDATE,INERRID,INDEST,INERRSTR,INERRTXT,INDSTNUM,INPATNAM,INESTAT
 N INEDATE,INEDEST,INELOC,INETTYPE,INMSGID,INMSTAT,INMSGTXT
 S INIEN=$G(INIEN),INLABEL=$G(INLABEL),INEXPAND=$G(INEXPAND),INLEVEL=$G(INLEVEL)
 ; build and return a title string if the flag is set
 I INLABEL S INERRSTR="D DWLTITLE^INHERR2("_+$G(INEXPAND)_")" Q INERRSTR
 ; acquire .01 field informationg for Errors and Messages
 S INERRTXT=$G(^INTHER(INIEN,0)),INMSGTXT=$S(+$P(INERRTXT,U,4):$G(^INTHU($P(INERRTXT,U,4),0)),1:"")
 Q:'$L(INERRTXT) "No Error Information Found"
 ; acquire information for each level of display
 I '$G(INLEVEL) D  Q INERRSTR
 . S INEDATE=$TR($$CDATASC^%ZTFDT($P(INERRTXT,U),1,2),":")
 .; use previously created TABLE of status codes(INETBL)
 . S INESTAT=$S($L($P(INERRTXT,U,10)):INETBL($P(INERRTXT,U,10)),1:"none")
 . S INELOC=$S(+$P(INERRTXT,U,5):+$P(INERRTXT,U,5),1:"none") S:+INELOC INELOC=$P($G(^INTHERL(INELOC,0)),U)
 . S $E(INERRSTR,1,17)=$E(INEDATE,1,18),$E(INERRSTR,21,36)=$E(INESTAT,1,12),$E(INERRSTR,38,79)=$E(INELOC,1,15)
 I $G(INLEVEL)=1 D  Q INERRSTR
 . S INERRSTR="",INNODE=$O(^INTHER(INIEN,2,0)) Q:'INNODE  Q:$L($G(^INTHER(INIEN,2,INNODE,0)))=0
 . S $E(INERRSTR,8,79)=$E($G(^INTHER(INIEN,2,INNODE,0)),1,65) S INNODE=$O(^INTHER(INIEN,2,INNODE))
 .; Concatenate as much of the next node as possible
 .;   if there is room and it exists
 . I $L(INERRSTR)<70,INNODE S $E(INERRSTR,($L(INERRSTR)+4),78)=$E($G(^INTHER(INIEN,2,INNODE,0)),1,(74-$L(INERRSTR)))
 I $G(INLEVEL)=2 D  Q INERRSTR
 . S INETTYPE=$S(+$P(INERRTXT,U,2):+$P(INERRTXT,U,2),+$P(INMSGTXT,U,11):+$P(INMSGTXT,U,11),1:"none") S:+INETTYPE INETTYPE=$P($G(^INRHT(INETTYPE,0)),U)
 . S INEDEST=$S(+$P(INERRTXT,U,9):+$P(INERRTXT,U,9),+$P(INMSGTXT,U,2):+$P(INMSGTXT,U,2),1:"none") S:+INEDEST INEDEST=$P($G(^INRHD(INEDEST,0)),U)
 . S $E(INERRSTR,3,43)=$E(INETTYPE,1,40),$E(INERRSTR,45,79)=$E(INEDEST,1,30)
 I $G(INLEVEL)=3,($L(INMSGTXT)) D  Q INERRSTR
 . S INTDATE=$TR($$CDATASC^%ZTFDT($P(INMSGTXT,U),1,2),":")
 . S INMSGID=$S($L($P(INMSGTXT,U,5)):$P(INMSGTXT,U,5),1:"no message id")
 .; use previously created TABLE of status codes(INMTBL)
 . S INMSTAT=$S($L($P(INMSGTXT,U,3)):INMTBL($P(INMSGTXT,U,3)),1:"none")
 . S $E(INERRSTR,3,23)=$E(INTDATE,1,18),$E(INERRSTR,25,45)=$E(INMSGID,1,20),$E(INERRSTR,47,77)=$E(INMSTAT,1,30)
 Q ""
 ;
CODETBL(INNAME,INFILE,INFIELD) ; build an array of Set-of-codes from a DD entry
 ; MODULE NAME: CODETBL ( build an array of codes from the ^DD global )
 ; DESCRIPTION: Construct a array containing selected fields from
 ;              the DD given the array name, file, and field. 
 ; RETURN = none
 ; PARAMETERS:
 ;    INNAME(PBV) = The name of the array to populate
 ;    INFILE(PBV) = The file number to reference
 ;    INFIELD(PBV) = The field within the file
 ; CODE BEGINS
 N X,INLEN,INCNT,INPIECE,INCODE,INTXT
 K @INNAME
 S X=$P(^DD(INFILE,INFIELD,0),U,3)
 S INLEN=$L(X,";")
 F INCNT=1:1:INLEN S INPIECE=$P(X,";",INCNT),INCODE=$P(INPIECE,":",1),INTXT=$P(INPIECE,":",2) S:$L(INCODE) @INNAME@(INCODE)=INTXT
 Q
 ;
