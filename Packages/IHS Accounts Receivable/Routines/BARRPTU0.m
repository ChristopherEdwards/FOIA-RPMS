BARRPTU0 ; IHS/SD/LSL - USER REPORTS ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;;
SELECT ; EP
 K DIC,DR,DA,DIE
 S DIC=$$DIC^XBDIQ1(90055.06)
 S DIC("W")="W ?40,$$VAL^XBDIQ1(90055.06,+Y,.02)"
 S DIC(0)="AEQML"
 D ^DIC
 Q:Y'>0
 S DA=+Y
 S DR=".01;.02"
 S DIE=DIC
 D ^DIE
 S BARFN=$$GET1^DIQ(90055.06,DA,.02,"I")
 K DR
 S DR=".03;.04;.05"
 D ^DIE
 S BARFN=$$VALI^XBDIQ1(90055.06,DA,.02)
 D USRRPT
 K DIR
 S DIR("A")="CR - Continue"
 D EOP^BARUTL(0)
 G SELECT
 ; *********************************************************************
 ;
SORT ; EP
 S BARFN=$$GET1^DIQ(90055.06,DA,.02,"I")
 Q:'BARFN
 D EN^XBNEW("S1^BARRPTU0","BARFN")
 Q
 ; *********************************************************************
 ;
S1 ; EP
 K DIC
 S L=0
 S DIC="^DIBT("
 S DIS(0)="I $P(^DIBT(D0,0),U,4)=BARFN"
 S BY=".01;S2"
 S FR="A"
 S TO="z"
 S FLDS="""*******"";C1;S2,.01;C1,""*******"";C1,1620"
 S DHD="SORT Templates for "_$$GET1^DIQ(1,BARFN,.01)
 D VIEWD^XBLM("EN1^DIP")
 Q
 ; *********************************************************************
 ;
PRINT ; EP
 ; XBLM print templates for the file
 S BARFN=$$GET1^DIQ(90055.06,DA,.02,"I")
 Q:'BARFN
 D EN^XBNEW("P1^BARRPTU0","BAR*")
 Q
 ; *********************************************************************
 ;
P1 ; EP
 K DIC
 S L=0
 S DIC="^DIPT("
 S DIS(0)="I $P(^DIPT(D0,0),U,4)=BARFN"
 S BY=".01;S2"
 S FR="A"
 S TO="z"
 S FLDS="""*******"";C1;S2,.01;C1,""*******"";C1,1620"
 S DHD="PRINT Templates for "_$$GET1^DIQ(1,BARFN,.01)
 D VIEWD^XBLM("EN1^DIP")
 Q
 ; *********************************************************************
 ;
USRRPT ;EP - run the user report
 S X=$$GET1^DIQ(90055.06,DA,.05,"I")
 Q:'X
 S BARURDA=DA
 W $$EN^BARVDF("IOF")
 W "Running the report:   ",$$GET1^DIQ(90055.06,DA,.01),!
 D EN^XBNEW("US0^BARRPTU0","BAR*")
 Q
 ; *********************************************************************
 ;
US0 ; EP
 ; run the report
 S DIC=$$DIC^XBDIQ1(BARFN)
 S FLDS=$$GET1^DIQ(90055.06,BARURDA,.04)
 S BY=$$GET1^DIQ(90055.06,BARURDA,.03)
 S L=0
 I $L(FLDS),$L(BY)
 E  Q
 S FLDS="["_FLDS_"]",BY="["_BY_"]"
 D EN1^DIP
 Q
