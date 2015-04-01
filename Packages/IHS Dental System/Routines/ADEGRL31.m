ADEGRL31 ; IHS/HQT/MJL - DENTAL ENTRY PART 5 ;  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;**26**;APRIL 1999;Build 13
 ;;IHS/OIT/GAB 10.2014 Modified for 2015 Code Updates - PATCH 26
DEL ;EP
 Q:'$D(ADEV)  D LIST^ADEGRL3
D1 W !!,"DELETE WHICH CODE? "
 R X:DTIME S:'$T X="^"
 Q:X=""!(X="^")
 I X["?" W !,?5,"ENTER AN ADA CODE FROM THE ABOVE LIST TO DELETE",!,?10,"OR PRESS 'RETURN' TO DELETE NOTHING" G D1
 I '$D(ADEV(X)) W *7,"??" G D1
 K ADEV(X),ADEDES(X)
 Q
EXIT ;EP
 I (X="^Q")!(X="^") S ADENOUPD=1,Y=1 W !!,?20,"***DATA ENTRY ABORTED***",*7 H 1 Q
 I ADELOED']"" W !,*7,"YOU MUST ENTER A LOCATION OF ENCOUNTER. ENTER ^L AT THE 'Select ADA CODE",!,"(or Action)' PROMPT TO EDIT LOCATION OF ENCOUNTER." D CON S Y=0 Q
 I ADERDNMD']"" W !,*7,"YOU MUST ENTER AN ATTENDING DENTIST. ENTER ^D AT THE 'Select ADA CODE,",!,"(or Action)' PROMPT TO EDIT ATTENDING DENTIST." D CON S Y=0 Q
 ;/IHS/OIT/GAB 11.2014 Patch #26 Removed below line to add 2015 codes 9986 & 9987 (cancelled or missed appt.) 
 ;I '$D(ADEV("0000")),'$D(ADEV("0190")),'$D(ADEV("9130")),'$D(ADEV("9140")) W !,*7,"You must enter a VISIT STATUS Code, either 0000, 0190, 9130, or 9140." D CON S Y=0 Q
 ;/IHS/OIT/GAB 11.2014 Patch #26 Added below line to change to 9986 & 9987 for 2015 code updates
 I '$D(ADEV("0000")),'$D(ADEV("0190")),'$D(ADEV("9130")),'$D(ADEV("9140")),'$D(ADEV("9986")),'$D(ADEV("9987")) W !,*7,"You must enter a VISIT STATUS Code, either 0000, 0190, 9986, or 9987." D CON S Y=0 Q
 ;PROMPT FOR FINISH CONFIRMATION HERE
 D HYGCHK
 D CHK Q:'Y
 S Y=1 Q
 ;
CHK W !!,"Ready to file this record" S %=2 D YN^DICN
 I %Y["?" W !,?5,"Enter `Y' to save this visit permanently in the computer",!,?5,"Enter `N' to go back and continue editing the visit." G CHK
 I %=1 S Y=1 Q
 I %=2 S Y=0 Q
 S Y=0 Q
 ;
HYGCHK ;
 Q:ADEPVNM]""
 N DIR,ADEFLG,ADEGRP,ADEJ
 S ADEFLG=0 S ADEGRP=$O(^ADEDIT("GRP","B","HYG/THER DATA ENTRY CHECK",0)),ADEGRP=^ADEDIT("GRP",ADEGRP,1) D
 . F ADEJ=1:1:$L(ADEGRP,"|") I $D(ADEV($P(ADEGRP,"|",ADEJ))) S ADEFLG=1 Q
 Q:'ADEFLG
 S DIR(0)="Y",DIR("A",1)="Some of the procedures entered are often performed by a HYGIENIST/THERAPIST."
 S DIR("A")="Do you want to add a HYGIENIST/THERAPIST for this visit"
 S DIR("B")="YES"
 D ^DIR
 I $$HAT^ADEGRL1()!(Y'=1)!(X[U) Q
 D PROV^ADEGRL4
 Q
 K ADEGRP ;*NE
 ;
TFEE ;EP
 W !,"TOTAL CHARGE THIS VISIT: ",$J(ADETCH,4,2),"// "
 R X:DTIME
 I X="" S Y=1 Q
 I X["?" W !,"ENTER THE TOTAL CHARGE FOR THIS VISIT" G TFEE
 I X["^" S Y=0 Q
 S:X["$" X=$P(X,"$",2) I X'?.N.1".".2N!(X>9999)!(X<0) K X W *7," ??" G TFEE
 S ADETCH=X,ADETCHF=1,Y=1 Q
CON R !,"(Press ENTER to continue) ",X:DTIME K X Q
FEE ;EP
 W !,"FEE: "
 S ADEDEF=$S($D(ADEV(ADECOD)):$P(ADEV(ADECOD),U,3),1:"") W:ADEDEF]"" ADEDEF,"// "
 R ADEFEE:DTIME S:'$T ADEFEE="^"
 S:ADEFEE="" ADEFEE=+ADEDEF
 I ADEFEE["?" S ADEHOLD=Y(0),XQH="ADE-DVIS-CDV-FEES" D EN^XQH,LIST^ADEGRL3 W !,"ADA Code: ",ADECOD S Y(0)=ADEHOLD K ADEHOLD,XQH G FEE
 I ADEFEE["^" S ADEY=0 Q
 S:ADEFEE["$" ADEFEE=$P(ADEFEE,"$",2) I ADEFEE'?.N.1".".2N!(ADEFEE>9999)!(ADEFEE<0) K ADEFEE W *7," ??" G FEE
 S $P(ADEV(ADECOD),U,3)=ADEFEE
 Q
