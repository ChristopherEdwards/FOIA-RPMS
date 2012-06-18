APCHMT1 ; IHS/CMI/LAB -- CONTINUATION OF ROUTINES ; 15 Sep 2010  8:15 AM
 ;;2.0;IHS PCC SUITE;**5,7**;MAY 14, 2009
 ;; ;
 ;routine to create/modify a health summary type
 ;
BACK ;go back to listman
 D TERM^VALM0
 S VALMBCK="R"
 D INIT^APCHMT
 D HDR^APCHMT
 K DIR
 K X,Y,Z,I
 Q
COMP(S,C) ;EP
 NEW X,Y S Y=0,X=0 F  S X=$O(^APCHSCTL(S,1,X)) Q:X'=+X!(Y)  I $P(^APCHSCTL(S,1,X,0),U,2)=C S Y=1
 Q Y
HS ;EP called from protocol to generate hs
 D FULL^VALM1
 S DFN=""
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DLAYGO,DIADD
 I Y<0 W !,"No Patient Selected." D BACK Q
 S DFN=+Y
 S Y=DFN D ^AUPNPAT
 S APCHSTYP=APCHDA
 S APCHSPAT=DFN
 S %=$P(^APCHSCTL(APCHDA,0),U)_" Health Summary for "_$P(^DPT(APCHSPAT,0),U)
 D VIEWR^XBLM("EN^APCHS",%) S APCHDA=APCHSTYP
 D BACK
 Q
GEN ;EP
 D FULL^VALM1
 S DA=APCHDA,DIE="^APCHSCTL(",DR="1.5;2;3;3.6;3.7;3.8;3.9T" D ^DIE,^XBFMK
 D BACK
 Q
MSUP ;EP - called from protocol entry
 D FULL^VALM1
 I '$$COMP(APCHDA,$O(^APCHSCMP("B","SUPPLEMENTS",0))) W !!,"WARNING:  SUPPLEMENTS has not been added to the Health Summary Structure.",! D
 .W "The SUPPLEMENTS you add to this panel will not display until SUPPLEMENTS is a part",!,"of the summary structure."
 W !
 S DA=APCHDA,DIE="^APCHSCTL(",DR=12 D ^DIE,^XBFMK
 D BACK
 Q
MCS ;EP - called from protocol entry
 D FULL^VALM1
 I '$$COMP(APCHDA,$O(^APCHSCMP("B","OUTPATIENT VISITS (SCREENED)",0))) W !!,"WARNING:  OUTPATIENT VISITS SCREENED has not been added to the Health Summary",!,"structure.  Entering clinic values into this field will have no affect",! D
 .W "unless OUTPATIENT VISITS (SCREENED) is added to the structure."
 W !!,"If the clinic of a visit is a clinic that matches one entered",!,"into this field the visit will NOT display on the summary",!,"in the OUTPATIENT VISITS (SCREENED) section."
 W !!,"To remove a clinic from being screened out of this summary",!,"type the clinic code or name and type an '@',",!
 S DA=APCHDA,DIE="^APCHSCTL(",DR=11 D ^DIE,^XBFMK
 D BACK
 Q
MPS ;EP - called from protocol entry
 D FULL^VALM1
 I '$$COMP(APCHDA,$O(^APCHSCMP("B","OUTPATIENT VISITS (SCREENED)",0))) W !!,"WARNING:  OUTPATIENT VISITS SCREENED has not been added to the Health Summary",!,"structure.  Entering Provider class values into this field will have no affect",! D
 .W "unless OUTPATIENT VISITS (SCREENED) is added to the structure."
 W !!,"If the primary provider on a visit has a provider class that matches one entered",!,"into this field the visit will NOT display on the summary",!,"in the OUTPATIENT VISITS (SCREENED) section."
 W !!,"To remove a provider class from being screened out of this summary",!,"type the provider class code and type an '@',",!
 S DA=APCHDA,DIE="^APCHSCTL(",DR=9 D ^DIE,^XBFMK
 D BACK
 Q
