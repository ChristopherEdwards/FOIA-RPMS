ACRFUFMU ;IHS/OIRM/DSD/AEF - OPEN DOCUMENTS MATCH FROM CORE FOR UFMS [ 05/21/2007   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGMT SYSTEM;**22**;NOV 05, 2001
 ;  NEW ROUTINE ACR*2.1*22 UFMS
 ;
PIECE ;EP;
 I ACROCCDA]"" D
 .S ACROCC=$P($G(^AUTTOBJC(ACROCCDA,0)),U)
 I ACRCANDA]"" D
 .S ACRCAN=$P($G(^AUTTCAN(ACRCANDA,0)),U)
 Q
 ;
 ; ****************************
MATCH() ;EP;
 I ACRCCAN'=ACRCAN Q 0
 I ACRCOCC'=ACROCC Q 0
 I ACRCFY=ACRFY Q 1           ;MATCH
 I $E(ACRCFY,3,4)'=ACRFY Q 0  ;ACCOMODATE 2-DIGIT FY
 Q 1                          ;MATCH
 ;
 ; ****************************
MATCH2(ACRXX,I,ACRV) ;EP; FIND MATCH IN ARRAY
 ;
 I '$D(ACRXX(1,I)) Q 0               ;NOT A MATCH
 S ACRMATCH=$G(ACRXX(1,I,ACRV))      ;SEND BACK ITEM DA
 S:ACRMATCH="" ACRMATCH=$G(ACRXX(1,I,0))
 S:ACRMATCH="" ACRMATCH=0
 Q ACRMATCH
 ;
 ; ****************************
CKVEND(ACRV) ;EP; CHECK FOR MISSING VENDOR DATA
 ;
 ;    Enters with: ACRV = Vendor file IEN
 ;    Returns:  NULL or
 ;              Error string
 S ACRERR=""
 I $G(ACRCTYP)="TR"  Q ACRERR          ;DON'T WANT TRAVEL VENDORS
 S ACRCEIN=$G(ACRCEIN)
 S ACRCORE=$G(ACRCORE)
 S:'$D(ACR) ACR=0
 N ACRTEIN
 D NAMCHK(ACRV)
 D DUNSCHK(ACRV)
 D EINCHK(ACRV)                    ;CHECKS EIN,SUFFIX & DUPS
 I ACRCEIN]"",ACRCEIN'[11111111 D
 .S ACRTEIN=ACREIN_ACRSFX
 .I ACRCEIN'=ACRTEIN D
 ..S ^ACRZ("CEIN",ACR)=ACRCEIN_"/"_ACRTEIN_" NO MATCH"_U_ACRCORE  ;RECORD BAD MATCH
 ..S ACRERR=ACRERR_"CORE EIN "_ACRCEIN_" does not match IHS "_ACRTEIN_U
 D ADDCHK(ACRV)
 D BANK(ACRV)
 I $$IDATE(ACRV) D
 .S ACRERR="Inactive** "_U_ACRERR
 Q ACRERR
 ; ****************************
BANK(ACRV) ;EP; CHECK EFT BANKING INFORMATION
 ;
 ;    Enters with: ACRV = Vendor file IEN
 ;    Returns:  Error string
 N ACREFTT,ACRRT,ACRBANK
 S ACRBANK=$TR($G(^AUTTVNDR(ACRV,19)),U) ;REMOVES DELIMITERS
 I ACRBANK="" D  Q
 .S ACRERR=ACRERR_"No EFT"_U
 S ACREFTT=$$EFTAT(ACRV)                 ;ACCOUNT TYPE
 S ACRRT=$$EFTRT(ACRV)                   ;ROUTING NUMBER
 S ACRACNT=$$EFTDA(ACRV)                 ;ACCOUNT NUMBER
 I ACRACNT'?5.N D
 .D SETDATE(ACRV)
 .S ACRERR=ACRERR_"Bad Account Number "_ACRACNT_U
 I '$$RCK(ACRRT)!(ACRRT'?5.N) D
 .S ACRERR=ACRERR_"Bad Bank Routing Number "_ACRRT_U
 .D SETDATE(ACRV)
 I ACREFTT'="S",ACREFTT'="C" D
 .S ACRERR=ACRERR_"Missing/Bad Acct Type "_ACREFTT_U
 .D SETDATE(ACRV)
 Q
 ; ****************************
