ACRFSSRC ;IHS/OIRM/DSD/THL,AEF - PRINT RENTAL CAR JUSTIFICATION; [ 11/01/2001   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;;NOV 05, 2001
 ;;ROUTINE TO PRINT RENTAL CAR JUSTIFICATION
EN I '$D(ACROUT),$D(^ACRDOC(D0,"TOSA")),$P(^("TOSA"),U,3)="Y",$D(^ACRTV("D",D0)) D EN1
EXIT K ACR
 Q
EN1 N I,J,ACRY,ACRX
 W !,"|-------------------------  RENTAL CAR JUSTIFICATION  -------------------------|"
 S ACR=0
 F  S ACR=$O(^ACRTV("D",D0,ACR)) Q:'ACR  D
 .S ACRY=$G(^ACRTV(ACR,"RCJ"))
 .Q:ACRY=""
 .S ACRX=$P($G(^ACRPD(+$P(^ACRTV(ACR,"DT"),U,4),0)),U)
 .S:ACRX="" ACRX="(CITY NOT LISTED)"
 .S ACRX=ACRX_":  "
 .F I=1:1:5 S:$P(ACRY,U,I)]"" ACRX=ACRX_$P(ACRY,U,I)_" "
 .Q:ACRX=""
 .W !,"|"
 .W ?5
 .F J=1:1:$L(ACRX," ") D
 ..S X=$P(ACRX," ",J)
 ..Q:X=""
 ..I $X+$L(X)+1>75 D
 ...W ?79,"|"
 ...W !,"|"
 ...W ?5
 ..W X
 ..W ?$X+1
 .W ?79,"|"
 Q
POT ;EP;TO PRINT PURPOSE OF TRAVEL
 N I,J,X,Y
 W !,"-----------------------------  PURPOSE OF TRAVEL  ------------------------------"
 S X=""
 S Y=$G(^ACROBL(D0,"JST"))
 I Y]"" F I=1:1:5 S:$P(Y,U,I)]"" X=X_$P(Y,U,I)_" "
 S Y=$G(^ACROBL(D0,"JST2"))
 I Y]"" F I=1:1:5 S:$P(Y,U,I)]"" X=X_$P(Y,U,I)_" "
 Q:X=""
 W !?5
 F J=1:1:$L(X," ") S X=$P(X," ",J) D:X]""
 .W:$X+$L(X)+1>75 !?5
 .W X
 .W ?$X+1
 Q
NEED ;EP;TO PRINT TRAINING NEED
 N ACRX,X,J
 S ACRX=$G(^ACRDOC(ACRDOCDA,"TRNGND1"))_" "_$G(^ACRDOC(ACRDOCDA,"TRNGND2"))_" "_$G(^ACRDOC(ACRDOCDA,"TRNGND3"))_" "_$G(^ACRDOC(ACRDOCDA,"TRNGND4"))
 Q:ACRX=""
 W !?5
 F J=1:1:$L(ACRX," ") S X=$P(ACRX," ",J) D:X]""
 .W:$X+$L(X)+1>75 !?5
 .W X
 .W ?$X+1
 Q
RELATE ;EP;TO PRINT HOW TRAINING NEED RELATES TO WORK
 N ACRX,X,J
 S ACRX=$G(^ACRDOC(ACRDOCDA,"TRNGRL1"))_" "_$G(^ACRDOC(ACRDOCDA,"TRNGRL2"))_" "_$G(^ACRDOC(ACRDOCDA,"TRNGRL3"))_" "_$G(^ACRDOC(ACRDOCDA,"TRNGRL4"))
 Q:ACRX=""
 W !?5
 F J=1:1:$L(ACRX," ") S X=$P(ACRX," ",J) D:X]""
 .W:$X+$L(X)+1>75 !?5
 .W X
 .W ?$X+1
 Q
