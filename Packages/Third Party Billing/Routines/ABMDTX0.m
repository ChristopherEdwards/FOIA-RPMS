ABMDTX0 ; IHS/ASDST/DMJ - EXPORT BILLS FROM FACILITY ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
DATA ;  EP
 K ^TMP("ABMDTX",$J) S Y=DT X ^DD("DD") S ^TMP("ABMDTX",$J,0)=Y
 S ABM("CNT")=0
 D REDO:ABM("REDO"),NEW:'ABM("REDO")
 Q
 ;--------------------------------------------------------------------
NEW S ABM("BDFN")=0 F  S ABM("BDFN")=$O(^ABMDBILL(DUZ(2),"AA","A",ABM("BDFN"))) Q:'ABM("BDFN")  D BILL
 Q
 ;--------------------------------------------------------------------
REDO S ABM("BDFN")=0 F  S ABM("BDFN")=$O(^ABMDBILL(DUZ(2),"AZ",ABM("ADFN"),ABM("BDFN"))) Q:'ABM("BDFN")  D BILL
 Q
 ;--------------------------------------------------------------------
BILL Q:'$D(^ABMDBILL(DUZ(2),ABM("BDFN"),0))  S ABM(0)=^ABMDBILL(DUZ(2),ABM("BDFN"),0)
 I $P(ABM(0),U,4)="X" D  Q   ; If cancelled bill del export status & q
 . S DA=ABM("BDFN")
 . S DIE="^ABMDBILL(DUZ(2),"
 . S DR=".16///@"
 . D ^ABMDDIE
 . Q
 I $P($G(^ABMDBILL(DUZ(2),ABM("BDFN"),1)),U,7) S ^TMP("ABMDTX",$J,"EXP",$P(^(1),U,7))=""
 S ABM("ITYPES")=$P($G(^ABMDPARM(DUZ(2),1,3)),"^",5) S:ABM("ITYPES")="" ABM("ITYPES")="PHF"
 I ABM("ITYPES")'[$P($G(^AUTNINS($P(ABM(0),U,8),2)),U) G RSET
 S ABM("IDFN")=$P(ABM(0),U,8) D INSCHK
 S ABM("PNAME")=$P(^DPT($P(ABM(0),U,5),0),U)
 S ^TMP("ABMDTX",$J,"SORT",ABM("PNAME"),$P(ABM(0),U,3),ABM("BDFN"))=""
 S ^TMP("ABMDTX",$J,ABM("BDFN"))=""
 S ABM("CNT")=ABM("CNT")+1
 Q
 ;--------------------------------------------------------------------
RSET ;SET STATUS FIELDS
 S DA=ABM("BDFN"),DIE="^ABMDBILL(DUZ(2),",DR=".16///@" D ^ABMDDIE
 Q:$P(^ABMDBILL(DUZ(2),ABM("BDFN"),0),"^",4)="C"
 S DR=".04////T" D ^ABMDDIE
 Q
 ;--------------------------------------------------------------------
