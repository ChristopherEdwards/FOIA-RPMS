PXRMEXLD ;SLC/PJH - Reminder Dialog Exchange Main Routine. ;11/07/2001
 ;;1.5;CLINICAL REMINDERS;**5,7**;Jun 19, 2000
 ;
 ;=====================================================================
 ;
 ;List Manager Functions (PXRM EX LIST DIALOG) called from PXRMEXLI
 ;--------------------------------------------
START N PXRMBG,PXRMMODE,VALMBCK,VALMBG,VALMCNT,VALMSG,X,XMZ
 S X="IORESET"
 D EN^VALM("PXRM EX LIST DIALOG")
 ;
 ;Rebuild Display
 D CDISP^PXRMEXLC(PXRMRIEN)
 Q
 ;
 ;Entry action for list PXRM EX LIST DIALOG
 ;-----------------------------------------
ENTRY D FIND Q
 ;
 ;Display Dialog Details
 ;----------------------
DETAIL S PXRMMODE=0 D DISP(PXRMMODE) Q
 ;
 ;Display Findings
 ;--------------------------
FIND S PXRMMODE=2 D DISP(PXRMMODE) Q
 ;
 ;Display Dialog Summary
 ;----------------------
SUM S PXRMMODE=3 D DISP(PXRMMODE) Q
 ;
 ;Display Dialog Usage
 ;--------------------
USE S PXRMMODE=4 D DISP(PXRMMODE) Q
 ;
 ;Display Dialog Text
 ;-------------------
TEXT S PXRMMODE=1 D DISP(PXRMMODE) Q
 ;
EXIT K ^TMP("PXRMEXLD",$J) Q
 ;
PEXIT ;PXRM EXCH DIALOG MENU protocol exit code
 S VALMSG="+ Next Screen   - Prev Screen   ?? More Actions"
 ;Reset after page up/down etc
 D XQORM
 Q
 ;
HELP N ORU,ORUPRMT,XQORM,PXRMTAG S PXRMTAG="DLG"
 D EN^VALM("PXRM EX DIALOG HELP")
 Q
 ;
