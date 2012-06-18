GMRAUTL2 ;SLC/DAN New style index utilities, update utility for 120.8 ;1/3/07  08:02
 ;;4.0;Adverse Reaction Tracking;**23,36**;Mar 29, 1996;Build 9
 ;
 N GMRAI,GMRAC,ENTRY,UPDATED
 Q:$G(X1(1))=$G(X2(1))  ;Entry unchanged
 S ENTRY=DA(1)_";GMRD(120.82,"_"^"_$P(^GMRD(120.82,DA(1),0),"^")
 I $G(X1(1))>0,$G(X2(1))>0 S:$G(GMRAT)="ING" GMRAI("D",X1(1))="",GMRAI("A",X2(1))="" S:$G(GMRAT)="CLASS" GMRAC("D",X1(1))="",GMRAC("A",X2(1))="" ;Edited existing entry
 I $G(X1(1))>0,$G(X2(1))="" S:$G(GMRAT)="ING" GMRAI("D",X1(1))="" S:$G(GMRAT)="CLASS" GMRAC("D",X1(1))="" ;Entry deleted
 I $G(X1(1))="",$G(X2(1))>0 S:$G(GMRAT)="ING" GMRAI("A",X2(1))="" S:$G(GMRAT)="CLASS" GMRAC("A",X2(1))="" ;New entry
 D QUP ;Queue updating of existing entries and order checking
 Q
 ;
QUP ;Queue the update
 S ZTRTN="UPDATE^GMRAUTL2(ENTRY,.GMRAI,.GMRAC)",ZTIO="GMRA UPDATE RESOURCE",ZTDTH=$H,ZTDESC="Update existing allergies",ZTSAVE("*")="" D ^%ZTLOAD Q
 ;
