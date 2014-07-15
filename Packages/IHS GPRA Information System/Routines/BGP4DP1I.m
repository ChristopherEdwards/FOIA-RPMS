BGP4DP1I ; IHS/CMI/LAB - print ind 1 ;
 ;;14.0;IHS CLINICAL REPORTING;;NOV 14, 2013;Build 101
 ;
SNDPG ;EP
 S BGPYSTP=0
 I '$G(BGPSUMON),BGPPTYPE="P" D HEADER^BGP4DPH Q:BGPQUIT  D W^BGP4DP(^BGPINDJ(BGPIC,53,1,0),0,1,BGPPTYPE) D:$D(^BGPINDJ(BGPIC,53,2,0)) W^BGP4DP(^BGPINDJ(BGPIC,53,2,0),0,1,BGPPTYPE) D AH^BGP4DP1H
 I BGPPTYPE'="P" D W^BGP4DP("",0,2,BGPPTYPE) D AH
 D W^BGP4DP("CURRENT REPORT PERIOD",0,1,BGPPTYPE)
 D W^BGP4DP(BGPHD2,0,1,BGPPTYPE)
 S T=28 F X=9:1:13 S V=$P(BGPDAC(X),U) D W^BGP4DP($S(BGPPTYPE="P":$$C(V,0,6),1:$S(V:V,1:0)),0,0,BGPPTYPE,X+1,T) S T=T+9
 I BGPPTYPE="P" D W^BGP4DP("# w/HIV screening-No",0,2,BGPPTYPE)
 D W^BGP4DP($S(BGPPTYPE="P":" Refusals (GPRA Dev.)",1:"# w/HIV screening-No Refusals (GPRA Dev.)"),0,$S(BGPPTYPE="P":1,1:2),BGPPTYPE,1,1)
 S T=28 F X=9:1:13 S V=$P(BGPDAC(X),U,2) D W^BGP4DP($S(BGPPTYPE="P":$$C(V,0,6),1:$S(V:V,1:0)),0,0,BGPPTYPE,X+1,T) S T=T+9
 I BGPPTYPE="P" D W^BGP4DP("% w/HIV screening-No",0,1,BGPPTYPE)
 D W^BGP4DP($S(BGPPTYPE="P":" Refusals (GPRA Dev.)",1:"% w/HIV screening-No Refusals (GPRA Dev.)"),0,$S(BGPPTYPE="P":1,1:1),BGPPTYPE,1,1)
 S T=28 F X=9:1:13 S V=$P(BGPDAC(X),U,3) D W^BGP4DP($S(BGPPTYPE="P":$J(V,6,1),1:$$SB($J(V,6,1))),0,0,BGPPTYPE,X+1,T) S T=T+9
 I BGPPTYPE="D" D W^BGP4DP("A. # w/ positive result w/ % of Total Screened",0,2,BGPPTYPE)
 I BGPPTYPE="P" D W^BGP4DP("A. # w/ positive result w/",0,2,BGPPTYPE),W^BGP4DP(" % of Total Screened",0,1,BGPPTYPE)
 S T=28 F X=9:1:13 S V=$P(BGPDAC(X),U,4) D W^BGP4DP($S(BGPPTYPE="P":$$C(V,0,6),1:$S(V:V,1:0)),0,0,BGPPTYPE,X+1,T) S T=T+9
 I BGPPTYPE="D" D W^BGP4DP("A. % # w/positive result w/ % of Total Screened",0,1,BGPPTYPE)
 I BGPPTYPE="P" D W^BGP4DP("A. % # w/positive result w/",0,1,BGPPTYPE),W^BGP4DP(" % of Total Screened",0,1,BGPPTYPE)
 S T=28 F X=9:1:13 S V=$P(BGPDAC(X),U,5) D W^BGP4DP($S(BGPPTYPE="P":$J(V,6,1),1:$$SB($J(V,6,1))),0,0,BGPPTYPE,X+1,T) S T=T+9
 I BGPPTYPE="D" D W^BGP4DP("B. # w/ negative result w/ % of Total Screened",0,2,BGPPTYPE)
 I BGPPTYPE="P" D W^BGP4DP("B. # w/ negative result w/",0,2,BGPPTYPE),W^BGP4DP(" % of Total Screened",0,1,BGPPTYPE)
 S T=28 F X=9:1:13 S V=$P(BGPDAC(X),U,6) D W^BGP4DP($S(BGPPTYPE="P":$$C(V,0,6),1:$S(V:V,1:0)),0,0,BGPPTYPE,X+1,T) S T=T+9
 I BGPPTYPE="D" D W^BGP4DP("B. % # w/ negative result w/ % of Total Screened",0,1,BGPPTYPE)
 I BGPPTYPE="P" D W^BGP4DP("B. % # w/ negative result w/",0,1,BGPPTYPE),W^BGP4DP(" % of Total Screened",0,1,BGPPTYPE)
 S T=28 F X=9:1:13 S V=$P(BGPDAC(X),U,7) D W^BGP4DP($S(BGPPTYPE="P":$J(V,6,1),1:$$SB($J(V,6,1))),0,0,BGPPTYPE,X+1,T) S T=T+9
 I BGPPTYPE="D" D W^BGP4DP("C. # w/ No result w/ % of Total Screened",0,2,BGPPTYPE)
 I BGPPTYPE="P" D W^BGP4DP("C. # w/ No result w/",0,2,BGPPTYPE),W^BGP4DP(" % of Total Screened",0,1,BGPPTYPE)
 S T=28 F X=9:1:13 S V=$P(BGPDAC(X),U,8) D W^BGP4DP($S(BGPPTYPE="P":$$C(V,0,6),1:$S(V:V,1:0)),0,0,BGPPTYPE,X+1,T) S T=T+9
 I BGPPTYPE="D" D W^BGP4DP("C. % # w/ No result w/ % of Total Screened",0,1,BGPPTYPE)
 I BGPPTYPE="P" D W^BGP4DP("C. % # w/ No result w/",0,1,BGPPTYPE),W^BGP4DP(" % of Total Screened",0,1,BGPPTYPE)
 S T=28 F X=9:1:13 S V=$P(BGPDAC(X),U,9) D W^BGP4DP($S(BGPPTYPE="P":$J(V,6,1),1:$$SB($J(V,6,1))),0,0,BGPPTYPE,X+1,T) S T=T+9
 I BGPPTYPE="P" D W^BGP4DP("# w/HIV screening",0,2,BGPPTYPE)
 D W^BGP4DP($S(BGPPTYPE="P":" Refusal",1:"# w/HIV screening Refusal"),0,$S(BGPPTYPE="P":1,1:2),BGPPTYPE,1,1)
 S T=28 F X=9:1:13 S V=$P(BGPDAC(X),U,10) D W^BGP4DP($S(BGPPTYPE="P":$$C(V,0,6),1:$S(V:V,1:0)),0,0,BGPPTYPE,X+1,T) S T=T+9
 I BGPPTYPE="P" D W^BGP4DP("% w/HIV screening",0,1,BGPPTYPE)
 D W^BGP4DP($S(BGPPTYPE="P":" Refusal",1:"% w/HIV screening Refusal"),0,$S(BGPPTYPE="P":1,1:1),BGPPTYPE,1,1)
 S T=28 F X=9:1:13 S V=$P(BGPDAC(X),U,11) D W^BGP4DP($S(BGPPTYPE="P":$J(V,6,1),1:$$SB($J(V,6,1))),0,0,BGPPTYPE,X+1,T) S T=T+9
 S BGPYSTP=1
 Q
