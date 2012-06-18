BARDUTL ; IHS/SD/LSL - DATE UTILITIES FOR A/R PACKAGE ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**4,6**;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 02/20/04 - V1.7 Patch 5 - REMARK CODES
 ;      New utility to read in string to local array for printing
 ;
 ; IHS/SD/LSL - 03/29/04 - V1.8
 ;      Added TRANS utility to find all $$ for specific trans type
 ;      on a bill.
 ;
 ; ********************************************************************
 ;
SDT(X) ; EP - Y is set to the printable date ##/##/## from X (fileman date)
 N Y
 S Y=$S(+X>0:$E(X,4,5)_"/"_$E(X,6,7)_"/"_($E(X,1,3)+1700),1:"")  ;Y2000
 Q Y
 ;start new code IHS/SD/SDR bar*1.8*6 4.1.3
 ; *********************************************************************
SHDT(X) ; EP - Y is set to the printable date ##/##/## from X (fileman date)
 N Y
 S Y=$S(+X>0:$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3),1:"")  ;Y2000
 Q Y
 ;end new code bar*1.8*6
 ; *********************************************************************
 ;
HDT(X) ;EP - Y is set to the printable date ##-##-## from X (fileman date)
 N Y
 S Y=$S(+X>0:$E(X,4,5)_"-"_$E(X,6,7)_"-"_($E(X,1,3)+1700),1:"")  ;Y2000
 Q Y
 ; *********************************************************************
 ;
CDT(X) ;EP - Y= date/time ##/##/##@##:## from X (fm date) for display in claim editor
 N Y
 I '+X S Y="" Q Y
 S Y=$E(X,4,5)_"/"_$E(X,6,7)_"/"_($E(X,1,3)+1700)  ;Y2000
 I '$P(X,".",2) Q Y
 S BARTIME=$P(X,".",2)
 S BARTIME=BARTIME_"00"
 S Y=Y_"@"_$E(BARTIME,1,2)_":"_$E(BARTIME,3,4)
 Q Y
 ; *********************************************************************
 ;start new code IHS/SD/SDR bar*1.8*4 DD item 4.1.5.4
 ;
TDT(X) ;EP - Y= date/time ##/##/##@##:##:## from X (fm date) for display of formatted trans date
 N Y
 I '+X S Y="" Q Y
 S Y=$E(X,4,5)_"/"_$E(X,6,7)_"/"_($E(X,1,3)+1700)
 I '$P(X,".",2) Q Y
 S BARTIME=$P(X,".",2)
 S BARTIME=BARTIME_"00"
 S Y=Y_"@"_$E(BARTIME,1,2)_":"_$E(BARTIME,3,4)_":"_$E(BARTIME,5,6)
 Q Y
 ; *********************************************************************
 ;end new code IHS/SD/SDR bar*1.8*4 DD item 4.1.5.4
 ;
MDT(X) ;EP - printable date and time in menu header format
 S BAR("DATE")=+$E(X,6,7)_"-"_$P($T(MTHS+1),";;",+$E(X,4,5)+1)_"-"_($E(X,1,3)+1700)  ;Y2000
 S BAR("TIME")=$P(X,".",2)
 I BAR("TIME")'="" D
 .S BAR("TIME")="."_BAR("TIME")
 .S BAR("TIME")=$E(X,8,15)+.0000001
 .S BAR("AMPM")=$S(BAR("TIME")>.1159999:"PM",1:"AM")
 .I BAR("TIME")>.1259999 S BAR("TIME")=BAR("TIME")-.12
 .S BAR("TIME")=+$E(BAR("TIME"),2,3)_":"_$E(BAR("TIME"),4,5)_" "_BAR("AMPM")
 .S BAR("TIME")=" "_BAR("TIME")
 S X=BAR("DATE")_BAR("TIME")
 K BAR("DATE"),BAR("TIME"),BAR("AMPM")
 Q X
 ; *********************************************************************
 ;
MDT2(X) ;EP - printable date, letter format
 S X=+$E(X,6,7)_" "_$P($T(MTHS+1),";;",+$E(X,4,5)+1)_" "_($E(X,1,3)+1700)  ;Y2000
 Q X
 ; *********************************************************************
 ;
Y2KDT(X) ;EP - date from fileman to Y2K format Y=MMDDCCYY
 N Y
 I X="" Q X
 S Y=$E(X,4,7)_($E(X,1,3)+1700)
 Q Y
 ; *********************************************************************
Y2KD2(X) ;EP - date from fileman to Y2K format Y=CCYYMMDD
 N Y
 I X="" Q X
 S Y=($E(X,1,3)+1700)_$E(X,4,7)
 Q Y
 ; *********************************************************************
 ;
MTHS ;MONTHS
 ;;JAN;;FEB;;MAR;;APR;;MAY;;JUN;;JUL;;AUG;;SEP;;OCT;;NOV;;DEC
 ; *********************************************************************
 ;
