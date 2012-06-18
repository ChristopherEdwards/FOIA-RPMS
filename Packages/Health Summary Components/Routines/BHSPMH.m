BHSPMH ;IHS/MSC/MGH - Health Summary for Patient Wellness Handout ;17-Mar-2009 15:48;MGH
 ;;1.0;HEALTH SUMMARY COMPONENTS;**1,2**;March 17, 2006
 ;===================================================================
 ;IHS/CMI/GRL Patient Health Summary - Pre-visit;
 ;;2.0;IHS RPMS/PCC Health Summary;**15**;JUN 24, 1997
 ;This is a copy of APCHPMH to use in VA health summary
 ;
EN ; EP for health summary component
 ;S APCDPAT=DFN,APCDVLDT=DT D ^APCDVLK  ;does pt have a visit today?
 D PRINT^BHSPMH
 Q
S(Y,F,C,T) ;set up array
 I '$G(F) S F=0
 I '$G(T) S T=0
 NEW %,X,L
 ;blank lines
 F F=1:1:F S X="" D S1
 S X=Y
 I $G(C) S L=$L(Y),T=(80-L)/2 D  D S1 Q
 .F %=1:1:(T-1) S X=" "_X
 F %=1:1:T S X=" "_Y
 D S1
 Q
S1 ;
 S %=$P(^TMP("BHSPHS",$J,"PMH",0),U)+1,$P(^TMP("BHSPHS",$J,"PMH",0),U)=%
 S ^TMP("BHSPHS",$J,"PMH",%)=X
 Q
PRINT ;
 N BHSCVD,BHSDFN,APCHSDFN,BHSCVS,BHX,DIWL,DIWR
OUTPUT S BHSCVD="S:Y]"""" Y=+Y,Y=$E(Y,4,5)_""/""_$S($E(Y,6,7):$E(Y,6,7)_""/"",1:"""")_$E(Y,2,3)"
 K ^TMP("BHSPHS",$J)
 S BHSDFN=DFN,APCHSDFN=DFN
 D EP^BHSPMH1(DFN) ;gather up data
W ;write out array
 D CKP^GMTSUP Q:$D(GMTSQIT)
 ;W !,"********** Patient Wellness Handout ********** ["_$P(^VA(200,DUZ,0),U,2)_"]  "_GMTSDTM_" ********"
 S BHX=0 F  S BHX=$O(^TMP("BHSPHS",$J,"PMH",BHX)) Q:BHX'=+BHX!($D(GMTSQIT))  D
 .D CKP^GMTSUP Q:$D(GMTSQIT)
 .W !,^TMP("BHSPHS",$J,"PMH",BHX)
 .Q
 D CKP^GMTSUP Q:$D(GMTSQIT)
 Q
 ;
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
