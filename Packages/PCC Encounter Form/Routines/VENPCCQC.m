VENPCCQC ; IHS/OIT/GIS - PRE INSTALL ; DATA ENTRY MNEMONIC
 ;;2.6;PCC+;**1,2,3**;APR 03, 2012;Build 24
APCDTWC1 ; CONTINUATION OF APCDTWC
 ; WELL CHILD EXAM INPUT TEMPLATE FOR PCC AND PCC+
 ; 
 ;
VWC(DFN,VIEN) ; EP - RETURN THE V WELL CHILD IEN - CREATE A NEW ONE IF NECESSARY
 I '$G(DFN)!('$G(VIEN)) Q ""
 N DIC,DIE,DR,DA,X,Y
 S DA=$O(^AUPNVWC("AD",VIEN,999999999),-1) I DA Q DA ; A RECORD HAS ALREADY BEEN CREATED - GET LATEST V WC RECORD
 S DIC="^AUPNVWC(",DIC(0)="L",DLAYGO=9000010.46,X=""""_0_""""
 D ^DIC
 I Y=-1 W:'$G(SILENT) !,"Unable to create a new V WELL CHILD record!  Results not entered..." Q ""
 S DA=+Y,DIE=DIC,DR=".02////^S X=DFN;.03////^S X=VIEN"
 L +^AUPNVWC(DA):1 I  D ^DIE L -^AUPNVWC(DA)
 Q DA
 ; 
EVWCFILE(SS,GUIFLAG) ; EP - FILE EXAMS IN V WC
 N DIC,DA,DIE,DR,X,Y,%,TOT,LIEN,CODE,CNT,VWCIEN,PEIEN,VPEIEN,CIEN,CODE,RES
 I '$D(ARR) Q
 I '$G(SS) Q
 S Y=$$VWC(AUPNPAT,APCDVSIT) ; GET V WELL CHILD IEN
 I (+Y)<1 G EX ; FAILED TO OBTAIN A V WC IEN
 S VWCIEN=+Y K ^AUPNVWC(VWCIEN,SS) ; CLEAN SLATE FOR EXAMS
