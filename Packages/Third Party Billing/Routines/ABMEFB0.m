ABMEFB0 ; IHS/ASDST/DMJ - HCFA-1500 EMC RECORD FB0 (Medical Segment) ;    
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20395
 ;   Split out lines bundled by rev code
 ;
START ;START HERE
 K ABMR(62),ABMREC(62)
 D LOOP
 S ABME("RTYPE")=62 D S90^ABMERUTL
 S ABMEF("LINE")=ABMREC(62)
 D WRITE^ABMEF19
 Q
LOOP ;LOOP HERE
 F I=10:10:360 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),62,I)) D @(^(I))
 .I '$G(ABMP("NOFMT")) S ABMREC(62)=$G(ABMREC(62))_ABMR(62,I)
 Q
10 ;1-3 Record type
 S ABMR(62,10)="FB0"
 Q
20 ;4-5 Sequence 
 S ABMR(62,20)=ABME("S#")
 S ABMR(62,20)=$$FMT^ABMERUTL(ABMR(62,20),"2NR")
 Q
30 ;6-22 Patient Control Number
 S ABMR(62,30)=ABMP("PCN")
 S ABMR(62,30)=$$FMT^ABMERUTL(ABMR(62,30),17)
 Q
40 ;23-39 Line Item Control #
 S ABMR(62,40)=""
 S ABMR(62,40)=$$FMT^ABMERUTL(ABMR(62,40),17)
 Q
50 ;40-46 Purchase Service Charge
 S ABMR(62,50)=""
 S ABMR(62,50)=$$FMT^ABMERUTL(ABMR(62,50),"7NRJ2")
 Q
60 ;47-53 Allowed Amount
 S ABMR(62,60)=""
 S ABMR(62,60)=$$FMT^ABMERUTL(ABMR(62,60),"7NRJ2")
 Q
70 ;54-60 Deductible Amount
 S ABMR(62,70)=""
 S ABMR(62,70)=$$FMT^ABMERUTL(ABMR(62,70),"7NRJ2")
 Q
80 ;61-67 Coinsurance Amount
 S ABMR(62,80)=""
 S ABMR(62,80)=$$FMT^ABMERUTL(ABMR(62,80),"7NRJ2")
 Q
90 ;68-82 Ordering Provider ID
 S ABMR(62,90)=$P(ABMRV(J,K,L),U,16)
 S ABMR(62,90)=$$FMT^ABMERUTL(ABMR(62,90),15)
 Q
100 ;83-84 Ordering Provider State
 S ABMR(62,100)=""
 S ABMR(62,100)=$$FMT^ABMERUTL(ABMR(62,100),2)
 Q
110 ;85-99 Purchase Service Provider ID
 S ABMR(62,110)=""
 S ABMR(62,110)=$$FMT^ABMERUTL(ABMR(62,110),15)
 Q
120 ;100-101 Purchase Service Provider State
 S ABMR(62,120)=""
 S ABMR(62,120)=$$FMT^ABMERUTL(ABMR(62,120),2)
 Q
130 ;102-105 Pen Grams of Protein
 S ABMR(62,130)=""
 S ABMR(62,130)=$$FMT^ABMERUTL(ABMR(62,130),"4NR")
 Q
140 ;106-109 Pen Calories
 S ABMR(62,140)=""
 S ABMR(62,140)=$$FMT^ABMERUTL(ABMR(62,140),"4NR")
 Q
150 ;110-120 National Drug Code
 S ABMR(62,150)=$P(ABMRV(J,K,L),U,15)
 S ABMR(62,150)=$$FMT^ABMERUTL(ABMR(62,150),11)
 Q
160 ;121-127 National Drug Units
 S ABMR(62,160)=$P(ABMRV(J,K,L),U,5)
 S ABMR(62,160)=$$FMT^ABMERUTL(ABMR(62,160),"7NR")
 Q
170 ;128-142 Prescription #
 S ABMR(62,170)=$P(ABMRV(J,K,L),U,13)
 S ABMR(62,170)=$$FMT^ABMERUTL(ABMR(62,170),15)
 Q
