PSSGIU ;BIR/CML3-GENERIC "APPLICATION PACKAGES' USE" SET ;01-Mar-2013 12:23;PLS
 ;;1.0;PHARMACY DATA MANAGEMENT;**1015**;9/30/97;Build 62
 ;
 ; Modified - IHS/MSC/WPB - 03/20/2012 - EP COMPND, ADD, QUIT, LIST
 ;      - IHS/MSC/PB  - 08/10/2012 - FIXED PROBLEM WITH ACTIVE DRUG CHECK, ADDED LINE TAG EXIT
 ;      - IHS/MSC/PB  - 09/04/2012 - ADDED CODE TO HAVE USERS ADDED UNIT OF MEASURE AND SEQUENCE FOR AN INGREDIENT IN A COMPOUND
 ;      - IHS/MSC/PB  - 10/03/2012 - ADDED CODE TO TEST INGREDIENT QTY TO BE GREATER THAN ZERO
 ;                    - 10/03/2012 - ADDED LINE TAG GQTY
 ;      - MSC/IHS/PB  - 03/01/2013 - Added lines ADD1=3-4 and EDING 9-11 to ask if user wants to see a list of ingredients at the end of editing
 ;
EN ;
 Q:$S('$D(PSIUDA):1,'$D(PSIUX):1,PSIUX'?1E1"^"1.E:1,1:'$D(^PSDRUG(PSIUDA,0)))  S PSIUO=$P($G(^(2)),"^",3) S PSIUT=$P(PSIUX,"^",2),PSIUT=$S($E(PSIUT,1,4)="UNIT":"",1:$E("N","AEIOU"[$E(PSIUT)))_" "_PSIUT,(%,PSIUQ)=PSIUO'[$E(PSIUX)+1
 F  W !!,"A",PSIUT," ITEM" D YN^DICN Q:%  D MQ S %=PSIUQ
 I %<0 S PSIUA="^" G DONE
 S PSIUA=$E("YN",%) G:%=PSIUQ DONE I %=1 S PSIUY=PSIUO_$P(PSIUX,"^"),$P(^PSDRUG(PSIUDA,2),"^",3)=PSIUY I $P(^(0),"^")]"" S ^PSDRUG("AIU"_$P(PSIUX,"^"),$P(^(0),"^"),PSIUDA)=""
 I %=2 D CMOP S PSIUY=$P(PSIUO,$P(PSIUX,"^"))_$P(PSIUO,$P(PSIUX,"^"),2),$P(^PSDRUG(PSIUDA,2),"^",3)=PSIUY I $P(^(0),"^")]"" K ^PSDRUG("AIU"_$P(PSIUX,"^"),$P(^(0),"^"),PSIUDA)
 K:PSIUO]"" ^PSDRUG("IU",PSIUO,PSIUDA) S:PSIUY]"" ^PSDRUG("IU",PSIUY,PSIUDA)=""
 ;
DONE ;
 K PSIU,PSIUO,PSIUQ,PSIUT,PSIUY Q
 ;
MQ ;
 S X="Enter 'YES' (or 'Y') to mark this drug as a"_$S($E(PSIUT,1,2)="N ":"n"_$E(PSIUT,2,99),1:PSIUT)_" item.  Enter 'NO' (or 'N') to not mark (or unmark) this drug."
 W !!?2 F PSIU=1:1:$L(X," ") S Y=$P(X," ",PSIU) W:$X+$L(Y)>79 ! W Y," "
 Q
CMOP I PSIUX="O^Outpatient Pharmacy",$P($G(^PSDRUG(PSIUDA,3)),"^",1)=1 W !,"This item has just been UNMARKED for CMOP transmission.",! S $P(^PSDRUG(PSIUDA,3),"^")=0 K ^PSDRUG("AQ",PSIUDA) S DA=PSIUDA N % D ^PSSREF
 Q
 ;