UPDATE(ENTRY,ING,CLASS) ;Update existing entries in 120.8 with new information.
 ;Entry is IEN;File reference^Text of file entry - 6;GMRD(120.82,^STRAWBERRIES
 ;ING - Array of ingredients - "A",IEN for those to be added and "D",IEN for those to be deleted
 ;CLASS - Array of drug classes - "A",IEN for those to be added and "D",IEN for those to be deleted
 ;
 N ALLERGY,POINTER,ACTION,SUB,SUBI,SUBC,DFN,GMRAS,GMRACOM
 S ALLERGY=$P(ENTRY,"^",2) Q:ALLERGY=""
 S POINTER=$P(ENTRY,"^") Q:POINTER=""
 S SUB=0 F  S SUB=$O(^GMR(120.8,"C",ALLERGY,SUB)) Q:'+SUB  D
 .S DFN=$P(^GMR(120.8,SUB,0),U)
 .Q:$$DECEASED^GMRAFX(DFN)  ;Don't update if patient is deceased
 .Q:$P(^GMR(120.8,SUB,0),"^",3)'=POINTER  ;Same text name but not the same entry
 .Q:$G(^GMR(120.8,SUB,"ER"))>0  ;Entered in error
 .S GMRACOM=0
 .F ACTION="A","D" D
 ..S SUBI=0 F  S SUBI=$O(ING(ACTION,SUBI)) Q:'+SUBI  D
 ...I ACTION="A" D ADD("I",SUB,SUBI,.GMRAS) I $G(GMRAS) S ING(ACTION,SUBI)=1,GMRACOM=1,UPDATED(DFN)=""
 ...I ACTION="D" D DEL("I",SUB,SUBI,.GMRAS) I $G(GMRAS) S ING(ACTION,SUBI)=1,GMRACOM=1
 ..S SUBC=0 F  S SUBC=$O(CLASS(ACTION,SUBC)) Q:'+SUBC  D
 ...I ACTION="A" D ADD("C",SUB,SUBC,.GMRAS) I $G(GMRAS) S CLASS(ACTION,SUBC)=1,UPDATED(DFN)="",GMRACOM=1
 ...I ACTION="D" D DEL("C",SUB,SUBC,.GMRAS) I $G(GMRAS) S GMRACOM=1,CLASS(ACTION,SUBC)=1
 .I $G(GMRACOM) D ADDCOM
 I $D(UPDATED) D CHKORD ;New order checks now?
 Q
 ;
ADD(TYPE,ALENT,SUBENT,GMRAS) ;Adds entry to appropriate multiple
 N FILE,FDA,EM
 S GMRAS=1
 I $D(^GMR(120.8,ALENT,$S(TYPE="I":2,1:3),"B",SUBENT)) S GMRAS=0 Q  ;Entry already exists
 L +^GMR(120.8,ALENT)
 S FILE=$S(TYPE="I":120.802,1:120.803)
 S FDA(FILE,"+1,"_ALENT_",",.01)=SUBENT
 D UPDATE^DIE("","FDA",,"EM")
 L -^GMR(120.8,ALENT)
 Q
 ;
DEL(TYPE,ALENT,SUBENT,GMRAS) ;Delete entry from multiple
 N FILE,FDA,EM,ENTRY
 S GMRAS=1
 I '$D(^GMR(120.8,ALENT,$S(TYPE="I":2,1:3),"B",SUBENT)) S GMRAS=0 Q  ;No entry to delete
 L +^GMR(120.8,ALENT)
 S ENTRY=$O(^GMR(120.8,ALENT,$S(TYPE="I":2,1:3),"B",SUBENT,0)) Q:'+ENTRY
 S FILE=$S(TYPE="I":120.802,1:120.803)
 S FDA(FILE,ENTRY_","_ALENT_",",.01)="@"
 D FILE^DIE("","FDA","EM")
 L -^GMR(120.8,ALENT)
 Q
 ;
CHKORD ;Check for orders that are now in conflict with existing allergy data
 N TIME,GMRAOC,ORX,SUB,GMRAORX,GI,CNT,DFN
 Q:'+$G(DUZ)  ;Don't check if no valid user to send data to
 K ^TMP("ORR",$J),^TMP($J,"ERR")
 S DFN=0 F  S DFN=$O(UPDATED(DFN)) Q:'+DFN  D
 .D EN^ORQ1(DFN_";DPT(") ;Retrieve active orders
 .S TIME=$O(^TMP("ORR",$J,0))
 .Q:'^TMP("ORR",$J,TIME,"TOT")  ;No orders found
 .S SUB=0 F  S SUB=$O(^TMP("ORR",$J,TIME,SUB)) Q:'+SUB  D
 ..D BLD^ORCHECK(+^TMP("ORR",$J,TIME,SUB)) ;Get "order" information in order checking format
 .M GMRAORX=ORX K ORX,GMRAOC
 .D EN^ORKCHK(.GMRAOC,DFN,.GMRAORX,"ACCEPT")
 .S GI=0,CNT=0 F  S GI=$O(GMRAOC(GI)) Q:'+GI  D
 ..Q:$P(GMRAOC(GI),U,2)'=3  ;Quit if not allergy related
 ..Q:$D(^OR(100,$P(GMRAOC(GI),U),9,"B",3))  ;Quit if existing allergy order check, can't be for this new information
 ..S CNT=CNT+1,^TMP($J,"ERR",DFN,CNT)=$P($$STATUS^ORQOR2($P(GMRAOC(GI),U)),U,2)_" order for "_$P($$OI^ORX8($P(GMRAOC(GI),U)),U,2)_",order #"_$P(GMRAOC(GI),U)
 .K GMRAORX ;Remove previous list of orders
 D MAIL K ^TMP("ORR",$J),^TMP($J,"ERR")
 Q
 ;
ADDCOM ;Add comment to updated allergy indicating changes
 Q
 N TYPE,ROOT,SUB2,DICR,DIEL,DL,DP,DM,DK,DIK,DC,DE,GLOB,DH,D,DQ,DR,DIC,DIE,DIA,DI,DG,DDH,DDER,DA,D0,D1
 F GLOB="ING(""A"")","ING(""D"")","CLASS(""A"")","CLASS(""D"")" I $D(@GLOB) D
 .S TYPE=$S(GLOB="ING(""A"")":1,GLOB="ING(""D"")":2,GLOB="CLASS(""A"")":3,1:4) ;Determines if we're adding or deleting ingredients or classes
 .S COM="The following "_$S(TYPE=1!(TYPE=2):"ingredients",1:"drug classes")_" were "_$S(TYPE=2!(TYPE=4):"deleted",1:"added")_": "
 .S ROOT=$S(TYPE=1:"ING(""A"")",TYPE=2:"ING(""D"")",TYPE=3:"CLASS(""A"")",1:"CLASS(""D"")")
 .S SUB2=0 F  S SUB2=$O(@ROOT@(SUB2)) Q:'+SUB2  I @ROOT@(SUB2) S COM=COM_$S($P(COM,": ",2)'="":", ",1:"")_$S(TYPE=1!(TYPE=2):$$GET1^DIQ(50.416,SUB2_",",.01),1:$$GET1^DIQ(50.605,SUB2_",",.01))
 .I $P(COM,": ",2)'="" L +^GMR(120.8,SUB) D ADCOM^GMRAFX(SUB,"O",COM) L -^GMR(120.8,SUB)
 Q
 ;
