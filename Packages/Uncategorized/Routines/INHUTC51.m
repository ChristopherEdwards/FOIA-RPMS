INHUTC51 ;KN,bar; 18 Jun 99 14:44; Interface Message/Error Search 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;;COPYRIGHT 1997 SAIC
 ;
 ; Interface Message/Error Search Part II (INHUTC5)
 ; This sub-module contains functions FIND, MSGTEST, and ERRTEST. 
 Q
 ;
MSGTEST(INFND,INMIEN,INSRCH)  ; Add matching message to array
 ; 
 ; Description:  Used to test a transaction in ^INTHU to
 ;  values passed in INSRCH parameter.    
 ; Parameters:
 ;    INFND    =  Flag indicates status of the test (returned)
 ;                    1 = match found
 ;                    0 = no match
 ;    INMIEN   =  IEN into ^INTHU
 ;    INSRCH   =  The array contains search criteria
 ;
 N INMSG0,INMAXSZ,INFLAGZ
 S INFND=0,INMSG0=$G(^INTHU(INMIEN,0))
 ; Test single and multiple values of the Original Transaction type
 I $D(INSRCH("INORIG")) Q:$P(INMSG0,U,11)'=INSRCH("INORIG")
 I $D(INSRCH("MULTIORIG")) S INQ=0 D  Q:'INQ
 .S X=0 F  S X=$O(INSRCH("MULTIORIG",X)) Q:'X  I $P(INMSG0,U,11)=X S INQ=1 Q
 ; Test single and multiple values of the Destination
 I $D(INSRCH("INDEST")) Q:$P(INMSG0,U,2)'=INSRCH("INDEST")
 I $D(INSRCH("MULTIDEST")) S INQ=0 D  Q:'INQ
 .S X=0 F  S X=$O(INSRCH("MULTIDEST",X)) Q:'X  I $P(INMSG0,U,2)=X S INQ=1 Q
 ; Test single and multiple values of the Status 
 I $D(INSRCH("INSTAT")) Q:$P(INMSG0,U,3)'=INSRCH("INSTAT")
 I $D(INSRCH("MULTISTAT")) S INQ=0 D  Q:'INQ
 .S X="" F  S X=$O(INSRCH("MULTISTAT",X)) Q:'$L(X)  I $P(INMSG0,U,3)=X S INQ=1 Q
 ; Test single and multiple values of the Division
 I $D(INSRCH("INDIV")) Q:$P(INMSG0,U,21)'=INSRCH("INDIV")
 I $D(INSRCH("MULTIDIV")) S INQ=0 D  Q:'INQ
 .S X=0 F  S X=$O(INSRCH("MULTIDIV",X)) Q:'X  I $P(INMSG0,U,21)=X S INQ=1 Q
 ; Test single value of the message ID, Source, User, Patient and Message Text
 I $D(INSRCH("INID")) Q:$P(INMSG0,U,5)'=INSRCH("INID")
 I $D(INSRCH("INDIR")) Q:$P(INMSG0,U,10)'=INSRCH("INDIR")
 I $D(INSRCH("INSOURCE")) Q:$E($P(INMSG0,U,8),1,$L(INSRCH("INSOURCE")))'=INSRCH("INSOURCE")
 I $D(INSRCH("INUSER")) Q:$P(INMSG0,U,15)'=INSRCH("INUSER")
 I $D(INSRCH("INPAT")) Q:'$$INMSPAT^INHMS1(INMIEN,INSRCH("INPAT"))
 I $D(INSRCH("INTEXT"))>9 Q:'$$INMSRCH^INHMS1(.INSRCH,INMIEN,INSRCH("INTYPE"))
 S INFND=1
 Q
 ;
