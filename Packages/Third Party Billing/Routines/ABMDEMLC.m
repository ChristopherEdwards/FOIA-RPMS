ABMDEMLC ; IHS/ASDST/DMJ - Edit Utility - FOR MULTIPLES - PART 4 ;  
 ;;2.6;IHS Third Party Billing System;**2,3**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - V2.5 P2 - 5/9/02 - NOIS HQW-0302-100190
 ;     Modified to display 2nd and 3rd modifiers and units
 ; IHS/SD/SDR - V2.5 P3 - 1/22/03 - QBA-0103-130075
 ;    Modified to use IEN for HCPCS for Fee Schedule lookup
 ; IHS/SD/SDR v2.5 p5 - 5/18/04 - Modified to put POS and TOS by line item
 ; IHS/SD/SDR - v2.5 p6 - 7/9/04 - IM14079 - Notes regarding removal of TOS for now
 ; IHS/SD/SDR - v2.5 p8 - task 6
 ;    Added code for POS ambulance default 41
 ; IHS/SD/SDR - v2.5 p9 - IM19297
 ;    Added message about 4 corresponding Dxs when 837
 ; IHS/SD/SDR - v2.5 p11 - Corrections to 4 corr. Dxs
 ;    If they answered NO it would put NO on the claim, not the selected
 ;    Dxs.
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*2 - 3PMS10003A - Modified to call ABMFEAPI
 ; IHS/SD/SDR - abm*2.6*3 - NOHEAT - fixed modifiers so they work correctly; it would let
 ;   user but garbage
 ;
DX ;EP for selecting Corresponding Diagnosis
 I '+$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C","")) W !!,"There are no Diagnosis entered to select from." Q
 S ABMX=0 K DIR
 W !!,?21,"DIAGNOSES"
 W !,?7,"Seq",?13,"ICD9"
 W !,?7,"Num",?13,"Code",?32,"Diagnosis Description"
 W !,?7,"===",?12,"======",?21,"============================================"
 D RES^ABMDEMLA(17)
 F ABMX("I")=1:1 S ABMX=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMX)) Q:'ABMX  D DX1
 I ABMX("I")=2 D  Q
 .S Y(0)=1
 .S ABMX(1)=1,X=1
 S Y(0)=""
 K DIC
 S DIC="^ABMDCLM(DUZ(2),ABMP(""CDFN""),17,",DIC(0)="AEMQ"
 S DIC("A")="Enter Principle Corresponding DX: "
 K ABMNY
 W ! F  D  Q:Y<0!(+$G(ABMNY)<0)
 .I $G(ABMP("EXP"))=21!($G(ABMP("EXP"))=22)!($G(ABMP("EXP"))=23),$L(Y(0),",")>4 D  Q:+$G(ABMNY)<0  ;only 4 corresponding Dxs
 ..S ABMBFY=Y
 ..S ABMBFY0=Y(0)
 ..S DIR("A",1)="STOP!"
 ..S DIR("A",2)="THE MODE OF EXPORT YOU ARE SUBMITTING FOR ONLY ALLOWS 4 CORRESPONDING"
 ..S DIR("A",3)="DIAGNOSIS CODES."
 ..S DIR("A")="ARE YOU SURE YOU WANT TO CONTINUE ENTERING ADDITIONAL CODES?:"
 ..S DIR("B")="Y"
 ..S DIR(0)="Y"
 ..D ^DIR
 ..K DIR
 ..I Y=1 S Y=ABMBFY,Y(0)=ABMBFY0
 ..E  S ABMNY=-1,Y=ABMBFY,Y(0)=$P(ABMBFY0,",",1,4)
 .D ^DIC Q:+Y<0
 .S DIC("A")="Enter Other Corresponding DX (carriage return when done): "
 .S Y(0)=$G(Y(0))
 .Q:Y(0)[ABMX(+Y)
 .I Y(0)'="" S Y(0)=Y(0)_","
 .S Y(0)=Y(0)_ABMX(+Y)
 .W "   ",Y(0)
 K DIC
 Q
 ;
DX1 ;LIST DX'S
 S ABMX("X")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),17,"C",ABMX,"")),ABMX(ABMX("X"))=ABMX("I"),ABMX("X0")=$$DX^ABMCVAPI(ABMX("X"),ABMP("VDT"))  ;CSV-c
 I $D(ABMX("EDIT")),$D(ABMZ(ABMX("Y"))) S:ABMX("X")=$P(ABMZ(ABMX("Y")),U,5) DIR("B")=ABMX("I")
 W !,?8,ABMX("I"),?12,$P(ABMX("X0"),U,2),?21,$P(ABMX("X0"),U,4)  ;CSV-c
 Q
 ;
