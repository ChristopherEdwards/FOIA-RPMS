VENPCCIT ; IHS/OIT/GIS - INSTALLATION TOOLS: ADD A NEW TEMPLATE FOR VER 2.5 ;
 ;;2.6;PCC+;;NOV 12, 2007
 ;
 ; 
 ; 
 N DIC,DA,DIK,DIR,X,Y,Z,%,%Y,VER25,RXFLAG,SEP,TIEN,FLD,TMN,TNM,GGIEN,KNM,KIEN
INIT S VER25=+$P($G(^VEN(7.5,$$CFG^VENPCCU,13)),U) ; PCC+ IS CONFIGURED FOR VER 2.5
 S SEP="----------------"
 S RXFLAG=0
 S X=$O(^PSRX("AD",9999999),-1) I X,$$FMDIFF^XLFDT(DT,X)<7 S RXFLAG=1 ; PHARMACY PKG IS IN ACTIVE USE
OLD K DIR,Y
 S DIR(0)="S^1:Add a new template;2:Edit an existing template;3:Delete an existing template;4:Exit",DIR("A")="Your choice"
 D ^DIR K DIR
 I 'Y!(Y=4) D ^XBFMK Q
 I Y'=1 S TIEN=$$LKUP Q:TIEN=""  S (TNM,FLD(.01))=$P($G(^VEN(7.41,TIEN,0)),U) ; GET TEMPLATE IEN AND NAME
 I Y=3 D DT(TIEN) G OLD  ; DELETE A CLINIC
 I Y=2 G TEDIT  ; EDIT A CLINIC
NAME ; TEMPLATE NAME
 W !!,"Enter the NAME of the new PCC+ template."
 W !,"This is the name that will be seen during the check-in process."
 W !,"Naming conventions-> "
 W !?3,"If your PCC+ system is used (& will be used) in only one facility:"
 W !?5,"<CLINIC NAME>"
 W !?5,"Examples: 'PODIATRY', or 'WALKIN'"
 W !?3,"Otherwise, if your PCC+ system covers multiple facilities: "
 W !?5,"<BRIEF SITE NAME> <CLINIC NAME>"
 W !?5,"Examples: 'ANMC NEUROLOGY' or 'WARM SPRINGS MEDICAL'",!
 W !?5,"Also, if you want to edit the properties of an existing template, enter the"
 W !?5,"the EXACT, full name of that template now"
NAME1 S DIR("?")="Name must be 3-30 uppercase letters.  Numbers and spaces OK also"
 S DIR(0)="FO^3:30",DIR("A")="Template name" D ^DIR
 I Y?1."^"!(Y="") G FIN
 S X=$TR(Y," ","") S X=$TR(X,"(","") S X=$TR(X,")","") S X=$TR(X,"-","") I X'?3.30UN W "  ??",!,DIR("?") G NAME1 ; NAME FAILED VALIDATION
 S (TNM,FLD(.01))=Y
 S Z=$O(^VEN(7.41,"B",TNM,0))
 I 'Z G HMN
 W !,"This template already exits.  Try again" W !! G NAME1
 ; 
TEDIT ; EP - EDIT TEMPLATE PROPERTIES ; TIEN MUST EXIT
HMN S FLD(.02)=25 ; HEADER MNEMONIC ; PATCHED BY GIS/OIT 10/15/05 ; PCC+ 2.5 PATCH 1
TMN ; TEMPLATE MNEMONIC
 W !!,"Enter this template's mnemonic..."
 W !?3,"The mnemonic is 1-10 lowercase characters/numbers"
 W !?3,"It is the first part of this template's file name on the print server"
 W !?3,"For example, 'neuro' is the mnemonic for the template 'neuro_template.doc"
TMN1 S DIR("?")="Name must be 1-10 lowercase letters. Imbedded numbers can be included as well."
 S DIR(0)="F^1:10",DIR("A")="Template mnemonic"
 S %=$O(^VEN(7.41,"B",FLD(.01),0))
 I % S DIR("B")=$P($G(^VEN(7.41,%,0)),U,3)
 D ^DIR
 I Y=U G NAME1
 I Y?2."^"!(Y="") G FIN
 I Y'?1.10LN W "  ??",!,DIR("?") G TMN1 ; MNEMONIC FAILED VALIDATION
 S (TMN,FLD(.03))=Y
 S DIC="^VEN(7.41,",DLAYGO=19707.41,DIC(0)="L"
 S X=FLD(.01)
 D ^DIC I Y=-1 W !!,"Update failed!" G FIN
 S (DA,TIEN)=+Y
 S DIE=DIC,DR=".02////^S X=FLD(.02);.03////^S X=FLD(.03)"
 L +^VEN(7.41,TIEN):0 I  D ^DIE L -^VEN(7.41,TIEN)
 K FLD
