AMER2B ; IHS/ANMC/GIS - COST RECOVERY DATA RELATED TO INJURIES ;
 ;;3.0;ER VISIT SYSTEM;**6,7**;MAR 03, 2009;Build 5
 ; 
QD31 ; CITY OF INJURY
 S DIR("B")=$G(^TMP("AMER",$J,2,31))
 S DIR(0)="FO^1:30",DIR("A")="Town/village where injury occurred" KILL DA D ^DIR KILL DIR
 D CKSC^AMER1 I $D(AMERCKSC) K AMERCKSC G QD31
 ;
 ;AMER*3.0*6;Added call to update BEDD
 NEW INJ
 I Y'["^" S INJ=Y D
 . NEW Y
 . D INJ^AMERBEDD("INJ.PtInjury.InjLocat",INJ)
 K INJ
 ;
 D OUT^AMER
 Q
 ; 
QD32 ; TIME OF INJURY
 I $D(^TMP("AMER",$J,2,32)) S Y=^(32) X ^DD("DD") S DIR("B")=Y
 S DIR(0)="DO^::ER",DIR("A")="Enter the exact time and date of injury",DIR("?")="Enter a time and date in the usual FileMan format (e.g., 1/3/90@1PM)." D ^DIR K DIR
 I Y,$$TCK^AMER2A($G(^TMP("AMER",$J,1,2)),Y,0,"admission") K Y G QD32
 I Y="" S Y=-1
 ;
 ;AMER*3.0*6;Added call to update BEDD
 NEW INJ
 I Y'["^" S INJ=Y D
 . NEW Y
 . D INJ^AMERBEDD("INJ.PtInjury.InjDtTm",INJ)
 K INJ
 ;
 D OUT^AMER
 Q
 ;
QD33(AMERPCC,DTOUT) ; CAUSE OF INJURY
 ;
 ;Input
 ;    AMERPCC - Visit IEN (optional)
 ;        DFN - Needs to be defined
 ;
 ;Returns DTOUT on timeouts
 ;
 NEW DIR,DUOUT,DIRUT,DIROUT,INP,VDT,LEX,QUIT,SELECT,TOTREC,SEX,RET
 NEW CAUSE,EDIT
 I $G(AMERPCC)="" S AMERPCC=$$GET1^DIQ(9009081,DFN_",",1.1,"I")
 I AMERPCC]"" S VDT=$P($$GET1^DIQ(9000010,AMERPCC,.01,"I"),".")
 S:$G(VDT)="" VDT=DT
 S SEX=$$GET1^DIQ(2,DFN_",",.02,"I")
 ;
 ;Get the current cause of injury
 I $G(AMERDA)]"" S CAUSE=$$GET1^DIQ(9009080,AMERDA_",",3.2,"I")
 I $G(CAUSE)="" S CAUSE=$G(^TMP("AMER",$J,2,33))
 ;
 ;If current value, display and check for edit
 S EDIT="" I CAUSE]"" D  I 'EDIT G XQD33
 . NEW DESC,DIR,DUOUT,DTOUT
 . ;
 . ;Get the current display value
 . S DESC=$$DX^AMERPOV(CAUSE,"",1,VDT) Q:DESC=""
 . W !!,"Current Cause of injury: ",DESC,!
 . S DIR("B")="NO"
 . S DIR(0)="YO",DIR("A")="Change cause of injury to new value"
 . D ^DIR
 . I Y=1 S EDIT=1 Q
 . ;
 . ;Process timeouts and "^"
 . I $D(DUOUT) S (X,Y)="^" Q
 . I $D(DTOUT) S (X,Y)="^" Q
 . ;
 . ;Do not change - plug in current value
 . S Y=CAUSE Q
 ;
QD33E S DIR(0)="F^3"
 ;S (X,Y)=""
 S DIR("A")="*Cause of injury"
 S DIR("?")="Enter a string or ICD code for the Cause of Injury"
 D ^DIR
 I $D(DIRUT) S X="^" Q
 ;
 ;Perform the lookup
 ;
 ;Call parameters
 ;P1-Search Text, P2-Return Count, P3-Search Type (0-No COI, 1-Only COI, 2-All),P4-Date,P5-Gender
 ;S INP=Y_"^1^"_VDT_"^"_SEX_"^2^0"
 D LEX^AMERUTIL(Y,100,1,VDT,SEX,.RET)
 ;
 ;Reprompt if no results
 I $O(RET(""))="" W !!,"<No results returned. Please try a different search string>",! H 2 K RET G QD33E
 ;
 ;Convert results to ICD
 K ^TMP("AMERICD",$J)
 S TOTREC=0,LEX="" F  S LEX=$O(RET(LEX)) Q:LEX=""  I +LEX S TOTREC=TOTREC+1,^TMP("AMERICD",$J,TOTREC)=RET(LEX)
 ;
 ;Display Results
 S SELECT=""
 W !!
 S (QUIT,LEX)=0 F  S LEX=$O(^TMP("AMERICD",$J,LEX)) Q:LEX=""  D  Q:QUIT>1  Q:SELECT]""
 . ;
 . NEW DIR,DIRUT,DUOUT,DTOUT,DIROUT,X,Y,ND
 . ;
 . ;Display one entry
 . S ND=$G(^TMP("AMERICD",$J,LEX)) Q:$TR(ND,"^")=""
 . W !,LEX,?4,$P(ND,U,2),?14,$E($P(ND,U,3),1,64)
 . ;
 . ;Prompt every 5 entries
 . I LEX#5'=0,LEX'=+TOTREC Q
 . W !,"Press <RETURN> to see more, '^' to exit this list, OR"
 . S DIR("A")="CHOOSE 1-"_LEX_": "
 . S DIR(0)="NOA^1:"_LEX
 . D ^DIR
 . S QUIT=$$CKANS() Q:QUIT
 . ;
 . ;Record the selection
 . S:+Y SELECT=+Y
 ;
 ;Handle "^", "^^", timeouot
 I QUIT=2 K RET G QD33E
 I QUIT=3 S (Y,X)="^" Q
 I SELECT="" K RET G QD33E
 ;
 ;Set entry
 S Y=$P($G(^TMP("AMERICD",$J,+SELECT)),U)
 ;
 ;AMER*3.0*6;Added call to update BEDD
 NEW INJ
 ;AMER*3.0*7;Added in DO
 ;I Y'["^" S INJ=Y
 I Y'["^" S INJ=Y D
 . NEW Y
 . D INJ^AMERBEDD("INJ.PtInjury.InjCauseIEN",INJ)
 K INJ
 ;
