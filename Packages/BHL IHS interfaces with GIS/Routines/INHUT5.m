INHUT5 ;JPD,KAC; 6 Feb 96 13:25;utilities 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
 ;
INITIALS(X) ;Make initials from name
 ; Input: X (req) = name from which to extract initials
 ;                  format : LAST,FIRST MIDDLE
 ; Output: returns initials
 Q $E($P(X,",",2))_$E($P(X," ",2))_$E(X)
NUM(X) ;--Converts a string to a number
 ; Input - X - String
 ; Returns - Numeric value
 N I,Y
 S Y="" F I=1:1:$L(X) S:"-.0123456789"[$E(X,I) Y=Y_$E(X,I)
 Q +Y
RPTFOOT() ;Report Footer
 F  Q:$Y'<($G(IOSL)-5)  W !
 W !,?IOM/2-11,"*** End of Report ***"
 I $E(IOST)="C" W ! I $$CR^UTSRD
 Q ""
DATIM() ;date/time function
 ; Returns: Y - Date/time
 N Y,%,%H,%I,X
 D NOW^%DTC S Y=% D DD^%DT
 Q Y
 ;
MUMPS ; Input transform for Selective Routing M Code free text fields (SRMC).
 ; Customized input transform adds ability to check for application
 ; team code that uses argumentless Locks or Kills.
 ;
 ; Input:
 ; X = value input by user
 ;
 ; Output:
 ; Kill X if value entered doesn't meet restrictions imposed by 
 ; transform.
 ;
 Q:'$D(X)
 ; disallow argumentless Locks
 I (X?1"L"." ")!(X?.E1" "1"L"2" ".E)!(X?.E1" "1"L"." ")!(X?1"LOCK"." ")!(X?.E1" "1"LOCK"2" ".E)!(X?.E1" "1"LOCK"." ") K X Q
 ; disallow argumentless Kills
 I (X?1"K"." ")!(X?.E1" "1"K"2" ".E)!(X?.E1" "1"K"." ")!(X?1"KILL"." ")!(X?.E1" "1"KILL"2" ".E)!(X?.E1" "1"KILL"." ") K X Q
 I $$SC^INHUTIL1 D MUMPS^DIED ; validate M syntax
 ;;Modified for IHS to call DIM directly
 I '$$SC^INHUTIL1 D ^DIM
 Q
 ;
FINDRID(INSRDATA,INDEST) ; $$function - Determine if there is a match of
 ; RouteID in 1st subscript of INSRDATA array
 ; Input:
 ; INSRDATA - array of RouteID nodes to be checked with Destination Route ID table
 ; INDEST   - INTERFACE DESTINATION IEN containing list of RouteIDs to ck
 ;
 ; Output:
 ; 1: Match NOT-FOUND
 ; 0: Match FOUND
 ;
 N %,FNDDEST
 ; Loop through INSRDATA("RouteID") using "B" xref to identify a match in
 ; the destination's Route ID table
 S FNDDEST=1,%="" F  S %=$O(INSRDATA(%)) Q:'$L(%)  I $O(^INRHD(INDEST,9,"B",%,0)) S FNDDEST=0 Q
 Q FNDDEST
 ;
RCVSCRN(INSRCTL,INSRDATA,INA,INDA) ; Default Inbound Receiver screen.
 ; Provides screening logic based on minimum requirements for 
 ; accepting a message at the Receiver process.
 ;
 ; Logic: If Receiving Facility field in MSH of inbound msg matches
 ; a Route ID entry for this inbound destination, accept msg into
 ; database, else, suppress receipt of msg.
 ;
 ; Called by: Application entry point (RCVSCRN^INHUT).
 ;            D RCVSCRN^INHUT5(.INSRCTL,.INSRDATA,.INA,.INDA)
 ;
 ; Input:
 ; INSRCTL  - array - screening logic control information
 ;   "INTT"     - (opt) INTERFACE TRANSACTION IEN for inbound msg
 ;   "INDEST"   - (req) INTERFACE DESTINATION IEN for inbound msg
 ;   "INBPC"    - (opt) BACKGROUND PROCESS CONTROL IEN for inbound msg
 ;   "MSH"      - (req) HL7 Message Header (MSH) string (not parsed)
 ;                      from inbound msg
 ; INA      - (opt) Not used.
 ; INDA     - (opt) Not used.
 ;
 ; Variables:
 ; INDELIM  - HL7 Field Separator for inbound msg
 ; INRCVFAC - HL7 Receiving Facility field from inbound msg
 ;
 ; Output:
 ; INSRDATA - (pbr) array - screening logic return values
 ;                  false = receive msg into database
 ;                  true  = suppress receipt of msg
 ;   "Route ID" - identifies system to which to route msg.  Multiple
 ;                entries are allowed.
 ;
 N INDELIM,INRCVFAC
 K INSRDATA
 I '$L($G(INSRCTL("MSH"))) S INSRDATA=0 Q  ; no MSH - receive msg
 ;
 ; get Receiving Facility field from msg
 S INDELIM=$E(INSRCTL("MSH"),4)
 S INRCVFAC=$P(INSRCTL("MSH"),INDELIM,6)
 ;
 I $L(INRCVFAC) S INSRDATA(INRCVFAC)="" Q  ; return Route ID for lookup
 ;
 ; Receiving Facility = ""
 ; 1) no DEST - receive msg
 ; 2) Route IDs exist - suppress msg
 ;    NO Route IDs - receive msg
 S INSRDATA=$S('$G(INSRCTL("INDEST")):0,1:$D(^INRHD(INSRCTL("INDEST"),9,"B")))
 Q
 ;
