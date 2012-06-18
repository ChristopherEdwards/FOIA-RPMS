ABMEH20 ; IHS/ASDST/DMJ - HCFA-1500 EMC RECORD CA0 (Patient) ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;DMJ;02/26/96 5:11 PM
 ;
 ; IHS/ASDS/DMJ - 05/03/01 - V2.4 Patch 5 - NOIS HQW-0401-100014
 ;     Modified to strip dash from zip code
 ;
 ; IHS/FCS/DRS - 09/17/01 - V2.4 P 9 - no incr tax id! 
 ;
START ;START HERE
 K ABMREC(20),ABMR(20)
 S ABME("RTYPE")=20
 K ABMP("SET")
 D SET^ABMERUTL,LOOP
 D S90^ABMERUTL
 K ABME,ABM
 Q
 ;
LOOP ;LOOP HERE
 F I=10:10:310 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),20,I)) D @(^(I))
 .I '$G(ABMP("NOFMT")) S ABMREC(20)=$G(ABMREC(20))_ABMR(20,I)
 Q
10 ;1-3 Record ID
 S ABMR(20,10)="CA0"
 Q
20 ;4-5 Filler
 S ABMR(20,20)=""
 S ABMR(20,20)=$$FMT^ABMERUTL(ABMR(20,20),2)
 Q
30 ;6-22 Patient Control Number
 S ABMR(20,30)=ABMP("PCN")
 S ABMR(20,30)=$$FMT^ABMERUTL(ABMR(20,30),17)
 Q
40 ;23-42 Patient Last Name
 D PNM^ABMER20A
 S ABMR(20,40)=$P(ABME("PNM"),",",1)
 S ABMR(20,40)=$$FMT^ABMERUTL(ABMR(20,40),20)
 Q
50 ;43-54 Patient First Name
 S ABMR(20,50)=$P(ABME("PNM"),",",2)
 S ABMR(20,50)=$P(ABMR(20,50)," ",1)
 S ABMR(20,50)=$$FMT^ABMERUTL(ABMR(20,50),12)
 Q
60 ;55-55 Patient MI
 S ABMR(20,60)=$P(ABME("PNM"),",",2)
 S ABMR(20,60)=$P(ABMR(20,60)," ",2)
 S ABMR(20,60)=$$FMT^ABMERUTL(ABMR(20,60),1)
 Q
70 ;56-58 Patient Generation
 S ABMR(20,70)=""
 S ABMR(20,70)=$$FMT^ABMERUTL(ABMR(20,70),3)
 Q
80 ;59-66 Patient DOB
 S ABMR(20,80)=$$Y2KD2^ABMDUTL(ABME("DOB"))
 Q
90 ;67-67 Patient Sex
 S ABMR(20,90)=$S(ABME("SEX")="":"U",1:ABME("SEX"))
 Q
100 ;68-68 Patient Type of Residence
 S ABMR(20,100)=" "
 Q
110 ;69-98 Patient Address 1
 D ADR
 S ABMR(20,110)=ABME("AD1")
 S ABMR(20,110)=$$FMT^ABMERUTL(ABMR(20,110),30)
 Q
120 ;99-128 Patient Address 2
 S ABMR(20,120)=ABME("AD2")
 S ABMR(20,120)=$$FMT^ABMERUTL(ABMR(20,120),30)
 Q
130 ;129-148 Patient City
 S ABMR(20,130)=ABME("AD4")
 S ABMR(20,130)=$$FMT^ABMERUTL(ABMR(20,130),20)
 Q
140 ;149-150 Patient State
 S ABMR(20,140)=ABME("AD5")
 S:ABMR(20,140)="" ABMR(20,140)="  "
 Q
150 ;151-159 Patient Zip
 S ABMR(20,150)=ABME("AD6")
 S ABMR(20,150)=$$FMT^ABMERUTL(ABMR(20,150),"9S")
 Q
160 ;160-169 Patient Phone
 S ABMR(20,160)=$P($G(^DPT(+ABMP("PDFN"),.13)),U)
 S:ABMR(20,160)="" ABMR(20,160)=$P($G(^DPT(+ABMP("PDFN"),.13)),"^",2)
 S ABMR(20,160)=$TR(ABMR(20,160),"()- ")
 S ABMR(20,160)=$$FMT^ABMERUTL(ABMR(20,160),10)
 Q
