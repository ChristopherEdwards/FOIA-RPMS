MASSETUQ ;IHS/ADC/PDW/ENM subroutines for MAS Installation [ 03/25/1999  11:38 AM ]
 ;;5.0;MAS INSTALLATION
 ;; This routine carries components cut out of MASSETUP to comply
 ;; with routine size standards.
DGPM5P1 ;EP
 ;
 S MAS1="MAS_INSTAL",MASI=7,MAS2="D ^DGPM5 part 1",MAS3="DGPM5P1"
 S ^XTMP(MAS1,MASI,MAS2,MAS3)=0
 K DIR S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit" D ^DIR I Y'=1 G EXIT ;====>>
 W @IOF,?10,MAS2
 W !,"Ready to run ^DGPM5 part 1 .."
 K DIR S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit" D ^DIR I Y'=1 G EXIT ;====>>
 D ^DGPM5
 K DIR S DIR(0)="Y",DIR("A")="Did DGMP5 part 1 complete properly ",DIR("B")="YES" D ^DIR
 I Y'=1 W !,"Exiting ..." G EXIT
 S ^XTMP(MAS1,MASI)=1
 ;
DGPM5P2 ;EP
 ;
 S MAS1="MAS_INSTAL",MASI=8,MAS2="D ^DGPM5 part 2",MAS3="DGPM5P2"
 S ^XTMP(MAS1,MASI,MAS2,MAS3)=0
 W @IOF,?10,MAS2
 W !,"Ready to run ^DGPM5 part 2 .."
 K DIR S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit" D ^DIR I Y'=1 G EXIT ;====>>
 D ^DGPM5
 K DIR S DIR(0)="Y",DIR("A")="Did DGMP5 part 2 complete properly ",DIR("B")="YES" D ^DIR
 I Y'=1 W !,"Exiting ..." G EXIT
 S ^XTMP(MAS1,MASI)=1
 K DIR S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit" D ^DIR I Y'=1 G EXIT ;====>>
 ;
DELINI ;EP delete routines
 S MAS1="MAS_INSTAL",MASI=9,MAS2="Delete Inits",MAS3="DELINI"
 S ^XTMP(MAS1,MASI,MAS2,MAS3)=0
 W @IOF,?10,MAS2
 W !,"Ready to Delete Inits .."
 K DIR S DIR(0)="E",DIR("A")="<CR> to Continue ""^"" to Exit" D ^DIR I Y'=1 G EXIT ;====>>
 K DIR
 K ^XTMP("ZIBRSEL",$J)
 S Z=$$RSEL^ZIBRSEL("DGINI-DGINIZZ") D DEL
 S Z=$$RSEL^ZIBRSEL("DGONI-DGONIZZ") D DEL
 S Z=$$RSEL^ZIBRSEL("DG5INI-DG5INIZZ") D DEL
 S Z=$$RSEL^ZIBRSEL("DGYP-DGYPZZZ") D DEL
 S Z=$$RSEL^ZIBRSEL("SDINI-SDINIZZZ") D DEL
 S Z=$$RSEL^ZIBRSEL("SDONI-SDONIZZZ") D DEL
 S Z=$$RSEL^ZIBRSEL("ORINI-ORINIZZZ") D DEL
 S Z=$$RSEL^ZIBRSEL("DPTIN-DPTINZZZ") D DEL
 K ^XTMP("ZIBRSEL",$J)
 K DIR S DIR(0)="Y",DIR("A")="Did the deletion of the inits complete properly ",DIR("B")="YES" D ^DIR
 S ^XTMP(MAS1,MASI)=1
 ;
 G FINISH^MASSETUP ;===>>>
 ;
DEL ;;EP 
 D DEL^MASSETUP
 Q
EXIT ;EP
 G EXIT^MASSETUP
