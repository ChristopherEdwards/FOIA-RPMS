PSBIHS3 ;KF/VAOIT  PSB DRUG/PHAM ORDERABLE ITEM/IV ADD/SOL
 ;;1.0;PSB BCMA CPS FOXK;**1018**;;Build 27
EN ;
 W @IOF
 W !,"Hello "_$P($$GET1^DIQ(200,DUZ,.01,"E"),",",2)_" this report looks at the Following Files for 'Correct Drug Pointers'"
 W !,?10,"Drug File (50) --->Pharmacy Orderble Item (50.7)"
 W !,?10," ^ ^                |              |"
 W !,?10," | |                |              |"
 W !,?10," | |                |              |"
 W !,?10," | -------IV Additives (52.6)      |"
 W !,?10," -------------------------------IV Solution (52.7)"
TAS ;TASK IT OR NOT
 S %ZIS="Q"
 W ! D ^%ZIS K %ZIS
 I POP D  Q
 .W $C(7)
 .K VISN,PSBEDATE,PSBBDATE,PSBDV
 ; output not queued...
 N PSBTK
 I '$D(IO("Q")) D
 .D WAIT^DICD U IO S PSBTK=1 D NEW
 .I IO'=IO(0) D ^%ZISC
 ; set up the Task...
 I $D(IO("Q")) D
 .N ZTDESC,ZTSAVE,ZTIO,ZTRTN
 .S ZTRTN="NEW^PSBIHS3"
 .S ZTDESC="PSB Drug File Pharm Orderable Item IV Add/Sol Report"
 .S ZTIO=ION
 .D ^%ZTLOAD
 .D HOME^%ZIS
 .W !,$S($G(ZTSK):"Task number "_ZTSK_" queued.",1:"ERROR -- NOT QUEUED!")
 .K IO("Q"),ZTSK
 Q
