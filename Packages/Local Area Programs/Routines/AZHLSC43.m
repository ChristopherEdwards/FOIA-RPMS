AZHLSC43 ; IHS/ADC/GTH:KEU:JN - SAC CHAPTER 2: M LANGUAGE PROGRAMMING STANDARDS & CONVENTIONS) ;  [ 08/02/1999  7:47 AM ]
 ;;5.0;AZHLSC;;JUL 10, 1996
 ;
 NEW AZHLB,AZHLFLD,AZHL0,BFN,DIF,EFN,F,G,XCNP,Z
 D END S AZHL0=""
 F  S AZHL0=$O(^UTILITY($J,AZHL0)) Q:AZHL0=""  W:AZHLTERM "." S X=AZHL0,DIF="^TMP($J,""Z"",",XCNP=0 X "X ^%ZOSF(""LOAD""),AZHLGFCX" I  S XCNP=XCNP-1 D
 .F AZHLB=3:1:XCNP S Z=AZHLB,(Z(Z),^TMP($J,"Z"))=^TMP($J,"Z",AZHLB,0) D
EN ..I ^TMP($J,"Z")["^(" D ^AZHLSC44
 ..Q
 .K ^TMP($J,"Z") ;K Z
 .Q
2210 D TTL^AZHLSC("2.2.10,  (9.8)  Naked Global References")
 I $O(^UTILITY($J,""))="" D NRTN^AZHLSC G END
 I $L($O(^TMP($J,"2.2.10",""))) W !?10,"SUSPECT Naked Reference without full Global Reference." S %="" F  S %=$O(^TMP($J,"2.2.10",%)) Q:%=""  S A=0 F  S A=$O(^TMP($J,"2.2.10",%,A)) Q:'A  W !?10,"+",A,"^",%," :  ",^(A)
END K ^("2.2.10"),^("Z"),Z
 Q
225 NEW AZHLB,AZHLFLD,AZHL0,BFN,DIF,EFN,F,G,XCNP,Z
 D END1 S AZHL0=""
 F  S AZHL0=$O(^UTILITY($J,AZHL0)) Q:AZHL0=""  W:AZHLTERM "." S X=AZHL0,DIF="^TMP($J,""Z"",",XCNP=0 X "X ^%ZOSF(""LOAD""),AZHLGFCX" I  S XCNP=XCNP-1 D
 .F AZHLB=3:1:XCNP S ^TMP($J,"Z")=^TMP($J,"Z",AZHLB,0) D
 ..D ^AZHLSC46 Q:AZHLSC4I=1  Q:$L(^TMP($J,"Z"))<"512"  S ^TMP($J,"2.2.5",AZHL0,AZHLB)=^TMP($J,"Z") 
 ..Q
 .K ^TMP($J,"Z") ;K Z
 .Q
2251 D TTL^AZHLSC("2.2.5, Line body must not exceed 512 characters")
 I $O(^UTILITY($J,""))="" D NRTN^AZHLSC G END
 I $L($O(^TMP($J,"2.2.5",""))) W !?10," " S %="" F  S %=$O(^TMP($J,"2.2.5",%)) Q:%=""  S A=0 F  S A=$O(^TMP($J,"2.2.5",%,A)) Q:'A  W !?10,"+",A,"^",%," :  ",^(A)
END1 K ^("2.2.5"),^("Z"),Z
 Q
