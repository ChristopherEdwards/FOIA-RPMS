ABMUTL8 ; IHS/ASDST/DMJ - 837 UTILITIES ;      
 ;;2.6;IHS Third Party Billing;**1,4,6,8**;NOV 12, 2009
 ;Original;DMJ;09/21/95 12:47 PM
 ;
 ; 02/18/04 V2.5 P5 - 837 modification
 ;     Use HRN in following priority order -  visit location/parent/loop satellites
 ; IHS/SD/SDR - v2.5 p5 - 5/18/04 - Modified to put POS and TOS by line item
 ; IHS/SD/SDR - v2.5 p6 - 7/13/04 - Modified so OVER works correctly
 ; IHS/SD/SDR - v2.5 p8 - IM13324/IM15558
 ;    Added code to format 0 to 0.00
 ; IHS/SD/SDR - v2.5 p8 - IM12628
 ;    Removed special delimiter for CA
 ; IHS/SD/SDR - v2.5 p8 - task 6
 ;    Check value code before formatting; can be dollar amt or zip
 ; IHS/SD/SDR - v2.5 p9 - IM14702/IM17968
 ;    Correct HRN lookup for satellites
 ;IHS/SD/SDR - v2.5 p9 - IM17270
 ;   Changed "~" to "-" to avoid delimiter issues
 ; IHS/SD/SDR - v2.5 p9 - IM16962
 ;    If BCBS/OK add CR/LF to delimiter; they can't do streamed data
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*1 - HEAT2836 - Remove Dxs when inpt Medicare/RR
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - added code to pull anesthesia charges
 ;
HRN(X) ;PEP - health record number
 ; First look at Visit Location for HRN
 ; If not then look at Parent Location for HRN
 ; If not, loop Satellite Locations for said parent until one is found.
 I $G(ABMP("LDFN")) S HRN=$P($G(^AUPNPAT(+X,41,ABMP("LDFN"),0)),"^",2)
 Q:HRN HRN
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
 S:$E(ABMBTYP,2)<3 ABMDXA="BJ:"_ABMDXA
 S:$E(ABMBTYP,2)>2 ABMDXA="ZZ:"_ABMDXA
 Q ABMDXA
DXE(X) ;EP - E-Code
 ;x=bill ien
 S ABMDXE=$P($G(^ABMDBILL(DUZ(2),X,8)),U,12)
 I ABMDXE="" Q ABMDXE
 S ABMDXE="BN:"_$TR($P($$DX^ABMCVAPI(ABMDXE,ABMP("VDT")),U,2),".")  ;CSV-c
 Q ABMDXE
DXSET(X) ;EP - set dx array
 ;x=bill ien
 I +$G(ABMP("EXP"))=31!(+$G(ABMP("EXP"))=32) D DXSET2(X) Q  ;abm*2.6*8 5010
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
 ..S $P(ABMDX(ABMCNT),":",2)=$TR($P($$DX^ABMCVAPI(J,ABMP("VDT")),U,2),".")  ;CSV-c
 I $P($G(^ABMDBILL(DUZ(2),X,5)),U,9)'="" S ABMDX("ADM")=$TR($P($$DX^ABMCVAPI($P($G(^ABMDBILL(DUZ(2),X,5)),U,9),ABMP("VDT")),U,2),".")   ;abm*2.6*8 5010
 Q
 ;start new code abm*2.6*8 5010
DXSET2(X) ;EP - set dx array
 ;x=bill ien
 K ABMDX
 N I,J
 S ABMCNT=0
 S I=0
 F  S I=$O(^ABMDBILL(DUZ(2),X,17,"C",I)) Q:'I  D
 .S J=0
 .F  S J=$O(^ABMDBILL(DUZ(2),X,17,"C",I,J)) Q:'J  D
 ..Q:$E($P($$DX^ABMCVAPI($P($G(^ABMDBILL(DUZ(2),X,5)),U,9),ABMP("VDT")),U,2),1)="E"  ;skip E-codes
 ..S ABMCNT=ABMCNT+1
 ..S:ABMCNT=1 ABMDX(ABMCNT)="BK"
 ..S:ABMCNT'=1 ABMDX(ABMCNT)="BF"
 ..S $P(ABMDX(ABMCNT),":",2)=$TR($P($$DX^ABMCVAPI(J,ABMP("VDT")),U,2),".")  ;CSV-c 
 ;
 S ABMCNT=0
 S I=0
 F  S I=$O(^ABMDBILL(DUZ(2),X,17,"C",I)) Q:'I  D
 .S J=0
 .F  S J=$O(^ABMDBILL(DUZ(2),X,17,"C",I,J)) Q:'J  D
 ..Q:$E($P($$DX^ABMCVAPI(J,ABMP("VDT")),U,2),1)'="E"  ;skip E-codes
 ..S ABMCNT=ABMCNT+1
 ..S ABMDXE(ABMCNT)="BN:"_$TR($P($$DX^ABMCVAPI(J,ABMP("VDT")),U,2),".")  ;CSV-c
 ..I $P($G(^ABMDBILL(DUZ(2),X,17,J,0)),U,5)'="" S $P(ABMDXE(ABMCNT),":",9)=$P($G(^ABMDBILL(DUZ(2),X,17,J,0)),U,5)
 I $P($G(^ABMDBILL(DUZ(2),X,5)),U,9)'="" S ABMDX("ADM")=$TR($P($$DX^ABMCVAPI($P($G(^ABMDBILL(DUZ(2),X,5)),U,9),ABMP("VDT")),U,2),".")   ;abm*2.6*8 5010
 Q
 ;end new code abm*2.6*8
