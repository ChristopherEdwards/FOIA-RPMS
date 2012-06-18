AGTXDOC ;IHS/ASDS/EFG - EXPORT RECORD DOCUMENTATION ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 ;NOTE:
 ;The piece numbers are -AFTER- SET'ing to the export global, b/c
 ;Unique Registration ID is -INSERTED- as piece 2 to all records.
 ;This means that, as of patch 14, you have to subtract 1 from the
 ;piece numbers, below, when you're actually reading the AGTX*
 ;routines.
 ;
 ;;     DEMOGRAPHICS RECORD LAYOUT
 ;;--------------------------------------------------------------------
 ;;***    RG1 RECORD LAYOUT    ***
 ;; Piece #
 ;; 01  "RG1"
 ;; 02  UNIQUE REGISTRATION ID
 ;; 03  ASUFAC OF HRN IN 04
 ;; 04  HRN OF ASUFAC IN 03
 ;; 05  LAST NAME
 ;; 06  FIRST NAME
 ;; 07  MIDDLE NAME
 ;; 08  CLASSIFICATION CODE
 ;; 09  DATE OF BIRTH
 ;; 10  SEX
 ;; 11  SOCIAL SECURITY NUMBER
 ;; 12  TRIBE CODE
 ;; 13  BLOOD QUANTUM
 ;; 14  FATHER LAST NAME
 ;; 15  FATHER FIRST NAME
 ;; 16  FATHER MIDDLE INITIAL
 ;; 17  COMMUNITY OF RESIDENCE
 ;; 18  MAILING ADDRESS STREET
 ;; 19  MAILING ADDRESS TOWN
 ;; 20  MAILING ADDRESS STATE
 ;; 21  MAILING ADDRESS ZIP
 ;;--------------------------------------------------------------------
 ;;***    RG2 RECORD LAYOUT    ***
 ;; 01  "RG2"
 ;; 02  UNIQUE REGISTRATION ID
 ;; 03  MOTHER MAIDEN NAME LAST
 ;; 04  MOTHER MAIDEN NAME FIRST
 ;; 05  MOTHER MAIDEN NAME MIDDLE INITIAL
 ;; 06  DATE OF DEATH
 ;; 07  MEDICARE A ELIGIBLE
 ;; 08  MEDICARE A ENROLL NUMBER
 ;; 09  MEDICARE A SUFFIX
 ;; 10  MEDICARE A ELIGIBILITY
 ;; 11  MEDICARE B ELIGIBLE
 ;; 12  MEDICARE B ENROLL NUMBER
 ;; 13  MEDICARE B SUFFIX
 ;; 14  MEDICARE B ELIGIBILITY
 ;; 15  MEDICARE AB ELIGIBLE
 ;; 16  MEDICARE AB ENROLL NUMBER
 ;; 17  MEDICARE AB SUFFIX
 ;; 18  MEDICARE AB ELIGIBILITY
 ;; 19  MEDICAID ELIGIBLE
 ;; 20  MEDICAID NUMBER
 ;; 21  MEDICAID SUFFIX
 ;; 22  MEDICAID ELIGIBILITY DATE
 ;; 23  VETERAN
 ;; 24  BLUE CROSS ELIGIBLE
 ;; 25  OTHER ELIGIBLE
 ;; 26  CHS ELIGIBILITY
 ;; 27  PATIENT SIGNED
 ;; 28  ADD/MODIFY CODE
 ;; 29  OPT/MM RELEASE DATE
 ;; 30  ELIGIBILITY CODE
 ;; 31  DATE ESTABLISHED
 ;; 32  SSN VERIFICATION STATUS
 ;; 33  MEDICAID STATE OF ELIGIBILITY
 ;; 34  MEDICAID TYPE OF COVERAGE
 ;; 35  DATE OF LAST UPDATE
 ;;--------------------------------------------------------------------
 ;;***    RG3 RECORD LAYOUT    ***
 ;; 01  "RG3"
 ;; 02  UNIQUE REGISTRATION ID
 ;; 03
 ;; 04
 ;; 05
 ;; 06
 ;; 07
 ;; 08
 ;; 09
 ;;--------------------------------------------------------------------
 ;;***    RG4 RECORD LAYOUT    ***
 ;; 01  "RG4"
 ;; 02  UNIQUE REGISTRATION ID
 ;; 03  ASUFAC OF HRN IN 07
 ;; 04  FIRST LETTER OF LN
 ;; 05  FIRST LETTER OF FN
 ;; 06  SEX
 ;; 07  HRN OF ASUFAC IN 03
 ;; 08  OFFICIAL REGISTERING FACILITY (Y/N/blank) OF ASUFAC IN 09
 ;; 09  ASUFAC OF HRN IN 10
 ;; 10  HRN OF ASUFAC IN 09
 ;;--------------------------------------------------------------------
 ;;***    RG5 RECORD LAYOUT    ***
 ;; 01  "RG5"
 ;; 02  UNIQUE REGISTRATION ID
 ;; 03  ELIGIBILITY ENROLLMENT NUMBER
 ;; 04  SUFFIX
 ;; 05  ELIG TYPE: 1=A, 2=B, 3=AB, 4=M
 ;; 06  DATE OF BIRTH
 ;; 07  ELIG BEGIN DATE
 ;; 08  MEDICARE LAST NAME
 ;; 09  MEDICARE FIRST NAME
 ;; 10  MEDICARE MIDDLE NAME
 ;; 11  MEDICAID LAST NAME
 ;; 12  MEDICAID FIRST NAME
 ;; 13  MEDICAID MIDDLE NAME
 ;; 14  MEDICARE DATE OF BIRTH
 ;; 15  MEDICAID DATE OF BIRTH
 ;; 16  MEDICARE A ELIG. END DATE
 ;; 17  MEDICARE B ELIG. END DATE
 ;; 18  MEDICARE AB ELIG. END DATE
 ;; 19  MEDICAID ELIG. END DATE
 ;; 20  ASUFAC FROM RPMS SITE FILE
 ;;--------------------------------------------------------------------
 ;;***    RG6 Communities
 ;; 01  "RG6"
 ;; 02  UNIQUE REGISTRATION ID
 ;; 03  DATE MOVED TO COMMUNITY
 ;; 04  COMMUNITY CODE Community/County/State
 ;; 05  ASUFAC FROM RPMS SITE FILE
 ;;--------------------------------------------------------------------
 ;;***    RG7 Aliases
 ;; 01  "RG7"
 ;; 02  UNIQUE REGISTRATION ID
 ;; 03  ALIAS LAST NAME
 ;; 04  ALIAS FIRST NAME
 ;; 05  ALIAS MIDDLE NAME
 ;; 06  ASUFAC FROM RPMS SITE FILE
 ;;--------------------------------------------------------------------
 ;;***    RG8 Insurance Eligibilities
 ;; 01  "RG8"                         MCR   MCD   RRE   PVT
 ;; 02  UNIQUE REGISTRATION ID
 ;; 03  INSURANCE CATEGORY ("MCR"/"MCD"/"RRE"/"PVT")
 ;; 04  ELIGIBILITY BEGIN DATE        .01   .01   .01  .06
 ;; 05  ELIGIBILITY END DATE          .02   .02   .02  .07
 ;; 06  COVERAGE TYPE                 .03   .03   .03
 ;; 07  INSURER NAME                  .02   .02   .02  .01
 ;; 08  INSURER EIN                   obtain from INSURER file
 ;; 09  POLICY NUMBER                 .03   .03   .04
 ;; 10  NUMBER PREFIX/SUFFIX          .04         .03
 ;; 11  LAST NAME                   
 ;; 12  FIRST NAME                   
 ;; 13  MIDDLE NAME                   
 ;; 14  DATE OF BIRTH                 2102  2102  2102
 ;; 15  MCD GENDER                          .07
 ;; 16  MCD STATE                           .04
 ;; 17  PVT INS VERIFIED COVERAGE DATE                  .09
 ;; 18  PVT INS PERSON CODE                             .12
 ;; 19  POLICY HOLDER LAST NAME          
 ;; 20  POLICY HOLDER FIRST NAME          
 ;; 21  POLICY HOLDER MIDDLE NAME          
 ;; 22  MEDICAID PLAN NAME                  .11
 ;; 23  MEDICAID CASE NUMBER                .13
 ;; 24  MEDICAID RATE CODE                  .12
 ;; 25  MEDICAID DATE OF LAST UPDATE        .08
 ;; 26  MEDICARE SECONDARY PAYER      .05
 ;; 27  RELATIONSHIP TO INSURED             .06         .05
 ;; 28  ASUFAC FROM RPMS SITE FILE
 ;; 29  MCR/MCD/RRE NAME              2101  2101  2101
 ;
