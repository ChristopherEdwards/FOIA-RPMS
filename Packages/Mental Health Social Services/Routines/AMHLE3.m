AMHLE3 ; IHS/CMI/LAB - DE CONT. ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**1**;JUN 18, 2010;Build 8
 ;
 ;
PHX ;EP
 ;called from DIE
 D EN^XBNEW("EP^AMHLE3","AMHPAT;AUPN*")
 Q
PR ;EP
 Q:'$G(AMHPAT)
 I '$D(^AMHPATR(AMHPAT)) S DIC="^AMHPATR(",DIC(0)="L",DLAYGO=9002011.55,X="`"_AMHPAT D ^DIC D ^XBFMK I Y=-1 W !!,"FAILED TO ADD PATIENT TO BH PATIENT DATA FILE" Q
 S DA=AMHPAT,DDSFILE=9002011.55,DR="[AMH PATIENT RELATED DATA]" D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S AMHQUIT=1 K DIMSG Q
 Q
EP ;EP
 Q:'$G(AMHPAT)
 ;DISPLAY IN DATE ORDER
 ;
 I '$D(^AMHPPHX("AC",AMHPAT)) W !!,"********** No Personal History currently on file for ",$P(^DPT(AMHPAT,0),U),".",!
 S AMHHEAD=" PERSONAL HISTORY FOR "_$P(^DPT(AMHPAT,0),U) D SUBHEAD
 S AMHX=0 F  S AMHX=$O(^AMHPPHX("AC",AMHPAT,AMHX)) Q:AMHX'=+AMHX  D
 .S AMHD=$P(^AMHPPHX(AMHX,0),U,3) D DATE
 .;W !,AMHD,?11,$E($P(^AMHTPHF($P(^AMHPPHX(AMHX,0),U),0),U),1,25)
 .W !,$E($P(^AMHTPHF($P(^AMHPPHX(AMHX,0),U),0),U),1,25)
 .Q
 ;call DIR to get the factor
 K DIR S DIR(0)="9002011.52,.01",DIR("A")="Enter PERSONAL HISTORY" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !!,"Bye..." D EOJ Q
 S AMHPHX=+Y
 I $D(^AMHPPHX("AA",AMHPAT,AMHPHX)) W !!,$P(^AMHTPHF(AMHPHX,0),U)," already recorded for this patient.",!,$C(7),"You may change it or delete it.  To delete an entry, enter an '@'.",! D  D EOJ Q
 .S DIE="^AMHPPHX(",DR=".01",DA=$O(^AMHPPHX("AA",AMHPAT,AMHPHX,0))
 .L +^AMHPPHX(DA,0):10 E  W !!,"Can't lock global entry." Q
 .D ^DIE
 .L -^AMHPPHX:10
 .K DIE,DA,DR
 S DIC(0)="L",DIC="^AMHPPHX(",DLAYGO=9002011.52,DIADD=1,X="`"_AMHPHX K DD S DIC("DR")=".02////^S X=AMHPAT;.03////"_$S($G(AMHDATE)]"":$P(AMHDATE,"."),1:DT) D ^DIC
 I Y=-1 W !!,"Adding Personal History of ",$P(^AMHPPHX(AMHPHX,0),U)," failed.",!
 K Y
 D EOJ
 Q
DATE ;
 S AMHD=$E(AMHD,4,5)_"/"_$E(AMHD,6,7)_"/"_$E(AMHD,2,3)
 Q
 ;
PEF ;EP - called from AMHLEA - other
 S AMHR=%,AMHPAT=%1
 K AMHEFT
 ;W !! S DIR(0)="S^F:Full Encounter Form;S:Suppressed Encounter Form;B:Both a Suppressed & Full;T:2 copies of the Suppressed;E:2 copies of the Full"
 ;S DIR("A")="What type of form do you want to print"
 ;S DIR("B")=$S($P(^AMHSITE(DUZ(2),0),U,23)]"":$P(^AMHSITE(DUZ(2),0),U,23),1:"B") K DA D ^DIR K DIR
 D FORMDIR^AMHLEFP(AMHR)
 Q:$D(DIRUT)
 S AMHEFT=Y
 S AMHACTN=5
 S XBRC="COMP^AMHLEFP",XBRP="^AMHLEFP2",XBNS="AMH",XBRX="XIT^AMHLEFP"
 D ^XBDBQUE
 K %,%1
 Q
EOJ ;EOJ CLEANUP
 K DIADD,DLAYGO
 D ^XBFMK
 K AMHS,AMHX,AMHD,AMHHEAD,AMHPHX
 Q
SUBHEAD ;
 NEW L
 S AMHS="",L=(80-$L(AMHHEAD))/2,$P(AMHS,"*",L)="*"
 W !!,AMHS,AMHHEAD,AMHS
 Q
