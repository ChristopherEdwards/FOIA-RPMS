ABME520A ; IHS/ASDST/DMJ - UB92 EMC RECORD 20 (Patient) cont'd ;   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;DMJ;02/07/96 12:33 PM
 ;
 ;IHS/DSD/MRS - 7/15/1999 NOIS BXX-0799-150034 Patch 3 #3
 ;      Modified to allow spaces in patient last name   
 ;
 ; IHS/ASDS/LSL - 07/10/00 - V2.4 P2 - NOIS NDA-0700-180029
 ;     Modified to strip off the leading zero of admission source
 ;     and admission type.
 ;
 ; IHS/ASDS/LSL - 09/06/00 - V2.4 Patch 3 - NOIS CAA-0900-110008
 ;     If nothing in Admission Source or Admission Type, make it
 ;     null instead of 0 (zero).
 ;
 ; IHS/ASDS/DMJ - 06/14/01 - v2.4 Patch 5 - NOIS NAI-0601-180016
 ;    Modified to not check visit type, so if insurer is Medicare
 ;    and there is blank admission type, admission source, and patient
 ;    status 3p will insert a 1.
 ;
 ; IHS/ASDS/DMJ - 09/07/01 - V2.4 Patch 7 - NOIS HQW-0701-100066
 ;     Modifications made related to Medicare Part B
 ;
 ; IHS/ASDS/SDH - 09/27/01 - V2.4 Patch 9 - NOIS XAA-0901-200095
 ;     After moving Kidscare to Page 5 from Page 7 found that there are
 ;     checks that are done for Medicaid that should also be done for
 ;     Kidscare.
 ;
 ; *********************************************************************
 ;
LOOP ;LOOP HERE
 F I=10:10:110 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),20,I)) D @(^(I))
 .I '$G(ABMP("NOFMT")) S ABMREC(20)=$G(ABMREC(20))_ABMR(20,I)
 Q
 ;
10 ;Record type, 1-2
 S ABMR(20,10)=20
 Q
 ;
20 ;Filler (National Use), 3-4
 S ABMR(20,20)=""
 S ABMR(20,20)=$$FMT^ABMERUTL(ABMR(20,20),2)
 Q
 ;
30 ;Patient Control Number, 5-24 (SOURCE: FILE=9000001.41,FIELD=.02)
 S ABMR(20,30)=$$EX^ABMER20(30,ABMP("BDFN"))
 S ABMR(20,30)=$$FMT^ABMERUTL(ABMR(20,30),20)
 Q
 ;
40 ;Patient Last Name, 25-44 (SOURCE: FILE=2, FIELD=.01)
 ; form locator #12
 I '$D(ABME("PNM")) D PNM
 S ABMR(20,40)=$P(ABME("PNM"),",",1)
 I $P($G(^ABMDEXP(ABMP("EXP"),1)),"^",5)="E" S ABMR(20,40)=$TR(ABMR(20,40),"-,.'/")
 S ABMR(20,40)=$$FMT^ABMERUTL(ABMR(20,40),20)
 Q
 ;
50 ;Patient First Name, 45-53 (SOURCE: FILE=2, FIELD=.01)
 ; form locator #12
 I '$D(ABME("PNM")) D PNM
 S ABMR(20,50)=$P(ABME("PNM"),",",2)
 D
 .Q:ABMR(20,50)="BABY BOY"
 .Q:ABMR(20,50)="BABY GIRL"
 .S ABMR(20,50)=$P(ABMR(20,50)," ",1)
 S ABMR(20,50)=$$FMT^ABMERUTL(ABMR(20,50),9)
 Q
 ;
60 ;Patient Middle Initial, 54 (SOURCE: FILE=2, FIELD=.01)
 ; form locator #12
 I '$D(ABME("PNM")) D PNM
 S ABMR(20,60)=$P(ABME("PNM"),",",2)
 I ABMR(20,60)="BABY BOY" S ABMR(20,60)=" " Q
 I ABMR(20,60)="BABY GIRL" S ABMR(20,60)=" " Q
 S ABMR(20,60)=$P(ABMR(20,60)," ",2)
 S ABMR(20,60)=$E(ABMR(20,60))
 S ABMR(20,60)=$$FMT^ABMERUTL(ABMR(20,60),1)
 Q
 ;
70 ;Patient Sex Code, 55 (SOURCE: FILE=2, FIELD=.02)
 ; form locator #15
 I '$D(ABME("SEX")) D PNM
 S ABMR(20,70)=$S(ABME("SEX")="":"U",1:ABME("SEX"))
 Q
 ;
