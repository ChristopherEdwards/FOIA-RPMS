ABSPOSCD ; IHS/FCS/DRS - ABSP("RX",*) ;      [ 10/28/2002  2:40 PM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,10,12,18,19,20,21,23,32,36,40,42,46**;JUN 21, 2001
 ;---
 ;IHS/SD/lwj 8/20/02  NCPDP 5.1 changes
 ; One of the new segments in 5.1 is the DUR/PPS segment - this 
 ; entire segment is comprised of repeating fields.  It's values 
 ; will originate in the ABSP DUR/PPS file, which will be 
 ; linked to the prescription via the 9999999.13 DUR/PPS Pointer
 ; field in the PSRX file. For POS, this pointer is stored
 ; in the ^ABSPT(D0,1) global - piece 14.  If there is a value
 ; in this field, and we are working with a 5.1 claim we have
 ; altered this routine to retrieve the values from the ABSP DUR/PPS
 ; file and store them in the ABSP("RX",MEDN,DURN,...) array.
 ;
 ; Prior authorization is now being done differently.  For 3.2 claims
 ; the value is stored in field 416 - in 5.1, it is split into a type
 ; stored in field 461 and the number, which is stored in 462.  Changes
 ; were made to reduce the complexity of the formulation of field 416.
 ; For now, fields 416, 461, and 462 will all be populated.
 ;
 ;---
 ;IHS/SD/lwj 03/10/04 patch 10
 ; Routine adjusted to call ABSPFUNC to retrieve
 ; the Prescription Refill NDC value.  At some
 ; point the call needs to be modified to call APSPFUNC.
 ; See ABSPFUNC for details on why call was done.
 ;---
 ;IHS/SD/lwj 5/24/05 patch 12
 ; Need to retrieve prescriber's last name for OK Medicaid
 ; Retrieve Payer Assigned Provider Number for WA L & I
 ;---
 ;IHS/SD/RLT - 7/18/06 - Patch 18
 ; Added code for ABSP("Claim",MEDN,"Unit of Measure")
 ;---
 ;IHS/SD/RLT - 12/19/06 - Patch 19
 ; Added code for ABSP("Basis of Cost Determination")
 ;---
 ;IHS/SD/RLT - 03/15/07 - Patch 20
 ; NPI
 ;---
 ;IHS/SD/RLT - 05/14/07 - Patch 21
 ; Updated NPI
 ;---
 ;IHS/SD/RLT - 06/27/07 - 10/18/07 - Patch 23
 ; New tag DIAGVAL for Diagnosis Code.
 Q
 ;----------------------------------------------------------------------
 ;Set ABSP() "RX" nodes for current medication:
 ;
 ;Parameters:   VMEDINFO  - Contains VMEDIEN,RXIEN,RXRFIEN,VCPTIEN
 ;              MEDN      - Index number indicating what medication is
 ;                          being processed
 ;----------------------------------------------------------------------
 ; Called from ABSPOSCA from ABSPOSQG from ABSPOSQ2,
 ; once for each item in its VMEDS() array.
MEDINFO(VMEDINFO,MEDN,INSPINS) ;EP
 ;Manage local variables
 N VMEDIEN,RXIEN,RXRFIEN,DRUGIEN,PROVIEN,VCPTIEN,RXI,IEN59,PINSTYPE
 N UOM        ;IHS/SD/RLT - 7/18/06 - Patch 18
 ;
 ;Parse variables from VMEDINFO variable
 S VMEDIEN=$P(VMEDINFO,U,1)
 S RXIEN=$P(VMEDINFO,U,2)
 S RXRFIEN=$P(VMEDINFO,U,3)
 S VCPTIEN=$P(VMEDINFO,U,4)
 S IEN59=$P(VMEDINFO,U,5) ; 06/23/2000
 D OVERRIDE(IEN59,MEDN) ; overrides stored in 9002313.511
 ;
 ;IHS/SD/lwj 8/20/02  NCPDP 5.1 changes - if a 5.1 claims and
 ; there are DUR values - retrieve them
 I ABSP("NCPDP","Version")'[3 D DURVALUE(IEN59,MEDN)
 ;
 ;IHS/SD/RLT - 06/27/07 - 10/18/07 - Patch 23
 ; Diagnosis Code
 I ABSP("NCPDP","Version")'[3 D DIAGVAL(IEN59,MEDN)
 ;
 S PINSTYPE=$P(INSPINS,",") ; "CAID" will make a difference
 ;
 S DRUGIEN=$P($G(^PSRX(RXIEN,0)),U,6)
 S PROVIEN=$P($G(^PSRX(RXIEN,0)),U,4)
 ;
 S ABSP("RX",MEDN,"VCPT IEN")=VCPTIEN
 S ABSP("RX",MEDN,"IEN59")=IEN59 ; 06/23/2000
 S (RXI,ABSP("RX",MEDN,"RX IEN"))=RXIEN
 S ABSP("RX",MEDN,"Date Written")=$P($G(^PSRX(RXIEN,0)),U,13)
 S ABSP("RX",MEDN,"RX Number")=RXIEN ;$P($G(^PSRX(RXIEN,0)),U,1)
 S ABSP("RX",MEDN,"New/Refill")=$S(RXRFIEN="":"N",1:"R")
 ;
 ;IHS/SD/lwj 8/30/02  NCPDP 5.1 changes 
 ; Version 3.2 uses field 416 for the prior auth code and number
 ; Version 5.1 will use fields 461 and 462
 ; Below line remarked out, next three lines added
 ;
 ;  S ABSP("RX",MEDN,"Preauth #")=$P(^ABSPT(IEN59,1),U,9)  ;obsolete
 S ABSP("RX",MEDN,"Preauth #")=$P(^ABSPT(IEN59,1),U,15)_$P(^ABSPT(IEN59,1),U,9)
 S ABSP("Claim",MEDN,"Prior Auth Type")=$P(^ABSPT(IEN59,1),U,15)
 S ABSP("Claim",MEDN,"Prior Auth Num Sub")=$P(^ABSPT(IEN59,1),U,9)
 ;
 ;IHS/OIT/SCR 060909 - Get 419 value - start changes
 ;S ABSPORGN=$$ISPOE(RXIEN)
 S ABSPORGN=$$ISOR1^ABSPFUNC(RXIEN) ;IHS/CAS/RCS 090913 Patch 46 New way of finding Field 419, else use original
 I ABSPORGN="" S ABSPORGN=$$ISPOE^APSPFUNC(RXIEN) ;IHS/OIT/SCR 011110 patch 36
 S:ABSPORGN=1 ABSP("RX",MEDN,"Origin Code")=3 ;ELECTRONIC - if not controlled substance and entered through EHR
 S:ABSPORGN=0 ABSP("RX",MEDN,"Origin Code")=1 ;WRITTEN - required for controlled substances
 ;IHS/OIT/SCR 060909 end changes
 I 'RXRFIEN D  ; first fill
 .S ABSP("RX",MEDN,"Quantity")=$P($G(^PSRX(RXIEN,0)),U,7)
 .S ABSP("RX",MEDN,"Days Supply")=$P($G(^PSRX(RXIEN,0)),U,8)
 .S ABSP("RX",MEDN,"Date Filled")=$P($G(^PSRX(RXIEN,2)),U,2)
 .S ABSP("RX",MEDN,"NDC")=$P($G(^PSRX(RXIEN,2)),U,7)
 E  D  ; refill
 .S ABSP("RX",MEDN,"Quantity")=$P($G(^PSRX(RXIEN,1,RXRFIEN,0)),U,4)
 .S ABSP("RX",MEDN,"Days Supply")=$P($G(^PSRX(RXIEN,1,RXRFIEN,0)),U,10)
 .S ABSP("RX",MEDN,"Date Filled")=$P($G(^PSRX(RXIEN,1,RXRFIEN,0)),U)
 .;IHS/SD/lwj 03/10/04 patch 10 nxt line rmkd out, new line added
 .;S ABSP("RX",MEDN,"NDC")=$P($G(^PSRX(RXIEN,1,RXRFIEN,0)),U,13)
 .S ABSP("RX",MEDN,"NDC")=$$NDCVAL^ABSPFUNC(RXIEN,RXRFIEN)  ;patch 10
 .;IHS/SD/lwj 03/10/04 patch 10 end change
 ;IHS/OIT/CNI/RAN PATCH 40 This is the proper fill date
 S ABSP("RX","Date Filled")=ABSP("RX",MEDN,"Date Filled")
 ;Add new fields;Patch 42
 S OCNT=0 I $G(ABSP("OVERRIDE","RX",MEDN,30))]"" D
 .S ABSP("RX",MEDN,"Subm Clar Code 1")=$P(ABSP("OVERRIDE","RX",MEDN,30),",") I ABSP("RX",MEDN,"Subm Clar Code 1")]"" S OCNT=OCNT+1
 .S ABSP("RX",MEDN,"Subm Clar Code 2")=$P(ABSP("OVERRIDE","RX",MEDN,30),",",2) I ABSP("RX",MEDN,"Subm Clar Code 2")]"" S OCNT=OCNT+1
 .S ABSP("RX",MEDN,"Subm Clar Code 3")=$P(ABSP("OVERRIDE","RX",MEDN,30),",",3) I ABSP("RX",MEDN,"Subm Clar Code 3")]"" S OCNT=OCNT+1
 .I OCNT S ABSP("RX",MEDN,"Subm Clar Count")=OCNT
 ;
 ;OIT/CAS/RCS 110113 Patch 46, Create Dx Clinic segment from NCPDP Overrides, HEAT #135659, On hold
 ;I $G(ABSP("OVERRIDE","RX",MEDN,492))=99,$G(ABSP("OVERRIDE","RX",MEDN,424))]"" D
 ;.S ABSP("RX",MEDN,"DIAG",0,491)=1
 ;.S ABSP("RX",MEDN,"DIAG",1,492)=ABSP("OVERRIDE","RX",MEDN,492)
 ;.S ABSP("RX",MEDN,"DIAG",1,424)=ABSP("OVERRIDE","RX",MEDN,424)
 ;
 S ABSP("RX",MEDN,"# Refills")=$P($G(^PSRX(RXIEN,0)),U,9)
 S ABSP("RX",MEDN,"Refill #")=$$RXRFN(RXIEN,RXRFIEN)
 S ABSP("RX",MEDN,"Prescriber IEN")=+PROVIEN
 S ABSP("RX",MEDN,"Prescriber DEA #")=$P($G(^VA(200,+PROVIEN,"PS")),U,2)
 S ABSP("RX",MEDN,"Prescriber CAID #")=$P($G(^VA(200,+PROVIEN,9999999)),U,7)
 S ABSP("RX",MEDN,"Prescriber UPIN #")=$P($G(^VA(200,+PROVIEN,9999999)),U,8) ;*1.26*2*
 S ABSP("RX",MEDN,"Prescriber State/Prov")=$P($G(^VA(200,+PROVIEN,.11)),U,5) ;Patch 42
 ;
 ;IHS/OIT/CASSEVERN/RAN 11/16/2010 PATCH 40 Adding Triplicate Serial # for New York Medicaid
 S ABSP("RX",MEDN,"Triplicate Serial #")=$P($G(^PSRX(RXIEN,9999999)),U,14)
 ;
 ;Get Prescriber NPI #
 S ABSP("RX",MEDN,"Prescriber NPI #")=$P($$NPI^XUSNPI("Individual_ID",+PROVIEN),U)
 ;
 S ABSP("RX",MEDN,"Prescriber Billing Location")=$S(PROVIEN]"":$P($G(^VA(200,PROVIEN,9999999)),"^",11),1:"") ; ANMC only?  not in Sitka's data dic.
 ;IHS/SD/lwj 5/24/05 patch 12 nxt ln OK Medicaid pres last name
 S ABSP("RX",MEDN,"Prescriber Last Name")=$P($P($G(^VA(200,+PROVIEN,0)),U),",")
 ;
 ;IHS/SD/lwj 6/1/05 patch 12 nxt ln WA L & I unique prov number
 S ABSP("RX",MEDN,"Payer Assigned Prov #")=$$GET1^DIQ(200.9999918,ABSP("Insurer","IEN")_","_+PROVIEN_",",.02,"I")
 ;
 ;
 D
 . N %
 . I PINSTYPE="CAID" D
 . . S %=ABSP("RX",MEDN,"Prescriber CAID #")
 . . I %="" D  ; special for ANMC
 . . . N %1 S %1=ABSP("RX",MEDN,"Prescriber Billing Location")
 . . . S %=$S(%1=1665:"MDG275",%1=1946:"MDG867",1:"")
 . . I %="" S %=ABSP("Site","Default CAID #")
 . E  D
 . . S %=ABSP("RX",MEDN,"Prescriber DEA #")
 . . I %="" S %=ABSP("Site","Default DEA #")
 . S ABSP("RX",MEDN,"Prescriber ID")=%
 ;
 ;Set fields 466 and 411
 S ABSP("Prescriber",MEDN,"Prescriber ID Qual")=12      ;default for 466
 ;I ABSP("Send NPI")=1&(ABSP("RX",MEDN,"Prescriber NPI #")>0) D
 I ABSP("Send Prescriber NPI")=1&(ABSP("RX",MEDN,"Prescriber NPI #")>0) D
 . S ABSP("Prescriber",MEDN,"Prescriber ID Qual")="01"
 . S ABSP("RX",MEDN,"Prescriber ID")=ABSP("RX",MEDN,"Prescriber NPI #")
 ;
 D:DRUGIEN'=""
 .S ABSP("RX",MEDN,"Drug IEN")=DRUGIEN
 .S ABSP("RX",MEDN,"Drug Name")=$P($G(^PSDRUG(DRUGIEN,0)),U,1)
 .I ABSP("RX",MEDN,"NDC")="" D
 ..S ABSP("RX",MEDN,"NDC")=$P($G(^PSDRUG(DRUGIEN,2)),U,4)
 .;IHS/SD/RLT - 7/18/06 - Patch 18 - Add Unit of Measure
 .S UOM=$P($G(^PSDRUG(DRUGIEN,660)),U,8)
 .S ABSP("Claim",MEDN,"Unit of Measure")="EA"        ;default
 .S:UOM="ML"!(UOM="ml")!(UOM="MILLILITERS") ABSP("Claim",MEDN,"Unit of Measure")="ML"
 .S:UOM="GM"!(UOM="gm")!(UOM="GRAM") ABSP("Claim",MEDN,"Unit of Measure")="GM"
 N PRICING S PRICING=^ABSPT(IEN59,5)
 S ABSP("RX",MEDN,"Quantity")=$P(PRICING,U) ; 01/31/2001
 S ABSP("RX",MEDN,"Unit Price")=$P(PRICING,U,2)
 S ABSP("RX",MEDN,"Ingredient Cost")=$J($P(PRICING,U,3),0,2)
 S ABSP("RX",MEDN,"Dispensing Fee")=$J($P(PRICING,U,4),0,2)
 ;IHS/OIT/SCR 11/20/08 - add incentive fee information
 S ABSP("RX",MEDN,"Incentive Amount")=$J($P(PRICING,U,7),0,2)
 S ABSP("Site","Dispensing Fee")=ABSP("RX",MEDN,"Dispensing Fee")
 S ABSP("RX",MEDN,"Gross Amount Due")=$J($P(PRICING,U,5),0,2)
 S ABSP("RX",MEDN,"Usual & Customary")=$J($P(PRICING,U,5),0,2)
 S ABSP("RX",MEDN,"Basis of Cost Determination")="00"     ;***RLT 12/19/06
 I ABSP("NCPDP","Add Disp. Fee to Ingr. Cost") D
 . N X S X=ABSP("RX",MEDN,"Ingredient Cost")
 . S X=X+ABSP("RX",MEDN,"Dispensing Fee")
 . S ABSP("RX",MEDN,"Ingredient Cost")=X
 ;
 ; Visit-related data
 ;
 I IEN59 D
 . N VSITIEN S VSITIEN=$P(^ABSPT(IEN59,0),U,7)
 . Q:'VSITIEN
 . S ABSP("RX",MEDN,"Diagnosis Code")=$TR($$PRIMPOV^APCLV(VSITIEN,"C"),".","")
 Q
 ;
 ; $$RXRFN()
 ;Determine RX Refill Number based on prescription record
 ;  It's overly cautious about making sure that the refills are
 ;  counted in date filled order.
 ;
 ;Input Variables:    RXIEN    -  Prescription record IEN (52)
 ;                    RXRFIEN  -  Refill multiple IEN
 ;
 ;Function Returns:   Null  - Could not process request
 ;                    0     - Not a refill
 ;                    N     - Refill number
 ; Copied into here from ABSPECD4 so we can remove ABSPECD4 from kit.
 ; Also called from ABSPOSN3
 ;----------------------------------------------------------------------
