BLRAG04 ; IHS/MSC/SAT - LABORATORY ACCESSION GUI RPCS ;
 ;;5.2;IHS LABORATORY;**1031**;NOV 01, 1997;Build 185
 ;
 ;  BLR REF LAB USING LEDI   - UL^BLRAG02      = return the value of the 'REF LAB USING LEDI?' field in the BLR MASTER CONTROL file
 ;  BLR ICD LOOKUP           - ICDLKUP^BLRAG07 = ICD code lookup
 ;  BLR ORDER REASON LKUP    - ORL^BLRAG07     = return order reasons from file 100.03
 ;  BLR PATIENT LOOKUP       - PTLK^BLRAG04    = Patient Lookup
 ;  BLR PRINTERS AVAILABLE   - DEVICE^BLRAG10  = return available printers from the DEVICE file
 ;  BLR USER LOOKUP          - NP^BLRAG06      = return entries from the NEW PERSON table 200 that are 'active'
 ;
 ;  BLR ACCESSION            - ACC^BLRAG05     = lab accession processor
 ;  BLR ACCESSION PRINT      - ABR^BLRAG02     = reprint accession label or manifest
 ;  BLR ALL NON-ACCESSIONED  - ANA^BLRAG01     = return all non-accessioned lab records
 ;  BLR ALL-ACCESSIONED      - ABD^BLRAG02     = return all accessioned records for given date range
 ;  BLR COLLECTION INFO      - BLC^BLRAG06     = check BLR PT CONFIRM parameter and return insurances for patient
 ;  BLR DELETE TEST          - DELTST^BLRAG08  = Cancel tests - Test are no longer deleted, instead the status is changed to Not Performed.
 ;  BLR ORDER/TEST STATUS    - LROS^BLRAG03    = return order/test status for given patient and date range
 ;
 ;  BLR SHIP CONF            - SC^BLRAG09A     = select a shipping configuration
 ;  BLR MANIFEST BUILD       - BM^BLRAG09B     = build a shipping manifest
 ;  BLR MANIFEST CLOSE/SHIP  - CLSHIP^BLRAG09C = Close/ship a shipping manifest
 ;  BLR MANIFEST DISPLAY     - DISP^BLRAG09G   = screen formatted text for manifest display
 ;  BLR MANIFEST START       - SMONLY^BLRAG09C = Start a shipping manifest only, no building
 ;  BLR MANIFEST TEST ADD    - ADDTEST^BLRAG09C= Add tests to an existing manifest\
 ;  BLR MANIFEST TEST REMOVE - REMVTST^BLRAG09C= Remove a test from manifest - actually flags test as "removed".
 ;  BLR MANIFEST TESTS TO ADD- TARPC^BLRAG09B  = return tests that can be added to a manifest
 ;
PTLK(BDGY,BDGP,BDGC,BDGGIEN,BDGADM)  ;EP Patient Lookup
 ;
 ; RPC: BLR PATIENT LOOKUP
 ;INPUT
 ;  BDGP    = (required) Partail patient name; Could also be DOB, SSN, or chart #.
 ;  BDGC    = (optional) Max number of patients returned; defaults to 10
 ;  BDGGIEN = (optional) Specific IEN of patient
 ;  BDGADM  = (optional) flag to only return patients that are currently
 ;                       admitted; 0=all patients; 1=admitted patients only
 ;RETURNS:
 ;   (0) NAME
 ;   (1) HRN
 ;   (2) SSN
 ;   (3) DOB
 ;   (4) IEN
 ;   (5) STATUS
 ;   (6) GENDER
 ;   (7) ADMISSION_IEN
 ;   (8) INPATIENT_STATUS
 ;   (9) WARD
 ;  (10) ROOM_BED
 ;  (11) TREATING_SPEC
 ;  (12) PRIM_PHYS
 ;  (13) ATT_PHYS
 ;  (14) ADMITTING_PROVIDER
 ;  (15) LAST_EDITED_BY
 ;  (16) LAST_EDITED_DATE
 ;  (17) DISCHARGE_IEN
 ;  (18) DISCHARGE_TYPE
 ;  (19) DATE_OF_DEATH
 ;  (20) CITY
 ;  (21) STATE
 ;
 ;Find up to BDGC patients matching BDGP*
 ;Supports DOB Lookup, SSN Lookup
 ;
 ;BDGADM - if passed, only return patients that are currently admitted.
 ;
 N BDGXI
 S BDGP=$G(BDGP,"")
 S:$G(BDGC)="" BDGC=10
 S BDGY=$NA(^TMP("BLRAG",$J)) K @BDGY
 S BDGXI=0
 N BDGHRN,BDGZ,BDGDLIM,BDGRET,BDGDPT,BDGRET,BDGIEN,BDGFILE
 N BDGIENS,BDGFIELDS,BDGFLAGS,BDGVALUE,BDGNUMBER,BDGINDEXES,BDGSCREEN
 N BDGTARG,BDGMSG,BDGRSLT,BDGCNT
 S BDGDLIM="^"
 S @BDGY@(0)="ERROR_ID"
 I '+$G(DUZ) Q
 I '$D(DUZ(2)) Q
 ;                      0          1         2         3         4         5            6            7                   8                      9          10             11                  12
 S @BDGY@(BDGXI)="T00030NAME^T00030HRN^T00030SSN^D00030DOB^T00030IEN^T00030STATUS^T00010GENDER^I00020ADMISSION_IEN^T00030INPATIENT_STATUS^T00030WARD^T00030ROOM_BED^I00020TREATING_SPEC^I00020PRIM_PHYS^"
 ;                                    13             14                       15                   16                     17                  18                   19
 S @BDGY@(BDGXI)=@BDGY@(BDGXI)_"I00020ATT_PHYS^T00030ADMITTING_PROVIDER^I00020LAST_EDITED_BY^D00020LAST_EDITED_DATE^I00030DISCHARGE_IEN^T00030DISCHARGE_TYPE^D00020DATE_OF_DEATH"
 ;                                    20         21
 S @BDGY@(BDGXI)=@BDGY@(BDGXI)_"T00020CITY^T00020STATE"
 S BDGXI=BDGXI+1
 I $G(BDGGIEN) D DATA(.BDGY,BDGGIEN,BDGXI) Q
 ;
