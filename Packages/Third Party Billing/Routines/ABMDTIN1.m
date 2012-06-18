ABMDTIN1 ; IHS/ASDST/DMJ - Maintenance of INSURER FILE part 2 ;   
 ;;2.6;IHS Third Party Billing;**1,6,8**;NOV 12, 2009
 ; IHS/SD/SDR - v2.5 p8 IM13693/IM17856 - Ask for new EMC REFERENCE ID
 ; IHS/SD/SDR - v2.5 p8 - task 8 - Added code for replacement insurer prompts
 ; IHS/SD/SDR - v2.5 p9 - IM19305 - Added itemized question to 837I format
 ; IHS/SD/SDR - v2.5 p9 - IM16962 - Ask EMC SUBMITTER ID all the time
 ; IHS/SD/SDR - v2.5 p9 - IM17789 - Fixed multiple lookup-error <SUBSCRIPT>I1+4^DICUIX
 ; IHS/SD/SDR - v2.5 p10 - IM20309 - Added RX in FL44 prompt
 ; IHS/SD/SDR - v2.5 p10 - IM20606 - Added code to put end date if none is put
 ; IHS/SD/SDR - v2.5 p10 - block 29 - Added code for new block 29 prompt
 ; IHS/SD/SDR - v2.5 p10 - IM21068 - Added prompt so CLIA number will print all the time or not
 ;   Also included DME group number issue IM20225
 ; IHS/SD/SDR - v2.5 p11 - NPI changes
 ; IHS/SD/SDR - v2.5 p11 - IM22787 - Fix display of replacement insurer with future term date
 ; IHS/SD/SDR - v2.5 p11 - IM24315 - New prompt for UB relationship code
 ; IHS/SD/SDR - v2.5 p12 - IM25207 - Edited display of prompt RX# in fl44
 ; IHS/SD/SDR - abm*2.6*1 - FIXPMS10028 - prompt for UB04 FL38
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - added code for BHT06
 ; ********************************************************************
 ;
 W ! K DIC
 S X="`"_ABM("DFN"),DIC="^ABMNINS(DUZ(2),",DIC(0)="LX" D ^DIC Q:+Y<0
 S DIE=DIC,DA=+Y,DR=".02;.03;.04;.05;.08;.09;.11" D ^DIE
 I $D(^DD(9002274.093)) D
 .W !
 .S DR=".06"
 .D ^DIE
 W !!,"PROVIDER PIN#",!
 K X,DIC,DIE,Y,DR,DD,DO,DA
 S DA(1)=ABM("DFN")
 S DIC="^ABMNINS(DUZ(2),"_DA(1)_",3,"
 S DIC(0)="ELMQA"
 S DIC("P")=$P(^DD(9002274.09,3,0),U,2)
 S DLAYGO=9002274.093
 D ^DIC
 I +Y>0 D
 .S DIE="^ABMNINS(DUZ(2),"_DA(1)_",3,"
 .S DA=+Y
 .S DR=".02"
 .D ^DIE
 ;D PROV2^ABMDTIN2  ;abm*2.6*6 5010
DISP ;DISPLAY VISIT TYPE TABLE
 D VHDR
 S DA=0 F  S DA=$O(^ABMNINS(DUZ(2),ABM("DFN"),1,DA)) Q:'DA  S ABM(0)=^(DA,0) D
 .I $Y+4>IOSL D
 ..S DIR(0)="E" D ^DIR K DIR
 ..D VHDR
 .W !?1,DA,?7,$E($P($G(^ABMDVTYP(DA,0)),U),1,17)
 .I $P(ABM(0),U,7)="N" W ?27,"***** (UNBILLABLE) *****" Q
 .I $D(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,12,0)) D
 ..S ABMMVTD=""
 ..F  S ABMMVTD=$O(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,12,"B",ABMMVTD),-1) Q:ABMMVTD=""!($G(ABMVFLG)=1)  D
 ...S ABMVTI=""
 ...F  S ABMVTI=$O(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,12,"B",ABMMVTD,ABMVTI)) Q:ABMVTI=""!($G(ABMVFLG)=1)  D
 ....I $P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,12,ABMVTI,0)),U,2)'="",$P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,12,ABMVTI,0)),U,2)<DT Q
 ....S ABMVFLG=1
 ....W ?27,"** Replace with: "
 ....W:$P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,12,ABMVTI,0)),U,3)'="" $P($G(^AUTNINS($P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,12,ABMVTI,0)),U,3),0)),U)
 ....W " **"
 .I $G(ABMVFLG)=1 K ABMVTI,ABMMVTD,ABMVFLG Q
 .S ABM("X")=$S($P(ABM(0),U,4):$P($G(^ABMDEXP($P(ABM(0),U,4),0)),U),DA=111:"UB-92",1:"HCFA-1500")
 .W ?26,$J("",9-$L(ABM("X"))\2)_ABM("X")
 .W ?40,$S($P(ABM(0),U,6)="Y":"YES",DA=999:"N/A",1:"NO"),?46,$P(ABM(0),U,5)
 .S ABM(1)=0 F ABM("I")=1:1 S ABM(1)=$O(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,11,ABM(1))) Q:'ABM(1)  S ABM(10)=^(ABM(1),0) D
 ..W:ABM("I")>1 !
 ..W ?50,$$SDT^ABMDUTL(ABM(10))
 ..I $P(ABM(10),U,3)]"" W ?61,$$SDT^ABMDUTL($P(ABM(10),"^",3))
 ..W ?72,$J($P(ABM(10),U,2),7,2)
