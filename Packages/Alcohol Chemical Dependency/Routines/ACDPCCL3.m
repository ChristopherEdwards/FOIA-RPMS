ACDPCCL3 ;IHS/ADC/EDE/KML - PCC LINK;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
 ;
SETIIF ; SET IIF VARIABLES
 S ACDQ=1
 S ACDIIF=$O(ACDPCCL(ACDDFNP,ACDVIEN,"IIF",0))
 I 'ACDIIF D ERROR^ACDPCCL("No IIF entry specified for visit",5) Q
 I '$D(^ACDIIF(ACDIIF,0)) D ERROR^ACDPCCL("Specified IIF entry doesn't exist",5) Q
 S ACDEV("IIF IEN")=ACDIIF
 S X=^ACDIIF(ACDIIF,0)
 S ACDEV("TIME")=$P(X,U,6)*60
 I '+X D ERROR^ACDPCCL("No primary problem in specified IIF entry",5) Q
 S W=$P(^ACDPROB(+X,0),U,3)
 I W="" D ERROR^ACDPCCL("No ICD9 code for primary problem",5) Q
 S W=W_":"_$P(^ICD9(W,0),U)
 S Z=$S($P(^ACDPROB(+X,0),U,2)="55":0,1:1) I 'Z,$P(X,U,2)="" S Z=1
 S ACDEV("POV",2)=W_":CHEMICAL DEPENDENCY-"_$S(Z:$P(^ACDPROB(+X,0),U),1:$P(X,U,2))
 S Y=0 F C=3:1 S Y=$O(^ACDIIF(ACDIIF,3,Y)) Q:'Y  I $D(^ACDIIF(ACDIIF,3,Y,0)) S X=^(0) D
 . I '+X D ERROR^ACDPCCL("No problem in OTHER PROBLEMS multiple entry",5) Q
 . S W=$P(^ACDPROB(+X,0),U,3)
 . Q:W=""  ;                           no ICD9 code
 . S W=W_":"_$P(^ICD9(W,0),U)
 . S Z=$S($P(^ACDPROB(+X,0),U,2)="55":0,1:1) I 'Z,$P(X,U,2)="" S Z=1
 . S ACDEV("POV",C)=W_":CHEMICAL DEPENDENCY-"_$S(Z:$P(^ACDPROB(+X,0),U),1:$P(X,U,2))
 . Q
 S ACDQ=0
 D EOJ
 Q
 ;
SETTDC ; SET TDC VARIABLES
 S ACDQ=1
 S ACDTDC=$O(ACDPCCL(ACDDFNP,ACDVIEN,"TDC",0))
 I 'ACDTDC D ERROR^ACDPCCL("No TDC entry for visit",5) Q
 I '$D(^ACDTDC(ACDTDC,0)) D ERROR^ACDPCCL("Specified TDC entry doesn't exist",5) Q
 S ACDEV("TDC IEN")=ACDTDC
 S X=^ACDTDC(ACDTDC,0)
 S ACDEV("TIME")=$P(X,U,29)*60
 S W=+$P(X,U,27)
 I 'W D ERROR^ACDPCCL("No primary problem in specified TDC entry",5) Q
 S W=$P(^ACDPROB(W,0),U,3)
 Q:W=""  ;                             no ICD9 code
 S W=W_":"_$P(^ICD9(W,0),U)
 S Z=$S($P(^ACDPROB(+$P(X,U,27),0),U,2)="55":0,1:1) I 'Z,$P(X,U,28)="" S Z=1
 S ACDEV("POV",2)=W_":CHEMICAL DEPENDENCY-"_$S(Z:$P(^ACDPROB(+$P(X,U,27),0),U),1:$P(X,U,28))
 S Y=0 F C=3:1 S Y=$O(^ACDTDC(ACDTDC,3,Y)) Q:'Y  I $D(^ACDTDC(ACDTDC,3,Y,0)) S X=^(0) D
 . I '+X D ERROR^ACDPCCL("No problem in OTHER PROBLEMS multiple entry",5) Q
 . S W=$P(^ACDPROB(+X,0),U,3)
 . Q:W=""  ;                           no ICD9 code
 . S W=W_":"_$P(^ICD9(W,0),U)
 . S Z=$S($P(^ACDPROB(+X,0),U,2)="55":0,1:1) I 'Z,$P(X,U,2)="" S Z=1
 . S ACDEV("POV",C)=W_":CHEMICAL DEPENDENCY-"_$S(Z:$P(^ACDPROB(+X,0),U),1:$P(X,U,2))
 . Q
 S ACDQ=0
 D EOJ
 Q
 ;
