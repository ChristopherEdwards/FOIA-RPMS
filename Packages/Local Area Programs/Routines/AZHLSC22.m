AZHLSC22 ; IHS/ADC/GTH:KEU:JN - SAC CHAPTER 2: M LANGUAGE PROGRAMMING STANDARDS & CONVENTIONS) ;  [ 01/12/98  8:47 AM ]
 ;;5.0;AZHLSC;;JUL 10, 1996
 ;Changed SHORT DESCRIPTION to .01 FIELD - NAME and global reference to Piece 3 of DIC(9.4 where variable SD Set (Line 1+11, 1+5) IHS/ALBQ/KEU 2/2/95
 ;Changed DIF="Z(" TO GLOBAL ^TMP($J,"Z" AND OTHER REFERENCES
 ;TO THE Z( ARRAY TO THE GLOBAL REF. TO ACCOMODATE LARGE RTNS
 ;THAT WE ARE RECEIVING  IHS/ABQ/KEU  4/7/95
 ;W !!!,$P($P($T(+1),";",2),"-",2)
1 D TTL^AZHLSC("2.2.1 First Line    2.2.2 Second Line.  (7.1)")
 I $O(^UTILITY($J,""))="" D NRTN^AZHLSC Q
 I 'AZHLPIEN W !?10,"PACKAGE not selected.",!,"Version/Short Description/Date Distributed not checked."
 K ^TMP($J,"AZHL","2")
 NEW AZHLSTBL,DIF,DTDIST,SD,V,XCNP,Z,AGENSITE ;IHS/ABQ/KEU 3/7/95 ADDED AGENSITE
 S (SD,V,DTDIST,AGENSITE)="" I AZHLPIEN S SD=$P(^DIC(9.4,AZHLPIEN,0),U,1),V=$G(^("VERSION")) I $L(V) S DTDIST=$P(^DIC(9.4,AZHLPIEN,22,$O(^DIC(9.4,AZHLPIEN,22,"B",V,0)),0),U,2)
 ;IHS/ABQ/KEU  2/2/95 ADDED AGENSITE AND CHANGED SD PIECE TO 1 TO LOOK FOR .01 FIELD INSTEAD OF SHORT DESCRPT
 S AZHL="",AZHLSTBL=^DD("FUNC",$O(^DD("FUNC","B","STRIPBLANKS",0)),1)
 F  S AZHL=$O(^UTILITY($J,AZHL)) Q:AZHL=""  W:AZHLTERM "." K Z S X=AZHL,DIF="^TMP($J,""Z"",",XCNP=0 X "X ^%ZOSF(""LOAD""),AZHLGFCX" I  S Z(1)=^TMP($J,"Z",1,0),Z(2)=^TMP($J,"Z",2,0),AGENSITE=$P(Z(1),";",2) D
 .I $P($G(AGENSITE),"/",3)']"" S AZHL0=AZHL D EN^AZHLSC46 I AZHLSC4I'=1 W !?10,AZHL,":  NO AGENCY/SITE/PROGRAMMER: ",AGENSITE D B("2.2.1.3  (7.1.1)") ;IHS/ABQ/KEU 3/7/95 Added to include check for New SAC
 .;I $L($P(Z(1),";",3)) S X=$P(Z(1),";",3),X=$P(X,"]") S:X["[" X=$P(X,"[",2) X AZHLSTBL S X=$P(X," ",1,2) S:X?1.2N.E X=$P(X," ") D ^%DT I Y=-1 S AZHL0=AZHL D EN^AZHLSC46 I AZHLSC4I'=1
 .; W !?10,"3rd ';'-piece is not date (of edit): ",Z(1) D B("2.2.1.4  (7.1.2)")
 .I $L(V),$P(Z(2),";",3)'=V W !?10,AZHL,":  Rtn vers, pkg file vers, no-match : ",Z(2) D B("2.2.2.1  (7.1.3)")
 .I $P(Z(2),";",5)]"" W !?10,"Patch piece not null in ",AZHL,": '",$P(Z(2),";",5),"'." D B("2.2.2.2  (7.1.5)")
 .S X=$P(Z(2),";",6) D ^%DT I Y=-1 W !?10,"Date of Release piece, not date :",AZHL,":  ",Z(2) D B("2.2.2.3  (7.1.6)")
 .E  I $L(DTDIST),DTDIST'=Y W !?10,"Date of Release '= DATE DISTRIBUTED in PACKAGE :",AZHL,":  ",Z(2) D B("2.2.2.3  (7.1.6)")
 .I $P(Z(1),";",2)'["-" S AZHL0=AZHL D EN^AZHLSC46 I AZHLSC4I'=1 W !?10,"No Dash between pgrm - desc : ",Z(1) D B("2.2.1  (7.1)")
 .Q
 I $D(^TMP($J,"AZHL","2")) W !!?5,"SUMMARY:" S %="" F  S %=$O(^TMP($J,"AZHL","2",%)) Q:%=""  W !?10,%," violations : ",^(%)
 Q
B(%) S ^(%)=$G(^TMP($J,"AZHL","2",%))+1 Q
