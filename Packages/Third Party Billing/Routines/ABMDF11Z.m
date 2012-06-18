ABMDF11Z ; IHS/ASDST/DMJ - PRINT UB92 ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;DMJ;
 ;
 ; IHS/ASDS/LSL - 04/05/00 - V2.4 Patch 1 - NOIS NCA-0300-180046
 ;     Moved PROV to ABMDF11W because patching here would result in
 ;     exceeding maximum routine size allowed.
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM15561
 ;    Only do state license number if not Medicare
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM19557
 ;   Correct due from patient
 ;
 ; IHS/SD/SDR - v2.5 p12 - IM24099
 ;   Put CR/LF after quit in tag 47
 ;   Removed extra - top of tag 51
 ;
45 ;
 ; ABMPAID = Primary + Secondary + Tertiary + Prepaid
 ; ABMPBAL = Gross amount - ABM("PAID")
 ; Form locator #57
 W !
 ; If non-ben patient
 I ABMP("ITYPE")="N" D
 .S ABMPRPAY=+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),"^",9)
 .S ABMPAID=+($E($G(ABMREC(30,1)),173,182)/100)+($E($G(ABMREC(30,2)),173,182)/100)+($E($G(ABMREC(30,3)),173,182)/100)+ABMPRPAY
 .S:$G(ABMPBAL)<0 ABMPBAL=0
 .S ABMDE=$TR($FN(ABMPAID,"T",2),".")_"^45^10R"
 .D WRT^ABMDF11W                  ; Total paid
 .S ABMDE=$TR($FN(ABMPBAL,"T",2),".")_"^56^10R"
 .D WRT^ABMDF11W                  ; Remaining balance
 ;
47 ;
 W !
 N I
 F I=1:1:3 D
 .Q:'$D(ABMREC(30,I))
 .S ABMDE=$E(ABMREC(30,I),111,130)  ; Insured's last name
 .S ABMDE=$TR(ABMDE," ")
 .I $E(ABMREC(30,I),131,139)]"" S ABMDE=ABMDE_","_$TR($E(ABMREC(30,I),131,139)," ")   ; Add First Name
 .I $E(ABMREC(30,I),140)]"" S ABMDE=ABMDE_" "_$E(ABMREC(30,I),140)   ; Add Middle Initial
 .S ABMDE=ABMDE_"^^25"                  ; Insured's Name
 .D WRT^ABMDF11W                                ; form locator #58
 .S ABMDE=$E(ABMREC(30,I),144,145)_"^26^2"  ; Pat relation to Ins
 .D WRT^ABMDF11W                                ; form locator #59
 .S ABMDE=$E(ABMREC(30,I),35,53)_"^29^19"   ; Claim Certificate ID
 .D WRT^ABMDF11W                                ; form locator #60
 .S ABMDE=$E(ABMREC(30,I),97,110)_"^49^14"  ; Insured Group Name
 .D WRT^ABMDF11W                                ; form locator #61
 .S ABMDE=$E(ABMREC(30,I),80,96)_"^64^17"   ; Insurance Group Num
 .D WRT^ABMDF11W                                ; Form locator #62
 ;
51 ;
 N I
 F I=50:10:70 D
 .D @(I_"^ABMER40A")
 N I
 F I=1:1:3 D
 .W !
 .Q:'$D(ABMREC(30,I))
 .S ABMDE=ABMR(40,(10*I)+40)_"^^18"         ; Pro Authorization #
 .D WRT^ABMDF11W                                ; form locator #63
 .S ABMDE=$E(ABMREC(30,I),146)_"^19^1R"     ; Employmnt Status code
 .D WRT^ABMDF11W                                ; form locator #64
 .S ABMDE=$E(ABMREC(31,I),87,110)_"^21^24"  ; Employer name
 .D WRT^ABMDF11W                                ; form locator #65
 .S ABMTMPDE=$E(ABMREC(31,I),129,143)       ; Employer city, state
 .S ABMDE=$P(ABMTMPDE," ",1)
 .N J
 .F J=2:1:$L(ABMTMPDE," ") D
 ..I $P(ABMTMPDE," ",J)]"" S ABMDE=ABMDE_" "_$P(ABMTMPDE," ",J)
 .I $E(ABMREC(31,I),144,145)'="  " S ABMDE=ABMDE_", "_$E(ABMREC(31,I),144,145)
 .S ABMDE=ABMDE_"^46^35"                ; Employer location
 .D WRT^ABMDF11W                                ; form locator #66
 ;
55 ;
 W !!
 N I
 F I=40:10:120 D
 .D @(I_"^ABMER70A")
 N I
 F I=250,260 D
 .D @(I_"^ABMER70")
 S ABMDE=ABMR(70,40)_"^^6"       ; Principle Diagnosis
 D WRT^ABMDF11W                      ; form locator #67
 S ABMDE=ABMR(70,50)_"^7^6"      ; Other Diagnosis Code 1
 D WRT^ABMDF11W                      ; form locator #68
 S ABMDE=ABMR(70,60)_"^14^6"     ; Other Diagnosis Code 2
 D WRT^ABMDF11W                      ; form locator #69
 S ABMDE=ABMR(70,70)_"^21^6"     ; Other Diagnosis Code 3
 D WRT^ABMDF11W                      ; form locator #70
 S ABMDE=ABMR(70,80)_"^28^6"     ; Other Diagnosis Code 4
 D WRT^ABMDF11W                      ; form locator #71
 S ABMDE=ABMR(70,90)_"^35^6"     ; Other Diagnosis Code 5
 D WRT^ABMDF11W                      ; form locator #72
 S ABMDE=ABMR(70,100)_"^42^6"    ; Other Diagnosis Code 6
 D WRT^ABMDF11W                      ; form locator #73
 S ABMDE=ABMR(70,110)_"^49^6"    ; Other Diagnosis Code 7
 D WRT^ABMDF11W                      ; form locator #74
 S ABMDE=ABMR(70,120)_"^56^6"    ; Other Diagnosis Code 8
 D WRT^ABMDF11W                      ; form locator #75
 S ABMDE=ABMR(70,250)_"^64^6"    ; Admitting Diagnosis
 D WRT^ABMDF11W                      ; form locator #76
 S ABMDE=ABMR(70,260)_"^71^6"    ; External cause of injury
 D WRT^ABMDF11W                      ; form locator #77
 ;
