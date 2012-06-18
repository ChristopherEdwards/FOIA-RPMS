ABSPECA8 ; IHS/FCS/DRS - construct a claim reversal ;   [ 11/18/2002  10:07 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,4,7,9,10,12**;JUN 21, 2001
 Q
 ; The way we build the claim reversal is to take the source data
 ; from the original claim (IEN) and position therein (RX).
 ; $$ returns pointer to 9002313.02 of the new entry.
 ;
 ; Future:  want to use new database server calls to create the
 ; 9002313.02 entry.  It would be soooo much cleaner.
 ;
 ; Remember, you have two 401 fields - one in header, one in prescript.
 ;
 ;IHS/SD/lwj 08/15/02 NCPDP 5.1 changes
 ; There are new fields to consider in the 5.1 reversal process, in
 ; addition to a new value for the transaction code (noe B2 as opposed
 ; to 11 in 3.2).
 ; Changes made as needed.
 ;
 ;IHS/SD/lwj 10/23/02 NCPDP 5.1 changes
 ; New code added to account for a mixed reversal.  A mixed reversal is 
 ; a claim that was created in 3.x format & needs to be reversed in 5.1
 ; format.  This requires field reformatting.
 ;
 ;--------------------------------------------------------
 ;IHS/SD/lwj 10/08/03  ACS requires new flds for the reversal.
 ; (ACS currently processes for Nebraska Medicaid, New Mexico
 ;  Medicaid, Colorado Medicaid, Washington Medicaid and
 ;  Mississippi Medicaid.)
 ; Needed to add fields 301, 302, 306, 309, 312, 313 405, 406, 
 ; 414, and 442 to the reversal process.
 ;--------------------------------------------------------
 ;IHS/SD/lwj 1/16/03 NCPDP 5.1 changes  Patch 9
 ;  New code added to account for newer reversal requirements
 ;  for Catalyst Rx and Medtrak.
 ; Fields 303, 304, 305, 310 and 311 added.
 ;--------------------------------------------------------
 ;IHS/SD/lwj 3/16/04 patch 10 NCPDP 5.1 changes
 ; Two new fields needed for the reversal process at the
 ; "detail" level - fields are 461 and 462.
 ; (Used on Procare format.)
 ;--------------------------------------------------------
 ;IHS/SD/lwj 6/23/05 patch 12 NCPDP 5.1 changes
 ; 331 patient id qualifier  332 patient id
 ; added for NMHCRX reversals
 ;--------------------------------------------------------
REVERSE(IEN,RX)  ;EP - from ABSPOS6D, ABSPOSC2
 ; IEN=original claim, RX = prescription # subscript therein
 ; returns IEN of the reversal claim created
 ;
 ; extract needed data
 N CLAIM,RXMULT S CLAIM=9002313.02,RXMULT=9002313.0201 ; file #s
 N DIC,DR,DA,DIQ,TMP,I,X
 ; This field list is repeated below.
 S DIC=CLAIM
 ;
 ;IHS/SD/lwj 1/16/03 new fields needed for Catalyst RX and Medtrak 5.1
 ; nxt line remarked out, following line added (patch 9)
 ;S DR=".01;.02;.03;1.01;1.02;1.03;101;102;103;104;109;110;201;202;301;302;306;309;312;313;400;401"
 ; IHS/SD/lwj 6/23/05 patch 12 nxt ln rmkd out, following added
 ;S DR=".01;.02;.03;1.01;1.02;1.03;101;102;103;104;109;110;201;202;301;302;303;304;305;306;309;310;311;312;313;400;401"
 S DR=".01;.02;.03;1.01;1.02;1.03;101;102;103;104;109;110;201;202;301;302;303;304;305;306;309;310;311;312;313;331;332;400;401"
 S DA=IEN
 S DIQ="TMP",DIQ(0)="I"
 ; This field list is repeated below.
 ; It needs to include all the fields that are used in any reversal
 ; format anywhere.  
 ;
 ;IHS/SD/lwj 8/15/02 NCPDP 5.1 new fields need to be used
 ; nxt line remarked out, following 2 lines added
 ;S DR(RXMULT)=".01;401;402;418;438;439;440;441",DA(RXMULT)=RX
 ;
 ;IHS/SD/lwj 10/08/03 new flds needed for NB Medicaid reversal
 ;nxt line remarked out, following added - flds 405/406/414,442
 ;S DR(RXMULT)=".01;308;401;402;403;407;418;420;436;438;439;440;441;455"
 ;IHS/SD/lwj 03/16/04 patch 10 nxt line remkd out, next line added
 ;S DR(RXMULT)=".01;308;401;402;403;405;406;407;414;418;420;436;438;439;440;441;442;455"
 S DR(RXMULT)=".01;308;401;402;403;405;406;407;414;418;420;436;438;439;440;441;442;455;461;462"
 S DA(RXMULT)=RX
 ;ZW DIC,DR,DA,DIQ
 D EN^DIQ1
 ;
 ;IHS/SD/lwj 10/23/02 NCPDP 5.1 changes
 ; check for a mixed claim (3.x claim - 5.1 reversal)-reformat if needed
 ;
 D:TMP(CLAIM,IEN,102,"I")[3 CKVERS
 ;
 ;IHS/SD/lwj 10/23/02 end mixed claim check
 ;
 ;ZW TMP
 ; create a new 9002313.02 record
 N DIC,X,DLAYGO,REVIEN,Y,UERETVAL
R2 S DIC=9002313.02,DIC(0)="LX",X=TMP(9002313.02,IEN,.01,"I")_"R"_RX
 S DLAYGO=CLAIM
 D ^DIC S REVIEN=+Y I REVIEN<1 D  G:UERETVAL R2
 . S UERETVAL=$$IMPOSS^ABSPOSUE("FM,P",,"call to ^DIC",,,$T(+0))
 ;ZW REVIEN
R4 ; create a new prescription multiple therein
 S DIC="^ABSPC("_REVIEN_",400,",DIC(0)="LX"
 S DIC("P")=$P(^DD(CLAIM,400,0),U,2)
 S DA(1)=REVIEN,DLAYGO=RXMULT
 S X=1 D ^DIC I +Y'=1 D  G:UERETVAL R4
 . S UERETVAL=$$IMPOSS^ABSPOSUE("FM,P",,"call to ^DIC","for multiple",,$T(+0))
 ;ZW Y
 ; set data values
 N DIE
 S DIE=CLAIM,DA=REVIEN
 S TMP(CLAIM,IEN,103,"I")=11 ; change transaction code to REVERSAL
 ;
 ;IHS/SD/lwj 8/15/02 NCPDP 5.1 changes
 ; if the version is 5.1, the transaction code needs to be B2 not 11
 ; following line added
 S:TMP(CLAIM,IEN,102,"I")[5 TMP(CLAIM,IEN,103,"I")="B2"
 ;
 ;IHS/SD/lwj 11/18/02 NCPDP 5.1 changes
 ; when it's a 5.1 reversal, we ALWAYS want the transaction code
 ; (fld 109) to be a 1 - ALWAYS
 ; next line added
 S:TMP(CLAIM,IEN,102,"I")[5 TMP(CLAIM,IEN,109,"I")=1
 ;
 ; Must agree with field list above.
 ;IHS/SD/lwj 8/15/02 NCPDP 5.1 new fields need to be used
 ; nxt line remarked out, following 2 lines added
 ;
 ;S DR="" N I F I=.02,.03,1.01,1.02,1.03,101,102,103,104,201,401 D
 S DR="" N I
 ;
 ;IHS/SD/lwj 10/08/03 new flds for NB Medicaid 
 ; nxt line remarked out - following line added
 ;F I=.02,.03,1.01,1.02,1.03,101,102,103,104,109,110,201,202,401 D
 ;IHS/SD/lwj 1/16/03 new fields for Catalyst and Medtrak
 ; nxt line remarked out - following line added  patch 9
 ;F I=.02,.03,1.01,1.02,1.03,101,102,103,104,109,110,201,202,301,302,306,309,312,313,401 D
 ;IHS/SD/lwj 6/23/05 patch 12 nxt ln rmkd out, following added
 ;F I=.02,.03,1.01,1.02,1.03,101,102,103,104,109,110,201,202,301,302,303,304,305,306,309,310,311,312,313,401 D
 F I=.02,.03,1.01,1.02,1.03,101,102,103,104,109,110,201,202,301,302,303,304,305,306,309,310,311,312,313,331,332,401 D
 .S DR=DR_I_"////"_TMP(CLAIM,IEN,I,"I")_";"
 S DR=DR_".04////2" ; transmit flag - it's 2 for POS
 D ^DIE
 S DIE="^ABSPC("_REVIEN_",400,"
 S DA(1)=REVIEN,DA=1,DR=""
 ; Must agree with field list above
 ;IHS/SD/lwj 8/15/02 NCPDP 5.1 new fields need to be used
 ; nxt line remarked out, following 2 lines added
 ;
 ;F I=401,402,418,438,439,440,441 D
 ;IHS/SD/lwj 10/08/03 new flds needed for NB Medicaid
 ;nxt line rmked out, following added (flds 405/406/414/442)
 ;F I=308,401,402,403,407,418,420,436,438,439,440,441,455 D
 ;IHS/SD/lwj 3/16/04 patch 10 nxt line remkd out, line added
 ;F I=308,401,402,403,405,406,407,414,418,420,436,438,439,440,441,442,455 D
 F I=308,401,402,403,405,406,407,414,418,420,436,438,439,440,441,442,455,461,462 D
 .S DR=DR_I_"////"_TMP(RXMULT,RX,I,"I")_";"
 S DR=$E(DR,1,$L(DR)-1) ; get rid of extra trailing ";"
 D ^DIE
 ; 
 Q REVIEN
 ;
CKVERS ;check the version of the current format - if it's 5.1 then we've hit a
 ; "mixed claim."  (Originally created in 3.2 - reverse in 5.1)
 ;
 N ABSPINS,ABSPFORM,ABSPVER,ABSPCFRM
 S (ABSPINS,ABSPFORM,ABSPVER,ABSPCFRM)=""
 ;
 S ABSPINS=TMP(9002313.02,IEN,.02,"I")
 Q:ABSPINS=""
 ;
 S ABSPCFRM=$P($G(^ABSPEI(ABSPINS,100)),U)  ;claim format
 Q:ABSPCFRM=""
 ;
 S ABSPFORM=$P($G(^ABSPF(9002313.92,ABSPCFRM,"REVERSAL")),U)
 Q:ABSPFORM=""
 ;
 S ABSPVER=$P($G(^ABSPF(9002313.92,ABSPFORM,1)),U,2)
 I ABSPVER[5 D
 . S TMP(9002313.02,IEN,102,"I")=51
 . D REFORM^ABSPOSHR(ABSPFORM)
 ;
 Q