DOB ;DOB Lookup
 I +DUZ(2),((BDGP?1.2N1"/"1.2N1"/"1.4N)!(BDGP?1.2N1" "1.2N1" "1.4N)!(BDGP?1.2N1"-"1.2N1"-"1.4N)!(BDGP?1.2N1"."1.2N1"."1.4N)) D  Q
 . S X=BDGP S %DT="P" D ^%DT S BDGP=Y Q:'+Y
 . Q:'$D(^DPT("ADOB",BDGP))
 . S BDGIEN=0 F  S BDGIEN=$O(^DPT("ADOB",BDGP,BDGIEN)) Q:'+BDGIEN  D
 . . Q:'$D(^DPT(BDGIEN,0))
 . . I $G(BDGADM) Q:'$$STATUS(BDGIEN,1)
 . . D DATA(.BDGY,BDGIEN,.BDGXI)
 . . Q
 . Q
 ;
 ;Chart# Lookup
 I +DUZ(2),BDGP]"",$D(^AUPNPAT("D",BDGP)) D  Q
 . S BDGIEN=0 F  S BDGIEN=$O(^AUPNPAT("D",BDGP,BDGIEN)) Q:'+BDGIEN  I $D(^AUPNPAT("D",BDGP,BDGIEN,DUZ(2))) D  Q
 . . Q:'$D(^DPT(BDGIEN,0))
 . . I $G(BDGADM) Q:'$$STATUS(BDGIEN,1)
 . . D DATA(.BDGY,BDGIEN,.BDGXI)
 . . Q
 . Q
 ;
 ;SSN Lookup
 I (BDGP?9N)!(BDGP?3N1"-"2N1"-"4N),$D(^DPT("SSN",BDGP)) D  Q
 . Q
 . S BDGIEN=0 F  S BDGIEN=$O(^DPT("SSN",BDGP,BDGIEN)) Q:'+BDGIEN  D  Q
 . . Q:'$D(^DPT(BDGIEN,0))
 . . I $G(BDGADM) Q:'$$STATUS(BDGIEN,1)
 . . D DATA(.BDGY,BDGIEN,.BDGXI)
 . . Q
 . Q
 ;
 ;All Patients
 I BDGP="" D  Q
 . D LISTALL^BEHOPTPL(.PLIST,"",1)
 . S BDGCNT=0 F  S BDGCNT=$O(PLIST(BDGCNT)) Q:'BDGCNT!(BDGCNT>$G(BDGC))  D
 . . I $G(BDGADM) Q:'$$STATUS($P(PLIST(BDGCNT),U,1),1)
 . . D DATA(.BDGY,$P(PLIST(BDGCNT),U,1),.BDGXI)
 . . Q
 . Q
 ;
 S BDGFILE=2
 S BDGIENS=""
 S BDGFIELDS=".01"
 S BDGFLAGS=""
 S BDGVALUE=BDGP
 S BDGNUMBER=BDGC
 S BDGINDEXES="B"
 S BDGSCREEN=$S(+DUZ(2):"I $D(^AUPNPAT(Y,41,DUZ(2),0))",1:"")
 S BDGIDEN=""
 S BDGTARG="BDGRSLT"
 S BDGMSG=""
 D FIND^DIC(BDGFILE,BDGIENS,BDGFIELDS,BDGFLAGS,BDGVALUE,BDGNUMBER,BDGINDEXES,BDGSCREEN,BDGIDEN,BDGTARG,BDGMSG)
 I '+$G(BDGRSLT("DILIST",0)) Q
 N BDGCNT S BDGCNT=2
 F BDGX=1:1:$P(BDGRSLT("DILIST",0),U) D
 . S BDGIEN=BDGRSLT("DILIST",2,BDGX)
 . I $G(BDGADM) Q:'$$STATUS(BDGIEN,1)
 . D DATA(.BDGY,BDGIEN,.BDGXI)
 . Q
 Q
 ;
