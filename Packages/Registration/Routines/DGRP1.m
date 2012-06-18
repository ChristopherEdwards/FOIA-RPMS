DGRP1 ;ALB/MRL - DEMOGRAPHIC DATA ; 5/5/03 2:51pm
 ;;5.3;Registration;**109,161,506,244**;Aug 13, 1993
 ;
EN S (DGRPS,DGRPW)=1 D H^DGRPU F I=0,.11,.121,.13,.15,.24,57 S DGRP(I)=$S($D(^DPT(DFN,I)):^(I),1:"")
 I $P(DGRP(.15),"^",2)]"" S Z="APPLICANT IS LISTED AS 'INELIGIBLE' FOR TREATMENT!",DGRPCM=1 D WW^DGRPV S DGRPCM=0
 I $P(DGRP(.15),"^",3)]"" S Z="APPLICANT IS LISTED AS 'MISSING'.  NOTIFY APPROPRIATE PERSONNEL!",DGRPCM=1 D WW^DGRPV S DGRPCM=0
 W ! S Z=1 D WW^DGRPV W "    Name: " S Z=$P(DGRP(0),"^",1),Z1=31 D WW1^DGRPV W "SS: " S X=$P(DGRP(0),"^",9),Z=$E(X,1,3)_"-"_$E(X,4,5)_"-"_$E(X,6,10),Z1=13 D WW1^DGRPV S Y=$P(DGRP(0),"^",3) X ^DD("DD") W "DOB: ",Y
 D GETNCAL  ;Display name component and alias information
 S Z=3,DGRPX=DGRP(0) D WW^DGRPV W " Remarks: ",$S($P(DGRPX,"^",10)]"":$E($P(DGRPX,"^",10),1,65),1:"NO REMARKS ENTERED FOR THIS PATIENT") S DGAD=.11,(DGA1,DGA2)=1 D A^DGRPU I $P(DGRP(.121),"^",9)="Y" S DGAD=.121,DGA1=1,DGA2=2 D A^DGRPU
 S Z=4 D WW^DGRPV W " Permanent Address: " S Z=" ",Z1=17
 D WW1^DGRPV S Z=5,DGRPW=0 D WW^DGRPV W " Temporary Address: "
 W !?11
 S Z1=40,Z=$S($D(DGA(1)):DGA(1),1:"NONE ON FILE") D WW1^DGRPV W $S($D(DGA(2)):DGA(2),1:"NO TEMPORARY ADDRESS")
 S I=2 F I1=0:0 S I=$O(DGA(I)) Q:I=""  W:(I#2)!($X>50) !?11 W:'(I#2) ?51 W DGA(I)
 S DGCC=$S($D(^DIC(5,+$P(DGRP(.11),U,5),1,+$P(DGRP(.11),U,7),0)):$E($P(^(0),U,1),1,20)_$S($P(^(0),U,3)]"":" ("_$P(^(0),U,3)_")",1:""),1:DGRPU) W !?3,"County: ",DGCC K DGCC
 S DGCC=$S($P(DGRP(.121),U,9)'="Y":"NOT APPLICABLE",$D(^DIC(5,+$P(DGRP(.121),U,5),1,+$P(DGRP(.121),U,11),0)):$E($P(^(0),U,1),1,20)_$S($P(^(0),U,3)]"":" ("_$P(^(0),U,3)_")",1:""),1:DGRPU) W ?43,"County: ",DGCC K DGCC
 W !?4,"Phone: ",$S($P(DGRP(.13),U,1)]"":$P(DGRP(.13),U,1),1:DGRPU),?44,"Phone: ",$S($P(DGRP(.121),U,9)'="Y":"NOT APPLICABLE",$P(DGRP(.121),U,10)]"":$P(DGRP(.121),U,10),1:DGRPU)
 S X="NOT APPLICABLE" I $P(DGRP(.121),U,9)="Y" S Y=$P(DGRP(.121),U,7) X:Y]"" ^DD("DD") S X=$S(Y]"":Y,1:DGRPU)_"-",Y=$P(DGRP(.121),U,8) X:Y]"" ^DD("DD") S X=X_$S(Y]"":Y,1:DGRPU)
 W !?3,"Office: ",$S($P(DGRP(.13),U,2)]"":$P(DGRP(.13),U,2),1:DGRPU),?42,"From/To: ",X
 W !?1,"Bad Addr: ",$$EXTERNAL^DILFD(2,.121,"",$P(DGRP(.11),U,16))
 ;
 ; ***  Additional displays added for Pre-Registration
 I $G(DGPRFLG)=1 D
 . W !
 . N I,MIS1,X,X1,SA1,TP1,X2,X3,ES1
 . I $D(^DIA(2,"B",DFN)) S X="" F I=1:1 S X=$O(^DIA(2,"B",DFN,X)) Q:X<1  I $P(^DIA(2,X,0),U,3)=.05 S MIS1=$P(^DIA(2,X,0),U,2)
 . W:$D(MIS1)>0 !," [MARITAL STATUS CHANGED:] "_$$FMTE^XLFDT(MIS1,"5D")
 . I $D(^DIA(2,"B",DFN)) S X1="" F I=1:1 S X1=$O(^DIA(2,"B",DFN,X1)) Q:X1<1  S:$P(^DIA(2,X1,0),U,3)=.111 SA1=$P(^DIA(2,X1,0),U,2)
 . W:$D(SA1)>0 !," [STREET ADDRESS LAST CHANGED:] "_$$FMTE^XLFDT(SA1,"5D")
 . I $D(^DIA(2,"B",DFN)) S X2="" F I=1:1 S X2=$O(^DIA(2,"B",DFN,X2)) Q:X2<1  S:$P(^DIA(2,X2,0),U,3)=.131 TP1=$P(^DIA(2,X2,0),U,2)
 . W:$D(TP1)>0 !," [HOME PHONE NUMBER CHANGED:] "_$$FMTE^XLFDT(TP1,"5D")
 . I $D(^DIA(2,"B",DFN)) S X3="" F I=1:1 S X3=$O(^DIA(2,"B",DFN,X3)) Q:X3<1  S:$P(^DIA(2,X3,0),U,3)=.31115 ES1=$P(^DIA(2,X3,0),U,2)
 . W:$D(ES1)>0 !," [EMPLOYMENT STATUS CHANGED:] "_$$FMTE^XLFDT(ES1,"5D")
 . I $D(^DPT(DFN,.312,0)) S IN1=0 F  S IN1=$O(^DPT(DFN,.312,IN1)) Q:'IN1  S IN2=$P(^DPT(DFN,.312,IN1,0),U) S INN=$P(^DIC(36,IN2,0),U) D
 .. S IND=$P($G(^DPT(DFN,.312,IN1,1)),U) W !," [INSURANCE:] "_INN_"  DATE ENTERED: "_$S(IND]"":$$FMTE^XLFDT(IND,"5D"),1:"")
 .. I $P($G(^DPT(DFN,.312,IN1,1)),U,5) S INE=$P($G(^DPT(DFN,.312,IN1,1)),U,5) W " DATE EDITED: "_$S(INE]"":$$FMTE^XLFDT(INE,"5D"),1:"")
 ;
 G ^DGRPP
 ;