ADDCHK(ACRV) ;EP;  CHECK VENDOR MAILING ADDRESS ZIP
 ;
 ;    Enters with: ACRV = Vendor file IEN
 ;    Returns:  Error string
 ;
 N ACRZIP,ACRZIP2
 S ACRZIP=$$MZIP(ACRV)
 S ACRZIP2=$TR(ACRZIP,"-")
 I ACRZIP2'?9N D
 .S ACRERR=ACRERR_"Mailing ZIP "_ACRZIP_U
 Q
 ; ****************************
NAMCHK(ACRV) ;EP; CHECK VENDOR NAME AND INACTIVE STATUS
 ;
 ;    Enters with: ACRV = Vendor file IEN
 ;    Returns:  Error string
 ;              Inactive flag
 ;
 N ACRE1,ACRE2
 S ACRVNAM=$$VNAME(ACRV)
 I ACRVNAM="" D
 .S ACRERR="Vendor Name Missing"_U
 .D SETDATE(ACRV)
 S ACRE1=$E(ACRVNAM)
 S ACRE2=$E(ACRVNAM,1,2)
 I $E(ACRVNAM,1,6)?6N S ACRE1=" "                       ;FORCE ERROR MESSAGE
 I ACRE1?1L!($E(ACRVNAM,2)?1L) D UPPER(ACRV,ACRVNAM)    ;NO LOWER CASE
 I ACRVNAM["DO NOT USE"!(ACRVNAM["DON'T USE")!(ACRVNAM["DONT USE")!(ACRVNAM["NOT SPECIFIED") S ACRE1=" "
 I ACRE1=" "!(ACRE1=".")!(ACRE2="ZZ")!(ACRE2="XX")!(ACRE1="""")!(ACRE1="'")!(ACRE1=",") D
 .S ACRERR=ACRERR_"Bad Vendor Name "_ACRVNAM_U
 .D SETDATE(ACRV)
 Q
 ;
 ; ****************************
DUNSCHK(ACRV) ; EP - CHECK FOR DUNS
 ;
 ;    Enters with: ACRV = Vendor file IEN
 ;    Returns:  Error string
 ;
 N ACRDUN
 S ACRDUN=$$DUNS^ACRFVLK(ACRV)
 I ACRDUN[99999!(ACRDUN[11111)!(ACRDUN["00000") S ACRDUN="BAD"  ;FORCE ERROR
 I ACRDUN'?9N,ACRDUN'?13N D  ;MISSING OR WRONG LENGTH
 .S DA=ACRV
 .S DIE="^AUTTVNDR("
 .S DR=".07///^S X=""@"""
 .D ^DIE
 .S ACRERR=ACRERR_"DUNS missing"_U
 Q
 ;
 ; ****************************
EINCHK(ACRV) ;EP; CHECK EIN FOR VENDORS WITH THE SAME EIN NO
 ;
 ;    Enters with: ACRV = Vendor file IEN
 ;    Returns:  Error string
 ;    Enters with ACRNODUP if called outside of UFMS routines
 ;
 N ACREINP,ACRXEIN,ACRXIEN,Z,I
 S ACRSFX=""
 S ACREIN=$$EIN(ACRV)
 I ACREIN="" D  Q
 .S ACRERR=ACRERR_"EIN is Missing "_U
 .D SETDATE(ACRV)                         ;MAKE INACTIVE
 S Z=ACREIN
 I ACRERR["DUNS missing" D                ;CHECK FOR 5 SEQUENTIAL NUMBERS
 .I Z["00000" S Z="" Q
 .I Z[11111 S Z="" Q
 .I Z[22222 S Z="" Q
 .I Z[33333 S Z="" Q
 .I Z[44444 S Z="" Q
 .I Z[55555 S Z="" Q
 .I Z[66666 S Z="" Q
 .I Z[77777 S Z="" Q
 .I Z[88888 S Z="" Q
 .I Z[99999 S Z="" Q
 .I Z[101010 S Z="" Q
 I Z'?10N D
 .S ACRERR=ACRERR_"EIN has Bad Format "_ACREIN_U
 .D SETDATE(ACRV)                            ;MAKE INACTIVE
 S ACRSFX=$$SFX(ACRV)
 S ACREINP=$E(ACREIN)
 S ACRORG=$$ORG(ACRV)
 I ACRORG="" D ORGSET(ACRV)
 I ACRORG]"",ACRORG'=ACREINP D
 .S ACRERR=ACRERR_"EIN prefix does not match Org/Ind "_ACREINP_"/"_ACRORG_U
 .D SETDATE(ACRV)                            ;MAKE INACTIVE
 I ACREINP'=1,ACREINP'=2 D
 .S ACRERR=ACRERR_"Bad EIN prefix "_ACREINP_U
 .D SETDATE(ACRV)                            ;MAKE INACTIVE
 S ACRXEIN=""
 I '$D(ACRNODUP) F  S ACRXEIN=$O(^AUTTVNDR("E",ACRXEIN)) Q:ACRXEIN=""  D
 .Q:$E(ACRXEIN,1,10)'=ACREIN
 .S ACRXIEN=""
 .F  S ACRXIEN=$O(^AUTTVNDR("E",ACRXEIN,ACRXIEN)) Q:'ACRXIEN  D
 ..I ACRXIEN=ACRV Q                   ;DON'T COUNT SELF
 ..Q:ACRERR["Duplicate"               ;DON'T ADD MULTIPLE DUPS
 ..Q:$$IDATE(ACRXIEN)                 ;DON'T COUNT INACTIVE DUPS
 ..Q:'$$DUPCHK(ACRV,ACRXIEN)          ;QUIT IF NOT A DUPLICATE
 ..S ACRERR=ACRERR_"Duplicate EIN "_$$EIN(ACRXIEN)_"  "_$$SFX(ACRXIEN)_U
 I ACRSFX=""!(ACRSFX'?2UN) D          ;BAD SUFFIX -- ALL VENDORS
 .S ACRERR=ACRERR_"Missing or Bad Suffix "_ACRSFX_U
 Q
 ;
 ; ****************************
VNAME(X) ;EP     ;----- RETURNS NAME OF VENDOR
 ;
 ;      X  = VENDOR IEN
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^AUTTVNDR(X,0)),U)               ;FREE TEXT
 Q Y
 ;
 ; *********************************
IDATE(X) ;EP     ;----- RETURNS DATE INACTIVATED
 ;
 ;      X  = VENDOR IEN
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^AUTTVNDR(X,0)),U,5)               ;DT DATE
 Q Y
 ;
 ; ****************************
EIN(X) ;EP;    ;----- RETURNS EIN NO
 ;
 ;      X  = VENDOR FILE IEN
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^AUTTVNDR(X,11)),U)        ;FREE TEXT
 Q Y
 ;
 ; ****************************
SFX(X) ;EP;    ;----- RETURNS SUFFIX
 ;
 ;      X  = VENDOR FILE IEN
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^AUTTVNDR(X,11)),U,2)        ;FREE TEXT
 Q Y
 ;
 ; ****************************
MZIP(X) ;      ;----- RETURNS MAILING ADDRESS - ZIP
 ;
 ;      X  = VENDOR FILE IEN
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^AUTTVNDR(X,13)),U,4)              ;FREE TEXT
 Q Y
 ;
 ; ****************************
EFTAT(X) ;EP;----- RETURNS EFT ACCOUNT TYPE INFORMATION
 ;
 ;      X  = VENDOR FILE IEN
 ;
 ;RETURNS:
 ;       Y = NULL or
 ;       Y = CODE
 ;              C = CHECKING
 ;              S = SAVINGS
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^AUTTVNDR(X,19)),U)
 Q Y
 ;
 ; ****************************
EFTRT(X) ;EP;    ;----- RETURNS EFT ROUTING TRANSIT NUMBER
 ;
 ;      X  = VENDOR FILE IEN
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^AUTTVNDR(X,19)),U,2)             ;FREE TEXT
 Q Y
 ;
 ; ****************************
EFTDA(X) ;EP;    ;----- RETURNS EFT DEPOSITOR ACCOUNT NUMBER
 ;
 ;      X  = VENDOR FILE IEN
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^AUTTVNDR(X,19)),U,3)             ;FREE TEXT
 Q Y
 ;
 ; ****************************
EFTSRT(X) ;EP;    ;----- RETURNS EFT SUB-ROUTING TRANSIT NUMBER
 ;
 ;      X  = VENDOR FILE IEN
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^AUTTVNDR(X,19)),U,4)             ;FREE TEXT
 Q Y
 ;
 ; ****************************
