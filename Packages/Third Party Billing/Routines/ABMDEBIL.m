ABMDEBIL ; IHS/ASDST/DMJ - Move Claim Data to Bill File ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**6,8**;NOV 12, 2009
 ;
 ; IHS/ASDS/DMJ - 06/11/01 v2.4 p5 - NOIS NEA-0601-180026
 ;     Modified to correct problem with lock table filling up
 ; IHS/ASDS/LSL - 10/09/01 - V2.4 Patch 9 - NOIS NDA-1001-180040
 ;     Allow all lines of remarks to pass from the claim to the bill
 ;
 ; IHS/SD/SDR - v2.5 p8 - IM15307/IM14092 - Put fix to bring MSP Reason onto bill from Pat Reg at time of approval
 ; IHS/SD/EFG - V2.5 P8 - IM16385 - Allows all charges to come over
 ; IHS/SD/SDR - v2.5 p8 - task 6 - Added code for new ambulance multiple 47
 ; IHS/SD/SDR - v2.5 p9 - IM16891 - Display bill number when approved
 ; IHS/SD/SDR - v2.5 p9 - IM16058 - allow approval of bill type 110
 ; IHS/SD/SDR - v2.5 p10 - IM20338 - Bring over 19 multiple to bill
 ; IHS/SD/SDR - v2.5 p12 - UFMS - Added call to populate UFMS Cashiering Sessions will approved bill number
 ;
 ; IHS/SD/SDR - abm*2.6*6 - Added code to populate LINE ITEM CONTROL NUMBER
 ; IHS/SD/SDR - abm*2.6*6 - Added code to populate OTHER BILL IDENTIFIER
 ; *********************************************************************
 K ^ABMDCLM(DUZ(2),ABMP("CDFN"),65),ABMFORM
 N I F I=1:1:10 D
 .S ABMPAGE=$P("27^21^25^23^37^35^39^43^33^45^47","^",I)
 .S ABMFORM(ABMPAGE)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),70)),"^",I)
 .S:ABMFORM(ABMPAGE)="" ABMFORM(ABMPAGE)=ABMP("EXP")
 S ABMB("EXP")=0
 F  S ABMB("EXP")=$O(ABMP("EXP",ABMB("EXP"))) Q:'ABMB("EXP")  D GEN:ABMP("EXP",ABMB("EXP"))!($P(ABMP("EXP",ABMB("EXP")),U,2)="Y")!(ABMP("BTYP")=110) Q:$G(ABMB("OUT"))
 G XIT
 ;
 ; *********************************************************************
GEN ;
 K ABMP("BDFN"),ABMP("OVER")
 S ABMB=ABMP("CDFN")
 S ABMB("Y")="A"
 S ABMB("OUT")=0
 F  Q:'$D(^ABMDBILL(DUZ(2),"B",ABMB_ABMB("Y")))  S ABMB("Y")=$C($A(ABMB("Y"))+1)
 S X=ABMB_ABMB("Y")
 S DIC="^ABMDBILL(DUZ(2),"
 S DIC(0)="L"
 K DD,DO
 K Y
 D FILE^DICN
 I +Y<1 D  Q
 . D MSG^ABMERUTL("ERROR: BILL NOT CREATED, ensure your Fileman ACCESS CODE contains a 'V'.")
 . S ABMB("OUT")=1
 L +^ABMDBILL(DUZ(2),+Y):1 I '$T D MSG^ABMERUTL("ERROR: Bill File is Locked by another User, Try Later!") Q
 S ABMP("BDFN")=+Y
 S ^ABMDTMP(ABMP("CDFN"),+Y)=X_U_$H
 ;
MOVE ;
 S ABMB("Y")="^ABMDBILL(DUZ(2),"_ABMP("BDFN")_","
 S ABMB("X")="ABMDCLM("_DUZ(2)_","_ABMP("CDFN")
 S ABMB="^"_ABMB("X")_")"
 F  S ABMB=$Q(@ABMB) Q:ABMB'[ABMB("X")  D
 .S ABMB("Z")=ABMB("Y")_$P($P(ABMB,"(",2),",",3,99)
 .S ABMB("OLDDATA")=@ABMB D
 ..I ABMB("OLDDATA")'["9002274.3" D  Q
 ... S ABMB("NEWDATA")=ABMB("OLDDATA")
 ..F I=1:1:$L(ABMB("OLDDATA"),"9002274.3") S $P(ABMB("NEWDATA"),"9002274.4",I)=$P(ABMB("OLDDATA"),"9002274.3",I)
 .S ABMB("C")=+$P($P(ABMB,"(",2),",",3,99)
 .I ABMB("C")<17!(ABMB("C")=41) D  Q
 ..S @ABMB("Z")=ABMB("NEWDATA")
 .;I $P(^ABMDEXP(ABMB("EXP"),0),U)'["UB",ABMB("C")>50,ABMB("C")<59 Q  ;abm*2.6*6
 .I $G(ABMFORM(ABMB("C"))),ABMFORM(ABMB("C"))'=ABMB("EXP") Q
 .I ABMB("C")=69 Q  ;not merge open/close status
 .S @ABMB("Z")=ABMB("NEWDATA")
 ;
