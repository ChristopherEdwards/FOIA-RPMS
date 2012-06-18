ABMDTINS ; IHS/ASDST/DMJ - Table Maintenance of INSURER FILE ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p12 - UFMS
 ;   Added prompt for Federal Tax ID
 ;
 K ABM
 W !!,"WARNING: Before ADDING a new INSURER you should ensure that it"
 W !?9,"does not already exist!"
 K DIR S DIR(0)="SO^1:EDIT EXISTING INSURER;2:ADD NEW INSURER",DIR("A")="Select DESIRED ACTION",DIR("B")=1 D ^DIR K DIR G XIT:'Y!$D(DIRUT)
 G ADD:Y=2
 W ! K DIR S DIR(0)="YO",DIR("A")="Screen-out Insurers with status of Unselectable",DIR("B")="Y"
 S DIR("?")="Answer 'YES' if the Insurers that have been designated as being Unselectable should be screened-out."
 D ^DIR K DIR G XIT:$D(DIROUT)!$D(DIRUT)
 K DIC I Y S DIC("S")="I $P($G(^(1)),U,7)'=0"
SEL W !! S DIC="^AUTNINS(",DIC("A")="Select INSURER: ",DIC(0)="QEAM" D ^DIC K DIC G XIT:X=""!$D(DUOUT)!$D(DTOUT),SEL:+Y<1
 S ABM("DFN")=+Y,ABM("MODE")=0 G EDIT
 ;
ADD S (ABM("DFN"),ABM,ABM("LOCK"))=0,ABM("MODE")=1
 W ! K DIR S DIR(0)="FO^3:30",DIR("A")="Enter the NAME of the INSURER" D ^DIR K DIR G XIT:$D(DIRUT) S ABM("X")=X
 I $D(^AUTNINS("B",$E(X,1,30))) W *7,!!,"The Insurer '",X,"' already exists!" G PAZ
 W !,*7 K DIR S DIR(0)="Y",DIR("A")="Do you want to Add '"_ABM("X")_"' as a New INSURER" D ^DIR K DIR G SEL:$D(DUOUT)!$D(DTOUT),SEL:Y<1
 W !,"OK, adding..."
 S X=ABM("X"),DIC="^AUTNINS(",DIC(0)="L" K DD,DO D FILE^DICN
 I +Y<1 W *7,!!,"ERROR: INSURER NOT CREATED",!! G PAZ
 S ABM("DFN")=+Y
 ;
EDIT L +^AUTNINS(ABM("DFN")):1 I '$T W *7,!!,"Record in USE by another USER, try Later!" G PAZ
 S DA=ABM("DFN"),DIE="^AUTNINS("
 G ADDR
 W ! S DR=".01R~Insurer Name.......: " D ^DIE G KILL:$D(Y)
 D KEYWD
 S DR=".41R~Long Lookup Name...: " D ^DIE G KILL:$D(Y)
