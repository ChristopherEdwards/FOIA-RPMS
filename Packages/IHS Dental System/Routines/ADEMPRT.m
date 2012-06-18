ADEMPRT ; IHS/HQT/MJL  - FOLLOWUP GROUP OUTPUT ;07:02 PM  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;------->INIT
 K DIS
 ;------->GET SEARCH TEMPLATE
 D TEM G:Y<1 END
 ;------->GET OUTPUT FORM
 D FORM G:'Y END
 ;------->GET HEADER
 I '$D(FLDS) D DHD G:'Y END
 I $D(FLDS),FLDS'["LET" D DHD G:'Y END
 ;------->CALL DIP
 D DIP
 ;------->END
END K ADEMDFN,ADEPAT,ADEQ,ADESUB,ADETMD,ADEDHIT Q
TEM K DIC S DIC="^DIBT(",DIC("A")="Select SEARCH TEMPLATE: ",DIC(0)="AEQMZ",DIC("S")="I $P(^(0),U,4)=9002003.2,$P(^(0),U,5)=DUZ,$D(^(""DIS""))" D ^DIC K DIC Q:Y<1
 S ADETMD=+Y,BY="["_Y(0,0)_"],.01",FR="",TO=""
 I '$D(^DIBT(ADETMD,1)) W !,"***NO DATA IN TEMPLATE***" S Y=0
 Q
DIP S DIC="^ADEFOL(" D EN1^DIP Q
FORM W !!?5,"OUTPUT FORMAT:",!,?10,"1. Letters",!,?10,"2. Standard Sorted List",!,?10,"3. Customized List",!,?5,"Select FORMAT (1-3): "
 R FLDS:DTIME S:'$T FLDS=""
 I FLDS=""!(FLDS["^") S Y=0 Q
 S FLDS=$S(FLDS=1:"[ADEMLET]",FLDS=2:"[ADEMLST]",FLDS=3:"USER",1:"")
 I FLDS="" W *7," ??" G FORM
 S Y=1,L=0
 D DHIT K:FLDS="USER" FLDS Q
 Q
DHD S Y=0 W !,"HEADING: DENTAL FOLLOWUP LIST// "
 R DHD:DTIME I '$T S DHD="^" Q
 Q:DHD["^"
 I DHD["?" W !!,?5,"Enter the Report Heading." G DHD
 S:DHD="" DHD="DENTAL FOLLOWUP LIST"
 S Y=1 Q
DHIT S Y=0 K DHIT
 I FLDS="[ADEMLET]" S ADEDHIT=" LETTER PRINTED" G DHIT1
 W !,"ACTION TO BE TAKEN: " R ADEDHIT:DTIME S:'$T ADEDHIT="^"
 Q:ADEDHIT="^"
 I $E(ADEDHIT,1,2)["?" W !,?5,"Enter the Action to be Taken based on the list you are about to print out.",!?5,"or press `RETURN' to skip." G DHIT
 I ADEDHIT="" S Y=1 Q
 I ADEDHIT="@" S DHIT="S $P(^ADEFOL(D0,0),U,6)=""""",Y=1 Q
 S ADEDHIT=" "_ADEDHIT
 S X=ADEDHIT S:X["^" X="^" X $P(^DD(9002003.2,5,0),U,5,99) I '$D(X) W *7,!?5,"ANSWER MUST BE 3-30 CHARACTERS AND NOT CONTAIN `^'" G DHIT
DHIT1 S DHIT="S $P(^ADEFOL(D0,0),U,6)=$E(DT,4,5)_""/""_$E(DT,6,7)_""/""_$E(DT,2,3)_"_$C(34)_ADEDHIT_$C(34)
 S Y=1 K X Q
