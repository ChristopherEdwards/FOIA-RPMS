ABMDF18A ; IHS/ASDST/DMJ - ADA Dental Export -part 2 ;    
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;08/13/96 11:47 AM
 ;
 ; IHS/ASDS/LSL - 06/26/00 - Patch 3 - NOIS DXX-0600-140080
 ;     Routine created (required by Wisconsin Medicaid 7/1/00)
 ;
 ; IHS/ASDS/SDH - 03/14/01 - V2.4 Patch 9 - NOIS NEA-0301-180042
 ;     Correct ADA-94 form to print address of patient instead of
 ;     NON-BENEFICIARY Insurer.
 ;
 ; IHS/ASDS/SDH - 7/20/2001 - V2.4 Patch 9 - NOIS QAA-0601-130017
 ;     Modified code to print location of service as the site, not
 ;     where the bills are going.  This was a problem because of
 ;     payments going to PNC.  This affects form locator 40.
 ;
 ; IHS/SD/SDR - V2.5 P2 - NOIS XXX-0302-200036
 ;     Modified to print HRN with bill number
 ;
 ; IHS/SD/SDR - V2.5 P3 - 2/27/2003
 ;     Modified to check if marked as accident
 ;
 ; IHS/SD/SDR - v2.5 p8 - IM12859
 ;    Added code to look for Dentist License Number
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20337
 ;   Added code for 9F
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM21043
 ;   Changed treatment address to physical address
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
 S ABMF(2)="^"_$P(ABM("ADD"),U,1)                ; Ins Name (3)
 S ABMF(4)="^"_$P(ABM("ADD"),U,2)                ; Address  (4)
 S $P(ABMF(5),U,3)=$P(ABMCSZ,"^",1)    ; City     (5)
 S ABMSTATE=$P(ABMCSZ,"^",2)           ; State    (6)
 S $P(ABMF(5),U,4)=$P($G(^DIC(5,+ABMSTATE,0)),"^",2)
 S $P(ABMF(5),U,5)=$P(ABMCSZ,"^",3)  ; Zip      (7)
 K ABMCSZ,ABMSTATE
 ;
