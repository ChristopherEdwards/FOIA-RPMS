INHBLD ;DP;12:16 PM  12 Apr 1996;14 Feb 96 08:15 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 W # R "Number of records: ",NUM:$G(DTIME,300)
 Q:'NUM  K ^UTIL(DUZ),DST,DEST
 N ZZ,ZZ1 F ZZ=1:1:6 S ZZ1(ZZ)=$P($T(ZZ1+ZZ),";;",2)
 ;Build an array of active destinations for this run
 W !,"Building array of active background processes",!
 F I=20:1:47 D
 .Q:'$D(^INRHB("RUN",I))
 .S DST=$P(^INTHPC(I,0),U,7) Q:'DST
 .W $P(^INTHPC(I,0),U),!
 .S DEST(DST)=""
 I '$D(DEST) W "No background processes are active. No messages generated!",! Q
 S DST="" F ZZ=1:1:NUM D
 .;Get next destination from array of active destinations
 .D
 ..S DST=$O(DEST(DST))
 ..;if DST="", start over
 ..S DST=$O(DEST(DST))
 .S X="NOW",DLAYGO=4001,DIC="^INTHU(",DIC(0)="FL" D ^DICN
 .S (INREQIEN,DA)=+Y L +^INTHU(DA) S ^UTIL(DUZ,ZZ)=INREQIEN K A1 D NAME
 .;B  S $P(^INTHU(0),U,3)=DA
 .S DIE="^INTHU(",DR="[INH MESSAGE NEW]" D ^DIE
 .S TIM=$$CDATH2F^%ZTFDT($H),MID="CHCS"_INREQIEN
 .S ^INTHU("B",TIM,INREQIEN)="",^INTHU("C",MID,INREQIEN)=""
 .;Concatenate time (.01 field) and destination to remainder
 .S X1=ZZ1(1),X=TIM_U_DST_U_$P(X1,U,3,4)_U_MID_U_$P(X1,6,99)
 .;S X1=ZZ1(1),X=TIM_U_$P(X1,U,2,4)_U_MID_U_$P(X1,6,99)
 .S ^INTHU(INREQIEN,0)=X,^INTHU(INREQIEN,3,0)=ZZ1(2)
 .S X1=ZZ1(3),X=$P(X1,U,1,9)_U_MID_U_$P(X1,U,11,99)
 .S ^INTHU(INREQIEN,3,1,0)=X
 .S ^INTHU(INREQIEN,3,2,0)=ZZ1(4)
 .S ^INTHU(INREQIEN,3,4,0)=ZZ1(6)
 .S ^INTHU(INREQIEN,3,3,0)=NAME
 .;Queue the message
 .;S INDEST=$P(^INTHU(INREQIEN,0),U,2)
 .;S INQUE=$P($G(^INRHD(INDEST,0)),U,12)
 .;S ^INLHDEST(INDEST,0,$H,INREQIEN)=""
 .S ^INLHDEST(DST,0,$H,INREQIEN)=""
 .L -^INTHU(INREQIEN)
 Q
NAME ;SET LIST OF NAMES
 S A=$R(1000) S:'$D(^DPT(A,0)) A=$O(^DPT(A))
 Q:'$D(^DPT(A,0))
 S A1=^DPT(A,0),A2=$G(^DPT(A,.11))
 S X=ZZ1(5),X1=$P(X,U,4),$P(X1,"\",1)=A,N=$P(A1,U)
 S NAME=$P(N,",")_"\"_$P($P(N,",",2)," ")_"\"_$P($P(N,",",2)," ",2)_"\\\"
 ;W !,X,!!,A1,!!,NAME
 S $P(X,U,6)=NAME,NAME=X ; W !,X
 S ZZ1(5)=X
 Q
ZZ1 ;
 ;;2951220.183743^11019^N^0^CHCS485207^^^^^O^12122^^^^^0^^^56601,67063
 ;;^^4^4
 ;;MSH^\|~&^CHCSADT^A0101^^^19951220183700^^ADT\A04^CHCS485207^P^2.2^^^^|CR|
 ;;EVN^A04^^^|CR|
 ;;PID^1^^424385\\\A0101^20/567-67-7890^GREEN\CHILD\ONE\\\^^19190505000000^M^^C^\\UNIVERSITY CITY\CALIFORNIA\92122^^^^^S^^^567-67-7890^^^^^^^^4104\USA ACTIVE DUTY ENLISTED\99PAT|CR|
 ;;PV1^1^O^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^|CR|
 ;
