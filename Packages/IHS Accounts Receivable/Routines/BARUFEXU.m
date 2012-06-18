BARUFEXU ; IHS/SD/TPF - UTILITY EXTRACT RTN FOR UFMS ;03/26/08
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**4**;NOV 19, 2007
 ;  NEW ROUTINE-- IHS/IOT/MRS:BAR*1.8*4 UFMS
 ; This routine checks for certain missing or invalid data in the
 ; A/R BILL IHS file
 ; If an error is found, the routine attempts to correct the problem.
 ; If not it sets the "NOT SENT" flag in the A/R UFMS CASHIER SESSION LOG
 ; file, and sets the REASON NOT SENT field and quits, returning a null value.
 Q
 ;
GETDUZ2(BARBLN,UDUZ,SESSID,TRDATE,ARBILL) ;EP; EXTRINSIC FUNCTION TO FIND TPB DUZ(2)
 ;
 ; This sub-routine returns the Third Party Billing DUZ(2) from the
 ; A/R BILL IHS file **or** if it is missing, searches the 3P BILL file and
 ; checks for errors. The routine loops through the TPB BILL file primary
 ; node (DUZ(2)) and looks for a match with the TPB IEN stored in A/R BILL file
 ;
 ; If there is no match, or the TPB IEN, Patient, or Payer info is
 ; missing, an error is created and the process quits.
 ;
 ; If it finds an entry, the routine checks for further matches.
 ;
 ; If the Bill Number, Patient, or Payer pointers do not match, an
 ; error is created and the process quits.
 ;
 ; If there are no errors, the routine modifies the A/R BILL IHS file
 ; and returns the TPB IEN to the calling routine.
 ;
 ;     ENTERS WITH:  BARBLN = AR BILL IEN
 ;                     UDUZ = AR USER PTR
 ;                   SESSID = SESSION ID
 ;                   TRDATE = TRANSMISSION DATE
 ;                   ARBILL = A/R BILL NUMBER
 ;     RETURNS: THIRD PARTY DUZ(2) or null and ERROR message
 ;
 ;If an error is found, the routine sets the "NOT SENT" flag in the
 ;A/R UFMS CASHIER SESSION LOG file, and sets the REASON NOT SENT field and quits
 ;returning a null value.
 ;
 S TPBDUZ2=$P($G(^BARBL(DUZ(2),BARBLN,0)),U,22)   ;A/R BILL, 3P DUZ(2)
 I TPBDUZ2]"" Q TPBDUZ2                           ;Has value
 ;
 N BARPAT,BARPAY,MSG
 S IENS=TRDATE_","
 S MSG=""
 S BARPAT=$P($G(^BARBL(DUZ(2),BARBLN,1)),U)
ERR10 I BARPAT="" D ERR(10) Q ""                       ;No patient
 S BARBACC=$$GETBACC(BARBLN)
 I 'BARBACC Q ""                           ;A/R BILL, A/R ACCOUNT PTR
 S BARPAY=+$$IEN^BARVPM                    ;INSURER PTR
ERR11 I 'BARPAY D ERR(11) Q ""                  ;No insurer
 S ABMIEN=$$GETTPB(BARBLN)                 ;A/R BILL, 3P IEN (DA)
 I ABMIEN="" Q ""                          ;ERROR AND QUIT
 ;
 N ABMDUZ,ABMTMP
 S ABMDUZ=0
 F  S ABMDUZ=$O(^ABMDBILL(ABMDUZ)) Q:'ABMDUZ  D  Q:TPBDUZ2]""
 .Q:'$D(^ABMDBILL(ABMDUZ,ABMIEN))            ;NOT IN THIS DUZ(2)
 .S ABMTMP=$G(^ABMDBILL(ABMDUZ,ABMIEN,0))
ERR13 .I $G(ABMTMP)="" D ERR(13) Q           ;TPB missing
 .S ABMBIL=$P(ABMTMP,U)                 ;TPB BILL NUMBER
 .S ABMPAT=$P(ABMTMP,U,5)               ;TPB PATIEN IEN
 .S ABMPAY=$P(ABMTMP,U,8)               ;TPB INSURER IEN
