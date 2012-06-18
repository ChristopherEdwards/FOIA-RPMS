AZHLSC51 ; IHS/ADC/GTH:KEU:JN - SAC CHAPTER 2: M LANGUAGE PROGRAMMING STANDARDS & CONVENTIONS ;  [ 01/06/1999  9:36 AM ] [1/19/00 7:12am]
 ;;5.0;AZHLSC;;JUL 10, 1996
 ;
 NEW AZHLB,AZHLFLD,AZHL0,BFN,DIF,EFN,F,G,XCNP,Z
529 D TTL^AZHLSC("2.3.2.9,  (9.1)  Global Names (of Package's files)")
 I 'AZHLPIEN D NPKG^AZHLSC Q
 S %=0 F  S %=$O(^DIC(9.4,AZHLPIEN,4,"B",%)) Q:'%  W:AZHLTERM "." S AZHLSC99=$P($G(^DIC(%,0,"GL")),"(",1) I AZHLSC99'="",$P(AZHLSC99,U,2)'[AZHLNMSP W !?10,"File ",%,", global ",^DIC(%,0,"GL")," is not namespaced."
 ;S %=0 F  S %=$O(^DIC(9.4,AZHLPIEN,4,"B",%)) Q:'%  W:AZHLTERM "." I '$E($P($P(^DIC(%,0,"GL"),"("),U,2),1,$L(AZHLNMSP))'=AZHLNMSP W !?10,"File ",%,", global ",^DIC(%,0,"GL")," is not namespaced."
 Q
524 NEW AZHLB,AZHLFLD,AZHL0,BFN,DIF,EFN,F,G,XCNP,Z
 ;D TTL^AZHLSC("2.3.2.4,  (9.4)   % Global Nodes")
 ;I $O(^UTILITY($J,""))="" D NRTN^AZHLSC Q
 D END S AZHL0=""
 F  S AZHL0=$O(^UTILITY($J,AZHL0)) Q:AZHL0=""  W:AZHLTERM "." S X=AZHL0,DIF="^TMP($J,""Z"",",XCNP=0 X "X ^%ZOSF(""LOAD""),AZHLGFCX" I  S XCNP=XCNP-1 D
 .F AZHLB=3:1:XCNP S Z=AZHLB,(Z(Z),^TMP($J,"Z"))=^TMP($J,"Z",AZHLB,0) D
 ..I ^TMP($J,"Z")["K ^" D EN^AZHLSC47 Q:AZHLSC4I=1  D EN^AZHLSC46 Q:AZHLSC4I=1  D UNSCRGL Q:AZHLSC4I=1  S ^TMP($J,"2.3.2.3",AZHL0,AZHLB)=^TMP($J,"Z")
 ..I ^TMP($J,"Z")["^%" D EN^AZHLSC47 Q:AZHLSC4I=1  D EN^AZHLSC54
 ..Q
 .K ^TMP($J,"Z") ;K Z
 .Q
 D TTL^AZHLSC("2.3.2.3,  KILL of unsubscripted global")
 I $O(^UTILITY($J,""))="" D NRTN^AZHLSC G 2324 
 I $L($O(^TMP($J,"2.3.2.3",""))) W !?10," " S %="" F  S %=$O(^TMP($J,"2.3.2.3",%)) Q:%=""  S A=0 F  S A=$O(^TMP($J,"2.3.2.3",%,A)) Q:'A  W !?10,"+",A,"^",%," :  ",^(A)
2324 D TTL^AZHLSC("2.3.2.4,  % Global Nodes")
 I $O(^UTILITY($J,""))="" D NRTN^AZHLSC Q
 I $L($O(^TMP($J,"2.3.2.4",""))) W !?10,"SET or KILL of %-Global Node." S %="" F  S %=$O(^TMP($J,"2.3.2.4",%)) Q:%=""  S A=0 F  S A=$O(^TMP($J,"2.3.2.4",%,A)) Q:'A  W !?10,"+",A,"^",%," :  ",^(A)
 D END S AZHL0=""
 Q
END K ^TMP($J,"2.3.2.4"),^TMP($J,"2.3.2.3"),^("Z")
 Q
UNSCRGL ;  FIND UNSUBCRIPTED GLOBAL
 S AZHLSCF="",AZHLSCG="",AZHLSC4I=0
 S AZHLSCF=$F(Z(Z),"K ^") I AZHLSCF=0 S AZHLSC4I=0 Q
 S AZHLSCG=$E(Z(Z),AZHLSCF,AZHLSCF+10) I AZHLSCG["(" S AZHLSC4I=1 Q
 I $E(AZHLSCG,1,3)="TMP" S AZHLSC4I=1 Q
 S AZHLSC4I=0 Q
