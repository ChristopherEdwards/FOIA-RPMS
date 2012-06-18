AMQQCMPM ; IHS/CMI/THL - RESOLVES DISPLAY OF MULTIPLE MULTIPLES ; [ 09/30/2009  8:45 AM ]
 ;;2.0;IHS PCC SUITE;**4,5**;MAY 14, 2009
MM N N,X,Y,Z,%,DIC,A,B,I
 K AMQQDVQU
 D ALL
 I $D(AMQQQUIT) G EXIT
 F I=1:1:($L(AMQQMULX,U)-2) S N=$P(AMQQMULX,U,I) D MM1
EXIT K AMQQMULX
 Q
 ;
MM1 ;
 I $D(^UTILITY("AMQQ",$J,"Q",N))=1 D  Q
 .S %=$P(^UTILITY("AMQQ",$J,"Q",N),U,9)
 .S:+^UTILITY("AMQQ",$J,"Q",N)'=758 $P(^UTILITY("AMQQ",$J,"Q",N),U,14)=1
 .Q:%["NULL"!(%["INVERSE")
 .S $P(%,";",4)="EXISTS",$P(^UTILITY("AMQQ",$J,"Q",N),U,9)=%
 F %=0:0 S %=$O(^UTILITY("AMQQ",$J,"Q",N,%)) Q:'%  S Z=%
 S ^UTILITY("AMQQ",$J,"Q",N,Z+1)=Y_"^U^EXIST^AMQQF^3^^0^0",$P(^UTILITY("AMQQ",$J,"Q",N),U,14)=1
 Q
 ;
ALL S %=$L(AMQQMULX,U)
 S %=$P(AMQQMULX,U,%-1)
 S AMQQMULN=%
 S AMQQOBJ=$P(^UTILITY("AMQQ",$J,"Q",%),U,2)
 S AMQQOBJS=AMQQOBJ_$S($E(AMQQOBJ,$L(AMQQOBJ))?1P!($E(AMQQOBJ,$L(AMQQOBJ))="S"):"",1:"S")
 S AMQQMULL=AMQQMULN
 I AMQQCCLS="V" G ALLEXIT
 F %="NULL","INVERSE" I $P(^UTILITY("AMQQ",$J,"Q",AMQQMULN),U,9)[% D SPEC G ALLEXIT
 I $D(AMQQXX) S X=$S($D(AMQQXX("FORMAT")):AMQQXX("FORMAT"),1:2) G X1
 S %=$G(AMQV("OPTION"))
 S %=$S(%="MAIL":2,%="HSUM":2,%="WORK":1,%="WORK":1,%="TIME":1,%="MONTH":1,1:0)
 I % S X=% G @("X"_X)
 I $D(^UTILITY("AMQQ",$J,"SQXQ",AMQQMULN)) S Z=$O(^(AMQQMULN,"")) I Z F %="NULL","ALL","EXISTS","ANY","INVERSE" I $D(^UTILITY("AMQQ",$J,"SQ",Z,%)) S X=2 S:Z'="ALL"&(Z'="ANY") $P(^UTILITY("AMQQ",$J,"Q",AMQQMULN),U,14)=1 G ALLEXIT
 I $D(^UTILITY("AMQQ",$J,"Q",AMQQMULN,1)),$P(^(1),U,2)="NULL" G ALLEXIT
 I $P(^UTILITY("AMQQ",$J,"Q",AMQQMULN),U,9)["ANY" G ALLEXIT
 I $P(^UTILITY("AMQQ",$J,"Q",AMQQMULN),U,3)="I" S %=$P(^(AMQQMULN),U,9) I $P(%,";",5)=2 G ALLEXIT
 S %=$P(^UTILITY("AMQQ",$J,"Q",AMQQMULN),U,13)
 I %,%'=4 G ALLEXIT
 S X=+$G(^UTILITY("AMQQ",$J,"Q",AMQQMULN))
 I X,$D(^AMQQ(1,X,9)),$P(^(9),U)'="" S AMQQN=^(9) D MULT G ALLEXIT
 I $D(AMQQONE) S X=1 G X1
 I AMQV("OPTION")="COHORT" S X=2 G X2
 S A="@AMQQRV,""PATIENTS"",@AMQQNV"
 S B="@AMQQRV,"""_AMQQOBJS_""",@AMQQNV"
 S %="list"
 I $G(AMQV("OPTION"))="COUNT" S %="count"
 W !!,"You have 2 options for ",%,"ing ",AMQQOBJS," =>",!
 W !?5,"1) For ea. patient, ",%," all ",@B," which match your",!?8,"criteria"
 W !?5,"2) ",$S(AMQV("OPTION")="COUNT":"Count",1:"List")," all ",@A," with ",AMQQOBJS," meeting your criteria,",!?8,"but do not ",%," the individual values of ea. ",AMQQOBJ,!
ALLQ W !,"Your choice (1 or 2): 1// "
 R X:DTIME E  S X=U
 I $E(X)=U S AMQQQUIT="" G ALLEXIT
 I X="" S X=1 W " (1)"
 I X?1."?" D HELP G ALL
X1 I X=1 D:$D(^UTILITY("AMQQ",$J,"Q",AMQQMULN)) X11 G ALLEXIT
X2 I X=2 S AMQQMULX=AMQQMULX_AMQQMULN_U G ALLEXIT
 W "  ??",*7
 G ALLQ
ALLEXIT K AMQQMULN,AMQQOBJ,AMQQOBJS,A,B,AMQQN,AMQQNO3
 Q
 ;
CD W !!,"You have 2 options for counting ",AMQQN(1)," =>",!
 W !?5,"1) Count all specified ",AMQQN(2)," for all patients"
 S AMQQI=0
 F  S AMQQI=$O(^UTILITY("AMQQ",$J,"LIST",AMQQI)) Q:'AMQQI!($D(AMQQSTP))  I ^(AMQQI)[$E(AMQQN(1),1,($L(AMQQN(1))-2)) S:$D(AMQQHIT) AMQQSTP="" S AMQQHIT=""
 W !?5,"2) Count PATIENTS with at least one of the ",$S('$D(AMQQSTP):AMQQN(1),1:AMQQN(1)_" in each query"),!,?7," you specified",!
 K AMQQSTP,AMQQHIT
CDQ W !,"Your choice (1-2): 1// "
 R X:DTIME E  S X=U
 I X=2 S X=3 Q
 I X="" Q
 I X=1 Q
 I X?1."?" D HELP G CD
 I $E(X)=U Q
 W "  ??",*7
 G CDQ
 ;
HELP N %A,%B
 S XQH=$O(^DIC(9.2,"B","AMQQLIST",""))
 D EN1^XQH
 Q
 ;
MULT F I=1:1:3 S AMQQN(I)=$P(AMQQN,U,I)
 I AMQV("OPTION")="COHORT" S X=3 G X3
 S %=$P(^UTILITY("AMQQ",$J,"Q",AMQQMULN),U,15)
 S %=$P(%,";",4)
 I %,$D(^UTILITY("AMQQ TAX",$J,%,"--"))!$D(^UTILITY("AMQQ TAX",$J,%,"-")) Q
 I AMQV("OPTION")="COUNT" D CD G DXQA
 I $D(AMQQONE) S X=2 G DXQA
 W !!,"You have ",$S('$D(AMQQNO3):3,1:2)," options for listing ",AMQQN(1)," =>",!
 W !?5,"1) List every ",$S(AMQQN(2)="ICD9 CODES":"DIAGNOSIS",1:AMQQN(2))," meeting search criteria."
 W !?5,"2) List every ",$S(AMQQN(2)="ICD9 CODES":"DIAGNOSIS",1:AMQQN(2))," and ",AMQQN(3)," meeting search criteria." I $D(AMQQNO3) W !
 I '$D(AMQQNO3) W !?5,"3) List all PATIENTS with ",$S(AMQQN(2)="ICD9 CODES":"DIAGNOSIS",1:AMQQN(2))," you specified, but DO NOT list",!?8,"individual ",AMQQN(2)," or ",AMQQN(3)," (FASTEST OPTION!!)",!
 W ?8,"(Displays UNDUPLICATED list of PATIENTS)",!
DXQ W !,"Your choice (1-",(3-$D(AMQQNO3)),"): 1// "
 R X:DTIME E  S X=U
DXQA I $E(X)=U S AMQQQUIT="" G DXEXIT
 I X="" S X=1 W " (1)"
 I X?1."?" D HELP G MULT
DXQA1 I X=2 S %=+^UTILITY("AMQQ",$J,"Q",AMQQMULN) D  Q
 .I %>999 D EXP Q
 .S:$D(^AMQQ(1,%+.1)) $P(^UTILITY("AMQQ",$J,"Q",AMQQMULN),U,1)=%+.1 S $P(^(AMQQMULN),U,18)=1,$P(^(AMQQMULN),U,14)=3
 .Q
X11 ;IHS/CMI/LAB - addded question about qualifiers
 ;I X=1 S $P(^UTILITY("AMQQ",$J,"Q",AMQQMULN),U,18)=1 Q  ;,$P(^(AMQQMULN),U,14)=2 Q
 K AMQQDVQU
 I X=1 S $P(^UTILITY("AMQQ",$J,"Q",AMQQMULN),U,18)=1
 I $P(^AMQQ(1,+$G(^UTILITY("AMQQ",$J,"Q",AMQQMULL)),0),U,3)=9000010.01 D
 .NEW X
 .K DIR,AMQQDVQU
 .S DIR(0)="Y",DIR("A")="Do you want to display associated measurement qualifiers with each "_AMQQOBJS,DIR("B")="N",DIR("?")="If you want to display the qualifiers (e.g. Oral, Left Arm, etc) enter Y for Yes." KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) K AMQQDVQU Q
 .I 'Y K AMQQDVQU Q
 .S AMQQDVQU=1
 .Q
 I X=1 Q
X3 I '$D(AMQQNO3),X=3 S $P(^UTILITY("AMQQ",$J,"Q",AMQQMULN),U,18)=2,AMQQMULX=AMQQMULX_AMQQMULN_U Q
 W " ??",*7
 G DXQ
DXEXIT K X
 Q
 ;
SPEC I $G(AMQV("OPTION"))'="COHORT",%="ALL"!(%="ANY"),$D(^AMQQ(1,+$G(^UTILITY("AMQQ",$J,"Q",AMQQMULN)),9)) S:%="ANY" AMQQNO3="" S AMQQN=^(9) D MULT Q
 S X=2-((%="ALL")!(%="ANY"))
 D DXQA1
 Q
 ;
EXP ; EXPANDED LAB OUTPUT
 N X,Y,Z
 S $P(^AMQQ(1,%,4,1,0),U,5,6)="30^30",^(1)="D EXP^AMQQDO"
 Q
 ;
