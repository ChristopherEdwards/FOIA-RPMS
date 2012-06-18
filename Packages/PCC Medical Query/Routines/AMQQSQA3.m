AMQQSQA3 ; IHS/CMI/THL - PIECE OF AMQQSQA0 TO MEET PORTABILITY STANDARDS ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
EN ; - EP - FROM ^AMQQSQA0
WHAT S DIR(0)="SO^1:FIND ALL "_AMQQCNAM_" who have a "_AMQQSQAN_" recorded;2:CANCEL this attribute"
 S DIR("A")=$C(10)_"     What do you want to do"
 S DIR("B")="FIND"
 S DIR("?")=""
 D ^DIR K DIR
 I $D(DUOUT)+$D(DTOUT)+$D(DIRUT) K DTOUT,DIRUT,DTOUT S X="" Q
 S X=$S(Y=1:"ALL",1:"")
 Q
 ;
