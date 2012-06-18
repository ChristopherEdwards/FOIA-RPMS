APCLW1P ; IHS/CMI/LAB - print dx by age ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
START ;
 S APCL80="",$P(APCL80,"-",80)=""
 S (APCLPG,APCLSEXP)=0
 K APCLQUIT
 I APCLBTUP=0 D HEAD W !,"NO PATIENT DATA TO REPORT",! G DONE
 F APCLSEXP="F","M","B" Q:$D(APCLQUIT)  D AGE
DONE D DONE^APCLOSUT
 K ^XTMP("APCLW1",APCLJOB,APCLBTH),APCLJOB,APCLBTH
 Q
AGE ;
 I APCLSEX'="B"&(APCLSEXP'=APCLSEX) Q
 D HEAD Q:$D(APCLQUIT)
 S APCLAGEP=0 F  S APCLAGEP=$O(^XTMP("APCLW1",APCLJOB,APCLBTH,"TOTAL USABLE PATS",APCLSEXP,APCLAGEP)) Q:APCLAGEP=""!($D(APCLQUIT))  D
 .I APCLAGEG="G" S APCLPAGE=$P(APCLBIN,";",APCLAGEP)
 .E  S APCLPAGE=APCLAGEP
 .I $Y>(IOSL-4) D HEAD Q:$D(APCLQUIT)
 .W !,APCLPAGE S P=^XTMP("APCLW1",APCLJOB,APCLBTH,"TOTAL USABLE PATS",APCLSEXP,APCLAGEP) W ?8,$J(P,6)
 .I P=0 D  Q
 ..F X=18,27,43,50,57,63,71,77 W ?X,"-"
 .S X=^XTMP("APCLW1",APCLJOB,APCLBTH,"TOTAL BMI",APCLSEXP,APCLAGEP),B=$J((X/P),5,1) W ?16,$J(B,6)
 .S X=$J(^XTMP("APCLW1",APCLJOB,APCLBTH,"LOW",APCLSEXP,APCLAGEP),5,1),Y=$J(^XTMP("APCLW1",APCLJOB,APCLBTH,"HIGH",APCLSEXP,APCLAGEP),5,1),R=X_"-"_Y W ?24,$J(R,6)
 .S X=^XTMP("APCLW1",APCLJOB,APCLBTH,"OVERWEIGHT",APCLSEXP,APCLAGEP),V=$J(((X/P)*100),5,1) W ?38,$J(X,6),?47,V
 .S B=^XTMP("APCLW1",APCLJOB,APCLBTH,"OBESE",APCLSEXP,APCLAGEP),V=$J(((B/P)*100),5,1) W ?52,$J(B,6),?60,V
 .S V=$J((((X+B)/P)*100),5,1) W ?66,$J((X+B),6),?74,V
 I $Y>(IOSL-4) D HEAD Q:$D(APCLQUIT)
 S T="APCL"_APCLSEXP_"TUP" W !!,"TOTAL:  ",?8,$J(@T,6)
 I @T=0 D  Q
 .F X=18,27,43,50,57,63,71,77 W ?X,"-"
 S Z="APCL"_APCLSEXP_"BMI",B=$J((@Z/@T),5,1) W ?16,$J(B,6)
 S Z="APCL"_APCLSEXP_"LOW",X=$J(@Z,5,1),Z="APCL"_APCLSEXP_"HGH",Y=$J(@Z,5,1) W ?24,X_"-"_Y
 S Z="APCL"_APCLSEXP_"OVR",V=$J(((@Z/@T)*100),5,1) W ?38,$J(@Z,6),?47,V
 S Y="APCL"_APCLSEXP_"OBE",V=$J(((@Y/@T)*100),5,1) W ?52,$J(@Y,6),?60,V
 S V=$J((((@Y+@Z)/@T)*100),5,1) W ?66,$J((@Y+@Z),6),?74,V
 I $Y>(IOSL-15) D HEAD Q:$D(APCLQUIT)
 W !!,"*  Usable Patient Records are defined as:",!?4,"1). Having a visit within the past 3 years (active users)",!?4,"2). Having current height and weight measurements recorded."
 W !?6,"- ages 2-19 must have ht and wt taken on the same day within the past year"
 W !?6,"- ages 20-74 must have ht taken after age 19/wt taken in the past 3 yrs"
 W !!,"NOTE:  To make sure data is accurate and to eliminate data entry error, table",!,"excludes patient records whose BMI falls above or below the data check limits.",!,"See the BMI Standard Reference Table for a list of these limits."
 W !,"Prenatal patients are also excluded."
 W !,"*****   Values identified on this report as errors are 'possible' errors that"
 W !,"        deserve review but are not 'validated true errors'.",!
 I $Y>(IOSL-9) D HEAD Q:$D(APCLQUIT)
 W !,"Ages 2-19:  'At Risk for Overweight' is defined as BMI >=85th% but <95th%"
 W !?12,"'Overweight' is defined as BMI >= 95th%"
 W !,"(per National Center for Health Statistics in collaboration with the National",!,"Center for Chronic Disease Prevention and Health Promotion (2000)."
 W !!,"Ages 20-74:  'Overweight' is defined as BMI >=25.0 but <30.0."
 W !?13,"'Obese' is defined as BMI >=30.0"
 W !,"(per Clinical Guidelines on the Identification, Evaluation,"
 W !," and Treatment of Overweight and Obesity in Adults. Bethesda, Md: NHlBI, 1998)"
 Q
HEAD I 'APCLPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !
 S X=$P(^DIC(4,DUZ(2),0),"^")
 W !,$P(^VA(200,DUZ,0),"^",2),?(80-$L(X)/2),X,?71,"Page ",APCLPG,!
 W ?21,"RISK FOR OVERWEIGHT PREVALENCE REPORT",!
 S X="As of Date: "_APCLDT W ?(80-$L(X))/2,X
 S APCLTEXT="Report includes: "_$S(APCLSEXP="B":"TOTAL POPULATION (MALES/FEMALES)",APCLSEXP="M":"MALES",APCLSEXP="F":"FEMALES",1:"NO USABLE PATIENT RECORDS")
 S APCLLENG=$L(APCLTEXT)
 W !?(80-APCLLENG)/2,APCLTEXT
 S APCLTEXT="Report Includes: "_$S(APCLIBEN=1:"INDIAN/ALASKA NATIVES ONLY",APCLIBEN'=1:"ALL BENEFICIARIES",1:"HUH")
 S APCLLENG=$L(APCLTEXT) W !?(80-APCLLENG)/2,APCLTEXT
 ;
 I APCLSEAT'="" S APCLTEXT="Search Template of Patients: "_$P(^DIBT(APCLSEAT,0),U)
 I APCLSEAT'="" S APCLLENG=$L(APCLTEXT) W !?(80-APCLLENG)/2,APCLTEXT
 I APCLCMS'="" S APCLTEXT="CMS Register: "_$P(^ACM(41.1,APCLCMS,0),U)
 I APCLCMS'="" S APCLLENG=$L(APCLTEXT) W !?(80-APCLLENG)/2,APCLTEXT
 W !!?7,"TOTAL #",!?7,"PATIENT",?15,"AVERAGE",?40,"(AT RISK FOR)"
 W !,"AGE",?7,"RECORDS",?17,"BMI",?25,"RANGE",?42,"OVERWEIGHT)",?57," OBESE",?70,"COMBINED"
 W !?7,"USED*",?36,"       #      %",?57,"#",?63,"%",?71,"#",?77,"%"
 W !,APCL80
 Q