ERRTEST(INFND,INEIEN,INSRCH)       ; Test for error matching criteria
 ;
 ; Description:  The function ERRTEST is used to test the error record
 ;  in ^INTHER (which pointed by INEIEN) for error to
 ;  values passed in INSRCH parameter.
 ; Parameters:
 ;    INFND    =  Flag indicates status of the test (returned)
 ;                    1 = match found
 ;                    0 = no match
 ;    INEIEN   =  IEN into ^INTHER
 ;    INSRCH   =  The array contains search criteria
 ;
 N INERR0,INMSG0,INMAXSZ,INMIEN
 S INFND=0,INERR0=$G(^INTHER(INEIEN,0))
 S INMIEN=$P(INERR0,U,4),INMSG0=$G(^INTHU(+INMIEN,0))
 Q:'INMIEN&$D(INSRCH("MESSAGEREQ"))
 ; Checking the Interface Error File
 ; Test single and multiple values of the Original Transaction type
 I $D(INSRCH("INORIG")) I $P(INERR0,U,2)'=INSRCH("INORIG"),($P(INMSG0,U,11)'=INSRCH("INORIG")) Q
 I $D(INSRCH("MULTIORIG")) S INQ=0 D  Q:'INQ
 . S X=0 F  S X=$O(INSRCH("MULTIORIG",X)) Q:'X  I ($P(INERR0,U,2)=X)!($P(INMSG0,U,11)=X) S INQ=1 Q
 ; Test single and multiple values of the Destination
 I $D(INSRCH("INDEST")) I $P(INERR0,U,9)'=INSRCH("INDEST"),($P(INMSG0,U,2)'=INSRCH("INDEST")) Q
 I $D(INSRCH("MULTIDEST")) S INQ=0 D  Q:'INQ
 . S X=0 F  S X=$O(INSRCH("MULTIDEST",X)) Q:'X  I ($P(INERR0,U,9)=X)!($P(INMSG0,U,2)=X) S INQ=1 Q
 ; Test single and multiple values of the Status
 I $D(INSRCH("INSTAT")) Q:$P(INMSG0,U,3)'=INSRCH("INSTAT")
 I $D(INSRCH("MULTISTAT")) S INQ=0 D  Q:'INQ
 . S X="" F  S X=$O(INSRCH("MULTISTAT",X)) Q:'$L(X)  I ($P(INMSG0,U,3)=X) S INQ=1 Q
 ; Test single and multiple values of the Division
 I $D(INSRCH("INDIV")) Q:$P(INMSG0,U,21)'=INSRCH("INDIV")
 I $D(INSRCH("MULTIDIV")) S INQ=0 D  Q:'INQ
 . S X=0 F  S X=$O(INSRCH("MULTIDIV",X)) Q:'X  I ($P(INMSG0,U,21)=X) S INQ=1 Q
 ; Test value of the Error Location, Error Resolution Status and Error Text to search
 I $D(INSRCH("INERLOC")) Q:$P(INERR0,U,5)'=INSRCH("INERLOC")
 I $D(INSRCH("INERSTAT")) Q:$P(INERR0,U,10)'=INSRCH("INERSTAT")
 I $D(INSRCH("INTEXT"))>9 Q:'$$INERSRCH^INHERR1(.INSRCH,INEIEN,INSRCH("INTYPE"))
 ; Checking the Interface Message file
 ; Test value of the Message Start Date and Message End Date
 I $D(INSRCH("INMSGSTART")) Q:($P(INMSG0,U)<INSRCH("INMSGSTART"))
 I $D(INSRCH("INMSGEND")) Q:($P(INMSG0,U)>INSRCH("INMSGEND"))
 ; Test value of the Message ID, Direction, User, Source and Patient
 I $D(INSRCH("INID")) Q:$P(INMSG0,U,5)'=INSRCH("INID")
 I $D(INSRCH("INDIR")) Q:$P(INMSG0,U,10)'=INSRCH("INDIR")
 I $D(INSRCH("INSOURCE")) Q:$E($P(INMSG0,U,8),1,$L(INSRCH("INSOURCE")))'=INSRCH("INSOURCE")
 I $D(INSRCH("INUSER")) Q:($P(INMSG0,U,15)'=INSRCH("INUSER"))&($P(INERR0,U,8)'=INSRCH("INUSER"))
 I $D(INSRCH("INPAT")) Q:'INMIEN  Q:'$$INMSPAT^INHMS1(INMIEN,INSRCH("INPAT"))
 S INFND=1
 Q
 ;
