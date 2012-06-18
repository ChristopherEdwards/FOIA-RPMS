ABMERUTL ; IHS/ASDST/DMJ - EMC UTILITIES ;      
 ;;2.6;IHS 3P BILLING SYSTEM;**3,6**;NOV 12, 2009
 ;Original;DMJ;09/21/95 12:47 PM
 ;
 ; IHS/SD/SDR - v2.5 p8 - IM14799
 ;    EA0 field 15 (pos 54) not populating correctly; Modified BCBS
 ;    line tag to kill possible pre-exisiting calue of ABME("LOC")
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM16962 - Allow Receiver ID to be longer than 5 characters
 ; IHS/SD/SDR - v2.5 p10 - IM20225/IM20271 - Set replacement insurer correctly
 ; IHS/SD/SDR - abm*2.6*3 - HEAT7574 - tribal self-insured changes
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - made changes for multi-insurer GCNs
 ; *********************************************************************
 ;
FMT(X,Y) ; EP
 ; Format Variable
 ;
 ;  INPUT:  X = DATA STRING
 ;          Y = FORMAT INSTRUCTONS
 ;
 ; OUTPUT:  X = FORMATTED DATA
 ;
 I $G(ABMP("NOFMT")) Q X           ; No formatting
 S $P(ABMP("SPACES")," ",130)=""   ; 130 spaces
 S $P(ABMP("ZEROS"),"0",60)=""     ; 60 zeroes
 I Y["J" D
 .N I S I=$P(Y,"J",2)
 .S I=$E(I)
 .S X=$TR($J(X,1,I),".")
 I Y["S" D
 .S X=$TR(X,"-\/!@#$%&*.,")
 S ABME("FILLER")=$S(Y["N":ABMP("ZEROS"),1:ABMP("SPACES"))
 S X=$S(Y["R":ABME("FILLER")_X,1:X_ABME("FILLER"))
 S X=$S(Y["R":$E(X,$L(X)+1-+Y,$L(X)),1:$E(X,1,+Y))
 Q X
 ;
STRIP(X) ;EP - strip trailing blanks
 N I F I=$L(X):-1:1 D  Q:$G(ABMLN)
 .Q:$E(X,I)=" "
 .S ABMLN=I
 S X=$E(X,1,ABMLN)
 K ABMLN
 Q X
STRPL(X) ;EP - strip leading blanks
 N I
 S ABMLEN=$L(X," ")
 F I=1:1:ABMLEN D  Q:$P(X," ",I)'=""
 .Q:$P(X," ",I)'=""
 S X=$P(X," ",I,ABMLEN)
 K ABMLEN
 Q X
DFMT ; EP
 ; Format Date Field
 S Y=$E(Y,4,5)_$E(Y,6,7)_$E(Y,2,3)
 Q
 ;
SET ; EP
 ; Set up some things
 Q:$G(ABMP("SET"))  ; Quit if already set up these variables
 K ABMP("INS")
 N I
 F I=0:1:9 D
 .S @("ABMB"_I)=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),I))
 S ABMP("PDFN")=$P(ABMB0,"^",5)   ; Patient IEN
 S ABMP("LDFN")=$P(ABMB0,"^",3)   ; Visit location IEN
 S ABMP("BTYP")=$P(ABMB0,"^",2)   ; Bill type
 S ABMP("EXP")=$P(ABMB0,"^",6)    ; Export mode IEN
 S ABMP("INS")=$P(ABMB0,"^",8)    ; Active Insurer IEN
 S ABMP("VTYP")=$P(ABMB0,"^",7)   ; Visit type IEN
 S ABMP("CLIN")=$P(ABMB0,"^",10)  ; Clinic
 S ABMP("CLIN")=$P($G(^DIC(40.7,+ABMP("CLIN"),0)),"^",2)
 S ABMP("VDT")=$P(ABMB7,U) ; Service date from
 S ABMP("ITYPE")=$P($G(^AUTNINS(+ABMP("INS"),2)),U)  ; Type of insurer
 D ISET                             ; set up insurers
 D PCN
 D SOP
 S ABMP("SET")=1                    ; set variable set flag
 Q
 ;
ISET ; EP
 ; Set up Insurers
 ; 
 ; ABMP("INS",priority) = Insurer IEN ^ type of insurer ^
 ;                        Insurer multiple IEN
 ;
 K ABMCDNUM
 S ABME("PRIO")=0
 S ABME("INS#")=0
 ; Loop down priority
 F  S ABME("PRIO")=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"C",ABME("PRIO"))) Q:'ABME("PRIO")!($G(ABMP("INS",3)))  D
 .N I
 .S I=0
 .; Loop entries
 .F  S I=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"C",ABME("PRIO"),I)) Q:'I!($G(ABMP("INS",3)))  D
 ..; Quit if insurer unbillable
 ..Q:$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I,0),U,3)="U"
 ..S ABME("INS")=$S($P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I,0),U,11)'="":$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I,0),U,11),1:$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I,0),U))  ;Insurer IEN
 ..S ABME("ITYPE")=$P(^AUTNINS(ABME("INS"),2),U)  ; type of insurer
 ..Q:"I"[ABME("ITYPE")  ; Quit if indian patient
 ..; Quit if non-beneficiary and not active insurer
 ..Q:"N"[ABME("ITYPE")&($P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,8)'=ABME("INS"))
 ..S ABME("INS#")=ABME("INS#")+1  ; increment counter
 ..S ABMP("INS",ABME("INS#"))=ABME("INS")_"^"_ABME("ITYPE")_"^"_I
 ..I ABME("ITYPE")="D"!(ABME("ITYPE")="K") D
 ...S ABMCDNUM=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I,0),"^",6)
 ...S:'$G(ABMP("PDFN")) ABMP("PDFN")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),"^",5)
 ...Q:$P($G(^AUPNMCD(+ABMCDNUM,0)),U)=ABMP("PDFN")
 ...D DBFX^ABMDEFIP(ABMP("BDFN"),I)
 ...S ABMCDNUM=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I,0),"^",6)
 I +$G(ABMP("INS"))'=0,($$RCID^ABMUTLP(ABMP("INS"))["61044") D
 .Q:$P($G(ABMP("INS",1)),U)=ABMP("INS")  ;61044 is primary
 .Q:$P($G(^AUTNINS($P($G(ABMP("INS",1)),U),0)),U)'["MEDICARE"  ;Medicare isn't primary
 .Q:$$RCID^ABMUTLP($P($G(ABMP("INS",2)),U))'["61044"  ;Medi-Cal is not secondary
 .Q:$P($G(^ABMDVTYP(ABMP("VTYP"),0)),U)'["CROSSOVER"  ;visit type must contain CROSSOVER
 .S ABMP("INS",1)=ABMP("INS",2)  ;move Medi-Cal to primary spot
 .K ABMP("INS",2)  ;remove Medi-Cal from secondary
 Q