MAIL ;Send message containing potential order checks to user.
 N XMSUB,XMTEXT,XMDUZ,XMY,XMZ,CNT,SUB,ERR,TYPE,NUM
 Q:'$D(^TMP($J,"ERR"))  ;Nothing to report
 K ^TMP($J,"TEXT")
 S XMDUZ="Allergy auto-update program"
 S XMY($G(DUZ,.5))="" ;Send to user who initiated change or postmaster
 S XMY("G.GMRA REQUEST NEW REACTANT")="" ;Include mail group to be sure someone gets this message
 S CNT=1
 S ^TMP($J,"TEXT",CNT)="The "_$P(ENTRY,U,2)_" reactant was updated.",CNT=CNT+1
 S ^TMP($J,"TEXT",CNT)="The following drug classes and/or drug ingredients were added:",CNT=CNT+1,^TMP($J,"TEXT",CNT)="",CNT=CNT+1
 F TYPE="GMRAI","GMRAC" D
 .I $D(@(TYPE)) D
 ..S ^TMP($J,"TEXT",CNT)=$S(TYPE="GMRAI":"Ingredients",1:"Classes")_": ",CNT=CNT+1
 ..S NUM=0 F  S NUM=$O(@TYPE@("A",NUM)) Q:'+NUM  S ^TMP($J,"TEXT",CNT)=$G(^TMP($J,"TEXT",CNT))_$S($L($G(^TMP($J,"TEXT",CNT))):",",1:"")_$$GET1^DIQ($S(TYPE="GMRAI":50.416,1:50.605),NUM_",",.01)
 ..S CNT=CNT+1,^TMP($J,"TEXT",CNT)="",CNT=CNT+1
 S ^TMP($J,"TEXT",CNT)="As a result of the update the following patients have drug-allergy",CNT=CNT+1
 S ^TMP($J,"TEXT",CNT)="interactions that need to be reviewed to ensure the patient's safety.",CNT=CNT+1
 S SUB=0 F  S SUB=$O(^TMP($J,"ERR",SUB)) Q:'+SUB  D
 .S ^TMP($J,"TEXT",CNT)="",CNT=CNT+1
 .S ^TMP($J,"TEXT",CNT)=$$GET1^DIQ(2,SUB_",",.01),CNT=CNT+1
 .S ERR=0 F  S ERR=$O(^TMP($J,"ERR",SUB,ERR)) Q:'+ERR  S ^TMP($J,"TEXT",CNT)="   "_^TMP($J,"ERR",SUB,ERR),CNT=CNT+1
 S XMTEXT="^TMP($J,""TEXT"",",XMSUB="Potential order checks from allergy update"
 D ^XMD
 K ^TMP($J,"TEXT")
 Q
 ;
