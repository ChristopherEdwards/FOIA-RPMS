AQAOPC81 ; IHS/ORDC/LJF - OCC BY PROVIDER ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This trending report by provider is similar to the one by special
 ;review type.  It adds the provider as an additional sort on top of
 ;one of the 3 main trending reports.
 ;
PROV ; >> ask user which providers to print
 S AQAOXSM="PROV" ;line label used by ^aqaopx
 S AQAOXSN=$O(^AQAO1(9,"B","PROVIDER",0)) G EXIT:AQAOXSN=""
 W !! K DIR S DIR(0)="NAO^1:3",DIR("A")="  Select One (1, 2, or 3):  "
 S DIR("A",1)="  INCLUDE WHICH PROVIDERS?",DIR("A",2)=" "
 S DIR("A",3)="   1.  ALL providers sorted by class"
 S DIR("A",4)="   2.  All providers within ONE CLASS"
 S DIR("A",5)="   3.  Only ONE PROVIDER",DIR("A",6)=" "
 D ^DIR G EXIT:$D(DIRUT),PROV:Y<1
 S AQAOSRT=Y I AQAOSRT=1 S AQAOXS(0)="" G RPT
 ;
ONE ; >> ask user to select one class or one provider
 W !! K DIC S DIC=$S(AQAOSRT=2:7,1:200),DIC(0)="AEMQZ"
 I AQAOSRT=3 D
 .S DIC("S")="I $D(^XUSEC(""PROVIDER"",+Y))"
 .S DIC("A")="Select PROVIDER NAME:  "
 D ^DIC G EXIT:$D(DTOUT),PROV:$D(DUOUT),PROV:X="",ONE:Y=-1
 I AQAOSRT=3 S AQAOXS(1,+Y)=+Y
 I AQAOSRT=2 S AQAOK=$O(^DIC(19.1,"B","PROVIDER",0)) I AQAOK]"" D
 .W !,"Searching for all ACTIVE Providers within this CLASS. . ."
 .S X=0 F  S X=$O(^VA(200,"AB",AQAOK,X)) Q:X=""  D
 ..I $P($G(^VA(200,X,"PS")),U,4)]"",$P(^("PS"),U,4)'>DT Q  ;inactive
 ..Q:$P($G(^VA(200,X,"PS")),U,5)'=+Y  ;wrong prov class
 ..S AQAOXS(1,X)=X
 ;
 ;
RPT ; >>> ask user to select report to run
 W !!,"  AVAILABLE OCCURRENCE REPORTS:",! K DIR S DIR(0)="NO^1:4"
 S DIR("A")="  Select REPORT to print"
 F I=1:1:4 S DIR("A",I)="  "_I_". "_$P($T(RTN+I),";;",2)
 S DIR("A",5)=" " D ^DIR G EXIT:$D(DTOUT),PROV:$D(DIRUT),RPT:Y=-1
 S AQAORTN=$P($T(RTN+Y),";;",3) D @AQAORTN
 ;
 ;
EXIT ; >> eoj
 D KILL^AQAOUTIL Q
 ;
 ;
RTN ;;
 ;;Occurrences By REVIEW CRITERIA;;^AQAOPC1
 ;;Occurrences By DIAGNOSIS/PROCEDURE;;^AQAOPC2
 ;;Occurrences By FINDINGS/ACTIONS;;^AQAOPC4
 ;;Occurrences for SINGLE CRIERION by MONTH;;^AQAOPC7
