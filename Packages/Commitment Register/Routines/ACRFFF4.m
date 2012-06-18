ACRFFF4 ;IHS/OIRM/DSD/AEF - PRODUCE FLAT FILE OF TRAINING INFORMATION [ 09/23/2005   4:18 PM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**13,19**;NOV 05, 2001
 ;
DESC ;----- ROUTINE DESCRIPTION
 ;;Create Training Information Flat File
 ;;
 ;;This option will gather all training documents within the
 ;;specified date range and place them into a UNIX comma
 ;;delimited flat file which can then be imported into an
 ;;Access or Excel spreadsheet.
 ;;
 ;;Fields included in the flat file are:
 ;;      1. ASUFAC Code                    14. Training Hours (Duty)
 ;;      2. CAN Number                     15. Tuition & Fees
 ;;      3. Training Order Number          16. Books & Other
 ;;      4. Attendee Name                  17. Travel Order Number
 ;;      5. Official Duty Station          18. Travel From City
 ;;      6. ODS Area                       19. Travel From State
 ;;      7. Gender                         20. Travel To City
 ;;      8. Pay Plan                       21. Travel To State
 ;;      9. Grade                          22. Transportation Cost
 ;;     10. Series                         23. Per Diem
 ;;     11. Training Begin Date            24. Other Expenses
 ;;     12. Training End Date              25. Travel Mgt. Fee
 ;;     13. Training Course Title          26. Training Order Status
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
 I '$D(^TMP("ACR",$J,"G")) D  Q
 . W !!,"No data found"
 . D PAUSE^ACRFWARN
 ;
 D UNIX(ACRFILE)
 ;
 ;K ^TMP("ACR",$J)
 ;
 D ^%ZISC
 ;
 D PAUSE^ACRFWARN
 ;
 Q
GET(ACRDATES)      ;
 ;----- LOOP THROUGH TRAINING ORDERS AND PUT DATA INTO ^TMP GLOBAL
 ;
 N ACRDATA,ACRDOCDA,ACRDOCNO,ACRREF,ACRTONO
 ;
 K ^TMP("ACR",$J)
 ;
 S ACRREF=$O(^AUTTDOCR("B",148,0))
 S ACRDOCDA=0
 F  S ACRDOCDA=$O(^ACRDOC("REF",ACRREF,ACRDOCDA)) Q:'ACRDOCDA  D
 . S ACRDATA=$G(^ACRDOC(ACRDOCDA,"TRNG"))
 . Q:$P(ACRDATA,U,11)<$P(ACRDATES,U)
 . Q:$P(ACRDATA,U,11)>$P(ACRDATES,U,2)
 . D ONE(ACRDOCDA)
 ;
 Q
ONE(ACRDOCDA)      ;
 ;----- GATHER DATA FOR ONE DOCUMENT AND PUT INTO ^TMP GLOBAL         
 ; 
 ;      ACRATT    =  ATTENDEE IEN
 ;      ACRDOCDA  =  TRAINING DOCUMENT IEN
 ;      ACRDOCNO  =  TRAINING DOCUMENT NUMBER
 ;      ACRTODA   =  TRAVEL DOCUMENT IEN
 ;      ACRTONO   =  TRAVEL DOCUMENT NUMBER
 ;
 N ACRDOCNO,ACRTODA,ACRTONO,Z
 ;
 S ACRDOCNO=$$DOCNO(ACRDOCDA)
 S ACRATT=$P($G(^ACRDOC(ACRDOCDA,"TRNG")),U,2)
 S ACRTODA=$P($G(^ACRDOC(ACRDOCDA,"TRNGTO")),U)
 S ACRTONO=""
 I ACRTODA D
 . S ACRTONO=$P($G(^ACRDOC(ACRTODA,0)),U)
 ;
 ;TUITION & FEES, BOOKS & OTHER, PER DIEM, ETC.
 I ACRDOCDA D AMTS(ACRDOCDA)
 I ACRTODA D AMTS(ACRTODA)
 ;
 ;
 ;----- SET DATA INTO ^TMP GLOBAL
 ;
 S $P(Z,U)=$$ASUFAC($$LOC(ACRATT))
 S $P(Z,U,2)=$$CAN(ACRDOCDA)
 S $P(Z,U,3)=ACRDOCNO
 S $P(Z,U,4)=$$NAME(ACRDOCDA)
 S $P(Z,U,5)=$$ODS(ACRATT)
 S $P(Z,U,6)=$$ODSA(ACRATT)
 S $P(Z,U,7)=$$SEX(ACRATT)
 S $P(Z,U,8)=$$PAYPLAN(ACRATT)
 S $P(Z,U,9)=$$GRADE(ACRATT)
 S $P(Z,U,10)=$$SER(ACRATT)
 S $P(Z,U,11)=$$BEG(ACRDOCDA)
 S $P(Z,U,12)=$$END(ACRDOCDA)
 S $P(Z,U,13)=$$TITLE(ACRDOCDA)
 S $P(Z,U,14)=$$HRS(ACRDOCDA)
 I ACRDOCNO]"" D
 . S $P(Z,U,15)=$G(^TMP("ACR",$J,"AMT",ACRDOCNO,"Tuition & Fees",0))
 . S $P(Z,U,16)=$G(^TMP("ACR",$J,"AMT",ACRDOCNO,"Books & Other",0))
 I ACRTONO]"" D
 . S $P(Z,U,17)=ACRTONO
 . S $P(Z,U,18)=$P($$TVLF(ACRTODA),U)
 . S $P(Z,U,19)=$P($$TVLF(ACRTODA),U,2)
 . S $P(Z,U,20)=$P($$TVLT(ACRTODA),U)
 . S $P(Z,U,21)=$P($$TVLT(ACRTODA),U,2)
 . S $P(Z,U,22)=$G(^TMP("ACR",$J,"AMT",ACRTONO,"Travel-DHHS",0))
 . S $P(Z,U,23)=$G(^TMP("ACR",$J,"AMT",ACRTONO,"Per Diem-DHHS",0))
 . S $P(Z,U,24)=$G(^TMP("ACR",$J,"AMT",ACRTONO,"Other Exp-DHHS",0))
 . S $P(Z,U,25)=$G(^TMP("ACR",$J,"AMT",ACRTONO,"Travel Mgt Fee",0))
 S $P(Z,U,26)=$$STAT(ACRDOCDA)
 ;
 S ^TMP("ACR",$J,"G",$E(ACRDOCNO,1,10),ACRDOCNO,0)=Z
 ;
 I '$D(^TMP("ACR",$J,"G",$E(ACRDOCNO,1,10),0)) D  Q
 . S ^TMP("ACR",$J,"G",$E(ACRDOCNO,1,10),0)=Z
 ;
 S Y=$G(^TMP("ACR",$J,"G",$E(ACRDOCNO,1,10),0))
 I $$DT($P(Z,U,11))>0,$$DT($P(Z,U,11))<$$DT($P(Y,U,11)) S $P(Y,U,11)=$P(Z,U,11) ;TRAINING BEGIN DATE
 I $$DT($P(Z,U,12))>0,$$DT($P(Z,U,12))>$$DT($P(Y,U,12)) S $P(Y,U,12)=$P(Z,U,12) ;TRAINING END DATE
 S $P(Y,U,15)=$P(Y,U,15)+$P(Z,U,15) ;TUITION & FEES
 S $P(Y,U,16)=$P(Y,U,16)+$P(Z,U,16) ;BOOKS & OTHER
 S $P(Y,U,22)=$P(Y,U,22)+$P(Z,U,22) ;TRANSPORTATION COST
 S $P(Y,U,23)=$P(Y,U,23)+$P(Z,U,23) ;PER DIEM
 S $P(Y,U,24)=$P(Y,U,24)+$P(Z,U,24) ;OTHER EXPENSES
 S $P(Y,U,25)=$P(Y,U,25)+$P(Z,U,25) ;TRAVEL MGT FEE
 ;
 S ^TMP("ACR",$J,"G",$E(ACRDOCNO,1,10),0)=Y
 Q
