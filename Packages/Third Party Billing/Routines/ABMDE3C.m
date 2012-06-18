ABMDE3C ; IHS/ASDST/DMJ - Edit Page 3 - QUESTIONS - part 4 ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**6**;NOV 12, 2009
 ; IHS/DSD/DMJ - 5/1/98 -  NOIS NCA-0598-180002
 ;  Modified to set Admission Type, node 5, if it does not already exist
 ; IHS/SD/SDR - v2.5 p3 - 2/26/2003 - NDA-0402-180192 - Added new block 19 stuff
 ; IHS/SD/SDR - v2.5 p5 - 5/17/04 - Added code to change from PATIENT to DISCHARGE STATUS
 ; IHS/SD/SDR v2.5 p5 - 5/17/04 - Added code for new prompt for refer. phys. person class
 ; IHS/SD/SDR v2.5 p6 - 7/14/04 - IM14117 - Modified code to prompt for either
 ;     Person Class, Provider Class, or taxonomy code.  One of the three must be entered
 ; IHS/SD/SDR v2.5 p8 - IM14016/IM15234/IM15615 - Fix Prior Authorization field
 ; IHS/SD/SDR V2.5 P8 - IM14693/IM16105 - Added code for Number of Enclosures (32)
 ; IHS/SD/SDR - V2.5 P8 - IM12246/IM17548 - Added Reference and In-House CLIA Numbers
 ; IHS/SD/SDR - v2.5 p9 - IM19291 - Supervising provider and UPIN
 ; IHS/SD/SDR - v2.5 p9 - IM18516 - Delayed Reason Code
 ; IHS/SD/SDR - v2.5 p9 - IM19062 - allow employment related to be "N"
 ; IHS/SD/SDR v2.5 p11 - NPI
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - added question 36 HEARING/VISION RX DATE
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - added start/end disability dates
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - added assumed/relinquished care dates
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - added property/casualty date of 1st contact
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - added patient paid amount
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - added spinal manipulation cond code
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - added vision condition info
 ;
 ;**********************************************************************
 ;
9 W ! S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".86["_ABM("#")_"] Date of First Symptom" D ^DIE K DR
 I X>ABMP("VDT") W *7,!!,"ERROR: Date can not be after the Visit Date (",$$HDT^ABMDUTL(ABMP("VDT")),")!" S DR=".86///@" D ^DIE G 9
 Q
 ;
11 W ! S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".87["_ABM("#")_"] Date First Consulted for this Condition" D ^DIE K DR
 I X>ABMP("VDT") W *7,!!,"ERROR: Date can not be after the Visit Date (",$$HDT^ABMDUTL(ABMP("VDT")),")!" S DR=".87///@" D ^DIE G 11
 Q
 ;
12 W ! S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".88["_ABM("#")_"] Name of Referring Physician" D ^DIE
 I X="",$P($G(^ABMDCLM(DUZ(2),DA,8)),U,11)]"" S DR=".884///@;.885///@;.886///@;.887///@;.888///@;.889///@" D ^DIE Q
 I X]"",$E(ABM("QU"),$L(ABM("QU")))="B" D
 .S ABMNPIU=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 .I ABMNPIU="B"!(ABMNPIU="N") D
 ..S DR=".889   Referring Physician NPI"
 ..D ^DIE
 .I ABMNPIU'="N" D
 ..S DR=".884    Referring Physician ID Qualifier"
 ..S DR=DR_";.885    Referring Physician I.D. No"
 ..D ^DIE
 .I $P($G(^ABMDCLM(DUZ(2),DA,8)),U,11)'="" D  ;only ask if UPIN was entered
 ..S ABMTXFLG=0
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,13)'="" D  ;Person Class
 ...W !!,"Person Class already entered:  ",$P($G(^USC(8932.1,$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),8),U,13),0)),U)
 ...S ABMTXFLG=1
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,14)'="" D  ;Provider Class
 ...W !!,"Provider Class already entered:  ",$P($G(^DIC(7,$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),8),U,14),9999999)),U)_"  "_$P($G(^DIC(7,$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),8),U,14),0)),U)
 ...S ABMTXFLG=1
 ..I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,15)'="" D  ;Taxonomy Code
 ...W !!,"Taxonomy Code already entered:  ",$P($G(^ABMPTAX($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),8),U,15),0)),U)
 ...S ABMTXFLG=1
 ..F  D  Q:ABMTXFLG=1
 ...S DIR(0)="SO^1:Person Class;2:Provider Class;3:Taxonomy Code"
 ...S DIR("A")="Which would you like to enter?"
 ...D ^DIR K DIR
 ...I Y=1 D  Q  ;Person Class
 ....S DR=".887////@;.888////@;.886          Referring Physician Person Class..:"
 ....D ^DIE
 ....I X'="" S ABMTXFLG=1
 ...I Y=2 D  Q  ;Provider Class
 ....S DR=".886////@;.888////@;.887          Referring Physician Provider Class..:"
 ....D ^DIE
 ....I X'="" S ABMTXFLG=1
 ...I Y=3 D  Q  ;Taxonomy code
 ....S DR=".886////@;.887////@;.888          Referring Physician Taxonomy Code..:"
 ....D ^DIE
 ....I X'="" S ABMTXFLG=1
 .K DR
 Q
 ;
