AQAOEDTA ; IHS/ORDC/LJF - STUFF PCC DATA INTO OCC ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn is called by ^AQAOEDTP if PCC visit is coded for section
 ;user is editing.  It will stuff any or all of the PCC data items into
 ;the appropriate QI OCC file.
 ;
CHOOSE ;ENTRY POINT to ask user to add PCC data for inclusion under an occ
 N AQAOX,AQAOI,DIR
 K DIR S DIR(0)="LO^0:"_AQAOCNT_"^K:X#1 X"
 S DIR("A")="Choose which PCC items are RELEVANT for this occurrence, if any"
 S DIR("?",1)="For ease of data entry, you can choose any or all of"
 S DIR("?",2)="these PCC items to be linked to your occurrence.  You"
 S DIR("?",3)="may choose a range (1-2 or 3,6) OR type in 0 (zero) to"
 S DIR("?",4)="have ALL of these linked to your occurrence."
 S DIR("?")=" " D ^DIR Q:$D(DIRUT)  Q:Y=-1
 ;
 I +Y=0 S Y="" F I=1:1:AQAOCNT S Y=Y_I_"," ;user chose ALL
 S AQAOX=Y F AQAOI=1:1 S X=$P(AQAOX,",",AQAOI) Q:X=""  D
 .K DD,DO,DIC S DIC=AQAOGBL,DIC(0)="LZ",DLAYGO=AQAOFL,X=AQAOA(+X)
 .I AQAOGBL="^AQAOCC(6," S X=X_";PSDRUG("
 .S DIC("DR")=".02////"_AQAOIFN_";.03////"_AQAOPAT
 .D FILE^DICN Q:Y=-1
 .K DIE,DA,DR S DIE=AQAOGBL,DA=+Y,DIDEL=AQAOFL
 .S DR=AQAOFLD_"-E1 FIRST]"
 .D ^DIE
 W ! Q