NARR ;EP for entering Provider's Narrative
 W ! K DIC S DIC="^AUTNPOV(",DIC(0)="LXAE"
 S DLAYGO=9999999.27
 S DIC("B")=$P(ABMX("DICB"),U)
 I $E(DIC("B"))=" " F  D  Q:$E(DIC("B"))'=" "
 .S DIC("B")=$P(DIC("B")," ",2,999)
 D ^DIC K DIC,DLAYGO
 I +Y<0 S Y=$P(ABMX("DICB"),U,2)
 Q
 ;
MOD2 ;EP for editing Modifiers
 Q:'$P($G(^ABMDPARM(DUZ(2),1,2)),U,5)
 S ABMZIEN=$O(^ICPT("BA",$P(ABMZ(ABMX("Y")),U)_" ",""))
 ;S ABMZ("CHARGE")=+$P($G(^ABMDFEE(ABMP("FEE"),ABMZ("CAT"),ABMZIEN,0)),U,2)  ;abm*2.6*2 3PMS10003A
 S ABMZ("CHARGE")=+$P($$ONE^ABMFEAPI(ABMP("FEE"),ABMZ("CAT"),ABMZIEN,ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 S ABMZ("MODFEE")=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),$P(ABMZ(ABMX("Y")),U,2),0)),U,+$P(ABMZ("CHRG"),".",2))
 S ABMX("MC")=ABMZ("CHARGE")
 S DIE="^ABMDCLM(DUZ(2),"_ABMP("CDFN")_","_ABMZ("SUB")_",",DA=$P(ABMZ(ABMX("Y")),U,2)
 S ABMX("M")=$S($P(ABMZ("MOD"),U,4):3,1:1)
 F ABMX("I")=1:1:ABMX("M") D
 .S DR=$S(ABMX("I")=1:+ABMZ("MOD"),ABMX("I")=2:$P(ABMZ("MOD"),U,3),1:$P(ABMZ("MOD"),U,4))
 .S ABMX("M",ABMX("I"))=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),$P(ABMZ(ABMX("Y")),U,2),$S(+DR<.13:0,1:1))),U,$S($E(DR,$L(+DR))>4:$E(DR,$L(+DR)),1:$E(DR,2,3)))
 F ABMX("I")=1:1:ABMX("M") D  Q:$D(DUOUT)!(ABMX("I")=ABMX("M"))  I X="",$G(ABMX("M",ABMX("I")+1))="" Q
 .S ABMX("S")=$S(ABMX("I")=1:"1st",ABMX("I")=2:"2nd",1:"3rd")
 .;S DR=$S(ABMX("I")=1:+ABMZ("MOD"),ABMX("I")=2:$P(ABMZ("MOD"),U,3),1:$P(ABMZ("MOD"),U,4))_"Select "_$S($P(ABMZ("MOD"),U,4):ABMX("S")_" ",1:"")_"MODIFIER: "  ;abm*2.6*3 NOHEAT
 .;start new code abm*2.6*3 NOHEAT
 .K DIR,X,Y
 .S DIR(0)="PO"_$S($$VERSION^XPDUTL("BCSV")>0:"^DIC(81.3,",1:"^AUTTCMOD(")_":QEM"
 .S DIR("A")="Select "_$S(ABMX("I")=1:"1st",ABMX("I")=2:"2nd",1:"3rd")_" MODIFIER"
 .S:$G(ABMX("M",ABMX("I")))'="" DIR("B")=$G(ABMX("M",ABMX("I")))
 .D ^DIR
 .S ABMX("ANS","X")=X
 .S ABMX("ANS","Y")=$P(Y,U,2)
 .I ABMX("ANS","X")="@" D
 ..K DIR,X,Y
 ..S DIR(0)="Y"
 ..S DIR(0)="YO",DIR("A")="Do you wish "_ABMX("M",ABMX("I"))_" DELETED"
 ..D ^DIR K DIR
 ..I Y=0 S ABMX("ANS","Y")=ABMX("M",ABMX("I"))
 ..I Y=1 S ABMX("ANS","Y")="@"
 .I ABMX("ANS","X")="" Q
 .S DR=$S(ABMX("I")=1:+ABMZ("MOD"),ABMX("I")=2:$P(ABMZ("MOD"),U,3),1:$P(ABMZ("MOD"),U,4))_"////"_$P(ABMX("ANS","Y"),U)
 .K DIR,X,Y,ABMX("ANS")
 .;end new code NOHEAT
 .W ! D ^DIE S:$D(Y) DUOUT="" Q:X=""
 .I +X,+$P($G(^ABMDMOD(+X,0)),U,4),'$D(ABMZ("RCHARGE")) S ABMX("MC")=$P(^(0),U,4)*ABMZ("CHARGE")
 .I +X=52 D
 ..K ABMZ("RCHARGE")
 ..K DIR S DIR(0)="N^0:"_ABMX("MC")_":2",DIR("A")="Reduced CHARGE",DIR("B")=$S(+ABMZ("MODFEE")=ABMZ("MODFEE"):ABMZ("MODFEE"),1:ABMX("MC"))
 ..D ^DIR K DIR S:Y=0!(+Y) ABMZ("RCHARGE")=+Y
 Q:ABMX("M")=1
 F ABMX("I")=ABMX("M"):-1:1 D
 .S DR=$S(ABMX("I")=1:+ABMZ("MOD"),ABMX("I")=2:$P(ABMZ("MOD"),U,3),1:$P(ABMZ("MOD"),U,4))
 .S ABMX("M",ABMX("I"))=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),ABMZ("SUB"),$P(ABMZ(ABMX("Y")),U,2),$S(+DR<.13:0,1:1))),U,$S($E(DR,$L(+DR))>4:$E(DR,$L(+DR)),1:$E(DR,2,3)))_U_DR
 .Q:ABMX("I")=3
 .I $P(ABMX("M",ABMX("I")),U)="",$P(ABMX("M",ABMX("I")+1),U)]"" D
 ..S DR=DR_"////"_$P(ABMX("M",ABMX("I")+1),U) D ^DIE
 ..S DR=$P(ABMX("M",ABMX("I")+1),U,2)_"///@" D ^DIE
 ..Q:ABMX("I")=2  Q:$P(ABMX("M",ABMX("I")+2),U)=""
 ..S DR=$P(ABMX("M",ABMX("I")+1),U,2)_"////"_$P(ABMX("M",ABMX("I")+2),U) D ^DIE
 ..S DR=$P(ABMX("M",ABMX("I")+2),U,2)_"///@" D ^DIE
 Q
 ;
