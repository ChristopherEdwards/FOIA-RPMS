ABMDF11W ; IHS/ASDST/DMJ - PRINT UB92 ;   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ; Original;LSL; June 20, 1997
 ;
 ; IHS/ASDS/LSL - 04/05/00 - V2.4 Patch 1 - NOIS NCA-0300-180046
 ;     Moved PROV to this routine because patching in ABMDF11Z
 ;     resulted in exceeding maximum routine size allowed.
 ;     If medicaid, look for payor assigned provider number in the NEW
 ;     PERSON File before looking at MEDICAID NUMBER in the NEW PERSON
 ;     File.
 ;
 ; IHS/ASDS/SDH - 09/27/01 - V2.4 Patch 9 - NOIS XAA-0901-200095
 ;     After moving Kidscare to Page 5 from Page 7 found that there are
 ;     checks that are done for Medicaid that should also be done for
 ;     Kidscare.
 ;
 ; IHS/SD/SDR - v2.5 p8 - IM13944
 ;    Print credentials.
 ;
 ; *********************************************************************
 ;
 Q
 ;
WRT ; EP
 ; Write data element in requested format
 S ABMTAB=+$P(ABMDE,"^",2)+ABMP("LM")
 I $P(ABMDE,"^",3)["R" S $P(ABMDE,"^")=$J($P(ABMDE,"^"),+$P(ABMDE,"^",3))
 S ABMDE=$E($P(ABMDE,"^"),1,+$P(ABMDE,"^",3))
 S:ABMTAB+$L(ABMDE)>IOM ABMDE=$E(ABMDE,1,IOM-ABMTAB)
 W ?ABMTAB,ABMDE
 Q
 ;
TEST ; EP
 ; Test Alignment
 S ABMP("LM")=$P(^ABMDEXP(11,0),"^",2)
 N I
 F I=1:1:4 D
 .W !
 .S ABMDE="XXXXX BLOCK 1 LINE "_I_" XXXXX"_"^^25"
 .D WRT
 .I I=2 D
 ..S ABMDE="XXXXXXXXXXXXXXXXXXXXX"_"^57^20"
 ..D WRT
 ..S ABMDE="XXX"_"^78^3"
 ..D WRT
 ..Q
 N I
 F I=1:1:14 W !
 S ABMDE=" 100 ALL INCL R&B/ANC"_"^^29"
 D WRT
 S ABMDE="450.00 ^30^9R"
 D WRT
 S ABMDE=3_"^47^7R"
 D WRT
 S ABMDE=135000_" ^55^10R"
 D WRT
 W $$EN^ABMVDF("IOF")
 Q
 ;
PROV ;EP - PROVIDER INFORMATION
 ;  ABM("PRV",#) = UPIN/MCD #_Provider Name ^ UPIN/MCD# ^
 ;                 Provider State Liscence Number
 S ABMPRVTP=0               ; Initialize Provider Type 
 S ABMPCNT=0                ; Initialize Provider Count 
 F  S ABMPRVTP=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,"C",ABMPRVTP)) Q:ABMPRVTP=""  D
 .S ABMPRVNO=0             ; Initialize Provider number
 .F  S ABMPRVNO=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,"C",ABMPRVTP,ABMPRVNO)) Q:'ABMPRVNO  D
 ..; NEW PERSON file IEN
 ..S ABMPRV=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,ABMPRVNO,0),"^",1)
 ..S ABMPCNT=ABMPCNT+1     ; Increment provider count
 ..Q:ABMPCNT>3             ; only 1st 3 providers
 ..S ABM("PRV",ABMPCNT)=$P($G(^VA(200,ABMPRV,20)),"^",2)  ; Provider name
 ..S $P(ABM("PRV",ABMPCNT),U,2)=""
 ..; If Medicare FI, find provider UPIN
 ..I ABMP("ITYPE")="R" D
 ...S ABMUPIN=$P($G(^VA(200,ABMPRV,9999999)),"^",8)
 ...S:ABMUPIN="" ABMUPIN="PHS000"
 ...S $P(ABM("PRV",ABMPCNT),U,2)=ABMUPIN
 ..;If Medicaid FI, get MCD Number
 ..I ABMP("ITYPE")="D"!(ABMP("ITYPE")="K") D
 ...S $P(ABM("PRV",ABMPCNT),U,2)=$P($G(^VA(200,ABMPRV,9999999.18,+ABMP("INS"),0)),U,2)
 ...S:$P(ABM("PRV",ABMPCNT),U,2)="" $P(ABM("PRV",ABMPCNT),U,2)=$P($G(^VA(200,ABMPRV,9999999)),U,7)
 ..S:$P(ABM("PRV",ABMPCNT),"^",2)]"" $P(ABM("PRV",ABMPCNT),"^")=$P(ABM("PRV",ABMPCNT),"^",2)_"  "_$P(ABM("PRV",ABMPCNT),"^")
 ..S ABMVST=$P($G(^AUTTLOC(+ABMP("LDFN"),0)),"^",23)  ; state IEN
 ..S:ABMVST="" ABMVST=$P($G(^AUTTLOC(+ABMP("LDFN"),0)),"^",14)
 ..S $P(ABM("PRV",ABMPCNT),"^",3)=$$SLN^ABMERUTL(ABMPRV,ABMVST)  ; Provider State License number
 Q
