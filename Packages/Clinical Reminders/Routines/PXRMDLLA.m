PXRMDLLA ;SLC/PJH - REMINDER DIALOG LOADER ;23-Jan-2006 16:11;MGH
 ;;1.5;CLINICAL REMINDERS;**2,5,7,1004**;Jun 19, 2000
 ;
CODE(DFIEN,DFTYP) ;
 Q:DFIEN="" ""
 Q:DFTYP["ICD9" $P($G(^ICD9(DFIEN,0)),U)
 Q:DFTYP["ICPT" $P($$CPT^ICPTCOD(DFIEN),U,2)
 Q ""
 ;
CODES(FILE,TXIEN,ARRAY) ;Return list of selectable codes from taxonomy file
 N CNT,CODE,DATA,IEN,TEMP,TEXT,NODE,SUB
 S SUB=0,CNT=0,NODE=$S(FILE=80:"SDX",FILE=81:"SPR")
 F  S SUB=$O(^PXD(811.2,TXIEN,NODE,SUB)) Q:'SUB  D
 .S DATA=$G(^PXD(811.2,TXIEN,NODE,SUB,0)) Q:DATA=""
 .;Ignore if disabled
 .I $P(DATA,U,3)=1 Q
 .;Get ien of code
 .S IEN=$P(DATA,U) Q:IEN=""
 .;Translate ien to code
 .I FILE=80 S CODE=$P($G(^ICD9(IEN,0)),U)
 .I FILE=81 S CODE=$P($$CPT^ICPTCOD(IEN),U,2)
 .;Ignore invalid codes
 .S TEMP=$$CODE^PXRMVAL(CODE,FILE) Q:'$P(TEMP,U)  Q:$P(TEMP,U,9)=1
 .;Set display text from taxonomy selectable code text
 .S TEXT=$P(DATA,U,2)
 .;otherwise use icd9/cpt description
 .I TEXT="",FILE=80 S TEXT=$G(^ICD9(IEN,1))
 .I TEXT="",FILE=80 S TEXT=$P($G(^ICD9(IEN,0)),U,3)
 .I TEXT="",FILE=81 S TEXT=$P($$CPT^ICPTCOD(IEN),U,3)
 .S CNT=CNT+1,ARRAY(CNT)=IEN_U_CODE_U_TEXT
 Q
 ;
EXP(TIEN,DCUR,DTTYP) ;Expand taxonomy codes
 N CODES,CNT,FILE,LIT,CAT
 S FILE=$S(DTTYP="POV":80,DTTYP="CPT":81,1:"") Q:'FILE
 S LIT="Selectable "_$S(FILE=80:"Diagnoses:",1:"Procedures:")
 S CAT=$P($G(^PXD(811.2,TIEN,0)),U)
 ;
 S OCNT=OCNT+1
 S ORY(OCNT)=3_U_DITEM_U_U_DTTYP_U_U_U_U_U_CAT_U_LIT
 ;Get selectable codes
 D CODES(FILE,TIEN,.CODES)
 S CNT=0
 ;Save selectable codes as type 5 records
 F  S CNT=$O(CODES(CNT)) Q:'CNT  D
 .S OCNT=OCNT+1,ORY(OCNT)=5_U_DITEM_U_U_DTTYP_U_U_CODES(CNT)
 Q
 ;
FREC(DFIEN,DFTYP) ;Build type 3 record
 ;Dialog type/text and resolution
 S DNAM=$$NAME(DFIEN,DFTYP),DCOD=$$CODE(DFIEN,DFTYP)
 ;Translate vitals ien to PCE code - This will need a DBIA
 I DPCE="VIT" D
 .S DFIEN=$$GET1^DIQ(120.51,DFIEN,7,"E")
 .;Vitals Caption
 .S DVIT=$P($G(^PXRMD(801.41,DITEM,2)),U,4)
 I DFTYP]"" D
 .S OCNT=OCNT+1
 .S ORY(OCNT)=3_U_DITEM_U_U_DPCE_U_DEXC_U_DFIEN_U_DCOD_U_DNAM_U_U_DVIT
 .;Get order type for orderable items
 .S:DPCE="Q" $P(ORY(OCNT),U,11)=$P($G(^ORD(101.41,DFIEN,0)),U,4)
 .;If mental health check if a GAF score
 .I DPCE="MH",DFIEN D
 ..I $P($G(^YTT(601,DFIEN,0)),U)="GAF" S $P(ORY(OCNT),U,12)=1
 Q
 ;
GUI(IEN) ;Work out prompt type for PCE
 Q:IEN="" ""
 N SUB S SUB=$P($G(^PXRMD(801.41,IEN,46)),U)
 Q:'SUB ""
 Q $P($G(^PXRMD(801.42,SUB,0)),U)
 ;
LOAD(DITEM,DCUR,DTTYP) ;Load dialog questions into array
 N DARRAY,DCOD,DEXC,DFIND,DFIEN,DFTYP,DNAM,DPCE,DRES,DSEQ,DSUB,DTYP,OCNT
 N DVIT
 ;
 ;Build list of PCE codes
 S DARRAY("AUTTEDT(")="PED"
 S DARRAY("AUTTEXAM(")="XAM"
 S DARRAY("AUTTHF(")="HF"
 S DARRAY("AUTTIMM(")="IMM"
 S DARRAY("AUTTSK(")="SK"
 ;
 S DARRAY("AUTTMSR(")="MSR"  ;IHS/CIA/DKM - Support for V MEASUREMENT
 S DARRAY("GMRD(120.51,")="VIT"
 S DARRAY("ORD(101.41,")="Q"
 S DARRAY("YTT(601,")="MH"
 ;
 S DARRAY("ICD9(")="POV"
 S DARRAY("ICPT(")="CPT"
 ;
 S DARRAY("PXD(811.2,")="T" ;dialog cpt/pov is generated from taxonomy
 ;
 ;Get the dialog element
 S OCNT=0,DTYP=$P($G(^PXRMD(801.41,DITEM,0)),U,4)
 ;Finding detail
 S DRES=$P($G(^PXRMD(801.41,DITEM,1)),U,3)
 S DFIND=$P($G(^PXRMD(801.41,DITEM,1)),U,5)
 S DFIEN=$P(DFIND,";"),DFTYP=$P(DFIND,";",2)
 S DPCE="",DVIT="" I DFTYP'="" S DPCE=$G(DARRAY(DFTYP))
 ;Exclude from P/N
 S DEXC=$P($G(^PXRMD(801.41,DITEM,2)),U,3)
 ;
 ;Non taxonomy codes (3 - finding record)
 I DPCE'="T" D FREC(DFIEN,DFTYP)
 ;
 ;Taxonomy codes need expanding (3 - finding record)
 I DPCE="T" D EXP(DFIEN,DCUR,DTTYP)
 ;
 ;Prompt details (4 - prompt records)
 N ARRAY,DTITLE,DREQ,DSEQ,DSSEQ,DSUB,DTYP
 ;If not a taxonomy get prompts from dialog file
 I DPCE'="T" D PROTH(DITEM)
 ;Ceck for MST findings
 I (DPCE'="T"),(DFTYP]"") D MST(DFTYP,DFIEN)
 ;If a taxonomy get details from general finding parameters (CPT/POV)
 I DPCE="T" D
 .;Quit if finding type not passed
 .Q:DTTYP=""
 .N RSUB,FNODE
 .;Get parameter file node for this finding type
 .S FNODE=$O(^PXRMD(801.45,"B",DTTYP,"")) Q:FNODE=""
 .;Derive resolution from line ien 1=done 2=done elsewhere
 .S RSUB=DCUR+1 I (RSUB<1)!(RSUB>2) Q
 .;Get details from 811.5
 .D PRTAX(FNODE,RSUB)
 ;Return array of type 4 records
 S DSEQ=""
 F  S DSEQ=$O(ARRAY(DSEQ)) Q:'DSEQ  D
 .S OCNT=OCNT+1
 .S ORY(OCNT)=4_U_DITEM_U_DSEQ_U_ARRAY(DSEQ)
 .S DSSEQ=""
 .F  S DSSEQ=$O(ARRAY(DSEQ,DSSEQ)) Q:'DSSEQ  D
 ..S OCNT=OCNT+1
 ..S ORY(OCNT)=4_U_DITEM_U_DSEQ_"."_DSSEQ_U_ARRAY(DSEQ,DSSEQ)
 ;
 ;Get progress note text if defined
 I DPCE'="T" D:'DEXC PTXT(DITEM)
 ;Additional findings
 N FASUB
 S FASUB=0
 F  S FASUB=$O(^PXRMD(801.41,DITEM,3,FASUB)) Q:'FASUB  D
 .S DFIND=$P($G(^PXRMD(801.41,DITEM,3,FASUB,0)),U)
 .S DFIEN=$P(DFIND,";"),DFTYP=$P(DFIND,";",2) Q:DFTYP=""  Q:DFIEN=""
 .S DVIT="",DPCE=$G(DARRAY(DFTYP))
 .I DPCE'="" D FREC(DFIEN,DFTYP)
 Q
 ;
 ;Pass MST code as a forced value
MST(DFTYP,DFIEN) ;
 ;Validate finding ien
 Q:DFIEN=""
 ;For each MST term check if finding is mapped
 N FOUND,TCOND,TIEN,TNAM,TSUB
 S FOUND=0
 F TNAM="POSITIVE","NEGATIVE","DECLINES" D  Q:FOUND
 .;Get term IEN
 .S TIEN=$O(^PXRMD(811.5,"B","MST "_TNAM_" REPORT","")) Q:'TIEN
 .;Check if finding is mapped to term
 .Q:'$D(^PXRMD(811.5,TIEN,20,"E",DFTYP,DFIEN))
 .;If exam and term condition logic is null ignore
 .I DFTYP="AUTTEXAM(" D  Q:TCOND=""
 ..S TCOND="",TSUB=$O(^PXRMD(811.5,TIEN,20,"E",DFTYP,DFIEN,"")) Q:'TSUB
 ..S TCOND=$P($G(^PXRMD(811.5,TIEN,20,TSUB,3)),U)
 .;If it is then create additional prompt for MST
 .N DSEQ,DEXC,DDEF,DGUI,DTYP,DTEXT,DSNL,DREQ
 .;Add to end of array
 .S DSEQ=$O(ARRAY(""),-1)+1
 .;Null fields
 .S DDEF="",DEXC="",DTEXT="",DSNL="",DREQ=""
 .;MST status (exept for exams)
 .I DFTYP'="AUTTEXAM(" S DDEF=$$STCODE^PXRMMST("MST "_TNAM_" REPORT")
 .;GUI process and forced value
 .S DGUI="MST",DTYP="F"
 .;Save in array
 .S ARRAY(DSEQ)=DGUI_U_DEXC_U_DDEF_U_DTYP_U_DTEXT_U_DSNL_U_DREQ
 .;Quit after the first term is found
 .S FOUND=1
 Q
 ;
 ;Returns item name
NAME(DFIEN,DFTYP) ;
 Q:DFTYP="" ""
 Q:DFIEN="" ""
 N NAME,FGLOB,POSN
 I DFTYP["ICD9" S NAME=$P($G(^ICD9(DFIEN,1)),U) Q:NAME]"" NAME
 S POSN=2
 S:DFTYP["AUTT" POSN=1 S:DFTYP["AUTTEDT" POSN=4 S:DFTYP["ICD" POSN=3
 S FGLOB=U_DFTYP_DFIEN_",0)",NAME=$P($G(@FGLOB),U,POSN)
 I (POSN>1),NAME="" S NAME=$P($G(@FGLOB),U)
 I NAME="" S NAME=DFIEN
 Q NAME
 ;
PROTH(IEN) ; Additional prompts defined in 801.41
 N DDATA,DDEF,DIEN,DEXC,DGUI,DNAME,DOVR,DREQ,DSEQ,DSNL,DSUB,DTXT,DTYP
 S DSEQ=0
 F  S DSEQ=$O(^PXRMD(801.41,IEN,10,"B",DSEQ)) Q:'DSEQ  D
 .;Get prompts in sequence
 .S DSUB=$O(^PXRMD(801.41,IEN,10,"B",DSEQ,"")) Q:'DSUB
 .;Prompt ien
 .S DIEN=$P($G(^PXRMD(801.41,IEN,10,DSUB,0)),U,2) Q:'DIEN
 .;Ignore disabled components, and those that are not prompts
 .Q:($P($G(^PXRMD(801.41,DIEN,0)),U,3)]"")!("PF"'[$P($G(^(0)),U,4))
 .;Set defaults to null
 .S DDEF="",DEXC="",DREQ="",DSNL=""
 .;Prompt name and GUI process (quit if null)
 .S DNAME=$P($G(^PXRMD(801.41,DIEN,0)),U),DGUI=$$GUI(DIEN)
 .;Type Prompt or Forced
 .S DTYP=$P($G(^PXRMD(801.41,DIEN,0)),U,4)
 .I "PF"[DTYP D
 ..;Required/Prompt caption
 ..S DDATA=$G(^PXRMD(801.41,DIEN,2)),DTXT=$P(DDATA,U,4)
 ..;Default value or forced value
 ..S:DTYP="P" DDEF=$P(DDATA,U) S:DTYP="F" DDEF=$P(DDATA,U,2)
 ..;Override caption/start new line/exclude PN from dialog file
 ..S DDATA=$G(^PXRMD(801.41,IEN,10,DSUB,0)),DREQ=$P(DDATA,U,9)
 ..S DOVR=$P(DDATA,U,6),DSNL=$P(DDATA,U,7),DEXC=$P(DDATA,U,8)
 ..S DNAME=DTXT I DOVR]"" S DNAME=DOVR
 ..;Convert date to fileman format
 ..I DGUI="VST_DATE",DDEF["T" S DDEF=$$DT^XLFDT()
 .S ARRAY(DSEQ)=DGUI_U_DEXC_U_DDEF_U_DTYP_U_DNAME_U_DSNL_U_DREQ
 .;Additional checkboxes
 .I DGUI="COM",DIEN>1 D
 ..N DSSEQ,DSUB,DTEXT
 ..S DSSEQ=0
 ..F  S DSSEQ=$O(^PXRMD(801.41,DIEN,45,"B",DSSEQ)) Q:'DSSEQ  D
 ...S DSUB=$O(^PXRMD(801.41,DIEN,45,"B",DSSEQ,"")) Q:'DSUB
 ...S DTEXT=$P($G(^PXRMD(801.41,DIEN,45,DSUB,0)),U,2) Q:DTEXT=""
 ...S ARRAY(DSEQ,DSSEQ)=U_DEXC_U_DDEF_U_DTYP_U_DTEXT_U_DSNL_U_DREQ
 Q
 ;
PRTAX(FNODE,RSUB) ;Get all additional fields for this resolution type
 N ACNT,ASUB
 N DDATA,DDEF,DEXC,DGUI,DNAME,DREQ,DSEQ,DSUB,DTYP
 S ASUB=0,DSEQ=0
 F  S ASUB=$O(^PXRMD(801.45,FNODE,1,RSUB,5,ASUB)) Q:'ASUB  D
 .S DDATA=$G(^PXRMD(801.45,FNODE,1,RSUB,5,ASUB,0)) Q:DDATA=""
 .;Ignore if disabled
 .I $P(DDATA,U,3)=1 Q
 .S DSUB=$P(DDATA,U) Q:DDATA=""
 .S DSEQ=DSEQ+1
 .;Set defaults to null
 .S DDEF="",DEXC="",DREQ="",DSNL=""
 .;Prompt name and GUI process (quit if null)
 .S DNAME=$P($G(^PXRMD(801.41,DSUB,0)),U),DGUI=$$GUI(DSUB)
 .;Type Prompt or Forced
 .S DTYP=$P($G(^PXRMD(801.41,DSUB,0)),U,4)
 .I DTYP="P" D
 ..S DREQ=$P(DDATA,U,2),DTXT=$P($G(^PXRMD(801.41,DSUB,2)),U,4)
 ..;Override caption/start new line/exclude from PN from finding type
 ..S DOVR=$P(DDATA,U,5),DSNL=$P(DDATA,U,6),DEXC=$P(DDATA,U,7)
 ..S DNAME=DTXT I DOVR]"" S DNAME=DOVR
 ..;Required/Prompt caption
 ..S DDATA=$G(^PXRMD(801.41,DSUB,2))
 .S ARRAY(DSEQ)=DGUI_U_DEXC_U_DDEF_U_DTYP_U_DNAME_U_DSNL_U_DREQ
 Q
 ;
PTXT(ITEM) ;Get progress note (WP) text for type 6 records
 N LAST,NULL,SUB,TEXT S SUB=0,LAST=0
 F  S SUB=$O(^PXRMD(801.41,ITEM,35,SUB)) Q:'SUB  D
 .S TEXT=$G(^PXRMD(801.41,ITEM,35,SUB,0))
 .S NULL=0 I (TEXT="")!($E(TEXT)=" ") S NULL=1
 .I LAST,'NULL S TEXT="<br>"_TEXT
 .S LAST=0 I NULL S TEXT="<br>"_TEXT,LAST=1
 .S OCNT=OCNT+1,ORY(OCNT)=6_U_ITEM_U_U_TEXT
 Q
 ;
TOK(TIEN,TYPE) ;Check if selectable codes exist
 N DATA,FOUND,SUB
 S FOUND=0,SUB=0
 F  S SUB=$O(^PXD(811.2,TIEN,TYPE,SUB)) Q:'SUB  D  Q:FOUND
 .S DATA=$G(^PXD(811.2,TIEN,TYPE,SUB,0)) Q:DATA=""
 .;Ignore disabled codes
 .I '$P(DATA,U,3) S FOUND=1
 Q FOUND
 ;
TEST(ORY,DITEM,DCUR,DTTYP) ;
 D LOAD(DITEM,DCUR,DTTYP)
 Q
