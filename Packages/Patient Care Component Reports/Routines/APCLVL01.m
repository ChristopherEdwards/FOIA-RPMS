APCLVL01 ; IHS/CMI/LAB - SCREEN LOGIC ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
INFORM ;EP
 S APCLTCW=0
 W:$D(IOF) @IOF
 S APCLLHDR="PCC "_$S(APCLPTVS="V":"VISIT",1:"PATIENT")_" GENERAL RETRIEVAL"
 W ?((80-$L(APCLLHDR))/2),APCLLHDR
 W !,"This report will list or count "_$S(APCLPTVS="V":"visits",1:"patients")_"  based on selection criteria"
 W !,"entered by the user.  You will be asked, in three separate steps, to identify"
 W !,"your selection criteria, what you wish displayed for each "_$S(APCLPTVS="V":"visit",1:"patient")_", and the ",!,"sorting order for your list.  You may save the logic used to produce the report "
 W !,"for future use.  If you design a report that is 80 characters or less in width,",!,"it can be displayed on your screen or printed.  If your report is 81-132"
 W !,"characters wide, it must be printed - and only on a printer capable of ",!,"producing 132 character lines.  You may limit the "_$S(APCLPTVS="V":"visits",1:"patients")_"  in your report to",!,"pre-established Search"
 W " Templates you have created in QMan, Case Management, or",!,"other RPMS tools.  If your"
 W " template was created in Case Management or in QMan,",!,"using Patients as the Search Subject, this is a Search Template of Patients.",!
 G:APCLPTVS="P" INFORMQ
 W "If your template was created in QMan using Visits as the Search Subject, this is",!,"a Search Template of Visits."
 W !,"Select one of the following and then proceed to the Date Range and"
 W !,"Selection Criteria screens:"
INFORMQ Q
ADD ;EP
 K APCLCAND
 W !!
 I $D(APCLNCAN) G ADD1
 I $D(APCLSEAT),'$D(APCLEP1) G ADD1
 S DIR(0)="Y",DIR("A")="Do you want to use a PREVIOUSLY DEFINED REPORT",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S APCLQUIT=1 Q
 I 'Y G ADD1
 S DIC="^APCLVRPT(",DIC("S")="I $P(^(0),U,2)&($P(^(0),U,6)=APCLPTVS)" S:$D(APCLEP1) DIC("S")=DIC("S")_"&($P(^(0),U,9)=APCLPACK)" S DIC(0)="AEQ",DIC("A")="REPORT NAME:  ",D="C" D IX^DIC K DIC,DA,DR
 I Y=-1 S APCLQUIT=1 Q
 S APCLRPT=+Y,APCLCAND=1
 ;--- set up sorting and report control variables
 S APCLSORT=$P(^APCLVRPT(APCLRPT,0),U,7),APCLSORV=$P(^(0),U,8),APCLSPAG=$P(^(0),U,4),APCLCTYP=$P(^(0),U,5),$P(^APCLVRPT(APCLRPT,13),U)=$G(APCLBD),$P(^APCLVRPT(APCLRPT,13),U,2)=$G(APCLED)
 S X=0 F  S X=$O(^APCLVRPT(APCLRPT,12,X)) Q:X'=+X  S APCLTCW=APCLTCW+$P(^APCLVRPT(APCLRPT,12,X,0),U,2)+2
 Q
ADD1 ;
 ;CREATE REPORT ENTRY IN FILEMAN FILE
 S %H=$H D YX^%DTC S X=$P(^VA(200,DUZ,0),U)_"-"_Y,DIC(0)="L",DIC="^APCLVRPT(",DLAYGO=9001003.8,DIADD=1,DIC("DR")=".13////"_DUZ D ^DIC K DIC,DA,DR,DIADD,DLAYGO I Y=-1 W !!,"UNABLE TO CREATE REPORT FILE ENTRY - NOTIFY SITE MANAGER!" S APCLQUIT=1 Q
 S APCLRPT=+Y
 K DIC,DIADD,DLAYGO,DR,DA,DD,X,Y,DINUM
 ;DELETE ALL 11 MULTIPLE HERE
 K ^APCLVRPT(APCLRPT,11)
 Q
