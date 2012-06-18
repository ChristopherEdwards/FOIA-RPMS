ABMEH31 ; IHS/ASDST/DMJ - HCFA-1500 EMC RECORD DA1 (Insurance Information) ;   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/ASDS/LSL - 04/05/01 - V2.4 Patch 9 - NOIS NHA-0600-180066
 ;     Need to 0 fill numeric fields in the DA1 record.  The fields
 ;     are Disallowed other (121-127), Allowed amount (128-134), 
 ;     Deductible amount (135-141), and Coinsurance amount (142-148).
 ;
 ; *********************************************************************
 ;
START ;START HERE
 K ABMR(31),ABMREC(31,ABME("S#"))
 S ABME("RTYPE")=31       ; Record type
 D SET^ABMERUTL
 D PAYED^ABMERUTL
 D ADDR
 D LOOP
 D S90^ABMERUTL           ; Increment record type counter
 K ABMADR,ABMP("PAYED")
 Q
 ;
LOOP ;LOOP HERE
 F I=10:10:260 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),31,I)) D @(^(I))
 .I '$G(ABMP("NOFMT")) S ABMREC(31,ABME("S#"))=$G(ABMREC(31,ABME("S#")))_ABMR(31,I)
 Q
 ;
10 ;1-3 Record ID
 S ABMR(31,10)="DA1"
 Q
 ;
20 ;4-5 Sequence #
 S ABMR(31,20)="0"_ABME("S#")
 S ABMR(31,20)=$$FMT^ABMERUTL(ABMR(31,20),2)
 Q
 ;
30 ;6-22 Patient Control Number
 S ABMR(31,30)=ABMP("PCN")
 S ABMR(31,30)=$$FMT^ABMERUTL(ABMR(31,30),17)
 Q
 ;
40 ;23-52 Payor Address Line 1
 S ABMR(31,40)=ABMADR(2)
 S ABMR(31,40)=$$FMT^ABMERUTL(ABMR(31,40),30)
 Q
 ;
50 ;53-82 Payor Address Line 2
 S ABMR(31,50)=""
 S ABMR(31,50)=$$FMT^ABMERUTL(ABMR(31,50),30)
 Q
 ;
60 ;83-102 Payor City
 S ABMR(31,60)=ABMADR(3)
 S ABMR(31,60)=$$FMT^ABMERUTL(ABMR(31,60),20)
 Q
 ;
70 ;103-104 Payor State
 S ABMR(31,70)=ABMADR(4)
 S ABMR(31,70)=$$FMT^ABMERUTL(ABMR(31,70),2)
 Q
 ;
80 ;103-113 Payor Zip
 S ABMR(31,80)=ABMADR(5)
 S ABMR(31,80)=$$FMT^ABMERUTL(ABMR(31,80),"9")
 Q
90 ;114-120 Dissallowed Cost Cont
 S ABMR(31,90)=""
 S ABMR(31,90)=$$FMT^ABMERUTL(ABMR(31,90),7)
 Q
100 ;121-127 Disallowed Other
 S ABMR(31,100)=""
 S ABMR(31,100)=$$FMT^ABMERUTL(ABMR(31,100),"7NRJ2")
 Q
110 ;128-134 Allowed Amount
 S ABMR(31,110)=""
 S ABMR(31,110)=$$FMT^ABMERUTL(ABMR(31,110),"7NRJ2")
 Q
120 ;135-141 Deductible Amount
 S ABMR(31,120)=""
 S ABMR(31,120)=$$FMT^ABMERUTL(ABMR(31,120),"7NRJ2")
 Q
130 ;142-148 Coinsurance Amount
 S ABMR(31,130)=""
 S ABMR(31,130)=$$FMT^ABMERUTL(ABMR(31,130),"7NRJ2")
 Q
140 ;149-155 Payor Amount Payed
 S ABMR(31,140)=$G(ABMP("PAYED",+ABME("INS")))
 S ABMR(31,140)=$$FMT^ABMERUTL(ABMR(31,140),"7NRJ2")
 Q
150 ;156-156 Zero Pay Indicator
 S ABMR(31,150)=""
 S ABMR(31,150)=$$FMT^ABMERUTL(ABMR(31,150),1)
 Q
160 ;157-158 Adjucation Ind 1
 S ABMR(31,160)=""
 S ABMR(31,160)=$$FMT^ABMERUTL(ABMR(31,160),2)
 Q
170 ;159-160 Adjudication Ind 2
 S ABMR(31,170)=""
 S ABMR(31,170)=$$FMT^ABMERUTL(ABMR(31,170),2)
 Q
180 ;161-162 Adjudication Ind 3
 S ABMR(31,180)=""
 S ABMR(31,180)=$$FMT^ABMERUTL(ABMR(31,180),2)
 Q
190 ;163-163 Champus Spnsr Branch
 S ABMR(31,190)=""
 S ABMR(31,190)=$$FMT^ABMERUTL(ABMR(31,190),1)
 Q
200 ;164-165 Champus Spnsr Grade
 S ABMR(31,200)=""
 S ABMR(31,200)=$$FMT^ABMERUTL(ABMR(31,200),2)
 Q
210 ;166-166 Champus Spnsr Status
 S ABMR(31,210)=""
 S ABMR(31,210)=$$FMT^ABMERUTL(ABMR(31,210),1)
 Q
220 ;167-174 Ins Card Effect Date
 S ABMR(31,220)=""
 S ABMR(31,220)=$$FMT^ABMERUTL(ABMR(31,220),8)
 Q
230 ;175-182 Ins Card Term Date
 S ABMR(31,230)=""
 S ABMR(31,230)=$$FMT^ABMERUTL(ABMR(31,230),8)
 Q
240 ;183-189 Balance Due
 S ABMR(31,240)=""
 S ABMR(31,240)=$$FMT^ABMERUTL(ABMR(31,240),7)
 Q
250 ;190-252 Filler (National)
 S ABMR(31,250)=""
 S ABMR(31,250)=$$FMT^ABMERUTL(ABMR(31,250),63)
 Q
260 ;301-320 Filler (Local)
 S ABMR(31,260)=""
 S ABMR(31,260)=$$FMT^ABMERUTL(ABMR(31,260),68)
 Q
ADDR ;Payor Address Info
 K ABMADR
 N I F I=1:1:5 S ABMADR(I)=$P(^AUTNINS(ABME("INS"),0),"^",I)
 S ABMADR(4)=$P($G(^DIC(5,+ABMADR(4),0)),"^",2)
 Q
EX(ABMX,ABMY,ABMZ) ;EXTRINSIC FUNCTION HERE
 ;
 ;  INPUT:  ABMX = data element
 ;          ABMY = bill internal entry number
 ;          ABMZ = Insurer priority (1 thru 3)
 ;
 ; OUTPUT:     Y = bill internal entry number
 ;
 S ABMP("BDFN")=ABMY
 D SET^ABMERUTL
 S ABME("INS")=ABMZ
 I '$D(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"B",ABME("INS"))) S Y="" Q Y
 D ISET^ABMERINS
 I '$G(ABMP("NOFMT")) S ABMP("FMT")=0
 D @ABMX
 S Y=ABMR(31,ABMX)
 I $D(ABMP("FMT")) S ABMP("FMT")=1
 K ABMR(31,ABMX),ABME,ABMX,ABMY,ABMZ,ABM
 Q Y
