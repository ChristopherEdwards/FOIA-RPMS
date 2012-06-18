ABME10 ; IHS/DSD/DMJ - Medicare Electronic ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 K ABMR S U="^",ABMP("XMIT")=0,ABMY("TOT")="0^0^0"
 S XMSUB=$S(ABMP("EXP")=10:"INPATIENT MEDICARE BILLS FROM ",1:"")_$P(^AUTTLOC(DUZ(2),0),U)
 S XMDUZ=DUZ
 D XMZ^XMA2 I XMZ<1 W !!,*7,"Unable to create mail message at this time.",! Q
 D R01
 K ABMR Q
R01 ;RECORD 01
 S $P(ABMR(1)," ",193)=""
 S $E(ABMR(1),1,2)="01"
 S ^XMB(3.9,XMZ,2,2,0)=ABMR(1)
 Q
BDFN S ABMY("N")=0 F  S ABMY("N")=$O(ABMY(ABMY("N"))) Q:'ABMY("N")  D
 .S ABMP("BDFN")=0 F  S ABMP("BDFN")=$O(ABMY(ABMY("N"),ABMP("BDFN"))) Q:'ABMP("BDFN")  D
 ..Q:'$D(^ABMDBILL(ABMP("BDFN"),0))
 ..D ENT
 ..S $P(ABMY("TOT"),U)=$P(ABMY("TOT"),U)+1
XMIT ..I ABMP("XMIT")=0 S ABM("XM")="" F  S ABM("XM")=$O(^ABMDTXST("B",DT,ABM("XM"))) Q:'ABM("XM")  D  Q:ABMP("XMIT")
 ...Q:'$D(^ABMDTXST(ABM("XM"),0))  Q:$P(^(0),U,2)'=ABMP("EXP")
 ...I $D(ABMY("TYP")),$P(^ABMDTXST(ABM("XM"),0),U,3)=ABMY("TYP") S ABMP("XMIT")=ABM("XM")
 ...I $D(ABMY("INS")),$P(^ABMDTXST(ABM("XM"),0),U,4)=ABMY("INS") S ABMP("XMIT")=ABM("XM")
 ..I '+ABMP("XMIT") S DIC="^ABMDTXST(",DIC(0)="L",X=DT,DIC("DR")=".02////1;.07////1;.08////1;"_$S($D(ABMY("TYP")):".03////"_ABMY("TYP"),$D(ABMY("INS")):".04////"_$P(ABMY("INS"),U),1:".03////A")_";.05////"_DUZ
 ..I  K DD,DO D FILE^DICN S ABMP("XMIT")=+Y
 ..S DIE="^ABMDBILL(",DA=ABMP("BDFN"),DR=".04////B;.16////A;.17////"_ABMP("XMIT") D ^ABMDDIE Q:$D(ABM("DIE-FAIL"))
 ..K ^ABMDBILL("AS",+^ABMDBILL(ABMP("BDFN"),0),"A",ABMP("BDFN"))
 ..S ABM=ABMP("BDFN"),ABM("L")=ABMP("XMIT") K ABMP S ABMP("XMIT")=ABM("L"),ABMP("BDFN")=ABM
 Q
 ;
ENT ;EP for setting up export array
 K ABMR
 Q