PAUSE ;EP
 Q:$E(IOST)'="C"!(IO'=IO(0))
 W ! S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
 ;
N ;EP
 K ^APCLVRPT(APCLRPT,11,APCLCRIT),^APCLVRPT(APCLRPT,11,"B",APCLCRIT)
 S DIR(0)="FO^1:20",DIR("A")=$S($G(^APCLVSTS(APCLCRIT,28))]"":^APCLVSTS(APCLCRIT,28),1:"Enter a Range of numbers (e.g. 5-12,1-1)"),DIR("?")=$S($G(^APCLVSTS(APCLCRIT,27))]"":^APCLVSTS(APCLCRIT,27),1:"Enter a range of number (e.g. 5-12, 1-1)")
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !!,"No numeric range entered.  All numerics will be included." Q
 I $D(^APCLVSTS(APCLCRIT,25)) S X=Y X ^(25) I '$D(X),$D(^APCLVSTS(APCLCRIT,26)) W !! X ^(26) G N ;if input tx exists and fails G N
 I '$D(^APCLVSTS(APCLCRIT,25)),Y'?1.3N1"-"1.3N W !!,$C(7),$C(7),"Enter a numeric range in the format nnn-nnn.  E.g. 0-5, 0-99, 5-20." G N
 S ^APCLVRPT(APCLRPT,11,APCLCRIT,0)=APCLCRIT,^APCLVRPT(APCLRPT,11,"B",APCLCRIT,APCLCRIT)=""
 S ^APCLVRPT(APCLRPT,11,APCLCRIT,11,0)="^9001003.8110101A^1^1" S ^APCLVRPT(APCLRPT,11,APCLCRIT,11,1,0)=$P(Y,"-"),^APCLVRPT(APCLRPT,11,APCLCRIT,11,"B",$P(Y,"-"),1)=""
 S $P(^APCLVRPT(APCLRPT,11,APCLCRIT,11,1,0),U,2)=$P(Y,"-",2)
 Q
J ;EP - JUST A HIT
 S ^APCLVRPT(APCLRPT,11,APCLCRIT,0)=APCLCRIT,^APCLVRPT(APCLRPT,11,"B",APCLCRIT,APCLCRIT)=""
 S ^APCLVRPT(APCLRPT,11,APCLCRIT,11,1,0)=1,^APCLVRPT(APCLRPT,11,APCLCRIT,11,"B",1,1)="",^APCLVRPT(APCLRPT,11,APCLCRIT,11,0)="^9001003.8110101A^"_1_"^"_1
 Q
Y ;EP - called from apclvl0
 S DIR(0)="S^1:"_APCLTEXT_";0:NO "_APCLTEXT_"",DIR("A")="Should "_$S(APCLPTVS="P":"patient",1:"visit")_" have",DIR("B")="1" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:Y=""
 S ^APCLVRPT(APCLRPT,11,APCLCRIT,0)=APCLCRIT,^APCLVRPT(APCLRPT,11,"B",APCLCRIT,APCLCRIT)=""
 S ^APCLVRPT(APCLRPT,11,APCLCRIT,11,1,0)=Y,^APCLVRPT(APCLRPT,11,APCLCRIT,11,"B",Y,1)="",^APCLVRPT(APCLRPT,11,APCLCRIT,11,0)="^9001003.8110101A^"_1_"^"_1
 Q
