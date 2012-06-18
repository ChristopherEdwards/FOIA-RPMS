XUINZIS ;SFISC/AC - Postinit to convert Hunt Groups to new format. ;11/9/92  16:24
 ;;7.1;KERNEL;;May 11, 1993
INIT ;
 ;Load data element numbers into ^UTILITY($J,"%ZISSDD",data element number
 D LODUTL^%ZISS
 F %ZISI=1:1 S %ZISZ=$T(Z+%ZISI) Q:%ZISZ=""  S ^UTILITY($J,"%ZISS",$P(%ZISZ,";",5),$P(%ZISZ,";",6))=""
 W !,"Removing 'W ' from Terminal Type fields"
 F D0=0:0 S D0=$O(^%ZIS(2,D0)) Q:D0'>0  I $D(^(D0,0))#2 W "." D
 .S ZISG="" F  S ZISG=$O(^UTILITY($J,"%ZISS",ZISG)) Q:ZISG=""  D
 ..F ZISP=0:0 S ZISP=$O(^UTILITY($J,"%ZISS",ZISG,ZISP)) Q:ZISP'>0  D
 ...I $D(^%ZIS(2,D0,ZISG))#2 S Y=$P(^(ZISG),"^",ZISP) I $E(Y,1,2)="W " D
 ....S $P(^(ZISG),"^",ZISP)=$E(Y,3,$L(Y))
 Q
Z ;
 ;;;;21;1
 ;;;;21;2
 ;;;;201;1
 ;;;;203;1
 ;;;;205;1
 ;;;;207;1
 ;;;;209;1
 ;;;;211;1
 ;;;;G;1
 ;;;;G;2
 ;;;;G;3
 ;;;;G;4
 ;;;;G;5
 ;;;;G;6
 ;;;;G;7
 ;;;;G;8
 ;;;;G;9
 ;;;;G;10
 ;;;;G;11
 ;;;;G0;1
 ;;;;G1;1
 ;;;;I0;1
 ;;;;I1;1
 ;;;;SPR0;1
 ;;;;SPR1;1
 ;;;;SUB0;1
 ;;;;SUB1;1
