AUGSAVE ;RPMS/TJF/MLQ;GENERIC GLOBAL SAVE FOR TRANSMISSION GLOBALS  
 ;;1.4;AUGS;*0*;OCT 16, 1991
SETUP K AUFLG,AUGLL S:'$D(DTIME) DTIME=300
START I '$D(AUGL) S AUFLG(1)="The variable 'AUGL' must contain the name of the global you wish to save." S AUFLG=-1 G EOJ
 D CHECK
 S:'$D(AUUF) AUUF="/usr/spool/uucppublic"
CKGLOB I '$D(@AUGLL) S AUFLG(1)="Transaction File does not exist",AUFLG=-1 G EOJ
 I '$D(DT) S AUFLG(1)="Fileman Date 'DT' not defined",AUFLG=-1 G EOJ
 S X2=$E(DT,1,3)_"0101",X1=DT D ^%DTC S AUCARTNO=X+1
 S:'$D(AUDT) AUDT="T"
 S X=AUDT
 S X="T",%DT="" D ^%DT S AUDT=$P("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"," ",$E(Y,4,5))_" "_(+$E(Y,6,7))_", "_($E(Y,1,3)+1700) S:$E(AUGL,1)'="^" AUGL="^"_AUGL ;S:$E(AUGL,$L(AUGL))'="(" AUGL=AUGL_"("
 I '$D(AUNAR) S AUNAR=""
 I '$D(DUZ(2)) S AUFLG(1)="User Number 'DUZ(2)' is not defined",AUFLG=-1 G EOJ
 S:'$D(AUTLE) AUTLE="" S AUTLE=AUTLE_" "_$P(^DIC(4,DUZ(2),0),"^",1)
 I '$D(^%ZOSF("OS")) S AUFLG(1)="The ^%ZOSF(""OS"") node does not exist",AUFLG=-1 G EOJ
 I ^%ZOSF("OS")["MSM" G SETUPMSM
 I ^%ZOSF("OS")["DSM" G SETUPDSM
 S AUFLG(1)="Operating system is not 'MSM' or 'DSM'",AUFLG=-1
 G EOJ
SETUPMSM ;SETUP FOR MSM
 S:'$D(AUIO) AUIO=51
 I $D(AUMED) I "CcDdFfTt"'[AUMED S AUFLG(1)="Media Type 'AUMED' is incorrect",AUFLG=-1 G EOJ
 D ^AZGSAVEM
 S:'$D(AUFLG) AUFLG=0
 G EOJ
SETUPDSM ;SETUPDSM
 I '$D(AUIO) S AUIO=47
 I $D(AUMED) I "CcTt"'[AUMED S AUFLG(1)="Media Type 'AUMED' is incorrect",AUFLG=-1 G EOJ
 D ^AZGSAVED
 S:'$D(AUFLG) AUFLG=0
EOJ ;KILL VARIABLES AND EXIT
 K AUGL,AUGLL,AUCARTNO,X1,X2,X,AUNAR,AUTLE,AUIO
 K AUPAR,AUDT,AUE,AUF,AUMED,%DT,AUUF,Y,%DEV
 Q
CHECK S X=AUGL
 I $L(X,"(")>1,$P(X,"(",2)="" S X=$P(X,"(")
 S:$E(X,$L(X))="," X=$E(X,1,($L(X)-1))
 I $L(AUGL,"(")>1,$E(AUGL,$L(AUGL))'="," S AUGL=AUGL_","
 I $L(X,"(")>1,$E(X,$L(X))'=")" S X=X_")"
 S:$L(X,"(")=1 AUGL=X_"("
 S AUGLL=U_X
 Q
