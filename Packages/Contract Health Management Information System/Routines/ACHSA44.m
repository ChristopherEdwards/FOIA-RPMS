ACHSA44 ; IHS/ADC/GTH - ENTER DOCUMENTS (5/8)-(CAN) ;  
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ;Get the common accounting number and validate.  That's all
 ;
 W !!,"in test version",!!
 ;
 D SETUP
 ;
 ;if the maintenance is not complete, say so and quit
 I 'OK W *7,!!,"CHS COST CENTER TABLE INCOMPLETE.",! W:ACHSF638'="Y" !,"Must have Cost Centers 568, 573, and 574." Q
 ;
 D MAKLST
 I '$D(CANLIST) W *7,!!,"There are no CHS COMMON ACCOUNTING NUMBERs for this facility.",!!,"Please contact your Site Manager.",!,*7 Q
 ;
 D A1
 I $G(ACHSQUIT) Q
 ;
 G ^ACHSA5
 ;
A1 ;EP
 ;get the common accounting number
 ;
 W !!,"Enter last 4 digits of the CAN Number: "
 I ACHSCAN,$D(^ACHS(2,ACHSCAN,0)) S ACHSCC=$P($G(^ACHS(2,ACHSCAN,0)),U,2) W $P($G(^ACHS(2,ACHSCAN,0)),U),"// "
 D READ^ACHSFU
 ;
 ;back from read.  handle the input.
 ;
 ;told to quit?
 G A3^ACHSA:$D(DUOUT)
 I $G(ACHSQUIT) Q
 ;
 ;asked for list
 I Y?1"?".E D LIST G A1
 ;
 ;no response
 I Y="",(ACHSCAN="") W *7,"  Must Have CAN Number" G A1
 ;
 ;if they entered four numbers, put the prefix on the front
 I Y?4N S Y=ACHSPREF_Y
 ;
 ;if they entered a sequence number related to the list, get the code
 I Y?1N.N,$D(CANLIST(Y)) S Y=$P(CANLIST(Y),U,2)
 ;
 ;validate the entry
 D VALID
 ;
 ;not okay?  try again
 I 'OK G A1
 ;
 Q
 ;
VALID ;
 ;validate the input
 ;
 S OK=0
 I '$D(CANLIST(0,Y)) W " Invalid entry" Q
 S ACHSCAN=$P(CANLIST(0,Y),U,2)
 S SEQ=$P(CANLIST(0,Y),U,1),ACHSCC=$P(CANLIST(SEQ),U,3)
 S OK=1
 ;
 Q
 ;
LIST ;
 W !!,"SEQ NO",?10,"FY",?15,"CAN NUMBER",?30,"DESCRIPTION OF THE CAN NUMBER",!,"------",?10,"--",?15,"----------",?30,"-----------------------------"
 S SEQ=0 F  S SEQ=$O(CANLIST(SEQ)) Q:SEQ=""  D
 . S DATA=CANLIST(SEQ)
 . W !,?(3-$L(SEQ)),SEQ,?10,$P(DATA,U,1),?15,$P(DATA,U,2),?30,$P(DATA,U,4)
 . Q
 Q
 ;
SETUP ;
 ;set some basic vars, and check for the minimum
 ;amount of maintenance
 K OK
 ;
 S ACHS573=$O(^ACHS(1,"B",573,0)),ACHS568=$O(^ACHS(1,"B",568,0))
 S ACHS574=$O(^ACHS(1,"B",574,0)),ACHS575=$O(^ACHS(1,"B",575,0))
 S ACHS533=$O(^ACHS(1,"B",533,0))
 S ACHSF638=$P($G(^ACHSF(DUZ(2),0)),U,8)
 ;
 ;set the prefix for the CANs.  This is stored in the AREA data.
 ;if you are not used to these globals, this line looks long and
 ;confusing, but all it's doing is using the facility code as a
 ;subscript to the LOCATION file.  It gets the fourth piece of
 ;that as a subscript to the AREA file, where piece 4 is the prefix
 S ACHSPREF=$P($G(^AUTTAREA($P($G(^AUTTLOC(DUZ(2),0)),U,4),0)),U,4)
 ;
 ;we have to have at least these three cans, unless we are
 ;a 638 facility, in which case we have to have at least one
 ;can, regardless of what it is.
 I ACHS573,ACHS568,ACHS574 S OK=1
 I ACHSF638="Y",$D(^ACHS(1,"B")) S OK=1
 Q
 ;
