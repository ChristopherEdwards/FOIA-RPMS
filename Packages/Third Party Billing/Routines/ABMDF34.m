ABMDF34 ; IHS/SD/SDR - ADA-2012 Dental Export Routine ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**14,16,19**;NOV 12, 2009;Build 300
 ;IHS/SD/SDR - 2.6*14 - HEAT136149 - Fixed box 34 to print 'B' for ICD9 codes.
 ;IHS/SD/SDR - 2.6*14 Updated DX^ABMCVAPI call to be numeric
 ;IHS/SD/SDR - 2.6*16 HEAT231506 - Added code for 'AB' to print for ICD10.
 ;IHS/SD/AML - 2.6*19 - HEAT181886 - Change coor. dx from numeric to alpha
 ;
 ;************************************************************************************
 K ABM
 S U="^"
 S ABMP("EXP")=34                ; Export mode
 D TXST^ABMDFUTL                 ; Create entry in 3P TX STATUS
 S ABMY("N")=0                   ; Initialize active insurer
 ; Print a form for every bill within an active insurer
 F  S ABMY("N")=$O(ABMY(ABMY("N"))) Q:'ABMY("N")  D
 .S ABMP("BDFN")=""             ; Initialize bill IEN
 .F  S ABMP("BDFN")=$O(ABMY(ABMY("N"),ABMP("BDFN"))) Q:'ABMP("BDFN")  D
 ..D ENT
 ..S DIE="^ABMDBILL(DUZ(2),"
 ..S DA=ABMP("BDFN")
 ..S DR=".04////B;.16////A;.17////"_ABMP("XMIT")
 ..D ^ABMDDIE
 ..Q:$D(ABM("DIE-FAIL"))
 ;
 D TXUPDT^ABMDFUTL               ; Update 3P TX STATUS
 ;
XIT ;
 K ABM,ABMF,ABMV
 Q
 ;
ENT ;EP for getting data and printing form
 K ABMF
 Q:'$D(^ABMDBILL(DUZ(2),ABMP("BDFN"),0))     ; Quit if no bill data
 Q:'$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),33,0))&('$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),43,0)))  ; Quit if no dental and misc data
 D ENT^ABMDF34A,BODY
 Q
 ;
BODY ;
 ; For each dental entry in the bill file, find and print data.
 S ABMX("INS")=ABMP("INS")       ; IEN to INSURER
 K ABMP("FLAT")
 D FRATE^ABMDE2X1                ; find Flat Rate
 S (ABM("C"),ABM,ABM("TCHRG"),ABM("I"),ABM("YTOT"))=0
 ;
 ;S $P(ABMF(36),U)="09"  ;(34)  ;abm*2.6*14 HEAT136149
 ;S $P(ABMF(36),U)="B"  ;(34)  ;abm*2.6*14 HEAT136149  ;abm*2.6*16 IHS/SD/SDR HEAT231506
 S $P(ABMF(36),U)=$S($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,21)=10:"AB",1:"B")  ;(34)  ;abm*2.6*14 HEAT136149  ;abm*2.6*16 IHS/SD/SDR HEAT231506
 ;(34a)
 F  S ABM=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,"C",ABM)) Q:'ABM  D  Q:(ABM("C")=4)
 .S ABM("C")=+$G(ABM("C"))+1
 .S ABM("X")=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,"C",ABM,""))
 .;S ABM("DX")=$P($$DX^ABMCVAPI($P(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,ABM("X"),0),U),ABMP("VDT")),U,2)  ;abm*2.6*14 updated API call
 .S ABM("DX")=$P($$DX^ABMCVAPI(+$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,ABM("X"),0),U),ABMP("VDT")),U,2)  ;abm*2.6*14 updated API call
 .I ABM=1 S $P(ABMF(37),U)=ABM("DX")
 .I ABM=2 S $P(ABMF(38),U)=ABM("DX")
 .I ABM=3 S $P(ABMF(37),U,2)=ABM("DX")
 .I ABM=4 S $P(ABMF(38),U,2)=ABM("DX")
 S (ABM,ABM("C"),ABM("X"),ABM("DX"))=0
 F  S ABM=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),33,ABM)) Q:'ABM  D  Q:$D(DUOUT)
 .S ABM(0)=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),33,ABM,0))
 .D RESET:ABM("I")=0
 .S ABM("F")=ABM("F")+1         ; Increment line counter
 .I $P(ABM(0),U,5) D
 ..S ABMOPS=$P(ABM(0),U,5)     ; IEN to DENTAL OPERATIVE SITE
 ..S $P(ABMF(ABM("F")),U,4)=$P($G(^ADEOPS(ABMOPS,88)),U)    ; Tooth mnemonic (d)  (27)
 .;
 .; Procedure date (24)
 .S $P(ABMF(ABM("F")),U)=$P(ABM(0),U,7)        ; DOS (24)
 .S $P(ABMF(ABM("F")),U,2)=$P(ABM(0),U,11)    ;Area of Oral Cavity (25)
 .S $P(ABMF(ABM("F")),U,3)=$P(ABM(0),U,12)    ;Tooth system (26)
 .;
 .S $P(ABMF(ABM("F")),U,5)=$P(ABM(0),U,6)                 ; Tooth surface (28)
 .S $P(ABMF(ABM("F")),U,9)=$P(^AUTTADA(+ABM(0),0),U,2)    ; Svc desc (30)
 .S $P(ABMF(ABM("F")),U,6)=$P(^AUTTADA(+ABM(0),0),U)      ; Procedure # (29)
 .;S $P(ABMF(ABM("F")),U,7)=$P(ABM(0),U,4)      ;Coor. DX (29a)  ;abm*2.6*19 IHS/SD/AML HEAT181886 Translate numeric corres DX to alpha
 .;start new abm*2.6*19 IHS/SD/AML HEAT181886 translate numeric corres DX to alpha
 .S ABMCORDX=$P(ABM(0),U,4)
 .S ABMCORDX=$P(ABMCORDX,",",1,4)
 .F ABMTMP=1:1:$L(ABMCORDX,",") D
 ..S $P(ABMCORDX,",",ABMTMP)=$P("A^B^C^D^","^",$P(ABMCORDX,",",ABMTMP))
 .S $P(ABMF(ABM("F")),U,7)=$TR(ABMCORDX,",")     ;Coor. DX (29a)
 .;end new abm*2.6*19 HEAT181886
 .S $P(ABMF(ABM("F")),U,8)=$P(ABM(0),U,9)      ;Qty(29b)
 .;
 .S ABMDENP=$P($G(^ABMDREC(ABMP("INS"),0)),U,2)           ; Dent remap
 .S:ABMDENP="" ABMDENP=$P($G(^ABMDPARM(ABMP("LDFN"),1,3)),U,11)
 .S:ABMDENP="" ABMDENP=$P($G(^ABMDPARM(DUZ(2),1,3)),U,11)
 .S:ABMDENP]"" $P(ABMF(ABM("F")),U,6)=ABMDENP_$P(ABMF(ABM("F")),U,6)
 .;
 .S ABM("CHRG")=+$P(ABM(0),U,8)
 .S $P(ABMF(ABM("F")),U,10)=$S(+$G(ABMP("FLAT")):"",1:ABM("CHRG"))*($S($P(ABM(0),U,9):$P(ABM(0),U,9),1:1))  ;Proc fee (31)
 .S ABM("TCHRG")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),2)),U)  ; Total fee (33)
 .;
 .S ABM("I")=ABM("I")+1         ; Increment line counter
 .I ABM("I")=10 D
 ..Q:'$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),33,ABM))
 ..S ABM("MORE")=1
 ..D ^ABMDF34X                 ; Print form
 ..S ABM("I")=0
 ;
