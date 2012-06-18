BRNRU21 ; IHS/OIT/LJF - SCREEN LOGIC CODE BY FIELD TYPE
 ;;2.0;RELEASE OF INFO SYSTEM;*1*;APR 10, 2003
 ;IHS/OIT/LJF 10/25/2007 PATCH 1 - aded this routine
 ;
Q ;EP; Qman fields
 K AMQQTAXN,DIC,X,Y,DD
 K ^XTMP("BRNVL",$J,"QMAN"),^UTILITY("AMQQ TAX",$J)
 S X=$P(^BRNSORT(BRNCRIT,0),U,3),DIC="^AMQQ(5,",DIC(0)="EQXM",DIC("S")="I $P(^(0),U,14)"
 D ^DIC K DIC,DA,DINUM,DICR I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" Q
 S BRNQMAN=+Y
 ;
 D ^AMQQGTX0(BRNQMAN,"^XTMP(""BRNVL"",$J,""QMAN"",")
 I '$D(^XTMP("BRNVL",$J,"QMAN")) W !!,$C(7),"** No ",$P(^BRNSORT(BRNCRIT,0),U)," selected, all will be included." Q
 I $D(^XTMP("BRNVL",$J,"QMAN","*")) K ^XTMP("BRNVL",$J,"QMAN")
 K BRNBQC1 I $G(BRNBQC),$P($G(^BRNSORT(BRNCRIT,90182)),U,5)=1,$G(AMQQTAXN)]"" S BRNBQC1="" D TAXV Q:BRNBQC1=""
 S ^BRNRPT(BRNRPT,11,BRNCRIT,0)=BRNCRIT,^BRNRPT(BRNRPT,11,"B",BRNCRIT,BRNCRIT)=""
 ;
 I $G(BRNBQC1)="T" D
 . S ^BRNRPT(BRNRPT,11,BRNCRIT,11,1,0)="["_AMQQTAXN
 . S ^BRNRPT(BRNRPT,11,BRNCRIT,11,"B","["_$P(AMQQTAXN,U),1)=""
 . S ^BRNRPT(BRNRPT,11,BRNCRIT,11,0)="^90264.8110101A^1^1"
 E  D
 . S X="",Y=0 F  S X=$O(^XTMP("BRNVL",$J,"QMAN",X)) Q:X=""  D
 . . S Y=Y+1,^BRNRPT(BRNRPT,11,BRNCRIT,11,Y,0)=X
 . . S ^BRNRPT(BRNRPT,11,BRNCRIT,11,"B",X,Y)=""
 . . S ^BRNRPT(BRNRPT,11,BRNCRIT,11,0)="^90264.8110101A^"_Y_"^"_Y
Q1 K X,Y,Z,BRNQMAN,V,AMQQSQNM,AMQQTAXN
 K ^XTMP("BRNVL",$J,"QMAN")
 Q
 ;
TAXV ;for query cloning
 W !!,"You entered a taxonomy name for this item.  ["_$P(AMQQTAXN,U)_"]"
 W !,"You have the option of sending the name of the taxonomy to each site and have"
 W !,"the taxonomy resolved at the site OR to send the individual coded values"
 W !,"for this taxonomy.",!
 S DIR(0)="S^T:Taxonomy Name (this taxonomy must reside at each site);V:Values in this Taxonomy"
 S DIR("A")="Which do you wish to send for this item",DIR("B")="T" KILL DA
 D ^DIR KILL DIR
 I $D(DIRUT) W !,"exiting......start over.." Q
 S BRNBQC1=Y
 Q
 ;
