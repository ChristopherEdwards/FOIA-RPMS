BPXRMEXT ;IHS/MSC/MGH - Calls to big for other routines. ;13-Aug-2015 12:23;du
 ;;2.0;CLINICAL REMINDERS;**1005**;Feb 04, 2005;Build 23
 ;==========================================
LEXCHK(CODE,CODESYS,TERM,NCODES,NL,TEXTOUT) ;Use $$TAX^LEX10CS
 ;to determine if code is a partial code that expands to a list of
 ;codes. Add valid codes to the list.
 N ACODE,CODEI,IND,NFOUND,RESULT,SRC,TEXT
 K ^TMP("LEXTAX",$J)
 ;DBIA #5681
 S RESULT=$$TAX^LEX10CS(CODE,CODESYS,DT,"LEXTAX",0)
 S NFOUND=+RESULT
 I NFOUND=-1 D  Q
 . S TEXT(1)="Invalid coding system code pair:"
 . S TEXT(2)=" Coding system is "_CODESYS_", code is "_CODE
 . D EN^DDIOL(.TEXT)
 . S NL=NL+1,TEXTOUT(NL)=TEXT(1)
 . S NL=NL+1,TEXTOUT(NL)=TEXT(2)
 . K ^TMP("LEXTAX",$J)
 S SRC=+$O(^TMP("LEXTAX",$J,0))
 S CODEI=""
 F  S CODEI=$O(^TMP("LEXTAX",$J,SRC,CODEI)) Q:CODEI=""  D
 . S IND=0
 . F  S IND=$O(^TMP("LEXTAX",$J,SRC,CODEI,IND)) Q:IND=""  D
 .. S ACODE=$P(^TMP("LEXTAX",$J,SRC,CODEI,IND,0),U,1)
 .. S NCODES=NCODES+1
 .. S NL=NL+1,TEXTOUT(NL)=$J(NCODES,5)_". "_ACODE
 .. S ^TMP($J,"CODES",TERM,CODESYS,ACODE)=""
 .. I '$D(^TMP($J,"CC",ACODE,CODESYS,TERM)) D
 ... S ^TMP($J,"CC",ACODE,CODESYS,TERM)=""
 ... S ^TMP($J,"CC",ACODE)=$G(^TMP($J,"CC",ACODE))+1
 ... S NCODES(CODESYS)=NCODES(CODESYS)+1
 K ^TMP("LEXTAX",$J)
 Q
 ;
 ;==========================================
PASTECSV(NODE) ;Paste the CSV file.
 N DONE,NL,TEMP
 K ^TMP($J,NODE)
 S DONE=0,NL=0
 D EN^DDIOL("Paste the CSV file now, press <ENTER> to finish.")
 D EN^DDIOL("","","!") H 1
 F  Q:DONE  D
 . R TEMP:10
 . I '$T S DONE=1 Q
 . I $L(TEMP)=0 S DONE=1 Q
 . S NL=NL+1,^TMP($J,NODE,NL,1)=TEMP
 Q
 ;=================================================
HELP ;Display help for taxonomy edits
 N DDS,DIR0,DONE,IND,TEXT
 ;DBIA #5746 covers kill and set of DDS. DDS needs to be set or the
 ;Browser will kill some ScreenMan variables.
 S DDS=1,DONE=0
 F IND=1:1 Q:DONE  D
 . S TEXT(IND)=$P($T(HTEXT+IND),";",3,99)
 . I TEXT(IND)="**End Text**" K TEXT(IND) S DONE=1 Q
 ;IHS/MSC/MGH Newed Variables
 N IOSTBM,IORI
 D BROWSE^DDBR("TEXT","NR","Lexicon Selection Help")
 S VALMBCK="R"
 Q
 ;=========================================
HTEXT ;Lexicon selection help text.
 ;;Select one of the following actions:
 ;;
 ;;  ADD  - adds selected codes to the taxonomy.
 ;;  RFT  - removes selected codes from the taxonomy.
 ;;  RFD  - removes selected codes from being used in a dialog.
 ;;  UID  - adds selected codes to the taxonomy and marks them for use i
 ;;  SAVE - saves all selected codes. Even if codes have been selected,
 ;;         not be stored until they are saved. Finally, a save must be
 ;;         exiting the ScreenMan form or no changes will be saved.
 ;;  EXIT - saves then exits.
 ;;
 ;;Some coding systems cannot be used in a dialog; in those cases, the R
 ;;actions cannot be selected. Actions that cannot be selected have thei
 ;;description surrounded by parentheses. For example, when a coding sys
 ;;used in a dialog, the UID action will look like this:
 ;; UID  Use in dialog
 ;;When the coding system cannot be used in a dialog, it will look like
 ;; UID  (Use in dialog)
 ;;
 ;;You can select the action first and then be prompted for a list of co
 ;;you can input the list and then select the action. Because of the way
 ;;Manager works, you may be able to select a larger list by selecting t
 ;;first.
 ;;
 ;;**End Text**
 Q
 ;--------------------------------------------------------
