BKMVC1 ;PRXM/HC/BWF - BKMV Taxonomy Check; [ 1/12/2005  7:16 PM ] ; 26 Apr 2005  11:18 AM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;;Modified by William McCrary, 3/11/05.
 ; Taxonomy Check routine
 Q
 ;
EN ;EP - Taxonomy Checks
 N DIR,FOUND,HIVIEN,I,LINE,QUIT,Y,BKMVTAX,TAX
 S FOUND=0
 I $G(FLAG)="" W @IOF
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" D  Q
 . I $$QUIT("There is no HMS register defined.")
 . Q
 ;
 I '$D(^BKM(90450,HIVIEN,11,"B",DUZ)) D  Q
 . I $$QUIT("You are not a valid HMS user.")
 . Q
 ;
 S QUIT=0
 ; Loop through the Taxonomies as stored in routine BKMVTAX4.
 K BKMVTAX
 F EP="DX","ED","IZ","M","P","S","T","O" D
 . F I=1:1 S Y=$P($T(@(EP_"+"_I_"^BKMVTAX4")),";;",2) Q:Y=""  S BKMVTAX(Y)=""
 . Q
 S TAX=""
 F  S TAX=$O(BKMVTAX(TAX)) Q:TAX=""  D  Q:QUIT
 . N IEN,TAXTYPE
 . S TAXTYPE="",IEN=""
 . ; Check if this taxonomy is not defined in either ^ATXAX or ^ATXLAB
 . I $D(^ATXAX("B",TAX)) S TAXTYPE="RX",IEN=$O(^ATXAX("B",TAX,""))
 . I $D(^ATXLAB("B",TAX)) S TAXTYPE="LAB",IEN=$O(^ATXLAB("B",TAX,""))
 . I TAXTYPE="" D IT(TAX,.FOUND,.QUIT,"Missing") Q
 . ; Check that IEN was valued to avoid a SUBSCRIPT error - should never happen
 . I IEN="" Q
 . ; Check if there are no codes defined for this taxonomy
 . I TAXTYPE="RX",$O(^ATXAX(IEN,21,"B",""))="" D IT(TAX,.FOUND,.QUIT,"No Entries") Q
 . I TAXTYPE="LAB",$O(^ATXLAB(IEN,21,"B",""))="" D IT(TAX,.FOUND,.QUIT,"No Entries") Q
 . Q
 ;
 I QUIT Q
 I FOUND=0,$G(DFLAG)="" W !!!,"All taxonomies are present",!,$$QUIT()
 I FOUND=1,$$QUIT("End of taxonomy check.  Enter RETURN to continue or '^' to exit")
 ;I $$QUIT()
 Q
 ;
IT(TAX,FOUND,QUIT,TEXT) ;
 I FOUND=0 D
 . W !,"The following taxonomies are missing or have no entries:",!
 . S FOUND=1
 . Q
 I $Y>22,$$QUIT() S QUIT=1 Q
 W !,?5,TAX,?40,TEXT
 Q
 ;
QUIT(PROMPT) ;
 N QUIT
 S PROMPT=$G(PROMPT,"")
 ;I $G(PROMPT)'="" W !,PROMPT
 S QUIT=$$PAUSE^BKMIXX3(PROMPT) S:QUIT=0 QUIT=""
 W @IOF
 Q QUIT