ADDR W !!,"<--------------- MAILING ADDRESS --------------->"
 S DR=".02R~Street...: ;.03R~City.....: ;.04R~State....: ;.05R~Zip Code.: " D ^DIE G KILL:$D(Y)
 S ABM("MODE")=0 W !!,"<--------------- BILLING ADDRESS --------------->",!?6,"(if Different than Mailing Address)"
 S DR="1Billing Office.: ;I X="""" S Y=""@9"";2        Street.: ;3        City...: ;4        State..: ;5        Zip....: ;@9" D ^DIE G KILL:$D(Y)
 W ! S DR=".06Phone Number.......: ;.09Contact Person.....: ;.11Federal Tax ID#....: ;.08AO Control Number..: " D ^DIE G XIT:$D(Y)
 I $P($G(^AUTNINS(DA,1)),U,7)'=2 D  G XIT:$D(Y)
 .S DR=".17Insurer Status.....: " D ^DIE Q:$D(Y)
 .I "HMPWCF"[$P($G(^AUTNINS(DA,2)),U) S DR=".21Type of Insurer....: " D ^DIE
 S ABM("DFLT")=0 F  S ABM("DFLT")=$O(^ABMNINS(DUZ(2),DA,1,ABM("DFLT"))) Q:'ABM("DFLT")  I $O(^(ABM("DFLT"),11,0)) Q
 S DR=".22All Inclusive Mode.: //"_$S(ABM("DFLT"):"Y",1:"")_";.24Backbill Limit (months): " D ^DIE G XIT:$D(Y)
 I ABM("DFLT"),$P(^AUTNINS(DA,2),U,2)="N" S ABM=0 F  S ABM=$O(^ABMNINS(DUZ(2),DA,1,ABM)) Q:'ABM  D
 .K ^ABMNINS(DUZ(2),DA,1,ABM,11)
 .S DA(1)=DA,DA=ABM,DR=".02////C",DIE="^ABMNINS("_DA(1)_",1,"
 .D ^DIE K DR S DA=DA(1),DIE="^AUTNINS("
 S DR=".25Dental Bill Status.: ;.23Rx Billing Status..: " D ^DIE G XIT:$D(Y)
CLINIC ;
 W !
 F  D  G XIT:$D(DTOUT)!$D(DUOUT)  Q:+$G(Y)<0
 .S DA(1)=ABM("DFN")
 .S DIC="^AUTNINS(DA(1),17,"
 .S DIC(0)="QLEAM"
 .S DIC("A")="Select CLINIC UNBILLABLE:  "
 .S:'$D(^AUTNINS(DA(1),17,0)) ^(0)="^9999999.181701P^^"
 .D ^DIC
 .K DIC
 .Q:$D(DTOUT)!$D(DUOUT)!(+Y<1)
 .S DA=+Y
 .S DIE="^AUTNINS(DA(1),17,"
 .S DR=".01     Clinic...."
 .D ^DIE
 D ^ABMDTIN1 G XIT:$D(DTOUT)!$D(DIROUT)!$D(DUOUT)
 I $P(^AUTNINS(ABM("DFN"),2),U,2)="Y" W ! K DIC S DIE="^AUTNINS(",DA=ABM("DFN"),DR="4301" D ^DIE
 G XIT
 ;
PAZ K DIR S DIR(0)="E" D ^DIR
XIT I $D(ABM("DFN")) L -^AUTNINS(ABM("DFN"))
 K ABM,DIC,DIE
 K DA,DR,Y,X
 Q
 ;
KILL I ABM("MODE") W !!,*7,"<Data Incomplete: Entry Deleted>" S DIK=DIE D ^DIK G PAZ
 G XIT
 ;
KEYWD ; EP for building Keyword Long Name Field
 S ABM("X")=$P(^AUTNINS(DA,0),U),ABM("L")=$O(^AICDKWLC("B","INSURERS",0)),ABM("R")="",ABM("O")=0 I ABM("L") F ABM("I")=1:1 D  Q:ABM("O")
 .I $P($G(^AUTNINS(DA,4)),U)]"",$P(^(4),U)'=$P(^(0),U) S ABM("O")=1 Q
 .S ABM=$P(ABM("X")," ",ABM("I")) I ABM="" S ABM("O")=1 Q
 .I ABM["." S ABM=$P(ABM,".")_$P(ABM,".",2) D SKEY Q
 .S ABM("OL")=ABM
 .F ABM("CH")="/","-",":",";" I ABM[ABM("CH") D  Q:ABM("OL")=""
 ..S ABM=$P(ABM,ABM("CH")) D SKEY
 ..S ABM=$P(ABM("OL"),ABM("CH"),2),ABM("OL")="" D SKEY
 .I ABM("OL")'="" D SKEY Q
 Q:ABM("R")=""  S:$P($G(^AUTNINS(DA,4)),U)="" ABM("X")=""
 I ABM("R")'=ABM("X") S DR=".41////"_ABM("R") D ^DIE
 Q
SKEY I ABM'="CO",ABM]"",$D(^AICDKWLC(ABM("L"),2,"B",ABM)),$D(^AICDKWLC(ABM("L"),2,$O(^(ABM,0)),0)) S ABM=$P(^(0),U,2)
 S ABM("R")=ABM("R")_$S(ABM("R")]"":" ",1:"")_ABM
 Q
