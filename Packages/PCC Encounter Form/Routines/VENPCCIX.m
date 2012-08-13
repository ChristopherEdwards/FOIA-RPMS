VENPCCIX ; IHS/OIT/GIS - INSTALLATION TOOLS: ADD A NEW TEMPLATE FOR VER 2.5 EXTENSION OF VENPCCIT ;
 ;;2.6;PCC+;;NOV 12, 2007
 ;
 ; 
 ; 
LAB ; EP-DISPLAY CERTAIN LAB RESULTS
 W !!,SEP,"  RECENT LAB RESULTS  ",SEP
 W !!,"Want to include recent lab test results on the form..."
 S %=2
 I $O(^VEN(7.41,TIEN,7,0)) S %=1 ; PATCHED BY GIS/OIT 10/15/05 ; PCC+ 2.5 PATCH 1
 D YN^DICN
 I %Y=U W !!,SEP G HMR^VENPCCIT
 I %Y?2."^" G FIN
 S DA(1)=TIEN,DIC="^VEN(7.41,"_DA(1)_",7,"
 I %=2,$O(^VEN(7.41,DA(1),7,0)),'$$OK("lab tests") G LAB1 ; PATCHED BY GIS/OIT 10/15/05 ; PCC+ 2.5 PATCH 1
 I %=2 D  G GRAPH
 . S DA(1)=TIEN,DIK=DIC,DA=0
 . F  S DA=$O(^VEN(7.41,DA(1),7,DA)) Q:'DA  D ^DIK
 . Q
LAB1 S DIC("P")="19707.417PA",DIC(0)="AEQL",DLAYGO=19707.417
 S DIC("A")="Enter the name of "_$S($D(^VEN(7.41,TIEN,7)):"another",1:"a")_" lab test result: "
 D ^DIC I Y=-1 G GRAPH
 S DA=+Y,DIE=DIC
 I $P(Y,U,3) G LAB2
 W !,"This test already is on the form.  Want to delete it"
 S %=2
 D YN^DICN
 I %=1 S DIK=DIC D ^DIK W ! G LAB1
LAB2 S DR=".02CPT Code;.03Printed test name;.08Max number of results allowed;.09Max age of result allowed (mos);.06Point of care test"
 L +^VEN(7.41,TIEN):0 I  D ^DIE L -^VEN(7.41,TIEN) W !
 G LAB1 ; ADD MORE TESTS TO THE FORM
 ; 
GRAPH ; EP - GRAPHS ASSOCIATED WITH THE FORM
 W !!,SEP,"  GRAPHS  ",SEP
 W !!,"Want to include graphs of measurable results on this form"
 S %=2
 I $O(^VEN(7.41,TIEN,6,0)) S %=1 ; PATCHED BY GIS/OIT 10/15/05 ; PCC+ 2.5 PATCH 1
 D YN^DICN
 I %Y=U W !!,SEP G LAB
 I %Y?2."^" G FIN
 S DA(1)=TIEN,DIC="^VEN(7.41,"_DA(1)_",6,"
 I %=2,$O(^VEN(7.41,DA(1),6,0)),'$$OK("graphs") G GRAPH1 ; PATCHED BY GIS/OIT 10/15/05 ; PCC+ 2.5 PATCH 1
 I %=2 D  G KB
 . S DA(1)=TIEN,DIK=DIC,DA=0
 . F  S DA=$O(^VEN(7.41,DA(1),6,DA)) Q:'DA  D ^DIK
 . Q
GRAPH1 S DIC("P")="19707.416P",DIC(0)="AEQL",DLAYGO=19707.416
 S DIC("A")="Enter the name of "_$S($D(^VEN(7.41,TIEN,6)):"another",1:"a")_" graph: "
 D ^DIC I Y=-1 G KB
 S DA=+Y,DIE=DIC
 I $P(Y,U,3) W ! G GRAPH1
 W !,"This graph already is on the form.  Want to delete it"
 S %=2
 D YN^DICN
 I %=1 S DIK=DIC D ^DIK
 W ! G GRAPH1 ; ADD MORE GRAPHS TO THE FORM
 ; 
