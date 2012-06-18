BATPOST ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED ;
 ;;1.0;IHS ASTHMA REGISTER;;FEB 19, 2003
 ;
 ;
ENV ;EP 
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
 ;
POST ;EP
 NEW X
 S X=$$ADD^XPDMENU("BAT MENU SETUP","APCL TAXONOMY SETUP","TX",20)
 I 'X W "Attempt to add taxonomy setup option failed.." H 3
 S X=$$ADD^XPDMENU("BAT MENU PATIENT MANAGEMENT","APCHSBRW","BHS",80)
 I 'X W "Attempt to add health summary option failed.." H 3
 S X=$$ADD^XPDMENU("BAT MENU PATIENT MANAGEMENT","APCHSUM","HS",81)
 I 'X W "Attempt to add health summary option failed.." H 3
 ;install icd taxonomy of asthma dxs
 D ^BATTX
 D DRUGS
 D AST
 D HAST
 D BAT
 Q
AST ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","AST"))
 S X="AST",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000010;.04///[APCD AST];.06///ASTHMA;.07///0;.08///1"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding AST mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
HAST ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","HAST"))
 S X="HAST",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000001;.04///[APCD HAST];.06///Historical Asthma;.07///0;.08///0;.09///9000010.41;.12///Historical Asthma;.15///81;.16///86"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding HAST mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
BAT ;EP
 D ^XBFMK
 Q:$D(^APCHSUP("B","ASTHMA"))
 S X="ASTHMA",DIC(0)="L",DIC="^APCHSUP(",DIC("DR")="1100///D AST^APCHS9"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding health summary supplement failed." H 4
 K DIC,DD,D0,DO
 Q
 Q
 ;
 ;;
DRUGS ;set up drug taxonomies
 S ATXFLG=1
 S BATX="BAT ASTHMA RELIEVER MEDS" D DRUG1
 S BATX="BAT ASTHMA INHALED STEROIDS" D DRUG1
 S BATX="BAT ASTHMA CONTROLLER MEDS" D DRUG1
 K ATXFLG,BATX,BATDA,BATTX
 Q
DRUG1 ;
 W !,"Creating ",BATX," Taxonomy..."
 S BATDA=$O(^ATXAX("B",BATX,0))
 Q:BATDA  ;taxonomy already exisits
 S X=BATX,DIC="^ATXAX(",DIC(0)="L",DIADD=1,DLAYGO=9002226 D ^DIC K DIC,DA,DIADD,DLAYGO,I
 I Y=-1 W !!,"ERROR IN CREATING ",BATX," TAX" Q
 S BATTX=+Y,$P(^ATXAX(BATTX,0),U,2)=BATX,$P(^(0),U,8)=0,$P(^(0),U,9)=DT,$P(^(0),U,12)=173,$P(^(0),U,13)=0,$P(^(0),U,15)=50,^ATXAX(BATTX,21,0)="^9002226.02101A^0^0"
 S DA=BATTX,DIK="^ATXAX(" D IX1^DIK
 Q
 ;
