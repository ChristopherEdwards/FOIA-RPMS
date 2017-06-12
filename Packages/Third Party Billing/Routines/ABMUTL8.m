ABMUTL8 ; IHS/ASDST/DMJ - 837 UTILITIES ;      
 ;;2.6;IHS Third Party Billing;**1,4,6,8,9,10,11,13,14,16,18**;NOV 12, 2009;Build 289
 ;Original;DMJ;09/21/95 12:47 PM
 ;V2.5 P5-837 mod. Use HRN in following priority order-visit loc/parent/loop satellites
 ;v2.5 p5-put POS, TOS by line item
 ;v2.5 p6-Make OVER works correctly
 ;v2.5 p8-IM13324/IM15558-Format 0 to 0.00
 ;v2.5 p8-IM12628-Remove special delimiter for CA
 ;v2.5 p8-task 6-Check value cd before formatting; can be dollar amt or zip
 ;v2.5 p9-IM14702/IM17968-Correct HRN lookup for satellites
 ;v2.5 p9-IM17270-Changed "~" to "-" to avoid delimiter issues
 ;v2.5 p9-IM16962-If BCBS/OK add CR/LF to delimiter; they can't do streamed data
 ;
 ;IHS/SD/SDR-v2.6 CSV
 ;IHS/SD/SDR-2.6*1 -HEAT2836 -Remove Dxs when inpt Medicare/RR
 ;IHS/SD/SDR-2.6*6 -5010 -added code to pull anesthesia charges
 ;IHS/SD/SDR-2.6*13 -Added check for new export mode 35
 ;IHS/SD/SDR-2.6*14 -ICD10 002F Changes for 837 qualifier ICD9 vs ICD10
 ;IHS/SD/SDR-2.6*14 -Updated DX^ABMCVAPI calls to be numeric
 ;IHS/SD/SDR-2.6*14 -split routine to ABMUTL8A due to size
 ;IHS/SD/SDR-2.6*14 -CR4072 -made correction to ICD10 check to be '=30 instead of =1
 ;IHS/SD/SDR-2.6*16 -HEAT217211 -Made change so it won't do the E-code change in DXSET2 if ICD code is an ICD-10 code.
 ;IHS/SD/SDR-2.6*16 -HEAT231506 -Updated so 837D will print DX codes.
 ;IHS/SD/SDR-2.6*18 -HEAT239392 -Made changes so E-code will be included appropriately. Was being dropped from file.
 ;
