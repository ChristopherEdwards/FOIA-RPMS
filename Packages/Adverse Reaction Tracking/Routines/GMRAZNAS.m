GMRAZNAS ; IHS/MSC/MGH - NON-ASSESSED ALLERGY PATIENTS ;08-Aug-2013 15:41;DU
 ;;4.0;Adverse Reaction Tracking;**1007**;Mar 29, 1996;Build 18
 ;
EN ;EP
 N GMRQ,GMRDIV,GMRTYP,GMRBD,GMRED
 W !!,"Report of patients with no allergy assessment who were seen in the dates selected"
 D ASKDATES^APSPUTIL(.GMRBD,.GMRED,.GMRQ,$$FMADD^XLFDT(DT,-90),$$FMADD^XLFDT(DT,-1))
 Q:GMRQ
 S GMRDIV=$$DIR^APSPUTIL("Y","Would you like all divisions","Yes",,.GMRQ)
 Q:GMRQ
 I GMRDIV D
 .S GMRDIV="*"
 E  D  Q:GMRQ
 .S GMRDIV=$$GETIEN^APSPUTIL(40.8,"Select Division: ",.GMRQ)
 Q:GMRQ
 S GMRTYP=+$$DIR^APSPUTIL("S^1:Delimited;2:Regular","Report Type",2,,.GMRQ)
 Q:GMRQ
 D DEV
 Q
DEV ;EP
 N XBRP,XBNS
 S XBRP="OUT^GMRAZNAS"
 S XBNS="GMR*"
 D ^XBDBQUE
 Q
OUT ;EP Run the report
 N FILTER,IEN,OK,ALG,DFN,CNT,UN,GMRBDF,GMREDF
 K ^TMP("GMRALG",$J)
 S CNT=0
 S FILTER="AHI"
 S GMRBDF=$P($TR($$FMTE^XLFDT(GMRBD,"5Z"),"@"," "),":",1,2)
 S GMREDF=$P($TR($$FMTE^XLFDT(GMRED,"5Z"),"@"," "),":",1,2)
 S GMRBD=GMRBD-.01,GMRED=GMRED+.99
 F  S GMRBD=$O(^AUPNVSIT("B",GMRBD)) Q:'+GMRBD!(GMRBD>GMRED)  D
 .S IEN="" F  S IEN=$O(^AUPNVSIT("B",GMRBD,IEN)) Q:'+IEN  D
 ..S OK=$$CHKVST(IEN)
 ..;Get the patient for this visit and check for assessment
 ..S DFN=$$GET1^DIQ(9000010,IEN,.05,"I")
 ..I +OK D
 ...N ALG
 ...S ALG=$$NKA^GMRANKA(DFN)
 ...I ALG="" D
 ....S UN=$$INASSESS^GMRAPEM0(DFN)
 ....I UN=0 D SETDATA(GMRDIV,DFN,IEN)
 ;Print out all the data in the array
 I GMRTYP=1 D DELIM Q
 I GMRTYP=2 D REG
 Q
CHKVST(IEN) ;Check to see its an ambulatory visit
 N RET,LOC,DIV
 S RET=0
 I FILTER[$P($G(^AUPNVSIT(IEN,0)),U,7) D
 .I GMRDIV="*" S RET=1
 .E  D
 ..S LOC=$$GET1^DIQ(9000010,IEN,.22,"I")
 ..I +LOC D
 ...S DIV=$$GET1^DIQ(44,LOC,3.5,"I")
 ...I +DIV=GMRDIV S RET=DIV
 Q RET
SETDATA(DIV,DFN,IEN) ;Put the data into the temp global
 N PRV,NAME,VSTDT,QUIT,PRI,PNAME,DIVNM
 S QUIT=0,PNAME="",DIVNM=""
 S CNT=CNT+1
 S NAME=$$GET1^DIQ(2,DFN,.01)
 S VSTDT=$$GET1^DIQ(9000010,IEN,.01)
 I DIV="*" D
 .S LOC=$$GET1^DIQ(9000010,IEN,.22,"I")
 .I +LOC D
 ..S DIVNM=$$GET1^DIQ(44,LOC,3.5)
 E  S DIVNM=$$GET1^DIQ(40.8,DIV,.01)
 S PRV="" F  S PRV=$O(^AUPNVPRV("AD",IEN,PRV)) Q:'+PRV!(QUIT=1)  D
 .S PRI=$$GET1^DIQ(9000010.06,PRV,.04,"I")
 .I PRI="P" D
 ..S PNAME=$$GET1^DIQ(9000010.06,PRV,.01)
 ..S QUIT=1
 S ^TMP("GMRALG",$J,DIV,DFN,CNT)=NAME_U_VSTDT_U_PNAME_U_DIVNM
 Q
REG ;Output to the screen
 N DIV,DFN,CNT,STRING
 D HDR1
 S DIV=0 F  S DIV=$O(^TMP("GMRALG",$J,DIV)) Q:DIV=""!(+GMRQ)  D
 .S DFN=0 F  S DFN=$O(^TMP("GMRALG",$J,DIV,DFN)) Q:DFN=""!(+GMRQ)  D
 ..S CNT=0
 ..F  S CNT=$O(^TMP("GMRALG",$J,DIV,DFN,CNT)) Q:CNT=""!(+GMRQ)  D
 ...I $Y+4>IOSL,IOST["C-" D PAUS Q:GMRQ  D HDR1
 ...Q:GMRQ=1
 ...S STRING=$G(^TMP("GMRALG",$J,DIV,DFN,CNT))
 ...W !,?1,$E($P(STRING,U,4),1,20),?22,$E($P(STRING,U,1),1,20),?43,$E($P(STRING,U,2),1,20),?64,$E($P(STRING,U,3),1,20)
 Q
DELIM ;Delimeted output
 N DIV,DFN,CNT,STRING
 D HDR2
 S DIV=0 F  S DIV=$O(^TMP("GMRALG",$J,DIV)) Q:DIV=""  D
 .S DFN=0 F  S DFN=$O(^TMP("GMRALG",$J,DIV,DFN)) Q:DFN=""  D
 ..S CNT=0
 ..F  S CNT=$O(^TMP("GMRALG",$J,DIV,DFN,CNT)) Q:CNT=""  D
 ...S STRING=$G(^TMP("GMRALG",$J,DIV,DFN,CNT))
 ...W !,$P(STRING,U,4)_U_$P(STRING,U,1)_U_$P(STRING,U,2)_U_$P(STRING,U,3)
 Q
HDR1 ;Write header
 N LIN
 I IOST["C-" W @IOF
 W !,"Patient with no allergy assessment seen between "_GMRBDF_" and "_GMREDF
 W !,?1,"DIVISION",?22,"PATIENT",?43,"VISIT",?64,"PROVIDER"
 W ! F LIN=1:1:72 W "-"
 W !
 Q
HDR2 ;Write delimeted header
 W !,"Patient with no allergy assessment seen between "_GMRBDF_" and "_GMREDF
 W !,"DIVISION^PATIENT^VISIT^PROVIDER"
 Q
PAUS ;pause
 N DTOUT,DUOUT,DIR
 S DIR("?")="Enter '^' to Halt or Press Return to continue"
 S DIR(0)="FO",DIR("A")="Press Return to continue or '^' to Halt"
 D ^DIR
 I $D(DUOUT) S GMRQ=1
 Q
