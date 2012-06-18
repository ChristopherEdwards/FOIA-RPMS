ACDRR1PB ;IHS/ADC/EDE/KML - BROKE UP ACDRR1P;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
ALCDRUG ;EP-alcohol/drug problem
 D F Q:ACDQ
 W !!,?50,"SEX",?68,"AGE",!
 W "PATIENT COUNT BY ALCOHOL/DRUG PROBLEM",?48,"M",?55,"F",?62,"<13",?67,"13-20",?75,"21+",!!
 ; seen
 D F Q:ACDQ
 F %="M","F" S @%=^TMP("ACDRR1",ACDJOB,ACDBT,"SEEN",%)
 F %=1:1:3 S %(%)=^TMP("ACDRR1",ACDJOB,ACDBT,"SEEN","AGE",%)
 W ?2,$$LJRF^ACD("TOTAL SEEN",28,".")," ",X,?44,$J(M,5),?51,$J(F,5),?60,$J(%(1),5),?67,$J(%(2),5),?73,$J(%(3),5),!
 ; alcohol
 D F Q:ACDQ
 S Y=^TMP("ACDRR1",ACDJOB,ACDBT,"ALCOHOL")
 F %="M","F" S @%=^TMP("ACDRR1",ACDJOB,ACDBT,"ALCOHOL",%)
 F %=1:1:3 S %(%)=^TMP("ACDRR1",ACDJOB,ACDBT,"ALCOHOL","AGE",%)
 W ?2,$$LJRF^ACD("ALCOHOL",28,".")," ",Y I Y W ?37,$J((Y/X*100),3,0),"%",?44,$J(M,5),?51,$J(F,5),?60,$J(%(1),5),?67,$J(%(2),5),?73,$J(%(3),5)
 W !
 ; drugs
 D F Q:ACDQ
 S Y=^TMP("ACDRR1",ACDJOB,ACDBT,"DRUGS")
 F %="M","F" S @%=^TMP("ACDRR1",ACDJOB,ACDBT,"DRUGS",%)
 F %=1:1:3 S %(%)=^TMP("ACDRR1",ACDJOB,ACDBT,"DRUGS","AGE",%)
 W ?2,$$LJRF^ACD("DRUGS",28,".")," ",Y I Y W ?37,$J((Y/X*100),3,0),"%",?44,$J(M,5),?51,$J(F,5),?60,$J(%(1),5),?67,$J(%(2),5),?73,$J(%(3),5)
 W !
 ; alcohol&drugs
 D F Q:ACDQ
 S Y=^TMP("ACDRR1",ACDJOB,ACDBT,"ALCOHOL&DRUGS")
 F %="M","F" S @%=^TMP("ACDRR1",ACDJOB,ACDBT,"ALCOHOL&DRUGS",%)
 F %=1:1:3 S %(%)=^TMP("ACDRR1",ACDJOB,ACDBT,"ALCOHOL&DRUGS","AGE",%)
 W ?2,$$LJRF^ACD("ALCOHOL&DRUGS",28,".")," ",Y I Y W ?37,$J((Y/X*100),3,0),"%",?44,$J(M,5),?51,$J(F,5),?60,$J(%(1),5),?67,$J(%(2),5),?73,$J(%(3),5)
 W !
 ; alcohol only
 D F Q:ACDQ
 S Y=^TMP("ACDRR1",ACDJOB,ACDBT,"ALCOHOL ONLY")
 F %="M","F" S @%=^TMP("ACDRR1",ACDJOB,ACDBT,"ALCOHOL ONLY",%)
 F %=1:1:3 S %(%)=^TMP("ACDRR1",ACDJOB,ACDBT,"ALCOHOL ONLY","AGE",%)
 W ?2,$$LJRF^ACD("ALCOHOL ONLY",28,".")," ",Y I Y W ?37,$J((Y/X*100),3,0),"%",?44,$J(M,5),?51,$J(F,5),?60,$J(%(1),5),?67,$J(%(2),5),?73,$J(%(3),5)
 W !
 ; drugs only
 D F Q:ACDQ
 S Y=^TMP("ACDRR1",ACDJOB,ACDBT,"DRUGS ONLY")
 F %="M","F" S @%=^TMP("ACDRR1",ACDJOB,ACDBT,"DRUGS ONLY",%)
 F %=1:1:3 S %(%)=^TMP("ACDRR1",ACDJOB,ACDBT,"DRUGS ONLY","AGE",%)
 W ?2,$$LJRF^ACD("DRUGS ONLY",28,".")," ",Y I Y W ?37,$J((Y/X*100),3,0),"%",?44,$J(M,5),?51,$J(F,5),?60,$J(%(1),5),?67,$J(%(2),5),?73,$J(%(3),5)
 W !
 ; neither
 D F Q:ACDQ
 S Y=^TMP("ACDRR1",ACDJOB,ACDBT,"NEITHER")
 F %="M","F" S @%=^TMP("ACDRR1",ACDJOB,ACDBT,"NEITHER",%)
 F %=1:1:3 S %(%)=^TMP("ACDRR1",ACDJOB,ACDBT,"NEITHER","AGE",%)
 W ?2,$$LJRF^ACD("NEITHER",28,".")," ",Y I Y W ?37,$J((Y/X*100),3,0),"%",?44,$J(M,5),?51,$J(F,5),?60,$J(%(1),5),?67,$J(%(2),5),?73,$J(%(3),5)
 W !
 Q
 ;
