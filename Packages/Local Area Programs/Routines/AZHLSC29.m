AZHLSC29 ; IHS/ADC/GTH:KEU:JN - SAC CHAPTER 2: M LANGUAGE PROGRAMMING STANDARDS & CONVENTIONS ;  [ 08/13/1998  2:27 PM ]
 ;;5.0;AZHLSC;;JUL 10, 1996
 ;
 ;IHS/ABQ/KEU - CHANGED DIF="Z(" TO ^TMP($J,"Z" AND OTHER
 ;REFERENCES TO THE ARRAY TO THE GLOBAL.
 ;W !!!,$P($P($T(+1),";",2),"-",2)
 NEW A,AC,ARG,AZHL0,AZHLA,AZHLB,CH,COM,DIF,EC,ERR,ERTX,GK,L,LAB,LABO,LI,LL,LOC,LV,NORTNS,OP,PL,Q,RDTIME,RTN,S,S1,STR,V,XCNP,Z
 D END K ^TMP($J,"A223")
 S NORTNS=$O(^UTILITY($J,""))="" G:NORTNS 8
 S AZHL0=1,(LAB,LABO)="",RTN="AZHL"
 F  K Z,^TMP($J,"Z") S AZHL0=$O(^UTILITY($J,AZHL0)) Q:AZHL0=""  S X=AZHL0,DIF="^TMP($J,""Z"",",XCNP=0 X "X ^%ZOSF(""LOAD""),AZHLGFCX" I  D
 .F AZHLB=3:1 Q:'$D(^TMP($J,"Z",AZHLB))  D
 ..;S Z=^TMP($J,"Z",AZHLB,0) D EN^AZHLSC46 I AZHLSC4I'=1 F AZHL=" R "," R:",".R " I Z[AZHL S COM="R",ARG=$E(Z,$F(Z,AZHL),245) K ERTX D R^%INDEX I '$D(ERTX) S ^TMP($J,"2911",AZHL0,AZHLB)=Z
 ..S Z=^TMP($J,"Z",AZHLB,0) D EN^AZHLSC46 I AZHLSC4I'=1 F AZHLSC49=" R "," R:",".R " I Z[AZHLSC49 D EN^AZHLSC49 I AZHLSC4I=0  S ^TMP($J,"2911",AZHL0,AZHLB)=Z
 ..I $E(AZHL0,1,2)="AZ"!($E(AZHL0,1,2)="BZ") S ^TMP($J,"A223",AZHL0)=""
 .Q
8 D TTL^AZHLSC("2.9.1.1, FileMan Utility Routine - DIR")  
 I NORTNS D NRTN^AZHLSC G 139
 I $L($O(^TMP($J,"2911",""))) W !?10,"Consider use of DIR instead of (suspected) READ." S %="" F  S %=$O(^TMP($J,"2911",%)) Q:%=""  S A=0 F  S A=$O(^TMP($J,"2911",%,A)) Q:'A  W !?10,"+",A,"^",%," :  ",^(A)
139 D TTL^AZHLSC("2.11.9,  (13.4)  Location Name")
 I 'AZHLPIEN D NPKG^AZHLSC G A221 
 S %=AZHLNMSP,Z=0
 F  S %=$O(^DIC(19,"B",%)) Q:AZHLNMSP'=$E(%,1,$L(AZHLNMSP))  S A=$O(^(%,0)) I $P(^DIC(19,A,0),U,4)="M" D
 .;W:'Z !?10,"The following ENTRY ACTIONS should display Location:" S Z=1 W !?10,%,":  ",$S($D(^(20)):^(20),1:"**** NO ENTRY ACTION ****")
 .W:'Z !?10,"The following ENTRY ACTIONS should display Location:" S Z=1 W:$G(^(20))!($G(^(26))) ?10,%,":  ","**** NO ENTRY ACTION ****"
 .Q
 ;
A221 D TTL^AZHLSC("APNDX A.2.2.1,  (C.2.2.1)  Security Keys => nsZ")
 I 'AZHLPIEN D NPKG^AZHLSC G A223
 S %=AZHLNMSP
 F  S %=$O(^DIC(19.1,"B",%)) Q:$E(%,1,$L(AZHLNMSP))'=AZHLNMSP  I $E(%,$L(AZHLNMSP)+1)'="Z" W !?10,"Security Key '",%,"', namespace not followed by ""Z""."
A223 D TTL^AZHLSC("APNDX A.2.2.3,  (C.2.2.3)  AZ - BZ  Local Area Routines")
 I NORTNS D NRTN^AZHLSC K ^TMP($J,"A223") G END
 I $L($O(^TMP($J,"A223",""))) W !?10,"The following routines are in the local area namespace." S %="" F  S %=$O(^TMP($J,"A223",%)) Q:%=""  W !?10,%
END ;K ^TMP($J,"13.8"),^("A222"),^("A223"),^("Z")
 K ^TMP($J,"A222"),^("A223"),^("2911"),^("Z")
 ;K ^TMP($J,"Z")
 Q