PR ;EP
 I '$G(BGPSUMON),BGPPTYPE="P" D HEADER^BGP4DPH Q:BGPQUIT  D W^BGP4DP(^BGPINDJ(BGPIC,53,1,0),0,1,BGPPTYPE) D:$D(^BGPINDJ(BGPIC,53,2,0)) W^BGP4DP(^BGPINDJ(BGPIC,53,2,0),0,1,BGPPTYPE) D AH^BGP4DP1H
 D W^BGP4DP("PREVIOUS REPORT PERIOD",0,$S(BGPPTYPE="P":1,1:2),BGPPTYPE)
 D W^BGP4DP(BGPHD2,0,1,BGPPTYPE)
 S T=28 F X=9:1:13 S V=$P(BGPDAP(X),U) D W^BGP4DP($S(BGPPTYPE="P":$$C(V,0,6),1:$S(V:V,1:0)),0,0,BGPPTYPE,X+1,T) S T=T+9
 I BGPPTYPE="P" D W^BGP4DP("# w/HIV screening-No",0,2,BGPPTYPE)
 D W^BGP4DP($S(BGPPTYPE="P":" Refusals (GPRA Dev.)",1:"# w/HIV screening-No Refusals (GPRA Dev.)"),0,$S(BGPPTYPE="P":1,1:2),BGPPTYPE,1,1)
 S T=28 F X=9:1:13 S V=$P(BGPDAP(X),U,2) D W^BGP4DP($S(BGPPTYPE="P":$$C(V,0,6),1:$S(V:V,1:0)),0,0,BGPPTYPE,X+1,T) S T=T+9
 I BGPPTYPE="P" D W^BGP4DP("% w/HIV screening-No",0,1,BGPPTYPE)
 D W^BGP4DP($S(BGPPTYPE="P":" Refusals (GPRA Dev.)",1:"% w/HIV screening-No Refusals (GPRA Dev.)"),0,$S(BGPPTYPE="P":1,1:1),BGPPTYPE,1,1)
 S T=28 F X=9:1:13 S V=$P(BGPDAP(X),U,3) D W^BGP4DP($S(BGPPTYPE="P":$J(V,6,1),1:$$SB($J(V,6,1))),0,0,BGPPTYPE,X+1,T) S T=T+9
 I BGPPTYPE="D" D W^BGP4DP("A. # w/ positive result w/ % of Total Screened",0,2,BGPPTYPE)
 I BGPPTYPE="P" D W^BGP4DP("A. # w/ positive result w/",0,2,BGPPTYPE),W^BGP4DP(" % of Total Screened",0,1,BGPPTYPE)
 S T=28 F X=9:1:13 S V=$P(BGPDAP(X),U,4) D W^BGP4DP($S(BGPPTYPE="P":$$C(V,0,6),1:$S(V:V,1:0)),0,0,BGPPTYPE,X+1,T) S T=T+9
 I BGPPTYPE="D" D W^BGP4DP("A. % # w/positive result w/ % of Total Screened",0,1,BGPPTYPE)
 I BGPPTYPE="P" D W^BGP4DP("A. % # w/positive result w/",0,1,BGPPTYPE),W^BGP4DP(" % of Total Screened",0,1,BGPPTYPE)
 S T=28 F X=9:1:13 S V=$P(BGPDAP(X),U,5) D W^BGP4DP($S(BGPPTYPE="P":$J(V,6,1),1:$$SB($J(V,6,1))),0,0,BGPPTYPE,X+1,T) S T=T+9
 I BGPPTYPE="D" D W^BGP4DP("B. # w/ negative result w/ % of Total Screened",0,2,BGPPTYPE)
 I BGPPTYPE="P" D W^BGP4DP("B. # w/ negative result w/",0,2,BGPPTYPE),W^BGP4DP(" % of Total Screened",0,1,BGPPTYPE)
 S T=28 F X=9:1:13 S V=$P(BGPDAP(X),U,6) D W^BGP4DP($S(BGPPTYPE="P":$$C(V,0,6),1:$S(V:V,1:0)),0,0,BGPPTYPE,X+1,T) S T=T+9
 I BGPPTYPE="D" D W^BGP4DP("B. % # w/ negative result w/ % of Total Screened",0,1,BGPPTYPE)
 I BGPPTYPE="P" D W^BGP4DP("B. % # w/ negative result w/",0,1,BGPPTYPE),W^BGP4DP(" % of Total Screened",0,1,BGPPTYPE)
 S T=28 F X=9:1:13 S V=$P(BGPDAP(X),U,7) D W^BGP4DP($S(BGPPTYPE="P":$J(V,6,1),1:$$SB($J(V,6,1))),0,0,BGPPTYPE,X+1,T) S T=T+9
 I BGPPTYPE="D" D W^BGP4DP("C. # w/ No result w/ % of Total Screened",0,2,BGPPTYPE)
 I BGPPTYPE="P" D W^BGP4DP("C. # w/ No result w/",0,2,BGPPTYPE),W^BGP4DP(" % of Total Screened",0,1,BGPPTYPE)
 S T=28 F X=9:1:13 S V=$P(BGPDAP(X),U,8) D W^BGP4DP($S(BGPPTYPE="P":$$C(V,0,6),1:$S(V:V,1:0)),0,0,BGPPTYPE,X+1,T) S T=T+9
 I BGPPTYPE="D" D W^BGP4DP("C. % # w/ No result w/ % of Total Screened",0,1,BGPPTYPE)
 I BGPPTYPE="P" D W^BGP4DP("C. % # w/ No result w/",0,1,BGPPTYPE),W^BGP4DP(" % of Total Screened",0,1,BGPPTYPE)
 S T=28 F X=9:1:13 S V=$P(BGPDAP(X),U,9) D W^BGP4DP($S(BGPPTYPE="P":$J(V,6,1),1:$$SB($J(V,6,1))),0,0,BGPPTYPE,X+1,T) S T=T+9
 I BGPPTYPE="P" D W^BGP4DP("# w/HIV screening",0,2,BGPPTYPE)
 D W^BGP4DP($S(BGPPTYPE="P":" Refusal",1:"# w/HIV screening Refusal"),0,$S(BGPPTYPE="P":1,1:2),BGPPTYPE,1,1)
 S T=28 F X=9:1:13 S V=$P(BGPDAP(X),U,10) D W^BGP4DP($S(BGPPTYPE="P":$$C(V,0,6),1:$S(V:V,1:0)),0,0,BGPPTYPE,X+1,T) S T=T+9
 I BGPPTYPE="P" D W^BGP4DP("% w/HIV screening",0,1,BGPPTYPE)
 D W^BGP4DP($S(BGPPTYPE="P":" Refusal",1:"% w/HIV screening Refusal"),0,$S(BGPPTYPE="P":1,1:1),BGPPTYPE,1,1)
 S T=28 F X=9:1:13 S V=$P(BGPDAP(X),U,11) D W^BGP4DP($S(BGPPTYPE="P":$J(V,6,1),1:$$SB($J(V,6,1))),0,0,BGPPTYPE,X+1,T) S T=T+9
 ;percentage changes
 D W^BGP4DP("CHANGE FROM PREVIOUS YR %",0,2,BGPPTYPE)
 I BGPPTYPE="P" D W^BGP4DP("# w/HIV screening-No",0,2,BGPPTYPE)
 D W^BGP4DP($S(BGPPTYPE="P":" Refusals (GPRA Dev.)",1:"# w/HIV screening-No Refusals (GPRA Dev.)"),0,$S(BGPPTYPE="P":1,1:2),BGPPTYPE,1,1)
 S T=28 F X=9:1:13 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAP(X),U,3) S:N="" N=0 S:O="" O=0 S Y=$S(BGPPTYPE="P":$J($FN((N-O),"+,",1),6),1:$$SB($J((N-O),6,1))) D W^BGP4DP(Y,0,0,BGPPTYPE,X+1,T) S T=T+9
 I BGPPTYPE="D" D W^BGP4DP("A. # w/ positive result w/ % of Total Screened",0,1,BGPPTYPE)
 I BGPPTYPE="P" D W^BGP4DP("A. # w/ positive result w/",0,1,BGPPTYPE),W^BGP4DP(" % of Total Screened",0,1,BGPPTYPE)
 S T=28 F X=9:1:13 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAP(X),U,5) S:N="" N=0 S:O="" O=0 S Y=$S(BGPPTYPE="P":$J($FN((N-O),"+,",1),6),1:$$SB($J((N-O),6,1))) D W^BGP4DP(Y,0,0,BGPPTYPE,X+1,T) S T=T+9
 I BGPPTYPE="D" D W^BGP4DP("B. # w/ negative result w/ % of Total Screened",0,1,BGPPTYPE)
 I BGPPTYPE="P" D W^BGP4DP("B. # w/ negative result w/",0,1,BGPPTYPE),W^BGP4DP(" % of Total Screened",0,1,BGPPTYPE)
 S T=28 F X=9:1:13 S N=$P(BGPDAC(X),U,7),O=$P(BGPDAP(X),U,7) S:N="" N=0 S:O="" O=0 S Y=$S(BGPPTYPE="P":$J($FN((N-O),"+,",1),6),1:$$SB($J((N-O),6,1))) D W^BGP4DP(Y,0,0,BGPPTYPE,X+1,T) S T=T+9
 I BGPPTYPE="D" D W^BGP4DP("C. # w/ No result w/ % of Total Screened",0,1,BGPPTYPE)
 I BGPPTYPE="P" D W^BGP4DP("C. # w/ No result w/",0,1,BGPPTYPE),W^BGP4DP(" % of Total Screened",0,1,BGPPTYPE)
 S T=28 F X=9:1:13 S N=$P(BGPDAC(X),U,9),O=$P(BGPDAP(X),U,9) S:N="" N=0 S:O="" O=0 S Y=$S(BGPPTYPE="P":$J($FN((N-O),"+,",1),6),1:$$SB($J((N-O),6,1))) D W^BGP4DP(Y,0,0,BGPPTYPE,X+1,T) S T=T+9
 I BGPPTYPE="P" D W^BGP4DP("% w/HIV screening",0,1,BGPPTYPE)
 D W^BGP4DP($S(BGPPTYPE="P":" Refusal",1:"% w/HIV screening Refusal"),0,$S(BGPPTYPE="P":1,1:1),BGPPTYPE,1,1)
 S T=28 F X=9:1:13 S N=$P(BGPDAC(X),U,11),O=$P(BGPDAP(X),U,11) S:N="" N=0 S:O="" O=0 S Y=$S(BGPPTYPE="P":$J($FN((N-O),"+,",1),6),1:$$SB($J((N-O),6,1))) D W^BGP4DP(Y,0,0,BGPPTYPE,X+1,T) S T=T+9
 Q
