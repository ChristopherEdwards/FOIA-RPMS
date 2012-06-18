ABMURSEL ; IHS/SD/SDR - UFMS Report selection ;
 ;;2.6;IHS Third Party Billing;**1**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - abm*2.6*1 - NOHEAT - Removed open/reopened status from report.
 ;   It causes errors or skews the averages on the bottom if the sessions aren't
 ;   closed.  Will now only report closed/transmitted/reconciled sessions.
 ;
SEL K DIC,DIR,ABMY
 S U="^"
 S ABMY("X")="W $$SDT^ABMDUTL(X)"
 I $D(ABM("POS")) S ABMY("POS")=ABM("POS")
 I $D(ABM("SSTAT")) M ABMY("SSTAT")=ABM("SSTAT")
 ;
LOOP ;
 ; Display current exclusion parameters
 G XIT:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 W !!?3,"EXCLUSION PARAMETERS Currently in Effect for RESTRICTING the EXPORT to:",!?3,"======================================================================="
 W !?3,"- Users..............:"
 I '$D(ABMY("USER")) W " ALL"
 E  D
 .S ABMU=0,ABMSFLG=0
 .F  S ABMU=$O(ABMY("USER",ABMU)) Q:+ABMU=0  D
 ..I ABMSFLG=1 W !
 ..W ?26,$P($G(^VA(200,ABMU,0)),U)
 ..S ABMSFLG=1
 I $D(ABMY("DT")) W !?3,"- Date Range.........: "
 I  S X=ABMY("DT",1) X ABMY("X") W "  to: " S X=ABMY("DT",2) X ABMY("X")
 I $D(ABMY("POS")) W !?3,"- POS Claims.........: ",$S(ABMY("POS")=1:"Included",1:"Excluded")
 S ABMSTAT="",ABMSFLG=0
 F  S ABMSTAT=$O(ABMY("SSTAT",ABMSTAT)) Q:ABMSTAT=""  D  Q:ABMSTAT="A"
 .W !?3,$S(ABMSFLG=0:"- Session status.....: ",1:"")
 .I ABMSTAT="A" W:ABMSFLG=1 ?26 W "ALL"
 .;I ABMSTAT="O" W:ABMSFLG=1 ?26 W "OPEN"  ;abm*2.6*1
 .I ABMSTAT="C" W:ABMSFLG=1 ?26 W "CLOSED"
 .I ABMSTAT="R" W:ABMSFLG=1 ?26 W "RECONCILED"
 .I ABMSTAT="T" W:ABMSFLG=1 ?26 W "TRANSMITTED"
 .;I ABMSTAT="S" W:ABMSFLG=1 ?26 W "REOPENED"  ;abm*2.6*1
 .S ABMSFLG=1
PARM ;
 ; Choose additional exclusion parameters
 K DIR
 S DIR(0)="SO^1:DATE RANGE;2:USERS;3:POS CLAIMS;4:SESSION STATUS"
 S DIR("A")="Select ONE or MORE of the above EXCLUSION PARAMETERS"
 S DIR("?")="The report can be restricted to one or more of the listed parameters. A parameter can be removed by reselecting it and making a null entry."
 D ^DIR
 K DIR
 G XIT:$D(DIRUT)!$D(DIROUT)
 D @($S(Y=1:"DT",Y=2:"USER",Y=3:"POS",Y=4:"STAT")_"^ABMURSL1") G LOOP
XIT ;
 G XIT2:$D(DIROUT)!$D(DTOUT)!$D(DUOUT)
 W !
 ;start old code abm*2.6*1 NOHEAT
 ;K DIR
 ;S DIR(0)="Y"
 ;S DIR("A")="Print Summary screen only"
 ;S DIR("B")="N"
 ;S DIR("?")="By selecting NO both a summary and detail will print.  If you select YES it will print the summary page ONLY"
 ;D ^DIR
 ;I '$D(DIROUT)&('$D(DIRUT)) S ABMY("SUM")=Y
 ;end old code abm*2.6*1
 S ABMY("SUM")=1  ;always summary for now  ;abm*2.6*1 NO HEAT
 ;
XIT2 ;
 K ABMY("I"),ABMY("X"),DIR
 Q
