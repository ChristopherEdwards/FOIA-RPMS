ACRFFF3 ;IHS/OIRM/DSD/AEF - PRODUCE FLAT FILE OF TRAVEL INFORMATION [ 09/23/2005   4:18 PM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**13,19**;NOV 05, 2001
 ;
DESC ;----- ROUTINE DESCRIPTION
 ;;Create Travel Information Flat File
 ;;
 ;;This option will gather all travel documents within the
 ;;specified date range and place them into a UNIX comma
 ;;delimited flat file which can then be imported into an
 ;;Access or Excel spreadsheet.
 ;;
 ;;Fields included in the flat file are:
 ;;     1 ASUFAC Code                 12 Travel End Date
 ;;     2 CAN Number                  13 Days in Travel
 ;;     3 Travel Order Number         14 Travel From City
 ;;     4 Traveler Name               15 Travel From State
 ;;     5 Official Duty Station       16 Travel To City
 ;;     6 ODS Area                    17 Travel To State
 ;;     7 Gender                      18 Amount Requested
 ;;     8 Pay Plan                    19 Amount Obligated
 ;;     9 Grade                       20 Amount Spent
 ;;    10 Series                      21 Status
 ;;    11 Travel Begin Date           22 Purpose of Travel
 ;;$$END
 ;
EN ;EP -- MAIN ENTRY POINT
 ;
 N ACRDATES,ACRFILE
 ;
 D ^XBKVAR
 D HOME^%ZIS
 ;
 D TXT
 ;
 D DATES(.ACRDATES)
 Q:$G(ACRDATES)']""
 ;
 D FILE(.ACRFILE)
 Q:$G(ACRFILE)']""
 ;
 W "   please wait..."
 ;
 D GET(ACRDATES)
 ;
 I '$D(^TMP("ACR",$J,"T")) D  Q
 . W !!,"No data found"
 . D PAUSE^ACRFWARN
 ;
 D UNIX(ACRFILE)
 ;
 ;K ^TMP("ACR",$J,"T")
 ;
 D ^%ZISC
 ;
 D PAUSE^ACRFWARN
 ;
 Q
GET(ACRDATES)      ;
 ;----- LOOP THROUGH TRAVEL ORDERS AND PUT DATA INTO ^TMP GLOBAL
 ;
 N ACRDATA,ACRDOCDA,ACRREF,ACRTOREF,ACRTVREF
 ;
 K ^TMP("ACR",$J,"T")
 K ^TMP("ACR",$J,"D")
 ;
 S ACRTOREF=$O(^AUTTDOCR("B",130,0))
 S ACRTVREF=$O(^AUTTDOCR("B",600,0))
 F ACRREF=ACRTOREF,ACRTVREF D
 . S ACRDOCDA=0
 . F  S ACRDOCDA=$O(^ACRDOC("REF",ACRREF,ACRDOCDA)) Q:'ACRDOCDA  D
 . . S ACRDATA=$G(^ACRDOC(ACRDOCDA,"TO"))
 . . Q:$P(ACRDATA,U,14)<$P(ACRDATES,U)
 . . Q:$P(ACRDATA,U,14)>$P(ACRDATES,U,2)
 . . D ONE(ACRDOCDA,ACRDATES,ACRREF)
 Q
ONE(ACRDOCDA,ACRDATES,ACRREF)          ; 
 ;----- GATHER DATA FOR ONE DOCUMENT AND PUT INTO ^TMP GLOBAL         
 ;
 N ACRDOCNO,ACRTVLR
 ;
 ;DOCUMENT NUMBER
 S ACRDOCNO=$P($G(^ACRDOC(ACRDOCDA,0)),U)
 ;
 ;TRAVELER IEN
 S ACRTVLR=$$TVLR(ACRDOCDA)
 ;
 ;TRAVEL DAYS
 D TDAYS(ACRDOCDA,ACRDOCNO)
 ;
 I $L(ACRDOCNO)>10 D  Q   ;ADD AMENDMENTS TO ORIGINAL DOCUMENT TOTALS
 . D SETAMT(ACRDOCDA,ACRDOCNO)
 . D SETTD(ACRDOCNO)
 ;
 D SET(ACRDOCDA,ACRDOCNO,ACRTVLR)
 D SETAMT(ACRDOCDA,ACRDOCNO)
 D SETTD(ACRDOCNO)
 Q
SET(ACRDOCDA,ACRDOCNO,ACRTVLR)         ;
 ;----- SET DATA INTO ^TMP GLOBAL
 ;
 N X
 ;
 S X=$G(^TMP("ACR",$J,"T",$E(ACRDOCNO,1,10),1,0))
 S $P(X,U)=$$ASUFAC($$LOC(ACRTVLR))
 S $P(X,U,2)=$$CAN(ACRDOCDA)
 S $P(X,U,3)=ACRDOCNO
 S $P(X,U,4)=$$NAME(ACRTVLR)
 S $P(X,U,5)=$$ODS(ACRTVLR)
 S $P(X,U,6)=$$ODSA(ACRTVLR)
 S $P(X,U,7)=$$SEX(ACRTVLR)
 S $P(X,U,8)=$$PAYPLAN(ACRTVLR)
 S $P(X,U,9)=$$GRADE(ACRTVLR)
 S $P(X,U,10)=$$SER(ACRTVLR)
 S $P(X,U,14)=$P($$TVLF(ACRDOCDA),U)
 S $P(X,U,15)=$P($$TVLF(ACRDOCDA),U,2)
 S $P(X,U,16)=$P($$TVLT(ACRDOCDA),U)
 S $P(X,U,17)=$P($$TVLT(ACRDOCDA),U,2)
 S $P(X,U,21)=$$STAT(ACRDOCDA)
 S ^TMP("ACR",$J,"T",$E(ACRDOCNO,1,10),1,0)=X
 S ^TMP("ACR",$J,"T",$E(ACRDOCNO,1,10),2,0)=$$PURP(ACRDOCDA)
 Q
SETAMT(ACRDOCDA,ACRDOCNO)    ;
 ;----- SET AMOUNTS INTO ^TMP GLOBAL
 ;
 N X
 ;
 S X=$G(^TMP("ACR",$J,"T",$E(ACRDOCNO,1,10),1,0))
 S $P(X,U,18)=$$DOL^ACRFUTL($P(X,U,18)+$$REQ(ACRDOCDA))
 S $P(X,U,19)=$$DOL^ACRFUTL($P(X,U,19)+$$OBL(ACRDOCDA))
 S $P(X,U,20)=$$DOL^ACRFUTL($P(X,U,20)+$$SPNT(ACRDOCDA))
 S ^TMP("ACR",$J,"T",$E(ACRDOCNO,1,10),1,0)=X
 Q
SETTD(ACRDOCNO)    ;
 ;----- SETS 1ST AND LAST TRAVEL DAYS INTO ^TMP GLOBAL
 ;
 N ACRF,ACRL,ACRN,X
 ;
 S X=$G(^TMP("ACR",$J,"T",$E(ACRDOCNO,1,10),1,0))
 S ACRF=$O(^TMP("ACR",$J,"D",$E(ACRDOCNO,1,10),0))
 S ACRL=$O(^TMP("ACR",$J,"D",$E(ACRDOCNO,1,10),9999999),-1)
 S ACRN=$$NTDAYS(ACRL,ACRF)
 S $P(X,U,11)=$$SLDATE^ACRFUTL(ACRF)
 S $P(X,U,12)=$$SLDATE^ACRFUTL(ACRL)
 S $P(X,U,13)=ACRN
 S ^TMP("ACR",$J,"T",$E(ACRDOCNO,1,10),1,0)=X
 Q
UNIX(ACRFILE)      ;
 ;----- WRITE ^TMP GLOBAL TO UNIX FILE
 ;
 N %FILE,ACRCNT,ACRDOCDA,ACROUT,X
 Q:'$D(^TMP("ACR",$J,"T"))
 D HFS(.ACROUT,.%FILE,ACRFILE)
 Q:$G(ACROUT)
 U %FILE
 S ACRCNT=0
 S ACRDOCDA=0
 F  S ACRDOCDA=$O(^TMP("ACR",$J,"T",ACRDOCDA)) Q:'ACRDOCDA  D
 . S ACRCNT=$G(ACRCNT)+1
 . S X=$G(^TMP("ACR",$J,"T",ACRDOCDA,1,0))
 . D WRITE(X)
 . S X=$G(^TMP("ACR",$J,"T",ACRDOCDA,2,0))
 . D WRITE(X)
 . W !
 U 0 W !!,ACRCNT_" Records have been put into file "_ACRFILE
 D ^%ZISC
 H 3
 Q
WRITE(X) ;
 ;----- FORMAT AND WRITE DATA TO UNIX FILE
 ;
 N I,Y
 F I=1:1:$L(X,U) D
 . S Y=$P(X,U,I)
 . W """"
 . W Y
 . W """"
 . W ","
 Q
DATES(ACRDATES)    ;
 ;----- ASK DATE RANGE
 ;
DLOOP ;----- DATE LOOP   
 ;
 N ACRBEG,ACREND,DIR,DIRUT,DTOUT,DUOUT,X,Y
 W !
 S DIR(0)="DO^::E"
 S DIR("A")="Start with first TRAVEL BEGIN DATE"
 S DIR("?")="The first BEGINNING DATE OF TRAVEL to include in the report"
 D ^DIR
 Q:$D(DTOUT)!($D(DUOUT))!($D(DIRUT))
 Q:Y=""
 S ACRBEG=Y
 S DIR("A")="End with last TRAVEL BEGIN DATE"
 S DIR("?")="The last BEGINNING DATE OF TRAVEL to include in the report"
 D ^DIR
 Q:$D(DTOUT)!($D(DUOUT))!($D(DIRUT))
 Q:Y=""
 S ACREND=Y
 I ACREND<ACRBEG D  G DLOOP
 . W *7,!?5,"ENDING DATE cannot be less than BEGINNING DATE"
 S ACRDATES=ACRBEG_U_ACREND
 Q
FILE(ACRFILE)      ;
 ;----- ASK FILE NAME
 ;
 N DIR,DIRUT,DTOUT,DUOUT,X,Y
 S ACRFILE=""
 S DIR(0)="F"
 S DIR("A")="Select OUTPUT FILE NAME"
 S DIR("?")="The name of the OUTPUT FILE you want to put the data into"
 D ^DIR
 Q:$D(DTOUT)!($D(DUOUT))!($D(DIRUT))
 S ACRFILE=Y_".csv"
 Q
HFS(ACROUT,%FILE,ACRFILE)    ;
 ;----- CREATE AND OPEN FILE
 ;
 N POP,X,Y,ZISH1,ZISH2,ZISH3,ZISH4
 S ZISH1="FILE"
 ;S ZISH2="/usr/ACR/alb/"                      ;ACR*2.1*13.06 IM14144
 S ZISH2=$$ARMSDIR^ACRFSYS(1)                  ;ACR*2.1*13.06 IM14144
 S ZISH3=ACRFILE
 S ZISH4="W"
 D OPEN^%ZISH(ZISH1,ZISH2,ZISH3,ZISH4)
 I POP D  Q
 . W "CANNOT OPEN FILE "_ZISH2_ZISH3
 . S ACROUT=1
 S %FILE=IO
 Q
LOC(X) ;----- RETURNS INTERNAL LOCATION IEN OF TRAVELER OFFICIAL DUTY STATION
 ;
 ;      X  =  TRAVELER IEN
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^ACRAU(X,1)),U)
 Q Y
