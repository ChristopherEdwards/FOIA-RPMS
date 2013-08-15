BQITAXCK ;GDIT/HS/ALA-Taxonomy check routine
 ;;2.3;ICARE MANAGEMENT SYSTEM;**1**;Apr 18, 2012;Build 43
 ;
EN(LIST) ;EP - Taxonomy Checks
 N DIR,FOUND,HIVIEN,I,LINE,QFL,Y,TAX,DFLAG
 S FOUND=0
 I $G(FLAG)="" W @IOF
 ;
 S QFL=0
 ; Loop through the Taxonomies
 S ALR=""
 F  S ALR=$O(LIST(ALR)) Q:ALR=""  D  Q:QFL
 . I $D(LIST(ALR))=1 W !!,$P(^BQI(90507.8,ALR,0),U,1)_" exists",! I $Y>20,$$QUIT() S QFL=1 Q
 . I $D(LIST(ALR))>1 W !,"The following taxonomies have no entries for "_$P(^BQI(90507.8,ALR,0),U,1)_": " D
 .. S TAX=""
 .. F  S TAX=$O(LIST(ALR,TAX)) Q:TAX=""  D  Q:QFL
 ... ; Check if there are no codes defined for this taxonomy
 ... I $Y>20,$$QUIT() S QFL=1 Q
 ... W !,?10,TAX
 ;
 I QFL Q
 I $$QUIT("End of taxonomy check.  Enter RETURN to continue or '^' to exit")
 Q
 ;
IT(TAX,FOUND,QFL,TEXT) ;
 I FOUND=0 D
 . W !,"The following taxonomies are missing or have no entries:",!
 . S FOUND=1
 . Q
 I $Y>20,$$QUIT() S QFL=1 Q
 W !,?5,TAX,?40,TEXT
 Q
 ;
QUIT(PROMPT) ;
 N QFL
 S PROMPT=$G(PROMPT,"")
 S QFL=$$PAUSE(PROMPT) S:QFL=0 QFL=""
 W @IOF
 Q QFL
 ;
PAUSE(PROMPT) ;EP - For screen displays pause and allow user to stop
 ; Returns a 1 if the user elected to stop
 I IOST'["C-" Q 0
 N DIR,DTOUT,DUOUT
 I $G(PROMPT)]"" S DIR("A")=PROMPT
 S DIR(0)="E" D ^DIR
 Q $D(DTOUT)!$D(DUOUT)
 ;
CA ; EP
 NEW ALR,TCT
 S ALR=0
 F  S ALR=$O(^BQI(90507.8,ALR)) Q:'ALR  D
 . S TX=0,TCT=0
 . F  S TX=$O(^BQI(90507.8,ALR,12,TX)) Q:'TX  D  S LIST(ALR)=TCT
 .. S LNC=$P(^BQI(90507.8,ALR,12,TX,0),U,1),TAX=$P(^(0),U,2)
 .. S TREF=$NA(^TMP("BQITAX",$J)) K @TREF
 .. D BLD^BQITUTL(TAX,.TREF)
 .. I '$D(@TREF),'$$ENTRS(TAX) S LIST(ALR,TAX)="" Q
 .. S TCT=TCT+1
 K @TREF
 Q
 ;
ENTRS(TAX) ;EP
 S IEN=$O(^ATXLAB("B",TAX,"")) I IEN="" S DFLAG=1 Q 0
 I $O(^ATXLAB(IEN,21,"B",""))="" Q 0
 Q 1