BL ;EP
 D BL^BGP4DP1K
 Q
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
SB(X) ;EP - Strip leading and trailing blanks from X.
 X ^DD("FUNC",$O(^DD("FUNC","B","STRIPBLANKS",0)),1)
 Q X
AH ;EP
 Q:$G(BGPSUMON)
 D W^BGP4DP(BGPHD1,1,2,BGPPTYPE)
 D W^BGP4DP("Age Specific HIV Screening",0,1,BGPPTYPE)
 I BGPPTYPE="P",BGPYSTP=0 G G2
 D W^BGP4DP("<13",0,1,BGPPTYPE,2,25)
 D W^BGP4DP("13-14",0,0,BGPPTYPE,3,30)
 D W^BGP4DP("15-19",0,0,BGPPTYPE,4,37)
 D W^BGP4DP("20-24",0,0,BGPPTYPE,5,44)
 D W^BGP4DP("25-29",0,0,BGPPTYPE,6,51)
 D W^BGP4DP("30-34",0,0,BGPPTYPE,7,58)
 D W^BGP4DP("35-39",0,0,BGPPTYPE,8,65)
 D W^BGP4DP("40-44",0,0,BGPPTYPE,9,72)
 I BGPPTYPE="P",BGPYSTP=1 Q
G2 ;
 D W^BGP4DP("45-49",0,$S(BGPPTYPE="P":1,1:0),BGPPTYPE,10,28)
 D W^BGP4DP("50-54",0,0,BGPPTYPE,11,37)
 D W^BGP4DP("55-59",0,0,BGPPTYPE,12,46)
 D W^BGP4DP("60-64",0,0,BGPPTYPE,13,55)
 D W^BGP4DP(">65",0,0,BGPPTYPE,14,65)
 Q
