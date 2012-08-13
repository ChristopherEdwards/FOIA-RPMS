INHMS4 ;JSH,DJL; 24 Jan 95 14:03;Interface - Message Search
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
GATHER(INSRCH,INDA,IND,INRVSRCH) ; Collect search criteria data
 ; MODULE NAME: GATHER ( Search Criteria Gathering Routine )
 ; DESCRIPTION: Gather the list of user selected search criteria and
 ;              manipulate IND search starting variable depending on
 ;              the INVRSRCH flag setting. Notify the user if the
 ;              search may span a large numbe of messages and give
 ;              the option of discontinuing the search
 ; RETURN = none
 ; PARAMETERS:
 ;    INSRCH = Array for holding search criteria information
 ;    INDA = Unique IEN into ^INTHU(4001.1) where ^DWC puts the
 ;           user entered search criteria information
 ;    IND = The starting time/date of the search set from information
 ;          in INSRCH and determined by INRVSRCH flag
 ;    INRVSRCH = Flag set user indicating direction of the search
 ;          -1 = (default)a reverse listing order. Newest to Oldest
 ;           1 = a forward search listing order. Oldest to Newest
 ; CODE BEGINS
 N X,INSRCHST,INSRCHEN,INNODE,INTEMP
 S INNODE=1
 F X="INSTART","INDEST","INSTAT","INID","INSOURCE","INDIR","INORIG","INPAT","INTEMP","INTYPE","INORDER","INEXPAND" S INSRCH(X)=$G(^DIZ(4001.1,INDA,INNODE)),INNODE=INNODE+1
 S INSRCH("INEND")=$G(^DIZ(4001.1,INDA,1.1))
 I $D(^DIZ(4001.1,INDA,9,0)) S INNODE=0 F  S INNODE=$O(^DIZ(4001.1,INDA,9,INNODE)) Q:'INNODE  S INSRCH("INTEXT")=INNODE,INSRCH("INTEXT",INNODE)=^DIZ(4001.1,INDA,9,INNODE,0)
 S:'INSRCH("INEND")!(INSRCH("INEND")=DT) (INSRCH("INEND"),^DIZ(4001.1,INDA,1.1))=DT_".24"
 I (INSRCH("INEND")-INSRCH("INSTART"))<0 D
 .  ; a RECENT to PAST search criteria
 .  S:(INSRCH("INEND")\1=INSRCH("INEND")) INSRCH("INEND")=INSRCH("INEND")-.0000001
 .  S INTEMP=INSRCH("INSTART"),INSRCH("INSTART")=INSRCH("INEND")
 .  I (INTEMP\1)=INTEMP S INSRCH("INEND")=INTEMP+.999999
 .  I (INTEMP\1)'=INTEMP S INSRCH("INEND")=INTEMP
 E  D
 .  ; a PAST to RECENT search criteria
 .  I (INSRCH("INEND")\1=INSRCH("INEND")) S INSRCH("INEND")=INSRCH("INEND")+.999999
 .  E  S INSRCH("INEND")=INSRCH("INEND")+.000099 ; Because second resolution can not be entered
 .  S INSRCH("INSTART")=INSRCH("INSTART")-.0000001
 ; set the search string match type (AND/OR)
 S:($D(INSRCH("INTEXT"))>9)&('INSRCH("INTYPE")) (INSRCH("INTYPE"),^DIZ(4001.1,INDA,10))=0
 ; set the search starting point, (listing direction dependent)
 S:'$G(INSRCH("INORDER")) (INSRCH("INORDER"),^DIZ(4001.1,INDA,11))=0
 S IND=$S('INSRCH("INORDER"):INSRCH("INEND"),1:INSRCH("INSTART"))
 S INRVSRCH=$S('INSRCH("INORDER"):-1,1:1)
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
