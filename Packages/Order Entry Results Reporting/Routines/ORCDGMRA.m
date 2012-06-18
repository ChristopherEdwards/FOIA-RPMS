ORCDGMRA ;SLC/MKB-Utility functions for GMRA dialogs ;7/21/97  16:40
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**4,33**;Dec 17, 1997
EN ; -- Entry action for GMRAOR dialog
 N DFN,ORY,ORI,ALLG,SEV
 S DFN=+ORVP D EN1^GMRAOR1(DFN,"ORY")
 S ORGMRAL=ORY Q:'ORY
 W !!,"Currently known reactions:"
 S ORI=0 F  S ORI=$O(ORY(ORI)) Q:ORI'>0  D
 . S ALLG=$P(ORY(ORI),U),SEV=$P(ORY(ORI),U,2)
 . W !?5 W:$L(SEV) $$LOWER^VALM1(SEV)_" reaction to " W ALLG
 Q
 ;
NKA ; -- No known allergies?
 Q:ORGMRAL  N X,Y,DIR
 S DIR(0)="YA",DIR("A")="Does this patient have any known allergies? "
 S DIR("?")="Enter YES to continue and enter an adverse reaction for this patient, or NO if you wish to document that this patient has no known allergies."
 S:ORGMRAL=0 DIR("B")="NO" D ^DIR I $D(DTOUT)!($D(DUOUT)) S ORQUIT=1 Q
 I Y S ORGMRAL=1 K ORDIALOG(PROMPT,INST) Q
 S ORDIALOG(PROMPT,INST)="NKA",ORGMRAL=0,ASK=0
 Q
 ;
FIND ; -- Search allergy & drug files for a match
 N ROOT,CNT,DIR,X,Y,XP,ORX K ^TMP("ORMATCH",$J)
 S X=ORDIALOG(PROMPT,ORI),CNT=0
 I 'FIRST,X=$G(ORESET) Q  ; edit, unchanged
 S ORX=X,X=$$UP^XLFSTR(X)
 F ROOT="^GMRD(120.82,""B"")","^PS(50.605,""C"")",$$B^PSNAPIS,$$T^PSNAPIS D
 . I $D(@ROOT@(X)) S CNT=CNT+1,^TMP("ORMATCH",$J,CNT)=$O(@ROOT@(X,0))_U_X_ROOT
 . S XP=X F  S XP=$O(@ROOT@(XP)) Q:XP=""  Q:$E(XP,1,$L(X))'=X  S CNT=CNT+1,^TMP("ORMATCH",$J,CNT)=$O(@ROOT@(XP,0))_U_XP_ROOT ; partial matches
 I 'CNT D USETEXT(ORX) Q
 I CNT=1 S Y=1,XP=$P(^TMP("ORMATCH",$J,1),U,2) W $E(XP,$L(X)+1,$L(XP)) G:$$OK FQ D USETEXT(ORX) Q
 D MATCHES S DIR("??")="^D MATCHES^ORCDGMRA"
 S DIR(0)="NAO^1:"_CNT,DIR("A")="Select 1-"_CNT_": "
 S DIR("?")="Select the number of the desired causative agent; enter ?? to redisplay the list of matches"
 D ^DIR I $D(DTOUT)!($D(DUOUT)) K DONE Q
 I 'Y D USETEXT(ORX) Q
 W "   "_$P(^TMP("ORMATCH",$J,Y),U,2)
FQ S ORDIALOG(PROMPT,ORI)=$P(^TMP("ORMATCH",$J,Y),U,2)
 S ORDIALOG($$PTR^ORCD("OR GTX ALLERGY TYPE"),1)=$S($P(^TMP("ORMATCH",$J,Y),U,3)?1"GMR".E:$P($G(^GMRD(120.82,+^TMP("ORMATCH",$J,Y),0)),U,2),1:"D")
 Q
 ;
MATCHES ; -- List matches for causative agent text
 N I,J,QUIT
 W !!,"Choose from the following "_+$G(CNT)_" matches:"
 S (I,J,QUIT)=0 F  S I=$O(^TMP("ORMATCH",$J,I)) Q:I'>0  D  Q:QUIT
 . S J=J+1 I J>(IOSL-5) S:'$$MORE QUIT=1 Q:QUIT  S J=1
 . W !,$E(I_"    ",1,4)_$P(^TMP("ORMATCH",$J,I),U,2)
 Q
 ;
MORE() ; -- show more matches?
 N DIR,X,Y
 S DIR(0)="EA",DIR("A")="Press <return> to see more, or ^ to stop ..."
 D ^DIR
 Q +Y
 ;
USETEXT(TEXT) ; -- Returns 1 or 0, if free text is acceptable
 N X,Y,DIR
 S DIR(0)="YA",DIR("A",1)="Could not find "_TEXT_" in any files."
 S DIR("A")="Would you still like to add it as a causative agent? "
 S DIR("B")="YES" D ^DIR
 I Y K ORDIALOG($$PTR^ORCD("OR GTX ALLERGY TYPE"),1) ; reask Type
 I 'Y K DONE
 Q
 ;
OK() ; -- Returns 1 or 0, if matched item is correct
 N X,Y,DIR
 S DIR(0)="YA",DIR("A")="... OK? ",DIR("B")="YES"
 D ^DIR
 Q +Y
 ;
