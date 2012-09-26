APSPPDEA ;IHS/MSC/MGH - PROVIDER DEA REPORT ;21-Oct-2011 09:16;MGH
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1013**;Sep 23, 2004;Build 33
EN ;EP
 N APSPTYP,APSPNUM,APSPTERM,APSPQ,APSPDR,APSPDARY,APSPNAME,QFLG,APSPCNT
 S (APSPQ,APSPTYP)=""
 S APSPCNT=0
 ;All or individual providers
 W @IOF
 W !,"Provider IEN Report",!!
 S APSPNUM=$$DIR^APSPUTIL("S^I:Individual Provider;A:All Providers","Lookup Individual Provider or List ALL Providers? ","A",,.APSPQ)
 Q:APSPQ
 I APSPNUM="I" D
 .F  D  Q:QFLG
 ..S APSPDR=$$GETIEN1^APSPUTIL(200,"Select Provider: ",-1,"B")
 ..I APSPDR<1 S QFLG=1 Q
 ..S APSPNAME=$$GET1^DIQ(200,APSPDR,.01)
 ..S APSPTERM=$$GET1^DIQ(200,APSPDR,9.2,,"I")
 ..I (APSPTERM=""!(APSPTERM>DT))&($P($G(^VA(200,APSPDR,"PS")),U)) D
 ...S X=$$ORDROLE(APSPDR)
 ...I X'=3 W !,APSPNAME_" is not a provider."
 ...I X=3 D
 ....S APSPDARY(APSPNAME)=APSPDR
 ....S APSPCNT=APSPCNT+1
 ..E  D
 ...W !,APSPNAME_" is not an active provider."
 ..S QFLG='$$DIRYN^APSPUTIL("Want to Select Another Provider","No","Enter a 'Y' or 'YES' to include more providers in your search",.APSPQ)
 ..S:'QFLG QFLG=APSPQ
 Q:APSPQ
 I APSPNUM="A" D DEV
 I APSPNUM="I"&($D(APSPDARY)) D DEV
 Q
DEV ;EP
 N XBRP,XBNS
 S XBRP="OUT^APSPPDEA"
 S XBNS="APS*"
 D ^XBDBQUE
 Q
OUT ;EP
 N IEN,PROV,X,DEA,EXP,PIEN,PRV,TITLE
 U IO
 D HDR
 K ^TMP($J)
 I APSPNUM="A" D
 .S APSPCNT=0
 .S IEN=0 F  S IEN=$O(^VA(200,IEN)) Q:IEN=""!('+IEN)  D
 ..S X=$$ORDROLE(IEN)
 ..I X=3 D
 ...S APSPTERM=$$GET1^DIQ(200,IEN,9.2,,"I")
 ...I (APSPTERM=""!(APSPTERM>DT))&($P($G(^VA(200,IEN,"PS")),U)) D
 ....S PROV=$$GET1^DIQ(200,IEN,.01)
 ....S APSPDARY(PROV)=IEN
 S PRV=0 F  S PRV=$O(APSPDARY(PRV)) Q:PRV=""!(+APSPQ)  D
 .S PIEN=$G(APSPDARY(PRV))
 .S DEA=$$GET1^DIQ(200,PIEN,53.2)
 .S EXP=$$GET1^DIQ(200,PIEN,747.44)
 .S TITLE=$E($$GET1^DIQ(200,PIEN,53.5),1,19)
 .W !,$E(PRV,1,25),?26,TITLE,?50,DEA,?65,EXP
 .I $Y+4>IOSL,IOST["C-" D PAUS Q:APSPQ  D HDR
 .Q:APSPQ=1
 Q
PAUS ;
 N DTOUT,DUOUT,DIR
 S DIR("?")="Enter '^' to Halt or Press Return to continue"
 S DIR(0)="FO",DIR("A")="Press Return to continue or '^' to Halt"
 D ^DIR
 I $D(DUOUT) S APSPQ=1
 Q
HDR ;
 N LIN
 I IOST["C-" W @IOF
 W !,"Provider List Report"
 W !,"Provider Name",?26,"Class",?50,"DEA#",?65,"Exp Date"
 W ! F LIN=1:1:72 W "-"
 W !
 Q
ORDROLE(IEN) ;EP
 Q:$$HASKEY("OREMAS",IEN)+$$HASKEY("ORELSE",IEN)+$$HASKEY("ORES",IEN)>1 5
 Q:$$HASKEY("OREMAS",IEN) 1
 Q:$$HASKEY("ORELSE",IEN) 2
 Q:$$HASKEY("ORES",IEN)&$$ISPROV(IEN) 3
 Q:$$ISPROV(IEN) 4
 Q 0
 ; Returns true if user is a provider
ISPROV(IEN) ;EP
 Q $$HASKEY("PROVIDER",IEN)
 ; Returns true if user has key
 ; KEY = Security key (or parameter if begins with "@")
 ; USR = IEN of user to check
HASKEY(KEY,USR) ;PEP - Does user have key?
 Q:'$L(KEY) 1
 S USR=$G(USR,DUZ)
 I $E(KEY)="@" D GETPAR^CIAVMRPC(.KEY,$E(KEY,2,999),,,,USR) Q ''KEY
 Q ''$D(^XUSEC(KEY,+USR))