HRN(X) ;PEP - HRN
 ; First look at Visit Loc for HRN
 ; If not then look at Parent Loc for HRN
 ; If not, loop Satellite Locs for said parent until one is found.
 I $G(ABMP("LDFN")) S HRN=$P($G(^AUPNPAT(+X,41,ABMP("LDFN"),0)),"^",2)
 ;Q:HRN HRN  ;abm*2.6*10 HEAT61426
 Q:($G(HRN)'="") HRN  ;abm*2.6*10 HEAT61426
 S ABMPAR=""
 F  S ABMPAR=$O(^BAR(90052.05,ABMPAR)) Q:ABMPAR=""!$D(^BAR(90052.05,ABMPAR,ABMP("LDFN")))
 S ABMPAR=$P($G(^BAR(90052.05,ABMPAR,ABMP("LDFN"),0)),"^",3)
 I $G(ABMPAR)'="" S HRN=$P($G(^AUPNPAT(X,41,ABMPAR,0)),"^",2)
 Q:HRN HRN
 I $G(ABMPAR)'="" D
 .S ABMSAT=0
 .F  S ABMSAT=$O(^BAR(90052.05,ABMPAR,ABMSAT)) Q:ABMSAT=""  D  Q:HRN
 ..S HRN=$P($G(^AUPNPAT(X,41,ABMSAT,0)),"^",2)
 Q HRN
DXP(X) ;EP - Primary DX
 ;x=bill ien
 D DXSET(X)
 S ABMDXP=$G(ABMDX(1))
 Q ABMDXP
DXA(X) ;EP - Admitting DX
 ;x=bill ien
 N ABMBTYP S ABMBTYP=$P(^ABMDBILL(DUZ(2),X,0),U,2)
 S ABMDXA=$P($G(^ABMDBILL(DUZ(2),X,5)),U,9)
 I ABMDXA="" Q ABMDXA  ;abm*2.6*4 HEAT19688
 S ABMDXA=$P($$DX^ABMCVAPI(+ABMDXA,ABMP("VDT")),U,2)  ;CSV-c
 I ABMDXA="" Q ABMDXA
 S ABMDXA=$TR(ABMDXA,".")
 ;S:$E(ABMBTYP,2)<3 ABMDXA="BJ:"_ABMDXA  ;abm*2.6*14 ICD10 002F
 S:$E(ABMBTYP,2)<3 ABMDXA=$S(+$P($G(^ABMDBILL(DUZ(2),X,17,J,0)),U,6)=1:"ABJ",1:"BJ")_":"_ABMDXA  ;abm*2.6*14 ICD10 002F
 S:$E(ABMBTYP,2)>2 ABMDXA="ZZ:"_ABMDXA
 Q ABMDXA
DXE(X) ;EP - E-Code
 ;x=bill ien
 S ABMDXE=$P($G(^ABMDBILL(DUZ(2),X,8)),U,12)
 I ABMDXE="" Q ABMDXE
 ;S ABMDXE="BN:"_$TR($P($$DX^ABMCVAPI(ABMDXE,ABMP("VDT")),U,2),".")  ;CSV-c  ;abm*2.6*14 update API call
 S ABMDXE="BN:"_$TR($P($$DX^ABMCVAPI(+ABMDXE,ABMP("VDT")),U,2),".")  ;CSV-c  ;abm*2.6*14 update API call
 Q ABMDXE
DXSET(X) ;EP - set dx array
 ;x=bill ien
 ;I +$G(ABMP("EXP"))=31!(+$G(ABMP("EXP"))=32) D DXSET2(X) Q  ;abm*2.6*8 5010  ;abm*2.6*16 HEAT231506
 I +$G(ABMP("EXP"))=31!(+$G(ABMP("EXP"))=32)!(+$G(ABMP("EXP"))=33) D DXSET2(X) Q  ;abm*2.6*8 5010  ;abm*2.6*16 HEAT231506
 K ABMDX
 N I,J
 S ABMCNT=0
 S I=0
 F  S I=$O(^ABMDBILL(DUZ(2),X,17,"C",I)) Q:'I  D
 .S J=0
 .F  S J=$O(^ABMDBILL(DUZ(2),X,17,"C",I,J)) Q:'J  D
 ..S ABMCNT=ABMCNT+1
 ..S:ABMCNT=1 ABMDX(ABMCNT)="BK"
 ..S:ABMCNT'=1 ABMDX(ABMCNT)="BF"
 ..;S $P(ABMDX(ABMCNT),":",2)=$TR($P($$DX^ABMCVAPI(J,ABMP("VDT")),U,2),".")  ;CSV-c  ;abm*2.6*14 update API
 ..S $P(ABMDX(ABMCNT),":",2)=$TR($P($$DX^ABMCVAPI(+J,ABMP("VDT")),U,2),".")  ;CSV-c  ;abm*2.6*14 update API
 ;I $P($G(^ABMDBILL(DUZ(2),X,5)),U,9)'="" S ABMDX("ADM")=$TR($P($$DX^ABMCVAPI($P($G(^ABMDBILL(DUZ(2),X,5)),U,9),ABMP("VDT")),U,2),".")   ;abm*2.6*8 5010  ;abm*2.6*14 update API
 I +$P($G(^ABMDBILL(DUZ(2),X,5)),U,9)'=0 S ABMDX("ADM")=$TR($P($$DX^ABMCVAPI(+$P($G(^ABMDBILL(DUZ(2),X,5)),U,9),ABMP("VDT")),U,2),".")   ;abm*2.6*14 update API
 Q
 ;start new abm*2.6*8 5010
DXSET2(X) ;EP - set dx array
 ;x=bill ien
 K ABMDX
 K ABMDXE  ;abm*2.6*10 HEAT67774
 N I,J
 S ABMCNT=0
 S I=0
 F  S I=$O(^ABMDBILL(DUZ(2),X,17,"C",I)) Q:'I  D
 .S J=0
 .F  S J=$O(^ABMDBILL(DUZ(2),X,17,"C",I,J)) Q:'J  D
 ..;Q:$E($P($$DX^ABMCVAPI($P($G(^ABMDBILL(DUZ(2),X,5)),U,9),ABMP("VDT")),U,2),1)="E"  ;skip E-codes  ;abm*2.6*14 ICD10 002F
 ..;I $E($P($$DX^ABMCVAPI(J,ABMP("VDT")),U,2),1)="E"&($P($$DX^ABMCVAPI(+J,ABMP("VDT")),U,20)'=30) Q  ;skip E-codes  ;abm*2.6*14 ICD10 002F and update API; CR4072  ;abm*2.6*18 HEAT239392
 ..;for next line skip E-codes ;abm*2.6*14 ICD10 002F; Update API; CR4072 ;abm*2.6*18 HEAT239392
 ..;I (+$P($G(^ABMDBILL(DUZ(2),X,5)),U,9)'=0)&(+$P($$DX^ABMCVAPI($P($G(^ABMDBILL(DUZ(2),X,5)),U,9),ABMP("VDT")),U,20)<30) Q  ;skip admit DX if ICD9 Ecode  ;removed line abm*2.6*18 HEAT239392
 ..;I ($E($P($$DX^ABMCVAPI(J,ABMP("VDT")),U,2),1)="E")&($P($$DX^ABMCVAPI(J,ABMP("VDT")),U,20)<30) Q  ;skip DX if ICD9 Ecode  ;removed abm*2.6*18 HEAT239392
 ..;skip admit DX if ICD10 accident cd
 ..;abm*2.6*18 HEAT239392 removed next 2 lines in a2.  ICD shouldn't be skipped here.
 ..;I (+$P($$DX^ABMCVAPI($P($G(^ABMDBILL(DUZ(2),X,5)),U,9),ABMP("VDT")),U,20)=30)&("^V^W^X^Y^"[("^"_$E($P($$DX^ABMCVAPI($P($G(^ABMDBILL(DUZ(2),X,5)),U,9),ABMP("VDT")),U,2),1)_"^")) Q  ;abm*2.6*18 HEAT239392
 ..;I (+$P($$DX^ABMCVAPI(J,ABMP("VDT")),U,20)=30)&("^V^W^X^Y^"[("^"_$E($P($$DX^ABMCVAPI(J,ABMP("VDT")),U,2),1)_"^")) Q  ;skip DX if ICD10 accident code  ;abm*2.6*18 HEAT239392
 ..S ABMCNT=ABMCNT+1
 ..;S:ABMCNT=1 ABMDX(ABMCNT)="BK"  ;abm*2.6*14 ICD10 002F
 ..S:ABMCNT=1 ABMDX(ABMCNT)=$S(+$P($G(^ABMDBILL(DUZ(2),X,17,J,0)),U,6)=1:"ABK",1:"BK")  ;abm*2.6*14 ICD10 002F
 ..;S:ABMCNT'=1 ABMDX(ABMCNT)="BF"  ;abm*2.6*14 ICD10 OO2F
 ..S:ABMCNT'=1 ABMDX(ABMCNT)=$S(+$P($G(^ABMDBILL(DUZ(2),X,17,J,0)),U,6)=1:"ABF",1:"BF")  ;abm*2.6*14 ICD10 002F
 ..;S $P(ABMDX(ABMCNT),":",2)=$TR($P($$DX^ABMCVAPI(J,ABMP("VDT")),U,2),".")  ;CSV-c   ;abm*2.6*14 update API
 ..S $P(ABMDX(ABMCNT),":",2)=$TR($P($$DX^ABMCVAPI(+J,ABMP("VDT")),U,2),".")  ;CSV-c   ;abm*2.6*14 update API
 ..I ABMP("EXP")=31,($P($G(^ABMDBILL(DUZ(2),X,17,J,0)),U,5)'="") S $P(ABMDX(ABMCNT),":",9)=$P($G(^ABMDBILL(DUZ(2),X,17,J,0)),U,5)  ;abm*2.6*9 HEAT57041
 ;
 S ABMCNT=0
 S I=0
 F  S I=$O(^ABMDBILL(DUZ(2),X,17,"C",I)) Q:'I  D
 .S J=0
 .F  S J=$O(^ABMDBILL(DUZ(2),X,17,"C",I,J)) Q:'J  D
 ..;Q:$E($P($$DX^ABMCVAPI(J,ABMP("VDT")),U,2),1)'="E"  ;skip E-codes  ;abm*2.6*14 ICD10 002F
 ..;I $E($P($$DX^ABMCVAPI(J,ABMP("VDT")),U,2),1)'="E"&($P($$DX^ABMCVAPI(+J,ABMP("VDT")),U,20)'=30) Q  ;skip E-codes  ;abm*2.6*14 ICD10 002F, update API; CR4072
 ..;I ($P($$DX^ABMCVAPI(+J,ABMP("VDT")),U,20)=30) Q  ;abm*2.6*16 HEAT217211  ;abm*2.6*18 HEAT239392
 ..;I $E($P($$DX^ABMCVAPI(J,ABMP("VDT")),U,2),1)'="E" Q  ;abm*2.6*16 HEAT217211  ;abm*2.6*18 HEAT239392
 ..I ($E($P($$DX^ABMCVAPI(J,ABMP("VDT")),U,2),1)'="E")&(+$P($$DX^ABMCVAPI(J,ABMP("VDT")),U,20)<30) Q  ;skip E-codes  ;abm*2.6*18 HEAT239392
 ..I (+$P($$DX^ABMCVAPI(J,ABMP("VDT")),U,20)=30)&("^V^W^X^Y^"'[("^"_$E($P($$DX^ABMCVAPI(J,ABMP("VDT")),U,2),1)_"^")) Q  ;abm*2.6*18 HEAT239392
 ..S ABMCNT=ABMCNT+1
 ..;S ABMDXE(ABMCNT)="BN:"_$TR($P($$DX^ABMCVAPI(J,ABMP("VDT")),U,2),".")  ;CSV-c  ;abm*2.6*14 ICD10 002F
 ..S ABMDXE(ABMCNT)=$S((+$P($G(^ABMDBILL(DUZ(2),X,17,J,0)),U,6)=1):"ABN:",1:"BN:")_$TR($P($$DX^ABMCVAPI(+J,ABMP("VDT")),U,2),".")  ;CSV-c  ;abm*2.6*14 ICD10 002F, updated API
 ..I $P($G(^ABMDBILL(DUZ(2),X,17,J,0)),U,5)'="" S $P(ABMDXE(ABMCNT),":",9)=$P($G(^ABMDBILL(DUZ(2),X,17,J,0)),U,5)
 ..I ABMP("EXP")=31,($P($G(^ABMDBILL(DUZ(2),X,17,J,0)),U,5)'="") S $P(ABMDX(ABMCNT),":",9)=$P($G(^ABMDBILL(DUZ(2),X,17,J,0)),U,5)  ;abm*2.6*9 HEAT57041
 ;I $P($G(^ABMDBILL(DUZ(2),X,5)),U,9)'="" S ABMDX("ADM")=$TR($P($$DX^ABMCVAPI($P($G(^ABMDBILL(DUZ(2),X,5)),U,9),ABMP("VDT")),U,2),".")   ;abm*2.6*8 5010  ;abm*2.6*14 ICD10 002F
 ;start new abm*2.6*14 ICD10 002F, update APIs
 I $P($G(^ABMDBILL(DUZ(2),X,5)),U,9)'="" D
 .S ABMDX("ADM")=$TR($P($$DX^ABMCVAPI(+$P($G(^ABMDBILL(DUZ(2),X,5)),U,9),ABMP("VDT")),U,2),".")
 .S ABMDX("ADMTYP")=$P($$DX^ABMCVAPI(+$P($G(^ABMDBILL(DUZ(2),X,5)),U,9),ABMP("VDT")),U,20)
 ;end new ICD10 002F
 Q
 ;end new abm*2.6*8
PXSET(X) ;EP -set px array
 ;x=bill ien
 D PXSET^ABMUTL8A(X)
 Q
OSSET(X) ;EP -occurrence span set
 ;x=bill ien
 D OSSET^ABMUTL8A(X)
 Q
OCSET(X) ;EP -occurrence set
 ;x=bill ien
 D OCSET^ABMUTL8A(X)
 Q
VASET(X) ;EP -value code set
 ;x=bill ien
 K ABMVA
 S ABMCNT=0
 N I
 S I=0
 F  S I=$O(^ABMDBILL(DUZ(2),X,55,I)) Q:'I  D
 .S ABMLINE=^ABMDBILL(DUZ(2),X,55,I,0)
 .S ABMCNT=ABMCNT+1
 .S ABMVA(ABMCNT)="BE"
 .S $P(ABMVA(ABMCNT),":",2)=$P($G(^ABMDCODE(+$P(ABMLINE,U),0)),U)
 .;start old abm*2.6*11 IHS/SD/AML HEAT89676
 .;I $P(ABMVA(ABMCNT),":",2)'="A0" S $P(ABMVA(ABMCNT),":",5)=$FN($P(ABMLINE,U,2),"",2)
 .;E  S $P(ABMVA(ABMCNT),":",5)=$P(ABMLINE,U,2)
 .;end old heat89676
 .S $P(ABMVA(ABMCNT),":",5)=$P(ABMLINE,U,2)  ;abm*2.6*11 IHS/SD/AML HEAT89676
 Q
CDSET(X) ;EP - condition code set
 ;x=bill ien
 D CDSET^ABMUTL8A(X)
 Q
 ;start new abm*2.6*6 5010
ANES(X) ;EP - anesthesia charges set
 D ANES^ABMUTL8A(X)
 Q
 ;end new 5010
WR(X) ;EP - write to file
 S ABMDELI="~"
 S:$$RCID^ABMUTLP(ABMP("INS"))=730266607 ABMDELI="~"_$C(13)_$C(10)
 S ABMSTRNG=$$STRIP(ABMREC(X))
 Q:$L(ABMSTRNG,"*")<2
 U IO
 U:$G(ABMDEBUG) IO(0)
 S ABMSTRNG=$TR(ABMSTRNG,"~","-")
 W ABMSTRNG
 W ABMDELI
 W:$G(ABMDEBUG) !
 S ABMSTOT=ABMSTOT+1
 U IO(0)
 K ABMR,ABMREC
 Q
STRIP(X) ;EP - strip trailing null data elements
 I $E(X,1,3)="ISA" Q X
 N I
 F I=$L(X,"*"):-1:1 Q:$P(X,"*",I)'=""
 S Y=$P(X,"*",1,I)
 Q Y
AN(X) ;EP - alpha numeric only
 N I
 F I=1:1:$L(X) D
 .S ABMCHAR=$E(X,I)
 .S ABMCHAR($A(ABMCHAR))=""
 S I=0
 F  S I=$O(ABMCHAR(I)) Q:'I  D
 .I I>31&(I<34) Q
 .I I>37&(I<59) Q
 .I I=61!(I=63) Q
 .I I>64&(I<91) Q
 .I I>96&(I<123) Q
 .S X=$TR(X,$C(I))
 K ABMCHAR
 Q X
PTAX(X) ;EP - provider taxonomy
 ;x=location ien
 S X="261QP0904X"
 Q X
OVER(ABMLN,ABMPCE) ;EP - get override values from 3P Insurer file
 S ABMVALUE=""
 N ABMOVTYP
 ;start old abm*2.6*10 HEAT53137
 ;I $D(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",14,ABMLN,ABMPCE,0)) S ABMOVTYP=0
 ;I $D(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",14,ABMLN,ABMPCE,ABMP("VTYP"))) S ABMOVTYP=ABMP("VTYP")
 ;end old start new HEAT53137,HEAT67605
 ;S ABMT("EXP")=$S(ABMP("EXP")=32:27,1:14)  ;abm*2.6*13 export mode 35
 S ABMT("EXP")=$S(ABMP("EXP")=32:35,1:14)  ;abm*2.6*13 export mode 35
 I $D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2,"AOVR",ABMT("EXP"),ABMLN,ABMPCE,0)) S ABMOVTYP=0
 I $D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2,"AOVR",ABMT("EXP"),ABMLN,ABMPCE,ABMP("VTYP"))) S ABMOVTYP=ABMP("VTYP")
 ;end new HEAT53137
 I $G(ABMOVTYP)="" Q ABMVALUE
 ;S ABMVALUE=^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",14,ABMLN,ABMPCE,ABMOVTYP)  ;abm*2.6*10 HEAT53137
 S ABMVALUE=^ABMNINS(ABMP("LDFN"),ABMP("INS"),2,"AOVR",ABMT("EXP"),ABMLN,ABMPCE,ABMOVTYP)  ;abm*2.6*10 HEAT53137, HEAT67605
 Q ABMVALUE
 ;start new abm*2.6*6 5010
837 ;EP - override for 837 5010 formats
 K ABME("VTYP")
 ;I $D(^ABMNINS(DUZ(2),ABMP("INS"),2.5,"ASEND",+ABMP("EXP"),ABMLOOP,ABME("RTYPE"),"N")) D  ;do not send seg  ;abm*2.6*10 HEAT53137
 I $D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2.5,"ASEND",+ABMP("EXP"),ABMLOOP,ABME("RTYPE"),"N")) D  ;do not send seg  ;abm*2.6*10 HEAT53137
 .S ABMREC(ABME("RTYPE"))=ABME("RTYPE")
 .K ABMR(ABME("RTYPE"))
 .S ABMR(ABME("RTYPE"),10)=ABME("RTYPE")
 S ABMELE=""
 ;F  S ABMELE=$O(^ABMNINS(DUZ(2),ABMP("INS"),2.5,"ASEND",+ABMP("EXP"),ABMLOOP,ABME("RTYPE"),ABMELE)) Q:($G(ABMELE)="")  D  ;abm*2.6*10 HEAT53137
 F  S ABMELE=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2.5,"ASEND",+ABMP("EXP"),ABMLOOP,ABME("RTYPE"),ABMELE)) Q:($G(ABMELE)="")  D  ;abm*2.6*10 HEAT53137
 .;I $O(^ABMNINS(DUZ(2),ABMP("INS"),2.5,"ASEND",+ABMP("EXP"),ABMLOOP,ABME("RTYPE"),ABMELE,""))="S" Q  ;abm*2.6*10 HEAT53137
 .I $O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2.5,"ASEND",+ABMP("EXP"),ABMLOOP,ABME("RTYPE"),ABMELE,""))="S" Q  ;abm*2.6*10 HEAT53137
 .I ABMELE["01" S ABMELEM=2
 .I ABMELE["02" S ABMELEM=3
 .I ABMELE["03" S ABMELEM=4
 .I ABMELE["04" S ABMELEM=5
 .I ABMELE["05" S ABMELEM=6
 .I ABMELE["06" S ABMELEM=7
 .I ABMELE["07" S ABMELEM=8
 .I ABMELE["08" S ABMELEM=9
 .;I ABMELE["09" S ABMELEM=10  ;abm*2.6*9 HEAT59090
 .I ABMELE["09" S ABMELEM=100  ;abm*2.6*9 HEAT59090
 .I ABMELE["14" S ABMELEM=15  ;abm*2.6*10 HEAT74624
 .I ABMELE["15" S ABMELEM=16  ;abm*2.6*9 HEAT58133
 .S ABMR(ABME("RTYPE"),ABMELEM)=""
 .S $P(ABMREC(ABME("RTYPE")),"*",$E(ABMELEM,1,$L(ABMELEM)-1))=""
 ;I $D(^ABMNINS(DUZ(2),ABMP("INS"),2.5,"A837",+ABMP("EXP"),ABMLOOP,ABME("RTYPE"))) D  ;seg override  ;abm*2.6*10 HEAT53137
 I $D(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2.5,"A837",+ABMP("EXP"),ABMLOOP,ABME("RTYPE"))) D  ;seg override  ;abm*2.6*10 HEAT53137
 .S ABMELE=""
 .;F  S ABMELE=$O(^ABMNINS(DUZ(2),ABMP("INS"),2.5,"A837",+ABMP("EXP"),ABMLOOP,ABME("RTYPE"),ABMELE)) Q:($G(ABMELE)="")  D  ;abm*2.6*10 HEAT53137
 .F  S ABMELE=$O(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2.5,"A837",+ABMP("EXP"),ABMLOOP,ABME("RTYPE"),ABMELE)) Q:($G(ABMELE)="")  D  ;abm*2.6*10 HEAT53137
 ..;start old abm*2.6*10 HEAT53137
 ..;S ABMVALUE=$G(^ABMNINS(DUZ(2),ABMP("INS"),2.5,"A837",+ABMP("EXP"),ABMLOOP,ABME("RTYPE"),ABMELE,0))
 ..;S:($G(ABMVALUE)="") ABMVALUE=$G(^ABMNINS(DUZ(2),ABMP("INS"),2.5,"A837",+ABMP("EXP"),ABMLOOP,ABME("RTYPE"),ABMELE,ABMP("VTYP")))
 ..;end old start new HEAT53137
 ..S ABMVALUE=$G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2.5,"A837",+ABMP("EXP"),ABMLOOP,ABME("RTYPE"),ABMELE,0))
 ..S:($G(ABMVALUE)="") ABMVALUE=$G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),2.5,"A837",+ABMP("EXP"),ABMLOOP,ABME("RTYPE"),ABMELE,ABMP("VTYP")))
 ..;end new HEAT53137
 ..I ABMVALUE'="" D
 ...I ABMELE["01" S ABMELEM=2
 ...I ABMELE["02" S ABMELEM=3
 ...I ABMELE["03" S ABMELEM=4
 ...I ABMELE["04" S ABMELEM=5
 ...I ABMELE["05" S ABMELEM=6
 ...I ABMELE["06" S ABMELEM=7
 ...I ABMELE["07" S ABMELEM=8
 ...I ABMELE["08" S ABMELEM=9
 ...;I ABMELE["09" S ABMELEM=10  ;abm*2.6*9 HEAT59090
 ...I ABMELE["09" S ABMELEM=100  ;abm*2.6*9 HEAT59090
 ...I ABMELE["14" S ABMELEM=15  ;abm*2.6*10 HEAT74624
 ...;I ABMELE["15" S ABMELEM=160  ;abm*2.6*9 HEAT58133  ;abm*2.6*11 HEAT97792
 ...I ABMELE["15" S ABMELEM=16  ;abm*2.6*11 HEAT97792
 ...S ABMR(ABME("RTYPE"),ABMELEM)=ABMVALUE
 ...I ABME("RTYPE")="ISA",ABMELEM=7 S ABMVALUE=$$FMT^ABMERUTL((ABMVALUE),15)  ;abm*2.6*10 IHS/SD/AML 03/23/2012 - If ISA06, ensure 15 chars for element
 ...I ABME("RTYPE")="ISA",ABMELEM=9 S ABMVALUE=$$FMT^ABMERUTL((ABMVALUE),15)  ;abm*2.6*9 NOHEAT - ensure ISA08 15 chars
 ...S $P(ABMREC(ABME("RTYPE")),"*",$E(ABMELEM,1,$L(ABMELEM-1)))=ABMVALUE  ;abm*2.6*10 HEAT74624
 Q
 ;end new 5010
