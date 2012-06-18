DGVPTDV1 ;alb/mjk - DVBHS5 for export with PIMS v5.3; 4/21/93
 ;;5.3;Registration;;Aug 13, 1993
 ;
DVBHS5 ; ALB/JLU;Routine for HINQ screen 5; 10/04/91
 ;;V4.0;HINQ;**12,11**;03/25/92 
 N Y
 K DVBX(1)
 K DVBDIQ ;F LP2=.3611,.3616,.3612,.306,.3615,391,1901,.301,.302,.361,.36205,.3621,.36235,.3624,.36215,.3622,.36295,.3025,.303 S X="DVBDIQ(2,"_DFN_","_LP2_")" K @X
 I $D(X(1)) S DVBX(1)=X(1)
 S DIC="^DPT(",DIQ(0)="E",DIQ="DVBDIQ("
 ;S DR=".01;.09;.3611;.3616;.3612;.306;.3615;391;1901;.301;.302;.361;.36205;.3621;.36235;.3624;.36215;.3622;.36295;.3025;.303"
 S DR=".01;.09;.3611;.3616;.3612;.306;.3615;391;1901;.301;.302;.361;.36205;.36235;.36215;.36295;.3025"
 D EN^DIQ1
 I $D(DVBX(1)) S X(1)=DVBX(1) K DVBX(1)
 ;
 S DVBSCRN=5 D SCRHD^DVBHUTIL
 S DVBJS=53
 W !,"Check Amt.: ",$S($D(DVBCHECK):"$"_DVBCHECK,1:"")
 W ?28,"Combined %: ",$S($D(DVBDXPCT):DVBDXPCT_"%",1:"")
 W ?48,"Net Award Amt.: ",$S($D(DVBBAS(1)):"$"_$P(DVBBAS(1),U,20),1:"")
 I $D(DVBP(1)) S T1=$P(DVBP(1),U,4) I +T1 S T2=$O(^DVB(395.1,"B",T1,"")) I T2 S DVBENT=$P(^DVB(395.1,T2,0),U,2)_"-"_T1
 K T1,T2 W !,"Entitlement:",?15,$S($D(DVBENT):DVBENT,1:""),!,"Aid & Attendance: " I $D(DVBAAHB) S Y=DVBAAHB D AAA^DVBHQM2 W Y
 ;;;W !,"Rated (HINQ) Disabilities:" I $D(DVBDXNO),DVBDXNO'=0 D S1^DVBHQZ6
 I $D(DVBSCR) K DVBSCR D LINE Q
 ;
 W !,"--- ",DVBON,"Patient Data",DVBOFF," ---"
 W !,DVBON,"(1)",DVBOFF," Elig. Stat.: ",$E(DVBDIQ(2,DFN,.3611,"E"),1,20) X DVBLIT1
 W ?38,"Elig. Stat. ent. by: ",$E(DVBDIQ(2,DFN,.3616,"E"),1,18)
 W !,?5,"Stat. date: ",DVBDIQ(2,DFN,.3612,"E")
 W ?37,"Monetary Ben. Verif.: ",DVBDIQ(2,DFN,.306,"E")
 W !,?3,"Verif. Meth.: ",$E(DVBDIQ(2,DFN,.3615,"E"),1,50)
 W ?44,"Patient Elig.: "
 I $D(^DPT(DFN,"E",0)),+$P(^(0),U,3) F DVBOH=0:0 S DVBOH=$O(^DPT(DFN,"E",DVBOH)) I DVBOH'=+^DPT(DFN,.36) S DVBOH=$S($D(^DIC(8,DVBOH,0)):$P(^(0),U),1:"") W $E(DVBOH,1,18) Q
 W !!,DVBON,"(2)",DVBOFF," Pat. Type: ",$E(DVBDIQ(2,DFN,391,"E"),1,30) X DVBLIT1
 W ?40,"Vet. (Y/N)?: ",DVBDIQ(2,DFN,1901,"E")
 W !,?4,"Ser. Con.: ",DVBDIQ(2,DFN,.301,"E")
 W ?40,"Ser. Con. %: ",DVBDIQ(2,DFN,.302,"E")
 W !,?3,"Elig. Code: ",$E(DVBDIQ(2,DFN,.361,"E"),1,30)
 W !!,DVBON,"(3)",DVBOFF,"     A&A: ",DVBDIQ(2,DFN,.36205,"E") X DVBLIT1
 ;W ?18,"Amt.: $",$E(DVBDIQ(2,DFN,.3621,"E"),1,11)
 W ?41,"VA Pension: ",DVBDIQ(2,DFN,.36235,"E")
 ;W ?58,"Amt.: $",$E(DVBDIQ(2,DFN,.3624,"E"),1,11)
 W !,"House Bound: ",DVBDIQ(2,DFN,.36215,"E")
 ;W ?18,"Amt.: $",$E(DVBDIQ(2,DFN,.3622,"E"),1,11)
 W ?38,"VA Disability: ",DVBDIQ(2,DFN,.3025,"E")
 ;W ?58,"Amt.: $",$E(DVBDIQ(2,DFN,.303,"E"),1,11)
 W !,"Tot.Ann. VA Check Amt.: $",DVBDIQ(2,DFN,.36295,"E")
 S NEW=DVBDIQ(2,DFN,.01,"E"),NEW2=DVBDIQ(2,DFN,.09,"E") K DVBDIQ
 S DVBDIQ(2,DFN,.01,"E")=NEW,DVBDIQ(2,DFN,.09,"E")=NEW2 K NEW,NEW2 Q
LINE W !,"------------------------------------------------------------------------------"