ENS ;
 Q:$S('$D(PSIUDA):1,'$D(PSIUX):1,'PSIUDA:1,$L($P(PSIUX,"^"))'=1:1,1:'$D(^PSDRUG(PSIUDA,0)))  S PSIU=$P(^(0),"^"),(PSIUO,PSIUY)=$P($G(^(2)),"^",3),PSIUT=$P(PSIUX,"^")
 I PSIUY'[PSIUT S PSIUY=PSIUY_PSIUT,$P(^PSDRUG(PSIUDA,2),"^",3)=PSIUY K:PSIUO]"" ^PSDRUG("IU",PSIUO,PSIUDA)
 S ^PSDRUG("IU",PSIUY,PSIUDA)="" I PSIU]"" S ^PSDRUG("AIU"_PSIUT,PSIU,PSIUDA)=""
 G DONE
 ;
END ;
 Q:$S('$D(PSIUDA):1,'$D(PSIUX):1,'PSIUDA:1,$L($P(PSIUX,"^"))'=1:1,1:'$D(^PSDRUG(PSIUDA,0)))  S PSIU=$P(^(0),"^"),(PSIUO,PSIUY)=$P($G(^(2)),"^",3),PSIUT=$P(PSIUX,"^")
 I PSIUY[PSIUT S PSIUY=$P(PSIUY,PSIUT)_$P(PSIUY,PSIUT,2),$P(^PSDRUG(PSIUDA,2),"^",3)=PSIUY K ^PSDRUG("IU",PSIUO,PSIUDA)
 S:PSIUY]"" ^PSDRUG("IU",PSIUY,PSIUDA)="" I PSIU]"" K ^PSDRUG("AIU"_PSIUT,PSIU,PSIUDA)
 G DONE
COMPND ;IHS/MSC/WPB line tag COMPND added to mark drug as compounded and to add the ingredients 3/8/2012
 N DIC,DR,DIE,DA
 D QUIT
 S DA=PSIUDA,DIE="^PSDRUG(",DR="9999999.35////1" D ^DIE K DIE,DR,DA,Y,X
 ;IHS/MSC/PB - modified next line so that it will not bomb if there aren't any ingredients to list 9/4/12
 ;I $P($G(^PSDRUG(PSIUDA,999999936,0)),"^",4) S DIR(0)="Y",DIR("B")="YES",DIR("A")="Do you want to see a list of ingredients for this drug? "
 I $P($G(^PSDRUG(PSIUDA,999999936,0)),"^",4)>0 S DIR(0)="Y",DIR("B")="YES",DIR("A")="Do you want to see a list of ingredients for this drug? "
 D ^DIR
 I $G(Y)=1 D LIST,QUIT
 D BRNCH
 Q
 ;Next block of code allows users to select edit or add ingredients
BRNCH K DIR(0),DIR("A"),DIR("B"),X,Y
 S DIR(0)="SO^A:ADD;E:EDIT" D ^DIR G:Y="A" ADD G:Y="E" EDING G:$D(DIRUT) EXIT
 Q
