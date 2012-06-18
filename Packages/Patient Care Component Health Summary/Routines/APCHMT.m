APCHMT ; IHS/CMI/LAB -- create/modify health summary type ;
 ;;2.0;IHS PCC SUITE;**7**;MAY 14, 2009
 ;; ;
 ;routine to create/modify a health summary type
EP ;EP - called from option
 W !!!,"This option will allow you to create a new or modify an existing"
 W !,"health summary type.",!!
 D ^XBFMK S DIC="^APCHSCTL(",DIC(0)="AEMQL" D ^DIC K DIC,DA,DR,DD,DO
 I Y=-1 W !!,"Goodbye",! D EOJ Q
 S %=$P(^APCHSCTL(+Y,0),U,2) I %]"",$D(^XUSEC(%,DUZ))[0 W !,"This summary type is currently locked to prevent alteration.",! G EP
 S APCHDA=+Y
 S DIE="^APCHSCTL(",DA=APCHDA,DR=".01;.05" D ^DIE D ^XBFMK
 D EN
EOJ ;
 D EN^XBVK("APCH")
 D ^XBFMK
 Q
EN ; -- main entry point for APCH CREATE/MODIFY TYPE
 D EN^VALM("APCH CREATE/MODIFY TYPE")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
HDR ;EP -- header code
 S VALMHDR(1)="Health Summary: " I $G(APCHDA),$D(^APCHSCTL(APCHDA)) S VALMHDR(1)=VALMHDR(1)_$P(^APCHSCTL(APCHDA,0),U)
 Q
 ;
INIT ;EP -- init variables and list array
 K ^TMP($J,"APCHTYPE")
 S APCHC=0
 NEW X,Y,O,C,M,T,A
 S X="STRUCTURE: " D S(X)
 S X="Order",$E(X,7)="Component",$E(X,49)="Max occ",$E(X,57)="Time",$E(X,62)="Alternate Title" D S(X)
 S Y=0 F  S Y=$O(^APCHSCTL(APCHDA,1,Y)) Q:Y'=+Y  D
 .S O=$P(^APCHSCTL(APCHDA,1,Y,0),U),C=$P(^APCHSCTL(APCHDA,1,Y,0),U,2),C=$P($G(^APCHSCMP(+C,0)),U,1)
 .S M=$P(^APCHSCTL(APCHDA,1,Y,0),U,3),T=$P(^APCHSCTL(APCHDA,1,Y,0),U,4),A=$P(^APCHSCTL(APCHDA,1,Y,0),U,5)
 .S X=O,$E(X,7)=C,$E(X,49)=M,$E(X,57)=T,$E(X,62)=A D S(X)
 S X="GENERAL:" D S(X,1)
 S X="Clinic Displayed on outpatient components: "_$$VAL^XBDIQ1(9001015,APCHDA,1.5) D S(X)
 S X="ICD Text Display: "_$$VAL^XBDIQ1(9001015,APCHDA,2) D S(X)
 S X="Provider Narrative Displayed: "_$$VAL^XBDIQ1(9001015,APCHDA,3) D S(X)
 S X="Display Provider Initials in Outpatient components: "_$$VAL^XBDIQ1(9001015,APCHDA,3.6) D S(X)
 S X="Provider Initials displayed on Medication components: "_$$VAL^XBDIQ1(9001015,APCHDA,3.7) D S(X)
 S X="Lab Comments displayed in LAB component: "_$$VAL^XBDIQ1(9001015,APCHDA,3.8)
 S X="Comments displayed with Reasons Service not done: "_$$VAL^XBDIQ1(9001015,APCHDA,3.9)
 S X="MEASUREMENT PANELS: " D S(X,1) I '$O(^APCHSCTL(APCHDA,3,0)) D S("<none>") G LP
 S X="Order",$E(X,7)="Panel" D S(X)
 S Y=0 F  S Y=$O(^APCHSCTL(APCHDA,3,Y)) Q:Y'=+Y  D
 .S O=$P(^APCHSCTL(APCHDA,3,Y,0),U),C=$P(^APCHSCTL(APCHDA,3,Y,0),U,2),C=$P($G(^APCHSMPN(+C,0)),U,1)
 .S X=O,$E(X,7)=C D S(X)
LP ;
 S X="LAB TEST PANELS: " D S(X,1) I '$O(^APCHSCTL(APCHDA,4,0)) D S("<none>") G HMR
 S X="Order",$E(X,7)="Panel" D S(X)
 S Y=0 F  S Y=$O(^APCHSCTL(APCHDA,4,Y)) Q:Y'=+Y  D
 .S O=$P(^APCHSCTL(APCHDA,4,Y,0),U),C=$P(^APCHSCTL(APCHDA,4,Y,0),U,2),C=$P($G(^LAB(60,+C,0)),U,1)
 .S X=O,$E(X,7)=C D S(X)
HMR ;
 S X="HEALTH MAINTENANCE REMINDERS: " D S(X,1) I '$O(^APCHSCTL(APCHDA,5,0)) D S("<none>") G TP
 S X="Order",$E(X,7)="Health Maintenance Reminder" D S(X)
 S Y=0 F  S Y=$O(^APCHSCTL(APCHDA,5,Y)) Q:Y'=+Y  D
 .S O=$P(^APCHSCTL(APCHDA,5,Y,0),U),C=$P(^APCHSCTL(APCHDA,5,Y,0),U,2),C=$P($G(^APCHSURV(+C,0)),U,1)
 .S X=O,$E(X,7)=C D S(X)
TP ;
 S X="BEST PRACTICE PROMPTS: " D S(X,1) I '$O(^APCHSCTL(APCHDA,13,0)) D S("<none>") G FS
 S X="Order",$E(X,7)="Best Practice Prompt" D S(X)
 S Y=0 F  S Y=$O(^APCHSCTL(APCHDA,13,Y)) Q:Y'=+Y  D
 .S O=$P(^APCHSCTL(APCHDA,13,Y,0),U),C=$P(^APCHSCTL(APCHDA,13,Y,0),U,2),C=$P($G(^APCHSURV(+C,0)),U,1)
 .S X=O,$E(X,7)=C D S(X)
FS ;
 S X="FLOWSHEET: " D S(X,1) I '$O(^APCHSCTL(APCHDA,6,0)) D S("<none>") G HF
 S X="Order",$E(X,7)="Flowsheet" D S(X)
 S Y=0 F  S Y=$O(^APCHSCTL(APCHDA,6,Y)) Q:Y'=+Y  D
 .S O=$P(^APCHSCTL(APCHDA,6,Y,0),U),C=$P(^APCHSCTL(APCHDA,6,Y,0),U,2),C=$P($G(^APCHSFLC(+C,0)),U,1)
 .S X=O,$E(X,7)=C D S(X)
HF ;
 S X="HEALTH FACTORS: " D S(X,1) I '$O(^APCHSCTL(APCHDA,7,0)) D S("<none>") G SP
 S X="Order",$E(X,7)="Health Factor",$E(X,49)="Title",$E(X,70)="Most Recent" D S(X)
 S Y=0 F  S Y=$O(^APCHSCTL(APCHDA,7,Y)) Q:Y'=+Y  D
 .S O=$P(^APCHSCTL(APCHDA,7,Y,0),U),C=$P(^APCHSCTL(APCHDA,7,Y,0),U,2),C=$P($G(^AUTTHF(+C,0)),U,1),T=$P(^APCHSCTL(APCHDA,7,Y,0),U,3),M=$P(^APCHSCTL(APCHDA,7,Y,0),U,4),M=$$EXTSET^XBFUNC(9001015.08,3,M)
 .S X=O,$E(X,7)=C,$E(X,49)=$E(T,1,20),$E(X,70)=M D S(X)
SP ;
 S X="SUPPLEMENTS: " D S(X,1) I '$O(^APCHSCTL(APCHDA,12,0)) D S("<none>") G PCS
 S X="Order",$E(X,7)="Supplement" D S(X)
 S Y=0 F  S Y=$O(^APCHSCTL(APCHDA,12,Y)) Q:Y'=+Y  D
 .S O=$P(^APCHSCTL(APCHDA,12,Y,0),U),C=$P(^APCHSCTL(APCHDA,12,Y,0),U,2),C=$P($G(^APCHSUP(+C,0)),U,1)
 .S X=O,$E(X,7)=C_"  "_$P(^APCHSCTL(APCHDA,12,Y,0),U,3) D S(X)
PCS ;
 S X="Provider Class Screen for OUTPATIENT VISITS (SCREENED) component (IF USED): " D S(X,1)
 I $O(^APCHSCTL(APCHDA,9,0)) S X="Provider Classes to be EXCLUDED" D S(X)
 S Y=0 F  S Y=$O(^APCHSCTL(APCHDA,9,Y)) Q:Y'=+Y  D
 .S C=$P(^APCHSCTL(APCHDA,9,Y,0),U),C=$P($G(^DIC(7,+C,0)),U,1)
 .S X=C D S(X)
 S X="CLINIC Screen for OUTPATIENT VISITS (SCREENED) component (IF USED): " D S(X,1)
 I $O(^APCHSCTL(APCHDA,11,0)) S X="Clinics to be EXCLUDED" D S(X)
 S Y=0 F  S Y=$O(^APCHSCTL(APCHDA,11,Y)) Q:Y'=+Y  D
 .S C=$P(^APCHSCTL(APCHDA,11,Y,0),U),C=$P($G(^DIC(40.7,+C,0)),U,1)
 .S X=C D S(X)
 S VALMCNT=$O(^TMP($J,"APCHTYPE",""),-1)
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
 S ^TMP($J,"APCHTYPE",APCHC,0)=X
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
