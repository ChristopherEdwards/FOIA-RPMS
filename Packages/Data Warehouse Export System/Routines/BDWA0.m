BDWA0 ;IHS/CMI/LAB - DW EXPORT - OLD, NOT USED;
 ;;1.0;IHS DATA WAREHOUSE;;JAN 23, 2006
 ;
 Q
 ;;                   REGISTRATION EXPORT RECORD LAYOUT
 ;; --------------------------------------------------------------------
 ;;        ***    RG1 RECORD LAYOUT    ***
 ;;        ***    AGTXA                ***
 ;;     Piece #
 ;;     01        001 03 "RG1"
 ;;     02               UNIQUE REGISTRATION ID
 ;;     02        004 06 FACILITY CODE
 ;;     03        010 06 UNIT RECORD NUMBER
 ;;     04        016 20 LAST NAME
 ;;     05        036 11 FIRST NAME
 ;;     06        047 11 MIDDLE NAME
 ;;     07        059 02 CLASSIFICATION CODE
 ;;     08        061 07 DATE OF BIRTH
 ;;     09        068 01 SEX
 ;;     10        069 09 SOCIAL SECURITY NUMBER
 ;;     11        078 03 TRIBE CODE
 ;;     12        081 01 BLOOD QUANTUM
 ;;     13        082 20 FATHER LAST NAME
 ;;     14        102 11 FATHER FIRST NAME
 ;;     15        113 01 FATHER MIDDLE INITIAL
 ;;     16        114 07 COMMUNITY OF RESIDENCE
 ;;     17        121 30 MAILING ADDRESS STREET
 ;;     18        151 15 MAILING ADDRESS TOWN
 ;;     19        166 02 MAILING ADDRESS STATE
 ;;     20        168 09 MAILING ADDRESS ZIP
 ;; --------------------------------------------------------------------
 ;;        ***   RG2 FORMAT   ***
 ;;        ***   AGTX1        ***
 ;;     01        ... 03 "RG2"
 ;;     02               UNIQUE REGISTRATION ID
 ;;     02        177 20 MOTHER NAME LAST X
 ;;     03        197 11 MOTHER NAME FIRST X
 ;;     04        208 01 MOTHER NAME MIDDLE INITIAL
 ;;     05        209 06 DATE OF DEATH
 ;;     06        215 01 MEDICARE A ELIGIBLE
 ;;     07        216 14 MEDICARE A ENROLL NUMBER
 ;;     08        225 01 MEDICARE A SUFFIX
 ;;     09        230 06 MEDICARE A ELIGIBILITY
 ;;     10        236 01 MEDICARE B ELIGIBLE
 ;;     11        237 14 MEDICARE B ENROLL NUMBER
 ;;     12        246 01 MEDICARE B SUFFIX
 ;;     13        251 06 MEDICARE B ELIGIBILITY
 ;;     14        257 01 MEDICARE AB ELIGIBLE
 ;;     15        258 14 MEDICARE AB ENROLL NUMBER
 ;;     16        267 01 MEDICARE AB SUFFIX
 ;;     17        272 06 MEDICARE AB ELIGIBILITY
 ;;     18        278 01 MEDICAID ELIGIBLE
 ;;     19        279 14 MEDICAID NUMBER
 ;;     20        288 01 MEDICAID SUFFIX
 ;;     21        293 06 MEDICAID ELIGIBILITY DATE
 ;;     22        299 01 VETERAN
 ;;     23        300 01 BLUE CROSS ELIGIBLE
 ;;     24        301 01 OTHER ELIGIBLE
 ;;     25        302 01 CHS ELIGIBILITY
 ;;     26        303 01 PATIENT SIGNED
 ;;     27        304 01 ADD/MODIFY CODE
 ;;     28        305 06 OPT/MM RELEASE DATE
 ;;     29        311 01 ELIGIBILITY CODE
 ;;     30        312 01 BIC ELIGIBILITY CODE
 ;;     31        313 01 BIC ISSUED (Y or null)
 ;;     32        314 02 MEDICAID STATE OF ELIGIBILITY
 ;;     33        316 02 MEDICAID TYPE OF COVERAGE
 ;;     34               DATE OF LAST UPDATE
 ;;--------------------------------------------------------------------
 ;;        ***   RG3 FORMAT   ***
 ;;        ***   AGTXA        ***
 ;;     01         03 "RG3"
 ;;     02               UNIQUE REGISTRATION ID
 ;;     02
 ;;     03
 ;;     04
 ;;     05
 ;;     06
 ;;     07
 ;;--------------------------------------------------------------------
 ;;        ***   RG4 RECORD FORMAT   ***
 ;;        ***   AGTX1, AGTX2        ***
 ;;     01         03 "RG4"
 ;;     02               UNIQUE REGISTRATION ID
 ;;     02     $P(^AUTTLOC(SITE,0),"^",10)_
 ;;     03         01 FIRST LETTER OF LN
 ;;     04         01 FIRST LETTER OF FN
 ;;     05          SEX
 ;;     06          HRN
 ;;     07          blank
 ;;     08          FACILITY CODE
 ;;     09          HRN
 ;;--------------------------------------------------------------------
 ;;        ***   RG5 FORMAT   ***
 ;;        ***   AGTX1 & 2    ***
 ;;     01        001 03 "RG5"
 ;;     02               UNIQUE REGISTRATION ID
 ;;     02        004 14 ELIGIBILITY ENROLLMENT NUMBER
 ;;     03        018 01 SUFFIX
 ;;     04        019 01 ELIG TYPE: 1=A, 2=B, 3=AB, 4=M
 ;;     05        020 07 DATE OF BIRTH
 ;;     06        027 06 ELIG BEGIN DATE
 ;;     07        033 20 MEDICARE LAST NAME X
 ;;     08        053 11 MEDICARE FIRST NAME X
 ;;     09        064 11 MEDICARE MIDDLE NAME X
 ;;     10        075 20 MEDICAID LAST NAME X
 ;;     11        095 11 MEDICAID FIRST NAME X
 ;;     12        106 11 MEDICAID MIDDLE NAME X
 ;;     13        117 06 MEDICARE DATE OF BIRTH        MMDDYYY
 ;;     14        123 06 MEDICAID DATE OF BIRTH        MMDDYYY
 ;;     15        129 06 MEDICARE A ELIG. END DATE     MMDDYY
 ;;     16        135 06 MEDICARE B ELIG. END DATE     MMDDYY
 ;;     17        141 06 MEDICARE AB ELIG. END DATE    MMDDYY
 ;;     18        147 06 MEDICAID ELIG. END DATE       MMDDYY
 ;;               153  END RG5 
 ;;
