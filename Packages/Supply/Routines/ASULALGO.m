ASULALGO ; IHS/ITSC/LMH -ALGOLRYTHM ALPHA TO NUMERIC ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine is used to translate an alphanumeric character to a
 ;2 digit numeric code.  The algolrythm is used to convert codes to
 ;internal record numbers.  Entry points are also available to reverse
 ;the translation.
TR(Z) ;EP ;TRANSLATE ALPHA
 I Z?1N S Y=0_Z Q
 I Z?1A G @Z
 S Y=-1 Q  ;AEF/2970723
A S Y=10 Q
B S Y=11 Q
C S Y=12 Q
D S Y=13 Q
E S Y=14 Q
F S Y=15 Q
G S Y=16 Q
H S Y=17 Q
I S Y=18 Q
J S Y=19 Q
K S Y=20 Q
L S Y=21 Q
M S Y=22 Q
N S Y=23 Q
O S Y=24 Q
P S Y=25 Q
Q S Y=26 Q
R S Y=27 Q
S S Y=28 Q
T S Y=29 Q
U S Y=30 Q
V S Y=31 Q
W S Y=32 Q
X S Y=33 Q
Y S Y=34 Q
Z S Y=35 Q
 Q
USR(X) ;EP ;ACCEPT USER CODE IN X
 N Z
 S Z=$E(X,3) D TR(Z)
 I Y<0 Q
 S X=$E(X,1,2)_Y
 Q
IEN(X) ;EP ;ACCEPT IEN IN X
 N Z
 S Z=$E(X,5,6) D UT^ASULALGO(.Z)  ;AEF/2970721
 I Z<0 Q
 S X=$E(X,3,4)_Z
 Q
UT(Z) ;EP ;
 I $E(Z,2)=0 S Z=$E(Z) Q
 I Z?2N,+Z>9,+Z<36 G @Z  ;AEF/2970722
 S Z=-1 Q  ;AEF/2970722
10 S Z="A" Q
11 S Z="B" Q
12 S Z="C" Q
13 S Z="D" Q
14 S Z="E" Q
15 S Z="F" Q
16 S Z="G" Q
17 S Z="H" Q
18 S Z="I" Q
19 S Z="J" Q
20 S Z="K" Q
21 S Z="L" Q
22 S Z="M" Q
23 S Z="N" Q
24 S Z="O" Q
25 S Z="P" Q
26 S Z="Q" Q
27 S Z="R" Q
28 S Z="S" Q
29 S Z="T" Q
30 S Z="U" Q
31 S Z="V" Q
32 S Z="W" Q
33 S Z="X" Q
34 S Z="Y" Q
35 S Z="Z" Q
