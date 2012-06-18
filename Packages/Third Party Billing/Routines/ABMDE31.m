ABMDE31 ;IHS/SD/SDR - AMBULANCE - PAGE 3A ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**6**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p8 - task 6 - New routine for page 3A
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - added patient count
 ;
 ;
OPT ;EP
 G XIT:$D(ABMP("WORKSHEET"))
 K ABM,ABME,ABMZ,DUOUT,ABMP("QU")
 S ABMP("OPT")="ENVJBQ"
 D DISP
 G XIT:$D(DTOUT)!$D(DIROUT)
 D ^ABMDE31X
 I +$O(ABME(0)) D
 . S ABME("CONT")=""
 . D ^ABMDERR
 . K ABME("CONT")
 G XIT:$D(DTOUT)!$D(DIROUT)
 W !
 D SEL^ABMDEOPT
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!("EV"'[$E(Y))
 S ABM("DO")=$S($E(Y)="E":"E1",1:"V1")
 W !
 D @ABM("DO")
 G XIT:$D(DTOUT)!$D(DIROUT)
 G OPT
V1 ;View data
 S ABMZ("TITL")="AMBULANCE QUESTIONS - VIEW OPTION"
 D SUM^ABMDE1
 D ^ABMDERR
 Q
E1 ;Edit data
 ;S ABMP("FLDS")=10  ;abm*2.6*6 5010
 S ABMP("FLDS")=11  ;abm*2.6*6 5010
 D FLDS^ABMDEOPT
 W !
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S DR=""
 F ABM("I")=1:1 S ABM=$P(ABMP("FLDS"),",",ABM("I")) Q:ABM=""  D
 .Q:$P(ABMP("FLDS"),",",ABM("I"))=3
 .S:ABM("I")>1 DR=DR_";"
 .S DR=DR_$P($T(@ABM),";;",2)
 S DIE="^ABMDCLM(DUZ(2),"
 S DA=ABMP("CDFN")
 D ^DIE
 ; other fields for Point of Pickup (1)
 I ABMP("FLDS")=1!(ABMP("FLDS")["1,") D
 .K DIE,DA,DR,DIC,X,Y
 .S DIE="^ABMDCLM(DUZ(2),"
 .S DA=ABMP("CDFN")
 .S DR=".122R//PATIENT'S HOME"
 .D ^DIE
 .I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12)),U,2)'="PATIENT'S HOME" S DR=".123:.126;.1214"
 .E  S DR=".123///^S X=$P($G(^DPT(ABMP(""PDFN""),.11)),U);.124///^S X=$P($G(^DPT(ABMP(""PDFN""),.11)),U,4);.125///^S X=$P($G(^DPT(ABMP(""PDFN""),.11)),U,5);.126///^S X=$P($G(^DPT(ABMP(""PDFN""),.11)),U,6);.1214"
 .D ^DIE
 .D VALSTUFF  ;stuff zip code with A0 as value code on 9D
 ;destination (3)
 I ABMP("FLDS")[3 D
 .K DIR,DIC,DIE,DR,DA,X
 .S DA=ABMP("CDFN")
 .S DIE="^ABMDCLM("_DUZ(2)_","
 .S DIC("V")="Q:X'=""PATIENT'S HOME""  I X=""PATIENT'S HOME"" S X=$P($G(^DPT(ABMP(""PDFN""),0)),U) I +Y(0)=9000001 K DIC(""V"")"
 .S ABMDVAR=$P($G(^DIC(4,DUZ(2),0)),U)
 .S DR=".127//^S X=ABMDVAR;.1216Destination Modifier"
 .D ^DIE
 ;
 I ABMP("FLDS")[5 D
 .K DIR,DIC,DIE,DR,DA,DIR
 .S DA=ABMP("CDFN")
 .S DR=.128
 .S DIE="^ABMDCLM("_DUZ(2)_","
 .D ^DIE
 .K DIR,DIC,DIE,DR,DA,DIR
 I ABMP("FLDS")[6 D
 .K DIR,DIC,DIE,DR,DA,DIR
 .S DA=ABMP("CDFN")
 .S DR=.129
 .S DIE="^ABMDCLM("_DUZ(2)_","
 .D ^DIE
 .K DIR,DIC,DIE,DR,DA,DIR
 ;other fields for medical necessity ind (5)
 I ABMP("FLDS")[7 D
 .S ABMANS=X
 .I ABMANS="Y" D
 ..F  D  Q:(+$G(Y)<1)!$D(DUOUT)!$D(DTOUT)
 ...K DIC
 ...S DA(1)=ABMP("CDFN")
 ...S ABMENTRY=+$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),14,0)),U,4)
 ...S DIC="^ABMDCLM(DUZ(2),"_DA(1)_",14,"
 ...S DIC(0)=$S(ABMENTRY=5:"AEMQ",1:"AELMQ")
 ...I ABMENTRY'=0 S DIC("A")=$S(ABMENTRY=1:"2nd ",ABMENTRY=2:"3rd ",ABMENTRY=3:"4th ",ABMENTRY=4:"5th ",1:"")
 ...S DIC("P")=$P(^DD(9002274.3,14,0),U,2)
 ...S DIC("A")=$G(DIC("A"))_"Condition indicator (reason): "
 ...K DD,DO
 ...D ^DIC
 ...I (+$G(Y)>0),$P(Y,U,3)="" D
 ....S DIE=DIC
 ....S DA=+Y
 ....S DR=".01Condition indicator//"
 ....D ^DIE
 .I ABMANS="N" D  ;make sure no condition indicators if no
 ..S DA(1)=ABMP("CDFN")
 ..S DIK="^ABMDCLM(DUZ(2),"_DA(1)_",14,"
 ..S ABMIEN=0
 ..F  S ABMIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),14,ABMIEN)) Q:ABMIEN=""  D
 ...S DA=ABMIEN
 ...D ^DIK
 ;
 K DR
 Q
