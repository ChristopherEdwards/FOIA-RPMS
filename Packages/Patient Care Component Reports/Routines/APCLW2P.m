APCLW2P ; IHS/CMI/LAB - print dx by age ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
START ;
 S APCL80="",$P(APCL80,"-",80)="-"
 S (APCLPG,APCLSEXP)=0
 K APCLQUIT
 D HEAD I APCLGRAN=0 W !,"NO PATIENT DATA TO REPORT",! G DONE
 I APCLRTYP="S" W !!,"Search Template ",$P($G(^DIBT(APCLSTMP,0)),U)," has been created.",!,"A total of ",APCLGRAN," patients were added to the template.",! G DONE
 S APCLSRT="" F  S APCLSRT=$O(^XTMP("APCLW2",APCLJOB,APCLBTH,"PATS",APCLSRT)) Q:APCLSRT=""!($D(APCLQUIT))  D PAT
 G:$D(APCLQUIT) DONE
 I $Y>(IOSL-15) D HEAD G:$D(APCLQUIT) DONE
 W !!,"TOTAL NUMBER OF PATIENTS: ",APCLGRAN
 W !!,"*  Usable Patient Records are defined as:",!?4,"1). Having a visit within the past 3 years (active users)",!?4,"2). Having current height and weight measurements recorded."
 W !?6,"- ages 2-19 must have ht and wt taken on the same day within the past year"
 W !?6,"- ages 20-74 must have ht since age 19 and wt taken in the past 3 yrs"
 W !!,"NOTE:  To make sure data is accurate and to eliminate data entry error, table",!,"excludes patient records whose BMI falls above or below the data check limits.",!,"See the BMI Standard Reference Table for a list of these limits."
 W !,"Prenatal patients are also excluded."
 W !,"*****   Values identified on this report as errors are 'possible' errors that"
 W !,"        deserve review but are not 'validated true errors'.",!
 I $Y>(IOSL-8) D HEAD Q:$D(APCLQUIT)
 W !,"Ages 2-19:  'At Risk for Overweight' is defined as BMI >=85th% but <95th%"
 W !?12,"'Overweight' is defined as BMI >= 95th%"
 W !,"(per National Center for Health Statistics in collaboration with the National",!,"Center for Chronic Disease Prevention and Health Promotion (2000)."
 W !!,"Ages 20-74:  'Overweight' is defined as BMI >=25.0 but <30.0."
 W !?13,"'Obese' is defined as BMI >=30.0"
 W !,"(per Clinical Guidelines on the Identification, Evaluation,"
 W !," and Treatment of Overweight and Obesity in Adults. Bethesda, Md: NHlBI, 1998)"
DONE D DONE^APCLOSUT
 K ^XTMP("APCLW2",APCLJOB,APCLBTH),APCLJOB,APCLBTH
 Q
PAT ;
 S DFN=0 F  S DFN=$O(^XTMP("APCLW2",APCLJOB,APCLBTH,"PATS",APCLSRT,DFN)) Q:DFN'=+DFN!($D(APCLQUIT))  S R=^XTMP("APCLW2",APCLJOB,APCLBTH,"PATS",APCLSRT,DFN) D
 .I $Y>(IOSL-4) D HEAD Q:$D(APCLQUIT)
 .W ! I 'APCLIDEN W $E($P(R,U),1,15),?17,$J($P(R,U,2),6)
 .W ?25,$J($P(R,U,3),5,1),?33,$J($P(R,U,4),5,1),?40,$E($P(R,U,5),4,5),"/",$E($P(R,U,5),6,7),"/",(1700+$E($P(R,U,5),1,3)),?51,$P(R,U,6),?57,$P(R,U,7),?61,$J($P(R,U,8),5,1),?70,$P(R,U,9),?77,$P(R,U,10) ; - 4 digit yr
 .;IHS/CMI/LAB
 Q
HEAD I 'APCLPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !
 S X=$P(^DIC(4,DUZ(2),0),"^")
 W !,$P(^VA(200,DUZ,0),"^",2),?(80-$L(X)/2),X,?71,"Page ",APCLPG,!
 W ?22,"RISK FOR OVERWEIGHT PATIENT LISTING "
 ;S APCLTEXT=$S(APCLRPT="T":"PATIENT LISTING",APCLRPT="V":"LIST OF OVERWEIGHT PATIENTS",APCLRPT="B":"LIST OF OBESE PATIENTS",APCLRPT="C":"LIST OF OVERWEIGHT/OBESE PATIENTS",APCLRPT="E":"LIST OF PATIENTS WITH BMI OUTSIDE EDIT RANGE",1:"HUH")
 S APCLTEXT="" I APCLRPT="E" S APCLTEXT="LIST OF PATIENTS WITH BMI OUTSIDE EDIT RANGE"
 S APCLLENG=$L(APCLTEXT)
 I $L(APCLTEXT) W !?(80-APCLLENG)/2,APCLTEXT,!
 S APCLTEXT="Report includes: "_$S(APCLSEX="B":"MALES & FEMALES",APCLSEX="F":"FEMALES",APCLSEX="M":"MALES",1:"HUH")_" / "_$S('$D(APCLAGER):"ALL AGES",1:"AGES: "_APCLAGER)
 S APCLLENG=$L(APCLTEXT) W !?(80-APCLLENG)/2,APCLTEXT
 S APCLTEXT="Report Includes: "_$S(APCLIBEN=1:"INDIAN/ALASKA NATIVES ONLY",APCLIBEN'=1:"ALL BENEFICIARIES")
 S APCLLENG=$L(APCLTEXT) W !?(80-APCLLENG)/2,APCLTEXT
 ;
 I APCLSEAT'="" S APCLTEXT="Search Template of Patients: "_$P(^DIBT(APCLSEAT,0),U)
 I APCLSEAT'="" S APCLLENG=$L(APCLTEXT) W !?(80-APCLLENG)/2,APCLTEXT
 W !,?66,"(AT RISK",!?41,"DATE OF",?69,"FOR)"
 W !,"PATIENT NAME",?17,"HRN #",?25," HT",?33," WT",?41,"WEIGHT",?51,"AGE",?56,"SEX",?61," BMI",?67,"OVERWT",?75,"OBESE"
 W !,APCL80
 Q
