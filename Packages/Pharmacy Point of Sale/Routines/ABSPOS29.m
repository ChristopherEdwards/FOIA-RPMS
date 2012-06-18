ABSPOS29 ; IHS/FCS/DRS - BUILD COMBINED INSURANCE ;  [ 09/12/2002  10:04 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,14,15,16,17,21,22,37**;JUN 21, 2001
 ; 
 ; Copied from VTLCOMB on 08/18/2000
 ; Removed $ZT="DX^KCRZT"
 ; Verified no other instances of "KCR" or "VTL"
 ;
 ; DRS 10/16/2000   Follow the FI pointer 
 ;   in ^AUTNINS(insurer,13,state,0),U,2) right now.
 ;   Site-selectable switch for this, though it perhaps isn't
 ;   in the setup routines.  See $$USEFI, below.
 ;   This was done because Pawhuska has ^AUTNINS(3,), MEDICAID,
 ;   set to not billable for RX.  But if you follow the pointer
 ;   to Oklahoma Medicaid, that one is billable.
 ; This sets the right medicaid insurer from the very beginning.
 ;
 ;** vtl 6/26/00 - get elig dates from Pvt Ins. file
 ;
 ;** this program will search the three files containing insurance
 ;   information. 1: Private Insurance Eligible
 ;                2: Medicare Eligible
 ;                3: Medicaid Eligible
 ;** It will update ^ABSPCOMB with the data found
 ;   IHS/SD/RLT - 04/25/06 - Patch 17
 ;   Added Railroad search
 ;                4: Railroad Eligible
 ;---
 ;IHS/SD/lwj 07/21/05 patch 14 (????)   need to adjust UPDATE so
 ; that previously entries in ^ABSPCOMB are deleted if the patient
 ; no longer has any insurance references
 ;---
 ;IHS/SD/RLT - 01/24/06 - Patch 15
 ;    Added new code to access new Medicare D eligibility data.
 ;---
 ;IHS/SD/RLT - 01/24/06 - Patch 16
 ;    Added insurer to Medicare D eligibility data.
 ;---
 ;IHS/SD/RLT - 04/25/06 - Patch 17
 ;    Added Railroad search.
 ;---
 ;IHS/SD/RLT - 05/01/07 - Patch 21
 ;    Changed Medicare and Railroad to capture B and D and
 ;    to skip incomplete D.
 ;---
 ;IHS/SD/RLT - 07/25/07 - Patch 22
 ;    Updated Medicare and RR D lookup.
 ;
EN(PATDFN)         ;EP - from ABSPOS25
 ;
 N ARRAY,BEGDAT,CAIDDFN,CAIDNAM,CAREDFN,CARENAM,CNT,D1,DA,DIK,DIQUIET
 N ENDDAT,FILE,FILECNT,NUMBER,P1,P2,P3
 N POLCOV,POLIEN,POLNAM,POLNUM,POLREL,POLSEX,PRVDFN,REC,REC11,SUFFIX
 N RRDFN,RRPREFIX,RRNAM,INSDFN,COVTYP
 ;S $ZT="DX^KCRZT"
 Q:'$G(PATDFN)
 ;N (DT,DUZ,PATDFN)
 N DIQUIET,NUMBER
 S DIQUIET=1 D DT^DICRW
 S NUMBER=0
 D PRIVATE
 D MEDICAID
 D MEDICARE
 D RAILROAD
 D UPDATE
 Q
TRANSFI(INSDFN,STATE)    ; translate based on the Medicaid FI field
 I '$$USEFI Q INSDFN ; flag is set to NOT do the translation
 N X S X=$P($G(^AUTNINS(INSDFN,13,STATE,0)),U,2)
 Q $S(X:X,1:INSDFN)
USEFI() Q '$P($G(^ABSP(9002313.99,1,"INS")),U,3)
 ;---
PRIVATE ;
 ;** scan the Private Insurance Eligible file
 S PRVDFN=$O(^AUPNPRVT("B",PATDFN,0))
 Q:'PRVDFN
 S FILE=$O(^DIC("B","PRIVATE INSURANCE ELIGIBLE",0))
 S D1=0
 F  S D1=$O(^AUPNPRVT(PRVDFN,11,D1)) Q:'D1  DO
 . S NUMBER=NUMBER+1
 . S REC=^AUPNPRVT(PRVDFN,11,D1,0)
 . S INSDFN=$P(REC,U,1)
 . S POLNUM=$P(REC,U,2)
 . S POLCOV=$P(REC,U,3)
 . S POLNAM=$P(REC,U,4)
 . S POLREL=$P(REC,U,5)
 . S BEGDAT=$P(REC,U,6)
 . S ENDDAT=$P(REC,U,7)
 . S POLIEN=$P(REC,U,8)
 . ;I POLIEN DO   ;vtl 6/26/00 - get elig dates from Pvt Ins. file
 .;.; S BEGDAT=$P(^AUPN3PPH(POLIEN,0),U,17)
 .;.; S ENDDAT=$P(^AUPN3PPH(POLIEN,0),U,18)
 . S ARRAY(NUMBER)=INSDFN_U_"PRVT"_U_POLNAM_U_POLNUM_U_BEGDAT_U_ENDDAT_U_POLIEN_U_FILE_U_PRVDFN_U_D1_U_POLREL
 Q
 ;---