DIC ;LOOK-UP WITH LAYGO
 W !
 S DA(1)=ABM("DFN")
 S DIC="^ABMNINS(DUZ(2),DA(1),1,",DIC(0)="QLEAM",DIC("A")="Select VISIT TYPE..: "
 S DIC("P")=$P(^DD(9002274.09,1,0),U,2)
 D ^DIC K DIC G XIT:X=""!$D(DTOUT)!$D(DUOUT),DIC:+Y<1
 S DA(1)=ABM("DFN")
 S DIE="^ABMNINS(DUZ(2),DA(1),1,",DA=+Y
 S ABM("VTYP")=DA
 I $P(Y,U,3) S DR=".02////"_$S($P(^AUTNINS(DA(1),2),U,2)="Y":"I",1:"C") D ^DIE K DR  ;icd/cpt?
 S DR=".07Billable (Y/N/E)....:" D ^DIE G XIT:$D(Y)
 I X="N" D INACTVTM(ABM("DFN"),ABM("VTYP"),DT) G DISP
 S DR=".25Reporting purposes only:" D ^DIE G XIT:$D(Y)  ;abm*2.6*6 5010
 D DISPRPL  ;display info about replacement insurer/visit type
 ;
 K DIR,X,Y
 S DIR(0)="YO"
 S DIR("A")="Do you want to replace with another insurer/visit type"
 S DIR("?",1)="Answering YES will get you another set of prompts.  Answering these will"
 S DIR("?",2)="make any claims generating with the original insurer/visit type actually"
 S DIR("?",3)="generate like the insurer/visit type in the following prompts."
 S DIR("?",4)="Answering NO will make it work like normal."
 S DIR("?",5)=""
 S DIR("?")="Enter Y to replace or N to continue"
 D ^DIR K DIR
 S ABMMIMIC=Y
 G XIT:$D(DUOUT)!$D(DIROUT)
 I X=""!("Nn"[X) D  ;didn't respond or put NO for replacement
 .I $G(ABMVTI)'="" D  ;active replacement insurer
 ..W !?5,"Active replacement insurer entry: " W:$P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,12,ABMVTI,0)),U,3)'="" $P($G(^AUTNINS($P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,12,ABMVTI,0)),U,3),0)),U)
 ..W !?10,"Effective: ",$$SDT^ABMDUTL($P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,12,ABMVTI,0)),U))
 ..W "Use Visit Type: " W:$P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,12,ABMVTI,0)),U,4)'="" $P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,12,ABMVTI,0)),U,4),!
 ..;
 ..K DIR,X,Y
 ..S DIR(0)="Y"
 ..S DIR("A",1)="WARNING: you are about to answer visit type set up prompts and there is a"
 ..S DIR("A",2)="replacement insurer entered for this visit type.  If you choose to continue"
 ..S DIR("A",3)="TODAY will be used as an end date on the existing entry.  If TODAY is before"
 ..S DIR("A",4)="the effective date, the effective date will be used as the end date as well."
 ..S DIR("A")="Do you wish to continue and add an end date"
 ..S DIR("B")="N"
 ..D ^DIR K DIR
 ..S ABMNOMIM=Y
 ..;
 ..I ABMNOMIM=1 D
 ...D INACTVTM(ABM("DFN"),ABM("VTYP"),"")  ;they want to continue-stuff end date
 ...S DIE="^ABMNINS(DUZ(2),"_DA(2)_",1,"
 ...S DA=ABM("VTYP")
 ...S DR=".23////N"  ;change auto-split to NO since all entries will be inactive
 ...D ^DIE
 .I $G(ABMNOMIM)=0 S ABMATCK=1  ;stops the rest of prompts from happening
 ;
 I +$G(ABMMIMIC)>0 D
 .D REPLCEIT  ;replace it!
 .D REPLCECK  ;make sure replacment is valid
 I $G(ABMINACK)'="" D INACTVTM(ABM("DFN"),ABM("VTYP"),DT)  ;inactivate other entries
 I $G(ABMATCK)'="" K ABMATCK G DISP
 K DR,DIC,DIE,DIR
 S DA=DA(1)
 S DA(1)=ABM("DFN"),DIE="^ABMNINS(DUZ(2),DA(1),1,"
