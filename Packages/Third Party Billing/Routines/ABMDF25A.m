ABMDF25A ; IHS/ASDST/DMJ - ADA 2000 Dental Export -part 2 ;    
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;08/13/96 11:47 AM
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM19380
 ;   Corrections to getting secondary insurer
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20337
 ;   Added code for page 9F
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM21043
 ;   Changed treatment addresss to physical address
 ;
 ; *********************************************************************
 ;
ENT ; EP for getting data
 S ABMP("B0")=^ABMDBILL(DUZ(2),ABMP("BDFN"),0)  ; 3P Bill file 0 node
 S ABMP("INS")=$P(ABMP("B0"),U,8)               ; Active insurer
 S ABMP("PDFN")=$P(ABMP("B0"),U,5)              ; Patient IEN
 S ABMP("LDFN")=$P(ABMP("B0"),U,3)              ; Location IEN
 S ABMP("VTYP")=$P(ABMP("B0"),U,7)              ; Visit Type
 S ABMP("BTYP")=$P(ABMP("B0"),U,2)              ; Bill Type
 Q:'ABMP("PDFN")!'ABMP("LDFN")!'ABMP("INS")
 S ABMP("VDT")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),7),U)  ; Visit Date
 ;
BADDR ;
 ; Billing Address
 S ABM("J")=ABMP("BDFN")
 S ABM("I")=$P(^AUTNINS(ABMP("INS"),0),U)_"-"_ABMP("INS")
 S ABM("INS",ABM("I"),ABM("J"))=""
 I $P($G(^AUTNINS(ABMP("INS"),2)),U)="N" D
 .S ABM("INS",ABM("I"),ABM("J"))=ABMP("PDFN")
 S ABM("IDFN")=ABMP("INS")
 D BADDR^ABMDLBL1
 G PAT:'$D(ABM("ADD"))
 S ABMF(8)=$P(ABM("ADD"),U,1)                ; Ins Name (3)
 S ABMF(9)=$P(ABM("ADD"),U,2)                ; Ins Address  (3)
 S ABMF(10)=$P(ABMCSZ,U)    ; City     (3)
 S ABMSTATE=$P(ABMCSZ,"^",2)           ; State    (3)
 S ABMF(10)=ABMF(10)_", "_$P($G(^DIC(5,+ABMSTATE,0)),"^",2)
 S ABMF(10)=ABMF(10)_"  "_$P(ABMCSZ,"^",3)  ; Zip      (3)
 K ABMCSZ,ABMSTATE
 ; Secondary information
 S ABMPIIEN=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"B",ABMP("INS"),0))
 K ABMSCNT,ABMSINS,ABMP("INS2")
 I +$G(ABMPIIEN)'=0 D
 .S ABMPINS=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMPIIEN,0)),U,2)  ;get priority of active insurer
 .S ABMIFLG=0
 .S ABMSCNT=ABMPINS
 .F  S ABMSCNT=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"C",ABMSCNT)) Q:+ABMSCNT=0  D  Q:ABMIFLG=1
 ..S ABMSINS=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"C",ABMSCNT,0))
 ..I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMSINS,0)),U,3)="U" Q  ;unbillable
 ..S ABMIFLG=1
 I $G(ABMSINS)'="" S ABMP("INS2")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMSINS,0)),U)
 I $G(ABMP("INS2"))'="" D
 .S ABMPISAV=ABMP("INS")
 .S ABMP("INS")=ABMP("INS2")
 .S ABM("J")=ABMP("BDFN")
 .S ABM("I")=$P(^AUTNINS(ABMP("INS"),0),U)_"-"_ABMP("INS")
 .S ABM("INS",ABM("I"),ABM("J"))=""
 .I $P($G(^AUTNINS(ABMP("INS"),2)),U)="N" D
 ..S ABM("INS",ABM("I"),ABM("J"))=ABMP("PDFN")
 .S ABM("IDFN")=ABMP("INS")
 .D BADDR^ABMDLBL1
 .G PAT:'$D(ABM("ADD"))
 .S $P(ABMF(21),U)=$P(ABM("ADD"),U,1)                ; Secondary Name (11)
 .S $P(ABMF(22),U)=$P(ABM("ADD"),U,2)                ; Secondary Address  (11)
 .S $P(ABMF(23),U)=$P(ABMCSZ,U)    ; Secondary City     (11)
 .S ABMSTATE=$P(ABMCSZ,"^",2)           ; Secondary State    (11)
 .S $P(ABMF(23),U)=$P(ABMF(23),U)_", "_$P($G(^DIC(5,+ABMSTATE,0)),"^",2)  ;Secondary State (11)
 .S $P(ABMF(23),U)=$P(ABMF(23),U)_"  "_$P(ABMCSZ,"^",3)  ; Secondary Zip      (11)
 .K ABMCSZ,ABMSTATE
 .S ABMP("INS")=ABMPISAV
 .;
 .; secondary group# (9)
 .I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMSINS,0)),U,4) S ABMX("PH")=ABMP("PDFN")
 .I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMSINS,0)),U,5) S ABMX("PH")=ABMP("PDFN")
 .I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMSINS,0)),U,6) S ABMX("PH")=$P($G(^AUPNMCD($P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMSINS,0),U,6),0)),U,9)
 . I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMSINS,0)),U,8),($P(^AUPNPRVT(ABMP("PDFN"),11,$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMSINS,0),U,8),0),U,8)'="") D
 .. S ABMX("PH")=$P(^AUPNPRVT(ABMP("PDFN"),11,$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMSINS,0),U,8),0),U,8)
 .I +$G(ABMX("PH"))'=0 D
 ..S ABMX("GRP")=$P($G(^AUPN3PPH(+ABMX("PH"),0)),U,6)
 ..I $P($G(^AUPN3PPH(+ABMX("PH"),0)),U,8)="M" S $P(ABMF(17),U,2)="X"  ;Gender (7)
 ..I $P($G(^AUPN3PPH(+ABMX("PH"),0)),U,8)="F" S $P(ABMF(17),U,3)="X"  ;Gender (7)
 ..S $P(ABMF(17),U,4)=$P($G(^AUPN3PPH(+ABMX("PH"),0)),U,4)  ;Policy Number (8)
 .I $G(ABMX("GRP"))'="" D
 ..I $D(^AUTNEGRP(ABMX("GRP"),0)) D
 ...S $P(ABMF(19),U)=$S($D(^AUTNEGRP(ABMX("GRP"),11,ABMP("VTYP"),0)):$P(^(0),U,2),1:$P(^AUTNEGRP(ABMX("GRP"),0),U,2))
 ;
