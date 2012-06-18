BTIUPRPN ;IHS/MSC/MGH Special header/printer formats  ;11-Nov-2010 14:59;DU
 ;;1.0;TEXT INTEGRATION UTILITIES;**1008**;Jun 20, 1997;Build 15
 ;Copy of SLC/MJC - Print SF 509 Progress Notes ;;7-6-95 9:00pm
DEVICE(TIUFLAG,TIUSPG) ; pick your device
 ;
 W ! K IOP S %ZIS="Q" D ^%ZIS I POP K POP G EXIT
 S TIUFLAG=+$G(TIUFLAG),TIUSPG=+$G(TIUSPG)
 I $D(IO("Q")) K IO("Q") D  G EXIT
 .S ZTRTN="ENTRY1^TIUPRPN",ZTSAVE("^TMP(""TIUPR"",$J,")=""
 .S ZTSAVE("TIUFLAG")="",ZTSAVE("TIUSPG")="",ZTDESC="TIU PRT PNS"
 .D ^%ZTLOAD W !,$S($D(ZTSK):"Request Queued!",1:"Request Canceled!")
 .K ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,TIUFLAG,TIUSPG
 .D HOME^%ZIS
 U IO D ENTRY1,^%ZISC
 Q
ENTRY ; Entry point to print progress notes-called from ^TIUA
 N TIUSPG
 U IO
ENTRY1 ; Entry point from above
 N TIUERR,D0,DN,Y,DTOUT,DUOUT,DIRUT,DIROUT,TIUTYPE
 I $E(IOST)="C" S (TIUSPG,TIUFLAG)=1
 I '+$G(TIUFLAG) S TIUSPG=1
 K ^TMP("TIULQ",$J)
 I $D(ZTQUEUED) S ZTREQ="@" ; Tell TaskMan to delete Task log entry
 ;If this title is defined as a special type
 ;S TIUTYPE=$P(TIU("DOCTYP"),U,1)
 S TIUTYPE=$P(TIUD0,U,1)
 I +TIUTYPE D PRINT^BTIUPRT1(TIUTYPE,1,0)
 E  D PRINT^TIUPRPN1($G(TIUFLAG),$G(TIUSPG))
EXIT K ^TMP("TIULQ",$J),^TMP("TIUPR",$J)
 Q
DIV ; enter/edit division params in file 8925.94
 N DA,DIC,DIV,DIE,DR,TIUQT,Y,TITLE
 F  W ! D  Q:$D(TIUQT)
 .S DIC=8925.94,DIC(0)="AEQMNL"
 .S DIC("A")="Select Division for PNs Outpatient Batch Print: "
 .D ^DIC I Y<0 S TIUQT=1 Q
 .S DIV=+Y
 .K DIC
 .;Find the title
 .S DIC="^TIU(8925.94,"_DIV_",9999999.11,",DIC(0)="AELQ"
 .S DA(1)=DIV,DIC("P")=$P(^DD(8925.94,9999999.11,0),"^",2)
 .D ^DIC I Y<0 S TIUQT=1 Q
 .S TITLE=+Y
 .K Y
 .S DIE=DIC
 .S DA(1)=DIV,DA=TITLE
 .S DR="1;2" D ^DIE
 .K DR,DA,DIE,DIC
 K DLAYGO
 Q
