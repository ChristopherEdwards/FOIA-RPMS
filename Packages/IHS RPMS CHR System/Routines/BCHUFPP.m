BCHUFPP ; IHS/TUCSON/LAB - PRINT CHR FORMS ;  [ 05/06/04  12:13 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**2,8,10,16**;OCT 28, 1996
 ;IHS/CMI/LAB - patch 8 Y2K
 ;
 ;IHS/TUCSON/LAB  - patch 1 06/03/97 - modified so subj/obj data
 ;would display.
 ;
PRINT1 ;EP - CALLED FROM LAST VISIT DISPLAY
 S BCHR0=^BCHR(BCHR,0)
 S BCHQUIT=0
 I $E(IOST)="C" W:$D(IOF) @IOF
 W !!!?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !?34,"CHR PCC FORM"
 W !?18,"***  Computer Generated Encounter Record  ***"
 W !,$TR($J("",80)," ","*")
 I $Y>(IOSL-6) D FF Q:BCHQUIT
 W !?3,"Date of Service:  " S Y=$P($P(BCHR0,U),".") D DD^%DT W Y
 W !?3,"Temporary Residence:  ",$P($G(^BCHR(BCHR,11)),U,8),!?35,"Program Code:  ",$P(^BCHTPROG($P(BCHR0,U,2),0),U,5)
 W !?35,"Provider (CHR): ",$$PPNAME^BCHUTIL(BCHR)
 W !,$TR($J("",80)," ","_")
SUB ;
 ;IHS/TUCSON/LAB - modified to display subjective info patch 1 06/03/97
 S BCHR12=$G(^BCHR(BCHR,12))
 S BCHR13=$G(^BCHR(BCHR,13))
 I $Y>(IOSL-5) D FF Q:BCHQUIT
 W !?3,"SUBJECTIVE INFORMATION (includes patient's complaint)",?65,"TEMP  ",$P(BCHR12,U,7)
 S BCHDA=BCHR,BCHFILE=90002,BCHNODE=51,BCHIOM=58 D WP
 S BCHWP(1)=$G(BCHWP(1)),$E(BCHWP(1),62)="PULSE "_$P(BCHR12,U,8)
 S BCHWP(2)=$G(BCHWP(2)),$E(BCHWP(2),62)="RESP  "_$P(BCHR12,U,9)
 S BCHWP(3)=$G(BCHWP(3)),$E(BCHWP(3),62)="BP    "_$P(BCHR12,U,1)
 S BCHWP(4)=$G(BCHWP(4)),$E(BCHWP(4),62)="WT    "_$P(BCHR12,U,2)
 S BCHWP(5)=$G(BCHWP(5)),$E(BCHWP(5),62)="HT    "_$P(BCHR12,U,3)
 S BCHX1=0 F  S BCHX1=$O(BCHWP(BCHX1)) Q:BCHX1'=+BCHX1!(BCHQUIT)  D
 .I $Y>(IOSL-4) D FF Q:BCHQUIT
 .W !?4,BCHWP(BCHX1)
 .Q
 I $Y>(IOSL-7) D FF Q:BCHQUIT
OBJ ;
 ;IHS/TUCSON/LAB - modified to display objective info patch 1 06/03/97
 W !,$TR($J("",80)," ","_")
 W !?3,"OBJECTIVE DATA",?65,"HEAD  ",$P(BCHR12,U,4)
 S BCHDA=BCHR,BCHFILE=90002,BCHNODE=61,BCHIOM=58 D WP
 S BCHWP(1)=$G(BCHWP(1)),$E(BCHWP(1),62)="BMI   "_$P(BCHR12,U,12)
 S BCHWP(2)=$G(BCHWP(2)),$E(BCHWP(2),62)="WAIST "_$P(BCHR12,U,11)
 S BCHWP(3)=$G(BCHWP(3)),$E(BCHWP(3),62)="VU    "_$P(BCHR12,U,5)
 S BCHWP(4)=$G(BCHWP(4)),$E(BCHWP(4),62)="VC    "_$P(BCHR12,U,6)
 S BCHX1=0 F  S BCHX1=$O(BCHWP(BCHX1)) Q:BCHX1'=+BCHX1!(BCHQUIT)  D
 .I $Y>(IOSL-4) D FF Q:BCHQUIT
 .W !?4,BCHWP(BCHX1)
 .Q
 W !,$TR($J("",80)," ","_")
POV ;
 I $Y>(IOSL-6) D FF Q:BCHQUIT
 W !?3,"ASSESSMENT - PCC Purpose of Visit"
 W !?3,"Hlth Prob",?13,"Svc",?18,"Svc",?30,"Narrative",?60,"Sub"
 W !?5,"Code",?13,"Code",?18,"Mins",?60,"Rel",?65,"Tests"
 W !,$TR($J("",80)," ","_")
 S (BCHX,BCHC)=0 F  S BCHX=$O(^BCHRPROB("AD",BCHR,BCHX)) Q:BCHX'=+BCHX!(BCHQUIT)  S BCHC=BCHC+1 D
 .I $Y>(IOSL-5) D FF Q:BCHQUIT
 .S BCHRNODE=^BCHRPROB(BCHX,0)
 .W !?6,$P(^BCHTPROB($P(BCHRNODE,U),0),U,2)
 .W ?14,$S($P(BCHRNODE,U,4)]"":$P(^BCHTSERV($P(BCHRNODE,U,4),0),U,3),1:"??")
 .W ?19,$P(^BCHRPROB(BCHX,0),U,5)
 .S BCHTNRQ=$P(^BCHRPROB(BCHX,0),U,6) S BCHTNRQ=$S(BCHTNRQ]"":$P(^AUTNPOV(BCHTNRQ,0),U),1:"<<none>>") S BCHW=35 D WRT ;IHS/TUCSON/LAB - patch 2
 .W ?23,BCHRPRNM(1),?61,$P(BCHRNODE,U,7) W:BCHC=1 ?65,"PPD  ",$P(BCHR12,U,10)
 .;begin Y2K
 .;W ! W:$D(BCHRPRNM(2)) ?23,BCHRPRNM(2) W:BCHC=1 ?65,"BS   ",$S($P(BCHR13,U,2)]"":$P(BCHR13,U,2),$P(BCHR13,U)]"":$E($P(BCHR13,U),4,5)_"/"_$E($P(BCHR13,U),6,7)_"/"_$E($P(BCHR13,U),2,3),1:"") ;Y2000
 .W ! W:$D(BCHRPRNM(2)) ?23,BCHRPRNM(2) W:BCHC=1 ?65,"BS   ",$S($P(BCHR13,U,2)]"":$P(BCHR13,U,2),$P(BCHR13,U)]"":$E($P(BCHR13,U),4,5)_"/"_$E($P(BCHR13,U),6,7)_"/"_(1700+($E($P(BCHR13,U),1,3))),1:"") ;Y2000
 .;W ! W:$D(BCHRPRNM(3)) ?23,BCHRPRNM(3) W:BCHC=1 ?65,"T/C   ",$S($P(BCHR13,U,4)]"":$P(BCHR13,U,4),$P(BCHR13,U,3)]"":$E($P(BCHR13,U,3),4,5)_"/"_$E($P(BCHR13,U,3),6,7)_"/"_$E($P(BCHR13,U,3),2,3),1:"") ;Y2000
 .W ! W:$D(BCHRPRNM(3)) ?23,BCHRPRNM(3) W:BCHC=1 ?65,"T/C  ",$S($P(BCHR13,U,4)]"":$P(BCHR13,U,4),$P(BCHR13,U,3)]"":$E($P(BCHR13,U,3),4,5)_"/"_$E($P(BCHR13,U,3),6,7)_"/"_(1700+($E($P(BCHR13,U,3),1,3))),1:"") ;Y2000
 .W ! W:$D(BCHRPRNM(4)) ?23,BCHRPRNM(4) W:BCHC=1 ?58,"Hemoglobin A1c  ",$S($P(BCHR13,U,9)]"":$P(BCHR13,U,9),1:"")
 .;end Y2K
 .Q
 S BCHX1=3 F  S BCHX1=$O(BCHRPRNM(BCHX1)) Q:BCHX1'=+BCHX1!(BCHQUIT)  D:$Y>(IOSL-4) FF Q:BCHQUIT  W !?23,BCHRPRNM(BCHX1)
 K BCHRPRNM,BCHX1
 Q:BCHQUIT
