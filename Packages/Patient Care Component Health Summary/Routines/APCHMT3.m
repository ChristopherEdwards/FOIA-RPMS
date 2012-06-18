APCHMT3 ; IHS/CMI/LAB -- health summary create/modify ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;; ;
 ;routine to create/modify a health summary type
 ;
BACK ;go back to listman
 D TERM^VALM0
 S VALMBCK="R"
 D INIT
 D HDR
 K DIR
 K X,Y,Z,I
 Q
COMP(S,C) ;EP
 NEW X,Y S Y=0,X=0 F  S X=$O(^APCHSCTL(S,1,X)) Q:X'=+X!(Y)  I $P(^APCHSCTL(S,1,X,0),U,2)=C S Y=1
 Q Y
TP ;EP - called from protocol entry
 D FULL^VALM1
 I '$$COMP(APCHDA,$O(^APCHSCMP("B","BEST PRACTICE PROMPTS",0))) W !!,"WARNING:  Best Practice Prompts has not been added to the Health Summary",! D
 .W "structure.  Best Practice Prompts will not display until they are part of the",!,"summary structure."
 .S DIR(0)="E",DIR("A")="Press enter to continue" KILL DA D ^DIR KILL DIR
 ;
 ;
EN ; -- main entry point for E
 D EN^VALM("APCH TP EDIT")
 D BACK
 Q
 ;
ADD ;add individual reminders or remove
 D FULL^VALM1
 W !!,"Enter the sequence number to put this Best Practice Prompt and then enter",!,"the prompt by name.",!
 K DIE S DA=APCHDA,DIE="^APCHSCTL(",DR=13 D ^DIE K DIE,DIV,DIW
 D BACK
 Q
REM ;
 D FULL^VALM1
 S APCHSEQ=$$READ("N^0:999:","Enter the sequence number of the Best Practice Prompt to remove")
 I APCHSEQ="" Q
 I APCHSEQ="^" Q
 K DIRUT
 I '$D(^APCHSCTL(APCHDA,13,APCHSEQ,0)) W !!,"Invalid Sequence number." G REM
 K ^APCHSCTL(APCHDA,13,APCHSEQ) S $P(^APCHSCTL(APCHDA,13,0),U,3)=APCHSEQ,$P(^APCHSCTL(APCHDA,13,0),U,4)=$P(^APCHSCTL(APCHDA,13,0),U,4)+1
 D BACK
 Q
ADDG ;add reminders by group
 D FULL^VALM1
 W !!
 S DIC="^APCHHMC(",DIC(0)="AEMQ",DIC("A")="Select the Category/Group of Best Practice Prompts to ADD: " D ^DIC K DIC
 I Y=-1 Q
 S APCHCAT=+Y
 ;add group
 S APCHSEQ=$$READ("N^0:999:","Enter the sequence number to place this group of Best Practice Prompts")
 I APCHSEQ="^" Q
 I APCHSEQ="" Q
 ;now gather up all reminder of this category and put them in
 ;if number already exists then move all numbers down
 D REMOVEG
 W !!,"Adding all Best Practice Prompts in the ",$P(^APCHHMC(APCHCAT,0),U)," group."
 K APCHC S X=0 F  S X=$O(^APCHSCTL(APCHDA,13,X)) Q:X'=+X  S APCHC($P(^APCHSCTL(APCHDA,13,X,0),U))=$P(^APCHSCTL(APCHDA,13,X,0),U,2)
 K ^APCHSCTL(APCHDA,13) S ^APCHSCTL(APCHDA,13,0)="^9001015.06AI^0^0"
 S (B,C,X)=0 F  S X=$O(APCHC(X)) Q:X'=+X!(X>APCHSEQ)!(X=APCHSEQ)  S ^APCHSCTL(APCHDA,13,X,0)=X_U_APCHC(X),C=C+1,$P(^APCHSCTL(APCHDA,13,0),U,3)=X,$P(^APCHSCTL(APCHDA,13,0),U,4)=C,B=X K APCHC(X)
 ;now put in new ones
 S Z=B S Y=0 F  S Y=$O(^APCHSURV(Y)) Q:Y'=+Y  I $P(^APCHSURV(Y,0),U,5)=APCHCAT,$P(^APCHSURV(Y,0),U,7)="T" S Z=Z+5,C=C+1 S ^APCHSCTL(APCHDA,13,Z,0)=Z_U_Y,$P(^APCHSCTL(APCHDA,13,0),U,3)=Z,$P(^APCHSCTL(APCHDA,13,0),U,4)=C
 ;now remaining old ones
 S X=0 F  S X=$O(APCHC(X)) Q:X'=+X  S Z=Z+5,C=C+1 S ^APCHSCTL(APCHDA,13,Z,0)=Z_U_APCHC(X),$P(^APCHSCTL(APCHDA,13,0),U,3)=Z,$P(^APCHSCTL(APCHDA,13,0),U,4)=C
 D BACK
 Q
