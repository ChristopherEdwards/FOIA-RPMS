ACHSRPIN ; IHS/ITSC/PMF - retrieve ALL insurances, display, choose  ;
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**3,13**;JUN 11,2001
 ;ACHS*3.1*3  whole routine new
 ;ACHS*3.1*13 11/27/06 IHS/OIT/FCJ PRT POLICY # & COV FR CORRECT FILES
 ;
 ;INPUT:     DFN
 ;
 ;OUTPUT:    INS array, list all insurances
 ;
 ;
GET ;EP- FROM ACHSDN2A
 K INS
 ;
 I $D(^AUPNMCR(DFN)) D MCR
 I $D(^AUPNMCD("B",DFN)) D MCD
 I $D(^AUPNRRE(DFN,0)) D RRE
 I $D(^AUPNPRVT(DFN,11)) D PVT
 ;
 K I,JJ
 Q
 ;
 ;
 ;
MCR ;
 ;I   used first to carry this patient's medicare data,
 ;    later a subscript var
 ;X   the first three pieces to display about this patient's medicare
 ;
 S I=$G(^AUPNMCR(DFN,0))
 ;
 ;if no medicare number, stop
 I '$P(I,U,3) Q
 ;
 S X=$P($G(^AUTNINS($P(I,U,2),0)),U)_U_$P(I,U,3)_U
 I $P(I,U,4)'="" S $P(X,U,3)=^AUTTMCS($P(I,U,4),0)
 ;
 ;GO THRU 'MEDICARE ELIGIBLE' FILE
 S I=0 F  S I=$O(^AUPNMCR(DFN,11,I)) Q:+I=0  D
 . S INS=$G(INS)+1
 . S INS(INS)=X_U_$P($G(^AUPNMCR(DFN,11,I,0)),U,3)_U_$$MDY($P($G(^AUPNMCR(DFN,11,I,0)),U))_U_$$MDY($P($G(^AUPNMCR(DFN,11,I,0)),U,2))_U_"M"_U_I
 . Q
 Q
 ;
 ;LETS LOOK AT POSSIBLE MEDICAID COVERAGE
MCD ;
 K ^TMP("ACHSRP31",$J,"MCD")
 S I=0 F  S I=$O(^AUPNMCD("B",DFN,I)) Q:'I  S JJ=0 F  S JJ=$O(^AUPNMCD(I,11,JJ)) Q:'JJ  D
 . S ^TMP("ACHSRP31",$J,"MCD",9999999-JJ)=$G(^AUPNMCD(I,11,JJ,0))
 . S $P(^TMP("ACHSRP31",$J,"MCD",9999999-JJ),U,4,6)=$P($G(^AUPNMCD(I,0)),U,2,4)
 . S $P(^TMP("ACHSRP31",$J,"MCD",9999999-JJ),U,7,8)=I_U_JJ
 . Q
 ;
 ;
 S JJ=0 F ACHS=1:1:4 S JJ=$O(^TMP("ACHSRP31",$J,"MCD",JJ)) Q:'JJ  I $P(^TMP("ACHSRP31",$J,"MCD",JJ),U,6)]"",$D(^DIC(5,$P(^(JJ),U,6),0)) S $P(^TMP("ACHSRP31",$J,"MCD",JJ),U,6)=$P(^(0),U,2)
 S I=0 F ACHS=1:1:4 S I=$O(^TMP("ACHSRP31",$J,"MCD",I)) Q:'I  D
 . S INS=$G(INS)+1,DAT=^TMP("ACHSRP31",$J,"MCD",I)
 . S INS(INS)=$P(^AUTNINS($P(DAT,U,4),0),U)_U_$P(DAT,U,5)_U_$P(DAT,U,6)_U_$P(DAT,U,3)_U_$$MDY($P(DAT,U))_U_$$MDY($P(DAT,U,2))_U_"C"_U_$P(DAT,U,7,8)
 . Q
 ;
 K DAT,^TMP("ACHSRP31",$J,"MCD")
 Q
 ;
RRE ;
 S FIRST=""
 I $P($G(^AUPNRRE(DFN,0)),U,2)'="" S FIRST=$P($G(^AUTNINS($P(^AUPNRRE(DFN,0),U,2),0)),U)
 I $P($G(^AUPNRRE(DFN,0)),U,3)'="" S FIRST=FIRST_U_$P(^AUTTRRP($P(^AUPNRRE(DFN,0),U,3),0),U)
 S FIRST=FIRST_U_$P($G(^AUPNRRE(DFN,0)),U,4)
 ;
 ;******LOOP THRU RAILROAD ELIGIBLE FILE
 S JJ=0 F  S JJ=$O(^AUPNRRE(DFN,11,JJ)) Q:JJ=""  D
 . S INS=$G(INS)+1,INS(INS)=FIRST_U_$P(^AUPNRRE(DFN,11,JJ,0),U,3)_U_$$MDY($P(^(0),U))_U_$$MDY($P(^(0),U,2))_U_"R"_U_JJ
 . Q
 Q
 ;
PVT ;
 S I=0 F  S I=$O(^AUPNPRVT(DFN,11,I)) Q:'I  D
 . ;ACHS*3.1*13 11/27/06 IHS/OIT/FCJ PRT POLICY # & COV FR CORRECT FILES
 . ;S INS=$G(INS)+1,INS(INS)=$E($P(^AUTNINS($P(^AUPNPRVT(DFN,11,I,0),U),0),U),1,26)_U_$P(^AUPNPRVT(DFN,11,I,0),U,2)
 .S ACHSPINS=^AUPNPRVT(DFN,11,I,0)
 .S INS=$G(INS)+1,INS(INS)=$E($P(^AUTNINS($P(ACHSPINS,U),0),U),1,26)
 .I $P(ACHSPINS,U,8),$D(^AUPN3PPH($P(ACHSPINS,U,8),0)) S INS(INS)=INS(INS)_U_$P(^AUPN3PPH($P(ACHSPINS,U,8),0),U,4)
 . ;I $P(^AUPNPRVT(DFN,11,I,0),U,3) S $P(INS(INS),U,4)=$P(^AUTTPIC($P(^(0),U,3),0),U)
 . I $P(ACHSPINS,U,8),$P(^AUPN3PPH($P(ACHSPINS,U,8),0),U,5) S $P(INS(INS),U,4)=$P(^AUTTPIC($P(^AUPN3PPH($P(ACHSPINS,U,8),0),U,5),0),U)
 . S $P(INS(INS),U,5,6)=$$MDY($P(^AUPNPRVT(DFN,11,I,0),U,6))_U_$$MDY($P(^(0),U,7))_U_"P"_U_I
 K ACHSPINS Q
 ;
MDY(X) ;
 Q $E(X,4,7)_$E(X,2,3)
 ;
PRT ;EP - FROM ACHSDN2A
 ;write out the array INS
 ;
 W !!,?5,"Type of Coverage",?35,"Policy #",?55,"Cov. type  EligDt TermDt",!,?5,"----------------",?35,"--------",?55,"---------  ------ ------"
 F JJ="" F CNT=1:1 S JJ=$O(INS(JJ)) Q:JJ=""  S DATA=INS(JJ) W !,CNT,".",?5,$P(DATA,U,1),?35,$P(DATA,U,2)," ",$P(DATA,U,3),?55,$P(DATA,U,4),?66,$P(DATA,U,5),?73,$P(DATA,U,6)
 K CNT,DATA,JJ
 Q
