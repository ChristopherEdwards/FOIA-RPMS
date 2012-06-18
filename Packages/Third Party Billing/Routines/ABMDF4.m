ABMDF4 ; IHS/ASDST/DMJ - ADA-90 Dental Export Routine ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;08/15/96 1:11 PM
 ;
 ;  IHS/DSD/DMJ - NOIS XFA-0698-200102
 ;      Meds showing up on split bill for ADA & HCFA.  Modified to
 ;      show meds on HCFA only also add code so claim generator will
 ;      not bomb if auto approve is turned on and Y2K fix to print 4
 ;      digit year in 3 birthdate fields.
 ; IHS/DSD/DMJ - 5/10/1999 - NOIS XAA-0599-200017 Patch 1
 ;           Itemized bills printing flat rate in batches at line BODY+4
 ; IHS/ASDS/LSL - 05/01/01 - V2.4 Patch 9 - NOIS HQW-0900-100053
 ;     Modified to allow use of dental prefix code on the ADA-90 form
 ;     as well.
 ;
 ; IHS/SD/EFG - V2.5 P8 - IM16385
 ;    Check for dental and misc services
 ; IHS/SD/SDR - v2.5 p10 - IM20395
 ;   Split out lines bundled by rev code
 ; IHS/SD/SDR - v2.5 p12 - IM24844
 ;   Fix for <UNDEF>BODY+78^ABMDF4
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;
 ; *********************************************************************
 ;
 K ABM
 S U="^"
 S ABMP("EXP")=4                        ; Export Mode
 D TXST^ABMDFUTL                        ; Create entry in 3P TX STATUS
 S ABMY("N")=0                          ; Initialize active insurer
 ; Print a form for every bill within an active insurer
 F  S ABMY("N")=$O(ABMY(ABMY("N"))) Q:'ABMY("N")  D
 .S ABMP("BDFN")=""
 .F  S ABMP("BDFN")=$O(ABMY(ABMY("N"),ABMP("BDFN"))) Q:'ABMP("BDFN")  D
 ..D ENT
 ..S DIE="^ABMDBILL(DUZ(2),"
 ..S DA=ABMP("BDFN")
 ..S DR=".04////B;.16////A;.17////"_ABMP("XMIT")
 ..D ^ABMDDIE
 ..Q:$D(ABM("DIE-FAIL"))
 ;
 D TXUPDT^ABMDFUTL                           ; Update 3P TX STATUS
 ;
XIT ;
 K ABM,ABMF,ABMV
 Q
 ;
ENT ;EP for getting data and printing form
 K ABMF
 Q:'$D(^ABMDBILL(DUZ(2),ABMP("BDFN"),0))     ; Quit if no bill data
 Q:'$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),33,0))&('$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,0)))  ;Quit if no dental or misc data
 D ENT^ABMDF4A,BODY
 Q
 ;
