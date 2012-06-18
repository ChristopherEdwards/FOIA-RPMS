ACGSTART ;IHS/OIRM/DSD/THL,AEF - ENTRY POINT FOR CONTRACT PROCESSING; [ 03/27/2000  5:48 PM ]
 ;;2.0t1;CONTRACT INFORMATION SYSTEM;;FEB 16, 2000
 ;;ENTRY POINT FOR CONTRACT PROCESSING
EN D FY1^ACGSEXP
 I '+$G(ACGPARA) D SITE^ACGSPARA
 Q:'+$G(ACGPARA)
 F  D EN1 Q:$D(ACGQUIT)
EXIT D KILL^ACGSTAR1
 Q
EN1 D HEAD^ACGSMENU
 S ACGCOC=ACG4
 S DIR(0)="SO^1:ADD Contract/Small Purchase;2:NEW Modification;3:EDIT Entry;4:CHANGE Activity Status;5:DELETE Modification",DIR("A")="          Which one"
 W !!?32,"DATA ENTRY/EDIT"
 D KILL1^ACGSTAR1
 D DIR^ACGSDIC
 Q:$D(ACGQUIT)
 S:Y=1 ACGC="" S:Y=2 ACGCA=""
 I Y=1 D ^ACGSNC K ACGQUIT Q
 I Y=2 D NCA K ACGQUIT Q
 I Y=3 D ^ACGSEDIT K ACGQUIT Q
 I Y=4 D INACT^ACGSTAR1 K ACGQUIT Q
 I Y=5 S ACGDELET="" D ^ACGSEDIT K ACGQUIT,ACGDELET Q
 Q
NCA S DIR(0)="SO^R:Contract mod (additional funds/performance);C:Contract mod (negotiated funds/performance);M:Contract mod (other than R, or C);PM:Small Purchase Modification;Q:Quarterly Report of Delivery Orders"
 S DIR(0)=DIR(0)_";T:Termination for default;U:Termination for convenienc" ;G:Delivery Order against Agency Contract"
 S DIR("A")="Type of Procurement Action",DIR("A",1)=" "
 W @IOF
 D DIR^ACGSDIC
 Q:$D(ACGQUIT)
 S (ACG1,ACGNCA,ACGFLDS,ACGFLDSS)=Y,ACG1DA=$O(^ACGTPA("B",Y,""))
NCA1 D VND^ACGSTAR1
 I '$D(ACGCNO) W !!,"Contract action cannot be created without identifying the contract." D HOLD^ACGSMENU Q
 Q:'ACGCNO
 S ACGNEW="" D EDIT1^ACGSEDIT
 S DIR(0)="YO",DIR("A")="Create new contract action"
 W !
 D DIR^ACGSDIC
 I $D(ACGQUIT)!(Y'=1) K ACGQUIT Q
 I $P(^ACGS(ACGCNO,"DT"),U,13)'=$P(^AUTTVNDR(ACG5DA,11),U,26) D  Q
 .W !!,*7,*7,"The TYPE OF BUSINESS listed for this Contractor under CONTRACTOR DATA",!,"does not match the TYPE OF BUSINESS from the original contract action.",!,"You must reconcile this difference and insure that the TYPE OF BUSINESS"
 .W !,"listed on the original and ALL modifications matches the information on file",!,"under CONTRACTOR DATA for this contractor."
 .D HOLD^ACGSMENU
 .S ACGQUIT=""
NUM I ACG1DA'=6 D
 .L +^ACGS(ACGCNO,0):4 I '$T G NUM
 .S ACGANO=$P(^ACGS(ACGCNO,0),U,2),(ACGANO,ACGAN)=ACGANO+1 S DA=ACGCNO,DIE="^ACGS(",DR=".02////"_ACGANO
 .L -^ACGS(ACGCNO,0):0
 .D DIE^ACGSDIC
 I ACG1DA=6 D  Q:$D(ACGQUIT)!$D(ACGOUT)
 .D QT,FY
 .Q:$D(ACGQUIT)!$D(ACGOUT)
 .S ACGANO=9_$E(ACGFY,2)_ACGQT,ACGAN=ACGANO
 F ACGK=1:1:(3-$L(ACGANO)) S ACGANO="0"_ACGANO
 G:$D(^ACGS("B",($E(ACGX,1,9)_ACGANO))) NUM
 S ACG2=$E(ACGX,1,9)_ACGANO,ACG3="",ACG4=$P(ACGPARA,U,3)
 S X=ACGAN,DIC="^ACGS(",DIC(0)="L"
 S DIC("DR")=".02////"_ACGAN_";.03////"_ACGCNO_";.05////"_ACGCDA_";1////"_ACG1DA_";2////"_ACG2_";3////"_ACG3_";4////"_ACG4_";1005////"_ACG5DA_";51////2;52////2;58////2;103////"_ACGFY_";1099////"_DT_";16////"_$P(^ACGS(ACGCNO,"DT"),U,16)
 S DIC("DR")=DIC("DR")_";21////1"
 I ACG1DA=15!(ACG1DA=17) S ACGSP=^ACGS(ACGCNO,"SP"),DIC("DR")=DIC("DR")_";301////"_$P(ACGSP,U)_";302////"_$P(ACGSP,U,2)_";303////"_$P(ACGSP,U,3)_";304////"_$P(ACGSP,U,4)_";305////"_$P(ACGSP,U,5)_";306////"_$P(ACGSP,U,6)
 E  S DIC("DR")=DIC("DR")
 S ACGX=$E($P(^VA(200,DUZ,0),U,2),1,3)
 I ACGX]"" D
 .I $L(ACGX)<3 F I=1:1:3-$L(ACGX) S ACGX=ACGX_" "
 .S DIC("DR")=DIC("DR")_";115////"_ACGX
 W ! D WAIT^DICD W !
 D FILE^ACGSDIC
 S ACGRDA=+Y
 D NOW^%DTC
 S DR=".07////"_%_";.08////"_DUZ_";22////"_$P(^ACGS(ACGCNO,"DT1"),U)_";1037////"_$P(^(10),U,4)_";62////"_$P(^("DT3"),U,7),DIE="^ACGS(",DA=ACGRDA
 D DIE^ACGSDIC
 D @ACG1^ACGSRQD