XQD33 D OUT^AMER
 Q
 ;
QD34 ; PLACE OF INJURY
 S DIC("A")="Setting of accident/injury: " K DIC("B")
 I $D(^TMP("AMER",$J,2,34)) S %=+^(34) S:%>0 DIC("B")=$P(^AMER(3,%,0),U)
 S DIC="^AMER(3,",DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("SCENE OF INJURY"),DIC(0)="AEQ"
 D ^DIC K DIC S Y=+Y
 ;
 ;AMER*3.0*6;Added call to update BEDD
 NEW INJ
 ;AMER*3.0*7;Added in DO
 ;I +Y>0 S INJ=Y
 I +Y>0 S INJ=Y D
 . NEW Y
 . D INJ^AMERBEDD("INJ.PtInjury.InjSet",INJ)
 K INJ
 ; 
 D OUT^AMER
 ;
 ;No longer in use
 ;S Z=U,%="MOTOR VEHICLE^BICYCLE^TOOLS JOB EQUIP.^INHILATION (GAS/SMOKE)^CHEMICALS (CAUSTIC OR TOXIC)^ELECTRICITY^FIRE FLAME^FALL (ACCIDENTAL)" F I=1:1:$L(%,U) S A=$P(%,U,I),Z=Z_+$O(^AMER(3,"B",A,0))_U
 ;S %=$P($G(^TMP("AMER",$J,2,33)),U) I Z'[(U_%_U) G QD35A ; SAFETY EQUIP NOT RELEVANT
 Q
 ;
QD35 ; SAFETY EQUIPMENT OF INJURY
 N A,Z,%
 S DIC("A")="Safety equipment used: " K DIC("B")
 I $D(^TMP("AMER",$J,2,35)) S %=+^(35) S:%>0 DIC("B")=$P(^AMER(3,%,0),U)
 S DIC="^AMER(3,",DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("SAFETY EQUIPMENT"),DIC(0)="AEQ"
 D ^DIC K DIC S Y=+Y
 ;
 ;AMER*3.0*6;Added call to update BEDD
 NEW INJ
 ;AMER*3.0*7;Added in DO
 ;I +Y>0 S INJ=Y
 I +Y>0 S INJ=Y D
 . NEW Y
 . D INJ^AMERBEDD("INJ.PtInjury.SafetyEquip",INJ)
 K INJ
 ;
 D OUT^AMER I $D(AMERQUIT) Q
QD35A ;
 ;
 NEW MVA
 ;
 S MVA=""
 ;
 ;Look for MVA
 I $G(AMERDFN)]"" D
 . NEW DESC,%,I
 . S %=$P($G(^TMP("AMER",$J,2,33)),U)
 . S DESC=$$DESC(%,AMERDFN,"","")
 . F I="MOTOR","VEH","MV","TRAFFIC" I $$UP^XLFSTR(DESC)[I S MVA=1
 ;
 ;If MVA ask additional questions
 I MVA=1 D  Q  ; MVA
 . S AMERRUN=40
 . F I=61:1:64 K ^TMP("AMER",$J,2,I) ; MVA
 . Q
 ;
 ;Not a MVA
 F I=41:1:46,51:1:57,61:1:64 K ^TMP("AMER",$J,2,I)
 I $D(AMEREFLG) S AMERRUN=99
 E  S AMERRUN=4
 Q
 ;
QD41 ; DESCIPTION OF MVA LOCATION
 K DIR("B") I $D(^TMP("AMER",$J,2,41)) S DIR("B")=^(41)
 S DIR(0)="FO^1:100",DIR("A")="Location of MVC (if applicable)",DIR("?")="Enter free text location description (100 characters max.)" D ^DIR K DIR
 D CKSC^AMER1 I $D(AMERCKSC) K AMERCKSC G QD41
 D OUT^AMER I $D(AMERQUIT) Q
 S AMERRUN=4
 Q
 ;
CKANS()  ;EP - Check answer "^", "^^", and timeout
 ;
 ;User typed "^^"
 I $G(DIROUT) Q 3
 ;
 ;User typed "^" or timed out
 I $G(DUOUT)!$G(DTOUT) Q 2
 ;
 ;User hit ENTER
 I $G(DIRUT) Q 1
 ;
 Q 0
 ;
DESC(X,D0,CODE,VDATE) ;Return the ICD Description
 ;
 NEW ICDDESC
 ;
 ;Make the call to get the string
 S ICDDESC=$$DX^AMERPOV($G(X),$G(D0),$G(CODE),$G(VDATE))
 Q ICDDESC