ADD ;IHS/MSC/WPB line tag COMPND added to add the ingredients 3/8/2012
 K DIR(0),DIR("A"),DIR("B"),X,Y,DIC,DIC(0),DIC("T"),Y,TEST
 ;IHS/MSC/PB next line changed to prevent null values from being added as ingredients 9/4/12
 ;S DIC="^PSDRUG(",DIC(0)="QEAMNTV",DIC("T")="" D ^DIC K DIC S TEST=+Y I Y<0 Q
 S DIC="^PSDRUG(",DIC(0)="QEAMNTV",DIC("T")="" D ^DIC K DIC S TEST=+Y
 Q:$G(DTOUT)
 Q:$G(DUOUT)
 Q:Y<0
 ;Check to see if the drug is active
 I $D(^PSDRUG(+Y,"I")) W !,"This ingredient is marked as inactive, please select an active ingredient!" G COMPND
 I $D(^PSDRUG(PSIUDA,999999936,"B",TEST)) W !,"This ingredient has already been added" G ADD1
 I '$D(^PSDRUG(PSIUDA,999999936,"B",TEST)) D
 .;IHS/MSC/PB next block of code changed to allow user to enter unit of use and sequence for the ingredient 9/4/12
 .;S DIC("A")="COMPOUND INGREDIENT QUANTITY PER ORDER UNIT OF COMPOUND",DA(1)=PSIUDA,DIC="^PSDRUG("_DA(1)_",999999936,",DIC(0)="",X=$P($G(TEST),"^"),DIC("DR")="1" D FILE^DICN K DIC
 .;S DIC("A")="COMPOUND INGREDIENT QUANTITY PER ORDER UNIT OF COMPOUND",DA(1)=PSIUDA
 .D GQTY
 .S DA(1)=PSIUDA
 .;IHS/MSC/PB next line changed to enter the ingredient qty as the ingredient is added
 .;S DIC="^PSDRUG("_DA(1)_",999999936,",DIC(0)="",X=$P($G(TEST),"^") ;,DIC("DR")="1;2;3"
 .S DIC="^PSDRUG("_DA(1)_",999999936,",DIC(0)="",X=$P($G(TEST),"^"),DIC("DR")="1///"_$G(QTY)
 .D FILE^DICN K DIC
 .S DA=+$G(Y),UOM1=""
 .K DR,DIC,DIC(0),X,Y
 .;IHS/MSC/PB - Next line changed to set UOM1 variable from the ingredient node. 10/3/12
 .I $P($G(^PSDRUG(TEST,"DOS")),"^",2)>0 S X1=$P($G(^PSDRUG(TEST,"DOS")),"^",2),UOM1=$P(^PS(50.607,X1,0),"^",1)
 .S DIE="^PSDRUG("_DA(1)_",999999936,",DR="2//"_$G(UOM1)_";3" D ^DIE
 .K DIE,DA,DA(1),DR,REC,UOM1,Y,X,QTY,TEST
 .;end changes - PB 9/4/12
 ;IHS/MSC/PB - changed prompt below to have a line tag that can be called.
 ;S DIR(0)="Y",DIR("A")="Add another ingredient? ",DIR("B")="NO" D ^DIR
ADD1 S DIR(0)="Y",DIR("A")="Add another ingredient? ",DIR("B")="NO" D ^DIR
 G:$G(Y)=1 ADD
 ;MSC/IHS/PB 3/1/13 modified to provide a list of ingredients at the end of adding ingredients.
 D QUIT S DIR(0)="Y",DIR("A")="Do you want to see a list of ingredients for this drug",DIR("B")="Y" D ^DIR D:Y=1 LIST
 D QUIT S DIR(0)="Y",DIR("A")="Edit another ingredient",DIR("B")="N" D ^DIR G:Y=1 EDING
QUIT ;IHS/MSC/WPB Quit adding and kill variables 3/8/2012
 K DIR(0),DIR("A"),DIR("B"),X,Y
 Q