DX ; ICD PREFERENCES ; PATCHED BY GIS/OIT 10/15/05 ; PCC+ 2.5 PATCH 1
 W !!,SEP,"  ICD PREFERENCES  ",SEP
DX1 W !!,"Does this form contain Dx mail merge fields (ICD preferences)"
 S %=1
 D YN^DICN I %Y?1."^" G FIN
 I %=2 S FLD(1.2)="@" G DXDIE
DX2 W !!,"Count the number of Dx mail merge fields on this form"
 K DIR S DIR(0)="NO^1:60:0",DIR("A")="How many are there",DIR("B")="50"
 S %=$P($G(^VEN(7.41,TIEN,1)),U,2) I % S DIR("B")=%
 S %=$G(FLD(1.2)) I % S DIR("B")=%
 D ^DIR
 I Y=U G DX
 I Y?2."^" G FIN
 S FLD(1.2)=+Y
DXDIE D DIE(TIEN)
MSR ; MEASUREMENTS
 W !!,SEP,"  MEASUREMENTS  ",SEP
MSR1 W !!,"Does this form contain measurements"
 S %=1
 D YN^DICN
 I %Y=U W !!,SEP G DX
 I %Y?2."^" G FIN
 I %=2 D  G MSRDIE
 . F %=.15,14.07,14.08 S FLD(%)="@" ; GENERAL CLEANUP
 . Q
MSR2 W !,"Specify default measurement units ->"
 K DIR S DIR(0)="SO^0:NEVER METRIC;1:ALWAYS METRIC;2:METRIC UNTIL AGE 1",DIR("A")="Units",DIR("B")="NEVER METRIC"
 S %=$P($G(^VEN(7.41,TIEN,0)),U,15) I %'="" S DIR("B")=%
 I $L($G(FLD(.15))) S DIR("B")=FLD(.15)
 D ^DIR
 I Y="" G POV
 I Y=U G MSR1
 I Y?2."^" G FIN
 S FLD(.15)=Y
MSR3 W !!,"Will the Nurse Check-in Module be used with this form"
 S %=2
 I $P($G(^VEN(7.41,TIEN,14)),U,7) S %=1
 S Z=$G(FLD(14.7)) I $L(Z) S %=$S(Z=1:1,1:2)
 D YN^DICN
 I %Y=U G MSR2
 I %Y?2."^" G FIN
 S FLD(14.07)=$S(%=1:1,1:0)
 I %'=1 S FLD(14.08)="@" G MSRDIE
MSR4 W !!,"Specify the max length of the Chief Complaint narrative allowed on this form"
 K DIR S DIR(0)="NO^1:240:0",DIR("A")="Maximum length",DIR("B")="240"
 S %=$P($G(^VEN(7.41,TIEN,14)),U,8) I % S DIR("B")=%
 D ^DIR
 I Y=U G MSR3
 I Y?2."^" G FIN
 S FLD(14.08)=Y
MSRDIE D DIE(TIEN)
POV ; POVS AND PROBLEMS
 W !!,SEP,"  POVS AND PROBLEMS  ",SEP
POV1 W !!,"Does this form contain POVs and/or Active Problems"
 S %=1 D YN^DICN
 I %Y=U W !!,SEP G MSR
 I %Y?2."^" G FIN
 I %=2 D  G POVDIE
 . F %=1.1,2.12,5.21,2.13,5.15,5.16 S FLD(%)="@"
 . Q
POVN ; MAX NO OF POVS ; PATCHED BY GIS/OIT 10/15/05 ; PCC+ 2.5 PATCH 1
 W !!,"Count the number of PROBLEM/POV mail merge fields on this form"
 K DIR S DIR(0)="NO^1:60:0",DIR("A")="How many are there",DIR("B")="20"
 S %=$P($G(^VEN(7.41,TIEN,1)),U,1) I % S DIR("B")=%
 S %=$G(FLD(1.1)) I % S DIR("B")=%
 D ^DIR
 I Y=U G POV1
 I Y?2."^" G FIN
 S FLD(1.1)=+Y
