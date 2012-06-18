ABMDREEX ; IHS/SD/SDR - Re-Create batch of Selected Bills ;    
 ;;2.6;IHS Third Party Billing System;**2,3,4,6**;NOV 12, 2009
 ; IHS/SD/SDR-abm*2.6*2-FIXPMS10005 - New routine
 ; IHS/SD/SDR-abm*2.6*3-RPMS10005#2 - mods to make Submission date of 3P Tx status file work correctly
 ; IHS/SD/SDR-abm*2.6*3-FIXPMS10005 - mods to create 1 file for each 1000 bills
 ; IHS/SD/SDR-abm*2.6*4-NOHEAT - if create and re-export are done on same day it will have duplicates
 ; IHS/SD/SDR-abm*2.6*6-HEAT28632 - <SUBSCR>CHECKBAL+17^ABMDREEX error when parent/satellite present
 ;
EN K ABMT,ABMREX,ABMP,ABMY
 K ^TMP($J,"ABM-D"),^TMP($J,"ABM-D-DUP"),^TMP($J,"D")  ;abm*2.6*4 NOHEAT
 S ABMREX("XMIT")=0
 S ABMT("TOT")="0^0^0"
 W !!,"Re-Print Bills for:"
 K DIR
 S DIR(0)="SO^1:SELECTIVE BILL(S) (Type in the Bills to be included in this                     export.  Grouped by Insurer and Export Mode)"
 S DIR(0)=DIR(0)_";2:FOR 277 - Response of not received for insurance company                        (INACTIVE AT THIS TIME)"
 S DIR(0)=DIR(0)_";3:UNPAID BILLS for an insurer - bill should not have posted                       transactions and should be the original bill amount."
 S DIR("A")="Select Desired Option"
 D ^DIR
 K DIR
 G XIT:$D(DIRUT)!$D(DIROUT),SEL:Y=1,UNPD:Y=3
277 ;
 W !!!,"INACTIVE AT THIS TIME; functionality will be available in a future patch" H 2 W !
 G EN
SEL ;
 W !!
 K DIC
 S DIC="^ABMDBILL(DUZ(2),"
 S DIC(0)="QZEAM"
 S ABMT=$G(ABMT)+1
 S ABM("E")=$E(ABMT,$L(ABMT))
 S DIC("A")="Select "_ABMT_$S(ABMT>3&(ABMT<21):"th",ABM("E")=1:"st",ABM("E")=2:"nd",ABM("E")=3:"rd",1:"th")_" BILL to Re-Print: "
 ;start old code abm*2.6*3 FIXPMS10005
 ;S DIC("S")="I $P(^(0),U)'=+^(0),""BTCP""[$P(^(0),""^"",4),$P(^(0),""^"",6)"
 ;S:ABMT>1 DIC("S")=DIC("S")_",$P(ABMT(""FORM""),""^"",1)[$P(^(0),""^"",6),(ABMT(""INS"")=$P(^(0),""^"",8))"
 ;end old code start new code FIXPMS10005
 S DIC("S")="I $P(^(0),U)'=+^(0),""BTCP""[$P(^(0),""^"",4),$P(^ABMDEXP($P(^(0),""^"",6),0),U)[""837"",($$CHECKBAL^ABMDREEX(Y)=1)"
 S:ABMT>1 DIC("S")=DIC("S")_",$P(ABMT(""FORM""),""^"",1)[$P(^(0),""^"",6),($$CHECKBAL^ABMDREEX(Y)=1),(ABMT(""INS"")=$P(^(0),""^"",8)),($P(^(0),U,7)=ABMT(""VTYP""))"
 ;end new code FIXPMS10005
 D BENT^ABMDBDIC
 G XIT:$D(DUOUT)!$D(DTOUT)
 I '$G(ABMP("BDFN")) G ZIS:ABMT>1,XIT
 I '$G(ABMP("BDFN")) S ABMT=ABMT-1 G SEL
 S ABMY(ABMP("BDFN"))=""
 G SEL:ABMT>1
 S ABMT("EXP")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,6)
 S ABMT("INS")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,8)
 S ABMT("VTYP")=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,7)  ;abm*2.6*3
 S ABMT("FORM")=ABMT("EXP")_"^"_$P($G(^ABMDEXP(ABMT("EXP"),0)),U)
 G SEL
