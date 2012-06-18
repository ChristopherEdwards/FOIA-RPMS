ASDROUT0 ; IHS/ADC/PDW/ENM - ROUTING SLIPS PRINT ;  [ 11/13/2002  9:31 AM ]
 ;;5.0;IHS SCHEDULING;**8**;MAR 25, 1999
 ;rewrite of VA rtn SDROUT0
 ;  need to use non-namespaced variables for calls to other VA rtns
 ;IHS/ITSC/KMS, 13-Nov-2002 - Patch 8 - Cache' compliancy
 ;
GOT ;EP; -- SUBRTN to set up ^utility sort of patient appts
 S DFN=$P(^SC(SC,"S",GDATE,1,L,0),U)
 S POP=1 D CKP Q:POP
 S NAME=$P(^DPT(DFN,0),U)
 S TDO=$$HRN^ASDUT(DFN),TDO=$P(TDO,"-",3)_$P(TDO,"-",2)
 D ^SDROUT1
 I ORDER=1 D TDO Q
 I ORDER=2 D CLO Q
 I ORDER=3 D PCO Q
 D NMO Q
 ;
TDO ; -- sort by terminal digit
 D COL
 S ^TMP("SDRS",$J," "_TDO,DFN,GDATE,SC)=$S(V:"** COLLATERAL **",1:"") Q
 ;
CLO ; -- sort by clinic
 D COL S SCN=$S($D(^SC(SC,0)):$P(^(0),U),1:SC)
 S ^TMP("SDRS",$J,"A",SCN," "_TDO,DFN)=SC_$S(V:"^** COLLATERAL **",1:"")
 S ^TMP("SDRS",$J,"B",DFN,GDATE)=SC K V Q
 ;
PCO ; -- sort by principal clinic
 NEW SCZ S SCZ=$P($G(^SC(SC,"SL")),U,5),SCZ=$S(+SCZ:SCZ,1:SC)
 D COL S SCN=$S($D(^SC(SCZ,0)):$P(^(0),U),1:SCZ)
 S ^TMP("SDRS",$J,"A",SCN," "_TDO,DFN)=SC_$S(V:"^** COLLATERAL **",1:"")
 S ^TMP("SDRS",$J,"B",DFN,GDATE)=SC K V Q
 ;
NMO ; -- sort by name
 D COL
 S ^TMP("SDRS",$J,NAME,DFN,GDATE,SC)=$S(V:"** COLLATERAL **",1:"") K V Q
 ;
COL ; -- ??
 S V=0 I $P(^SC(SC,"S",GDATE,1,L,0),U,10)]"" D
 . S V=$P(^SC(SC,"S",GDATE,1,L,0),U,10)
 . S V=$S($D(^DIC(8,+V,0)):$P(^(0),U,9)=13,1:0)
 Q
 ;