MOD ;EP for adding a Modifier
 K ABMX("MODS")
 S ABMZ("MODFEE")="" Q:'$P($G(^ABMDPARM(DUZ(2),1,2)),U,5)
 ;S ABMZ("CHARGE")=+$P($G(^ABMDFEE(ABMP("FEE"),ABMZ("CAT"),ABMX("Y"),0)),U,2)  ;abm*2.6*2 3PMS10003A
 S ABMZ("CHARGE")=+$P($$ONE^ABMFEAPI(ABMP("FEE"),ABMZ("CAT"),ABMX("Y"),ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 S DIC=$S($$VERSION^XPDUTL("BCSV")>0:"^DIC(81.3,",1:"^AUTTCMOD(")  ;CSV-c
 S DIC(0)="QEAM"  ;CSV-c
 S ABMX("M")=$S($P(ABMZ("MOD"),U,4):3,1:1)
 F ABMX("I")=1:1:ABMX("M") D  Q:Y<1
 .S ABMX("S")=$S(ABMX("I")=1:"1st",ABMX("I")=2:"2nd",1:"3rd")
 .D SELMOD Q:Y<1
 .I $D(ABMX("MODS",+Y)) W *7,!!,"*** Modifier has already been entered! ***" S ABMX("I")=ABMX("I")-1 Q
 .S ABMX("MODS",+Y)=""
 .S ABMZ("DR")=ABMZ("DR")_";"_$S(ABMX("I")=1:+ABMZ("MOD"),ABMX("I")=2:$P(ABMZ("MOD"),U,3),1:$P(ABMZ("MOD"),U,4))_"////"_$P(Y,"^",2)
 .I +Y=52 K DIR S DIR(0)="N^0:"_ABMZ("CHARGE")_":2",DIR("A")="Reduced CHARGE",DIR("B")=ABMZ("CHARGE") D ^DIR K DIR S:Y=0!(+Y) ABMZ("MODFEE")=+Y Q
 .Q:ABMZ("MODFEE")
 .I $P($G(^ABMDMOD(+Y,0)),U,4) S ABMZ("MODFEE")=$P(^(0),U,4)*ABMZ("CHARGE")
 Q
 ;
SELMOD ;
 W ! S DIC("A")="Select "_$S($P(ABMZ("MOD"),U,4):ABMX("S")_" ",1:"")_"MODIFIER: "
 D ^DIC
 Q
POSA ; EP - place of service
 I "^3^14^15^19^20^22^27"'[ABMP("EXP") Q  ;only for HCFAs and 837P
 D POS
 I $D(ABMZ("DR")) S ABMZ("DR")=ABMZ("DR")_";.15T//"_ABMDFLT
 E  S ABMZ("DR")=";W !;.15T//"_ABMDFLT
 Q
POS ; figure place of service
 ; set place of service
 ;  21 if visit type is inpatient
 ;  24 if visit type is ambulatory surgery
 ;  23 if clinic is emergency medicine (code 30)
 ;  11 for all other cases
 S ABMDFLT=$S(ABMP("VTYP")=111!($G(ABMP("BTYP"))=111):21,ABMP("VTYP")=831:24,1:11)
 ; if place of service set to 11 check to see if pointer exists
 ; in parameter file to code file and use it
 I ABMDFLT=11 D
 . S ABMPTR=$P($G(^ABMDPARM(ABMP("LDFN"),1,3)),"^",6)
 . S:ABMPTR="" ABMPTR=$P($G(^ABMDPARM(DUZ(2),1,3)),"^",6) Q:'ABMPTR
 . Q:'$D(^ABMDCODE(ABMPTR,0))
 . S ABMDFLT=$P(^ABMDCODE(ABMPTR,0),U)
 I $P($G(^DIC(40.7,+ABMP("CLN"),0)),"^",2)=30 D
 . S ABMDFLT=23
 I $P($G(^DIC(40.7,+ABMP("CLN"),0)),"^",2)="A3" D
 . S ABMDFLT=41
 Q
TOSA ; EP - add type of service
 ; 7/9/04 - Call to this tag have been commented out.  This is marked as NOT USED
 ;    in 837 implementation guide.  If it is determined that it really is needed tags
 ;    can be restored in ABMDEML and ABMDEMLE
 I "^3^14^15^19^20^22"'[ABMP("EXP") Q  ;only for HCFAs and 837P
 S ABMDFLT=""
 S:ABMP("SB")=21 ABMDFLT=1  ;surg
 S:ABMP("SB")=23 ABMDFLT=9  ;Rx
 S:ABMP("SB")=27 ABMDFLT=1  ;Medical
 S:ABMP("SB")=33 ABMDFLT=9  ;Dental
 S:ABMP("SB")=35 ABMDFLT=4  ;Rad
 S:ABMP("SB")=37 ABMDFLT=5  ;Lab
 S:ABMP("SB")=39 ABMDFLT=7  ;Anes
 S:ABMP("SB")=43 ABMDFLT=1  ;Misc
 S:ABMP("SB")=47 ABMDFLT="AMBULANCE"  ;Ambulance
 I $D(ABMZ("DR")) S ABMZ("DR")=ABMZ("DR")_";.16T//"_ABMDFLT
 E  S ABMZ("DR")=";W !;.16T//"_ABMDFLT
 Q
