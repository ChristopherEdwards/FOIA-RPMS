DGRP14 ;ALB/MRL - REGISTRATION SCREEN 14/APPOINTMENT INFORMATION ;06JUN 88@2300
 ;;5.3;Registration;;Aug 13, 1993
 S DGRPS=14 D H^DGRPU S (Z,DGRPW)=1 D WW^DGRPV W " Enrollment Clinics: " S I1="" F I=0:0 S I=$O(^DPT(DFN,"DE",I)) Q:'I  I $P(^(I,0),U,2)'="I" S I1=1,X=$S($D(^SC(+^(0),0)):$P(^(0),U,1)_", ",1:"") W:(79-$X)<$L(X) !?24 W X
 W:'I1 "NOT ACTIVELY ENROLLED IN ANY CLINICS AT THIS TIME" W ! S Z=2 D WW^DGRPV W "     Pending Appt's",?18,": " S I1="",I2=DT_".9999"
 F I=0:0 S I2=$O(^DPT(DFN,"S",I2)) Q:I2=""  I $S($P(^(I2,0),U,2)']"":1,$P(^(0),U,2)="I":1,1:0) S X=+$P(^(0),U,1),Y=I2 X ^DD("DD") S X=$S($D(^SC(+X,0)):$P(^(0),U,1),1:"UNKNOWN CLINIC")_" ("_Y_"), ",I1=1 W:(79-$X)<$L(X) !?24 W X
 I 'I1 W "NO PENDING APPOINTMENTS ON FILE"
Q K I,I1,I2,X,Y G ^DGRPP
