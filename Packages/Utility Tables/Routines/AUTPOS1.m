AUTPOS1 ; IHS/DIRM/JDM/DFM - POST INIT; [ 11/25/97  12:34 PM ]
 ;;98.1;IHS DICTIONARIES (POINTERS);;NOV 25, 1997
 ;
 ;
UPDATE ;EP - update fields in AUT dictionaries
 D ^XBKVAR
 I DUZ(0)'="@" W !!,"SORRY, YOU MUST HAVE PROGRAMMER ACCESS (Variable DUZ(0) must = '@'.)",!,"POST INITS NOT RUN - PLEASE DO SO LATER BY RUNNING RTN '^AUTPOS1' (D ^AUTPOS1)." Q
 W !!,"Many AUT tables will now be updated.  This will take a while.",!
 W !,"Please have your aux port printer turned ON.  THANKS."
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="Y" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 I 'Y W !!,"BYE - POST INIT NOT RUN - PLEASE RUN IT LATER BY RUNNING ^AUTPOS1." Q
 D MEAS
 D MEASTYPE
 D RCAT
 D RECODE^AUTPOS2 ;update recode apc/icd file
 D RECINJ ; update recode injury file
 D REINDEX1 ;reindex AD on 9999999.08 and C on 9999999.12
 D IMM ;update immunization entries with CPT codes
 D EXAM ;update exam table
 D SKINTEST
 D HF
 D PPT ;do presentation types
 D EOJ
 Q
EOJ ;
 K AUTCPT,AUTJ,AUTMOD,AUTT,AUTTXT,AUTVAL,AUTX,AUTY
 K DIC,DD,DLAYGO,DR,DLAYGO,X,Y,D,DIU
 D ^XBFMK
 W !!,"All done with AUTT post init.",!
 Q
REINDEX1 ;
 W !,"Re-indexing a new index on RECODE INJURY"
 S DIK="^AUTTINJ(",DIK(1)=".04^C" D ENALL^DIK
 W !,"Re-indexing a new index on RECODE APC/ICD"
 S DIK="^AUTTRCD(",DIK(1)=".06^AC" D ENALL^DIK
 Q
IMM ;add cpt codes to immunization entries
 W !,"Adding CPT codes to immunization table."
 S AUTT="IMMCPT" F AUTJ=1:1 S AUTX=$T(@AUTT+AUTJ),AUTVAL=$P(AUTX,";;",2) Q:AUTVAL="QUIT"!(AUTVAL="")  D
 .S AUTY=0 F  S AUTY=$O(^AUTTIMM("C",AUTVAL,AUTY)) Q:AUTY'=+AUTY  D
 ..S DA=AUTY,DIE="^AUTTIMM(",DR=".11///"_$P(AUTX,";;",3) D ^DIE I $D(Y) W !,"updating immunization ",AUTVAL,"failed. Notify database mgr. of incomplete Immunization file.."
 ..Q
 .Q
 Q
MEAS ;add cpt code to tonometry measurement type
 W !,"Adding CPT code to measurement types."
 S DA=$O(^AUTTMSR("B","TON",0)) I 'DA W !,"Could not find Tonometry measurement type.  Skipping Tonometry Measurement update." Q
 S DIE="^AUTTMSR(",DR=".11///92100" D ^DIE I $D(Y) W !,"Could not enter CPT code in tonometry file. Notify database mgr." Q
 Q
MEASTYPE ;
 W !,"Adding Measurement Types (Edema and Presentation)",!
 S X="ED",DIC="^AUTTMSR(",DIC(0)="L",DLAYGO=9999999.07,DIC("DR")=".02////EDEMA;.03////55" D ^DIC K DIC,DD,DLAYGO,DA,D0
 S X="PR",DIC="^AUTTMSR(",DIC(0)="L",DLAYGO=9999999.07,DIC("DR")=".02////PRESENTATION;.03////56" D ^DIC K DIC,DD,DLAYGO,DA,D0
 S DA=$O(^AUTTMSR("B","EFF",0)) I DA S DIE="^AUTTMSR(",DR=".01///EF" D ^DIE
 S DA=$O(^AUTTMSR("B","STN",0)) I DA S DIE="^AUTTMSR(",DR=".01///SN" D ^DIE
 S X="CXD",DIC="^AUTTMSR(",DIC(0)="L",DLAYGO=9999999.07,DIC("DR")=".02////CERVIX DILATATION;.03////57" D ^DIC K DIC,DD,DLAYGO,DA,D0
 S X="EF",DIC="^AUTTMSR(",DIC(0)="L",DLAYGO=9999999.07,DIC("DR")=".02////EFACEMENT;.03////58" D ^DIC K DIC,DD,DLAYGO,DA,D0
 S X="SN",DIC="^AUTTMSR(",DIC(0)="L",DLAYGO=9999999.07,DIC("DR")=".02////STATION (PREGNANCY);.03////59" D ^DIC K DIC,DD,DLAYGO,DA,D0
 Q