DAYSCS ;EP-alcohol/drug problem days used & client service info
 D F Q:ACDQ
 W !
 W ?30,"AVG",?40,"CLIENT SERVICE INFO",!
 W ?27,"DAYS USED",?41,"AVG #CS",?51,"AVG HRS",!!
 ; alcohol
 D F Q:ACDQ
 S Y=^TMP("ACDRR1",ACDJOB,ACDBT,"ALCOHOL")
 S W=^TMP("ACDRR1",ACDJOB,ACDBT,"ALCOHOL","CS")
 S V=^TMP("ACDRR1",ACDJOB,ACDBT,"ALCOHOL","DAYS")
 S Z=^TMP("ACDRR1",ACDJOB,ACDBT,"ALCOHOL","HRS")
 W ?2,$$LJRF^ACD("ALCOHOL",28,".") I Y W " ",$P(V/Y,"."),?42,$J(W/Y,5,0),?55,$J(Z/Y,2,0)
 W !
 ; drugs
 D F Q:ACDQ
 S Y=^TMP("ACDRR1",ACDJOB,ACDBT,"DRUGS")
 S W=^TMP("ACDRR1",ACDJOB,ACDBT,"DRUGS","CS")
 S V=^TMP("ACDRR1",ACDJOB,ACDBT,"DRUGS","DAYS")
 S Z=^TMP("ACDRR1",ACDJOB,ACDBT,"DRUGS","HRS")
 W ?2,$$LJRF^ACD("DRUGS",28,".") I Y W " ",$P(V/Y,"."),?42,$J(W/Y,5,0),?55,$J(Z/Y,2,0)
 W !
 ; alcohol&drugs
 D F Q:ACDQ
 S Y=^TMP("ACDRR1",ACDJOB,ACDBT,"ALCOHOL&DRUGS")
 S W=^TMP("ACDRR1",ACDJOB,ACDBT,"ALCOHOL&DRUGS","CS")
 S V=^TMP("ACDRR1",ACDJOB,ACDBT,"ALCOHOL&DRUGS","DAYS")
 S Z=^TMP("ACDRR1",ACDJOB,ACDBT,"ALCOHOL&DRUGS","HRS")
 W ?2,$$LJRF^ACD("ALCOHOL&DRUGS",28,".") I Y W " ",$P(V/Y,"."),?42,$J(W/Y,5,0),?55,$J(Z/Y,2,0)
 W !
 ; alcohol only
 D F Q:ACDQ
 S Y=^TMP("ACDRR1",ACDJOB,ACDBT,"ALCOHOL ONLY")
 S W=^TMP("ACDRR1",ACDJOB,ACDBT,"ALCOHOL ONLY","CS")
 S V=^TMP("ACDRR1",ACDJOB,ACDBT,"ALCOHOL ONLY","DAYS")
 S Z=^TMP("ACDRR1",ACDJOB,ACDBT,"ALCOHOL ONLY","HRS")
 W ?2,$$LJRF^ACD("ALCOHOL ONLY",28,".") I Y W " ",$P(V/Y,"."),?42,$J(W/Y,5,0),?55,$J(Z/Y,2,0)
 W !
 ; drugs only
 D F Q:ACDQ
 S Y=^TMP("ACDRR1",ACDJOB,ACDBT,"DRUGS ONLY")
 S W=^TMP("ACDRR1",ACDJOB,ACDBT,"DRUGS ONLY","CS")
 S V=^TMP("ACDRR1",ACDJOB,ACDBT,"DRUGS ONLY","DAYS")
 S Z=^TMP("ACDRR1",ACDJOB,ACDBT,"DRUGS ONLY","HRS")
 W ?2,$$LJRF^ACD("DRUGS ONLY",28,".") I Y W " ",$P(V/Y,"."),?42,$J(W/Y,5,0),?55,$J(Z/Y,2,0)
 W !
 ; neither
 D F Q:ACDQ
 S Y=^TMP("ACDRR1",ACDJOB,ACDBT,"NEITHER")
 S W=^TMP("ACDRR1",ACDJOB,ACDBT,"NEITHER","CS")
 S Z=^TMP("ACDRR1",ACDJOB,ACDBT,"NEITHER","HRS")
 W ?2,$$LJRF^ACD("NEITHER",28,".") I Y W ?42,$J(W/Y,5,0),?55,$J(Z/Y,2,0)
 W !
 Q
 ;
