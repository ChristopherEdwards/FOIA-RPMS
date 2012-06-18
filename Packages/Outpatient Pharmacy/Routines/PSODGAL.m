PSODGAL ;BIR/LC-DRUG ALLERGY REACTION CHECKING ;08/09/95  02:22
 ;;7.0;OUTPATIENT PHARMACY;**26**;DEC 1997
 ;External reference to ^GMRADPT supported by DBIA 10099
 ;External reference to ORCHK^GMRAOR supported by DBIA 2378
 ;External reference to $P(^GMR(120.8,LP,3),"^",3) supp. by DBIA 2214
 ;External reference to EN1^GMRAOR2 supported by DBIA 2422
 ;External reference to ^XUSEC("PSORPH" supported by DBIA 10076
CHK(DFN,TYP,PTR) ;matched to ndf
 K ^TMP("PSODAI",$J) S PSOACK=$$ORCHK^GMRAOR(DFN,TYP,PTR) D:$G(PSOACK)=1 
 .Q:$D(^XUSEC("PSORPH",DUZ))
 .S ^TMP("PSODAI",$J,0)=1
 .S I=0 F  S I=$O(GMRAING(I)) Q:'I  S ^TMP("PSODAI",$J,I,0)=GMRAING(I)
 D:$G(PSOACK)=1 DSPLY
 K PSOACK,GMRAING,I
 Q
CHK1(DFN) ;not matched to ndf
 K ^TMP("PSODAI",$J)
 S GMRA="0^0^001" D ^GMRADPT F LP=0:0 S LP=$O(GMRAL(LP)) Q:'LP!($G(PSOACK))  D:$D(^GMR(120.8,LP,0))
 .S:'$D(PSOACK) APTR=$P(^GMR(120.8,LP,0),"^",3)
 .I $P(APTR,";",2)="PSDRUG(",$P(APTR,";")=PSODRUG("IEN") S PSOACK=1
 .Q:$D(^XUSEC("PSORPH",DUZ))  S:$G(PSOACK)=1 ^TMP("PSODAI",$J,0)=1
 D:$G(PSOACK)=1 DSPLY
 K APTR,GMRA,GMRAL,LP,PSOACK
 Q
 ;
CLASS ;
 ;Q:'PSODRUG("VA CLASS")
 S GMRA="0^0^111" D ^GMRADPT F CC=0:0 S CC=$O(GMRAL(CC)) Q:'CC  D
 .K AGNL D EN1^GMRAOR2(CC,"AGNL")
 .S (CT,CLS,CLCHK)="" I $D(AGNL("V")) F CT=0:1 S CPT=$O(AGNL("V",CT)) Q:'CPT  S:$E($P($G(AGNL("V",CPT)),"^"),1,4)=$E(PSODRUG("VA CLASS"),1,4) CLCHK=1,CLS=CLS_$P($G(AGNL("V",CPT)),"^")_","
 .D:$G(CLCHK)
 ..W $C(7),!,"A Drug-Allergy Reaction exists for this medication and/or class!",!
 ..W !,"Drug: "_PSODRUG("NAME")
 ..W !,"Drug Class(es): "_CLS
 ..S DIR("?",1)="Answer 'YES' if you DO want to enter a reaction for this medication,"
 ..S DIR("?")="       'NO' if you DON'T want to enter a reaction for this medication,"
 ..S DIR(0)="SA^1:YES;0:NO",DIR("A")="Do you want to Intervene? ",DIR("B")="Y" W ! D ^DIR
 ..I Y D ^PSORXI
 ..I '$G(Y) K DIR,DTOUT,DIRUT,DIROUT,DUOUT,Y Q
 .K CLS,CPT,CLCHK,CT,AGNL
 K CC,GMRA
 Q
DSPLY ;
 W $C(7),!,"A Drug-Allergy Reaction exists for this medication and/or class!",!
 I $D(^XUSEC("PSORPH",DUZ)) D
 .W !,"Drug: "_PSODRUG("NAME") I $O(GMRAING(0)) W !,?6,"Ingredients: "
 .S DIR("?",1)="Answer 'YES' if you DO want to enter a reaction for this medication,"
 .S DIR("?")="       'NO' if you DON'T want to enter a reaction for this medication,"
 .W ?19 S I=0 F  S I=$O(GMRAING(I)) Q:'I  W:$X+$L($G(GMRAING(I)))+2>IOM !?19 W $G(GMRAING(I))_", "
 .S DIR(0)="SA^1:YES;0:NO",DIR("A")="Do you want to Intervene? ",DIR("B")="Y" W ! D ^DIR
 .I 'Y K DIR,DTOUT,DIRUT,DIROUT,DUOUT,Y Q
 .I Y D ^PSORXI
 K DIR,DTOUT,DIRUT,DIROUT,DUOUT,Y
 Q
