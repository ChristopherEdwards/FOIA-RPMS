BLRF612A ; IHS/OIT/MKK - IHS Lab: File 61.2 Add from DTS Server ; 22-Oct-2013 09:22 ; MKK
 ;;5.2;LAB SERVICE;**1033**;NOV 1, 1997
 ;
 ; Add entries to ETIOLOGY FIELD (#61.2) dictionary using lookup into DTS Server and then guiding
 ; user to enter data for specific fields so as to use an UPDATE^DIE call to update the dictionary.
 ;
PEP ; EP
EP ; EP
EEP ; Ersatz EP
 D EEP^BLRGMENU
 Q
 ;
ADDIT ; EP - Add an Entry
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D ^XBCLS
 S (BAIL,FOUNDSUM)=0
 F  Q:FOUNDSUM!(BAIL)  D
 . W !!
 . D ^XBFMK
 . S DIR(0)="F"
 . S DIR("A")="Enter SNOMED Description (Free Text)"
 . D ^DIR
 . I +$G(DIRUT) D  Q
 .. W !,?4,"Quit or No/Invalid Input.  Routine Ends."
 .. D PRESSKEY^BLRGMENU(9)
 .. S BAIL=1
 . ;
 . S OUT="VARS",IN=$G(X)_"^F^^^^100"
 . S FOUNDSUM=$$SEARCH^BSTSAPI(OUT,IN)
 . I FOUNDSUM<1 W !!,?9,"No entries found in the IHS STANDARD TERMINOLOGY database.  Try Again."
 ;
 Q:BAIL
 ;
 S WHICHONE=0
 D EN^BLRSM
 I WHICHONE<1 D  Q
 . W !,?4,"No Entry Selected.  Routine Ends."
 . D PRESSKEY^BLRGMENU(9)
 ;
 D REST61P2
 Q
 ;
REST61P2 ; EP - Enter rest of data needed to update 61.2
 S STR=$G(SNOMED(WHICHONE))
 S SNOMED=$P(STR,"^")
 S SNOMEDSC=$P(STR,"^",2)
 ;
 Q:$$ALREADY(SNOMED,SNOMEDESC)
 ;
 D CGTRIBEF
 D GRAMSTAN
 D IDENTIFR
 D ABBREV
 D SUSEDITT
 D HDEPTRPT
 ;
 K ERRS,FDA
 S FDA(61.2,"+1,",.01)=SNOMEDSC
 S FDA(61.2,"+1,",2)=SNOMED
 S:$L(GRAMSTAN) FDA(61.2,"+1,",3)=GRAMSTAN
 S:$L(IDENTIFR) FDA(61.2,"+1,",4)=IDENTIFR
 S:$L(ABBREV) FDA(61.2,"+1,",6)=ABBREV
 S:$L(SUSEDITT) FDA(61.2,"+1,",8)=SUSEDITT
 S:$L(HDEPTRPT) FDA(61.2,"+1,",10)=HDEPTRPT
 S:$L(CGTRIBEF) FDA(61.2,"+1,",1.6)=CGTRIBEF
 ;
 D UPDATE^DIE("ES","FDA","ERRS")
 ;
 I $D(ERRS) D ERRORS  Q
 ;
 D DISPLAY(+$$FIND1^DIC(61.2,,,SNOMEDSC))
 ;
 Q
 ;
ALREADY(SNOMED,SNOMEDESC) ; EP - Is the selected entry already in 61.2?
 NEW ALREADY
 ;
 S ALREADY=$$FIND1^DIC(61.2,,,SNOMEDSC,,,"ERRS")
 I ALREADY D
 . W !,?4,"SNOMED ",SNOMED," already exists in ETIOLOGY FIELD (#61.2) File.  Routine Ends."
 . D PRESSKEY^BLRGMENU(9)
 Q ALREADY
 ;
CGTRIBEF ; EP - CLASS/GROUP-TRIBE/FAMILY
 D ^XBCLS
 S CGTRIBEF=""
 D ^XBFMK
 S DIR(0)="FO^1:30"
 S DIR("A")="CLASS/GROUP-TRIBE/FAMILY"
 S DIR("?")="The class/group or tribe/family the etiologic agent belongs to."
 D ^DIR
 I +$G(DIRUT) D NOSELECT("CLASS/GROUP-TRIBE/FAMILY")  Q
 ;
 S CGTRIBEF=$G(X)
 Q
 ;
GRAMSTAN ; EP - GRAM STAIN
 D ^XBCLS
 S GRAMSTAN=""
 ;
 D ^XBFMK
 S DIR(0)="S^1:;2:;3:;4:;"
 S DIR("L",1)="Select GRAM STAIN:"
 S DIR("L",2)=""
 S DIR("L",3)="     1) GRAM POSITIVE"
 S DIR("L",4)="     2) GRAM NEGATIVE"
 S DIR("L",5)="     3) INDETERMINATE"
 S DIR("L",6)="     4) EXIT/NO SELECTION"
 S DIR("L")=""
 S DIR("A")="Selection"
 D ^DIR
 ;
 I +$G(DIRUT)!(+$G(Y)<1) D NOSELECT("GRAM STAIN")  Q
 ;
 S GRAMSTAN=$S(Y=1:"P",Y=2:"N",Y=3:"I",1:"")
 Q
 ;
IDENTIFR ; EP - IDENTIFIER
 D ^XBCLS
 S IDENTIFR=""
 ;
 D ^XBFMK
 S DIR(0)="S^1:;2:;3:;4:;5:;6:;7:;8:;"
 S DIR("L",1)="Select category into which the etiologic agent falls:"
 S DIR("L",2)=""
 S DIR("L",3)="     1) BACTERIUM"
 S DIR("L",4)="     2) FUNGUS"
 S DIR("L",5)="     3) PARASITE"
 S DIR("L",6)="     4) MYCOBACTERIUM"
 S DIR("L",7)="     5) VIRUS"
 S DIR("L",8)="     6) CHEMICAL"
 S DIR("L",9)="     7) DRUG"
 S DIR("L",10)="     8) EXIT/NO SELECTION"
 S DIR("L")=""
 S DIR("A")="Selection"
 S DIR("?")="This field identifies the category into which this etiologic agent falls."
 D ^DIR
 ;
 I +$G(DIRUT)!(+$G(Y)<1) D NOSELECT("IDENTIFIER")  Q
 ;
 S IDENTIFR=$S(Y=1:"B",Y=2:"F",Y=3:"P",Y=4:"M",Y=5:"V",Y=6:"C",Y=7:"D",1:"")
 Q
 ;
ABBREV ; EP - ABBREVIATION
 D ^XBCLS
 S ABBREV=""
 D ^XBFMK
 S DIR(0)="FO^1:5"
 S DIR("A")="ABBREVIATION"
 D ^DIR
 I +$G(DIRUT) D NOSELECT("CLASS/GROUP-TRIBE/FAMILY")  Q
 ;
 S ABBREV=$G(X)
 Q
 ;
SUSEDITT ; EP - SUSCEPTIBILITY EDIT TEMPLATE
 NEW ARRAY,CNT,DIRZERO,IEN,INDEX,TMPLNAME
 ;
 D ^XBCLS
 S SUSEDITT=""
 ;
 S IEN=0
 F  S IEN=$O(^DIE(IEN))  Q:IEN<1  D
 . I $P($G(^DIE(IEN,0)),"^",4)=63  S ARRAY($P($G(^(0)),"^"))=IEN
 ;
 S DIRZERO="S^"
 S CNT=0,TMPLNAME=""
 F  S TMPLNAME=$O(ARRAY(TMPLNAME))  Q:TMPLNAME=""  D
 . S CNT=CNT+1
 . S DIRZERO=DIRZERO_CNT_":;"
 . S DIRZERO(CNT)=$$LJ^XLFSTR($J(CNT,2)_") "_$E(TMPLNAME,1,18),26)
 . S INDEX(CNT)=TMPLNAME
 ;
 ; Add EXIT/NO SELECTION
 S CNT=CNT+1
 S DIRZERO=DIRZERO_CNT_":;"
 S DIRZERO(CNT)=$$LJ^XLFSTR($J(CNT,2)_") EXIT/NO SELECTION",26)
 S INDEX(CNT)=""
 ;
 S CNT=CNT+1
 S DIRZERO=DIRZERO_(CNT)_":AL"
 ;
 D ^XBFMK
 S DIR(0)=DIRZERO
 S DIR("L",1)="Select SUSCEPTIBILITY EDIT TEMPLATE:"
 S DIR("L",2)=""
 S BELOW=3
 S CNT=0
 F  S CNT=$O(DIRZERO(CNT))  Q:CNT<1  D
 . S:(CNT#3)=1 DIR("L",BELOW)=$J("",2)
 . S DIR("L",BELOW)=$G(DIR("L",BELOW))_DIRZERO(CNT)
 . S:(CNT#3)=0 BELOW=BELOW+1
 ;
 S DIR("L")=""
 S DIR("A")="Selection"
 S DIR("?")="Contains the edit template name the etiologic agent is associated with."
 S DIR("??")="Determines the set of antibiotics that will be shown for editing when this organism is chosen."
 D ^DIR
 ;
 I +$G(DIRUT) D NOSELECT("SUSCEPTIBILITY EDIT TEMPLATE")  Q
 ;
 S SUSEDITT=$G(INDEX(Y))
 Q
 ;
HDEPTRPT ; EP - HEALTH DEPT REPORT
 D ^XBCLS
 S HDEPTRPT=""
 D ^XBFMK
 S DIR(0)="YO"
 S DIR("A")="HEALTH DEPARTMENT REPORT"
 D ^DIR
 I +$G(DIRUT) D NOSELECT("HEALTH DEPARTMENT REPORT")  Q
 ;
 S HDEPTRPT=$E(X)
 Q
 ;
DISPLAY(IEN) ; EP - Display the entry in 61.2
 S DA=IEN
 S DIC="^LAB(61.2,"
 D EN^DIQ
 D PRESSKEY^BLRGMENU(9)
 Q
 ;
NOSELECT(WOT) ; EP - Selection not done
 W !,?4,WOT," not selected."
 W !,?9,"None will be added to ETIOLOGY FIELD (#61.2) dictionary."
 D PRESSKEY^BLRGMENU(4)
 Q
 ;
ERRORS ; EP - ERRS Array has data.  Display it.
 W !!,"ERRORS:",!
 S J="ERRS"
 S X=$G(@J)
 W ?4,J,"=",X,!
 F  S J=$Q(@J) Q:J=""  W ?9,J,"=",@J,!
 ;
 D PRESSKEY^BLRGMENU(4)
 Q
 ;
TESTIT ; EP 
 NEW ERRS,FDA
 N SNOMEDSC,SNOMED,GRAMSTAN,IDENTIFR,ABBREV,SUSEDITT,HDEPTRPT,CGTRIBEF
 ;
 S SNOMEDSC="Rubella antibody screening"
 S SNOMED=375964015
 S GRAMSTAN="P"
 S IDENTIFR="B"
 S ABBREV="RAS"
 S SUSEDITT="GNS"
 S HDEPTRPT="Y"
 S CGTRIBEF="ENTEB"
 ;
 S FDA(61.2,"+1,",.01)=SNOMEDSC
 S FDA(61.2,"+1,",2)=SNOMED
 S FDA(61.2,"+1,",3)=GRAMSTAN
 S FDA(61.2,"+1,",4)=IDENTIFR
 S FDA(61.2,"+1,",6)=ABBREV
 S FDA(61.2,"+1,",8)=SUSEDITT
 S FDA(61.2,"+1,",10)=HDEPTRPT
 S FDA(61.2,"+1,",1.6)=CGTRIBEF
 ;
 D UPDATE^DIE("ES","FDA",,"ERRS")
 I $D(ERRS) D ERRORS  Q
 ;
 D DISPLAY(+$$FIND1^DIC(61.2,,,SNOMEDSC))
 Q
