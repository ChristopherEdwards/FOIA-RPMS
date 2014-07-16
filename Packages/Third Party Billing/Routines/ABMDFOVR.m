ABMDFOVR ; IHS/ASDST/DMJ - Set Up Form Override ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**10,13**;NOV 12, 2009;Build 213
 ;IHS/DSD/MRS - Added hcfa block 11c 11/25/1998
 ;
 ;IHS/SD/SDR - V2.5 P2 - 4/17/02 - NOIS LUA-0102-160077
 ;    Modified so it wouldn't kick user out after immediately
 ;    editing one line for box 24,32, and 33.  It now asks if you
 ;    would like to edit another line.
 ;
 ;IHS/SD/SDR - V2.5 P2 - 4/17/02 - NOIS NCA-1001-180096 - Modified to correct so block 53 would print correct info
 ;IHS/SD/SDR - v2.5 p8 - task 8 - Added code to correct add/edit prompt for FL override
 ;IHS/SD/SDR - v2.5 p13 - IM25365 - Added FL 32a/32b/33a/33b for export mode 27
 ;
 ;IHS/SD/SDR - 2.6*13 - Added check for new export mode 35
 ;
START ;start
 K DIC
 W !
 D INS Q:'$G(ABMINS)
 D FORM Q:'$G(ABMFORM)
 D BOX Q:'$G(ABMBOX)
 D VTYP Q:'$G(ABMVTYP)
STARTA K ABMLINE,ABMPIECE,ABMNM D @ABMBOX
 Q:'$G(ABMLINE)
 S ABMNM="FM"_ABMFORM_" "_ABMNM_" "_ABMVTYP
 S:ABMVTYP=9999 ABMVTYP=""
 D FILE
 K ABMINS,ABMFORM,ABMBOX,ABMLINE,ABMPIECE,ABMANS,ABMDA,ABMEXIST,ABMVTYP
 Q
FORM ;select form
 S DIC="^ABMDEXP(",DIC(0)="AEMQ"
 ;S DIC("S")="I +Y=3!(+Y=14)!(+Y=27)"  ;abm*2.6*13 export mode 35
 S DIC("S")="I +Y=3!(+Y=14)!(+Y=27)!(+Y=35)"  ;abm*2.6*13 export mode 35
 D ^DIC K DIC
 Q:+Y<0
 S ABMFORM=+Y
 Q
INS ;select insurer
 ;S DIC="^ABMNINS(DUZ(2),"  ;abm*2.6*13 IHS/SD/AML HEAT132667
 S DIC="^AUTNINS("  ;abm*2.6*13 IHS/SD/AML HEAT132667
 S DIC(0)="AEMQ"
 D ^DIC Q:+Y<0
 S ABMINS=+Y
 Q
BOX ;select form locator
 S DIR(0)="S^10:RESERVED FOR LOCAL USE;11:BOX 11C - INSURANCE PLAN/PROGRAM NAME;19:RESERVED FOR LOCAL USE;24:LINE ITEMS;241:LINE 24, LINE 1 ITEM;32:WHERE SERVICES RENDERED;33:BILLING INFO"
 ;start new code abm*2.6*10 HEAT64983
 I ABMFORM'=3  S DIR(0)="S^10:RESERVED FOR LOCAL USE;11:BOX 11C - INSURANCE PLAN/PROGRAM NAME;19:RESERVED FOR LOCAL USE;24:LINE ITEMS;241:LINE 24, LINE 1 ITEM;31:SIGNATURE OF PHYSICIAN;32:WHERE SERVICES RENDERED;33:BILLING INFO"
 S DIR("A")="Select Form Locator"
 ;end new code HEAT64983
 D ^DIR K DIR
 Q:'+Y
 S ABMBOX=+Y
 Q