HF ;
 W !,"Adding a few new health factors"
 ;add current smoker & smokeless
 ;exposure to environmental tobacco smoke
 ;smoker in home
 S X="CURRENT SMOKER & SMOKELESS",DIC="^AUTTHF(",DIC(0)="L",DLAYGO=9999999.64 D ^DIC K DIC,DD,DLAYGO,DA,D0
 S X="EXPOSURE TO ENVIRONMENTAL TOBACCO SMOKE",DIC="^AUTTHF(",DIC(0)="L",DLAYGO=9999999.64 D ^DIC K DIC,DD,DLAYGO,DA,D0
 S X="SMOKER IN HOME",DIC="^AUTTHF(",DIC(0)="L",DLAYGO=9999999.64 D ^DIC K DIC,DD,DLAYGO,DA,D0
 Q
SKINTEST ;
 W !,"Adding CPT code to skin test entries."
 S AUTT="SKCPT" F AUTJ=1:1 S AUTX=$T(@AUTT+AUTJ),AUTVAL=$P(AUTX,";;",2) Q:AUTVAL="QUIT"!(AUTVAL="")  D
 .S AUTY=0 F  S AUTY=$O(^AUTTSK("C",AUTVAL,AUTY)) Q:AUTY'=+AUTY  D
 ..S DA=AUTY,DIE="^AUTTSK(",DR=".11///"_$P(AUTX,";;",3) D ^DIE I $D(Y) W !,"updating skin test code ",AUTVAL,"failed. Notify database mgr. of incomplete SKIN TEST file."
 ..Q
 .Q
 Q
EXAM ;
 W !,"Adding CPT code to exam entries."
 S AUTT="EXAMCPT" F AUTJ=1:1 S AUTX=$T(@AUTT+AUTJ),AUTVAL=$P(AUTX,";;",2) Q:AUTVAL="QUIT"!(AUTVAL="")  D
 .S AUTY=0 F  S AUTY=$O(^AUTTEXAM("C",AUTVAL,AUTY)) Q:AUTY'=+AUTY  D
 ..S DA=AUTY,DIE="^AUTTEXAM(",DR=".11///"_$P(AUTX,";;",3) D ^DIE I $D(Y) W !,"Updating exam ",AUTVAL,"failed. Notify database mgr. of incomplete EXAM file."
 ..Q
 .Q
 Q
RCAT ;update recode category 9999999.081, field .01
 W !,"Adding APC Recode Categories to Recode Category File.."
 S DIC="^AUTTRCDC(",DIC(0)="L"
 S AUTT="RCDC" F AUTJ=1:1 S AUTX=$T(@AUTT+AUTJ),AUTVAL=$P(AUTX,";;",2) Q:AUTVAL="QUIT"!(AUTVAL="")  D
 .S X=AUTVAL D ^DIC I Y=-1 W "ADDING of Category ",AUTVAL," failed.. skipping.  Notify Database Manager."
 .Q
 K DIC,DD,DLAYGO,DA,DR
 Q
RECINJ ;update .02 and .04 of RECODE INJURY FILE
 W !,"Adding Narrative and E-Codes to APC Injury code table..."
 S AUTT="INJ02" F AUTJ=1:1 S AUTX=$T(@AUTT+AUTJ),AUTVAL=$P(AUTX,";;",2) Q:AUTVAL="QUIT"!(AUTVAL="")  D
 .S AUTCAT=$P(AUTX,";;",4)
 .S AUTICD=$P(AUTX,";;",3),AUTICD=$O(^ICD9("AB",AUTICD,0))
 .I AUTICD="" W !!,"Can't find ICD code ",$P(AUTX,";;",3)," for APC code ",AUTVAL
 .S AUTICD="`"_AUTICD
 .S DA=$O(^AUTTRIJ("B",AUTVAL,0)) I DA="" W !,"Can't find entry ",AUTVAL," to edit.",! Q
 .S DIE="^AUTTRIJ(",DR=".04///"_AUTCAT_";.02///"_AUTICD
 .D ^DIE I $D(Y) W !,"Editing APC INJURY Code ",AUTVAL," failed, notify database mgr. of incomplete RECODE INJURY file."
 .Q
 Q
PPT ;EP - add presentation types to presentation type file
 W !,"Adding Pregnancy Presentation Types to Presentation Type file..."
 S DIC="^AUTTPPT(",DIC(0)="L"
 S AUTT="PPTTYPE" F AUTJ=1:1 S AUTX=$T(@AUTT+AUTJ),AUTVAL=$P(AUTX,";;",2) Q:AUTVAL="QUIT"!(AUTVAL="")  D
 .S X=AUTVAL,DIC("DR")=".02////"_$P(AUTX,";;",3)_";.03////"_$P(AUTX,";;",4),DLAYGO=9999999.87 D ^DIC K DA I Y=-1 W !,"Adding Presentation Type ",X," failed. Notify database mgr. of incomplete PRESENTATION TYPE file.",!
 .Q
 K DIC,DD,DLAYGO,DR,DA,DD
 Q