TOBACCO ;EP-tobacco
 D F Q:ACDQ
 W !!,?50,"SEX",?68,"AGE",!
 W "PATIENT COUNT BY TOBACCO USE",?48,"M",?55,"F",?62,"<13",?67,"13-20",?75,"21+",!!
 F %="M","F" S @%=^TMP("ACDRR1",ACDJOB,ACDBT,"SEEN",%)
 F %=1:1:3 S %(%)=^TMP("ACDRR1",ACDJOB,ACDBT,"SEEN","AGE",%)
 W ?2,$$LJRF^ACD("TOTAL SEEN",28,".")," ",X,?44,$J(M,5),?51,$J(F,5),?60,$J(%(1),5),?67,$J(%(2),5),?73,$J(%(3),5),!
 F T=1,2,3 D
 .  Q:'$D(^TMP("ACDRR1",ACDJOB,ACDBT,"TOBACCO",T))
 .  D F Q:ACDQ
 .  S Y=^TMP("ACDRR1",ACDJOB,ACDBT,"TOBACCO",T)
 .  F %="M","F" S @%=^TMP("ACDRR1",ACDJOB,ACDBT,"TOBACCO",T,%)
 .  F %=1:1:3 S %(%)=^TMP("ACDRR1",ACDJOB,ACDBT,"TOBACCO",T,"AGE",%)
 .  S T=$S(T=1:"(SMOKING)",T=2:"(SMOKELESS)",1:"(SMOKING&SMOKELESS)")
 .  W ?2,$$LJRF^ACD("TOBACCO"_T,28,".")," ",Y I Y W ?37,$J((Y/X*100),3,0),"%",?44,$J(M,5),?51,$J(F,5),?60,$J(%(1),5),?67,$J(%(2),5),?73,$J(%(3),5)
 .  W !
 .  Q
 Q
 ;
