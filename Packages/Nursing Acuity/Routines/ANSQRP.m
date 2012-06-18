ANSQRP ;IHE/OIRM/DSD/CSC - PRINT NURSING UNIT ROSTER; [ 02/25/98  10:32 AM ]
 ;;3.0;NURSING PATIENT ACUITY;;APR 01, 1996
 ;;PRINT NURSING UNIT ROSTER
EN K DTOUT,DUOUT
 S ANSU=$S($D(^ANSD(59.1,ANSUNIT,0)):$P(^(0),U),1:""),Y=DT
 X ^DD("DD")
 S ANSDT=Y,ANSPG=0
 S X=$P($H,",",2),H=X\3600,M=X#3600\60,X=$S(X>43199:"PM",1:"AM"),M=$E(100+M,2,3)
 S:H>12 H=H-12
 S:H<1 H=12
 S ANSTM=H_":"_M_" "_X
 W:$G(IOST)["C-" @IOF
 D HEAD
 K A
 S (ANSR,ANSPTC)=""
 F  S ANSR=$O(^TMP("ANS",$J,ANSR)) Q:ANSR=""!$D(DTOUT)!$D(DUOUT)  D
 .S ANSB=""
 .F  S ANSB=$O(^TMP("ANS",$J,ANSR,ANSB)) Q:ANSB=""!$D(DTOUT)!$D(DUOUT)  D
 ..S ANSDFN=""
 ..F  S ANSDFN=$O(^TMP("ANS",$J,ANSR,ANSB,ANSDFN)) Q:ANSDFN=""!$D(DTOUT)!$D(DUOUT)  S ANSDX=^(ANSDFN),ANSCL=$G(^(ANSDFN,1)),ANSAF=$G(^(2)) D
 ...S ANSPTC=ANSPTC+1,ANSPL=0
 ...Q:'$D(^DPT(ANSDFN,0))  S P=$P(^(0),U),N=""
 ...I $D(^AUPNPAT(ANSDFN,41,ANSSITE,0)) S N="("_$P(^(0),U,2)_")"
 ...S L=$L(N),P=$E(P,1,28-L)_" "_N,(R,B)="",X=$P(ANSDX,U,3),Y=$P(ANSDX,U,4)
 ...I X,$D(^ANSD(59.1,ANSUNIT,"R",X,0)) S R=$P(^(0),U) I Y,$D(^("B",Y,0)) S B=$P(^(0),U)
 ...D PRINT
 W !!,"Total Patients: ",ANSPTC,!!
 S N=0
 F I=1:1 S N=$O(^ANSD(51.1,1,"K",N)) Q:N<1  I $D(^(N,0)) S X=^(0) D
 .W ?I-1*18,"Level ",$P(X,U,2),": ",$S($D(A(N)):A(N),1:"None")
 D PAUSE^ANSDIC
 Q
PRINT D:$Y>54 HEAD
 I $Y+4>IOSL D PAUSE^ANSDIC Q:$D(DUOUT)!$D(DTOUT)  D HEAD
 W !,$J(R,5),$J(B,3),?10,P,?39
 F I=1:1:10 S L=$P(ANSCL,U,I),ANSPL=ANSPL+L,P=$S(L>3:"*",1:" ") W " ",$J(P_L,3)
A4 S DX=$P(ANSDX,U)
 W !,?5,"Dx:  "
 I DX="" W "None Listed"
 E  D
 .W:IOST["C-" @ANSRVON
 .W DX,@ANSSPAC
 .W:IOST["C-" @ANSRVOF
 W !," Adj FX:  "
 S T=0
 I ANSAF="" W "None Listed"
 I ANSAF]"" D
 .F I=1:1 S X=$P(ANSAF,U,I) Q:X=""  D:$D(^ANSD(59.3,X,0))
 ..S X=$P(^ANSD(59.3,X,0),U,2),S=$P(^(0),U,3),L=$L(X)
 ..W:$X+L>74 !,?14
 ..W:I>1 ","
 ..W:IOST["C-" @ANSRVON
 ..W X_" "
 ..W:IOST["C-" @ANSRVOF
 ..I S]"" S @("T=T"_S_"4")
 S ANSPL=ANSPL+T-1
 S L="",N=$O(^ANSD(51.1,1,"K",ANSPL))
 I N,$D(^ANSD(51.1,1,"K",N,0)) S L=^(0)
 S NCL1=$P(L,U,2),NCL2=$P(L,U,3)
 W !,?4,"NCL:  "
 I NCL1'["V" W NCL1_"  "_NCL2
 E  D
 .W:IOST["C-" @ANSRVON
 .W NCL1_"  "_NCL2_" "
 .W:IOST["C-" @ANSRVOF
 S L=+L
 S A(L)=$G(A(L))+1
 W !
 Q
HEAD D HEAD^ANSMENU  ;CSC 10-97 D ^ANSMENU
 S ANSX="UNIT ROSTER"
 W !!,?80-$L(ANSX)/2,ANSX
 S ANSPG=ANSPG+1 W ?70,"Page ",ANSPG
 W !,?80-$L(ANSU)\2,ANSU,!!,?80-$L(ANSDT)\2,ANSDT,!,?80-$L(ANSTM)\2,ANSTM,!!
 W !," Room-Bed",?20,"Patient",?39
 F I=1:1:10 S X=$S($D(^ANSD(59,I,0)):$P(^(0),U,3),1:"") W $J(X,4)
 W !,"---------",?10,"----------------------------"
 W ?39
 F I=1:1:10 W " ---"
 Q
