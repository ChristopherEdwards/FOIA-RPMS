AMERFIX ; IHS/ANMC/GIS - RESTORES MISSING DATA TO ER VISIT FILE ; 
 ;;3.0;ER VISIT SYSTEM;;FEB 23, 2009
 ;
NEW N A,E,T,W,%,X,Y,Z,G
 N DIE,DA,DR,DIC,DQ,DI,D0
 S DIE="^AMERVSIT(",G="^AMERVSIT"
RUN S DA=0 F  S DA=$O(@G@(DA)) Q:'DA  D
 .D VAR
 .I 'A Q
 .I T("D"),'W("D") D DR(A,T("D"),12.3)
 .I T("R"),'W("R") D DR(A,T("R"),12.4)
 .I T("S"),'W("S") D DR(A,T("S"),12.7)
 .I E,'W("V") D DR(A,E,12.5)
 .I DR]"" L +^AMERVSIT:DTIME
 .I $T D ^DIE L -^AMERVSIT Q
 .W !,"Sorry Someone else is editing this visit."
 .Q
 Q
 ;
VAR S DR=""
 S A=$P($G(@G@(DA,0)),U) I 'A Q
 S T("D")=$P($G(@G@(DA,12)),U),W("D")=$P($G(@G@(DA,12)),U,3)
 S T("R")=$P($G(@G@(DA,12)),U,2),W("R")=$P($G(@G@(DA,12)),U,4)
 S T("S")=$P($G(@G@(DA,12)),U,6),W("S")=$P($G(@G@(DA,12)),U,7)
 S E=$P($G(@G@(DA,6)),U,2),W("V")=$P($G(@G@(DA,12)),U,5)
 Q
 ;
DR(X,Y,Z) ; BUILD DR STRING
 N %
 S %=$$DT^AMERSAV1(Y,X,"M") I %="" Q
 I DR]"" S DR=DR_";"
 S DR=DR_Z_"///"_%
 Q
