BDMLEH ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED ; [ 01-FEB-2010 ]
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**1,3**;JUN 14, 2007
 ;; ;
EN ; -- main entry point for BDM LETTER INSERT HELP
 D EN^VALM("BDM LETTER INSERT HELP")
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="General Information about letter inserts."
 Q
 ;
INIT ; -- init variables and list array
 K BDMLELH
 NEW BDMX,BDMC
 S BDMC=0
 S BDMX=0 F  S BDMX=$O(^BDMLETIH(1,1,BDMX)) Q:BDMX'=+BDMX  D
 .S BDMC=BDMC+1,BDMLETH(BDMC,0)=^BDMLETIH(1,1,BDMX,0)
 S VALMCNT=BDMC
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 Q
 ;
EXPND ; -- expand code
 Q
 ;
INDITEM ;EP - called from protocol
 ;get item
 ;display text
 NEW BDMIEN,BDMP
 S BDMIEN=0
 D EN^VALM2(XQORNOD(0),"OS") ;this list man call allows user to select an entry in list
 I '$D(VALMY) W !,"No letter insert selected." Q
 S BDMP=$O(VALMY(0)) I 'BDMP K APCDP,VALMY,XQORNOD W !,"No record selected." Q
 S (X,Y)=0 F  S X=$O(BDMLETI("IDX",X)) Q:X'=+X!(BDMIEN)  I $O(BDMLETI("IDX",X,0))=BDMP S Y=$O(BDMLETI("IDX",X,0)),BDMIEN=BDMLETI("IDX",X,Y)
 I '$D(^BDMLETI(BDMIEN,0)) W !,"Not a valid INSERT." K BDMP S BDMIEN=0 Q
 D FULL^VALM1 ;give me full control of screen
 W !!,$P(^BDMLETI(BDMIEN,0),U,1)
 W !
 S X=0 F  S X=$O(^BDMLETI(BDMIEN,3,X)) Q:X'=+X  W !,^BDMLETI(BDMIEN,3,X,0)
 I $O(^BDMLETI(BDMIEN,2,0)) W !!,"Education Text is: ",!
 S X=0 F  S X=$O(^BDMLETI(BDMIEN,2,X)) Q:X'=+X  W !,^BDMLETI(BDMIEN,2,X,0)
 K DIR S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR
 D TERM^VALM0
 S VALMBCK="R"
 Q