ERR14 .I ABMBIL'=$P(ARBILL,"-",1) D ERR(14) Q  ;Bill numbers don't match
ERR15 .I ABMPAT'=BARPAT D ERR(15) Q          ;Patient pointers don't match
ERR16 .I ABMPAY'=BARPAY D ERR(16) Q          ;Insurers don't match
 .;HAVE A MATCH -- NOW STUFF DUZ(2) INTO AR BILL FILE
 .K DR
 .S DIE="^BARBL(DUZ(2),"
 .S DA=BARBLN
 .S DR="22////"_ABMDUZ                   ;SET TPB DUZ(2)
 .D ^DIE
 .S TPBDUZ2=ABMDUZ
ERR17 I 'TPBDUZ2 D ERR(17)                    ;Can't find TPB DUZ(2)
 Q TPBDUZ2
 ;
GETBACC(BARBLN) ;EP;
 ;     ENTERS WITH:  BARBLN = AR BILL IEN
 ;
 ;     RETURNS: A/R ACCOUNT or null and ERROR message
 ;
 S D0=$P($G(^BARBL(DUZ(2),BARBLN,0)),U,3)     ;A/R BILL, A/R ACCOUNT PTR
ERR12 I 'D0 D ERR(12) Q ""                         ;Pointer is missing
 Q D0
 ;
GETPLOC(BARBLN) ;EP;Check Parent Location
 ;     ENTERS WITH:  BARBLN = AR BILL IEN
 ;
 ;     RETURNS: PARENT LOCATION or null and ERROR message
 ;
 N BARPLOC,BARVLOC
 S BARPLOC=$P($G(^BARBL(DUZ(2),BARBLN,0)),U,8)  ;A/R BILL, PARENT LOCATION
 I BARPLOC Q BARPLOC
 I 'BARPLOC D                                   ;Not found/or bad location
 .S BARVLOC=$P($G(^BARBL(DUZ(2),BARBLN,1)),U,8) ;A/R BILL, VISIT LOCATION
 .S BARPLOC=$$PARENT                                ;A/R PARENT/SATELITE
ERR18 I 'BARPLOC D ERR(18) Q ""                      ;Can't find parent
 ;Have a match -- now stuff DUZ(2) into AR BILL/IHS file
 ;  also updates the ASUFAC-IEN and A/R BILLING SITE/ASUFAC fields 
 K DR
 S DIE="^BARBL(DUZ(2),"
 S DA=BARBLN
 S DR="8////"_BARPLOC                               ;Set Parent Location
 D ^DIE
 Q BARPLOC
 ;
GETASUFA(BARBLN) ;EP;Check ASUFAC; if not in document, find and populate or error
 ;
 ;     ENTERS WITH:  BARBLN = AR BILL IEN
 ;
 ;     RETURNS: ASUFAC or null and ERROR message
 ;
 N BARASUF
 S BARASUF=$P($P($G(^BARBL(DUZ(2),BARBLN,0)),U,9),"-")
 I 'BARASUF D
 .S BARASUF=$$GETSUFAC^BARUFUT1
 .I BARASUF D
 ..K DR
 ..S DIE="^BARBL(DUZ(2),"
 ..S DA=BARBLN
 ..S DR=".02////"_BARASUF_"-"_BARBLN          ;Set ASUFAC - IEN
 ..D ^DIE
ERR19 I 'BARASUF D ERR(19)                         ;Can't build asufac
 Q BARASUF
 ;
ERR(BARREAS) ;EP; Message Center and Error Processor
 ;ALWAYS WRITE MESSAGE
 W !!,"TRANSACTION "_TRDATE_" HAS NOT BEEN SENT BECAUSE"
 I BARREAS="I" D  Q
 .W !,"IS ONE OF A PAIR OF IGNORED TRANSACTIONS IN "_ARBILL
 W !,$P($G(^BARUFERR(BARREAS,0)),U,5)
 W !," FOR A/R BILL "_ARBILL
 N DIR,DIE,DIC,DA,DR
 S DA(2)=UDUZ
 S DA(1)=SESSID
 S DA=TRDATE
 S DIE="^BARSESS(DUZ(2),"_UDUZ_",11,"_SESSID_",2,"
 S DR=".06////^S X=1;.09///"_$G(BARREAS)
 D ^DIE
 Q
 ;