HRN(X) ;EP - Y is set to the printable HRN
 ;     for patient BARP("PDFN") at location BARP("LDFN")
 S Y=$S('$G(BARP("PDFN")):"[no PAT]",'$G(BARP("LDFN")):"[no LOC]",$D(^AUPNPAT(BARP("PDFN"),41,BARP("LDFN"),0)):"[HRN:"_$P(^(0),U,2)_"]",1:"[no HRN]")
 Q Y
 ; *********************************************************************
 ;
CSZ(X) ;EP - Y is set to the printable City, State ZIP CODE
 ; X incoming variable must = CITY^ST^ZIP
 S Y=$S($G(X)="":"no address",$P(X,U)="":"no city",'$P(X,U,2):"no state",$P($G(^DIC(5,$P(X,U,2),0)),U,2)="":"invalid state",'$P(X,U,3):"no zip",1:$P(X,U)_", "_$P(^(0),U,2)_"  "_$P(X,U,3))
 Q Y
 ; *********************************************************************
 ;
TM(X,Y) ;EP - FIGURE TOTAL MINUTES GIVEN FM DATE/TIMES IN X AND Y
 I X="" Q X
 I Y="" S X="" Q X
 D H^%DTC
 S BAR(1,1)=%H
 S BAR(1,2)=%T
 S X=Y
 D H^%DTC
 S BAR(2,1)=%H
 S BAR(2,2)=%T
 S BAR("D")=BAR(2,1)-BAR(1,1)*24*60*60
 S BAR("T")=BAR(2,2)-BAR(1,2)
 S BAR("TS")=BAR("D")+BAR("T")
 S X=BAR("TS")\60
 Q X
 ; *********************************************************************
 ;
PAT(X) ;EP - DISPLAY PATIENT HEADER WITH IDENTIFIERS - X=DFN
 S $P(BAR("="),"=",80)=""
 W $$EN^BARVDF("IOF")
 W !,$$EN^BARVDF("RVN"),"PATIENT:",$$EN^BARVDF("RVF"),"  "
 S BAR("P0")=^DPT(X,0)
 W $P(BAR("P0"),"^",1),"     ",$P(BAR("P0"),"^",2)
 S BAR("DOB")=$P(BAR("P0"),"^",3)
 W "  ",$E(BAR("DOB"),4,5),"/",$E(BAR("DOB"),6,7),"/",($E(BAR("DOB"),1,3)+1700)  ;Y2000
 S BAR("SSN")=$P(BAR("P0"),"^",9)
 W "  ",$E(BAR("SSN"),1,3),"-",$E(BAR("SSN"),4,5),"-",$E(BAR("SSN"),6,9)
 W "  ","HRN: ",$P($G(^AUPNPAT(X,41,DUZ(2),0)),"^",2)
 W !,BAR("=")
 Q
 ; *********************************************************************
 ;
DATE(X) ;EP - ask beginning and ending date
 S %DT="AEP"
 S %DT("A")="Select "_$P("Beginning^Ending","^",X)_" Date: "
 D ^%DT
 Q Y
 ; *********************************************************************
 ;
MSG(DATA,PRE,POST,BEEP)      ;EP; Writes line to device
 N X,Y
 I PRE>0 F I=1:1:PRE W !
 W DATA
 I POST>0 F I=1:1:POST W !
 I $G(BEEP)>0 F I=1:1:BEEP W $C(7)
 Q
 ; *********************************************************************
 ;
ARDAYS ; EP
 ; Computed field (File 90050.0204, Field .07)
 N I,J,BAREND,CBAREND
 S J=D1
 S BAREND=0
 F I=1:1:3 D  Q:'+J
 . S J=$O(^BARAC(DUZ(2),D0,4,J),-1)  ; Previous entry
 . Q:'+J
 . S BAR(0)=$G(^BARAC(DUZ(2),D0,4,J,0))
 . S BARTMP=$P(BAR(0),U,2)+$P(BAR(0),U,4)-$P(BAR(0),U,5)-$P(BAR(0),U,6)
 . S BAREND=BAREND+BARTMP
 I '+J S X="" Q
 S BAREND=BAREND/3
 S BAR(0)=$G(^BARAC(DUZ(2),D0,4,D1,0))
 S CBAREND=$P(BAR(0),U,2)+$P(BAR(0),U,4)-$P(BAR(0),U,5)-$P(BAR(0),U,6)
 S X=CBAREND/BAREND
 Q
 ; *********************************************************************
 ;
VARDAYS ; EP
 ; Computed field (File 90050.0205, Field .07)
 N I,J,BAREND,CBAREND
 S J=D2
 S BAREND=0
 F I=1:1:3 D  Q:'+J
 . S J=$O(^BARAC(DUZ(2),D0,4,D1,1,J),-1)  ; Previous entry
 . Q:'+J
 . S BAR(0)=$G(^BARAC(DUZ(2),D0,4,D1,1,J,0))
 . S BAREND=$P(BAR(0),U,2)+$P(BAR(0),U,4)-$P(BAR(0),U,5)-$P(BAR(0),U,6)
 I '+J S X="" Q
 S BAREND=BAREND/3
 S BAR(0)=$G(^BARAC(DUZ(2),D0,4,D1,1,D2,0))
 S CBAREND=$P(BAR(0),U,2)+$P(BAR(0),U,4)-$P(BAR(0),U,5)-$P(BAR(0),U,6)
 S X=CBAREND/BAREND
 Q
 ; *********************************************************************
 ;