SETCS ; SET CS VARIABLES
 S ACDQ=1
 S ACDCS=$O(ACDPCCL(ACDDFNP,ACDVIEN,"CS",0))
 I 'ACDCS D ERROR^ACDPCCL("No CS entry specified for visit",5) Q
 S X="V65.4",W=$O(^ICD9("AB",X,0))
 I 'W D ERROR^ACDPCCL("Cannot find ICD9 code V65.4 - notify programmer",5) Q
 S Y="V65.42",Y=$O(^ICD9("AB",Y,0)) S:Y W=Y,X="V65.42"
 S ACDEV("POV",1)=W_":"_X_":CONSULTING ON SUBSTANCE USE & ABUSE"
 S (ACDC,ACDCS)=0 F  S ACDCS=$O(ACDPCCL(ACDDFNP,ACDVIEN,"CS",ACDCS)) Q:'ACDCS  D SETCS2
 S ACDQ=0
 D EOJ
 Q
 ;
SETCS2 ;
 S ACDQ=1
 I '$D(^ACDCS(ACDCS,0)) D ERROR^ACDPCCL("Specified CS entry doesn't exist",5) Q
 S X2=+^ACDCS(ACDCS,0)-1,X1=ACDEV("V DATE") D C^%DTC S ACDCSDTE=X
 S ACDX=^ACDCS(ACDCS,0)
 S W=+$P(ACDX,U,2)
 I 'W D ERROR^ACDPCCL("No client service in specified CS entry",5) Q
 S ACDNARR=$P(^ACDSERV(W,0),U)
 S Y=$P(^ACDSERV(W,0),U,4)
 ;S W=$P(^ACDSERV(W,0),U,4)
 ;Q:W=""  ;                             no ICD0 code
 ;S W=W_":"_$P(^ICD0(W,0),U)
 S W=$P(^ACDSERV(W,0),U,5)
 Q:W=""  ;                              no CPT code
 S W=W_":"_$P(^ICPT(W,0),U) ;           cpt code
 S:Y W=W_"/"_$P(^ICD0(Y,0),U) ;         icd0 code
 S (ACDCSLOC,ACDLOC)=$P(ACDX,U,3)
 I ACDFPCC D  Q:ACDQ  S ACDQ=1,ACDLOC=ACDLOCPC,ACDEV("PROC",ACDCSDTE,ACDLOC,"PCC LOC")=ACDLOCPC ;                      use PCC location if available
 . S ACDQ=0
 . I $P(ACDX,U,6) S ACDLOCPC=$P(ACDX,U,6) Q
 . S ACDLOCPC=$P(^ACDLOT(+$P(ACDX,U,3),0),U,4)
 . I 'ACDLOCPC D ERROR^ACDPCCL("No PCC LOCATION for CDMIS LOCATION entry",5) S ACDQ=1 Q
 . Q
 S ACDEV("PROC",ACDCSDTE,ACDLOC,"CS LOC")=ACDCSLOC
 S ACDC=ACDC+1
 S ACDEV("PROC",ACDCSDTE,ACDLOC,ACDC,"CS IEN")=ACDCS
 S ACDEV("PROC",ACDCSDTE,ACDLOC,ACDC,"NARR")=W_":CHEMICAL DEPENDENCY-"_ACDNARR
 S ACDEV("PROC",ACDCSDTE,ACDLOC,ACDC,"TIME")=$P(ACDX,U,4)*60
 S Y=0 F  S Y=$O(^ACDCS(ACDCS,1,Y)) Q:'Y  I $D(^ACDCS(ACDCS,1,Y,0)) S X=+^(0),ACDEV("PROC",ACDCSDTE,ACDLOC,ACDC,"PROV",X)="",ACDEV("PROC",ACDCSDTE,ACDLOC,"PROV",X)=""
 S ACDQ=0
 Q
 ;
EOJ ;
 K ACDC,ACDCS,ACDCSDTE,ACDCSLOC,ACDIIF,ACDLOC,ACDLOCPC,ACDNARR,ACDTDC,ACDX
 Q