MSGSTD(INIEN) ; return the message standard for a given entry in the UIF
 ;
 ;    INIEN   =  IEN into ^INTHU
 ;
 N INMSG0,INORIGTT,INREP,INSCR
 S INIEN=$G(INIEN) Q:'INIEN ""
 S INMSG0=$G(^INTHU(INIEN,0)) Q:'$L(INMSG0) ""
 ; if incoming message, the parent message field points to the
 ; outgoing message
 I $P(INMSG0,U,10)="I" D  Q:'$L(INMSG0)!('INIEN) ""
 . S INIEN=$P(INMSG0,U,7) Q:'INIEN
 . S INMSG0=$G(^INTHU(INIEN,0))
 S INORIGTT=$P(INMSG0,U,11) Q:'INORIGTT ""
 S INSCR=$P($G(^INRHT(INORIGTT,0)),U,3) I 'INSCR D  Q:'INSCR ""
 . ; Special processing for replicated messages, if no script pointer
 . S INREP=$O(^INRHR("B",INORIGTT,"")) Q:'INREP
 . S INORIGTT=$P($G(^INRHR(INREP,0)),U,2) Q:'INORIGTT
 . S INSCR=$P($G(^INRHT(INORIGTT,0)),U,3)
 Q $P($G(^INRHS(INSCR,0)),U,7)
 ;
INNCPAT(INIEN,INPAT,INPATNA) ; Test msg. for a NCPDP patient match
 ;
 ; MODULE NAME: INNCPAT (Interface Message PATIENT Search for NCPDP msg)
 ; DESCRIPTION: Search ^INTHU( INIEN ) Pharm. claim message for matching
 ;               values to the string: INPAT. Using CHCS patient IEN for
 ;               outbound messages, and Pharmacy Prescription Number.
 ; RETURN = PASS/FAIL (1/0) and patient found set in INPATNAM 
 ; PARAMETERS:
 ;   INIEN   = The IEN of the message in the ^INTHU message file
 ;   INPAT   = The patients internal IEN from the ^DPT file
 ;   INPATNA = The patient name found in the message ("" if none)
 ;
 S INIEN=$G(INIEN),INPAT=+$G(INPAT),INPATNAM=$G(INPATNA)
 Q:'INIEN 0
 N INBLDCT,INBLDTXT,INRET,INRXNUM
 ; Pharmacy claim message is in line 3
 S INBLDTXT="",INBLDCT=2 D GETLINE^INHOU(INIEN,.INBLDCT,.INBLDTXT)
 Q:'$D(INBLDTXT) 0
 ; prescription number is the first field and is 7 bytes
 S INRXNUM=+$E(INBLDTXT,1,7),INRET=$$NCMATCH(INPAT,INRXNUM),INPATNAM=$P(INRET,U,2)
 Q INRET
 ;
NCMATCH(INPAT,INRXNUM) ; For a given RX number find a patient match
 ;
 ; Input: INPAT   (req) = IEN for the Patient
 ;        INRXNUM (req) = Prescription number from the NCPDP message
 ; Output: 1_"^"_Patient IEN, if match found
 ;         0, otherwise
 ;
 N INC0,INCPT,INCOLLEC,INDPT
 S INPAT=$G(INPAT) Q:'INPAT 0
 S INCOLLEC=$O(^PSM(8216,"B",INRXNUM,0)) Q:'INCOLLEC 0
 S INC0=$G(^PSM(8216,INCOLLEC,0)) Q:'$L(INC0) 0
 S INCPT=$P(INC0,U,5) S:INCPT INDPT=$P($G(^DPT(INCPT,0)),U)
 Q:INPAT=INCPT 1_"^"_INDPT
 Q 0
