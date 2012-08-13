INHDIA(%T,%F) ;GFT,JSH; 16 Nov 95 16:22;Generic Interface - create an Input Template 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;%T = name of template
 ;%F = file number^global reference
 ;Enter with ^UTILITY("INDIA",$J,n) [n=1,2,3...] containing the lines for the template
 ;
 S DIC=U_$P(%F,U,2) N T S:'$D(DMAX) DMAX=$G(^DD("ROU")) S:'DMAX DMAX=4000
 S DIA=DIC,DI=+%F,(J(0),DIA("P"))=DI,DIA("DIET")=$G(^DIC(DI,0,"DIET"))
 D QQ S DR="",(DIEFMT,L,DIAR,DRS,DIAP,DB,DSC)=0,F=-1,I(0)=DIA,DXS=1 D EN
 Q:'$O(^UTILITY("INDIA",$J,0))
 S INI=0 F  S INI=$O(^UTILITY("INDIA",$J,INI)) Q:'INI  S X=^(INI) W:'(INI#5) "." D L
 F  Q:'F  D UP
STORE ;Store the template
 F F=0:0 S F=$O(^UTILITY($J,"OV",F)) Q:'F  F X=0:0 S X=$O(^UTILITY($J,"OV",F,X)) Q:'X  S DW=DR(F,X),DR(F,X)=^(X,0),I=1 D OV
 G S
 ;
OV I '$D(^(I)) S DR(F,X,I)=DW Q
 S DR(F,X,I)=^(I),I=I+1 G OV
 ;
S S DIC="^DIE(",DIC(0)="LZ",DIC("S")="I $P(^(0),U,4)="_+%F,D="F"_+%F,X=%T D IX^DIC K DIC S %=$P(Y,U,3)
 L +^DIE K ^DIE(+Y) S ^(+Y,0)=X_U_DT_U_"@"_U_+%F_U_U_"@",^DIE("F"_+%F,X,+Y)=1 L -^DIE K ^UTILITY($J,"OV")
 M ^DIE(+Y,"DR")=DR,^DIE(+Y,"DIAB")=^UTILITY($J)
 S X=%T D EN^DIEZ
 ;
Q K DI,DLAYGO,DIA,I,J
QQ K ^UTILITY($J),DICHK,DIAT,DIART,DIAR,DIAB,DIAO,DIAP,DIAA,IOP,DSC,DIA3,DHIT,DRS,DIE,DR,DA,DG,DIC,F,DP,DQ,DV,DB,DW,D,X,Y,L Q
1 Q
L K DIC,DIAB,DIAM S DSC=X?1"^".E I DSC S X=$E(X,2,999) I U[X K DR Q
 I $A(X)=64 G AT^INHDIA3:X'?1P.N,P:$L(X)>1,X:'DB S DB=DB+1 G 2
 D DICS S DV="",J=$P(X,"-",2)
DIC ;
 K Y S DIC(0)="Z",DIC="^DD(DI," D ^DIC
 I Y>0 D SET S Y=$P(Y(0),U,2) G 2:'Y S X=DI,L=L+1,(DI,J(L))=+Y,I(L)=""""_$P($P(Y(0),U,4),";")_"""" G DOWN
 F D=124,93 I $A(X)=D S:D=124 DIAB=X,DIAM=1 S DRS=9,X=$E(X,2,999) G DIC:X]"",UP
 S DIC(0)="Y",D="GR" I $D(^DD(DI,D)) D IX^DIC I Y>0 D SET G 2
 G X^INHDIA3
 ;
F S X=$P(^DD(DI,0),U) I F,X="FIELD" S X=$O(^(0,"NM",0))_" "_X
 Q
 ;
X ;
 W !,*7,"Field: '"_$P(^UTILITY("INDIA",$J,INI),"///")_"' is invalid in template.  (It may be COMPUTED)" K Y D DICS
2 ;
 Q
UP ;
 Q:'F
 K I(L),J(L) S L=L-1 I '$D(J(L)) F L=L-99:1 Q:'$D(J(L+1))
 I DB S DB=DB(F),DIART=DIART(F),DIAO=DIAO(F),DIAT=$S(DIAO<0:"",DIAO:^DIE(DIAA,"DR",DIART,J(L),DIAO),$D(^DIE(DIAA,"DR",DIART,J(L))):^(J(L)),1:"")
 S DIAR=DIAR(F),DIAP=DIAP(F),DI=J(L),F=F-1 G 2
 ;
EN ;
 D DICS
DOWN S F=F+1,DIAP(F)=DIAP,DIAP=0,DIAR(F)=DIAR F %=F+1:.01 I '$D(DR(%,DI)) S:%["." DR(DIAR,X)=DR(DIAR,X)_U_%_";",DIAP(F)=DIAP(F)+1 S DIAR=% Q
 G GO:'DB!$D(DIEFMT) S DIART(F)=DIART,DIART=F+1,%=$P(DIAT,";",DB) I %?1"^".NP S DIART=$P(%,U,2),DB=DB+1
 S DB(F)=DB,DB=1,DIAO(F)=DIAO,DIAO=0,DIAT=$G(^DIE(DIAA,"DR",DIART,DI))
GO G 1:$D(DIAM),1:$O(^DD(DI,.01))>0,1:L#100=0,UP
DICS ;
 S DIC("S")="I Y>.001,$P(^(0),U,2)'[""C"" Q:$G(^(9))=""""  I ^(9)'=U" I DUZ(0)'="@" S DIC("S")="I $P(^(0),U,2)'[""Q"" "_DIC("S")_",$TR(DUZ(0),^(9))'=DUZ(0)"
 Q
 ;
P ;
 S DRS=99,Y=X D DB G 2
 ;
SET S Y=+Y_DV
DB ;
 I DB,'DSC S DB=DB+1
D ;
 I '$D(DR(DIAR,DI)) S DR(DIAR,DI)="",DIAP=0
 E  I $L(DR(DIAR,DI))+$L(Y)>230 F %=0:1 I '$D(^UTILITY($J,"OV",DIAR,DI,%)) S DIAP=DIAP\1000+1*1000,^(%)=DR(DIAR,DI),DR(DIAR,DI)="" Q
 S DR(DIAR,DI)=DR(DIAR,DI)_Y_";",DRS=DRS+1,DIAP=DIAP+1 I $D(DIAB),Y'="Q" S ^UTILITY($J,DIAP#1000,DIAR-1,DI,DIAP\1000)=DIAB