ASUFAC(D0)         ;
 ;----- RETURN LOCATION ASUFAC CODE
 ;
 ;      D0 =  LOCATION IEN
 ;
 N Y
 S Y=""
 I D0 X $G(^DD(9999999.06,.0799,9.2))
 S Y=$P($G(Y(9999999.06,.0799,3)),U,10)
 Q Y
CAN(X) ;----- RETURN EXTERNAL CAN NUMBER
 ;
 ;      X  =  DOCUMENT IEN
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^ACRDOC(X,"REQ")),U,10)
 I Y S Y=$P($G(^ACRCAN(Y,0)),U)
 I Y S Y=$P($G(^AUTTCAN(Y,0)),U)
 Q Y
TVLR(X) ;----- RETURN TRAVELER IEN
 ;
 ;      X  =  DOCUMENT IEN
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^ACRDOC(X,"TO")),U,9)
 Q Y
NAME(X) ;----- RETURN EXTERNAL TRAVELER NAME
 ;
 ;      X  =  TRAVELER IEN
 ;
 N Y
 S Y=""
 ;I X S Y=$P($G(^VA(200,X,0)),U)  ;ACR*2.1*19.02 IM16848
 I X S Y=$$NAME2^ACRFUTL1(X)  ;ACR*2.1*19.02 IM16848
 Q Y