C ;EP
 W !!,"Enter a string which will be searched for in the narrative text.",!,"The system will check for any narrative that contains this string.",!
 K ^APCLVRPT(APCLRPT,11,APCLCRIT),^APCLVRPT(APCLRPT,11,"B",APCLCRIT)
 S DIR(0)="FO^1:40",DIR("A")="Enter a String of Characters for Search (e.g. DIABETES) " D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !!,"No range entered.  All ",APCLTEXT,"  will be included." Q
 ;I $D(^APCLVSTS(APCLCRIT,21)) S X=Y X ^(21) I '$D(X),$D(^APCLVSTS(APCLCRIT,22)) W !! X ^(22) G F ;if input tx exists and fails G N
 ;I '$D(^APCLVSTS(APCLCRIT,21)),Y'?1.ANP1":"1.ANP W !!,$C(7),$C(7),"Enter an free text range in the format AAA:AAA.  E.g. 94-01:94-200,CA:CZ, A:Z." G F
 S ^APCLVRPT(APCLRPT,11,APCLCRIT,0)=APCLCRIT,^APCLVRPT(APCLRPT,11,"B",APCLCRIT,APCLCRIT)=""
 S APCLCNT=0,^APCLVRPT(APCLRPT,11,APCLCRIT,11,APCLCNT,0)="^9001003.8110101A^1^1" S APCLCNT=APCLCNT+1,^APCLVRPT(APCLRPT,11,APCLCRIT,11,1,0)=X,^APCLVRPT(APCLRPT,11,APCLCRIT,11,"B",X,APCLCNT)=""
 Q
S ;EP
 ;special logic for hard coded lookups
 X ^APCLVSTS(APCLCRIT,5)
 Q
LABLOINC ;EP
 ;prompt for lab tests, loinc codes, taxonomy on each
 W !,"This selection item allows you to search for visits on which selected"
 W !,"lab test were done.  You can search by selected lab test names, a taxonomy"
 W !,"of lab test names, by selected loinc codes, by a taxonomy of LOINC codes,"
 W !,"or by any combination of the above."
 K APCLLABT
LABL ;
 I $D(APCLLABT) D LABLIST
 W !,"Please select which of the items below you want to use to search"
 W !,"for lab tests:"
 S DIR(0)="SO^1:Lab Test Name;2:Lab Test Taxonomy;3:LOINC Code;4:LOINC Code Taxonomy",DIR("A")="Select" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I Y="" Q
 S APCLCH=Y
 I APCLCH=1 D LABL1
 I APCLCH=2 D LABL2
 I APCLCH=3 D LABL3
 I APCLCH=4 D LABL4
 G LABL
LABL1 ;
 W !,"Please enter an '^' when you are finished selecting lab tests"
 K DIR S DIR(0)="9000010.09,.01",DIR("A")="Enter Lab Test Name" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S APCLLABT("LAB",+Y)=""
 G LABL1
LABL2 ;
 K DIC,DLAYGO,DIADD S DIC="^ATXLAB(",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 Q
 S X=0 F  S X=$O(^ATXLAB(+Y,21,X)) Q:X'=+X  S Z=$P(^ATXLAB(+Y,21,X,0),U),APCLLABT("LAB",Z)=""
 G LABL2
LABL3 ;
 W !,"Please enter an '^' when you are finished selecting lab tests"
 K DIR S DIR(0)="9000010.09,1113",DIR("A")="Enter LOINC Code" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S Z=$P(^LAB(95.3,+Y,0),U)_$P(^LAB(95.3,+Y,0),U,15)
 S APCLLABT("LOINC",Z)=""
 G LABL3
LABL4 ;
 K DIC,DLAYGO,DIADD S DIC="^ATXAX(",DIC(0)="AEMQ",DIC("S")="I $P(^(0),U,15)=95.3" D ^DIC K DIC
 I Y=-1 Q
 S X=0 F  S X=$O(^ATXAX(+Y,21,X)) Q:X'=+X  S Z=$P(^ATXAX(+Y,21,X,0),U),APCLLABT("LOINC",Z)=""
 G LABL4
