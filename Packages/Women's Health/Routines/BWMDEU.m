BWMDEU ;IHS/ANMC/MWR - MDE FUNCTIONS.;29-Oct-2003 21:34;PLS
 ;;2.0;WOMEN'S HEALTH;**8,9**;MAY 16, 1996
 ; CDC Export functions to retrieve data for individual fields.
 ;
 ;
RACE(BWDFN,MDEVER,MDERACE) ; EP - CDC's MDE Race classification.
 ; Call with  BWDFN = ien of patient in file PATIENT (#9000001)
 ;           MDEVER = version number of CDC Minimum Data Extraction (MDE)
 ;
 ; Returns  MDERACE = MDE Race classification based on MDE version number (passed by reference).
 ;                    Contains array of all races reported by patient
 ;
 N BWIEN,CODE,I,TRIBE
 ;
 ; Build array of race code for patient's designated races
 S I=0
 F  S I=$O(^BWP(BWDFN,2,I)) Q:'I  D
 . S BWIEN=+^BWP(BWDFN,2,I,0)
 . S CODE=$O(^BWRACE(BWIEN,1,"AC",MDEVER,0))
 . I CODE S MDERACE(I)=CODE
 ;
 ; If no race designated then return a CDC MDE Race code based on tribal relationship
 ;  ***These relationships should moved to a table. ***
 I '$O(MDERACE(0)) D
 . S TRIBE=$P($G(^AUPNPAT(BWDFN,11)),U,8),BWIEN=0
 . I TRIBE D
 . . I "^1^215^219^220^"[(U_TRIBE_U) S BWIEN=6 Q  ; Other
 . . I "^206^207^208^209^210^212^213^217^"[(U_TRIBE_U) S BWIEN=3 Q  ; Asian
 . . I TRIBE=211 S BWIEN=4 Q  ; Native Hawaiian/Pacific Islander
 . . I TRIBE=214 S BWIEN=1 Q  ; White
 . . I TRIBE=216 S BWIEN=2 Q  ; Black
 . . S BWIEN=5 ; American Indian/Alaska Native
 . I BWIEN D
 . . S CODE=$O(^BWRACE(BWIEN,1,"AC",MDEVER,0))
 . . I CODE S MDERACE(1)=CODE
 ;
 ; If no race designated then return 'unknown' for corresponding MDE version
 I '$O(MDERACE(0)) D
 . S CODE=$O(^BWRACE(7,1,"AC",MDEVER,0))
 . I CODE S MDERACE(1)=CODE
 Q
 ;
 ;
HISP(BWDFN) ; EP - Determine Hispanic/Latino origin
 ; Call with BWDFN = ien of patient in file PATIENT (#9000001)
 ; Returns     BWY = 1 (yes), 2 (no), 3 (unknown)
 ;
 N BWY,TRIBE
 S TRIBE=$P($G(^AUPNPAT(BWDFN,11)),U,8)
 I TRIBE=215 S BWY=1
 E  S BWY=3
 Q BWY
 ;
 ;
BSU(BWDT,SITE) ; EP - Determine Bethesda System Used
 ; Call with BWDT = "as of" date to check
 ;           SITE = site to check (pointer to BW SITE PARAMETER file #9002086.02)
 ;
 ; Returns  BWBSU = 1 (Bethesda 1991)
 ;                  2 (Bethesda 2001)
 ;
 N BWBSU,X
 ;
 S X=$G(^BWSITE(SITE,.51))
 I $P(X,"^",2),BWDT'<$P(X,"^",2) S BWBSU=2
 E  S BWBSU=1
 ;
 Q BWBSU
 ;
 ;
SAPT(BWIEN,BWBSU,BWMDEV) ; EP - Specimen Adequacy of Pap Test
 ; Call with BWIEN = ien of entry in file BW PROCEDURE (#9002086.1)
 ;           BWBSU = Bethesda System Used
 ;          BWMDEV = MDE version
 ;
 ; Returns   BWSAPT = Specimen adequacy based on Bethesda system used
 ;
 N BWPDT,BWSAPT
 ;
 ; Specimen adequacy not collected under versions of MDE prior to 5.0
 I BWMDEV<50 S BWSAPT=" "
 ;
 ; Need to code for Bethesda 2001 and collected after 10/01/02.
 I BWMDEV=50 D
 . S BWSAPT=$P($G(^BWPCD(BWIEN,.3)),"^")
 . S BWPDT=$P($G(^BWPCD(BWIEN,0)),"^",12)
 . I BWBSU=2,BWSAPT=2 S BWSAPT=1 Q  ; code 2 only for Bethesda 1991
 . I BWPDT>3020930,BWSAPT="" S BWSAPT=4 Q  ; default to 4-unknown when none entered.
 ;
 Q BWSAPT
 ;
 ;
POTHR(BWIEN,BWBSU,BWRPT) ; EP - Text results of Pap Test
 ; Call with BWIEN = ien of entry in file BW PROCEDURE (#9002086.1)
 ;           BWBSU = Bethesda system used
 ;           BWRPT = Results of Pap Test
 ;
 ; Return    BWRES = Pap test text results when result = other
 ;
 N BWRES,X,Y
 S BWRES="",X=+$P($G(^BWPCD(BWIEN,0)),"^",5),Y=""
 I X S Y=$P($G(^BWDIAG(X,0)),"^")
 ;
 I BWBSU=1,BWRPT=7 S BWRES=$E(Y,1,20)
 I BWBSU=2,BWRPT=8 S BWRES=$E(Y,1,20)
 ;
 Q BWRES
 ;
 ;
PSCRDT(BWDT,BWBSU,BWRPT) ; EP - Return date of Pap Test
 ; Call with BWDT = date of Pap test
 ;          BWBSU = Bethesda system used
 ;          BWRPT = results of Pap test
 ;
 ; Returns  BWPDT = date of Pap test in MDE date format
 ;
 N BWPDT,FLAG
 S FLAG=1
 ;
 I BWBSU=1,BWRPT>8,BWRPT<11 S FLAG=0
 I BWBSU=2,BWRPT>8,BWRPT<11 S FLAG=0
 ;
 I FLAG,BWDT S BWPDT=$TR($$FMTE^XLFDT(BWDT,"5DZ"),"/")
 E  S BWPDT=$$REPEAT^XLFSTR(" ",8)
 Q BWPDT
 ;
 ;
PRESLT(BWIEN,BWBSU) ; EP - Results of Pap Test
 ; Call with BWIEN = ien of entry in file BW PROCEDURE (#9002086.1)
 ;           BWBSU = Bethesda system used (1-Bethesda 1991) (2-Bethesda 2001)
 ;
 ; Return    BWRESLT = result of Pap test based on Bethesda system used
 ;
 ;
 N BWRESN,BWRESLT
 ;
 S BWRESN=$P($G(^BWPCD(BWIEN,0)),"^",5),BWRESLT=""
 ; If no result, return 11 (Result pending).
 I 'BWRESN S BWRESLT=11
 ;
 ; Return CDC code for the result.
 I BWRESN D
 . I BWBSU=1 S BWRESLT=$P($G(^BWDIAG(BWRESN,0)),"^",24) Q
 . I BWBSU=2 S BWRESLT=$P($G(^BWDIAG(BWRESN,1)),"^",1)
 ;
 I BWRESLT,BWRESLT<10 S BWRESLT=$$RJ^XLFSTR(BWRESLT,2,"0")
 ;
 Q BWRESLT
 ;
 ;
PABN(BWBSU,BWPRESLT) ; EP - Abnormal Pap Flag
 ; Call with BWBSU = Bethesda system used (1-Bethesda 1991) (2-Bethesda 2001)
 ;        BWPRESLT = results of Pap test
 ;
 ; Return   BWPABN = 1-yes, 2-no
 ;
 N BWPABN
 S BWPABN=""
 I BWBSU=1 D
 . I BWPRESLT=11 S BWPABN=0 Q
 . I BWPRESLT=14 S BWPABN=1 Q
 . I "3456"[BWPRESLT S BWPABN=1 Q
 . S BWPABN=0
 I BWBSU=2 D
 . I BWPRESLT=11 S BWPABN=0 Q
 . I "4567"[BWPRESLT S BWPABN=1 Q
 . S BWPABN=0
 ;
 Q BWPABN
 ;
 ;
PPAY(BWBSU,BWPRESLT) ; EP - Pap paid for by NBCCEDP funds
 ; Call with BWBSU = Bethesda system used (1-Bethesda 1991) (2-Bethesda 2001)
 ;        BWPRESLT = results of Pap test
 ;
 ; Return   BWPPAY = 1-yes, 2-no, 3=unknown
 ;
 N BWPPAY
 S BWPPAY=1
 I BWBSU=1 D
 . I BWPRESLT>8,BWPRESLT<12 S BWPPAY="" Q
 . I BWPRESLT>11,BWPRESLT<14 S BWPPAY=2
 I BWBSU=2 D
 . I BWPRESLT>8,BWPRESLT<12 S BWPPAY="" Q
 . I BWPRESLT>11,BWPRESLT<14 S BWPPAY=2
 Q BWPPAY
 ;
 ;
PWKUP(BWIEN,BWBSU,BWPRESLT) ; EP - Diagnostic workup 1=PLANNED, 2=NOT PLANNED, 3=UNDETERMINED.
 ; Call with BWIEN = ien of entry in file BW PROCEDURE (#9002086.1)
 ;           BWBSU = Bethesda system used (1-Bethesda 1991) (2-Bethesda 2001)
 ;        BWPRESLT = result of Pap test
 ;
 ; Return  BWPWKUP = CDC code for diagnostic workup
 ;
 N BWPWKUP,X
 ;
 I BWBSU=1,BWPRESLT=11 S BWPWKUP=3
 I BWBSU=2,BWPRESLT=11 S BWPWKUP=3
 S X=$P($G(^BWPCD(BWIEN,2)),"^",20)
 I X S BWPWKUP=X
 E  S BWPWKUP=2
 Q BWPWKUP
 ;
 ;
MPREVDT(BWIEN) ; EP - Retrieve date of previous mammogram if any in CDC MDE date format
 ; Call with BWIEN = ien of entry in file BW PROCEDURE (#9002086.1)
 ;
 ; Return    BWMDT = date of mammogram in CDC MDE date format (MMYYYY)
 ;
 N BWMAM,BWMDT,BWI,CUTOFF,DFN,N,X,Y
 ;
 ; Look for previous mammograms (ien 25, 26, or 28)
 S X=$G(^BWPCD(BWIEN,0))
 S DFN=+$P(X,"^",2),CUTOFF=+$P(^BWPCD(BWIEN,0),"^",12)
 S N=0
 F  S N=$O(^BWPCD("C",DFN,N)) Q:'N  D
 . S Y=^BWPCD(N,0)
 . I "^25^26^28^"'[(U_$P(Y,U,4)_U) Q  ;CIA/DKM - added delimeters
 . I $P(Y,"^",12)<CUTOFF S BWMAM($P(Y,"^",12))=""
 ;
 ; Get last date in list and return in CDC MDE date format
 S BWI=$O(BWMAM(""),-1)
 I BWI S BWMDT=$E(BWI,4,5)_($E(BWI,1,3)+1700)  ;$$CDCDT^BWMDEU2(BWI)
 E  S BWMDT=""
 Q BWMDT
 ;
 ;
MSCRDT(BWDT,BWRPT) ; EP - Return date of Mammogram Test
 ; Call with BWDT = date of Mammogram test
 ;          BWRPT = results of Mammogram test
 ;
 ; Returns  BWPDT = date of Pap test in MDE date format
 ;
 N BWPDT,FLAG
 S FLAG=1
 ;
 I BWRPT>7,BWRPT<10 S FLAG=0
 ;
 I FLAG,BWDT S BWPDT=$$CDCDT^BWMDEU2(BWDT)
 E  S BWPDT=$$REPEAT^XLFSTR(" ",8)
 Q BWPDT
 ;
 ;
PAID(DFN,PCCDATE,MDATE,RESULT,SITE) ; EP - Determine if procedure paid with NBCCEDP funds.
 ; Call with   DFN = patient ien in Patient file
 ;         PCCDATE = PCC event date in FileMan format
 ;           MDATE = date of mammogram in MDE date format
 ;          RESULT = mammography test result from item k of MDE
 ;            SITE = pointer to site in BW SITE file
 ;
 ; Reuturns  PAID = 1-yes, 2-no, 3-unknown
 ;
 N AGE,PAID
 S PAID=""
 ; PCC event date before CDC Funding Began date, funded if procedure is before CDC Funding date
 I MDATE,PCCDATE<$P($G(^BWSITE(SITE,0)),"^",17) S PAID=1
 ; Result type 12 do not have funding
 I 'PAID,RESULT=12 S PAID=2
 ; Age logic ensures that 75% of the reported population meets the CDC 75% rule.
 ; IHS WH does not turn away patients not meeting the age limitations.
 ; Ensure that at least 75% of those between ages 50 and 65 are funded
 I PAID>1 D
 . S AGE=+$$AGE^AUPNPAT(DFN)
 . I AGE<50!(AGE>65) S AGE=$R(100)
 . E  S AGE=1
 . S PAID=$S(AGE<26:1,1:2)
 ; Date of Mammogram required to mark funding as YES
 I PAID="",MDATE S PAID=1
 Q PAID
