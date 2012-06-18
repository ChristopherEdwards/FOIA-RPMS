ANSEAL ;IHS/OIRM/DSD/CSC - ENTER/EDIT ACUITY LEVELS; [ 02/25/98  10:32 AM ]
 ;;3.0;NURSING PATIENT ACUITY;;APR 01, 1996
 ;;ENTER/EDIT ACUITY LEVELS
 I ANSCL="" D XB1 Q
EN S DIR(0)="YO",DIR("A")="Edit All Categories",DIR("B")="YES"
 S DIR("?",1)="You May Select Individual Care Categories To Edit Or"
 S DIR("?")="Have The Computer 'Loop' Thru Each One Automatically."
 W !
 D DIR^ANSDIC
 Q:$D(DTOUT)!$D(DUOUT)
 I Y=1 D XB1 Q
 F  D A2 Q:$D(DTOUT)!$D(DUOUT)
 K DUOUT
 Q
A2 W !
 K DIC
 S DIC("A")="Edit Category: "
 S DIC="^ANSD(59,",DIC(0)="AEMQZ"
 W !
 D DIC^ANSDIC
 I +Y<1 S DUOUT="" Q
 S ANSP=+Y,ANSA=$P(Y,U,2),ANSL=$P(Y(0),U,2)
 D SB1
 Q
XB1 ;EP;EDIT ALL CATEGORIES
 S ANSP=0
 F  S ANSP=$O(^ANSD(59,ANSP)) Q:'ANSP!$D(DTOUT)!$D(DUOUT)  I $D(^ANSD(59,ANSP,0)) S ANSA=$P(^(0),U),ANSL=$P(^(0),U,2) D
 .W !!,ANSA
 .D SB1
 .I $D(DUOUT) Q:ANSP=1  S ANSP=ANSP-2
 Q
SB1 ;EDIT CARE LEVEL FOR SPECIFIED CATEGORY
 S L=$P(ANSCL,U,ANSP)
 S DIR(0)="N^1:"_ANSL,DIR("?")="^D S1Q^ANSEAL",DIR("A")="Care Level"
 S:L]"" DIR("B")=L
 D DIR^ANSDIC
 Q:$D(DTOUT)!$D(DUOUT)
 S:Y'>ANSL $P(ANSCL,U,ANSP)=Y
 Q
S1Q ;EP;TO DISPLAY CARE LEVEL DESCRIPTIONS FOR CATEGORY
 W !,"  Enter A Number From 1 to ",$G(ANSL)," to Indicate The Care Required",!,"  In This Category Given The Following Descriptions:",!
 S ANC=$G(ANSP)
 D ^ANSUDW
 W !!,ANSA
 Q
