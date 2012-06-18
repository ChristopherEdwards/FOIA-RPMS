ABMDTX3 ; IHS/ASDST/DMJ - PT 4 OF CLAIM EXPORT PROGRAM ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 S (ABM("BDFN"),ABM("AMT"),ABM("CNT"))=0
 F  S ABM("BDFN")=$O(^TMP("ABMDTX",$J,ABM("BDFN"))) Q:'ABM("BDFN")  D
 . Q:'$D(^ABMDBILL(DUZ(2),ABM("BDFN"),0))
 . S ABM(0)=^ABMDBILL(DUZ(2),ABM("BDFN"),0)
 . S ABM(1)=^ABMDBILL(DUZ(2),ABM("BDFN"),1)
 . S ABM("IDFN")=$P(ABM(0),U,8)           ; Active Insurer IEN
 . S ABM("X1")="ABP1"
 . S ABM("P")=$P(ABM(0),U,5)              ; Patient IEN
 . S ABM("L")=$P(ABM(0),U,3)              ; Location IEN
 . S $P(ABM("X1"),U,2)=$P(^DPT(ABM("P"),0),U)  ; Patient name
 . S $P(ABM("X1"),U,23)=$P(^DPT(ABM("P"),0),U,9)
 . S $P(ABM("X1"),U,3)=$P(^AUTTLOC(ABM("L"),0),U,10)  ; ASU fac index
 . S ABM("HRN")=$S($D(^AUPNPAT(ABM("P"),41,ABM("L"),0)):$P(^(0),U,2),1:0)
 . I 'ABM("HRN"),$D(^AUTTSITE(1,0)),$D(^AUPNPAT(ABM("P"),41,+^(0),0)) S ABM("HRN")=$P(^(0),U,2)
 . S $P(ABM("X1"),U,4)=ABM("HRN")
 . S $P(ABM("X1"),U,5)=$P(^ABMDBILL(DUZ(2),ABM("BDFN"),7),U)
 . S ABMP("VDT")=$P(ABM("X1"),U,5)
 . S $P(ABM("X1"),U,6)=$S($P(ABM(0),U,7)=111:"I",$P(ABM(0),U,7)=998:"D",1:"O")
 . S $P(ABM("X1"),U,7)=$S($P(ABM(0),U,7)=111:$P(^ABMDBILL(DUZ(2),ABM("BDFN"),7),U,3),$P($G(^ABMDBILL(DUZ(2),ABM("BDFN"),6)),U,9)>0:$P(^(6),U,9),1:1)
 . S $P(ABM("X1"),U,8)=+$FN($P(^ABMDBILL(DUZ(2),ABM("BDFN"),2),U),"T",2)
 . S ABM("AMT")=ABM("AMT")+$P(ABM("X1"),U,8)
 . S $P(ABM("X1"),U,22)=$P(^ABMDBILL(DUZ(2),ABM("BDFN"),2),U,2)
 . K ABMV
 . S ABMP("PDFN")=ABM("P")
 . S ABMP("LDFN")=ABM("L")
 . S ABMP("VTYP")=$P(ABM(0),U,7)
 . S ABMP("BDFN")=ABM("BDFN")
 . S ABMP("GL")="^ABMDBILL(DUZ(2),"_ABM("BDFN")_","
 . S Y=ABM("IDFN")
 . S ABM("XIEN")=ABM("IDFN")
 . D SEL^ABMDE2X
 . I $D(ABMV("X1")) D
 . . S $P(ABM("X1"),U,11)=$P(ABMV("X1"),U,4)
 . . S $P(ABM("X1"),U,12)=$P($P(ABMV("X2"),U),";",2)
 . S $P(ABM("X1"),U,10)=$P(ABM(1),U,5)
 . S ABM("IDFN")=$P(ABM(0),U,8)
 . S:+$P(^AUTNINS(ABM("IDFN"),0),U,8) $P(ABM("X1"),U,9)=$P(^(0),U,8)
 . F ABM("I")=1:1:6 S $P(ABM("X1"),U,ABM("I")+12)=$P(^AUTNINS(ABM("IDFN"),0),U,ABM("I"))
 . S $P(ABM("X1"),U,19)=$P(^AUTNINS(ABM("IDFN"),0),U,9)
 . S ABM("X2")="ABP2"
 . I $D(^AUTNINS(ABM("IDFN"),1))=1 D
 . . S ABM(1)=^AUTNINS(ABM("IDFN"),1)
 . . F ABM("I")=1:1:5 S $P(ABM("X2"),U,ABM("I")+1)=$P(ABM(1),U,ABM("I"))
 . S $P(ABM("X1"),U,20)=$P(ABM(0),U)
 . S $P(ABM("X1"),U,21)=$S(ABM("REDO"):ABM("ADFN"),1:DT)
 . S ABM("CNT")=ABM("CNT")+1
 . S ^TMP($J,ABM("CNT"))=ABM("X1")
 . S:ABM("CNT")=1 (ABM("FDT"),ABM("EDT"))=$P(ABM("X1"),U,10)
 . S ABM("CNT")=ABM("CNT")+1
 . S ^TMP($J,ABM("CNT"))=ABM("X2")
 . I ABM("CNT")#4=0,'$D(ABMP("AUTO")) U IO(0) W $J((ABM("CNT")/2),8)
 . I $P(ABM("X1"),U,10)<ABM("FDT") S ABM("FDT")=$P(ABM("X1"),U,10)
 . I $P(ABM("X1"),U,10)>ABM("EDT") S ABM("EDT")=$P(ABM("X1"),U,10)
 . S ABM("LREC")=ABM("BDFN")
 Q
