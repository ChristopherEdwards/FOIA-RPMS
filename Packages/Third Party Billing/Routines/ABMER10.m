ABMER10 ; IHS/ASDST/DMJ - UB92 EMC RECORD 10 (Provider) ;   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;DMJ;08/15/96 12:03 PM
 ;
 ; IHS/DSD/LSL - 09/14/98 - Patch 2 - NOIS XXX-0698-200039
 ;               AHCCCS needs leading zeroes on Medicaid Provider number
 ; IHS/ASDS/DMJ - 04/18/00 - V2.4 Patch 1 - NOIS HQW-0500-100040
 ;     Modified location code to check for satellite first.  If no
 ;     satellite use parent.
 ; IHS/ASDS/LSL - 08/29/00 - V2.4 Patch 3 - NOIS QDA-0800-130111
 ;     Populate medicaid provider number if kidscare
 ; IHS/FCS/DRS - 09/17/01 - V2.4 Patch 9
 ;     Part 20 - Field 10-13 Provider Address - remove illegal chars
 ;
 ; IHS/SD/SDR - 10/29/02 - V2.5 P2 - BXX-0501-150089
 ;     Modified routine to shorted 2nd line of address by 2 so bill
 ;     type won't be cut off on right margin.
 ;
START ;START HERE
 K ABMREC(10),ABMR(10)
 S ABME("RTYPE")=10
 D LOOP
 K ABME,ABM
 Q
 ;
LOOP ;LOOP HERE
 F I=10:10:200 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),10,I)) D @(^(I))
 .I '$G(ABMP("NOFMT")) S ABMREC(10)=$G(ABMREC(10))_ABMR(10,I)
 Q
 ;
10 ;Record type
 S ABMR(10,10)="10"
 Q
 ;
20 ;Type of Batch (SOURCE: FILE=9002274.4, FIELD=.02)
 S ABMR(10,20)=ABMP("BTYP")
 S ABMR(10,20)=$$FMT^ABMERUTL(ABMR(10,20),3)
 Q
 ;
30 ;Batch Number
 S ABMR(10,30)=ABMEF("BATCH#")
 S ABMR(10,30)=$$FMT^ABMERUTL(ABMR(10,30),"2NR")
 Q
 ;
40 ; EP
 ; Federal Tax Number or EIN (SOURCE: FILE=9999999.06, FIELD=.21)
 ; 2/10/98 - LSL - Use Fed Tax Number of facility providing service
 ;           not facility receiving payment. Per Santa Fe.
 ; form locator #5
 D DIQ1
 S ABMR(10,40)=ABM(9999999.06,ABMP("LDFN"),.21,"E")
 I $$RCID^ABMERUTL(ABMP("INS"))=99999 D
 .S ABMR(10,40)=$$FMT^ABMERUTL(ABMR(10,40),10)
 I $$RCID^ABMERUTL(ABMP("INS"))'=99999 D
 .S ABMR(10,40)=$$FMT^ABMERUTL(ABMR(10,40),"10NR")
 S ABMRT(95,20)=ABMR(10,40)
 Q
 ;
50 ;Federal Tax Submitter ID (SOURCE: FILE=, FIELD=)
 S ABMR(10,50)=""
 S ABMR(10,50)=$$FMT^ABMERUTL(ABMR(10,50),4)
 Q
 ;
60 ;Medicare Provider Number (SOURCE: FILE=9999999.181501, FIELD=.02)
 S ABMR(10,60)=""
 I ABMP("ITYPE")="R" D
 .S ABMR(10,60)=$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),0)),U,8)
 .S:ABMR(10,60)="" ABMR(10,60)=$P($G(^AUTNINS(ABMP("INS"),15,ABMP("LDFN"),0)),"^",2)
 .I ABMR(10,60)="" D
 ..D DIQ1
 ..S ABMR(10,60)=ABM(9999999.06,ABMP("LDFN"),.22,"E")
 ..Q
 .S ABMR(10,60)=$TR(ABMR(10,60),"-")
 S ABMR(10,60)=$$FMT^ABMERUTL(ABMR(10,60),13)
 Q
 ;
70 ;Medicaid Provider Number (SOURCE: FILE=9999999.181501, FIELD=.02)
 S ABMR(10,70)=""
 I ABMP("ITYPE")="D"!(ABMP("ITYPE")="K") D
 .S ABMR(10,70)=$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),0)),U,8)
 .S:ABMR(10,70)="" ABMR(10,70)=$P($G(^AUTNINS(ABMP("INS"),15,ABMP("LDFN"),0)),"^",2)
 S:$$RCID^ABMERUTL(ABMP("INS"))=99999 ABMR(10,70)="OO"_ABMR(10,70)
 S ABMR(10,70)=$$FMT^ABMERUTL(ABMR(10,70),13)
 Q
 ;
80 ; Champus Insurer Provider Number
 ; (SOURCE: FILE=9999999.181501, FIELD=.02)
 S ABMR(10,80)=""
 S ABMR(10,80)=$$FMT^ABMERUTL(ABMR(10,80),13)
 Q
 ;
90 ; Other Insurer Provider Number 1
 ; (SOURCE: FILE=9999999.181501, FIELD=.02)
 S ABMR(10,90)=""
 I $G(ABMP("BCBS")) D
 .D DIQ1
 .S ABMR(10,90)=$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),0)),U,8)
 .S:ABMR(10,90)="" ABMR(10,90)=$P($G(^AUTNINS(ABMP("INS"),15,ABMP("LDFN"),0)),"^",2)
 .S ABMR(10,90)=ABMR(10,90)_" "_$E(ABM(9999999.06,ABMP("LDFN"),.01,"E"),1,2)
 S ABMR(10,90)=$$FMT^ABMERUTL(ABMR(10,90),13)
 Q
 ;
