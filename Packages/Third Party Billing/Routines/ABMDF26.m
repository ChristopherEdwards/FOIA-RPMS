ABMDF26 ; IHS/ASDST/DMJ - ADA-99 Dental Export Routine V2000 ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;09/12/95 8:48 AM
 ;
 ; IHS/SD/SDR - v2.5 p8 - IM12857/IM13525
 ;    Created new export mode for ADA-99 v2000 format
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20395
 ;   Split out lines bundled by rev code
 ;    
 K ABM
 S U="^"
 S ABMP("EXP")=26                ; Export mode
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
 Q:'$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),33,0))  ; Quit if no dental data
 D ENT^ABMDF26A,BODY
 Q
 ;
BODY ;
 ; For each dental entry in the bill file, find and print data.
 S ABMX("INS")=ABMP("INS")       ; IEN to INSURER
 K ABMP("FLAT")
 D FRATE^ABMDE2X1                ; find Flat Rate
 S (ABM("C"),ABM,ABM("TCHRG"),ABM("I"),ABM("YTOT"))=0
 F  S ABM=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),33,ABM)) Q:'ABM  D  Q:$D(DUOUT)
 .S ABM(0)=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),33,ABM,0))
 .D RESET:ABM("I")=0
 .S ABM("F")=ABM("F")+1         ; Increment line counter
 .I $P(ABM(0),U,5) D
 ..S ABMOPS=$P(ABM(0),U,5)     ; IEN to DENTAL OPERATIVE SITE
 ..S $P(ABMF(ABM("F")),U,4)=$P($G(^ADEOPS(ABMOPS,88)),U)    ; Tooth mnemonic (d)
 ..S:ABMF(ABM("F"))["D" $P(ABMF(ABM("F")),U,4)=$P($G(^ADEOPS(ABMOPS,0)),U,4) ; Tooth synonym
 .S $P(ABMF(ABM("F")),U,5)=$P(ABM(0),U,6)                 ; Tooth surf
 .S $P(ABMF(ABM("F")),U,9)=$P(^AUTTADA(+ABM(0),0),U,2)    ; Svc desc
 .S $P(ABMF(ABM("F")),U)=$E($P(ABM(0),U,7),4,5)           ; DOS MM
 .S $P(ABMF(ABM("F")),U,2)=$E($P(ABM(0),U,7),6,7)         ; DOS DD
 .S $P(ABMF(ABM("F")),U,3)=($E($P(ABM(0),U,7),1,3)+1700)  ; DOS YYYY
 .S $P(ABMF(ABM("F")),U,7)=$P(^AUTTADA(+ABM(0),0),U)      ; Procedure #
 .S ABMDENP=$P($G(^ABMDREC(ABMP("INS"),0)),U,2)           ; Dent remap
 .S:ABMDENP="" ABMDENP=$P($G(^ABMDPARM(ABMP("LDFN"),1,3)),U,11)
 .S:ABMDENP="" ABMDENP=$P($G(^ABMDPARM(DUZ(2),1,3)),U,11)
 .S:ABMDENP]"" $P(ABMF(ABM("F")),U,7)=ABMDENP_$P(ABMF(ABM("F")),U,7)
 .S ABM("CHRG")=+$P(ABM(0),U,8)
 .S $P(ABMF(ABM("F")),U,10)=$S(+$G(ABMP("FLAT")):"",1:ABM("CHRG"))
 .S ABM("TCHRG")=ABM("TCHRG")+ABM("CHRG")                 ; Proc fee
 .;
 .S ABM("I")=ABM("I")+1         ; Increment line counter
 .I ABM("I")=10 D
 ..Q:'$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),33,ABM))
 ..S ABM("MORE")=1
 ..D ^ABMDF26X                 ; Print form
 ..S ABM("I")=0
 ;
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
 ...S $P(ABMF(ABM("F")),U,4)=$E(ABMRX,1,3)
 ...S $P(ABMF(ABM("F")),U,5)=$E(ABMRX,4,8)
 ...S $P(ABMF(ABM("F")),U,9)=$E(ABMRX,9,99)
 ...I ABMRXDT]"" D
 ....S $P(ABMF(ABM("F")),U)=$E(ABMRXDT,4,5)
 ....S $P(ABMF(ABM("F")),U,2)=$E(ABMRXDT,6,7)
 ....S $P(ABMF(ABM("F")),U,3)=$E(ABMRXDT,1,3)+1700
 ...S $P(ABMF(ABM("F")),U,8)=ABMRXQTY
 ...S $P(ABMF(ABM("F")),U,10)=ABMRXCHG
 ...S ABM("TCHRG")=ABM("TCHRG")+ABMRXCHG
 ...S ABM("I")=ABM("I")+1
 ...I ABM("I")=10 D
 ....Q:($O(ABMRV(ABMRCD,ABMED))=""&($O(ABMRV(ABMRCD))=""))
 ....S ABM("MORE")=1
 ....D ^ABMDF26X                         ; Print form
 ....S ABM("I")=0
 ;
 D TAIL:ABM("I")
 Q
 ;
RESET ;
 ; Reset line numbers for BODY
 F ABM("F")=41:1:48 K ABMF(ABM("F"))
 S ABM("F")=40
 Q
 ;
TAIL ;END OF FORM
 I +$G(ABMP("FLAT")) S ABM("TCHRG")=+ABMP("FLAT")
 S $P(ABMF(50),U)=ABM("TCHRG")   ; Total fee charged on bill
 S ABM("YTOT")=ABM("TCHRG")
 D YTOT^ABMDFUTL
 S (ABM("I"),ABM("TCHRG"))=0
 D ^ABMDF26X                     ; Print form
 Q
