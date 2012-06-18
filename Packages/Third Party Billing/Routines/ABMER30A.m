ABMER30A ; IHS/ASDST/DMJ - UB92 EMC RECORD 30 (Third Party Payor) cont'd ;   
 ;;2.6;IHS Third Party Billing System;**3**;NOV 12, 2009
 ;Original;DMJ;04/12/96 3:31 PM
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM19557 - Patient name if Non-Ben
 ; IHS/SD/SDR - v2.5 p10 - IM20225 - Check for DME group number
 ; IHS/SD/SDR - abm*2.6*3 - HEAT8996 - get group number for Medicaid
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
10 ;Record type
 S ABMR(30,10)=30
 Q
 ;
20 ;Payor Priority (SOURCE: FILE=9002274.4013, FIELD=.02)
 S ABMR(30,20)="0"_ABME("S#")
 S ABMR(30,20)=$$FMT^ABMERUTL(ABMR(30,20),2)
 Q
 ;
30 ;Patient Control Number, (SOURCE: FILE=9000001.41,FIELD=.02)
 S ABMR(30,30)=$$EX^ABMER20(30,ABMP("BDFN"))
 S ABMR(30,30)=$$FMT^ABMERUTL(ABMR(30,30),20)
 Q
 ;
40 ;Source Payment Code (SOURCE: FILE=9999999.18, FIELD=.21)
 S ABMR(30,40)=$S(ABME("ITYPE")="W":"B",ABME("ITYPE")="R":"C",ABME("ITYPE")="D"!(ABME("ITYPE")="K"):"D",$G(ABME("BCBS")):"G",ABME("ITYPE")="P":"F",1:"H")
 Q
 ;
50 ;Receiver Identification (SOURCE: FILE=9999999.18, FIELD=.08)
 S ABMR(30,50)=$$RCID^ABMERUTL(ABME("INS"))
 S:$$ENVOY^ABMEF16 ABMR(30,50)=$$ENVY^ABMERUTL(ABME("INS"),"H")
 S ABMR(30,50)=$$FMT^ABMERUTL(ABMR(30,50),5)
 Q
 ;         
60 ;Receiver Sub Identification (SOURCE: FILE=, FIELD=)
 ; form locator 51
 S ABMR(30,60)=$G(ABMR(30,60))
 S ABMR(30,60)=$$FMT^ABMERUTL(ABMR(30,60),"4R")
 Q
 ;
70 ;Claim Certificate ID Number (SOURCE: FILE=, FIELD=)
 ; form locator 60
 ; (previously set in ^ABMERINS)
 S ABMR(30,70)=$G(ABMR(30,70))
 S ABMR(30,70)=$$FMT^ABMERUTL(ABMR(30,70),19)
 Q
 ;
80 ;Insurance Company Name (SOURCE: FILE=9999999.18, FIELD=.01)
 ; form locator 50
 S ABMR(30,80)=$P(^AUTNINS(ABME("INS"),0),U)
 I ABME("ITYPE")="D"!(ABME("ITYPE")="K") D
 .Q:ABMR(30,80)'["NEW MEXICO"
 .Q:ABMR(30,80)'["MEDICAID"
 .S ABMR(30,80)="MEDICAID"
 I ABME("ITYPE")="N" S ABMR(30,80)=ABMP("PNAME")
 S ABMR(30,80)=$$FMT^ABMERUTL(ABMR(30,80),25)
 Q
 ;
90 ;Payer Code (SOURCE: FILE=, FIELD=)
 S ABMR(30,90)=$S(ABME("ITYPE")="R":"Z",ABME("ITYPE")="W":"E",ABME("ITYPE")="D"!(ABME("ITYPE")="K"):1,$G(ABME("BCBS")):2,1:3)
 Q
 ;
100 ;Group ID Number (SOURCE: FILE=9999999.77, FIELD=.02)
 ; form locator 62
 S ABMR(30,100)=$P($G(^AUTNEGRP(+$G(ABME("GRP")),0)),"^",2)
 S ABMR(30,100)=$$FMT^ABMERUTL(ABMR(30,100),17)
 Q
 ;
110 ;Group Name (SOURCE: FILE=9999999.77, FIELD=.01)
 ; form locator 61
 S ABMR(30,110)=$P($G(^ABMNINS(DUZ(2),ABME("INS"),1,ABMP("VTYP"),1)),U,3)
 I $G(ABMR(30,110))="" D
 .S ABMR(30,110)=$G(ABM(9000003.1,+$G(ABME("PH")),.06,"E"))
 .I ABMR(30,110)="",ABME("ITYPE")="P" S ABMR(30,110)="UNKNOWN"
 .I ABMR(30,110)="",ABME("ITYPE")="D",$G(ABME("GRP")) S ABMR(30,110)=$P($G(^AUTNEGRP(ABME("GRP"),0)),U)  ;abm*2.6*3 HEAT8996
 S ABMR(30,110)=$$FMT^ABMERUTL(ABMR(30,110),14)
 Q
 ;
120 ;Insured's Last Name (SOURCE: FILE=, FIELD=)     
 ; form locator 58
 S ABMR(30,120)=$P(ABME("PHNM"),",",1)
 S ABMR(30,120)=$$FMT^ABMERUTL(ABMR(30,120),20)
 Q
 ;
130 ;Insured's First Name (SOURCE: FILE=, FIELD=)
 ; form locator 58
 S ABMR(30,130)=$P(ABME("PHNM"),",",2),ABMR(30,130)=$P(ABMR(30,130)," ",1)
 S ABMR(30,130)=$$FMT^ABMERUTL(ABMR(30,130),9)
 Q
 ;
140 ;Insured's Middle Initial (SOURCE: FILE=, FIELD=)
 ; form locator 58
 S ABMR(30,140)=$P(ABME("PHNM"),",",2)
 S ABMR(30,140)=$P(ABMR(30,140)," ",2)
 S ABMR(30,140)=$E(ABMR(30,140))
 S ABMR(30,140)=$$FMT^ABMERUTL(ABMR(30,140),1)
 Q
 ;
150 ;Insured's Sex (SOURCE: FILE=, FIELD=)
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