MEDICAID ;
 S FILE=$O(^DIC("B","MEDICAID ELIGIBLE",0))
 S CAIDDFN=0
 F  S CAIDDFN=$O(^AUPNMCD("B",PATDFN,CAIDDFN)) Q:'CAIDDFN  DO
 . ;IHS/OIT/RAN 021710 patch 37 add all dates, not just most recent -Move following line
 . ;S NUMBER=NUMBER+1
 . S REC=^AUPNMCD(CAIDDFN,0)
 . S INSDFN=$P(REC,U,2)
 . S POLNUM=$P(REC,U,3)
 . S STATE=$P(REC,U,4)
 . I INSDFN,STATE S INSDFN=$$TRANSFI(INSDFN,STATE)
 . S POLNAM=$P(REC,U,5)
 . S POLREL=$P(REC,U,6)
 . S POLSEX=$P(REC,U,7)
 . S POLIEN=$P(REC,U,9)
 . I INSDFN,$P($G(^AUTNINS(INSDFN,0)),U)="NEW MEXICO MEDICAID" D
 . . I $P(REC,U,10) S INSDFN=$P(REC,U,10) ; replace with plan name
 . S CAIDNAM=$P($G(^AUPNMCD(CAIDDFN,21)),U,1)
 . S (BEGDAT,ENDDAT)=""
 . ;S D1=$O(^AUPNMCD(CAIDDFN,11,"A"),-1)
 . ;I D1 DO
 . ;. S BEGDAT=$P(^AUPNMCD(CAIDDFN,11,D1,0),U,1)
 . ;. S ENDDAT=$P(^AUPNMCD(CAIDDFN,11,D1,0),U,2)
 . ;S ARRAY(NUMBER)=INSDFN_U_"CAID"_U_POLNAM_U_POLNUM_U_BEGDAT_U_ENDDAT_U_POLIEN_U_FILE_U_CAIDDFN_U_U_POLREL
 . ;IHS/OIT/RAN 021710 patch 37 add all dates, not just most recent -BEGIN
 . S ABSPD1=0
 . F  S ABSPD1=$O(^AUPNMCD(CAIDDFN,11,ABSPD1)) Q:ABSPD1=""  D
 . . S NUMBER=NUMBER+1
 . . S BEGDAT=$P(^AUPNMCD(CAIDDFN,11,ABSPD1,0),U,1)
 . . S ENDDAT=$P(^AUPNMCD(CAIDDFN,11,ABSPD1,0),U,2)
 . . S ARRAY(NUMBER)=INSDFN_U_"CAID"_U_POLNAM_U_POLNUM_U_BEGDAT_U_ENDDAT_U_POLIEN_U_FILE_U_CAIDDFN_U_U_POLREL
 . ;IHS/OIT/RAN 021710 patch 37 add all dates, not just most recent -END
 Q
 ;---
MEDICARE ;
 S FILE=$O(^DIC("B","MEDICARE ELIGIBLE",0))
 S CAREDFN=$O(^AUPNMCR("B",PATDFN,0))
 Q:'CAREDFN
 ;S NUMBER=NUMBER+1             ;RLT 21
 S REC=^AUPNMCR(CAREDFN,0)
 S D1=0
 F  S D1=$O(^AUPNMCR(CAREDFN,11,D1)) Q:'D1  D
 . S REC11=$G(^AUPNMCR(CAREDFN,11,D1,0))
 . S COVTYP=$P(REC11,U,3)
 . Q:COVTYP="A"
 . S INSDFN=$P(REC,U,2)
 . S POLNUM=$P(REC,U,3)
 . S SUFFIX=$P(REC,U,4)
 . S POLNAM=""
 . S POLREL=$O(^AUTTRLSH("B","SELF",0))
 . S POLIEN=""
 . S CARENAM=$P($G(^AUPNMCR(CAREDFN,21)),U,1)
 . S BEGDAT=$P(REC11,U,1)
 . S ENDDAT=$P(REC11,U,2)
 . I COVTYP="D"  D
 .. S INSDFN=$P(REC11,U,4)
 .. S CARENAM=$P(REC11,U,5)
 .. S POLNUM=$P(REC11,U,6)
 . Q:INSDFN=""                  ;RLT 21 incomplete record
 . S NUMBER=NUMBER+1            ;RLT 21
 . ;S ARRAY(NUMBER)=INSDFN_U_"CARE"_U_CARENAM_U_POLNUM_U_BEGDAT_U_ENDDAT_U_POLIEN_U_FILE_U_CAREDFN_U_U_POLREL
 . S ARRAY(NUMBER)=INSDFN_U_"CARE"_U_CARENAM_U_POLNUM_U_BEGDAT_U_ENDDAT_U_POLIEN_U_FILE_U_CAREDFN_U_D1_U_POLREL
 Q
 ;---
