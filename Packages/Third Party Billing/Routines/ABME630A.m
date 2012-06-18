ABME630A ; IHS/ASDST/DMJ - UB92 EMC RECORD 30 (Third Party Payor) cont'd ;   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;DMJ;04/12/96 3:31 PM
 ;
 ; IHS/ASDS/DMJ - 01/23/01 - V2.4 Patch 3 - NOIS HQW-0101-100032
 ; Created routine to correct rejections for Medicare electronic trans.
 ;
 ; IHS/ASDS/SDH - 9/27/01 - V2.4 Patch 9 - NOIS XAA-0901-200095
 ;     After moving Kidscare to Page 5 from Page 7 found that there are 
 ;     checks that are done for Medicaid that should also be done for
 ;     Kidscare
 ;
 ; *********************************************************************
 ;
LOOP2 ;LOOP HERE
 F I=10:10:150 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),30,I)) D @(^(I))
 .I '$G(ABMP("NOFMT")) S ABMREC(30,ABME("S#"))=$G(ABMREC(30,ABME("S#")))_ABMR(30,I)
 Q
 ;
10 ;1-2, Record type
 S ABMR(30,10)=30
 Q
 ;
20 ;3-4, Payor Priority
 S ABMR(30,20)="0"_ABME("S#")
 S ABMR(30,20)=$$FMT^ABMERUTL(ABMR(30,20),2)
 Q
 ;
30 ;5-24, Patient Control Number
 S ABMR(30,30)=$$EX^ABMER20(30,ABMP("BDFN"))
 S ABMR(30,30)=$$FMT^ABMERUTL(ABMR(30,30),20)
 Q
 ;
40 ;25-25, Source Payment Code
 S ABMR(30,40)=$S(ABME("ITYPE")="W":"B",ABME("ITYPE")="R":"C",ABME("ITYPE")="D"!(ABME("ITYPE")="K"):"D",$G(ABME("BCBS")):"G",ABME("ITYPE")="P":"F",1:"H")
 Q
 ;
50 ;26-34, Receiver Identification
 S ABMR(30,50)=$P($G(^AUTNINS(ABME("INS"),0)),"^",8)
 S ABMR(30,50)=$$FMT^ABMERUTL(ABMR(30,50),"5NR")
 S ABMR(30,50)=$$FMT^ABMERUTL(ABMR(30,50),9)
 Q
 ;
60 ;35-53, Claim Certificate ID Number
 ; form locator 60
 ; (previously set in ^ABMERINS)
 S ABMR(30,60)=$G(ABMR(30,70))
 S ABMR(30,60)=$$FMT^ABMERUTL(ABMR(30,70),19)
 Q
 ;
70 ;54-55, Payer Identification Indicator
 S ABMR(30,70)="  "
 Q
 ;
80 ;56-78, Payer Name
 ; form locator 50
 S ABMR(30,80)=$P(^AUTNINS(ABME("INS"),0),U)
 I ABME("ITYPE")="D"!(ABME("ITYPE")="K") D
 .Q:ABMR(30,80)'["NEW MEXICO"
 .S ABMR(30,80)="MEDICAID"
 S ABMR(30,80)=$$FMT^ABMERUTL(ABMR(30,80),23)
 Q
 ;
90 ;79-79, Payer Code
 S ABMR(30,90)=$S(ABME("ITYPE")="R":"Z",ABME("ITYPE")="W":"E",ABME("ITYPE")="D"!(ABME("ITYPE")="K"):1,$G(ABME("BCBS")):2,1:3)
 Q
 ;
100 ;80-96, Group ID Number
 ; form locator 62
 S ABMR(30,100)=$P($G(^AUTNEGRP(+$G(ABME("GRP")),0)),"^",2)
 S ABMR(30,100)=$$FMT^ABMERUTL(ABMR(30,100),17)
 Q
 ;
110 ;97-110, Group Name
 ; form locator 61
 S ABMR(30,110)=$G(ABM(9000003.1,+$G(ABME("PH")),.06,"E"))
 I ABMR(30,110)="",ABME("ITYPE")="P" S ABMR(30,110)="UNKNOWN"
 S ABMR(30,110)=$$FMT^ABMERUTL(ABMR(30,110),14)
 Q
 ;
120 ;111-130, Insured's Last Name
 ; form locator 58
 S ABMR(30,120)=$P(ABME("PHNM"),",",1)
 S ABMR(30,120)=$$FMT^ABMERUTL(ABMR(30,120),20)
 Q
 ;
130 ;131-139, Insured's First Name
 ; form locator 58
 S ABMR(30,130)=$P(ABME("PHNM"),",",2),ABMR(30,130)=$P(ABMR(30,130)," ",1)
 S ABMR(30,130)=$$FMT^ABMERUTL(ABMR(30,130),9)
 Q
 ;
140 ;140-140, Insured's Middle Initial
 ; form locator 58
 S ABMR(30,140)=$P(ABME("PHNM"),",",2)
 S ABMR(30,140)=$P(ABMR(30,140)," ",2)
 S ABMR(30,140)=$E(ABMR(30,140))
 S ABMR(30,140)=$$FMT^ABMERUTL(ABMR(30,140),1)
 Q
 ;
150 ;141-141, Insured's Sex
 I $G(ABME("PHSEX")) S ABMR(30,150)=ABME("PHSEX")
 E  S ABMR(30,150)=$$EX^ABMER20A(70,ABMP("BDFN"))
 S ABMR(30,150)=$$FMT^ABMERUTL(ABMR(30,150),1)
 Q
 ;
DIQ1 ;PULL BILL DATA VIA DIQ1
 Q:$D(ABM(9002274.4,ABMP("BDFN"),ABME("FLD")))
 N I
 S DIQ="ABM("
 S DIQ(0)="EI"
 S DIC="^ABMDBILL(DUZ(2),"
 S DA=ABMP("BDFN")
 S DR=".66;.67;.68;.73;.74;.75;.99"
 D EN^DIQ1
 K DIQ
 Q
 ;
DIQ2 ;POLICY HOLDER INFORMATION
 Q:'$G(ABME("PH"))
 Q:$D(ABM(9000003.1,ABME("PH"),ABME("FLD")))
 N I
 S DIQ="ABM("
 S DIQ(0)="EI"
 S DIC="^AUPN3PPH("
 S DA=ABME("PH")
 S DR=".02;.15"
 D EN^DIQ1
 K DIQ
 Q
 ;
DIQ3 ;PATIENT IS INSURED    
 Q:$D(ABM(2,ABMP("PDFN"),ABME("FLD")))
 N I
 S DIQ="ABM("
 S DIQ(0)="EI"
 S DIC="^DPT("
 S DA=ABMP("PDFN")
 S DR=".31115"
 D EN^DIQ1
 K DIQ
 Q
 ;
EX(ABMX,ABMY,ABMZ) ;EXTRINSIC FUNTION HERE
 ;
 ;  INPUT:  ABMX = data element
 ;          ABMY = bill internal entry number
 ;          ABMZ = insurer
 ;
 ; OUTPUT:     Y = Bill internal entry number
 ;
 S ABMP("BDFN")=ABMY
 D SET^ABMERUTL
 S ABME("INS")=ABMZ
 I '$D(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"B",ABME("INS"))) S Y="" Q Y
 S ABME("S#")=0
 D ISET^ABMERINS
 I '$G(ABMP("NOFMT")) S ABMP("FMT")=0
 D @ABMX
 S Y=ABMR(30,ABMX)
 I $D(ABMP("FMT")) S ABMP("FMT")=1
 K ABMR(30,ABMX),ABMX,ABMY,ABME,ABM
 Q Y
