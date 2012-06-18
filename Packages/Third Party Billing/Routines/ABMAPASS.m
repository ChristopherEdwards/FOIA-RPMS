ABMAPASS ; IHS/ASDST/DMJ - PASS INFO TO A/R ;    
 ;;2.6;IHS 3P BILLING SYSTEM;**3,4,6,8**;NOV 12, 2009
 ;Original;DMJ
 ;
 ;IHS/DSD/MRS-4/1/1999 Modify to check for missing root of insurer array
 ;IHS/DSD/MRS - 6/23/1999 - NOIS PYA-0499-90061 Patch 3 #2
 ;  Code assumed ICPT ien was equal to .01, not true for type II & III
 ;  HCPCS. Modified to retrieve numerical ien from "B" cross-reference
 ; IHS/ASDS/LSL - 05/18/2001 - V2.4 Patch 6 - Modified to accomodate
 ;     Pharmacy POS posting.  Allow RX to pass to A/R Bill file as 
 ;     Other Bill Identifier.
 ;
 ; IHS/SD/SDR - v2.5 p8
 ;    added code to pass ambulance charges
 ; IHS/SD/SDR - v2.5 p9 - IM16864
 ;    Correction to bill suffix when rolling over for satellites
 ; IHS/SD/SDR - v2.5 p10 - IM20395
 ;   Split out lines bundled by rev code
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*3 - modified to pass POS Rejection info if it exists for bill
 ; IHS/SD/SDR - abm*2.6*3 - modified to pass Re-export dates if any exist on bill
 ; IHS/SD/SDR - abm*2.6*4 - POS rejection change was causing 3P CREDIT A/R transactions to create.
 ;  Modified to only pass the codes not the whole ABMPOS array.
 ; IHS/SD/SDR - abm*2.6*6 - NOHEAT - Added code to put a partial bill number as other identifier
 ;
 ; *********************************************************************
 ; This routine is called each time the Bill Status is changed in
 ; the 3P BILL file.  It is called as part of a cross-reference on
 ; the Bill Status (.04) field.  It will send the ABMA array to A/R.
 ; The ABMA array is stored in ^TMP($J,"ABMAPASS") and it is this
 ; global that is passed to A/R.  The array can be defined as follows
 ; (Field numbers are as they relate to the 3P BILL file):
 ; This rtn has been modified so it will work with either A/R 1.1 or 1.0
 ;
 ; VARIABLE       FIELD #    DESCRIPTION
 ;
 ; ABMA("BLDA")   = .001 = IEN to 3P BILL file
 ; ABMA("ACTION") =        Insurance priority or cancelled status
 ;                           value  1 = Primary Insurer
 ;                           value  2 = Secondary Insurer
 ;                           value  3 = Tertiary Insurer
 ;                           value 99 = Cancelled Status
 ; ABMA("BLNM")   = .01  = Bill name (bill #-Bill # suffix-HRN)
 ; ABMA("VSLC")   = .03  = Visit location
 ; ABMA("PTNM")   = .05  = Patient (Pointer)
 ; ABMA("VSTP")   = .07  = Visit Type
 ; ABMA("INS")    = .08  = Active Insurer
 ; ABMA("CLNC")   = .1   = Clinic
 ; ABMA("DTAP")   = .15  = Date/Time Approved
 ; ABMA("DTBILL") = .17  = Export number
 ; ABMA("BLAMT")  = .21  = Bill Amount
 ; ABMA("DOSB")   = .71  = Service Date From
 ; ABMA("DOSE")   = .72  = Service Date To
 ; ABMA("PRIM")   =        Primary Insurer (Pointer)
 ; ABMA("SEC")    =        Secondary Insurer (Pointer)
 ; ABMA("TERT")   =        Tertiary Insurer (Pointer)
 ; ABMA("POLH")   =        Policy Holder of active insurance
 ; ABMA("POLN")   =        Policy Number of active insurance
 ; ABMA("PROV")   =        Attending Provider (Pointer)
 ; ABMA("CREDIT") =        Total payments (payment+deductable+coins)
 ; ABMA("OTHIDENT") =      Other Bill Identifier for A/R (from POS)
 ; ABMA("LICN") =          Line Item Control Number (if flat rate)  ;abm*2.6*8
 ;
 ;  ITEM ARRAY
 ;
 ; ABMA(counter,"BLSRV")  = Type of service (ie: Dental,Pharmacy)
 ; ABMA(counter,"ITCODE") = IEN to REVENUE CODE file
 ; ABMA(counter,"ITQT")   = total units (quantity)
 ; ABMA(counter,"ITTOT")  = total charges
 ; ABMA(counter,"ITUC")   = unit charge
 ; ABMA(counter,"OTUC")   = dispense fee (pharmacy)
 ; ABMA(counter,"OTIT")   = "DISPENSE FEE" (Pharmacy)
 ; ABMA(counter,"ITNM")   = Revenue code description (item)
 ; ABMA(counter,"ITCODE") = Revenue code (item code)
 ; ABMA(counter,"DOS")    = Date of service
 ; ABMA(counter,"LICN")   = Line Item Control Number  ;abm*2.6*8
 ;
 ; start new code abm*2.6*3 POS Rejection codes
 ; ABMA(73,"REJDATE") = POS rejection date
 ; ABMA(73,cnt,"CODE") = code
 ; ABMA(73,cnt,"REASON") = reason
 ;
 ; Re-export info
 ; ABMA(74,ABMMIEN,"DT")
 ; ABMA(74,ABMMIEN,"STAT")
 ; ABMA(74,ABMMIEN,"GCN")
 ; ABMA(74,ABMMIEN,"RSN")
 ; ABMA(74,ABMMIEN,"USR")
 ; end new code abm*2.6*3
 ; 
 ; *********************************************************************
 ;
START ; START HERE
 ; X = Bill status in 3P BILL file
 ;
 Q:X=""
 Q:"ABTX"'[X  ; q: bill not approved, billed, transferred, or cancelled
 S ABMP("ARVERS")=$$CV^XBFUNC("BAR")
 Q:ABMP("ARVERS")<0   ;Q if A/R not loaded
 D BLD        ; Build ABMA Array
 D PASS       ; Pass ABMA Array to A/R
 K ABMA,ABM,ABMR,^TMP($J,"ABMPASS")
 Q
 ;
 ; *********************************************************************
BLD ; PEP
 ; BUILD ABMA ARRAY (STORED IN TMP for ver 1.1)
 ; NEEDS X AND DA IF CALLED FROM HERE
 ; X  = Bill status in 3P BILL
 ; DA = IEN to 3P BILL
 ;
 K ABMA,^TMP($J,"ABMPASS")
 S (ABMA("BLDA"),ABMP("BDFN"))=DA
 S ABMA="^TMP($J,""ABMPASS"")"
 S ABMA("ACTION")=X
 ; The line below translate cancelled status to 99 for A/R
 S:X="X" ABMA("ACTION")=$S(ABMP("ARVERS")'<1.1:99,1:"C")
 N I
 F I=1:1 S ABMA("LINE")=$T(TXT+I) Q:ABMA("LINE")["END"  D
 . S ABMA("DR")=$P(ABMA("LINE"),";;",2)
 . S ABMA($P(ABMA("LINE"),";;",3))=$$VALI^XBDIQ1("^ABMDBILL(DUZ(2),",DA,ABMA("DR"))
 . I ABMA("DR")=.17,ABMA("DTBILL") S ABMA("DTBILL")=$$VALI^XBDIQ1(^DIC(9002274.6,0,"GL"),ABMA("DTBILL"),.01)
 I ABMA("ACTION")="B",ABMA("DTBILL")="" S ABMA("DTBILL")=DT
 D BLNM                      ; Calculate complete bill name
 N I,DA,K
 S K=0
 ; Loop through each type of bill service and find ITEM ARRAY data
 S ABMP("VDT")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),U)  ;fix for CSV; needed for CSV API call
 F I=21,23,25,27,33,35,37,39,43,47 D
 . K ABM,ABMRV
 . D @(I_"^ABMERGR2")  ; Build ABRV Array for all items for service type
 . Q:'$D(ABMRV)        ; quit if no items for this service type
 . D CONV              ; Convert ABRV Array to ABMA array 
 K ABMRV
 D ORV^ABMERGRV        ; Find other items (Revenue codes)
 N I
 S I=.97
 D CONV
 N ABME
 ; Get insurer data
 S ABMP("ITYPE")=$P($G(^AUTNINS(+ABMA("INS"),2)),"^",1)
 D ISET^ABMERUTL       ; Set insurer priorities based on 3P BILL
 D CONV2               ; Convert insurer to ABMA array
 K ABMP("SET")
 S ABMP("PDFN")=ABMA("PTNM")
 S ABME("INS")=ABMA("INS")
 ;The following line has been added to Klamath falls ***
 I '$G(ABME("INSIEN")),'($D(ABMP("INS"))#2) S ABMP("INS")=""
 ; Get policy data of active insurer
 D EN^XBNEW("ISET^ABMERINS","ABME,ABMP,ABMR")
 S ABMA("POLH")=$G(ABME("PHNM"))
 S ABMA("POLN")=$G(ABMR(30,70))
 ;
 D PROV                ; Get Attending provider
 S ABMA("CREDIT")=$$TCR^ABMERUTL(ABMP("BDFN"))  ; Total Credit
 S ABMA("OTHIDENT")=$G(ABMPOS("OTHIDENT"))
 I ($G(ABMA("OTHIDENT"))=""),($L(ABMA("BLNM")>14)) S ABMA("OTHIDENT")=$E(ABMA("BLNM"),1,14)  ;abm*2.6*6 NOHEAT
 K ABMA("LINE"),ABMA("DR"),ABMA("DA")
 I $P($G(^AUTNINS(ABMA("INS"),2)),"^",1)="N" S ABMA("INS")=""
 ;I ABMP("ARVERS")'<1.1 M @ABMA=ABMA  ;abm*2.6*3
 ;
 ;I $D(ABMPOS) M ABMA=ABMPOS  ;abm*2.6*3 POS Rejections  ;abm*2.6*4
 I $D(ABMPOS) M ABMA(73)=ABMPOS(73)  ;abm*2.6*4
 ;start new code abm*2.6*3 re-export dates
 I $G(ABMREX("BDFN")),$D(^ABMDBILL(DUZ(2),ABMREX("BDFN"),74)) D
 .S ABMMIEN=0
 .F  S ABMMIEN=$O(^ABMDBILL(DUZ(2),ABMREX("BDFN"),74,ABMMIEN)) Q:(+$G(ABMMIEN)=0)  D
 ..S ABMA(74,ABMMIEN,"DT")=$P($G(^ABMDTXST(DUZ(2),$P($G(^ABMDBILL(DUZ(2),ABMREX("BDFN"),74,ABMMIEN,0)),U),0)),U)
 ..S ABMA(74,ABMMIEN,"STAT")=$P($G(^ABMDBILL(DUZ(2),ABMREX("BDFN"),74,ABMMIEN,0)),U,2)
 ..S ABMA(74,ABMMIEN,"GCN")=$P($G(^ABMDBILL(DUZ(2),ABMREX("BDFN"),74,ABMMIEN,0)),U,3)
 ..S ABMTXIEN=$O(^ABMDTXST(DUZ(2),$P($G(^ABMDBILL(DUZ(2),ABMREX("BDFN"),74,ABMMIEN,0)),U),3,"B",ABMA(74,ABMMIEN,"DT"),0))
 ..I ABMTXIEN'="" D
 ...S ABMA(74,ABMMIEN,"USR")=$P($G(^ABMDTXST(DUZ(2),$P($G(^ABMDBILL(DUZ(2),ABMREX("BDFN"),74,ABMMIEN,0)),U),3,ABMTXIEN,0)),U,4)
 ...S ABMA(74,ABMMIEN,"RSN")=$P($G(^ABMDTXST(DUZ(2),$P($G(^ABMDBILL(DUZ(2),ABMREX("BDFN"),74,ABMMIEN,0)),U),3,ABMTXIEN,0)),U,5)
 I $G(ABMREX("BDFN")),+$G(ABMP("XMIT"))'=0 D
 .I $D(^ABMDBILL(DUZ(2),ABMREX("BDFN"),74,"B",ABMP("XMIT"))) Q  ;already has this transmission
 .S ABMMIEN=($O(ABMA(74,99999),-1)+1)
 .S ABMTXIEN=$O(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,"B",$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),0)),U),0))
 .I ABMTXIEN'="" D
 ..S ABMA(74,ABMMIEN,"DT")=$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,ABMTXIEN,0)),U)
 ..S ABMA(74,ABMMIEN,"GCN")=$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,ABMTXIEN,0)),U,2)
 ..S ABMSTAT="O"
 ..I $G(ABMREX("BILLSELECT"))'="" S ABMSTAT="F"
 ..I $G(ABMREX("BATCHSELECT"))'="" S ABMSTAT="S"
 ..I $G(ABMREX("RECREATE"))'="" S ABMSTAT="C"
 ..S ABMA(74,ABMMIEN,"STAT")=ABMSTAT
 ..S ABMA(74,ABMMIEN,"USR")=$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,ABMTXIEN,0)),U,4)
 ..S ABMA(74,ABMMIEN,"RSN")=$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,ABMTXIEN,0)),U,5)
 ;end new code abm*2.6*3 re-export dates
 ;
 I ABMP("ARVERS")'<1.1 M @ABMA=ABMA  ;abm*2.6*3
 Q
 ;
 ; *********************************************************************