POV2 W !!,"If the Onset Date has been stored in RPMS,",!,"want to display it with the POV/Problem"
 S %=2
 I $P($G(^VEN(7.41,TIEN,2)),U,12) S %=1
 S Z=$G(FLD(2.12)) I $L(Z) S %=$S(Z=1:1,1:2)
 D YN^DICN
 I %Y=U G POVN
 I %Y?2."^" G FIN
 S FLD(2.12)=$S(%=1:1,1:0)
POV3 W !!,"If the Visit Control # (VCN) has been stored in RPMS,",!,"want to display it with the POV/Problem"
 S %=2
 I $P($G(^VEN(7.41,TIEN,5)),U,21) S %=1
 S Z=$G(FLD(5.21)) I $L(Z) S %=$S(Z=1:1,1:2)
 D YN^DICN
 I %Y=U G POV2
 I %Y?2."^" G FIN
 S FLD(5.21)=$S(%=1:1,1:0)
POV4 W !!,"Show only PROBLEMS (no POVs) in the POV/Problem list"
 S %=2
 I $P($G(^VEN(7.41,TIEN,2)),U,13) S %=1
 S Z=$G(FLD(2.13)) I $L(Z) S %=$S(Z=1:1,1:2)
 D YN^DICN
 I %Y=U G POV3
 I %Y?2."^" G FIN
 S FLD(2.13)=$S(%=1:1,1:0)
POV5 W !!,"Want to block the display of ICD codes entered at other facilities"
 S %=2
 I $P($G(^VEN(7.41,TIEN,5)),U,15) S %=1
 S Z=$G(FLD(5.15)) I $L(Z) S %=$S(Z=1:1,1:2)
 D YN^DICN
 I %Y=U G POV4
 I %Y?2."^" G FIN
 S FLD(5.15)=$S(%=1:1,1:0)
POV6 K DIR S DIR("?")="You can extend the length of the provider narrative up to 80 characters"
 W !!,DIR("?")
 S DIR(0)="NO^1:80:0",DIR("A")="Maximum narrative length",DIR("B")="27"
 S %=$P($G(^VEN(7.41,TIEN,5)),U,16) I % S DIR("B")=%
 I $L($G(FLD(5.16))) S DIR("B")=FLD(5.16)
 D ^DIR
 I Y=U G POV5
 I Y?2."^" G FIN
 S FLD(5.16)=Y
POVDIE D DIE(TIEN) ; ENTER FIELD DATA INTO RPMS AND CLEAN OUT FLD ARRAY
RX ; PRESCRIPTIONS
 W !!,SEP,"  PRESCRIPTIONS  ",SEP
RX1 W !!,"Does this form contain a Prescription List"
 S %=1 D YN^DICN
 I %Y=U W !!,SEP G POV
 I %Y?2."^" G FIN
 I %=2 D  G RXDIE
 . F %=.12,.14,2.11,2.4,2.6,2.7,2.8,2.9,14.01,14.02,14.03,14.04,14.05 S FLD(%)="@"
 . Q
RXN ; MAX RXS ; PATCHED BY GIS/OIT 10/15/05 ; PCC+ 2.5 PATCH 1
 W !!,"Count the number of Rx mail merge fields on this form"
 K DIR S DIR(0)="NO^1:60:0",DIR("A")="How many are there",DIR("B")="15"
 S %=$P($G(^VEN(7.41,TIEN,2)),U,4) I % S DIR("B")=%
 S %=$G(FLD(2.4)) I % S DIR("B")=%
 D ^DIR
 I Y=U G RX1
 I Y?2."^" G FIN
 S FLD(2.4)=+Y
RX2 W !!,"You can limit the time that a drug is displayed beyond it run-out date"
 K DIR S DIR(0)="NO^1:999:0",DIR("A")="Maximum display duration (days)",DIR("B")="75"
 S %=$P($G(^VEN(7.41,TIEN,2)),U,6) I % S DIR("B")=%
 I $L($G(FLD(2.6))) S DIR("B")=FLD(2.6)
 D ^DIR
 I Y=U G RXN
 I Y?2."^" G FIN
 I Y S FLD(2.6)=Y