PCN ;EP - Patient Control Number
 S:'$G(ABMDUZ2) ABMDUZ2=DUZ(2)
 S ABMP("PCN")=$P(^ABMDBILL(ABMDUZ2,ABMP("BDFN"),0),U)
 S ABMSFX=$P($G(^ABMDPARM(+ABMP("LDFN"),1,2)),"^",4)
 I ABMSFX'="" D
 .S ABMP("PCN")=ABMP("PCN")_"-"_ABMSFX
 I $P($G(^ABMDPARM(ABMP("LDFN"),1,3)),U,3)  D
 .S ABMP("HRN")=$P($G(^AUPNPAT(+ABMP("PDFN"),41,+ABMP("LDFN"),0)),"^",2)
 .S:ABMP("HRN")="" ABMP("HRN")=$P($G(^AUPNPAT(+ABMP("PDFN"),41,DUZ(2),0)),"^",2)
 .Q:ABMP("HRN")=""
 .S ABMP("PCN")=ABMP("PCN")_"-"_ABMP("HRN")
 K ABMSFX
 Q
SOP ;EP - Source of Pay
 N X
 S X=$F("HMDRPWCFNIK",ABMP("ITYPE"))
 S ABMP("SOP")=$E(" IZDCFBHZAZD",X)
 I ABMP("ITYPE")="P" D BCBS S:$G(ABMP("BCBS")) ABMP("SOP")="G"
 Q
BCBS ; EP
 ; Check if Blue Cross and Blue Shield
 K ABME("LOC")
 K ABMP("BCBS")
 S ABMP("INAME")=$P($G(^AUTNINS(ABMP("INS"),0)),U)
 N I
 F I="B","C","S" D  Q:'ABME("LOC")
 .S ABME("LOC")=$F(ABMP("INAME"),I,$G(ABME("LOC")))
 Q:'ABME("LOC")
 S ABMP("BCBS")=1
 Q
