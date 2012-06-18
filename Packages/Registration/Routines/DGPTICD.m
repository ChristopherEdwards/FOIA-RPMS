DGPTICD ;ALB/MTC - PTF DRG Grouper Utility ; 2/19/02 3:08pm
 ;;5.3;Registration;**375,441**;Aug 13, 1993
 ;variables to pass in:
 ;  DGDX <- format: DX CODE1^DX CODE2^DX CODE3^...                      (REQUIRED)
 ;  DGSURG <- format: SURGERY CODE1^SURGERY CODE2^SURGERY CODE3^...       (OPTIONAL)
 ;  DGPROC <- format: PROCEDURE CODE1^PROCEDURE CODE2^PROCEDURE CODE3^... (OPTIONAL)
 ;  DGTRS  <- 1 if patient transferred to acute care facility             (REQUIRED)
 ;  DGEXP  <- 1 if patient died during this episode                       (REQUIRED)
 ;  DGDMS  <- 1 if patient was discharged with an Irregular discharge (discharged against medical advice) (REQUIRED)
 ;  AGE,SEX     (REQUIRED)
 ;values of variables listed above are left unchanged by this routine
 ;variable passed back: DRG(0) <- zero node of DRG in DRG file
 ;                    : DRG <- IFN of DRG in DRG file
 ;
 ;-- check for required variables
 Q:'$D(DGDX)!'$D(DGTRS)!'$D(DGEXP)!'$D(DGDMS)
 N DGI
 ;-- build ICDDX array
 K ICDDX
 S DGI=0 F  S DGI=DGI+1 Q:$P(DGDX,U,DGI)=""  D
 . I $D(^ICD9(+$P(DGDX,U,DGI),0)) S ICDDX(DGI)=$P(DGDX,U,DGI)
 G Q:'$D(ICDDX)
 ;
 ;-- build ICDPRC array
 ;K ICDPRC
 ;I $D(DGPROC) S DGSURG=$S('$D(DGSURG):DGPROC,1:DGSURG_DGPROC)
 ;I $D(DGSURG) S DGI=0 F  S DGI=DGI+1 Q:$P(DGSURG,U,DGI)=""  D
 ;. I $D(^ICD0($P(DGSURG,U,DGI),0)) S ICDPRC(DGI)=$P(DGSURG,U,DGI)
 ;-- build ICDPRC array eliminating dupes as we go
 K ICDPRC
 N I,J,X,Y,FLG,SUB S SUB=0
 I $D(DGPROC) F I=2:1 S X=$P(DGPROC,U,I) Q:X=""  D
 .I $D(^ICD0(X,0)) S SUB=SUB+1,ICDPRC(SUB)=X
 I $D(DGSURG) F I=2:1 S X=$P(DGSURG,U,I) Q:X=""  D
 .S FLG=0,J=0 F  S J=$O(ICDPRC(J)) Q:'J  I X=$G(ICDPRC(J)) S FLG=1 Q
 .I FLG Q
 .I $D(^ICD0(X,0)) S SUB=SUB+1,ICDPRC(SUB)=X
 ;
 ;-- set other required variables
 S ICDTRS=DGTRS,ICDEXP=DGEXP,ICDDMS=DGDMS
 ;
 ;-- calculate DRG
 D ^ICDDRG S DRG=ICDDRG I '$D(DGDRGPRT) G Q
 ;
PRT ;print DRG and national HCFA values
 I '$D(^ICD(+DRG,0)) W !,"Invalid DRG Error" G Q
 I DRG=468!(DRG=469)!(DRG=470) W *7
 S DRG(0)=^ICD(DRG,0) W !!,"Diagnosis Related Group: ",$J(DRG,6),?36,"Average Length of Stay(ALOS): ",$J($P(DRG(0),"^",8),6)
 W !?17,"Weight: ",$J($P(DRG(0),"^",2),6)  ;,?40,"Local Breakeven: ",$J($P(DRG(0),"^",12),6)
 W !?12," Low Day(s): ",$J($P(DRG(0),"^",3),6)  ;,?39,"Local Low Day(s): ",$J($P(DRG(0),"^",9),6)
 W !?13," High Days: ",$J($P(DRG(0),"^",4),6)  ;,?40,"Local High Days: ",$J($P(DRG(0),"^",10),6)
 W !!,"DRG: ",DRG,"-" F DGI=0:0 S DGI=$O(^ICD(DRG,1,DGI)) Q:DGI'>0  W ?10,$P(^(DGI,0),U,1),!
Q K ICDDMS,ICDDRG,ICDDX,ICDEXP,ICDMDC,ICDPRC,ICDRTC,ICDTRS Q
