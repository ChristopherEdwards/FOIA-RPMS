AZHLSC2 ; IHS/ADC/GTH:KEU:JN - SAC CHAPTER 2: M LANGUAGE PROGRAMMING STANDARDS & CONVENTIONS ;  [ 11/05/1999  11:18 AM ]
 ;;5.0;AZHLSC;;JUL 10, 1996
 ;
 W !!!,$P($P($T(+1),";",2),"-",2)
 NEW A,B,DIF,NO,V,XCNP,Z,AZHLFILE,AZHLFLD
5 D TTL^AZHLSC("2.1.5,  (8.5)  File/Data Restrictions")
 I 'AZHLPIEN D NPKG^AZHLSC G 6
 S %=0 F  S %=$O(^DIC(9.4,AZHLPIEN,4,%)) Q:'%  W:AZHLTERM "." I $S('$D(^DIC(9.4,AZHLPIEN,4,%,222)):0,$P(^(222),U,7)="y":1,1:0) W !?10,"File ",$P(^(0),U,1)," marked as DATA COMES WITH FILE."
6 D TTL^AZHLSC("2.1.6,  (8.6)  FileManager Access Code Security")
 I 'AZHLPIEN D NPKG^AZHLSC G 16 
 S (A,%)=0,B=""
 F  S %=$O(^DIC(9.4,AZHLPIEN,4,%)) Q:'%  S AZHLACCE=$P($G(^DIC(9.4,AZHLPIEN,4,%,0)),U,1) W:AZHLTERM "." D
 .F %(1)="AUDIT","DD","RD","WR","DEL","LAYGO" Q:'AZHLACCE  I $S('$D(^DIC(AZHLACCE,0,%(1))):1,'$L(^(%(1))):1,1:0) S B=B_$S($L(B):", ",1:"")_%(1)
 .I $L(B) W:'A !?5,"File",?25,"Missing Access Code(s)",!?10,"-------------------------------------------------" S A=1 W !?5,$P(^DIC(9.4,AZHLPIEN,4,%,0),U,1),?25,B S B=""
 .Q
16 ;
 G FILEVR
 ;IHS/JN 1/8/98 THE FOLLOWING CODE IS BY-PASSED, FIELDS WILL BE GONE IN THE NEAR FUTURE AND CHG IS STANDARDS
7 D TTL^AZHLSC("2.1.7,  (8.9)  Version Information")
 I 'AZHLPIEN D NPKG^AZHLSC G 20
 I $S('$D(^DIC(9.4,AZHLPIEN,"VERSION")):1,'(^("VERSION")):1,1:0) W !?10,"Version number not in PACKAGE file.",!?10,"Other fields in VERSION multiple not checked."
 E  S V=^("VERSION"),%="The following fields are missing from the PACKAGE file entry for version "_V_".",V1=0,V1=$O(^DIC(9.4,AZHLPIEN,22,"B",V,V1)),V=V1 K X D
 .;E  S V=^("VERSION"),%="The following fields are missing from the PACKAGE file entry for version "_V_".",V=$O(^DIC(9.4,AZHLPIEN,22,"B",V_$S(V[".":"",1:".0"),0)) K X D;Old line, new line above-RAW 10/93
 .I '$P($G(^DIC(9.4,AZHLPIEN,22,V,0)),U,2) S X(0)="DATE DISTRIBUTED"
 .I '+$P($G(^DIC(9.4,AZHLPIEN,22,V,1,0)),U,3) S X(1)="DESCRIPTION OF ENHANCEMENTS"
 .I '+$P($G(^DIC(9.4,AZHLPIEN,22,V,"I",0)),U,3) S X("I")="INSTALLATION NOTES"
 .I '+$P($G(^DIC(9.4,AZHLPIEN,22,V,"P",0)),U,3) S X("P")="PROGRAMMER NOTES"
 .I '+$P($G(^DIC(9.4,AZHLPIEN,22,V,"R",0)),U,3) S X("R")="RELEASE NOTE"
 .I '+$P($G(^DIC(9.4,AZHLPIEN,22,V,"S",0)),U,3) S X("S")="SYSTEM REQUIREMENTS"
 .I $D(X) W !?5,% F %=0,1,"I","P","R","S" I $D(X(%)) W !?10,X(%)
 .Q
 ;IHS/DSM/JN 1/8/98  THE ABOVE CODE TO LABEL  7  IS BY-PASSED
FILEVR ;
 D TTL^AZHLSC("2.1.7,  (8.9)  Version number in ^DD(file#,0,""VR"")")
 I 'AZHLPIEN D NPKG^AZHLSC G 20
 S %=0 F  S %=$O(^DIC(9.4,AZHLPIEN,4,"B",%)) Q:'%  D
 .I '$D(^DD(%,0,"VR")) W !?10,"Version number not in ^DD(",%,",0,""VR"")."
 .I $S('$D(^DIC(9.4,AZHLPIEN,4,$O(^DIC(9.4,AZHLPIEN,4,"B",%,0)),222)):1,$P(^(222),U,2)'="y":1,1:0) W !?10,"File ",%,", ASSIGN A VERSION NUMBER is not 'YES'."
 .Q
20 D ^AZHLSC20 ; LAYGO Restrictions
 D ^AZHLSC22
 D ^AZHLSC41
 D ^AZHLSC42
 D ^AZHLSC23
 D ^AZHLSC24
 D ^AZHLSC25 ;$NEXT
 D ^AZHLSC26
 D ^AZHLSC27
 D ^AZHLSC28
 D ^AZHLSC29
 Q
BUL ;;BULLETIN
DIBT ;;SORT TEMPLATE
DIE ;;INPUT TEMPLATE
DIPT ;;PRINT TEMPLATE
FUN ;;FUNCTION
HEL ;;HELP FRAME
KEY ;;SECURITY KEY
OPT ;;OPTION
 ;
