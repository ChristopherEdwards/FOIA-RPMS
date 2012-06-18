PSGMMAR5 ;BIR/CML3-MD MARS - GATHER INFO FOR ACK ORDERS ;14 Oct 98 / 4:29 PM
 ;;5.0; INPATIENT MEDICATIONS ;**15,20**;16 DEC 97
 ;
PEND ;*** Only select orders that were acknowledged by nurses and
 ;*** still having pending status.
 NEW PSJSYSW,PSJSYSW0
 S PSJSYSW=$O(^PS(59.6,"B",+$G(PSJPWD),0))
 S:PSJSYSW PSJSYSW0=$G(^PS(59.6,PSJSYSW,0))
 Q:'+$P($G(PSJSYSW0),U,6)
 NEW ND,ON,TYPE,QST
 F ON=0:0 S ON=$O(^PS(53.1,"AV",PSGP,ON)) Q:'ON  D
 . S ND=$G(^PS(53.1,ON,0)),TYPE=$P(ND,U,4)
 . I $P(ND,U,7)="P"!($P($G(^PS(53.1,ON,2)),U)["PRN") S QST="OZ"_$S($P(ND,U,4)="F":"V",1:"A")
 . E  S QST="CZ"_$S($P(ND,U,4)="F":"V",1:"A")
 . I PSGMTYPE[1 D:TYPE'="F" SETTMP D:TYPE="F" IV
 . I PSGMTYPE'[1 D
 .. I PSGMTYPE[2,(TYPE="U") D SETTMP Q
 .. I PSGMTYPE'[2,(TYPE="I") D SETTMP Q
 .. I PSGMTYPE[4,(TYPE="F") D IV
 Q
 ;
SETTMP ;*** Setup ^tmp for pending U/D and Inpatient med IVs.
 ;*** OZ_(V/A) = PRN/One time orders (V=IV).
 ;*** CZ_(V/A) = Continuous orders (A=U/D).
 I PSGMARS=2,(QST["CZ") Q
 I PSGMARS=1,(QST["OZ") Q
 NEW MARX
 D DRGDISP^PSJLMUT1(PSGP,+ON_"P",20,0,.MARX,1) S DRG=MARX(1)_U_+ON_"P"
 I PSGSS="P" S ^TMP($J,PPN,$S(+PSGMSORT:$E(QST,1),1:QST),DRG)="" Q
 S ^TMP($J,TM,PSGMARWN,SUB1,SUB2,$S(+PSGMSORT:$E(QST,1),1:QST),DRG)=""
 Q
 ;
IV ;*** Sort IV pending orders for 24 Hrs, 7/14 Day MAR.
 K DRG,P N X,ON55,PSJLABEL S DFN=PSGP,PSJLABEL=1 D GT531^PSIVORFA(DFN,ON)
 S X=$P(P("MR"),U,2)
 S QST=QST_4
 I DRG S X=$S($G(DRG("AD",1)):DRG("AD",1),1:$G(DRG("SOL",1))),X=$E($P(X,U,2),1,20)_U_+ON_"P" D
 . I PSGSS="P" S ^TMP($J,PPN,$S(+PSGMSORT:$E(QST,1),1:QST),X)="" Q
 . S:PSGRBPPN="P" ^TMP($J,TM,PSGMARWN,PPN,PSJPRB,$S(+PSGMSORT:$E(QST,1),1:QST),X)=""
 . S:PSGRBPPN="R" ^TMP($J,TM,PSGMARWN,PSJPRB,PPN,$S(+PSGMSORT:$E(QST,1),1:QST),X)=""
 Q
