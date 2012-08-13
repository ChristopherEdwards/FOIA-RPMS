CIMGAGP0 ; CMI/TUCSON/LAB - DEVICE CALLS AND QUEUING ;  [ 01/31/00  8:34 AM ]
 ;;1.0;ABERDEEN GPRA REPORT;;JAN 22, 2000
SU ;EP;FIND SERVICE UNIT COMMUNITIES
 N I,J,K,X,Y,Z,CIMTMP
 S J=0
 F I=1:1 S Z=$T(SUTEXT+I) Q:Z=""!$D(CIMQUIT)  D
 .S CIMTAX=$P(Z,";",3)
 .Q:CIMTAX=""
 .S Y=$O(^ATXAX("B",CIMTAX,0))
 .I 'Y K CIMTAX Q
 .S J=J+1
 .S CIMTMP(J)=Y_";"_$P(Z,";",2,3)
 D SSU:$D(CIMTMP)
 Q
DIR ;EP;
 I $D(CIMOUT) K DIR S Y="" Q
 K DTOUT,DUOUT,CIMQUIT,CIMOUT
 D ^DIR
 S CIMY=Y
 S:$D(DIRUT)!$D(DIROUT)!$D(DUOUT) CIMQUIT=""
 S:X="^^"!$D(DTOUT) (CIMQUIT,CIMOUT)=""
 K DIR,DIRUT,DIROUT,DUOUT,DTOUT
 Q
SSU ;SELECT SERVICE UNIT COMMUNITY TAXONOMY
 I J=1 S Y=1 D SSU1 Q
 N I,J,K
 W !!?5,"Service Unit Community Taxonomies"
 W !!?5,"NO.",?10,"Service Unit"
 W !?5,"---",?10,"---------------"
 S (I,J)=0
 F  S J=$O(CIMTMP(J)) Q:'J  D
 .S Z=CIMTMP(J)
 .W !?5,J,?10,$P(Z,";",2)
 .S I=I+1
 S DIR(0)="NO^1:"_I
 S DIR("A")="Which SERVICE UNIT Taxonomy"
 W !
 D DIR
 I Y<1 S CIMQUIT="" Q
SSU1 I '$G(CIMTMP(Y)) S CIMQUIT="" Q
 S CIMZ=CIMTMP(Y)
 S CIMX=+CIMTMP(Y)
 S CIMTAX=$P(CIMZ,";",3)
 ;D LIST
 ;Q:$D(CIMQUIT)
 D SU1
 Q
SU1 S X=0
 F  S X=$O(^ATXAX(CIMX,21,X)) Q:'X  D
 .S CIMTAX($P(^ATXAX(CIMX,21,X,0),U))=""
 .Q
 I $D(CIMTAX)=11 D
 .S CIMQUIT=""
 .;S CIMSU=$P(CIMZ,";",2)
 K CIMQUIT
 Q
SUTEXT ;;
 ;Cheyenne River;ebutte117
 ;Crow Creek;Crowcreek2
 ;Spirit Lake Sioux;fort totten
 ;Flandreau;Fland117
 ;Lower Brule;lobrule117
 ;Oglala Sioux;PINERIDGE117
 ;Kyle;kyle117
 ;Wanblee;wanblee117
 ;Omaha;Macy117
 ;N. Ponca;ponca117
 ;Rapid City;rapid117
 ;Rosebud;rose117
 ;Sac & Fox;sacfox117
 ;Santee Sioux;santee117
 ;Sisseton-Wahpeton;siss_117
 ;Standing Rock;ftyate117
 ;McLaughlin;mclaugh117
 ;Three Affiliated;Ft_BERTH117
 ;Trenton;trent117
 ;Turtle Mountain;belc117
 ;Winnebago;winne117
 ;Yankton;wagner117
 ;