PLANS ;
 ;IHS/TUCSON/LAB - modified to display plan info patch 1 06/03/97
 I $Y>(IOSL-7) D FF Q:BCHQUIT
 W !,$TR($J("",80)," ","_")
 W !?3,"Plans/Treatments/Education/Medications"
 ;begin Y2K
 ;W ?65,"HCT  ",$S($P(BCHR13,U,8)]"":$P(BCHR13,U,8),$P(BCHR13,U,7)]"":$E($P(BCHR13,U,7),4,5)_"/"_$E($P(BCHR13,U,7),6,7)_"/"_$E($P(BCHR13,U,7),2,3),1:"") ;Y2000
 W ?65,"HCT  ",$S($P(BCHR13,U,8)]"":$P(BCHR13,U,8),$P(BCHR13,U,7)]"":$E($P(BCHR13,U,7),4,5)_"/"_$E($P(BCHR13,U,7),6,7)_"/"_(1700+($E($P(BCHR13,U,7),1,3))),1:"") ;Y2000
 ;end Y2K
 S BCHDA=BCHR,BCHFILE=90002,BCHNODE=71,BCHIOM=52 D WP
 ;W !?65,"UA   ",$S($P(BCHR13,U,8)]"":$P(BCHR13,U,8),$P(BCHR13,U,7)]"":$E($P(BCHR13,U,7),4,5)_"/"_$E($P(BCHR13,U,7),6,7)_"/"_$E($P(BCHR13,U,7),2,3),1:"")
 ;begin Y2K
 ;S BCHWP(1)=$G(BCHWP(1)),$E(BCHWP(1),62)="UA   "_$S($P(BCHR13,U,6)]"":$P(BCHR13,U,6),$P(BCHR13,U,5)]"":$E($P(BCHR13,U,5),4,5)_"/"_$E($P(BCHR13,U,5),6,7)_"/"_$E($P(BCHR13,U,5),2,3),1:"") ;Y2000
 S BCHWP(1)=$G(BCHWP(1)),$E(BCHWP(1),62)="UA   "_$S($P(BCHR13,U,6)]"":$P(BCHR13,U,6),$P(BCHR13,U,5)]"":$E($P(BCHR13,U,5),4,5)_"/"_$E($P(BCHR13,U,5),6,7)_"/"_(1700+($E($P(BCHR13,U,5),1,3))),1:"")
 ;end Y2K
 S BCHWP(2)=$G(BCHWP(2)),$E(BCHWP(2),55)="Reproductive Factors"
 ;begin Y2K
 ;S BCHWP(3)=$G(BCHWP(3)),$E(BCHWP(3),55)="LMP  " S:$P(BCHR0,U,13)]"" BCHWP(3)=BCHWP(3)_$E($P(BCHR0,U,13),4,5)_"/"_$E($P(BCHR0,U,13),6,7)_"/"_$E($P(BCHR0,U,13),2,3) ;Y2000
 S BCHWP(3)=$G(BCHWP(3)),$E(BCHWP(3),55)="LMP  " S:$P(BCHR0,U,13)]"" BCHWP(3)=BCHWP(3)_$E($P(BCHR0,U,13),4,5)_"/"_$E($P(BCHR0,U,13),6,7)_"/"_(1700+($E($P(BCHR0,U,13),1,3))) ;Y2000
 ;end Y2K
 S BCHWP(4)=$G(BCHWP(4)),$E(BCHWP(4),55)="FP   "_$S($P(BCHR0,U,14)]"":$P(^BCHTFPM($P(BCHR0,U,14),0),U),1:"")
 S BCHX1=0 F  S BCHX1=$O(BCHWP(BCHX1)) Q:BCHX1'=+BCHX1!(BCHQUIT)  D
 .I $Y>(IOSL-4) D FF Q:BCHQUIT
 .W !?4,BCHWP(BCHX1)
 .Q
 I $Y>(IOSL-3) D FF Q:BCHQUIT
 W !?3,"Education Topics recorded"
 S BCHX=0 F  S BCHX=$O(^BCHRPED("AD",BCHR,BCHX)) Q:BCHX'=+BCHX  D
 .W !?3,$E($$VAL^XBDIQ1(90002.02,BCHX,.01),1,38),?40,$E($$VAL^XBDIQ1(90002.02,BCHX,.06),1,10),?51,$E($$VAL^XBDIQ1(90002.02,BCHX,.07),1,10),?62,$$VAL^XBDIQ1(90002.02,BCHX,.08)_" MIN",?69,"OBJ: ",$$VAL^XBDIQ1(90002.02,BCHX,.14)
 W !,$TR($J("",80)," ","_")
