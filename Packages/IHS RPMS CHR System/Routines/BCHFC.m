BCHFC ; IHS/TUCSON/LAB - COUNT FORMS REPORT ;  [ 06/03/99  6:53 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
 ;
START ; 
 S BCHSITE="" S:$D(DUZ(2)) BCHSITE=DUZ(2)
 I '$D(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! K BCHSITE Q
 I 'DUZ(2) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER",!! K BCHSITE Q
 D INFORM
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Posting Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S BCHBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_BCHBD_":DT:EP",DIR("A")="Enter ending Posting Date" S Y=BCHBD D DD^%DT S DIR("B")=Y,Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S BCHED=Y
 S X1=BCHBD,X2=-1 D C^%DTC S BCHSD=X
 ;
DEC ;
 S DIR(0)="YO",DIR("A")="Report on ALL Operators",DIR("?")="If you wish to include visits entered by ALL Operators answer Yes.  If you wish to tabulate for only one operator enter NO." D ^DIR K DIR
 G:$D(DIRUT) BD
 I Y=1 S BCHDEC="ALL" G ZIS
DEC1 ;enter location
 S DIC("A")="Which Operator: ",DIC="^VA(200,",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 DEC
 S BCHDEC=+Y
ZIS ;
 S XBRP="^BCHFCP",XBRC="DRIVER^BCHFC",XBRX="XIT^BCHFC",XBNS="BCH"
 D ^XBDBQUE
 D XIT
 Q
DRIVER ; entry point for taskman
 S BCHBT=$H
 S U="^"
 D XTMP^BCHUTIL("BCHFC","CHR FORMS COUNT")
 D ^BCHFC1
 Q
ERR W $C(7),$C(7),!,"Must be a valid date and be Today or earlier. Time not allowed!" Q
XIT ;
 K DIC,%DT,IO("Q"),X,Y,POP,DIRUT,ZTSK,BCHH,BCHM,BCHS,BCHTS,ZTIO,%ZIS,%,DTOUT,DUOUT,X1,X2
 K BCH1,BCH2,BCH80S,BCHAP,BCHBD,BCHBDD,BCHBT,BCHDATE,BCHDEC,BCHDT,BCHED,BCHEDD,BCHET,BCHGOT,BCHFC,BCHVDES,BCHTDES,BCHDESU,BCHX,BCHQUIT
 K BCHLENG,BCHODAT,BCHPG,BCHPROC,BCHPROV,BCHSD,BCHSITE,BCHSORT,BCHSRT,BCHSUB,BCHTOT,BCHVSIT,BCHVREC,BCHWDAT,BCHY,BCHC,BCHDFN,BCHAVG,BCHDEC
 Q
 ;
INFORM ;
 W:$D(IOF) @IOF
 W !,"This report will generate a count of forms entered by a particular data entry",!,"operator or for ALL data entry operators for a date range that you specify.",!
 Q
 ;