DISP ;
 S ABMZ("TITL")="AMBULANCE QUESTIONS"
 S ABMZ("PG")="3A"
 I $D(ABMP("DDL")),$Y>(IOSL-6) D PAUSE^ABMDE1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)  I 1
 E  D SUM^ABMDE1
 ;
 S ABMAREC=$G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12))
 W !?3,"[01] Point of Pickup........: ",$P(ABMAREC,U,2)  ;origin
 W !?33,$P(ABMAREC,U,3)  ;origin address
 W !?33,$S($P(ABMAREC,U,4)'="":$P(ABMAREC,U,4),1:"")  ;origin city
 W $S($P(ABMAREC,U,5)'="":", "_$P($G(^DIC(5,$P(ABMAREC,U,5),0)),U),1:"")  ;origin state
 W $S($P(ABMAREC,U,6)'="":"  "_$P(ABMAREC,U,6),1:"")  ;origin zip
 W !,?8,"[02] Modifier.........: ",$P(ABMAREC,U,14)_"  "_$S($P(ABMAREC,U,14)'="":$P($P($P(^DD(9002274.3,.1214,0),U,3),$P(ABMAREC,U,14)_":",2),";"),1:"")  ;modifier
 ;
 S ABMDIEN=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12)),U,7)
 S ABMDREC=$$GETDEST(ABMDIEN)  ;variable pointer; get data
 W !?3,"[03] Destination............: ",$P(ABMDREC,U)  ;destination
 W !?33,$P(ABMDREC,U,2)  ;destination address
 W !?33,$P(ABMDREC,U,3)  ;destination city
 W $S($P(ABMDREC,U,4)'="":", "_$P(ABMDREC,U,4),1:"")
 W $S($P(ABMDREC,U,5)'="":"  "_$P(ABMDREC,U,5),1:"")  ;destination state/zip
 W !,?8,"[04] Modifier.........: ",$P(ABMAREC,U,16)_"  "_$S($P(ABMAREC,U,16)'="":$P($P($P(^DD(9002274.3,.1216,0),U,3),$P(ABMAREC,U,16)_":",2),";"),1:"")  ;modifier
 ;
 W !
 W !?3,"[05] Mileage (Covered)......: ",$P(ABMAREC,U,8)
 W !?3,"[06] Mileage (Non-Covered)..: ",$P(ABMAREC,U,9)
 ;
 W !?3,"[07] Medical Necessity Ind..: ",$P(ABMAREC,U,15)
 S ABMCONDI=0
 F  S ABMCONDI=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),14,ABMCONDI))  Q:+ABMCONDI=0  D
 .S ABMCOND=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),14,ABMCONDI,0)),U)
 .W !?9,"Condition Indicator...: ",$P($G(^ABMCNDIN(ABMCOND,0)),U)_" "_$E($P($G(^ABMCNDIN(ABMCOND,0)),U,2),1,43)
 ;
 W !?3,"[08] Patient Weight (lbs)...: ",$P(ABMAREC,U,11)
 W !?3,"[09] Patient Count..........: ",$P(ABMAREC,U,18)  ;abm*2.6*6 5010
 W !
 W !,"Transfers Only:"
 S ABMTRNST=$P(ABMAREC,U,12)
 S:ABMTRNST'="" ABMTRNST=$S(ABMTRNST="I":"INITIAL TRIP",ABMTRNST="R":"RETURN TRIP",ABMTRNST="T":"TRANSFER TRIP",1:"ROUND TRIP")
 ;start old code abm*2.6*6 5010
 ;W !?3,"[09] Type of Transport......: ",ABMTRNST
 ;W !?3,"[10] Transported To/For.....: "
 ;I $P(ABMAREC,U,13)'="" W $P($T(@($P(ABMAREC,U,13))),";;",2)
 ;end old code start new code 5010
 W !?3,"[10] Type of Transport......: ",ABMTRNST
 W !?3,"[11] Transported To/For.....: "
 I $P(ABMAREC,U,13)'="" W $P($T(@($P(ABMAREC,U,13))),";;",2)
 ;end new code 5010
 W !
 K ABMAREC
 Q
