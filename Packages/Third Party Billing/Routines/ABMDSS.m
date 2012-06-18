ABMDSS ; IHS/ASDST/DMJ - SET UP NEW SITE ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM19365
 ;    Added file # 9002274.32 for 3P Cancelled Claims Data
START ;START HERE
 W !!,"This option will initialize a new location for the Third Party "
 W !,"Billing Package. You are logged in as"
 S DIC="^AUTTLOC(",DIC(0)="EMQZ",X="`"_DUZ(2) D ^DIC Q:Y<0  S ABM("LOC")=+Y(0) W !
 S DIR(0)="Y",DIR("A")="Initialize Site "_$P(Y(0),"^",2),DIR("B")="NO" D ^DIR K DIR Q:Y'=1
LOOP ;LOOP THROUGH 3P FILES
 F I=1:1 S ABM("FN")=$P($T(TXT+I),";;",2) Q:'ABM("FN")  D
 .S ABM("GL")=^DIC(ABM("FN"),0,"GL")_"0)"
 .Q:$D(@(ABM("GL")))
 .W !,"Initializing ",$P(^DIC(ABM("FN"),0),U)," file."
 .S @ABM("GL")=^DIC(ABM("FN"),0)
 .I ABM("FN")=9002274.5 S ^ABMDPARM(ABM("LOC"),1,0)=ABM("LOC"),^ABMDPARM(ABM("LOC"),"B",ABM("LOC"),1)=""
 D ERR
 D INS
 W !!,"Site ",$P(ABM("LOC"),"^",2)," initialized.",!
 D EOP^ABMDUTL(1)
 K ABM
 Q
ERR ;ADD ENTRY TO 3P ERROR FILE
 S I=0 F  S I=$O(^ABMDERR(I)) Q:'I  D
 .S:'$D(^ABMDERR(I,31,0)) ^(0)="^9002274.0431P^^"
 .S ^ABMDERR(I,31,ABM("LOC"),0)=ABM("LOC")_"^^"_$P(^ABMDERR(I,0),"^",3)_"^"_$P(^(0),"^",4)
 .S ^ABMDERR(I,31,"B",ABM("LOC"),ABM("LOC"))=""
 Q
INS ;set up 3P insurer file
 Q:$O(^ABMNINS(DUZ(2),0))
 S I=0 F  S I=$O(^AUTNINS(I)) Q:'I  D
 .Q:'$D(^AUTNINS(I,39))
 .S ^ABMNINS(DUZ(2),I,0)=$P(^AUTNINS(I,0),U)
 .M ^ABMNINS(DUZ(2),I,1)=^AUTNINS(I,39)
 .S $P(^ABMNINS(DUZ(2),I,1,0),"^",2)="9002274.091P"
 .S J=0 F  S J=$O(^ABMNINS(DUZ(2),I,1,J)) Q:'J  D
 ..S:$D(^ABMNINS(DUZ(2),I,1,J,11,0)) $P(^(0),"^",2)=9002274.09111
 S DIK="^ABMNINS(DUZ(2)," D IXALL^DIK
 Q
TXT ;FILE NUMBERS
 ;;9002274.09
 ;;9002274.3
 ;;9002274.32
 ;;9002274.4
 ;;9002274.5
 ;;9002274.6
 ;;9002274.9
 ;;end of list