180 ;143-150 Prescription Date
 S ABMR(62,180)=$P(ABMRV(J,K,L),U,10)
 S ABMR(62,180)=$$FMT^ABMERUTL(ABMR(62,180),8)
 Q
190 ;151-152 Prescription # of Months
 S ABMR(62,190)=""
 S ABMR(62,190)=$$FMT^ABMERUTL(ABMR(62,190),"2NR")
 Q
200 ;153-153 Special Pricing Indicator
 S ABMR(62,200)=""
 S ABMR(62,200)=$$FMT^ABMERUTL(ABMR(62,200),1)
 Q
210 ;154-154 Copay Status Indicator
 S ABMR(62,210)=""
 S ABMR(62,210)=$$FMT^ABMERUTL(ABMR(62,210),1)
 Q
220 ;155-155 EPSDT Indicator
 S ABMR(62,220)=""
 S ABMR(62,220)=$$FMT^ABMERUTL(ABMR(62,220),1)
 Q
230 ;156-156 Family Planning Indicator     
 S ABMR(62,230)=""
 S ABMR(62,230)=$$FMT^ABMERUTL(ABMR(62,230),1)
 Q
240 ;157-157 DME Charge Indicator
 S ABMR(62,240)=""
 S ABMR(62,240)=$$FMT^ABMERUTL(ABMR(62,240),1)
 Q
250 ;158-172 HPSA Facility ID
 S ABMR(62,250)=""
 S ABMR(62,250)=$$FMT^ABMERUTL(ABMR(62,250),15)
 Q
260 ;173-181 HPSA Facility Zip
 S ABMR(62,260)=""
 S ABMR(62,260)=$$FMT^ABMERUTL(ABMR(62,260),9)
 Q
270 ;182-214 Purchase Service Name
 S ABMR(62,270)=""
 S ABMR(62,270)=$$FMT^ABMERUTL(ABMR(62,270),33)
 Q
280 ;215-244 Purchase Service Address1
 S ABMR(62,280)=""
 S ABMR(62,280)=$$FMT^ABMERUTL(ABMR(62,280),30)
 Q
290 ;245-274 Purchase Service Address2
 S ABMR(62,290)=""
 S ABMR(62,290)=$$FMT^ABMERUTL(ABMR(62,290),30)
 Q
300 ;275-294 Purchase Service City
 S ABMR(62,300)=""
 S ABMR(62,300)=$$FMT^ABMERUTL(ABMR(62,300),20)
 Q
310 ;295-303 Purchase Service Zip
 S ABMR(62,310)=""
 S ABMR(62,310)=$$FMT^ABMERUTL(ABMR(62,310),9)
 Q
320 ;304-313 Purchase Service Phone
 S ABMR(62,320)=""
 S ABMR(62,320)=$$FMT^ABMERUTL(ABMR(62,320),10)
 Q
330 ;314-316 Drug Days Supply
 S ABMR(62,330)=$P(ABMRV(J,K,L),U,14)
 S ABMR(62,330)=$$FMT^ABMERUTL(ABMR(62,330),"3NR")
 Q
340 ;317-317 Refill Indicator
 S ABMR(62,340)="N"
 S:$P(ABMRV(J,K,L),U,17) ABMR(62,340)="Y"
 S ABMR(62,340)=$$FMT^ABMERUTL(ABMR(62,340),1)
 Q
350 ;318-318 Brand Need Indicator
 S ABMR(62,350)=""
 S ABMR(62,350)=$$FMT^ABMERUTL(ABMR(62,350),1)
 Q
360 ;319-320 Filler (Local)
 S ABMR(62,360)=""
 S ABMR(62,360)=$$FMT^ABMERUTL(ABMR(62,360),2)
 Q
EX(ABMX,ABMY,ABMZ) ;EXTRINSIC FUNCTION HERE
 ;X=data element, Y=bill internal entry number
 S ABMP("BDFN")=ABMY D SET^ABMERUTL
 I '$G(ABMP("NOFMT")) S ABMP("FMT")=0
 D @ABMX
 S Y=ABMR(62,ABMX)
 I $D(ABMP("FMT")) S ABMP("FMT")=1
 K ABMR(62,ABMX),ABME,ABMX,ABMY,ABMZ,ABM
 Q Y