R ;EP; Reader fields
 NEW DIR,DUOUT,DIRUT,Y
 S DIR(0)=$P(^BRNSORT(BRNCRIT,0),U,4)_"O",DIR("A")="ENTER "_$P(^(0),U)
 D ^DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:Y=-1
 I Y="" Q
 S ^BRNRPT(BRNRPT,11,BRNCRIT,0)=BRNCRIT,^BRNRPT(BRNRPT,11,"B",BRNCRIT,BRNCRIT)=""
 S BRNCNT=BRNCNT+1,^BRNRPT(BRNRPT,11,BRNCRIT,11,BRNCNT,0)=$P(Y,U)
 S ^BRNRPT(BRNRPT,11,BRNCRIT,11,"B",$P(Y,U),BRNCNT)=""
 S ^BRNRPT(BRNRPT,11,BRNCRIT,11,0)="^90264.8110101A^"_BRNCNT_"^"_BRNCNT
 D R
 Q
 ;
D ;EP; date fields
BD ;get beginning date
 W ! S DIR(0)="D^::EP",DIR("A")="Enter beginning "_BRNTEXT_" for Search" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) Q
 S BRNBDAT=Y
ED ;get ending date
 W ! S DIR(0)="D^"_BRNBDAT_"::EP",DIR("A")="Enter ending "_BRNTEXT_" for Search"
 S Y=BRNBDAT D DD^%DT S DIR("B")=Y,Y=""
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S BRNEDAT=Y
 S X1=BRNBDAT,X2=-1 D C^%DTC S BRNSDAT=X
 ;
 S ^BRNRPT(BRNRPT,11,BRNCRIT,0)=BRNCRIT,^BRNRPT(BRNRPT,11,"B",BRNCRIT,BRNCRIT)=""
 S BRNCNT=0,^BRNRPT(BRNRPT,11,BRNCRIT,11,BRNCNT,0)="^90264.8110101A^1^1"
 S BRNCNT=BRNCNT+1,^BRNRPT(BRNRPT,11,BRNCRIT,11,1,0)=BRNBDAT_U_BRNEDAT,^BRNRPT(BRNRPT,11,BRNCRIT,11,"B",BRNBDAT,BRNCNT)=""
 Q
 ;
N ;EP; numeric fields
 K ^BRNRPT(BRNRPT,11,BRNCRIT),^BRNRPT(BRNRPT,11,"B",BRNCRIT)
 S DIR(0)="FO^1:20"
 S DIR("A")=$S($G(^BRNSORT(BRNCRIT,28))]"":^BRNSORT(BRNCRIT,28),1:"Enter a Range of numbers (e.g. 5-12,1-1)")
 S DIR("?")=$S($G(^BRNSORT(BRNCRIT,27))]"":^BRNSORT(BRNCRIT,27),1:"Enter a range of number (e.g. 5-12, 1-1)")
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !!,"No numeric range entered.  All numerics will be included." Q
 I $D(^BRNSORT(BRNCRIT,25)) S X=Y X ^(25) I '$D(X),$D(^BRNSORT(BRNCRIT,26)) W !! X ^(26) G N ;if input tx exists and fails G N
 I '$D(^BRNSORT(BRNCRIT,25)),Y'?1.3N1"-"1.3N W !!,$C(7),$C(7),"Enter a numeric range in the format nnn-nnn.  E.g. 0-5, 0-99, 5-20." G N
 S ^BRNRPT(BRNRPT,11,BRNCRIT,0)=BRNCRIT,^BRNRPT(BRNRPT,11,"B",BRNCRIT,BRNCRIT)=""
 S ^BRNRPT(BRNRPT,11,BRNCRIT,11,0)="^90264.8110101A^1^1"
 S ^BRNRPT(BRNRPT,11,BRNCRIT,11,1,0)=$P(Y,"-"),^BRNRPT(BRNRPT,11,BRNCRIT,11,"B",$P(Y,"-"),1)=""
 S $P(^BRNRPT(BRNRPT,11,BRNCRIT,11,1,0),U,2)=$P(Y,"-",2)
 Q
 ;
