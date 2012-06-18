ABMDF11 ; IHS/ASDST/DMJ - Set UB92 Print Array ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**6**;NOV 12, 2009
 ;Original;TMD;12/15/95 2:39 PM
 ;
 ;IHS/DSD/DMJ - 5/7/1999 - NOIS XAA-0599-200017 Patch 1
 ;            Itemized bills printing flat rate at line FRATE+5
 ;
 ; IHS/SD/SDR - v2.5 p8 - IM14272/IM15419
 ;    Used billed amount on 3P Bill for flat rate per Adrian; Due
 ;    to Inpt covered days, make rate=billed amount/covered days(units)
 ; IHS/SD/SDR - abm*2.6*6 - Swing Bed changes
 ;
 ;  INPUT:  ABMY(active insurer IEN, 3P BILL IEN)="" ;
 K ABMP
 S U="^"
 S ABMP("XMIT")=0        ; initialize transmittal flag
 S ABMP("EXP")=11        ; set mode of export to 11 (UB-92)
 S ABMY("TOT")="0^0^0"   ; # bills ^ $ amt ^ # insurers
 S ABMP("NOFMT")=1       ; format flag used for EMC
 ;
BDFN ;
 ; Loop ABMY array to print bills grouped by insurer
 S ABMY("N")=0           ; initialize active insurer
 F  S ABMY("N")=$O(ABMY(ABMY("N"))) Q:'ABMY("N")  D
 .S ABMP("BDFN")=0      ; initialize 3P BILL IEN
 .F  S ABMP("BDFN")=$O(ABMY(ABMY("N"),ABMP("BDFN"))) Q:'ABMP("BDFN")  D
 ..Q:'$D(^ABMDBILL(DUZ(2),ABMP("BDFN"),0))  ; Quit if no bill data
 ..D ENT               ; gather data print form
 ..S $P(ABMY("TOT"),U)=$P(ABMY("TOT"),U)+1  ; increment bill count
 ..I ABMP("XMIT")=0 D  ; if no previous transmittal do...
 ...S ABM("XM")=""
 ...F  S ABM("XM")=$O(^ABMDTXST(DUZ(2),"B",DT,ABM("XM"))) Q:'ABM("XM")  D  Q:ABMP("XMIT")
 ....Q:'$D(^ABMDTXST(DUZ(2),ABM("XM"),0))  ; Quit if no data
 ....Q:$P(^ABMDTXST(DUZ(2),ABM("XM"),0),U,2)'=ABMP("EXP")         ; Quit if wrong export mode
 ....I $D(ABMY("TYP")),$P(^ABMDTXST(DUZ(2),ABM("XM"),0),U,3)=ABMY("TYP") S ABMP("XMIT")=ABM("XM")    ; Insurer type
 ....I $D(ABMY("INS")),$P(^ABMDTXST(DUZ(2),ABM("XM"),0),U,4)=ABMY("INS") S ABMP("XMIT")=ABM("XM")    ; Insurer
 ....Q
 ...Q
 ..; Create entry in 3P TX STATUS
 ..I '+ABMP("XMIT") D
 ...S DIC="^ABMDTXST(DUZ(2),"
 ...S DIC(0)="L"
 ...S X=DT
 ...S DIC("DR")=".02////11;.07////1;.08////1;"_$S($D(ABMY("TYP")):".03////"_ABMY("TYP"),$D(ABMY("INS")):".04////"_$P(ABMY("INS"),U),1:".03////A")_";.05////"_DUZ
 ...K DD,DO,DINUM D FILE^DICN
 ...S ABMP("XMIT")=+Y
 ...Q
 ..S DIE="^ABMDBILL(DUZ(2),"
 ..S DA=ABMP("BDFN")
 ..S DR=".04////B;.16////A;.17////"_ABMP("XMIT")
 ..D ^ABMDDIE
 ..Q:$D(ABM("DIE-FAIL"))
 ..K ^ABMDBILL(DUZ(2),"AS",+^ABMDBILL(DUZ(2),ABMP("BDFN"),0),"A",ABMP("BDFN"))
 ..S ABM=ABMP("BDFN")
 ..S ABM("L")=ABMP("XMIT")
 ..K ABMP
 ..S ABMP("XMIT")=ABM("L")
 ..S ABMP("BDFN")=ABM
 K ABM,ABMF
 Q
 ;