VTYP ;select visit type
 S DIC="^ABMDVTYP("
 S DIC(0)="AEMQ"
 S DIC("A")="Enter visit type, or leave blank for all. "
 D ^DIC
 I X="" D
 .S Y=9999
 .W "ALL"
 Q:+Y<0
 S ABMVTYP=+Y
 Q
FILE ;file in 3P Insurer file
 S ABMEXIST=$G(^ABMNINS(DUZ(2),ABMINS,2,"AOVR",ABMFORM,ABMLINE,ABMPIECE,+ABMVTYP)) D
 .Q:ABMEXIST=""
 .W !!,"Current Value: ",ABMEXIST
 .W !,"Visit Type: ",$S(ABMVTYP="":"ALL",1:ABMVTYP)
 I ABMLINE=37,(ABMPIECE=1!(ABMPIECE=2)) W !!?5,"Be sure to enter date in FM format (3071218 for 12/18/07)",!
 S DA(1)=ABMINS
 S:'$D(^ABMNINS(DUZ(2),DA(1),2,0)) ^(0)="^9002274.092^^"
 S DIC="^ABMNINS(DUZ(2),DA(1),2,"
 S X=ABMNM
 S DIC(0)="LXE" D ^DIC
 Q:+Y<0
 S DA=+Y
 S ABMDA=DA
 S DIE=DIC
 I $P(Y,U,3)'=1 D
 .S DIR(0)="S^1:ADD/EDIT;2:DELETE"
 .S DIR("A")="Add or Delete Entry?"
 .S DIR("B")="ADD/EDIT"
 .D ^DIR K DIR
 .Q:'Y  S ABMANS=Y
 E  S ABMANS=1
 S:ABMANS=1 DR=".02///"_ABMFORM_";.03///"_ABMLINE_";.04///"_ABMPIECE_";.045///"_ABMVTYP_";.05"
 S:ABMANS=2 DR=".01///@"
 D ^DIE
 I ABMANS=2 D
 .W !,"Entry Deleted.",!
 .D EOP^ABMDUTL(1)
 ;I ABMNM["BOX 32"!(ABMNM["BOX 33")!(ABMNM["BOX 24") D  ;abm*2.6*10 HEAT64983
 I ABMNM["BOX 31"!(ABMNM["BOX 32")!(ABMNM["BOX 33")!(ABMNM["BOX 24") D  ;abm*2.6*10 HEAT64983
 .K DIR
 .S DIR(0)="Y"
 .S DIR("A")="EDIT ANOTHER LINE?"
 .S DIR("B")="N"
 .D ^DIR
 .K DIR
 .I Y=1 G STARTA
 Q
10 ;locator 10d
 S ABMLINE=19
 S ABMPIECE=2
 S ABMNM="BOX 10D LOCAL USE"
 Q
11 ;locator 11C
 S ABMLINE=17
 S ABMPIECE=4
 S ABMNM="BOX 11C"
 Q
19 ;locator 19
 S ABMLINE=29
 S ABMPIECE=1
 S ABMNM="BOX 19 LOCAL USE"
 Q
24 ;locator 24
 K DIR
 S DIR(0)="S^1:A1 - DOS FROM;2:A2 - DOS TO;3:B - POS;4:C - TOS;5:D - HCPCS;6:E - DIAGNOSIS;7:F - CHARGE;8:G - UNITS;9:H - EPSDT;10:I - EMG;11:J - COB;12:K - LOCAL USE"
 ;S:ABMFORM=27 DIR(0)="S^1:A1 - DOS FROM;2:A2 - DOS TO;3:B - POS;4:C - EMG;5:D - HCPCS;6:E - DIAGNOSIS;7:F - CHARGE;8:G - UNITS;9:H - EPSDT;10:I - QUALIFIER;11:J - PROVIDER#"  ;abm*2.6*13 export mode 35
 S:ABMFORM=27!(ABMFORM=35) DIR(0)="S^1:A1 - DOS FROM;2:A2 - DOS TO;3:B - POS;4:C - EMG;5:D - HCPCS;6:E - DIAGNOSIS;7:F - CHARGE;8:G - UNITS;9:H - EPSDT;10:I - QUALIFIER;11:J - PROVIDER#"  ;abm*2.6*13 export mode 35
 S DIR("A")="Which Section?"
 D ^DIR K DIR
 Q:'Y
 S ABMLINE=37
 S ABMPIECE=+Y
 S ABMNM="BOX 24 "_$S($G(Y(0)):Y(0),1:Y)
 Q
241 ;location 24, line 1
 ;IHS/SD/AML 7/18/2012 - Begin new code - Allow correct override for Shaded line in Box 24
 K DIR
 S DIR(0)="S^1:PIECE 1 - FREE TEXT;2:I - ID QUALIFIER;3:J - IDENTIFIER"
 S DIR("A")="Which Section?"
 D ^DIR K DIR
 Q:'Y
 S ABMLINE=36
 S ABMPIECE=+Y
 S ABMNM="BOX 24, Line 1 "_$S($G(Y(0)):Y(0),1:Y)
 ;IHS/SD/AML 7/18/2012 - End new code, begin old code
 ;S ABMLINE=36
 ;S ABMPIECE=3
 ;S ABMNM="BOX 24, Line 1"
 ;IHS/SD/AML 7/18/2012 - End old code
 Q
 ;start new code abm*2.6*10 HEAT64983
31 ;locator 31
 K DIR
 S DIR(0)="S^1:LINE 1;2:LINE 2"
 S DIR("A")="Enter Line Number"
 D ^DIR K DIR
 Q:'Y
 S ABMLINE=+Y+51
 S ABMPIECE=1
 S ABMNM="BOX 31 "_$S($G(Y(0)):Y(0),1:Y)
 Q
 ;end new code HEAT64983
32 ;locator 32
 K DIR
 S DIR(0)="N^1:4"
 ;I ABMFORM=27 S DIR(0)="S^1:LINE 1;2:LINE 2;3:LINE 3;4:LINE 4 32A;5:LINE 4 32B"  ;abm*2.6*13 export mode 35
 I ABMFORM=27!(ABMFORM=35) S DIR(0)="S^1:LINE 1;2:LINE 2;3:LINE 3;4:LINE 4 32A;5:LINE 4 32B"  ;abm*2.6*13 export mode 35
 S DIR("A")="Enter Line Number"
 D ^DIR K DIR
 Q:'Y
 S ABMLINE=+Y+50
 S ABMPIECE=Y
 I ABMLINE=53 S ABMPIECE=ABMPIECE-1
 I +Y=4 S ABMPIECE=1,ABMLINE=54
 I +Y=5 S ABMPIECE=2,ABMLINE=54
 S ABMNM="BOX 32 "_$S($G(Y(0)):Y(0),1:Y)
 Q
33 ;locator 33
 K DIR
 S DIR(0)="S^1:LINE 1;2:LINE 2;3:LINE 3;4:LINE 4 PIN#;5:LINE 4 GRP#"
 ;I ABMFORM=27 S DIR(0)="S^1:LINE 1;2:LINE 2;3:LINE 3;4:LINE 4 33A;5:LINE 4 33B"  ;abm*2.6*13 export mode 35
 I ABMFORM=27!(ABMFORM=35) S DIR(0)="S^1:LINE 1;2:LINE 2;3:LINE 3;4:LINE 4 33A;5:LINE 4 33B"  ;abm*2.6*13 export mode 35
 S DIR("A")="Enter Line Number"
 D ^DIR K DIR
 Q:'Y
 S ABMLINE=+Y+50
 S ABMPIECE=$S(ABMLINE=51:2,1:3)
 I +Y=5 S ABMPIECE=4,ABMLINE=54
 S ABMNM="BOX 33 "_$S($G(Y(0)):Y(0),1:Y)
 Q
