ACRFUTL ;IHS/OIRM/DSD/AEF - VARIOUS UTILITY SUBROUTINES [ 10/27/2004  4:17 PM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**3,13,14**;NOV 05, 2001
 ;
PAD(X,S,L,C)       ;EP
 ;----- PAD MACHINE - PAD CHARACTER STRING
 ;
 ;      X = DATA STRING
 ;      S = L=PADLEFT, R=PADRIGHT
 ;      L = LENGTH
 ;      C = PAD CHARACTER
 ;
 I $L(X)>L S X=$E(X,1,L) Q X
 S X=$TR(X," ","~")
 I S="R" D
 . S X=X_$J("",L-$L(X))
 I S="L" D
 . S X=$J("",L-$L(X))_X
 I C]"" S X=$TR(X," ",C)
 S X=$TR(X,"~"," ")
 Q X
 ;
AREA(X) ;EP -- RETURNS INTERNAL AREA SYSTEM FOR FMS SUPPLIES AND SERVICES FILE
 ;
 ;      Used by Function ACRFSSAREA, which is used by trigger on
 ;      COMMON ACCOUNTING NUMBER field of FMS Supplies and Services file
 ;      to trigger the AREA SYSTEM field.
 ;
 ;      Input:
 ;      X  =  IEN OF FMS SUPPLIES AND SERVICES FILE ENTRY
 ;
 ;      Output:
 ;      X  =  INTERNAL AREA IN FMS SYSTEM DEFAULTS FILE
 ;
 I $P($G(^ACRSS(X,0)),U,5)="" S X="" Q X
 I $P($G(^ACRCAN($P($G(^ACRSS(X,0)),U,5),0)),U,7)="" S X="" Q X
 I $P($G(^AUTTLCOD($P($G(^ACRCAN($P($G(^ACRSS(X,0)),U,5),0)),U,7),0)),U,3)="" S X="" Q X
 S X=$P($G(^AUTTACPT($P($G(^AUTTLCOD($P($G(^ACRCAN($P($G(^ACRSS(X,0)),U,5),0)),U,7),0)),U,3),0)),U,2)
 S X=$O(^ACRSYS("B",X,0))
 I 'X S X=""
 Q X
 ;
SYS(X) ;EP -- RETURNS FMS SYSTEM DEFAULTS ENTRY IEN FOR PURCHASING OFFICE
 ;
 ;      X = FMS PURCHASING OFFICE IEN
 ;
 N Y
 S Y=1
 I 'X Q Y
 I '$P($G(^ACRPO(X,0)),U,19) Q Y
 S Y=$P(^ACRPO(X,0),U,19)
 Q Y
TCMD(X,Y)          ;EP
 ;----- ENTRY POINT FOR USING $$TERMINAL^%HOSTCMD
 ;    (ALSO REPLACES HOSTCMD^AFSLCKZC CALL)
 ;
 ;      RETURNS 0 IF VALID, 1 IF INVALID
 ;
 S Y=$$TERMINAL^%HOSTCMD(X)
 Q
JCMD(X,Y)          ;EP
 ;----- ENTRY POINT FOR USING $$JOBWAIT^%HOSTCMD
 ;
 ;      RUNS IN BACKGROUND - WILL WORK IN CACHE'
 ;      RETURNS 0 IF VALID, 1 IF INVALID
 ;
 S Y=$$JOBWAIT^%HOSTCMD(X)
 Q
JDATE() ;EP -- RETURNS TODAY'S JULIAN DATE
 ;
 N X,X1,X2
 D ^XBKVAR
 S X1=DT
 S X2=$E(DT,1,3)_"0101"
 D ^%DTC
 S X=X+1
 S X=$$PAD(X,"L",3,0)
 Q X
QUE(ZTRTN,ZTSAVE,ZTDESC)     ;EP;
 ;----- QUEUEING CODE FROM WITHIN ROUTINES
 ;
 N %ZIS,IO,POP,ZTIO,ZTSK
 S %ZIS="Q"
 D ^%ZIS
 Q:POP
 I $D(IO("Q")) D  Q
 . K IO("Q")
 . S ZTIO=ION_";"_IOST_";"_IOM_";"_IOSL
 . D ^%ZTLOAD
 . W !,"Task #",$G(ZTSK)," queued"
 D @ZTRTN
 Q
NOW() ;EP -- RETURNS CURRENT DATE/TIME
 ;
 N %,%H,%I,X
 D ^XBKVAR
 D NOW^%DTC
 S Y=DT
 X ^DD("DD")
 Q Y_" "_$E($P(%,".",2),1,2)_":"_$E($P(%,".",2),3,4)
 ;
SLDATE(X)          ;EP
 ;----- RETURNS DATE IN MM/DD/YYYY FORMAT
 ;
 ;      X = INTERNAL FILEMANAGER DATE IN YYYMMDD FORMAT
 ;
 N Y
 S Y=""
 I X D
 . Q:$L(X)'=7
 . S Y=$E(X,4,5)_"/"_$E(X,6,7)_"/"_($E(X,1,3)+1700)
 Q Y