DATA(BDGY,BDGIEN,BDGXI) ;
 S BDGDPT=$G(^DPT(BDGIEN,0))
 S BDGZ=$P(BDGDPT,U)
 S BDGHRN=$P($G(^AUPNPAT(BDGIEN,41,DUZ(2),0)),U,2) ;CHART
 I BDGHRN="" Q  ;NO CHART AT THIS DUZ2
 I $P($G(^AUPNPAT(BDGIEN,41,DUZ(2),0)),U,3) S BDGHRN=BDGHRN_"(*)" Q  ;HMW 20050721 Record Inactivated
 S $P(BDGZ,BDGDLIM,2)=BDGHRN
 S $P(BDGZ,BDGDLIM,3)=$P(BDGDPT,U,9) ;SSN
 S Y=$P(BDGDPT,U,3) X ^DD("DD")
 S $P(BDGZ,BDGDLIM,4)=Y ;DOB
 S $P(BDGZ,BDGDLIM,5)=BDGIEN
 S $P(BDGZ,BDGDLIM,6)=$$STATUS(BDGIEN)
 S $P(BDGZ,BDGDLIM,7)=$$SEX^AUPNPAT(BDGIEN)_"^"_$$INP(BDGIEN)
 S $P(BDGZ,BDGDLIM,21)=$$GET1^DIQ(2,BDGIEN_",",.114)  ;get city
 S $P(BDGZ,BDGDLIM,22)=$$GET1^DIQ(2,BDGIEN_",",.115)  ;get state
 S DFN=BDGIEN I $G(DFN) S $P(BDGZ,BDGDLIM,20)=$$DOD^AUPNPAT(DFN) ; Date of Death
 S @BDGY@(BDGXI)=BDGZ,BDGXI=BDGXI+1
 Q
STATUS(DFN,CHECK) ;
 N STATUS,A,INP
 I 'DFN Q ""
 K VAIN
 I $G(CHECK) D  Q INP
 .D IN5^VADPT
 .I $G(VAIP(1)) S INP=1 Q
 .S INP=0
 D INP^DGPMV10,Q^VADPT3
 S A=$S("^3^5^"[("^"_+DGPMVI(2)_"^"):0,1:+DGPMVI(2))
 S STATUS=$S('A:"IN",1:"")_"ACTIVE "_$S("^4^5^"[("^"_+DGPMVI(2)_"^"):"LODGER",$P(DGPMVI(8),"^",2)["OBSERVATION":"OBSERVATION PATIENT",1:"INPATIENT")
 Q STATUS
INP(DFN) ;
 N BDGINP,BDGWARD,BDGRMBD,BDGIEN,BDGTRSP,BDGPPHYS,BDGAPHYS,BDGLEBY,BDGLEON,BDGADIS,BDGDIST,BDGADMPV
 N BDGARY
 K VAIN
 S BDGINP=0
 D INP^VADPT M BDGARY=VAIN
 S BDGIEN=+$G(VAIN(1)) I BDGIEN S BDGINP=1
 I 'BDGINP D INP^DGPMV10 S BDGDIEN=$G(DGPMVI(1))
 I 'BDGINP S BDGIEN=$$GET1^DIQ(405,BDGDIEN,.14,"I")
 S BDGLEBY=$$GET1^DIQ(405,$S(BDGINP:BDGIEN,1:BDGDIEN),102,"I")
 S BDGLEON=$$GET1^DIQ(405,$S(BDGINP:BDGIEN,1:BDGDIEN),103,"I")
 S BDGPPHYS=$P(BDGARY(2),U)
 S BDGTRSP=$P(BDGARY(3),U)
 S BDGWARD=$P(BDGARY(4),U)
 S BDGRMBD=$P(BDGARY(5),U) I BDGRMBD]"" S BDGRMBD=$O(^DG(405.4,"B",BDGRMBD,0))
 S BDGAPHYS=$P(BDGARY(11),U)
 S BDGADIS=$$GET1^DIQ(405,BDGIEN,.17,"I")
 I BDGADIS D
 .S BDGDIST=$$GET1^DIQ(405,BDGADIS,.04,"E")
 S BDGADMPV=$$GET1^DIQ(405,BDGIEN,9999999.02,"E")
 Q BDGIEN_U_BDGINP_U_BDGWARD_U_BDGRMBD_U_BDGTRSP_U_BDGPPHYS_U_BDGAPHYS_U_BDGADMPV_U_BDGLEBY_U_BDGLEON_U_BDGADIS_U_$G(BDGDIST)
 ;