BODY ;
 ; For each dental entry in the bill file, find and print data
 S ABMX("INS")=ABMP("INS")              ; IEN to INSURER
 K ABMP("FLAT") D FRATE^ABMDE2X1                       ; find Flat Rate
 S (ABM("C"),ABM,ABM("TCHRG"),ABM("I"),ABM("YTOT"))=0
 ; BOX 30 
 F  S ABM=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),33,ABM)) Q:'ABM  S ABM(0)=^(ABM,0) D  Q:$D(DUOUT)
 .D RESET:ABM("I")=0
 .;
 .S ABM("F")=ABM("F")+1                ; Increment line counter
 .I $P(ABM(0),U,5) D
 ..S ABMOPS=$P(ABM(0),U,5)            ; IEN to DENTAL OPERATIVE SITE
 ..S ABMF(ABM("F"))=$P($G(^ADEOPS(ABMOPS,88)),U)  ; Tooth Mnemonic
 ..S:ABMF(ABM("F"))["D" ABMF(ABM("F"))=$P($G(^ADEOPS(ABMOPS,0)),U,4)  ; Tooth synonym
 .S $P(ABMF(ABM("F")),U,2)=$P(ABM(0),U,6)            ; Tooth Surface
 .S $P(ABMF(ABM("F")),U,3)=$P(^AUTTADA(+ABM(0),0),U,2)  ; Service Desc
 .S $P(ABMF(ABM("F")),U,4)=$E($P(ABM(0),U,7),4,5)    ; Date of serv. MM
 .S $P(ABMF(ABM("F")),U,5)=$E($P(ABM(0),U,7),6,7)    ; Date of serv. DD
 .S $P(ABMF(ABM("F")),U,6)=$E($P(ABM(0),U,7),2,3)    ; Date of serv. YY
 .S $P(ABMF(ABM("F")),U,7)=$P(^AUTTADA(+ABM(0),0),U) ; Procedure #
 .S ABMDENP=$P($G(^ABMDREC(ABMP("INS"),0)),U,2)      ; Dent remap
 .S:ABMDENP="" ABMDENP=$P($G(^ABMDPARM(ABMP("LDFN"),1,3)),U,11)
 .S:ABMDENP="" ABMDENP=$P($G(^ABMDPARM(DUZ(2),1,3)),U,11)
 .S:ABMDENP]"" $P(ABMF(ABM("F")),U,7)=ABMDENP_$P(ABMF(ABM("F")),U,7)
 .S ABM("CHRG")=+$P(ABM(0),U,8)*(+$P(ABM(0),U,9))
 .S $P(ABMF(ABM("F")),U,8)=$S(+$G(ABMP("FLAT")):"",1:ABM("CHRG"))
 .S ABM("TCHRG")=ABM("TCHRG")+ABM("CHRG")            ; Fee
 .;
 .S ABM("I")=ABM("I")+1                ; Increment line counter
 .I ABM("I")=14 D
 ..Q:'$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),33,ABM))
 ..S ABM("MORE")=1
 ..D ^ABMDF4X                         ; Print form
 ..S ABM("I")=0
 ;
 N ABMRV
 D 43^ABMERGR2  ;obtain misc services data in ABMRV array
 S ABMRCD=-1
 F  S ABMRCD=$O(ABMRV(ABMRCD)) Q:ABMRCD=""  D
 .S ABMED=""
 .F  S ABMED=$O(ABMRV(ABMRCD,ABMED)) Q:ABMED=""  D  Q:$D(DUOUT)
 ..S ABMCNTR=0
 ..F  S ABMCNTR=$O(ABMRV(ABMRCD,ABMED,ABMCNTR)) Q:ABMCNTR=""  D
 ...D RESET:ABM("I")=0
 ...S ABM("F")=ABM("F")+1
 ...S ABMMS=$P($$CPT^ABMCVAPI($O(^ICPT("B",ABMED,"")),ABMP("VDT")),U,3)  ;CPT name  ;CSV-c
 ...S ABMMSDT=$P(ABMRV(ABMRCD,ABMED,ABMCNTR),U,10)  ;date
 ...S ABMMSQTY=$P(ABMRV(ABMRCD,ABMED,ABMCNTR),U,5)  ;quantity
 ...S ABMMSCHG=$P(ABMRV(ABMRCD,ABMED,ABMCNTR),U,6)  ;charge
 ...I ABMMSDT]"" D
 ....S $P(ABMF(ABM("F")),U,3)=ABMMS
 ....S $P(ABMF(ABM("F")),U,4)=$E(ABMMSDT,4,5)
 ....S $P(ABMF(ABM("F")),U,5)=$E(ABMMSDT,6,7)
 ....S $P(ABMF(ABM("F")),U,6)=$E(ABMMSDT,2,3)
 ...S $P(ABMF(ABM("F")),U,7)=$P($G(ABMRV(ABMRCD,ABMED)),U,2)
 ...S $P(ABMF(ABM("F")),U,8)=ABMMSCHG
 ...S ABM("TCHRG")=ABM("TCHRG")+ABMMSCHG
 ...S ABM("I")=ABM("I")+1
 ...I ABM("I")=10 D
 ....Q:($O(ABMRV(ABMRCD,ABMED))=""&($O(ABMRV(ABMRCD))=""))
 ....S ABM("MORE")=1
 ....D ^ABMDF4X  ;print form
 ....S ABM("I")=0
 ; Put RX data on dental form
 N ABMRV
 D 23^ABMERGR2    ; Obtain RX data in ABMRV array
 S ABMRCD=-1
 F  S ABMRCD=$O(ABMRV(ABMRCD)) Q:ABMRCD=""  D
 .S ABMED=0
 .F  S ABMED=$O(ABMRV(ABMRCD,ABMED)) Q:'+ABMED  D  Q:$D(DUOUT)
 ..S ABMCNTR=0
 ..F  S ABMCNTR=$O(ABMRV(ABMRCD,ABMED,ABMCNTR)) Q:ABMCNTR=""  D
 ...D RESET:ABM("I")=0
 ...S ABM("F")=ABM("F")+1
 ...S ABMRX=$P(ABMRV(ABMRCD,ABMED,ABMCNTR),U,9)     ; NDC# name
 ...S ABMRXDT=$P(ABMRV(ABMRCD,ABMED,ABMCNTR),U,10)  ; date/time
 ...S ABMRXQTY=$P(ABMRV(ABMRCD,ABMED,ABMCNTR),U,5)  ; Quantity
 ...S ABMRXCHG=$P(ABMRV(ABMRCD,ABMED,ABMCNTR),U,6)  ; Charge
 ...S $P(ABMF(ABM("F")),U)=$E(ABMRX,1,3)
 ...S $P(ABMF(ABM("F")),U,2)=$E(ABMRX,4,8)
 ...S $P(ABMF(ABM("F")),U,3)=$E(ABMRX,9,99)
 ...I ABMRXDT]"" D
 ....S $P(ABMF(ABM("F")),U,4)=$E(ABMRXDT,4,5)
 ....S $P(ABMF(ABM("F")),U,5)=$E(ABMRXDT,6,7)
 ....S $P(ABMF(ABM("F")),U,6)=$E(ABMRXDT,2,3)
 ...S $P(ABMF(ABM("F")),U,7)="QTY "_ABMRXQTY
 ...S $P(ABMF(ABM("F")),U,8)=ABMRXCHG
 ...S ABM("TCHRG")=ABM("TCHRG")+ABMRXCHG
 ...S ABM("I")=ABM("I")+1
 ...I ABM("I")=14 D
 ....Q:($O(ABMRV(ABMRCD,ABMED))=""&($O(ABMRV(ABMRCD))=""))
 ....S ABM("MORE")=1
 ....D ^ABMDF4X                         ; Print form
 ....S ABM("I")=0
 ;
 D TAIL:ABM("I")
 Q
 ;
RESET ; Reset line numbers for BODY
 F ABM("F")=35:1:48 K ABMF(ABM("F"))
 S ABM("F")=34
 Q
 ;
TAIL ;END OF FORM
 I +$G(ABMP("FLAT")) S ABM("TCHRG")=+ABMP("FLAT")
 S $P(ABMF(57),U,4)=ABM("TCHRG")        ; Total fee charged
 S ABM("YTOT")=ABM("TCHRG")
 D YTOT^ABMDFUTL
 S (ABM("I"),ABM("TCHRG"))=0
 D ^ABMDF4X                             ; Print form
 Q