PAT ;
 ; Patient Information
 S ABM("P0")=^DPT(ABMP("PDFN"),0)                ; 0 node patient file
 S ABMF(7)=$P(ABM("P0"),U)                       ; Name     (8)
 S ABM("P11")=$G(^DPT(ABMP("PDFN"),.11))
 S $P(ABMF(7),U,2)=$P(ABM("P11"),U)              ; Mailing address (9)
 S $P(ABMF(7),U,3)=$P(ABM("P11"),U,4)            ; Mailing - city  (10)
 S $P(ABMF(7),U,4)=$P(^DIC(5,$P(ABM("P11"),U,5),0),U,2) ; Mailing - State (11)
 S ABMDOB=$P(ABM("P0"),U,3)                      ; dob
 S $P(ABMF(9),U)=$E(ABMDOB,4,5)                  ; dob - month     (12)
 S $P(ABMF(9),U,2)=$E(ABMDOB,6,7)                ; dob - day       (12)
 S $P(ABMF(9),U,3)=($E(ABMDOB,1,3)+1700)         ; dob - yr        (12)
 I $P(ABM("P0"),U,2)="M" S $P(ABMF(9),U,5)="X"   ; sex - male      (14)
 E  S $P(ABMF(9),U,6)="X"                        ; sex - female    (14)
 S $P(ABMF(9),U,7)=$P($G(^DPT(ABMP("PDFN"),.13)),U) ; phone        (15)
 S $P(ABMF(9),U,8)=$P(ABM("P11"),U,6)            ; zip             (16)
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
 S $P(ABMF(28),U)=$S($P(ABMV("X1"),U,2)]"":$P(ABMV("X1"),U,2),1:$P($P(ABMV("X1"),U),";",2))                                ; billing entity name  (42)
 S $P(ABMF(30),U)=$P(ABMV("X1"),U,3)       ; address (46) 
 S ABMCSZ=$P(ABMV("X1"),"^",4)
 S $P(ABMF(32),U)=$P(ABMCSZ,",",1) ; City (50)
 S ABMCSZ=$P(ABMCSZ,",",2)
 S $P(ABMF(32),U,2)=$P(ABMCSZ," ",2)  ; State  (51)
 S $P(ABMF(32),U,3)=$P(ABMCSZ," ",4)  ; zip (52)
 K ABMCSZ
 S $P(ABMF(28),U,4)=$P(ABMV("X1"),U,6)     ; SSN/TIN (45)
 S $P(ABMF(28),U,2)=$P(ABMV("X1"),U,5)     ; Phone (43)
 S ABMLOC=$P(ABMP("B0"),U,3)
 S ABMV("X1")=$G(^AUTTLOC(ABMLOC,0))
 S $P(ABMF(58),U)=$P(ABMV("X1"),U,12)           ;address (63)
 S $P(ABMF(60),U)=$P(ABMV("X1"),U,13)         ;city (64)
 S ABML=$P(ABMV("X1"),U,14)
 S $P(ABMF(60),U,2)=$P(^DIC(5,ABML,0),U,2)     ;state (65)
 S $P(ABMF(60),U,3)=$P(ABMV("X1"),U,15)         ;zip (66)
 I $P($G(^AUTNINS(ABMP("INS"),0)),U)["DELTA DENTAL" D
 .S $P(ABMF(58),U)=$P($G(^DIC(4,ABMP("LDFN"),1)),U)  ;address  (63)
 .S $P(ABMF(60),U)=$P($G(^DIC(4,ABMP("LDFN"),1)),U,3)  ;city  (64)
 .S ABMX("STATE")=$P($G(^DIC(4,ABMP("LDFN"),0)),U,2)  ;state  (65)
 .S $P(ABMF(60),U,2)=$P($G(^DIC(5,+ABMX("STATE"),0)),U,2)
 .S $P(ABMF(60),U,3)=$P($G(^DIC(4,ABMP("LDFN"),1)),U,4)  ;zip  (66)
 ;
INSNUM ; 
 ; Insurer Information
 S ABM("INUM")=$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,$P(ABMP("B0"),U,7),0)),U,8)
 S:ABM("INUM")="" ABM("INUM")=$P($G(^AUTNINS(ABMP("INS"),15,ABMP("LDFN"),0)),U,2)
 I ABM("INUM")="" D
 .S ABMPRV=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,"C","A",0))
 .S:ABMPRV ABMPRV=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,ABMPRV,0)),U)
 .S:ABMPRV ABM("INUM")=$P($G(^VA(200,ABMPRV,9999999.18,ABMP("INS"),0)),U,2)
 S $P(ABMF(28),"^",3)=ABM("INUM")
 S $P(ABMF(30),U,2)=ABM("INUM")            ; Dentist License (47)
 S ABMP("ITYP")=$P($G(^AUTNINS(ABMP("INS"),2)),U)  ; Ins. type
 I ABMP("ITYP")="D" D
 .S ABMMCD=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMP("INS"),0)),U,6)
 .S:+ABMMCD $P(ABMF(9),U,4)=$P($G(^AUPNMCD(ABMMCD,0)),U,3) ; mcd # (13)
 ;
