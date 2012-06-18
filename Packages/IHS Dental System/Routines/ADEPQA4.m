ADEPQA4 ; IHS/HQT/MJL - REVIEW PARAMETERS ;08:38 PM  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;
CHK() ;EP - Returns 1 if user says parameters ok, otw 0
 W !
 N DIR
 K DIR
 S DIR(0)="Y",DIR("B")="YES",DIR("A")="Do you want to review your search parameters" D ^DIR
 I $$HAT^ADEPQA() Q 0
 I Y'=1 Q 1
 D CHK2
 K DIR
 W ! S DIR(0)="Y",DIR("B")="YES",DIR("A")="Do you want continue with this search" D ^DIR
 I $$HAT^ADEPQA() Q 0
 I Y'=1 Q 0
 Q 1
 ;
CHK2 W !!,"This search includes dental visits which meet the following specifications:",!!
 I ADESTP,$D(^DIBT($P(ADESTP,U,2),0)) W !,"Limited to entries in the ",$P(^DIBT($P(ADESTP,U,2),0),U)," Template."
 I ADEDATE D
 . N Y
 . W !,"Limited to visits between "
 . S Y=$P(ADEDATE,U,2) X ^DD("DD") W Y
 . W " and "
 . S Y=$P(ADEDATE,U,3) X ^DD("DD") W Y
 I ADEAGE W !,"Limited to patients whose AGE AT TIME OF VISIT was between ",$P(ADEAGE,U,2)," and ",$P(ADEAGE,U,3)," (inclusive)."
 I ADEPROV W !,"Limited to the following ATTENDING DENTISTS:",!,?5 D
 . N ADEJ
 . F ADEJ=1:1:$L($P(ADEPROV,U,2),",") W $P(^DIC(16,$P(^DIC(6,$P($P(ADEPROV,U,2),",",ADEJ),0),U),0),U),"  "
 I ADEHYG W !,"Limited to the following HYGIENISTS/THERAPISTS:",!,?5 D
 . N ADEJ
 . F ADEJ=1:1:$L($P(ADEHYG,U,2),",") W $P(^DIC(16,$P(^DIC(6,$P($P(ADEHYG,U,2),",",ADEJ),0),U),0),U),"  "
 I ADELOC W !,"Limited to the following LOCATIONS:",!,?5 D
 . N ADEJ
 . F ADEJ=1:1:$L($P(ADELOC,U,2),",") W $P(^DIC(4,$P($P(ADELOC,U,2),",",ADEJ),0),U),"  "
 ;
 I ADEADA(1) D
 . N ADESCN S ADESCN=ADEADA(1)
 . I $P(ADESCN,U,2)]"" W !,"Limited to the following ADA CODES:",!,?5 D
 . . N ADEJ
 . . F ADEJ=1:1:$L($P(ADESCN,U,2),",") W $P(^AUTTADA($P($P(ADESCN,U,2),",",ADEJ),0),U),"  "
 . I $P(ADESCN,U,7)]"" W !,"Limited to the following OPERATIVE SITES:",!,?5 D
 . . F ADEJ=1:1:$L($P(ADESCN,U,7),",") W $P(^ADEOPS($P($P(ADESCN,U,7),",",ADEJ),88),U),"  "
 . I $P(ADESCN,U,3)]"" D
 . . W !
 . . I $P(ADESCN,U,4)]"" W "NOT "
 . . W "Followed "
 . . I $P(ADESCN,U,6)]"" W "on the SAME Operative Site "
 . . I $P(ADESCN,U,5)]"" W "within ",$P(ADESCN,U,5)," days "
 . . W "by these ADA CODES: " W !,?5 D
 . . . F ADEJ=1:1:$L($P(ADESCN,U,3),",") W $P(^AUTTADA($P($P(ADESCN,U,3),",",ADEJ),0),U),"  "
 . . W !,"Codes on the same visit ",$S($P(ADESCN,U,8)="Y":"WILL",1:"will NOT")," be included as 'FOLLOWED BY' codes."
 Q
 K ADESCN ;*NE
