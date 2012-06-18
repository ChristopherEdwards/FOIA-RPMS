LRORD1GU ;VA/DALOI/RWF - LAZY ACCESSION LOGGING ;JUL 06, 2010 3:14 PM
 ;;5.2;LAB SERVICE;**1027**;NOV 01, 1997
 ;;
 ; Cloned from LEDI III LRORD1 routine. Next two lines VA code
LRORD1 ;DALOI/RWF - LAZY ACCESSION LOGGING ; Feb 20, 2004
 ;;5.2;LAB SERVICE;**1,8,121,153,201,286,1027**;Sep 27, 1994
 ;;
 ; This code was removed from the previous IHS version of the LRORD1 routine
 ; and placed in this new routine due to the changes to the LRORD1 routine
 ; brought in with VA LR*5.2*286 --LEDI III.
 ; 
 ; It was felt that the PATIENT CHART coding was overwhelming the logic
 ; flow of the LRORD1 routine.
 ;
 ; This code is invoked ONLY when BLRGUI=1.  No need to check for that.
 ; All code that was skipped when BLRGUI=1 has been removed.
 ;
L2 ; EP ;
 K LROT,LRSAME,LRKIL,LRGCOM,LRCCOM,LR696IEN,LRNATURE
 S LRWPC=LRWP G:$D(LROR) LRFIRST
 ;
 S LRDPF="2^DPT(",PNM=^DPT(DFN,0),SSN=$P(PNM,U,9),PNM=$P(PNM,U)
 S HRCN=$P($G(^AUPNPAT(DFN,41,DUZ(2),0),"^?"),U,2)
 S X="^"_$P(LRDPF,"^",2)_DFN_",""LR"")",LRDFN=+$S($D(@X):@X,1:-1) G E3:LRDFN>0
 L ^LR(0):1 S LRDFN=$P(^LR(0),"^",3)+1
E2 I $D(^LR(LRDFN)) S LRDFN=LRDFN+1 G E2
 S ^LR(LRDFN,0)=LRDFN_"^"_+LRDPF_"^"_DFN,@X=LRDFN,^(0)=$P(^LR(0),"^",1,2)_"^"_LRDFN_"^"_(1+$P(^(0),"^",4)),^LR("B",LRDFN,LRDFN)=""
 L
E3 I LRDFN>0,$P(^LR(LRDFN,0),"^",2)'=+LRDPF!($P(^(0),"^",3)'=DFN) S RESULT(1)=-1,RESULT(2)="Database degradation on "_PNM_".  Contact site manager." Q
BPC I LRDFN<1 S RESULT(1)=-1,RESULT(2)="No Lab LRDFN Defined" Q
 S LRDPF=$P(^LR(LRDFN,0),U,2)
 Q:$G(RESULT(1))=-1
 ;
Q12 ; 
 S LRLLOC=$P(BPCPARAM,";",5),LROLLOC=""
 S Y=0,Y=$O(^SC("B",LRLLOC,Y))
 ;
 ; IHS/ITSC/TPF 12/19/02 **1015** PER F.J. EVANS fix for Fort Thompson not
 ; printing Verified results to the ward when using the Patient Chart
 I Y S LROLLOC=Y,LRLLOC=$S($L($P($G(^SC(Y,0)),U,2)):$P(^(0),U,2),1:LRLLOC)
 ;