KB ; EP - KNOWLEDGEBASE ASSOCIATED WITH THE FORM
 W !!,SEP,"  KNOWLEDGEBASES  ",SEP
 W !,"A knowledgebase contains custom guidelines or patient education topics."
 S %=2
 I $O(^VEN(7.41,TIEN,19,0)) S %=1 D
 . W !,"This form already contains the following knowledgebase(s): "
 . S KIEN=0 F  S KIEN=$O(^VEN(7.41,TIEN,19,"B",KIEN)) Q:'KIEN  D
 .. S KNM=$P($G(^VEN(7.13,KIEN,0)),U)
 .. W !?3,KNM
 .. Q
 . W !!
 . Q
 W !,"Want to include knowledgebase(s) on this form"
 D YN^DICN
 I %Y=U W !!,SEP G GRAPH ; PATCHED BY GIS/OIT 10/15/05 ; PCC+ 2.5 PATCH 1
 I %Y?2."^" G FIN
 S DA(1)=TIEN,DIC="^VEN(7.41,"_DA(1)_",19,"
 I %=2,$O(^VEN(7.41,DA(1),19,0)),'$$OK("knowledgebases") G KB1 ; PATCHED BY GIS/OIT 10/15/05 ; PCC+ 2.5 PATCH 1
 I %=2 D  G GG
 . S DA(1)=TIEN,DIK=DIC,DA=0
 . F  S DA=$O(^VEN(7.41,DA(1),19,DA)) Q:'DA  D ^DIK
 . Q
KB1 S DIC("P")="19707.4119P",DIC(0)="AEQL",DLAYGO=19707.4119
 S DIC("A")="Enter the name of a knowledgebase clinical domain: "
 D ^DIC I Y=-1 G GG ; ASSIGN A KB CLINICAL DOMAIN TO THE TEMPLATE
 S DA=+Y
 I '$P(^VEN(7.41,TIEN,19,DA,0),U,2) S $P(^(0),U,2)=(DA*5)+100 ; AUTOMATICALLY ASSIGN AN ORDER
 I $P(Y,U,3) W ! G KB1 ; CHECK TO SEE IF THE KB DOMAINE IS ALREADY ASSIGNED.  IF SO, DOES IT NEED OT BE REMOVED
 W !,"This knowledgebase already is on the form.  Want to delete it"
 S %=2
 D YN^DICN
 I %=1 S DIK=DIC D ^DIK
 W ! G KB1 ; ADD MORE GRAPHS TO THE FORM
 ; 
GG ; EP - GROWTH GRIDS FOR WELL CHILD FORM
 S GGIEN=$O(^VEN(7.62,"B","PEDS GROWTH CHART",0)),%=2
 I 'GGIEN G CL ; THE PEDS GROWTH CHART OCX IS UNAVAILABLE
 W !!,SEP,"  PEDIATRIC GROWTH GRIDS  ",SEP
 I $D(^VEN(7.62,GGIEN,6,"B",TIEN)) S %=1
 W !!,"Want to include Pediatric Growth Grids on the form"
 D YN^DICN
 I %=1 G GG1
 I %Y=U W !! G KB
 I %Y?2."^" G FIN
GGD I $D(^VEN(7.62,GGIEN,6,"B",TIEN)),%=2 D  G CL ; DELETE GRID FROM FORM
 . W !,"Sure you want to remove the Grids from this template"
 . S %=2 D YN^DICN
 . I %'=1 D ^XBFMK Q
 . S DA(1)=GGIEN
 . S DIK="^VEN(7.62,"_DA(1)_",6,"
 . S DA=$O(^VEN(7.62,GGIEN,6,"B",TIEN,0)) I 'DA Q
 . D ^DIK
 . D ^XBFMK
 . Q
 Q  ; PATCHED BY GIS/OIT 01/10/06 ; PCC+ 2.5 PATCH 2
 ; 
GG1 ; EP - UPDATE THE OCX COMPONENTS FILE
 S DA(1)=GGIEN
 S DIC="^VEN(7.62,"_DA(1)_",6," S DIC(0)="L"
 S DLAYGO=19707.626
 S DIC("P")=19707.626
 S X="`"_TIEN
 D ^DIC I Y=-1 G CL
 W !,"OK, you may now add Pediatric Growth Grids to this template"
 W !,"If 'blank' graphs appear on the printed form, you should review"
 W !,"section 5 in the PCC+ users guide to learn about the 'blank graph' remedy"