UNPD ;UN-PAID BILLS
 W !!
 K DIR
 S DIR(0)="PO^9999999.18:EQM"
 S DIR("A")="Select Insurer"
 D ^DIR
 K DIR
 G XIT:$D(DIRUT)!$D(DIROUT)
 S ABMREX("SELINS")=+Y
BEGDT K DIR
 S DIR(0)="DO"
 S DIR("A")="Select Beginning Export Date"
 D ^DIR
 K DIR
 ;G XIT:$D(DIRUT)!$D(DIROUT)  ;abm*2.6*3 NOHEAT
 I $D(DIRUT) K ABMREX("SELINS") G UNPD  ;abm*2.6*3 NOHEAT
 G XIT:$D(DIROUT)  ;abm*2.6*3 NOHEAT
 S ABMREX("BEGDT")=+Y
ENDDT K DIR
 S DIR(0)="DO"
 S DIR("A")="Select Ending Export Date"
 D ^DIR
 K DIR
 ;G XIT:$D(DIRUT)!$D(DIROUT)  ;abm*2.6*3 NOHEAT
 I $D(DIRUT) K ABMREX("BEGDT") G BEGDT  ;abm*2.6*3 NOHEAT
 G XIT:$D(DIROUT)  ;abm*2.6*3 NOHEAT
 S ABMREX("ENDDT")=+Y