80 ;Patient's Birth Date, 56-63 (SOURCE: FILE=2, FIELD=.03)
 ; form locator #14
 I '$D(ABME("DOB")) D PNM
 S ABMR(20,80)=$$Y2KD2^ABMDUTL(ABME("DOB"))
 Q
 ;
90 ;Marital Status Code, 64 (SOURCE: FILE=2, FIELD=.05)
 ; form locator #16
 I '$D(ABME("MS")) D PNM
 S ABMR(20,90)=$S(ABME("MS")=1:"D",ABME("MS")=2:"M",ABME("MS")=4:"W",ABME("MS")=5:"X",ABME("MS")=6:"S",1:"U")
 Q
 ;
100 ;Type of Admission, 65 (SOURCE: FILE=9002274.4, FIELD=.51)
 ; form locator #19
 S ABME("FLD")=.51
 D DIQ1
 S ABMR(20,100)=+ABM(9002274.4,ABMP("BDFN"),.51,"E")
 ; if type of admission is "" and  visit type is outpatient and
 ;    insurance type is Medicare FI set type of admission to 1
 I 'ABMR(20,100),ABMP("VTYP")=131,ABMP("ITYPE")="R" S ABMR(20,100)=1
 S:'ABMR(20,100) ABMR(20,100)=""
 S ABMR(20,100)=$$FMT^ABMERUTL(ABMR(20,100),1)
 Q
 ;
110 ;Source of Admission, 66 (SOURCE: FILE=9002274.4, FIELD=.52)
 ; form locator #20
 S ABME("FLD")=.52
 D DIQ1
 S ABMR(20,110)=+ABM(9002274.4,ABMP("BDFN"),.52,"E")
 ; if type of admission is "" and visit type is outpatient and
 ;    insurance type is Medicare FI set type of admission to 1
 I 'ABMR(20,110),ABMP("ITYPE")="R" S ABMR(20,110)=1
 S:'ABMR(20,110) ABMR(20,110)=""
 S ABMR(20,110)=$$FMT^ABMERUTL(ABMR(20,110),1)
 Q
 ;
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
PNM ; EP
 ; Patient name
 K ABME("PNM"),ABME("DOB")
 ; if insurer type is Medicare FI
 I ABMP("ITYPE")="R" D
 .; if insurer name contains "MEDICARE"
 .I $P(^AUTNINS(ABMP("INS"),0),U)["MEDICARE" D
 ..; Medicare Patient name from MEDICARE ELIGIBLE
 ..S ABME("PNM")=$P($G(^AUPNMCR(ABMP("PDFN"),21)),U)
 ..S ABME("DOB")=$P($G(^AUPNMCR(ABMP("PDFN"),21)),"^",2) ; DOB
 .; If insurer name contains "RAILROAD"
 .I $P(^AUTNINS(ABMP("INS"),0),U)["RAILROAD" D
 ..; Railroad Patient name from RAILROAD ELIGIBLE
 ..S ABME("PNM")=$P($G(^AUPNRRE(ABMP("PDFN"),21)),U)
 ..S ABME("DOB")=$P($G(^AUPNRRE(ABMP("PDFN"),21)),"^",2) ; DOB
 ;
 ; if insurer type is Medicaid FI
 I ABMP("ITYPE")="D"!(ABMP("ITYPE")="K") D
 .Q:'$G(ABMCDNUM)
 .S ABME("PNM")=$P($G(^AUPNMCD(ABMCDNUM,21)),U) ; Pat name
 .S ABME("DOB")=$P($G(^AUPNMCD(ABMCDNUM,21)),"^",2) ; dob
 ;
 ; Else get from patient file
 S:$G(ABME("PNM"))="" ABME("PNM")=$P($G(^DPT(+ABMP("PDFN"),0)),U)
 S:$G(ABME("DOB"))="" ABME("DOB")=$P(^DPT(ABMP("PDFN"),0),"^",3)
 ; sex code & marital status
 S ABME("SEX")=$P(^DPT(ABMP("PDFN"),0),"^",2),ABME("MS")=$P(^(0),"^",5)
 Q
 ;
EX(ABMX,ABMY) ; EP
 ; Extrincic function here
 ;
 ;  INPUT: ABMX = data element
 ;            Y = bill internal entry number
 ;
 ; OUTPUT:    Y = bill internal entry number
 ;
 S ABMP("BDFN")=ABMY
 D SET^ABMERUTL
 I '$G(ABMP("NOFMT")) S ABMP("FMT")=0
 D @ABMX
 S Y=ABMR(20,ABMX)
 K ABMR(20,ABMX),ABMX,ABMY
 I $D(ABMP("FMT")) S ABMP("FMT")=1
 Q Y