PASS ;
 ;PASS TO A/R
 I ABMP("ARVERS")'<1.1 D
 . D TPB^BARUP(ABMA)
 E  D TPB^BARUP(.ABMA)
 S $P(^ABMDBILL(DUZ(2),DA,2),U,6)=$G(^TMP($J,"ABMPASS","ARLOC"))
 Q
 ;
 ; *********************************************************************
BLNM ;EP - get full bill name
 I $P($G(^ABMDPARM(ABMA("VSLC"),1,2)),"^",4)]"" S ABMA("BLNM")=ABMA("BLNM")_"-"_$P(^(2),"^",4)
 I $P($G(^ABMDPARM(ABMA("VSLC"),1,3)),"^",3)=1 D
 .S ABM("HRN")=$P($G(^AUPNPAT(ABMA("PTNM"),41,ABMA("VSLC"),0)),"^",2)
 .S:ABM("HRN")]"" ABMA("BLNM")=ABMA("BLNM")_"-"_ABM("HRN")
 Q
 ;
 ; *********************************************************************
CONV ;
 ;CONVERT ABMRV ARRAY TO ABMA ARRAY
 N L
 N J
 I '$D(ABMP("ARVERS")) S ABMP("ARVERS")=$$CV^XBFUNC("BAR")
 S L=-1
 F  S L=$O(ABMRV(L)) Q:L=""  D
 .S J=-1
 .F  S J=$O(ABMRV(L,J)) Q:J=""  D
 ..S M=0
 ..F  S M=$O(ABMRV(L,J,M)) Q:M=""  D
 ...S K=K+1
 ...S ABMA(K,"DOS")=""
 ...S ABMA(K,"BLSRV")=$P(^DD(9002274.4,I,0),U)
 ...S ABMA(K,"BLSRV")=$$UPC^ABMERUTL(ABMA(K,"BLSRV"))
 ...S ABMA(K,"BLSRV")=$TR(ABMA(K,"BLSRV"),"*")
 ...S ABMA(K,"ITCODE")=L
 ...S ABMA(K,"ITQT")=$P(ABMRV(L,J,M),U,5)
 ...S ABMA(K,"ITTOT")=$P(ABMRV(L,J,M),U,6)
 ...S ABMA(K,"ITUC")=ABMA(K,"ITTOT")
 ...S ABMA(K,"LICN")=$P(ABMRV(L,J,M),U,38)  ;abm*2.6*8
 ...I I=23 D
 ....S ABMA(K,"OTUC")=ABM(5)
 ....S ABMA(K,"OTIT")="DISPENSE FEE"
 ....S ABMA(K,"ITUC")=ABMA(K,"ITTOT")-ABM(5)
 ....S ABMA(K,"ITNM")=$P(ABMRV(L,J,M),U,9) ;Medicine code
 ...I I=25 S ABMA(K,"ITNM")=$P($G(^AUTTREVN(L,0)),U,2)
 ...I J]"",I'=23,I'=33 D
 ....N ABMJIEN
 ....S ABMJIEN=$O(^ICPT("B",J,""))     ; GET NUMERICAL ien
 ....I ABMJIEN S ABMA(K,"ITNM")=$P($$CPT^ABMCVAPI(ABMJIEN,$P(ABMRV(L,J,M),U,10),ABMP("VDT")),U,3) Q  ;CSV-c
 ....S ABMA(K,"ITNM")=$P($$CPT^ABMCVAPI(J,$P(ABMRV(L,J,M),U,10),ABMP("VDT")),U,3)  ;CSV-c
 ....S ABMA(K,"ITCODE")=J
 ...I J,I=33 D
 ....S ABMA(K,"ITCODE")=$P(ABMRV(L,J,M),U,2)
 ...S:$P(ABMRV(L,J,M),U,9)'="" ABMA(K,"ITNM")=$P(ABMRV(L,J,M),U,9)
 ...S:$P(ABMRV(L,J,M),U,10) ABMA(K,"DOS")=$P(ABMRV(L,J,M),U,10)
 ...I '$G(ABMA(K,"ITQT")) S ABMA(K,"ITUC")=0 Q
 ...S ABMA(K,"ITUC")=$J(ABMA(K,"ITUC")/ABMA(K,"ITQT"),1,3)
 ...I ABMP("ARVERS")'<1.1 D
 ....M @ABMA@(K)=ABMA(K)
 ....K ABMA(K)
 Q
 ;
 ; *********************************************************************