OTHER ;
 ; Other charges on page 3?
 I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),U,21)'="" D
 .S $P(ABMF(36),U,2)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9)),U,21)  ;Other charges (32)
 .S ABM("TCHRG")=ABM("TCHRG")+$P(ABMF(36),U,2)  ;add to total charges (33)
 ;
 ;Put misc services on dental form
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
 ....S $P(ABMF(ABM("F")),U)=ABMMSDT
 ...S $P(ABMF(ABM("F")),U,6)=ABMED
 ...S $P(ABMF(ABM("F")),U,8)=ABMMSQTY
 ...S $P(ABMF(ABM("F")),U,9)=ABMMS
 ...S $P(ABMF(ABM("F")),U,10)=ABMMSCHG
 ...S ABM("I")=ABM("I")+1
 ...I ABM("I")=10 D
 ....Q:($O(ABMRV(ABMRCD,ABMED))=""&($O(ABMRV(ABMRCD))=""))
 ....S ABM("MORE")=1
 ....D ^ABMDF34X
 ....S ABM("I")=0
 ;
 ; Put RX data on dental form
RXDATA N ABMRV
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
 ...S $P(ABMF(ABM("F")),U,4)=$E(ABMRX,1,3)
 ...S $P(ABMF(ABM("F")),U,5)=$E(ABMRX,4,8)
 ...S $P(ABMF(ABM("F")),U,7)=$E(ABMRX,9,99)
 ...I ABMRXDT]"" S $P(ABMF(ABM("F")),U)=ABMRXDT
 ...S $P(ABMF(ABM("F")),U,8)=ABMRXCHG
 ...S ABM("TCHRG")=ABM("TCHRG")+ABMRXCHG
 ...S ABM("I")=ABM("I")+1
 ...I ABM("I")=10 D
 ....Q:($O(ABMRV(ABMRCD,ABMED))=""&($O(ABMRV(ABMRCD))=""))
 ....S ABM("MORE")=1
 ....D ^ABMDF34X                         ; Print form
 ....S ABM("I")=0
 ;
 D TAIL:ABM("I")
 Q
 ;
RESET ;
 ; Reset line numbers for BODY
 F ABM("F")=25:1:35 K ABMF(ABM("F"))
 S ABM("F")=25
 Q
 ;
TAIL ;END OF FORM
 I +$G(ABMP("FLAT")) S ABM("TCHRG")=+ABMP("FLAT")
 S $P(ABMF(38),U,3)=ABM("TCHRG")   ; Total fee charged on bill
 S ABM("YTOT")=ABM("TCHRG")
 D YTOT^ABMDFUTL
 S (ABM("I"),ABM("TCHRG"))=0
 D ^ABMDF34X                     ; Print form
 Q