EXPMODE D ^XBFMK
 S DIC(0)="AEBNQ"
 S DIC="^ABMDEXP("
 S DIC("S")="I $P($G(^ABMDEXP(Y,0)),U)[""837"""
 S DIC("A")="Select Export Mode (leave blank for ALL): "
 D ^DIC
 ;G XIT:$D(DIRUT)!$D(DIROUT)  ;abm*2.6*3 NOHEAT
 G XIT:(X["^^")  ;abm*2.6*3 NOHEAT
 I $D(DUOUT) K ABMREX("ENDDT") G ENDDT  ;abm*2.6*3 NOHEAT
 S ABMREX("SELEXP")=$S(+Y>0:+Y,1:"")  ;they can select all exp modes by leaving prompt blank
 I (ABMREX("BEGDT")>(ABMREX("ENDDT"))) W !!,"Beginning Export Date must be before Ending Export Date" H 1 G UNPD
 S ABMBDT=(ABMREX("BEGDT")-.5)
 S ABMEDT=(ABMREX("ENDDT")+.999999)
 S ABMBCNT=0,ABMTAMT=0
 S ABMFCNT=1  ;file cnt  ;abm*2.6*3 FIXPMS10005
 F  S ABMBDT=$O(^ABMDTXST(DUZ(2),"B",ABMBDT)) Q:(+ABMBDT=0!(ABMBDT>ABMEDT))  D
 .S ABMIEN=0
 .F  S ABMIEN=$O(^ABMDTXST(DUZ(2),"B",ABMBDT,ABMIEN)) Q:+ABMIEN=0  D
 ..I $P($G(^ABMDTXST(DUZ(2),ABMIEN,0)),U,4)'=ABMREX("SELINS") Q  ;not our ins
 ..I ABMREX("SELEXP")'="",($P($G(^ABMDTXST(DUZ(2),ABMIEN,0)),U,2)'=(ABMREX("SELEXP"))) Q  ;they selected one & this isn't it
 ..I ABMREX("SELEXP")="",($P($G(^ABMDEXP($P($G(^ABMDTXST(DUZ(2),ABMIEN,0)),U,2),0)),U)'[("837")) Q  ;they didn't answer so deflt to all 837s
 ..S ABMBIEN=0
 ..S ABMFBCNT=0  ;cnt bills in file ;abm*2.6*3 FIXPMS10005
 ..F  S ABMBIEN=$O(^ABMDTXST(DUZ(2),ABMIEN,2,ABMBIEN)) Q:+ABMBIEN=0  D
 ...I $P($G(^ABMDBILL(DUZ(2),ABMBIEN,0)),U,4)="X" Q  ;skip cancelled bills
 ...S ABMBALCK=$$CHECKBAL(ABMBIEN)
 ...I ABMBALCK=0 Q  ;has been posted to
 ...;cnt tot bills & amt
 ...S ABMBCNT=+$G(ABMBCNT)+1
 ...S ABMTAMT=+$G(ABMTAMT)+($P($G(^ABMDBILL(DUZ(2),ABMBIEN,2)),U))
 ...;cnt bills not cancelled or posted to in export
 ...S ABMREX("CNTS",$P($G(^ABMDTXST(DUZ(2),ABMIEN,0)),U,2),ABMIEN)=+$G(ABMREX("CNTS",$P($G(^ABMDTXST(DUZ(2),ABMIEN,0)),U,2),ABMIEN))+1
 ...S $P(ABMREX("CNTS",$P($G(^ABMDTXST(DUZ(2),ABMIEN,0)),U,2),ABMIEN),U,2)=+$P($G(ABMREX("CNTS",$P($G(^ABMDTXST(DUZ(2),ABMIEN,0)),U,2),ABMIEN)),U,2)+($P($G(^ABMDBILL(DUZ(2),ABMBIEN,2)),U))
 ...S ABMREX("EXPS",$P($G(^ABMDTXST(DUZ(2),ABMIEN,0)),U,2),ABMIEN)=""  ;capture what export IENs to do
 ...;start new abm*2.6*3 FIXPMS10005
 ...S ^TMP($J,"ABM-D",ABMFCNT,$P($G(^ABMDTXST(DUZ(2),ABMIEN,0)),U,2),ABMIEN,ABMBIEN)=""
 ...S ^TMP($J,"ABM-D-DUP",ABMBIEN)=+$G(^TMP($J,"ABM-D-DUP",ABMBIEN))+1  ;cnt # of times bill in select exports  ;abm*2.6*3
 ...S ABMFBCNT=+$G(ABMFBCNT)+1
 ...I ABMFBCNT>1000 S ABMFCNT=+$G(ABMFCNT)+1,ABMFBCNT=0
 ...;end new abm*2.6*3 FIXPMS10005
 W !!,"A total of "_ABMBCNT_" "_$S(ABMBCNT=1:"bill ",1:"bills ")_"for $"_$J(ABMTAMT,1,2)_" have been located."
 I ABMBCNT>0 D
 .W !?8,"Export mode",?25,"Export Dt/Tm",?50,"#Bills",?60,"Total Amt"
 .S ABMREX("EXP")=0,ABMECNT=0
 .F  S ABMREX("EXP")=$O(ABMREX("CNTS",ABMREX("EXP"))) Q:($G(ABMREX("EXP"))="")  D
 ..S ABMIEN=0
 ..F  S ABMIEN=$O(ABMREX("CNTS",ABMREX("EXP"),ABMIEN)) Q:($G(ABMIEN)="")  D
 ...S ABMECNT=+$G(ABMECNT)+1
 ...W !,?1,ABMECNT,?8,$P(^ABMDEXP(ABMREX("EXP"),0),U),?25,$$CDT^ABMDUTL($P($G(^ABMDTXST(DUZ(2),ABMIEN,0)),U)),?50,+$G(ABMREX("CNTS",ABMREX("EXP"),ABMIEN)),?60,$J(+$P($G(ABMREX("CNTS",ABMREX("EXP"),ABMIEN)),U,2),1,2)
ZIS ;EP
 ;start new abm*2.6*3
 S ABMBIEN=0,ABMDFLG=0
 F  S ABMBIEN=$O(^TMP($J,"ABM-D-DUP",ABMBIEN)) Q:(+$G(ABMBIEN)=0)  D
 .I $G(^TMP($J,"ABM-D-DUP",ABMBIEN))>1 S ABMDFLG=1
 I ABMDFLG=1 W !!?2,"Duplicate bills exist in this selection.  If re-exported the bill will only",!?2,"be included once."
 ;end new abm*2.6*3
 S DIR(0)="Y"
 S DIR("A",1)=""
 S DIR("A",2)=""
 I $G(ABMREX("SELINS"))'="" S DIR("A",3)="One file will be created for each export mode with a maximum of 1000 bills in each file"  ;abm*2.6*3 FIXPMS10005
 I $G(ABMREX("SELINS"))="" S DIR("A",3)="A file will be created for the bills selected"
 S DIR("A")="Proceed"
 S DIR("B")="YES"
 D ^DIR
 K DIR
 ;I Y'=1 K ABME Q  ;abm*2.6*3
 I Y'=1 D  Q:Y=1
 .W !!
 .K X,Y,DIR,DIE,DIC,DA
 .S DIR(0)="Y"
 .S DIR("A",1)="Your selection of bills will be lost."
 .S DIR("A")="Are you sure you wish to exit"
 .S DIR("B")="NO"
 .D ^DIR
 .K DIR
 ;selected bills-one filename
 I $G(ABMREX("SELINS"))="" D
 .S ABMEXP=ABMT("EXP")
 .S ABMREX("BILLSELECT")=1
 .;start new abm*2.6*3  ;abm*2.6*3 FIXPMS10005
 .S ABMY("TOT")=0
 .S ABMREX("BDFN")=0
 .F  S ABMREX("BDFN")=$O(ABMY(ABMREX("BDFN"))) Q:(+$G(ABMREX("BDFN"))=0)  D
 ..S ABMY("INS")=$P($G(^ABMDBILL(DUZ(2),ABMREX("BDFN"),0)),U,8)
 ..S ABMY("VTYP")=$P($G(^ABMDBILL(DUZ(2),ABMREX("BDFN"),0)),U,7)
 ..S ABMY("EXP")=$P($G(^ABMDBILL(DUZ(2),ABMREX("BDFN"),0)),U,6)
 ..S ABMY("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),U,2)
 ..S ABMY("TOT")=+$G(ABMY("TOT"))+$P($G(^ABMDBILL(DUZ(2),ABMREX("BDFN"),2)),U)
 ..S ^TMP($J,"D",ABMY("INS"),ABMY("LOC"),ABMY("VTYP"),ABMY("EXP"),ABMREX("BDFN"))=""
 .;end new abm*2.6*3  ;abm*2.6*3 FIXPMS10005
 .D CREATEN
 ;exports selected - one filename for each export
 I $G(ABMREX("SELINS"))'="" D
 .S ABMREX("BATCHSELECT")=1
 .;start old code abm*2.6*3 FIXPMS10005
 .;S ABMEXP=0,ABMECNT=0
 .;F  S ABMEXP=$O(ABMREX("EXPS",ABMEXP)) Q:(+$G(ABMEXP)=0)  D
 .;.S ABMREX("EDFN")=0
 .;.F  S ABMREX("EDFN")=$O(ABMREX("EXPS",ABMEXP,ABMREX("EDFN"))) Q:(+$G(ABMREX("EDFN"))=0)  D
 .;..S ABMECNT=+$G(ABMECNT)+1
 .;..W !!,"Creating file # ",ABMECNT,?20,$P(^ABMDEXP(ABMEXP,0),U),?40,$$CDT^ABMDUTL($P($G(^ABMDTXST(DUZ(2),ABMREX("EDFN"),0)),U)),?60,+$G(ABMREX("CNTS",ABMEXP,ABMREX("EDFN"))),?70,$J(+$P($G(ABMREX("CNTS",ABMEXP,ABMREX("EDFN"))),U,2),1,2)
 .;..I $P($G(^ABMDTXST(DUZ(2),ABMREX("EDFN"),0)),U,9)'=($P($G(ABMREX("CNTS",ABMEXP,ABMREX("EDFN"))),U)) D CREATEN
 .;..I $P($G(^ABMDTXST(DUZ(2),ABMREX("EDFN"),0)),U,9)=($P($G(ABMREX("CNTS",ABMEXP,ABMREX("EDFN"))),U)) D USEORIG
 .;end old start new abm*2.6*3 FIXPMS10005
 .S ABMFCNT=0
 .F  S ABMFCNT=$O(^TMP($J,"ABM-D",ABMFCNT)) Q:+$G(ABMFCNT)=0  D
 ..W !!,"Creating file # ",ABMFCNT
 ..S ABMEXP=0
 ..F  S ABMEXP=$O(^TMP($J,"ABM-D",ABMFCNT,ABMEXP)) Q:(+$G(ABMEXP)=0)  D
 ...S ABMEDFN=0
 ...F  S ABMEDFN=$O(^TMP($J,"ABM-D",ABMFCNT,ABMEXP,ABMEDFN)) Q:(+$G(ABMEDFN)=0)  D
 ....W !,?20,$P(^ABMDEXP(ABMEXP,0),U),?40,$$CDT^ABMDUTL($P($G(^ABMDTXST(DUZ(2),ABMEDFN,0)),U)),?60,+$G(ABMREX("CNTS",ABMEXP,ABMEDFN)),?70,$J(+$P($G(ABMREX("CNTS",ABMEXP,ABMEDFN)),U,2),1,2)
 ...S ABMEDFN=0
 ...F  S ABMEDFN=$O(^TMP($J,"ABM-D",ABMFCNT,ABMEXP,ABMEDFN)) Q:(+$G(ABMEDFN)=0)  D
 ....S ABMREX("BDFN")=0,ABMY("TOT")=0
 ....F  S ABMREX("BDFN")=$O(^TMP($J,"ABM-D",ABMFCNT,ABMEXP,ABMEDFN,ABMREX("BDFN"))) Q:(+$G(ABMREX("BDFN"))=0)  D
 .....S ABMY("INS")=$S($G(ABMREX("SELINS")):ABMREX("SELINS"),1:ABMT("INS"))
 .....S ABMY("VTYP")=$P($G(^ABMDBILL(DUZ(2),ABMREX("BDFN"),0)),U,7)
 .....S ABMY("EXP")=$P($G(^ABMDBILL(DUZ(2),ABMREX("BDFN"),0)),U,6)
 .....S ABMY("LOC")=$P($G(^AUTTLOC(DUZ(2),0)),U,2)  ;abm*2.6*3 FIXPMS10005
 .....S ABMY("TOT")=+$G(ABMY("TOT"))+$P($G(^ABMDBILL(DUZ(2),ABMREX("BDFN"),2)),U)  ;abm*2.6*3 FIXPMS10005
 .....S ^TMP($J,"D",ABMY("INS"),ABMY("LOC"),ABMY("VTYP"),ABMY("EXP"),ABMREX("BDFN"))=""  ;abm*2.6*3 FIXPMS10005
 ....K ABMXMTDT  ;abm*2.6*3 5PMS10005#2
 ...D CREATEN
 ...K ^TMP($J,"D")
 .;end new abm*2.6*3 FIXPMS10005
 S DIR(0)="E"
 D ^DIR
 K DIR
 W !!
OUT ;
 D ^%ZISC
 ;
XIT ;
 K ^TMP($J,"D"),^TMP($J,"ABM-D")  ;abm*2.6*3
 K ABMP,ABMY,DIQ,ABMT,ABMREX
 Q
CHECKBAL(ABMBIEN) ;
 ;start old IHS/SD/SDR HEAT28632
 ;S ABMDUZ2=DUZ(2)
 ;S ABMBALCK=0
 ;S ABMP("LDFN")=$P($G(^ABMDBILL(DUZ(2),ABMBIEN,0)),U,3)
 ;S ABMP("DOS")=$P($G(^ABMDBILL(DUZ(2),ABMBIEN,7)),U)
 ;S ABMARPS=$P($G(^ABMDPARM(DUZ(2),1,4)),U,9)    ;Use A/R parent/sat
 ;;Use A/R par/sat is yes & visit loc not defined under parent
 ;;in A/R Par/Sat file.
 ;I ABMARPS,'$D(^BAR(90052.05,DUZ(2),ABMP("LDFN"),0)) S ABMDUZ2=ABMP("LDFN")
 ;;Use A/R parent/sat is yes, but DUZ(2) is not the parent for this
 ;;visit loc
 ;I ABMARPS,$P($G(^BAR(90052.05,DUZ(2),ABMP("LDFN"),0)),U,3)'=DUZ(2) S ABMDUZ2=ABMP("LDFN")
 ;I ABMARPS,$P($G(^BAR(90052.05,DUZ(2),ABMP("LDFN"),0)),U,6)>ABMP("DOS") S ABMDUZ2=ABMP("LDFN")
 ;I ABMARPS,$P($G(^BAR(90052.05,DUZ(2),ABMP("LDFN"),0)),U,7),$P(^(0),U,7)<ABMP("DOS") S ABMDUZ2=ABMP("LDFN")
 ;S ABMHOLD=DUZ(2)
 ;S DUZ(2)=ABMDUZ2
 ;S ABMARBIL=$O(^BARBL(DUZ(2),"B",$P($G(^ABMDBILL(ABMHOLD,ABMBIEN,0)),U)))
 ;S ABMARIEN=$O(^BARBL(DUZ(2),"B",ABMARBIL,0))
 ;S ABMARBAL=$$GET1^DIQ(90050.01,ABMARIEN,15)
 ;I ABMARBAL'=($P($G(^ABMDBILL(ABMHOLD,ABMBIEN,2)),U)) S ABMBALCK=0
 ;I ABMARBAL=($P($G(^ABMDBILL(ABMHOLD,ABMBIEN,2)),U)) S ABMBALCK=1
 ;S DUZ(2)=ABMHOLD
 ;Q ABMBALCK
 ;end old start new HEAT28632
 S ABMBALCK=0
 S ABMHOLD=DUZ(2)
 S BARSAT=$P($G(^ABMDBILL(DUZ(2),ABMBIEN,0)),U,3)  ;Satellite=3P Visit loc
 S ABMP("DOS")=$P($G(^ABMDBILL(DUZ(2),ABMBIEN,7)),U)
 S BARPAR=0  ;Parent
 ; check site active at DOS to ensure bill added to correct site
 S DA=0
 F  S DA=$O(^BAR(90052.06,DA)) Q:DA'>0  D  Q:BARPAR
 .Q:'$D(^BAR(90052.06,DA,DA))  ;Pos Parent UNDEF Site Parm
 .Q:'$D(^BAR(90052.05,DA,BARSAT))  ;Sat UNDEF Par/Sat
 .Q:+$P($G(^BAR(90052.05,DA,BARSAT,0)),U,5)  ;Par/Sat not usable
 .;Q if sat NOT active at DOS
 .I ABMP("DOS")<$P($G(^BAR(90052.05,DA,BARSAT,0)),U,6) Q
 .;Q if sat became NOT active before DOS
 .I $P($G(^BAR(90052.05,DA,BARSAT,0)),U,7),(ABMP("DOS")>$P($G(^BAR(90052.05,DA,BARSAT,0)),U,7)) Q
 .S BARPAR=$S(BARSAT:$P($G(^BAR(90052.05,DA,BARSAT,0)),U,3),1:"")
 I 'BARPAR Q ABMBALCK       ;No parent defined for satellite
 S DUZ(2)=BARPAR
 S ABMARBIL=$O(^BARBL(DUZ(2),"B",$P($G(^ABMDBILL(ABMHOLD,ABMBIEN,0)),U)))
 S ABMARIEN=$O(^BARBL(DUZ(2),"B",ABMARBIL,0))
 Q:'ABMARIEN ABMBALCK
 S ABMARBAL=$$GET1^DIQ(90050.01,ABMARIEN,15)
 I ABMARBAL'=($P($G(^ABMDBILL(ABMHOLD,ABMBIEN,2)),U)) S ABMBALCK=0
 I ABMARBAL=($P($G(^ABMDBILL(ABMHOLD,ABMBIEN,2)),U)) S ABMBALCK=1
 S DUZ(2)=ABMHOLD
 Q ABMBALCK
 ;end new HEAT28632 
CREATEN ;
 S ABMSEQ=1
 S ($P(ABMER(ABMSEQ),U,3),ABMP("EXP"))=ABMEXP
 S ABMLOC=$P($G(^AUTTLOC(DUZ(2),0)),U,2)
 S ABMY("INS")=$S($G(ABMREX("SELINS")):ABMREX("SELINS"),1:ABMT("INS"))
 S ABMINS("IEN")=ABMY("INS")  ;ins
 S $P(ABMER(ABMSEQ),U)=ABMINS("IEN")  ;abm*2.6*3 FIXPMS10005
 S $P(ABMER(ABMSEQ),U,2)=ABMY("VTYP")  ;abm*2.6*3 FIXPMS10005
 S $P(ABMER(ABMSEQ),U,5)=ABMY("TOT")  ;abm*2.6*3 FIXPMS10005
 S ABMITYP=$P($G(^AUTNINS(ABMY("INS"),2)),U)  ;ins typ
 ;# forms & tot chgs
 I $G(ABMP("SELINS"))="" S $P(ABMER(ABMSEQ),U,4)=+$G(ABMBCNT)
 I $G(ABMP("SELINS"))'="" S $P(ABMER(ABMSEQ),U,4)=+$G(ABMREX("CNTS",ABMEXP,ABMREX("EDFN")))
 ;start new abm*2.6*3 FIXPMS10005
 D FILE^ABMECS
 ;end new abm*2.6*3 FIXPMS10005
 Q
USEORIG ;
 S ABMP("XMIT")=ABMREX("EDFN")
 S ABMP("EXP")=$P(^ABMDTXST(DUZ(2),ABMP("XMIT"),0),"^",2)
 S ABMP("XRTN")=$P($G(^ABMDEXP(+ABMP("EXP"),0)),"^",4)
 S X=ABMP("XRTN")
 X ^%ZOSF("TEST")
 I '$T D  K ABMP Q
 .W !!,"Routine :",ABMP("XRTN")," not found.Cannot proceed.",!
 .S DIR(0)="E"
 .D ^DIR
 .K DIR
 D @("^"_ABMP("XRTN"))
 K ABMP
 Q
LISTBILL ;
 K ABMY
 S ABMT("BDFN")=0
 F  S ABMT("BDFN")=$O(^ABMDTXST(DUZ(2),ABMREX("EDFN"),2,ABMT("BDFN"))) Q:'ABMT("BDFN")  D
 .I $P($G(^ABMDBILL(DUZ(2),ABMT("BDFN"),0)),U,4)="X" Q  ;skip cancelled bills
 .S ABMBALCK=$$CHECKBAL(ABMT("BDFN"))
 .I ABMBALCK=0 Q
 .S ABMY(ABMT("BDFN"))=""
 Q
BILLSTAT(ABMLOC,ABMBDFN,ABMEXP,ABMSTAT,ABMGCN) ;
 N DIC,DIE,DIR,DA,X,Y,ABMP
 S ABMHOLD=DUZ(2)
 S DUZ(2)=ABMLOC
 S (DA(1),ABMREX("BDFN"))=ABMBDFN
 S DIC="^ABMDBILL(DUZ(2),"_DA(1)_",74,"
 S DIC("P")=$P(^DD(9002274.4,.175,0),U,2)
 S DIC(0)="L"
 S X=ABMEXP
 I $G(ABMREX("BILLSELECT"))'="" S ABMSTAT="F"
 I $G(ABMREX("BATCHSELECT"))'="" S ABMSTAT="S"
 I $G(ABMREX("RECREATE"))'="" S ABMSTAT="C"
 S DIC("DR")=".02////"_ABMSTAT_";.03////"_ABMGCN
 K DD,DO
 D FILE^DICN
 S DUZ(2)=ABMHOLD
 S X="A"  ;deflt bill status to approved
 N DA
 S DA=ABMBDFN
 Q
