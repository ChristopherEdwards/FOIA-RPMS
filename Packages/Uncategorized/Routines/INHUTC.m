INHUTC ;bar; 23 Jul 97 15:02; Criteria Mgmt and Execution API 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;;COPYRIGHT 1997 SAIC
 ;
 ; MODULE NAME: Criteria Management And Execution API (INHUTC) 
 ;
 ; PURPOSE: 
 ;  Support application teams with an interface to Interface 
 ;  Transaction and Error reporting functionality.
 ;
 ; DESCRIPTION:
 ;  This module contains entry points for Interface Criteria Management,
 ;  Transaction search and print, and Error search and print.
 ;
ENTRY(INTYPE,INAPP,INFUNC,INCTRL,INOPT) ; simple entry point to run generic
 ; user-interfactive search of Interface Transactions and Error.
 ; input: INTYPE = "TRANSACTION" or "ERROR".  Required.
 ;        INAPP  = Optional text/namespace of application. ie; "MCSC".
 ;        INFUNC = Optional text of functionality. ie; "Scheduling"
 ;        INCTRL = Optional CONTROL value(s)
 ;             if INCTRL contains a "S" allow only STANDARD entries
 ;             if INCTRL contains a "U" allow only USER entries
 ;             if INCTRL contains a "W" allow only WORKING entries
 ;               (if only "W", user will not be prompted)
 ;
 ;IHS does not ENV^UTIL
 I $$SC^INHUTIL1 D ENV^UTIL
 I '$$TYPE^INHUTC2($G(INTYPE)) W !," Search type required." Q
 ; setup inbound parameters
 S INOPT("TYPE")=INTYPE,INOPT("APP")=$G(INAPP),INOPT("FUNC")=$G(INFUNC),INOPT("CONTROL")=$G(INCTRL)
 ; setup runtime parameters
 S INOPT("GALLERY")="INH "_INTYPE_" SEARCH EDIT"
 F  Q:'$$RUN^INHUTC(.INOPT)
 Q
 ;
TIEN(INOPT,INARNAM) ; simple entry to retrieve a selected list of transactions
 ;
 S INOPT("TYPE")="TRANSACTION",INOPT("GALLERY")="INH TRANSACTION SEARCH EDIT",INOPT("APP")="INTERFACE",INOPT("ARRAY")=INARNAM
 Q $$RUN^INHUTC(.INOPT)
 ;
GETCRIT(INOPT,INPARMS) ; Get/Create entries.
 ; 
 ; Description:   The function GETCRIT provides users and Programmers 
 ;  an interface to get, create, recall, edit and save a 
 ;  search entry from the Interface Criteria file.
 ;
 ;   Note:  Optionally pass in values.  Optionally run user 
 ;         interface.  Optionally save entry.
 ;
 ; Returns: 
 ; IEN of record in INTERFACE CRITERIA file if function does not 
 ; complete, reason text is returned.  Also returns DUOUT and 
 ; DTOUT if appropriate.
 ;
 ; Parameters:
 ;  INOPT   =   Array.  (Please refer to INHUTCD documentation for
 ;         description).
 ; INPARMS  =   Array of values to stuff into criteria fields.
 ;                     The value is the base name of the array rather 
 ;       than the array itself so it can be used with 
 ;       indirection.  @INPARMS@("TTYPE",1)="DG REG". 
 ;       Optional Refer to table under FIELDS^INHUTC3 
 ;       for field mnemonics.
 ;
 ; Code begins:
 Q $$GETCRIT^INHUTC7(.INOPT,.INPARMS)
 ;
 ;
DELCRIT(DA) ; Clean-up search criteria storage data
 ; 
 ; Description:  The function DELCRIT is used to cleans up the search
 ;        criteria data in the ^DIZ global by using the ^DIK
 ;        routine.
 ;
 ; Return:
 ; 0   =  failure
 ; 1   =  success
 ; Parameters:
 ;     INDA  =   IEN into ^DIZ Interface Criteria File used to search 
 ;        criteria data.
 ; 
 ; Code begins:
 Q:'$G(DA) 0
 ; do not delete standard entries
 Q:$P($G(^DIZ(4001.1,DA,0)),U,3)="S" 0
 ; do not delete if locked
 Q:'$$LOCK(DA,1,2) 0
 N DIK S DIK="^DIZ(4001.1," D ^DIK
 ; unlock entry
 S %=$$LOCK(DA,0)
 Q 1
 ;
 ;
RUN(INOPT,INPARMS) ; Run calling search and print 
 ; 
 ; Description: The function RUN operates into two modes:
 ; 1. Interactive mode:  In this mode, RUN will call function 
 ;    DISPLAY to do the search, display the found entries on 
 ;    screen for selection and allow user to select print device 
 ;    to output.
 ; 2. Non-interactive mode:  In this mode, RUN will initialize the
 ;    device selected in the search criteria.  It will create a 
 ;           background task to do the search and print to the selected
 ;    device.      
 ;
 ; Return:
 ; 1        =  if no error
 ; Error text  =  if error occurs
 ;
 ; Parameters:
 ;   (Same as parameters of the function SEARCH).  
 ;              
 ; 
 ; Code Begins:
 ;
 Q $$RUN^INHUTC7(.INOPT,.INPARMS)
 ;
 ;
