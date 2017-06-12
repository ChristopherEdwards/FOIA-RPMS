ABSPOSC2 ; IHS/FCS/DRS - certification testing ;     [ 06/22/2001  2:14 PM ]
 ;;1.0;PHARMACY POINT OF SALE;**42**;JUN 21, 2001;Build 15
 ; see remarks in ABSPOSC1 too
 Q
 ; ^ABSP(9002313.31, has data for test claims
 ; Now construct packets
ALL ; Construct packets for all entries in 9002313.31
 D IMPOSS^ABSPOSUE("P","TI","Development utility - incomplete",,"ALL",$T(+0))
 Q
 ;
TEST(ENTRY)       ;
 W "Testing in ",$T(+0),!
 I '$P(^ABSP(9002313.31,ENTRY,0),U,4) D  Q
 . W "Field .04 in 9002313.31 needs to have pointer to insurer.",!
 N DIALOUT S DIALOUT=$$DIALOUT
 N X S X=$$PACKET(ENTRY,DIALOUT,2) ; ^TMP($J gets copy of ABSP() data
 W "Input: 9002313.31 entry `",ENTRY,!
 W "Output: 9002313.02 entry `",X,!
 W !,"To send this claim, DO SEND^ABSPOSC2(",ENTRY,")",!
 ;M X=^ABSPC(X)
 ;ZW X
 ;K X M X=^TMP($J,$T(+0)) ZW X
 Q
REVERSAL(ENTRY,N)    ; construct the reversal packet for this 9002313.31 entry
 D LOG^ABSPOSL("Reversal claim `"_REV_" "_$P(^ABSPC(REV,0),U))
 ; for the N'th prescription therein - N defaults to 1
 ; First construct the original version.
 D TEST(ENTRY)
 N ORIG S ORIG=$P(^ABSP(9002313.31,ENTRY,0),U,3)
 I 'ORIG D  Q
 . D IMPOSS^ABSPOSUE("DB,P","TRI","Error constructing original claim",,"REVERSAL - 1",$T(+0))
 N REVERSAL S REVERSAL=$$REVERSE^ABSPECA8(ORIG,$S($G(N):N,1:1))
 W "Reversal: 9002313.02 entry `",REVERSAL,!
 I 'REVERSAL D  Q  ; error during construction of reversal
 . D IMPOSS^ABSPOSUE("DB,P","TRI","Error constructing reversal claim",,"REVERSAL - 2",$T(+0))
 ; Now construct the data packet
 N COUNT,DIALOUT,CLAIMIEN S COUNT=0
 S DIALOUT=$$DIALOUT,CLAIMIEN=REVERSAL D PASCII1^ABSPOSQH
 ; ORIG is obsolete, orphaned
 ; Overwrite the pointer to 9002313.02 with the Reversal packet
 N DIE S DIE=9002313.31,DA=ENTRY,DR=".03////"_REVERSAL D ^DIE
 ; Now SEND^ABSPOSC2(ENTRY) will send the reversal
 Q
DIALOUT()          Q $O(^ABSP(9002313.55,"B","RESERVED - DO NOT USE",0))
SEND(ENTRY)        ; 
 N IEN02 S IEN02=$P(^ABSP(9002313.31,ENTRY,0),U,3)
 D RUNTEST^ABSPOSC3($$DIALOUT,IEN02)
 W "The log file can be viewed by DO LOG^",$T(+0),!
 Q
LOG ;EP -
 W !,"At the prompt, just type RES to get the RESERVED - DO NOT USE",!
 D COMMSLOG^ABSPOSU6
 Q
PRINT(IEN31,FLAG) ;
 W "IEN31=",IEN31,!
 N CLAIM S CLAIM=$P(^ABSP(9002313.31,IEN31,0),U,3)
 I 'CLAIM W "No claim for IEN31=",IEN31,! Q
 I $G(FLAG)=0 G P12
 D PRINT02^ABSPOSAY(CLAIM)
P12 N RESP S RESP=$O(^ABSPR("B",CLAIM,""),-1)  ; get the most recent resp.
 I 'RESP W "No response for CLAIM=",CLAIM,! Q
 D PRINT03^ABSPOSAY(RESP)
 Q
PRINTR(IEN31) ;
 D PRINT(IEN31,0)
 Q
SAVEABSP K ^TMP($J,$T(+0))
 N % S %="ABSP"
 F  S %=$Q(@%) Q:%=""  S ^TMP($J,$T(+0),%)=@%
 Q
PACKET(ENTRY,DIALOUT,DUMPABSP)      ; EP - from ABSPOSC4
 N ABSP
 D SETABSP(ENTRY) ; construct the ABSP(*) array
 I $G(DUMPABSP)[1 D ZWRITE^ABSPOS("ABSP") ;ZW ABSP
 I $G(DUMPABSP)[2 D SAVEABSP
 N N S N=$P(^ABSP(9002313.31,ENTRY,2,0),U,3)
 D NEWCLAIM^ABSPOSCE(1,N,N) ; builds a 9002313.02 record
 N CLAIMIEN S CLAIMIEN=$P(^ABSPC(0),U,3)
 N COUNT S COUNT=0 ; this variable is used by PASCII1^ABSPOSQH
 D PASCII1^ABSPOSQH ; construct the data packet
 N DA,DIE,DR S DIE=9002313.31,DA=ENTRY,DR=".03////"_CLAIMIEN D ^DIE
 Q CLAIMIEN
SETABSP(ENTRY) ; Construct packet for just one entry in 9002313.31
 W "Create 9002313.02 claim for "
 W $P(^ABSP(9002313.31,ENTRY,0),U),!
 S ABSP("Insurer","IEN")=$P(^ABSP(9002313.31,ENTRY,0),U,4)
 S ABSP("Site","Switch Type")=$P(^ABSP(9002313.31,ENTRY,0),U,5)
 I ABSP("Site","Switch Type")=""  S ABSP("Site","Switch Type")="ENVOY"
 S ABSP("NCPDP","IEN")=$P(^ABSPEI(ABSP("Insurer","IEN"),100),U)
 ;IHS/OIT/CASSEVERN/RAN - 02/09/2011 - Patch 42 -New code for working without formats - START
 I $G(^ABSP(9002313.99,1,"ABSPICNV"))=1 D
 . N DO,VERSION
 . S DO=ABSP("NCPDP","IEN")_","
 . S VERSION=$$GET1^DIQ(9002313.4,DO,100.15) ;NEW PLACE TO STORE NCPDP VERSION
 . I $G(VERSION)="D.0" S ABSP("NCPDP","Version")="D0"
 . I $G(VERSION)="5.1" S ABSP("NCPDP","Version")="51"
 . S ABSP("NCPDP","BIN Number")=$$GET1^DIQ(9002313.4,DO,100.16)
 ELSE  D
 . ;IHS/OIT/CASSEVERN/RAN - 02/09/2011 - Patch 42 -New code for D.0 - END (Below 4 entries moved out one dot level)
 . S ABSP("NCPDP","BIN Number")=$P(^ABSPF(9002313.92,ABSP("NCPDP","IEN"),1),U)
 . S ABSP("NCPDP","Envoy Plan Number")=$P(^ABSPF(9002313.92,ABSP("NCPDP","IEN"),1),U,4)
 . S ABSP("NCPDP","Version")=$P(^ABSPF(9002313.92,ABSP("NCPDP","IEN"),1),U,2)
 . S ABSP("Envoy Terminal ID")=$P(^ABSP(9002313.56,1,0),U,6)
 N A,N S A=0 ; Loop through claim header fields
 F  S A=$O(^ABSP(9002313.31,ENTRY,1,A)) Q:'A  D
 . ; Set the Claim Header fields
 . N X S X=^ABSP(9002313.31,ENTRY,1,A,0)
 . N FIELD S FIELD=$P(^ABSPF(9002313.91,$P(X,U),0),U)
 . D SETABSP1(FIELD,$P(X,U,2))
 S N=0 ; Loop through prescription fields
 F  S N=$O(^ABSP(9002313.31,ENTRY,2,N)) Q:'N  D
 . N A S A=0
 . F  S A=$O(^ABSP(9002313.31,ENTRY,2,N,1,A)) Q:'A  D
 . . S X=^ABSP(9002313.31,ENTRY,2,N,1,A,0)
 . . N FIELD S FIELD=$P(^ABSPF(9002313.91,$P(X,U),0),U)
 . . D SETABSP1(FIELD,$P(X,U,2),N)
 . ; Construct a few other fields that weren't already set
 . I '$D(ABSP("Site","Dispensing Fee")) S ABSP("Site","Dispensing Fee")=4.5
 . ; Need this IEN59 for logging some stuff.
 . ; call it 9999991.00001, 9999992.00001, etc.
 . S ABSP("RX",N,"IEN59")=$$MYIEN59(N)
 . D INIT^ABSPOSL(ABSP("RX",N,"IEN59"))
 ; Construct a few other fields that weren't already set.
 S ABSP("Patient","Name")=$G(ABSP("Patient","Last Name"))_","_$G(ABSP("Patient","First Name"))
 Q
PRINTLOG(N) ; print the log file for test claim number N
 D PRINTLOG^ABSPOSL($$MYIEN59(N)) Q
MYIEN59(N) ; a fake number
 Q "999999"_N_".00001"
SETABSP1(FIELD,VALUE,N)         ; store values in Claim Header's ABSP(*)
 N OK S OK=0
 N I F I=1:1 Q:$T(TABLE+I)=" ;*"  D  Q:OK
 . N X S X=$T(TABLE+I)
 . I $P(X,";",2)'=FIELD Q
 . S @("ABSP("_$P(X,";",3)_")=VALUE")
 . S OK=1
 I 'OK W !,"Failed to find field ",FIELD," in TABLE^",$T(+0),!
 Q
TABLE ;
 ;101;"NCPDP","Envoy Plan Number"
 ;102;"NCPDP","Version"
 ;103;"Transaction Code"
 ;104;"Envoy Terminal ID"
 ;201;"Site","Pharmacy #"
 ;301;"Insurer","Group #"
 ;302;"Insurer","Policy #"
 ;303;"Insurer","Person Code"
 ;304;"Patient","DOB"
 ;305;"Patient","Sex"
 ;306;"Insurer","Relationship"
 ;308;"Patient","Other Coverage Code"
 ;307;"Customer Location"
 ;309;"Eligibility Clarification Code"
 ;310;"Patient","First Name"
 ;311;"Patient","Last Name"
 ;312;"Cardholder","First Name"
 ;313;"Cardholder","Last Name"
 ;322;"Patient","Street Address"
 ;323;"Patient","City"
 ;324;"Patient","State"
 ;325;"Patient","Zip"
 ;401;"RX","Date Filled"
 ;402;"RX",N,"RX Number"
 ;403;"RX",N,"Refill #"
 ;404;"RX",N,"Quantity"
 ;405;"RX",N,"Days Supply"
 ;406;"RX",N,"Compound Code"
 ;407;"RX",N,"NDC"
 ;408;"RX",N,"DAW"
 ;409;"RX",N,"Ingredient Cost"
 ;410;"RX",N,"Sales Tax"
 ;411;"RX",N,"Prescriber ID"
 ;412;"RX",N,"Dispensing Fee"
 ;414;"RX",N,"Date Written"
 ;415;"RX",N,"# Refills"
 ;416;"RX",N,"Preauth #"
 ;418;"RX",N,"Level of Service"
 ;419;"RX",N,"Origin Code"
 ;420;"RX",N,"Clarification"
 ;421;"RX",N,"Primary Prescriber"
 ;422;"RX",N,"Clinic ID"
 ;423;"RX",N,"Basis of Cost Determination"
 ;424;"RX",N,"Diagnosis Code"
 ;426;"RX",N,"Usual & Customary"
 ;429;"RX",N,"Unit Dose Indicator"
 ;430;"RX",N,"Gross Amount Due"
 ;431;"RX",N,"Other Payor Amount"
 ;433;"RX",N,"Patient Paid Amount"
 ;438;"RX",N,"Incentive Amount"
 ;439;"RX",N,"DUR Conflict Code"
 ;440;"RX",N,"DUR Intervention Code"
 ;441;"RX",N,"DUR Outcome Code"
 ;442;"RX",N,"Metric Decimal Quantity"
 ;443;"RX",N,"Primary Payor Denial Date"
 ;*
