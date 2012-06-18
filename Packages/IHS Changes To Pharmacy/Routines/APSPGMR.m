APSPGMR ; IHS/DSD/ENM - Patient Allergy Lookup ;  [ 09/03/97   1:30 PM ]
 ;;6.0;IHS PHARMACY MODIFICATIONS;;09/03/97
EP ;EP - Entry point from APSPDSC1
 S DFN=PSODFN D GMRA
 Q
GMRA K ^TMP($J,"AL") S GMRA="0^1^111" D ^GMRADPT I GMRAL D
 .F DR=0:0 S DR=$O(GMRAL(DR)) Q:'DR  S ^TMP($J,"AL",$S('$P($P(GMRAL(DR),"^",6),";",2):1,1:2),$P(GMRAL(DR),"^",3),$P(GMRAL(DR),"^",2))=""
 .W !!,"ALLERGIES: " S (DR,TY)="" F I=0:0 S TY=$O(^TMP($J,"AL",1,TY)) Q:TY=""  F D=0:0 S DR=$O(^TMP($J,"AL",1,TY,DR)) Q:DR=""  W:$X+$L(DR)+$L(", ")>IOM !?11 W DR_", "
 .;IHS/DSD/ENM 3.9.95 ESCAPE CODES ADDED TO NEXT LINE
 .;W !!,$C(27)_"[7m"_$C(27)_"[5m"_"ALLERGIES: "_$C(27)_"[m" S (DR,TY)="" F I=0:0 S TY=$O(^TMP($J,"AL",1,TY)) Q:TY=""  F D=0:0 S DR=$O(^TMP($J,"AL",1,TY,DR)) Q:DR=""  W:$X+$L(DR)+$L(", ")>IOM !?11 W DR_", "
 .;W !!,$C(27)_"[7m"_$C(27)_"[5m"_"ADVERSE REACTIONS: "_$C(27)_"[m" S (DR,TY)="" F I=0:0 S TY=$O(^TMP($J,"AL",2,TY)) Q:TY=""  F D=0:0 S DR=$O(^TMP($J,"AL",2,TY,DR)) Q:DR=""  W:$X+$L(DR)+$L(", ")>IOM !?19 W DR_", "
 .W !!,"ADVERSE REACTIONS: " S (DR,TY)="" F I=0:0 S TY=$O(^TMP($J,"AL",2,TY)) Q:TY=""  F D=0:0 S DR=$O(^TMP($J,"AL",2,TY,DR)) Q:DR=""  W:$X+$L(DR)+$L(", ")>IOM !?19 W DR_", "
 I $G(GMRAL)']"" F AD="ALLERGIES:","ADVERSE REACTIONS:" W !!,AD I $G(PSOFROM)="" F ADL=1:1:IOM-($L(AD)+5) W "_"
 I GMRAL=0 W !!,"ALLERGIES: NKA",!!,"ADVERSE REACTIONS:"
 W ! K TY,D,GMRA,GMRAL,DR,AD,ADL,^TMP($J,"AL") Q