PAT ;
 ; Patient Information
 S ABM("P0")=^DPT(ABMP("PDFN"),0)                ; 0 node patient file
 S ABMF(18)=$P(ABM("P0"),U)                       ; Name     (20)
 S ABM("P11")=$G(^DPT(ABMP("PDFN"),.11))
 S $P(ABMF(19),U,6)=$P(ABM("P11"),U)              ; Mailing address (20)
 S $P(ABMF(20),U)=$P(ABM("P11"),U,4)            ; Mailing - city  (20)
 S $P(ABMF(20),U)=$P(ABMF(20),U)_", "_$P(^DIC(5,$P(ABM("P11"),U,5),0),U,2) ; Mailing - State (20)
 S $P(ABMF(20),U)=$P(ABMF(20),U)_"  "_$P(ABM("P11"),U,6)  ;Mailing - Zip (20)
 ;
 S $P(ABMF(23),U,2)=$P(ABM("P0"),U,3)                      ; dob (21)
 ;
 I $P(ABM("P0"),U,2)="M" S $P(ABMF(23),U,3)="X"   ; sex - male      (22)
 E  S $P(ABMF(23),U,4)="X"                        ; sex - female    (22)
 K ABM("P0"),ABM("P11")
 ;
 S (ABMV("X1"),ABMV("X2"),ABMV("X3"))=""
 D PAT^ABMDE1X
 D REMPL^ABMDE1X1
 D LOC^ABMDE1X1
 K ABME
 ;
