ABMDTPAR ; IHS/ASDST/DMJ - Table Maintenance of 3P PARAMETERS ;  
 ;;2.6;IHS Third Party Billing;**1,3**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p8
 ;    Added code for UNCODED DX LAG TIME prompt
 ;
 ; IHS/SD/SDR - V2.5 P8 - IM12246/IM17548
 ;    Added code for default prompt for Reference and In-House CLIAs
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM14099
 ;    Fixed access to multiple; would error when user typed "??"
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM17482
 ;   Add site parameter for restricting PRV segment by insurer
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM19802
 ;   Fix multiple lookup
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20089
 ;   Added code for new prompt to override ISA08 value for Medicare
 ;
 ; IHS/SD/SDR - v2.5 p11 - Patient Statement
 ;   Added prompt for statement header line 2
 ;
 ; IHS/SD/SDR - v2.5 p13 - POA changes
 ;   Added new prompt
 ;
 ; IHS/SD/SDR - abm*2.6*1 - HEAT4158 - Added prompt for mammography cert#
 ;
 ; *********************************************************************
 ;
 W !
 K DTOUT,DUOUT
AFFL I '$D(^ABMDPARM(DUZ(2),1,0)) D
 .W !,"Site ",$P(^DIC(4,DUZ(2),0),U)," has not been initialized in 3P Billing Package."
 .W !,"I will now run option INITIALIZE SITE."
 .D ^ABMDSS
 Q:'$D(^ABMDPARM(DUZ(2),1,0))  S ABM("X")=$P(^(0),U)
 Q:'$D(^AUTTLOC(ABM("X"),0))  S ABM("LCD")=$P(^(0),U,7)
 S ABM("AFFL")=""
 S ABM("I")=0 F  S ABM("I")=$O(^AUTTLOC(ABM("X"),11,ABM("I"))) Q:'ABM("I")  S ABM("IDT")=$S($P(^(ABM("I"),0),U,2)]"":$P(^(0),U,2),1:9999999) I DT>$P(^(0),U)&(DT<ABM("IDT")) S ABM("AFFL")=$P(^(0),U,3)
 I ABM("AFFL")="" D SETAF G XIT:$D(DTOUT)!$D(DUOUT)
 S:ABM("AFFL")="" ABM("AFFL")=1
 S DA=1,DIE="^ABMDPARM(DUZ(2),"
 S DR=".34T"                      ; EMC File Preference
 S DR=DR_";S:X=""K"" Y=""@1"" S:X=""H"" Y=""@2"""
 S DR=DR_";.39T"
 S DR=DR_";S Y=""@1"""
 S DR=DR_";@2"
 S DR=DR_";.47T"                  ; Default EMC Path
 S DR=DR_";.23T"                  ; Facility to receive payments
 S DR=DR_";.26T"                  ; Printable name of payment site
 S DR=DR_";.09T"                  ; Current Default fee schedule
 S DR=DR_";.18T"                  ; Create bills for all patients
 S DR=DR_";I 'X S Y=.13"          ; Branching 
 S DR=DR_";.185T"                 ; Display bene patient all claims
 S DR=DR_";.13T"                  ; Require that queing be forced
 S DR=DR_";.14T"                  ; Display long ICP/CPT description
 S DR=DR_";.16T"                  ; Backbill limit
 S DR=DR_";.17T"                  ; Block 31 (HCFA 1500) to print
 S DR=DR_";I X'=3 S Y=.38"
 S DR=DR_";.37T"                  ; HCFA-1500 Signature
 S DR=DR_";.38T"                  ; UB-92 Signature
 S DR=DR_";.36T"                  ; Place of service code
 S DR=DR_";.24T"                  ; Bill Number suffix
 S DR=DR_";.33T"                  ; Append HRN to bill number
 S DR=DR_";.25T"                  ; Allow for CPT modifiers prompt
 S DR=DR_";.27T"                  ; Set prof. component Automatically
 S DR=DR_";.28T"                  ; Days inactive before purging
 S DR=DR_";.29T"                  ; Default version of HCFA-1500
 S DR=DR_";.32T"                  ; Default form for dental billing
 D ^DIE K DR Q:$D(Y)
 S DA(1)=DA
 S ABMFLD="15",ABMFLE="9002274.5" D MULTLKUP(ABMFLD,ABMFLE)  ;default unbillable clinics
 S ABMFLD="17",ABMFLE="9002274.5" D MULTLKUP(ABMFLD,ABMFLE)  ;default invalid prv discipline
 S ABMFLD="6",ABMFLE="9002274.5" D MULTLKUP(ABMFLD,ABMFLE)  ;unbillable insurers
 S DA=1,DIE="^ABMDPARM(DUZ(2),"
 S DR=".3T//P"  ;UB92 FL38
 S DR=DR_";.411"                  ; In-House CLIA
 S DR=DR_";.412"                  ; Reference Lab CLIA
 D ^DIE K DR Q:$D(Y)
 S DR=".48T" D ^DIE Q:$D(Y)
 S DR=".52T" D ^DIE Q:$D(Y)
 S DR=".49T" D ^DIE Q:$D(Y)
 S DR="212T" D ^DIE Q:$D(Y)
 ;S DR=".51T"  ;abm*2.6*1 HEAT4158
 S DR=".51T" D ^DIE Q:$D(Y)  ;abm*2.6*1 HEAT4158
 S DR=".54T" D ^DIE Q:$D(Y)  ;abm*2.6*1 HEAT4158
 ;D ^DIE  ;abm*2.6*1 HEAT4158
 I $P($G(^ABMDPARM(DUZ(2),1,5)),U)'=2 D
 .S DR=".53"
 .D ^DIE
 I $P($G(^ABMDPARM(DUZ(2),1,5)),U)=2 D
 .S DR=".53////@"  ;remove anything that might be there
 .D ^DIE
 Q:$D(Y)
 S DR=".311T" D ^DIE Q:$D(Y)
 S DR="211T" D ^DIE Q:$D(Y)  ;pt stmt
 S DR="214T" D ^DIE Q:$D(Y)  ;pt stmt dt abm*2.6*3
 S DR="213T" D ^DIE Q:$D(Y)  ;poa
 W !!,"RX DISPENSE FEES",!,"================"
 S DR=".03T;.41T;.42T;.43T;.44T;.45T;.46T" D ^DIE K DR Q:$D(Y)
 W ! S DR=11 D ^DIE K DR Q:$D(Y)
 G XIT:$D(Y)!$D(DTOUT)!$D(DUOUT)!$D(ABM("DIE-FAIL"))
 S DIE="^ABMDEXP(",DA=11,DR=1 D ^DIE Q:$D(Y)
 S DIE="^ABMDPARM(DUZ(2),",DA=1,DR=".15////Y" D ^DIE Q:$D(Y)
 S ABMFLD="19",ABMFLE="9002274.5" D MULTLKUP(ABMFLD,ABMFLE)
