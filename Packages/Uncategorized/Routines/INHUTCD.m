INHUTCD ;KN; 4 Apr 97 12:14; Documentation Of The Criteria Mgmt And Exec. API
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;;COPYRIGHT 1997 SAIC
 ;
 ;
 ; General Description of parameters passed in INHUTC routines:
 ; input: INOPT - Array of options. Format: INOPT(OPTION)=VALUE (opt)
 ;            APP  = application area. Free text.
 ;            CONTROL = "S","U","SU","" Limits search to SYSTEM, USER
 ;                      BOTH or NEITHER. Default is BOTH. 
 ;            DUZ  = DUZ of user. Default is current DUZ value.
 ;            FUNC = functional area within application. Free text
 ;            GALLERY = Gallery to use for edit of criteria fields.
 ;                      Use "[]" for input template.
 ;            LOCK = 0 - Do not leave entry locked
 ;                   1 - Leave selected/edited entry locked on exit.
 ;               ("LOCK",ien) = Returned. # of incremental locks on ien
 ;            NAME = name or ien of criteria.  This will be used for
 ;                   lookup and save.  If interactive, this is default.
 ;            PROMPT = Prompt used for criteria selection
 ;            SELECTED = Returned.  Contains selected criteria
 ;            TYPE = "TRANSACTION", ERROR", OR "TEST". (required)
 ;
 Q