ACT ;
 I $Y>(IOSL-5) D FF Q:BCHQUIT
 W !?3,"Activity Location:  ",$S($P(BCHR0,U,6)]"":$P(^BCHTACTL($P(BCHR0,U,6),0),U),1:"") I $P(BCHR0,U,5)]"" W ?40,"Hospital/Clinic: ",$E($P(^DIC(4,$P(BCHR0,U,5),0),U),1,22)
 W !?3,"Referred to CHR by:  ",$S($P(BCHR0,U,7)]"":$E($P(^BCHTREF($P(BCHR0,U,7),0),U),1,15),1:""),?45,"Referred by CHR to: ",$S($P(BCHR0,U,8)]"":$E($P(^BCHTREF($P(BCHR0,U,8),0),U),1,15),1:"")
 W !?3,"Evaluation:  ",$S($P(BCHR0,U,9)]"":$$EXTSET^XBFUNC(90002,.09,$P(BCHR0,U,9)),1:"")
 W !?3,"Travel Time:  ",$P(BCHR0,U,11),?45,"Number Served:  ",$P(BCHR0,U,12)
 W !,$TR($J("",80)," ","_")
DEMO ;demographics
 D DEMO^BCHUFP
 Q
WRT ;EP - Entry point to print wp fields pass node in BCHNODE
 K ^UTILITY($J,"W"),BCHRPRNM
 S BCHPCNT=0
 S DIWL=1,DIWR=35,X=BCHTNRQ D ^DIWP
 S Z=0 F  S Z=$O(^UTILITY($J,"W",DIWL,Z)) Q:Z'=+Z  S BCHPCNT=BCHPCNT+1,BCHRPRNM(BCHPCNT)=^UTILITY($J,"W",DIWL,Z,0)
 K DIWL,DIWR,DIWF,Z
 K ^UTILITY($J,"W"),BCHNODE,BCHFILE,BCHDA
 Q
