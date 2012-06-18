APCDPCCM ; IHS/CMI/LAB - UPDATE PCC MASTER CONTROL PCC LINK ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 W:$D(IOF) @IOF
 W !,$$CTR("PCC DATA ENTRY SUPERVISOR MENU",80)
 W !!,$$CTR("UPDATE PCC MASTER CONTROL FILE and ANCILLARY TO PCC LINKs",80)
 W !,"This option is used to update the PCC Master Control file and the"
 W !,"Ancillary to PCC link status for ancillary packages.",!,"You should be very careful when using this option."
 W !
 ;continue or NOT
 S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 I 'Y D XIT Q
 ;get site
 S APCDSITE=""
 S DIC=9001000,DIC(0)="AEMQL",DIC("A")="Enter your SITE Name: " D ^DIC
 I Y=-1 D XIT Q
 S (DA,APCDSITE)=+Y,DDSFILE=9001000,DR="[APCD PCC MASTER CONTROL UPDATE]" D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" K DIMSG H 3 D XIT Q
 D XIT
 Q
XIT ;
 K DIADD,DLAYGO
 D EN^XBVK("APCD")
 D ^XBFMK
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
