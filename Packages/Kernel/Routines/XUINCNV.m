XUINCNV ;SFISC/HVB - STRIP ASCII 127&128 FROM AC&VC ;8/25/89  09:15 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1002,1003,1004,1005,1007**;APR 1, 2003
 ;;7.1;KERNEL;;May 11, 1993
 S T=+$H F X=0:0 S X=$O(^VA(200,X)) Q:'X  D B
 Q
B Q:'$D(^VA(200,X,0))  S (AC,AC0)=$P(^(0),"^",3) Q:AC=""!('$D(^(.1)))  S (VC,VC0)=$P(^(.1),"^",2)
C F Z=0:0 Q:AC'[$C(127)  S P=$F(AC,$C(127)),AC=$E(AC,1,P-2)_$E(AC,P,20)
 F Z=0:0 Q:AC'[$C(128)  S P=$F(AC,$C(128)),AC=$E(AC,1,P-2)_$E(AC,P,20)
 F Z=0:0 Q:VC'[$C(127)  S P=$F(VC,$C(127)),VC=$E(VC,1,P-2)_$E(VC,P,20)
 F Z=0:0 Q:VC'[$C(128)  S P=$F(VC,$C(128)),VC=$E(VC,1,P-2)_$E(VC,P,20)
 W:$X>74 ! S Y=1
 I AC'=AC0 S $P(^VA(200,X,0),"^",3)=AC,^VA(200,"A",AC,X)=T K ^VA(200,"A",AC0) W X,"a" S Y=0
 I VC'=VC0 S $P(^VA(200,X,.1),"^",2)=VC W:Y X W "v"
 Q
