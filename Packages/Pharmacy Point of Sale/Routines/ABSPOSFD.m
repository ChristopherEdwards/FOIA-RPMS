ABSPOSFD ; IHS/FCS/DRS - ABSP("RX",*) ;      [ 09/12/2002  10:09 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,10,40**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ; This is a copy of routine ABSPOSCD, made on 03/20/2001.
 ; It constructs the ABSP(*) array for printing NCPDP forms.
 ; Try to keep the two versions in synch.
 ;
 ;----------------------------------------------------------------------
 ;IHS/SD/lwj 03/10/04 patch 10
 ; Routine adjusted to call ABSPFUNC to retrieve
 ; the Prescription Refill NDC value.  At some
 ; point the call needs to be modified to call APSPFUNC.
 ; See ABSPFUNC for details on why call was done.
 ;----------------------------------------------------------------------
 Q
 ;----------------------------------------------------------------------
 ;Set ABSP() "RX" nodes for current medication:
 ;
 ;Parameters:   VMEDINFO  - Contains RXIEN,RXRFIEN,IEN57
 ;              MEDN      - Index number indicating what medication is
 ;                          being processed
 ;----------------------------------------------------------------------
 ; Called from ABSPOSCA from ABSPOSQG from ABSPOSQ2,
 ; once for each item in its VMEDS() array.
MEDINFO(VMEDINFO,MEDN,INSPINS) ;EP
 ;Manage local variables
 N RXIEN,RXRFIEN,DRUGIEN,PROVIEN,RXI,IEN57,PINSTYPE
 ;
 ;Parse variables from VMEDINFO variable
 S RXIEN=$P(VMEDINFO,U,2)
 S RXRFIEN=$P(VMEDINFO,U,3)
 S IEN57=$P(VMEDINFO,U,5)
 D OVERRIDE(IEN57,MEDN) ; overrides stored in 9002313.511
 ;
 S PINSTYPE=$P(INSPINS,",") ; "CAID" will make a difference
 ;
 S DRUGIEN=$P($G(^PSRX(RXIEN,0)),U,6)
 S PROVIEN=$P($G(^PSRX(RXIEN,0)),U,4)
 ;
 S ABSP("RX",MEDN,"IEN57")=IEN57
 S (RXI,ABSP("RX",MEDN,"RX IEN"))=RXIEN
 S ABSP("RX",MEDN,"Date Written")=$P($G(^PSRX(RXIEN,0)),U,13)
 S ABSP("RX",MEDN,"RX Number")=RXIEN ;$P($G(^PSRX(RXIEN,0)),U,1)
 S ABSP("RX",MEDN,"New/Refill")=$S(RXRFIEN="":"N",1:"R")
 S ABSP("RX",MEDN,"Preauth #")=$P(^ABSPTL(IEN57,1),U,9)
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
 .S ABSP("RX",MEDN,"NDC")=$$NDCVAL^ABSPFUNC(RXIEN,RXRFIEN) ; patch 10
 .;IHS/SD/lwj 03/10/04 patch 10 end change
 ;IHS/OIT/CNI/RAN PATCH 40 This is the proper fill date
 S ABSP("RX","Date Filled")=ABSP("RX",MEDN,"Date Filled")
 ;
 S ABSP("RX",MEDN,"# Refills")=$P($G(^PSRX(RXIEN,0)),U,9)
 S ABSP("RX",MEDN,"Refill #")=$$RXRFN(RXIEN,RXRFIEN)
 S ABSP("RX",MEDN,"Prescriber IEN")=+PROVIEN
 S ABSP("RX",MEDN,"Prescriber DEA #")=$P($G(^VA(200,+PROVIEN,"PS")),U,2)
 S ABSP("RX",MEDN,"Prescriber CAID #")=$P($G(^VA(200,+PROVIEN,9999999)),U,7)
 S ABSP("RX",MEDN,"Prescriber UPIN #")=$P($G(^VA(200,+PROVIEN,9999999)),U,8) ;*1.26*2*
 S ABSP("RX",MEDN,"Prescriber Billing Location")=$S(PROVIEN]"":$P($G(^VA(200,PROVIEN,9999999)),"^",11),1:"") ; ANMC only?  not in Sitka's data dic.
 ;IHS/OIT/CASSEVERN/RAN 11/16/2010 PATCH 40 Adding Triplicate Serial # for New York Medicaid
 S ABSP("RX",MEDN,"Triplicate Serial #")=$P($G(^PSRX(RXIEN,9999999)),U,14)
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
 D:DRUGIEN'=""
 .S ABSP("RX",MEDN,"Drug IEN")=DRUGIEN
 .S ABSP("RX",MEDN,"Drug Name")=$P($G(^PSDRUG(DRUGIEN,0)),U,1)
 .I ABSP("RX",MEDN,"NDC")="" D
 ..S ABSP("RX",MEDN,"NDC")=$P($G(^PSDRUG(DRUGIEN,2)),U,4)
 N PRICING S PRICING=^ABSPTL(IEN57,5)
 S ABSP("RX",MEDN,"Quantity")=$P(PRICING,U) ; 01/31/2001
 S ABSP("RX",MEDN,"Unit Price")=$P(PRICING,U,2)
 S ABSP("RX",MEDN,"Ingredient Cost")=$J($P(PRICING,U,3),0,2)
 S ABSP("RX",MEDN,"Dispensing Fee")=$J($P(PRICING,U,4),0,2)
 S ABSP("Site","Dispensing Fee")=ABSP("RX",MEDN,"Dispensing Fee")
 S ABSP("RX",MEDN,"Gross Amount Due")=$J($P(PRICING,U,5),0,2)
 S ABSP("RX",MEDN,"Usual & Customary")=$J($P(PRICING,U,5),0,2)
 ;IHS/OIT/SCR 11/20/08 - Add incentive amount info
 S ABSP("RX",MEDN,"Incentive Amount")=$J($P(PRICING,U,7),0,2)
 I ABSP("NCPDP","Add Disp. Fee to Ingr. Cost") D
 . N X S X=ABSP("RX",MEDN,"Ingredient Cost")
 . S X=X+ABSP("RX",MEDN,"Dispensing Fee")
 . S ABSP("RX",MEDN,"Ingredient Cost")=X
 ;
 ; Visit-related data
 ;
 I IEN57 D
 . N VSITIEN S VSITIEN=$P(^ABSPTL(IEN57,0),U,7)
 . Q:'VSITIEN
 . ;S ABSP("RX",MEDN,"Diagnosis Code")=$TR($$PRIMPOV^APCLV(VSITIEN,"C"),".","")
 . ; For paper forms, do not strip the "."
 . ; Strictly speaking, electronic claims should have stripped the "."
 . ; in the format code, not here in the fetch
 . S ABSP("RX",MEDN,"Diagnosis Code")=$$PRIMPOV^APCLV(VSITIEN,"C")
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
OVERRIDE(IEN57,MEDN)    ; set any ABSP("OVERRIDE" nodes from 9002313.511 data
 ; ABSP("OVERRIDE",field)=value  for fields 101-401
 ; ABSP("OVERRIDE","RX",MEDN,field) for med #N, fields 402+
 ; Note that if you have multiple prescriptions bundled, the
 ; union of overrides from 101-401 apply to all; and if there's a 
 ; conflict, the last one overwrites the previous ones.
 N IEN511 S IEN511=$P(^ABSPTL(IEN57,1),U,13) Q:'IEN511
 D GET511^ABSPOSO2(IEN511,"ABSP(""OVERRIDE"")","ABSP(""OVERRIDE"",""RX"","_MEDN_")")
CC Q