CONV2 ;
 ;CONVERT INSURER ARRAY
 F I=1:1:3 D
 . Q:'$D(ABMP("INS",I))
 . Q:ABMA("ACTION")=$S(ABMP("ARVERS")'<1.1:99,1:"C")
 . S:+ABMP("INS",I)=ABMA("INS") ABMA("ACTION")=I
 . S:$P($G(^AUTNINS(+ABMP("INS",I),0)),"^",1)="N" ABMP("INS",I)=""
 S ABMA("PRIM")=$P($G(ABMP("INS",1)),"^",1)
 S ABMA("SEC")=$P($G(ABMP("INS",2)),"^",1)
 S ABMA("TERT")=$P($G(ABMP("INS",3)),"^",1)
 Q
 ;
 ; *********************************************************************
PROV ;
 ;GET ATTENDING PROVIDER
 S ABMA("PROV")=""
 N I
 S I=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,"C","A",0))
 N J
 S J=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,+I,0)),"^",1)
 S ABMA("PROV")=J
 Q
 ;
 ; *********************************************************************
TXT ;FIELDS
 ;;.01;;BLNM
 ;;.03;;VSLC
 ;;.05;;PTNM
 ;;.07;;VSTP
 ;;.08;;INS
 ;;.1;;CLNC
 ;;.15;;DTAP
 ;;.17;;DTBILL
 ;;.21;;BLAMT
 ;;.29;;LICN
 ;;.71;;DOSB
 ;;.72;;DOSE
 ;;END
 ;abm*2.6*8 added .29 field above
 ;
 ; *********************************************************************
EXT ;EP 
 ;  EXTERNAL CALL (NEEDS DA DEFINED)
 S DIC="^ABMDBILL(DUZ(2),"
 S X="A"
 D START
 K ABM,ABMP,ABMA,ABME
 Q