Q11 ;
 S (LRPRAC,^LR(LRDFN,.2))=BLRPRAC  ;IHS/ITSC/IHS 10/9/02 PATIENT CHART FIX **1014**
 K T,TT,LRDMAX,LRDTST,LRTMAX
 S DA=0
 F  S DA=$O(^LRO(69,LRODT,1,"AA",LRDFN,DA)) Q:DA<1  D
 . I $S($D(^LRO(69,LRODT,1,DA,1)):$P(^LRO(69,LRODT,1,DA,1),U,4)'="U",1:1) D
 .. S S=+$G(^LRO(69,LRODT,1,DA,4,1,0))
 .. S I=0 F  S I=$O(^LRO(69,LRODT,1,DA,2,I)) Q:+I<1  D
 ... S X=+^LRO(69,LRODT,1,DA,2,I,0),T(X,DA)=S
 ... S:'$D(TT(X,S)) TT(X,S)=0 S TT(X,S)=TT(X,S)+1
 ;
 K DIC
 I $D(LRADDTST) S LRORD=+LRADDTST,LRADDTST="" G LRFIRST
 D ORDER^LROW2
 I $D(LRFLOG),$P(LRFLOG,U,3)="MI",$G(LRORDRR)'="R" K DUOUT D MICRO G L2:$D(DUOUT)!$D(DTOUT)
 ;
LRFIRST S LRSX=1 G Q13:'LRFIRST!(LRWP<2)
 ;
Q13 S LREDO=0
LEDI ;
 ;
 G:LRWP'>1 Q13A
 S LRSX=BPCTL
 F I=1:1 S LRSSX=$P(LRSX,",",I),LRSSX=$P(LRSSX,"*") Q:$P(LRSX,",",I,99)=""  S LREDO=$S($L(LRSSX)>31:1,1:(+(LRSSX\1)'=LRSSX)!(LRSSX<1)!(LRSSX>LRWP)) Q:LREDO
 ;
Q13A ;
 F LRK=1:1 S LRSSX=$P(LRSX,",",LRK) Q:LRSSX=""  D
 . N X
 . S LRST=$S(LRSSX["*":1,1:0),LRSSX=+LRSSX
 . S X=^TMP("LRSTIK",$J,LRSSX)
 . S LRSAMP=$P(X,U,3),LRSPEC=$P(X,U,5),LRTSTS=+X
 . D Q20^LRORDD
 ;
BAR S LRM=LRWPC+1,K=0
 ;
LRM ; D MORE^LRORD2
 ;
Q14 D:$P(LRPARAM,U,17) ^LRORDD D ^LRORD2A D ENSTIK^LROW3 G LRM:'$D(%)&($D(LROT)'=11),DROP:$O(LROT(-1))="",LRM:'$D(%),DROP:%[U K DIC G DROP:'$D(LROT)!(%["N")
 S:LRECT LRORDTIM="08"
 D NOW^%DTC S LRNT=% S:'LRECT LRCDT=LRNT_"^1"
 S LRIDT=9999999-LRCDT
 D ^LRORDST Q:$D(LROR)
 S RESULT(1)=1,RESULT(2)="Order:  "_LRORD_"  "_$G(BPCACC)
 Q
 ;
% R %:DTIME Q:%=""!(%["N")!(%["Y")  W !,"Answer 'Y' or 'N': " G %
 ;
Q20A ;from LRORD2
MAX ; CHECK FOR MAXIUM ORDER FREQUENCY
 I $D(TT(LRTSTS,LRSPEC)),$D(^LAB(60,LRTSTS,3,"B",LRCS(LRCSN))) D EN2^LRORDD I %'["Y" Q
 S I7=0 F I9=0:0 S I9=$O(T(LRTSTS,I9)) Q:I9=""  I $D(^LAB(60,LRTSTS,3,+$O(^LAB(60,LRTSTS,3,"B",LRSAMP,0)),0)),+$P(^(0),U,5),LRSPEC=T(LRTSTS,I9) S I7=1
 I I7 W $C(7),!!,"You have a duplicate: " S LRSN=0 F  S LRSN=$O(T(LRTSTS,LRSN)) Q:LRSN<1  W "  for ",$P(^LAB(60,LRTSTS,0),U) S LRZT=LRTSTS D ORDER^LROS S LRTSTS=LRZT
 I I7 W !,"You already have that test, do you really want another? N//" D %
 Q
 ;
URGG ; W !,"For ",$P(^TMP("LRSTIK",$J,LRSSX),U,2)
 D URG^LRORD2
 Q
 ;
 ;
DROP Q:$D(LROR)  G L2 ; !($G(LREND))  G L2
 ;
 ;
MICRO ; EP
 Q:$D(LRFLOG)  ;IHS/ITSC/TPF 08/02/01  ;ACCESSION TEST GROUP ALREADY CHOSEN
 D GSNO^LRORD3 Q:$D(DUOUT)!$D(DTOUT)
 S LRSAMP=1,LRSPEC=1
 I +LRSAMP=-1&(LRSPEC=-1) W !,"Incompletely defined." G MICRO
 S LRSAME=LRSAMP_U_LRSPEC
 S LRECOM=0 D GCOM^LRORD2
 Q
 ;
 ;
PRAC ;from LRFAST
 S X=$S(+DIC("B"):$P(^VA(200,+DIC("B"),0),U),1:"")
 W !,"PRACTITIONER: ",X,$S($L(X):"//",1:"")
 R X:DTIME
 I DIC("B"),X="" S Y=DIC("B") Q
 D ^DIC K DIC
 Q