RX3 W !!,"Want to display only active prescriptions"
 S %=2
 I $P($G(^VEN(7.41,TIEN,2)),U,8) S %=1
 S Z=$G(FLD(2.8)) I $L(Z) S %=$S(Z=1:1,1:2)
 D YN^DICN
 I %Y=U G RX2
 I %Y?2."^" G FIN
 S FLD(2.8)=$S(%=1:1,1:0)
RX4 W !!,"Want to hide redundant prescriptions"
 S %=2
 I $P($G(^VEN(7.41,TIEN,2)),U,9) S %=1
 S Z=$G(FLD(2.9)) I $L(Z) S %=$S(Z=1:1,1:2)
 D YN^DICN
 I %Y=U G RX3
 I %Y?2."^" G FIN
 S FLD(2.9)=$S(%=1:1,1:0)
 W !!,"You can now specify the max length of the RX and its components."
RX5 K DIR S DIR(0)="NO^1:80:0",DIR("A")="Max length of Medication name",DIR("B")="30"
 S %=$P($G(^VEN(7.41,TIEN,14)),U,2) I % S DIR("B")=%
 I $L($G(FLD(14.02))) S DIR("B")=FLD(14.02)
 D ^DIR
 I Y=U G RX2
 I Y?2."^" G FIN
 I Y S FLD(14.02)=Y
RX6 K DIR S DIR(0)="NO^1:199:0",DIR("A")="Max length of Sig",DIR("B")="40"
 S %=$P($G(^VEN(7.41,TIEN,14)),U,3) I % S DIR("B")=%
 I $L($G(FLD(14.03))) S DIR("B")=FLD(14.03)
 D ^DIR
 I Y=U G RX5
 I Y?2."^" G FIN
 I Y S FLD(14.03)=Y
 ; I 'RXFLAG G RX14
RX8 K DIR S DIR(0)="NO^1:999:0",DIR("A")="Max length of entire prescription",DIR("B")="30"
 S %=$P($G(^VEN(7.41,TIEN,14)),U) I % S DIR("B")=%
 I $L($G(FLD(14.01))) S DIR("B")=FLD(14.01)
 D ^DIR
 I Y=U G RX6
 I Y?2."^" G FIN
 I Y S FLD(14.01)=Y
RX9 W !!,"Want to hide the Rx reminder note"
 S %=2
 I $P($G(^VEN(7.41,TIEN,0)),U,12) S %=1
 S Z=$G(FLD(.12)) I $L(Z) S %=$S(Z=1:1,1:2)
 D YN^DICN
 I %Y=U G RX8
 I %Y?2."^" G FIN
 S FLD(.12)=$S(%=1:1,1:0)
RX10 W !!,"Want to show the prescribing provider"
 S %=2
 I $P($G(^VEN(7.41,TIEN,0)),U,14) S %=1
 S Z=$G(FLD(.14)) I $L(Z) S %=$S(Z=1:1,1:2)
 D YN^DICN
 I %Y=U G RX9
 I %Y?2."^" G FIN
 S FLD(.14)=$S(%=1:1,1:0)
RX11 W !!,"Want to display the Rx issue date"
 S %=2
 I $P($G(^VEN(7.41,TIEN,2)),U,11) S %=1
 S Z=$G(FLD(2.11)) I $L(Z) S %=$S(Z=1:1,1:2)
 D YN^DICN
 I %Y=U G RX10
 I %Y?2."^" G FIN
 S FLD(2.11)=$S(%=1:1,1:0)
RX12 W !!,"Want to show chronic meds only"
 S %=2
 I $P($G(^VEN(7.41,TIEN,2)),U,7) S %=1
 S Z=$G(FLD(2.7)) I $L(Z) S %=$S(Z=1:1,1:2)
 D YN^DICN
 I %Y=U G RX11
 I %Y?2."^" G FIN
 S FLD(2.7)=$S(%=1:1,1:0)
RX13 W !!,"Want to sort the list by 'chronic' & 'incidental' Rxs"
 S %=2
 I $P($G(^VEN(7.41,TIEN,14)),U,5) S %=1
 D YN^DICN
 I %Y=U G RX12
 I %Y?2."^" G FIN
 S FLD(14.05)=$S(%=1:1,1:0)
