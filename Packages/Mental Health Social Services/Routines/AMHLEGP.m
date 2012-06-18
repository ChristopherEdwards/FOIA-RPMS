AMHLEGP ; IHS/CMI/LAB - BH GROUP FORM DATA ENTRY ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 D ^AMHLEIN
 D INFORM
GETDATE ; GET DATE OF ENCOUNTER
 S AMHGROUP=1 ;  so I know I am in group entry
 S AMHDATE="",DIR(0)="D^:"_DT_":EPT",DIR("A")="Enter ENCOUNTER DATE" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 S %DT="ET" D ^%DT G:Y<0 GETDATE
 I Y>DT W "  <Future dates not allowed>",$C(7),$C(7) K X G GETDATE
 S AMHDATE=Y
GETPROG ;
 S AMHPROG=""
 K DIR,DA,DTOUT,DIRUT,DUOUT,DIC,X,Y S DIR(0)="SB^M:Mental Health;S:Social Services;C:Chemical Dependency;O:Other",DIR("A")="Enter PROGRAM" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) GETDATE
 S AMHPROG=Y,AMHPROG(0)=Y(0),AMHPTYPE=Y
GETCLN ;
 S AMHCLN="",DIC="^DIC(40.7,",DIC(0)="AEMQ",DIC("A")="Enter CLINIC: " D ^DIC K DIC
 I X="" W !!,"Clinic is required.  Type '^' to exit or enter a clinic code." G GETCLN
 G:Y<0 GETPROG
 S AMHCLN=+Y
