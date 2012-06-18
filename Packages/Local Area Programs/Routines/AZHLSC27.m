AZHLSC27 ; IHS/ADC/GTH:KEU:JN - SAC CHAPTER 2: M LANGUAGE PROGRAMMING STANDARDS & CONVENTIONS ;  [ 06/05/1998  7:30 AM ]
 ;;5.0;AZHLSC;;JUL 10, 1996
 ;
 ;W !!!,$P($P($T(+1),";",2),"-",2)
 NEW A,B,DIF,NO,V,XCNP,Z
4 D TTL^AZHLSC("2.7.4,  (8.4)  Menu Options")
 I 'AZHLPIEN D NPKG^AZHLSC Q
 S %=AZHLNMSP
 F  S %=$O(^DIC(19,"B",%)) Q:'($E(%,1,$L(AZHLNMSP))=AZHLNMSP)  S A=$O(^(%,0)),B=0 F  S B=$O(^DIC(19,A,10,"B",B)) Q:'B  S C=$O(^(B,0)) D
 .I $E($P(^DIC(19,A,10,C,0),U,2))'?1A W !?10,"Option ",%," has non-Alpha synonym: '",$P(^(0),U,2),"'."
 .Q
 Q
