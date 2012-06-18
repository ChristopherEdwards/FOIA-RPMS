AMQQEM11 ; IHS/CMI/THL - OVERFLOW FROM AMQQEMAN ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
MARK W !!,"---------",!!
 Q
 ;
FWD S AMQQEMS=AMQQERUN_U_AMQQEMS
 Q
 ;
BACKUP S AMQQERUN=$P(AMQQEMS,U)-1
 S AMQQEMS=$P(AMQQEMS,U,2,99)
 Q
 ;
CK I $D(DIRUT)!($D(DUOUT))!($D(DTOUT))!($D(DIROUT))!(X="") K DIRUT,DUOUT,DTOUT,DIROUT S AMQQQUIT=""
 Q
 ;
DATA ; EP FROM AMQQEMAN
 D MARK
 W "ASSIGN DATA TYPE TO EACH FIELD",!
 I $D(AMQQEM("DATA")) S DIR("B")=AMQQEM("DATA")
 E  S DIR("B")="DATA TYPE NOT REQUIRED"
 S DIR("?")="Many types of analytic/graphic software require you to assign a 'data type' (e.g., number, date, free text etc.) to ea. field in the file"
 S DIR(0)="S^0:DATA TYPE NOT REQUIRED;1:E-MAN WILL ASSIGN DATA TYPES AUTOMATICALLY;2:E-MAN WILL PROMPT YOU TO ASSIGN A DATA TYPE TO EA. FIELD"
 S DIR("A")="     Your choice"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I X=U D BACKUP Q
 D CK
 I $D(AMQQQUIT) Q
 D FWD
 S AMQQEM("DATA")=Y
 D SAVE
 I $D(AMQQEMNO) K AMQQEMNO G DATA
 Q
 ;
MLEN ; - EP - DEL FIELD LENGTH ; 7 ; ENTRY POINT FROM AMQQEMAN
 D MARK
 W "MAXIMUM FIELD LENGTH",!
 I $D(AMQQEM("MLEN")) S DIR("B")=AMQQEM("MLEN")
 S DIR(0)="N^1:"_(AMQQEM("LEN")-1)_":"
 S DIR("A")="Max. delimited field length"
 S DIR("?")="The typical maximum length for a delimited field is 16-24 characters.  Check the user's guide for the analytic/graphic software"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I X=U D BACKUP Q
 D CK
 I $D(AMQQQUIT) Q
 I Y<1 W "  ??",*7 G MLEN
 D FWD
 S AMQQEM("MLEN")=Y
 S AMQQERUN=8
 Q
 ;
FIX ; - EP -
 D MARK
 W "INDIVIDUAL FIELD LENGTH",!
 I $D(AMQQEM("FIX")) S DIR("B")=AMQQEM("FIX")
 S DIR(0)="N^1:"_AMQQEM("LEN")_":"
 S DIR("A")="Field length (no. characters)"
 S DIR("?")="Enter the number of characters in the fixed length field.  See your analytic/graphic software user's guide"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I X=U D BACKUP Q
 D CK I $D(AMQQQUIT) Q
 I Y<1 W "  ??",*7 G FIX
 D FWD S AMQQEM("FIX")=Y
 Q
 ;
HLEN ; - EP - DEL FIELD LENGTH ; 9 ; ENTRY POINT FROM AMQQEMAN
 D MARK
 W "MAXIMUM LENGTH OF FIELD HEADER/VARIABLE NAME",!
 I $D(AMQQEX("NO HEADER")) K AMQQEX("NO HEADER") S AMQQEM("HLEN")=0
 I $D(AMQQEM("HLEN")) S DIR("B")=AMQQEM("HLEN")
 I '$D(DIR("B")) S DIR("B")=$G(AMQQEM("MLEN"))+$G(AMQQEM("FIX"))
 S AMQQEM("HLEN")=$G(AMQQEM("MLEN"))+$G(AMQQEM("FIX"))
 S DIR(0)="N^0:"_AMQQEM("HLEN")_":"
 S DIR("A")="Max. header/name length"
 S DIR("?")="The typical maximum length for a header/name is 8 characters.  Check the user's guide of your analytic/graphic software"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I X=U D BACKUP Q
 D CK
 I $D(AMQQQUIT) Q
 I Y<0 W "  ??",*7 G MLEN
 I 'Y S AMQQEX("NO HEADER")="" D FWD Q
 D FWD
 S AMQQEM("HLEN")=Y Q
 Q
 ;
SAVE ; SAVE CUSTOM CONFIG
 D MARK
 W "SAVE CUSTOM CONFIGURATION"
 W !! S DIR(0)="Y"
 S DIR("A")="Want to save this custom configuration for future use"
 S DIR("B")="NO"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I X=U S AMQQEMNO="" Q
 D CK
 I $D(AMQQQUIT) Q
 I 'Y Q
S1 S DIC="^AMQQ(3,"
 S DIC(0)="AEMQL"
 S DIC("A")="Enter Configuration name: "
 D ^DIC
 K DIC
 I U[X S AMQQEMNO="" Q
 D CK
 I $D(AMQQQUIT) Q
 I Y=-1 Q
 I '$P(Y,U,3) W !!,*7,"A configuration with this name already exists." D  Q:$D(AMQQQUIT)  I Y=0 G S1
 .I DUZ,$P(^AMQQ(3,+Y,0),U,9)'=DUZ W "  Select another name..." S Y=0 Q
 .S DIR(0)="Y"
 .S DIR("A")="Want to replace it with another of the same name"
 .S DIR("B")="NO"
 .S DIR("?")="If you replace the configutation the old configuraton will cease to exist.  If you want to keep the old configuration, enter'NO' and use a new name."
 .D ^DIR
 .K DIR
 .D CK
 .I $D(AMQQQUIT) Q
 S %="^LEN^TYPE^DEL^MLEN^HLEN^FIX^DATA"
 F I=2:1:8 S X=$P(%,U,I),$P(^AMQQ(3,+Y,0),U,I)=$G(AMQQEM(X))
 Q
 ;