UNIX(ACRFILE)      ;
 ;----- WRITE ^TMP GLOBAL TO UNIX FILE
 ;
 N %FILE,ACRCNT,ACRDOCDA,ACROUT,X
 Q:'$D(^TMP("ACR",$J,"G"))
 D HFS(.ACROUT,.%FILE,ACRFILE)
 Q:$G(ACROUT)
 U %FILE
 S ACRCNT=0
 S ACRDOCDA=""
 F  S ACRDOCDA=$O(^TMP("ACR",$J,"G",ACRDOCDA)) Q:ACRDOCDA']""  D
 . S X=$G(^TMP("ACR",$J,"G",ACRDOCDA,0))
 . S ACRCNT=$G(ACRCNT)+1
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
 ;
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
 S DIR("A")="Start with first TRAINING BEGIN DATE"
 S DIR("?")="The first BEGINNING DATE OF TRAINING to include in the report"
 D ^DIR
 Q:$D(DTOUT)!($D(DUOUT))!($D(DIRUT))
 Q:Y=""
 S ACRBEG=Y
 S DIR("A")="End with last TRAINING BEGIN DATE"
 S DIR("?")="The last BEGINNING DATE OF TRAINING to include in the report"
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
 ;S ZISH2="/usr/ACR/alb/"                   ;ACR*2.1*13.06 IM14144
 S ZISH2=$$ARMSDIR^ACRFSYS(1)               ;ACR*2.1*13.06 IM14144
 S ZISH3=ACRFILE
 S ZISH4="W"
 D OPEN^%ZISH(ZISH1,ZISH2,ZISH3,ZISH4)
 I POP D  Q
 . W "CANNOT OPEN FILE "_ZISH2_ZISH3
 . S ACROUT=1
 S %FILE=IO
 Q
