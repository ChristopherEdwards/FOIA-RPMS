AMQQEM22 ; IHS/CMI/THL - EM2 OVERFLOW ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
VVAR S %="^^VISIT TIMESTAMP^D;142^1^TYPE^F;145^1^PATIENT^F;144^1^LOCATION^F;143^1^SERVICE CATEGORY^F;172^1^CLINIC^F"
 S A="+^AUPNVSIT(AMQP(1),0);$P(^AUPNVSIT(AMQP(1),0),U,3);$P(^AUPNVSIT(AMQP(1),0),U,5);$P(^AUPNVSIT(AMQP(1),0),U,6);$P(^AUPNVSIT(AMQP(1),0),U,7);$P(^AUPNVSIT(AMQP(1),0),U,8)"
 F C=1:1:6 S @G@(C,0)=$P(%,";",C),$P(^(0),U,6)=$E($P(^(0),U,3),1,AMQQEM("HLEN")),$P(^(0),U,7)=AMQQEM("MLEN"),@G@(C,1)="S X="_$P(A,";",C) I C>1 S @G@(C,2)="I X'="""" "_^AMQQ(1,+$P(%,";",C),4,1,1)
 K %,A,B
 Q
 ;
VISIT N %,A,B,X,Y,Z
 D VVAR
 S (P,AMQQEMP)="^TIMESTAMP^TYPE^PATIENT^LOCATION^SERVICE CATEGORY^CLINIC^"
 S Z="1:TIMESTAMP;2:TYPE;3:PATIENT;4:LOCATION;5:SERVICE CATEGORY;6:CLINIC;"
 F %=9:0 S %=$O(^UTILITY("AMQQ",$J,"VAR NAME",%)) Q:'%  S X=^(%) D
 .S Y=$P(^AMQQ(1,+X,4,$P(X,U,2),0),U)
 .I P[(U_Y_U) Q
 .S C=C+1,Z=Z_C_":"_Y_";"
 .S @G@(C,0)=+X_U_$P(X,U,2)_U_$E(Y,1,AMQQEM("HLEN"))_U_$S($P(X,U,2)>2:"F",$P(X,U,2)=2:"D",$P(^AMQQ(1,+X,0),U,5)=7:"D",$P(^(0),U,5)=9:"N",1:"F")_U_%_U_$E(Y,1,AMQQEM("HLEN"))_U_($G(AMQQEM("FIX"))+$G(AMQQEM("MLEN")))
 .S @G@(C,1)="S X=AMQP("_%_")"
 .I $G(^AMQQ(1,+X,4,$P(X,U,2),1,1))'="" S @G@(C,2)="I X'="""" "_^(1)
 S Z=Z_(C+1)_":"_"OTHER VISIT ATTRIBUTE;"
 S C("OTHER")=C+1
 S Z=Z_(C+2)_":EDIT A PREVIOUSLY SELECTED FIELD;"
 S C("EDIT")=C+2
 S AMQQEMZ="SO^"_Z
 K A,B,Z
 I $G(AMQQEM("ACCN"))="YES" S C=C+1,@G@(C,0)="^^"_$E("ENTRY #",1,AMQQEM("HLEN"))_"^N^^"_$E("ENTRY #",1,AMQQEM("HLEN"))_U_($G(AMQQEM("FIX"))+$G(AMQQEM("MLEN"))),@G@(C,1)="S X=AMQQTOT",AMQQEMFS=C_U
 D LOOP^AMQQEM2
 Q
 ;
ACCN ; - EP - ACCESSION NUMBER ; EP FROM AMQQEM2
 S DIR("B")=$S($D(AMQQEM("ACCN")):AMQQEM("ACCN"),1:"NO")
 S DIR(0)="Y"
 S DIR("A")="Want to make the 1st field a sequential (serial) number"
 S DIR("?")="In some cases you may want to enter an serial number (starting with 1 and incrementing by 1 for each entry) as the first field of each record"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I X=U W !!,*7,"Sorry, you can't back up here.  Enter '^^' if you want to terminate the session" W !! G ACCN
 D CK^AMQQEMAN
 I $D(AMQQQUIT) Q
 S AMQQEM("ACCN")=$S(Y:"YES",1:"NO")
 Q
 ;
