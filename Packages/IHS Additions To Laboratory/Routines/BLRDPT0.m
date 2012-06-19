BLRDPT0 ; IHS/DIR/FJE - PATIENT VARIABLE ROUTINE DRIVER, CONT. ; [ 06/16/98  11:25 AM ]
 ;;5.2;BLR;**1003**;JUN 01, 1998
 ;
 ;;MAS VERSION 5.0;
 ;
 ;Initialize variables
 N I1  ;IHS/DIR/AAB 06/12/98
 S U="^" D DT^DICRW:'$D(DT)
 S VAERR=$S('$D(DFN)#2:1,'$D(^DPT(DFN,0)):1,1:0)
 S Y=VAN'=13 I Y,$D(VAROOT)'[0,VAROOT]"" S Y=0,VAV=VAROOT K @VAV
 I Y S:$S(VAN>9:1,'$D(VAHOW):0,1:VAHOW[2) VAV="^UTILITY("_""""_VAV_""""_","_$J_")"
 D @VAN
Q K X,Y,VAC,VAS,VAV,VAW,VAN,I,VAX,VAZ,I1 Q
 ;
INIT ; -- determine #'s or names then init array
 ;
 S VAS="1^2^3^4^5^6^7^8^9^10^11^12^13^14^15^16^17"
 I VAN<10,$D(VAHOW),VAHOW[1 S VAS=$P($T(SS+VAN),";;",2)
 I $D(VAN(1)) F I=1:1:VAN(1) S @VAV@($P(VAS,"^",I))=""
 Q
 ;
1 ; -- [DEM] demos
 D C1,INIT I 'VAERR D 1^BLRDPT1,13 Q
 ;
2 ; -- [OPD] other pt vars
 D C2,INIT,2^BLRDPT1:'VAERR Q
 ;
3 ; -- [ADD] current address
 D C3,INIT,3^BLRDPT1:'VAERR Q
 ;
4 ; -- [OAD] other pt vars
 D C4,INIT,4^BLRDPT1:'VAERR Q
 ;
5 ; -- [INP] inpt data -v5
 D C5,INIT,5^BLRDPT2:'VAERR Q
 ;
6 ; -- [IN5] inpt data v5
 D C6,INIT F I=13:1:17 F I1=1:1:7 S @VAV@($P(VAS,"^",I),I1)=""
 D 6^BLRDPT3:'VAERR Q
 ;
7 ; -- [ELIG] elig data
 D C7,INIT F I=1:1:6 S @VAV@($P(VAS,"^",5),I)=""
 D 7^BLRDPT4:'VAERR Q
 ;
8 ; -- [MB] $ benefits
 D C8,INIT D 8^BLRDPT4:'VAERR Q
 ;
9 ; -- [SVC] service data
 D C9,INIT F I=1:1:8 S @VAV@($P(VAS,"^",I),1)="",@VAV@($P(VAS,"^",I),2)=""
 S @VAV@($P(VAS,"^",2),3)="",@VAV@($P(VAS,"^",2),4)="",@VAV@($P(VAS,"^",4),3)="",@VAV@($P(VAS,"^",5),3)=""
 F I=6,7,8 F I1=3,4,5 S @VAV@($P(VAS,"^",I),I1)=""
 D 9^BLRDPT4:'VAERR Q
 ;
10 ; -- [REG] registration data
 D C10,INIT D 10^BLRDPT5:'VAERR Q
 ;
11 ; -- [SDE] clinic enrollment data
 D C11,INIT D 11^BLRDPT5:'VAERR Q
 ;
12 ; -- [SDA] appt data
 D C12,INIT D 12^BLRDPT5:'VAERR Q
 ;
13 ; -- [PID] pt id's
 S (VA("PID"),VA("BID"))="" D 13^BLRDPT6:'VAERR Q
 ;
KVAR ; kill all vadpt data
 K VAN
C1 K ^UTILITY("VADM",$J),VADM Q:$D(VAN)
C2 K ^UTILITY("VAPD",$J),VAPD Q:$D(VAN)
C3 K X S:$D(VAPA("P")) X("P")=VAPA("P")
 K ^UTILITY("VAPA",$J),VAPA
 S:$D(X("P")) VAPA("P")=X("P") K X Q:$D(VAN)
C4 K X S:$D(VAOA("A")) X("A")=VAOA("A")
 K ^UTILITY("VAOA",$J),VAOA
 S:$D(X("A")) VAOA("A")=X("A") K X Q:$D(VAN)
C5 K ^UTILITY("VAIN",$J),VAIN Q:$D(VAN)
C6 K X F I="D","E","L","M","V" I $D(VAIP(I)) S X(I)=VAIP(I)
 S Y=$S('$D(VAIP("V")):"VAIP",VAIP("V")'?1A.E:"VAIP",1:VAIP("V")) K ^UTILITY(Y,$J),@Y
 F I="D","E","L","M","V" I $D(X(I)) S VAIP(I)=X(I)
 K X Q:$D(VAN)
C7 K ^UTILITY("VAEL",$J),VAEL Q:$D(VAN)
C8 K ^UTILITY("VAMB",$J),VAMB Q:$D(VAN)
C9 K ^UTILITY("VASV",$J),VASV Q:$D(VAN)
C10 K ^UTILITY("VARP",$J) Q:$D(VAN)
C11 K ^UTILITY("VAEN",$J) Q:$D(VAN)
C12 K ^UTILITY("VASD",$J) Q
C13 Q
 ;
SS ;  1^ 2^ 3^ 4^ 5^ 6^ 7^ 8^ 9^10^11^12^13^14^15^16^17
 ;;NM^SS^DB^AG^SX^EX^RE^RA^RP^MS
 ;;BC^BS^FN^MN^MM^OC^ES
 ;;L1^L2^L3^CI^ST^ZP^CO^PN^TS^TE
 ;;L1^L2^L3^CI^ST^ZP^CO^PN^NM^RE
 ;;AN^DR^TS^WL^RB^BS^AD^AT^AF^PT
 ;;MN^TT^MD^MT^WL^RB^DR^TS^MF^BS^RD^PT^AN^LN^PN^NN^DN
 ;;EL^PS^SC^VT^IN^TY^CN^ES^MT
 ;;AA^HB^SS^PE^MR^SI^DI^OR^GI
 ;;VN^AO^IR^PW^CS^S1^S2^S3