56 ;
 W !
 D PROV^ABMDF11W
 ; Primary Provider State Liscence #
 I ABMP("ITYPE")'="R" D  ;only if not Medicare
 .S ABMDE=$P($G(ABM("PRV",1)),"^",3)_"^59^23"
 .D WRT^ABMDF11W  ;form locator #82a
 ;
57 ;
 W !
 N I
 F I=130:10:240,270 D
 .D @(I_"^ABMER70")
 S ABMDE=ABMR(70,270)_"^^1"      ; Procedure coding method used
 D WRT^ABMDF11W                      ; form locator #79
 I $P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,9)'="N" D
 .D WRT^ABMDF11W                      ; form locator #79
 .S ABMDE=ABMR(70,130)_"^3^7"     ; Principle Procedure code
 .D WRT^ABMDF11W                      ; form locator #80a
 .S ABMDE=ABMR(70,140)_"^11^6"    ; Principle Procedure date
 .D WRT^ABMDF11W                      ; form locator #80b
 .S ABMDE=ABMR(70,150)_"^18^7"    ; Other Procedure code - 1
 .D WRT^ABMDF11W                      ; form locator #81a
 .S ABMDE=ABMR(70,160)_"^26^6"    ; Other Procedure date - 1
 .D WRT^ABMDF11W                      ; form locator #81b
 .S ABMDE=ABMR(70,170)_"^33^7"    ; Other Procedure code - 2
 .D WRT^ABMDF11W                      ; form locator #81c
 .S ABMDE=ABMR(70,180)_"^41^6"    ; Other Procedure date - 2
 .D WRT^ABMDF11W                      ; form locator #81d
 ; Primary Provider UPIN/MCD #_name
 S ABMDE=$P($G(ABM("PRV",1)),"^",1)_"^49^32"
 D WRT^ABMDF11W                      ; form locator #82b
 ;
58 ;
 ; Secondary Provider Liscence #
 W !
 S ABMDE=$P($G(ABM("PRV",2)),"^",3)_"^59^23"
 D WRT^ABMDF11W                      ; form locator #83a
 ;
59 ;
 W !
 S ABMDE=ABMR(70,190)_"^3^7"     ; Other Procedure code - 3
 D WRT^ABMDF11W                      ; form locator #81e
 S ABMDE=ABMR(70,200)_"^11^6"    ; Other Procedure date - 3
 D WRT^ABMDF11W                      ; form locator #81f
 S ABMDE=ABMR(70,210)_"^18^7"    ; Other Procedure code - 4
 D WRT^ABMDF11W                      ; form locator #81g
 S ABMDE=ABMR(70,220)_"^26^6"    ; Other Procedure date - 4
 D WRT^ABMDF11W                      ; form locator #81h
 S ABMDE=ABMR(70,230)_"^33^7"    ; Other Procedure code - 5
 D WRT^ABMDF11W                      ; form locator #81i
 S ABMDE=ABMR(70,240)_"^41^6"    ; Other Procedure date - 5
 D WRT^ABMDF11W                      ; form locator #81j
 ; Secondary Provider UPIN/MCD #_name
 S ABMDE=$P($G(ABM("PRV",2)),"^",1)_"^49^32"
 D WRT^ABMDF11W                      ; form locator #83b
 ;
60 ;
 W !
 S ABMDE=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),61,1,0))_"^^48"  ; remarks line 1
 D WRT^ABMDF11W                      ; form locator #84a
 S ABMDE=$P($G(ABM("PRV",3)),"^",3)_"^59^23"  ; Tertiary Provider Liscence #
 D WRT^ABMDF11W                      ; form locator #83c
 ;
61 ;
 W !
 S ABMDE=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),61,2,0))_"^^48"  ; remarks line 2
 D WRT^ABMDF11W                      ; form locator #84b
 ; Tertiary Provider UPIN/MCD #_name
 S ABMDE=$P($G(ABM("PRV",3)),"^",1)_"^49^32"
 D WRT^ABMDF11W                      ; form locator #83d
 ;
62 ;
 W !
 S ABMDE=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),61,3,0))_"^^48"  ; remarks line 3
 D WRT^ABMDF11W                      ; form locator #84c
 ;
63 ;
 W !
 S ABMDE=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),61,4,0))_"^^48"  ; remarks line 4
 D WRT^ABMDF11W                      ; form locator #84d
 S ABMSIGN=$P($G(^ABMDPARM(DUZ(2),1,3)),"^",8)  ; UB-92 Signature IEN
 S:ABMSIGN="" ABMSIGN=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),1)),"^",4)  ;  Approving official IEN
 S ABMDE=$P($G(^VA(200,+ABMSIGN,20)),"^",2)_"^51^23"  ; Signature block printed name
 D WRT^ABMDF11W                      ; form locator #85
 S ABMDE=$E(DT,4,7)_$E(DT,2,3)_"^74^6"  ; Today's date
 D WRT^ABMDF11W                      ; form locator #86
 Q
