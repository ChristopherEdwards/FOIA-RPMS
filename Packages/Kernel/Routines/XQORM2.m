XQORM2 ; SLC/KCM - Lookup for Menu Utility ;11/18/92  15:23 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1001,1002,1003,1004,1005,1007**;APR 1, 2003
 ;;8.0;KERNEL;**56,62**;Jul 10, 1995
EN ;From: XQORM  Entry: X,XQORM  Exit: X,Y,XQORM
 N K K Y,OROTHER I X=" " D  Q:'$L(X)
 . I $D(^DISV(DUZ,"XQORM",XQORM,"ALT")),$D(XQORM("ALT")) D  S X="" Q
 . . N XQORMERR,XQORMSAV,XQORMRCL
 . . S (X,XQORMSAV)=^DISV(DUZ,"XQORM",XQORM,"ALT"),XQORMRCL=""
 . . X XQORM("ALT") S Y=0
 . . I $D(XQORMERR) S Y=-1 I XQORM(0)["A" W "??" W:XQORM(0)["\" !
 . S XQORM(0)=XQORM(0)_"X" D LAST^XQORM4
 . I '$L(X) S Y=-1 W:XQORM(0)["A" "??" W:XQORM(0)["A"&(XQORM(0)["\") !
 D UP^XQORM1 K ORUX S ORUX=X,(ORUT,ORUER,Y)=0,XQORMSF=""
 F J=1:1:$L(ORUX,",") S X=$P(ORUX,",",J) D EAT,SET D:X["-" RNG^XQORM3 Q:ORUER  F K=1:1:$L(X,",") I $L($P(X,",",K)) S ORUT=ORUT+1,ORUX(ORUT)=$P(X,",",K) S:$L(ORUFG) ORUX(ORUT,"=")=ORUFG S:ORUSB ORUX(ORUT,"'")=""
 I 'ORUER S (ORUSQ,ORUT)=0 F I=0:0 S ORUT=$O(ORUX(ORUT)) Q:ORUT=""  S X=ORUX(ORUT) D SPCL I $L(X) D LOOK^XQORM3,CHAL Q:ORUER
 I 'ORUER,+XQORM(0),+Y>XQORM(0) D:XQORM(0)["A" NE^XQORM4 S ORUER=1,Y=-1
 I 'ORUER S ORUB=0 F I=0:0 S ORUB=$O(Y(ORUB)) Q:ORUB'>0  D SCRN I 'ORUFG D:ORUX["ALL" SUB I ORUX'["ALL" D:XQORM(0)["A" NS^XQORM4 S ORUER=1
 I 'ORUER,Y>0 W:XQORM(0)["A" "   " S ORUFG=$S($X>(IOM-30):9,1:$X) K:XQORM(0)'["F" ^DISV(DUZ,"XQORM",XQORM) F I=0:0 S I=$O(Y(I)) Q:I'>0  D:XQORM(0)["A" ECHO D:XQORM(0)'["F" DISV
 S X=ORUX I ORUER K Y S Y=-1 I $D(XQORM("ALT")) D
 . N XQORMERR,XQORMSAV S XQORMSAV=X X XQORM("ALT")
 . S Y=0 I $D(XQORMERR) S Y=-1 D:XQORM(0)["A" UR^XQORM4
 . I '$D(XQORMERR),(XQORM(0)'["F") D
 . . K ^DISV(DUZ,"XQORM",XQORM)
 . . S ^DISV(DUZ,"XQORM",XQORM,"ALT")=XQORMSAV
KILL K ORUX,ORUFG,ORUSB,ORUT,ORUER,ORUFD,ORUB,ORUDA,ORUW,ORUSQ,XQORMSF,J,Y("B"),Y("#") Q
SCRN S ORUFG=1 I $D(XQORM("S"))'[0,$L(XQORM("S")) N DA S DA(1)=+XQORM,DA=+Y(ORUB) I DA N Y X XQORM("S") S ORUFG=$T
 Q
SET S ORUSB=0 I $E(X)="-",$L(X)>1 S ORUSB=1,X=$P(X,"-",2,99)
 S ORUFG="" I $E(X)'="=" S ORUFG=$P(X,"=",2,99),X=$P(X,"=",1)
 Q
SPCL S:'$D(XQORSPEW) XQORSPEW=0 I $E(X)="*" S XQORSPEW=$S(XQORSPEW:0,1:1),X=$E(X,2,255) W $S(XQORSPEW:" -RAPID MODE-",1:" -NORMAL MODE-")
 ;I $D(XQORM("KEY",$P(X," "))) S ORUX(ORUT,"=")=$P(X," ",2,99)_"="_$G(ORUX(ORUT,"=")),X="^^`"_XQORM("KEY",$P(X," "))
 I '$D(XQORM("NO^^")),$E(X,1,2)="^^" S Y=Y+1,ORUSQ=ORUSQ+1,Y(ORUSQ)="^"_X,X="" S:$D(ORUX(ORUT,"=")) $P(Y(ORUSQ),"=",2)=ORUX(ORUT,"=") Q
 I XQORM(0)["+","+-"[X S Y=Y+1,ORUSQ=ORUSQ+1,Y(ORUSQ)=X,X="" Q
 I $E(X)=";" D SC^XQORM4 S X="",ORUER=1 Q
 S X=$P(X,";",1) D EAT
 Q
CHAL ; Q:ORUER  I ORUDA,'$D(ORUDA("KEY")),'$D(XQORM("#")) D UPD^XQORM3 Q
 Q:ORUER  I ORUDA?1.N1"."1.N D UPD^XQORM3 Q
 I $D(XQORM("KEY",$P(ORUDA," "))) D  Q
 . S Y=Y+1,ORUSQ=ORUSQ+1,Y(ORUSQ)="^^"_ORUDA_"^`"_+XQORM("KEY",$P(ORUDA," "))_"="_$P(ORUDA," ",2,99)_"="_$G(ORUX(ORUT,"="))
 . I $P(XQORM("KEY",$P(ORUDA," ")),"^",2) S $P(Y(ORUSQ),"^",2)=+XQORM("KEY",$P(ORUDA," "))
 . K ORUDA("KEY")
 . Q
 I $D(XQORM("#")),ORUDA?1.N,ORUDA D  Q
 . I '$D(Y("#")) S Y=Y+1,ORUSQ=ORUSQ+1,Y(ORUSQ)="^"_+XQORM("#")_"^^=",Y("#")=ORUSQ
 . S Y(Y("#"))=Y(Y("#"))_ORUDA_","
 . Q
 I ORUDA="ALL" S X="ALL",ORUER=0 D ALL^XQORM4 Q
 Q
EAT F I=0:0 Q:$E(X)]" "  Q:'$L(X)  S X=$E(X,2,999)
 F I=0:0 Q:$E(X,$L(X))]" "  Q:'$L(X)  S X=$E(X,1,$L(X)-1)
 Q
ECHO W:($X+$L($P(Y(I),"^",3))+4)>IOM !,?ORUFG W $P(Y(I),"^",3),"  " Q
DISV I +Y(I) S ^DISV(DUZ,"XQORM",XQORM,I)=$P(Y(I),"^",3) Q
 I XQORM(0)["R",$L($P(Y(I),"^",3)) S ^DISV(DUZ,"XQORM",XQORM,I)=$P(Y(I),"^",3) Q
 I XQORM(0)["r",'$L($P(Y(I),"^",3)) S ^DISV(DUZ,"XQORM",XQORM,I)="^^"_$P(Y(I),"^",4)
 Q
SUB K Y(ORUB) S Y=Y-1 Q