E1 ; V WC SUBFILE ENTRY
 S DA(1)=VWCIEN,DIC="^AUPNVWC("_DA(1)_","_SS_",",DLAYGO=9000010.46_SS,DIC(0)="L"
 S DIC("P")=$P(^DD(9000010.46,SS,0),U,2)
 S DIE=DIC,DR=".02Exam result (N or A)"
 S CNT=0 F  S CNT=$O(ARR(CNT)) Q:'CNT  I $D(ARR(CNT,1)) D
 . S %=$G(ARR(CNT)) I '$L(%) Q  ; ENTER SUB-TOPIC NAME AS FREE TEXT
 . I %[". " S %=$P(%,". ",2)
 . S X=% D ^DIC I Y=-1 Q
 . S DA=+Y
 . I $G(GUIFLAG) S RES=$G(ARR(CNT,1)) Q:RES=""  S DR=".02///^S X=RES" ; SILENT MODE FOR GUI
 . E  W !,X
 . L +^VEN(7.12,DA(1),SS,DA):1 I  D ^DIE L -^VEN(7.12,DA(1),SS,DA)
 . I '$G(GUIFLAG) W !
 . Q
EX D ^XBFMK
 Q
 ; 
ASQFILE ; EP - RECORD ASQ RESULTS IN V WELL CHILD AND THEN REDUNDANTLY FILE THEM IN V MEASUREMENT
 N DIE,DA,DR,X,Y,ASQM,QIEN,%,STG,DIR,VWCIEN,ASK,PCE,RES
 S (DA,VWCIEN)=$$VWC(AUPNPAT,APCDVSIT) I DA<1 G ASQX ; FIND AN EXISTING VISIT OR MAKE A NEW ONE
 S ASQM=$$ASQM(APCDVSIT) I 'ASQM W !!,"No ASQ scores should be entered on this visit!!",!! H 1 Q
 S DIE="^AUPNVWC(",DR="2.07//^S X=ASQM"
 L +^AUPNVWC(DA):1 I  D ^DIE L -^AUPNVWC(DA) ; RECORD THE QUESTIONNAIRE
 S QIEN=$P($G(^AUPNVWC(DA,2)),U,7)
 I 'QIEN W !,"You must specify which form is used before entering results!" G ASQX
 S STG=$G(^VEN(7.14,QIEN,0)) I '$L(STG) Q
 S ASK="COMMUNICATIONS^GROSS MOTOR^FINE MOTOR^PROBLEM SOLVING^PERSONAL-SOCIAL"
 F PCE=1:1:5 D ASKASQ(PCE) ; RECORD/FILE THE 5 ASQ SCORES FOR THE QUESTIONNAIRE IN V WELL CHILD
 S RES=$G(^AUPNVWC(VWCIEN,2)) I '$P(RES,U,7) G ASQX
 F PCE=7,1:1:5 D ASQVMSR(PCE) ; AUTOMATICALLY FILE THE 5 ASQ SCORES FOR THE QUESTIONNAIRE IN V MEASUREMENTS
ASQX D ^XBFMK
 Q
 ; 
ASKASQ(PCE) ; EP -GET AQS SCORE AND FILE IT
 N DIR,DIE,DIC,DA,DR,X,Y,%,ASQX,FLD
 S FLD=$E(32154,PCE) ; PUT ELEMENTS IN CORRECT ORDER
ASK1 S DIR(0)="NO^0:100:"
 S DIR("A")=$P(ASK,U,PCE)_" score"
 S %=$P($G(^AUPNVWC(VWCIEN,2)),U,FLD) I $L(%) S DIR("B")=+%
 D ^DIR KILL DIR
 I 'Y Q
 I Y#5 W " ??",!,"A valid score must be a multipe of 5 (0,5,10,15...)" G ASK1
 S ASQX=Y_" ("_$P(STG,U,PCE+1)_")"
ASK2 S DA=VWCIEN,DIE="^AUPNVWC(",DR="2.0"_FLD_"///^S X=ASQX"
 L +^AUPNVWC(DA):1 I  D ^DIE L -^AUPNVWC(DA)
 Q
 ; 
ASQVMSR(PCE) ; EP - FILE ASQ SCORES IN V MEASUREMNTS
 N DIE,DIC,DA,DR,X,Y,VAL
 S X=$P("ASQF^ASQG^ASQL^ASQS^ASQP^^ASQM",U,PCE) I X="" Q
 S DA=$$VMSR(APCDVSIT,X) I 'DA Q  ; FIND EXISTING V MEASUREMENT OR MAKE A NEW ONE
 S VAL=$P(RES,U,PCE) I '$L(VAL) Q
 I PCE=7 S VAL=+$G(^VEN(7.14,+VAL,0)) I 'VAL Q
 S DIE="^AUPNVMSR(",DR=".04////^S X=VAL"
 I $P($G(^AUPNVMSR(DA,0)),U,2)="" S DR=".02////^S X=AUPNPAT;.03////^S X=APCDVSIT;"_DR
 L +^AUPNVMSR(DA):1 I  D ^DIE L -^AUPNVMSR(DA)
 Q
 ; 
VMSR(VIEN,TYPE) ; EP - FIND OR CREATE A V MEASUREMENT ENTRY
 N MIEN,VMIEN,DIC,X,Y
 S MIEN=$O(^AUTTMSR("B",TYPE,0)) I 'MIEN Q "" ; GET THE MEASUREMENT IEN
 S VMIEN=0
 F  S VMIEN=$O(^AUPNVMSR("AD",VIEN,VMIEN)) Q:'VMIEN  I +$G(^AUPNVMSR(VMIEN,0))=MIEN Q
 I VMIEN Q VMIEN ; A V MEAS ENTRY ALREADY EXISTS FOR THIS ASQ CATEGORY AND VISIT
 S DIC="^AUPNVMSR(",DIC(0)="L",DLAYGO=9000010.01
 S X=""""_TYPE_""""
 D ^DIC I Y=-1 Q "" ; MAKE A NEW V MEAS ENTRY
 Q +Y
 ; 
ASQM(VIEN) ; EP - RETURN THE ASQ QUESTIONNAIRE (MOS)
 N M,DT,ASQM,DFN,IEN,VDT
 S VDT=+$G(^AUPNVSIT(+$G(VIEN),0))\1 I 'VDT Q "" ; PATCHED BY GIS 1/7/07 TO MEET SAC GUIDELINES
 S DFN=$P(^AUPNVSIT(VIEN,0),U,5) I 'DFN Q ""
 S M=$$ASQAGE^APCDTWC2(DFN,VDT) I 'M Q ""
 S IEN=+$$ASQIEN^APCDTWC2(M) I 'IEN Q ""
 S ASQM=+$G(^VEN(7.14,IEN,0)) I 'ASQM Q ""
 Q ASQM
 ; 
FEED(VIEN) ; EP - INFANT FEEDING PRACTICES
 N DIC,DIE,DA,DR,X,Y,Z,%,AGE,DFN,DOB,DIR,FIEN,SEL
 S DFN=$P($G(^AUPNVSIT(+$G(VIEN),0)),U,5) I 'DFN Q
 S DOB=$P($G(^DPT(DFN,0)),U,3) I 'DOB Q
 S AGE=(DT=DOB)\10000
 S FIEN=$O(^AUPNVIF("AD",VIEN,0))
 I 'FIEN,AGE>1 Q  ; ONLY APPLIES TO INFANTS
 I 'FIEN W !,"Was an Infant Feeding Choice recorded" S %=2 D YN^DICN I %'=1 Q
 I FIEN S DIR("B")=$P($G(^AUPNVIF(FIEN,0)),U)
 S DIR(0)="SO^1:EXCLUSIVE BREASTFEEDING;2:MOSTLY BREASTFEEDING;3:1/2 & 1/2 BREAST AND FORMULA;4:MOSTLY FORMULA;5:FORMULA ONLY;6:NOT SPECIFIED"
 S DIR("A")="Feeding choice"
 D ^DIR K DIR,DA
 S SEL=Y
 I SEL=6,'FIEN Q
 I 'SEL D ^XBFMK Q
 I FIEN S DA=FIEN,DIK="^AUPNVIF(" D ^DIK K DIK,DA I SEL=6 Q  ; CLEAN SLATE
 S DIC="^AUPNVIF(",DIC(0)="L",DLAYGO=9000010.44,X=""""_SEL_""""
FEED1 D ^DIC I Y=-1 Q
 S DIE=DIC,DA=+Y,DR=".02////^S X=DFN;.03////^S X=VIEN"
 L +^AUPNVIF(DA):1 I  D ^DIE L -^AUPNVIF(DA)
 D ^XBFMK
 Q
 ; 
EXFILE ; EP - MAKE V EXAM ENTRIES
 ; NEED NEW EXAM TYPE: 'WELL CHILD SCREENING' - DONE
 ; NEED MULTIPLE UNDER V EXAM FOR SPECIFIC EXAMS - DONE
 N DIC,DIE,DA,DR,X,Y,%,CODE,TOT,CIEN,VIEN
EXVCLEAN ; CLEAN OUT ALL V EXAM ENTRIES ASSOCIATED WITH THIS VISIT AND THE EXAM LIST
 S DIK="^AUPNVXAM(" S DA=0
 F  S DA=$O(^AUPNVXAM("AD",APCDVSIT,DA)) Q:'DA  D
 . S CIEN=+$G(^AUPNVXAM(DA,0)) I 'CIEN Q
 . S CODE=$P($G(^AUTTEXAM(CIEN,0)),U,2)
 . S TOT=0
 . F  S TOT=$O(ARR("CODE",CODE,TOT)) Q:'TOT  I $D(ARR(TOT,1)) D ^DIK
 . Q
EXVADD ; MAKE NEW V FILE ENTRY
 S DIC="^AUPNVXAM(",DIC(0)="L",DLAYGO=9000010.13
 S CODE="" F  S CODE=$O(ARR("CODE",CODE)) Q:CODE=""  D
 . S CIEN=$O(^AUTTEXAM("C",CODE,0)) I 'CIEN Q
 . S X="`"_CIEN
 . D ^DIC I Y=-1 Q
 . S DIE=DIC,DA=+Y,DR=".02////^S X=DFN;.03////^S X=APCDVSIT"
 . L +^AUPNVXAM(DA):1 I  D ^DIE L -^AUPNVXAM(DA)
 . S DA(1)=DA,DIC="^AUPNVXAM("_DA(1)_",1,",DIC(0)="L",DLAYGO=900010.131
 . S TOT=0 F  S TOT=$O(ARR("CODE",CODE,TOT)) Q:'TOT  D
 .. S X=$G(ARR("CODE",CODE,TOT)) D ^DIC
 .. Q
 . Q
 D ^XBFMK
 Q
 ; 
NVWCFILE(LOU,TIME,EDU) ; EP - MAKE V WC NUTR ENTRIES
 N DIC,DA,DIE,DR,X,Y,%,TOT,LIEN,CODE,CNT,VWCIEN,PEIEN,VPEIEN,CIEN,CODE
 I '$D(ARR) Q
 S Y=$$VWC(AUPNPAT,APCDVSIT) ; GET V WELL CHILD IEN
 I (+Y)<1 G FX ; FAILED TO OBTAIN A V WC IEN
 S VWCIEN=+Y K ^AUPNVWC(VWCIEN,5) ; CLEAN SLATE FOR NUTR TOPICS
N1 ; NUTR COUNSELING FIELDS
 S LOU=$G(LOU),TIME=$G(TIME),EDU=$G(EDU)
 S DIE="^AUPNVWC(",DA=VWCIEN,DR=""
 I $L($G(LOU)) S DR=".08///^S X=LOU"
 I $G(TIME) S:$L(DR) DR=DR_";" S DR=DR_".07///^S X=TIME"
 I $G(EDU) S:$L(DR) DR=DR_";" S DR=DR_".09////^S X=EDU"
 L +^AUPNVWC(DA):1 I  D ^DIE L -^AUPNVWC(DA)
N2 ; V WC NURT SUBFILE ENTRY
 S DA(1)=VWCIEN,DIC="^AUPNVWC("_DA(1)_",5,",DLAYGO=9000010.465,DIC(0)="L"
 S DIC("P")=$P(^DD(9000010.46,5,0),U,2)
 S CNT=0 F  S CNT=$O(ARR(CNT)) Q:'CNT  I $D(ARR(CNT,1)) D
 . S %=$G(ARR(CNT)) I '$L(%) Q  ; ENTER SUB-TOPIC NAME AS FREE TEXT
 . I %[". " S %=$P(%,". ",2)
 . S X=% D ^DIC
 . Q
NX D ^XBFMK
 Q
 ; 
PEWCFILE(LOU,TIME,EDU) ; EP - MAKE V WELL CHILD ENTRIES
 N DIC,DA,DIE,DR,X,Y,%,TOT,LIEN,CODE,CNT,VWCIEN,PEIEN,VPEIEN,CIEN,CODE
 I '$D(ARR) Q
 S Y=$$VWC(AUPNPAT,APCDVSIT) I 'Y Q  ; GET V WELL CHILD IEN
 S VWCIEN=+Y
 D CLEANVWC(VWCIEN) ; CLEAN SLATE FOR PT ED TOPICS!
F1 ; PT ED FIELDS ; VALUES APPLY TO ENTIRE SESSION - NOT JUST A SINGLE TOPIC
 S DIE="^AUPNVWC(",DA=VWCIEN
 S DR=""
 I $L($G(LOU)) S DR=".06///^S X=LOU"
 I $G(TIME) S:$L(DR) DR=DR_";" S DR=DR_".05///^S X=TIME"
 I $G(EDU) S:$L(DR) DR=DR_";" S DR=DR_".04////^S X=EDU"
 I $L(DR) L +^AUPNVWC(DA):1 I  D ^DIE L -^AUPNVWC(DA)
F2 ; V WELL CHILD PT ED SUBFILE ENTRY
 S DA(1)=VWCIEN,DIC="^AUPNVWC("_DA(1)_",1,",DLAYGO=9000010.461,DIC(0)="L"
 S DIC("P")=$P(^DD(9000010.46,1,0),U,2)
 S CNT=0 F  S CNT=$O(ARR(CNT)) Q:'CNT  I $D(ARR(CNT,1)) D
 . S %=$G(ARR(CNT)) I '$L(%) Q  ; ENTER SUB-TOPIC NAME AS FREE TEXT
 . I %[". " S %=$P(%,". ",2)
 . S X=% D ^DIC
 . Q
FX D ^XBFMK
 Q
 ; 
CLEANVWC(VWCIEN) ; EP - CLEANUP PREVIOUS ENTRIES
 N X,Y,%,SEL,DIK,DA,CNT
 S DA=0,DA(1)=VWCIEN
 S DIK="^AUPNVWC("_DA(1)_",1,"
 F  S DA=$O(^AUPNVWC(VWCIEN,1,DA)) Q:'DA  D
 . S X=$G(^AUPNVWC(VWCIEN,1,DA,0)) I '$L(X) Q
 . S CNT=0
 . F  S CNT=$O(ARR(CNT)) Q:'CNT  D
 .. S Y=$G(ARR(CNT)) I Y'=X Q
CLN .. D ^DIK  ; THIS SUBFILE ENTRY MATCHES ONE OF THIS TYPE'S POSSIBLE CHOICES, SO CLEAR IT OUT
 .. Q
 . Q
 D ^XBFMK
 Q
 ; 
VPEFILE(LOU,FTIME,EDU) ; EP - MAKE V PATIENT ED ENTRIES
 N DIC,DIE,DA,DR,X,Y,%,DIK,CIEN,CODE,SEL,TOT,CAT,T,ITEM,VPEIEN,GRP
 I '$D(ARR("CODE")) Q
UVAR ; USER VARIEBLES
 S LOU=$G(LOU) S LOU=$$UP^XLFSTR(LOU) ; LEVEL OF UNDERSTANDING
 S FTIME=$G(FTIME) ; FRACTIONAL EDUCATION TIME (AVERAGED ACROSS ALL TOPICS) - POS INTEGER
 I FTIME=+FTIME,FTIME=FTIME\1,FTIME>-1
 E  S FTIME=""
 S GRP="I" ; COUNSELLING TYPE: INDIVIDUAL
 S EDU=$G(EDU) I '$D(^VA(200,EDU,0)) S EDU="" ; EDUCATOR IEN
VPECLEAN ; CLEAN SLATE FOR ALL TOPICS IN THE LIST
 S DA=0,DIK="^AUPNVPED("
 F  S DA=$O(^AUPNVPED("AD",APCDVSIT,DA)) Q:'DA  D
 . S CIEN=+$G(^AUPNVPED(DA,0)) I 'CIEN Q
 . S CODE=$P($G(^AUTTEDT(CIEN,0)),U,2) I '$L(CODE) Q
 . I $D(ARR("CODE",CODE)) D ^DIK ; THIS ENTRY'S CODE IS IN THE ARRAY, SO KLILL IT OFF
 . Q
VPEADD ; ADD PATIENT ED ENTRIES IN V PATIENT ED - ONE FOR EACH PT ED CODE WITH SUB-TOPICS IN THE '1' MULTIPLE
 S CODE=""
 F  S CODE=$O(ARR("CODE",CODE)) Q:CODE=""  D  ; SORT BY CODE GROUP
 . S SEL=0,TOT=0,DIC="^AUPNVPED(",DIC(0)="L",DLAYGO=9000010.16
 . F  S TOT=$O(ARR("CODE",CODE,TOT)) Q:'TOT  I $D(ARR(TOT,1)) S SEL=1 Q
 . I 'SEL Q  ; STOP IF NO ITEMS WITH THIS CODE WERE SELECTED
 . S CIEN=$$CODE(CODE) I 'CIEN Q  ; GET THE CORRECT CODE IEN
 . S X="""`"_CIEN_"""" ; THE .01 FIELD OF V PATIENT ED POINT TO THE EDUCATION TOPICS FILE
 . D ^DIC I Y=-1 Q
 . S (VPEIEN,DA)=+Y,DIE="^AUPNVPED("
 . S DR=".02////^S X=AUPNPAT;.03////^S X=APCDVSIT;.06///^S X=LOU;.07///^S X=GRP;.08///^S X=FTIME"
 . L +^AUPNVPED(DA):1 I  D ^DIE L -^AUPNVPED(DA)
 . K DA
 . S TOT=0,DA(1)=VPEIEN,DIC="^AUPNVPED("_DA(1)_",1,",DIC(0)="L",DLAYGO=9000010.161
 . S DIC("P")=$P(^DD(9000010.16,1,0),U,2)
 . F  S TOT=$O(ARR("CODE",CODE,TOT)) Q:'TOT  D  ; ENTER SUB TOPICS
 .. I '$D(ARR(TOT,1)) Q  ; TOPIC MUST BE SELECTED
 .. S X=$G(ARR("CODE",CODE,TOT)) I '$L(X) Q
 .. S X=$TR(X,$C(34),"") ; STRIP OFF QUOTES
 .. D ^DIC
 .. Q
 . Q
 D ^XBFMK
 Q
 ; 
CODE(CODE) ; EP - RETURN THE IEN OF THE MOST RECENT VALID/ACTIVE INSTANCE OF A PT ED CODE
 N OK,CIEN,%
 S OK=0,CIEN=999999
 F  S CIEN=$O(^AUTTEDT("C",CODE,CIEN),-1) Q:'CIEN  D  I OK=1 Q  ; FIND MOST RECENT VALID INSTANCE OF CODE
 . S %=$G(^AUTTEDT(CIEN,0)) I '$L(%) Q
 . I '$P(%,U,3) S OK=1 ; MUST HAVE A VALID CODE
 . Q
 Q CIEN
 ; 
LOU(TITLE,LOU,TIME,FTIME,EDU) ; EP - GET LEVEL OF UNDERSTANDING, TOTAL PT ED TIME AND FRACTIONAL PT ED TIME, EDUCATOR
 N DIR,X,Y,CNT,CODE,TOT,VWCIEN,LL,LT,DIC
 S (LL,LT)=""
 S VWCIEN=+$O(^AUPNVWC("AD",APCDVSIT,999999999),-1)
 S %=$G(^AUPNVWC(VWCIEN,0))
 I TITLE["nutrition" S LL=$P(%,U,8),LT=$P(%,U,7)
 E  S LL=$P(%,U,6),LT=$P(%,U,5)
 S DIC=200,DIC(0)="AEQM",DIC("A")="Name of educator: ",DIC("B")=$P($G(^AUPNVWC(VWCIEN,0)),U,4),EDU=""
 D ^DIC I +Y>0 S EDU=+Y
 W !!,"If possible, record the level of understanding and duration of ",TITLE,"session"
 S DIR(0)="SO^1:POOR;2:FAIR;3:GOOD;5:REFUSED"
 S DIR("A")="Level of understanding" I LL S DIR("B")=LL
 D ^DIR  K DIR I 'Y G TIME
 S LOU=Y
TIME S DIR(0)="NO^1:100:0"
 S DIR("A")="Total "_TITLE_"time (min)" I LT S DIR("B")=LT
 D ^DIR K DIR
 I 'Y D ^XBFMK Q
 S TIME=Y,CNT=0,CODE=""
 F  S CODE=$O(ARR("CODE",CODE)) Q:CODE=""  D
 . S TOT=0
 . F  S TOT=$O(ARR("CODE",CODE,TOT)) Q:'TOT  I $D(ARR(TOT,1)) S CNT=CNT+1 Q  ; IF CODE SELECTED, INC CNT
 . Q
 S FTIME=""
 I CNT S FTIME=TIME\CNT ; ARBITRARILY DIVIDE TOTAL TIME BY THE NUMBER OF V PATIENT ED ENTRIES FOR THIS VISIT
 I FTIME S FTIME=$J(FTIME,1,0) ; MUST BE AN INTEGER ; PATCHED BY GIS/OIT 1/17/2011
 D ^XBFMK
 Q
 ; 
