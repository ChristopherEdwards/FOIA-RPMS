INHMGD5 ;CAR; 7 Jul 97 10:42;HL7 MESSAGING - USER INPUT TO SENSITIVITY ANALYSIS
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; MODULE NAME:
 ; HL7 Messaging - User Input to Sensitivity Analysis (INHMGD5).
 ;
SENSINP(INSENS) ;User input module for Sens field/file
 ; Purpose:
 ;   This module is used to query the user for Field and File
 ;   names or numbers to be looked up and reported on by the
 ;   Sensitivity Analysis routine.
 ; Input:
 ;   INSENS = Used merely as a flag on input
 ; Output:
 ;   INSENS = An array to hold the requested File and Field numbers
 ;            the format is: INSENS(FILE#,FIELD#)=""
 ;   DUOUT  = Normally doesn't exist, use $G(DUOUT) when checking
 ;            Contains 1 when user "^" out of query, or 2 when user
 ;            "timed-out" and 3 when user "^^" out of query.
 ;
 ;D ^UTSRD("query: ;;;;default;;;;;;;;;DUOUT",1) ;new format
 ;
 N DIC,INJ,INL,INF,INFIL,INFOLD,INFLD,INFLDT,INHLP,INDONE
 K DIC
 ;
 S INHLP=" " ;add "^ D ...." to execute code
 S INHLP(1)="Enter the CHCS/Fileman Field:File as numbers or names"
 S INHLP(2)="Use a comma (,) to separate multiple Field:File requests"
 S INHLP(3)="If you omit the file name/number entirely, you will be"
 S INHLP(4)="asked for the first one, the rest will assume the same"
 S INHLP(5)="file#, until you supply another one."
 S (INFIL,INFOLD)=0
 F  D  Q:X=""!$G(DUOUT)
 .W ! D UTSRD("Enter CHCS Field:File[,Field:File,...]: ",.INHLP)
 .Q:X=""!$G(DUOUT)  ;terminates repeated entries
 .;save the text, since we'll be using X:
 .S INL=X
 .;validate each entry (separated by ","):
 .F INJ=1:1:$L(INL,",") D  I $G(DUOUT) K:$G(DUOUT)'=3 DUOUT Q
 ..;extract field & file name/number and go into verify loop
 ..S INF=$P(INL,",",INJ) Q:'$L(INF)
 ..S INFLD=$P(INF,":"),INFIL=$P(INF,":",2),INDONE=0
 ..S INDONE=0 F  D  Q:INDONE!$G(DUOUT)  ;loop till it's right or ^quit
 ...D  I $G(DUOUT) K:$G(DUOUT)'=3 DUOUT Q
 ....S INF=INFIL,INFIL=0
 ....I '$L(INF),INFOLD S INFIL=INFOLD Q  ;use file# from last time
 ....I INF,$D(^DIC(+INF,0))!$D(^DD(+INF,0)) S (INFOLD,INFIL)=INF Q
 ....I $L(INF) D
 .....;may have a file NAME, do quiet lookup for number
 .....K DIC S DIC="^DIC(",DIC(0)="FMZ",X=INF D ^DIC
 .....I Y>0 S (INFIL,INFOLD)=+Y ;found it
 ...;-----------------------------
 ...;now, validate the field name:
 ...I $L(INFLD),INFIL D  Q:Y>0
 ....;make sure this is the name of a field; quiet lookup
 ....K DIC S X=INFLD,DIC="^DD("_INFIL_",",DIC(0)="FMZ"
 ....D ^DIC
 ....;report success
 ....I Y>0 S INFLD=+Y D  S INDONE=1 Q
 .....S INFLDT=Y(0,0)
 .....S INFILT=$P($G(^DIC(INFIL,0)),U)
 .....I INFILT="" S INFILT=$P($G(^DD(INFIL,0)),U)
 .....W !,?5,"Found Field#: "_INFLD_", ("_INFLDT_") in file#: "_INFIL_" "_$S($D(^DIC(INFIL,0)):$P(^(0),U),1:$P($G(^DD(INFIL,0)),U))
 .....S INSENS(INFIL,INFLD)=""
 ...;lookup didn't work, re-ask the user for file and field
 ...W !,?5,"Could NOT find Entry# "_INJ_", Field/File: "_INFLD_":"_INFIL
 ...K DIC S DIC="^DIC(",DIC(0)="AEMQZ"
 ...I INFIL,$D(^DIC(+INFIL,0)) S DIC("B")=+INFIL
 ...S DIC("A")="Re-enter CHCS File (?? for list) or ^out: "
 ...D ^DIC
 ...I Y>0 D
 ....S (INFIL,INFOLD)=+Y
 ....;see if user wants sub-file
 ....K DIC S DIC="^DD("_+Y_",",DIC(0)="AEMQZ"
 ....S DIC("S")="I $P(^(0),U,2)"
 ....S DIC("A")="Select SUB-FILE: "
 ....D ^DIC I Y>0 S (INFIL,INFOLD)=+$P(Y(0),U,2)
 ...Q:$G(DUOUT)
 ...K DIC S DIC="^DD("_INFIL_",",DIC(0)="ACEQMZ"
 ...S DIC("A")="Re-enter Field (?? for list) or ^out: "
 ...I INFIL,INFLD,$D(^DD(INFIL,INFLD,0)) S DIC("B")=+INFLD
 ...D ^DIC I Y>0 S INFLD=+Y
 Q
 ;
UTSRD(DIR,DIRH) ;adds arrayed help(for ?) and options(for ??) to D ^UTSRD(p1,p2)
 ; Inputs
 ;   DIR  = $p;1 is prompt, $p;5 is default, auto sets $p;14 to DUOUT
 ;   DIRH = "^ code to list options,...?", DIRH(1)..DIRH(n) = help text
 ;
 ;set up DUOUT as variable to receive exit status from reader
 S $P(DIR,";",14)="DUOUT"
 ;set up request to ^UTSRD to return any help, ? or ?? requests.
 F  D ^UTSRD(DIR,1) Q:X'["?"!$G(DUOUT)  D
 .;check if request is to execute some code (??) or (?) for help text.
 .I $E(X,1,3)["??",$D(DIRH)#2,$E(DIRH)="^" D  Q
 ..X $E(DIRH,2,999)
 .;else, write any documentation; ?? falls through to ? if no code to X
 .N INJ S INJ=0 F  S INJ=$O(DIRH(INJ)) Q:'INJ  W !,DIRH(INJ)
 .W !
 Q
 ;