RAILROAD ;RLT - 04/25/06 - Patch 17
 S FILE=$O(^DIC("B","RAILROAD ELIGIBLE",0))
 S RRDFN=$O(^AUPNRRE("B",PATDFN,0))
 Q:'RRDFN
 ;S NUMBER=NUMBER+1             ;RLT 21
 S REC=^AUPNRRE(RRDFN,0)
 S D1=0
 F  S D1=$O(^AUPNRRE(RRDFN,11,D1)) Q:'D1  D
 . S REC11=$G(^AUPNRRE(RRDFN,11,D1,0))
 . S COVTYP=$P(REC11,U,3)
 . Q:COVTYP="A"
 . S INSDFN=$P(REC,U,2)
 . S POLNUM=$P(REC,U,3)
 . S SUFFIX=$P(REC,U,4)
 . S POLNAM=""
 . S POLREL=$O(^AUTTRLSH("B","SELF",0))
 . S POLIEN=""
 . S RRNAM=$P($G(^AUPNRRE(RRDFN,21)),U,1)
 . S BEGDAT=$P(REC11,U,1)
 . S ENDDAT=$P(REC11,U,2)
 . I COVTYP="D"  D
 .. S INSDFN=$P(REC11,U,4)
 .. S RRNAM=$P(REC11,U,5)
 .. S POLNUM=$P(REC11,U,6)
 . Q:INSDFN=""                  ;RLT 21 incomplete record
 . S NUMBER=NUMBER+1            ;RLT 21
 . ;S ARRAY(NUMBER)=INSDFN_U_"RR"_U_RRNAM_U_POLNUM_U_BEGDAT_U_ENDDAT_U_POLIEN_U_FILE_U_RRDFN_U_U_POLREL
 . S ARRAY(NUMBER)=INSDFN_U_"RR"_U_RRNAM_U_POLNUM_U_BEGDAT_U_ENDDAT_U_POLIEN_U_FILE_U_RRDFN_U_D1_U_POLREL
 Q
 ;---
UPDATE ;
 ;IHS/SD/lwj 07/21/05 patch 14 (???)  adjust logic to delete
 ; previous entries in ^ABSPCOMB if the patient no longer
 ; has any insurance entries (Pine Hill)
 ;
 I (('$D(ARRAY))&($D(^ABSPCOMB(PATDFN)))) D
 . N DIK,DA
 . S DIK="^ABSPCOMB("
 . S DA=PATDFN
 . D ^DIK
 ;IHS/SD/lwj 7/21/05 end changes
 ;
 Q:'$D(ARRAY)
 F  L +^ABSPCOMB(0):10 Q:$T
 S FILECNT=$P(^ABSPCOMB(0),U,4)
 I '$D(^ABSPCOMB(PATDFN)) S FILECNT=FILECNT+1
 S $P(^ABSPCOMB(0),U,4)=FILECNT
 S $P(^ABSPCOMB(0),U,3)=PATDFN
 L -^ABSPCOMB(0)
 K ^ABSPCOMB(PATDFN,1)
 S ^ABSPCOMB(PATDFN,0)=PATDFN
 S ^ABSPCOMB("B",PATDFN,PATDFN)=""
 S D1=0,CNT=0
 F  S D1=$O(ARRAY(D1)) Q:'D1  DO
 . S CNT=CNT+1
 . S ^ABSPCOMB(PATDFN,1,D1,0)=ARRAY(D1)
 . S ^ABSPCOMB(PATDFN,1,"B",$P(ARRAY(D1),U,1),D1)=""
 . S P1=$P(ARRAY(D1),U,2),P2=$P(ARRAY(D1),U,9),P3=+$P(ARRAY(D1),U,10)
 . S ^ABSPCOMB(PATDFN,1,"AZ",P1,P2,P3,D1)=""
 S ^ABSPCOMB(PATDFN,1,0)="^9002313.11P^"_CNT_"^"_CNT
 S DIK="^ABSPCOMB(",DA=PATDFN D IX1^DIK
 Q