WRT ;EP for Printing Transmittal List
 D HEADER^ABMDTX1
 S (ABM("CT"),ABM("AMT"))=0
 S ABM("P")=0 F  S ABM("P")=$O(^TMP("ABMDTX",$J,"SORT",ABM("P"))) Q:ABM("P")=""  D
 .S ABM("L")=0 F  S ABM("L")=$O(^TMP("ABMDTX",$J,"SORT",ABM("P"),ABM("L"))) Q:'ABM("L")  D
 ..S ABM("BDFN")=0 F  S ABM("BDFN")=$O(^TMP("ABMDTX",$J,"SORT",ABM("P"),ABM("L"),ABM("BDFN"))) Q:'ABM("BDFN")  D
 ...S ABM(0)=^ABMDBILL(DUZ(2),ABM("BDFN"),0),ABM(1)=^(1),X=$P(ABM(1),U,5)
 ...W ?1,$$SDT^ABMDUTL(X)
 ...S ABM("PDFN")=$P(ABM(0),U,5)
 ...W ?12,$J($P(ABM(0),U),7),?20,$E(ABM("P"),1,30)
 ...S ABM("HRN")=$S($D(^AUPNPAT(ABM("PDFN"),41,ABM("L"),0)):$P(^(0),U,2),1:0) I 'ABM("HRN"),$D(^AUTTSITE(1,0)),$D(^AUPNPAT(ABM("PDFN"),41,+^(0),0)) S ABM("HRN")=$P(^(0),U,2)
 ...W ?52,$J(ABM("HRN"),6)
 ...S X=+^ABMDBILL(DUZ(2),ABM("BDFN"),7) W ?61,$$SDT^ABMDUTL(X)
 ...S ABM("IDFN")=$P(ABM(0),U,8)
 ...W ?73,$E($P(^AUTNINS(ABM("IDFN"),0),U),1,28)
 ...W ?103,$J($FN($P(^ABMDBILL(DUZ(2),ABM("BDFN"),2),U),",",2),8)
 ...S ABM("CT")=ABM("CT")+1,ABM("AMT")=ABM("AMT")+^ABMDBILL(DUZ(2),ABM("BDFN"),2)
 ...W ?113,$S($P(ABM(0),U,7)=111:"I",$P(ABM(0),U,7)=998:"D",1:"O")
 ...W ?117,$J($S($P(ABM(0),U,7)=111:$P(^ABMDBILL(DUZ(2),ABM("BDFN"),7),U,3),$P($G(^ABMDBILL(DUZ(2),ABM("BDFN"),6)),U,9)>0:$P(^(6),U,9),1:1),2),!
 ...I $Y+6>IOSL,$E(IOST,1)="P" D HEADER^ABMDTX1
 ...I $Y+3>IOSL,$E(IOST,1)="C" S DIR(0)="E" D ^DIR K DIR D HEADER^ABMDTX1
 ...I $Y+3>IOSL,$E(IOST,1)="C" D
 ....S DIR(0)="E" D ^DIR K DIR I 'Y S ABM("P")="ZZZ" Q
 ....D HEADER^ABMDTX1
 W ?5 F I=1:1:110 W "-"
 W !,?5,"TOTAL CLAIMS = ",ABM("CT"),?45,"TOTAL CLAIM AMT = ",?64,$J($FN(ABM("AMT"),",",2),8),!!
 S DIE="^ABMDAOTX(DUZ(2),",DA=ABM("ADFN"),DR=".02////"_ABM("CT")_";.04////"_ABM("AMT") D ^ABMDDIE
 Q
 ;--------------------------------------------------------------------
INSCHK ;PROCEDURE TO INSPECT FOR COMPLETE INSURANCE RECORD
 S ABM("IERR")=0,ABM("ND")="" G NXTNODE
IERR S ABM("IERR")=ABM("IERR")_1
NXTNODE S ABM("ND")=$O(^AUTNINS(ABM("IDFN"),ABM("ND"))) G:(ABM("ND")="")!(+ABM("ND")>1) INSCHKC
 S ABM("I")=^AUTNINS(ABM("IDFN"),ABM("ND"))
 I ABM("ND")=1 I $P(ABM("I"),U)="",$P(ABM("I"),U,5)="" G NXTNODE
 G IERR:$L($P(ABM("I"),U,2))<2!($L($P(ABM("I"),U,3))<2)!(+$P(ABM("I"),U,4)<1)
 G IERR:'$D(^DIC(5,+$P(ABM("I"),U,4),0))
 I $L($P(ABM("I"),U,5))<5!($P(ABM("I"),U,5)'?5N.E) G IERR
 S ABM("IERR")=ABM("IERR")_0 G NXTNODE
INSCHKC I ABM("IERR")="01"!(ABM("IERR")="010") S ^TMP("ABMDTX",$J,"INS-ERR",ABM("IDFN"))=""
 I ABM("IERR")="001"!(ABM("IERR")="011") S ^TMP("ABMDTX",$J,"INS-ERR",ABM("IDFN"))="*"
 Q