FF ;EP
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BCHQUIT=1 Q
 W:$D(IOF) @IOF
 Q
WP ;EP - Entry point to print wp fields pass node in BCHWP
 ;PASS FILE IN BCHFILE, ENTRY IN BCHDA
 NEW G,P,BCHX
 K BCHWP
 K ^UTILITY($J,"W")
 S BCHX=0,P=0
 S G=$S($G(G)]"":G,1:^DIC(BCHFILE,0,"GL")),G=G_BCHDA_","_BCHNODE_",BCHX)"
 S DIWR=$S($G(BCHIOM):BCHIOM,1:IOM),DIWL=0 F  S BCHX=$O(@G) Q:BCHX'=+BCHX  D
 .S Y=$P(G,")")_",0)"
 .S X="" I $G(BCHCAP)]"",BCHX=1 S X=BCHCAP
 .S X=X_@Y D ^DIWP
 .Q
WPS ;EP
 S Z=0 F  S Z=$O(^UTILITY($J,"W",DIWL,Z)) Q:Z'=+Z  S P=P+1,BCHWP(P)=^UTILITY($J,"W",DIWL,Z,0)
 K DIWL,DIWR,DIWF,Z
 K ^UTILITY($J,"W"),BCHNODE,BCHFILE,BCHDA,G,BCHCOL,BCHCAP
 Q
