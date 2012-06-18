AQAOPC8 ; IHS/ORDC/LJF - OCC BY PROVIDER ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains the user interface for the occurrence-based reports
 ;by provider.  A user who is not a QI staff member cannot run the
 ;single provider profile and is dropped into^AQAOPC81.  This rtn lets
 ;the QI staff member set up the provider profile.  The calculate of
 ;the profile is rtn ^AQAOPC82.
 ;
TYPE ; -- ask user which provider report to print
 D PROV^AQAOHOP3 ;print intro text
 I $P(AQAOUA("USER"),U,6)="" D ^AQAOPC81 G EXIT ;if not qi staff
 W !! K DIR S DIR(0)="NAO^1:2",DIR("A")="  Select 1 or 2:  "
 S DIR("?")="^D PROVQ^AQAOHOP3"
 S DIR("A",1)="  TYPES OF PROVIDER REPORTS AVAILABLE:",DIR("A",2)=" "
 S DIR("A",3)="   1.  TRENDING reports sorted by provider"
 S DIR("A",4)="   2.  Single Provider PROFILE"
 S DIR("A",5)=" " D ^DIR G EXIT:$D(DIRUT),TYPE:Y<1
 S X=$S(Y=1:"^AQAOPC80",1:"PROFILE") D @X G TYPE
 ;
 ;
EXIT ; -- eoj
 D KILL^AQAOUTIL Q
 ;
 ;
 ;
PROFILE ; -- SUBRTN for starting point for single provider profile
 D PROFILE1^AQAOPC80,NAME Q
 ;
 ;
NAME ; >> ask if user wants provider name to print on report
 W !! K DIR S DIR(0)="Y",DIR("B")="NO"
 S DIR("A")="Do you want the provider/person name printed on the report"
 S DIR("?",1)="Answer YES to have the NAME print on the heading."
 S DIR("?",2)="Answer NO to have only the QI Code print on the report."
 D ^DIR G EXIT:$D(DTOUT),PROFILE:$D(DIRUT)
 I Y=0 S AQAOPRVN="#"_$S(AQAOPROV["VA":"I",1:"C")_+AQAOPROV
 ;
 ;
DATES ; >> ask for date range
 S AQAOBD=$$BDATE^AQAOLKP G NAME:AQAOBD=U,PROFILE:AQAOBD=""
 S AQAOED=$$EDATE^AQAOLKP G DATES:AQAOED=U,DATES:AQAOED=""
 ;
FORMAT ; >> individual indicators or grouped by med staff function?
 W !! K DIR S DIR("A")="Select PROFILE FORMAT"
 S DIR(0)="SO^1:List occurrences for INDIVIDUAL INDICATORS;2:List occurrences by MEDICAL STAFF FUNCTION"
 S DIR("?",1)="The provider profile lists case review results sorted by"
 S DIR("?",2)="indicator.  Choice #1 gives you the option to select"
 S DIR("?",3)="just those indicators you want.",DIR("?",4)=" "
 S DIR("?",5)="Choice #2 groups all indicators by selected medical"
 S DIR("?",6)="staff function.  This gives you an easy way to see all"
 S DIR("?",7)="Drug Usage Review cases without having to choose each"
 S DIR("?",8)="indicator separately.  Choice #2 includes the option"
 S DIR("?",9)="to list ALL occurrences for this provider."
 S DIR("?")=" "
 D ^DIR G DATES:$D(DIRUT),FORMAT:Y=-1
 I Y=1 D  G DEV
 .S AQAOMSF=1,AQAOMP(10)="** SELECTED INDICATORS **"
 .F  S Y=$$IND^AQAOLKP Q:Y=-1  Q:Y=U  S AQAOMSF(+Y)=""
 ;
MEDSTF ; >> ask user to select which med staff functions to print
 W !! K DIR S DIR(0)="LAO^0:10^K:X#1 X"
 S DIR("A")="Select One or More by Number (0-10):  "
 S DIR("A",1)="MEDICAL STAFF FUNCTIONS -",DIR("A",2)=" "
 F I=1:1:9 S DIR("A",I+2)=" "_I_".  "_$P($T(MSF+I),";;",2)
 S DIR("A",10)="     OR Enter 0 (zero) for ALL INDICATORS"
 S DIR("A",11)=" " D ^DIR
 G EXIT:$D(DTOUT),FORMAT:$D(DIRUT),MEDSTF:Y<0 S AQAOMSF=Y
 I AQAOMSF["0" S AQAOMSF(0)="",AQAOMSF="1,2,3,4,5,6,7,8,9,10"
 ;
 ; >> set MSF in printable format
 F I=1:1 S Y=$P(AQAOMSF,",",I) Q:Y=""  D
 .S X=$P($T(MSF+Y),";;",2) Q:X=""
 .S AQAOMP(Y)="** "_X_" **"
 I $D(AQAOMSF(0)) S AQAOMP(10)="** OTHER INDICATORS **"
 ;
IND ; >> for MSF chosen get indicators
 S AQAOX=0 F I=1:1 S AQAOX=$P(AQAOMSF,",",I) Q:AQAOX=""  D  G MEDSTF:Y=U
 .S AQAOY=0 F  S AQAOY=$O(^AQAO(2,"AD",AQAOX,AQAOY)) Q:AQAOY=""  D
 ..S AQAOMSF(AQAOY)="" ;array(ind ifn)
 I '$D(AQAOMSF(0)),'$O(AQAOMSF(0)) D  G MEDSTF
 .K AQAOMSF,AQAOMP
 .W !,*7,"NO INDICATORS FOUND!"
 ;
 ;
DEV ; >> get print device
 W !! S %ZIS="QP" D ^%ZIS I POP D EXIT Q
 I '$D(IO("Q")) U IO D ^AQAOPC82 Q
 K IO("Q") S ZTRTN="^AQAOPC82",ZTDESC="PROVIDER PROFILE"
 F I="AQAOMSF","AQAOMSF(","AQAOMP(","AQAOBD","AQAOED","AQAOPROV","AQAOPRVN" S ZTSAVE(I)=""
 D ^%ZTLOAD D HOME^%ZIS D EXIT Q
 ;
 ;
MSF ;;
 ;;Review of SURGICAL Procedures
 ;;DRUG Usage Review
 ;;Medical RECORDS Review
 ;;BLOOD Usage Review
 ;;PHR & THERAPEUTICS Function
 ;;MORTALITY/MORBIDITY Review
 ;;INFECTION CONTROL
 ;;SAFETY Review
 ;;Ongoing MONITORING & EVALUATION
