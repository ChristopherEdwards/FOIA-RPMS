BCHPCCBL ;IHS/CMI/LAB - back load chr visits to PCC [ 06/17/02  9:14 AM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**14**;OCT 28, 1996
 ;
 ;
 W:$D(IOF) @IOF
 W !!,"This routine will loop through all CHR records for a time frame you specify",!,"and if there is no PCC visit already created it will fire the CHR to PCC",!,"link for that record.",!!
 W !!,"This routine should be used if the PCC link was turned off for some reason",!,"or another.",!!
GETDATES ;
 S BCHBLCNT=0
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter BEGINNING Visit Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S BCHBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_BCHBD_":DT:EP",DIR("A")="Enter ENDING Visit Date" S Y=BCHBD D DD^%DT S DIR("B")=Y,Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S BCHED=Y
 S X1=BCHBD,X2=-1 D C^%DTC S BCHSD=X
 S DIR(0)="Y",DIR("A")="Are you sure you want to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 I 'Y D XIT Q
PROCESS ;
 F  S BCHSD=$O(^BCHR("B",BCHSD)) Q:BCHSD=""!(BCHSD>BCHED)  D
 .S BCHR=0 F  S BCHR=$O(^BCHR("B",BCHSD,BCHR)) Q:BCHR'=+BCHR  D
 ..Q:'$D(^BCHR(BCHR,0))
 ..Q:$P(^BCHR(BCHR,0),U,15)]""
 ..S BCHEV("TYPE")="A"
 ..D PROTOCOL^BCHUADD1
 ..S BCHBLCNT=BCHBLCNT+1
 ..Q
 .Q
 W !!,"All done. ",BCHBLCNT," records were reviewed and processed.",!
 D XIT
 Q
XIT ;
 D EN^XBVK("BCH")
 Q
