PXRMTDLG ; SLC/PJH - Edit/Inquire Taxonomy Dialog ;03/05/2001
 ;;1.5;CLINICAL REMINDERS;**2**;Jun 19, 2000
 ;
 ;Called by option PXRM TAXONOMY DIALOG
 ;
START N DIC,PXRMGTYP,PXRMHD,PXRMTIEN,Y
SELECT ;General selection
 S PXRMHD="Taxonomy Dialog",PXRMGTYP="DTAX",PXRMTIEN=""
 D START^PXRMSEL(PXRMHD,PXRMGTYP,"PXRMTIEN")
 ;Should return a value
 I PXRMTIEN D  G SELECT
 .S PXRMHD="TAXONOMY NAME:"
 .;Listman option
 .D START^PXRMGEN(PXRMHD,PXRMGTYP,PXRMTIEN)
 ;
END Q
 ;
 ;List all Taxonomy Dialogs (for protocol PXRM SELECTION LIST)
 ;-------------------------
ALL N BY,DC,DHD,DIC,FLDS,FR,L,LOGIC,NOW,TO,Y
 S Y=1
 D SET
 S DIC="^PXD(811.2,"
 S BY=".01"
 S FR=""
 S TO=""
 S DHD="W ?0 D HED^PXRMTDLG"
 D DISP
 Q
 ;
 ;Inquire/Print Option (for protocol PXRM GENERAL INQUIRE/PRINT)
 ;--------------------
INQ(Y) N BY,DC,DHD,DIC,FLDS,FR,L,LOGIC,NOW,TO
 S DIC="^PXD(811.2,"
 S DIC(0)="AEMQ"
 D SET
 D DISP
 Q
 ;
 ;Display Header (see DHD variable)
 ;--------------
HED N TEMP,TEXTLEN,TEXTHED,TEXTUND
 S TEXTHED="TAXONOMY DIALOG LIST"
 S TEXTUND=$TR($J("",IOM)," ","-")
 S TEMP=NOW_"  Page "_DC
 S TEXTLEN=$L(TEMP)
 W TEXTHED
 W ?(IOM-TEXTLEN),TEMP
 W !,TEXTUND,!!
 Q
 ;
 ;DISPLAY (Display from FLDS array)
 ;-------
DISP S L=0,FLDS="[PXRM TAXONOMY DIALOG]"
 D EN1^DIP
 Q
 ;
SET ;Setup all the variables
 ; Set Date for Header
 S NOW=$$NOW^XLFDT
 S NOW=$$FMTE^XLFDT(NOW,"1P")
 ;
 ;These variables need to be setup every time because DIP kills them.
 S BY="NUMBER"
 S (FR,TO)=+$P(Y,U,1)
 S DHD="W ?0 D HED^PXRMTDLG"
 ;
 Q
 ;
 ;Build display for selected taxonomy - Called from PXRMGEN
 ;---------------------------------------------------------
DTAX(TIEN) ;
 ;If dialog selectable codes don't exist build them
 I ('$D(^PXD(811.2,TIEN,"SDX")))&('$D(^PXD(811.2,TIEN,"SPR"))) D
 .D BUILD^PXRMTDUP(TIEN)
 ;
 N ARRAY,CNT,SEQ,TSEQ
 S VALMCNT=0 K ^TMP("PXRMGEN",$J)
 ;Format headings to include taxonomy name
 S HEADER=PXRMHD_" "_$P(^PXD(811.2,TIEN,0),U)
 ;Get associated codes
 D TAX^PXRMDLL(TIEN,.ARRAY)
 ;Taxonomy header
 S SEQ=1,TSEQ=$J(SEQ,3)_"  "
 S CNT=0,VALMCNT=VALMCNT+1
 S ^TMP("PXRMGEN",$J,VALMCNT,0)=TSEQ_$J("",15-$L(TSEQ))_ARRAY
 ;Dialog and Procedure entries
 F  S CNT=$O(ARRAY(CNT)) Q:CNT=""  D
 .S TSEQ=$J(SEQ,3)_"."_CNT
 .S VALMCNT=VALMCNT+1
 .S ^TMP("PXRMGEN",$J,VALMCNT,0)=TSEQ_$J("",15-$L(TSEQ))_$P(ARRAY(CNT),U)
 .D CODES($P(ARRAY(CNT),U,2),TIEN)
 .S VALMCNT=VALMCNT+1
 .S ^TMP("PXRMGEN",$J,VALMCNT,0)=$J("",79)
 ;Create headings
 D CHGCAP^VALM("HEADER1","Taxonomy Dialog")
 D CHGCAP^VALM("HEADER2","")
 D CHGCAP^VALM("HEADER3","")
 Q
 ;
 ;Selectable codes
 ;----------------
CODES(FILE,TIEN) ;
 N CODES,CODE,DESC,DTEXT,SUB,TAB,TEXT
 ;Display text
 S TEXT="Selectable codes: ",TAB=18
 ;Get array
 D CODES^PXRMDLLA(FILE,TIEN,.CODES)
 ;Move results into workfile
 S SUB=""
 F  S SUB=$O(CODES(SUB)) Q:SUB=""  D
 .S CODE=$P(CODES(SUB),U,2),DESC=$P(CODES(SUB),U,3)
 .S DTEXT=CODE_$J("",7-$L(CODE))_DESC
 .S VALMCNT=VALMCNT+1
 .S ^TMP("PXRMGEN",$J,VALMCNT,0)=$J("",15)_$G(TEXT)_DTEXT
 .S TEXT=$J("",TAB)
 Q
 ;
 ;Display selectable codes - called from print template
 ;-----------------------------------------------------
TDES(FILE,D0,D1) ;
 N CNT,CODE,DATA,IEN,TEXT,NODE
 S NODE=$S(FILE=80:"SDX",FILE=81:"SPR")
 S DATA=$G(^PXD(811.2,D0,NODE,D1,0)) Q:DATA=""
 ;Get ien of code
 S IEN=$P(DATA,U) Q:IEN=""
 ;Translate ien to code
 I FILE=80 S CODE=$P($G(^ICD9(IEN,0)),U)
 I FILE=81 S CODE=$P($$CPT^ICPTCOD(IEN),U,2)
 ;Set display text from taxonomy selectable code text
 S TEXT=$P(DATA,U,2)
 ;otherwise use icd9/cpt description
 I TEXT="",FILE=80 S TEXT=$G(^ICD9(IEN,1))
 I TEXT="",FILE=80 S TEXT=$P($G(^ICD9(IEN,0)),U,3)
 I TEXT="",FILE=81 S TEXT=$P($$CPT^ICPTCOD(IEN),U,3)
 S TEXT=" "_$E(TEXT,1,40)_$J("",40-$L(TEXT))
 W $J(CODE,10)_TEXT
 Q
