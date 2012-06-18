%ZTF ; JSH,GFT,ESS,Hrubovcak ; 14 Jan 98 07:52; Function Library for MSM/Windows NT  
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;CHCS TLS_4603; GEN 1; 21-MAY-1999
 ;COPYRIGHT 1998 SAIC
 ;This version is for MICRONETICS MUMPS.
 N %,N,R,L,T
 W !,"Available functions in library ^"_$T(+0)
 S N=0 F %=2:1 S R=$T(+%) Q:R=""  D
 .S L=$P(R," "),T=$E(R,$F(R," "),999)
 .I L]"",$E(T)=";" W !!,$P(L,"("),?10,"(",$P(L,"(",2,99) S N=1
 .I N,$E(T)=";" W !,?5,T Q
 Q
ABS(X) ;Returns the absolute value of X.
 Q $S(X<0:-X,1:X)
 ;
ACTIVE(XJB,XNOD) ;Return true if job number active, false if inactive (logged off)
 ; Input: XJB  = $J for the process to check
 ;        XNOD = Node name of the job to check
 ;
 N XACT,XALLNODS,XCNT,XCURNOD,XRES,XUCI,XVOL
 ; If no node name is passed check only the current node
 S XNOD=$G(XNOD) Q:'$L(XNOD) $$ACTIVE^%ACTJOB(XJB)
 S XCURNOD=$$NODENAME^%ZTF ; get the name of the current node
 ; If XNOD is the same as the current node, do not need to job remotely
 Q:XCURNOD=XNOD $$ACTIVE^%ACTJOB(XJB)
 K ^%ZTSCH("ACTIVE",XJB,0) ; this node is being used to pass the result
 ; grab all node names, and production UCI,VOL
 S XALLNODS=$$NODES^%ZTOS,XUCI=$G(^%ZOSF("PROD")),XVOL=$P(XUCI,",",2)
 S XUCI=$P(XUCI,",")
 ; If the node to job to is not a valid node quit false
 Q:'$F(XALLNODS,XNOD)!('$L(XUCI))!('$L(XVOL)) ""
 ; job the check to prevent the DDP hang if remote node is not up
 J ACTIVJ^%ZTF(XJB,XUCI,XVOL,XNOD)
 ; now wait for the remote job to finish and pass the result back
 S XCNT=0 F  D  Q:XRES!(XCNT>10)
 .L +^%ZTSCH("ACTIVE",XJB,0)
 .S XRES=$D(^%ZTSCH("ACTIVE",XJB,0))
 .L -^%ZTSCH("ACTIVE",XJB,0)
 .S XCNT=XCNT+1 H 1
 ; get the result, cleanup and return the result
 S XACT=$G(^%ZTSCH("ACTIVE",XJB,0)) K ^%ZTSCH("ACTIVE",XJB,0)
 Q XACT
 ;
ACTIVJ(XJB,XUCI,XVOL,XNOD) ; Start ACTIV^%ZTF on a remote node
 ;
 ; Input: XJB  = $J for the process to check
 ;        XUCI = UCI name of the Production UCI
 ;        XVOL = Volume name of the Production UCI
 ;        XNOD = Node name of the job to check
 ;
 ; job the check on the remote node XNOD
 N X
 S X="ACTERR^%ZTF",@^%ZOSF("TRAP")
 X "J ACTIV^%ZTF(XJB)|XUCI,XVOL,XNOD|::10"   ;***
 Q
ACTIV(XJB) ;Return true if job number active, false if inactive (logged off)
 ; pass the result to the remote process in the ^%ZTSCH("ACTIVE" global
 ; Input: XJB  = $J for the process to check
 ;
 S ^%ZTSCH("ACTIVE",XJB,0)=$$ACTIVE^%ACTJOB(XJB)
 Q
ACTERR ; Trap error if not able to job on remote node
 ; assume job being not active
 S ^%ZTSCH("ACTIVE",XJB,0)=0
 D ET^%ZTF
 Q
 ;
BREAK(X) ;Enable/Disable Control-C.  1 = Enable, 0 = Disable ;***
 X "B $S(X:1,1:0)" Q X
CRC(X,Y) ;
 N % X "S %=$ZCRC(X,6,+$G(Y))" Q %   ;****** MSM VERSION 4.1
DIR(X) ; return proper directory
 ; input: 0 = common user directory (default)
 ;        1 = application exe directory
 S X=+$G(X),X=$S('X:$G(^%ZOSF("DIR_USER")),X=1:$G(^%ZOSF("DIR_APPL")),1:"")
 Q (X_$S($L(X)&($E(X,$L(X))'="\"):"\",1:""))
DIRCHK(X)       ; validate directory - return 1 if it exists, else 0
 Q '$$TERMINAL^%HOSTCMD("cd "_X_">nul")
DIRE ; external call to DIR function in DVX, this tag is a placeholder
 Q
DNCASE(X) ;
 Q $TR(X,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
DUP(X,N) ;
 N % S $P(%,X,N+$L(X)-1/$L(X))=X Q $E(%,1,N)
EDIT(S,N) ;Edit a string based on the value of N
 N % I N\256#2 D  Q S
 .F %=1:2:$L(S,"""") D  I %+1=$L(S,"""") S %=%+1 D
 ..S $P(S,"""",%)=$$EDIT($P(S,"""",%),N-256)
 I N\2#2 S S=$TR(S,$C(9,32))
 I N\4#2 S S=$TR(S,$C(0,10,12,13,127))
 I N\8#2 F  Q:$C(9,32)'[$E(S)  Q:S=""  S S=$E(S,2,999)
 I N\16#2 S S=$TR(S,$C(9)," ") F %=0:0 S %=$F(S," ",%) Q:'%  I $E(S,%)=" " S S=$E(S,1,%-1)_$E(S,%+1,999),%=%-1
 I N\32#2 S S=$$UPCASE(S)
 I N\64#2 S S=$TR(S,"[]","()")
 I N\128#2 F %=$L(S):-1:1 Q:$C(9,32)'[$E(S,%)  S S=$E(S,1,%-1)
 I N#2 F %=1:1:$L(S) S S=$E(S,1,%-1)_$C($A(S,%)#128)_$E(S,%+1,999)
 Q S
EOFF(X) ;Turn off echo on device X
 X "S:$G(X)="""" X=$I U X:(::::1)" Q ""  ;***
EON(X) ;Turn on echo on device X
 X "S:$G(X)="""" X=$I U X:(:::::1)" Q ""   ;***
ESCAPE(X) ;Enable or disable escape sequence processing
 S X=+$G(X) X "U:X $I:(::::8388608) U:'X $I:(:::::8388608)" Q ""  ;***
ET ; log error in error trap
 G INT^%ZET
ETYPE(X) ;check for certain error conditions
 ;  input:  X  =  "C" checks for ^C error
 ;             =  "A" checks for memory allocation error
 ;  output: TRUE if specified error accured, FALSE otherwise
 N % S X=$G(X),%=0
 I X="C",$ZE["INRPT" S %=1
 I X="A",$ZE["PGMOV" S %=1
 Q %
FDEL(NAME) ;delete spool file from current directory
 N X
 S:$L(NAME) X=$$JOBWAIT^%HOSTCMD("delete "_NAME)  ; Delete file
 Q
FOLLOWS(X,Y) ;Returns truth value 'X follows Y', whether string or numeric
 Q $S(+X=X&(+Y=Y):X>Y,1:X]Y)
MAX(X,Y) ;Returns the maximum of X and Y, or of all values in array .X
 I $D(Y) Q $S(X>Y:X,1:Y)
 N %,%0 S %="X",%0=$G(X) F  S %=$Q(@%) Q:%=""  I @%>%0 S %0=@%
 Q %0
MIN(X,Y) ;Returns the minimum of X and Y, or of all values in array .X
 I $D(Y) Q $S(X<Y:X,1:Y)
 N %,%0 S %="X",%0=$G(X) F  S %=$Q(@%) Q:%=""  I @%<%0 S %0=@%
 Q %0
NODENAME(E) ;Returns the current node name
 Q $$DDPNODES^%MSMOPS(0)  ;***
OS() ;Return the current M Version
 Q $ZV
 ;
POWER(B,E) ;Returns B raised to E
 Q B**E  ;MDC type A extention 
 ;
PRG() ;Return 1 if in program mode, 0 if not.
 Q $$PRG^%SAICOPS()
 ;
PRIINQ(J) ;Return base priority of job X
 Q $$PRIINQ^%SAICOPS(J)  ;Q $V(20,$J,2)
 ;
READ(FLAG,LEN,PROMPT,DEFAULT,TERM,FUNC,X,Y) ; general reader utility
 G READ^%ZTF1
RMARGIN(X,I) ;Set the right margin of device I to X, return current setting.
 S X=+$G(X),I=$G(I,$I)
 Q $$RMARGIN^%SAICOPS(X,I)
ROUSIZE(X) ;Returns the size of a routine X's executable code
 Q $$ROUSIZE^%SAICOPS(X)
ROUTEST(X) ;Returns true if routine X exists in current UCI
 Q:'$L($G(X)) 0 Q ''$D(^$R(X))
SETPRI(X,J) ;Set job J (defaults to our job) to priority X ;***
 Q:'$G(X) "" D:X>4 HIGH^%HL D:X<5 LOW^%HL
 Q ""
SETPRIN(JOB) ;Resets the $Principal to the bit-bucket
 D SETPRIN^%SAICOPS(JOB,46)
 Q
SETXY(X,Y,C) ;Set $X=X, $Y=Y.  Unless C is present and true, move cursor.
 I '$G(C) I (X<0)!(X>80)!(Y<0)!(Y>24) Q ""  ;sir 7661
 W:'$G(C) /CUP(Y+1,X+1) S $X=X,$Y=Y Q ""
SQRT(X) ;Return the square-root of X.  Returns zero for an illegal X.
 N %X,%RES S %X=X D ^%SQRT
 Q %RES
TYPAHEAD(X) ;Enable or disable type-ahead on the current device. ;***
 ;X=1 Enable, X=0 Disable
 X "U:X=1 $I:(::::67108864:33554432) U:X=0 $I:(::::33554432:67108864)"
 Q ""
UCI(X) ;Returns UCI, Volume if X is true
 Q $P($ZU(0),",",1,1+$G(X))  ;***
UCICHECK(W) ;Returns true if the specified UCI [,volume set] is valid ;***
 S $ZT="UCICHK1" N V
 S:W?1.2N!(W?1.2N1","1.2N) W=$ZU(+W,$S(W[",":$P(W,",",2),1:$P($ZU(0),",",2)))
 I W'?3U,W'?3U1","3U Q 0
 S V=$S(W[",":$P(W,",",2),1:$P($ZU(0),",",2)),V=$ZU($P(W,","),V)
 Q ''V
UCICHK1 Q 0
 ;
UPCASE(X) ;Convert all lowercase letters in X to uppercase
 Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 ;
XORB(X) ;Return the exclusive-or of all the bytes in X.  (Returned as a number, not a single byte.)
 N % X "S %=$ZCRC(X,0)" Q %
YN(YN,S) ;Return True for yes, false for no.  YN=1 for yes default, 0=no
 ;If '^' is entered, it will be returned as the result.
 ;If the read times-out DTOUT will be set to 1.
 ;S is a flag used by the window processor
 N %,%X S S=$G(S) I S N BS S $P(BS,$C(8),80)=$C(8)
YN1 W "? "_$S(YN:"Yes",1:"No")_"// " S %X=$X
 R %#5:$S($D(DTIME):DTIME,1:300) S:%="" %=$E("YN",'YN+1) E  S DTOUT=1 Q 0
 S %=$E(%),%=$S("Yy"[%:1,"Nn"[%:0,%="^":%,1:"?")
 I %="?" D  G YN1
 .W:'S ! W " Answer 'Y', 'N', or '^' to quit" Q:'S
 .W $E(BS,1,$X-%X+7+YN)
 W:%?1N $E($C(8,8,8,8,8),1,$X-%X)_$P("No   ^Yes  ","^",%+1)
 Q %
ZE(C) ;Return the last error code
 ; If C is TRUE, add on explanation
 N EC S EC="" I $G(C) S EC=$TR($P($ZE,":",4,5),":") S:EC EC=$P($T(@EC^%ERRCODE),";",2)
 Q $ZE_EC
ZH() ; return DSM $ZH or OS equivilent
 N H S H=$H,H=$E(H,3,5)*86400+$P(H,",",2)
 Q $TR($$ZH^%SAICOPS,"^",",")_","_H
ERR Q $ZE  ;ERROR RETURN
ERRNL Q ""  ;RETURN NULL STRING ON ERROR
ERR0 Q 0  ;RETURN 0 ON ERROR
 Q
