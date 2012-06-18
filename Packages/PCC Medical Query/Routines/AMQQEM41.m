AMQQEM41 ; IHS/CMI/THL - DOCUMENTATION OF EXPORT INSTRUCTIONS ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
RUN N T,I,X,Y,Z,%,I,J
 D VAR,INTRO,LOGIC,FIELD,SET,SAVE
EXIT K AMQQEML
 Q
 ;
VAR S T="^UTILITY(""AMQQ"",$J,""EMAN"",2,AMQQEML)"
 S AMQQEML=0
 Q
 ;
INC S AMQQEML=AMQQEML+1
 Q
 ;
INTRO ;
 S %=$P(@AMQQ200(3)@(DUZ,0),U)
 S %=$P(%,",",2,9)_" "_$P(%,",")
 S %="This report requested by "_%
 D INC
 S @T=%
 D INC
 S Y=DT
 X ^DD("DD")
 S @T="Date created: "_Y
 F %=1,2 D INC S @T=" "
 S %=$G(AMQQEM("MLEN"))
 I % D INC S @T="Record type: DELIMITED"
 S %=$G(AMQQEM("LEN"))
 I % D INC S @T="Maximum record length: "_%
 S %=$G(AMQQEM("DEL"))
 I %'="" D INC S @T="Delimiter: '"_%_"'"
 S %=$G(AMQQEM("FIX"))
 I % D INC S @T="Field length: "_%
 S %=$G(AMQQEM("FILE"))
 I %'="" D INC S @T="Destination path/file: "_%
 F %=1,2 D INC S @T=" "
 Q
 ;
LOGIC ;
 D INC
 S @T="Search criteria =>"
 D INC
 S @T=" "
 F I=0:0 S I=$O(^UTILITY("AMQQ",$J,"LIST",I)) Q:'I  S X=^(I) D
 .S %="",Z=0 I $P(X,",")["W ?" S Z=+$E($P(X,","),4,99) F J=1:1:Z S %=%_" "
 .F J=1:1 S Y=$P(X,",",J) Q:Y=""  I $E(Y)="""",$E(Y,$L(Y))="""" S Y=$E(Y,2,$L(Y)-1),%=%_Y
 .D INC S @T=%
 Q
 ;
FIELD ;
 F %=1,2 D INC S @T=" "
 D INC
 S @T="VARIABLES / FIELDS"
 D INC
 S @T=" "
 D INC
 S @T="NAME                DATA TYPE   LENGTH      COLUMN #"
 D INC
 S @T="------------------- ----------- ----------- -----------"
 F I=1:1 S X=$P(AMQQEMFS,U,I) Q:'X  D
 .S X=^UTILITY("AMQQ",$J,"FLAT",X,0)
 .S X(1)=$P(X,U,6)
 .S X(2)=$P(X,U,4)
 .S X(3)=$P(X,U,7)
 .S X(4)=I
 .S X(1)=$E(X(1),1,19)_$J("",20-$L(X(1)))
 .I $G(AMQQEM("FIX")) S X(3)=AMQQEM("FIX")
 .F J=2:1:4 S X(J)=$E(X(J),1,11) I J'=4 S X(J)=X(J)_$J("",12-$L(X(J)))
 .S X=""
 .F J=1:1:4 S X=X_X(J)
 .D INC
 .S @T=X
 Q
 ;
SET ;
 I $D(AMQQEX("TDFN")) F I=1:1 Q:'$D(^UTILITY("AMQQ",$J,"EMAN",2,I))  S ^AMQQ(3.1,AMQQEX("TDFN"),2,I,0)=^(I),$P(^AMQQ(3.1,AMQQEX("TDFN"),2,0),U,3,4)=I_U_I
 I $D(AMQQEX("DOC")) S AMQQEFN=AMQQEX("DOC") X AMQQEX("WRITE") E  D BUSY^AMQQEM4
 I '$D(AMQQSTOP),$D(AMQQEX("DOC")) X AMQQEX("USE") F I=1:1 Q:'$D(^UTILITY("AMQQ",$J,"EMAN",2,I))  W ^(I),!
 X $G(AMQQEX("CLOSE"))
 K AMQQSTOP
 Q
 ;
SAVE ; SAVE SEARCH LOGIC AND FORMATTING INSTRUCTIONS
TMP ; THIS OPTION IS TEMPORARILY DISABLED UNTIL DR. GRAU RESTORES THE SCRIPT OPTION ON THE OPENING SCREEN
 W !!
 Q
 W !!
 S DIR(0)="Y"
 S DIR("A")="Save the search logic and formatting instructions for future use"
 S DIR("B")="NO"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I "^"[X!('$G(Y)) Q
 I X?2."^" S AMQQQUIT="" Q
 D STORE^AMQQQE
 I $D(AMQQQUIT) Q
 I $D(AMQQCPLF) D ^AMQQCMPS
 Q
 ;