CL ; CHECKLISTS
 W !!,SEP,"  CHECKLISTS  ",SEP
 W !,"A checklist contains a set of orderable items or clinical tasks"
 W !!,"Want to include checklists(s) on this form"
 S %=2
 I $O(^VEN(7.41,TIEN,17,0)) S %=1 ; PATCHED BY GIS/OIT 10/15/05 ; PCC+ 2.5 PATCH 1
 D YN^DICN
 I %Y=U G GG
 I %Y?2."^" G FIN
 S DA(1)=TIEN,DIC="^VEN(7.41,"_DA(1)_",17,"
 I %=2,$O(^VEN(7.41,DA(1),17,0)),'$$OK("checklists") G CL1 ; PATCHED BY GIS/OIT 10/15/05 ; PCC+ 2.5 PATCH 1
 I %=2 D  G HX
 . S DA(1)=TIEN,DIK=DIC,DA=0
 . F  S DA=$O(^VEN(7.41,DA(1),17,DA)) Q:'DA  D ^DIK
 . S %=$NA(^VEN(7.41,TIEN)),$P(@%@(0),U,17)=0 ; PATCHED BY GIS/OIT 10/15/05 ; PCC+ 2.5 PATCH 1
 . Q
CL1 S %=$NA(^VEN(7.41,TIEN)),$P(@%@(0),U,17)=1 ; PATCHED BY GIS/OIT 10/15/05 ; PCC+ 2.5 PATCH 1
 S DIC("P")="19707.4117P",DIC(0)="AEQL",DLAYGO=19707.4117
 S DIC("A")="Enter the name of "_$S($D(^VEN(7.41,TIEN,17)):"another",1:"a")_" checklist: "
 D ^DIC I Y=-1 G HX
 S DA=+Y,DIE=DIC
 I $P(Y,U,3) W ! G CL1
 W !,"This checklist already is on the form.  Want to delete it"
 S %=2
 D YN^DICN
 I %=1 S DIK=DIC D ^DIK
 W ! G CL1 ; ADD MORE GRAPHS TO THE FORM
 ; 
HX ; EP - PATIENT HX
 W !!,SEP,"  HISTORICAL INFORMATION  ",SEP
HX1 W !!,"Want to include personal history items on the form"
 S %=2
 I $P($G(^VEN(7.41,TIEN,5)),U,9) S %=1
 S Z=$G(FLD(5.09)) I $L(Z) S %=$S(Z=1:1,1:2)
 D YN^DICN
 I %Y=U G CL
 I %Y?2."^" G FIN
 S FLD(5.09)=$S(%=1:1,1:0)
 I %'=1 G HX3
HX2 W !!,"Want to exclude the onset date from the personal history"
 S %=2
 I $P($G(^VEN(7.41,TIEN,5)),U,10) S %=1
 S Z=$G(FLD(5.1)) I $L(Z) S %=$S(Z=1:1,1:2)
 D YN^DICN
 I %Y=U G HX1
 I %Y?2."^" G FIN
 S FLD(5.1)=$S(%=1:1,1:0)
HX3 W !!,"Want to include family history items on this form"
 S %=2
 I $P($G(^VEN(7.41,TIEN,5)),U,8) S %=1
 S Z=$G(FLD(5.08)) I $L(Z) S %=$S(Z=1:1,1:2)
 D YN^DICN
 I %Y=U G HX1
 I %Y?2."^" G FIN
 S FLD(5.08)=$S(%=1:1,1:0)
HX4 W !!,"Want to include past surgical procedures on this form"
 S %=2
 I $P($G(^VEN(7.41,TIEN,5)),U,8) S %=1
 S Z=$G(FLD(5.04)) I $L(Z) S %=$S(Z=1:1,1:2)
 D YN^DICN
 I %Y=U G HX3
 I %Y?2."^" G FIN
 I %'=1 G FIN
 S FLD(5.04)=$S(%=1:1,1:0)
HX5 W !!,"Want to include the diagnosis with the procedure"
 S %=1
 I '$P($G(^VEN(7.41,TIEN,5)),U,8) S %=2
 S Z=$G(FLD(5.05)) I $L(Z) S %=$S(Z=1:1,1:2)
 D YN^DICN
 I %Y=U G HX4
 I %Y?2."^" G FIN
 S FLD(5.05)=$S(%=1:1,1:0)
HX6 W !!,"Want to include the operating provider with the procedure"
 S %=1
 I '$P($G(^VEN(7.41,TIEN,5)),U,8) S %=2
 S Z=$G(FLD(5.06)) I $L(Z) S %=$S(Z=1:1,1:2)
 D YN^DICN
 I %Y=U G HX5
 I %Y?2."^" G FIN
 S FLD(5.06)=$S(%=1:1,1:0)