PRIPROB ;EP-primary problem
 D F Q:ACDQ
 W !!,?50,"SEX",?68,"AGE",!
 W "PATIENT COUNT BY PRIMARY PROBLEM",?48,"M",?55,"F",?62,"<13",?67,"13-20",?75,"21+",!!
 F %="M","F" S @%=^TMP("ACDRR1",ACDJOB,ACDBT,"SEEN",%)
 F %=1:1:3 S %(%)=^TMP("ACDRR1",ACDJOB,ACDBT,"SEEN","AGE",%)
 W ?2,$$LJRF^ACD("TOTAL SEEN",28,".")," ",X,?44,$J(M,5),?51,$J(F,5),?60,$J(%(1),5),?67,$J(%(2),5),?73,$J(%(3),5),!
 S Y="A"
 F  S Y=$O(^TMP("ACDRR1",ACDJOB,ACDBT,"PRI PROB",Y),-1) Q:'Y  D  Q:ACDQ
 .  S ACDPRIEN=0
 .  F  S ACDPRIEN=$O(^TMP("ACDRR1",ACDJOB,ACDBT,"PRI PROB",Y,ACDPRIEN)) Q:'ACDPRIEN  S M=$G(^(ACDPRIEN,"M")),F=$G(^("F")) S %(1)=^("AGE",1),%(2)=^(2),%(3)=^(3) D  Q:ACDQ
 ..  S Z=$P($G(^ACDPROB(ACDPRIEN,0)),U)
 ..  D F Q:ACDQ
 ..  W ?2,$$LJRF^ACD(Z,28,".")," ",Y,?37,$J((Y/X*100),3,0),"%",?44,$J(M,5),?51,$J(F,5),?60,$J(%(1),5),?67,$J(%(2),5),?73,$J(%(3),5),!
 ..  Q
 .  Q
 Q
 ;
PROBLEM ;EP-problem
 D F Q:ACDQ
 W !!,?50,"SEX",?68,"AGE",!
 W "PATIENT COUNT BY PROBLEM",?48,"M",?55,"F",?62,"<13",?67,"13-20",?75,"21+",!!
 F %="M","F" S @%=^TMP("ACDRR1",ACDJOB,ACDBT,"SEEN",%)
 F %=1:1:3 S %(%)=^TMP("ACDRR1",ACDJOB,ACDBT,"SEEN","AGE",%)
 W ?2,$$LJRF^ACD("TOTAL SEEN",28,".")," ",X,?44,$J(M,5),?51,$J(F,5),?60,$J(%(1),5),?67,$J(%(2),5),?73,$J(%(3),5),!
 S Y="A"
 F  S Y=$O(^TMP("ACDRR1",ACDJOB,ACDBT,"PROBLEM",Y),-1) Q:'Y  D  Q:ACDQ
 .  S ACDPRIEN=0
 .  F  S ACDPRIEN=$O(^TMP("ACDRR1",ACDJOB,ACDBT,"PROBLEM",Y,ACDPRIEN)) Q:'ACDPRIEN  S M=$G(^(ACDPRIEN,"M")),F=$G(^("F")) S %(1)=^("AGE",1),%(2)=^(2),%(3)=^(3) D  Q:ACDQ
 ..  S Z=$P($G(^ACDPROB(ACDPRIEN,0)),U)
 ..  D F Q:ACDQ
 ..  W ?2,$$LJRF^ACD(Z,28,".")," ",Y,?37,$J((Y/X*100),3,0),"%",?44,$J(M,5),?51,$J(F,5),?60,$J(%(1),5),?67,$J(%(2),5),?73,$J(%(3),5),!
 ..  Q
 .  Q
 Q
 ;
