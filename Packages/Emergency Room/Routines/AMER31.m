AMER31 ; IHS/ANMC/GIS -ISC - ENTER DIAGNOSES ;  
 ;;3.0;ER VISIT SYSTEM;;FEB 23, 2009
 ;
QD11 ; ENTRY POINT FROM AMER3  
 ; FINAL DIAGNOSIS
 N %,AMERPDX,AMERDXI,AMERDXN,AMERDXC,DIC,DIR
 S AMERDXI=$O(^TMP("AMER",$J,2,11,999),-1)
 I $D(^TMP("AMER",$J,2,11)) D PREV^AMER3(11) S AMEROPT=""
DX S DIR("A",1)="*Enter narrative description of  "_$S($D(^TMP("AMER",$J,2,11,.1)):"a ",1:"the PRIMARY ")_$S($D(AMERDOA):"cause of death",1:"diagnosis")_": "
 S DIR("A")=""
 I $D(^TMP("AMER",$J,2,11,.1)) S DIR(0)="FAO^1:80" G DXN
 S DIR(0)="FA^1:80",AMERPDX=""
 S DIR("?")="Enter free text diagnosis (80 characters max.  ';' and ':' not allowed)"
DXN D ^DIR,OUT^AMER I $D(AMERQUIT) Q
 D CKSC^AMER1 I $D(AMERCKSC) K AMERCKSC G DX
 I "^"[X S Y="" Q
 S %=$$OLD(Y) I $D(AMERQUIT) Q
 I %?1."^" S Y="",AMEROPT="" Q
 I %=0 S Y="" Q
 I % W ! G DX
 S AMERDXN=%
DXP S DIC("A")="*Enter ICD9 code: " K DIC("B")
 I $D(AMERPDX) S %=$G(^TMP("AMER",$J,2,11,.1)) I %]"" S %=$P(%," [",2),DIC("B")=$P(%,"]")
 S Y=0
 I $G(DIC("B"))="" S DIC("B")=".9999"
DX1 S DIC="^ICD9(",DIC(0)="AEQMI"
 S:$D(APCDEIN) APCDTPCC="" S DIC("S")="D ^AUPNSICD"
 D ^DIC K DIC
 I X?2."^" S DIROUT=""
 D OUT^AMER I $D(AMERQUIT) Q
 I X=U G DXN
 S AMERDXC=$P(Y,U,2)
 I $D(AMERPDX) S %=.1
 E  S AMERDXI=AMERDXI+1,%=AMERDXI
SET S ^TMP("AMER",$J,2,11,%)=+Y_U_AMERDXN_" ["_AMERDXC_"]",Y=0,AMEROPT="" K AMERPDX
 K DIR("A",1)
 S DIR("A")="Enter another "_$S($D(AMERDOA):"cause of death",1:"diagnosis")_": " K DIR("B") S DIR(0)="FAO^1:80"
 G DXN
 ;
OLD(Y) ; CHECK FOR PREVIOUSLY SELECTED DIAGNOSES
 N X,Z,%,I,J,A,B,C
 S (J,A)=0 F I=0:0 S I=$O(^TMP("AMER",$J,2,11,I)) Q:'I  S %=$P(^(I),U,2) I $E(%,1,$L(Y))=Y S Z(I)="",J=J+1 I Y=$P(%," [") S A=1
 I 'J Q Y
 I J=1 S %=^TMP("AMER",$J,2,11,$O(Z(0))),%=$P(%,U,2),%=$P(%," [") W $E(%,$L(Y)+1,999) Q $$REP($O(Z(0)))
 Q $$REM(A,.Z,Y)
 ;
REP(Z) ; REPLACE THE PRIMARY DIAGNOSIS
 S DIR("A")="Want to replace this with another "_$S(Z=.1:"PRIMARY ",1:"")_"diagnosis? "
 S DIR(0)="YA" D ^DIR,OUT^AMER I $D(AMERQUIT) Q Y
 I Y K ^TMP("AMER",$J,2,11,Z)
 I Y S AMEROPT=""
 Q Y
 ;
REM(A,Z,T) ; SELECT FROM MULTIPLE MATCHES
 N X,%,I,J
 W !,"Several previously entered diagnoses match your input =>"
 S (I,J)=0 F  S I=$O(Z(I)) Q:'I  S X=^TMP("AMER",$J,2,11,I) D
 .S %=$P(X,U,2),Y=$P(%," ["),J=J+1
 .W !?3,J,?6,Y S J(J)=I
 .Q
 S DIR("A")="Do you want to delete one of them? "
 S DIR(0)="YA" D ^DIR,OUT^AMER I $D(AMERQUIT) Q Y
 I 'Y,'A G REM1
 S DIR("A")="Which one (1-"_J_"): ",DIR(0)="NA^1:"_J_":0"
 D ^DIR,OUT^AMER I $D(AMERQUIT) Q Y
 S %=^TMP("AMER",$J,2,11,J(Y)),%=$P(%,U,2) W "   ",%," has been deleted"
 K ^TMP("AMER",$J,2,11,J(Y))
 Q Y
REM1 ; ADD A NEW DX
 S DIR("A")="Well then, do you want to enter """_T_""" as a new diagnosis? "
 S DIR(0)="YA" D ^DIR,OUT^AMER I $D(AMERQUIT) Q ""
 I 'Y Q 0
 Q T
 ;
STUFF ; STUFF PROVIDER NARRATIVE
 ;IHS/OIT/SCR 11/18/08 this routine is not used
 N X,Y,Z,A,B,C,I,%,DIC,DIE,DA,DR
 S A=0 F  S A=$O(^AMERVSIT(A)) Q:'A  S B=0 F  S B=$O(^AMERVSIT(A,5,B)) Q:'B  S X=^(B,0),Y=$G(^(1)) I X]"",Y="" D
 .S Z=$P($$ICDDX^ICDCODE(+X),U,4)
 .I Z]"" S Z=$E(Z,1,80)
 .S DIC="^AMERVSIT(DA(1),5,",DA(1)=A,DA=B,DR="1////"_Z,DIE=DIC D ^DIE
 .Q
 Q