LABLIST ;
 W !!,"So far you have selected the following lab tests and/or LOINC Codes:"
 S X="",C=0 F  S X=$O(APCLLABT("LAB",X)) Q:X'=+X  D
 .I C=3 S C=1 I 1
 .E  S C=C+1
 .I C=1 W !
 .W ?$S(C=1:1,C=2:27,C=3:53),$E($P(^LAB(60,X,0),U),1,25)
 .Q
 S X="",C=0 F  S X=$O(APCLLABT("LOINC",X)) Q:X=""  D
 .I C=3 S C=1 I 1
 .E  S C=C+1
 .I C=1 W !
 .W ?$S(C=1:1,C=2:27,C=3:53),X
 .Q
 Q:'$D(APCLLABT)
 S ^APCLVRPT(APCLRPT,11,APCLCRIT,0)=APCLCRIT,^APCLVRPT(APCLRPT,11,"B",APCLCRIT,APCLCRIT)=""
 S ^APCLVRPT(APCLRPT,11,APCLCRIT,11,0)="^9001003.8110101A^1^1" S ^APCLVRPT(APCLRPT,11,APCLCRIT,11,1,0)=1,^APCLVRPT(APCLRPT,11,APCLCRIT,11,"B",1,1)=""
 Q
 ;
GETREG ;EP
 ;get register name to use to exclude patients
 K APCLEXRG
 S DIC="^ACM(41.1,",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Register containing the patients to exclude: " D ^DIC K DIC
 I Y=-1 Q
 S APCLEXRG=+Y
 S ^APCLVRPT(APCLRPT,11,APCLCRIT,0)=APCLCRIT,^APCLVRPT(APCLRPT,11,"B",APCLCRIT,APCLCRIT)=""
 S ^APCLVRPT(APCLRPT,11,APCLCRIT,11,0)="^9001003.8110101A^1^1" S ^APCLVRPT(APCLRPT,11,APCLCRIT,11,1,0)=+Y,^APCLVRPT(APCLRPT,11,APCLCRIT,11,"B",+Y,1)=""
 Q
 ;
FAMHXR ;EP - family history with relation
 ;get diagnosis and relation and store as 2 pieces
 ;with a dash in between
 K AMQQTAXN
 K ^XTMP("APCLVL",$J,"QMAN"),^UTILITY("AMQQ TAX",$J)
 K DIC,X,Y,DD S X="FAMILY HISTORY DIAGNOSIS",DIC="^AMQQ(5,",DIC(0)="EQXM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA,DINUM,DICR I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" Q
 S APCLQMAN=+Y
 D PEP^AMQQGTX0(APCLQMAN,"^XTMP(""APCLVL"",$J,""QMAN"",")
 I '$D(^XTMP("APCLVL",$J,"QMAN")) W !!,$C(7),"** No ",$P(^APCLVSTS(APCLCRIT,0),U)," selected, all will be included." D PAUSE
 I $D(^XTMP("APCLVL",$J,"QMAN","*")) K ^XTMP("APCLVL",$J,"QMAN") W !!,"All diagnosis will be included." D PAUSE
 ;now get relation
 K DIC
 K APCLREL D GETREL
 I '$O(APCLREL(0)) W !!,"No relationships selected, ANY non-null relationship will be included." D PAUSE
 S ^APCLVRPT(APCLRPT,11,APCLCRIT,0)=APCLCRIT,^APCLVRPT(APCLRPT,11,"B",APCLCRIT,APCLCRIT)=""
 I '$D(^XTMP("APCLVL",$J,"QMAN")) D  G Q1
 .S X=""
 .I '$D(APCLREL) S Z="",Y=Y+1,^APCLVRPT(APCLRPT,11,APCLCRIT,11,Y,0)=X_"-"_Z,^APCLVRPT(APCLRPT,11,APCLCRIT,11,"B",X_"-"_Z,Y)="",^APCLVRPT(APCLRPT,11,APCLCRIT,11,0)="^9001003.8110101A^"_Y_"^"_Y Q
 .S Z=0 F  S Z=$O(APCLREL(Z)) Q:Z'=+Z  D
 ..S Y=Y+1,^APCLVRPT(APCLRPT,11,APCLCRIT,11,Y,0)=X_"-"_Z,^APCLVRPT(APCLRPT,11,APCLCRIT,11,"B",X_"-"_Z,Y)="",^APCLVRPT(APCLRPT,11,APCLCRIT,11,0)="^9001003.8110101A^"_Y_"^"_Y
 ;
 S X="",Y=0 F  S X=$O(^XTMP("APCLVL",$J,"QMAN",X)) Q:X=""  D
 .I '$D(APCLREL) S Z="",Y=Y+1,^APCLVRPT(APCLRPT,11,APCLCRIT,11,Y,0)=X_"-"_Z,^APCLVRPT(APCLRPT,11,APCLCRIT,11,"B",X_"-"_Z,Y)="",^APCLVRPT(APCLRPT,11,APCLCRIT,11,0)="^9001003.8110101A^"_Y_"^"_Y Q
 .S Z=0 F  S Z=$O(APCLREL(Z)) Q:Z'=+Z  D
 ..S Y=Y+1,^APCLVRPT(APCLRPT,11,APCLCRIT,11,Y,0)=X_"-"_Z,^APCLVRPT(APCLRPT,11,APCLCRIT,11,"B",X_"-"_Z,Y)="",^APCLVRPT(APCLRPT,11,APCLCRIT,11,0)="^9001003.8110101A^"_Y_"^"_Y