DRUGUSED ;EP-drug used
 D F Q:ACDQ
 W !!,?50,"SEX",?68,"AGE",!
 W "PATIENT COUNT BY DRUG USED",?48,"M",?55,"F",?62,"<13",?67,"13-20",?75,"21+",!!
 NEW X
 S X=^TMP("ACDRR1",ACDJOB,ACDBT,"DRUGS")
 Q:X<1  ;                    quit if no drugs used
 F %="M","F" S @%=^TMP("ACDRR1",ACDJOB,ACDBT,"DRUGS",%)
 F %=1:1:3 S %(%)=^TMP("ACDRR1",ACDJOB,ACDBT,"DRUGS","AGE",%)
 W ?2,$$LJRF^ACD("TOTAL USING DRUGS",28,".")," ",X,?44,$J(M,5),?51,$J(F,5),?60,$J(%(1),5),?67,$J(%(2),5),?73,$J(%(3),5),!
 S Y="A"
 F  S Y=$O(^TMP("ACDRR1",ACDJOB,ACDBT,"DRUG",Y),-1) Q:'Y  D  Q:ACDQ
 .  S ACDDIEN=0
 .  F  S ACDDIEN=$O(^TMP("ACDRR1",ACDJOB,ACDBT,"DRUG",Y,ACDDIEN)) Q:'ACDDIEN  S M=$G(^(ACDDIEN,"M")),F=$G(^("F")) S %(1)=^("AGE",1),%(2)=^(2),%(3)=^(3) D  Q:ACDQ
 ..  S Z=$P($G(^ACDDRUG(ACDDIEN,0)),U) S:Z="" Z=ACDDIEN
 ..  D F Q:ACDQ
 ..  W ?2,$$LJRF^ACD(Z,28,".")," ",Y,?37,$J((Y/X*100),3,0),"%",?44,$J(M,5),?51,$J(F,5),?60,$J(%(1),5),?67,$J(%(2),5),?73,$J(%(3),5),!
 ..  Q
 .  Q
 Q
 ;
DRUGCMB ;EP-drug combinations
 I $D(^TMP("ACDRR1",ACDJOB,ACDBT,"DRUG COMBO")) D
 .  D F Q:ACDQ
 .  W !!,?50,"SEX",?68,"AGE",!
 .  W "PATIENT COUNT BY ALCOHOL/DRUG COMBINATIONS",?48,"M",?55,"F",?62,"<13",?67,"13-20",?75,"21+",!
 .  S Y="A"
 .  F  S Y=$O(^TMP("ACDRR1",ACDJOB,ACDBT,"DRUG COMBO",Y),-1) Q:'Y  D  Q:ACDQ
 ..  S ACDCMBO=""
 ..  F  S ACDCMBO=$O(^TMP("ACDRR1",ACDJOB,ACDBT,"DRUG COMBO",Y,ACDCMBO)) Q:ACDCMBO=""  S M=$G(^(ACDCMBO,"M")),F=$G(^("F")) S %1=^("AGE",1),%2=^(2),%3=^(3) D  Q:ACDQ
 ...  W !
 ...  S Z=""
 ...  F %=1:1 S ACDDIEN=$P(ACDCMBO,",",%) Q:ACDDIEN=""  D F Q:ACDQ  W:Z'="" ?2,Z,! S Z="" S:ACDDIEN="A" Z="ALCOHOL" I Z="" S Z=$P($G(^ACDDRUG(ACDDIEN,0)),U) S:Z="" Z=ACDDIEN
 ...  D F Q:ACDQ
 ...  W ?2,$$LJRF^ACD(Z,28,".")," ",Y,?37,$J((Y/X*100),3,0),"%",?44,$J(M,5),?51,$J(F,5),?60,$J(%(1),5),?67,$J(%(2),5),?73,$J(%(3),5),!
 ...  Q
 ..  Q
 .  Q
 Q
 ;
F ;Form feed
 NEW V,W,X,Y,Z
 I $Y+4>IOSL D
 . I '$D(ZTQUEUED),'$D(IO("S")),$E(IOST,1,2)'="P-" D PAUSE^ACDDEU S:$D(DIRUT) ACDQ=1
 . W @IOF
 . W !
 . Q
 Q