DOL(X) ;EP -- FORMAT DOLLAR AMOUNT ;
 ;
 ;      RETURNS X IN 999.99 FORMAT
 ;
 I X["(" S X=$TR(X,"()",""),X="-"_X
 S X=$FN(X,"P",2)
 S X=$TR(X," ","")
 I X["(" S X=$TR(X,"()",""),X="-"_X
 Q X
FY(X) ;EP -- CALCULATE FISCAL YEAR
 ;
 ;      RETURNS FISCAL YEAR IN X
 ;
 N MON
 S MON=$E(X,4,5)
 S X=$E(X,1,3)
 S X=1700+X
 I +MON>9 S X=X+1
 Q X
UPPER(X) ;EP -- CONVERT STRING TO UPPERCASE ;
 ;
 X ^%ZOSF("UPPERCASE")
 Q Y
 ;
HFS(ZISH1,ZISH2,ZISH3,%FILE) ;EP ;
 ;----- CREATE AND OPEN UNIX FILE - SILENT & NO "FILE"
 ;
 ; *NOTE: OPEN^%ZISH IS EXTRINSIC FUNCTION WHEN IT HAS ONLY 3 PARAMS
 ;        MUST 'DO' THE CALL WHEN PASSING 4 OR MORE
 ;
 ;      ENTERS WITH: ZISH1= PATH
 ;                   ZISH2= FILENAME
 ;                   ZISH3= "R" OR "W"
 ;      RETURNS: %FILE = DEVICE NUMBER (or UNDEFINED) 
 ;
 ;
 N X,Y
 ;S Y=$$OPEN^%ZISHMSM(ZISH1,ZISH2,ZISH3)   ;ACR*2.1*13.01 IM13574
 S Y=$$OPEN^%ZISH(ZISH1,ZISH2,ZISH3)       ;ACR*2.1*13.01 IM13574
 Q:Y
 S %FILE=IO
 Q
DOC(X) ;EP -- CONVERT REQUISITION NUMBER
 ;
 ;      INPUT:
 ;      X  =  REQUISITION NUMBER
 ;
 ;      RETURNS: THE 10 DIGIT REQUISITION NUMBER WITHOUT THE DASHES
 ;
 S X=$TR(X,"-","")
 S X=$E(X,2,11)
 Q X
HOST() ;EP -- RETURNS HOST NAME ; ACR*2.1*13.02 IM13574
 N Y
 S Y=""
 S Y=$P(^AUTTSITE(1,0),U,14)
 S Y=$TR(Y,"-")
 Q Y
PSSN(X,DUZ,IOST,ACRSSNOK)    ;EP  ;ACR*2.1*3.36
 ;----- OUTPUT TRANSFORM FOR TRAVEL ORDER/TRAVEL VOUCHER/TRAINING
 ;      REQUEST PRINT TEMPLATES
 ;
 ;      INPUT VARIABLES:
 ;      X        =  EMPLOYEE IEN
 ;      DUZ      =  PERSON PRINTING REPORT
 ;      IOST     =  PRINT SUBTYPE
 ;      ACRSSNOK =  VARIABLE SET IN ACRFPRNT AUTOPRINT ROUTINE
 ;
 ;      OUTPUT:
 ;      Y        = SSN IN 999-99-9999 OR ***-**-**** FORMAT
 ;
 ;      PRINT LOGIC:
 ;      NEVER PRINT TO TERMINAL SCREEN
 ;      ALWAYS PRINT SSN IF DOCUMENT IS AUTOPRINTED DUE TO APPROVAL
 ;      IF NOT AUTOPRINTED, ONLY PRINT IF THE USER HAS SECURITY KEY
 ;
 N Y
 S Y="*********"
 I "S-P-"[$E($G(IOST),1,2) D
 . Q:'$G(ACRSSNOK)&'$D(^XUSEC("ACRFZ SSN",+$G(DUZ)))
 . I $P($G(^VA(200,+$G(X),1)),U,9) S Y=$P(^(1),U,9)
 S Y=$E(Y,1,3)_"-"_$E(Y,4,5)_"-"_$E(Y,6,9)
 Q Y
ASKAP(ACRAP)       ;EP;             NEW SUB-ROUTINE ACR*2.1*13.02
 ;----- SELECT ACCOUNTING POINT FROM LIST
 ;     ------RETURNS INTERNAL AND EXTERNAL VALUES
 ;
 N DIC,X,Y
 S ACRAP=""
 S DIC="^AUTTACPT("
 S DIC(0)="AEMQ"
 D ^DIC
 Q:$D(DTOUT)!($D(DUOUT))!(+Y'>0)
 S ACRAP=Y
 Q
 ;
AP(X) ;EP;             NEW SUB-ROUTINE ACR*2.1*13.02
 ;------------EXTRINSIC FUNCTION FOR ACCOUNTING POINT
 ;
 N Y
 Q $P($G(^AUTTACPT(X,0)),U)
 ;
EXPDN(X) ;EP -- RETURN EXPANDED DOCUMENT NUMBER - ACR*2.1*14.01 IM12272
 ;
 ;      INPUT:
 ;      X  =  DOCUMENT IEN
 ;
 ;      OUTPUT:
 ;      Y  =  EXPANDED DOCUMENT NUMBER
 ;            IN FORMAT:
 ;            "HHS"_"I"_CONTRACTLOCATION_4FY_DOCNO
 ;
 ;      NOTE:  If "< UNKNOWN XXX >" is returned it is most likely
 ;             due to the following:
 ;             UNKNOWN 001 = discrepancy in the fiscal year of 
 ;             the document and the expanded number could not be
 ;             calculated based on the available data.  In this 
 ;             case, the expanded number should be manually
 ;             entered into the expanded document number field of
 ;             the FMS DOCUMENT file for the document.
 ;
 N Y,Z
 S Y=""
 S Z=$G(^ACRSYS(1,601))
 I X,+Z,$P(Z,U,2) D
 . S Z=$G(^ACRDOC(X,0))
 . S Y=$P(Z,U,2)                    ;PO/CONTRACT NO
 . I "148^600^130"[$$REF(X) D
 . . S Y=$P(Z,U)                    ;DOCUMENT NO
 . S Z=$P($G(^ACRDOC(X,"X")),U)     ;IF EXPDN ALREADY EXISTS
 . I Z]"" S Y=Z Q
 . Q:Y']""
 . S Z=$P($G(^ACRDOC(X,0)),U,15)    ;ORIG DOCNO IF MOD
 . I Z S X=Z
 . S Z=$P($G(^ACRSYS(1,601)),U)
 . I Z S Z=$P($G(^ACRCLC(+Z,0)),U)  ;CONTRACT LOCATION CODE
 . Q:Z']""
 . Q:$E($$DOCYR(X),4)'=$E(Y)
 . S Z="HHS"_"I"_Z_$$DOCYR(X)_$E(Y,2,10)
 . Q:$L(Z)'=20
 . Q:$D(^ACRDOC("B",Z))
 . S Y=Z
 Q Y
DOCYR(X) ;EP -- RETURN DOCUMENT YEAR - ACR*2.1*14.01 IM12272
 ;
 ;      This subroutine calculates the document year based
 ;      on code logic in the DOC3^ACRFDOCN routine:
 ;      If the fiscal year in which the document is created is
 ;      greater than the fiscal year of funds (in the FMS
 ;      DEPARTMENT ACCOUNT file), use the fiscal year in which
 ;      the document is created, otherwise use the fiscal year
 ;      of funds.
 ;
 ;      INPUT:
 ;      X  =  DOCUMENT IEN
 ;
 ;      OUTPUT:
 ;      Y  =  DOCUMENT YEAR
 ;
 N Y,Z
 S Y=""
 I X D
 . S Y=$P($G(^ACRLOCB($$DEPT(X),"DT")),U) ;FYFUN
 . S Z=$P($G(^ACRDOC(X,"PO")),U)          ;DATE OF PO
 . I Z="" S Z=$P($G(^ACRDOC(X,0)),U,3)    ;DOCUMENT DATE
 .  S Z=$$FY(Z)
 . I Z>Y S Y=Z
 Q Y
YEAR(X) ;EP -- RETURN 4 DIGIT YEAR OF DATE - ACR*2.1*14.01 IM12272
 ;
 ;      INPUT:
 ;      X  =  YEAR IN INTERNAL FILEMAN FORMAT
 ;
 ;      OUTPUT:
 ;      Y  =  4 DIGIT YEAR
 ;
 N Y
 S Y=""
 I X D
 . Q:$L(X)'=7
 . S Y=$E(X,1,3)+1700
 Q Y
DEPT(X) ;EP -- RETURN INTERNAL DEPARTMENT ACCOUNT OF DOCUMENT ;ACR*2.1*14.01 IM12272
 ;
 ;      INPUT:
 ;      X  =  DOCUMENT IEN
 ;
 ;      OUTPUT:
 ;      Y  =  INTERNAL DEPARTMENT ACCOUNT
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^ACRDOC(X,0)),U,6)
 Q Y
REF(X) ;EP -- RETURN EXTERNAL DOCUMENT REFERENCE CODE ;ACR*2.1*14.01 IM12272
 ;
 ;      INPUT:
 ;      X  =  DOCUMENT IEN
 ;
 ;      OUTPUT:
 ;      Y  =  EXTERNAL DOCUMENT REFERENCE CODE
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^ACRDOC(X,0)),U,13)
 I Y S Y=$P($G(^AUTTDOCR(Y,0)),U)
 Q Y