F ;EP; free text range
 K ^BRNRPT(BRNRPT,11,BRNCRIT),^BRNRPT(BRNRPT,11,"B",BRNCRIT)
 S DIR(0)="FO^1:40",DIR("A")="Enter a Range of Characters for Search (e.g. A:B) "
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !!,"No range entered.  All ",BRNTEXT,"  will be included." Q
 I $D(^BRNSORT(BRNCRIT,21)) S X=Y X ^(21) I '$D(X),$D(^BRNSORT(BRNCRIT,22)) W !! X ^(22) G F ;if input tx exists and fails G N
 I '$D(^BRNSORT(BRNCRIT,21)),Y'?1.ANP1":"1.ANP D  G F
 . W !!,$C(7),$C(7),"Enter an free text range in the format AAA:AAA.  E.g. 94-01:94-200,CA:CZ, A:Z."
 S ^BRNRPT(BRNRPT,11,BRNCRIT,0)=BRNCRIT,^BRNRPT(BRNRPT,11,"B",BRNCRIT,BRNCRIT)=""
 S BRNCNT=0,^BRNRPT(BRNRPT,11,BRNCRIT,11,BRNCNT,0)="^90264.8110101A^1^1"
 S BRNCNT=BRNCNT+1,^BRNRPT(BRNRPT,11,BRNCRIT,11,1,0)=$P(X,":")_U_$P(X,":",2)
 S ^BRNRPT(BRNRPT,11,BRNCRIT,11,"B",$P(X,":"),BRNCNT)=""
 Q
 ;
J ;EP Just a hit
 S ^BRNRPT(BRNRPT,11,BRNCRIT,0)=BRNCRIT,^BRNRPT(BRNRPT,11,"B",BRNCRIT,BRNCRIT)=""
 S ^BRNRPT(BRNRPT,11,BRNCRIT,11,1,0)=1,^BRNRPT(BRNRPT,11,BRNCRIT,11,"B",1,1)=""
 S ^BRNRPT(BRNRPT,11,BRNCRIT,11,0)="^90264.8110101A^"_1_"^"_1
 Q
 ;
C ;EP; Contains
 W !!,"Enter a string which will be searched for in the narrative text."
 W !,"The system will check for any narrative that contains this string.",!
 K ^BRNRPT(BRNRPT,11,BRNCRIT),^BRNRPT(BRNRPT,11,"B",BRNCRIT)
 S DIR(0)="FO^1:40",DIR("A")="Enter a String of Characters for Search (e.g. DIABETES) "
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !!,"No range entered.  All ",BRNTEXT,"  will be included." Q
 S ^BRNRPT(BRNRPT,11,BRNCRIT,0)=BRNCRIT,^BRNRPT(BRNRPT,11,"B",BRNCRIT,BRNCRIT)=""
 S BRNCNT=0,^BRNRPT(BRNRPT,11,BRNCRIT,11,BRNCNT,0)="^90264.8110101A^1^1"
 S BRNCNT=BRNCNT+1,^BRNRPT(BRNRPT,11,BRNCRIT,11,1,0)=X,^BRNRPT(BRNRPT,11,BRNCRIT,11,"B",X,BRNCNT)=""
 Q
 ;
Y ;EP - Yes/No field
 S DIR(0)="S^1:"_BRNTEXT_";0:NOT "_BRNTEXT_""
 S DIR("A")="Include disclosure requests with",DIR("B")="1"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:Y=""
 S ^BRNRPT(BRNRPT,11,BRNCRIT,0)=BRNCRIT,^BRNRPT(BRNRPT,11,"B",BRNCRIT,BRNCRIT)=""
 S ^BRNRPT(BRNRPT,11,BRNCRIT,11,1,0)=Y,^BRNRPT(BRNRPT,11,BRNCRIT,11,"B",Y,1)=""
 S ^BRNRPT(BRNRPT,11,BRNCRIT,11,0)="^90264.8110101A^"_1_"^"_1
 Q
 ;
S ;EP ;special logic for hard coded lookups
 X ^BRNSORT(BRNCRIT,5)
 Q
