BSDHSP ; IHS/ANMC/LJF - PRINT/BROWSE HEALTH SUMMARY ;  [ 02/10/2005  4:07 PM ]
 ;;5.3;PIMS;**1002***;APR 26, 2002
 ;
 I $T(EN^APCHS)="" W !!,"HEALTH SUMMARY PACKAGE NOT INSTALLED." D PAUSE^BDGF Q
 ;
 NEW DFN,APCHSPAT,APCHSTYP,APCHSTAT,APCHSMTY
 S DFN=$G(SDFN)
 I '$D(SDFN) S DFN=+$$READ^BDGF("P^2:EMQZ","Select Patient")
 Q:'DFN  S APCHSPAT=DFN
 ;
 D GETHSTYP Q:'$G(APCHSTYP)   ;ask health summary type
 ;IHS/ITSC/WAR 2/2/2005 PATCH #1002 SPT issue dealing with HS
 S BSDSPT=$O(^DGSL(38.1,DFN,"D",0))
 I BSDSPT>0 D
 .I $P(^DGSL(38.1,DFN,"D",BSDSPT,0),U,3)["Appointment Management" D
 ..S $P(^DGSL(38.1,DFN,"D",BSDSPT,0),U,3)="AM/Health Summary"
 ;
 I $$BROWSE^BDGF="B" D EN Q   ;view in browse mode
 ;IHS/ITSC/WAR 2/2/2005 PATCH #1002 SPT issue dealing with HS
 ;  If they didn't browse (D EN, from above) then they printed it.
 I BSDSPT>0 S $P(^DGSL(38.1,DFN,"D",BSDSPT,0),U,3)="AM/PrtHealth Summary"
 D ZIS^BDGF("PQ","EN^APCHS","HEALTH SUMMARY","APCHSPAT;APCHSTYP") Q
 ;
 ;
EN ;EP; -- main entry point for list template BSDAM HS VIEW
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDAM HS VIEW")
 D CLEAR^VALM1
 Q
 ;
HDR ;EP; -- header code
 Q
 ;
INIT ;EP; -- init variables and list array
 NEW X S VALMCNT=0
 K ^TMP("BSDHSP",$J),^TMP("BSDHSP1",$J)
 D GUIR^XBLM("EN^APCHS","^TMP(""BSDHSP1"",$J,")
 S X=0 F  S X=$O(^TMP("BSDHSP1",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BSDHSP",$J,X,0)=^TMP("BSDHSP1",$J,X)
 K ^TMP("BSDHSP1",$J)
 Q
 ;
HELP ;EP; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ;EP; -- exit code
 K ^TMP("BSDHSP",$J)
 Q
 ;
EXPND ;EP; -- expand code
 Q
 ;
GETHSTYP ; -- ask user for health summary type
 NEW DIC,X,Y
 S DIC="^APCHSCTL(",DIC(0)="AEMQ"
 ;
 ; try to determine a default for question
 ;   first based on current clinic
 S X=$$GET1^DIQ(9009017.2,+$G(SDCLN),.05)
 ;   next based on last one used by user
 I X="",$D(^DISV(DUZ,"^APCHSCTL(")) D
 . S Y=^("^APCHSCTL(") I $D(^APCHSCTL(Y,0)) S X=$P(^(0),U,1)
 ;   last find default for whole facility
 I X="",$D(^APCCCTRL(+$G(DUZ(2)),0)) S X=$$GET1^DIQ(9001000,DUZ(2),.03)
 S:X="" X="ADULT REGULAR" S DIC("B")=X
 D ^DIC K DIC Q:Y<1  S APCHSTYP=+Y
 Q