10 W ! S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".89["_ABM("#")_"] Similiar Illness or Injury Date" D ^DIE K DR
 I X>ABMP("VDT") W *7,!!,"ERROR: Date can not be after the Visit Date (",$$HDT^ABMDUTL(ABMP("VDT")),")!" S DR=".89///@" D ^DIE G 10
 Q
 ;
4 K DIR W ! S DIR(0)="Y",DIR("A")="["_ABM("#")_"] Was Visit Employment Related",DIR("?")="Was the Reason for the Visit Related to Employment"
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),$P(^(9),U,1)="Y" S DIR("B")="Y"
 E  S DIR("B")="N"
 D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABM("Y")=Y
 I Y=1 G EMCODE
 I ABM("Y")=0,$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),$P(^(9),U,1)="Y" S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".91///@;.92///@;.93///@;.94///@;.95///@;.96///@" D ^DIE K DR
 Q:($D(^ABMDCLM(DUZ(2),ABMP("CDFN"),53,0))<10)
 S DA(1)=ABMP("CDFN"),DIK="^ABMDCLM(DUZ(2),"_DA(1)_",53,",DA=$O(^ABMDCODE("AC","C",2,"")) D ^DIK
 Q
EMCODE S (DINUM,X)=$O(^ABMDCODE("AC","C",2,"")) Q:X=""
 K DD,DO S DA(1)=ABMP("CDFN"),DIC="^ABMDCLM(DUZ(2),"_DA(1)_",53,",DIC(0)="LE"
 I '$D(^ABMDCLM(DUZ(2),DA(1),53,0)) S ^ABMDCLM(DUZ(2),DA(1),53,0)="^9002274.3053P^^"
 D FILE^DICN K DIC
 S DR=".91////Y",DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN") W !
 I "AB"'[$E(ABM("QU"),$L(ABM("QU"))) G ESET
 I $E(ABM("QU"),$L(ABM("QU")))="B" S DR=DR_";.93Unable to Work From Date...: ;I X="""" S Y=""@9"";.94Unable to Work Thru Date...: ;@9"
 E  S DR=DR_";.92T;.93T;I X="""" S Y=.95;.94T;.95T;I X="""" S Y=""@9"";.96T;@9"
ESET D ^DIE K DR
 Q
 ;
13 ;
 Q
 ;
14 W ! S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".48["_ABM("#")_"] Assigned Case Number" D ^DIE K DR
 Q
 ;
15 W ! S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".49["_ABM("#")_"] Medicaid Resubmission No." D ^DIE K DR
 Q
 ;
16 W ! S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".43["_ABM("#")_"] Number Radiographs Submitted" D ^DIE K DR
 Q
 ;
17 W ! S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".44["_ABM("#")_"] Orthodontic Related" D ^DIE K DR
 Q:X'=1
 S DR=".45    Placement Date" D ^DIE
 S DR="413    Months of Treatment Remaining:" D ^DIE
 I X>ABMP("VDT") W *7,!!,"ERROR: Date can not be after the Visit Date (",$$HDT^ABMDUTL(ABMP("VDT")),")!" S DR=".45///@" D ^DIE G 17
 Q
 ;
18 W ! S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".46["_ABM("#")_"] Init. Prosthesis Placed" D ^DIE K DR
 I X=0 S DR=".47   Prior Placement Date" D ^DIE
 Q
 ;
19 W ! S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".58["_ABM("#")_"] Peer Review Organization (PRO) Approval No." D ^DIE K DR
 Q
20 ;HCFA-1500B BLOCK 19
 S $P(ABM("-"),"-",49)="" W !,?15,ABM("-")
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR="10["_ABM("#")_"] Block 19" D ^DIE K DR
 Q
21 ;TYPE OF ADMISSION
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".51["_ABM("#")_"] Admission Type" D ^DIE
 Q
22 ;SOURCE OF ADMISSION
 S:'$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)) ^(5)=""
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".52["_ABM("#")_"] Admission Source" D ^DIE
 Q
23 ;DISCHARGE STATUS
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".53["_ABM("#")_"]Discharge Status" D ^DIE
 Q
24 ;Admitting DX
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".59["_ABM("#")_"] Admitting DX" D ^DIE
 Q
25 ; Supervising Prov (FL19)
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".912["_ABM("#")_"] Supervising Prov.(FL19)" D ^DIE
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".911["_ABM("#")_"] Date Last Seen" D ^DIE
 S ABMNPIU=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 I ABMNPIU="B"!(ABMNPIU="N") D
 .S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR="925["_ABM("#")_"] NPI" D ^DIE
 I ABMNPIU'="N" D
 .S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR="924["_ABM("#")_"] I.D. Number (UPIN)" D ^DIE
 Q
26 ; Date of Last X-Ray
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".913["_ABM("#")_"] Date of Last X-Ray" D ^DIE
 Q
27 ;Referral Number
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".511["_ABM("#")_"] Referral Number" D ^DIE
 Q
28 ;Prior Authorization Number
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".512["_ABM("#")_"] Prior Authorizaion Number" D ^DIE
 Q
29 ; Homebound Indicator
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".914["_ABM("#")_"] Homebound Indicator" D ^DIE
 Q
30 ; Hospice Employed Provider
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".915["_ABM("#")_"] Hospice Employed Provider" D ^DIE
 Q
31 ;Delayed Reason Code
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".916["_ABM("#")_"] Delayed Reason Code" D ^DIE
 Q
32 ; Number of Enclosures - Radiographs/Oral Images/Models
 W !,"Number of Enclosures: ",!
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".917 Radiographs" D ^DIE
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".918 Oral Images" D ^DIE
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".919 Models" D ^DIE
 Q
33 ;Other Dental Charges
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".921["_ABM("#")_"] Other Dental Charges" D ^DIE
 Q
34 ; Reference Lab CLIA#
 N ABMDCLIA
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN")
 S ABMDCLIA=$P($G(^ABMDPARM(DUZ(2),1,4)),U,12)
 I ABMDCLIA'="" S ABMDCLIA=$P($G(^ABMRLABS(ABMDCLIA,0)),U)
 I ABMDCLIA'="" S ABMDCLIA=$P($G(^AUTTVNDR(ABMDCLIA,0)),U)
 S DR=".923"_$S(ABMDCLIA'="":"//"_ABMDCLIA,1:"")
 D ^DIE
 K ABMDCLIA
 Q
35 ; In-House CLIA#
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".922["_ABM("#")_"] In-House CLIA#: //"_$P($G(^ABMDPARM(DUZ(2),1,4)),U,11) D ^DIE
 Q
 ;start new code abm*2.6*6 5010
36 ; Hearing and Vision Prescription Date
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".714["_ABM("#")_"] Hearing/Vision Prescription Date: //" D ^DIE
 Q
37 ; Start/End Disability Dates
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN")
 S DR=".715["_ABM("#")_"] Start Disability Date: //" D ^DIE
 S DR=".716["_ABM("#")_"] End Disability Date: //" D ^DIE
 Q
38 ; Assumed/Relinquished Care Dates
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN")
 S DR=".719["_ABM("#")_"] Assumed Care Date: //" D ^DIE
 S DR=".721["_ABM("#")_"] Relinquished Care Date: //" D ^DIE
 Q
39 ; Property/Casualty Date of 1st contact
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".722["_ABM("#")_"] Property/Casualty Date of 1st Contact: //" D ^DIE
 Q
40 ; Patient Paid Amount
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".723["_ABM("#")_"] Patient Paid Amount: //" D ^DIE
 Q
41 ; Spinal Manipulation Cond Code
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN"),DR=".724["_ABM("#")_"] Spinal Manipulation Cond Code Ind: //" D ^DIE
 Q
42 ; Vision Condition Info
 S DIE="^ABMDCLM(DUZ(2),"
 S DA=ABMP("CDFN")
 S DR=".821["_ABM("#")_"] Vision Condition Info: //"
 S DR=DR_";W !?3;.822 Vision Certification Condition Indicator: //"
 D ^DIE
 F  D  Q:Y<0
 .K DIC,DIE,DIR,X,Y,DA
 .S DA(1)=ABMP("CDFN")
 .S DIC="^ABMDCLM(DUZ(2),"_DA(1)_",8.5,"
 .S DIC(0)="AQELM"
 .S DIC("P")=$P(^DD(9002274.3,8.5,0),U,2)
 .D ^DIC
 Q
 ;end new code 5010
