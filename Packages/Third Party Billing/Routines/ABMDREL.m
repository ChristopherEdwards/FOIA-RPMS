ABMDREL ; IHS/ASDST/DMJ - List holders of medicare a, b, medicaid or priv ins ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
START I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",! Q
 I '$D(ABMDRPT) W !,$C(7),$C(7),"REPORT TYPE MISSING!!  NOTIFY PROGRAMMER",! Q
 D GETINFO G:$D(ABMD("Q")) QUIT
 W !!,"This option will print a list of Patients who are registered at",!,"the facility that you select who are currently enrolled in ",ABMD("INF"),".",!
 W !,"You will be asked to enter an 'As of' date to be used in determining",!,"those patients who are 'actively' enrolled.",!
 W !,"The report will be sorted alphabetically by Patient Name.",!
F ;
 S DIC("A")="Which Facility: ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 QUIT
 S ABMD("SU")=+Y
AOD ;
 S %DT("A")="Patients are to be considered ACTIVE as of what date: ",%DT="AEPX" W ! D ^%DT
 I Y=-1 G F
 S ABMD("ACE")=Y D DD^%DT S ABMD("ACEY")=Y
 S ABMD("$J")=DUZ_"-"_$P($H,",",1)_"-"_$P($H,",",2)
 S ABMQ("RC")="^ABMDREL2",ABMQ("RP")="^ABMDREL1",ABMQ("RX")="EOJ^ABMDREL0",ABMQ("NS")="ABMD"
 D ^ABMDRDBQ
QUIT K ABMD,ABMDRPT
 Q
 ;
GETINFO ;
 I $T(@(ABMDRPT))="" W !!,$C(7),$C(7),"REPORT INFORMATION MISSING!! NOTIFY PROGRAMMER!",!! S ABMD("Q")="" Q
 S ABMD("INFO")=$T(@(ABMDRPT)),ABMD("VAL")=$P(ABMD("INFO"),";;",2),ABMD("PROC")=$P(ABMD("INFO"),";;",4),ABMD("INF")=$P(ABMD("INFO"),";;",3),ABMD("TITL")=$P(ABMD("INFO"),";;",5)
 Q
 ;
MCD ;;X;;Medicaid;;MCD;;ACTIVE MEDICAID ENROLLEES
MCRA ;;A;;Medicare Part A;;MCRA;;ACTIVE MEDICARE PART A ENROLLEES
MCRB ;;B;;Medicare Part B;;MCRA;;ACTIVE MEDICARE PART B ENROLLEES
PI ;;X;;Private Insurance;;PI;;ACTIVE PRIVATE INSURANCE ENROLLEES
