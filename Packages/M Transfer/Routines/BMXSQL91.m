BMXSQL91 ; IHS/OIT/HMW - BMX REMOTE PROCEDURE CALLS ;
 ;;4.0;BMX;;JUN 28, 2010
 ;
 ;Below is dead code, but keep for later
SETX2 ;Don't need this unless porting to machine with
 ;local variable size limitations
 N F,LVL,ROOT,START
 S LVL=1,START=1
 S ROOT="BMXY"
 F F=1:1:BMXFF D  Q:$D(BMXERR)
 . S BMX=BMXFF(F)
 . I BMX="(" D  Q  ;Increment level
 . . S LVL=LVL+1
 . . ;S ROOT=$S(ROOT["(":$P(ROOT,")")_","_0_")",1:ROOT_"("_0_")")
 . . ;Get operator following close paren corresponding to this open
 . . ;If op = OR then set up FOR loop in zeroeth node
 . . ;if op = AND then set up
 . I BMX=")" D  Q  ;Decrement level
 . . S LVL=LVL-1
 . . I LVL=1,$D(BMXFF(F+1)),BMXFF(F+1)="&" D  Q
 . . . S BMXX=BMXX+1
 . . . S BMXX(BMXX)=""
 . . . F J=START:1:F S BMXX(BMXX)=BMXX(BMXX)_BMXFF(J)
 . . . S START=F+2
 . . . ;S BMXX(BMXX)="I "_BMXX(BMXX)_" X BMXX("_BMXX+1_")"
 . ; I BMX="AND" D  Q  ;Chain to previous expression at current level
 . ; I BMX="OR" D  Q  ;Create FOR-loop to execute screens
 ;
 Q
 ;
 ;
 ;S F=0 F  S F=$O(BMXMFL(F)) Q:'+F  S:'$D(BMXMFL(F,"SUBFILE")) BMXMFL("NOSUBFILE",F)=""
 ;I $D(BMXMFL("NOSUBFILE")) S F=0 F  S F=$O(BMXMFL("NOSUBFILE",F)) Q:'+F  D MAKEC1
 ;I $D(BMXMFL("SUBFILE")) S F=0 F  S F=$O(BMXMFL("SUBFILE",F)) Q:'+F  D MAKEC1 ;S BMXROOTZ=BMXZ+100
 ;
 Q
MAKEC1 ;
 I '$D(BMXMFL(F,"SUBFILE")),'$D(BMXMFL(F,"MULT")) S BMXZ=BMXZ+100,BMXCFN(BMXCID,BMXZ,F)="" Q
 Q:'$D(BMXMFL(F,"SUBFILE"))
 Q:$D(BMXMFL(F,"MULT"))
 S BMXROOT=F
 S BMXROOTZ=BMXZ+100
 S BMXROOTC=BMXCID
 D MCNT(F)
 Q
 ;
MCNT(F) ;
 N S
 ;B  ;MCNT
 I '$D(BMXMFL(F,"SUBFILE")) D MCNT2 Q
 S S=0 F  S S=$O(BMXMFL(F,"SUBFILE",S)) Q:'+S  S:'$D(BMXCFN(BMXCID,BMXZ,F)) BMXZ=BMXZ+100,BMXCFN(BMXCID,BMXZ,F)="" S BMXZ=BMXZ+100,BMXCFN(BMXCID,BMXZ,S)="",BMXCFNX(S,F)="" D MCNT(S)
 Q
 ;
MCNT2 ;
 ;B  ;Back-chain
 ;TODO: RESTART HERE -- $O(BMXCFN(BMXCID,0)) NEEDS TO BE CHANGED TO SOMETHING BESIDES 0
 N BMXFTOP,BMXFBACK
 F  S BMXFTOP=$O(BMXCFN(BMXROOTC,BMXROOTZ,0)) Q:BMXFTOP=BMXROOT  S BMXFBACK=$O(BMXCFNX(BMXFTOP,0)) S BMXROOTZ=BMXROOTZ-1,BMXCFN(BMXCID,BMXROOTZ,BMXFBACK)=""
 S BMXCID=BMXCID+1,BMXROOTC=BMXCID
 ;Get the root files
 I $D(BMXMFL("NOSUBFILE")) D
 . N F
 . S F=0 F  S F=$O(BMXMFL("NOSUBFILE",F)) Q:'+F  D
 . . Q:$D(BMXMFL(F,"MULT"))
 . . Q:F=BMXROOT
 . . S BMXZ=BMXZ+100
 . . S BMXCFN(BMXCID,BMXZ,F)=""
 S BMXROOTZ=BMXZ+100
 Q
 ;
 ;
ITER ;Iterate through result array A
 S BMXCNT=BMXFLDO ;Field count
 S F=0
 S:BMXNUM ^BMXTEMP($J,I)=IEN0_"^"
 S BMXCNTB=0
 S BMXORD=BMXNUM
 N BMXONOD
 N BMXINT
 ;B  ;WRITE Before REORG
 N M,N S N=0
 D REORG
 ;B  ;WRITE After REORG
 F  S N=$O(M(N)) Q:'+N  D
 . S O=0
 . F O=1:1:$L(M(N),U) S BMXFLDO(O-1,"IEN0")=$P(M(N),U,O)
 . S BMXORD=BMXNUM
 . D OA
 Q
 ;
REORG N R,IEN,J,CONT,TEST
 F R=0:1:BMXFLDO-1 S IEN(R)=0
 F J=1:1 D  Q:'CONT
 . S CONT=0
 . F R=1:1:BMXFLDO D
 . . S TEST=$O(A(+BMXFLDO(R-1),IEN(R-1)))
 . . I +TEST S IEN(R-1)=TEST,CONT=1
 . . S $P(M(J),U,R)=IEN(R-1)
 . Q
 I M(J)=M(J-1) K M(J)
 Q
 ;
 ;
OA ;
 I $D(A) F R=0:1:(BMXFLDO-1) S F=$P(BMXFLDO(R),U,2),BMXFN=$P(BMXFLDO(R),U),BMXINT=$P(BMXFLDO(R),U,3) D  S:(R+1)<BMXFLDO ^BMXTEMP($J,I)=^BMXTEMP($J,I)_U
 . ;S IEN0=BMXFLDO(R,"IEN0") F  S IEN0=$O(A(BMXFN,IEN0)) Q:'+IEN0  Q:$D(A(BMXFN,IEN0,F,BMXINT))
 . S IEN0=BMXFLDO(R,"IEN0")
 . Q:'+IEN0
 . S BMXORD=BMXORD+1
 . I $D(^DD(BMXFN,F,0)),$P(^DD(BMXFN,F,0),U,2) D  I 1 ;Multiple or WP
 . . ;Get the subfile number into FL1
 . . S FL1=+$P(^DD(BMXFN,F,0),U,2)
 . . S FLD1=$O(^DD(FL1,0))
 . . I $P(^DD(FL1,FLD1,0),U,2)["W" D  ;WP
 . . . S WPL=0,BMXLTMP=0
 . . . F  S WPL=$O(A(BMXFN,IEN0,F,WPL)) Q:'WPL  S I=I+1 D
 . . . . S ^BMXTEMP($J,I)=A(BMXFN,IEN0,F,WPL)_" "
 . . . . S BMXLTMP=BMXLTMP+$L(A(BMXFN,IEN0,F,WPL))+1
 . . . . Q
 . . . S:BMXLTMP>BMXLEN(BMXORD) BMXLEN(BMXORD)=BMXLTMP
 . . . Q
 . . D  ;It's a multiple.  Implement in next phase
 . . . ;S BMXMCT=BMXMCT+1
 . . . ;S BMXMCT(BMXMCT)=BMXFN_U_F
 . . . Q  ;Process A( for multiple field
 . . Q
 . E  D  ;Not a multiple
 . . S I=I+1
 . . I $G(BMXTK("DISTINCT"))="TRUE" D  Q
 . . . Q:A(BMXFN,IEN0,F,BMXINT)=""
 . . . I $D(^BMXTMPD($J,A(BMXFN,IEN0,F,BMXINT))) Q
 . . . S ^BMXTMPD($J,A(BMXFN,IEN0,F,BMXINT))=""
 . . . S ^BMXTEMP($J,I)=A(BMXFN,IEN0,F,BMXINT)
 . . . S:$L(A(BMXFN,IEN0,F,BMXINT))>BMXLEN(BMXORD) BMXLEN(BMXORD)=$L(A(BMXFN,IEN0,F,BMXINT))
 . . . Q
 . . S ^BMXTEMP($J,I)=A(BMXFN,IEN0,F,BMXINT)
 . . S:$L(A(BMXFN,IEN0,F,BMXINT))>BMXLEN(BMXORD) BMXLEN(BMXORD)=$L(A(BMXFN,IEN0,F,BMXINT))
 . Q
 ;---> Set data in result global.
 I $D(^BMXTEMP($J,I)) S ^BMXTEMP($J,I)=^BMXTEMP($J,I)_$C(30)
ZZZ Q
