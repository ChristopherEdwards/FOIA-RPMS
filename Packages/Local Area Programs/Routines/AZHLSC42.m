AZHLSC42 ; IHS/ADC/GTH:KEU:JN - SAC CHAPTER 2: M LANGUAGE PROGRAMMING STANDARDS & CONVENTIONS) ;  [ 09/25/1998  12:01 PM ] [5/31/00 7:25am]
 ;;5.0;AZHLSC;;JUL 10, 1996
 ;CHANGED DIF="Z(" TO GLOBAL AND OTHER REFERENCES TO THE 
 ;ARRAY TO THE GLOBAL REFERENCE TO ACCOMMODATE LARGE RTNS SIZES
 ;IHS/ABQ/KEU  4/7/95
 NEW A,A3,A4,A5,ARG,B,CH,COM,DIF,G,I,J,LIN,NORTNS,NUL,R,Q,VSS,XCNP,Z
 D END
 S Q="""",A4="=""O ",A5="=""C ",NORTNS=$O(^UTILITY($J,""))="",VSS=$P($T(VSS),";;",2)
 S G="NEW I X ^%ZOSF(""SIZE"") S:Y>15000 ^TMP($J,""227"",AZHL)=Y"
 S AZHL=""
 F  S AZHL=$O(^UTILITY($J,AZHL)) Q:AZHL=""  W:AZHLTERM "." K Z S (AZHL0,X)=AZHL,DIF="^TMP($J,""Z"",",XCNP=0 X "X ^%ZOSF(""LOAD""),G,AZHLGFCX" I  S XCNP=XCNP-1 D
 .F Z=3:1:XCNP S Z(Z)=^TMP($J,"Z",Z,0) K ^TMP($J,"Z",Z,0) D
 ..F %=1:1 S X=U_$P(VSS,U,%) Q:X=U  I Z(Z)[X,$E(Z(Z),$F(Z(Z),X))?1P S ^TMP($J,"228",AZHL,Z)=Z(Z)
 ..I $E(AZHL,1)="Z" S ^TMP($J,"22121",AZHL)=""
 ..I $L(AZHLNMSP),$E(AZHL,$L(AZHLNMSP)+1)="Z" S ^TMP($J,"22122",AZHL)=""
 ..I Z(Z)["%AU"!(Z(Z)["D ^AU") D EN^AZHLSC45 
 ..D EN^AZHLSC47 Q:AZHLSC4I=1  D EN^AZHLSC46 Q:AZHLSC4I=1  D CHKBLNK Q:AZHLSC4I=1  S ^TMP($J,"2223",AZHL,Z)=Z(Z)
 ..Q
 .Q
 D TTL^AZHLSC("2.2.7,  Routine size as determined by ^%ZOSF(""SIZE"")")
 I NORTNS D NRTN^AZHLSC G 48
 I $L($O(^TMP($J,"227",""))) S %="" F  S %=$O(^TMP($J,"227",%)) Q:%=""  W !?10,%," is ",^(%)," bytes."
 ;
48 D TTL^AZHLSC("2.2.8,  Vendor Specific Subroutines")
 I NORTNS D NRTN^AZHLSC G 410
 I $L($O(^TMP($J,"228",""))) W !?10,"Possible use of Vendor Specific Subroutine." S %="" F  S %=$O(^TMP($J,"228",%)) Q:%=""  S A=0 F  S A=$O(^TMP($J,"228",%,A)) Q:'A  W !?10,"+",A,"^",%," :  ",^(A)
410 D ^AZHLSC43
4121 D TTL^AZHLSC("2.2.12.1,  Z first letter of namespace routines, export prohibited ")
 I NORTNS D NRTN^AZHLSC G 4122
 I $L($O(^TMP($J,"22121",""))) S %="" F  S %=$O(^TMP($J,"22121",%)) Q:%=""  W !?10,%," should not be included in the package."
4122 D TTL^AZHLSC("2.2.12.2,  Creation of Local Routines")
 I NORTNS D NRTN^AZHLSC G 418
 I $L($O(^TMP($J,"22122",""))) S %="" F  S %=$O(^TMP($J,"22122",%)) Q:%=""  W !?10,%," should not be included in the package."
418 D TTL^AZHLSC("2.2.18,  XB/ZIB Prefixed Routines")
 I NORTNS D NRTN^AZHLSC G 2223 
 I $L($O(^TMP($J,"2218",""))) W !?10,"Possible call to old %AU/AU routine instead of XB/ZIB equivalent." S %="" F  S %=$O(^TMP($J,"2218",%)) Q:%=""  S A=0 F  S A=$O(^TMP($J,"2218",%,A)) Q:'A  W !?10,"+",A,"^",%," :  ",^(A)
2223 D TTL^AZHLSC("2.2.23,  BLANKS AT END OF LINE")
 I NORTNS D NRTN^AZHLSC Q
 I $L($O(^TMP($J,"2223",""))) W !?10," " S %="" F  S %=$O(^TMP($J,"2223",%)) Q:%=""  S A=0 F  S A=$O(^TMP($J,"2223",%,A)) Q:'A  W !?10,"+",A,"^",%," :  ",^(A)
 Q
END K ^TMP($J,"227"),^("228"),^("22121"),^("22122"),^("2218"),^("2223"),^("Z"),Z
 Q
CHKBLNK ; CHECK FOR BLANKS AT END OF LINE   
 S AZHLSC4I=0,AZHLSCF=""
 S AZHLSCG=$L(Z(Z)) I $E(Z(Z),AZHLSCG)=" " S AZHLSC4I=0 D CHKSEMI D CHKBHLK G CHKEND 
 S AZHLSC4I=1
CHKEND K AZHLSCF,AZHLSCG 
 Q
CHKBHLK ;  CHECK FOR COMMAND BREADK,HALT,LOCK,KILL FOLLOWED BY BLANKS
 F J(1)=" B  "," H  "," K  "," L  "," N  " I $E(Z(Z),AZHLSCG-3,AZHLSCG)=J(1) S AZHLSC4I=1 Q
 Q
CHKSEMI ; CHECK FOR SEMI COLON IN COMMAND LINE
 S AZHLSCF=$F(Z(Z),";") Q:AZHLSCF=0  S AZHLSC4I=1 Q
 Q
VSS ;;%ACTJOB^%D^%DEVUSE^%DI^%DO^%DOMAIN^%ECHO^%ET^%FGR^%FGS^%FLIST^%GCH^%GCHANGE^%GCOPY^%GD^%GDEL^%GUCI^%HL^%HOSTCMD^%MDMP^%MODESET^%MTCHK^%SDEV^%SRCHPAT^%T^%TI^%TO^%TRANS
