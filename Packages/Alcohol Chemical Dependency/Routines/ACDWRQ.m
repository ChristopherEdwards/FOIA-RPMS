ACDWRQ ;IHS/ADC/EDE/KML - PROMPTS FOR RPTS CRITERIA AREA/SU/FAC;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;;
 ;*********************************************************
 ;//^ACDWDRV*
 ;First get dates to run then see if user is facility or area or HQ.
 ;Ask HQ to print reports by area or service unit or facility.
 ;Force AREA to run report by facility.
 ;Force FACILITY to run only for their ONE facility.
 ;************************************************************
 ;
 K ACDAREA,ACDSU,ACDFAC,ACDPROV,ACDSUB,ACDTRB,ACDSTA,ACDCOMU,ACDCRST
 D D Q:$D(ACDQUIT)  D LOC Q:$D(ACDQUIT)  I $D(ACDFAC) D 2 Q
 W !! S DIR(0)="S^1:AREA;2:FACILITY;3:SERVICE UNIT",DIR("A")="Print Reports By:" D ^DIR S:X["^"!($D(DTOUT))!(X="") ACDQUIT=1 Q:$D(ACDQUIT)  D @Y Q:$D(ACDQUIT)
 Q
1 ;AREA
 ;User is running reports by area
 D ^ACDWAREA Q:$D(ACDQUIT)
 D TSC Q
 ;
2 ;FACILITY
 ;User is running reports by facility
 ;If the user is a facility, they are not asked to run reports
 ;by area, service unit, or facility, so I pre-set the ACDFAC
 ;array
 I '$D(ACDFAC) D ^ACDWFAC Q:$D(ACDQUIT)
 D TSC Q
 ;
3 ;SERVICE UNIT
 ;User is running reports by service unit
 D ^ACDWSU Q:$D(ACDQUIT)
 D TSC Q
 ;
TSC ;
 ;Ask to further restrict output by tribe, state, community
 ;This will further restrict the output criteria already
 ;selected above
 ;
 Q:$D(ACDWDRV(5))
 W !!!,"OK, within ",$S($D(ACDAREA):"AREA, ",$D(ACDFAC):"FACILITY, ",$D(ACDSU):"SERVICE UNIT, "),"restrict reports by: "
 S DIR(0)="S^4:TRIBE;5:STATE;6:COMMUMITY;7:NO RESTRICTION" D ^DIR S:X["^"!($D(DTOUT))!(X="") ACDQUIT=1 Q:$D(ACDQUIT)  D @Y Q:$D(ACDQUIT)
 Q
 ;
4 ;TRIBE
 ;User is running reports by the area, facility, or service unit
 ;with a further restriction i.e. being tribe
 D ^ACDWTRB Q
 ;
5 ;STATE
 ;User is running reports by the area, facility, or service unit
 ;with a further restriction i.e. being state
 D ^ACDWSTA Q
 ;
6 ;COMMUMITY
 ;User is running reports by the area, facility, or service unit
 ;with a futher restriction i.e. being community
 ;W !!!,"UNAVAILABLE" Q
 Q
 ;
7 ;No restrictions
 ;User is running reports by area, facility, or service unit and
 ;does NOT want a further restriction by state, tribe, or community
 Q
 ;
D ;EP
 ;Select visit start and stop dates
 ;//^ACDGSAVE
 ;//^ACDDFAC
 ;W !!,"*** Do not enter the day in the date string if you wish to get Client Services ***"
 S %DT="AE",%DT("A")="Select Start Visit Date: " D ^%DT S:Y<0 ACDQUIT=1
 Q:$D(ACDQUIT)
 S ACDFR=+Y
 S %DT("A")="Select End Visit Date: " D ^%DT S:Y<0 ACDQUIT=1
 Q:$D(ACDQUIT)
 S ACDTO=+Y
 I ACDTO<ACDFR W !!,"** Visit start date must be earlier then Visit end date. **" G D
 ;
 ;
CNTACT ;
 ;Ask user for the contact types to run the initial/info/fu
 ;reports for i.e. ACDWDRV(1) will be defined
 Q:'$D(ACDWDRV(1))
 K ACDCRST,DIR
 F  S DIR(0)="9002172.1,3O",DIR("A")="Select Contact type(s)" D ^DIR Q:X["^"!($D(DTOUT)!(X=""))  S ACDCRST(Y)="" I Y="CS"!(Y="TD") W "  *** NOT ALLOWED ***",*7 K ACDCRST(Y)
 I $O(ACDCRST(""))="" S ACDQUIT=1
 Q
 ;
LOC ;See user is site, area, or HQ
 ;See if user running client details, if so, force array set and quit
 I $D(ACDWDRV(3)) S ACDFAC(ACD6DIG)="",ACDLOC=$P(^DIC(4,DUZ(2),0),U) Q
 ;
 ;See if site is HQ
 I $E(ACD6DIG)=9 W !!,*7,"HEADQUARTERS..............",! Q
 ;
 ;See if user is a site, if so, force array set and quit
 I $E(ACD6DIG,3,4)'="00" S ACDFAC(ACD6DIG)="",ACDLOC=$P(^DIC(4,DUZ(2),0),U) Q
 ;
 ;User is a area, force user to the facility selection module
 W !!,*7,"Area ...................",! D ^ACDWFAC
 Q
 ;
