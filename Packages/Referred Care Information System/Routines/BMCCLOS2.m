BMCCLOS2 ; IHS/OIT/FCJ - Auto Close of CHS Referrals ;    [ 05/15/2006  12:23 PM ]
 ;;4.0;REFERRED CARE INFO SYSTEM;**2**;JAN 09, 2006
 ;IHS/ITSC/FCJ TEST FOR SR
 ;IHS/OIT/FCJ ADDED NEW SORT BY DATE OF SERVICE, ADDED NEW TYPE ALL,
 ;ADDED BOTH TO INP/OUT SELECTION
 ;
 ;
 ;
 W !?12,"********  AUTOMATIC CLOSE OF REFERRALS  ********",!
 W !,?25,"******WARNING*****",!
 ;W !,"This routine will LOOP through all referrals that were initiated in a date ",!,"range entered by the User --" ;IHS/OIT/FCJ
 W !,"This routine will LOOP through all referrals either by date initiated",!,"or by date of service, date range entered by the User --" ;IHS/OIT/FCJ
 W !,?20,"*****AUTOMATIC CLOSURE OF REFERRAL*****",!
 W "This Routine allows User to Select a specific INDIVIDUAL FACILITY Only!",!
 W "This Routine also allows the User to EXCLUDE a particular Local Category ",!
 W "This Routine allows the User to Select INPATIENT or OUTPATIENT Referrals Only!",!
 W "This Routine allows the User to Select TYPE of Referral (CHS,IHS,OTHER) Only!",!
 ;
ASK ;
 W ! S DIC="^AUTTLOC(",DIC("A")="Enter Facility Name: ",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 G XIT
 S BMCFAC=+Y
 ;
KIND ;Ask for specific Type of Referral (IHS, CHS, OTHER)
 S DIR(0)="S^C:CHS;O:OTHER;I:IHS;A:ALL"
 S DIR("A")="Enter Type of Referral:",DIR("B")="ALL"
 S DIR("?")="You must select a Type from the List"
 K DA D ^DIR KILL DIR
 Q:$D(DIRUT)
 G:Y=0 ASK
 S BMCKIND=Y
ASK1 ;Restrict a Certain Local Category
 S BMCLCAT=0
 W ! S DIR(0)="Y0",DIR("A")="Would you like to EXCLUDE a particular Local Category in this report",DIR("B")="NO"
 S DIR("?")="To EXCLUDE a particular Local Category from this Report - Answer Yes."
 D ^DIR K DIR
 G:$D(DIRUT) ASK
 I 'Y G TYPE
CAT ;Category Restriction
 S BMCLCAT=0
 S DIC="^BMCLCAT(",DIC(0)="AEQM",DIC("A")="Enter the Local Category to EXCLUDE: "
 D ^DIC K DIC
 Q:$D(DIRUT)
 G:Y=0 TYPE
 S BMCLCAT=+Y
 ;
 ;
TYPE ;Select Inpatient Or Outpatient
 ;
 S DIR(0)="S^I:INPATIENT;O:OUTPATIENT;B:BOTH"
 S DIR("A")="Select Inpatient or Outpatient",DIR("B")="O"
 S DIR("?")="You must choose Inpatient or Outpatient"
 K DA D ^DIR KILL DIR
 Q:$D(DIRUT)
 G:Y=0 CAT
 S BMCTYP=Y
 ;
 ;IHS/OIT/FCJ ADDED NXT SECTION TO ALLOW SORT BY DOS
SORT ;SORT BY DATE INITIATED OR BY DATE OF SERVICE
 W !! S DIR(0)="S^I:DATE INITIATED;S:DATE OF SERVICE",DIR("B")="I"
 S DIR("A")="Select close by Date Initiated or by Date of Service"
 D ^DIR K DIR
 Q:$D(DIRUT)
 G:Y=0 TYPE
 S BMCDTS=Y
 ;IHS/OIT/FCJ END OF CHANGES
BD ;get beginning date
 W !! S DIR(0)="D^::EP"
 S DIR("A")="Enter beginning Referral Date "_$S(BMCDTS="I":"Initiated",1:"of Service")
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G ASK
 S BMCBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_BMCBD_"::EP"
 S DIR("A")="Enter ending Referral Date "_$S(BMCDTS="I":"Initiated",1:"of Service")
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S BMCED=Y
 S X1=BMCBD,X2=-1 D C^%DTC S BMCSD=X
 ;
PROCESS ;Process Data
 ;D ^BMCCLOS3  ;IHS/OIT/FCJ
 D @$S(BMCDTS="S":"DOS^BMCCLOS3",1:"DRI^BMCCLOS3")  ;IHS/OIT/FCJ
 ;
XIT ;
 K BMCBD,BMCBT,BMCBTH,BMCCOL,BMCD,BMCDA,BMCDATE,BMCED,BMCET,BMCFILE,BMCG,BMCHRN,BMCIOM,BMCJOB,BMCNODE,BMCODAT,BMCOPT,BMCP,BMCPG,BMCPN,BMCQUIT,BMCRCNT,BMCREF,BMCRREC,BMCSD,BMCWP,BMCX,BMCC
 K BMCLOCC,BMCLOCI,BMCLOCP,BMCLOCPP,BMCLCAT,BMCCT,BMCFAC,BMCRIEN,BMCRSTAT,BMCTYP,BMCTYP,BMCKIND,BMCDTS,BMCCLS,BMCADOS
 D KILL^AUPNPAT
 K %,C,D0,DA,DFN,DI,DIC,DIQ,DIR,DIRUT,DIWF,DIWL,DIWR,DR,DTOUT,F,I,X,Y,Z
 Q