TDAYS(ACRDOCDA,ACRDOCNO)     ;
 ;----- BUILDS TRAVEL DAY ARRAY
 ;
 N X,Y,Z
 S Y=""
 S X=0
 F  S X=$O(^ACRTV("D",ACRDOCDA,X)) Q:'X  D
 . S Z=$P($G(^ACRTV(X,"DT")),U)
 . Q:'Z
 . S ^TMP("ACR",$J,"D",$E(ACRDOCNO,1,10),Z,0)=$$SLDATE^ACRFUTL(Z)
 Q
NTDAYS(X1,X2)      ;
 ;----- RETURN TRAVEL TRAVEL DAYS
 ;
 N %Y,X,Y
 S Y=""
 D ^%DTC
 I %Y S Y=X
 Q Y
TVLF(X) ;----- RETURNS EXTERNAL TRAVEL FROM CITY^STATE
 ;
 ;      X  =  DOCUMENT IEN
 ;
 N Y
 S Y=""
 I X S X=$P($G(^ACRDOC(X,13)),U)
 I X S Y=$$CITY(X)
 Q Y
TVLT(X) ;----- RETURNS EXTERNAL TRAVEL TO CITY^STATE
 ;
 ;      X  =  DOCUMENT IEN
 ;
 N Y,Z
 S Y=""
 I X S Z=$O(^ACRDOC(X,9,0))
 I Z S Z=$P($G(^ACRDOC(X,9,Z,0)),U)
 I Z S Y=$$CITY(Z)
 Q Y