100 ;Other Insurer Provider Number 2 (SOURCE: FILE=9999999.18, FIELD=)
 S ABMR(10,100)=""
 S ABMR(10,100)=$$FMT^ABMERUTL(ABMR(10,100),13)
 Q
 ;
110 ; EP
 ; Provider Telephone Number (SOURCE: FILE=9999999.06 FIELD=.13)
 ; Form locator #1
 D DIQ1
 S ABMR(10,110)=ABM(9999999.06,ABMP("PAYDFN"),.13,"E")
 I '$G(ABMP("NOFMT")) S ABMR(10,110)=$TR(ABMR(10,110),"() -")
 S ABMR(10,110)=$$FMT^ABMERUTL(ABMR(10,110),"10R")
 Q
 ;
120 ; EP
 ; Provider Name (SOURCE: FILE=9002274.5, FIELD=.26)
 ; Form locator #1
 D DIQ2
 S ABMR(10,120)=ABM(9002274.5,1,.26,"E")
 S:ABMR(10,120)="" ABMR(10,120)=$P(^AUTTLOC(DUZ(2),0),"^",2)
 S ABMR(10,120)=$$FMT^ABMERUTL(ABMR(10,120),25)
 Q
 ;
130 ; EP
 ; Provider Address (SOURCE: FILE=9999999.06, FIELD=9999999.06,.14)
 ; Form locator #1
 D DIQ1
 S ABMR(10,130)=ABM(9999999.06,ABMP("PAYDFN"),.14,"E")
 I $$ENVOY^ABMEF16 D
 .S ABMR(10,130)=$$REPLNOT(ABMR(10,130),"/,. &#")
 S ABMR(10,130)=$$FMT^ABMERUTL(ABMR(10,130),23)
 Q
REPLNOT(X,P) ; EP - replace punctuation not in P in X with spaces ; return the result ; P is the punctuation you want to protect ; replaces control chars too
 N I F I=1:1:$L(X) I $E(X,I)?1PC,P'[$E(X,I) S $E(X,I)=" "
 Q X
 ;
140 ; EP
 ; Provider City (SOURCE: FILE=9999999.06, FIELD=.15)
 ; Form locator #1
 D DIQ1
 S ABMR(10,140)=ABM(9999999.06,ABMP("PAYDFN"),.15,"E")
 S ABMR(10,140)=$$FMT^ABMERUTL(ABMR(10,140),14)
 Q
 ;
150 ; EP
 ; Provider State (SOURCE: FILE=9999999.06 FIELD=.16)
 ; Form locator #1
 D DIQ1
 S ABMR(10,150)=$P($G(^DIC(5,ABM(9999999.06,ABMP("PAYDFN"),.16,"I"),0)),"^",2)
 S ABMR(10,150)=$$FMT^ABMERUTL(ABMR(10,150),2)
 Q
 ;
160 ; EP
 ; Provider Zip (SOURCE: FILE=9999999.06, FIELD=.17)
 ; Form locator #1
 D DIQ1
 S ABMR(10,160)=ABM(9999999.06,ABMP("PAYDFN"),.17,"E")
 I '$G(ABMP("NOFMT")) S $E(ABMR(10,160),6,9)="0000"
 S ABMR(10,160)=$$FMT^ABMERUTL(ABMR(10,160),9)
 Q
 ;
170 ;Provider FAX Number (SOURCE: FILE= FIELD=)
 S ABMR(10,170)=""
 S ABMR(10,170)=$$FMT^ABMERUTL(ABMR(10,170),"10NR")
 Q
 ;
180 ;Country Code (SOURCE: FILE=, FIELD=)     
 S ABMR(10,180)=""
 S ABMR(10,180)=$$FMT^ABMERUTL(ABMR(10,180),4)
 Q
 ;
190 ;Filler (National Use)
 S ABMR(10,190)=""
 S ABMR(10,190)=$$FMT^ABMERUTL(ABMR(10,190),4)
 Q
 ;
200 ;Filler (Local Use)
 S ABMR(10,200)=""
 S ABMR(10,200)=$$FMT^ABMERUTL(ABMR(10,200),3)
 Q
 ;
DIQ1 ;PULL LOCATION DATA VIA DIQ1
 Q:$D(ABM(9999999.06,ABMP("LDFN")))
 N I
 S DIQ="ABM("
 S DIQ(0)="IE"
 S DIC="^AUTTLOC("
 S DA=ABMP("LDFN")
 S DR=".01;.21;.22"
 D EN^DIQ1
 S ABMP("PAYDFN")=$P($G(^ABMDPARM(DUZ(2),1,2)),"^",3)
 S:'$D(^AUTTLOC(+ABMP("PAYDFN"),0)) ABMP("PAYDFN")=ABMP("LDFN")
 S DA=ABMP("PAYDFN")
 S DR=".13;.14;.15;.16;.17;.21"
 D EN^DIQ1
 K DIQ
 Q
 ;
DIQ2 ;GET SITE PARAMETER INFO    
 Q:$D(ABM(9002274.5,DUZ(2)))
 N I
 S DIQ="ABM("
 S DIQ(0)="E"
 S DIC="^ABMDPARM(DUZ(2),"
 S DA=1
 S DR=.26
 D EN^DIQ1 K DIQ
 Q
 ;
EX(ABMX,ABMY) ;EXTRINSIC FUNCTION HERE
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
 K ABMR(20,ABMX),ABME,ABM,ABMX,ABMY
 I $D(ABMP("FMT")) S ABMP("FMT")=1
 Q Y
