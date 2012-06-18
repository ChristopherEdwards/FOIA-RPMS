AGBICEDZ ; IHS/ASDS/EFG - ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 D PTLK^AG
 Q:'$D(DFN)  D VIDEO^AG S AG("SVELIG")="" I $D(^AUPNPAT(DFN,11)) S AG("SVELIG")=$P(^(11),U,24)
 Q:'$D(^DPT(DFN,0))  S AG("PG")="BICFLDS",AGPAT=$P(^DPT(DFN,0),U),AGCHRT=$P(^AUPNPAT(DFN,41,DUZ(2),0),U,2),AG("AUPN")="" S:$D(^AUPNPAT(DFN,0)) AG("AUPN")=^(0)
 S AGUPDT="" S Y=$P(AG("AUPN"),U,3) I Y]"" D DD^%DT S AGUPDT="(updated: "_Y_")"
 I AGUPDT="" S Y=$P(AG("AUPN"),U,2) I Y]"" D DD^%DT S AGUPDT="(file est: "_Y_")"
 S AGLINE("-")="W !,""------------------------------------------------------------------------------""",AGLINE("EQ")="W !,""=============================================================================="""
VAR D ^AGBIC2C,^AGED S DA=DFN,DR=1124,DIC=9000001 D ^AGDICLK W !!,"IHS ELIGIBILITY : ",AG("LKPRINT"),!!
 W !,"1.       COMMUNITY:" I $D(^AUPNPAT(DFN,11)) W ?22,$P(^(11),U,18) I $P(^(11),U,18)]"" W $S($P(^(11),U,21)="Y":" (VERIFIED)",$P(^(11),U,21)="N":" (UNVERIFIED)",1:" (UNVERIFIED)")
 W !,"2.           TRIBE:",?22 S AG("Y")=$P(^AUPNPAT(DFN,11),U,8)
 I AG("Y")]"",$D(^AUTTTRI(AG("Y"))) W $P(^AUTTTRI(AG("Y"),0),U) I $P(^(0),U,4)="Y" W ?$X+2,$$S^AGVDF("RVN"),"(OLD UNUSED TRIBE NAME)",$$S^AGVDF("RVF")
 I $D(^AUPNPAT(DFN,11)),$P(^(11),U,8)]"",$P(^(11),U,19)]"" W $S($P(^(11),U,19)="Y":" (VERIFIED)",$P(^(11),U,19)="U":" (UNABLE TO VERIFY (NO TRIBAL ROLE))",1:" (UNVERIFIED)")
 W !,"3.  INDIAN QUANTUM:",?22,$P(^AUPNPAT(DFN,11),U,10),! W !,AGLINE("EQ")
 W !!?23,"CHANGE which item? (1-3) NONE// " D READ^AGED1 Q:$D(DUOUT)!$D(DTOUT)!$D(DFOUT)  G END:$D(DLOUT)!(Y["N"),VAR:$D(AG("ERR")) I $D(DQOUT)!(+Y<1)!(+Y>3) D QUES^AGED1 G VAR
 S AG("SEL")=+Y
L7 D @($P("EDCOM^AG2B,TRIBE^AG2A,IQTM^AG2A",",",AG("SEL")))
 I AG("SEL")="1" G:'$D(AG("COMAGED1")) VAR S DIE="^AUPNPAT(",DA=DFN,DR="1121///"_AG("COMAGED1") D ^DIE,^AGBIC2C G ENDOPT
 I AG("SEL")=2&($P(^AUTTTRI($P(^AUPNPAT(DFN,11),U,8),0),U,4)="Y") D TRBMSG G:'$D(DUOUT) L7
ENDOPT D UPDATE^AGED,^AGBIC2C:AG("SEL")=3
 G VAR
END K AG,AGCHRT,AGLINE,AGPAT,AGUPDT,DA,DFOUT,DIC,DLOUT,DQOUT,DR,DTOUT,DUOUT,G,AGL,AG("LKDATA"),AG("LKERR"),AG("LKPRINT"),X,Y
 Q
TRBMSG W !,"OLD (unused) TRIBE.",!,"Please enter a current TRIBE name.",!,"""??"" for a list, ""^"" to exit."
 Q