EOJ2 ;
 K AUTX,AUTVAL,AUTICD,AUTCAT
 Q
PPTTYPE ; presentation types
 ;;VERTEX;;1;;VT
 ;;COMPLETE BREECH;;2;;CB
 ;;DOUBLE FOOTLING;;3;;DF
 ;;SINGLE FOOTLING;;4;;SF
 ;;FRANK BREECH;;5;;FB
 ;;FACE;;6;;FA
 ;;UNSPECIFIED BREECH;;7;;UB
 ;;TRANSVERSE;;8;;TR
 ;;OTHER;;9;;OT
 ;;UNKNOWN;;U;;UNK
 ;;QUIT
RCDC ;
 ;;INFECTIVE & PARASITIC DIS.
 ;;NEOPLASMS
 ;;ENDOCR., NUTR., & METAB. DIS.
 ;;DIS. OF BLOOD & BLOOD-FORMING ORGANS
 ;;MENTAL DISORDERS
 ;;DIS. OF NERVOUS SYSTEM
 ;;EYE DISEASES
 ;;EAR DISEASES
 ;;DIS. OF CIRCULATORY SYSTEM
 ;;DIS. OF RESPIRATORY SYSTEM
 ;;DIS. OF DIGESTIVE SYSTEM
 ;;DIS. OF URINARY TRACT
 ;;DIS. OF FEMALE GENITALIA & BREAST
 ;;PREG., CHILDBIRTH & THE PUERPERIUM
 ;;DIS. OF SKIN & SUBCUTANEOUS TISSUE
 ;;MUSCULOSKEL SYSTEM & CONNECT. TISSUE
 ;;CONGENITAL ANOMALIES
 ;;SYMPTOMS & ILL-DEFINED CONDITION
 ;;SUPPLEMENTAL
 ;;ACCID. POISONINGS AND VIOLENCE
 ;;ALL DIS., MALE GENIT. (EXCL VD)
 ;;CAUSES OF PERNATAL MORB. & MORT.
 ;;QUIT
INJ02 ;
 ;;01;;E819.9;;MOTOR VEHICLE ACCIDENT
 ;;03;;E838.9;;WATER TRANSPORT
 ;;04;;E844.9;;AIR TRANSPORT
 ;;05;;E866.9;;ACCIDENTAL POISONING
 ;;06;;E888.;;ACCIDENTAL FALLS
 ;;07;;E899.;;FIRES AND FLAMES
 ;;08;;E904.9;;ENVIRONMENTAL FACTORS
 ;;09;;E905.9;;STINGS AND VENOMS
 ;;10;;E906.9;;ANIMAL RELATED, INCLUDING BITES
 ;;11;;E910.9;;DROWNING AND SUBMERSION
 ;;12;;E920.9;;CUTTING AND PIERCING OBJECTS
 ;;13;;E922.9;;FIREARMS ACCIDENTS
 ;;14;;E919.9;;MACHINERY
 ;;15;;E958.9;;SUICIDE ATTEMPT
 ;;16;;E968.9;;INJ. PURPOSELY INFLICTED BY OTHERS
 ;;17;;E967.9;;BATTERED CHILD
 ;;18;;E988.9;;UNDETERMINED CAUSE
 ;;19;;E988.8;;OTHER CAUSES
 ;;QUIT
IMMCPT ;
 ;;01;;
 ;;02;;90718
 ;;03;;90701
 ;;04;;90703
 ;;05;;90714
 ;;06;;90712
 ;;07;;90713
 ;;08;;
 ;;09;;
 ;;10;;
 ;;11;;90705
 ;;12;;90724
 ;;13;;90725
 ;;14;;90706
 ;;15;;90704
 ;;16;;90728
 ;;17;;90707
 ;;18;;90708
 ;;19;;90732
 ;;31;;90717
 ;;32;;
 ;;33;;90726
 ;;34;;90702
 ;;35;;90737
 ;;37;;90737
 ;;38;;90737
 ;;39;;90737
 ;;40;;90730
 ;;41;;90716
 ;;42;;90700
 ;;QUIT
EXAMCPT ;;
 ;;01;;
 ;;02;;
 ;;03;;
 ;;04;;
 ;;05;;
 ;;06;;
 ;;07;;
 ;;08;;
 ;;09;;
 ;;10;;
 ;;11;;
 ;;12;;
 ;;14;;
 ;;15;;57410
 ;;16;;
 ;;17;;92506
 ;;18;;
 ;;19;;92081
 ;;20;;
 ;;21;;92502
 ;;22;;
 ;;23;;92551
 ;;24;;92552
 ;;25;;92567
 ;;26;;92100
 ;;27;;
 ;;28;;
 ;;29;;
 ;;QUIT
SKCPT ;
 ;;23;;86490
 ;;24;;86585
 ;;21;;86580
 ;;22;;
 ;;20;;86585
 ;;QUIT
