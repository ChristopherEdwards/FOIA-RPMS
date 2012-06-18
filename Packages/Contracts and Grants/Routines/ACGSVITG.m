ACGSVITG ;IHS/OIRM/DSD/THL,AEF - CHECK INTEGRITY OF VENDORS; [ 03/27/2000   2:22 PM ]
 ;;2.0t1;CONTRACT INFORMATION SYSTEM;;FEB 16, 2000
 ;;CHECK INTEGRITY OF VENDOR DATA PRIOR TO CONTRACT EDIT
INTEG ;EP;TO CHECK INTEGRITY OF VENDOR DATA
 F  D I1 Q:'$D(ACGVND)!$D(ACGQUIT)
 K ACG,ACG10,ACG11,ACG13,ACG30,ACG6,ACG7,ACG8,ACG9,ACGD0,ACGDA,ACGGL,ACGSP27,ACGSP29,ACGGL
 Q
I1 S ACGVND=$S($D(^AUTTVNDR(ACG5DA,11)):^(11),1:""),ACG11=$P(ACGVND,U,13),ACG13=$P(ACGVND,U,26),ACG10=$P(ACGVND,U,16),ACGGL=$P(ACGVND,U,25),ACG30=$P(ACGVND,U,15),ACGSP27=$P(ACGVND,U,27),ACGSP28=$P(ACGVND,U,28),ACGVND=$S($D(^(13)):^(13),1:"")
 S ACG6=$P(ACGVND,U),ACG7=$P(ACGVND,U,2),ACG8=$P(ACGVND,U,3),ACG9=$P(ACGVND,U,4)
 K ACGVND
 I $D(ACG1DA),ACG1DA'=15&(ACG1DA'=17) D
 .I ACG10="" S ACGVND(10)="Contractor's CONGRESSIONAL DISTRICT is missing."
 .I ACG10'="",ACG10'?3N S ACGVND(10)="Contractors's CONGRESSIONAL DISTRICT is incorrect."
 .I ACGGL="" S ACGVND(25)="Contractor's GEOGRAPHICAL LOCATION is missing."
 .I ACG13="" S ACGVND(13)="Contractor's TYPE OF BUSINESS is missing."
 .I ACG30="" S ACGVND(30)="Contractor's WOMEN OWNED STATUS is missing."
 I $D(ACG1DA),ACG1DA=15!(ACG1DA=17) D
 .I ACGSP27="" S ACGVND(27)="Contractor's SMALL PURCHASE TYPE OF BUSINESS is missing."
 .I ACGSP28="" S ACGVND(28)="Contractor's SMALL PURCHASE TYPE OF VENDOR is missing."
 I ACG11="" S ACGVND(11)="Contractor's EIN NO. is missing."
 I ACG11'="","12"'[$E(ACG11) S ACGVND(11)="Contractor's EIN NO. is incorrect.  First character must be 1 or 2."
 I ACG11'="",$E(ACG11,1,10)'?10N S ACGVND(11)="The first 10 characters of the EIN NO. must be numeric starting with 1 or 2."
 I ACG11'="",$E(ACG11)=1,$E(ACG11,11)'?1U!($E(ACG11,12)'?1N) S ACGVND(11)="Contractor's EIN SUFFIX must be one capital letter and one number."
 I ACG11'="",$E(ACG11)=2,$E(ACG11,11,12)'="" S ACGVND(11)="Contractor's EIN SUFFIX must be null when EIN begins with a 2."
 I ACG6="" S ACGVND(6)="Contractor's STREET address is missing."
 I ACG7="" S ACGVND(7)="Contractor's CITY address is missing."
 I ACG8="" S ACGVND(8)="Contractor's STATE address is missing."
 I ACG9="" S ACGVND(9)="Contractor's ZIP CODE is missing."
 Q:'$D(ACGVND)
VEDIT I $D(ACGVND(10))!$D(ACGVND(25)) D GL
 W !
 S ACG=0
 F  S ACG=$O(ACGVND(ACG)) Q:'ACG  W *7,!,ACGVND(ACG)
 W !!,"Data listed above must be corrected before using this contractor."
 S DIR(0)="YO",DIR("A")="Correct data now",DIR("B")="YES" W ! D DIR^ACGSDIC I Y'=1 S ACGQUIT="" Q
 S Y=ACG5DA
 I $D(ACG1DA),ACG1DA=15!(ACG1DA=17) D SP4^ACGSVEND Q
 D EN4^ACGSVEND
 Q
GL I ACGGL="" W !!,*7,ACGVND(25)
 I ACG10="" S ACGVND(10)="Contractor's CONGRESSIONAL DISTRICT is missing."
 I ACG10'="",ACG10'?3N S ACGVND(10)="Contractors's CONGRESSIONAL DISTRICT is incorrect."
 W !!,"Geographical location data must be checked before you can continue."
 I ACGGL="" W !,"Next you must select the Contractor's Geographical Location and review all data."
 D HOLD^ACGSMENU
 I ACGGL="" D G11^ACGSPARA Q
 I ACGGL'="",'$D(^AUTTGL(ACGGL,0)) D G11^ACGSPARA Q
 I ACGGL'="",$D(^AUTTGL(ACGGL,0)) S Y=ACGGL D G2^ACGSPARA Q
 Q
DIR D ^DIR S:$D(DIRUT) ACGQUIT="" K DIR,DIRUT,DUOUT,DTOUT Q