MAKLST ;
 ;create list of all CAN numbers valid for this case.
 ;validity is decided by several factors, including:
 ;  is the can for this facility, is the year of the can
 ;  fit the year of the service, does the service type
 ;  (in, out, dental) match the service ordered.
 ;
 ;the advantage of this is that if users asks for a list,
 ;we are only showing them valid ones, not all CANs defined.
 ;It also allows for a much simpler and shorter validation
 ;process.
 ;
 K CANLIST N CSTCEN,YEAR,EIN,DATA,OK,SEQ
 ;
 ;look through the Fiscal Year cross reference for CANs to
 ;validate.  The hard part is that some IDIOT changed the
 ;format of the fiscal year from 2 digits to 4, but left
 ;all of the 2 digit ones out there.  So we have to be
 ;ready for either format
 ;
 ;also, we qualify by fiscal year two ways.  if we are using
 ;multi year CANs (site parm 2,24) or if we don't have the
 ;ACHSMGR key, the fiscal year of the can has to be this year
 ;or last.
 ;
 ;the list has two parts.  
 ;    list(0,code1)=seq1_U_...
 ;    list(0,code2)=seq2_U_...
 ;    ... and so on
 ;    list(seq1)=code1_U_...
 ;    ... and so on
 ;
 ; the listing by sequence number is used to write the list to the
 ; screen.  The zero node is used for quick validation of the entry.
 ; the list is defined in detail further down
 ;
 S EIN=0 F  S EIN=$O(^ACHS(2,EIN)) Q:EIN=""  Q:'EIN  D
 . S DATA=$G(^ACHS(2,EIN,0)) I DATA="" Q
 . ;got a can.  first check the facility
 . I $P(DATA,U,3)'=DUZ(2) Q
 . ;is it expired?
 .  I $P(DATA,U,4)'="",($P(DATA,U,4)<DT) Q
 . ;
 . ;if the parm for multi year cans is on, OR
 . ;this user does not have security for ACHSZMGR, AND
 . ;the fiscal year is more than a year ago, stop
 . I $$PARM^ACHS(2,24)="Y"!'($D(^XUSEC("ACHSZMGR",DUZ))) D
 .. ;check the year
 .. Q
 . ;
 . S CSTCEN=$P(DATA,U,2)
 . I ACHSF638'="Y" S OK=0 D MAKLST1 I 'OK Q
 . ;if we got this far, this can is valid
 . ;the canlist has this format
 . ; canlist(0,CAN)           = sequence num^EIN
 . ; canlist(sequence number) = 
 . ;         fy^CAN^cc^ccd^expdate^EIN
 . ;    piece 1         fiscal year
 . ;    piece 2         CAN number
 . ;    piece 3         cost center
 . ;    piece 4         cost center description
 . ;    piece 5         expiration date
 . ;    piece 6         subscript for ^ACHS(2,EIN,0)
 . ;
 . ; not all of these pieces are used right now, but they are
 . ; here so as to be handy
 . ;
 . S CAN=$P(DATA,U,1)
 . S SEQ=$G(SEQ)+1,CANLIST(SEQ)=$G(TYEAR)_U_DATA_U_EIN
 . ; now go get the cost center description and place into piece 4
 . S DATA=$G(^ACHS(1,$P(DATA,U,2),0)),$P(CANLIST(SEQ),U,4)=$P(DATA,U,2)
 . ; finally, set the 0 node
 . S CANLIST(0,CAN)=SEQ_U_EIN
 . Q
 Q
 ;
MAKLST1 ;
 ;if this is not a 638 fac, we come here.  now make sure that
 ;the cost center matches the service type
 I ACHSTYP=1,(CSTCEN'=ACHS573),(CSTCEN'=ACHS575),(CSTCEN'=ACHS533) Q
 I ACHSTYP=2,(CSTCEN'=ACHS568) Q
 I ACHSTYP=3,(CSTCEN=ACHS568) Q
 S OK=1
 Q
