AZZDACK ; CHECK DATA FOR ALL REG PATIENTS AT SELECTED SITE;[ 01/02/90  1:50 PM ]
 ; Mike Remillard, ISC/BAO
 ; IHS/MFD changed description- active registration patients
START ;
 K ^AZZDA D ^AUKVAR,^%AUCLS
 W ?6,"* * CHECK ALL ACTIVE PATIENTS FOR MISSING OR INVALID REG DATA * *"
 ;-----> ASK LOCATION.
 W !!!!,"Select a Location for the patient records you wish to scan.",!
 S:'$D(IOSL) IOSL=24
 S DIC="^AUTTLOC(",DIC(0)="QEMA",DIC("A")="Location: "
 D ^DIC Q:Y=-1
 S DUZ(2)=$P(Y,U),(AZZDA("ALL"),AZZDA("HERE"),AZZDA("BAD"),DFN)=0
 S AZZDA("SITE")=$P(^DIC(4,DUZ(2),0),U)
 D PROMPT Q:QQ=U
SCAN ;-----> BEGIN SCAN.
 D VARS,HEADER1 Q:QQ="^"  W !!
 F  S DFN=$O(^DPT(DFN)) Q:'DFN  S AZZDA("ALL")=AZZDA("ALL")+1 D
 .W:'(AZZDA("ALL")#1500) !!?12,"  *** STILL SCANNING ",AZZDA("SITE")," ***  ",!!
 .;-----> CHECK IF DECEASED.
 .I $D(^DPT(DFN,.35)) W "-" Q
 .;-----> CHECK IF REG'D AT THIS SITE; ALSO, QUIT IF FILE IS INACTIVE.
 .I $D(^AUPNPAT(DFN,41,DUZ(2))) Q:$P(^(DUZ(2),0),U,3)  S AZZDA("HERE")=AZZDA("HERE")+1 D ^AGDATCK W:AG("DTOT")=0 "." D:AG("DTOT")>0 STORE Q
 .W "-"
 D PROMPT1 D:QQ'=U TOTALS
 D PROMPT D:QQ'=U PRINT
EXIT ;
 X ^%ZIS("C")
 K AG,AZZDA,X,I,QQ,^AZZDA
 Q
STORE ;
 ;-----> STORE DATA IN GLOBAL, TOTALS IN LOCAL VARIABLES.
 S AZZDA("BAD")=AZZDA("BAD")+1 W "X"
 S ^AZZDA(DFN)=$P(^DPT(DFN,0),"^",1)
 S $P(^AZZDA(DFN),U,2)=$P(^AUPNPAT(DFN,41,DUZ(2),0),"^",2)
 F I=1:1:12 S:$D(AG("ER",I)) $P(^AZZDA(DFN),U,(I+2))=1,AZZDA("AG",I)=AZZDA("AG",I)+1
 Q
TOTALS ;
 ;-----> PRINT TOTAL STATISTICS ON SCAN FOR THIS LOCATION.
 W !! S %ZIS="",%ZIS("A")="Select DEVICE to print statistics: " D ^%ZIS Q:POP  U IO
 D HEADER3
 F I=1:1:12 D:$Y>(IOSL-7) PROMPT Q:QQ=U  D:$Y>(IOSL-7) HEADER3 W:AZZDA("AG",I) !!?5,"Patients with ",AG(I),":",?55,$J(AZZDA("AG",I),10)
 W !!,"   ----------------------------------------------",?55,"-----------"
 D:$Y>(IOSL-8) PROMPT Q:QQ=U  D:$Y>(IOSL-8) HEADER3
 W !?5,"Total patients at ",AZZDA("SITE")
 W !?5,"with Missing or Invalid data: ",?55,$J(AZZDA("BAD"),10)
 W !!?5,"Total patients in this database"
 W !?5,"registered at ",AZZDA("SITE"),": ",?55,$J(AZZDA("HERE"),10)
 W !!?5,"Total patients in the database: ",?55,$J(AZZDA("ALL"),10)
 X ^%ZIS("C")
 Q
PRINT ;
 ;-----> PRINT MISSING/INVALID DATA FOR EACH INDIVIDUAL PATIENT.
 W !! S %ZIS="",%ZIS("A")="Select DEVICE to print individual errors: " D ^%ZIS Q:POP  U IO
 S DFN=0 D HEADER2
 F  S DFN=$O(^AZZDA(DFN)) Q:'DFN  D:$Y>(IOSL-10) PROMPT Q:QQ=U  D:$Y>(IOSL-10) HEADER2 D
 .W !!,"PATIENT: ",$P(^AZZDA(DFN),U),!
 .W "CHART #: ",$P(^AUPNPAT(DFN,41,DUZ(2),0),"^",2)
 .W " at ",AZZDA("SITE")
 .W !!?5,"Missing/Invalid data:"
 .F I=1:1:12 W:$P(^AZZDA(DFN),U,(I+2)) ?28,"** ",AG(I),!
 D:QQ'=U PROMPT
 W @IOF X ^%ZIS("C")
 Q
VARS ;
 ;-----> SET UP NECESSARY LOCAL VARIABLES.
 S AG(1)="invalid NAME entry",AG(2)="invalid CHART NUMBER",AG(3)="missing DATE OF BIRTH",AG(4)="invalid SEX entry",AG(5)="missing TRIBE entry"
 S AG(6)="missing INDIAN QUANTUM",AG(7)="missing CURRENT COMMUNITY",AG(8)="missing BENEFICIARY entry",AG(9)="invalid ELIGIBILITY entry"
 S AG(10)="patient not eligible for BIC",AG(11)="missing SOCIAL SECURITY NUMBER",AG(12)="OLD (unused) TRIBE still use"
 F I=1:1:12 S AZZDA("AG",I)=0
 Q
PROMPT ;
 I IOSL>24 S QQ="" Q
 F  W ! Q:$Y>17
PROMPT1 R !!?23,"Press <return> to continue. ",QQ:DTIME
 Q
HEADER1 ;
 D ^%AUCLS W "During the scanning processes the following symbols will be displayed:"
 W !!?3,"""X"" = Patients with missing/invalid data."
 W !?3,"""."" = Patients registered with correct data."
 W !?3,"""-"" = Patients in the database not registered at ",$E(AZZDA("SITE"),1,28)
 D PROMPT1 Q:QQ="^"
 W !!!!?6,"* * *   SCANNING FOR PATIENTS WITH MISSING OR INVALID DATA   * * *",!,?22,"AT ",AZZDA("SITE")
 Q
HEADER2 ;
 W @IOF,!?8,"* * *   PATIENTS WITH MISSING OR INVALID REQUIRED DATA   * * *",!,?22,"AT ",AZZDA("SITE"),!! Q
HEADER3 ;
 W @IOF,?6,"* * *   STATISTICS ON PATIENTS WITH MISSING OR INVALID DATA   * * *",!,?22,"AT ",AZZDA("SITE"),!! Q
