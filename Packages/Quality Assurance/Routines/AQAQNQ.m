AQAQNQ ;IHS/ANMC/LJF - INQUIRE TO CREDENTIAL ENTRY; [ 12/23/93  12:04 PM ]
 ;;2.2;STAFF CREDENTIALS;**1**;01 OCT 1992
 ;IHS/ORDC/LJF 4/29/93 PATCH #1: changed print of security keys to NEW
 ;                               PERSON file per Kernel 7
 ;
PROV ;EP;****>  displays data for a given provider
 W @IOF,!!?20,"INQUIRY TO PROVIDER CREDENTIALS",!!
 K DIC S DIC("A")="Select PROVIDER NAME:  ",DIC(0)="AQEMZ",DIC=9002165
 D ^DIC G PEND:Y=-1
 S L=0,DIC=9002165,FLDS="[AQAQINQUIRE]",BY="@NUMBER",(TO,FR)=+Y
 D EN1^DIP
 K DIR S DIR(0)="E",DIR("A")="RETURN to continue" D ^DIR
PEND W @IOF K DIC,DIR,X,Y Q
 ;
 ;
INAC ;EP;****>  displays data for an inactive provider
 W @IOF,!!?20,"VIEW INACTIVE PROVIDER'S RECORD",!!
 S AQAQINAC="" ;variable to override screen on inactive providers
 K DIC S DIC("A")="Select NAME OF INACTIVE PROVIDER:  ",DIC(0)="AQEMZ"
 S DIC("S")="I $D(^DIC(6,Y,""I"")),(^(""I"")'="""")"
 S DIC=9002165 D ^DIC G PEND:Y=-1
 S L=0,DIC=9002165,FLDS="[AQAQINQUIRE]",BY="@NUMBER",(TO,FR)=+Y
 D EN1^DIP
 K DIR S DIR(0)="E" D ^DIR
IEND W @IOF K DIC,DIR,X,Y,AQAQINAC Q
 ;
APPL ;EP;****> prints summary for all pending applications
 W @IOF,!!?20,"PENDING APPOINTMENT APPLICATIONS",!!
 W ?5,"This report will print summaries on each provider whose"
 W !,"original application has not yet been approved.  The summaries"
 W !,"will print in alphabetical order.",!!
 ;
 S %ZIS="NPQ" D ^%ZIS Q:POP  I '$D(IO("Q")) G APPL1
 K IO("Q") S ZTRTN="APPL1^AQAQNQ",ZTDESC="PENDING APPLICATIONS"
 D ^%ZTLOAD K ZTSK D ^%ZISC Q
 ;
APPL1 ;**> set variables then call FileMan print
 S L=0,DIC=9002165,FLDS="[AQAQINQUIRE]",BY="#@NAME",(TO,FR)=""
 S IOP=ION,DIS(0)="I $P(^AQAQC(D0,0),U,4)=""""&($P($G(^AQAQC(D0,""R"",1,0)),U,2)="""")"
 D EN1^DIP
 I '$D(ZTQUEUED) K DIR S DIR(0)="E" D ^DIR
AEND W @IOF K DIC,DIR,X,Y Q
 ;
 ;
KEYS ;EP;****>  displays who has access to Credential system
 W @IOF
 W !!,"This program displays a list of computer users who have access"
 W !,"to this Credential Tracking System.  This tool is designed to"
 W !,"be used to monitor the security of the package.",!!
 ;K DIC S DIC(0)="QEMZ",DIC=19.1,X="AQAQZMENU" D ^DIC G KEND:Y=-1 ;IHS/ORDC/LJF 4/29/93 PATCH #1
 ;S L=0,DIC=19.1,FLDS="[AQAQSECURITY]",BY="@NUMBER",(TO,FR)=+Y ;IHS/ORDC/LJF 4/29/93 PATCH #1
 S L=0,DIC=200,FLDS="[AQAQ ACCESS PRINT]",BY="[AQAQ ACCESS SORT]" ;IHS/ORDC/LJF 4/29/93 PATCH #1
 D EN1^DIP
 K DIR S DIR(0)="E" D ^DIR
KEND W @IOF K DIC,DIR,X,Y Q
 ;
 ;
USER ;EP;****>  prints list of all entries and users who have accessed them
 W @IOF,!!?20,"LISTING OF USER ACCESS TO PROVIDER ENTRIES",!!
 S L=0,DIC=9002165,FLDS="[AQAQUSER]",BY="@NAME",(TO,FR)=""
 D EN1^DIP
 K DIR S DIR(0)="E" D ^DIR
UEND W @IOF K DIC,DIR,X,Y Q
 ;
 ;
NOTCONV ;EP;****>  print data not converted to NEW CREDENTIALS file
 W @IOF,!!?20,"DATA NOT CONVERTED TO NEW CREDENTIALS FILE",!!
 W ?5,"This report will print a list of the data that could not"
 W !?5,"be converted to the NEW CREDENTIALS file.  This data includes"
 W !?5,"medical licensure data plus the date privileges were granted."
 W !!
 ;
 S %ZIS="NPQ" D ^%ZIS Q:POP  I '$D(IO("Q")) G NOTC1
 K IO("Q") S ZTRTN="NOTC1^AQAQNQ",ZTDESC="DATA NOT CONVERTED"
 D ^%ZTLOAD K ZTSK D ^%ZISC Q
 ;
NOTC1 ;**> set variables then call FileMan print
 S L=0,DIC=9002155,FLDS="[AQAQ NOT CONVERTED]",BY="@NAME",(TO,FR)=""
 S IOP=ION D EN1^DIP
 I '$D(ZTQUEUED) K DIR S DIR(0)="E" D ^DIR
NEND W @IOF K DIC,DIR,X,Y Q
 ;
 ;
MLHELP ;EP;***> help on Medical License Verified field
 W !!?5,"The license verification date should be one of the following:"
 W !?10,"(1)  Date of Verification Letter"
 W !?10,"(2)  Date of Printout"
 W !?10,"(3)  Date of Call"
 W !?10,"(4)  Date Copy Received (for re-licensure)"
 W !! Q
 ;
 ;
DLQPRV ;EP;***> print inquiry on delq chart numbers for provider
 W @IOF,!!?20,"MEDICAL RECORDS REVIEW FOR A PROVIDER",!!
 K DIC S DIC("A")="Select PROVIDER NAME:  ",DIC(0)="AQEMZ",DIC=9002165
 D ^DIC G PEND:Y=-1
 S L=0,DIC=9002165,FLDS="[AQAQ MED RECORD REVIEW]"
 S BY="@NUMBER",(TO,FR)=+Y D EN1^DIP
 K DIR S DIR(0)="E" D ^DIR
DEND W @IOF K DIC,DIR,X,Y Q