PRV ;
 ; Provider?
 S ABM("X")=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,"C","A",0))
 I ABM("X") D
 .D SELBILL^ABMDE4X
 .D PAYED^ABMERUTL
 .S ABMF(59)=$P(ABM("A"),U)_U_ABM("PNUM")_U_DT  ;  (62)
 .S ABMF(51)=$G(ABMP("PAYED"))            ; Payment by other plans 
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
 .S ABMF(2)="^^"_$P($P(ABM("ADD"),U),";",2)
 .S ABMF(3)="^"_$P(ABM("ADD"),U,3)
 .S ABMF(4)="^^"_$P(ABM("ADD"),U,4)
 S $P(ABMF(15),U)=$P($P(ABMV("X2"),U),";",2)     ; Subscriber name (22)
 S $P(ABMF(17),U)=$P(ABMV("X2"),U,3)             ; Address   (23)
 S $P(ABMF(17),U,2)=$P(ABMV("X2"),U,5)           ; Phone  (24)
 S ABMCSZ=$P(ABMV("X2"),"^",4)
 S $P(ABMF(19),U)=$P(ABMCSZ,",",1)     ; City  (25)
 S ABMCSZ=$P(ABMCSZ,",",2)
 S $P(ABMF(19),U,2)=$P(ABMCSZ," ",2) ; State (26)
 S $P(ABMF(19),U,3)=$P(ABMCSZ," ",4) ; Zip (27)
 K ABMCSZ
 S $P(ABMF(21),U,$S($P(ABMV("X2"),U,6)="M":7,1:8))="X"  ; Sex (30)
 S $P(ABMF(13),U)=$P(ABMV("X1"),U,4)             ; Emp. id (19)
 S $P(ABMF(21),U)=$E($P(ABMV("X2"),U,7),4,5)     ; dob - month (28)
 S $P(ABMF(21),U,2)=$E($P(ABMV("X2"),U,7),6,7)   ; dob - day (28)
 S $P(ABMF(21),U,3)=($E($P(ABMV("X2"),U,7),1,3)+1700)  ; dob - yr (28)
 S ABMSTAT=$P($P(ABMV("X3"),U,5),";")
 I ABMSTAT=1 S $P(ABMF(21),U,9)="X"            ; Employed full time (38)
 I ABMSTAT=2 S $P(ABMF(21),U,10)="X"           ; Employed parttiime (38)
 I "12"[ABMSTAT S $P(ABMF(22),U)=$P(ABMV("X3"),U,6)  ; Employer     (40)
 ;
EMPL ;
 ; Employer information
 S $P(ABMF(13),U,2)=$P(ABMV("X3"),U)             ; Employer name (20)
 S $P(ABMF(13),U,3)=$P(ABMV("X3"),U,7)           ; Group number (21)
 ;
REL ;
 ; Relationship
 G INS:'$P(ABMV("X2"),U,2)
 S ABM=+$P($G(^AUTTRLSH(+$P(ABMV("X2"),U,2),0)),U,2)
 I ABM,ABM<8,ABM'=2 S $P(ABMF(11),U,$S(ABM=1:1,1:3))="X"   ; (17)
 E  S $P(ABMF(11),U,$S(ABM=2:2,1:4))="X"
 ;
INS ;
 ; Insurer Information
 S ABM("I")=0
 F  S ABM("I")=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"C",ABM("I"))) Q:'ABM("I")  D
 .S ABM=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"C",ABM("I"),0))
 .S ABM=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABM,0),U)
 .I ABM'=ABMP("INS") D  Q
 ..I "U"[$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABM,0)),U,3) Q
 ..S Y=ABM
 ..S ABMP("GL")="^ABMDBILL(DUZ(2),"_ABMP("BDFN")_","
 ..D SEL^ABMDE2X
 ..S $P(ABMF(17),U,3)=$E($P(ABMV("X2"),U,7),4,5)         ; (34)
 ..S $P(ABMF(17),U,4)=$E($P(ABMV("X2"),U,7),6,7)         ; (34)
 ..S $P(ABMF(17),U,5)=($E($P(ABMV("X2"),U,7),1,3)+1700)  ; (34)
 ..I $P($G(^AUTNINS(ABM,2)),U,5)="O" S $P(ABMF(13),U,6)="X" ; den (31)
 ..E  S $P(ABMF(13),U,7)="X"       ; Other Medical (31)
 ..S $P(ABMF(13),U,5)="X"          ; Other coverage (31)
 S:$P(ABMF(13),U,5)="" $P(ABMF(13),U,4)="X"    ; No other coverage (31)
 ;
