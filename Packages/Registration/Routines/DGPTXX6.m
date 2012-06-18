DGPTXX6 ; COMPILED XREF FOR FILE #45 ; 02/13/06
 ; 
 S DIKZK=1
 S DIKZ(0)=$G(^DGPT(DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" S ^DGPT("B",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,1)
 I X'="" I $D(DGK),'$P(^DGPT(DA,0),U,4),$D(^DPT("AA",+$P(^(0),U,2),X)) S %=$N(^(X,0)) I $D(^DPT(X,"DA",%,0)) I '$P(^(0),U,12) S $P(^(0),U,12)=DA D REC^DGPTFCR
 S X=$P(DIKZ(0),U,2)
 I X'="" S L=+^DGPT(DA,0) I L>0 S ^DGPT("AAD",L,X,DA)=""
 S X=$P(DIKZ(0),U,2)
 I X'="" S ^DGPT("AF",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,2)
 I X'="" S L=$S($D(^DGPT(DA,70)):+^(70),1:0) I L'?7N.E S ^DGPT("AADA",X,DA)=""
 S X=$P(DIKZ(0),U,2)
 I X'="" I $P(^DGPT(DA,0),U,4),$P(^(0),U) S ^DGPT("AFEE",$P(^DGPT(DA,0),U),$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,4)
 I X'="" I $P(^DGPT(DA,0),U),$P(^(0),U,2) S ^DGPT("AFEE",$P(^DGPT(DA,0),U),$P(^DGPT(DA,0),U,2),DA)=""
 S X=$P(DIKZ(0),U,6)
 I X'="" S ^DGPT("AS",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,10)
 I X'="" S ^DGPT("AMT",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,12)
 I X'="" S ^DGPT("ACENSUS",$E(X,1,30),DA)=""
 S X=$P(DIKZ(0),U,13)
 I X'="" D
 .N DIK,DIV,DIU,DIN
 .K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGPT(D0,0)):^(0),1:"") S X=$P(Y(1),U,11),X=X S DIU=X K Y S X=DIV S X=2 S DIH=$S($D(^DGPT(DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,11)=DIV,DIH=45,DIG=11 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
 S DIKZ(101)=$G(^DGPT(DA,101))
 S X=$P(DIKZ(101),U,4)
 I X'="" S %=+^DGPT(DA,0) I %>0 S %C=$S($D(^DPT(%,.3)):^(.3),1:"")_"^^^^^^^^^^",^(.3)=$P(%C,U,1,9)_U_X_U_$P(%C,U,11,99),^DPT("ACB",X,%)="" K ^DPT("ACB",+$P(%C,U,10),%),%,%C
 S DIKZ("401P")=$G(^DGPT(DA,"401P"))
 S X=$P(DIKZ("401P"),U,1)
 I X'="" S ^DGPT(DA,"AP",X)=""
 S X=$P(DIKZ("401P"),U,2)
 I X'="" S ^DGPT(DA,"AP",X)=""
 S X=$P(DIKZ("401P"),U,3)
 I X'="" S ^DGPT(DA,"AP",X)=""
 S X=$P(DIKZ("401P"),U,4)
 I X'="" S ^DGPT(DA,"AP",X)=""
 S X=$P(DIKZ("401P"),U,5)
 I X'="" S ^DGPT(DA,"AP",X)=""
 S DIKZ(70)=$G(^DGPT(DA,70))
 S X=$P(DIKZ(70),U,1)
 I X'="" S ^DGPT("ADS",$E(X,1,30),DA)=""
 S X=$P(DIKZ(70),U,1)
 I X'="" S %=$S($D(^DGPT(DA,"M",1,0)):^(0),1:""),%D=+$P(%,U,10),^(0)=$P(%_"^^^^^^^^^^",U,1,9)_U_X_U_$P(%,U,11,99),^DGPT(DA,"M","AM",X,1)="" K:%D'=X ^DGPT(DA,"M","AM",%D,1) K %,%D
 S X=$P(DIKZ(70),U,1)
 I X'="" S L=$P(^DGPT(DA,0),"^",2) I L?7N.E K ^DGPT("AADA",L,DA)
 S X=$P(DIKZ(70),U,2)
 I X'="" I $D(^DGPT(DA,"M",1,0)) S $P(^(0),U,2)=X,$P(^DGPT(DA,"M",1,0),U,16)=$S($D(^DIC(42.4,X,0)):$P(^(0),U,6),1:"")
 S X=$P(DIKZ(70),U,10)
 I X'="" X ^DD(45,79,1,992,1)
 S DIKZ(70)=$G(^DGPT(DA,70))
 S X=$P(DIKZ(70),U,16)
 I X'="" X ^DD(45,79.16,1,992,1)
 S DIKZ(70)=$G(^DGPT(DA,70))
 S X=$P(DIKZ(70),U,17)
 I X'="" X ^DD(45,79.17,1,992,1)
 S DIKZ(70)=$G(^DGPT(DA,70))
 S X=$P(DIKZ(70),U,18)
 I X'="" X ^DD(45,79.18,1,992,1)
 S DIKZ(70)=$G(^DGPT(DA,70))
 S X=$P(DIKZ(70),U,19)
 I X'="" X ^DD(45,79.19,1,992,1)
 S DIKZ(70)=$G(^DGPT(DA,70))
 S X=$P(DIKZ(70),U,20)
 I X'="" X ^DD(45,79.201,1,992,1)
 S DIKZ(70)=$G(^DGPT(DA,70))
 S X=$P(DIKZ(70),U,21)
 I X'="" X ^DD(45,79.21,1,992,1)
 S DIKZ(70)=$G(^DGPT(DA,70))
 S X=$P(DIKZ(70),U,22)
 I X'="" X ^DD(45,79.22,1,992,1)
 S DIKZ(70)=$G(^DGPT(DA,70))
 S X=$P(DIKZ(70),U,23)
 I X'="" X ^DD(45,79.23,1,992,1)
 S DIKZ(70)=$G(^DGPT(DA,70))
 S X=$P(DIKZ(70),U,24)
 I X'="" X ^DD(45,79.24,1,992,1)
 S DIKZ(70)=$G(^DGPT(DA,70))
 S X=$P(DIKZ(70),U,11)
 I X'="" X ^DD(45,80,1,992,1)
END G ^DGPTXX7