SEARCH(INOPT,INIEN)   ; Interface Message/Error search 
 ;
 ; Description:  The function SEARCH is performed to searches global
 ;  ^INTHU (4001) or ^INTHER (4003) for records matching the 
 ; criteria defined in INOPT("CRITERIA") and then stores the 
 ; found ien in array INIEN.  
 ; The programmer can call this function within a loop.  
 ; INOPT("INSRCHCT") and INOPT("INFNDCT")(number 
 ; of the messages searched and number of the messages found) 
 ; are updated by this function as an indicator for the search 
 ; performed.
 ;
 ;  Note:  It is responsible of the programmer to reset the NUMBER
 ;        OF SEARCH (INOPT("INSRCHCT") to zero when the search
 ;        criteria changed.
 ;
 ; Return:  1  =  max found reached
 ;          2  =  max search reached
 ;          3  =  no more to search
 ;          4  =  user abort
 ;       text  =  error text
 ;
 ; Parameters:
 ;  
 ;  INOPT     = Array of option values passed by reference.  Some 
 ;  main options are listed below.  More details can be
 ;  found in the API documentation.  
 ;  INOPT("CRITERIA") = IEN to an entry in the INTERFACE CRITERIA file.
 ;  Search will be performed based on value in this entry.
 ;  INIEN     = List of found entry number are returned in this store
 ;  the ien into ^INTHU global that user selected.  
 ;
 ; Code Begins:
 N INQUIT,INSRCH
 Q:'$G(INOPT("CRITERIA")) "Incorrect or Missing Search Criteria"
 I $D(INOPT("INSRCH")) M INSRCH=INOPT("INSRCH")
 D FIND^INHUTC5(.INQUIT,.INOPT,.INIEN,.INSRCH)
 I $D(INSRCH) M INOPT("INSRCH")=INSRCH
 Q INQUIT
 ; 
PRINT(INOPT,INIEN) ; Display/Print messages
 ;
 ; Description:  The function PRINT is used to Display/print Messages or
 ;        Error by using INH MESSAGE/ERROR DISPLAY print template.
 ;
 ;
 ; Return:
 ; Parameters:
 ;    INOPT    =  Array of options. See INHUTCD for values.
 ;    INIEN    =  A NAME of an Array of IEN's into global ^INTHU or 
 ;  ^INTHER of messages or Errors selected for 
 ;   displaying/printing
 ;
 ; Code begins:
 Q $$PRINT^INHUTC7(.INOPT,.INIEN)
 ; 
 ;
LOCK(INDA,INMODE,INTIME) ; lock criteria entry
 ; 
 ; Description:  The function LOCK is used to manage lock and unlock 
 ;        entry in criteria file.
 ;
 ; Return: 
 ;   TRUE   =  success
 ;   FAILSE =  faild
 ; Parameters:
 ;   INDA   =  entry in criteria file to lock (req)
 ;   INMODE =  1 to lock and 0 to unlock 0 is default
 ;   INTIME =  timeout value, defaults to DTIME or 5 sec if
 ;                   DTIME is not around.
 ;
 ; Code begins:
 Q:'$G(INDA) 0 S:'$D(INTIME) INTIME=$G(DTIME,5)
 S INMODE=+$G(INMODE)
 I INMODE L +^DIZ(4001.1,INDA):INTIME Q $T
 L -^DIZ(4001.1,INDA)
 Q 1
 ;
 ;
RESOLV(INIEN) ; Resolve transaction and errors associated with it
 ;
 ; Description: The function RESOLV is used to set interface transac-
 ;  tions to a status of "COMPLETE".  It will update all 
 ;  pointers and cross-references within the interface 
 ;  files, and update the status to RESOLVED on errors 
 ;  linked to these transaction.
 ; Return: Each entry will be set to a status value:
 ;   0^error text
 ;   1^ien value
 ;
 ; Parameters:
 ; INIEN  =  Array of entry numbers.  
 ;
 ; Code begins: 
 N INUIF,INSTAT
 ; loop thru array
 S INUIF=0 F  S INUIF=$O(INIEN(INUIF)) Q:'INUIF  D  L -^INTHU(INUIF)
 . I '$D(^INTHU(INUIF,0)) S INIEN(INUIF)="0^Entry does not exist" Q
 . ;validate status of UIF entry
 . S INSTAT=$P($G(^INTHU(INUIF,0)),U,3)
 . I "^C^K^E"'[("^"_INSTAT) S INIEN(INUIF)="0^Status not COMPLETE, ERROR, or NEG ACK" Q
 . L +^INTHU(INUIF):0 E  S INIEN(INUIF)="0^Cannot lock entry" Q
 . ; mark complete and update log, resolve all errors
 . D ULOG^INHU(INUIF,"C","Marked complete by user "_$P(^DIC(3,DUZ,0),U)_" through API")
 . S INIEN(INUIF)="1^"_INUIF
 Q
 ;
