INHERR4 ;DJL; 17 Nov 97 11:59;Interface - Error Search
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
GATHER(INSRCH,INDA,IND,INRVSRCH) ; Collect search criteria data
 ; MODULE NAME: GATHER ( Search Criteria Gathering Routine )
 ; DESCRIPTION: Gather the list of user selected search criteria and
 ;              manipulate IND search starting variable depending on
 ;              the INVRSRCH flag setting. Notify the user if the
 ;              search may span a large numbe of errors and give
 ;              the option of discontinuing the search
 ; RETURN = none
 ; PARAMETERS:
 ;    INSRCH(PBR) = Array for holding search criteria information
 ;    INDA(PBV) = Unique IEN into ^INTHU(4001.1) where ^DWC puts the
 ;           user entered search criteria information
 ;    IND(PBR) = The starting time/date of the search set from information
 ;          in INSRCH and determined by INRVSRCH flag
 ;    INRVSRCH(PBR) = Flag set user indicating direction of the search
 ;          -1 = (default)a reverse listing order. Newest to Oldest
 ;           1 = a forward search listing order. Oldest to Newest
 ; CODE BEGINS
 N X,INSRCHST,INSRCHEN,INNODE,INTEMP,INEND,INSTART
 S INNODE=1
 F X="INSTART","INDEST","INSTAT","INID","INSOURCE","INDIR","INORIG","INPAT","INTEMP","INTYPE","INORDER","INEXPAND" S INSRCH(X)=$G(^DIZ(4001.1,INDA,INNODE)),INNODE=INNODE+1
 S INNODE=1,INTEMP=$G(^DIZ(4001.1,INDA,15))
 F X="INMSGSTART","INMSGEND","INERLOC","INERSTAT" S INSRCH(X)=$P(INTEMP,U,INNODE),INNODE=INNODE+1
 I $D(^DIZ(4001.1,INDA,9,0)) S INNODE=0 F  S INNODE=$O(^DIZ(4001.1,INDA,9,INNODE)) Q:'INNODE  S INSRCH("INTEXT")=INNODE,INSRCH("INTEXT",INNODE)=^DIZ(4001.1,INDA,9,INNODE,0)
 ; obtain Error date information
 S INSTART=INSRCH("INSTART"),(INSRCH("INEND"),INEND)=$G(^DIZ(4001.1,INDA,1.1))
 D GETDATE(.INSTART,.INEND) S INSRCH("INSTART")=INSTART,INSRCH("INEND")=INEND
 ; obtain Message date information
 I $G(INSRCH("INMSGSTART"))!$G(INSRCH("INMSGEND")) D
 .  S INSTART=$G(INSRCH("INMSGSTART")),INEND=$G(INSRCH("INMSGEND"))
 .  D GETDATE(.INSTART,.INEND) S INSRCH("INMSGSTART")=INSTART,INSRCH("INMSGEND")=INEND
 ; set the search string match type (AND/OR)
 S:($D(INSRCH("INTEXT"))>9)&('INSRCH("INTYPE")) (INSRCH("INTYPE"),^DIZ(4001.1,INDA,10))=0
 ; set the search starting point, (listing direction dependent)
 S:'$G(INSRCH("INORDER")) (INSRCH("INORDER"),^DIZ(4001.1,INDA,11))=0
 S IND=$S('INSRCH("INORDER"):INSRCH("INEND"),1:INSRCH("INSTART"))
 S INRVSRCH=$S('INSRCH("INORDER"):-1,1:1)
 Q
 ;
GETDATE(INSTART,INEND) ; setup the date/time
 ; MODULE NAME: GATHER ( Search Criteria Gathering Routine )
 ; DESCRIPTION: Set the start and end times appropriately
 ;              for a search by assigning END if not set,
 ;              setting to the start of end of the day selected,
 ;              and arranging the start and end variables
 ;              to a Past-to-Recent ordering.
 ; RETURN = none
 ; PARAMETERS:
 ;    INSTART(PBR) = Variable containing the start date
 ;    INEND(PBR) = Variable containing the end date
 ; CODE BEGINS
 N INTEMP
 S INEND=$G(INEND),INSTART=$G(INSTART)
 ; if no START date was defined default to the BEGINNING of time (M time)
 S:'INSTART INSTART=1800
 S:'INEND!(INEND=DT) INEND=DT_".24"
 ; Take care a special case of start date
 S:(INEND\1=INEND)&(INSTART\1=INEND) INEND=INEND+.999999
 I (INEND-INSTART)<0 D
 .  ; a RECENT to PAST search criteria
 .  S:((INEND\1)=INEND) INEND=INEND-.0000001
 .  S INTEMP=INSTART,INSTART=INEND
 .  I (INTEMP\1)=INTEMP S INEND=INTEMP+.999999
 .  I (INTEMP\1)'=INTEMP S INEND=INTEMP
 E  D
 .  ; a PAST to RECENT search criteria
 .  I ((INEND\1)=INEND) S INEND=INEND+.999999
 .  E  S INEND=INEND+.000099 ; Because second resolution can not be entered
 .  S INSTART=INSTART-.0000001
 Q
 ;
SRCHSIZE(INSRCH,INFILE) ; Determine the expected search size
 ; MODULE NAME: SRCHSIZE ( Determine the expected Search Size )
 ; DESCRIPTION: Determine the expected number of errors that will
 ;              be searched. Warn of very large searches and provide
 ;              a mechanism to abort the search.
 ;              Uses the Start-Date and End-Date of span to search to
 ;              determine the size(approximate).
 ; RETURNS: -1 = The user aborted the search
 ;          Number of errors in the search
 ; PARAMETERS:
 ;    INSRCH(PBR) = Array for holding search criteria information
 ;    INFILE(PBV) = The file/global to use
 ; CODE BEGINS
 N INSRCHEN,INSRCHST,INTEMP,INMSGCT,INSIZE,INWRNSZ
 ; INWRNSZ= the water-mark on when to notify the user of the search size
 S INWRNSZ=5000,INSIZE=0,INTEMP=$O(@INFILE@(INSRCH("INSTART")))
 I INTEMP,(INTEMP<INSRCH("INEND")) S INSRCHST=$O(@INFILE@(INTEMP,"")),INTEMP=$O(@INFILE@(INSRCH("INEND")),-1),INSRCHEN=$O(@INFILE@(INTEMP,""),-1),(INMSGCT,INSIZE)=(INSRCHEN-INSRCHST)+1
 I INTEMP,(INTEMP<INSRCH("INEND")),(INMSGCT>INWRNSZ) D
 .  W !! D ERR^INHMS2("WARNING: Approximate search size="_INMSGCT_" errors. This may take awhile.")
 .  I '$$YN^UTSRD("Do you want to continue with THIS search? ") S INSIZE=-1
 Q INSIZE
 ;
