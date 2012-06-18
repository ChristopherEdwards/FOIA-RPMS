INHUTC6 ;KN,bar; 13 Aug 97 09:18; Interface Message/Error Search 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; MODULE NAME: Interface Message/Error Search Part III (INHUTC6) 
 ;
 ; PURPOSE:
 ; The purpose of this Message/Error Search module is to provide User/
 ; Programmer a generic search functionality into file ^INTHU and 
 ; ^INTHER .  This module contains three subs modules:  INHUTC4, INHUTC5
 ; and INHUTC6.
 ;
 ; DESCRIPTION: 
 ; This sub-module contains function GATHER and BLDLIST
 ;
GATHER(INDA,INSRCH) ; Collect search criteria data
 ;
 ; input:  INDA = entry number in INTERFACE CRITERIA file
 ;         INSRCH = array of search criteria, passed by reference
 ; return: INDA  if successful
 ;         Error text if unsuccesful
 ;
 ; Description: Collects data from the INTERFACE CRITERIA file based
 ; on the type of search defined and creates the INSRCH array.
 ; Also calculates the start date and end date based on
 ; relative (start/end) date and/or absolute (start/end) date.
 ;
 ; Code begins:
 N X,Y,INX,INY,INNODE,INEND,INSTART,INTYPE,INETBL,INMTBL
 Q:'$G(INDA) "GATHER: Criteria ien not present."
 Q:'$D(^DIZ(4001.1,INDA,0)) "GATHER: Criteria entry not found."
 ; Set the constant values for Transaction or Error
 S INTYPE=$P(^DIZ(4001.1,INDA,0),U,5)
 Q:'$$TYPE^INHUTC2(INTYPE,1) "GATHER: Invalid criteria type for search."
 ; update relative dates before we retrieve values
 D RELDATE^INHUTC2(INDA)
 ;
 ;---------- SINGLE VALUE ENTRIES  -------------------------------
 S INSRCH("TYPE")=INTYPE
 S INY=0 F INX="INSTART","INDEST","INSTAT","INID","INSOURCE","INDIR","INORIG","INPAT","INTEMP","INTYPE","INORDER","INEXPAND" S INY=INY+1,X=$G(^DIZ(4001.1,INDA,INY)) S:$L(X) INSRCH(INX)=X
 S INSRCH("INEND")=$G(^DIZ(4001.1,INDA,1.1))
 ; Only set the value for USER and DIVISION if they exist
 S X=$G(^DIZ(4001.1,INDA,24))
 S:$P(X,U,3) INSRCH("INDIV")=$P(X,U,3)
 S:$P(X,U,4) INSRCH("INUSER")=$P(X,U,4)
 ;
 ;---------- MULTIPLE VALUE ENTRIES ------------------------------
 ; Get the multiple in node 31, 32, 33 and 34 indicated by INNODE
 S INNODE=30 F INX="MULTIORIG","MULTIDEST","MULTISTAT","MULTIDIV" D
 . S INNODE=INNODE+1,INY=0
 . F  S INY=$O(^DIZ(4001.1,INDA,INNODE,INY)) Q:'INY  S X=$G(^(INY,0)) S:$L(X) INSRCH(INX,X)=""
 ; text search field
 I $D(^DIZ(4001.1,INDA,9,0)) S INY=0 F  S INY=$O(^DIZ(4001.1,INDA,9,INY)) Q:'INY  S INSRCH("INTEXT")=INY,INSRCH("INTEXT",INY)=$G(^(INY,0))
 ; set the search string match type (AND/OR)
 S:($D(INSRCH("INTEXT"))>9)&('$D(INSRCH("INTYPE"))) INSRCH("INTYPE")=0
 ;
 ;---------- TRANSACTION SPECIFIC --------------------------------
 I INTYPE="TRANSACTION" S INSRCH("FILENAME")="^INTHU",INSRCH("FILENUM")=4001,INSRCH("MSG")="MESSAGE"
 ;
 ;---------- ERROR SPECIFIC --------------------------------------
 I INTYPE="ERROR" D
 . S INSRCH("FILENAME")="^INTHER",INSRCH("FILENUM")=4003,INSRCH("MSG")="ERROR"
 . ; Loop through node 15 and get all value for error criteria
 . S INX=$G(^DIZ(4001.1,INDA,15)),INY=0
 . F X="INMSGSTART","INMSGEND","INERLOC","INERSTAT" S INY=INY+1,Y=$P(INX,U,INY) S:$L(Y) INSRCH(X)=Y
 . ; build table values for later use in display
 . D CODETBL^INHERR3("INETBL",4003,.1),CODETBL^INHERR3("INMTBL",4001,.03)
 . M INSRCH("INETBL")=INETBL,INSRCH("INMTBL")=INMTBL
 ;
 ;---------- DATE MANIPULATION -----------------------------------
 ; obtain Date information
 S INSTART=$G(INSRCH("INSTART")),INEND=$G(INSRCH("INEND"))
 D GETDATE^INHERR4(.INSTART,.INEND)
 S INSRCH("INSTART")=INSTART,INSRCH("INEND")=INEND
 ; Get the auxiliary date for error
 I INTYPE="ERROR",$D(INSRCH("INMSGSTART"))!$D(INSRCH("INMSGEND")) D
 . S INSTART=$G(INSRCH("INMSGSTART")),INEND=$G(INSRCH("INMSGEND"))
 . D GETDATE^INHERR4(.INSTART,.INEND)
 . S INSRCH("INMSGSTART")=INSTART,INSRCH("INMSGEND")=INEND
 ; Set Indicator for search starting point and direction
 S:'$G(INSRCH("INORDER")) (INSRCH("INORDER"),^DIZ(4001.1,INDA,11))=0
 S INSRCH("IND")=$S('INSRCH("INORDER"):INSRCH("INEND"),1:INSRCH("INSTART"))
 ; set flag for transaction search under error search
 F X="INMSGSTART","INMSGEND","INID","INDIR","INPAT","INSOURCE" I $D(INSRCH(X)) S INSRCH("MESSAGEREQ")=1 Q
 ; system settings, min is 20000
 S INX=$P($G(^INRHSITE(1,0)),U,14),INSRCH("SPACE")=$S(INX>20000:INX,1:20000)
 Q INDA
 ;
LOCK(INGLB,INDA,INMODE,INTIME,INOPT,INCLR) ; lock file entry
 ; 
 ; Description: Lock and Unlock entries in a global and track
 ;              incremental locks
 ;
 ; Return: 
 ;   TRUE   =  success
 ;   FAILSE =  faild
 ; Parameters:
 ;         INGLB  =  file number or global base ref ie; "^DIC(3,"
 ;   INDA   =  entry in criteria file to lock (req)
 ;   INMODE =  1 to lock and 0 to unlock 0 is default
 ;         INTIME =  timeout value, defaults to DTIME or 5 sec if
 ;                   DTIME is not around.
 ;         INOPT  =  INOPT("LOCK", is where the lock array in kept
 ;                   INOPT("LOCK",INGLB,INDA)=num_of_locks
 ;         INCLR  =  optional. 0 or not used will do nothing extra
 ;                   if 1, will clear all locks in INOPT("LOCK",INGLB)
 ;                   if 2, will clear all locks in INOPT("LOCK")
 ;
 ; check for req values, set defaults
 Q:'$L($G(INGLB)) 0 Q:'$G(INDA) 0 S:'$D(INTIME) INTIME=$G(DTIME,5) S INMODE=+$G(INMODE)
 ; if numeric, get global base ref from FM
 I INGLB=+INGLB S INGLB=$G(^DIC(INGLB,0,"GL")) Q:'$L($G(INGLB)) 0
 ; if clearing locks do recursive unlock and quit
 I $G(INCLR) D  Q
 . N ING,INY,INN
 . ; loop thru globals
 . S ING=0 F  S ING=$O(INOPT("LOCK",ING)) Q:'$L(ING)  D
 .. ; loop thru iens
 .. S INY=0 F  S INY=$O(INOPT("LOCK",ING,INY)) Q:'INY  D
 ... ; loop thru num_of_locks
 ... S INN=INOPT("LOCK",ING,INY) F  S INN=INN-$$LOCK(ING,INY,0)
 N INODE,INT S INODE=INGLB_INDA_")"
 ; lock entry
 I INMODE S INT=0 D  Q INT
 . L +@INODE:INTIME E  Q
 . S INT=1,INOPT("LOCK",INGLB,INDA)=$G(INOPT("LOCK",INGLB,INDA))+1
 ; unlock entry
 L -@INODE S INOPT("LOCK",INGLB,INDA)=$G(INOPT("LOCK",INGLB,INDA))-1
 Q 1
 ;
