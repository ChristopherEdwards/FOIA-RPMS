AGED7B ; IHS/ASDS/TPF - EDIT/DISPLAY PRIVATE PAGE B SCREEN ;    
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
EN ;
 N INSPTR,POLHPTR
 S AGSELECT=$G(AGINSREC)
VAR D DRAW
 I $D(AGSEENLY) K DIR S DIR(0)="E",DIR("A")="Enter Response" D ^DIR Q
 Q:$D(AGSEENLY)
 W !,AGLINE("EQ")
 I $G(NOPVTB) D  Q
 .K DIR
 .S DIR(0)="E"
 .S DIR("A")="Press RETURN to cont"
 .D ^DIR
 K DIR
 S DIR("A")="CHANGE which item? (1-"_AG("N")_") NONE// "
 D READ^AGED1
 G END:Y=$G(AGOPT("ESCAPE"))
 G:$D(AG("ED"))&'$D(AGXTERN) @("^AGED"_AG("ED"))
 G END:$D(DLOUT)!(Y["N")!$D(DUOUT),VAR:$D(AG("ERR"))
 Q:$D(DFOUT)!$D(DTOUT)
 I +Y>0,(+Y<AG("N")+1),$D(AG("PLANEXP")),AG("PLANEXP")<DT D  G VAR
 . W !!,"This plan has expired. You may not edit it." H 2
 I $D(DQOUT)!(+Y<1)!(+Y>AG("N")) W !!,"You must enter a number from 1 to ",AG("N") H 2 G VAR
 S AGY=Y
 F AGI=1:1 S AG("SEL")=+$P(AGY,",",AGI) Q:AG("SEL")<1!(AG("SEL")>AG("N"))  D @($P(AG("C"),",",AG("SEL")))
 ;AFTER EDITING THE SELECTION MUST BE UPDATED SO ANY ERRORS CORRECTED WILL BE REFLECTED ON THE REDRAWN SCREEN
 S:$G(AGSELECT)'="" AGSELECT=$$FINDPVT^AGINSUPD(AGSELECT)
 D UPDATE1^AGED(DUZ(2),DFN,3,"")
 K AGI,AGY
 G VAR
 ;CLEAN UP THE VARIBALES USED
END K AG,DA,DIC,DR,AGSCRN,COVREC
 K ROUTID
 Q:$D(AGXTERN)
 Q:$D(DIROUT)
 Q:$D(AGSEENLY)
 Q:$D(DUOUT)
 Q
DRAW ;EP
 D HDR
 D GETAW
 Q
HDR ;
 S AGPAT=$P(^DPT(DFN,0),U)
 S AGCHRT=$S($D(^AUPNPAT(DFN,41,DUZ(2),0)):$P(^AUPNPAT(DFN,41,DUZ(2),0),U,2),1:"xxxxx")
 S AG("AUPN")=""
 S:$D(^AUPNPAT(DFN,0)) AG("AUPN")=^(0)
 S AGLINE("-")=$TR($J(" ",78)," ","-")
 S AGLINE("EQ")=$TR($J(" ",78)," ","=")
 S $P(AGLINE("PGLN"),"=",81)=""
 W $$S^AGVDF("IOF"),!
 S AG("PG")="4PVTB"
 S ROUTID=$P($T(+1)," ")  ;SET ROUTINE ID FOR PROGRAMMER VIEW
 D PROGVIEW^AGUTILS(DUZ)
 W "IHS REGISTRATION ",$S($D(AGSEENLY):"VIEW SCREEN",1:"EDITOR")
 W ?31,"PRIVATE INSURANCE B"
 W ?80-$L($P(^DIC(4,DUZ(2),0),U)),$P(^DIC(4,DUZ(2),0),U)
 S AGLINE("-")=$TR($J(" ",80)," ","-")
 S AGLINE("EQ")=$TR($J(" ",80)," ","=")
 W !,AGLINE("EQ")
 W !,$E(AGPAT,1,23)
 W ?23,$$DTEST^AGUTILS(DFN)
 I $D(AGCHRT) W ?42,"HRN#:",AGCHRT
 ;GET ELIGIBILITY STATUS
 S AGELSTS=$P($G(^AUPNPAT(DFN,11)),U,12)
 W ?56,"(",$S(AGELSTS="C":"CHS & DIRECT",AGELSTS="I":"INELIGIBLE",AGELSTS="D":"DIRECT ONLY",AGELSTS="P":"PENDING VERIFICATION",1:"NONE"),")"
 W !,AGLINE("EQ")
 S DA=DFN
 K AG("EDIT")
 Q
GETAW ;DISPLAY
 S POLHPTR=$E($P($G(AGINSREC),U,7),2,10)
 S COVPTR=$P($G(AGINSREC),U,3)
 I COVPTR="" S NOPVTB=1 W !!,"NO COVERAGE TYPE FOUND FOR THIS PATIENT!",!,"COVERAGE TYPE CAN BE ADDED FOR A PATIENT ON THE FIRST PRIVATE INSURANCE PAGE",!,"Edit Item 11 and edit the Coverage field" H 3 Q
 D LSTREC(COVPTR,.COVREC)  ;GET COVREC TO BE USED WHEN EDITING THE AMOUNTS
 S INSPTR=$P(AGINSREC,U,2)
 W $S(INSPTR'="":$E($P($G(^AUTNINS(INSPTR,0)),U),1,15),1:"UNDEFINED")
 W:$P($G(^AUTTPIC(COVPTR,0)),U)'="" " ("_$E($P($G(^AUTTPIC(COVPTR,0)),U),1,15)_")"
 S DIC=9999999.18,D0=INSPTR,DR=".39"
 W ?50,"Network Provider : ",$$GET1^DIQ(DIC,D0,DR)
 W !
 I $P($G(^AUTTPIC(COVPTR,19,COVREC,0)),U)'="" D
 .S Y=$P(^AUTTPIC(COVPTR,19,COVREC,0),U) D DD^%DT W ?0,"EFF: ",Y
 I $P($G(^AUTTPIC(COVPTR,0)),U,6)'="" D
 .S Y=$P(^AUTTPIC(COVPTR,0),U,6),AG("PLANEXP")=Y D DD^%DT W ?20,"EXP: ",Y
 W !!,"-OUTPATIENT",$E(AGLINE("-"),1,69)
 K AG("C")
 F AG=1:1 D  Q:$G(AGSCRN)[("*END*")
 . S D0=COVREC
 . S AGSCRN=$P($T(@1+AG),";;",2,15)
 . Q:AGSCRN[("*END*")
 . I AG=4 W !,"-DAY SURGERY (ASC)",$E(AGLINE("-"),1,62)
 . I AG=6 W !,"-INPATIENT",$E(AGLINE("-"),1,70)
 . I AG=8 W !,"-DENTAL",$E(AGLINE("-"),1,72)
 . I AG=9 W !,"-MENTAL HEALTH",$E(AGLINE("-"),1,66)
 . I AG=10 W !,"-DEDUCTIBLE",$E(AGLINE("-"),1,69)
 . S CAPTION=$P(AGSCRN,U)  ;FIELD CAP
 . S DIC=$P(AGSCRN,U,3)    ;FILE OR SUBFILE #
 . S DR=$P(AGSCRN,U,4)      ;FLD #
 . S NEWLINE=$P(AGSCRN,U,5)  ;NEWLINE OR INDENT
 . S CAPDENT=$P(AGSCRN,U,2)   ;CAP INDENT
 . S ITEMNUM=$P(AGSCRN,U,6)   ;ITEM #
 . S TAGCALL=$P($P(AGSCRN,"|"),U,7)   ;TAG TO CALL TO EDIT THIS FLD
 . S EXECUTE=$P(AGSCRN,"|",2)      ;USE TO DISP FLD WHICH IS DEPENDENT ON ANOTHER FLD
 . S PREEXEC=$P(AGSCRN,"|",3)     ;PLACE CODE TO BE XECUTED PRIOR TO DISP OF THE FLD
 . S PRECAPEX=$P(AGSCRN,"|",4)   ;PLACE CODE TO EXECUTE BEF CAPTION/FLD LABEL
 . S POSTEXEC=$P(AGSCRN,"|",5)    ;PLACE CODE HERE TO BE EXECUTED AFT DISP OF THE FLD
 . S:TAGCALL'="" $P(AG("C"),",",ITEMNUM)=TAGCALL   ;SELECTION STRING
 . W @NEWLINE,AG,".",@CAPDENT,$S($G(CAPTION)'="":CAPTION,1:$P(^DD(DIC,DR,0),U)),":  "
 . I PREEXEC="" W $$GET1^DIQ(DIC,D0,DR)
 . I PREEXEC'="" S D0=COVREC_","_COVPTR_"," X PREEXEC
 . I EXECUTE'="" S D0=$TR(D0,",") X EXECUTE
 S AG("N")=$L(AG("C"),",")
 W !,$G(AGLINE("-"))
 K MYERRS,MYVARS
 D FETCHERR^AGEDERR(AG("PG"),.MYERRS)
 S MYVARS("DFN")=DFN,MYVARS("FINDCALL")="FINDPVT",MYVARS("SITE")=DUZ(2),MYVARS("SELECTION")=$G(AGSELECT)
 D EDITCHEK^AGEDERR(.MYERRS,.MYVARS,1)
 D VERIF^AGUTILS
 Q
 ;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ; SUBROUTINES FOR EDITING FIELDS
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;
OPCOPAY ;OUTPATIENT CO-PAYMENT
 K DIC,DR,DIE,DA,DD,DO
 S DA=$G(COVREC)
 S DA(1)=$G(COVPTR)
 S DIE="^AUTTPIC("_DA(1)_",19,"
 S DR=".02"
 D ^DIE
 K DIC,DR,DIE,DA
 Q
OPCOINS ;OUTPATIENT CO-INSURANCE
 K DIC,DR,DIE,DA,DD,DO
 S DA=$G(COVREC)
 S DA(1)=$G(COVPTR)
 S DIE="^AUTTPIC("_DA(1)_",19,"
 S DR=".03"
 D ^DIE
 K DIC,DR,DIE,DA
 Q
ERCOPAY ;ER CO-PAY
 K DIC,DR,DIE,DA,DD,DO
 S DA=$G(COVREC)
 S DA(1)=$G(COVPTR)
 S DIE="^AUTTPIC("_DA(1)_",19,"
 S DR=".04"
 D ^DIE
 K DIC,DR,DIE,DA
 Q
DSCOPAY ;DAY SURGERY CO-PAYMENT
 K DIC,DR,DIE,DA,DD,DO
 S DA=$G(COVREC)
 S DA(1)=$G(COVPTR)
 S DIE="^AUTTPIC("_DA(1)_",19,"
 S DR=".05"
 D ^DIE
 K DIC,DR,DIE,DA
 Q
DSCOINS ;DAY SURGERY CO-INSURANCE
 K DIC,DR,DIE,DA,DD,DO
 S DA=$G(COVREC)
 S DA(1)=$G(COVPTR)
 S DIE="^AUTTPIC("_DA(1)_",19,"
 S DR=".06"
 D ^DIE
 K DIC,DR,DIE,DA
 Q
IPCOPAY ;INPATIENT CO-PAYMENT
 K DIC,DR,DIE,DA,DD,DO
 S DA=$G(COVREC)
 S DA(1)=$G(COVPTR)
 S DIE="^AUTTPIC("_DA(1)_",19,"
 S DR=".07"
 D ^DIE
 K DIC,DR,DIE,DA
 Q
IPCOINS ;INPATIENT CO-INSURANCE
 K DIC,DR,DIE,DA,DD,DO
 S DA=$G(COVREC)
 S DA(1)=$G(COVPTR)
 S DIE="^AUTTPIC("_DA(1)_",19,"
 S DR=".08"
 D ^DIE
 K DIC,DR,DIE,DA
 Q
DENCOINS ;DENTAL CO-INSURANCE
 K DIC,DR,DIE,DA,DD,DO
 S DA=$G(COVREC)
 S DA(1)=$G(COVPTR)
 S DIE="^AUTTPIC("_DA(1)_",19,"
 S DR=".09"
 D ^DIE
 K DIC,DR,DIE,DA
 Q
MHDED ;MENTAL HEALTH DEDUCTIBLE
 K DIC,DR,DIE,DA,DD,DO
 S DA=$G(COVREC)
 S DA(1)=$G(COVPTR)
 S DIE="^AUTTPIC("_DA(1)_",19,"
 S DR=".11"
 D ^DIE
 K DIC,DR,DIE,DA
 Q
DEDFAM ;DEDUCTIBLE FAMILY
 K DIC,DR,DIE,DA,DD,DO
 S DA=$G(COVREC)
 S DA(1)=$G(COVPTR)
 S DIE="^AUTTPIC("_DA(1)_",19,"
 S DR=".12"
 D ^DIE
 K DIC,DR,DIE,DA
 Q
DEDIND ;DEDUCTIBLE INDIVIDUAL
 K DIC,DR,DIE,DA,DD,DO
 S DA=$G(COVREC)
 S DA(1)=$G(COVPTR)
 S DIE="^AUTTPIC("_DA(1)_",19,"
 S DR=".13"
 D ^DIE
 K DIC,DR,DIE,DA
 Q
DEDOOP ;DEDUCTIBLE OUT-OF-POCKET
 K DIC,DR,DIE,DA,DD,DO
 S DA=$G(COVREC)
 S DA(1)=$G(COVPTR)
 S DIE="^AUTTPIC("_DA(1)_",19,"
 S DR=".14"
 D ^DIE
 K DIC,DR,DIE,DA
 Q
LSTREC(COVPTR,COVREC) ;FIND MOST RECENT RECORD
 S AG("COVDT")=$O(^AUTTPIC(COVPTR,19,"B",""),-1)
 Q:AG("COVDT")=""
 S COVREC=$O(^AUTTPIC(COVPTR,19,"B",AG("COVDT"),""),-1)
 Q
 ; ****************************************************************
 ; ON LINES BELOW:
 ; U "^" DELIMITED
 ; AGSCRN CONTAINS THE $TEXT OF EACH LINE BELOW STARTING AT TAG '1'
 ; PIECE  VAR       DESC
 ; -----  --------  -----------------------------------------------
 ; 1      CAPTION    FLD CAP ASSIGNED BY PROGRAMMER OVERRIDES FLD LBL IF POPULATED
 ; 2      CAPDENT    POSITION ON LINE TO DISP CAP
 ; 3      DIC        FILE OR SUBFILE NUMBER
 ; 4      DR         FLD NUMBER
 ; 5      NEWLINE    NEW LINE OR NOT (MUST BE EITHER A '!' OR '?#') USE THIS TO INDENT THE LINE
 ; 6      ITEMNUM    ITEM NUMBER ASSIGNMENT. USE THIS TO ASSIGN THE ITEM # USED TO CHOOSE THIS
 ;                   FLD ON THE SCREEN
 ; 7      TAGCALL    TAG TO CALL WHEN THIS FLD IS CHOSEN BY USER TO BE EDITED
 ; 
 ; BAR "|" DELIMITED
 ; PIECE  VAR        DESC
 ; -----  --------   ----------------------------------------------
 ; 2      EXECUTE    EXECUTE CODE TO GET FLD THAT ANOTHER IS POINTING TO. EXECUTED AFT FLD PRINT
 ; 3      PREEXEC    EXECUTE CODE TO DO BEF FLD PRINTS.
 ;                   USE TO SCREEN OUT PRINTING A FLD VALUE
 ; 4      PRECAPEX   EXECUTE CODE TO DO BEF PRINTING THE CAP OR FLD LBL.
 ;                   USE TO SCREEN OUT PRINTING A CAP/FLD LBL
 ; 5      POSTEXEC   EXECUTE CODE TO DO AFT PRINTING THE FLD DATA
1 ;
 ;;Co-payment............($)^?5^9999999.6519^.02^!^1^OPCOPAY||W $J($$GET1^DIQ(DIC,D0,DR),8,2)
 ;;Co-insurance.......(%)^?45^9999999.6519^.03^?45^2^OPCOINS||W $J($$GET1^DIQ(DIC,D0,DR),8)
 ;;ER Co-pay.............($)^?5^9999999.6519^.04^!^3^ERCOPAY||W $J($$GET1^DIQ(DIC,D0,DR),8,2)
 ;;Co-payment............($)^?5^9999999.6519^.05^!^4^DSCOPAY||W $J($$GET1^DIQ(DIC,D0,DR),8,2)
 ;;Co-insurance.......(%)^?45^9999999.6519^.06^?45^5^DSCOINS||W $J($$GET1^DIQ(DIC,D0,DR),8)
 ;;Co-payment............($)^?5^9999999.6519^.07^!^6^IPCOPAY||W $J($$GET1^DIQ(DIC,D0,DR),8,2)
 ;;Co-insurance.......(%)^?45^9999999.6519^.08^?45^7^IPCOINS||W $J($$GET1^DIQ(DIC,D0,DR),8)
 ;;Dental Co-insurance...(%)^?5^9999999.6519^.09^!^8^DENCOINS||W $J($$GET1^DIQ(DIC,D0,DR),8)
 ;;Mental Health Deductible ^?5^9999999.6519^.11^!^9^MHDED||W $J($$GET1^DIQ(DIC,D0,DR),8,2)
 ;;Family................($)^?5^9999999.6519^.12^!^10^DEDFAM||W $J($$GET1^DIQ(DIC,D0,DR),8,2)
 ;;Individual........($)^?45^9999999.6519^.13^?45^11^DEDIND||W $J($$GET1^DIQ(DIC,D0,DR),8,2)
 ;;Out-Of-pocket.........($)^?5^9999999.6519^.14^!^12^DEDOOP||W $J($$GET1^DIQ(DIC,D0,DR),8,2)
 ;;*END*
