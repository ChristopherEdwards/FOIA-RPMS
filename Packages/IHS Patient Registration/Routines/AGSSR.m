AGSSR ; IHS/ASDS/EFG - MASTER PRINTER routine ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 ;the array AGSSP(report #)=type controlls the prints
S Q:'$D(AGSSP)
 D NOW^%DTC S AGSS("JOBID")=%
 N AGTMPK
 F AGTMPK="^AGSTEMP" D
 . I $$KILLOK^ZIBGCHAR($P(AGTMPK,U,2)) W !,$$ERR^ZIBGCHAR($$KILLOK^ZIBGCHAR($P(AGTMPK,U,2)))_"  "_AGTMPK Q
 . K @AGTMPK ;kill off earlier temp global reports if there
 D ^AGSSRV,^AGSSRA,^AGSSRD,^AGSSRN,^AGSSRP ;set up print globals for all reports
 Q
PRINT ;EP - PRINT
 S AGSSPG=1,AGSSHDR="SSN Summary" D AGSSHDR^AGSSPRT
 U IO W !,"Patients :",?40,"Number",?50,"Report",!
 F AGSSFLAG="V","A","D","N","P" S AGSSROU="PRINT^AGSSR"_AGSSFLAG I $D(AGSSP(AGSSFLAG)) W !,$P($T(@AGSSFLAG),";;",2),?40,$J($G(^AGSSTEMP(AGSSITE,"TOT","R"_AGSSFLAG)),7),?50,$S(AGSSP(AGSSFLAG)="C":"Complete",1:"Statistics")
 W !! I "C"=$E(IOST) K DIR S DIR(0)="E" D ^DIR
 ;loop through all printing routines
 F AGSSFLAG="V","A","D","N","P","X" S AGSSROU="PRINT^AGSSR"_AGSSFLAG I $G(AGSSP(AGSSFLAG))="C" D @AGSSROU I "C"=$E(IOST) W !!! I '($G(DUOUT)!$G(DFOUT)!$G(DIRUT)!$G(DTOUT)) K DIR S DIR(0)="E" D ^DIR
 I "C"=$E(IOST) W !!!,*7,?20,">>>>>     REPORTS COMPLETED    <<<<<" K DIR S DIR(0)="E" D ^DIR
 Q
V ;;'V' Verified
A ;;'A' Added
P ;;'P' Potential / Pending
D ;;'D' Data Differs but SSNs Match
N ;;'N' SSNs Differ but Data Matches
X ;;'X' SSA could not process
