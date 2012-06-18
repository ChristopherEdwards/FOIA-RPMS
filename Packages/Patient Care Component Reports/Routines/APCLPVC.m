APCLPVC ; IHS/CMI/LAB - POV GROUPED BY APC CODES - 6/21/89 12:58 PM ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;SEARCH VISIT FILE FOR DATE RANGE AND GENERATE APC RECODED AMBULATORY PCC VISIT COUNTS
 ;
START ;
 D GO
SD S %DT("A")="Starting Visit Date: ",%DT="AEPX" W ! D ^%DT
 G:Y=-1 QUIT S APCLSD=Y X ^DD("DD") S APCLSDY=Y
ED S %DT("A")="Ending Visit Date: " W ! D ^%DT
 I Y=-1 D GO G SD
 S APCLFD=Y X ^DD("DD") S APCLFDY=Y
 I APCLFD<APCLSD W !!,"Ending Date cannot be before Starting Date! Please reenter.",! G SD
COM ;
 K APCLCOM
 S DIR(0)="Y",DIR("A")="Should the counts only include visits for patients from a specific community",DIR("B")="N"
 S DIR("?")="You may restrict the POV counts to patients whose current community matches the one you select if you answer 'Y' to this question." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G ED
 I Y'=1 G LIM
 S DIC(0)="AEMQZ",DIC="^AUTTCOM(" W ! D ^DIC K DIC G:Y=-1 COM S APCLCOM=Y(0,0)
LIM  ;
 S DIR(0)="N^0:999:0",DIR("A")="How many (MAXIMUM) ICD9 POV's to include in each APC Category",DIR("B")="20"
 S DIR("?")="If you enter '0' the POV counts will be by APC category only.  If you enter a number, the APC counts will be broken down by ICD code as well, within the limit you specifiy." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) COM
 S APCLLIM=Y
ZIS ;
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G COM
 S XBRP="^APCLPVC2",XBRC="^APCLPVC1",XBRX="QUIT^APCLPVC",XBNS="APCL"
 D ^XBDBQUE
 D QUIT
QUIT ;
 K DIC,%DT,ZTSK,ZTQUEUED,I,J,K,Y
 K APCLIDFN,APCLSITE,APCLQUIT,APCL80D,APCLDTP,APCLFDY,APCLPG,APCLSDY,APCLINM,APCLINO,APCLPDFN,APCLBT,APCLJOB,APCLERR
 K APCLCNTL,APCLAPNM,APCLCNTI,APCLLIMC,APCLCOM,APCLICLN,APCLPCOM,APCLCNT,APCLCNTR,APCLICNO,APCLLIM,APCL,APCLVDFN,APCLVN0,APCLFD,APCLS,APCLSD,APCLX,APCLY,APCLAPC
 Q
GO W:$D(IOF) @IOF
 W ?25,"*** Purpose of Visit Counts ***",!!
 W !!,"The Purpose of Visit Counts will include only Ambulatory Visits within the",!,"date range you select."
 Q