CITY(X) ;----- RETURNS EXTERNAL ARMS PER DIEM CITY^STATE
 ;
 ;      X  =  CITY IEN
 ;
 N Y
 S Y=""
 I X S X=$G(^ACRPD(X,0))
 S Y=$P(X,U)
 S X=$P(X,U,2)
 I X S X=$P($G(^DIC(5,X,0)),U,2)
 S Y=Y_U_X
 Q Y
PURP(X) ;----- RETURN PURPOSE OF TRAVEL
 ;
 ;      X  =  DOCUMENT IEN
 ;
 N I,G,Y,Z
 S Y=""
 F G="JST","JST2" D
 . S Z=$G(^ACROBL(X,G))
 . F I=1:1:5 D
 . . I $P(Z,U,I)]"" S Y=Y_" "_$P(Z,U,I)
 Q Y
STAT(X) ;----- RETURNS DOCUMENT STATUS
 ;
 ;      X  =  DOCUMENT IEN
 ;
 N ACRREF,Y,Z
 S Y=""
 S Z=$G(^ACRDOC(X,0))
 I $L($P(Z,U))'=10 Q Y
 S ACRREF=$P(Z,U,13)
 I ACRREF S ACRREF=$P($G(^AUTTDOCR(ACRREF,0)),U)
 S Z=$G(^ACROBL(X,"APV"))
 I ACRREF=130 S Z=$P(Z,U),Y="TO"
 I ACRREF=600 S Z=$P(Z,U,8),Y="TV"
 I $P($G(^ACRDOC(X,0)),U,14)["CANCELLED" S Z="C"
 S Y=Y_$S(Z="A":" APPROVED",Z="D":" DISAPPROVED",Z="C":" CANCELLED",1:" PENDING")
 Q Y
SEX(X) ;----- RETURNS GENDER
 ;
 ;      X  =  TRAVELER
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^VA(200,X,1)),U,2)
 Q Y
PAYPLAN(X)         ;
 ;----- RETURNS PAY PLAN OF TRAVELER
 ;
 ;      X  =  TRAVELER
 ;
 N Y
 S Y=""
 I X S X=$G(^ACRAU(X,1))
 S Y=$P(X,U,3)
 Q Y
GRADE(X) ;----- RETURNS GRADE OF TRAVELER
 ;
 ;      X  =  TRAVELER
 ;
 N Y
 S Y=""
 I X S X=$G(^ACRAU(X,1))
 S Y=$P(X,U,4)
 Q Y
SER(X) ;----- RETURNS SERIES OF TRAVELER
 ;
 ;      X  =  TRAVELER
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^ACRAU(X,1)),U,8)
 Q Y
ODS(X) ;----- RETURNS OFFICAL DUTY STATION
 ;
 ;      X  =  TRAVELER
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^ACRAU(X,1)),U)
 I Y S Y=$P($G(^AUTTLOC(Y,0)),U)
 I Y S Y=$P($G(^DIC(4,Y,0)),U)
 Q Y
ODSA(X) ;----- RETURNS OFFICIAL DUTY STATION AREA
 ;
 ;      X  =  TRAVELER
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^ACRAU(X,1)),U)
 I Y S Y=$P($G(^AUTTLOC(Y,0)),U,4)
 I Y S Y=$P($G(^AUTTAREA(Y,0)),U)
 Q Y
REQ(X) ;----- RETURNS AMOUNT REQUESTED
 ;
 ;      X  =  DOCUMENT IEN
 N Y
 S Y=""
 I X S Y=$P($G(^ACROBL(X,0)),U)
 Q Y
OBL(X) ;----- RETURNS AMOUNT OBLIGATED
 ;
 ;      X  =  DOCUMENT IEN
 N Y
 S Y=""
 I X S Y=$P($G(^ACROBL(X,"DT")),U,4)
 Q Y
SPNT(X) ;----- RETURNS AMOUNT SPENT
 ;
 ;      X  =  DOCUMENT IEN
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^ACROBL(X,"DT")),U,2)
 Q Y
TXT ;----- PRINT OPTION TEXT
 ;
 N I,X
 F I=1:1 S X=$P($T(DESC+I),";",3) Q:X["$$END"  W !,X
 Q
