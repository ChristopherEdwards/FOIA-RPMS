DGVREL3 ;ALB/MRL - FORMAT RELEASE MESSAGE/LETTER ; 2 JUN 87
 ;;5.3;Registration;;Aug 13, 1993
 K ^UTILITY($J) D:'$D(DT) DT^DICRW S Y=DT X ^DD("DD") S DGD=Y,DGFAC=$S($D(^DD("SITE"))#2:^("SITE"),1:"FACILITY UNKNOWN")_$S($D(^DD("SITE",1)):" ("_^(1)_")",1:""),DGS="MAS V."_DGVREL_" INSTALLATION"
 S DGC=0 I DGHOW="L" S DGT="DATE:  "_DGD D S S DGT="" D S S DGT="FROM:  "_DGFAC D S S DGT="" D S S DGT="SUBJ:  "_DGS D S F I=1:1 S DGT=$P($T(TO+I),";;",2) Q:DGT="QUIT"  D S
 S DGT="1.  DPT Installation: STARTED            COMPLETED          HOURS  MINUTES" D S,L
 S DGO="",$P(DGO," ",40)="",(DGHT,DGMT)=0,DGN=^DG(48,DGVREL,"R") F DGJ=5,6,7 S DGT="",DGI=$P(DGN,"^",DGJ),DGI1=$P(DGN,"^",DGJ+1) D TIME
 D L S DGJ=0,DGT="",$P(DGT," ",61)="",DGI=$P(DGN,"^",5),DGI1=$P(DGN,"^",8) D TIME S DGT="" D S
 S DGT="2.  DG Installation:  STARTED            COMPLETED          HOURS  MINUTES" D S,L
 S DGO="",$P(DGO," ",40)="",(DGHT,DGMT)=0,DGN=^DG(48,DGVREL,"R") F DGJ=1,2,3 S DGT="",DGI=$P(DGN,"^",DGJ),DGI1=$P(DGN,"^",DGJ+1) D TIME
 D L S DGJ=0,DGT="",$P(DGT," ",61)="",DGI=$P(DGN,"^",1),DGI1=$P(DGN,"^",4) D TIME S DGT="" D S
 G FILE:'DGVRELSD S DGT="3.  SD Installation:  STARTED            COMPLETED          HOURS  MINUTES" D S,L
 S DGO="",$P(DGO," ",40)="",(DGHT,DGMT)=0,DGN=^DG(48,DGVREL,"R") F DGJ=9,10,11 S DGT="",DGI=$P(DGN,"^",DGJ),DGI1=$P(DGN,"^",DGJ+1) D TIME
 D L S DGJ=0,DGT="",$P(DGT," ",61)="",DGI=$P(DGN,"^",9),DGI1=$P(DGN,"^",12) D TIME S DGT="" D S
FILE S DGN=^DG(48,DGVREL,"S"),DGFILE=0 G ^DGVREL4:'$P(DGN,"^",1) F DGJ1="REGISTRATION","SCHEDULING" S DGJ=$O(^DIC(9.4,"B",DGJ1,0)) Q:'DGJ  D GET
 D:C=1 S S DGT="" D S S C=$S(DGVRELSD:5,1:4),DGT=C_".  Patient File has '"_$S($D(^DPT(0)):+$P(^(0),"^",4),1:0)_"' Entries." D S S DGFILE=1,DGT="" D S
 G ^DGVREL4
GET S DGT="" D S S C=$S('DGVRELSD:3,DGJ1="REGISTRATION":4,1:0) I C S DGT=C_".  FILE NAME                #ENTRIES     FILE NAME                   #ENTRIES" D S
 S DGT="    ---------                --------     ---------                   --------" D S
 S C=0 F I=0:0 S I=$O(^DIC(9.4,DGJ,4,"B",I)) Q:'I  S DGF=^DIC(I,0),DGF1=^DIC(I,0,"GL"),DGF2=$S($D(@(DGF1_"0)")):+$P(@(DGF1_"0)"),"^",4),1:0),C=C+1 D:C=1 F1 I C=2 D F2 S DGT=DGT_DGT1,C=0 D S
 Q
TIME I DGJ S DGT="    "_$S(DGJ=1!(DGJ=5):"PRE-",DGJ=2!(DGJ=6!(DGJ=10)):"ACTUAL ",1:"POST-")_"INIT"_DGO,DGT=$E(DGT,1,22),Y=DGI X ^DD("DD") S DGT=DGT_$E(Y_DGO,1,19) S Y=DGI1 X ^DD("DD") S DGT=DGT_$E(Y_DGO,1,19)
 S X=DGI,DGX=$P(X,".",2),DGX=$E((DGX_"000"),1,4) D H^%DTC S DGX=%H_","_($E(DGX,1,2)*60*60+($E(DGX,3,4)*60)),X=DGI1,DGX1=$P(X,".",2),DGX1=$E((DGX1_"000"),1,4) D H^%DTC S DGX1=%H_","_($E(DGX1,1,2)*60*60+($E(DGX1,3,4)*60))
 S X=DGX1,Y=(X-DGX)*86400,X1=$P(X,",",2),X2=$P(DGX,",",2),X3=Y-X2+X1,X=X3\3600,X1=X3#3600\60 S:'X&('X1) X1=1 S DGM=X1,DGH=X
HM S DGT=DGT_$J(DGH,5),DGT=DGT_$J(DGM,9)
S S DGC=DGC+1,^UTILITY($J,"DGVREL",DGC,0)=DGT Q
L S DGT="                      ----------------   ----------------    -----  -------" D S Q
F1 S DGT="    "_$E($P(DGF,"^",1),1,24)_DGO,DGT=$E(DGT,1,28)_$J(DGF2,9)_DGO,DGT=$E(DGT,1,42)
F2 S DGT1=$E($P(DGF,"^",1),1,25)_DGO,DGT1=$E(DGT1,1,28)_$J(DGF2,8) Q
 Q
TO ;
 ;;
 ;;TO:    Director
 ;;       Information Systems Center (10BA1/ADP)
 ;;       Frear Building
 ;;       2 Third Street, Suite 301
 ;;       Troy, New York      12180
 ;;
 ;;
 ;;QUIT
