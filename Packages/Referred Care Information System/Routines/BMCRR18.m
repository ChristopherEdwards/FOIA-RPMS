BMCRR18 ; IHS/PHXAO/TMJ - list patients for Inpatient Discharge Comments ; 
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ;
 ;
 W !?10,"********  DISCHARGE LISTING BY ENDING DATE OF SERVICE  ********",!
 W !!,"The report will print a list of all Inpatient referrals' ENDING DATE of Service",!,"Range entered by the user.  This report will list Patient "
 W "Name, Health Record #,",!,"Age, Community, Actual Beginning Dt of Service,"
 W " Facility Referred To, Purpose",!,"of Referral, Actual Ending Dt of Service,"
 W " & Los",!!
 W "Selecting the Detailed Patient Listing will provide a separate page for each",!,"Referral & also includes the Discharge Comments."
 W !!,"The Summary Report Listing will include all Discharges on one",!,"report, but will not include the Discharge Comments.",!
 W !,"Inhouse Referrals are NOT included.",!
BD ;get beginning END OF SERVICE date
 W !! S DIR(0)="D^::EP",DIR("A")="Enter beginning ENDING DT OF SERVICE Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S BMCBD=Y
ED ;get ending END OF SERVICE date
 W ! S DIR(0)="D^"_BMCBD_"::EP",DIR("A")="Enter ending ENDING OF SERVICE Date"  D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S BMCED=Y
 S X1=BMCBD,X2=-1 D C^%DTC S BMCSD=X
 ;
OUTPUT ;Print Output Summary or Detail
 S BMCOUTP=""
 S DIR(0)="S^D:Detailed Patient Listing;S:Summary Report Listing",DIR("A")="Select Report Printing",DIR("B")="D" K DA D ^DIR K DIR
 I $D(DIRUT) G XIT
 S BMCOUTP=Y
 ;
ZIS ;call to XBDBQUE
 K BMCOPT
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) S BMCQUIT="" Q
 S BMCOPT=Y
 G:$G(BMCQUIT) XIT
 I $G(BMCOPT)="B" D BROWSE,XIT Q
 S XBRP="^BMCRR18P",XBRC="^BMCRR181",XBRX="XIT^BMCRR18",XBNS="BMC"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^BMCRR18P"")"
 S XBRC="^BMCRR181",XBRX="XIT^BMCRR18",XBIOP=0 D ^XBDBQUE
 Q
XIT ;EP - CALLED FROM BMCRR18
 K BMCBD,BMCBT,BMCBTH,BMCCOL,BMCD,BMCDA,BMCDATE,BMCED,BMCET,BMCFILE,BMCG,BMCHRN,BMCIOM,BMCJOB,BMCNODE,BMCODAT,BMCOPT,BMCP,BMCPG,BMCPN,BMCQUIT,BMCRCNT,BMCREF,BMCRREC,BMCSD,BMCWP,BMCX,BMCC,BMCOUTP
 K BMCRNUMB
 D KILL^AUPNPAT
 K %,C,D0,DA,DFN,DI,DIC,DIQ,DIR,DIRUT,DIWF,DIWL,DIWR,DR,DTOUT,F,I,X,Y,Z
 Q