PXSET(X) ;EP - set px array
 ;x=bill ien
 K ABMPX
 K ABMICD
 N I,J
 S ABMCNT=0
 S I=0
 F  S I=$O(^ABMDBILL(DUZ(2),X,19,"C",I)) Q:'I  D
 .S J=0
 .F  S J=$O(^ABMDBILL(DUZ(2),X,19,"C",I,J)) Q:'J  D
 ..S ABMCNT=ABMCNT+1
 ..S:ABMCNT=1 ABMPX(ABMCNT)="BR"
 ..S:ABMCNT'=1 ABMPX(ABMCNT)="BQ"
 ..S ABMICD=$P($G(^ABMDBILL(DUZ(2),X,19,J,0)),U)
 ..S $P(ABMPX(ABMCNT),":",2)=$TR($P($$ICDOP^ABMCVAPI(+ABMICD,ABMP("VDT")),U,2),".")  ;CSV-c
 ..S $P(ABMPX(ABMCNT),":",3)="D8"
 ..S $P(ABMPX(ABMCNT),":",4)=$$Y2KD2^ABMDUTL($P(^ABMDBILL(DUZ(2),X,19,J,0),U,3))
 S I=0
 ;start old code abm*2.6*1 HEAT2836
 ;F  S I=$O(^ABMDBILL(DUZ(2),X,21,"C",I)) Q:'I  D
 ;.S J=0
 ;.F  S J=$O(^ABMDBILL(DUZ(2),X,21,"C",I,J)) Q:'J  D
 ;..N ABMCODE
 ;..S ABMCODE=$P($G(^ABMDBILL(DUZ(2),X,21,J,0)),U)
 ;..S ABMCNT=ABMCNT+1
 ;..S:ABMCNT=1 ABMPX(ABMCNT)="BP"
 ;..S:ABMCNT'=1 ABMPX(ABMCNT)="BO"
 ;..S $P(ABMPX(ABMCNT),":",2)=$P($$CPT^ABMCVAPI(+ABMCODE,ABMP("VDT")),U,2)  ;CSV-c
 ;..S $P(ABMPX(ABMCNT),":",3)="D8"
 ;..S $P(ABMPX(ABMCNT),":",4)=$$Y2KD2^ABMDUTL($P(^ABMDBILL(DUZ(2),X,21,J,0),U,5))
 ;end old code HEAT2836
 Q
OSSET(X) ;EP - occurrence span set
 ;x=bill ien
 K ABMOS
 S ABMCNT=0
 N I
 S I=0
 F  S I=$O(^ABMDBILL(DUZ(2),X,57,I)) Q:'I  D
 .S ABMLINE=^ABMDBILL(DUZ(2),X,57,I,0)
 .S ABMCNT=ABMCNT+1
 .S ABMOS(ABMCNT)="BI"
 .S $P(ABMOS(ABMCNT),":",2)=$P($G(^ABMDCODE(+$P(ABMLINE,U),0)),U)
 .S $P(ABMOS(ABMCNT),":",3)="RD8"
 .S $P(ABMOS(ABMCNT),":",4)=$$Y2KD2^ABMDUTL($P(ABMLINE,"^",2))_"-"_$$Y2KD2^ABMDUTL($P(ABMLINE,"^",3))
 Q
OCSET(X) ;EP - occurrence set
 ;x=bill ien
 K ABMOC
 S ABMCNT=0
 N I
 S I=0
 F  S I=$O(^ABMDBILL(DUZ(2),X,51,I)) Q:'I  D
 .S ABMLINE=^ABMDBILL(DUZ(2),X,51,I,0)
 .S ABMCNT=ABMCNT+1
 .S ABMOC(ABMCNT)="BH"
 .S $P(ABMOC(ABMCNT),":",2)=$P($G(^ABMDCODE(+$P(ABMLINE,U),0)),U)
 .S $P(ABMOC(ABMCNT),":",3)="D8"
 .S $P(ABMOC(ABMCNT),":",4)=$$Y2KD2^ABMDUTL($P(ABMLINE,"^",2))
 Q
VASET(X) ;EP - value code set
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
 .I $P(ABMVA(ABMCNT),":",2)'="A0" S $P(ABMVA(ABMCNT),":",5)=$FN($P(ABMLINE,U,2),"",2)
 .E  S $P(ABMVA(ABMCNT),":",5)=$P(ABMLINE,U,2)
 Q
