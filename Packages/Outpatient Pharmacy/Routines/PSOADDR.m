PSOADDR ;BIR/RTR-Print address changes from Audit file ;10/17/01
 ;;7.0;OUTPATIENT PHARMACY;**127**;DEC 1997
 ;External reference to ^DIA supported by DBIA 2602
 ;
EN ;
 N PSOFORM,PSOAPAT,PSOSDT,PSOEDT,PSOSDTX,PSOEDTX,X,Y,X1,X2
 W !!,"This option provides a report that displays changes made to address information",!,"and temporary address information in the PATIENT file (#2). Changes can only",!,"be displayed if the edits were made using VA FileMan, and the Audit"
 W !,"function was turned for the field(s) at the time of the edit.",!!
 K DIR S DIR(0)="SB^S:Single;A:All",DIR("A")="Print report for a Single patient, or All patients",DIR("B")="Single",DIR("?")=" ",DIR("?",1)="Enter 'S' to print address changes for one patient over the selected"
 S DIR("?",2)="date range, enter 'A' to print address changes for all patients",DIR("?",3)="over the selected date range."
 D ^DIR K DIR I Y["^"!($D(DTOUT))!($D(DUOUT)) D MESS Q
 S PSOFORM=$S(Y="S":1,1:0)
 I 'PSOFORM G DATE
 K DIC W ! S DIC="^DPT(",DIC(0)="QEAM",DIC("A")="Select PATIENT: " D ^DIC K DIC I Y<1!($D(DUOUT))!($D(DTOUT)) D MESS Q
 S PSOAPAT=+Y
DATE ;
 W !!
 I PSOFORM W !,"This report will be sorted by Date/time of edit."
 I 'PSOFORM W !,"This report will be sorted by Patient Name, and within Patient Name will be",!,"sorted by Date/time of edit."
 W !,"A beginning and ending date must now be entered for the search."
 K DIR W ! S DIR(0)="DAO^:DT:APEX",DIR("A")="Beginning Date: ",DIR("?")=" ",DIR("?",1)="Enter the date to begin searching for changes to address fields.",DIR("?",2)="A future date cannot be entered." D ^DIR K DIR
 I 'Y!($D(DTOUT))!($D(DUOUT)) D MESS Q
 S PSOSDT=Y D DD^%DT S PSOSDTX=Y
 S X1=PSOSDT,X2=-1 D C^%DTC S PSOSDT=X_".9999"
 W ! K DIR S DIR(0)="DAO^"_PSOSDT_"::APEX",DIR("A")="Ending Date: ",DIR("?")=" ",DIR("?",1)="Enter the ending date of the search for changes to address fields.",DIR("?",2)="This date cannot be before the beginning date." D ^DIR K DIR
 I 'Y!($D(DTOUT))!($D(DUOUT)) D MESS Q
 S PSOEDT=Y D DD^%DT S PSOEDTX=Y
 S X1=PSOEDT,X2=+1 D C^%DTC S PSOEDT=X
 K IOP,%ZIS,POP S %ZIS="QM" D ^%ZIS I $G(POP) D MESS Q
 I $D(IO("Q")) D  Q
 .S ZTRTN="REP^PSOADDR",ZTDESC="Pharmacy Address change report",ZTSAVE("PSOFORM")="",ZTSAVE("PSOAPAT")="",ZTSAVE("PSOSDT")="",ZTSAVE("PSOEDT")="",ZTSAVE("PSOEDTX")="",ZTSAVE("PSOSDTX")="" D ^%ZTLOAD K %ZIS W !!,"Report queued to print.",!
REP ;
 K ^TMP("PSOADD",$J)
 N PSODEV,PSOUT,PSOLINE,PSOPAGE,PSOADND,PSOADUSR,PSOADF,PSOADFF,PSOAOPT,PSOAOPTA,PSOAOPTZ,PSOAOPTB,PSOAOPTC,PSOADLP,PSOANODE,PSOADX,PSOADXX,PSOADATE,PSOAFL,PSOAALL,PSOADFN,PSOANAME,PSONI,PSONX,PSONB,PSOASN,VA,DFN,PSONSSN,PSOAFLAG
 U IO
 S (PSOUT,PSOAFLAG)=0,PSODEV=$S($E(IOST,1,2)'="C-":0,1:1),PSOPAGE=1
 S $P(PSOLINE,"-",78)=""
 I $G(PSOFORM) G ONE
ALL ;Print report for all patients
 F PSOAALL=PSOSDT:0 S PSOAALL=$O(^DIA(2,"C",PSOAALL)) Q:'PSOAALL!(PSOEDT'>PSOAALL)  S PSOADLP="" F  S PSOADLP=$O(^DIA(2,"C",PSOAALL,PSOADLP)) Q:PSOADLP=""  D
 .S PSOADFN=$P($G(^DIA(2,PSOADLP,0)),"^"),PSOAFL=$P($G(^(0)),"^",3) Q:'PSOADFN
 .I PSOAFL=.111!(PSOAFL=.112)!(PSOAFL=.113)!(PSOAFL=.114)!(PSOAFL=.115)!(PSOAFL=.116)!(PSOAFL=.1211)!(PSOAFL=.1212)!(PSOAFL=.1213)!(PSOAFL=.1214)!(PSOAFL=.1215)!(PSOAFL=.1216)!(PSOAFL=.1112)!(PSOAFL=.12112) D
 ..S PSOANAME=$P($G(^DPT(PSOADFN,0)),"^") Q:PSOANAME=""
 ..S ^TMP("PSOADD",$J,PSOANAME,PSOADFN,PSOAALL,PSOADLP)=$G(^DIA(2,PSOADLP,0))
 D HD
 I '$D(^TMP("PSOADD",$J)) W !!,"No data found to print for this date range.",! G END
 S PSONI="" F  S PSONI=$O(^TMP("PSOADD",$J,PSONI)) Q:PSONI=""!(PSOUT)  S PSONX="" F  S PSONX=$O(^TMP("PSOADD",$J,PSONI,PSONX)) Q:PSONX=""!(PSOUT)  D NAME S PSONB="" F  S PSONB=$O(^TMP("PSOADD",$J,PSONI,PSONX,PSONB)) Q:PSONB=""!(PSOUT)  D
 .S PSOADXX="" F  S PSOADXX=$O(^TMP("PSOADD",$J,PSONI,PSONX,PSONB,PSOADXX)) Q:PSOADXX=""!(PSOUT)  D
 ..I ($Y+5)>IOSL D HD Q:PSOUT
 ..S Y=PSONB D DD^%DT S PSOADATE=Y
 ..S PSOADND=$G(^TMP("PSOADD",$J,PSONI,PSONX,PSONB,PSOADXX))
 ..D FLD
 ..D PRALL
 G END
ONE ;Print report for one patient
 S PSOADLP="" F  S PSOADLP=$O(^DIA(2,"B",PSOAPAT,PSOADLP)) Q:PSOADLP=""  S PSOAFL=$P($G(^DIA(2,PSOADLP,0)),"^",3) D
 .I PSOAFL=.111!(PSOAFL=.112)!(PSOAFL=.113)!(PSOAFL=.114)!(PSOAFL=.115)!(PSOAFL=.116)!(PSOAFL=.1211)!(PSOAFL=.1212)!(PSOAFL=.1213)!(PSOAFL=.1214)!(PSOAFL=.1215)!(PSOAFL=.1216)!(PSOAFL=.1112)!(PSOAFL=.12112) D
 ..S PSOANODE=$G(^DIA(2,PSOADLP,0))
 ..I +$P($G(PSOANODE),"^",2)>PSOSDT,+$P($G(PSOANODE),"^",2)<PSOEDT D
 ...S ^TMP("PSOADD",$J,+$P(PSOANODE,"^",2),PSOADLP)=PSOANODE
 K VA S DFN=PSOAPAT D PID^VADPT6 S PSOASN=$P($G(^DPT(+$G(PSOAPAT),0)),"^")_"  ("_$E(VA("PID"),5,12)_")"
 K VA
 D HD
 I '$D(^TMP("PSOADD",$J)) W !!,"No data found to print for this date range.",! G END
 S PSOADX="" F  S PSOADX=$O(^TMP("PSOADD",$J,PSOADX)) Q:PSOADX=""!(PSOUT)  S PSOADXX="" F  S PSOADXX=$O(^TMP("PSOADD",$J,PSOADX,PSOADXX)) Q:PSOADXX=""!(PSOUT)  D
 .I ($Y+5)>IOSL D HD Q:PSOUT
 .S Y=PSOADX D DD^%DT S PSOADATE=Y
 .S PSOADND=$G(^TMP("PSOADD",$J,PSOADX,PSOADXX))
 .D FLD
 .W ! D PRONE
END ;
 K ^TMP("PSOADD",$J)
 I '$G(PSOUT),PSODEV W !!,"End of Report." K DIR S DIR(0)="E",DIR("A")="Press Return to continue" D ^DIR K DIR
 I 'PSODEV W !!,"End of Report."
 I PSODEV W !
 E  W @IOF
 D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@"
 Q
HD ;
 I '$G(PSOFORM) S PSOAFLAG=1
 I PSODEV,PSOPAGE'=1 W ! K DIR S DIR(0)="E",DIR("A")="Press Return to continue, '^' to exit" D ^DIR K DIR I 'Y S PSOUT=1 Q
 I PSOPAGE=1,'PSODEV W ! I 1
 E  W @IOF
 D  W ?67,"PAGE: "_PSOPAGE S PSOPAGE=PSOPAGE+1
 .I PSOFORM W !,"Address changes for "_$G(PSOASN) Q
 .W !,"Address changes for ALL Patients"
 W !,"made between "_$G(PSOSDTX)_" and "_$G(PSOEDTX)
 W !,PSOLINE
 Q
MESS ;
 W !!,"Nothing queued to print.",!
 Q
NAME ;Set name(ssn)
 K VA S DFN=PSONX D PID^VADPT6
 S PSONSSN=$G(PSONI)_"   ("_$E(VA("PID"),5,12)_")"
 K VA
 Q
PRALL ;Print data for all patients
 S PSOAFLAG=0
 W !!,"          Patient: ",$G(PSONSSN) I ($Y+5)>IOSL D HD Q:PSOUT
PRONE ;Print data for one patient
 D CON W !,"Date/time of edit: ",$G(PSOADATE) I ($Y+5)>IOSL D HD Q:PSOUT
 D CON W !,"     Field edited: ",$G(PSOADFF) I ($Y+5)>IOSL D HD Q:PSOUT
 D CON W !,"        Edited by: ",$G(PSOADUSR) I ($Y+5)>IOSL D HD Q:PSOUT
 D CON W !,"  Option/Protocol: ",$G(PSOAOPT) I ($Y+5)>IOSL D HD Q:PSOUT
 D CON W !,"        Old Value: ",$S($P($G(^DIA(2,PSOADXX,2)),"^")'="":$P($G(^(2)),"^"),1:"<no previous value>") I ($Y+5)>IOSL D HD Q:PSOUT
 D CON W !,"        New Value: ",$S($P($G(^DIA(2,PSOADXX,3)),"^")'="":$P($G(^(3)),"^"),1:"<no current value>") I ($Y+5)>IOSL D HD
 Q
CON ;
 I PSOAFLAG,'PSOFORM W !,"  Patient (cont.): ",$G(PSONSSN) S PSOAFLAG=0
 Q
FLD ;Set field value
 K PSOADF D FIELD^DID(2,$P(PSOADND,"^",3),"","LABEL","PSOADF")
 S PSOADFF=$G(PSOADF("LABEL"))
USR ;Set user value
 S PSOADUSR=$P(PSOADND,"^",4) I 'PSOADUSR S PSOADUSR="UNKNOWN"
 I PSOADUSR'="UNKNOWN" K DIC S DIC="^VA(200,",DIC(0)="MZO",X="`"_PSOADUSR D ^DIC S PSOADUSR=$P($G(Y),"^",2) K DIC
 I $G(PSOADUSR)="" S PSOADUSR="UNKNOWN"
PROT ;Set value of protocol or option
 S (PSOAOPT,PSOAOPTB,PSOAOPTC)=""
 I $G(^DIA(2,PSOADXX,4.1))="" S PSOAOPT="/" Q
 S PSOAOPTA=$P($G(^DIA(2,PSOADXX,4.1)),"^")
 I PSOAOPTA K DIQ,DIC,PSOAOPTZ S DIC=19,DR=".01",DA=PSOAOPTA,DIQ(0)="E",DIQ="PSOAOPTZ" D EN^DIQ1 S PSOAOPTB=$G(PSOAOPTZ(19,PSOAOPTA,.01,"E")) K DIQ,DA,DR,PSOAOPTZ
 S PSOAOPTA=$P($G(^DIA(2,PSOADXX,4.1)),"^",2)
 K PSOAOPTZ I $P(PSOAOPTA,";",2)="ORD(101," K DIC S DIC=101,DR=".01",DA=+PSOAOPTA,DIQ(0)="E",DIQ="PSOAOPTZ" D EN^DIQ1 S PSOAOPTC=$G(PSOAOPTZ(101,+PSOAOPTA,.01,"E")) K DA,DR,DIC,DIQ,PSOAOPTZ
 I $P(PSOAOPTA,";",2)'="ORD(101,",+PSOAOPTA K DIC,DIQ S DIC=19,DR=".01",DA=+PSOAOPTA,DIQ(0)="E",DIQ="PSOAOPTZ" D EN^DIQ1 S PSOAOPTC=$G(PSOAOPTZ(19,+PSOAOPTA,.01,"E")) K PSOAOPTZ,DIC,DA,DR,DIQ
 S PSOAOPT=$G(PSOAOPTB)_"/"_$G(PSOAOPTC)
 Q