DIC2 S DA=ABM("VTYP")
 S DR=".14Start Billing Date (create no claims with visit date before)..:" D ^DIE G XIT:$D(Y)
 S DR=".02Procedure Coding....:;I X=""I"" S Y=""@2"";.05Fee Schedule........:;114Add Zero Fees?...:;@2;.06Multiple Forms?.....:"
 D ^DIE G XIT:$D(Y)
 S DR=".08Payer Assigned Provider Number.....:" D ^DIE G XIT:$D(Y)
 S DR=".19EMC Submitter ID #..:" D ^DIE
 S DR="101EMC Reference ID....:" D ^DIE
 S DR=".13Auto Approve?.......:" D ^DIE G XIT:$D(Y)
 ;start old code abm*2.6*1 FIXPMS10028
 ;S DR=".04Mode of Export......:;S:X=11!(X=21)!(X=51)!(X=28) Y=""@1"";S:X=3!(X=14) Y=""@2"";S Y=0;@1;.18Relationship Code?;.12Itemized UB?.....:;109ICD PX on Claim?;S Y=0;@2;.15Block 24K..........:;.17Block 29...........:;.2Block 33 PIN#......:"
 ;D ^DIE G XIT:$D(Y)
 ;end old code start new code FIXPMS10028
 S DR=".04Mode of Export......:" D ^DIE
 K DR
 ;I ("^11^21^51^28^"[("^"_($P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,ABM("VTYP"),0)),U,4))_"^")) S DR=".18Relationship Code?;.12Itemized UB?.....:;115UB-04 Form Locater 38;109ICD PX on Claim?"  ;abm*2.6*8 5010
 I ("^11^21^31^51^28^"[("^"_($P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,ABM("VTYP"),0)),U,4))_"^")) S DR=".18Relationship Code?;.12Itemized UB?.....:;115UB-04 Form Locater 38;109ICD PX on Claim?;.125Print meds on 2 lines?"  ;abm*2.6*8 5010
 ;I ("^3^14^"[("^"_($P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,ABM("VTYP"),0)),U,4))_"^")) S DR=".15Block 24K..........:;.17Block 29...........:;.2Block 33 PIN#......:"  ;abm*2.6*8 HEAT32544
 I ("^3^14^22^27^32^"[("^"_($P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,ABM("VTYP"),0)),U,4))_"^")) S DR=".15Block 24K..........:;.17Block 29...........:;.2Block 33 PIN#......:"  ;abm*2.6*8 HEAT32544
 D:($G(DR)) ^DIE G XIT:$D(Y)
 ;end new code FIXPMS10028
 I ($P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,ABM("VTYP"),0)),U,4)=3!($P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,ABM("VTYP"),0)),U,4)=14)),$P($G(^AUTNINS(ABM("DFN"),2)),U)="D" D
 .S DR="107Dash in block 1A?" D ^DIE
 I ("^11^21^31^51^28^"[(U_($P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,ABM("VTYP"),0)),U,4))_U)),$P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,0)),U,12)=1!($P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,0)),U,4)=11)!($P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,0)),U,4)=28) D
 .S DR=".24RX# IN FL44?....." D ^DIE
 S ABM(0)=^ABMNINS(DUZ(2),ABM("DFN"),1,DA,0)
 I $P($G(^ABMNINS(DUZ(2),ABM("DFN"),0)),U,9)="L" S DR="18////@" D ^DIE
 ;
 I $P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,0)),U,4),$P($G(^ABMDEXP($P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,0)),U,4),0)),U)["837" D
 .K DR,DIC,DIE,DIR,X,Y
 .S DIR(0)="Y"
 .S DIR("A")="Contract Code Req'd"
 .S:$P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,1)),U,13)'="" DIR("B")=$P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,1)),U,13)
 .S DIR("?")="This may be used by certain payers to report contract information.  This populates the CN1 segment on the 837."
 .D ^DIR K DIR
 .S ABMANS=Y
 .I ABMANS=1 D
 ..K DR,DIC,DIE,DIR,X,Y
 ..S DIR(0)="S^02:PER DIEM;03:VARIABLE PER DIEM;04:FLAT;05:CAPITATED;06:PERCENT;09:OTHER"
 ..I $P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,0)),U,4)=21 S $P(DIR(0),U,2)="01:DIAGNOSIS RELATED GROUP (DRG);"_$P(DIR(0),U,2)
 ..S DIR("A")="Contract Code Type"
 ..S:$P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,1)),U,11) DIR("B")=$P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,1)),U,11)
 ..D ^DIR K DIR
 ..S ABMCTYP=Y
 ..S DA(1)=ABM("DFN")
 ..S DIE="^ABMNINS(DUZ(2),DA(1),1,"
 ..S DA=ABM("VTYP")
 ..S DR="111////"_ABMCTYP_";112;113////Y"
 ..D ^DIE
 .I ABMANS=0 D
 ..S DA(1)=ABM("DFN")
 ..S DIE="^ABMNINS(DUZ(2),DA(1),1,"
 ..S DA=ABM("VTYP")
 ..S DR="113////N"
 ..D ^DIE
 .S DA(1)=ABM("DFN")
 .S DIE="^ABMNINS(DUZ(2),DA(1),1,"
 .S DA=ABM("VTYP")
 ;
 I $P($G(^ABMNINS(DUZ(2),ABM("DFN"),0)),U,9)="N"!($P($G(^ABMNINS(DUZ(2),ABM("DFN"),0)),U,9)="B") S DR="18SUBPART NPI:" D ^DIE
 S DR="104DME Contractor?.....:" D ^DIE
 I $P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,1)),U,4)="Y" D
 .S DR="103DME GROUP NUMBER/NAME:" D ^DIE
 .S DR="105CLIA# req'd for all visits? " D ^DIE
 .I $P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,1)),U,5)="Y" D
 ..S DR="106Which CLIA should print? " D ^DIE
 I $P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,1)),U,4)'="Y" D
 .S DR="103////@;105////@;106////@" D ^DIE
 G DISP:$P(^AUTNINS(ABM("DFN"),2),U,2)'="Y"
 I $P($G(^ABMDEXP(+$P(ABM(0),U,4),0)),U)["UB" D  G XIT:$D(Y)
 .S DR=".03R~Revenue Code........:;.09Revenue Description.:" D ^DIE Q:$D(Y)
 .S DR=".11Bill Type...........:" D ^DIE
 S DR=".16CPT Code............:" D ^DIE Q:$D(Y)
 S DA(2)=ABM("DFN"),DA(1)=ABM("VTYP")
 S DIC("P")=$P(^DD(9002274.091,11,0),U,2)
 S DIC="^ABMNINS(DUZ(2),DA(2),1,DA(1),11,",DIC(0)="AEMQL"
 D ^DIC Q:+Y<0
 S DIE="^ABMNINS(DUZ(2),DA(2),1,DA(1),11,",DA=+Y,DR=".01;.02;.03" D ^DIE
 G DISP
 ;
XIT I '$O(^ABMNINS(DUZ(2),ABM("DFN"),1,0)) K ^ABMNINS(DUZ(2),ABM("DFN"),1,0)
 Q
VHDR ;VISIT TABLE HEADER
 W $$EN^ABMVDF("IOF")
 W !!,"Visit",?27,"Mode of",?39,"Mult",?45,"Fee",?52,"------- Flat Rate --------"
 W !,"Type - Description",?28,"Export",?39,"Form",?44,"Sched",?52,"Start      Stop       Rate "
 W !,"==============================================================================="
 Q
INACTVTM(ABMINS,ABMVTYP,ABMDT) ;Make sure all other entries are termed before adding new one
 S ABMVTIEN=0
 F  S ABMVTIEN=$O(^ABMNINS(DUZ(2),ABMINS,1,ABMVTYP,12,ABMVTIEN)) Q:+ABMVTIEN=0  D
 .I $P($G(^ABMNINS(DUZ(2),ABMINS,1,ABMVTYP,12,ABMVTIEN,0)),U,2)="" D
 ..Q:ABMVTIEN=+$G(ABMINACK)  ;entry that was just added-skip it
 ..S DA(2)=ABMINS
 ..S DA(1)=ABMVTYP
 ..S DIE="^ABMNINS(DUZ(2),"_DA(2)_",1,"_DA(1)_",12,"
 ..S DA=ABMVTIEN
 ..S DR=".02"_$S($G(ABMDT)'="":"////"_ABMDT,1:"//"_DT)  ;stuff today for end date
 ..D ^DIE
 Q
DISPRPL ; EP-display active replacement insurer/visit 
 I $D(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,12,0)) D
 .S ABMMVTD=""
 .F  S ABMMVTD=$O(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,12,"B",ABMMVTD),-1) Q:ABMMVTD=""!($G(ABMVFLG)=1)  D
 ..S ABMVTI=""
 ..F  S ABMVTI=$O(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,12,"B",ABMMVTD,ABMVTI)) Q:ABMVTI=""!($G(ABMVFLG)=1)  D  Q:$G(ABMVFLG)=1
 ...Q:$P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,12,ABMVTI,0)),U,2)'=""  ;end date exists
 ...;active was found-display replacment info and flag to quit
 ...W !!,"This VISIT TYPE is currently replaced with the following:"
 ...W !?3,$$SDT^ABMDUTL($P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,12,ABMVTI,0)),U))  ;eff date
 ...W:$P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,12,ABMVTI,0)),U,3)'="" ?20,$P($G(^AUTNINS($P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,12,ABMVTI,0)),U,3),0)),U)  ;insurer
 ...W:$P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,12,ABMVTI,0)),U,4)'="" ?45,$P($G(^ABMDVTYP($P($G(^ABMNINS(DUZ(2),ABM("DFN"),1,DA,12,ABMVTI,0)),U,4),0)),U),!  ;visit type
 ...S ABMVFLG=1
 Q