ORG(X) ;EP;    ;----- RETURNS INDIVIDUAL/ORGANIZATION INDICATOR
 ;
 ;      X  = VENDOR FILE IEN
 ;    RETURNS: 1 = ORGANIZATION
 ;             2 = INDIVIDUAL
 N Y
 S Y=""
 I X S Y=$P($G(^AUTTVNDR(X,11)),U,19)
 Q Y
 ;
 ; ****************************
SETCK(ACRMSG,ACR) ;EP; ONLY ENTER NO MATCHES ONCE
 ;
 N I,J,QUIT,STR,HIT
 S (HIT,QUIT)=0
 F I="ACRDOC","NOVNDR","GTRIP","CHS","TR","GR","NOHIT" D  Q:QUIT
 .I $D(^ACRZ(I,ACR)) S HIT=1 I $D(^ACRZ("NOMATCH",ACR)) D
 ..K ^ACRZ("NOMATCH",ACR)
 ..S ACRMCNT=ACRMCNT-1
 ..S QUIT=1
 ;
 Q:QUIT
 I ACRCHS,$$OCC(ACRCOCC) D  Q:QUIT
 .I (ACRCFY-ACRFY)>2 D                         ;IGNORE OLD CHS DOCUMENTS
 ..D CHSSET^ACRFUFMZ(ACR)                      ;NO VALID MATCH, SET CHS FILE
 ..S QUIT=1
 I $D(^ACRZ("NOMATCH",ACR)) Q
 I 'HIT,ACRCTYP="TR" D  Q
 .Q:$D(^ACRZ("TR",ACR))
 .S ^ACRZ("TR",ACR)="NO MATCH TRAVEL"_U_U_U_U_ACRCORE
 .S ACRTRTOT=ACRTRTOT+1
 I 'HIT D
 .S ^ACRZ("NOMATCH",ACR)=ACRMSG_U_ACRSTR_U_ACRCORE  ;CAPTURE NOT MATCHED
 .S ACRMCNT=ACRMCNT+1
 I ACRV>0 D
 .Q:$D(^ACRZ("VNDR",ACRV))                 ;ALREADY IN FILE
 .S ACRERR=$$CKVEND^ACRFUFMU(ACRV)         ;CHECK FOR VENDOR ERRORS
 .S ACRSTR=ACRSTR_U_ACRCORE_U_U
 .D SETVND^ACRFUFMZ
 Q
 ;
 ; ****************************
