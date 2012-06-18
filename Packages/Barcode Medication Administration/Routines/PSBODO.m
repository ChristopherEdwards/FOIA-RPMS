PSBODO ;BIRMINGHAM/EFC-BCMA UNIT DOSE VIRTUAL DUE LIST FUNCTIONS ;Mar 2004
 ;;3.0;BAR CODE MED ADMIN;**5,21**;Mar 2004
 ;
 ; Reference/IA
 ; EN^PSJBCMA2/2830
EN ;
 ;
 ; Description:
 ; Returns a display for a selected order when double clicked on the VDL
 ;
 N PSBGBL,DFN
 S PSBGBL=$NAME(^TMP("PSBO",$J,"B"))
 F  S PSBGBL=$Q(@PSBGBL) Q:PSBGBL=""  Q:$QS(PSBGBL,2)'=$J  Q:$QS(PSBGBL,1)'["PSBO"  D
 .S DFN=$QS(PSBGBL,5)
 .D DISPORD
 Q
 ;
DISPORD ;
 N PSBGBL,PSBOI,PSBHDR
 S PSBOI=$$GET1^DIQ(53.69,PSBRPT_",",.09)
 D EN^PSJBCMA2(DFN,PSBOI)
 M PSBOACTL=^TMP("PSJ",$J) K ^TMP("PSJ",$J)
 D CLEAN^PSBVT
 D PSJ1^PSBVT(DFN,PSBOI)
 S PSBHDR(1)="BCMA - Display Order" D PT^PSBOHDR(DFN,.PSBHDR) W !
 I '$G(PSBONX) W !,"Invalid Order"
 D:$G(PSBONX)
 .W !,"Orderable Item: ",PSBOITX
 .I PSBONX["V" W !,"Infusion Rate:  ",PSBIFR
 .I PSBONX'["V" W !,"Dosage Ordered: ",PSBDOSE
 .W ?40,"Start:    ",PSBOSTX
 .W !,"Med Route:      ",PSBMRAB
 .W ?40,"Stop:     ",PSBOSPX
 .W !,"Schedule Type:  ",PSBSCHTX
 .I PSBONX'["V" W ?40,"Self Med: ",PSBSMX
 .W:PSBSM !?40,"Hosp Sup: ",PSBSMX
 .W:PSBSCH'="" !,"Schedule: ",PSBSCH
 .I PSBONX'["V" W !,"Admin Times:    ",PSBADST
 .I PSBONX["V",((PSBIVT="P")!(PSBISYR=1)) W !,"Admin Times:    ",PSBADST
 .W !,"Provider: ",PSBMDX
 .I $E(PSBOTXT,1)="!"  S $E(PSBOTXT,1)=""
 .W !,"Spec Inst:      ",PSBOTXT
 .W !
 .I $D(PSBDDA(1)) D
 ..W !,"Dispense Drugs",!,"Drug Name",?40,"Units",?50,"Inactive Date"
 ..W !,$TR($J("",75)," ","-")
 ..F Y=0:0 S Y=$O(PSBDDA(Y)) Q:'Y  D
 ...S X=$P(PSBDDA(Y),U,4)
 ...W !,$P(PSBDDA(Y),U,3),?40,$S(X]"":X,1:1)
 ...S X=$P(PSBDDA(Y),U,5) Q:'X
 ...W ?50,$E(X,4,5),"/",$E(X,6,7),"/",(1700+$E(X,1,3))
 .I $D(PSBADA(1)) D
 ..W !!,"Additives",!,"Name",?40,"Strength"
 ..W !,$TR($J("",75)," ","-")
 ..F Y=0:0 S Y=$O(PSBADA(Y)) Q:'Y  D
 ...W !,$P(PSBADA(Y),U,3),?40,$P(PSBADA(Y),U,4)
 .I $D(PSBSOLA(1)) D
 ..W !!,"Solution",!,"Name",?40,"Volume"
 ..W !,$TR($J("",75)," ","-")
 ..F Y=0:0 S Y=$O(PSBSOLA(Y)) Q:'Y  D
 ...W !,$P(PSBSOLA(Y),U,3),?40,$P(PSBSOLA(Y),U,4)
 .I $P(PSBOACTL(0),U,1)'=-1 D
 ..W !,$TR($J("",75)," ","-")
 ..W !,"Pharmacy Activity Log: "
 ..F I=1:1:$P(PSBOACTL(0),U,4) D
 ...W !?9,"Date:  ",$$FMTE^XLFDT($P(PSBOACTL(I,1),U,1)),?35,"User:  ",$P(PSBOACTL(I,1),U,2)
 ...W !?5,"Activity:  ",$P(PSBOACTL(I,1),U,4)
 ...I $D(PSBOACTL(I,2)) W !?8,"Field:  ",$P(PSBOACTL(I,1),U,3),!?5,"Old Data:  ",PSBOACTL(I,2)
 ...I $D(PSBOACTL(I,3)) W !?7,"Reason:  ",PSBOACTL(I,3)
 ...W !
 W !!
 D CLEAN^PSBVT K PSBOACTL
 Q
