ABMDTMOD ; IHS/ASDST/DMJ - ENTER/EDIT 3P MODIFIERS ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;
START ;START HERE
 W !
 S DIC=$S($$VERSION^XPDUTL("BCSV")>0:"^DIC(81.3,",1:"^AUTTCMOD(")  ;CSV
 S DIC(0)="AEMQL"  ;CSV-c
 D ^DIC Q:+Y<0  ;CSV-c
 S DIE=DIC,DA=+Y,DR=".02;.03//12345;.04"
 D ^DIE
 Q
HELP ;EP - HELP FOR CATEGORIES FIELD
 W !,"Enter category or categories of CPT codes this modifier can be used with."
 W !,"Select from: ",!
 F I=1:1:5 D
 .W !?3,$P("1  Medicine^2  Anesthesia^3  Surgery^4  Radiology^5  Laboratory","^",I)
 W ! Q
H2 ;EP - HELP FOR UNITS FIELD
 W !!,"Enter multiplier to be applied to the base charge"
 W !,"(for example, enter 1.5 to apply a 50% price increase"
 W !,"whenever this modifier is selected).",!
 Q
