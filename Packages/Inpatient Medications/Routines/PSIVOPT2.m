PSIVOPT2 ;BIR/PR,MLM-OPTION DRIVER (CONT) ;09-Dec-2010 09:06;SM
 ;;5.0; INPATIENT MEDICATIONS ;**23,29,58,1009**;16 DEC 97
 ;
 ; Reference to ^PS(55 is supported by DBIA# 2191.
 ; Reference to ^PSSLOCK is supported by DBIA #2789
 ;
 ;Modified - IHS/MSC/PLS - 12/09/10 - Line R+3
D ; Discontinue order.
 D NATURE^PSIVOREN I '$D(P("NAT")) W !,$C(7),"Order Unchanged." Q
 ;* 8/2* D EN1^PSJHL2(DFN,"OD",+ON55_"V","ORDER DISCONTINUED"),D1
 I '$$REQPROV^PSGOEC W !,$C(7),"Order Unchanged." Q
 D D1
 S PSIVALT=1,PSIVALCK="STOP",PSIVREA="D",ON=ON55 D LOG^PSIVORAL S P(3)=$P($G(^PS(55,DFN,"IV",+ON55,0)),U,3)
 Q
D1 N %,DA,DIE,DIU,STP,NSTOP
 D NOW^%DTC S NSTOP=+$E(%,1,12),STP=$P($G(^PS(55,DFN,"IV",+ON55,0)),U,3),NSTOP=+$S(STP>NSTOP:NSTOP,1:STP),P(17)="D"
 S DA(1)=DFN,DA=+ON55,DIE="^PS(55,"_DFN_",""IV"",",DR="109////"_NSTOP_$S('$P($G(^PS(55,DFN,"IV",+ON55,2)),U,7):";116////"_STP,1:"")_";100///D;.03////"_NSTOP,PSIVACT=1 D ^DIE
 I $S($G(PSIVAC)="OD":0,$G(PSIVAC)'="AD":1,$G(PSGALO)<1060:0,1:$P($G(PSJSYSW0),U,15)) S X=$S($G(PSIVAC)="AD":1,1:2) D ENLBL^PSIVOPT(X,$S(X=1:+$G(PSGUOW),1:DUZ),DFN,3,+ON55,$E("AD",1,3-X))
 D:'$D(PSJIVORF) ORPARM^PSIVOREN Q:'PSJIVORF  ;* S ORIFN=$P($G(^PS(55,DFN,"IV",+ON55,0)),U,21) Q:'ORIFN
 Q
 ;
R ; Renew order.
 I P(17)="D",P(12) N ERR D RI W:$G(ERR)=1 $C(7),"  Order unchanged." Q:$G(ERR)<2
 NEW PSGORQF S PSIVRNFG=1 D ORDCHK^PSJLIFN K PSIVRNFG Q:$G(PSGORQF)  W !
 I $T(OI^APSPMULT)]"" N OI S OI=+$G(^PS(55,DFN,"IV",+PSJORD,.2)) I '$$OI^APSPMULT(OI) W $C(7),"Sorry, this drug is not currently available in this facility" Q    ;IHS/MSC/JDS - 12/09/10 - MDF
 D NEWENT^PSIVORFE S P("OLDON")=ON55 K ON55 D NEW55^PSIVORFB I '$D(ON55) S ON55=P("OLDON") Q
 N PSIVOAT S PSIVOAT=P(11),X="" D ENAD^PSIVCAL S P(11)=PSIVOAT,P(2)=$G(PSIVADM)
 ;
R1 S P("NEWON")=ON55,(PSIVOK,EDIT)="10^25^1" D EDIT^PSIVEDT I X="^" D RD Q
 S:+VAIN(4)'=$P($G(^PS(55,DFN,"IV",+P("OLDON"),2)),U,10) P(11)=$$ENRNAT^PSGOU($P($G(^PS(55,DFN,"IV",+P("OLDON"),2)),U,10),+VAIN(4),P(9),P(11))
 S PSIVCHG=1
 D OK G:X["N" R1 I X=U D RD Q
 S P(17)="A",P("RES")="R",P("FRES")="" D:'$D(PSJIVORF) ORPARM^PSIVOREN I PSJIVORF D  Q:'$D(P("NAT"))
 .D NATURE^PSIVOREN I '$D(P("NAT")) D RD Q
 .S ON=ON55 ;D SET^PSIVORFE
 ;;S P(16)="",PSJORIFN="",PSIVACT=1,P(21)="" D SET55^PSIVORFB
 S P(16)="",PSJORIFN="",PSIVACT=1,P("21FLG")="" D SET55^PSIVORFB
 F PSIV=P("OLDON"),P("NEWON") K DA,DR,DIE S DA=+PSIV,DA(1)=DFN,DIE="^PS(55,"_DFN_",""IV"",",DR=$S(PSIV=P("NEWON"):"113////"_P("OLDON")_";122////R",1:"114////"_P("NEWON")_";123////R") D ^DIE
 D:$P(^PS(55,DFN,"IV",+P("OLDON"),0),U,17)="A" RUPDATE^PSIVOREN(DFN,ON55,P(2))
 S (ON,ON55)=P("NEWON"),PSIVAL="Order created due to Renew.",PSIVREA="R",PSIVALCK="STOP" D LOG^PSIVORAL
 I PSJIVORF D
 . D EN1^PSJHL2(DFN,"XX",+P("PON")_"V","ORDER RENEWED") D UNL^PSSLOCK(DFN,+P("PON")_"V")
 . D EN1^PSJHL2(DFN,"SN",+ON55_"V","ORDER RENEWED")
 . S X=$$LS^PSSLOCK(DFN,+ON55_"V")
 ;S OD=P(2) D EN^PSIVORE,^PSIVORE1
 S OD=P(2) D EN^PSIVORE
 D VF1^PSJLIACT("","",0)
 D ENLBL^PSIVOPT(2,DUZ,DFN,3,+ON55,"R")
 Q
 ;
RD ; Delete for renew.
 ;Q:'$G(PSJVFY)
 D DEL55^PSIVORE2 S (ON55,P("PON"))=P("OLDON") D GT55^PSIVORFB
 Q
 ;
OK ;Print example label, run order through checker, ask if it is ok.
 S P16=0,PSIVEXAM=1,(PSIVNOL,PSIVCT)=1 D GTOT^PSIVUTL(P(4)) I ($G(P("PD"))="") D GTPD^PSIVORE2
 D ^PSIVCHK I $D(DUOUT) S X="^" Q
 I ERR=1 S X="N" Q
 W ! D ^PSIVORLB K PSIVEXAM S Y=P(2) W !,"Start date: " X ^DD("DD") W $P(Y,"@")," ",$P(Y,"@",2),?30," Stop date: " S Y=P(3) X ^DD("DD") W $P(Y,"@")," ",$P(Y,"@",2),!
 W:$G(PSIVCHG) !,"*** This change will cause a new order to be created. ***"
 S X="Is this O.K.: ^"_$S(ERR:"N",1:"Y")_"^^NO"_$S(ERR'=1:",YES",1:"") D ENQ^PSIV I X["?" S HELP="OK" D ^PSIVHLP G OK
 Q
 ;
RI ; Reinstate Auto-DC'ed order.
 N DA,DIE,DIR,DIU,DR,PSIVACT,PSIVALT,PSIVALCK,PSIVREA W !!,$C(7),"This order has been Auto-DC'ed."
 S DIR(0)="Y",DIR("A")="Reinstate this order" D ^DIR K DIR I 'Y S ERR=1 Q
 D NOW^%DTC I %>$P($G(^PS(55,DFN,"IV",+ON55,2)),U,7) D
 .K DIR S ERR=1,DIR(0)="Y",DIR("A",1)="The original stop date of this order has past.",DIR("A")="Do you wish to renew this order" D ^DIR K DIR S ERR=$S(Y:2,1:1)
 Q:$G(ERR)  S X=$G(^VA(200,+P(6),"PS")) I $S('X:1,'$P(X,U,4):0,DT<$P(X,U,4):0,1:1) S ERR=1
 I $G(ERR) W !!,$C(7),"This order's provider is no longer valid. Please enter a valid provider." S (EDIT,PSIVOK)=1 D EDIT^PSIVEDT I $G(DONE) W $C(7),"Order unchanged." S ERR=1 Q
 N PSGALO S PSGALO=18530 D ENARI^PSIVOPT(DFN,ON,DUZ,PSGALO)
 Q
