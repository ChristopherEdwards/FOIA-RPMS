AQAOPR22 ; IHS/ORDC/LJF - PRINT REVIEW WORKSHEET CONT. ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn prints the review worksheet which lists the possible 
 ;answers for an occurrence review based on review level.
 ;
INIT ; >>> initialize variables    
 S AQAOLINE="",$P(AQAOLINE,"=",80)=""
 S AQAOLIN2="",$P(AQAOLIN2,"_",20)=""
 S AQAOSTOP=""
 ;
HEADING ; >>> print worksheet heading & top section 
 S IOP=AQAODEV D ^%ZIS U IO
 W !,"REVIEW WORKSHEET FOR QAI OCCURRENCE"
 S Y=DT X ^DD("DD") W ?60,Y D TIME^AQAOUTIL S AQAOSTR=^AQAOC(AQAOIFN,0)
 S AQAONAM=$P($G(^DPT($P(AQAOSTR,U,2),0)),U)
 W !,"Case ID:  ",AQAOCID W ?40,"Patient:  ",$E(AQAONAM,1,20)
 S X=$P(AQAOSTR,U,2) W "  #",$P(^AUPNPAT(X,41,DUZ(2),0),U,2) ;chart #
 W !,"Occurrence Date:  " S Y=$P(AQAOSTR,U,4) X ^DD("DD") W Y
 W ?40,"Visit Date:  "
 S (AQAOV,Y)=$P(AQAOSTR,U,3)
 I Y]"" S Y=$P(^AUPNVSIT(Y,0),U) X ^DD("DD") W Y
 I AQAOV D
 .S Y=$P(^AUPNVSIT(AQAOV,0),U,7),C=$P(^DD(9000010,.07,0),U,2) D Y^DIQ
 .W "(",$E(Y,1,4),")" ;visit service category
 S Y=$P(AQAOSTR,U,7),C=$P(^DD(9002167,.07,0),U,2) D Y^DIQ
 W !,"Service/Ward or Clinic:  ",$E(Y,1,25),"/"
 S Y=$P(AQAOSTR,U,6),C=$P(^DD(9002167,.06,0),U,2) D Y^DIQ W $E(Y,1,25)
 W !,"Indicator:  "
 S Y=$P(AQAOSTR,U,8) I Y]"" W $P(^AQAO(2,Y,0),U),?25,$P(^(0),U,2)
 W !,AQAOLINE,!
 ;
REVIEW ; >>> print review level data
 S X="*** "_$P(AQAORLEV,U,2)_" REVIEW ***" W !?(80-$L(X))/2,X,!
 W !,"REVIEWER/TEAM NAME: " W AQAOLIN2,?47,"REVIEW DATE: ",AQAOLIN2
 ;
 ;
RISK ; >>> print all risk of outcomes in file
 G COMMENT:(+AQAORLEV=1) ;no outcome levels at non-clin review level
 F AQAOI=2,4,5 D  Q:AQAOSTOP=U
 .W !!,$S(AQAOI=2:"POTENTIAL OF ADVERSE OUTCOME:",AQAOI=4:"ADVERSE OUTCOME OF OCCURRENCE:",1:"ULTIMATE PATIENT OUTCOME (Only asked when closing occurrence)"),!
 .S AQAOX=0 F  S AQAOX=$O(^AQAO1(3,AQAOX)) Q:AQAOX'=+AQAOX  Q:AQAOSTOP=U  D
 ..Q:'$D(^AQAO1(3,AQAOX,0))  S AQAOX1=^(0)
 ..Q:$P(AQAOX1,U,3)="I"  Q:$P(AQAOX1,U,AQAOI)=""  ;inactive/othr scale
 ..W !?5,"_____  ",$P(AQAOX1,U),"  ",$P(AQAOX1,U,AQAOI)
 ..I $Y>(IOSL-4) D NEWPG
 G END:AQAOSTOP=U
 ;
 ;preformance levels by provider
 W !!,"PERFORMANCE LEVELS BY PROVIDER (Only asked when closing occurrence)",!
 S AQAOX=0 F  S AQAOX=$O(^AQAO1(3,AQAOX)) Q:AQAOX'=+AQAOX  Q:AQAOSTOP=U  D
 .Q:'$D(^AQAO1(3,AQAOX,0))  S AQAOX1=^(0)
 .Q:$P(AQAOX1,U,3)="I"  Q:$P(AQAOX1,U,6)=""  ;inactive/othr scale
 .W !?5,$P(AQAOX1,U),"  ",$P(AQAOX1,U,6)
 .I $Y>(IOSL-4) D NEWPG
 G END:AQAOSTOP=U
 F I=1:1:4 D
 .I $Y>(IOSL-4) D NEWPG
 .W !,"PROVIDER: _______  LEVEL: _____",!
 G END:AQAOSTOP=U
 ;
FIND ; >>> print findings available for this review level
 W !!,"FINDING:",!
 S AQAOX=0 F  S AQAOX=$O(^AQAO(8,AQAOX)) Q:AQAOX'=+AQAOX  Q:AQAOSTOP=U  D
 .Q:'$D(^AQAO(8,AQAOX,0))  S AQAOX1=^(0) Q:$P(AQAOX1,U,4)="I"  ;inactiv
 .Q:$P(AQAOX1,U,3)'[+AQAORLEV  ;not for this review level
 .W !?5,"_____  ",$P(AQAOX1,U,2),?20,$P(AQAOX1,U)
 .I $Y>(IOSL-4) D NEWPG
 G END:AQAOSTOP=U
 ;
ACTION ; >>> print actions available for this review level
 W !!,"ACTION:",!
 S AQAOX=0 F  S AQAOX=$O(^AQAO(6,AQAOX)) Q:AQAOX'=+AQAOX  Q:AQAOSTOP=U  D
 .Q:'$D(^AQAO(6,AQAOX,0))  S AQAOX1=^(0) Q:$P(AQAOX1,U,5)="I"  ;inactiv
 .Q:$P(AQAOX1,U,3)'[+AQAORLEV  ;not for this review level
 .W !?5,"_____  ",$P(AQAOX1,U,2),?20,$P(AQAOX1,U)
 .I $Y>(IOSL-4) D NEWPG
 G END:AQAOSTOP=U
 ;         
COMMENT ; >>> print comments area
 I $Y>(IOSL-4) D NEWPG G END:AQAOSTOP=U
 W !,"COMMENTS:  "
 ;
END ; >>> eoj
 I '$D(ZTQUEUED),'$D(AQAOSLV) D PRTOPT^AQAOVAR
 D ^%ZISC Q
 ;
 ;
NEWPG ; >>> SUBRTN for end of page control
 I IOST?1"C-".E K DIR S DIR(0)="E" D ^DIR S AQAOSTOP=X
 I AQAOSTOP=U Q
 W @IOF,!,"Case ID:  ",AQAOCID W ?40,"Patient:  ",$E(AQAONAM,1,20)
 S X=$P(AQAOSTR,U,2) W "  #",$P(^AUPNPAT(X,41,DUZ(2),0),U,2) ;chart #
 W !,AQAOLINE,!!
 Q
