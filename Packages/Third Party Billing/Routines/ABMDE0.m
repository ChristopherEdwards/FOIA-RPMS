ABMDE0 ; IHS/ASDST/DMJ - Claim Summary Page ; 10 Nov 2009  2:48 PM
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/ASDS/LSL - 08/13/2001 - V2.4 Patch 9 NOIS HQW-0798-100082
 ;     If all insurers are unbillable - ask if delete claim
 ;
 ; IHS/SD/SDR - v2.5 p8 - Fix supplied by Carlene McIntyre for
 ;    OmniCell link
 ;
 ; IHS/SD/SDR,TPF - v2.5 p8 - added code for pending status (12)
 ;
 ; IHS/SD/SDR - v2.5 p8 - task 57
 ;   Added code for Rx changes (dt disc. and RTS)
 ;
 ; IHS/SD/SDR - v2.5 p8 - task 5
 ;   Added code for CLIA number to populate on claims if none on
 ;   claim and default is present
 ;
 ; IHS/SD/SDR - v2.5 p9 - per Adrian
 ;    Only display meds check if claim status isn't Uneditable or
 ;    Complete
 ;
 ; IHS/SD/SDR - v2.5 p11 - IM22787
 ;    Modified so future term date for replacement insurer will work
 ;
 ; *********************************************************************
 ;
OPT K ABM,ABMV,ABME,ABMZ
 G XIT:$D(ABMP("DDL")),CONT:$G(ABMP("OPT"))="V"
 W !!?15,"...<< Processing, Claim Error Checks >>..."
 S ABMP("GL")="^ABMDCLM(DUZ(2),"_ABMP("CDFN")_","
 S ABMC("QUE")=2
 S ABMC("E0")=""
 D ERRIN^ABMDECK
 D ^ABMDE1X
 D TPICHECK^ABMDE1
 N I F I=106,107,108,10,102,12,13,6,151,152,153,109 D
 . Q:'$D(ABME(I))
 . S ABMP("JUMP1")=0
 K ABME,ABMC,ABMP("CHK"),ABMP("DDL")
 G CONT:$P($G(ABMP("STATUS")),U)=1
 D PCC
 G:$G(ABMNOPCC) XIT
 D ELIG
 G:$G(ABMNOELG) XIT
 S $P(ABMP("STATUS"),U)=1
 D D2^ABMDE8X  ;build array of Rxs from V Med file/23 multiple
 ;this checks to see if drugs are RTS or discontinued
 S ABMRXIEN=0,ABMRXFLG=0
 F  S ABMRXIEN=$O(ABMMEDS(ABMRXIEN)) Q:+ABMRXIEN=0  D  Q:ABMRXFLG=1
 .I $P($G(ABMMEDS(ABMRXIEN)),U,3)'="",('$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,"B",ABMRXIEN))) S ABMRXFLG=1
 .I $P($G(ABMMEDS(ABMRXIEN)),U,4)'="",('$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,"B",ABMRXIEN))) S ABMRXFLG=1
 I ABMRXFLG=1 D PUTMEDS
 D D2^ABMDE8X
 ;
CONT ; EP
 D OPEN^ABMDTMS(+$G(ABMP("PDFN")),+$G(ABMP("CDFN")))  ;OmniCell call
 D CLIACHK
 D ^ABMDE0X
 W $$EN^ABMVDF("IOF")
 S ABMP("OPT")="VCFNJQ"
 I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,4)="U"!($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,4)="X") D
 . S ABMP("OPT")="VNJQ"
 . S ABMP("DFLT")="Q"
 . S ABMP("VIEWMODE")=1
 D DISP^ABMDE0A
 W !
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,4)="P" D
 .W !
 .W "Pending for "
 .W $P($G(^ABMPSTAT($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,18),0)),U)  ;status
 .W " by "_$P($G(^VA(200,$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,19),0)),U,2)  ;new person inits
 .W !
 D SEL^ABMDEOPT
 I "CFV"'[$E(Y) G XIT
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 K ABM,ABMZ
 I $E(X)="V" D  G OPT
 . D ^ABMDECK
 . S ABMP("SCRN")=0
 . K DUOUT,DTOUT,DIRUT,DIROUT
 . S ABMP("OPT")="V"
 I $E(X)="C"!($E(X)="A") D ^ABMDEOK G XIT:$D(ABMP("OVER")),OPT
 I $E(X)="F" D  S Y="Q" G XIT
 .D EN^ABMSTAT($G(ABMP("CDFN")))
 .S ABMP("SCRN")=0
 .K DUOUT,DTOUT,DIRUT,DIROUT
 .S ABMP("OPT")="V"
 ;
