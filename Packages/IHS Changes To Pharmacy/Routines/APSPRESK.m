APSPRESK ; IHS/DSD/ENM - BHAM ISC/SAB/ENM - RETURN TO STOCK ;21-Mar-2004 20:36;PLS
 ;;7.0;IHS PHARMACY MODIFICATIONS;;09/03/97
 ;MODIFIED VERSION OF PSORESK BY ENM
 ; Modified - 01/21/04 - Changed calls to PSONUM to APSPNUM
 S:$G(PSOFROM)']"" PSOFROM="RETURN" ;IHS/DSD/ENM 02/07/96
AC S PSIN=+$P(^PS(59.7,1,49.99),"^",2)
 ;IHS/DSD/ENM  6.14.95 Next 13 lines added for multi-lkup&view Rx data
START G:$D(PSOSD)'>1 END ;IHS/DSD/ENM/POC 3/5/98
 D INIT,LKUP G:PSORXED("QFLG") END D PARSE,EX G AC
END D EX
EMQ Q
INIT S PSORXED("QFLG")=0 Q
LKUP ;S PSONUM="RX",PSONUM("A")="Return to Stock",PSOQFLG=0 D EN1^APSPNUM I PSOQFLG!($Q(PSOLIST)']"") S PSORXED("QFLG")=1 ;IHS/DSD/ENM 10/01/96
 N PSOOPT S PSOOPT=0 ;IHS/DSD/ENM 10/01/96
 S PSONUM("A")="Return to Stock ",PSOQFLG=0 D ^APSPNUM I $G(PSOQFLG)']""!($Q(PSOLIST)']"") S PSORXED("QFLG")=1 ;IHS/DSD/ENM 10/30/97
 K PSOQFLG Q
 ;
PARSE F PSORXED("LIST")=1:1 Q:'$D(PSOLIST(PSORXED("LIST")))!PSORXED("QFLG")  F PSORXED("I")=1:1:$L(PSOLIST(PSORXED("LIST"))) S PSORXED("IRXN")=$P(PSOLIST(PSORXED("LIST")),",",PSORXED("I")) D:+PSORXED("IRXN") BC
 Q
BC ;W !! S DIR("A")="Enter PRESCRIPTION number",DIR("?")="^D HP^PSORESK",DIR(0)="FO" D ^DIR K DIR G:$D(DIRUT) EX
 S APSPX="" D ^APSPRXV S (X,Y)=APSPX9 ;IHS/DSD/ENM DISPLAY RX INFO
 ;G:$D(DIRUT) EX ;IHS/DSD/ENM 5.19.95
 Q:APSPQ  ;IHS/DSD/ENM 5.19.95
 I X'["-" D BCI W:'$G(RXP) !,"INVALID Rx" G:'$G(RXP) EMQ G BC1
 I X["-",$P(X,"-")'=$P(^DD("SITE",1),"^") W !,*7,*7,"   INVALID STATION NUMBER !!",*7,*7,! Q
 I X["-" S RXP=$P(X,"-",2) I '$D(^PSRX(+$G(RXP),0))!($G(RXP)']"") W !,*7,*7,*7,"   NON-EXISTENT Rx" Q
 G:$D(^PSRX(RXP,0)) BC1
 W !,*7,*7,*7,"   IMPROPER BARCODE FORMAT" Q
