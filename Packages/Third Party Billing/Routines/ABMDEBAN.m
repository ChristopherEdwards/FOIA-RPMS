ABMDEBAN ; IHS/ASDST/DMJ - Claim Data Entry Banner ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 W !!
 W ?22 F ABMD("I")=1:1:35 W "*"
 W !?22,"*",?27,"THIRD PARTY BILLING SYSTEM",?56,"*"
 W !,?22,"*",?32,"CLAIM DATA ENTRY"
 W ?56,"*"
 W !?22,"*"
 W ?80-$L(ABMD("SITE"))\2,ABMD("SITE")
 W ?56,"*"
 W !,?22 F ABMD("I")=1:1:35 W "*"
 W !
 ;
XIT K ABMD
 Q