CKP ; -- check to see if rs should be printed for patient
 I SDREP D CKP1 Q
 I $S('$D(^DPT(DFN,"S",GDATE,0)):1,$P(^(0),U,2)["C":1,1:0) S POP=1 Q
 I $S($D(SDI1):1,SDX["ALL":1,SDIQ=1:1,$P(^DPT(DFN,"S",GDATE,0),U,6)'["Y":1,1:0) S POP=0 Q
 I $P(^DPT(DFN,"S",GDATE,0),U,6)="Y",$$NEW1 S POP=0 Q
 Q
 ;
CKP1 ; -- check if rs should be included in reprint
 I $S('$D(^DPT(DFN,"S",GDATE,0)):1,$P(^(0),U,2)["C":1,1:0) S POP=1 Q
 I SDX["ALL" S POP=0 Q
 I $P(^DPT(DFN,"S",GDATE,0),U,13)']""!($P(^(0),U,13)=SDSTART) S POP=0,$P(^(0),U,13)=SDSTART Q
 S POP=1 Q
 ;
 ;
 ;
GO ;EP; called to print r slips
 S SDCNT=0 D GO1
 I ORDER=2!(ORDER=3) D CLIN Q
 ;
 ; term digit or name order
 F  S I=$O(^TMP("SDRS",$J,I)) Q:I=""  D
 . S J=0 F  S J=$O(^TMP("SDRS",$J,I,J)) Q:J=""  D
 .. S P=0,SDZ=0
 .. D PRINT(I,J),CNT Q:$D(SDZMK)  ;one rs for chart room or mk appt
 .. I $D(SDZCV) D PRINT(I,J):$$RS2 D OTHER Q  ;walk-in visit
 .. I $$RS2 S K=0 F  S K=$O(^TMP("SDRS",$J,I,J,K)) Q:K=""  D
 ... S L=0 F  S L=$O(^TMP("SDRS",$J,I,J,K,L)) Q:L=""  D
 .... D PRINT(I,J),CNT ;one rs for each appt
 .. D OTHER
 D END^SDROUT1
 Q
 ;
GO1 ; -- SUBRTN to initialize sort
 S I=0 Q:'SDREP!(SDX'["ALL")!(SDSTART="0000")
 I SDSTART?4N D  Q  ;term digit
 . S SDZ=(SDSTART-1)/10000,SDZ=$P(SDZ,".",2)
 . S SDZ=SDZ_$E("0000",1,4-$L(SDZ)),I=" "_SDZ K SDZ
 ;
 I '$D(^TMP("SDRS",$J,SDSTART)) S I=SDSTART Q
 S SDZ=$A($E(SDSTART,$L(SDSTART)))
 S I=$E(SDSTART,1,$L(SDSTART)-1)_$C(SDZ-1) K SDZ
 Q
 ;
CLIN ; -- SUBRTN to print by clinic
 F  S I=$O(^TMP("SDRS",$J,"A",I)) Q:I=""  D
 . S SDTD=0 F  S SDTD=$O(^TMP("SDRS",$J,"A",I,SDTD)) Q:SDTD=""  D
 .. S J=0 F  S J=$O(^TMP("SDRS",$J,"A",I,SDTD,J)) Q:J=""  D
 ... I ^TMP("SDRS",$J,"A",I,SDTD,J) D
 .... S SC=+^TMP("SDRS",$J,"A",I,SDTD,J),P=0
 .... D PRINT2(I,J) D CNT D:$$RS2 PRINT2(I,J) D OTHER
 W:IOF]"" !,@IOF D END^SDROUT1
 Q
 ;
PRINT2(I,J) ; -- SUBRTN to print rs by clinic
 NEW K,L
 I SDCNT>0 W @IOF
 D HED^SDROUT2,HD^SDROUT2 S K=0
 F  S K=$O(^TMP("SDRS",$J,"B",J,K)) D:K="" FUT  Q:K=""  D
 . S (SDZ,L)=^TMP("SDRS",$J,"B",J,K) D LIN,X1
 Q
 ;
PRINT(I,J) ; -- SUBRTN to print a routing slip based on patient ifn J
 NEW K,L
 I SDCNT>0 W @IOF
 D HED^SDROUT2,HD^SDROUT2
 S K=0 F  S K=$O(^TMP("SDRS",$J,I,J,K)) D:K="" FUT Q:K=""  D
 . S L=0 F  S L=$O(^TMP("SDRS",$J,I,J,K,L)) Q:L=""  D LIN,X
 Q
 ;
LIN ; -- SUBRTN to print individual appointments
 S X=K D TM W !,$J(X,8)
 I $D(^SC(L,0)) D
 . W ?11,$P(^SC(L,0),U)
 . D LOC W:$$SHORT^ASDROUT2 !?11 W:'$$SHORT^ASDROUT2 ?42
 . W SDLOC K SDLOC
 . D:$D(^DPT(J,"S",K,0)) SETP(J,K)
 . W:'$D(^DPT(J,"S",K,0)) ?70,"*DELETED*"
 . D SCCOND^SDROUT2
 W:'$D(^SC(L,0)) ?11,L
 ;
 NEW X S X=0 F  S X=$O(^SC(L,"S",K,1,X)) Q:'X  D
 . Q:$P(^SC(L,"S",K,1,X,0),U)'=J
 . W:$P(^SC(L,"S",K,1,X,0),U,4)'="" !,?11,$P(^(0),U,4)
 D:$Y>(IOSL-5) HED^SDROUT2
 Q
 ;
X ; -- SUBRTN to print extra info
 I $P(^TMP("SDRS",$J,I,J,K,L),U)]"" W !,?4,$P(^(L),U) Q
 I $D(^DPT(+J,.36)),$D(^DIC(8,+^DPT(+J,.36),0)),$P(^(0),U,9)=13 W !,?4,"** COLLATERAL **"
 Q
 ;
X1 ; -- SUBRTN to print extra info
 I $P(^TMP("SDRS",$J,"A",I,SDTD,J),U,2)]"" W !,?4,$P(^(J),U,2) Q
 I $D(^DPT(+J,.36)),$D(^DIC(8,+^DPT(+J,.36),0)),$P(^(0),U,9)=13 W !,?4,"** COLLATERAL **"
 Q
 ;
 ;
LOC ; -- SUBRTN to return location
 S SDLOC=$P(^SC(L,0),U,11)
 I SDLOC']"",$D(^DIC(4,+^DD("SITE",1),"DIV")),^("DIV")="Y" D
 . S SDLOC=$S($P(^SC(L,0),U,15)=DIV:"",$D(^DG(40.8,+$P(^SC(L,0),U,15),0)):$P(^(0),U,1),1:"")
 Q
 ;
FUT ;EP -- SUBRTN to print future appts
 I $$SHORT^ASDROUT2 D DATE Q  ;short form
 I $O(^DPT(J,"S",SDATE_".9"))>0 D
 . I $Y>(IOSL-5) D HED^SDROUT2
 . D HED2
 . F M=SDATE_".9":0 S M=$O(^DPT(J,"S",M)) Q:M=""  D
 .. I $Y>(IOSL-5) D HED^SDROUT2,HED2
 .. I $S($P(^DPT(J,"S",M,0),U,2)']"":1,$P(^(0),U,2)="I":1,1:0) D LIN2
 ;
DATE I SDREP,SDX'["ALL" D  Q
 . W !!,"DATE PRINTED  : " S Y=SDSTART D DTS^SDUTL
 . W Y,!,"DATE REPRINTED: ",PRDATE
 W !!,"DATE PRINTED: ",PRDATE
 W !,"Requested by: ",$P($G(^VA(200,+$G(DUZ),0)),U)
 Q
 ;
LIN2 ; -- SUBRTN to print future appts line
 D LIN2^SDROUT1
 S L=+^DPT(J,"S",M,0),X=M D TM S Y=M D DTS^SDUTL
 W !,Y,?11,$J(X,8),?20,$P(^SC(L,0),U,1) D LOC W ?52,SDLOC K SDLOC
 I $P($G(^SC(L,9999999)),U,7)]"" W !?13,$P(^(9999999),U,7)
 Q
 ;
HED2 ;EP -- SUBRTN to print future appt heading
 W !!,?9,"**FUTURE APPOINTMENTS**"
 W !!,"  DATE",?11,"TIME",?21,"CLINIC",?55,"LOCATION",!
 Q
 ;
TM ; -- SUBRTN for printable time
 I $P(X,".",2)']"" S X1=""
 S X=$E($P(X,".",2)_"0000",1,4),%=X>1159 S:X>1259 X=X-1200 S X=X\100_":"_$E(X#100+100,2,3)_" "_$E("AP",%+1)_"M"
 Q
 ;
SETP(J,K) ; -- called to set date printed
 NEW DIE,DA,DR,END
 Q:J<1  Q:K<1
 S DIE="^DPT("_J_",""S"",",DA=K\1,DA(1)=J,END=DA+.2400
 F  S DA=$O(^DPT(J,"S",DA)) Q:DA=""!(DA>END)  D
 . Q:$P(^DPT(J,"S",DA,0),U,2)["C"
 . S DR="8///Y" S:$P(^DPT(J,"S",DA,0),U,13)="" DR=DR_";8.5///"_DT
 . D ^DIE
 Q
 ;
OTHER ; -- calls other forms
 ; searhc/maw these all get set up in the clinic setup option
 Q:$P($G(^DG(40.8,$$DIV,"IHS")),U,4)'=1  ;others not print with rs
 D EF ;   encounter form 
 D HS ;   health summary
 D MP ;   med profile 
 D AIU ;  address/insurance update 
 Q
 ;
EF ; -- encounter form
 Q:$G(SDZEF)  Q:'$$ONE(J,5)  W @IOF D EF^ASDFORM(SC,J,SDATE) Q
 ;
HS ; -- health summary
 ;IHS/ITSC/KMS, 13-Nov-2002  Added extra space " " after QUIT for Cache' compliance - KMS
 ;I $G(SDZHS) Q ;searhc/maw removed form feed
 I $G(SDZHS) Q  ;searhc/maw removed form feed
 ;I $G(SDZHS) W @IOF Q
 ;IHS/ITSC/KMS, 13-Nov-2002 Added extra space " " after QUIT for Cache' compliance - KMS
 ;I '$$ONE(J,1) Q ;searhc/maw removed form feed
 I '$$ONE(J,1) Q  ;searhc/maw removed form feed
 ;I '$$ONE(J,1) W @IOF Q
 D HS^ASDFORM(J,$P($$ONE(J,1),U,2)) Q
 ;
MP ; -- med profile
 Q:$G(SDZMP)  Q:'$$ONE(J,3)  D MP^ASDFORM(J) Q
 ;
AIU ; -- insurance update
 Q:$G(SDZAI)  Q:'$$ONE(J,4)  D AIU^ASDFORM(J) Q
 ;
NEW1() ; -- returns 1 if patient has new appt on same day
 NEW X,Y
 S Y=0,X=GDATE\1
 F  S X=$O(^DPT(DFN,"S",X)) Q:X=""  Q:X>(GDATE+.2400)  Q:Y=1  D
 . Q:$P(^DPT(DFN,"S",X,0),U,2)["C"
 . I $P(^DPT(DFN,"S",X,0),U,13)=""!($P(^(0),U,13)=SDSTART) S Y=1
 Q Y
 ;
ONE(DFN,FORM) ; -- returns 1 if at least one  clinic for pat wants form
 NEW X,Y,Z
 S Y=0,X=SDATE\1
 F  S X=$O(^DPT(DFN,"S",X)) Q:X=""  Q:X>(SDATE+.2400)  Q:Y=1  D
 . S Z=$P($G(^DPT(DFN,"S",X,0)),U) Q:Z=""  Q:$P(^(0),U,2)["C"
 . I $P($G(^SC(Z,9999999)),U,FORM)="Y" S Y=1
 . I FORM=1,$$HSTYP^ASDUT(Z,DFN)="" S Y=0
 . I FORM=1,Y=1 S Y=1_U_$$HSTYP^ASDUT(Z,DFN)
 Q Y
 ;
CNT ; -- increment # of routing slips printed
 S SDCNT=SDCNT+1 Q
 ;
RS2() ; -- returns 1 if want >1 rs
 Q $P($G(^DG(40.8,$$DIV,"IHS")),U,3)
 ;
DIV() ; -- returns division ien
 Q $O(^DG(40.8,"C",DUZ(2),0))