VENDOR(ACR) ;EP; FIND VENDOR FROM PO,TRAINING OR TRAVEL (SSN FROM NEW PERSON)
 ;   ENTERS WITH FMS DOCUMENT IEN
 ;   RETURNS VENDOR FROM FMS DOCUMENT (PO OR TRAINING)
 ;
 N ACRV,V1,V2
 S ACRCTYP=$G(ACRCTYP)
 S ACRRTYP=$$REQTP^ACRFSSU(ACR)               ;GET REQUEST TYPE
 I ACRRTYP["CREDIT CARD" D  Q ACRV            ;QUIT IF DEF CC VENDOR
 .S ACRV=$$CCVEN                              ;DEFAULT CC VENDOR
 S ACRV=$P($G(^ACRDOC(ACR,"PO")),U,5)         ;PAYEE
 S:'ACRV ACRV=""
 I ACRV="",ACRRTYP["TRAINING" D
 .S ACRV=$P($G(^ACRDOC(ACR,"TRNG3")),U)       ;GET VENDOR FROM TRAINING NODE
 I ACRRTYP["TRAVEL" D                         ;TRAVELER
 .I ACRCTYP="AP" S ACRCTYP="TR"               ;TRAVEL DOC DISGUISED AS PO
 .S ACRV=$P($G(^ACRDOC(ACR,"TO")),U,9)        ;POINTER TO NEW PERSON FILE
 I ACRV="" S ACRV=$P($G(^ACRDOC(ACR,5)),U,5)  ;CONTRACTOR
 S:ACRV="" ACRV=0
 Q ACRV
 ;
 ; ****************************
RCK(ACRR) ;EXTRINSIC FUNCTION TO CHECKSUM THE EFT BANK ROUTING NUMBER
 ; ENTERS WITH THE ROUTING NUMBER = ACRR
 ;
 ; RETURNS 0 IF BAD
 ;         1 IF GOOD
 N ACRX
 S ACRX=$TR(ACRR," ")
 S ACRX=$TR(ACRX,"-")
 I $L(ACRX)'=9 Q 0                         ;BAD LENGTH
 N I,P,PP,ACRTOT8,ACRTOT9,ACRLAST
 S ACRTOT8=0
 F I=1:1:9 S P(I)=$E(ACRX,I)
 F I=1:3:7 S PP(I)=P(I)*3
 F I=2:3:8 S PP(I)=P(I)*7
 F I=3:3:9 S PP(I)=P(I)*1
 F I=1:1:8 S ACRTOT8=ACRTOT8+PP(I)
 S ACRTOT9=ACRTOT8+PP(9)
 I ACRTOT9#10'=0 Q 0                        ;NOT A MULTIPLE OF 10
 S ACRLAST=$E(ACRX,9)
 I ACRTOT8+ACRLAST'=ACRTOT9 Q 0             ;BAD CHECKSUM NUMBER
 Q 1
 ;
 ;*****************************
PRG(X) ;
 ;  X = DEPARTMENT ACCOUNT POINTER
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^AUTTPRG(X,0)),U)          ;PROGRAM NAME
 Q Y
 ;
 ;*****************************
DOL(X,Z) ;EP; EXTRINSIC FUNCTION TO RETURN 
 ;    X = DOLLAR AMOUNT IN 0000123456 FORMAT (FROM DHR)
 ;    Z = REVERSE CODE FROM TRANSACTION NUMBER
 N Y
 S Y=$FN((X/100),",",2)
 I Y]"",Z=2 S Y="-"_Y
 Q Y
 ;
 ;*****************************
