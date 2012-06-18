SROCODE ;B'HAM ISC/MAM - SET UP FLAG FOR ANESTHESIA AGENTS ; [ 05/06/98   7:14 AM ]
 ;;3.0; Surgery ;**72,41,114**;24 Jun 93
 ;
 ; Reference to ENS^PSSGIU supported by DBIA #895
 ;
1 W !! K DIR S DIR(0)="P^50:QEAM",DIR("A")="Enter the name of the drug you wish to flag" D ^DIR G:Y<1 DONE S SROIUDA=+Y,SROIRX=$P(Y,"^",2),SROIUX="S^SURGERY" D SROIU
 G 1
SROIU Q:'$D(SROIUDA)!'$D(SROIUX)  Q:SROIUX'?1E1"^"1.E  S SROIUY=$S($D(^PSDRUG(SROIUDA,2)):$P(^(2),"^",3),1:""),SROIUT=$P(SROIUX,"^",2),SROIUT=$E("N","AEIOU"[$E(SROIUT))_" "_SROIUT
 I SROIUY["S" W !!,"This drug is already flagged for SURGERY." K DIR S DIR("A")="Do you want to remove the flag (Y/N)",DIR(0)="Y" D ^DIR D:Y OFF D DONE Q
 W !! K DIR S DIR("A")="Do you want to flag this drug for SURGERY (Y/N)",DIR(0)="Y" D ^DIR D:Y FLAG
DONE W @IOF K SROIRX D ^SRSKILL
 Q
FLAG S PSIUDA=SROIUDA,PSIUX=SROIUX_"^1"
 S X="PSSGIU" X ^%ZOSF("TEST") I $T D ENS^PSSGIU
 ;HL7 master file update (addition) to anesthesia agent list
 N SRTBL,SRENT,FEC,REC S SRTBL="ANESTHESIA AGENT^50^.01",FEC="UPD",REC="MAD",SRENT=SROIUDA_U_SROIRX D MSG^SRHLMFN(SRTBL,FEC,REC,SRENT)
 ;A call to PDM to possibly generate an HL7 outgoing drug message
 S X="PSSHUIDG" X ^%ZOSF("TEST") I $T D DRG^PSSHUIDG(PSIUDA)
 K PSIUDA,PSIUX
 Q
OFF S PSIUDA=SROIUDA,PSIUX=SROIUX_"^1"
 S X="PSSGIU" X ^%ZOSF("TEST") I $T D END^PSSGIU
 ;HL7 master file update (deletion) to anesthesia agent list
 N SRTBL,SRENT,FEC,REC S SRTBL="ANESTHESIA AGENT^50^.01",FEC="UPD",REC="MDL",SRENT=SROIUDA_U_$P(^PSDRUG(SROIUDA,0),U) D MSG^SRHLMFN(SRTBL,FEC,REC,SRENT)
 ;A call to PDM to possibly generate an HL7 outgoing drug message
 S X="PSSHUIDG" X ^%ZOSF("TEST") I $T D DRG^PSSHUIDG(PSIUDA)
 K PSIUDA,PSIUX
 Q