LOC ;
 ; Location info
 S $P(ABMF(55),U)=$S($P(ABMV("X1"),U,2)]"":$P(ABMV("X1"),U,2),1:$P($P(ABMV("X1"),U),";",2))                                ; billing entity name  (48)
 S $P(ABMF(56),U)=$P(ABMV("X1"),U,3)       ; address              (48) 
 S ABMCSZ=$P(ABMV("X1"),"^",4)
 S $P(ABMF(57),U)=$P(ABMCSZ,",",1) ; City               (48)
 S ABMCSZ=$P(ABMCSZ,",",2)
 S $P(ABMF(57),U)=$P(ABMF(57),U)_", "_$P(ABMCSZ," ",2)  ; State         (48)
 S $P(ABMF(57),U)=$P(ABMF(57),U)_"  "_$P(ABMCSZ," ",4)  ; zip           (48)
 K ABMCSZ
 ;
 S $P(ABMF(60),U,3)=$P(ABMV("X1"),U,6)     ; SSN/TIN              (51)
 S $P(ABMF(61),U,1)=$P(ABMV("X1"),U,5)     ; Phone                (52)
 S ABMLOC=$P(ABMP("B0"),U,3)
 S ABMV("X1")=$G(^AUTTLOC(ABMLOC,0))
 S $P(ABMF(59),U)=$P(ABMV("X1"),U,12)           ;address            (56)
 S $P(ABMF(60),U,4)=$P(ABMV("X1"),U,13)         ;city               (56)
 S ABML=$P(ABMV("X1"),U,14)
 S $P(ABMF(60),U,4)=$P(ABMF(60),U,4)_", "_$P(^DIC(5,ABML,0),U,2)     ;state              (56)
 S $P(ABMF(60),U,4)=$P(ABMF(60),U,4)_"  "_$P(ABMV("X1"),U,15)         ;zip                (56)
 I $P($G(^AUTNINS(ABMP("INS"),0)),U)["DELTA DENTAL" D
 .S $P(ABMF(59),U)=$P($G(^DIC(4,ABMP("LDFN"),1)),U)  ;address  (56)
 .S $P(ABMF(60),U,4)=$P($G(^DIC(4,ABMP("LDFN"),1)),U,3)  ;city  (56)
 .S ABMX("STATE")=$P($G(^DIC(4,ABMP("LDFN"),0)),U,2)  ;state  (56)
 .S ABMX("STATE")=$P($G(^DIC(5,+ABMX("STATE"),0)),U,2)
 .I ABMX("STATE")'="" D
 ..S $P(ABMF(60),U,4)=$P(ABMF(60),U,4)_", "_ABMX("STATE")_" "_$P($G(^DIC(4,ABMP("LDFN"),1)),U,4)  ;zip  (56)
 ;
INSNUM ; 
 ; Insurer Information
 S ABM("INUM")=$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,$P(ABMP("B0"),U,7),0)),U,8)
 S:ABM("INUM")="" ABM("INUM")=$P($G(^AUTNINS(ABMP("INS"),15,ABMP("LDFN"),0)),U,2)
 I ABM("INUM")="" D
 .S ABMPRV=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,"C","A",0))
 .S:ABMPRV ABMPRV=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,ABMPRV,0)),U)
 .S:ABMPRV ABM("INUM")=$P($G(^VA(200,ABMPRV,9999999.18,ABMP("INS"),0)),U,2)
 S $P(ABMF(60),U)=ABM("INUM")            ; Dentist License     (54)
 S ABMP("ITYP")=$P($G(^AUTNINS(ABMP("INS"),2)),U)  ; Ins. type
 I ABMP("ITYP")="D" D
 .S ABMMCD=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMP("INS"),0)),U,6)
 ;
PRV ;
 ; Provider?
 S ABM("X")=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,"C","A",0))
 I ABM("X") D
 .D SELBILL^ABMDE4X
 .D PAYED^ABMERUTL
 .S $P(ABMF(55),U,2)=$P(ABM("A"),U)  ;  (53)
 .S $P(ABMF(55),U,3)=DT  ;  (53)
 .S $P(ABMF(60),U,2)=$$SLN^ABMEEPRV($P(ABM("A"),U,2))            ; Dentist License     (50)
 .S $P(ABMF(57),U,3)=$$SLN^ABMEEPRV($P(ABM("A"),U,2))  ;  (55)
 .S $P(ABMF(57),U,2)=ABM("PNUM")          ; Provider number  (49)
 .S $P(ABMF(61),U,2)=$P($G(^VA(200,$P(ABM("A"),U,2),.13)),"^",2)  ;office phone (57)
 .I $P(ABMF(61),U,2)="" S $P(ABMF(61),U,2)=$P($G(^AUTTLOC(ABMP("LDFN"),0)),"^",11)  ;location phone (57)
 .S $P(ABMF(61),U,3)=$$PTAX^ABMEEPRV($P(ABM("A"),U,2))  ;specialty (taxonomy code) (58)
 ;