TOP10 ;Check top 10 reactions after push of file 120.83
 N SUB,REAC,REACNO,ARRAY,SUBNM,REACNM,GMRATXT,XMSUB,XMTEXT,XMDUZ,XMY,DIFROM,CNT
 I '$L($T(SCREEN^XTID)) Q  ;No screening code so quit
 S SUB=0 F  S SUB=$O(^GMRD(120.84,SUB)) Q:'+SUB  I $D(^GMRD(120.84,SUB,1)) D
 .S REAC=0 F  S REAC=$O(^GMRD(120.84,SUB,1,REAC)) Q:'+REAC  D
 ..S REACNO=$P(^GMRD(120.84,SUB,1,REAC,0),U) Q:'+REACNO
 ..I $$SCREEN^XTID(120.83,.01,REACNO_",") D
 ...S SUBNM=$P(^GMRD(120.84,SUB,0),U),REACNM=$P(^GMRD(120.83,REACNO,0),U)
 ...S ARRAY(SUBNM,REACNM)=""
 I $D(ARRAY) D
 .S XMDUZ="Data Standardization update of file 120.83",XMY("G.GMRA REQUEST NEW REACTANT")=""
 .S GMRATXT(1)="The signs/symptoms file has been automatically updated.  You're receiving"
 .S GMRATXT(2)="this message because one or more signs/symptoms was inactivated during this"
 .S GMRATXT(3)="update and the term(s) appear in your top ten list and must be replaced."
 .S GMRATXT(4)="Below you will find the name of the site parameter and the terms that are now"
 .S GMRATXT(5)="inactive for that entry.  Use the Enter/Edit Site Parameters [GMRA SITE FILE]"
 .S GMRATXT(6)="option to find and replace these terms."
 .S GMRATXT(7)=""
 .S CNT=7
 .S SUB="" F  S SUB=$O(ARRAY(SUB)) Q:SUB=""  S CNT=CNT+1,GMRATXT(CNT)="Site parameter: "_SUB D  S CNT=CNT+1,GMRATXT(CNT)=""
 ..S REAC="" F  S REAC=$O(ARRAY(SUB,REAC)) Q:REAC=""  S CNT=CNT+1,GMRATXT(CNT)="Term: "_REAC
 .S XMTEXT="GMRATXT(",XMSUB="Signs/symptoms require updating"
 .D ^XMD
 Q
 ;
QREACT ;Queue name update, called from "AC" xref in file 120.82.  Entire section added in patch 23
 N OTERM,NTERM,ZTRTN,ZTDTH,ZTIO,ZTDESC
 Q:X1(1)=""!(X2(1)="")  ;Entry is new or has been deleted, no updating required
 Q:X1(1)=X2(1)  ;Entry has been updated to same value, no updating required
 S OTERM=X1(1),NTERM=X2(1)
 S ZTRTN="REACT^GMRAUTL2",ZTIO="GMRA UPDATE RESOURCE",ZTDTH=$H,ZTDESC="UPDATE REACTANT FIELD IN 120.8",ZTSAVE("*")="" D ^%ZTLOAD
 Q
 ;
REACT ;Update REACTANT field with name from 120.82.  Section added with patch 23
 N IEN,FDA,EM,DFN
 S IEN=0 F  S IEN=$O(^GMR(120.8,"C",OTERM,IEN)) Q:'+IEN  D
 .S DFN=$P(^GMR(120.8,IEN,0),U)
 .Q:$$DECEASED^GMRAFX(DFN)  ;Don't update if patient is deceased
 .Q:+$G(^GMR(120.8,IEN,"ER"))  ;Don't update if entered in error
 .L +^GMR(120.8,IEN)
 .S FDA(120.8,IEN_",",.02)=NTERM
 .D FILE^DIE("","FDA","EM")
 .L -^GMR(120.8,IEN)
 Q
 ;
QTYPE ;Queue allergy type updates, section added in 36
 N ENTRY
 S ENTRY=DA_";GMRD(120.82,"_"^"_$P(^GMRD(120.82,DA,0),"^")
 Q:X1(1)=""!(X2(1)="")
 Q:X1(1)=X2(1)
 S ZTRTN="TYPE^GMRAUTL2",ZTIO="",ZTDTH=$H,ZTDESC="Allergy type updates",ZTSAVE("*")="" D ^%ZTLOAD
 Q
 ;
TYPE ;Find related entries in 120.8 and update, section added in 36
 N ALLERGY,POINTER,DFN,SUB
 S ALLERGY=$P(ENTRY,"^",2) Q:ALLERGY=""
 S POINTER=$P(ENTRY,"^") Q:POINTER=""
 S SUB=0 F  S SUB=$O(^GMR(120.8,"C",ALLERGY,SUB)) Q:'+SUB  D
 .Q:$P(^GMR(120.8,SUB,0),"^",3)'=POINTER  ;Same text name but not the same entry
 .S DFN=$P(^GMR(120.8,SUB,0),U)
 .Q:$$DECEASED^GMRAFX(DFN)  ;Don't update if patient is deceased
 .Q:$G(^GMR(120.8,SUB,"ER"))>0  ;Entered in error
 .S DR="3.1///"_X2(1),DIE=120.8,DA=SUB D ^DIE ;Update allergy type
 Q