GETTOD ;
 S AMHDATE=$P(AMHDATE,".")
 S AMHTOD="12:00"
 W !,"ARRIVAL Time: ",$S(AMHTOD]"":AMHTOD_"// ",1:"") R X:$S($D(DTIME):DTIME,1:300) S:'$T X="^" S:X="" X=AMHTOD
 I X="^" G GETCLN
 I X="" S AMHTOD="12:00" G EDTIME
 I X["?" W !,"Enter time of arrival, or 'D' for default." G GETTOD
 I X="D" S X="12:00" W "  ",X
 S AMHTOD=X
EDTIME S Y=AMHDATE D DD^%DT S X=Y_"@"_AMHTOD
 S %DT="ET" D ^%DT I Y<0 W !!,"Invalid time entry, enter time of visit or 1200 for the default." G GETTOD
 I X="-1" W ! G GETTOD
 S AMHDATE=Y
GETLOC ;
 S AMHLOC="",DIC="^AUTTLOC(",DIC(0)="AEMQ",DIC("B")=$S($$GETLOC^AMHLEIN(DUZ(2),AMHPTYPE)]"":$P(^DIC(4,$$GETLOC^AMHLEIN(DUZ(2),AMHPTYPE),0),U),1:"") D ^DIC K DIC
 I Y=-1,X["^" G GETTOD
 I Y=-1,X="" W !!,$C(7),$C(7),"REQUIRED, enter a '^' to exit.",! G GETLOC
 ;CMI/TUCSON/LAB - moved the S AMHLOC=+Y line to here from GETPROV-2 10/06/97 - this caused an error in group entry
 S AMHLOC=+Y
 I $E($P(^AUTTLOC(+Y,0),U,10),5,6)>50 S AMHOL="",DIR(0)="9002011,.26",DIR("A")="Enter Outside Location (e.g. Central High School)" K DA D ^DIR K DIR G:$D(DUOUT) GETLOC S AMHOL=Y
 ;
GETPROV ;get providers
 K AMHPROV S AMHC=0
GETPROV1 ;
 K DIR,DA,DTOUT,DIRUT,DUOUT,DIC,X,Y S DIR(0)="9002011.02,.01O",DIR("A")="Enter "_$S(AMHC=0:"PRIMARY",1:"SECONDARY")_" PROVIDER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DUOUT) G GETLOC
 I $D(DIRUT),AMHC=0 G GETLOC
 I Y="",AMHC=0 G GETLOC
 I Y="",AMHC>0 G GETCOMM
 S AMHC=AMHC+1,AMHPROV(AMHC)=+Y,$P(AMHPROV(AMHC),U,2)=$S(AMHC=1:"P",1:"S")
 G GETPROV1
GETCOMM ;
 S AMHCOMM="",DIC(0)="AEMQ",DIC("A")="Enter COMMUNITY: ",DIC="^AUTTCOM(",DIC("B")=$$GETCOMM^AMHLEIN(DUZ(2),"M") D ^DIC K DIC,DA
 I Y=-1 G GETPROV
 S AMHCOMM=+Y
GETACT ;
 S AMHACT="",DIR(0)="9002011,.06",DIR("A")="Enter ACTIVITY CODE" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G GETCOMM
 S AMHACT=Y
GETCONT ;
 S AMHCONT="",DIR(0)="9002011,.07",DIR("A")="Enter TYPE OF CONTACT" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G GETACT
 S AMHCONT=Y,AMHCONT(0)=Y(0)
GETPOVS ;
 K AMHPOV S AMHC=0
GETPOVS1 ;
 K DIR,DA,DTOUT,DIRUT,DUOUT,DIC,X,Y S DIR(0)="9002011.01,.01O",DIR("A")=$S(AMHC=0:"Enter PROBLEM (POV)",1:"Enter another PROBLEM (POV) or press enter if none") D ^DIR K DIR
 K DIR
 I $D(DUOUT) G GETCONT
 I $D(DIRUT),AMHC=0 G GETCONT
 I Y="",AMHC=0 G GETCONT
 I Y="",AMHC>0 G GETCPTS
 I $D(DIRUT),AMHC>0 G GETCPTS
 S AMHPOVP=+Y
GETNARR ;
 S AMHNARR=""
 S DIR(0)="FO^3:79",DIR("A")="Provider Narrative" K DA D ^DIR K DIR
 I $D(DUOUT) G GETCPTS
 S X=Y I Y="" S X=$P(^AMHPROB(AMHPOVP,0),U,2) W "   ",X
 S DIC(0)="L",DLAYGO=9999999.27,APCDOVRR=1,DIC="^AUTNPOV(" D ^DIC K DIC,DLAYGO,DIADD,DD,DO I Y=-1 W !,$C(7),$C(7),"Invalid Narrative" G GETNARR
 S AMHNARR=+Y
 S AMHC=AMHC+1,AMHPOV(AMHC)=AMHPOVP_U_AMHNARR
 G GETPOVS1
GETCPTS ;
 K AMHCPT S AMHC=0
GETCPTS1 ;
 K DIR,DA,DTOUT,DIRUT,DUOUT,DIC,X,Y S DIR(0)="9002011.04,.01O",DIR("A")="Enter CPT CODE (or enter if none)" D ^DIR K DIR
 K DIR
 I Y="" G GETEDUC
 I $D(DUOUT) G GETPOVS
 I $D(DIRUT),AMHC=0 G GETPOVS
 I Y="" G GETTIME
 I $D(DIRUT),AMHC>0 G GETEDUC
 S AMHCPTP=+Y
 S AMHC=AMHC+1,AMHCPT(AMHC)=AMHCPTP
 G GETCPTS1
GETEDUC ;
 K AMHEDUC S AMHC=0
GETEDUC1 ;
 K DIR,DA,DTOUT,DIRUT,DUOUT,DIC,X,Y S DIR(0)="9002011.05,.01O",DIR("A")="Enter EDUCATION TOPIC (or enter if none)" D ^DIR K DIR
 K DIR
 I Y="" G GETTIME
 I $D(DIRUT),AMHC=0 G GETCPTS
 I Y="" G GETTIME
 I $D(DIRUT),AMHC>0 G GETTIME
 S AMHCPTP=+Y
 S AMHC=AMHC+1,AMHEDUC(AMHC)=AMHCPTP
 ;get provider
 K DIR,DA,DTOUT,DIRUT,DUOUT,DIC,X,Y S DIR(0)="9002011.05,.04",DIR("A")="   Enter Education PROVIDER" D ^DIR K DIR
 I +Y S $P(AMHEDUC(AMHC),U,2)="`"_+Y
 K DIR,DA,DTOUT,DIRUT,DUOUT,DIC,X,Y S DIR(0)="9002011.05,.06",DIR("A")="   Enter Length of Education (minutes)" D ^DIR K DIR
 I $D(DIRUT) S Y=""
 S $P(AMHEDUC(AMHC),U,3)=Y
 K DIR,DA,DTOUT,DIRUT,DUOUT,DIC,X,Y S DIR(0)="9002011.05,.07",DIR("A")="   Enter CPT code for Education" D ^DIR K DIR
 I +Y S $P(AMHEDUC(AMHC),U,4)=Y
 K DIR,DA,DTOUT,DIRUT,DUOUT,DIC,X,Y S DIR(0)="9002011.05,1101",DIR("A")="   Enter COMMENT about the education" D ^DIR K DIR
 I $D(DIRUT) S Y=""
 S $P(AMHEDUC(AMHC),U,5)=Y
 G GETEDUC1
GETTIME ;
 S AMHTIME="",DIR(0)="9002011,.12",DIR("A")="Enter TOTAL ACTIVITY TIME" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G GETPOVS
 S AMHTIME=Y
GETNUM ;
 S AMHNUM="",DIR(0)="9002011,.09",DIR("A")="Enter TOTAL NUMBER OF PATIENTS ON FORM" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G GETTIME
 S AMHNUM=Y
DISP ;
 W !!,"I am going to ask you to enter ",AMHNUM," patient names.  I will then create a",!,"record in the BH file for each patient.  The record will contain the",!,"following information: ",!
 W !,"Date of Encounter: " S Y=AMHDATE D DD^%DT W Y W ?40,"Program: ",AMHPROG(0)
 W !,"Loc. of Enc.: ",$E($P(^DIC(4,AMHLOC,0),U),1,25),?40,"Community: ",$E($P(^AUTTCOM(AMHCOMM,0),U),1,25)
 W !,"Providers: " S X=0 F  S X=$O(AMHPROV(X)) Q:X'=+X  W:X>1 ! W ?12,$P(^VA(200,$P(AMHPROV(X),U),0),U)
 W !,"Activity: ",$E($P(^AMHTACT(+AMHACT,0),U,2),1,25),?40,"Type of Contact: ",$P(AMHCONT(0),U)
 W !,"PROBLEM (POV): " S X=0 F  S X=$O(AMHPOV(X)) Q:X'=+X  W:X>1 ! W ?12,$P(^AMHPROB($P(AMHPOV(X),U),0),U),"   ",$E($P(^AUTNPOV($P(AMHPOV(X),U,2),0),U),1,50)
 W !,"# Patients: ",AMHNUM,?15,"Total Time: ",AMHTIME,!
 K DIR,DA,DTOUT,DIRUT,DUOUT,DIC,X,Y S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="Y" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) XIT
 G:'Y XIT
 D ^AMHLEGP1
