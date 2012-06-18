CIMGAGPS ; CMI/TUCSON/LAB - aberdeen gpra print ;  [ 01/27/00  10:04 AM ]
 ;;1.0;ABERDEEN GPRA REPORT;;JAN 22, 2000
 ;
 S CIMQUIT="",CIMGPG=0
 S CIML=0 F  S CIML=$O(^XTMP("CIMGAGP",CIMGJ,CIMGH,"LIST",CIML)) Q:CIML'=+CIML!(CIMQUIT)  D
 .S CIMTITL=$P($T(@CIML),";;",2),CIMTITL1=$P($T(@CIML),";;",3),CIMCOUNT=0
 .D HEADER Q:CIMQUIT
 .S CIMCOM="" F  S CIMCOM=$O(^XTMP("CIMGAGP",CIMGJ,CIMGH,"LIST",CIML,CIMCOM)) Q:CIMCOM=""!(CIMQUIT)  D
 ..S CIMSEX="" F  S CIMSEX=$O(^XTMP("CIMGAGP",CIMGJ,CIMGH,"LIST",CIML,CIMCOM,CIMSEX)) Q:CIMSEX=""!(CIMQUIT)  D
 ...S CIMAGE="" F  S CIMAGE=$O(^XTMP("CIMGAGP",CIMGJ,CIMGH,"LIST",CIML,CIMCOM,CIMSEX,CIMAGE)) Q:CIMAGE=""!(CIMQUIT)  D
 ....S DFN=0 F  S DFN=$O(^XTMP("CIMGAGP",CIMGJ,CIMGH,"LIST",CIML,CIMCOM,CIMSEX,CIMAGE,DFN)) Q:DFN'=+DFN!(CIMQUIT)  D PRINTL
 ....Q
 ...Q
 ..Q
 .I $Y>(IOSL-3) D HEADER Q:CIMQUIT
 .W !!,"Total Number: ",CIMCOUNT
 .Q
 Q
PRINTL ;print one line
 I $Y>(IOSL-3) D HEADER Q:CIMQUIT
 W !,$E($P(^DPT(DFN,0),U),1,25),?27,$$HRN^AUPNPAT(DFN,DUZ(2)),?33,$E(CIMCOM,1,18),?52,CIMSEX,?56,CIMAGE,?60,^XTMP("CIMGAGP",CIMGJ,CIMGH,"LIST",CIML,CIMCOM,CIMSEX,CIMAGE,DFN)
 S CIMCOUNT=CIMCOUNT+1
 Q
 ;
 Q
CALC(N,O) ;ENTRY POINT
 ;N is new
 ;O is old
 NEW Z
 I O=0!(N=0)!(O="")!(N="") Q "**"
 NEW X,X2,X3
 S X=N,X2=1,X3=0 D COMMA^%DTC S N=X
 S X=O,X2=1,X3=0 D COMMA^%DTC S O=X
 I +O=0 Q "**"
 S Z=(((N-O)/O)*100),Z=$FN(Z,"+,",1)
 Q Z
V(R,N,P) ;
 Q $P($G(^CIMAGP(R,N)),U,P)
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
HEADER ;EP
 G:'CIMGPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S CIMQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S CIMGPG=CIMGPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",CIMGPG,!
 W !,$$CTR("***  ABERDEEN AREA GPRA INDICATORS  ***",80),!
 W $$CTR($P(^DIC(4,DUZ(2),0),U)),!
 S X="Reporting Period: "_$$FMTE^XLFDT(CIMBD)_" to "_$$FMTE^XLFDT(CIMED) W $$CTR(X,80),!
 S X="Baseline Period:  "_$$FMTE^XLFDT(CIM98B)_" to "_$$FMTE^XLFDT(CIM98E) W $$CTR(X,80),!
 W $$CTR(CIMTITL,80),!
 I CIMTITL1]"" W $$CTR(CIMTITL1,80),!
 W "PATIENT NAME",?27,"HRN",?33,"COMMUNITY",?52,"SEX",?56,"AGE",?60,"VALUE"
 W !,$TR($J("",80)," ","-")
 Q
1 ;;1/1 Diabetes Prevalance;;Listing of Patients Diagnosed with Diabetes
2 ;;1/2 Diabetes Incidence;;Listing of Patients Diagnosed with Diabetes in Time Period
3 ;;2/2 Diabetes;;Listing of Diabetic Patients and HGB A1C Values
4 ;;3/3 Diabetes;;Listing of Diabetics/w HTN and Blood Pressure Control
5 ;;4/4 Diabetes;;Listing of Diabetics and Date LDL done
6 ;;5/5 Diabetes;;Listing of Diabetics and Urine Protein Value
7 ;;6/6 Women's Health;;Listing of Women over 17 years old and Date of Pap Screening
8 ;;7/7 Women's Health;;Listing of Women 40-69 and Date of Mammogram Screeing
9 ;;8/8 Child Health;;Listing of Children turning 27 Months and # of Well child visits
10 ;;11/12 Dental Health;;Active Users and Dental Visit Status
11 ;;12/13 Dental Health;;Children 6-8 or 14-15 and Sealant Status
12 ;;Child Health Immunization;;Listing of Children 2 Yrs old and Immunization Needs
13 ;;Child Obesity;;Listing of Children 3-5 and 8-10 and Obesity Status
14 ;;Adult Immuniations;;Listing of Patients Over 65 and Pneumovax date
15 ;;Adult Immunizations;;Listing of Patients Over 65 and Date of Flu Vaccine
16 ;;24/2000 Smoking;;Listing of Documented Current Tobacco Users
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