CDSET(X) ;EP - condition code set
 ;x=bill ien
 K ABMCD
 S ABMCNT=0
 N I
 S I=0
 F  S I=$O(^ABMDBILL(DUZ(2),X,53,I)) Q:'I  D
 .S ABMLINE=^ABMDBILL(DUZ(2),X,53,I,0)
 .S ABMCNT=ABMCNT+1
 .S ABMCD(ABMCNT)="BG"
 .S $P(ABMCD(ABMCNT),":",2)=$P($G(^ABMDCODE(+ABMLINE,0)),U)
 Q
 ;start new code abm*2.6*6 5010
ANES(X) ;EP - anesthesia charges set
 K ABMANES
 S ABMCNT=0
 N I
 S I=0
 F  S I=$O(^ABMDBILL(DUZ(2),X,39,I)) Q:'I  D  Q:ABMCNT=2
 .S ABMCNT=ABMCNT+1
 .S ABMANES(ABMCNT)=$S(ABMCNT=1:"BP",1:"BO")
 .S $P(ABMANES(ABMCNT),":",2)=$$GET1^DIQ(81,$P($G(^ABMDBILL(DUZ(2),X,39,I,0)),U),".01")
 Q
 ;end new code 5010
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
 I $D(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",14,ABMLN,ABMPCE,0)) S ABMOVTYP=0
 I $D(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",14,ABMLN,ABMPCE,ABMP("VTYP"))) S ABMOVTYP=ABMP("VTYP")
 I $G(ABMOVTYP)="" Q ABMVALUE
 S ABMVALUE=^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",14,ABMLN,ABMPCE,ABMOVTYP)
 Q ABMVALUE
 ;start new code abm*2.6*6 5010
837 ;EP - override for 837 5010 formats
 K ABME("VTYP")
 I $D(^ABMNINS(DUZ(2),ABMP("INS"),2.5,"ASEND",+ABMP("EXP"),ABMLOOP,ABME("RTYPE"),"N")) D  ;do not send segment
 .S ABMREC(ABME("RTYPE"))=ABME("RTYPE")
 .K ABMR(ABME("RTYPE"))
 .S ABMR(ABME("RTYPE"),10)=ABME("RTYPE")
 S ABMELE=""
 F  S ABMELE=$O(^ABMNINS(DUZ(2),ABMP("INS"),2.5,"ASEND",+ABMP("EXP"),ABMLOOP,ABME("RTYPE"),ABMELE)) Q:($G(ABMELE)="")  D
 .I $O(^ABMNINS(DUZ(2),ABMP("INS"),2.5,"ASEND",+ABMP("EXP"),ABMLOOP,ABME("RTYPE"),ABMELE,""))="S" Q
 .I ABMELE["01" S ABMELEM=2
 .I ABMELE["02" S ABMELEM=3
 .I ABMELE["03" S ABMELEM=4
 .I ABMELE["04" S ABMELEM=5
 .I ABMELE["05" S ABMELEM=6
 .I ABMELE["06" S ABMELEM=7
 .I ABMELE["07" S ABMELEM=8
 .I ABMELE["08" S ABMELEM=9
 .I ABMELE["09" S ABMELEM=10
 .I ABMELE["15" S ABMELEM=160
 .S ABMR(ABME("RTYPE"),ABMELEM)=""
 .S $P(ABMREC(ABME("RTYPE")),"*",$E(ABMELEM,1,$L(ABMELEM)-1))=""
 I $D(^ABMNINS(DUZ(2),ABMP("INS"),2.5,"A837",+ABMP("EXP"),ABMLOOP,ABME("RTYPE"))) D  ;segment override
 .S ABMELE=""
 .F  S ABMELE=$O(^ABMNINS(DUZ(2),ABMP("INS"),2.5,"A837",+ABMP("EXP"),ABMLOOP,ABME("RTYPE"),ABMELE)) Q:($G(ABMELE)="")  D
 ..S ABMVALUE=$G(^ABMNINS(DUZ(2),ABMP("INS"),2.5,"A837",+ABMP("EXP"),ABMLOOP,ABME("RTYPE"),ABMELE,0))
 ..S:($G(ABMVALUE)="") ABMVALUE=$G(^ABMNINS(DUZ(2),ABMP("INS"),2.5,"A837",+ABMP("EXP"),ABMLOOP,ABME("RTYPE"),ABMELE,ABMP("VTYP")))
 ..I ABMVALUE'="" D
 ...I ABMELE["01" S ABMELEM=2
 ...I ABMELE["02" S ABMELEM=3
 ...I ABMELE["03" S ABMELEM=4
 ...I ABMELE["04" S ABMELEM=5
 ...I ABMELE["05" S ABMELEM=6
 ...I ABMELE["06" S ABMELEM=7
 ...I ABMELE["07" S ABMELEM=8
 ...I ABMELE["08" S ABMELEM=9
 ...I ABMELE["09" S ABMELEM=10
 ...S ABMR(ABME("RTYPE"),ABMELEM)=ABMVALUE
 ...S $P(ABMREC(ABME("RTYPE")),"*",$E(ABMELEM,1,$L(ABMELEM-1)))=ABMVALUE
 Q
 ;end new code 5010