ENT ;EP for setting up export array and printing form
 K ABMF,ABM,ABMU,ABMR,ABMS,ABME,ABMP("CPT")
 S ABMP("B0")=^ABMDBILL(DUZ(2),ABMP("BDFN"),0)  ; 3P BILL 0 node
 S ABMP("INS")=$P(ABMP("B0"),U,8)     ; Active insurer
 Q:'ABMP("INS")                       ; Q:no active insurer
 S ABMP("ITYPE")=$P($G(^AUTNINS(ABMP("INS"),2)),"^",1)  ; type of insur
 S ABMP("PDFN")=$P(ABMP("B0"),U,5)    ; IEN to patient
 S ABMP("CDFN")=+$P(ABMP("B0"),U)      ; IEN to 3P CLAIM
 S ABMP("LDFN")=$P(ABMP("B0"),U,3)    ; IEN to location (visit location)
 S ABMP("VTYP")=$P(ABMP("B0"),U,7)    ; Visit type
 Q:'ABMP("PDFN")!('+ABMP("LDFN"))     ; Q: no patient or location
 S ABMP("VDT")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),7),U)  ; Serv. date from
 S ABMP("BTYP")=$P(ABMP("B0"),U,2)  ; Bill type
 S ABMP("EXP")=$P(ABMP("B0"),U,6) S:ABMP("EXP")="" ABMP("EXP")=11 ;Export mode w/default set to 11
 D EXP^ABMDEVAR  ; set export array ABMP("EXP",IEN to 3P EXPORT MODE)
 D ISET^ABMERUTL ; set export array ABMP("VTYP",IEN to VISIT)=IEN to 3P EXPORT MODE
 S $P(ABMY("TOT"),"^",2)=$P(ABMY("TOT"),"^",2)+$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),2),"^",1)  ; increment total bill amount
 I '$D(ABMY("TINS",ABMP("INS"))) D
 .S ABMY("TINS",ABMP("INS"))=""
 .S $P(ABMY("TOT"),"^",3)=$P(ABMY("TOT"),"^",3)+1  ; increment total number of insurers
 .Q
 D FRATE         ; Build flat rate
 D ^ABMDF11X     ; Gather data and print bill
 Q
 ;
FRATE ; EP
 ; BUILD FLAT RATE VARIABLE
 ; ABMP("FLAT")="Flat rate of visit ^ Revenue Code ^ # days covered"
 ; if date in Visit file is in specified range for specified visit type
 K ABMP("FLAT")
 Q:$P(^AUTNINS(ABMP("INS"),2),"^",2)'="Y"
 I $O(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),11,0)) D
 .I ABMP("BTYP")=121 S ABMP("VTYP")=121  ; Ancillary
 .S ABMP("FLAT")=$$FLAT^ABMDUTL(ABMP("INS"),ABMP("VTYP"),ABMP("VDT"))  ; Rate of visit
 .I +ABMP("FLAT")&(+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),2)),U)'=0) S ABMP("FLAT")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),2)),U)
 .I '+ABMP("FLAT") K ABMP("FLAT") Q
 .S $P(ABMP("FLAT"),"^",2)=$P(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0),"^",3)  ; Revenue code
 .I ABMP("BTYP")=121 S ABMP("VTYP")=111
 .I ABMP("BTYP")=181 S ABMP("VTYP")=111  ;abm*2.6*6 Swing bed
 .I $P(ABMP("FLAT"),"^",2)="" D   ; if no revenue code
 ..I ABMP("VTYP")'=111 S $P(ABMP("FLAT"),"^",2)=510 Q  ; and not inpatient
 ..I ABMP("BTYP")=121 S $P(ABMP("FLAT"),"^",2)=240 Q  ; and inpatient
 ..S $P(ABMP("FLAT"),"^",2)=100 Q  ; else
 ..Q
 .S $P(ABMP("FLAT"),"^",3)=$S(ABMP("VTYP")=111:$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),"^",3),1:1)  ; number of days covered
 .S:$P(ABMP("FLAT"),"^",3)=0 $P(ABMP("FLAT"),"^",3)=1
 .S $P(ABMP("FLAT"),U)=$P(ABMP("FLAT"),U)/$P(ABMP("FLAT"),U,3)
 .Q
 K ABM
 Q
