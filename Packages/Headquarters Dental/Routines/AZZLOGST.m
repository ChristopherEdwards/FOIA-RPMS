AZZLOGST ; DISPLAYS STATISTICS ON USER AND DEVICE LOGINS. [ 01/03/90  9:15 AM ]
 ; Mike Remillard, DDS, ISC/BAO
 ;
 D ^AUKVAR
 K AZZLO
 D ^AUCLS W ?22,"* * *  LOGIN STATISTICS  * * *"
 W !!,"This will take a minute, so enjoy the dots ..."
DATES ;
 S X=$P($O(^XUSEC(0,0)),".")
 S AZZLO("DATE")=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3)
 S N=0 F I=1:1 S N=$O(^XUSEC(0,N)) Q:'N  W:'(I#100) "." S X=N
 S AZZLO("DATE1")=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3)
START ;
 S N=0 F I=1:1 S N=$O(^XUSEC(0,N)) Q:'N  W:'(I#10) "." D
 .S AZZLO("DUZ")=$P(^XUSEC(0,N,0),U),AZZLO("DEV")=$P(^(0),U,2)
 .I '$D(AZZLO(AZZLO("DUZ"))) S AZZLO(AZZLO("DUZ"))=0
 .I '$D(AZZLO("DEV",AZZLO("DEV"))) S AZZLO("DEV",AZZLO("DEV"))=0
 .S $P(AZZLO(AZZLO("DUZ")),U)=$P(AZZLO(AZZLO("DUZ")),U)+1
 .S $P(AZZLO("DEV",AZZLO("DEV")),U)=$P(AZZLO("DEV",AZZLO("DEV")),U)+1
 .K X S D0=N D TIME
 .S:$D(X) $P(AZZLO(AZZLO("DUZ")),U,2)=$P(AZZLO(AZZLO("DUZ")),U,2)+X
 .S:$D(X) $P(AZZLO("DEV",AZZLO("DEV")),U,2)=$P(AZZLO("DEV",AZZLO("DEV")),U,2)+X
NEXT ;
 ;-----> SET "B", "C", "E", AND "F" XREFS
 ;-----> "B" = NUMBER OF SIGNONS PER USER
 ;-----> "C" = TOTAL TIME PER USER
 ;-----> "E" = NUMBER OF SIGNONS PER DEVICE
 ;-----> "F" = TOTAL TIME PER DEVICE
 S N=0 F I=1:1 S N=$O(AZZLO(N)) Q:'N  W:'(I#10) "." S AZZLO("B",-$P(AZZLO(N),U),N)=N
 S N=0 F I=1:1 S N=$O(AZZLO(N)) Q:'N  W:'(I#10) "." S AZZLO("C",-$P(AZZLO(N),U,2),N)=N
 S N=0 F I=1:1 S N=$O(AZZLO("DEV",N)) Q:'N  W:'(I#10) "." S AZZLO("E",-$P(AZZLO("DEV",N),U),N)=N
 S N=0 F I=1:1 S N=$O(AZZLO("DEV",N)) Q:'N  W:'(I#10) "." S AZZLO("F",-$P(AZZLO("DEV",N),U,2),N)=N
 H 1
 ;
 D ^AZZLOGS1
EXIT ;
 K AZZLO,I,N,X
 D ^%AUCLS
 Q
TIME ;
 S X1=$P(^XUSEC(0,D0,0),U,4),X="" Q:X1<2000000  S X=D0,Y=$E(X1_"000",9,10)-$E(X_"000",9,10)*60+$E(X1_"00000",11,12)-$E(X_"00000",11,12),X2=X,X=$P(X,".",1)'=$P(X1,".",1) D ^%DTC:X S X=X*1440+Y
 Q