BNODES ;
 ; Bill nodes
 I $D(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)) D
 .S ABM("B4")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),4))
 .S ABM("B5")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),5))
 .S ABM("B7")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7))
 .S ABM("B8")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8))
 .S ABM("B9")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9))
 S $P(ABMF(5),U,2)=$P(ABM("B5"),U,8)           ; Prior Auth  (2)
 I $P(ABM("B9"),U)]"" S $P(ABMF(34),U,2)="X"
 E  S $P(ABMF(34),U)="X"
 ;
ACCD ;
 ; Accident?
 I $P(ABM("B8"),U,3)'="" D
 .I "12"[$P(ABM("B8"),U,3) D  Q
 ..S $P(ABMF(34),U,3)="X"                       ; auto accident  (57)
 .I "5"[$P(ABM("B8"),U,3) D  Q
 ..S $P(ABMF(34),U,4)="X"                        ; other accident (57)
 .S $P(ABMF(34),U,5)="X"                          ; neither  (57)
 ;
FSYM ;
 S $P(ABMF(30),U,3)=$P(ABM("B8"),U,6)           ; 1st date series(48)
 I $P(ABM("B7"),U,4)="Y" D                      ; Release of Info
 .S ABMF(25)="SIGNATURE ON FILE"                             ;  (39)
 .S $P(ABMF(25),U,2)=DT                                      ;  (39)
 I $P(ABM("B7"),U,5)="Y" D                      ; Assignment of Benefits
 .S $P(ABMF(25),U,3)="SIGNATURE ON FILE"                     ;  (41)
 .S $P(ABMF(25),U,4)=DT                                      ;  (41)
 S $P(ABMF(30),U,4)="X"                        ; office place of tx (49)
 ;
XRAY ;
 ; Number of X-rays included
 S $P(ABMF(31),U,$S($P(ABM("B4"),U,3):1,1:3))="X"                ;  (53)
 S $P(ABMF(31),U,3)=$P(ABM("B4"),U,3)                            ;  (53)
 ;
ORTHO ;
 ; Orthodontic Related?
 S $P(ABMF(31),U,$S($P(ABM("B4"),U,4):4,1:5))="X"                ;  (54)
 ; Orthodontic Placement Date
 I $P(ABM("B4"),U,4) S $P(ABMF(33),U,5)=$P(ABM("B4"),U,5)        ;  (54)
 ;
PROTH ;
 ; Prothesis Included?
 S $P(ABMF(33),U,$S($P(ABM("B4"),U,6):1,1:2))="X"                ;  (55)
 ; Prior Placement Date
 I $P(ABM("B4"),U,6) S $P(ABMF(36),U)=$P(ABM("B4"),U,7)          ;  (55)
 S ABMBIL=$P(ABMP("B0"),U)                       ; Bill number
 S ABMSFX=$P($G(^ABMDPARM(DUZ(2),1,2)),U,4)    ; Bill Number suffix
 S ABMAHRN=$P($G(^ABMDPARM(DUZ(2),1,1,3)),U,3)   ; Append HRN?
 S ABMHRN=$P($G(^AUPNPAT(ABMP("PDFN"),41,ABMP("LDFN"),0)),U,2)  ; HRN
 S $P(ABMF(53),U)="Bill Number: "_ABMBIL_"-"_ABMSFX_" "_ABMHRN  ;Comments (61)
 I +ABMAHRN,+ABMHRN S $P(ABMF(55),U)=$P(ABMF(55),U)_+ABMHRN
 I $D(^ABMDBILL(DUZ(2),ABMP("BDFN"),61,0)) D
 .S ABMIEN=0
 .S ABMLINE=54
 .F  S ABMIEN=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),61,ABMIEN)) Q:+ABMIEN=0!(ABMLINE>56)  D
 ..S ABMF(ABMLINE)=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),61,ABMIEN,0))
 ..S ABMLINE=ABMLINE+1
 ;
XIT ;
 K ABM,ABMV
 Q