GETNCAL ;Get name component values
 N DGCOMP,DGNC,DGI,DGA,DGALIAS,DGX,DGRPW
 S DGNC="Family^Given^Middle^Prefix^Suffix^Degree"
 S DGCOMP=+$G(^DPT(DFN,"NAME"))_","
 I DGCOMP D GETS^DIQ(20,DGCOMP,"1:6",,"DGCOMP")
 ;Get alias values
 S DGA=0 F DGI=1:1:6 D  Q:'$D(DGALIAS(DGI))
A2 .S DGA=$O(^DPT(DFN,.01,DGA))
 .I 'DGA D:DGI=1  Q
 ..S DGALIAS(DGI)="< No alias entries on file >" Q
 .I DGI=6 S DGALIAS(DGI)="< More alias entries on file >" Q
 .S DGX=$G(^DPT(DFN,.01,DGA,0)) G:'$L(DGX) A2
 .S DGALIAS(DGI)=$P(DGX,U),DGX=$P(DGX,U,2)
 .I $L(DGX) D
 ..S DGX=" "_$E(DGX,1,3)_"-"_$E(DGX,4,5)_"-"_$E(DGX,6,9)
 ..S $E(DGALIAS(DGI),20)=DGX Q
 .S DGALIAS(DGI)=$E(DGALIAS(DGI),1,31)
 .Q
 ;Display name component and alias data
 F DGI=1:1:6 D
 .W !?5,$J($P(DGNC,U,DGI),6),": ",$E($G(DGCOMP(20,DGCOMP,DGI)),1,$S(DGI=1:23,1:27))
 .I DGI=1 S DGRPW=0,Z=2 W ?37 D WW^DGRPV W " Alias: "
 .W ?48,$G(DGALIAS(DGI))
 .Q
 Q
