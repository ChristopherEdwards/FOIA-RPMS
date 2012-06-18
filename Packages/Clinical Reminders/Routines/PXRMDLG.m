PXRMDLG ; SLC/PJH - Reminder Dialog Edit/Inquiry ;04/04/2002
 ;;1.5;CLINICAL REMINDERS;**2,8**;Jun 19, 2000
 ;
 ;Labels called from list 'PXRM DIALOG LIST'
 ;
EXIT ;Exit code
 D CLEAN^VALM10
 D FULL^VALM1
 S VALMBCK="Q"
 K ^TMP("PXRMDLG",$J)
 Q
 ;
HDR ; Header code
 S VALMHDR(1)=PXRMHD
 S VALMHDR(2)=""
 S VALMSG="+ Next Screen   - Prev Screen   ?? More Actions"
 Q
 ;
HELP ;Help code
 N ORU,ORUPRMT,XQORM,PXRMTAG S PXRMTAG="GDLG"
 D EN^VALM("PXRM DIALOG MAIN HELP")
 Q
 ;
INIT ;Init
 S VALMCNT=0
 ;Load details of dialog
 D BUILD(0)
 Q
 ;
PEXIT ;PXRM DIALOG MENU protocol exit code
 S VALMSG="+ Next Screen   - Prev Screen   ?? More Actions"
 ;Reset after page up or down
 D XQORM
 Q
 ;
 ;Other Subroutines
 ;
 ;Build workfile (protocols PXRM DIALOG VIEW/LIST)