LIST ;IHS/MSC/WPB line tag LIST added to display a list of current ingredients for the drug
 ;IHS/MSC/PB - next block of code changed to add the unit of measure and sequence of each ingredient 9/4/12
 ;W !,"INGREDIENT NAME",?44,"INGREDIENT QTY PER ORDER UNIT",!
 ;S XX=0 F  S XX=$O(^PSDRUG(PSIUDA,999999936,XX)) Q:XX'>0  D
 ;S PTR=$P($G(^PSDRUG(PSIUDA,999999936,XX,0)),"^",1)
 ;W !,$P(^PSDRUG(PTR,0),"^",1),?44,$P($G(^PSDRUG(PSIUDA,999999936,XX,0)),"^",2)
 I $P($G(^PSDRUG(PSIUDA,999999936,1,0)),"^",1)'>0 W !,"No ingredients have been added yet" Q
 W !,"INGREDIENT NAME",?44,"INGREDIENT QTY",?62,"UOM",?70,"SEQUENCE"
 W !,?44,"PER ORDER UNIT",!
 K PTR,PTR1,UOM,SEQ,QTY,IDRUG
 S XX=0 F  S XX=$O(^PSDRUG(PSIUDA,999999936,XX)) Q:XX'>0  D
 .S PTR=$P($G(^PSDRUG(PSIUDA,999999936,XX,0)),"^",1)
 .;IHS/MSC/PB - next few lines of code added to set variables for the report. Drug name can't be null, other fields can be null 9/14/2014
 .S:$G(PTR)>0 IDRUG=$P(^PSDRUG(PTR,0),"^",1)
 .S PTR1=$P($G(^PSDRUG(PSIUDA,999999936,XX,0)),"^",3)
 .S:$G(PTR1)>0 UOM=$P(^PS(50.607,PTR1,0),"^",1)
 .S SEQ=$P($G(^PSDRUG(PSIUDA,999999936,XX,0)),"^",4)
 .S:$P($G(^PSDRUG(PSIUDA,999999936,XX,0)),"^",2) QTY=$P($G(^PSDRUG(PSIUDA,999999936,XX,0)),"^",2)
 .W:$G(IDRUG)'="" !,$G(IDRUG),?44,$G(QTY),?62,$G(UOM),?70,$G(SEQ)
 .K PTR,PTR1,UOM,SEQ,QTY,IDRUG
 K XX Q
EDING ;IHS/MSC/WPB line tag EDING allows editing of current ingredients for the drug
 ;Edit existing ingredients for a compound
 K DIR(0),DIR("A"),DIR("B"),X,Y,DIC,DIC(0),DIC("T"),Y,TEST
 S DA(1)=PSIUDA
 S DIC="^PSDRUG("_DA(1)_",999999936,",DIC(0)="QEAMN",DIC("T")="" D ^DIC K DIC S TEST=+Y I Y<0 Q
 S DA=+Y
 K DA(1),DIE,DR
 ;IHS/MSC/PB - modified next line to add the new fields for the ingredient for editing 9/4/12
 ;S DA(1)=PSIUDA,DIE="^PSDRUG("_DA(1)_",999999936,",DR=".01;1" D ^DIE
 S DA(1)=PSIUDA,DIE="^PSDRUG("_DA(1)_",999999936,",DR=".01;1;2;3" D ^DIE
 D QUIT
 S DIR(0)="Y",DIR("A")="Edit another ingredient",DIR("B")="N" D ^DIR G:Y=1 EDING
 ;MSC/IHS/PB - 3/1/13 Modified to ask the user if they want to see a list of ingredients
 D QUIT S DIR(0)="Y",DIR("A")="Do you want to see a list of ingredients for this drug",DIR("B")="Y" D ^DIR D:Y=1 LIST
 D QUIT
 S DIR(0)="Y",DIR("A")="Edit another ingredient",DIR("B")="N" D ^DIR G:Y=1 EDING
 Q
GQTY ;IHS/MSC/PB - code added to get quantity and then check to be sure it is > 0
 K QTY,DIR,DIR(0),DIR("A"),DTOUT,DUOUT,DIRUT,DIROUT
 S DIR("A")="COMPOUND INGREDIENT QUANTITY PER ORDER UNIT OF COMPOUND"
 S DIR("?")="Enter a value greater than zero"
 S DIR(0)="N"
 D ^DIR S QTY=Y K DIR,DIR(0),DIR("A"),DIR("?")
 Q:$G(DUOUT)
 Q:$G(DTOUT)
 Q:$G(DIRUT)
 Q:$G(DIROUT)
 I $G(QTY)'>0 D
 .K DIR,DIR(0),DIR("A"),DIR("?"),DIR("B")
 .S DIR(0)="Y",DIR("B")="NO",DIR("A")="Value must be greater than ZERO. Do you want to delete this INGREDIENT"
 .I $G(Y)=1 D ADD1 ;if yes, don't add the ingredient
 .I $G(Y)'=1 G GQTY
 Q
EXIT D QUIT
 Q