ENDMSG ;
 ;print forms?
 I $O(AMHLEGP("RECS ADDED",0)) D PRINT
 D XIT
 Q
PRINT ;
 W !! S DIR(0)="Y",DIR("A")="Do you wish to PRINT an encounter form for each patient's chart",DIR("B")="Y" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:'Y
NUM ;
 ;S DIR(0)="N^1:4:0",DIR("A")="How many copies of each form do you need",DIR("B")="1" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 ;Q:$D(DIRUT)
 ;S AMHNUM=Y
 K AMHEFT,AMHEFTH
 W !! S DIR(0)="S^F:Full Encounter Form;S:Suppressed Encounter Form;B:Both a Suppressed & Full;T:2 copies of the Suppressed;E:2 copies of the Full"
 S DIR("B")=$S($P(^AMHSITE(DUZ(2),0),U,23)]"":$P(^AMHSITE(DUZ(2),0),U,23),1:"B") K DA D ^DIR K DIR
 Q:$D(DIRUT)
 S (AMHEFT,AMHEFTH)=Y
 S XBRP="PRINT^AMHLEGPP",XBRC="COMP^AMHLEGPP",XBRX="XIT^AMHLEGPP",XBNS="AMH"
 D ^XBDBQUE
 ;loop through all patients, records and print forms
 Q
INFORM ;
 D INFORM^AMHLEGP1
 Q
XIT ;
 D XIT^AMHLEGP1
 Q
