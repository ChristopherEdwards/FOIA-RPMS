INHUTC5 ;KN,bar; 26 Sep 97 22:03; Interface Message/Error Search 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;;COPYRIGHT 1997 SAIC
 ;
 ; Interface Message/Error Search Part II (INHUTC5)
 ; This sub-module contains functions FIND, MSGTEST, and ERRTEST. 
 Q
FIND(INQUIT,INOPT,INIEN,INSRCH) ; Build IEN message
 ;
 ; Description: Based on search type INSRCH("TYPE"), the function 
 ; FIND loops through global ^INTHU or ^INTHER from the date-start
 ; to date-end and calls MSGTEST or ERRTEST to build the list of 
 ; matching records.  The matching records will be stored
 ; in array INIEN.  FIND will stop depending on set parameters
 ; and return the stop reason.
 ;
 ; Parameters:
 ; INQUIT = Search status at stop (returned)
 ;  1  =  max found reached
 ;  2  =  max search reached
 ;  3  =  no more to search
 ;  4  =  user abort
 ;  error =  error text
 ; INOPT = Array of user defined options and run parameters
 ; INIEN = Array to store found records, pass by reference
 ;    used with indirection ie; @INIEN@(X) (returned)
 ; INSRCH = Array of search criteria, pass by reference
 ;    Optional.  Only needed if calling repeatedly
 ;    So values do not need to be rebuilt with each call
 ;
 N INA,IND,INM,INX,INFND,INTYPE,INFILE,INRVSRCH
 ; get search criteria values
 I '$D(INSRCH) S INQUIT=$$GATHER^INHUTC6($G(INOPT("CRITERIA")),.INSRCH) Q:'INQUIT
 ; setup file stuff, search starting point, listing direction
 S INTYPE=$G(INSRCH("TYPE")),INFILE=$G(INSRCH("FILENAME")),IND=$G(INSRCH("IND")),INRVSRCH=$S('INSRCH("INORDER"):-1,1:1)
 ; set counters and stop values
 S INSRCH("INSRCHCT")=$G(INOPT("INSRCHCT")),INSRCH("INFNDCT")=$G(INOPT("INFNDCT"))
 S INSRCH("FNDSTP")=$S($D(INOPT("MAXFND")):INSRCH("INFNDCT")+INOPT("MAXFND"),1:0)
 S INSRCH("SRCHSTP")=$S($D(INOPT("MAXSRCH")):INSRCH("INSRCHCT")+INOPT("MAXSRCH"),1:0)
 ; Loop through date/time
 S INQUIT=0 F  D  Q:INQUIT
 . S IND=$O(@INFILE@("B",IND),INRVSRCH) I 'IND S INQUIT=3 Q
 . ; check for stop dates
 . I (INRVSRCH>-1)&(IND>INSRCH("INEND")) S INQUIT=3 Q
 . I (INRVSRCH=-1)&(IND<INSRCH("INSTART")) S INQUIT=3 Q
 . ; loop thru entries
 . ; do not quit loop at this level. this value is not held
 . ; and entries will be skipped on next call.
 . S INM="" F  S INM=$O(@INFILE@("B",IND,INM),INRVSRCH) Q:'INM  D
 .. ; increment search count, check for stop
 .. S INSRCH("INSRCHCT")=INSRCH("INSRCHCT")+1
 .. I INSRCH("SRCHSTP"),INSRCH("INSRCHCT")'<INSRCH("SRCHSTP") S INQUIT=2
 .. ; test entry for match on criteria
 .. S INFND=0
 .. D:INTYPE="TRANSACTION" MSGTEST^INHUTC51(.INFND,INM,.INSRCH)
 .. D:INTYPE="ERROR" ERRTEST^INHUTC51(.INFND,INM,.INSRCH)
 .. ;IHS branch
 .. I '$$SC^INHUTIL1 D  Q
 ... Q:'INFND
 ... S INSRCH("INFNDCT")=INSRCH("INFNDCT")+1
 ... D SETTMP^INHUTC52(INM,.INSRCH)
 .. ; if found inc count, check for stop
 .. I INFND D
 ... S INSRCH("INFNDCT")=INSRCH("INFNDCT")+1
 ... I INSRCH("FNDSTP"),INSRCH("INFNDCT")'<INSRCH("FNDSTP") S INQUIT=1
 ... ; format the return string for entry INM
 ... I '$D(INOPT("DISPFORMAT")) S @INIEN@(INSRCH("INFNDCT"))=INM
 ... E  X INOPT("DISPFORMAT")
 .. ; Merge to ^Utility if memory is low
 .. I INIEN'["^",$S<INSRCH("SPACE") N INX S INX=INIEN,INIEN="^UTILITY(""INL"","_$J_")" K @INIEN M @INIEN=@INX K @INX,INX
 .. ; every 100 searched...
 .. I '(INSRCH("INSRCHCT")#100) D
 ... ; update search screen
 ... D:$D(DWLRF) DISPCNT
 ... ; allow user to abort on long search
 ... I $E(IOST)="C" R %#1:0 S:%="^" INQUIT=4
 ; update ListMan if needed
 I $D(DWLRF) S $P(@DWLRF,U,2)=$S(INQUIT>2:0,1:+INSRCH("INFNDCT")) D DISPCNT
 ; save off values for next call,return count to caller by setting values in INOPT
 S INSRCH("IND")=$S(INQUIT>2:"",1:IND),INOPT("INSRCHCT")=INSRCH("INSRCHCT"),INOPT("INFNDCT")=INSRCH("INFNDCT")
 I '$G(INOPT("NONINTER")) D
 . I INQUIT=4 D MS(INST_" Search Aborted.",1) Q
 . I INQUIT=3,INOPT("INFNDCT")=0 D MS("No "_INST_"s found that match critieria.",1)
 Q
 ;
DISPCNT ; display count on screen, called only from FIND
 D MS("SEARCHING...   Searched:"_$J(INSRCH("INSRCHCT"),8)_"  Found:"_$J(INSRCH("INFNDCT"),8))
 Q
 ;
MS(INX,INCR) ;print message on 23th line
 Q:'$$SC^INHUTIL1  ;Don't go here if IHS
 N DX,DY,% S DY=22,DX=0,DWDM=1 X DWXY,DIJC("N") W $E(INX,1,80)_$J("",IOM-$L(INX))
 I $G(INCR) S %=$$CR^UTSRD
 Q
 ;
