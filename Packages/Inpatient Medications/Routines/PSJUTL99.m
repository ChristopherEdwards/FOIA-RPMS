PSJUTL99 ;IHS/ITSC/ENM - SPECIAL PATCHES INSTALL [ 11/22/2002  4:06 PM ]
 ;;4.5; Inpatient Medications ;;02/11/2002
EP ;ENTRY POINT
 W !!,"This routine will install all of the portions of various patches",!,"that contained manual installation instructions!",!
 ;
 W !!,?20,">>>>> POST PART 1 <<<<<",!!
 D ^PSJ1INIT ;PSJ*4.5*3
 W !!,?20,">>>>> POST PART 2 <<<<<",!!
 D ^PSJUTL2 ;PSJ*4.5*12
 W !!,?20,">>>>> POST PART 3 <<<<<",!!
 D ^PSJUTL1 ;PSJ*4.5*10
 W !!,?20,">>>>> POST PART 4 <<<<<",!!
 D ^PSJUTL3 ;PSJ*4.5*22
 W !!,?20,">>>>> POST PART 5 <<<<<",!!
 D ^PSJUTL4 ;PSJ*4.5*24
 W !!,?20,">>>>> POST PART 6 <<<<<",!!
 D ^PSJAINIT ;PSJ*4.5*27
 W !!,?20,">>>>> POST PART 7 <<<<<",!!
 D ^PSJUTL5 ;PSJ*4.5*39
 W !!,?20,">>>>> POST PART 8 <<<<<",!!
 D ^PSW1INIT ;AUTO REPLENISHMENT WARD STOCK PATCH #3
 W !!,?20,">>>>> POST PART 9 <<<<<",!!
 D ^PSGWFIX ;AUTO REPLENISHMENT WARD STOCK PATCH #4
 M ^PS(54)=^DIC(54) ;IHS/ITSC/ENM 05/13/02 MOVE RX CONSULT DATA
 S ^DD(55,0,"DIC")="AUPNLK" ;ENM 07/30/02 STUFF NODE FOR SPECIAL LOOKUP
 W !!,?20,">>>>> POST PART 10 <<<<<",!!
 D ^APSP416 ;CHECK 50.416 SUB-FILE NODES FOR MISSING ZERO NODES AND FIX
 W !!,?20,">>>>> POST PART 11 <<<<<",!!
 D ^PSNJP54 ;MANUAL CALL FROM NDF P54
 D ^PSNOP54 ;MANUAL CALL FROM NDF P54
 W !!,"Done with Patch #54 Manual Calls....",!
 ;INPUT OR* PATCHES
 ;D ^PSJUTL3 ;PSJ*4.5*40
EP1 ;EP
 ;S ZZ=$O(^DIC(9.4,"B","NATIONAL DRUG FILE",0))
 ;M ^DIC(9.4,ZZ,22,8,"PAH")=^APSX(9.4,101,22,8,"PAH")
 ;W !,"Application Patch History for Package File entry "_ZZ_" has been loaded!!",!
 ;K ^APSX ;REMOVE THIS GLOBAL AFTERWARDS
 Q