NEW N PSBIEN,PSBIV,PSBIVD,PSBOI,PSBCNT
 K ^TMP($J,"DRUG")
 S (PSBCNT,PSBIEN)=0 F  S PSBIEN=$O(^PSDRUG(PSBIEN)) Q:'+PSBIEN  D
 .Q:$P($G(^PSDRUG(PSBIEN,"I")),U,1)'=""  ;NO  INACTIVE
 .S PSBOI=$P($G(^PSDRUG(PSBIEN,2)),U,1)
 .Q:PSBOI'>0
 .S PSBIV=0 F  S PSBIV=$O(^PS(52.7,"AOI",PSBOI,PSBIV)) Q:PSBIV'>0  D
 ..S PSBIVD=$P($G(^PS(52.7,+PSBIV,0)),U,2)
 ..S PSBSTATUS=$S($P($G(^PS(52.7,+PSBIV,"I")),U,1)'="":"I",1:"A")
 ..Q:PSBIEN=+PSBIVD
 ..S PSBCNT=1
 ..I PSBIVD'>0 S PSBIVD="NOT SET"
 ..I PSBIV>0 S ^TMP($J,"DRUG","S",PSBSTATUS,PSBIV)=PSBOI_"^"_PSBIEN_"^"_PSBIVD
 .;Additives
 .S PSBIV=0 F  S PSBIV=$O(^PS(52.6,"AOI",PSBOI,PSBIV)) Q:PSBIV'>0  D
 ..;S PSBIV=$O(^PS(52.6,"AOI",PSBOI,""))
 ..S PSBIVD=$P($G(^PS(52.6,+PSBIV,0)),U,2)
 ..S PSBSTATUS=$S($P($G(^PS(52.7,+PSBIV,"I")),U,1)'="":"I",1:"A")
 ..Q:PSBIEN=+PSBIVD
 ..S PBSCNT=1
 ..I PSBIVD'>0 S PSBIVD="NOT SET"
 ..I PSBIV>0 S ^TMP($J,"DRUG","A",PSBSTATUS,PSBIV)=PSBOI_"^"_PSBIEN_"^"_PSBIVD
 ;PRINT SOLUTIONS
 N PSB1,PSB2,PSB3,PSB4
 S PSB1="" F  S PSB1=$O(^TMP($J,"DRUG","S",PSB1)) Q:PSB1=""  D
 .S PSB2="" F  S PSB2=$O(^TMP($J,"DRUG","S",PSB1,PSB2)) Q:PSB2'>0  D
 ..S PSB3=$P(^TMP($J,"DRUG","S",PSB1,PSB2),"^",1),PSB4=$P(^TMP($J,"DRUG","S",PSB1,PSB2),"^",2)
 ..S PSB5=$P(^TMP($J,"DRUG","S",PSB1,PSB2),"^",3)
 ..I $Y>(IOSL-4) D HEAD
 ..W !,"Drug File: ",PSB4,U,$P($G(^PSDRUG(PSB4,0)),U,1)
 ..W !?5,"Pharmacy Orderable Item:",PSB3," ",$P($G(^PS(50.7,PSB3,0)),U,1)
 ..W !?5,"IV Solution IEN:",PSB2," Generic Drug:",PSB5," ",$P($G(^PSDRUG(PSB5,0)),U,1)
 ..W !?5,"IV Solution:",$S(PSB1="I":"INACTIVE",PSB1="A":"ACTIVE"),!!
 N PSB1,PSB2,PSB3,PSB4
 S PSB1="" F  S PSB1=$O(^TMP($J,"DRUG","A",PSB1)) Q:PSB1=""  D
 .S PSB2="" F  S PSB2=$O(^TMP($J,"DRUG","A",PSB1,PSB2)) Q:PSB2'>0  D
 ..S PSB3=$P(^TMP($J,"DRUG","A",PSB1,PSB2),"^",1),PSB4=$P(^TMP($J,"DRUG","A",PSB1,PSB2),"^",2)
 ..S PSB5=$P(^TMP($J,"DRUG","A",PSB1,PSB2),"^",3)
 ..I $Y>(IOSL-4) D HEAD
 ..W !,"Drug File: ",PSB4,U,$P($G(^PSDRUG(PSB4,0)),U,1)
 ..W !?5,"Pharmacy Orderable Item:",PSB3," ",$P($G(^PS(50.7,PSB3,0)),U,1)
 ..W !?5,"IV Additives IEN:",PSB2," Generic Drug:",PSB5," ",$P($G(^PSDRUG(PSB5,0)),U,1)
 ..W !?5,"IV Additives:",$S(PSB1="I":"INACTIVE",PSB1="A":"ACTIVE"),!!
 I PSBCNT=0 W !,"Nothing to Report"
 Q
HEAD ;
 W @IOF
 W !,"Drug File Pharmacy Orderable IV Additives/Solution Checker" D NOW^%DTC S Y=% D DD^%DT W ?60,$E(Y,1,18),!
 F J=1:1:IOM W "-"
 Q
REINACT ;RENAME ALL INACTIVE DRUGS TO ZZ/zz THEM
 N PSBIEN,PSBIV,PSBIVD,PSBOI,PSBCNT
 K ^TMP("$J")
 S %DT("A")="Lets ZZ all inactive Drugs with 'INACTIVE DATE' before: "
 S %DT="AE"
 D ^%DT I X="^"!(X="")!(Y'>0) Q
 S PSBBDATE=Y K %DT,Y
 W @IOF,!,"Searching..." D WAIT^DICD
 S (PSBCNT,PSBIEN)=0 F  S PSBIEN=$O(^PSDRUG(PSBIEN)) Q:'+PSBIEN  D
 .S PSBDATE=$P($G(^PSDRUG(PSBIEN,"I")),U,1)
 .Q:+PSBDATE>PSBBDATE   ;BAIL ON THOSE WITH INACTIVE GREATER THAN DT ENTERS
 .S PSBNAME=$P($G(^PSDRUG(PSBIEN,0)),U,1)
 .Q:$E(PSBNAME,1,2)="ZZ" ;QUIET ALREADY ZZ'D"
 .Q:$E(PSBNAME,1,2)="zz" ;QUIET ALREADY ZZ'D"
 .S ^TMP($J,50,PSBIEN_",",.01)="ZZ"_PSBNAME
 .W !,"IEN:"_PSBIEN_" RENAMING "_PSBNAME_" TO ZZ"_PSBNAME
 .S PSBCNT=PSBCNT+1
 I PSBCNT=0 W !!,"NONE FOUND" Q
 W !,"Would like me to ZZ the "_PSBCNT_" INACTIVE Drugs?" S %=2 D YN^DICN
 Q:%'=1
 D WAIT^DICD
 D UPDATE^DIE(,"^TMP($J)")
 W !,"BYE I AM DONE NOW!"
