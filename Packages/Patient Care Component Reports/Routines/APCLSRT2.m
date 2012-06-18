APCLSRT2 ; IHS/CMI/LAB - GETS SORT INFO FOR PCC REPORTS ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
CHKVARS ;EP
 K APCLQUIT
 I '$D(APCLFILE)!('$D(APCLPTMP))!('$D(APCLRPT)) W !,"Required variables do not exist to run this report!!  Notify programmer!",$C(7),$C(7),! S APCLQUIT="" Q
 S APCLPTMP=$O(^DIPT("B",APCLPTMP,""))
 I '$D(APCLPTMP)!(APCLPTMP="") W !,$C(7),$C(7),"Template does not exist!  Notify programmer" S APCLQUIT="" Q
 I '$D(^DIC(APCLFILE)) W !,$C(7),$C(7),"File number passed is Invalid!  Notify programmer!",!! S APCLQUIT="" Q
INIT S FLDS="[`"_APCLPTMP_"]",BY="",FR="",TO="",APCLN=1,APCLMAND=99,APCLCSTG="^99^"
CURRENT S IOP=0 D ^%ZIS K IOP
 I $D(IOST(0)) S APCLTRM=$S($D(^%ZIS(2,IOST(0),5)):^(5),1:X),APCLRVON=$S($P(APCLTRM,U,4)]"":$P(APCLTRM,U,4),1:""),APCLRVOF=$S($P(APCLTRM,U,5)]"":$P(APCLTRM,U,5),1:"")
 S:'$D(APCLRVON) (APCLRVON,APCLRVOF)=""
 Q
 ;
 ;
 ;HOLD CODE FOR LATER