HX7 W !!,"Want to exclude minor procedures from the list"
 S %=2
 I $P($G(^VEN(7.41,TIEN,5)),U,8) S %=1
 S Z=$G(FLD(5.07)) I $L(Z) S %=$S(Z=1:1,1:2)
 D YN^DICN
 I %Y=U G HX6
 I %Y?2."^" G FIN
 S FLD(5.07)=$S(%=1:1,1:0)
HX8 W !!,"Want to display only the last major procedure"
 S %=2
 I $P($G(^VEN(7.41,TIEN,5)),U,8) S %=1
 S Z=$G(FLD(5.11)) I $L(Z) S %=$S(Z=1:1,1:2)
 D YN^DICN
 I %Y=U G HX7
 I %Y?2."^" G FIN
 S FLD(5.11)=$S(%=1:1,1:0)
HX9 W !!,"Want to display the ICD code associated with the procedure"
 S %=1
 I '$P($G(^VEN(7.41,TIEN,5)),U,8) S %=2
 D YN^DICN
 I %Y=U G HX8
 I %Y?2."^" G FIN
 S FLD(5.12)=$S(%=1:1,1:0)
HXDIE D DIE^VENPCCIT(TIEN)
 W !!,SEP,!!,"CONGRATULATIONS! This template's definition is now complete..."
 W !,"Be sure to copy the template '"_TMN_"_template.doc on to BOTH print severs"
 W !,"Then check template synchronization with the 'TS' option on the"
 W !,"PCC+ Install menu.  It is no longer necessary to make a companion file."
 W !,"You can edit the properties of '",TNM,"' at any"
 W !,"time by running this utility again.",!!,SEP,!!
FIN D ^XBFMK
 Q
 ;
GRADD ; EP - ENTER A NEW GRAPH
 N NAME,TYPE,LFILE,MFILE,FILE,MM,MDP,UNIT,X,Y,Z,%,DIC,DA,DR,DIE,DIR,DTOUT,GIEN
GRA1 S DIR(0)="F^3:30",DIR("A")="Name of graph"
 D ^DIR K DIR
 I $D(DTOUT) G GRAX
 I Y?1."^" G GRAX
 I Y'?1U2.29UN W "  ??" G GRA1
 I $D(^VEN(7.63,"B",Y)) W !,"This graph name already exists!  Enter another name..." G GRA1
 S DIC(0)="L",X=""""_Y_""""
 S DIC="^VEN(7.63,",DLAYGO=19707.63
 D ^DIC I Y=-1 Q
 W !,"This name will also be used as the graph's title",!
 S GIEN=+Y,NAME=$P(Y,U,2)
GRA2 S DIR(0)="S^M:MEASUREMENT;L:LAB TEST RESULT",DIR("A")="Data type",DIR("B")=$G(TYPE)
 D ^DIR K DIR
 I $D(DTOUT) G GRAX
 I Y?1."^" G GRAX
 S TYPE=Y
GRAM ; GET MEASUREMENT ENTRY
 I TYPE="L" G GRAL
 I TYPE'="M" G GRAX
 S DIC("A")="Enter the associated MEASUREMENT file entry: "
 I $D(^AUTTMSR("B",NAME)) S DIC("B")=NAME
 I $L($G(MFILE)) S DIC("B")=MFILE
 S DIC(0)="AEQM" S DIC="^AUTTMSR("
 D ^DIC I Y=-1 G GRAX
 S FILE=+Y,MFILE=$P(Y,U,2)
 G GRAMM
 ; 
GRAL ; EP - GET LAB RESULT ENTRY
 S DIC("A")="Enter the associated LAB file entry: "
 I $D(^LAB(60,"B",NAME)) S DIC("B")=NAME
 I $L($G(LFILE)) S DIC("B")=LFILE
 S DIC(0)="AEQM" S DIC="^LAB(60,"
 D ^DIC I Y=-1 G GRAX
 S FILE=+Y,LFILE=$P(Y,U,2)
GRAMM ; MAX MONTHS
 S DIR(0)="NO^1:300:0",DIR("A")="Enter the max months displayed in this graph"
 S DIR("B")=24 I $G(MM) S DIR("B")=MM
 D ^DIR K DIR
 I $D(DTOUT) G GRAX
 I Y=U W ! G GRAM
 I Y?2."^" G GRAX
 S MM=Y
