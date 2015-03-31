PSODGAL ;BIR/LC-DRUG ALLERGY REACTION CHECKING ;03-Oct-2012 16:10;DU
 ;;7.0;OUTPATIENT PHARMACY;**26,243,1015**;DEC 1997;Build 62
 ;External reference to ^GMRADPT supported by DBIA 10099
 ;External reference to ORCHK^GMRAOR supported by DBIA 2378
 ;External reference to $P(^GMR(120.8,LP,3),"^",3) supp. by DBIA 2214
 ;External reference to ^PS(50.605 supported by DBIA 696
 ;External reference to EN1^GMRAOR2 supported by DBIA 2422
 ;External reference to GETDATA^GMRAOR supported by DBIA 4847
 ;External reference to ^TMP("GMRAOC" supported by DBIA 4848
 ;External reference to ^XUSEC("PSORPH" supported by DBIA 10076
 ;Modified - IHS/MSC/MGH - 04/06/2012 - Allergy reactions added patch 1014
CHK(DFN,TYP,PTR) ;matched to ndf
 ;IHS/MSC/MGH - 04/06/2012
 ;K ^TMP("PSODAI",$J) S PSOACK=$$ORCHK^GMRAOR(DFN,TYP,PTR) D:$G(PSOACK)=1
 K ^TMP("PSODAI",$J) S PSOACK=$$ORCHK^GMRAOR(DFN,TYP,PTR,"",1,1) D:$G(PSOACK)=1
 .Q:$D(^XUSEC("PSORPH",DUZ))
 .S ^TMP("PSODAI",$J,0)=1
 .S I=0 F  S I=$O(GMRAING(I)) Q:'I  S ^TMP("PSODAI",$J,I,0)=GMRAING(I)
 D:$G(PSOACK)=1 DSPLY
 ;IHS/MSC/MGH - 04/06/12
 ;K PSOACK,GMRAING,I
 K PSOACK,GMRAING,GMRAREAC,I,GMRACOM
 Q
CHK1(DFN) ;not matched to ndf
 K ^TMP("PSODAI",$J)
 S GMRA="0^0^001" D ^GMRADPT F LP=0:0 S LP=$O(GMRAL(LP)) Q:'LP!($G(PSOACK))  D:$D(^GMR(120.8,LP,0))
 .S:'$D(PSOACK) APTR=$P(^GMR(120.8,LP,0),"^",3)
 .I $P(APTR,";",2)="PSDRUG(",$P(APTR,";")=PSODRUG("IEN") S PSOACK=1
 .Q:$D(^XUSEC("PSORPH",DUZ))  S:$G(PSOACK)=1 ^TMP("PSODAI",$J,0)=1
 .;IHS/MSC/MGH Updated for reactions patch 1015
 .D GETREAC^GMRAOR(LP)
 .D GETCOM^GMRAOR(LP)
 D:$G(PSOACK)=1 DSPLY
 K APTR,GMRA,GMRAL,LP,PSOACK
 Q
 ;
CLASS(DFN) ;
 N CPT,CLCHK,CT,AGNL,CC,GMRA,LEN
 S LEN=4
 I $E(PSODRUG("VA CLASS"),1,4)="CN10" S LEN=5 ;look at 5 chars if ANALGESICS
 K ^TMP($J,"PSODRCLS")
 I $T(GETDATA^GMRAOR)]"" G CLASS2 ; CHECK FOR EXISTENCE OF NEW ENTRY POINT BEFORE USING
 S CLCHK=""
 S GMRA="0^0^111" D ^GMRADPT F CC=0:0 S CC=$O(GMRAL(CC)) Q:'CC  D
 .K AGNL D EN1^GMRAOR2(CC,"AGNL")
 .I $D(AGNL("V")) F CT=0:1 S CPT=$O(AGNL("V",CT)) Q:'CPT  I $E($P($G(AGNL("V",CPT)),"^"),1,LEN)=$E(PSODRUG("VA CLASS"),1,LEN) D
 ..S CLCHK=$G(CLCHK)+1,^TMP($J,"PSODRCLS",CLCHK)=$P($G(AGNL("V",CPT)),"^")_" "_$P($G(AGNL("V",CPT)),"^",2)
 ..;IHS/MSC/MGH Updated for reactions Patch 1015
 ..N K S K=0 S K=$O(AGNL("S",K)) Q:'+K  D
 ...I K=1 S ^TMP($J,"PSODRCLS","REAC",K)="Reactions: "_$G(AGNL("S",K))
 ...E  S ^TMP($J,"PSODRCLS","REAC",K)=$G(AGNL("S",K))
 ..;IHS/MSC/MGH Updated for reactions Patch 1015
 ..N K S K=0 S K=$O(AGNL("C",K)) Q:'+K  D
 ...I K=1 S ^TMP($J,"PSODRCLS","COM",K)="Comments: "_$G(AGNL("C",K))
 ...E  S ^TMP($J,"PSODRCLS","COM",K)=$G(AGNL("C",K))
 ..;END MOD
 G CLASSDSP
CLASS2 ;
 N RET,K,L
 S RET=$$DRCL(DFN)
 I '$G(RET) Q
 S CLCHK="",CT="" F  S CT=$O(GMRADRCL(CT)) Q:CT=""  D
 .I $E(PSODRUG("VA CLASS"),1,LEN)=$E(CT,1,LEN) D
 ..S CLCHK=$G(CLCHK)+1,^TMP($J,"PSODRCLS",CLCHK)=CT_" "_$P(GMRADRCL(CT),"^",2)
 ..;IHS/MSC/MGH Modified for adding reactions patch 1015
 ..S K=0 F  S K=$O(GMRAREAC(CT,K)) Q:'+K  D
 ...I K=1 S ^TMP($J,"PSODRCLS","REAC",K)="Reactions: "_$G(GMRAREAC(CT,K))
 ...E  S ^TMP($J,"PSODRCLS",CLCHK,"REAC",K)=$G(GMRAREAC(CT,K))
 ..;IHS/MSC/MGH Modified for adding comments patch 1015
 ..S K=0 F  S K=$O(GMRACOM(CT,K)) Q:'+K  D
 ...I K=1 S ^TMP($J,"PSODRCLS",CLCHK,"COM",K)="Comments: "_$G(GMRACOM(CT,K))
 ...E  S ^TMP($J,"PSODRCLS",CLCHK,"COM",K)=$G(GMRACOM(CT,K))
 ..;END MOD
CLASSDSP ;
 I '$D(^TMP($J,"PSODRCLS")) Q
 W $C(7),!,"A Drug-Allergy Reaction exists for this medication and/or class!",!
 W !,"Drug: "_PSODRUG("NAME")
 S CT="" F  S CT=$O(^TMP($J,"PSODRCLS",CT)) Q:'CT  W !,"Drug Class: "_^TMP($J,"PSODRCLS",CT)
 ;IHS/MSC/MGH added patch 1015 for reactions
 S K=0 F  S K=$O(^TMP($J,"PSODRCLS","REAC",K)) Q:K=""  D
 .W !,$G(^TMP($J,"PSODRCLS","REAC",K))
 ;IHS/MSC/MGH added patch 1015 for comments
 S K=0 F  S K=$O(^TMP($J,"PSODRCLS","COM",K)) Q:K=""  D
 .W !,$G(^TMP($J,"PSODRCLS","COM",K))
 ;END MOD
 K ^TMP($J,"PSODRCLS")
 S DIR("?",1)="Answer 'YES' if you DO want to enter a reaction for this medication,"
 S DIR("?")="       'NO' if you DON'T want to enter a reaction for this medication,"
 S DIR(0)="SA^1:YES;0:NO",DIR("A")="Do you want to Intervene? ",DIR("B")="Y" W ! D ^DIR
 I Y D ^PSORXI
 I '$G(Y) K DIR,DTOUT,DIRUT,DIROUT,DUOUT,Y Q
 Q
DSPLY ;
 W $C(7),!,"A Drug-Allergy Reaction exists for this medication and/or class!",!
 I $D(^XUSEC("PSORPH",DUZ)) D
 .W !,"Drug: "_PSODRUG("NAME") I $O(GMRAING(0)) W !,?6,"Ingredients: "
 .S DIR("?",1)="Answer 'YES' if you DO want to enter a reaction for this medication,"
 .S DIR("?")="       'NO' if you DON'T want to enter a reaction for this medication,"
 .W ?19 S I=0 F  S I=$O(GMRAING(I)) Q:'I  W:$X+$L($G(GMRAING(I)))+2>IOM !?19 W $G(GMRAING(I))_", "
 .;IHS/MSC/MGH Added for reactions
 .I $O(GMRAREAC(0)) D
 ..W !,?6,"Reactions: "
 ..W ?19 S I=0 F  S I=$O(GMRAREAC(I)) Q:'I  W:$X+$L($G(GMRAREAC(I)))+2>IOM !?19 W $G(GMRAREAC(I))_", "
 .;IHS/MSC/MGH Added for comments
 .I $O(GMRACOM(0)) D
 ..W !,?6,"Comments: "
 ..S K=0 F  S K=$O(GMRACOM(K)) Q:'+K  D
 ...S L=0 F  S L=$O(GMRACOM(K,L)) Q:'+L  D
 ....W ?19,$G(GMRACOM(K,L,0))_" "
 .;END MOD
 .S DIR(0)="SA^1:YES;0:NO",DIR("A")="Do you want to Intervene? ",DIR("B")="Y" W ! D ^DIR
 .I 'Y K DIR,DTOUT,DIRUT,DIROUT,DUOUT,Y Q
 .I Y D ^PSORXI
 K DIR,DTOUT,DIRUT,DIROUT,DUOUT,Y,I,K,L
 Q
 ;
DRCL(DFN) ;
 ;IHS/MSC/MGH - 04/06/12
 ;N RET
 N RET,J
 S RET=0
 K GMRADRCL
 D GETDATA^GMRAOR(DFN)
 Q:'$D(^TMP("GMRAOC",$J,"APC")) 0
 N GMRACL
 S GMRACL="" F  S GMRACL=$O(^TMP("GMRAOC",$J,"APC",GMRACL)) Q:'$L(GMRACL)  D
 .N GMRANM,GMRALOC
 .S GMRALOC=^TMP("GMRAOC",$J,"APC",GMRACL)
 .S GMRANM=$P(^PS(50.605,+$O(^PS(50.605,"B",GMRACL,0)),0),U,2)
 .S GMRADRCL(GMRACL)=GMRACL_U_GMRANM_" ("_GMRALOC_")"
 .;IHS/MSC/MGH added for reaction data
 .S J=0 F  S J=$O(^TMP("GMRAOC",$J,"APC",GMRACL,"REAC",J)) Q:'+J  D
 ..S GMRAREAC(GMRACL,J)=$G(^TMP("GMRAOC",$J,"APC",GMRACL,"REAC",J))
 .;IHS/MSC/MGH added for comment data
 .S J=0 F  S J=$O(^TMP("GMRAOC",$J,"APC",GMRACL,"COM",J)) Q:'+J  D
 ..S GMRACOM(GMRACL,J)=$G(^TMP("GMRAOC",$J,"APC",GMRACL,"COM",J))
 .;END MOD
 .S RET=RET+1
 K ^TMP("GMRAOC",$J)
 Q RET