VEN(X) ;EP;  EXTRINSIC FUNCTION TO FIND VENDOR THROUGH CROSS-REFERENCES
 ;    X = EIN FROM CORE
 ;    RETURNS VENDOR FILE POINTER OR 0
 ;
 I X["1111111"!(X="") Q 0              ;PSUEDO NUMBER
 N I,Y,Z,HIT
 S (Y,HIT)=0
 F I="C","D","E" D  Q:Y
 .Q:'$D(^AUTTVNDR(I,X))
 .S Y=$O(^AUTTVNDR(I,X,0))
 I Y Q Y                        ;FOUND A VENDOR
 I $D(^AUTTVNDR("C",$E(X,1,10))) D
 .S Y=$O(^AUTTVNDR("C",$E(X,1,10),0))
 I 'Y S Y=0
 Q Y
 ;
 ; ****************************
SETDATE(ACR) ;
 Q:$$IDATE(ACR)                 ;ALREADY INACTIVATED
 S DIE="^AUTTVNDR("
 S DA=ACR
 S DR=".05///"_DT
 D DIE^ACRFDIC
 Q
 ; ****************************
DUPCHK(ACRIEN,ACRXIEN) ;EP; CHECK EIN FOR VENDORS WITH THE SAME EIN NO
 ;  IF DIFFERENT BANK ACCOUNTS OR DUNS NOT A DUPLICATE
 ;    Enters with: ACRIEN = Vendor file IEN
 ;                 ACRXIEN = Possible duplicate IEN
 ;    Returns: 0 = not a duplicate
 ;             1 = is a duplicate
 ;
 I $D(ACRNODUP) Q 0                          ;ALLOW AUDIT ENTRY
 S ACRBNK=$TR($G(^AUTTVNDR(ACRIEN,19)),U)
 S ACRXBNK=$TR($G(^AUTTVNDR(ACRXIEN,19)),U)
 I ACRBNK]"",ACRXBNK]"",ACRBNK'=ACRXBNK Q 0  ;DIFFERENT BANK ACCOUNT
 S ACRDUN=$$DUNS^ACRFVLK(ACRIEN)
 S ACRXDUN=$$DUNS^ACRFVLK(ACRXIEN)
 I ACRDUN]"",ACRXDUN]"",ACRDUN'=ACRXDUN Q 0  ;DIFFERENT DUNS
 Q 1                                         ;IT IS A DUPLICATE
 ; ****************************