XIT ;
 S ABMP("C0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),0)
 K ABM,ABMV,ABME
 Q
GETDEST(ABMDIEN) ;EP - figure out data for destination - variable pointer
 I $G(ABMDIEN)="" S ABMDREC="" Q ""
 I $P(ABMDIEN,";",2)["AUPNPAT" D  Q ABMDREC
 .S ABMDREC="PATIENT'S HOME"
 .S $P(ABMDREC,U,2)=$P($G(^DPT(+ABMDIEN,.11)),U)  ;pt street
 .S $P(ABMDREC,U,3)=$P($G(^DPT(+ABMDIEN,.11)),U,4)  ;pt city
 .S $P(ABMDREC,U,4)=$S($P($G(^DPT(+ABMDIEN,.11)),U,5):$P($G(^DIC(5,$P(^DPT(+ABMDIEN,.11),U,5),0)),U),1:"")  ;pt state
 .S $P(ABMDREC,U,5)=$P($G(^DPT(+ABMDIEN,.11)),U,6)  ;pt zip
 ;
 I $P(ABMDIEN,";",2)["AUTTLOC" D  Q ABMDREC
 .S ABMDREC=$P($G(^AUTTLOC(+ABMDIEN,0)),U)  ;loc name
 .S:$G(ABMDREC)'="" ABMDREC=$P($G(^DIC(4,ABMDREC,0)),U)
 .S $P(ABMDREC,U,2)=$P($G(^AUTTLOC(+ABMDIEN,0)),U,12)  ;loc street
 .S $P(ABMDREC,U,3)=$P($G(^AUTTLOC(+ABMDIEN,0)),U,13)  ;loc city
 .S $P(ABMDREC,U,4)=$S($P($G(^AUTTLOC(+ABMDIEN,0)),U,14):$P($G(^DIC(5,$P(^AUTTLOC(+ABMDIEN,0),U,14),0)),U),1:"")  ;loc state
 .S $P(ABMDREC,U,5)=$P($G(^AUTTLOC(+ABMDIEN,0)),U,15)  ;loc zip
 ;
 I $P(ABMDIEN,";",2)["AUTTVNDR" D  Q ABMDREC
 .S ABMDREC=$P($G(^AUTTVNDR(+ABMDIEN,0)),U)  ;vndr name
 .S $P(ABMDREC,U,2)=$P($G(^AUTTVNDR(+ABMDIEN,13)),U)  ;vndr street
 .S $P(ABMDREC,U,3)=$P($G(^AUTTVNDR(+ABMDIEN,13)),U,2)  ;vndr city
 .S $P(ABMDREC,U,4)=$S($P($G(^AUTTVNDR(+ABMDIEN,13)),U,3):$P($G(^DIC(5,$P(^AUTTVNDR(+ABMDIEN,13),U,3),0)),U),1:"")  ;vndr state
 .S $P(ABMDREC,U,5)=$P($G(^AUTTVNDR(+ABMDIEN,13)),U,4)  ;vndr zip
 Q ABMDREC
VALSTUFF ;
 K DA,DA(1),DIC,DR,DIR
 S DA(1)=ABMP("CDFN")
 S DIC="^ABMDCLM(DUZ(2),"_DA(1)_",55,"
 S DIC(0)="LM"
 S DIC("P")=$P(^DD(9002274.3,55,0),U,2)
 S X="A0"
 K DD,DO
 D ^DIC
 Q:+Y<0
 K DA,DA(1),DR,DIC,DIR
 S DA=+Y
 S DA(1)=ABMP("CDFN")
 S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",55,"
 S DR=".02////"_$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),12)),U,6)
 D ^DIE
 Q
 ; Entry of Claim Identifiers
2 ;;.1214 Point of Pickup Modifier
4 ;;.1216 Destination Modifier
7 ;;.1215 Was ambulance transport considered MEDICALLY NECESSARY?
8 ;;.1211
 ;; abm*2.6*6 5010 moved 9 to 10; 10 to 11; added new 9 for pt count
9 ;;1218
10 ;;.1212
11 ;;.1213
 ;
 ;transported to/for descriptions
A ;;NEAREST FAC.-CARE OF SYMPTOMS/COMPLAINTS/BOTH
B ;;BENEFIT OF PREFERRED PHYSICIAN
C ;;NEARNESS OF FAMILY MEMBERS
D ;;A SPECIALIST/AVAILABILITY OF SPECIALIZED EQUIP
E ;;TRANSFERRED TO REHAB FACILITY
