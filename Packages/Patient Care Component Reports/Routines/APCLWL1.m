APCLWL1 ; IHS/CMI/LAB - CLINIC HOURLY WORKLOAD REPORT ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
DOC ;See INFORM section for documentation notes for this routine
 ;
 ;List of VARIABLES with brief descriptions:
 ;
START ;Start of routine
 I '$G(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! K APCLSITE Q
 S APCLSITE=DUZ(2)
INFORM ;
 W:$D(IOF) @IOF
 W !,"  ******* TALLY OF DAILY VISITS BY 24-HOUR TIME FRAMES *******"
 W !,"- This report will generate an hourly visit count, by clinic,",!,"  for a date range that you specify.",!
 W "- ALL visits in the database will be included in the tabulation with",!,"  the exception of the following:  "
 W !,"    VISIT TYPES:  Contract, VA",!,"    VISIT SERVICE CATEGORIES:  Chart Review, In-Hospital, Ancillary,",!?31,"Hospitalizations, Events, Telecommunications",!
 W "- Visits MUST have a Primary Provider and Purpose of Visit.",!
 W "- The report will be totaled by hourly time frames.",!
 ;
GETDATES ;This section gets BEGINNING and ENDING dates:
BD ;Get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter Beginning Visit Date" D ^DIR
 K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S APCLBD=Y
ED ;Get ending date
 W ! S DIR(0)="DA^"_APCLBD_":DT:EP",DIR("A")="Enter Ending Visit Date:  "
 S Y=APCLBD D DD^%DT S Y="" D ^DIR
 K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCLED=Y,X1=APCLBD,X2=-1
 S X1=APCLBD,X2=-1 D C^%DTC S APCLSD=X
 ; 
LOC ;Enter facility
 S DIC("A")="Select Facility: ",DIC="^AUTTLOC(",DIC(0)="AEMQ",DIC("B")=$P(^DIC(4,DUZ(2),0),U) D ^DIC K DIC,DA G:Y<0 BD
 S APCLLOC=+Y
 ;
CLIN ;Select Clinic(s)
 S DIR(0)="YO",DIR("A")="Include visits from ALL Clinics",DIR("B")="NO",DIR("?")="If you wish to include visits from ALL of clinics answer Yes.  If you wish to tabulate for a single clinic enter NO." D ^DIR K DIR
 G:$D(DIRUT) BD
 I Y=1 S APCLCLN="" G AGE
CLIN1 ;
 S DIC("A")="Select Clinic: ",DIC="^DIC(40.7,",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 CLIN
 S APCLCLN=+Y
AGE ;Age Screening
 K APCLAGE,APCLAGET
 W ! S DIR(0)="YO",DIR("A")="Would you like to restrict the report by Patient age range",DIR("B")="YES"
 S DIR("?")="If you wish to include visits from ALL age ranges, anwser No.  If you wish to include visits for only patients within a particular age range, enter Yes."
 D ^DIR K DIR
 G:$D(DIRUT) CLIN
 I 'Y G PROV
 ;
AGER ;Age Screening
 W !
 S DIR(0)="FO^1:7",DIR("A")="Enter an Age Range (e.g. 5-12,1-1)" D ^DIR
 I Y="" W !!,"No age range entered." G AGE
 I Y'?1.3N1"-"1.3N W !!,$C(7),$C(7),"Enter a numeric range in the format nnn-nnn. e.g. 0-5, 0-99, 5-20." G AGER
 S APCLAGET=Y
 ;
PROV ;Provider Screening
 ;
 S DIR(0)="YO",DIR("A")="Include visits from ALL Providers",DIR("B")="NO",DIR("?")="If you wish to include visits from ALL of Providers answer Yes.  If you wish to tabulate for a single Provider enter NO." D ^DIR K DIR
 G:$D(DIRUT) BD
 I Y=1 S APCLPROV="" G ZIS
PROV1 ;Provider Screening
 ;
 S DIC("A")="Select Provider: ",DIC=$S($P(^DD(9000010.06,.01,0),U,2)[200:"^VA(200,",1:"^DIC(6,"),DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 PROV
 S APCLPROV=+Y
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G PROV
 W !!,$C(7),$C(7),"THIS REPORT MUST BE PRINTED ON 132 COLUMN PAPER OR ON A PRINTER THAT IS",!,"SET UP FOR CONDENSED PRINT!!!",!!,"IF YOU DO NOT HAVE SUCH A PRINTER AVAILABLE - SEE YOUR SITE MANAGER.",!!
 S XBRP="^APCLWL1P",XBRC="^APCLWL11",XBRX="XIT^APCLWL1",XBNS="APCL"
 D ^XBDBQUE
 D XIT
 Q
ERR W $C(7),$C(7),!,"Must be a valid date and be Today or earlier. Time not allowed!" Q
XIT ;
 K APCL132S,APCLBD,APCLBDD,APCLCLN,APCLCLNT,APCLDT,APCLED,APCLEDD,APCLTAB,APCLGTOT,APCLODAT,APCLPG,APCLSD,APCLSITE,APCLSRT2,APCLTIME,APCLET,APCLAGET
 K APCLVDFN,APCLVLOC,APCLVREC,APCLBT,APCLLENG,APCLLOC,APCLLOCT,APCLQUIT,APCLJOB,APCLDATE,APCL1,APCL2,APCLDOW,APCLCLIN,APCLPROV,APCLFILE
 K X,Y,ZTSK,X1,X2,XBNS,XBRC,XBRP,XBRX,DIC,DA,DIG,DIH,DIR,DIRUT,DIU,DIV
 Q
 ;