BUILD(VIEW) ;Clear existing file
 S PXRMMODE=VIEW,VALMCNT=0,VALMBG=1,VALMBCK="R"
 K ^TMP("PXRMDLG",$J)
 ;Headers
 S DNAM=$P($G(^PXRMD(801.41,PXRMDIEN,0)),U)
 I $P($G(^PXRMD(801.41,PXRMDIEN,0)),U,3)]"" D
 .S DNAM=DNAM_" (DISABLED - "_$P($G(^PXRMD(801.41,PXRMDIEN,0)),U,3)_")"
 S PXRMHD="DIALOG NAME: "_DNAM
 I $P($G(^PXRMD(801.41,PXRMDIEN,0)),U,4)="R" D
 .S PXRMHD="REMINDER "_PXRMHD
 I $P($G(^PXRMD(801.41,PXRMDIEN,0)),U,4)="G" D
 .S PXRMHD="DIALOG GROUP NAME: "_DNAM
 I $P($G(^PXRMD(801.41,PXRMDIEN,100)),U)="N" D
 .S PXRMHD=PXRMHD_" [NATIONAL]"
 .I VIEW S PXRMHD=PXRMHD_" *NO EDITING*"
 D HDR
 ;
 ;Reminder Inquiry
 I VIEW=3 D REMD S PXRMOPT=0 D XQORM Q
 ;
 N DATA,DGRP,DHED,FGLOB,FIEN,FITEM,FNAME,FNUM,FTYP,RESULT,RESNM
 N OIEN,ONAME,ONUM,PDIS,PIEN,PNAME,PTXT,PTYP,RIEN,RNAME,SEQ,SUB
 ;Build list of finding items
 N DEF,DEF1,DEF2 D DEF^PXRMRUTL(.DEF,.DEF1,.DEF2)
 ;Special processing for national dialogs
 I VIEW=0,$P($G(^PXRMD(801.41,PXRMDIEN,100)),U)="N" D NATION Q
 ;Display group text fields
 I $P($G(^PXRMD(801.41,PXRMDIEN,0)),U,4)="G",VIEW D
 .D GROUP^PXRMDLG1(PXRMDIEN,VIEW)
 ;Display group findings and prompts
 I $P($G(^PXRMD(801.41,PXRMDIEN,0)),U,4)="G",'VIEW D
 .D GROUP^PXRMDLG2(PXRMDIEN)
 ;
 S SEQ=0
 ;Get each sequence number
 F  S SEQ=$O(^PXRMD(801.41,PXRMDIEN,10,"B",SEQ)) Q:'SEQ  D
 .;Determine subscript
 .S SUB=$O(^PXRMD(801.41,PXRMDIEN,10,"B",SEQ,"")) Q:'SUB
 .;Get ien of prompt/component
 .S PIEN=$P($G(^PXRMD(801.41,PXRMDIEN,10,SUB,0)),U,2) Q:'PIEN
 .;Ignore prompts and forced values
 .I "PF"[$P($G(^PXRMD(801.41,PIEN,0)),U,4) Q
 .;Check if this is a dialog group
 .S DGRP=0 I $P($G(^PXRMD(801.41,PIEN,0)),U,4)="G" S DGRP=1
 .S DHED=$S(DGRP:"Dialog elements:    ",1:"Additional prompts: ")
 .;Save seq/description/disabled
 .I 'VIEW D
 ..D DETAIL^PXRMDLG2(PIEN)
 ..;Create headings
 ..D CHGCAP^VALM("HEADER1","Sequence")
 ..D CHGCAP^VALM("HEADER2","Dialog Details")
 ..D CHGCAP^VALM("HEADER3","Disabled")
 ..;If DN requested build prompt/additional prompt details
 .I VIEW D
 ..D VIEW^PXRMDLG1(PIEN,VIEW)
 ..N MAP
 ..S MAP="" I PXRMHD["NO EDIT" S MAP="USE 'DD' TO MAP FINDINGS"
 ..;Create headings
 ..D CHGCAP^VALM("HEADER1","Sequence")
 ..I VIEW=1 D CHGCAP^VALM("HEADER2","Dialog Text              "_MAP)
 ..I VIEW=4 D CHGCAP^VALM("HEADER2","Progress Note Text       "_MAP)
 ..D CHGCAP^VALM("HEADER3"," ")
 .;Final linefeed
 .S VALMCNT=VALMCNT+1
 .S ^TMP("PXRMDLG",$J,VALMCNT,0)=$J("",79)
 ;Allow for sequence number being greater than VALMCNT
 I $O(^TMP("PXRMDLG",$J,"IDX",""),-1)>VALMCNT D
 .N IC S IC=VALMCNT
 .S VALMCNT=$O(^TMP("PXRMDLG",$J,"IDX",""),-1)
 .F IC=IC+1:1:VALMCNT S ^TMP("PXRMDLG",$J,VALMCNT,0)=$J("",79)
 ;If no lines default to 15
 I VALMCNT<15 D  S VALMCNT=15
 .N IC F IC=VALMCNT+1:1:15 S ^TMP("PXRMDLG",$J,IC,0)=$J("",79)
 S ^TMP("PXRMDLG",$J,"VALMCNT")=VALMCNT
 ;Menu reset
 I $P($G(^PXRMD(801.41,PXRMDIEN,100)),U)="N" D  Q
 .S PXRMOPT=0 D XQORM
 S PXRMOPT=1 D XQORM
 Q
 ;
 ;Find description for dialog type
LIT(INP) ;
 Q:INP="G" "Dialog group: "
 Q:INP="F" "Forced value: "
 Q:INP="P" "Prompt: "
 Q:INP="E" "Dialog element: "
 Q "???"
 ;
 ;Finding description
DESC(FIEN) ;
 ;Determine finding type
 S FGLOB=$P(FIEN,";",2) Q:FGLOB=""
 S FITEM=$P(FIEN,";") Q:FITEM=""
 ;Diagnosis POV
 I FGLOB["ICD9" D  Q
 .S FTYP="DIAGNOSIS",FGLOB=U_FGLOB_FITEM_",0)"
 .S FNAME=$P($G(@FGLOB),U,3)_" ["_FITEM_"]"
 ;Procedure CPT
 I FGLOB["ICPT" D  Q
 .S FTYP="PROCEDURE",FGLOB=U_FGLOB_FITEM_",0)"
 .S FNAME=$P($G(@FGLOB),U,2)_" ["_FITEM_"]"
 ;Quick order
 I FGLOB["ORD(101.41" D  Q
 .S FTYP="QUICK ORDER",FGLOB=U_FGLOB_FITEM_",0)"
 .S FNAME=$P($G(@FGLOB),U,2)_" ["_FITEM_"]"
 ;Short name for finding type
 S FTYP=$G(DEF1(FGLOB)) Q:FTYP=""
 S FNUM=" ["_FTYP_"("_FITEM_")]"
 ;Long name
 S FTYP=$G(DEF2(FTYP))
 S FGLOB=U_FGLOB_FITEM_",0)"
 S FNAME=$P($G(@FGLOB),U,1)
 I FNAME="" S FNAME=$P($G(@FGLOB),U)
 I FNAME]"" S FNAME=FNAME_FNUM Q
 S FNAME=FITEM
 Q
 ;
 ;Display national dialog
NATION N NLINE,NSEL
 S NLINE=0,NSEL=0
 ;
 ;Group header
 I $P($G(^PXRMD(801.41,PXRMDIEN,0)),U,4)="G" D
 .D DLINE^PXRMDLG3(PXRMDIEN,"","")
 ;Other components
 D DETAIL^PXRMDLG3(PXRMDIEN,"")
 ;Create headings
 D CHGCAP^VALM("HEADER1","Item  Seq.")
 D CHGCAP^VALM("HEADER2","Dialog Details/Findings")
 D CHGCAP^VALM("HEADER3","Type")
 S VALMCNT=NLINE
 S ^TMP("PXRMDLG",$J,"VALMCNT")=VALMCNT
 S PXRMOPT=2 D XQORM
 Q
 ;
 ;Reminder Details
REMD N ARRAY,SUB
 ;Change listman headings
 D CHGCAP^VALM("HEADER1","Reminder Inquiry")
 D CHGCAP^VALM("HEADER2","")
 D CHGCAP^VALM("HEADER3","")
 ;Check if dialog is linked to a reminder
 I 'PXRMITEM D  Q
 .S ^TMP("PXRMDLG",$J,2,0)=" *This dialog is not linked to a reminder*"
 ;Build array using print template
 D REMVAR^PXRMINQ(.ARRAY,PXRMITEM)
 ;Copy into Listman global
 S SUB=0
 F  S SUB=$O(ARRAY(SUB)) Q:'SUB  D
 .S VALMCNT=SUB
 .S ^TMP("PXRMDLG",$J,VALMCNT,0)=ARRAY(VALMCNT)
 Q
 ;
SEL ;PXRM DIALOG SELECTION ITEM validation
 N ERR,IEN,SEL
 S VALMBCK="",SEL=+$P(XQORNOD(0),"=",2)
 ;Invalid selection
 I ('SEL)!(SEL>VALMCNT)!('$D(@VALMAR@("IDX",SEL))) D  Q
 .N ANS,DTOUT,DUOUT,LIT,Y
 .W IORESET S VALMBCK="R",ANS="N"
 .I $P($G(^PXRMD(801.41,PXRMDIEN,100)),U)="N" D  Q:$D(DUOUT)!$D(DTOUT)
 ..S LIT="item"
 ..I $G(PXRMINST)=1,DUZ(0)="@" D XASK^PXRMDLG(.ANS)
 .I $P($G(^PXRMD(801.41,PXRMDIEN,100)),U)'="N" D  Q:$D(DUOUT)!$D(DTOUT)
 ..S LIT="sequence" D XASK^PXRMDLG(.ANS)
 .I ANS'="Y" W $C(7),!,SEL_" is not an existing "_LIT_" number." H 2 Q
 .D ESEL^PXRMDEDT(PXRMDIEN,SEL)
 ;Valid selection
 S IEN=$O(@VALMAR@("IDX",SEL,"")) Q:'IEN
 ;Copy/Delete/Edit dialog element
 D IND^PXRMDEDT(IEN)
 Q
 ;
XQORM I PXRMOPT=1 D
 .N COUNT
 .;Allow sequence numbers 1-99 (except when auto generate creates more)
 .S COUNT=99 I VALMCNT>99 S COUNT=VALMCNT+10
 .S XQORM("#")=$O(^ORD(101,"B","PXRM DIALOG SELECTION ITEM",0))
 .S XQORM("#")=XQORM("#")_U_"1:"_COUNT
 .S XQORM("A")="Select Sequence: "
 I PXRMOPT=2 D
 .S XQORM("#")=$O(^ORD(101,"B","PXRM DIALOG SELECTION ITEM",0))
 .S XQORM("#")=XQORM("#")_U_"1:"_VALMCNT
 .S XQORM("A")="Select Item: "
 I PXRMGTYP="DLGE" D
 .N FMENU
 .S FMENU=$O(^ORD(101,"B","PXRM DIALOG GROUP MENU",0))_";ORD(101,"
 .I FMENU S XQORM("HIJACK")=FMENU
 Q
 ;
 ;Add sequence number
 ;-------------------
XASK(YESNO) ;
 N X,Y,TEXT,DIR
 K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="YA0"
 S DIR("A")="ARE YOU ADDING "_SEL_" AS A NEW SEQUENCE NUMBER: "
 S DIR("B")="N"
 S DIR("?")="Enter Y or N. For detailed help type ??"
 S DIR("??")=U_"D XHLP^PXRMDLG(1)"
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) Q
 S YESNO=$E(Y(0))
 Q
 ;
 ;
 ;General help text routine.
 ;--------------------------
XHLP(CALL) ;
 N HTEXT
 N DIWF,DIWL,DIWR,IC
 S DIWF="C75",DIWL=0,DIWR=75
 ;
 I CALL=1 D
 .S HTEXT(1)="Enter Yes to if you are adding a new sequence number or"
 .S HTEXT(2)="dialog element to this reminder dialog."
 K ^UTILITY($J,"W")
 S IC=""
 F  S IC=$O(HTEXT(IC)) Q:IC=""  D
 . S X=HTEXT(IC)
 . D ^DIWP
 W !
 S IC=0
 F  S IC=$O(^UTILITY($J,"W",0,IC)) Q:IC=""  D
 . W !,^UTILITY($J,"W",0,IC,0)
 K ^UTILITY($J,"W")
 W !
 Q
