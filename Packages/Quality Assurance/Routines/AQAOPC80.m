AQAOPC80 ; IHS/ORDC/LJF - OCC BY PROVIDER ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This trending report by provider is similar to the one by special
 ;review type.  It adds the provider as an additional sort on top of
 ;one of the 3 main trending reports.
 ;Added for Enhancement #1; called by AQAOPC8
 ;
 S AQAOXSM="PROV" ;line label used by ^aqaopcx
 S AQAOXSN=$O(^AQAO1(9,"B","PROVIDER",0)) I AQAOXSN="" D EXIT Q
 ;
PROV ; -- ask for provider or person or vendor
 W !! K DIR S DIR(0)="N^1:5",DIR("B")=1
 S DIR("A",1)="  Who do you want included in the Trending Report?"
 S DIR("A",2)=" "
 S DIR("A",3)="   1. One IHS PROVIDER"
 S DIR("A",4)="   2. One IHS EMPLOYEE"
 S DIR("A",5)="   3. One CHS PROVIDER"
 S DIR("A",6)="   4. All IHS PROVIDERS within a Class"
 S DIR("A",7)="   5. All CHS PROVIDERS within a Type"
 S DIR("A",8)="   6. ALL Providers/Employees"
 S DIR("A",9)=" "
 S DIR("A")="  Select ONE by number"
 S DIR("?",1)="Choose #1 to print a report for one IHS provider;"
 S DIR("?",2)="Choose #2 to print a report for one non-provider employee."
 S DIR("?",3)="Choose #3 for a specific CHS provider."
 S DIR("?",4)="Choose #4 to print the report for all IHS providers"
 S DIR("?",5)="          within a specific provider class (i.e., Surgeon)"
 S DIR("?",6)="Choose #5 to print the report for all CHS providers"
 S DIR("?",7)="          within a specific CHS provider type."
 S DIR("?",8)="Choose #6 to include all providers/persons in the report."
 S DIR("?",7)=" ",DIR("?")="Make your selection by number."
 D ^DIR I $D(DTOUT)!$D(DUOUT) D EXIT Q
 ;
 K AQAOXS S AQAOSRT=+Y
 I Y=6 S AQAOXS(0)="" D RPT Q  ;multiple categories sorted by name
 ;
 S X=$S(AQAOSRT=1:"I $D(^XUSEC(""PROVIDER"",+Y))",1:"")
 I AQAOSRT=1 D ASK(200,"IHS PROVIDER",X)
 I AQAOSRT=2 D ASK(200,"IHS EMPLOYEE",X)
 I AQAOSRT=3 D ASK(9999999.11,"CHS PROVIDER",X)
 I AQAOSRT=4 D ASK(7,"IHS PROVIDER CLASS",X)
 I AQAOSRT=5 D ASK(9999999.34,"CHS PROVIDER TYPE",X)
 I '$D(AQAOXS) D PROV Q
 ;
RPT ; -- ask user to select report to run
 W !!,"  AVAILABLE OCCURRENCE REPORTS:",! K DIR S DIR(0)="NO^1:4"
 S DIR("A")="  Select REPORT to print"
 F I=1:1:4 S DIR("A",I)="  "_I_". "_$P($T(RTN+I),";;",2)
 S DIR("A",5)=" " D ^DIR G EXIT:$D(DTOUT),PROV:$D(DIRUT),RPT:Y=-1
 S AQAORTN=$P($T(RTN+Y),";;",3) D @AQAORTN
 ;
EXIT ; -- eoj
 D KILL^AQAOUTIL Q
 ;
 ;
ASK(DIC,DICA,DICS) ; -- SUBRTN to ask user to choose one item
 S:DICA["" DIC("A")="Select "_DICA_": " S:DICS]"" DIC("S")=DICS
 S DIC(0)="AEMQZ" W !! D ^DIC Q:$D(DTOUT)  Q:$D(DUOUT)  Q:Y=-1
 I AQAOSRT<4 S AQAOXS(1,+Y)=+Y Q
 ;
 S AQAOK=$O(^DIC(19.1,"B","PROVIDER",0)) I AQAOSRT=4,AQAOK]"" D  Q
 .W !,"Searching for all ACTIVE IHS Providers within this CLASS. . ."
 .S X=0 F  S X=$O(^VA(200,"AB",AQAOK,X)) Q:X=""  D
 ..I $P($G(^VA(200,X,"PS")),U,4)]"",$P(^("PS"),U,4)'>DT Q  ;inactive
 ..Q:$P($G(^VA(200,X,"PS")),U,5)'=+Y  ;wrong prov class
 ..S AQAOXS(1,X)=X
 ;
 W !,"Searching for all ACTIVE CHS Providers within this TYPE. . ."
 S X=0 F  S X=$O(^AUTTVNDR(X)) Q:X'=+X  D
 .Q:$$VAL^XBDIQ1(9999999.11,X,.05)]""  ;inactive provider
 .Q:$$VALI^XBDIQ1(9999999.11,X,1103)'=+Y  ;wrong prov type
 .S AQAOXS(1,X)=X
 Q
 ;
 ;
PROFILE1 ;EP; -- SUBRTN to ask for provider or person or vendor
 ; called by AQAOPC8
 W !! K DIR S DIR(0)="N^1:3",DIR("B")=1
 S DIR("A")="Select ONE by Number"
 S DIR("A",1)="   1. IHS PROVIDER Profile"
 S DIR("A",2)="   2. IHS PERSON Profile"
 S DIR("A",3)="   3. CHS PROVIDER Profile",DIR("A",4)=" "
 S DIR("?",1)="Choose #1 for a profile on a direct care provider"
 S DIR("?",2)="Choose #2 for an IHS employee or volunteer"
 S DIR("?",3)="Choose #3 for a contract health care provider"
 S DIR("?")="Choose the type of profile you want to print"
 D ^DIR Q:$D(DTOUT)  Q:$D(DUOUT)
 S X=$S(Y=1:"I $D(^XUSEC(""PROVIDER"",+Y))",1:"")
 I Y=1 D ASKP(200,"IHS PROVIDER",X,.AQAOPROV,.AQAOPRVN)
 I Y=2 D ASKP(200,"IHS PERSON",X,.AQAOPROV,.AQAOPRVN)
 I Y=3 D ASKP(9999999.11,"CHS PROVIDER",X,.AQAOPROV,.AQAOPRVN)
 I '$D(AQAOPROV) D PROFILE1
 Q
 ;
 ;
ASKP(DIC,DICA,DICS,AQAOPROV,AQAOPRVN) ; -- SUBRTN to ask prov,pers,vendr name
 N X S:DICA]"" DIC("A")="Select "_DICA_": " S:DICS]"" DIC("S")=DICS
 W !! S DIC(0)="AEMQZ" D ^DIC Q:$D(DTOUT)  Q:$D(DUOUT)  Q:Y=-1
 S AQAOPROV=+Y_";"_$P(DIC,U,2)
 S AQAOPRVN=Y(0,0)
 Q
 ;
 ;
RTN ;;
 ;;Occurrences By REVIEW CRITERIA;;^AQAOPC1
 ;;Occurrences By DIAGNOSIS/PROCEDURE;;^AQAOPC2
 ;;Occurrences By FINDINGS/ACTIONS;;^AQAOPC4
 ;;Occurrences for SINGLE CRIERION by MONTH;;^AQAOPC7