170 ;170-170 Patient Marital Status
 S ABMR(20,170)=$P($G(^DPT(+ABMP("PDFN"),0)),"^",5)
 S:ABMR(20,170) ABMR(20,170)=$E("DM WXSU",ABMR(20,170))
 S ABMR(20,170)=$$FMT^ABMERUTL(ABMR(20,170),1)
 Q
180 ;171-171 Patient Student Status
 S ABMR(20,180)=" "
 Q
190 ;172-172 Patient Employment Status
 S ABMR(20,190)=$P($G(^AUPNPAT(+ABMP("PDFN"),0)),"^",21)
 S:ABMR(20,190)="" ABMR(20,190)=$P($G(^DPT(+ABMP("PDFN"),.311)),"^",15)
 S ABMR(20,190)=$$FMT^ABMERUTL(ABMR(20,190),1)
 Q
200 ;173-173 Patient Death Indicator
 S ABMR(20,200)=" "
 S:$P($G(^DPT(+ABMP("PDFN"),.35)),U) ABMR(20,200)="D"
 Q
210 ;174-181 Patient Date of Death
 S ABMR(20,210)=$P($G(^DPT(+ABMP("PDFN"),.35)),U)
 S ABMR(20,210)=$$Y2KD2^ABMDUTL(ABMR(20,210))
 S ABMR(20,210)=$$FMT^ABMERUTL(ABMR(20,210),8)
 Q
220 ;182-182 Other Insurance Indicator
 S ABMR(20,220)=" "
 Q
230 ;183-183 Claim Editing Indicator
 S ABMR(20,230)=ABMP("SOP")
 Q
240 ;184-185 Type of Claim Indicator
 S ABMR(20,240)="  "
 Q
250 ;186-186 Legal Rep Indicator
 S ABMR(20,250)=" "
 Q
260 ;187-195 Origin Code
 S ABMR(20,260)=""
 S ABMR(20,260)=$$FMT^ABMERUTL(ABMR(20,260),9)
 Q
270 ;196-212 Payor Clm Control Number
 S ABMR(20,270)=""
 S ABMR(20,270)=$$FMT^ABMERUTL(ABMR(20,270),17)
 Q
280 ;213-227 Pay To Provider Number
 S ABMR(20,280)=""
 S ABMR(20,280)=$$FMT^ABMERUTL(ABMR(20,280),15)
 Q
290 ;228-233 Claim ID Number
 S ABMR(20,290)=""
 S ABMR(20,290)=$$FMT^ABMERUTL(ABMR(20,290),6)
 Q
300 ;234-237 For Encounter Data Only
 S ABMR(20,300)=""
 S ABMR(20,300)=$$FMT^ABMERUTL(ABMR(20,300),4)
 Q
310 ;238-320 Filler
 S ABMR(20,310)=""
 S ABMR(20,310)=$$FMT^ABMERUTL(ABMR(20,310),83)
 Q
ADR ;GET PATIENT ADDRESS FROM FILE 2
 ; I = 1 - Mailing Address - Street
 ;     2 - Street Address [line 2]
 ;     3 - Street Address [line 3]
 ;     4 - Mailing Address - City
 ;     5 - Mailing Address - State
 ;     6 - Mailing Address - Zip
 N I
 F I=1:1:6 S ABME("AD"_I)=$P($G(^DPT(+ABMP("PDFN"),.11)),"^",I)
 S ABME("AD5")=$P($G(^DIC(5,+ABME("AD5"),0)),"^",2)
 Q
DIQ1 ;PULL BILL DATA VIA DIQ1
 Q:$D(ABM(9002274.4,ABMP("BDFN"),ABME("FLD")))
 N I
 S DIQ="ABM("
 S DIQ(0)="EI"
 S DIC="^ABMDBILL(DUZ(2),"
 S DA=ABMP("BDFN")
 S DR=".01;.21;.51;.52;.53;.61;.62;.63;.64;.71;.72;.99"
 D EN^DIQ1
 K DIQ
 Q
 ;
EX(ABMX,ABMY) ;EP - EXTRINSIC FUNCTION HERE
 ;
 ;  INPUT:  ABMX = data element
 ;             Y = bill internal entry number
 ;
 ; OUTPUT:     Y = bill internal entry number
 ;
 S ABMP("BDFN")=ABMY
 D SET^ABMERUTL
 I '$G(ABMP("NOFMT")) S ABMP("FMT")=0
 D @ABMX
 S Y=ABMR(20,ABMX)
 K ABMR(20,ABMX),ABMX,ABMY
 I $D(ABMP("FMT")) S ABMP("FMT")=1
 Q Y