ITYPES ;ENTER INSURANCE TYPE TO EXPORT TO AREA OFFICE
 ;
 K DIR
 ;
XIT K DIE,ABM,DR
 Q
 ;
SETAF ;SET AFFILIATION
 W *7,!!?5,"The Affilation of "_$P(^AUTTLOC(ABM("X"),0),U,2)_" has not been Established!",!
 S DIE="^AUTTLOC(",DA=DUZ(2),DR=1101 D ^DIE
 Q
MULTLKUP(ABMFLD,ABMFLE) ;lookup/edit of 3p Parameters multiples
 N X,Y
 F  D  Q:$D(DTOUT)!($D(DUOUT))!(+$G(Y)<0)
 .S DA(1)=1
 .S DIC="^ABMDPARM(DUZ(2),"_DA(1)_","_ABMFLD_","
 .S DIC(0)="AEMLQ"
 .K DD,DO
 .S DIC("P")=$P(^DD(ABMFLE,ABMFLD,0),U,2)
 .D ^DIC
 .Q:Y<0
 .I $D(DTOUT)!$D(DUOUT) Q
 .I $P(Y,U,3)="" D  ;not a new entry
 ..S DIE=DIC
 ..S DA=+Y
 ..S DR=".01"
 ..D ^DIE
 Q