XIT ;
 I $G(ABMP("JUMP1")) D
 . S ABMP("SCRN")=1
 . K ABMP("JUMP1")
 K ABM,ABMV,ABME,ABMZ
 Q
 ;
 ; *********************************************************************
ELIG ;EP - CHECK ELIGIBILITY
 K ABMNOELG
 W !!?8,"...<< Checking Eligibility Files for Potential Coverage >>...",!!
 D ^ABMDE2E
 N INSGOOD,INS
 S (INSGOOD,INS)=0
 F  S INS=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,INS)) Q:'+INS  D
 . S:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,INS,0)),U,3)'="U" INSGOOD=1
 I '+INSGOOD D
 . D ^ABMDE0X
 . D DISP^ABMDE0A
 . W !?3,$$EN^ABMVDF("RVN"),"NOTE:",$$EN^ABMVDF("RVF")
 . W " CANNOT OPEN CLAIM - NO ELIGIBILITY FOUND FOR THIS PATIENT.",!
 . D ENT2^ABMDECAN
 . S Y="Q"
 . S ABMNOELG=1
 Q
PCC ;check pcc primary visit         
 K ABMNOPCC
 Q:'$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,"AC","P"))
 N I
 S I=0
 F  S I=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,"AC","P",I)) Q:'I  D
 .Q:$P($G(^AUPNVSIT(I,0)),"^",11)
 .S ABMPRI=I
 Q:$G(ABMPRI)
 D ^ABMDE0X
 D DISP^ABMDE0A
 W !?3,$$EN^ABMVDF("RVN"),"NOTE:",$$EN^ABMVDF("RVF")
 W " THE PRIMARY PCC VISIT FOR THIS CLAIM HAS BEEN DELETED.",!
 D ENT2^ABMDECAN
 S Y="Q"
 S ABMNOPCC=1
 Q
PUTMEDS ;
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,4)="C"!($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,4)="U") Q
 W !!,"             * * * * * * M E D I C A T I O N  A L E R T * * * * * *"
 W !!
 K DD,DO,DIE,DIC,DIR
 S DIR("A")="DO YOU WISH TO INCLUDE THOSE ENTRIES ON PAGE 8D"
 S DIR("A",1)="MEDICATIONS WITH A 'DATE DISCONTINUED' OR 'RETURN TO STOCK' ENTRY HAVE BEEN"
 S DIR("A",2)="IDENTIFIED."
 S DIR("A",3)=""
 S DIR(0)="Y"
 S DIR("B")="N"
 D ^DIR K DIR
 I Y=1 D
 .S ABMRXFLG=1
 .S ABMVIEN=0
 .F  S ABMVIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,ABMVIEN)) Q:+ABMVIEN=0  D
 ..S ABMP("V0")=$G(^AUPNVSIT(ABMVIEN,0))
 ..D ^ABMDVST5 ;they want to include all meds on claim
 K ABMMEDS,ABMRXFLG,ABMVIEN
 Q
CLIACHK ;
 ;reference
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,23)="" D
 .K DIE,DA,DR
 .S DIE="^ABMDCLM(DUZ(2),"
 .S DA=ABMP("CDFN")
 .S DR=".923////"_$P($G(^ABMDPARM(DUZ(2),1,4)),U,12)
 .D ^DIE
 ;in-house
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,22)="" D
 .K DIE,DA,DR
 .S DIE="^ABMDCLM(DUZ(2),"
 .S DA=ABMP("CDFN")
 .S DR=".922////"_$P($G(^ABMDPARM(DUZ(2),1,4)),U,11)
 .D ^DIE
 Q