BC1 ;
 I $S('+$P($G(^PSRX(+RXP,0)),"^",15):0,$P(^(0),"^",15)=11:0,$P(^(0),"^",15)=12:0,1:1) D STAT Q
 S COPAYFLG=1,QDRUG=$P($G(^PSRX(RXP,0)),"^",6),QTY=$P($G(^(0)),"^",7) I $O(^PSRX(RXP,1,0)) G REF
 I $O(^PSRX(RXP,"P",0)) D  Q:$D(DTOUT)!($D(DUOUT))
 .S DIR(0)="SA^O:ORIGINAL;P:PARTIAL",DIR("B")="ORIGINAL",DIR("A",1)="",DIR("A",2)="There are Partials for this Rx.",DIR("A")="Which are you Returning To Stock? "
 .S DIR("?")=" Press return for Original. Enter 'P' for Partial" D ^DIR K DIR
 ;S XTYPE=$S(Y="O":"O",1:"P") G:Y="P" PAR
 S XTYPE=$S(Y="P":"P",1:"O") G:Y="P" PAR ;RX REF IN ACT LOG DEF ORIG
 I $P($G(^PSRX(RXP,2)),"^",15) W !,*7,*7,"Original fill for Rx # "_$P(^PSRX(RXP,0),"^")_" was RETURNED TO STOCK." Q
 I '$P($G(^PSRX(RXP,2)),"^",13),$P($G(^(2)),"^",2)'<PSIN W !,*7,*7,"Rx # "_$P(^PSRX(RXP,0),"^")_" was NOT released !" Q
 I $P($G(^PSRX(RXP,2)),"^",2)<PSIN D  Q
 .W !!,*7,*7,"Original Fill CANNOT be Returned!",!,"This fill entered before installation of version 6.  There are no refills.",!
 W ! S DIR("B")="Y",DIR("A")="Are you sure you want to RETURN TO STOCK Rx # "_$P(^PSRX(RXP,0),"^"),DIR(0)="YO" D ^DIR K DIR G:Y=0 EMQ G:$G(DIRUT) EMQ
 ;ORI
 I $P($G(^PSRX(RXP,2)),"^",2)'<PSIN D  D EX Q
 .;I +$G(^PSRX(RXP,"IB")) D CP Q:'$G(COPAYFLG) ;IHS/DSD/ENM 03/06/97
 .I $G(^PSDRUG(QDRUG,660.1)) S ^PSDRUG(QDRUG,660.1)=^PSDRUG(QDRUG,660.1)+QTY
 .D NOW^%DTC S DA=RXP,DIE="^PSRX(",DR="12COMMENTS;31///@;32.1///"_% L +^PSRX(DA):20 D ^DIE K DIE,DR L -^PSRX(DA) K DA Q:$D(Y)
 .D ACT S DA=$O(^PS(52.5,"B",RXP,0)) I DA S DIK="^PS(52.5," D ^DIK
 .W !,"Rx # "_$P(^PSRX(RXP,0),"^")_" RETURNED TO STOCK.",!
 .D STOCK ;IHS/DSD/ENM/POC 01/28/98 ADDS A REFILL
 .D  ;IHS/OKCAO/POC 8/18/2000
 ..N APSQPST
 ..S APSQPST=$$EN^APSQBRES(RXP,"","D")
 .D PCC ;IHS/DSD/ENM 02/09/96
REF I $O(^PSRX(RXP,1,0)),$O(^PSRX(RXP,"P",0)) D  Q:$D(DTOUT)!($D(DUOUT))  S XTYPE=$S(Y="R":1,1:"P")
 .S DIR(0)="SA^R:REFILL;P:PARTIAL",DIR("B")="REFILL",DIR("A",1)="",DIR("A",2)="There are Refills and Paritals for this Rx.",DIR("A")="Which are you Returning To Stock? "
 .S DIR("?")=" Press return for Refill. Enter 'P' for Partial" D ^DIR K DIR
PAR S:$G(XTYPE)']"" XTYPE=1 S TYPE=0 F YY=0:0 S YY=$O(^PSRX(RXP,XTYPE,YY)) Q:'YY  S TYPE=YY
 I 'TYPE D EX Q
 I $P($G(^PSRX(RXP,XTYPE,TYPE,0)),"^",16) W *7,!!,"Last Fill Already Returned to Stock !",! D EX Q
 I '$P(^PSRX(RXP,XTYPE,TYPE,0),"^",$S(XTYPE:18,1:19)),$P(^(0),"^")'<PSIN W !!,*7,*7,$S(XTYPE:"Refill",1:"PARTIAL")_" #"_TYPE_" was NOT released !",! Q
 I '$P(^PSRX(RXP,XTYPE,TYPE,0),"^",$S(XTYPE:18,1:19)),$P(^(0),"^")<PSIN D  Q
 .W !!,*7,*7,$S(XTYPE:"Refill",1:"PARTIAL")_" #"_TYPE_" CANNOT be Returned!",!,"This fill entered before installation of version 6.",!
 W ! K DIR,DUOUT,DTOUT
 S DIR("B")="Y",DIR("A",1)="Are you sure you want to RETURN TO STOCK",DIR("A")="Rx # "_$P(^PSRX(RXP,0),"^")_$S(XTYPE:" REFILL ",1:" PARTIAL ")_"# "_TYPE,DIR(0)="YO"
 D ^DIR K DIR Q:'Y!($D(DUOUT))!($D(DTOUT))
 D PCC ;IHS/DSD/ENM 12/26/95
 ;I +$G(^PSRX(RXP,"IB")),XTYPE D CP Q:'$G(COPAYFLG)
 D NOW^%DTC S QTY=$P(^PSRX(RXP,XTYPE,TYPE,0),"^",4) S:$G(^PSDRUG(QDRUG,660.1)) ^PSDRUG(QDRUG,660.1)=^PSDRUG(QDRUG,660.1)+QTY
 S DA(1)=RXP,DA=TYPE,DIE="^PSRX("_DA(1)_","_$S(XTYPE:1,1:"""P""")_",",DR=$S(XTYPE:"3COMMENTS;14////"_%_";17////@",1:".03COMMENTS;5////"_%_";8////@")
 L +^PSRX(DA(1)):20 W ! D ^DIE L -^PSRX(DA(1)) G:$D(Y) EMQ D ACT
 W !!,"Rx # "_$P(^PSRX(RXP,0),"^")_$S(XTYPE:" REFILL",1:" PARTIAL")_" #"_TYPE_" RETURNED TO STOCK" S DA=$O(^PS(52.5,"B",RXP,0)) I DA S DIK="^PS(52.5," D ^DIK
 D STOCK ;IHS/DSD/ENM/POC 01/28/98 ADDS A REFILL
 D  ;IHS/OKCAO/POC 8/18/2000 FOR BILLING
 .N APSQPST
 .S APSQPST=$$EN^APSQBRES(RXP,TYPE,"D")
 Q
EX K DA,DR,DIE,X,X1,X2,Y,RXP,REC,DIR,XDT,REC,RDUZ,DIRUT,PSOCPN,PSOCPRX,YY,QDRUG,QTY,TYPE,XTYPE,I,%,DIRUT,COPAYFLG,APSPQ,APSPX
 ;K PS,PSIN,RXN,SEX,SSN,AGE,APSP,APSPD,APSPL,APSPLTYP,APSPMM,APSPRXX,APSPX9,APST,D,D0,DFN,DOB ;IHS/DSD/ENM 04/29/99
 K PS,RXN,SEX,SSN,AGE,APSP,APSPD,APSPL,APSPLTYP,APSPMM,APSPRXX,APSPX9,APST,D,D0,DFN,DOB ;IHS/DSD/ENM 04/29/99;IHS/DSD/LWJ 09/03/99
 Q
HP ;W !!,"Wand the barcode number of the Rx or manually key in",!,"the number below the barcode or the Rx number."
 ;W !,"The barcode number should be of the format - 'NNN-NNNNNNN'",!!,"Press 'ENTER' to process Rx or ""^"" to quit"
 W !,"Enter the Rx number you would like to return to stock." ;IHS/DSD/ENM 5.18.95
 Q
BCI ;S RXP=0
RXP ;S RXP=$O(^PSRX("B",X,RXP)) I $P($G(^PSRX(+RXP,0)),"^",15)=13 G RXP
 S RXP=APSPX ;I $P($G(^PSRX(+RXP,0)),"^",15)=13 G RXP ;IHS/DSD/ENM 03/0697
 Q
STAT S RX0=^PSRX(RXP,0),RX2=^PSRX(RXP,2),J=RXP D ^PSOFUNC
 W !!,*7,*7,"Rx has a status of "_ST_" and cannot be returned to stock.",!
 K RX0,ST Q
CP ;S PSOCPRX=$P(^PSRX(RXP,0),"^") S PSO=1,PSODA=RXP,PSOPAR7=$G(^PS(59,PSOSITE,"IB")) W !!,"ATTEMPTING TO REMOVE COPAY CHARGES",! D RXED^PSOCPA
 ;I COPAYFLG=0 W !!,"REASON MUST BE ENTERED. Rx ",$P(^PSRX(RXP,0),"^")," NOT RETURNED TO STOCK.",!
 Q
ACT S IFN=0 F I=0:0 S I=$O(^PSRX(RXP,"A",I)) Q:'I  S IFN=I
 D NOW^%DTC S IFN=IFN+1,^PSRX(RXP,"A",0)="^52.3DA^"_IFN_"^"_IFN,^PSRX(RXP,"A",IFN,0)=%_"^I^"_DUZ_"^"_$S(XTYPE="O":0,XTYPE:$G(TYPE),1:6)_"^ RETURNED TO STOCK"
 K DA Q
PCC ;Data link to IHS/PCC (cancel/reinstate) ;IHS/DSD/ENM 11/29/95
 I $P(%APSITE,U,15)="Y" S APSRX=RXP,APSREA="C",APSPFROM="R" D ^APSPCCC ;IHS/DSD/ENM 02/09/96
 Q
STOCK ;ADD ONE BACK TO STOCK ;IHS/DSD/ENM/POC
 S $P(^PSRX(RXP,0),"^",9)=$P(^PSRX(RXP,0),"^",9)+1
 K PSOSD ;NODE REMOVED SO THAT RX PROFILE WILL BE REBUILD
 Q
