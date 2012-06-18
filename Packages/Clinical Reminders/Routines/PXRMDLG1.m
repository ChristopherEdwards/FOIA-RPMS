PXRMDLG1 ; SLC/PJH - Reminder Dialog Edit/Inquiry (overflow) ;07/09/2001
 ;;1.5;CLINICAL REMINDERS;**2,5,6**;Jun 19, 2000
 ;
 ;Get selectable codes for a taxonomy
 ;-----------------------------------
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
 .S ^TMP("PXRMDLG",$J,VALMCNT,0)=$J("",15)_$G(TEXT)_DTEXT
 .S TEXT=$J("",TAB)
 Q
 ;
 ;Either dialog text or P/N text
 ;------------------------------
TSUB(IEN,VIEW) ;
 ;Dialog View uses Dialog text
 I VIEW=1 Q 25
 ;P/N View uses P/N TEXT if defined
 I $D(^PXRMD(801.41,IEN,35)) Q 35
 ;Otherwise Dialog Text
 Q 25
 ;
 ;Progress note text (DP)
 ;-----------------------
VIEW(IEN,VIEW) ;
 N DCAP,TSUB
 ;Dialog Group process
 I DGRP D  Q
 .N DATA,DGBEG,DGIEN,DGSEQ,DGSUB
 .;Update index
 .S ^TMP("PXRMDLG",$J,"IDX",SEQ,IEN)=""
 .;Get GROUP text
 .S DGSUB=0,DGBEG=$J(SEQ,3),TSUB=$$TSUB(IEN,VIEW)
 .F  S DGSUB=$O(^PXRMD(801.41,IEN,TSUB,DGSUB)) Q:'DGSUB  D
 ..S DTXT=$G(^PXRMD(801.41,IEN,TSUB,DGSUB,0))
 ..S VALMCNT=VALMCNT+1
 ..S ^TMP("PXRMDLG",$J,VALMCNT,0)=DGBEG_$J("",12)_DTXT,DGBEG=$J("",3)
 .;Get additional prompts
 .D PROMPT(IEN,0,"","")
 .;Group caption text
 .S DTXT=$P($G(^PXRMD(801.41,IEN,0)),U,5),DCAP=" [group caption]"
 .I DTXT="" S DCAP="[no caption for this group]"
 .;Text of caption
 .S VALMCNT=VALMCNT+1
 .S ^TMP("PXRMDLG",$J,VALMCNT,0)=DGBEG_$J("",12)_DTXT_DCAP,DGBEG=$J("",3)
 .;Get dialog group sub-elements
 .S DGSEQ=0
 .F  S DGSEQ=$O(^PXRMD(801.41,IEN,10,"B",DGSEQ)) Q:'DGSEQ  D
 ..S SUB=$O(^PXRMD(801.41,IEN,10,"B",DGSEQ,"")) Q:'SUB
 ..S DGIEN=$P($G(^PXRMD(801.41,IEN,10,SUB,0)),U,2) Q:'DGIEN
 ..;Ignore forced values and prompts
 ..Q:"PF"[$P($G(^PXRMD(801.41,DGIEN,0)),U,4)
 ..S DGBEG=$J(SEQ,3)_"."_DGSEQ
 ..;Get Resolution/Finding details
 ..S FIEN=$P($G(^PXRMD(801.41,DGIEN,1)),U,5)
 ..;If taxonomy generate 
 ..I $P(FIEN,";",2)="PXD(811.2," D TAX(FIEN,DGBEG,DGIEN) Q
 ..;Otherwise get text from dialog element
 ..S DGSUB=0,TSUB=$$TSUB(DGIEN,VIEW)
 ..F  S DGSUB=$O(^PXRMD(801.41,DGIEN,TSUB,DGSUB)) Q:'DGSUB  D
 ...S DTXT=$G(^PXRMD(801.41,DGIEN,TSUB,DGSUB,0))
 ...S VALMCNT=VALMCNT+1
 ...S ^TMP("PXRMDLG",$J,VALMCNT,0)=DGBEG_$J("",10)_DTXT,DGBEG=$J("",5)
 ...;Get additional prompts
 ..D PROMPT(DGIEN,0,"","")
 ..;Final linefeed
 ..S VALMCNT=VALMCNT+1
 ..S ^TMP("PXRMDLG",$J,VALMCNT,0)=$J("",79)
 ;
 N TAX,SUB
 ;Get Resolution/Finding details
 S DATA=$G(^PXRMD(801.41,IEN,1)),FIEN=$P(DATA,U,5),TAX=0
 ;Mental Health
 I $P(FIEN,";",2)="YTT(601," D MENTAL(FIEN) Q
 ;Check if taxonomy
 I $P(FIEN,";",2)="PXD(811.2," S TAX=1
 ;If a taxonomy use the dialog text from taxonomy file
 I TAX D TAX(FIEN,SEQ,IEN) Q
 ;If not a taxonomy use dialog file
 I 'TAX D  Q
 .S TSUB=$$TSUB(IEN,VIEW)
 .S DTXT=$G(^PXRMD(801.41,IEN,TSUB,1,0))
 .;Text of the first prompt
 .S VALMCNT=VALMCNT+1
 .S ^TMP("PXRMDLG",$J,VALMCNT,0)=$J(SEQ,3)_$J("",12)_DTXT
 .S ^TMP("PXRMDLG",$J,"IDX",SEQ,IEN)=""
 .;Text or subsequent lines
 .S SUB=1
 .F  S SUB=$O(^PXRMD(801.41,IEN,TSUB,SUB)) Q:'SUB  D
 ..S DTXT=$G(^PXRMD(801.41,IEN,TSUB,SUB,0))
 ..S VALMCNT=VALMCNT+1
 ..S ^TMP("PXRMDLG",$J,VALMCNT,0)=$J("",15)_DTXT
 .;Get additional prompts
 .D PROMPT(IEN,0,"","")
 ;
 Q
 ;
 ;additional prompts in 801.45
 ;----------------------------
FPROMPT(FNODE,RSUB,CNT,ARRAY) ;
 ;Get all additional fields for this resolution type
 S ASUB=0,ACNT=0
 F  S ASUB=$O(^PXRMD(801.45,FNODE,1,RSUB,5,ASUB)) Q:'ASUB  D
 .S DNODE=$G(^PXRMD(801.45,FNODE,1,RSUB,5,ASUB,0)) Q:DNODE=""
 .;Ignore if disabled
 .I $P(DNODE,U,3)=1 Q
 .S DNODE=$P(DNODE,U) Q:DNODE=""
 .S ATXT=$P($G(^PXRMD(801.41,DNODE,0)),U) Q:ATXT=""
 .;S ATXT=$TR(ATXT,UPPER,LOWER)
 .S ACNT=ACNT+1
 .S ARRAY(CNT,ACNT)=DNODE
 Q
 ;
 ;Group text and caption
 ;----------------------
GROUP(IEN,VIEW) ;
 N DDATA,DGIEN,DGSUB,DTXT
 ;Get GROUP text
 S DGSUB=0,TSUB=$$TSUB(IEN,VIEW)
 F  S DGSUB=$O(^PXRMD(801.41,IEN,TSUB,DGSUB)) Q:'DGSUB  D
 .S DTXT=$G(^PXRMD(801.41,IEN,TSUB,DGSUB,0))
 .S VALMCNT=VALMCNT+1
 .S ^TMP("PXRMDLG",$J,VALMCNT,0)=$J("",12)_DTXT
 ;Group caption text
 S DDATA=$G(^PXRMD(801.41,IEN,0))
 S DTXT=$P(DDATA,U,5),DCAP=" [group caption]"
 I DTXT="" S DCAP="[no caption for this group]"
 ;Text of caption
 S VALMCNT=VALMCNT+1
 S ^TMP("PXRMDLG",$J,VALMCNT,0)=$J("",12)_DTXT_DCAP
 ;Get additional group prompts
 D PROMPT(IEN,0,"","")
 ;Other group fields
 N DBOX,DSUPP,DSHOW,DMULT
 S DBOX=$S($P(DDATA,U,6)="Y":"BOX",1:"NO BOX")
 S DSUPP=$S($P(DDATA,U,11):"SUPPRESS",1:"NO SUPPRESS")
 S DSHOW=$S($P(DDATA,U,10):"HIDE",1:"SHOW")
 S DMULT=$P(DDATA,U,9)
 S DMULT=$S(DMULT=1:"ONE ONLY",DMULT=2:"ONE OR MORE",DMULT=3:"NONE OR ONE",1:"NO SELECTION")
 S VALMCNT=VALMCNT+1
 S ^TMP("PXRMDLG",$J,VALMCNT,0)=$J("",12)_"["_DBOX_", "_DSUPP_", "_DSHOW_", "_DMULT_"]"
 S VALMCNT=VALMCNT+1
 S ^TMP("PXRMDLG",$J,VALMCNT,0)=$J("",79)
 Q
 ;
 ;Mental Healt Instrument
 ;-----------------------
MENTAL(RESN) ;
 N ARRAY,CNT,SUB,TXT,TYP,YT,YIEN,YNAM,YSEQ
 S YIEN=$P(RESN,";") Q:'YIEN
 S YNAM=$P($G(^YTT(601,YIEN,0)),U) Q:YNAM=""
 S YT("CODE")=YNAM
 ;Get test details
 D SHOWALL^YTAPI3(.ARRAY,.YT)
 ;Quit if invalid test
 I ARRAY(1)["[ERROR]" Q
 ;Get Name
 S TXT=$G(ARRAY(2)),TXT=$P(TXT,U)_" : "_$P(TXT,U,2)
 S VALMCNT=VALMCNT+1
 S ^TMP("PXRMDLG",$J,VALMCNT,0)=$J(SEQ,3)_$J("",12)_TXT
 S ^TMP("PXRMDLG",$J,"IDX",SEQ,IEN)=""
 S VALMCNT=VALMCNT+1
 S ^TMP("PXRMDLG",$J,VALMCNT,0)=$J("",79)
 ;Get caption
 S SUB=0
 F  S SUB=$O(ARRAY(1,"I",SUB)) Q:'SUB  D
 .S VALMCNT=VALMCNT+1
 .S TXT=$J("",15)_ARRAY(1,"I",SUB)
 .S ^TMP("PXRMDLG",$J,VALMCNT,0)=TXT
 ;
 S VALMCNT=VALMCNT+1
 S ^TMP("PXRMDLG",$J,VALMCNT,0)=$J("",79)
 S CNT=0
 F  S CNT=$O(ARRAY(CNT)) Q:CNT=""  D
 .S YSEQ=$J(SEQ,3)_"."_CNT,SUB=0
 .;Get question
 .F  S SUB=$O(ARRAY(CNT,"T",SUB)) Q:'SUB  D
 ..S VALMCNT=VALMCNT+1
 ..S TXT=YSEQ_$J("",15-$L(YSEQ))_ARRAY(CNT,"T",SUB),YSEQ=""
 ..S ^TMP("PXRMDLG",$J,VALMCNT,0)=TXT
 .S VALMCNT=VALMCNT+1
 .S ^TMP("PXRMDLG",$J,VALMCNT,0)=$J("",79)
 Q
 ;
 ;additional prompts in the dialog file
 ;-------------------------------------
PROMPT(IEN,TAB,TEXT,DGRP) ;
 N DATA,DDIS,DGSEQ,DSUB,DTITLE,DTXT,DTYP,SEQ,SUB
 S SEQ=0
 F  S SEQ=$O(^PXRMD(801.41,IEN,10,"B",SEQ)) Q:'SEQ  D
 .S SUB=$O(^PXRMD(801.41,IEN,10,"B",SEQ,"")) Q:'SUB
 .S DSUB=$P($G(^PXRMD(801.41,IEN,10,SUB,0)),U,2) Q:'DSUB
 .S DATA=$G(^PXRMD(801.41,DSUB,0)) Q:DATA=""
 .S DNAME=$P(DATA,U),DDIS=$P(DATA,U,3),DTYP=$P(DATA,U,4)
 .I VIEW,('DGRP),(DTYP'="P") Q
 .I ('VIEW),('DGRP),("FP"'[DTYP) Q
 .S:VIEW DDIS=""
 .I DTYP="F" S DNAME=DNAME_" (forced value)"
 .I DGRP D
 ..S DGSEQ=$P($G(^PXRMD(801.41,IEN,10,SUB,0)),U)
 ..S DNAME=DGSEQ_$J("",3-$L(DGSEQ))_DNAME
 .I TAB=0,DTYP="P" D
 ..;Override prompt caption
 ..S DTITLE=$P($G(^PXRMD(801.41,IEN,10,SUB,0)),U,6)
 ..I DTITLE="" S DTITLE=$P($G(^PXRMD(801.41,DSUB,2)),U,4)
 ..S DNAME=$J("",3)_DTITLE
 .I TAB=0,DTYP="F" S DNAME=$J("",3)_DNAME
 .S DNAME=$J("",15)_$G(TEXT)_DNAME
 .S:DDIS]"" DNAME=DNAME_$J("",72-$L(DNAME))_DDIS
 .S VALMCNT=VALMCNT+1
 .S ^TMP("PXRMDLG",$J,VALMCNT,0)=DNAME
 .S TEXT=$J("",TAB)
 Q
 ;
 ;
 ;Taxonomy Questions
 ;------------------
TAX(FIEN,SEQ,DIEN) ;
 N ARRAY,CNT,TIEN,TSEQ
 S TIEN=$P(FIEN,";") Q:TIEN=""
 ;Get associated codes
 D TAX^PXRMDLL(TIEN,.ARRAY)
 ;Taxonomy header
 S TSEQ=SEQ I $L(SEQ)<3 S TSEQ=$J(SEQ,3)_"  "
 S CNT=0,VALMCNT=VALMCNT+1
 S ^TMP("PXRMDLG",$J,VALMCNT,0)=TSEQ_$J("",15-$L(TSEQ))_ARRAY
 S ^TMP("PXRMDLG",$J,"IDX",SEQ,DIEN)=""
 ;Dialog and Procedure entries
 F  S CNT=$O(ARRAY(CNT)) Q:CNT=""  D
 .S TSEQ=$J(SEQ,3)_"."_CNT
 .S VALMCNT=VALMCNT+1
 .S ^TMP("PXRMDLG",$J,VALMCNT,0)=TSEQ_$J("",15-$L(TSEQ))_$P(ARRAY(CNT),U)
 .D CODES($P(ARRAY(CNT),U,2),TIEN)
 .;Get additional prompts (from finding parameter file)
 .D TPROMPT(ARRAY(CNT),0,"")
 .S VALMCNT=VALMCNT+1
 .S ^TMP("PXRMDLG",$J,VALMCNT,0)=$J("",79)
 Q
 ;
 ;additional prompts for a taxonomy
 ;---------------------------------
TPROMPT(DATA,TAB,TEXT) ;
 N FNODE,FTYP,RSUB,SEQ,DSUB,DTXT,DTYP
 ;Finding type
 S FTYP=$P(DATA,U,4) Q:FTYP=""
 ;Get parameter file node for this finding type
 S FNODE=$O(^PXRMD(801.45,"B",FTYP,"")) Q:FNODE=""
 ;Resolution type
 S RSUB=$P(DATA,U,3) Q:'RSUB
 ;Get details from  parameter file 
 D FPROMPT(FNODE,RSUB,CNT,.ARRAY)
 S SEQ=0
 F  S SEQ=$O(ARRAY(CNT,SEQ)) Q:'SEQ  D
 .S DSUB=ARRAY(CNT,SEQ) Q:'DSUB
 .S DNAME=$P($G(^PXRMD(801.41,DSUB,0)),U)
 .S DTYP=$P($G(^PXRMD(801.41,DSUB,0)),U,4)
 .I DTYP="F" S DNAME=DNAME_" (forced value)"
 .I TAB=0,DTYP="F" S DNAME=$J("",3)_DNAME
 .I TAB=0,DTYP="P" S DNAME=$J("",3)_$P($G(^PXRMD(801.41,DSUB,2)),U,4)
 .S VALMCNT=VALMCNT+1
 .S ^TMP("PXRMDLG",$J,VALMCNT,0)=$J("",15)_$G(TEXT)_DNAME
 .S TEXT=$J("",TAB)
 Q