TYPE() ; -- Returns 1 or 0, if the current reaction has a type
 N X,Y,Z S X=$$VAL^ORCD("CAUSATIVE AGENT"),Y=0,Z="" Q:X="" 0
 S Z=$O(^GMRD(120.82,"B",X,0)) I Z S Z=$P($G(^GMRD(120.82,+Z,0)),U,2) S:$L(Z) Y=1 G TYPQ ; < Allergies file
 ;I $D(^PS(50.605,"C",X)) S Y=1,Z="D" G TYPQ ;   < VA Drug class file
 ;I $D(^PSNDF("B",X)) S Y=1,Z="D" G TYPQ ;       < National Drug file
 ;I $D(^PSNDF("T",X)) S Y=1,Z="D" G TYPQ ;       < NDF
 I $$CLASS^PSNAPIS(X) S Y=1,Z="D" G TYPQ ;   < VA Drug class file
 I $$DRUG^PSNAPIS(X) S Y=1,Z="D" G TYPQ ;    < National Drug File
TYPQ I Y,$L(Z) S X=$$PTR^ORCD("OR GTX ALLERGY TYPE") S:'$L($G(ORDIALOG(X,1))) ORDIALOG(X,1)=Z
 Q Y
 ;
COMMON ; -- Build ORDIALOG(PROMPT,"LIST") of common signs/symptoms
 Q:$D(ORDIALOG(PROMPT,"LIST"))
 N CNT,NAME,I,DA S CNT=0,I=0
 F  S I=I+1,NAME=$P($T(SIGN+I),";",3) Q:NAME="ZZZZ"  S DA=$O(^GMRD(120.83,"B",NAME,0)) I DA S CNT=CNT+1,ORDIALOG(PROMPT,"LIST",CNT)=DA_U_NAME,ORDIALOG(PROMPT,"LIST","B",NAME)=DA
 S ORDIALOG(PROMPT,"LIST")=CNT
 S:CNT ORDIALOG(PROMPT,"?")="Enter the signs or symptoms of this reaction; select either the number of a common symptom listed above or '??' to see a listing of all available symptoms."
 Q
 ;
SIGN ;; Common signs/symptoms
 ;;ANXIETY
 ;;ITCHING,WATERING EYES
 ;;HYPOTENSION
 ;;DROWSINESS
 ;;NAUSEA,VOMITING
 ;;DIARRHEA
 ;;HIVES
 ;;DRY MOUTH
 ;;DRY NOSE
 ;;RASH
 ;;ZZZZ
 ;
LIST ; -- List common signs/symptoms
 N NUM,DA,HALF Q:'$O(ORDIALOG(PROMPT,"LIST",0))
 S HALF=ORDIALOG(PROMPT,"LIST")\2
 I ORDIALOG(PROMPT,"LIST")\2*2'=ORDIALOG(PROMPT,"LIST") S HALF=HALF+1
 W !!,"Choose from (or enter another): "
 F NUM=1:1:HALF D
 . S DA=ORDIALOG(PROMPT,"LIST",NUM)
 . W !,$J(NUM,3)_" "_$E($P(ORDIALOG(PROMPT,"LIST",NUM),U,2),1,36)
 . S DA=$G(ORDIALOG(PROMPT,"LIST",NUM+HALF)) Q:'DA
 . W ?40,$J(NUM+HALF,3)_" "_$E($P(ORDIALOG(PROMPT,"LIST",NUM+HALF),U,2),1,36)
 Q
 ;
REQD(PRMT) ; -- ck if PRMT should be required or not
 N OBS,X,Y,%DT
 S OBS=($$VAL^ORCD("(O)BSERVED OR (H)ISTORICAL")="o") Q:'OBS
 S X=$G(ORDIALOG(PROMPT,ORI)),%DT="PTX"
 I 'X K DONE W $C(7),!,"This is a required response!",! Q
 D ^%DT I Y'>0 K DONE W $C(7),!,"This must be an exact date/time!",!
 Q
 ;
SIGNS ; -- Special lookup for signs/symptoms
 N ORX,ORJ,I,J,BEG,END K ORINST
 I X'[",",X'["-" S Y=$$FIND^ORCDLG2("ORDIALOG("_PROMPT_",""LIST"")",X) D:'$L(Y) DIC^ORCDLG2 Q
 S ORX=X,ORINST="" F ORJ=1:1:$L(ORX,",") S X=$P(ORX,",",ORJ) I $L(X) D
 . I X'["-" S Y=$$FIND^ORCDLG2("ORDIALOG("_PROMPT_",""LIST"")",X) D:'$L(Y) DIC^ORCDLG2 S:Y I=$O(ORDIALOG(PROMPT,"?"),-1)+1,ORDIALOG(PROMPT,I)=+Y,ORINST=ORINST_$S($L(ORINST):"^",1:"")_I Q
 . S BEG=+X,END=+$P(X,"-",2) S:'END END=BEG
 . F J=BEG:1:END S Y=$G(ORDIALOG(PROMPT,"LIST",J)) I Y W !?5,$P(Y,U,2) S I=$O(ORDIALOG(PROMPT,"?"),-1)+1,ORDIALOG(PROMPT,I)=+Y,ORINST=ORINST_$S($L(ORINST):"^",1:"")_I
 K:'$L(ORINST) ORINST S:$G(ORINST) Y=ORDIALOG(PROMPT,$P(ORINST,U))
 Q
 ;
DATES ; -- Stuff reaction date for multiple symptoms
 Q:'$G(ORINST)  N I,ORDATE
 S ORDATE=$G(ORDIALOG(PROMPT,INST))
 ;I 'ORDATE D  K ORINST Q
 ;. N SIGN S SIGN=$$PTR^ORCD("OR GTX REACTION")
 ;. F I=1:1:$L(ORINST,U) K ORDIALOG(SIGN,$P(ORINST,U,I))
 I ORDATE F I=1:1:$L(ORINST,U) S ORDIALOG(PROMPT,$P(ORINST,U,I))=ORDATE
 K ORINST
 Q