LOC(X) ;----- RETURN INTERNAL LOCATION IEN OF TRAVELER OFFICIAL DUTY STATION
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
CAN(ACRDOCDA)      ;
 ;----- RETURN EXTERNAL CAN NUMBER
 ;
 N Y
 S Y=""
 S Y=$P($G(^ACRDOC(ACRDOCDA,"REQ")),U,10)
 I Y S Y=$P($G(^ACRCAN(Y,0)),U)
 I Y S Y=$P($G(^AUTTCAN(Y,0)),U)
 Q Y
NAME(ACRDOCDA)     ;
 ;----- RETURN EXTERNAL TRAINEE NAME
 ;
 N Y
 S Y=""
 S Y=$P($G(^ACRDOC(ACRDOCDA,"TRNG")),U,2)
 ;I Y S Y=$P($G(^VA(200,Y,0)),U)  ;ACR*2.1*19.02 IM16848
 I Y S Y=$$NAME2^ACRFUTL1(Y)  ;ACR*2.1*19.02 IM16848
 Q Y
AMTS(ACRDOCDA)     ;
 ;----- BUILDS TUITION & FEES, BOOKS & OTHER, TRAVEL, PER DIEM,
 ;      OTHER EXP, TRAVEL MGT FEE ARRAY
 ;
 N ACRAMT,ACRD0,ACRDATA,ACRDOCNO,ACRKW,X
 ;
 S ACRDOCNO=$P($G(^ACRDOC(ACRDOCDA,0)),U)
 Q:ACRDOCNO']""
 S ACRD0=0
 F  S ACRD0=$O(^ACRSS("C",ACRDOCDA,ACRD0)) Q:'ACRD0  D
 . S ACRKW=$P($G(^ACRSS(ACRD0,"NMS")),U,5)
 . Q:ACRKW']""
 . S ACRDATA=$G(^ACRSS(ACRD0,"DT"))
 . S ACRAMT=$P(ACRDATA,U,4)
 . I $P($G(^ACRSS(ACRD0,"APV")),U,2)="A" D
 . . S ACRAMT=$P(ACRDATA,U,9)
 . S ^TMP("ACR",$J,"AMT",ACRDOCNO,ACRKW,0)=ACRAMT
 Q
STAT(ACRDOCDA)     ;
 ;----- RETURNS DOCUMENT STATUS
 ;
 N Y
 S Y=$P($G(^ACROBL(ACRDOCDA,"APV")),U)
 S Y="350 "_$S(Y="A":"APPROVED",Y="D":"DISAPPROVED",Y="C":"CANCELLED",1:"PENDING")
 Q Y
TXT ;----- PRINT OPTION TEXT
 ;
 N I,X
 F I=1:1 S X=$P($T(DESC+I),";",3) Q:X["$$END"  W !,X
 Q
DT(X) ;----- RETURNS FM DATE
 ;
 ;      X = EXTERNAL DATE, IE., 01/10/2002
 ;
 N Y
 S %DT=""
 D ^%DT
 Q Y
DOCNO(X) ;----- RETURNS DOCUMENT NUMBER 
 ;
 ;      X  =  DOCUMENT IEN
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^ACRDOC(X,0)),U)
 Q Y
TVLF(X) ;----- RETURNS EXTERNAL TRAVEL FROM CITY^STATE  
 ;
 ;      X  =  DOCUMENT IEN
 ;
 N Y,Z
 S Y=""
 I X S Z=$P($G(^ACRDOC(X,13)),U)
 S Y=$$CITY(Z)
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
 ;      X  =  PER DIEM CITY IEN
 ;
 N Y
 S Y=""
 I X S X=$G(^ACRPD(X,0))
 S Y=$P(X,U)
 S X=$P(X,U,2)
 I X S X=$P($G(^DIC(5,X,0)),U,2)
 S Y=Y_U_X
 Q Y
ODS(X) ;----- RETURNS OFFICIAL DUTY STATION
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
SEX(X) ;----- RETURNS GENDER
 ;
 ;      X  =  TRAVELER
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^VA(200,X,1)),U,2)
 Q Y
PAYPLAN(X) ;----- RETURNS PAY PLAN OF TRAVELER
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
BEG(X) ;----- RETURNS TRAINING BEGIN DATE
 ;
 ;      X  =  DOCUMENT IEN
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^ACRDOC(X,"TRNG")),U,11)
 I Y S Y=$$SLDATE^ACRFUTL(Y)
 Q Y
END(X) ;----- RETURNS TRAINING END DATE
 ;
 ;      X  =  DOCUMENT IEN
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^ACRDOC(X,"TRNG")),U,12)
 I Y S Y=$$SLDATE^ACRFUTL(Y)
 Q Y
TITLE(X) ;----- RETURNS TRAINING COURSE TITLE
 ;
 ;      X  =  DOCUMENT IEN
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^ACRDOC(X,"TRNG")),U,18)
 Q Y
HRS(X) ;----- RETURNS TRAINING HOURS (DUTY)
 ;
 ;      X  =  DOCUMENT IEN
 ;
 N Y
 S Y=""
 I X S Y=$P($G(^ACRDOC(X,"TRNG")),U,9)
 Q Y