HDR S VALMHDR(1)="Packed reminder dialog: "
 S VALMHDR(1)=VALMHDR(1)_$G(^TMP("PXRMEXTMP",$J,"PXRMDNAM"))
 I $D(^TMP("PXRMEXTMP",$J,"PXRMDNAT")) D
 .S VALMHDR(1)=VALMHDR(1)_" [NATIONAL DIALOG]"
 S VALMHDR("TITLE")=VALMHDR(1)
 S VALMSG="+ Next Screen   - Prev Screen   ?? More Actions"
 Q
 ;
 ;Build list manager workfile from ^TMP("PXRMEXTMP" (see ^PXRMEXLB)
DISP(VIEW) ;
 K ^TMP("PXRMEXLD",$J)
 N DDATA,DDLG,DEND,DREP,DSTRT,IND,JND,NLINE,NSEL
 S NLINE=0,NSEL=0,VALMBCK="R",VALMCNT=NLINE
 S DDLG=$G(^TMP("PXRMEXTMP",$J,"PXRMDNAM")) Q:DDLG=""
 ;
 ;Save reminder dialog
 S DDATA=^TMP("PXRMEXTMP",$J,"DLOC",DDLG)
 S DSTRT=$P(DDATA,U,1),DEND=$P(DDATA,U,2)
 S IND=$P(DDATA,U,3),JND=$P(DDATA,U,4),DREP=""
 D DLINE(DDLG,"","")
 S NLINE=NLINE+1,^TMP("PXRMEXLD",$J,NLINE,0)=$J("",79)
 S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
 ;Process components
 D DCMP(DDLG,"")
 ;Change header
 I VIEW=0 D CHGCAP^VALM("HEADER2","Dialog Details")
 I VIEW=1 D CHGCAP^VALM("HEADER2","Dialog Text")
 I VIEW=2 D CHGCAP^VALM("HEADER2","Dialog Findings")
 I VIEW=3 D CHGCAP^VALM("HEADER2","Dialog Summary")
 I VIEW=4 D CHGCAP^VALM("HEADER2","Dialog Usage")
 ;
 S VALMCNT=NLINE,^TMP("PXRMEXLD",$J,"VALMCNT")=VALMCNT,VALMBG=1
 ;
 ;Reset protocol
 D XQORM
 Q
 ;
 ;Update workfile
DLINE(DNAM,LEV,DSEQ) ;
 ;Check if standard PXRM prompt
 N DPXRM S DPXRM=$$PXRM^PXRMEXID(DNAM)
 ;
 ;Ignore PXRM prompts if doing a finding view (DF)
 I VIEW>1,DPXRM Q
 ;
 N DEXIST,DPTX,DTXT,DTYP,EXIST,ITEM,TEMP,SEP
 S ITEM=""
 I DPXRM=0 S NSEL=NSEL+1,ITEM=NSEL
 S NLINE=NLINE+1,SEP=$E(LEV,$L(LEV)),DEXIST=0
 S TEMP=$J(ITEM,3)_$J("",4)_LEV_DSEQ
 ;Determine type
 S DTYP=$G(^TMP("PXRMEXTMP",$J,"DTYP",DNAM))
 ;Dialog component display
 I (VIEW'=1) D
 .I $L(TEMP)<13 S TEMP=TEMP_$J("",12+$L(SEP)-$L(TEMP))_$E(DNAM,1,50)
 .E  S TEMP=TEMP_" "_$E(DNAM,1,50)
 I VIEW=1 D
 .I DTYP]"" S DTXT=$G(^TMP("PXRMEXTMP",$J,"DTXT",DNAM))
 .I DTYP="" S DTXT=DNAM
 .I DREP'="" S DTXT=DNAM
 .I $L(TEMP)<13 S TEMP=TEMP_$J("",12+$L(SEP)-$L(TEMP))_$E(DTXT,1,50)
 .E  S TEMP=TEMP_" "_$E(DTXT,1,50)
 ;Add Type
 S TEMP=TEMP_$J("",65-$L(TEMP))_DTYP
 ;Exists flag
 I DPXRM=0,$$EXISTS^PXRMEXIU(801.41,DNAM) D
 .S TEMP=TEMP_$J("",75-$L(TEMP))_"X",DEXIST=1
 S ^TMP("PXRMEXLD",$J,NLINE,0)=TEMP
 ;
 ;Set up selection index
 S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)="" Q:DPXRM=1
 ;Store the file number, start and stop line in the exchange file.
 S ^TMP("PXRMEXLD",$J,"SEL",NSEL)=FILENUM_U_DSTRT_U_DEND_U_DEXIST_U_IND_U_JND
 ;
 ;Check for replacements
 I DREP'="" D
 .N TEMP
 .S TEMP=$J("",12+$L(SEP))_"(Replaced with "_PXRMNMCH(FILENUM,DNAM)_")"
 .S TEMP=$E(TEMP,1,74),TEMP=TEMP_$J("",75-$L(TEMP))_"X"
 .S NLINE=NLINE+1,^TMP("PXRMEXLD",$J,NLINE,0)=TEMP
 .S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
 .S NLINE=NLINE+1,^TMP("PXRMEXLD",$J,NLINE,0)=$J("",79)
 .S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
 ;
 ;Insert additional text lines
 I VIEW=1,DREP="" D
 .N DSUB,DTXT,FILENUM
 .S DSUB=0,FILENUM=8927.1
 .F  S DSUB=$O(^TMP("PXRMEXTMP",$J,"DTXT",DNAM,DSUB)) Q:'DSUB  D
 ..S DTXT=$G(^TMP("PXRMEXTMP",$J,"DTXT",DNAM,DSUB)),NLINE=NLINE+1
 ..S ^TMP("PXRMEXLD",$J,NLINE,0)=$J("",12+$L(SEP))_$E(DTXT,1,50)
 ..S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
 .;TIU template changes
 .I $D(PXRMNMCH(FILENUM)),$D(^TMP("PXRMEXTMP",$J,"DTIU",DNAM)) D
 ..N TEMP,TNAM,TNNAM
 ..S TNAM=""
 ..F  S TNAM=$O(^TMP("PXRMEXTMP",$J,"DTIU",DNAM,TNAM)) Q:TNAM=""  D
 ...S TNNAM=$G(PXRMNMCH(FILENUM,TNAM)) Q:TNNAM=""
 ...S NLINE=NLINE+1,^TMP("PXRMEXLD",$J,NLINE,0)=$J("",79)
 ...S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
 ...S TEMP=$J("",12+$L(SEP))_"(TIU template "_TNAM_" copied to "_TNNAM_")"
 ...S NLINE=NLINE+1,^TMP("PXRMEXLD",$J,NLINE,0)=TEMP
 ...S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
 ...S NLINE=NLINE+1,^TMP("PXRMEXLD",$J,NLINE,0)=$J("",79)
 ...S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
 ;Insert finding items
 I VIEW=2,("element;group"[DTYP),DREP="" D
 .N DSUB,FDATA,FILENUM,FLIT,FLONG,FNAME,FOUND,FREP,FTAB,FTYP,TEMP
 .;Findings and additional findings
 .S DSUB=0,FOUND=0
 .F  S DSUB=$O(^TMP("PXRMEXTMP",$J,"DFND",DNAM,DSUB)) Q:'DSUB  D
 ..S FNAME=$G(^TMP("PXRMEXTMP",$J,"DFND",DNAM,DSUB)) Q:FNAME=""
 ..S FDATA=$G(^TMP("PXRMEXFND",$J,FNAME))
 ..S FILENUM=$P(FDATA,U),FTYP=$P(FDATA,U,2) Q:'FILENUM
 ..S FREP=$G(PXRMNMCH(FILENUM,FNAME)) I FREP=FNAME S FREP=""
 ..S NLINE=NLINE+1,EXIST=$$EXISTS^PXRMEXIU(FILENUM,FNAME),FOUND=1
 ..I DSUB=1 S FLIT="Finding: "
 ..I DSUB>1 S FLIT="Add. Finding: "
 ..S FLONG=0 I $L(FLIT_FNAME_" ("_FTYP_")")>60 S FLONG=1
 ..I 'FLONG S FNAME=FLIT_FNAME_" ("_FTYP_")"
 ..I FLONG S FNAME=FLIT_FNAME
 ..S TEMP=$J("",12+$L(SEP))_$E(FNAME,1,60)_$J("",60-$L(FNAME))
 ..I EXIST S TEMP=TEMP_$J("",75-$L(TEMP))_"X"
 ..S ^TMP("PXRMEXLD",$J,NLINE,0)=TEMP
 ..S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
 ..I FLONG D
 ...S NLINE=NLINE+1
 ...S FTAB=$S(DSUB=1:21,1:26)
 ...S ^TMP("PXRMEXLD",$J,NLINE,0)=$J("",FTAB)_"("_FTYP_")"
 ...S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
 ..I FREP'="" D
 ...S NLINE=NLINE+1
 ...S FTAB=$S(DSUB=1:21,1:26)
 ...S ^TMP("PXRMEXLD",$J,NLINE,0)=$J("",FTAB)_"(Replaced by "_FREP_")"
 ...S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
 .;If no findings
 .I 'FOUND D
 ..S NLINE=NLINE+1
 ..S ^TMP("PXRMEXLD",$J,NLINE,0)=$J("",12+$L(SEP))_"Finding: *NONE*"
 ..S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
 ;
 ;Usage screen
 I VIEW=4,DREP="" D
 .N DOTHER,DTXT,DTYPE,OTHER,TYPE
 .D OTHER(DNAM,.DOTHER) Q:'$D(DOTHER)
 .S OTHER=""
 .F  S OTHER=$O(DOTHER(OTHER)) Q:OTHER=""  D
 ..S TYPE=DOTHER(OTHER),NLINE=NLINE+1,DTYPE="REMINDER DIALOG"
 ..I TYPE="G" S DTYPE="DIALOG GROUP"
 ..I TYPE="E" S DTYPE="DIALOG ELEMENT"
 ..S DTXT="USED BY: "_OTHER_" ("_DTYPE_")"
 ..S ^TMP("PXRMEXLD",$J,NLINE,0)=$J("",12+$L(SEP))_DTXT
 ..S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
 Q
 ;
 ;Save details of dialog components for display
DCMP(DLG,LEV) ;
 N DDATA,DDLG,DEND,DNAM,DSEQ,DSTRT,IND,JND
 S DSEQ=0
 F  S DSEQ=$O(^TMP("PXRMEXTMP",$J,"DMAP",DLG,DSEQ)) Q:'DSEQ  D
 .S DDATA=^TMP("PXRMEXTMP",$J,"DMAP",DLG,DSEQ)
 .S DNAM=$P(DDATA,U),DSTRT=$P(DDATA,U,2),DEND=$P(DDATA,U,3) Q:DNAM=""
 .S IND=$P(DDATA,U,4),JND=$P(DDATA,U,5)
 .;Check if this component has been replaced
 .S DREP=$G(PXRMNMCH(FILENUM,DNAM)) I DREP=DNAM S DREP=""
 .;Save line in workfile
 .D DLINE(DNAM,LEV,DSEQ) Q:DREP'=""
 .;
 .;Process any sub-components
 .I $D(^TMP("PXRMEXTMP",$J,"DMAP",DNAM)) D DCMP(DNAM,LEV_DSEQ_".")
 .;Extra line feed
 .I LEV="" D
 ..S NLINE=NLINE+1,^TMP("PXRMEXLD",$J,NLINE,0)=$J("",79)
 ..S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
 Q
 ;
 ;Rebuild string in ascending or descending order
ORDER(STRING,ORDER) ;
 N ARRAY,ITEM,CNT
 F CNT=1:1 S ITEM=$P(STRING,",",CNT) Q:'ITEM  S ARRAY(ITEM)=""
 K STRING
 F CNT=1:1 S ITEM=$O(ARRAY(ITEM),ORDER) Q:'ITEM  D
 .S $P(STRING,",",CNT)=ITEM
 Q
 ;
 ;Check if used by other dialogs
OTHER(NAME,LIST) ;
 N DDATA,DIEN,DNAME,DTYP,IEN
 S IEN=$O(^PXRMD(801.41,"B",NAME,0)) Q:'IEN
 ;Check if used by other dialogs
 I '$D(^PXRMD(801.41,"AD",IEN)) Q
 ;Build list of dialogs using this component
 S DIEN=0
 F  S DIEN=$O(^PXRMD(801.41,"AD",IEN,DIEN)) Q:'DIEN  D
 .S DDATA=$G(^PXRMD(801.41,DIEN,0)) Q:DDATA=""
 .S DNAME=$P(DDATA,U),DTYP=$P(DDATA,U,4) Q:DNAME=""
 .;Include only dialogs that are not part of this reminder dialog
 .I $D(^TMP("PXRMEXTMP",$J,"DMAP",DNAME)) Q
 .S LIST(DNAME)=DTYP
 Q
 ;
 ;Validate sequence numbers
VALID(STRING) ;
 N CNT,FOUND,OK
 S FOUND=0,OK=1
 F CNT=1:1 S SEL=$P(STRING,",",CNT) Q:'SEL  D
 .;Invalid selection
 .I ('SEL)!(SEL>VALMCNT)!('$D(@VALMAR@("SEL",SEL))) D  Q
 ..S OK=0 W $C(7),!,SEL_" is not a valid item number." H 2
 .S FOUND=1
 Q:OK&FOUND 1
 Q 0
 ;
XQORM S XQORM("#")=$O(^ORD(101,"B","PXRM EXCH SELECT DIALOG",0))_U_"1:"_VALMCNT
 S XQORM("A")="Select Action: "
 Q
 ;
XSEL ;PXRM EXCH SELECT DIALOG validation
 N ALL,CNT,ERR,IEN,IND,PXRMDONE,SELECT,SEL
 S ALL="",PXRMDONE=0,PXRMBG=$G(VALMBG)
 ;Invalid selection
 S SELECT=$P(XQORNOD(0),"=",2) I '$$VALID(SELECT) S VALMBCK="R" Q
 ;
 ;Sort the SELECTION into reverse order
 D ORDER(.SELECT,-1)
 ;
 ;Lock the file
 I '$$LOCK^PXRMEXID S VALMBCK="R" Q
 ;
 ;Install dialog component(s)
 S CNT=0
 F CNT=1:1 S SEL=$P(SELECT,",",CNT) Q:'SEL  D  Q:PXRMDONE
 .D INSCOM^PXRMEXID(SEL,0)
 ;
 ;Unlock file
 D UNLOCK^PXRMEXID
 ;
 ;
 ;Rebuild Workfile
 D DISP^PXRMEXLD(PXRMMODE)
 ;
 ;Refresh
 S VALMBCK="R" I $D(PXRMBG) S VALMBG=PXRMBG
 Q