PARENT() ;EP:   get parent from parent/satellite file
 ;
 N BARSAT,BARPAR,DA,ASUFAC
 S BARSAT=DUZ(2)
 S BARPAR=0                               ; Parent
 ; check site active at DOS to ensure bill added to correct site
 S DA=0
 F  S DA=$O(^BAR(90052.06,DA)) Q:DA'>0  D  Q:BARPAR
 . Q:'$D(^BAR(90052.06,DA,DA))      ; Pos Parent UNDEF Site Parameter
 . Q:'$D(^BAR(90052.05,DA,BARSAT))  ; Satellite UNDEF Parent/Satellit
 . Q:+$P($G(^BAR(90052.05,DA,BARSAT,0)),U,5)  ; Par/Sat not usable
 . ; Q if sat NOT active at DT
 . I DT<$P($G(^BAR(90052.05,DA,BARSAT,0)),U,6) Q
 . ; Q if sat became NOT active before DT
 . I $P($G(^BAR(90052.05,DA,BARSAT,0)),U,7),(DT>$P($G(^BAR(90052.05,DA,BARSAT,0)),U,7)) Q
 . S BARPAR=$S(BARSAT:$P($G(^BAR(90052.05,DA,BARSAT,0)),U,3),1:"")
 Q BARPAR
 ;
GETTPB(BARBLN) ;EP;
 ;
 ;     ENTERS WITH:  BARBLN = AR BILL IEN
 ;
 ;     RETURNS: THIRD PARTY IEN or null and ERROR message
 ;
 N ABMIEN
 S ABMIEN=$P($G(^BARBL(DUZ(2),BARBLN,0)),U,17)  ;A/R BILL, 3P IEN (DA)
ERR20 I ABMIEN="" D ERR(20) Q ""      ;No pointer, create error and quit
 Q ABMIEN
 ;
GETTRDT(TPBDUZ2,TPBIEN) ;EP; GET 3P TRANSMISSION DATE
 ;
 ;Check if the 3P Bill (Invoice) has been sent to A/R from 3P
 ;If so, the Invoice # will be returned as ASUFACASUFACIEN
 ;
 N TPBAPDT,TPBEXDT
 S UFMSSUFC=""
 S TPBAPDT=$$APPRDTTM^ABMUEAPI(TPBDUZ2,TPBIEN)  ;API 3P APPROVAL DATE
 I TPBAPDT="" D  Q UFMSSUFC
ERR21 .D ERR(21)                                     ;3PB not approved
 ;
 ;Prelive logic for 'APPLY TO' or ASUFACASUFAC3PIEN string
 ;If Date/Time Approved < 10/1/2007 then UFMSSUFC=$$PRELIVE instead
 ;
 ;If this is true there will be no delay send at all
 ;
 S BAR08DT=$P($G(^BAR(90052.06,DUZ(2),DUZ(2),15)),U,5)  ;IHS/SD/SDR bar*1.8*4 SCR100
 I TPBAPDT<PRELIVLM!(TPBAPDT<BAR08DT) D  Q UFMSSUFC  ;IHS/SD/SDR bar*1.8*4 SCR100
 .S PRELIV=$$PRELIVE^BARUFUT1(BARAREA,BARITYP)
 .S UFMSSUFC=PRELIV
 ;
 I $L($T(TRANSMIT^ABMUEAPI)) D
 .S UFMSSUFC=$$TRANSMIT^ABMUEAPI(TPBDUZ2,TPBIEN)
 I 'UFMSSUFC D  Q UFMSSUFC
ERR22 .D ERR(22)                                  ;3PB bill not sent to UFMS
 .S UFMSSUFC=""          ;Sometimes UFMSSUFC can be -1
 Q UFMSSUFC