XSEL ;Entry action for protocol PXRM LEXICON SELECT ENTRY.
 N ENUM,IND,LIST,LVALID
 S LIST=$P(XQORNOD(0),"=",2)
 ;Remove trailing ,
 I $E(LIST,$L(LIST))="," S LIST=$E(LIST,1,$L(LIST)-1)
 S LVALID=1
 F IND=1:1:$L(LIST,",") D
 . S ENUM=$P(LIST,",",IND)
 . I (ENUM<1)!(ENUM>VALMCNT)!('$D(^TMP("PXRMLEXL",$J,"LINES",ENUM))) D
 .. W !,ENUM," is not a valid selection."
 .. W !,"The range is 1 to ",$O(^TMP("PXRMLEXL",$J,"LINES",""),-1),"."
 .. H 2
 .. S LVALID=0
 I 'LVALID S VALMBCK="R" Q
 ;
 ;Full screen mode
 D FULL^VALM1
 ;Possible actions.
 N DIR,DIROUT,DIRUT,DTOUT,DUOUT,OPTION,X,Y
 S DIR(0)="SBM"_U_"ADD:Add to taxonomy;"
 S DIR(0)=DIR(0)_"RFT:Remove from taxonomy;"
 I $$UIDOK^PXRMLEXL D
 . S DIR(0)=DIR(0)_"RFD:Remove from dialog;"
 . S DIR(0)=DIR(0)_"UID:Use in dialog;"
 S DIR("A")="Select Action: "
 S DIR("B")="ADD"
 S DIR("?")="Select from the actions displayed."
 D ^DIR
 I $D(DIROUT)!$D(DIRUT) S VALMBCK="R" Q
 I $D(DTOUT)!$D(DUOUT) S VALMBCK="R" Q
 S OPTION=Y
 D CLEAR^VALM1
 I OPTION="ADD" D INCX^PXRMLEXL(.LIST,0)
 I OPTION="RFD" D RFDX^PXRMLEXL(.LIST)
 I OPTION="RFT" D RFTX^PXRMLEXL(.LIST)
 I OPTION="UID" D INCX^PXRMLEXL(.LIST,1)
 ;
 S VALMBCK="R"
 Q
SCTDESC(NODE) ;Append the SNOMED hierarchy to the description and then
 ;sort the list by description.
 N ACTDT,CODEI,CODE,DESC,FSN,HE,HIER,HS,NUM,SRC
 K ^TMP($J,"DESC"),^TMP($J,"SORT")
 S SRC=$O(^TMP(NODE,$J,0))
 S CODEI=""
 F  S CODEI=$O(^TMP(NODE,$J,SRC,CODEI)) Q:CODEI=""  D
 . S ACTDT=$P(^TMP(NODE,$J,SRC,CODEI,1),U,1)
 . S CODE=$P(^TMP(NODE,$J,SRC,CODEI,1,0),U,1)
 . S DESC=$P(^TMP(NODE,$J,SRC,CODEI,1,0),U,2)
 .;DBIA #5007
 . S FSN=$$GETFSN^LEXTRAN1(SRC,CODE,ACTDT)
 . S HS=$F(FSN,"(")
 . S HE=$F(FSN,")",HS)
 . S HIER=$E(FSN,HS-1,HE-1)
 . S DESC=DESC_" "_HIER
 . S ^TMP($J,"DESC",DESC,CODEI)=""
 S DESC="",NUM=0
 F  S DESC=$O(^TMP($J,"DESC",DESC)) Q:DESC=""  D
 . S CODEI=""
 . F  S CODEI=$O(^TMP($J,"DESC",DESC,CODEI)) Q:CODEI=""  D
 .. S NUM=NUM+1
 .. M ^TMP($J,"SORT",SRC,NUM)=^TMP(NODE,$J,SRC,CODEI)
 .. S $P(^TMP($J,"SORT",SRC,NUM,1,0),U,2)=DESC
 K ^TMP(NODE,$J)
 M ^TMP(NODE,$J)=^TMP($J,"SORT")
 K ^TMP($J,"DESC"),^TMP($J,"SORT")
 Q
IMPLIST(TAXIEN,TERM,CODESYS,NCODES,NLINES,TEXT) ;Build the list for an
 ;imported set of codes.
 N ACTDT,CODE,DESC,INACTDT,NUM,PDATA,RESULT
 S CODE="",(NCODES,NLINES)=0
 F  S CODE=$O(^TMP("PXRMCODES",$J,TERM,CODESYS,CODE)) Q:CODE=""  D
 . K PDATA
 .;DBIA #5679
 . S RESULT=$$PERIOD^LEXU(CODE,CODESYS,.PDATA)
 . I +RESULT=-1 Q
 . S NCODES=NCODES+1
 . S (ACTDT,NUM)=0
 . F  S ACTDT=$O(PDATA(ACTDT)) Q:ACTDT=""  D
 .. S INACTDT=$P(PDATA(ACTDT),U,1)
 .. S DESC=PDATA(ACTDT,0)
 .. S NUM=NUM+1
 .. S NLINES=NLINES+1
 .. I NUM=1 S TEXT(NLINES)=NCODES_U_CODE_U_ACTDT_U_INACTDT_U_DESC
 .. E  S TEXT(NLINES)=U_U_ACTDT_U_INACTDT_U_DESC
 Q