BIL ;
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U)=X
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,4)="A"
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,5)=ABMP("PDFN")
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,6)=ABMB("EXP")
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,9)=ABMP("PX")
 S ABMAPOK=1
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,2)=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,12)
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,10)=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,6)
 D NOW^%DTC
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),1),U,4)=DUZ
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),1),U,5)=%
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),2),U)=+ABMP("EXP",ABMB("EXP"))
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),2),U,3)=ABMP("TOT")
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),2),U,5)=+$FN(+^ABMDBILL(DUZ(2),ABMP("BDFN"),2),"",2)
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),2),U,2)=$P($G(^AUTNINS(ABMP("INS"),2)),U)
 S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),2),U,7)=(+$G(ABMP("OBAMT")))
 S:+$G(ABMP("FLAT"))'=0 $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),2),U,8)=$P(+ABMP("FLAT"),U)
 I "FHM"[$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),2)),U,2) S $P(^(2),U,2)="P"
 ;start new code abm*2.6*6 NOHEAT
 S ABM("BLNM")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U)
 I $P($G(^ABMDPARM(ABMP("LDFN"),1,2)),"^",4)]"" S ABM("BLNM")=ABM("BLNM")_"-"_$P(^(2),"^",4)
 I $P($G(^ABMDPARM(ABMP("LDFN"),1,3)),"^",3)=1 D
 .S ABM("HRN")=$P($G(^AUPNPAT(ABMP("PDFN"),41,ABMP("LDFN"),0)),"^",2)
 .S:ABM("HRN")]"" ABM("BLNM")=ABM("BLNM")_"-"_ABM("HRN")
 I $L(ABM("BLNM")>14) S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),1),U,15)=$E(ABM("BLNM"),1,14)
 ;end new code abm*2.6*6 NOHEAT
 ;start new code abm*2.6*6
 ;line iten control number
 S ABMBN=$$FMT^ABMERUTL(ABMP("BDFN"),"12NR")
 I $G(ABMP("FLAT"))'="" D
 .S DIE="^ABMDBILL("_DUZ(2)_","
 .S DA=ABMP("BDFN")
 .S DR=".29////"_ABMBN_"000000"
 .D ^DIE
 I $G(ABMP("FLAT"))="" D
 .K DIC,DIE,DA,DR,X,Y
 .F ABMI=21,23,25,27,33,35,37,39,43,45,47 D
 ..S ABMLNNUM=1
 ..S DA(1)=ABMP("BDFN")
 ..S ABMIEN=0
 ..F  S ABMIEN=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),ABMI,ABMIEN)) Q:'ABMIEN  D
 ...S ABMLNNUM=$$FMT^ABMERUTL(ABMLNNUM,"4NR")
 ...S DA=ABMIEN
 ...S DIE="^ABMDBILL("_DUZ(2)_","_DA(1)_","_ABMI_","
 ...S DR="21////"_ABMBN_ABMI_ABMLNNUM
 ...D ^DIE
 ...S ABMLNNUM=+$G(ABMLNNUM)+1
 ;end new code
 S DA=ABMP("BDFN")
 S DIK="^ABMDBILL(DUZ(2),"
 D IX1^DIK
 I $P($G(^AUTNINS(ABMP("INS"),2)),U)="I" D
 .S DIE="^ABMDBILL(DUZ(2),"
 .S DR=".04////C"
 .D ^DIE
 I $P($G(^AUTNINS(ABMP("INS"),2)),U,2)]"","YN"'[$P(^(2),U,2) D
 .S DIE="^AUTNINS("
 .S DA=ABMP("INS")
 .S DR=".22////"_$S($D(^ABMNINS(DUZ(2),DA,1,ABMP("VTYP"),11)):"Y",1:"")
 .D ^DIE
 I $G(ABMMSPRS)'="" D  ;MSP reason
 .S ABMMSPR=$S(ABMMSPRS="E":12,ABMMSPRS="L":43,ABMMSPRS="V":42,ABMMSPRS="W":15,ABMMSPRS="B":41,1:"14")
 .S $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),12),U)=ABMMSPR
 S (DINUM,X)=ABMP("BDFN")
 S DA(1)=ABMP("CDFN")
 S DIC="^ABMDCLM(DUZ(2),"_DA(1)_",65,"
 S DIC(0)="LE"
 S DIC("P")=$P(^DD(9002274.3,65,0),U,2)
 K DD,DO
 D FILE^DICN
 K DIC
 ;
REM ;REMARKS
 D MSG^ABMERUTL("Bill Number "_$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U)_" Created.  (Export Mode: "_$P(^ABMDEXP(ABMB("EXP"),0),U)_")")
 L -^ABMDBILL(DUZ(2),ABMP("BDFN"))
 D ADDBENTR^ABMUCUTL("ABILL",ABMP("BDFN"))  ;add bill to UFMS Cash. Session
 Q:$D(^ABMDBILL(DUZ(2),ABMP("BDFN"),61))
 N I
 F I=1:1:4 D
 .Q:'$D(^ABMDEXP(ABMP("EXP"),2,I,0))
 .S ^ABMDBILL(DUZ(2),ABMP("BDFN"),61,I,0)=^ABMDEXP(ABMP("EXP"),2,I,0)
 .S ^ABMDBILL(DUZ(2),ABMP("BDFN"),61,0)="^^"_I_"^"_I_"^"_DT
 Q
 ;
 ; *********************************************************************
XIT ;
 K ABMB,ABMS,ABMX,ABMFORM,ABMAPOK
 Q
