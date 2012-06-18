BHLPRV ;cmi/sitka/maw  - HL7 provider functions ;  
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;
 ;this routine will return various components of a provider
 ;
 ;F is defined as:
 ;I - returns ien of provider in file 200 or 6
 ;T - returns provider' initials
 ;A - returns internal set of affiliation (e.g. 1)
 ;B - returns external of affiliation (e.g. IHS)
 ;C - returns provider's code
 ;D - returns provider's discipline code (E.G. 01)
 ;E - returns provider's discipline in external format (PHYSICIAN)
 ;F - returns ien of provider's discipline (22)
 ;H - returns provider's dea #
 ;N - returns provider's name in hl7 format
 ;O - returns provider's affl_disc  (e.g. 101 for IHS nurse)
 ;P - returns provider's affl_disc_code (e.g. 101LAB for nurse Lori Ann
 Q
 ;
PROV(P,F) ;EP - provider in many different formats
 NEW %,Y,Z ;IHS/TUCSON/LAB - added ,Z patch 1 5/19/97
 I 'P Q P
 I $P(^AUTTSITE(1,0),U,22),'$D(^VA(200,P)) Q -1
 I '$P(^AUTTSITE(1,0),U,22),'$D(^DIC(6,P)) Q -1
 I $G(F)="" S F="N"
 I F=99 D  Q
 .F I=1:1 S S=$T(@I) Q:S=""  S %="" D @I S $P(BHLV(P),U,I)=%
 I F[";" D  Q
 .F J=1:1 S I=$P(F,";",J) Q:I=""  I I'=99 S %="" D @I S $P(BHLV(P),U,J)=%
 S %="",I=F D @I S $P(BHLV(P),U)=%
 Q %
 ;
I ;EP
 S %=P Q
T ;EP
 S %=$S($P(^AUTTSITE(1,0),U,22):$P($G(^VA(200,P,1)),U,2),1:$P(^DIC(6,P,0),U,2)) Q
A ;EP
 S %=$S($P(^AUTTSITE(1,0),U,22):$P($G(^VA(200,P,9999999)),U),1:$P($G(^DIC(6,P,9999999)),U)) Q
B ;EP
 S %=$S($P(^AUTTSITE(1,0),U,22):$P($G(^VA(200,P,9999999)),U),1:$P($G(^DIC(6,P,9999999)),U))
 Q:%=""
 S %=$$EXTSET^XBFUNC(200,9999999.01,%)
 Q
D ;EP
 D F
 Q:%=""
 S %=$P($G(^DIC(7,%,9999999)),U)
 Q
 ;
E ;EP
 S %=$$VAL^XBDIQ1($S($P(^AUTTSITE(1,0),U,22):200,1:6),P,$S($P(^AUTTSITE(1,0),U,22):53.5,1:2))
 Q
F ;EP
 S %=$$VALI^XBDIQ1($S($P(^AUTTSITE(1,0),U,22):200,1:6),P,$S($P(^AUTTSITE(1,0),U,22):53.5,1:2))
 Q
H ;EP
 S %=$S($P(^AUTTSITE(1,0),U,22):$P($G(^VA(200,P,"PS")),U,2),1:$P($G(^DIC(6,P,0)),U,3)) Q
C ;EP
 S %=$S($P(^AUTTSITE(1,0),U,22):$P($G(^VA(200,P,9999999)),U,2),1:$P($G(^DIC(6,P,9999999)),U,2)) Q
N ;EP
 S %=$S($P(^AUTTSITE(1,0),U,22):$$PN^INHUT($P($G(^VA(200,P,0)),U)),1:$$PN^INHUT($P($G(^DIC(16,P,0)),U))) Q
O ;EP
 NEW A D A Q:%=""  S A=%,%="" D D Q:%=""  S %=A_% Q
P ;EP
 NEW A D A Q:%=""  S A=% NEW D D D Q:%=""  S D=%,%="" D C Q:%=""  S %=A_D_% Q
6 D T Q
7 D A Q
8 D B Q
9 D C Q
10 D D Q
11 D E Q
12 D F Q
13 D N Q
14 D O Q
15 D P Q
 ;