MH ;EP - called from protocol entry
 D FULL^VALM1
 I '$$COMP(APCHDA,$O(^APCHSCMP("B","HEALTH FACTORS",0))) W !!,"WARNING:  HEALTH FACTORS has not been added to the Health Summary Structure.",!,"HEALTH FACTORS will not display until they are part of the summary",!,"structure."
 W !!,"If you want all HEALTH FACTOR categories to display on your summary",!,"then DO NOT update this field.  If it is left blank then all HEALTH FACTOR",!,"categories will display.  If you want only selected HEALTH FACTOR categories",!
 W "to display on this summary type then enter them into this field."
 W !!,"You can add a new HEALTH FACTOR category by entering a new sequence number",!,"and HEALTH FACTOR category name.",!,"To remove a HEALTH FACTOR category from this summary type select the category",!
 W "by sequence number and type an '@',",!
 S DA=APCHDA,DIE="^APCHSCTL(",DR=8 D ^DIE,^XBFMK
 D BACK
 Q
MF ;EP - called from protocol entry
 D FULL^VALM1
 I '$$COMP(APCHDA,$O(^APCHSCMP("B","FLOWSHEETS",0))) W !!,"WARNING:  FLOWSHEETS has not been added to the Health Summary Structure.",!,"FLOWSHEETS will not display until they are part of the summary",!,"structure."
 W !!,"You can add a new FLOWSHEET by entering a new sequence number",!,"and FLOWSHEET name.  The FLOWSHEET must have been added using",!
 W "the option 'Create/Modify Flowsheet' in order to be selected.",!,"To remove a FLOWSHEET from this summary type select the FLOWSHEET",!
 W "by sequence number and type an '@',",!
 S DA=APCHDA,DIE="^APCHSCTL(",DR=7 D ^DIE,^XBFMK
 D BACK
 Q
ML ;EP - called from protocol entry
 D FULL^VALM1
 I '$$COMP(APCHDA,$O(^APCHSCMP("B","LABORATORY DATA",0))) W !!,"WARNING:  LABORATORY DATA has not been added to the Health Summary Structure.",! D
 .W "The LABS you put on the panel will not display until LABORATORY DATA is a part",!,"of the summary structure."
 W !!,"You can add a new LAB TEST by entering a new sequence number and",!,"the LAB TEST name.  To remove a LAB TEST from this summary type select the",!,"LAB TEST by name or sequence number and then enter an '@'.",!
 D FULL^VALM1
 S DA=APCHDA,DIE="^APCHSCTL(",DR=5 D ^DIE,^XBFMK
 D BACK
 Q
MP ;EP - called from protocol entry
 D FULL^VALM1
 I '$$COMP(APCHDA,$O(^APCHSCMP("B","MEASUREMENT PANELS",0))) W !!,"WARNING:  Measurement Panels has not been added to the Health Summary Structure.",!,"Measurement panels will not display until they are part of the summary",!,"structure."
 W !!,"You can add a new measurement panel by entering a new sequence number",!,"and measurement panel name.  The measurement panel must have been added using",!
 W "the option 'Create/Modify Measurement Panel' in order to be selected.",!,"To remove a measurement panel from this summary type select the measurement",!
 W "panel by sequence number and type an '@',",!
 S DA=APCHDA,DIE="^APCHSCTL(",DR=4 D ^DIE,^XBFMK
 D BACK
 Q
MS ;EP - called from protocol entry
 D FULL^VALM1
 W !!,"You can add a new component by entering a new order number and",!,"component name.  To remove a component from this summary type select the",!,"component by name or order and then enter an '@'.",!
 S DA=APCHDA,DIE="^APCHSCTL(",DR="[APCH MOD STRUCTURE]" D ^DIE,^XBFMK
 D BACK
 Q
PAUSE ;EP; -- ask user to press ENTER
 Q:IOST'["C-"
 NEW Y S Y=$$READ("E","Press ENTER to continue") D ^XBCLS Q
READ(TYPE,PROMPT,DEFAULT,HELP,SCREEN,DIRA) ;EP; calls reader, returns response
 NEW DIR,X,Y
 S DIR(0)=TYPE
 I $D(SCREEN) S DIR("S")=SCREEN
 I $G(PROMPT)]"" S DIR("A")=PROMPT
 I $G(DEFAULT)]"" S DIR("B")=DEFAULT
 I $D(HELP) S DIR("?")=HELP
 I $D(DIRA(1)) S Y=0 F  S Y=$O(DIRA(Y)) Q:Y=""  S DIR("A",Y)=DIRA(Y)
 D ^DIR
 Q Y
