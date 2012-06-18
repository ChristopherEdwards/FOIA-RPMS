AUTTVNDR ; IHS/DIRM/JDM/DFM - CHECK FOR VENDOR FILE DUPLICATES; [ 10/06/2006   8:10 AM ]
 ;;98.1;IHS DICTIONARIES (POINTERS);**21**;MAR 04, 1998
 ;
NAME ;EP;Called from ^DD(9999999.11,.01,"LAYGO",1,0)
 Q:$G(DIC(0))'["L"&($G(DLAYGO)'=9999999.11)&($G(DIE)'["AUTTVNDR")
 W !!,"Checking VENDOR NAME for matches.",!
 NEW AUT1,AUT2,AUT3
 S AUT3=X,X=$$^AUTTVND1(AUT3),(AUT1,AUT2)=0
 F  S AUT1=$O(^AUTTVNDR("ASX",X,AUT1)) Q:AUT1'>0  D W
 F AUTJ=1:1 S AUTX=$P(AUT3," ",AUTJ) Q:AUTX=""&($P(AUT3," ",AUTJ+1,9999)="")!$D(AUTQUIT)  D FIND
 KILL AUTJ
 I 'AUT2 W !,"No matches found.",! S AUT2=1 G L3
L2 ;
 W !!,"Do you still want to ",$S($G(DIC(0))'["L"&($G(DLAYGO)'=9999999.11):"make this change",1:"add this entry"),": NO//"
 R AUT2:300
 S AUT2=$TR($E(AUT2_"N"),"NnYy^?","00110?")
 I "01"'[AUT2 W !!?4,"Answer NO to stop the addition of ",AUT3," as a new VENDOR.",!?4,"Answer YES to add, a '^' will be taken as a NO." G L2
L3 ;
 S X=AUT3
 KILL:AUT2'=1 X
 I AUT2
 W !
 Q
 ;
EIN ;EP;CALL WHEN EIN NO. IS EDITED TO CHECK FOR EIN MATCHES
 Q:$D(DDS)&($G(DDS)["ACR")
 Q:$G(DIE)'["AUTTVNDR"
 W !!,"Checking VENDOR EIN for matches.",!
 NEW AUT1,AUT2,AUT3
 S AUT3=X,AUT2=0
 F AUT1=0:0 S AUT1=$O(^AUTTVNDR("C",X,AUT1)) Q:AUT1'>0!(AUT1=$G(DA))  D W
 I 'AUT2 W !,"No matches found." S AUT2=1 G E3
E2 ;
 W !!,"Do you still want to ",$S($G(DIC(0))'["L"&($G(DLAYGO)'=9999999.11):"enter this EIN",1:"add this entry"),": NO//"
 R AUT2:300
 S AUT2=$TR($E(AUT2_"N"),"NnYy^?","00110?")
 I "01"'[AUT2 W !!?4,"Answer NO to stop the addition of ",AUT3," as a new VENDOR.",!?4,"Answer YES to add, a '^' will be taken as a NO." G E2
E3 ;
 S X=AUT3
 KILL:AUT2'=1 X
 I AUT2
 W !
 Q
 ;
SUFFIX ;EP;TO CHECK EIN SUFFICES FOR MATCHES WITH EXISTING VENDORS
 Q:$G(DIE)'["AUTTVNDR"
 W !!,"Checking VENDOR EIN including SUFFIX for matches.",!
 NEW AUT1,AUT2,AUT3
 S AUT3=X,AUT2=0,X=$P($G(^AUTTVNDR(DA,11)),"^")_X
 F AUT1=0:0 S AUT1=$O(^AUTTVNDR("E",X,AUT1)) Q:AUT1'>0  W !?5,$P($G(^AUTTVNDR(AUT1,0)),"^"),?40,$P($G(^AUTTVNDR(AUT1,11)),"^",13) S AUT2=AUT2+1
 I 'AUT2 W !,"No matches found." S AUT2=1 G S3
S2 ;
 I $G(DIE)="^AUTTVNDR(" D
 .W !!,"You cannot create a new VENDOR file entry which has the exact same",!,"EIN and EIN SUFFIX as an existing VENDOR.  Enter the correct SUFFIX for this VENDOR.",!!,"Press <RETURN> to continue.. "
 .R AUT2:300
 .Q
 S AUT2="^"
S3 ;
 S X=AUT3
 KILL:AUT2'=1 X
 I AUT2
 W !
 Q
 ;
FIND ;
 S AUTX=$TR(AUTX,"!@#$%^&*()-_=+[{]}\|':;,<.>/?`~",""),AUTX=$TR(AUTX,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q:"^A^AN^AND^OF^THE^INC^CORP^COMP^"[(U_AUTX_U)
 S:$A($E(AUTX,$L(AUTX)))>65 AUTZ=$E(AUTX,1,$L(AUTX)-1)_$C($A($E(AUTX,$L(AUTX)))-1)_"z"
 S:$E(AUTX,$L(AUTX)) AUTZ=$E(AUTX,1,$L(AUTX)-1)_($E(AUTX,$L(AUTX))-1)
 Q:$G(AUTZ)=""
 F  S AUTZ=$O(^AUTTVNDR("G",AUTZ)) Q:AUTZ=""!(AUTZ'[AUTX)!$D(AUTQUIT)  D
 .S AUT1=0
 .F  S AUT1=$O(^AUTTVNDR("G",AUTZ,AUT1)) Q:'AUT1!$D(AUTQUIT)  D W,R:AUT2#10=0
 .Q
 KILL AUTQUIT
 Q
 ;
W ;
 W !?5
 W:$G(AUTX)]""&($G(AUTX)'=$P($G(^AUTTVNDR(AUT1,0)),"^")) AUTX,?$X+3
 W $P($G(^AUTTVNDR(AUT1,0)),"^"),?40+$S($L($G(AUTX))<16:$L($G(AUTX)),1:15)," ",$P($G(^AUTTVNDR(AUT1,11)),"^",13) S AUT2=AUT2+1
 Q
 ;
R ;
 R !,"Press <RETURN> to continue, '^' to exit ",Z:300
 S:$E(Z)="^" AUTQUIT=""
 Q
 ;