POL ;
 ; Policy Information
 N I
 S I=0
 F  S I=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I)) Q:'I  D
 .I $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I,0),"^",3)="I" S ABM("XIEN")=I
 S Y=ABMP("INS")
 S ABMP("GL")="^ABMDBILL(DUZ(2),"_ABMP("BDFN")_","
 D SEL^ABMDE2X            ; ABMV("X2")           ; Policy holder info
 I ABM("ADD")["NON-BEN" D
 .S ABM("ADD")=ABMV("X2")
 S $P(ABMF(6),U)=$P($P(ABMV("X2"),U),";",2)     ; Subscriber name (12)
 S $P(ABMF(7),U)=$P(ABMV("X2"),U,3)             ; Address         (12)
 S ABMCSZ=$P(ABMV("X2"),"^",4)
 S $P(ABMF(8),U,2)=$P(ABMCSZ,",",1)     ; City            (12)
 S ABMCSZ=$P(ABMCSZ,",",2)
 S $P(ABMF(8),U,2)=$P(ABMF(8),U,2)_", "_$P(ABMCSZ," ",2) ; State           (12)
 S $P(ABMF(8),U,2)=$P(ABMF(8),U,2)_"  "_$P(ABMCSZ," ",4) ; Zip             (12)
 K ABMCSZ
 ;
 S $P(ABMF(11),U,$S($P(ABMV("X2"),U,6)="M":2,1:3))="X"  ; Sex      (14)
 S $P(ABMF(11),U,4)=$P(ABMV("X1"),U,4)             ; Emp. id         (15)
 ;
 S $P(ABMF(11),U)=$P(ABMV("X2"),U,7)     ; dob  (13)
 ;
 S ABMSTAT=$P($P(ABMV("X3"),U,5),";")
 I $P(ABMV("X3"),U)="STUDENT" D  ;check if marked as student
 . I ABMSTAT=1 S $P(ABMF(16),U,5)="X"  ;full-time student (19)
 . I ABMSTAT=2 S $P(ABMF(16),U,6)="X"  ;part-time student (19)
 ;
EMPL ;
 ; Employer information
 I ABMP("ITYP")'="P" S $P(ABMF(13),U,4)=$P(ABMV("X3"),U)             ; Employer name   (17)
 E  D
 .S ABMP("PH")=$P(ABMV("X2"),U)
 .S ABMEMPL=$P($G(^AUPN3PPH(+ABMP("PH"),0)),U,16)
 .S:+ABMEMPL $P(ABMF(13),U,4)=$P($G(^AUTNEMPL(ABMEMPL,0)),U)
 S $P(ABMF(13),U,3)=$P(ABMV("X3"),U,7)           ; Group number    (16)
 ;
REL ;
 ; Relationship
 G INS:'$P(ABMV("X2"),U,2)
 S ABM=+$P($G(^AUTTRLSH(+$P(ABMV("X2"),U,2),0)),U,2)
 I ABM,ABM<8,ABM'=2 S $P(ABMF(16),U,$S(ABM=1:1,1:4))="X"   ; Relationship to subscriber(18)
 E  S $P(ABMF(16),U,$S(ABM=2:2,ABM=1:1,1:4))="X"
 ;
INS ;
 ; Insurer Information
 S ABM("I")=0
 F  S ABM("I")=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"C",ABM("I"))) Q:'ABM("I")  D
 .S ABM=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"C",ABM("I"),0))
 .S ABM=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABM,0),U)
 .I ABM'=ABMP("INS") D  Q
 ..I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABM,0)),U,3)="U" Q
 ..S Y=ABM
 ..S ABMP("GL")="^ABMDBILL(DUZ(2),"_ABMP("BDFN")_","
 ..D SEL^ABMDE2X
 ..S $P(ABMF(15),U)=$P(ABMV("X3"),U)                   ; (5)
 ..S $P(ABMF(17),U)=$P(ABMV("X2"),U,7)         ; (6)
 ..;
 ..S $P(ABMF(13),U,2)="X"          ; Other coverage        (4)
 S:$P($G(ABMF(13)),U,2)="" $P(ABMF(13),U)="X"    ; No other coverage (4)
 S $P(ABMF(2),U)="X"   ;statement of actual services (1)
 I $P($G(^AUTNINS(ABMP("INS"),2)),"^")="D" S $P(ABMF(3),U)="X"  ;EPSDT/Title 19 (1)
 ;
