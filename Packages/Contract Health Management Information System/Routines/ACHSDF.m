ACHSDF ; IHS/ITSC/PMF - UNMET NEEDS DATA ENTRY (1/2) ;   [ 03/24/2005  8:22 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**18**;JUN 11, 2001
 ;ACHS*3.1*18 4/1/2010;IHS/OIT/ABK;Change every occurrance of Deferred to Unmet Need
 ;
 D SETCK^ACHSDF1       ;SET UP SITE PARAMETERS
 Q:$G(ACHDXQT)
START ; --- Set Temporary Number.
 I $D(^ACHSDEF(DUZ(2),"D",0))=0 S ^ACHSDEF(DUZ(2),"D",0)="^9002066.01A^0^0"
 S DIC="^ACHSDEF("_DUZ(2)_",""D"","
 S DA(1)=DUZ(2)
 S DIC(0)="L"
 S X="#"_$P($H,",",1)_"#"_$P($H,",",2)
 D ^DIC
 I +Y<1 S ACHDXIT="" D END Q
 S ACHSA=+Y
 ;
 ;FORCE ENTER 'DATE OF SERVICE' AND 'ISSUED BY'
 I '$$DIE("2////"_DT_";3////"_DUZ,2) S ACHDXIT="" D END Q
 D PAT
 Q:X[U
 D END
 Q
 ;
PAT ; --- Is Patient Registered.
 K DQ
 Q:'$$DIE("5//Y",2)
 I $D(Y) S ACHDXIT="" Q
 I $$DF^ACHS(0,5)="N" G PATNOT
 ;
 ;ITSC/SET/JVK ACHS*3.1*12 ADD CHANGES FOR IHS/OKCAO/POC PAWNEE BEN PKG
 ;Q:'$$DIE(6,2)
 ;I +$P($G(^AUTTLOC(DUZ(2),0)),U,10)=505613 Q:'$$DIEPWN ;ACHS*3.1*18 3.12.2010 IHS.OIT.FCJ ADDED ACHSDXIT TST
 I +$P($G(^AUTTLOC(DUZ(2),0)),U,10)=505613 Q:('$$DIEPWN)!(ACHDXIT) Q
 E  Q:'$$DIE(6,2)
 ;ITSC/SET/JVK END CHANGES ACHS*3.1*12
 I $D(Y) S ACHDXIT="" Q
 I '$$DF^ACHS(0,6) W !,*7,"A Patient Name Must Be Entered",!! G PAT
 D USER
 Q
 ;
PATNOT ; --- Patient not on file.
 K DQ
 Q:'$$DIE("7:13")
 I $D(Y) G PAT
 I '$L($$DF^ACHS(0,7)) W !,*7,"A Patient Name Must Be Entered",!! G PAT
 D USER
 Q
 ;
USER ; --- Set variables to file.
 Q:'$$DIE("3////"_DUZ)
 I $D(Y) S ACHDXIT="" Q
 D ISSDT
 Q
 ;
ISSDT ; --- Issue Date.
 Q:'$$DIE("2////"_DT)
 I $D(Y) S ACHDXIT="" Q
 D REQ
 Q
 ;
REQ ; --- Date Request Received.
 Q:'$$DIE(4,2)
 I $D(Y) S ACHDXIT="" Q
 I '$$DF^ACHS(0,4) W !,*7,"A Date Received Request Must Be Entered" G REQ
 D DEFCAT
 Q
 ;
DEFCAT ; --- Deferred Service Category.
 W !!
 ;{ABK,7/9/10}S DIC="^ACHSDFC(",DIC(0)="QAEM",DIC("A")="Enter Deferred Service Category: "
 S DIC="^ACHSDFC(",DIC(0)="QAEM",DIC("A")="Enter Unmet Need Category: "
 D ^DIC
 I X=U Q
 ;{ABK,7/9/10}I Y<0 W *7,!!,"Must Have Deferred Services Category",! G DEFCAT
 I Y<0 W *7,!!,"Must Have Unmet Need Category",! G DEFCAT
 S ACHDCAT=+Y
 Q:'$$DIE("100////"_ACHDCAT)
 ;
DEFSUB ; --- Deferred Service Subcategory
 W !!
 ;{ABK,7/9/10}S DIC="^ACHSDFC("_ACHDCAT_",1,",DIC(0)="AQEM",DIC("A")="Enter Deferred Service Subcategory: "
 S DIC="^ACHSDFC("_ACHDCAT_",1,",DIC(0)="AQEM",DIC("A")="Enter Unmet Need Subcategory: "
 D ^DIC
 I X=U Q
 ;{ABK,7/9/10}I Y<0 W *7,!!,"Must Have Deferred Service Subcategory",! G DEFSUB
 I Y<0 W *7,!!,"Must Have Unmet Need Subcategory",! G DEFSUB
 S ACHDSUB=+Y
 Q:'$$DIE("105////"_ACHDSUB)
 Q:'$$DIE("110:130",2)
 I $D(Y) G DEFCAT
 D DEFDIAG
 Q
 ;
DEFDIAG ; --- Deferred Service Diagnosis.
 I $$DF^ACHS(100,2)="O" G DEFPROC
 Q:'$$DIE(200,2)
 I $D(Y) S ACHDXIT="" Q
 I '$D(^ACHSDEF(DUZ(2),"D",ACHSA,200,0)) W !,*7,"An ICD9 Diagnosis Code Must Be Entered",!! G DEFDIAG
 D DEFCMT
 Q
 ;
DEFPROC ; --- Deferred Service CPT.
 Q:'$$DIE(300,2)
 I $D(Y) S ACHDXIT="" Q
 I '$D(^ACHSDEF(DUZ(2),"D",ACHSA,300,0)) W !,*7,"A CPT Procedure Code Must Be Entered",!! G DEFPROC
 D DEFCMT
 Q
 ;
DEFCMT ; --- Comment. 
 Q:'$$DIE(400,2)
 I $D(Y) S ACHDXIT="" Q
 D DEFDCT
 Q
 ;
DEFDCT ; --- Document Control.
 W !!
 K DIR
 S DIR(0)="Y",DIR("A")="Enter Document Control Information Now",DIR("B")="NO"
 S DIR("?",1)="Answer 'Y' if patient or their representative is picking up the document in person.",DIR("?")="Answer 'N' if document is being mailed."
 D ^DIR
 I Y Q:'$$DIE("500////Y;501:503",2)  I $D(Y) S ACHDXIT="" Q
 Q
 ;
 ;EP - Denial Issued.
 Q:'$$DIE("504:505",2)
 I $D(Y) S ACHDXIT="" D END Q
 Q
 ;
DEFPO ; --- Service Provided on PO.
 Q:'$$DIE("506:507",2)
 I $D(Y) S ACHDXIT="" Q
 Q
 ;
END ;
 D:'$D(ACHDXIT) ^ACHSDFDP                    ;DISPLAY DOCUMENT INFO
 ;                                            IF NO EXIT THEN
 I '$D(ACHDXIT),'$D(DUOUT) D NUMBER^ACHSDF1   ;SET THE DEFERRED SERVICE
 ;                                            NUMBER AND POST THE
 ;                                            DOCUMENT 
 K ACHDXIT
 Q
 ;
DOCNTL1 ;EP - CALLED FROM OPTION 'ACHS DEF DOCNTL' Enter Document Control Info
 D SETCK^ACHSDF1                   ;CLEAR PHONY DOCUMENTS
 N ACHSA,DA,DIC,DIE
 W !!
 S DIC="^ACHSDEF("_DUZ(2)_",""D"",",DA(1)=DUZ(2),DIC(0)="AQEM"
 D ^DIC
 Q:Y<1
 S ACHSA=+Y
 I $$DIE("500////Y;501:503",2)
 Q
 ;
DENIAL ;EP - CALLED FROM OPTION 'ACHS DEN INFO' Enter Denial Info
 D SETCK^ACHSDF1                ;CLEAR PHONY DOCUMENTS
 N ACHSA,DA,DIC,DIE
 W !!
 S DIC="^ACHSDEF("_DUZ(2)_",""D"",",DA(1)=DUZ(2),DIC(0)="AQEM"
 D ^DIC
 Q:Y<1
 S ACHSA=+Y
 I $$DIE("504;505",2)
 Q
 ;
PO ;EP - CALLED FROM OPTION 'ACHS DEF PO' Enter Purchase Order Info
 D SETCK^ACHSDF1                 ;CLEAR PHONY DOCUMENTS
 N ACHSA,DA,DIC,DIE
 W !!
 S DIC="^ACHSDEF("_DUZ(2)_",""D"",",DA(1)=DUZ(2),DIC(0)="AEQM"
 D ^DIC
 Q:Y<1
 S ACHSA=+Y
 I $$DIE("506;507",2)
 Q
 ;
DIE(DR,Z) ;EP --- Edit Deferred Service
 I $G(Z) F %=1:1:Z W !
 S DIE="^ACHSDEF("_DUZ(2)_",""D"","
 S DA(1)=DUZ(2)
 S DA=ACHSA
 S AUPNLK("INAC")=""
 S ACHDALL=1
 ;S DIC("S")="I $D(^AUPNPAT(Y,41,DUZ(2)))"
 ;
 ;S DIC("W")="I $D(^AUPNPAT(Y,41,DUZ(2)))"
 ;
 I '$$LOCK^ACHS("^ACHSDEF(DUZ(2),""D"",ACHSA)","+") S DUOUT="" Q 0
 D ^DIE I $D(Y) S ACHDXIT=""
 I '$$LOCK^ACHS("^ACHSDEF(DUZ(2),""D"",ACHSA)","-") S DUOUT="" Q 0
 Q 1
 ;
DIEPWN() ;ITSC/SET/JVK ADD FOR ACHS*3.1*12 IHS/OKCAO/POC PAWNEE BEN PKG
 N PBEXDT,DFN,DUZSAVE
 S DIC=1808000,DIC(0)="IQAZEM" S:$D(DFN) DIC("B")=$P($G(^DPT(DFN,0)),U)
 D ^DIC K DIC
 I $D(DUOUT)!($D(DTOUT))!(+Y<0) Q 0
 S DFN=+Y
 ;ACHS*3.1*15 1.26.2009 IHS/OIT/FCJ ADDED $ IN FRONT OF THE P($G TO THE NEXT LINE
 S PBEXDT=+$P($G(^AZOPBPP(+Y,0)),U,3),Y=PBEXDT X ^DD("DD")
 I PBEXDT<DT W !!,*7,"PBPP Eligibility Card Expired on ",Y Q 0
 F %=1:1:2 W !
 S DIE="ACHSDEF("_DUZ(2)_",""D"","
 S DA(1)=DUZ(2)
 S DA=ACHSA
 S AUPNLK("INAC")=""
 S DUZSAVE=DUZ(2),DUZ(2)=0
 S ACHDALL=1
 I '$$LOCK^ACHS("^ACHSDEF(DUZ(2),""D"",ACHSA)","+") S DUOUT="" Q 0
 S DFN="`"_DFN
 S DR="6///^S X=DFN" D DIE I $D(Y) S ACHDXIT=""
 S DUZ(2)=DUZSAVE
 I '$$LOCK^ACHS("^ACHSDEF(DUZ(2),""D"",ACHSA)","-") S DUOUT="" Q 0
 Q 1