GRAD ; MAX DATA POINTS
 S DIR(0)="NO^1:999:0",DIR("A")="Enter the max # data points displayed in this graph"
 S DIR("B")=10 I $G(MDP) S DIR("B")=MDP
 D ^DIR K DIR
 I $D(DTOUT) G GRAX
 I Y=U W ! G GRAMM
 I Y?2."^" G GRAX
 S MDP=Y
GRAU ; UNITS
 S DIR(0)="FO^3:30",DIR("A")="Units represented in this graph"
 I $L($G(UNIT)) S DIR("B")=UNIT
 D ^DIR K DIR
 I $D(DTOUT) G GRAX
 I Y=U W ! G GRAD
 I Y?2."^" G GRAX
 S UNIT=Y
 I UNIT="@" S UNIT=""
 I $L(UNIT) W !,"The unit '",UNIT,"' will be used as the y-axis label",!
GRAF ; FILE THE RESULTS
 S DIE="^VEN(7.63,",DA=GIEN
 S DR=".02///^S X=TYPE;.03///^S X=MM;.04///^S X=MDP;.05///^S X=NAME;.08///^S X=UNIT"
 I $L($G(MFILE)) S DR=DR_";.11///^S X=FILE"
 I $L($G(LFILE)) S DR=DR_";.12///^S X=FILE"
 D ^DIE
 W !,"This graph has been added to PCC+.",!,"Use the TCU option to attach it to specific PCC+ templates."
GRAX D ^XBFMK
 Q
 ;
GRED ; EP - EDIT A GRAPH'S PROPERTIES
 N DIC,DIE,DR,DA,X,Y,%,TYPE
 S DIC="^VEN(7.63,",DIC(0)="AEQ",DIC("A")="Which graph do you want to edit: "
 D ^DIC I Y=-1 G GREX
 S DA=+Y,DIE=DIC,DR=".02" D ^DIE
 S TYPE=$P($G(^VEN(7.63,DA,0)),U,2)
 I TYPE="" W !,"No data type specified.  Graph entry will be deleted!",! N DIK G GRDEL
 I TYPE=1 S DR=".11Associated MEASUREMENT file entry"
 I TYPE=2 S DR=".12Associated LAB file entry"
 S DR=DR_";.03;.04;.08"
 D ^DIE W !,"The properties of this graph have been updated...",!
GREX D ^XBFMK
 Q
 ;
GRD ; EP - DELETE A GRAPH
 N DIK,DIC,X,Y,NAME,GRIEN,TIEN,GIEN
 S DIC("A")="Which graph do you want to delete: "
 S DIC="^VEN(7.63,",DIC(0)="AEQ"
 D ^DIC I Y=-1 G GRAX
 S GRIEN=+Y,NAME=$P(Y,U,2)
 W !,"WARNING: This will remove this graph from PCC+ and ",!,"detach it from all PCC+ templates..."
 W !,"Are you sure you want to delete this graph"
 S %=0 D YN^DICN I %'=1 G GRAX
GRDT ; REMOVE GRAPH FROM INDIVIDUAL TEMPLATES
 S TIEN=0
 F  S TIEN=$O(^VEN(7.41,TIEN)) Q:'TIEN  D  ; REMOVE GRAPH FROM ALL TEMPLATE DEFINITIONS
 . S GIEN=0 F  S GIEN=$O(^VEN(7.41,TIEN,6,"B",GRIEN,GIEN)) Q:'GIEN  D
 .. S DA(1)=TIEN,DA=GIEN
 .. S DIK="^VEN(7.41,"_DA(1)_",6,"
 .. D ^DIK
 .. Q
 . Q
 K DIK
GRDEL S DIK="^VEN(7.63," S DA=GRIEN ; REMOVE GRAPH DEFINITION
 I '$D(^VEN(7.63,+$G(DA))) Q
 D ^DIK W !,NAME," deleted..."
 D ^XBFMK
 Q
 ; 
OK(TXT) ; EP - CONFRIM REMOVAL OF ITEMS
 ; PATCHED BY GIS/OIT 10/15/05 ; PCC+ 2.5 PATCH 1
 N %,%Y
 S TXT=$S($L($G(TXT)):TXT,1:"items")
 W !,"This will remove ALL ",TXT," from the form!!!"
 W !,"Are you sure you want to do this"
 S %=2
 D YN^DICN
 I %=1 Q 1
 Q 0
 ; 
