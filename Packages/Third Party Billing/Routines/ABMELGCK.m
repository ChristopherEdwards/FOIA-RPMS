ABMELGCK ; IHS/SD/SDR - Recreate cancelled claim from PCC ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Allows user to look up eligibility for visit by patient
 ;This runs "eligiblity checker" portion of CG and outputs
 ;ABML array of info found
 ;
START ;EP
 S DIC="^AUPNPAT("
 S DIC(0)="AEMQ"
 S DIC("S")="I $D(^AUPNVSIT(""AC"",Y))"
 D ^DIC
 I Y<0 G Q
 S ABMPDFN=+Y
 S DIC="^AUPNVSIT("
 S DIC(0)="AEQ"
 S DIC("S")="I $D(^AUPNVSIT(""AC"",DFN,Y))&'$P(^AUPNVSIT(Y,0),U,11)"
 D ^DIC
 I Y<0 G Q
 S ABMVDFN=+Y
 S ABMVDT=+$P($G(^AUPNVSIT(ABMVDFN,0)),U)
 S ABML=""
 D ELG^ABMDLCK(ABMVDFN,.ABML,ABMPDFN,ABMVDT)
 ;
 W !!
 W !,"For patient ",$P($G(^DPT(ABMPDFN,0)),U),", for visit ",$$CDT^ABMDUTL($P($G(^AUPNVSIT(ABMVDFN,0)),U)),!
 W "PRIORITY",?9,"INSURER",?37,"STATUS",?50,"REASON UNBILLABLE",!
 F A=1:1:80 W "-"
 W !
 S ABMPRI=0
 K ABME
 F  S ABMPRI=$O(ABML(ABMPRI)) Q:+ABMPRI=0  D
 .S ABMINS=0
 .F  S ABMINS=$O(ABML(ABMPRI,ABMINS)) Q:+ABMINS=0  D
 ..W ?2,ABMPRI
 ..W ?9,$E($P($G(^AUTNINS(ABMINS,0)),U),1,20)_"("_ABMINS_")"
 ..W ?37,$S(+$P(ABML(ABMPRI,ABMINS),U,6):"UNBILLABLE",1:"BILLABLE")
 ..W:$P(ABML(ABMPRI,ABMINS),U,6) ?50,"("_$P(ABML(ABMPRI,ABMINS),U,6)_")",$E($P($G(^ABMDCS($P(ABML(ABMPRI,ABMINS),U,6),0)),U),1,26)
 ..W !
 ..Q:($P(ABML(ABMPRI,ABMINS),U,6)="")
 ..S ABME($P(ABML(ABMPRI,ABMINS),U,6))=""
 W !!
 I $D(ABME) D
 .W ?1,"REASON UNBILLABLE KEY:"
 .S ABMA=0
 .F  S ABMA=$O(ABME(ABMA)) Q:+ABMA=0  D
 ..W !?3,ABMA_" - ",$P($G(^ABMDCS(ABMA,0)),U)
 .W !
 G START
 ;
Q K DIC,DIE,ABMV,DR
 Q