BNODES ;
 ; Bill nodes
 I $D(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)) D
 .S ABM("B4")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),4))
 .S ABM("B5")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),5))
 .S ABM("B7")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7))
 .S ABM("B8")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8))
 .S ABM("B9")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9))
 ;
 S $P(ABMF(5),U)=$P(ABM("B5"),U,8)           ; Prior Auth         (2)
 I $P(ABM("B9"),U)]"" S $P(ABMF(50),U,3)="X"  ;Occupational illness (45)
 ;
ACCD ;
 ; Accident?
 I $P(ABM("B8"),U,3)'="" D
 .I "12"[$P(ABM("B8"),U,3) D  Q
 ..S $P(ABMF(50),U,4)="X"                       ; auto accident  (45)
 ..S $P(ABMF(51),U)=$P(ABM("B8"),U,2)   ;accident date (46)
 ..S $P(ABMF(51),U,2)=$P($G(^DIC(5,$P(ABM("B8"),U,16),0)),"^",2)  ;accident state (47)
 .I "5"[$P(ABM("B8"),U,3) D  Q
 ..S $P(ABMF(50),U,5)="X"                        ; other accident (45)
 .S $P(ABMF(51),U)=$P(ABM("B8"),U,2)   ;accident date (46)
 .S $P(ABMF(51),U,2)=$P($G(^DIC(5,$P(ABM("B8"),U,16),0)),"^",2)  ;accident state (47)
 ;
 ;
FSYM ;
 I $P(ABM("B7"),U,4)="Y" D                      ; Release of Info
 .S $P(ABMF(46),U)="SIGNATURE ON FILE"                             ;  (36)
 .S $P(ABMF(46),U,2)=DT                                      ;  (36)
 I $P(ABM("B7"),U,5)="Y" D                      ; Assignment of Benefits
 .S $P(ABMF(50),U)="SIGNATURE ON FILE"                     ;  (37)
 .S $P(ABMF(50),U,2)=DT                                      ;  (37)
 S $P(ABMF(44),U,4)="X"                        ; office place of tx (38)
 S $P(ABMF(44),U,5)=$P($G(ABM("B4")),U,3)     ;Radiographs (39)
 S $P(ABMF(44),U,6)=$P($G(ABM("B9")),U,18)    ;Oral Images (39)
 S $P(ABMF(44),U,7)=$P($G(ABM("B9")),U,19)     ;Models (39)
 ;
XRAY ;
 ; Number of X-rays included
 ;
ORTHO ;
 ; Orthodontic Related?
 S $P(ABMF(46),U,$S($P(ABM("B4"),U,4):4,1:3))="X"                ;  (40)
 ; Orthodontic Placement Date
 I $P(ABM("B4"),U,4) S $P(ABMF(46),U,5)=$P(ABM("B4"),U,5)        ;  (41)
 ;
PROTH ;
 ; Prothesis Included?
 S $P(ABMF(48),U,$S($P(ABM("B4"),U,6):3,1:2))="X"                ;  (43)
 ; Prior Placement Date
 I $P(ABM("B4"),U,6) S $P(ABMF(48),U,4)=$P(ABM("B4"),U,7)          ;  (44)
 ;
 S ABMBIL=$P(ABMP("B0"),U)                       ; Bill number
 S ABMSFX=$P($G(^ABMDPARM(DUZ(2),1,2)),U,4)    ; Bill Number suffix
 S ABMAHRN=$P($G(^ABMDPARM(DUZ(2),1,1,3)),U,3)   ; Append HRN?
 S ABMHRN=$P($G(^AUPNPAT(ABMP("PDFN"),41,ABMP("LDFN"),0)),U,2)  ; HRN
 S $P(ABMF(23),U,5)=ABMBIL_"-"_ABMSFX_" "_ABMHRN  ;Patient ID (23)
 I $D(^ABMDBILL(DUZ(2),ABMP("BDFN"),61,0)) D
 .S ABMIEN=0
 .S ABMLINE=41
 .F  S ABMIEN=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),61,ABMIEN)) Q:+ABMIEN=0!(ABMLINE>43)  D
 ..S ABMF(ABMLINE)=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),61,ABMIEN,0))
 ..S ABMLINE=ABMLINE+1
 ;
XIT ;
 K ABM,ABMV
 Q