RXRFN(RXIEN,RXRFIEN) ;EP
 ;Manage local variables
 N COUNT,DATE,XIEN,STOP
 ;
 ;Make sure input variables are defined
 Q:$G(RXIEN)="" ""
 Q:$G(RXRFIEN)="" ""
 ;
 ;Initialize local variables
 S (COUNT,STOP)=0
 ;
 ;Loop through refill multiple by date
 S DATE=""
 F  D  Q:'+DATE!(STOP)
 .S DATE=$O(^PSRX(RXIEN,1,"B",DATE))
 .Q:'+DATE
 .;
 .;For each sub-record increment refill count
 .S XIEN=""
 .F  D  Q:'+XIEN!(STOP)
 ..S XIEN=$O(^PSRX(RXIEN,1,"B",DATE,XIEN))
 ..Q:'+XIEN
 ..S COUNT=COUNT+1
 ..;
 ..;STOP when you reach the refill record
 ..S:XIEN=RXRFIEN STOP=1
 Q $S(STOP=1:COUNT,1:0)
 ;
 ; Retrieve OVERRIDE nodes and put into ABSP array
 ; They will be fetched from ABSP("OVERRIDE"
 ; during low-level construction of the actual encoded claim packet.
 ;
OVERRIDE(IEN59,MEDN)    ; set any ABSP("OVERRIDE" nodes from 9002313.511 data
 ; ABSP("OVERRIDE",field)=value  for fields 101-401
 ; ABSP("OVERRIDE","RX",MEDN,field) for med #N, fields 402+
 ; Note that if you have multiple prescriptions bundled, the
 ; union of overrides from 101-401 apply to all; and if there's a 
 ; conflict, the last one overwrites the previous ones.
 N IEN511 S IEN511=$P(^ABSPT(IEN59,1),U,13) Q:'IEN511
 D GET511^ABSPOSO2(IEN511,"ABSP(""OVERRIDE"")","ABSP(""OVERRIDE"",""RX"","_MEDN_")")
CC Q
 ;
DURVALUE(IEN59,MEDN)         ;IHS/SD/lwj 8/20/02 NCPDP 5.1 changes
 ; This subroutine will see if there is a DUR/PPS pointer for this
 ; prescription - if there is, we will read through the DUR/PPS 
 ; file and retrieve the values into the ABSP("RX",MEDN,DUR,....)
 ; fields
 ; (NOTE - unlike most values, these fields are stored by their
 ; field number.  Since they are repeating, it will ease the 
 ; retrieval of them, when we populate the claim.)
 ;
 N IEN473,DUR,DCNT,DURREC
 ;
 S IEN473=$P(^ABSPT(IEN59,1),U,14) Q:'IEN473   ;pointer to DUR/PPS fl
 ;
 S (DUR,DCNT)=0
 F  S DCNT=$O(^ABSP(9002313.473,IEN473,1,DCNT)) Q:'+DCNT  D
 . S DURREC=$G(^ABSP(9002313.473,IEN473,1,DCNT,0))
 . S DUR=DUR+1
 . S ABSP("RX",MEDN,"DUR",DUR,473)=DUR  ;dur/pps cntr
 . S ABSP("RX",MEDN,"DUR",DUR,439)=$P(DURREC,U,2) ;Reason Srv Cd
 . S ABSP("RX",MEDN,"DUR",DUR,440)=$P(DURREC,U,3) ;Prof Srv Cd
 . S ABSP("RX",MEDN,"DUR",DUR,441)=$P(DURREC,U,4) ;Result Src Cd
 . S ABSP("RX",MEDN,"DUR",DUR,474)=$P(DURREC,U,5) ;Level of Effort
 . S ABSP("RX",MEDN,"DUR",DUR,475)=$P(DURREC,U,6) ;Co-agent Qual
 . S ABSP("RX",MEDN,"DUR",DUR,476)=$P(DURREC,U,7) ;Co-agent ID
 ;
 Q
DIAGVAL(IEN59,MEDN)         ;Diagnosis Code
 ; Get data from Diagnosis Code file and put in ABSP array.
 N IEN491,DIAG,DIAGCNT,DIAGREC
 ;
 S IEN491=$P(^ABSPT(IEN59,1),U,17) Q:'IEN491   ;pointer
 ;
 S ABSP("RX",MEDN,"DIAG",0,491)=$P($G(^ABSP(9002313.491,IEN491,0)),U,5)     ;diag code cnt
 ;
 S (DIAG,DIAGCNT)=0
 F  S DIAGCNT=$O(^ABSP(9002313.491,IEN491,1,DIAGCNT)) Q:'+DIAGCNT  D
 . S DIAGREC=$G(^ABSP(9002313.491,IEN491,1,DIAGCNT,0))
 . Q:DIAGREC=""
 . S DIAG=DIAG+1
 . S ABSP("RX",MEDN,"DIAG",DIAG,492)=$P(DIAGREC,U,2) ;diag code qualifier
 . S ABSP("RX",MEDN,"DIAG",DIAG,424)=$P(DIAGREC,U,3) ;diagnosis code
 Q
