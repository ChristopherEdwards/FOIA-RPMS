PSJHL2 ;BIR/RLW-PATIENT ID AND VISIT SEGMENTS ;22 Nov 1999  9:27 AM
 ;;5.0; INPATIENT MEDICATIONS ;**1,18,16,23,28,42,50,70,58,100,102**;16 DEC 97
 ;
 ; Reference to ^PS(55 is supported by DBIA# 2191.
 ; Reference to ^SC("B" is supported by DBIA# 10040.
 ; Reference to $$FMTHL7^XLFDT is supported by DBIA# 10103.
 ;
EN1(PSJHLDFN,PSOC,PSJORDER,PSREASON) ; start here
 ; passed in are PSJHLDFN (patient ien)
 ;               PSJORDER* (order_file (N,P,V, etc))
 ;               PSOC* (order control code - NW for new order, OK to return filler number to OE/RR, OC for order canceled, SC for status change)
 ;               PSREASON* (text reason)
 ; *=optional, only required if an order segment is also to be generated
START ;
 K ^TMP("PSJHLS",$J,"PS")
 N CLERK,J,LIMIT,NAME,NEXT,NODE1,NODE2,NODE4,NOO,PSJCLEAR,PSJHINST,PSJHLSDT,PROVIDER,PSJI,ROOMBED,RXORDER,STATUS,UNDO,VERIFY,WARD
 S RXORDER=PSJORDER,PSJORDER=$S((PSJORDER["N")!(PSJORDER["P"):"^PS(53.1,"_+PSJORDER,PSJORDER["V":"^PS(55,"_PSJHLDFN_",""IV"","_+PSJORDER,1:"^PS(55,"_PSJHLDFN_",5,"_+PSJORDER)_","
 I RXORDER["P",$P($G(@(PSJORDER_"0)")),U,15)'=PSJHLDFN S ORDCON="Patient does not match/PSJHL2" S X="ORERR" X ^%ZOSF("TEST") I  D EN^ORERR(ORDCON) Q
 S UNDO=$S("OC^CR"[PSOC:1,1:0)
 D INIT,PID,PV1,ORC
 D @$S("SN^SC^OC^OD^DR^CR^OH^OR^XX^ZC^XR"[PSOC:"EN1^PSJHL3(PSJHLDFN,PSOC,PSJORDER)",1:"CALL^PSJHLU(PSJI)")
 I UNDO D UNDO
 K ^TMP("PSJHLS",$J,"PS"),FIELD
 Q
 ;
INIT ; initialize HL7 variables, set master file identification segment
 ; PSJHLMTN = message type - ORR for messages sent as a response to an OE/RR event; ORM for "unsolicited" messages.
 S PSJI=0,PSJHLMTN=$S($G(PSJHLMTN)]"":PSJHLMTN,1:"ORM")
 D INIT^PSJHLU
 S LIMIT=17 X PSJCLEAR
 S FIELD(0)="MSH",FIELD(1)="^~\&",FIELD(2)="PHARMACY",FIELD(3)=$G(PSJHINST),FIELD(8)=PSJHLMTN
 D SEGMENT^PSJHLU(LIMIT),DISPLAY
 Q
 ;
PID ; get patient data, format PID SEGMENT
 S LIMIT=22 X PSJCLEAR
 S FIELD(0)="PID"
 S FIELD(3)=PSJHLDFN
 N DFN S DFN=PSJHLDFN D DEM^VADPT S FIELD(5)=VADM(1)
 D SEGMENT^PSJHLU(LIMIT),DISPLAY
 Q
 ;
PV1 ; get patient visit information, format PV1 segment
 S LIMIT=50 X PSJCLEAR
 S FIELD(0)="PV1"
 I PSJHLMTN="ORR" S FIELD(3)=LOC
 I PSJHLMTN="ORM" D
 .S LOC="",WARD=$G(^DPT(PSJHLDFN,.1)),LOC=$S($G(WARD)]"":$O(^SC("B",WARD,LOC)),1:LOC)
 .I $G(LOC)="" D
 .. I RXORDER["P",($G(^PS(53.1,+RXORDER,"DSS"))) S LOC=^("DSS")
 .. I RXORDER["V",($G(^PS(55,PSJHLDFN,"IV",+RXORDER,"DSS"))) S LOC=^("DSS")
 .I $G(LOC)]"" S ROOMBED=$G(^DPT(PSJHLDFN,.101)),LOC=LOC_"^"_ROOMBED
 .S FIELD(3)=LOC
 S FIELD(2)=$S($G(CLASS)="O":CLASS,1:"I")
 I FIELD(2)="I" N DFN S DFN=PSJHLDFN D INP^VADPT S FIELD(19)=VAIN(1)
 D SEGMENT^PSJHLU(LIMIT),DISPLAY
 Q
 ;
ORC ; order control segment
 S LIMIT=18 X PSJCLEAR
 Q:'$D(PSJORDER)!'$D(PSOC)
 S NODE1=$G(@(PSJORDER_"0)")),NODE2=$G(@(PSJORDER_"2)"))
 S NODE4=$G(@(PSJORDER_"4)"))
 S FIELD(0)="ORC"
 S FIELD(1)=PSOC
 S FIELD(2)=$S(PSOC="SN":"",1:$P(NODE1,"^",21))_"^OR" I $P(FIELD(2),"^")=0 S $P(FIELD(2),"^")="" ; IV orders are created with a zero in the oerr order number, for some reason
 S FIELD(3)=RXORDER_"^PS"
 ; translate Pharmacy status code to HL7 status code, set in FIELD(5)
 S STATUS=$S(RXORDER["V":($P(NODE1,"^",17)),1:($P(NODE1,"^",9)))
 D @STATUS
 I STATUS="U",RXORDER["P" S FIELD(3)="^PS"
 S FIELD(9)=$S(RXORDER["V":$$FMTHL7^XLFDT($P(NODE2,"^")),1:$$FMTHL7^XLFDT($P(NODE1,"^",16)))
 S CLERK=$S(RXORDER["V":$P(NODE2,"^",11),1:$P(NODE4,"^",7))
 S NAME=$P($G(^VA(200,+CLERK,0)),"^")
 S FIELD(10)=CLERK_"^"_NAME
 I PSOC="ZV"!($G(PSJBCBU)) S VERIFY=$P($G(NODE4),"^"),FIELD(11)=VERIFY_"^"_$P($G(^VA(200,+VERIFY,0)),"^"),FIELD(9)=$$FMTHL7^XLFDT($P(NODE4,"^",2))
 S PROVIDER=$S($G(PSJDCPRV)]"":$G(PSJDCPRV),RXORDER["V":$P(NODE1,"^",6),1:$P(NODE1,"^",2)) K PSJDCPRV
 S NAME=$P($G(^VA(200,+PROVIDER,0)),"^")
 S FIELD(12)=PROVIDER_"^"_NAME
 S FIELD(15)=$S(RXORDER["V":$$FMTHL7^XLFDT($P(NODE1,"^",2)),1:$$FMTHL7^XLFDT($P(NODE2,"^",2)))
 S NOO=$S(PSJORDER["IV":$G(P("NAT")),(($G(PSJNOO)="")&($G(P("NAT"))]"")):$G(P("NAT")),1:$G(PSJNOO)),PSREASON=$S(NOO="D":"",1:$G(PSREASON))
 S FIELD(16)=NOO_U_$S(NOO="P":"Telephoned",NOO="D":"Duplicate",NOO="X":"Rejected",NOO="A":"Auto",NOO="S":"Service Correction",NOO="W":"Written",NOO="V":"Verbal",NOO="E":"Physician Entered",NOO="I":"Policy",1:"")_U_"99ORN"_U_U_$G(PSREASON)_U
 D SEGMENT^PSJHLU(LIMIT),DISPLAY
 Q
 ;
DISPLAY ; just for testing
 ;W ! F NEXT=0:1:LIMIT W FIELD(NEXT)_"|"
 Q
UNDO ;Undo Renew if Pending Renewal is dc'd
 I RXORDER["P",(STATUS="D"),($G(PSJNOO)'="A"),($P(NODE1,U,24)="R") D ENBKOUT^PSJOREN(PSJHLDFN,RXORDER)
 Q
 ;
A S FIELD(5)="CM" Q  ; active
D S FIELD(5)="DC" Q  ; discontinued
I S FIELD(5)="IP" Q  ; incomplete
N S FIELD(5)="IP" Q  ; non-verified
U S FIELD(5)="ZX" Q  ; unreleased
P S FIELD(5)="IP" Q  ; pending
DE S FIELD(5)="RP" Q  ; discontinued (edit)
E S FIELD(5)="ZE" Q  ; expired
H S FIELD(5)="HD" Q  ; hold
R S FIELD(5)="ZZ" Q  ; renewed
RE S FIELD(5)="CM" Q  ; reinstated
DR S FIELD(5)="DC" Q  ; discontinued (renewal)
O S FIELD(5)="HD" Q  ; on call (is this kind of like HOLD?)
