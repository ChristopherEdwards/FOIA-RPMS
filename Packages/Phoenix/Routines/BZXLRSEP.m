BZXLRSEP ;IHS/PIMC/JLG - AZ HEALTH DEPT REPORT [ 08/13/2002  3:03 PM ]
 ;;1.0;Special local routine for printing reportable disesases
 ;Original WRITTEN BY DAN WALZ CALLED BY DWLRSER1
PREPORT I '$D(^TMP($J)) W @IOF,"NO DATA TO REPORT" Q
 S PEDT=$E(BZXENDT,4,5)_"/"_$E(BZXENDT,6,7)_"/"_$E(BZXENDT,2,3)
 S PSDT=$E(BZXSDT,4,5)_"/"_$E(BZXSDT,6,7)_"/"_$E(BZXSDT,2,3)
 S FOOTFLG=0,PG=1
 S BZXTP=0
 F  S BZXTP=$O(^TMP($J,BZXTP)) Q:'BZXTP  D
 .S IENS=BZXTP_","
 .S BZXTST=$$GET1^DIQ(1966360,IENS,2)
 .I FOOTFLG=1 D FOOTER
 .W @IOF
 .D RHEAD
 .S LRDFN=""
 .F  S LRDFN=$O(^TMP($J,BZXTP,LRDFN)) Q:'LRDFN  D
 ..S LRIDT=""
 ..F  S LRIDT=$O(^TMP($J,BZXTP,LRDFN,LRIDT)) Q:'LRIDT  D PRTIT 
 D FOOTER W @IOF
 Q
 ;
RLOOP1 D:FOOTFLG=1 FOOTER
 W @IOF D RHEAD W !,"Reporting Test: "_DWBUG,!
 S RPNM="" F II=0:0 S RPNM=$O(^UTILITY("CH",$J,DWBUG,RPNM))  Q:RPNM=""  D RLOOP2
 Q
RLOOP2 S RACC="" F III=0:0 S RACC=$O(^UTILITY("CH",$J,DWBUG,RPNM,RACC))  Q:RACC=""  D PRTIT
 Q
 ;
PRTIT ; Print
 S Y=^TMP($J,BZXTP,LRDFN,LRIDT)
 S Y1=^LR(LRDFN,"CH",LRIDT,0)
 W !!,$E($P(Y,U,1),1,28) ;PATIENT NAME
 W ?30,$P(Y,U,2) ;HRN
 W ?40,$P(Y,U,3) ;DOB
 W ?54,$E($P(Y,U,4),1,1) ;SEX
 W ?58,$P(Y1,U,6) ;ACCN
 S IENS=LRIDT_","_LRDFN_","
 S SPEC=$$GET1^DIQ(63.04,IENS,.05)
 W ?74,$E(SPEC,1,12) ;SPEC
 S COLDT=$P(Y1,U,1)
 W ?88,$E(COLDT,4,5)_"/"_$E(COLDT,6,7)_"/"_$E(COLDT,2,3) ;COL DT
 S VERDT=$P(Y1,U,3)
 W ?98,$E(VERDT,4,5)_"/"_$E(VERDT,6,7)_"/"_$E(VERDT,2,3) ;verify or complete date
 S PROV=$$GET1^DIQ(63.04,IENS,.1)
 W ?108,$E(PROV,1,23) ;PROV
 W !,?5,$P(Y,U,5) ;PHONE
 W ?30,$P(Y,U,6) ;STREET
 W ?64,$P(Y,U,7) ;CITY
 W ?84,$P(Y,U,8) ;STATE
 W ?98,$P(Y,U,9) ;ZIP
 W ?108,$E($P(Y1,U,11),1,23) ;LOC
 W !,?5,"Result: ",$P(Y,U,11)
 ;
 ; start - vjm 4/14/2000
 ;W !?5,"Current COMMUNITY:  ",$G(BZXXCOMM)
 W !?5,"Current COMMUNITY:  "
 W $P(Y,U,10) ;CURRENT COMMUNITY
 ; end - vjm 4/14/2000
 ;
 I $Y>50 D FOOTER W @IOF D RHEAD
 Q
 ;
RHEAD W "AZ HEALTH DEPARTMENT REPORT",?51,"Phoenix Indian Medical Center",!,?46,"4212 N. 16th St., Phoenix, AZ  85016",!,"From "_PSDT_" to "_PEDT,?53,"****** CONFIDENTIAL ******",?98,"Printed: "_$E(DT,4,5)_"/"_$E(DT,6,7)_"/"_$E(DT,2,3),?120,"Page: "_PG,!
 W !,"Name",?30,"ID#",?40,"DOB",?54,"Sex",?58,"Lab #",?74,"Sample",?88,"Col Dt",?98,"Cpl Dt",?108,"Provider",!,?5,"Phone #",?30,"Address",?108,"Location"
 ;
 ; start - vjm 4/14/2000
 W:$G(BZXGR) !?5,"Current Community"
 ; end - vjm 4/14/2000
 ;
 S M=$S($G(IOM):IOM,1:132)
 W ! F LI=0:1:M-1 W ?LI,"-"
 W ! S PG=PG+1,FOOTFLG=1
 W !,"Reporting Test: "_BZXTST
 Q
 ;
FOOTER S PLG=56-$Y F PP=1:1:PLG W !
 W "________________________________________            _______________"
 W !,"  Medical Technologist                                   Date"
 Q