Q1 K X,Y,Z,APCLQMAN,V,AMQQSQNM,AMQQTAXN
 K ^XTMP("APCLVL",$J,"QMAN")
 K APCLREL,DIR
 Q
GETREL ;
 K DIR
 S DIR(0)="9000014.1,.01O",DIR("A")="ENTER PCC RELATIONSHIP" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:Y=-1
 I Y="" Q
 S APCLREL(+Y)=""
 G GETREL
 Q
APPTS ;EP - Appointments
 ;get date range as pieces 1 and 2 and clinics as pieces 3-99 or 3rd piece blank if any clinic
 ;beginning and ending date
 NEW APCLBDAT,APCLEDAT,APCLSDAT,APCLCLN,APCLT
APPTBD ;get beginning date
 W ! S DIR(0)="D^::EP",DIR("A")="Enter beginning Appointment date for Search" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) Q
 S APCLBDAT=Y
APPTED ;get ending date
 W ! S DIR(0)="D^"_APCLBDAT_"::EP",DIR("A")="Enter ending Appointment date for Search" S Y=APCLBDAT D DD^%DT S DIR("B")=Y,Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G APPTBD
 S APCLEDAT=Y
 S X1=APCLBDAT,X2=-1 D C^%DTC S APCLSDAT=X_".9999"
 ;get clinics
APPCLNS ;
 K APCLCLN
 S APCLT=""
 S DIR(0)="S^A:ANY Clinic (All Clinics);S:Selected Set of Clinics",DIR("A")="Which Appointment Clinics should be included",DIR("B")="S" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"No Clinics chosen....item will not be used as a selection item..." D PAUSE Q
 I Y="A" G SETAPPT
 ;
 K APCLCLN
APPCLNS1 ;
 S DIR(0)="9001003.7,999916",DIR("A")="Enter APPOINTMENT CLINIC" KILL DA D ^DIR KILL DIR
 I $D(DIRUT),'$O(APCLCLN(0)) W !!,"No clinics chosen...." G APPCLNS
 I Y="",'$O(APCLCLN(0)) W !!,"No clinics chosen...." G APPCLNS
 I Y S APCLCLN(+Y)="" G APPCLNS1