REPLCEIT ;EP- prompt for replacement insurer/visit type
 S DA(2)=ABM("DFN"),DA(1)=ABM("VTYP")
 S ABMATCK=1,ABMPSINS=+Y
 S DIC("P")=$P(^DD(9002274.091,12,0),U,2)
 S DIC="^ABMNINS(DUZ(2),DA(2),1,DA(1),12,",DIC(0)="AEMQL"
 D ^DIC Q:+Y<0
 S (DA,ABMINACK)=+Y
 I $P(Y,U,3)="" D
 .S DIE="^ABMNINS(DUZ(2),DA(2),1,DA(1),12,"
 .S DR=".02;.03;.04"
 .D ^DIE
 Q
REPLCECK ;EP- make sure replacement follows "rules"
 S ABMMINS=$P($G(^ABMNINS(DUZ(2),DA(2),1,DA(1),12,DA,0)),U,3)
 S ABMMVTYP=$P($G(^ABMNINS(DUZ(2),DA(2),1,DA(1),12,DA,0)),U,4)
 I ABMMINS=""!(ABMMVTYP="") D  Q
 .W !,"Replacement must have a Insurer and a visit type to be complete!"
 .S DIK="^ABMNINS(DUZ(2),DA(2),1,DA(1),12," D ^DIK Q  ;incomplete entry
 I ABMMINS=DA(2),ABMMVTYP=DA(1) D  Q
 .W !,"Replacement Insurer/Visit Type can not replace itself!"
 .H 2
 .S DIK="^ABMNINS(DUZ(2),DA(2),1,DA(1),12,"
 .D ^DIK
 I $G(ABMMVTYP),('$D(^ABMNINS(DUZ(2),ABMMINS,1,ABMMVTYP,0))) D  Q
 .W !,"Replacement Insurer/Visit Type not set up!  Must be set up before it can replace."
 .H 2
 .S DIK="^ABMNINS(DUZ(2),DA(2),1,DA(1),12,"
 .D ^DIK
 I $P($G(^AUTNINS(ABMMINS,1)),U,7)=4 D  Q
 .W !,"Replacement Insurer is designated UNBILLABLE."
 .H 2
 .S DIK="^ABMNINS(DUZ(2),DA(2),1,DA(1),12,"
 .D ^DIK
 I $P($G(^AUTNINS(ABMMINS,2)),U,7)'="" D  Q
 .W !,"Replacement Insurer can not be one that's merged."
 .H 2
 .S DIK="^ABMNINS(DUZ(2),DA(2),1,DA(1),12,"
 .D ^DIK
 Q