RCID(X) ;EP - Receiver ID (X=Insurer IEN)
 S Y=$P($G(^AUTNINS(X,0)),"^",8)
 I +Y=400 D  Q Y
 .S Y="00400"
 .I $G(ABMP("VTYP"))=999!($G(ABMP("BTYP"))=831&($G(ABMP("EXP"))=22)) S Y="00900"
 .I $G(ABMP("EXP"))>20 S Y="C"_Y
 I Y=4001 D  Q Y
 .S Y="04001"
 .I $G(ABMP("VTYP"))=999!($G(ABMP("BTYP"))=831&($G(ABMP("EXP"))=22)) S Y="04402"  ;ASC
 Q Y
ENVY(X,Y)          ;EP - Envoy Payer ID (X=Insurer EIN,Y=Visit Type)
 N ABM,I,Z
 S Z=""
 F I=1:1:3 S ABM(I)=$P($G(^AUTNINS(+X,5)),"^",I)
 I Y=111 S Z=ABM(2)
 I Y="H" S Z=ABM(2)
 I Y=998 S Z=ABM(3)
 I Y="D" S Z=ABM(3)
 I Y=999 S Z=ABM(1)
 I Y="M" S Z=ABM(1)
 I Y=131 S Z=ABM(1)
 I Z="" S Z=ABM(1)
 S Z=$P($G(^ABMENVOY(+$G(Z),0)),U)
 Q Z
MSG(X) ; EP
 ; Display message to terminal
 Q:$G(ABMQUIET)
 W !!,*7,X,!
 F  W ! Q:$Y+3>IOSL
 S DIR(0)="E"
 D ^DIR
 K DIR
 Q
 ;
PAYED ; EP
 ; Build Insurance Payment Array
 K ABMP("PAYED")
 N L
 S L=+$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U)_" "  ; Bill number
 F  S L=$O(^ABMDBILL(DUZ(2),"B",L)) Q:+L'=+$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U)!(L="")  D
 .N I
 .S I=$O(^ABMDBILL(DUZ(2),"B",L,0))                ; IEN
 .Q:$P(^ABMDBILL(DUZ(2),I,0),"^",4)="X"  ; Quit if cancelled
 .N K
 .S K=$P(^ABMDBILL(DUZ(2),I,0),"^",8)              ; Active insurer IEN
 .;I $P($G(^ABMNINS(ABMP("LDFN"),K,0)),U,11)="Y"&($P($G(^AUTNINS(ABMP("INS"),2)),U)="R") S (ABMP("PAYED"),ABMP("PAYED",K))=$P(ABMB2,U) Q  ;abm*2.6*3 HEAT7574
 .N J
 .S J=0
 .F  S J=$O(^ABMDBILL(DUZ(2),I,3,J)) Q:'J  D
 ..N ABMPAY,ABMPDT,ABMZERO
 ..S ABMZERO=^ABMDBILL(DUZ(2),I,3,J,0)
 ..S ABMPDT=$P(ABMZERO,U)                     ; Payment date
 ..S ABMPAY=$P(ABMZERO,"^",2)                    ; Amt paid
 ..S ABMP("PAYED",K)=+$G(ABMP("PAYED",K))+ABMPAY  ; Add amt paid per insurer
 ..S ABMP("PDT",K)=ABMPDT
 ..S ABMP("PAYED")=+$G(ABMP("PAYED"))+ABMPAY      ; Add amt paid
 Q
 ;
TCR(X) ; EP
 ; Total credits for a bill
 S ABM("TCREDITS")=0
 S I=0
 F  S I=$O(^ABMDBILL(DUZ(2),X,3,I)) Q:'I  D
 .F J=2,3,4 S ABM("TCREDITS")=ABM("TCREDITS")+$P(^ABMDBILL(DUZ(2),X,3,I,0),"^",J)
 S X=ABM("TCREDITS")
 K ABM("TCREDITS")
 Q X
 ;
UPC(X) ; EP
 ; Upper case
 S X=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q X
 ;
