AMHLEFP1 ; IHS/CMI/LAB - print form ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**1**;JUN 18, 2010;Build 8
 ;CMI/TUCSON/LAB - 07/06/98 changed line check from 9 to 10 DEMO+1
 ;CMI/TUCSON/LAB - 07/06/98 check $G on 11 node of AUPNPAT DEMO+8
DEMO ;EP  demographics
 I $P(AMHR0,U,8)="" S X="NO PATIENT INFORMATION AVAILABLE" D S(X,2) S X="" D S(X) Q
 I '$G(FLAG) S X="BEGIN PATIENT DEMOGRAPHIC DATA" D S(X)
 S DFN=$P(AMHR0,U,8)
 S AMHHRN=$$HRN^AUPNPAT(DFN,DUZ(2),2)
 S:AMHHRN="" AMHHRN="<?????>"
 S X="",$E(X,3)="HR#:  "_AMHHRN
 ;NEW %,C,Y S (%,C)=0 F  S %=$O(^AUPNPAT(DFN,41,%)) Q:%'=+%!(C>4)  I %'=DUZ(2) S X=X_"  "_$$HRN^AUPNPAT(DFN,%,2) S C=C+1 PER WENDY AND BJ 7/23/09
 D S(X)
 S X="",$E(X,3)="NAME:  "_$P(^DPT(DFN,0),U) S $E(X,42)="SSN:  "_$$SSN^AMHUTIL(DFN) D S(X)
 S X="",$E(X,3)="SEX: "_$$EXTSET^XBFUNC(2,.02,$P(^DPT(DFN,0),U,2)),$E(X,30)="TRIBE: " S:$P($G(^AUPNPAT(DFN,11)),U,8)]"" X=X_$P(^AUTTTRI($P(^AUPNPAT(DFN,11),U,8),0),U) D S(X)
 S X="",$E(X,3)="DOB:  "_$$FMTE^XLFDT($P(^DPT(DFN,0),U,3)) D S(X)
 S X="",$E(X,3)="RESIDENCE:  "_$P($G(^AUPNPAT(DFN,11)),U,18) D S(X)
 S X="",$E(X,3)="FACILITY: "_$E($P(^DIC(4,DUZ(2),0),U),1,25),$E(X,38)="LOCATION: " S:$P(AMHR0,U,4) X=X_$P(^DIC(4,$P(AMHR0,U,4),0),U) D S(X)
 ;
 I $P($G(^AMHREC(AMHR,11)),U,12)="" D
 .S X="",$E(X,20)="PROVIDER SIGNATURE:  " D S(X,1)
 .S X="",$E(X,3)=$$FMTE^XLFDT($P($P(AMHR0,U),"."))
 .S Y=$$PPINT^AMHUTIL(AMHR) I Y S Y=$P($G(^VA(200,Y,3.1)),U,6) I Y]"" S Y=", "_Y
 .S $E(X,41)=$$PPNAME^AMHUTIL(AMHR)_Y D S(X)
 S X="" D S(X)
 S X=$TR($J("",79)," ","*") D S(X)
 Q
S(Y,F,C,T) ;set up array
 I '$G(F) S F=0
 I '$G(T) S T=0
 ;blank lines
 F F=1:1:F S X="" D S1
 S X=Y
 I $G(C) S L=$L(Y),T=(80-L)/2 D  D S1 Q
 .F %=1:1:(T-1) S X=" "_X
 F %=1:1:T S X=" "_Y
 D S1
 Q
S1 ;
 S %=$P(^TMP("AMHS",$J,"DCS",0),U)+1,$P(^TMP("AMHS",$J,"DCS",0),U)=%
 S ^TMP("AMHS",$J,"DCS",%)=X
 Q
FF ;EP
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S AMHQUIT=1 Q
 W:$D(IOF) @IOF
 Q
