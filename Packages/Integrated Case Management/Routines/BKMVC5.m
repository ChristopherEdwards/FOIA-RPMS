BKMVC5 ;PRXM/HC/JGH - Patient Record Edit (Unreviewed Status); 24-JAN-2005 ; 09 Jun 2005  2:01 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
EN ; -- main entry point for BKMV Update Patient Data 1
 ;
 ; D EN^BKMVAUD   ; Audit routine called before edit
 ; D POST^BKMVAUD ; Audit routine called after edit
 ;
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 I '$$VALID^BKMIXX3(DUZ) W !,"You are not a valid HMS user."  H 2 Q
 ;
EN1 K ^TMP("BKMVC5",$J)
 D GETALL I $G(DFN)="" G CLEAN
 D EN^VALM("BKMV R/E PATIENT RECORD",)
 I $D(DTOUT)!$D(DUOUT)!($G(Y)<0) G CLEAN
 G EN1
 ;
GETALL ; -- init variables and list array
 N HRN,DOB,NAME,STATUS,TEXT,DA1,DA
 ; Review "Unreviewed" patients
 ;
 S STATUS="R"
 D RLK^BKMPLKP("I $$STAT^BKMIXX5(STATUS)") I $G(DFN)="" Q
 S DA=$O(^BKM(90451,"B",DFN,0))
 D BASETMP^BKMIXX3(DFN)
 Q
SETSTAT(DFN) ;
 D ^XBFMK ; Kills off a lot of Fileman variables
 S DA(1)=$O(^BKM(90451,"B",DFN,""))
 Q:DA(1)=""
 S DA=$O(^BKM(90451,DA(1),1,"B",HIVIEN,""))
 Q:DA=""
 S DR=".5///"_STATUS  ; "LMNZ"
 S DIE="^BKM(90451,"_DA(1)_",1," ; ,DIADD=1
 D ^DIE
 D ^XBFMK
 Q
GETPNP() ;
 K DIC,DFN,DA
 N STATUS
 S STATUS="R"
 D RLK^BKMPLKP("I $$STAT^BKMIXX5(STATUS)")
 I $G(DFN)="" D ^XBFMK Q 0
 S IEN=BKMRIEN
 S PNT=$G(PTNAME),AGE=$G(AGE)
 S DOB=$$FMTE^XLFDT(DOB,"5Z"),SEX=$G(SEX)
 D ^XBFMK
 Q 1
MAINPRMP ;
 N EXIT,HIVIEN
 S EXIT=0
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" W !,"There is no HMS register defined." H 2 Q
 I '$$VALID^BKMIXX3(DUZ) W !,"You are not a valid HMS user."  Q
 F  D  Q:EXIT
 . I '$$GETPNP S EXIT=1 Q
 . ;I '$$UNREV(DFN) W !,"Patient does not have a status of unreviewed" Q
 . S STATUS=$$STATPRMP
 . I STATUS="" Q
 . I '$$YNPRMP("Change status of "_PNT_" to "_Y(0)_"") Q
 . D SETSTAT(DFN)
 Q
UNREV(DFN) ;
 S DA(1)=$O(^BKM(90451,"B",DFN,""))
 Q:DA(1)=""
 S DA=$O(^BKM(90451,DA(1),1,"B",HIVIEN,""))
 Q:DA=""
 S IENS=$$IENS^DILF(.DA)
 S STAT=$$GET1^DIQ(90451.01,IENS,.5,"I")
 Q $S(STAT="R":1,1:0)
STATPRMP() ;
 S DIR(0)="S^"_$P(^DD(90451.01,.5,0),"^",3)
 S DIR("A")="Status"
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) Q ""
 Q Y
YNPRMP(PROMPT) ;
 N DIR,X,YU
 S DIR(0)="Y"
 S DIR("A")=PROMPT
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) Q 0
 Q Y
HELP ;
 Q
EXIT ;
 Q
EXPND ;
 Q
INIT ;
 Q
HRN(DFN) ;
 N DA,IENS
 S DA(1)=DFN,DA=DUZ(2)
 S IENS=$$IENS^DILF(.DA)
 S HRN=$$GET1^DIQ(9000001.41,IENS,.02,"E"),HRN=$G(HRN,"None Found")
 W !,"  **  ",HRN H 3
 Q HRN
CLEAN ;
 K AGE,BKMSTAT,DTOUT,DUOUT,HIVIEN,IEN,PNT,SEX,SITE,STATUS,Y
 K ^TMP("BKMVC5",$J)
 Q