LWC(X) ; EP
 ; Lower case
 S X=$TR(X,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
 Q X
 ;
SLN(X,Y) ; EP
 ; Provider state license number
 ; 
 ;  INPUT:  X = PROVIDER
 ;          Y = STATE
 ;
 ; OUTPUT:  X = Provider state license number
 ;
 ; (If no number, grab the first one)
 ;
 I '$G(Y) S Y=$P(^AUTTLOC(DUZ(2),0),"^",23)  ; State IEN
 I 'Y S Y=$P(^AUTTLOC(DUZ(2),0),"^",14)      ; Mail address - State IEN
 I 'Y S Y=999
 N I
 S I=$O(^VA(200,X,"PS1","B",Y,0))
 I 'I S I=$O(^VA(200,X,"PS1",0))
 I 'I S X="" Q X
 S Y=$P(^VA(200,X,"PS1",I,0),U)          ; Licensing state IEN
 S X=$P(^VA(200,X,"PS1",I,0),"^",2)          ; License number
 S X=$P(^DIC(5,Y,0),"^",2)_"-"_X             ; State - License
 Q X
 ;
MCDBFX(X,Y)         ; EP
 ; Fix BILL Insurance Multiple if broken pointer medicaid
 ;
 ;  INPUT:  X = IEN (CLAIM OR BILL)
 ;          Y = INSURER IEN UNDER FIELD #13 (INS MULTIPLE)
 ;
 ; OUTPUT:
 ;
 N ABMP
 S ABMP("D0")=X
 S ABMP("D1")=Y
 S ABMP("ZERO")=^ABMDBILL(DUZ(2),ABMP("D0"),13,ABMP("D1"),0)
 S ABMP("PDFN")=$P(^ABMDBILL(DUZ(2),ABMP("D0"),0),"^",5)
 S ABMP("VDT")=$P(^ABMDBILL(DUZ(2),ABMP("D0"),7),U)
 D MGET
 I $G(ABMP(1)) S $P(^ABMDBILL(DUZ(2),ABMP("D0"),13,ABMP("D1"),0),"^",6)=ABMP(1),$P(^(0),"^",7)=ABMP(2)
 Q
 ;
MCDCFX(X,Y)        ; EP
 ; Fix CLAIM Insurance Multiple if broken pointer, Medicaid
 ;
 ;  INPUT:  X = IEN (CLAIM OR BILL)
 ;          Y = INSURER IEN UNDER FIELD #13 (INS MULTIPLE)
 ;
 ; OUTPUT:
 ;
 N ABMP
 S ABMP("D0")=X
 S ABMP("D1")=Y
 S ABMP("ZERO")=^ABMDCLM(DUZ(2),ABMP("D0"),13,ABMP("D1"),0)
 S ABMP("PDFN")=$P(^ABMDCLM(DUZ(2),ABMP("D0"),0),U)
 S ABMP("VDT")=$P(^ABMDCLM(DUZ(2),ABMP("D0"),0),"^",2)
 D MGET
 I $G(ABMP(1)) S $P(^ABMDCLM(DUZ(2),ABMP("D0"),13,ABMP("D1"),0),"^",6)=ABMP(1),$P(^(0),"^",7)=ABMP(2)
 Q
 ;
MGET ; EP
 ; Get new pointer
 S ABMP("INSCO")=$P(ABMP("ZERO"),U)
 S ABMP("PTR")=$P(ABMP("ZERO"),"^",6)
 Q:ABMP("PTR")=""
 Q:$D(^AUPNMCD(ABMP("PTR"),0))
 Q:$P($G(^AUTNINS(ABMP("INSCO"),2)),U)'="D"
 D 4^ABMDLCK2
 S ABMP("PRI")=$O(ABML(0)) Q:'ABMP("PRI")
 S ABMP("INS")=$O(ABML(ABMP("PRI"),0)) Q:'ABMP("INS")
 Q:ABMP("INS")'=ABMP("INSCO")
 N I
 F I=1,2 S ABMP(I)=$P(ABML(ABMP("PRI"),ABMP("INS")),"^",I)
 Q
 ;
S90 ; EP
 ; add 1 to record type counts
 N I
 S I=ABME("RTYPE")\10
 S I=I*10
 S I=I+30
 S ABMRT(90,40)=+$G(ABMRT(90,40))+1
 S ABMRT(90,I)=+$G(ABMRT(90,I))+1
 S ABMRT(90,"RTOT")=+$G(ABMRT(90,"RTOT"))+1
 Q
POS(X) ;EP - place of service
 S X=$G(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",3,37,3,ABMP("VTYP")))
 I X="" S X=$G(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",3,37,3,0))
 I X="" S X=$G(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",14,37,3,ABMP("VTYP")))
 I X="" S X=$G(^ABMNINS(DUZ(2),ABMP("INS"),2,"AOVR",14,37,3,0))
 I X'="" Q X
 S X=$P($G(^ABMDPARM(ABMP("LDFN"),1,3)),"^",6)
 S:X="" X=$P($G(^ABMDPARM(DUZ(2),1,3)),"^",6)
 S:X X=$P(^ABMDCODE(X,0),U)
 I X=22,$E($G(ABMP("BTYP")),2)=1 S X=21
 I X=21,$E($G(ABMP("BTYP")),2)>2 S X=22
 I $G(ABMP("VTYP"))=831 S X=24  ;ASC
 I $G(ABMP("CLIN"))=30 S X=23
 I $G(ABMP("CLIN"))=11 S X=12
 Q X
TOS(X) ;EP - type of service (where x=multiple from 3P Bill File)
 S Y="01"
 S:X=21 Y="02"
 S:X=23 Y=99
 S:X=35 Y="04"
 S:X=37 Y="05"
 S:X=39 Y="07"
 Q Y
SOP1(X) ;EP - source of pay (x=ien insurer file)
 S ABMTYP=$P($G(^AUTNINS(+X,2)),U)
 S Y=ABMTYP
 I Y'="" D
 .S Y=$F("HMDRPWCFNIK",ABMTYP)
 .S Y=$E(" IZDCFBHZAZD",Y)
 .I ABMTYP="P",$$BCBS1(X) S Y="G"
 K ABMTYP
 Q Y
BCBS1(X) ;EP - check if blue cross/blue shield
 S Y=0
 S ABMNM=$P($G(^AUTNINS(+X,0)),U)
 I ABMNM="" K ABMNM Q Y
 N I
 F I="B","C","S" D  Q:'ABMLC
 .S ABMLC=$F(ABMNM,I,$G(ABMLC))
 I ABMLC S Y=1
 K ABMNM,ABMLC
 Q Y
NSN(X) ; EP - next submission number
 I $G(^ABMDTXST(0))<100000 S ^(0)=100000
 L +^ABMDTXST(0):30 I '$T S X="" Q X
 S X=^ABMDTXST(0)+1
 S ^ABMDTXST(0)=X
 L -^ABMDTXST(0)
 Q X
TCN(X) ;EP - Transmission Control Number
 I $G(X)="" Q X
 I '$D(^ABMDTXST(DUZ(2),X,0)) S X="" Q X
 S DA=X
 ;start old code abm*2.6*3 5PMS10005#2
 ;I $P($G(^ABMDTXST(DUZ(2),DA,1)),"^",6)="" D
 ;.S DIE="^ABMDTXST(DUZ(2),"
 ;.S DR=".16///"_$$NSN()
 ;.D ^DIE
 ;Q $P(^ABMDTXST(DUZ(2),DA,1),"^",6)
 ;end old code start new code 5PMS10005#2
 I $G(ABMXMTDT)="" S X="" Q X
 I +$O(^ABMDTXST(DUZ(2),X,3,"B",ABMXMTDT,0))=0 D
 .S ABMP("XMIT")=X
 .D GCNMULT("O","")
 Q $P($G(^ABMDTXST(DUZ(2),X,3,$O(^ABMDTXST(DUZ(2),X,3,"B",ABMXMTDT,0)),0)),U,2)
 ;end new code 5PMS10005#2
 ;
 ;start new code abm*2.6*3 5PM10005#2
GCNMULT(ABMSTAT,ABMREASN) ;
 N DIC,DIE,DA,DR,X,Y
 ;S ABMGCN=$$NSN()  ;abm*2.6*6 5010
 I +$G(ABMGCN)=0 S ABMGCN=$$NSN()  ;abm*2.6*6 5010
 S DA(1)=ABMP("XMIT")
 S DIC="^ABMDTXST(DUZ(2),"_DA(1)_",3,"
 S DIC("P")=$P(^DD(9002274.6,3,0),U,2)
 S DIC(0)="L"
 D NOW^%DTC
 S (X,ABMXMTDT)=%
 S DIC("DR")=".02////"_ABMGCN
 S DIC("DR")=DIC("DR")_";.03////"_ABMSTAT
 S DIC("DR")=DIC("DR")_";.04////"_DUZ
 I +$G(ABM("CHIEN"))'=0  S DIC("DR")=DIC("DR")_";.07////"_+$G(ABM("CHIEN"))  ;abm*2.6*6 5010
 D ^DIC
 Q:(+Y<0)
 I $G(ABMREASN) D
 .W !
 .K DIC,DIE,DA,DR,X
 .S DA(1)=ABMP("XMIT")
 .S DA=+Y
 .K Y
 .S DIE="^ABMDTXST(DUZ(2),"_DA(1)_",3,"
 .S DR=".05Reason for Recreate\Resend//"
 .S DIE("NO^")=""
 .D ^DIE
 Q
 ;end new code abm*2.6*3 5PMS10005#2