RXDIE D DIE(TIEN)
HMR ; EP - HEALTH MAINTENANCE REMINDERS
 W !!,SEP,"  HEALTH MAINTENANCE REMINDERS  ",SEP
HMR1 W !!,"Does this form contain reminders"
 S %=1
 D YN^DICN
 I %Y=U W !!,SEP G RX
 I %Y?2."^" G FIN
 I %=2 D  G HMRDIE
 . F %=5.01,5.02,5.03,15.01,15.02 S FLD(%)="@" ; GENERAL CLEANUP
 . Q
HMR2 W !!,"Want to use the new surveillance list - !RECOMMENDED!"
 S %=1
 I $P($G(^VEN(7.41,TIEN,5)),U)=0 S %=2
 S Z=$G(FLD(5.01)) I $L(Z) S %=$S(Z=1:1,1:2)
 D YN^DICN
 I %Y=U G HMR1
 I %Y?2."^" G FIN
 S FLD(5.01)=$S(%=1:1,1:0)
HMR3 W !!,"When displaying reminders, hide last date & result"
 S %=2
 I $P($G(^VEN(7.41,TIEN,5)),U,2)=1 S %=1
 S Z=$G(FLD(5.02)) I $L(Z) S %=$S(Z=1:1,1:2)
 D YN^DICN
 I %Y=U G HMR2
 I %Y?2."^" G FIN
 S FLD(5.02)=$S(%=1:1,1:0)
HMR4 W !!,"When displaying reminders, hide forecasts if not 'due now'"
 S %=2
 I $P($G(^VEN(7.41,TIEN,5)),U,3)=1 S %=1
 S Z=$G(FLD(5.03)) I $L(Z) S %=$S(Z=1:1,1:2)
 D YN^DICN
 I %Y=U G HMR3
 I %Y?2."^" G FIN
 S FLD(5.03)=$S(%=1:1,1:0)
HMR5 W !!,"You can hide 'refusals' that are old or 'stale'."
 K DIR S DIR(0)="NO^1:60:0"
 S DIR("A")="Maximum age of a refusal (months)",DIR("B")="60"
 S %=$P($G(^VEN(7.41,TIEN,15)),U) I % S DIR("B")=%
 I $L($G(FLD(15.01))) S DIR("B")=FLD(15.01)
 D ^DIR
 I Y=U G HMR4
 I Y?2."^" G FIN
 I Y S FLD(15.01)=Y
HMR6 W !!,"Include patient education topics in the refusal list"
 S %=2
 I $P($G(^VEN(7.41,TIEN,15)),U,2)=1 S %=1
 D YN^DICN
 I %Y=U G HMR5
 I %Y?2."^" G FIN
 S FLD(15.02)=$S(%=1:1,1:0)
HMRDIE D DIE(TIEN)
 G LAB^VENPCCIX ; CONTINUE IN VENPCCIX.  THIS ROUTINE IS GETTING TOO LONG!!!
 ; 
FIN D ^XBFMK ; EP - CLEANUP
 Q
 ;
DT(DA) ; EP - DELETE A TEMPLATE
 N DIC,DIK
 I '$D(^VEN(7.41,+$G(DA),0)) Q  ; NOTHING TO DELETE
 W !!,"Are you sure you want to completely delete this template" S %=0
 D YN^DICN
 I %'=1 W !,"Nothing deleted..." D ^XBFMK Q
 S DIK="^VEN(7.41,"
 D ^DIK
 W !,"Template deleted"
 D ^XBFMK
 Q
 ; 
LKUP() ; EP - LOOK UP A PCC+ TEMPLATE
 N DIC,X,Y,CIEN
 S DIC="^VEN(7.41,"
 S DIC(0)="AEQM"
 W "PCC+ Template: "
 D ^DIC
 I Y=-1 S TIEN=""
 E  S TIEN=+Y
 D ^XBFMK
 Q TIEN
 ; 
DIE(DA) ; EP - UPDATE FILEMAN FIELDS
 N DR,DIE
 S DIE="^VEN(7.41,"
 S DR="",FLD=0
 F  S FLD=$O(FLD(FLD)) Q:'FLD  D
 . I $L(DR) S DR=DR_";"
 . S DR=DR_FLD_"////^S X=FLD("_FLD_")"
 . Q
 L +^VEN(7.41,DA):0 I  D ^DIE L -^VEN(7.41,DA)
 K FLD
 Q
 ; 