CARDAYS ; EP
 ; Computed field (File 90050.0205, Field .07)
 N I,J,BAREND,CBAREND
 S J=D2
 S BAREND=0
 F I=1:1:3 D  Q:'+J
 . S J=$O(^BARAC(DUZ(2),D0,4,D1,2,J),-1)  ; Previous entry
 . Q:'+J
 . S BAR(0)=$G(^BARAC(DUZ(2),D0,4,D1,2,J,0))
 . S BAREND=$P(BAR(0),U,2)+$P(BAR(0),U,4)-$P(BAR(0),U,5)-$P(BAR(0),U,6)
 I '+J S X="" Q
 S BAREND=BAREND/3
 S BAR(0)=$G(^BARAC(DUZ(2),D0,4,D1,2,D2,0))
 S CBAREND=$P(BAR(0),U,2)+$P(BAR(0),U,4)-$P(BAR(0),U,5)-$P(BAR(0),U,6)
 S X=CBAREND/BAREND
 Q
 ;
 ; ********************************************************************
WP(BARSTR,BARRAY,BARLNGTH) ; EP
 ; Used to read string into array where each line is less than
 ; specified length
 Q:'$D(BARSTR)!'$D(BARRAY)!'$D(BARLNGTH)
 S BARCNT=0
 F  D READ  Q:$L(BARSTR)=0
 K BARSTR,BARLNGTH,BARWORD,BARTXT,BARCNT
 Q
 ; ********************************************************************
 ;
READ ;
 ; Loop through String
 Q:$L(BARSTR)=0                        ; Nothing left in string
 S BARWORD=0
 K BARTXT
 F  D READWORD  Q:$L(BARTXT)>BARLNGTH  Q:$L(BARSTR)=0
 Q
 ; ********************************************************************
 ;
READWORD ;
 ; Loop each "word" of string
 S BARWORD=BARWORD+1
 S BARTXT=$P(BARSTR," ",1,BARWORD)
 I $L(BARSTR)=$L(BARTXT) D LASTLINE Q
 I $L(BARTXT)>BARLNGTH D SETLINE
 Q
 ; ********************************************************************
 ;
SETLINE ;
 S BARCNT=BARCNT+1
 S BARIDR=BARRAY_"("_$J_","_BARCNT_")"
 S @BARIDR=$P(BARSTR," ",1,BARWORD-1)
 S BARSTR=$P(BARSTR," ",BARWORD,9999999999)
 Q
 ; ********************************************************************
 ;
LASTLINE ;
 S BARCNT=BARCNT+1
 S BARIDR=BARRAY_"("_$J_","_BARCNT_")"
 S @BARIDR=BARSTR
 S BARSTR=""
 Q
 ; ********************************************************************
 ;
TRANS(BARDUZ,BAR,BARTYPE) ; EP
 ; BARDUZ  = DUZ(2)
 ; BAR     = AR BILL IEN
 ; BARTYPE = TYPE OF TRANSACTION
 ;         = A - Adjustment $
 ;         = C - Copay $
 ;         = P - Paid $
 ;         = D - Deductible $
 I '+$G(BARDUZ) Q 0
 I '+$G(BAR) Q 0
 I $G(BARTYPE)="" Q 0
 K BARAMT
 N BARHOLD,BARTR
 S BARHOLD=DUZ(2)
 I '$D(^BARTR(DUZ(2),"AC",BAR)) Q 0
 S DUZ(2)=BARDUZ
 S BARTR=0
 F  S BARTR=$O(^BARTR(DUZ(2),"AC",BAR,BARTR)) Q:'+BARTR  D TRANS2
 S DUZ(2)=BARHOLD
 I '$D(BARAMT) Q 0
 Q +$G(BARAMT(BARTYPE))
 ; ********************************************************************
 ;
TRANS2 ;
 Q:'$D(^BARTR(DUZ(2),BARTR,0))
 S BARAMT("C")=$G(BARAMT("C"))+$$GET1^DIQ(90050.03,BARTR,3.714)
 S BARAMT("D")=$G(BARAMT("D"))+$$GET1^DIQ(90050.03,BARTR,3.713)
 S BARAMT("A")=$G(BARAMT("A"))+$$GET1^DIQ(90050.03,BARTR,3.7)
 I $P($G(^BARTR(DUZ(2),BARTR,1)),U)=40 D
 . S BARAMT("P")=$G(BARAMT("P"))+$$GET1^DIQ(90050.03,BARTR,3.5)
 Q
