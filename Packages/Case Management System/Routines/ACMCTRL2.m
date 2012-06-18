ACMCTRL2 ; IHS/TUCSON/TMJ - MASTER CONTROL #2 (HEADERS/FIELD POSITIONS) ;
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;;JAN 10, 1996
 ;ENTER/EDIT DISPLAY HEADERS FOR EACH ELEMENT
 ;INDIVIDUAL FIELD & POSITION CALLED FROM ACMCTRL1
 ;DATA DISPLAY CALLED FROM ACMEP
 ;
MD1 ;;W !!?8,ACMTL,?60,"SIG",!?8,"--------------------------------------------------",?60,"--------------------"
MEAS1 ;;W !!?14,ACMTL,?46,"VALUE",?60,"DATE",!?14,"------------------------------",?46,"------------------------------"
CT1 ;;W !?14,"-------------------------------------------------" S ACMCT=""
CMP1 ;;S ACMLE(1)="W !!?1,ACMTL,?27,""ONSET DT"",?37,""ST"",?40,""COMMENTS""",ACMLE(2)="W !?1,""-----------------------   --------  --""",ACMLE(3)="W ?40,""----------------------------------------""" F J=1:1:3 X ACMLE(J)
PROB1 ;;D ^ACMPROB R !!,"Type the <ENTER> key to continue",ACMX#1:300,!! S ACMPROB="" Q
DX1 ;;W !!?14,ACMTL,?46,"ONSET DATE",?60,"SEVERITY",!?14,"------------------------------",?46,"------------",?60,"--------------------"
DC1 ;;S ACMLE(1)="W !!?14,""DIAGNOSTIC CRITERIA"",?50,""DATE ESTABLISHED""",ACMLE(2)="W !?14,""------------------------------""",ACMLE(3)="W ?50,""----------------""" F J=1:1:3 X ACMLE(J)
RF1 ;;W !!?14,ACMTL,!?14,"------------------------------"
ET1 ;;W !!?14,ACMTL,!?14,"------------------------------"
FM1 ;;S ACMLE(1)="W !!?5,""FAMILY MEMBER"",?40,""CHART"",?51,""RELATION"",?65,""RELATED DX""",ACMLE(2)="W !?5,""--------------------------     --------""",ACMLE(3)="W ?51,""----------------"",?65,""----------""" F J=1:1:3 X ACMLE(J) S ACMFM=""
CH1 ;;S ACMLE(1)="W !!?3,""ONSET DATE"",?18,""PLACE OF ONSET""",ACMLE(2)="W ?40,""CASE HISTORY""",ACMLE(3)="W !?3,""-------------  --------------------""",ACMLE(4)="W ?40,""---------------------------""" F J=1:1:4 X ACMLE(J)
CR1 ;;S ACMLE(1)="W !!?14,""LAST REVIEW"",?29,""NEXT REVIEW""",ACMLE(2)="W !?14,""------------  ------------""",DA=ACMRGDFN,ACMNT="" F J=1:1:2 X ACMLE(J)
SV1 ;;S ACMLE(1)="W !!?14,""SERVICES NEEDED BY THIS CLIENT""",ACMLE(2)="W ?50,""AVAILABILITY STATUS""",ACMLE(3)="W !?14,""---------------------------------""",ACMLE(4)="W ?50,""-------------------""" F J=1:1:4 X ACMLE(J)
REG1 ;;S ACMREG="" D REGHEAD^ACMCTRL2
REGHEAD W !!,?14,"CURRENT STATUS FOR THIS CLIENT",!,?14,"-------------------------------------"
 D ^ACMLCMS,ACMPT^ACMLCMS
 W !!,?14,"Do you want to update this information"
 S %=2 D YN^DICN
 I %=2!(%Y="")!(%="-1") S ACMQUIT="" S:%Y["^" ACMOUT=""
 Q
AP1 ;;D APHEAD^ACMCTRL2
APHEAD W !!?5,"INTERVENTION",?30,"RESULTS",?50,"RESULT DATE",?65,"NEXT DATE DUE",!?5,"------------",?30,"-------",?50,"-----------",?65,"-------------"
 Q