CCVEN() ;EP; RETRIEVE CREDIT CARD VENDOR FROM FMS SYSTEM DEFAULT FILE
 ;
 N X
 S X=$P($G(^ACRSYS(1,501)),U)
 S:X']"" X=0
 Q X
CHS() ;EP - CHECK FOR CHS DOCUMENTS *********
 I ACRCREF'=323,ACRCREF'=324,ACRCREF'=325 Q 0  ;NOT CHS REFERENCE CODES
 I $E(ACRCCAN,5)'?1A Q 0
 I ACRAP=94 Q 0                                ;HQ -- ADMIN NO CHS
 I ACRAP=59 Q 0                                ;ALASKA -- NO CHS
 I '$$OCC(ACRCOCC) Q 0                         ;WRONG OBJECT CLASS CODE
 N ACRE3
 S ACRE3=$E(ACRCDOC,3)
 I ACRAP=53,ACRE3="Q" Q 1         ;ALBUQUERQUE
 I ACRAP=45,ACRE3="C" Q 1         ;ABERDEEN
 I ACRAP=46,ACRE3="D" Q 1         ;BEMIDJI
 I ACRAP=47,ACRE3="B" Q 1         ;BILLINGS
 I ACRAP=51,ACRE3="U" Q 1         ;NASHVILLE
 I ACRAP=54,ACRE3="N" Q 1         ;NAVAJO
 I ACRAP=50,ACRE3="O" Q 1         ;OKLAHOMA
 I ACRAP=40,ACRE3="X" Q 1         ;PHOENIX
 I ACRAP=64,ACRE3="P" Q 1         ;PORTLAND
 I ACRAP=42,ACRE3="S" Q 1         ;TUCSON
 I ACRAP=41,ACRE3="L" Q 1         ;CALIFORNIA
 I ACRE3="A" Q 1                  ;BELONGS SOMEWHERE
 Q 0
 ; ****************************
OCC(Z) ;CHECK OBJECT CLASS CODE FOR FI PAID
 ; -- Enters with CORE Object Class Code
 ;
 I Z="2611" Q 0            ;IHS PAID CODE
 ;    List contains only OCC that FI pays
 I Z="256Q" Q 1
 I Z="256R" Q 1
 I Z="256T" Q 1
 I Z="2185" Q 1
 I Z="263A" Q 1
 I Z="263G" Q 1
 I Z="263K" Q 1
 I Z="4319" Q 1
 Q 0
 ; ********************************
UPPER(X,Z) ; CONVERT TO UPPER CASE
 ;ENTER WITH X=VENDOR IEN, Z=VENDOR NAME
 N NAME
 S NAME=$$UPPER^ACRFUTL(Z)
 S DIE="^AUTTVNDR("
 S DA=X
 S DR=".01///"_NAME
 D DIE^ACRFDIC
 Q
 ; ******************************
ORGSET(X) ; SET MISSING ORG/IND FIELD IF VALID NUMBER
 I ACREINP'=1,ACREINP'=2 Q
 S DIE="^AUTTVNDR("
 S DA=X
 S DR="1119///"_ACREINP
 D DIE^ACRFDIC
 Q