SETAPPT ;
 K APCLCLN
 S ^APCLVRPT(APCLRPT,11,APCLCRIT,0)=APCLCRIT,^APCLVRPT(APCLRPT,11,"B",APCLCRIT,APCLCRIT)=""
 S APCLCNT=0,^APCLVRPT(APCLRPT,11,APCLCRIT,11,APCLCNT,0)="^9001003.8110101A^1^1"
 S ^APCLVRPT(APCLRPT,11,APCLCRIT,11,1,0)=APCLBDAT_U_APCLEDAT
 S C=2,X=0 F  S X=$O(APCLCLN(X)) Q:X'=+X  S C=C+1,$P(^APCLVRPT(APCLRPT,11,APCLCRIT,11,1,0),U,C)=X
 S ^APCLVRPT(APCLRPT,11,APCLCRIT,11,"B",APCLBDAT,APCLCNT)=""
 Q
PLDOO ;EP - Appointments
 ;get date range as pieces 1 and 2 and clinics as pieces 3-99 or 3rd piece blank if any clinic
 ;beginning and ending date
 NEW APCLBDAT,APCLEDAT,APCLSDAT,APCLCLN,APCLT
PLDOOBD ;get beginning date
 W ! S DIR(0)="D^::EP",DIR("A")="Enter beginning Date of Onset for Search" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) Q
 S APCLBDAT=Y
PLDOOED ;get ending date
 W ! S DIR(0)="D^"_APCLBDAT_"::EP",DIR("A")="Enter ending Date of Onset date for Search" S Y=APCLBDAT D DD^%DT S DIR("B")=Y,Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G PLDOOBD
 S APCLEDAT=Y
 S X1=APCLBDAT,X2=-1 D C^%DTC S APCLSDAT=X_".9999"
 ;get clinics
PLDXS ;
 K APCLPDOO
 S APCLT=""
 S DIR(0)="S^A:ANY Diagnosis;S:Selected Set of Diagnoses",DIR("A")="Which Problem List Diagnoses should be included",DIR("B")="S" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !!,"No dx chosen....item will not be used as a selection item..." D PAUSE Q
 I Y="A" G SETPLDOO
 ;
 K APCLPDOO
PLDXS1 ;
 K AMQQTAXN
 K ^XTMP("APCLVL",$J,"QMAN"),^UTILITY("AMQQ TAX",$J)
 K DIC,X,Y,DD S X="DIAGNOSIS",DIC="^AMQQ(5,",DIC(0)="EQXM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA,DINUM,DICR I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" Q
 S APCLQMAN=+Y
 D PEP^AMQQGTX0(APCLQMAN,"^XTMP(""APCLVL"",$J,""QMAN"",")
 I '$D(^XTMP("APCLVL",$J,"QMAN")) W !!,$C(7),"** No ",$P(^APCLVSTS(APCLCRIT,0),U)," selected." G PLDXS
 I $D(^XTMP("APCLVL",$J,"QMAN","*")) K ^XTMP("APCLVL",$J,"QMAN") W !!,"*** All items selected, if you want all then choose ANY diagnosis." G PLDXS
 S X="",Y=0 F  S X=$O(^XTMP("APCLVL",$J,"QMAN",X)) Q:X=""  S APCLPDOO(X)=""
Q11 K X,Y,Z,APCLQMAN,V,AMQQSQNM,AMQQTAXN
 K ^XTMP("APCLVL",$J,"QMAN")
SETPLDOO ;
 S ^APCLVRPT(APCLRPT,11,APCLCRIT,0)=APCLCRIT,^APCLVRPT(APCLRPT,11,"B",APCLCRIT,APCLCRIT)=""
 S APCLCNT=0,^APCLVRPT(APCLRPT,11,APCLCRIT,11,APCLCNT,0)="^9001003.8110101A^1^1"
 S ^APCLVRPT(APCLRPT,11,APCLCRIT,11,1,0)=APCLBDAT_U_APCLEDAT
 S ^APCLVRPT(APCLRPT,11,APCLCRIT,11,"B",APCLBDAT,APCLCNT)=""
 Q