REMOVEG ;
 I $G(APCHTALK) W !!,"Removing all Best Practice Prompts in the ",$P(^APCHHMC(APCHCAT,0),U)," group."
 S X=0 F  S X=$O(^APCHSCTL(APCHDA,13,X)) Q:X'=+X  D
 .S Y=$P(^APCHSCTL(APCHDA,13,X,0),U,2)
 .I $P(^APCHSURV(Y,0),U,5)=APCHCAT K ^APCHSCTL(APCHDA,13,X,0)
 .Q
 Q
REMG ;ep
 D FULL^VALM1
 W !!
 S DIC="^APCHHMC(",DIC(0)="AEMQ",DIC("A")="Select the Category of Best Practice Prompts to REMOVE: " D ^DIC K DIC
 I Y=-1 Q
 S APCHCAT=+Y
 S APCHTALK=1 D REMOVEG K APCHTALK
 D BACK
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="Health Summary: "_$P(^APCHSCTL(APCHDA,0),U)
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP($J,"APCHHMRT") S APCHC=0 K APCHT
 S X="Note: any Best Practice Prompt flagged as inactive will not display" D S(X)
 S X="      on the summary even though you selected it for display.  The " D S(X)
 S X="      Best Practice Prompt must be activated.  Any Best Practice Prompts" D S(X)
 S X="      with (DEL) should be removed as they are no longer used." D S(X)
 S X="Currently defined BEST PRACTICE PROMPTS on the "_$P(^APCHSCTL(APCHDA,0),U)_" summary type" D S(X,1)
 S X="",$E(X,5)="SEQ",$E(X,10)="Best Practice Prompts",$E(X,65)="Category/Group" D S(X,1)
 S X="-------------------------------------------------------------------------------" D S(X)
 S Y=0,T=0 F  S Y=$O(^APCHSCTL(APCHDA,13,Y)) Q:Y'=+Y  D
 .S T=T+1 S O=$P(^APCHSCTL(APCHDA,13,Y,0),U),C=$P(^APCHSCTL(APCHDA,13,Y,0),U,2),N=$P($G(^APCHSURV(+C,0)),U,1)
 .S X="",$E(X,5)=O,$E(X,10)=N_" "_$S($P(^APCHSURV(C,0),U,3)="I":"(INACT)",$P(^APCHSURV(C,0),U,3)="D":"(DEL)",1:"")
 .S $E(X,65)=$$VAL^XBDIQ1(9001018,C,.05) D S(X)
 .S APCHT(C)=""
 ;now get all those that aren't yet used
 S X="Other BEST PRACTICE PROMPTS not yet selected that can be " D S(X,2)
 S X="added to this summary type:" D S(X)
 S T=0 F  S T=$O(^APCHSURV(T)) Q:T'=+T  D
 .Q:$D(APCHT(T))  ;already used
 .Q:$P(^APCHSURV(T,0),U,3)="D"
 .Q:$P(^APCHSURV(T,0),U,7)'="T"
 .S X="",$E(X,7)=$P(^APCHSURV(T,0),U),$E(X,65)=$$VAL^XBDIQ1(9001018,T,.05) D S(X)
 S VALMCNT=$O(^TMP($J,"APCHHMRT",""),-1)
 Q
S(Y,F,C,T) ;EP - set up array
 I '$G(F) S F=0
 I '$G(T) S T=0
 ;blank lines
 F F=1:1:F S X="" D S1
 S X=Y
 I $G(C) S L=$L(Y),T=(80-L)/2 D  D S1 Q
 .F %=1:1:(T-1) S X=" "_X
 F %=1:1:T S X=" "_Y
 D S1
 Q
S1 ;
 S APCHC=APCHC+1
 S ^TMP($J,"APCHHMRT",APCHC,0)=X
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- EXIT code
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PAUSE ;EP; -- ask user to press ENTER
 Q:IOST'["C-"
 NEW Y S Y=$$READ("E","Press ENTER to continue") D ^XBCLS Q
READ(TYPE,PROMPT,DEFAULT,HELP,SCREEN,DIRA) ;EP; calls reader, returns response
 NEW DIR,X,Y
 S DIR(0)=TYPE
 I $D(SCREEN) S DIR("S")=SCREEN
 I $G(PROMPT)]"" S DIR("A")=PROMPT
 I $G(DEFAULT)]"" S DIR("B")=DEFAULT
 I $D(HELP) S DIR("?")=HELP
 I $D(DIRA(1)) S Y=0 F  S Y=$O(DIRA(Y)) Q:Y=""  S DIR("A",Y)=DIRA(Y)
 D ^DIR
 Q Y