PF ;EP;TO PROCESS FIELDS FOR CONTRACT ACTION EDIT SEQUENCES
 F ACGX="DT1","DT2","DT3" S:'$D(^ACGS(ACGRDA,ACGX)) ^ACGS(ACGRDA,ACGX)=""
ACGSPF W @IOF
 S DR=$P($T(@ACGFLDSS^ACGSRF),";;",2)_$S("MRDIL"'[ACGFLDSS:";115T",1:""),DIE="^ACGS(",DA=ACGRDA
 S:"P"'=$E(ACGFLDSS) DR="2T;"_DR
 D DIE^ACGSDIC
 I "MRDIL"[$E(ACGFLDSS) S DIE="^ACGS(",DA=ACGRDA,DR=$P($T(@ACGFLDSS+1^ACGSRF),";;",2)_";115T" D DIE^ACGSDIC
 I "MRDILGN"[$E(ACGFLDSS),$P(^ACGS(ACGRDA,"DT"),U,13)=10 S DIE="^ACGS(",DA=ACGRDA,DR="67T;68T;69T" D DIE^ACGSDIC
 I $P(^ACGS(ACGRDA,"IHS"),U,16)="" W !!,*7,*7,"IT APPEARS THAT THE DATA ENTRY SEQUENCE HAS NOT BEEN COMPLETED.",!,"YOU MUST COMPLETE DATA ENTRY BEFORE PROCEEDING." D HOLD^ACGSMENU G PF
 I "P"'=$E(ACGFLDS) D DOLLARS
 D:$D(ACGNEW)&("P"'[$E(ACG1)) VNDUP^ACGSTAR1 K ACGNEW
 D ^ACGSCS
 Q
DOLLARS I $P(^ACGS(ACGRDA,"DT1"),U,5),($P(^("DT2"),U,3)+$P(^("DT2"),U,5)+$P(^("DT2"),U,7))'=$P(^("DT1"),U,5) F  D  Q:($P(^ACGS(ACGRDA,"DT2"),U,3)+$P(^("DT2"),U,5)+$P(^("DT2"),U,7))=$P(^("DT1"),U,5)
 .S DA=ACGRDA,DIE="^ACGS(",DR="1037T;38T;1039T;40T;1041T;42T"
 .W !!,*7,"The amount allocated to all CAN's must equal ",$FN($P(^ACGS(ACGRDA,"DT1"),U,5),"P",0),!
 .D DIE^ACGSDIC
 Q
QT ;EP;TO DETERMINE DATE RANGE FOR QUARTERS
 S DIR(0)="SO^1:FIRST;2:SECOND;3:THIRD;4:FOURTH",DIR("A")="Quarter....",DIR("?")="Enter the quarter for the report"
 W !
 D DIR^ACGSDIC
 Q:$D(ACGQUIT)
 S ACGQT=+Y
 Q
FY S DIR(0)="FO^2:2^K:X'?2N X",DIR("A")="Fiscal Year",DIR("?")="Enter the last 2 digits of the Fiscal Year, e.g., '94' for 1994."
 W !
 D DIR^ACGSDIC
 Q:$D(ACGQUIT)
 S ACGFY=Y
 Q
