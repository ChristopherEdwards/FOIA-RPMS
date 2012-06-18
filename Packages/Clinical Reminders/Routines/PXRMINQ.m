PXRMINQ ; SLC/PKR - Clinical Reminder inquiry routines. ;08/31/2001
 ;;1.5;CLINICAL REMINDERS;**2,5,7**;Jun 19, 2000
 ;
 ;======================================================================
DISP(DIC,FLDS) ;Display detail.
 N L
 S L=0
 D EN1^DIP
 Q
 ;
 ;======================================================================
HEADER(TEXT) ;Display Header (see DHD variable).
 N TEMP,TEXTLEN,TEXTUND
 S TEXTUND=$TR($J("",IOM)," ","-")
 S TEMP=NOW_"  Page "_DC
 S TEXTLEN=$L(TEMP)
 W TEXT
 W ?(IOM-TEXTLEN),TEMP
 W !,TEXTUND,!!
 Q
 ;
 ;======================================================================
REM ;Do reminder inquiry.
 N BY,DC,DHD,FLDS,FROM,IENN,NOW,PXRMFVPL,PXRMROOT,TO
 ;Build the finding variable pointer information.
 D BLDRLIST^PXRMVPTR(811.902,.01,.PXRMFVPL)
 S FLDS="[PXRM DEFINITION INQUIRY]"
 S IENN=0
 S PXRMROOT="^PXD(811.9,"
 F  Q:IENN=-1  D
 . S IENN=$$SELECT(PXRMROOT,"Select Reminder Definition: ","")
 . I IENN=-1 Q
 . D SET(IENN,"REMINDER DEFINITION INQUIRY")
 . D DISP(PXRMROOT,FLDS)
 Q
 ;
 ;======================================================================
REMVAR(VAR,IEN) ;Do reminder inquiry for reminder IEN return formatted
 ;output in VAR. VAR can be either a local variable or a global.
 ;If it is a local it is indexed for the broker. If it is a global
 ;it should be passed in closed form i.e., ^TMP("PXRMTEST",$J).
 ;It will be returned formatted for ListMan i.e.,
 ;^TMP("PXRMTEST",$J,N,0).
 N %ZIS,BY,DC,DHD,DONE,FF,FILENAME,FILESPEC,FLDS,FROM,GBL,HFNAME
 N IND,IOP,NOW,PATH,PXRMFVPL,PXRMROOT,SUCCESS,TO,UNIQN
 ;Build the finding variable pointer information.
 D BLDRLIST^PXRMVPTR(811.902,.01,.PXRMFVPL)
 S FLDS="[PXRM DEFINITION INQUIRY]"
 S PXRMROOT="^PXD(811.9,"
 D SET(IEN,"")
 ;Make sure the PXRM WORKSTATION device exists.
 D MKWSDEV^PXRMHOST
 ;Set up the output file before DIP is called.
 S PATH=$$PWD^%ZISH
 S NOW=$$NOW^XLFDT
 S NOW=$TR(NOW,".","")
 S UNIQN=$J_NOW
 S FILENAME="PXRMWSD"_UNIQN_".DAT"
 S HFNAME=PATH_FILENAME
 S IOP="PXRM WORKSTATION;80"
 S %ZIS("HFSMODE")="W"
 S %ZIS("HFSNAME")=HFNAME
 D DISP(PXRMROOT,FLDS)
 ;Move the host file into a global.
 S GBL="^TMP(""PXRMINQ"",$J,1,0)"
 S GBL=$NA(@GBL)
 K ^TMP("PXRMINQ",$J)
 S SUCCESS=$$FTG^%ZISH(PATH,FILENAME,GBL,3)
 ;Look for a form feed, remove it and all subsequent lines.
 S FF=$C(12)
 I $G(VAR)["^" D
 . S VAR=$NA(@VAR)
 . S VAR=$P(VAR,")",1)
 . S VAR=VAR_",IND,0)"
 . S (DONE,IND)=0
 . F  Q:DONE  S IND=$O(^TMP("PXRMINQ",$J,IND)) Q:+IND=0  D
 .. I ^TMP("PXRMINQ",$J,IND,0)=FF S DONE=1 Q
 .. S @VAR=^TMP("PXRMINQ",$J,IND,0)
 E  D
 . S (DONE,IND)=0
 . F  Q:DONE  S IND=$O(^TMP("PXRMINQ",$J,IND)) Q:+IND=0  D
 .. S VAR(IND)=^TMP("PXRMINQ",$J,IND,0)
 .. I VAR(IND)=FF K ARRAY(IND) S DONE=1
 K ^TMP("PXRMINQ",$J)
 ;Delete the host file.
 S FILESPEC(FILENAME)=""
 S SUCCESS=$$DEL^%ZISH(PATH,$NA(FILESPEC))
 Q
 ;
 ;======================================================================
SELECT(ROOT,PROMPT,DEFAULT) ;Select the entry.
 N DIC,Y
 S DIC=ROOT
 S DIC(0)="AEMQ"
 S DIC("A")=PROMPT
 I $G(DEFAULT)'="" S DIC("B")=DEFAULT
 D ^DIC
 Q Y
 ;
 ;======================================================================
SET(Y,TEXT) ;Set data for entry selection and the header.
 ;
 ;These variables need to be setup every time because DIP kills them.
 S BY="NUMBER"
 S (FR,TO)=+$P(Y,U,1)
 ;
 ;If TEXT is null then no header.
 I $L(TEXT)>0 D
 . S NOW=$$NOW^XLFDT
 . S NOW=$$FMTE^XLFDT(NOW,"1P")
 . S DHD="W ?0 D HEADER^PXRMINQ("""_TEXT_""")"
 E  S DHD="@@"
 Q
 ;
 ;======================================================================
SPONSOR ;Do sponsor inquiry.
 N BY,DC,DHD,FLDS,FROM,IENN,NOW,PXRMEDOK,PXRMFVPL,PXRMROOT,TO
 S PXRMEDOK=1
 S FLDS="[PXRM SPONSOR INQUIRY]"
 S IENN=0
 S PXRMROOT="^PXRMD(811.6,"
 F  Q:IENN=-1  D
 . S IENN=$$SELECT(PXRMROOT,"Select Reminder Sponsor: ","")
 . I IENN=-1 Q
 . D SET(IENN,"REMINDER SPONSOR INQUIRY")
 . D DISP(PXRMROOT,FLDS)
 Q
 ;
 ;======================================================================
TAX ;Do taxonomy inquiry.
 N BY,DC,DHD,FLDS,FROM,IENN,NOW,PXRMFVPL,PXRMROOT,TO
 S FLDS="[PXRM TAXONOMY INQUIRY]"
 S IENN=0
 S PXRMROOT="^PXD(811.2,"
 F  Q:IENN=-1  D
 . S IENN=$$SELECT(PXRMROOT,"Select Reminder Taxonomy: ","")
 . I IENN=-1 Q
 . D SET(IENN,"REMINDER TAXONOMY INQUIRY")
 . D DISP(PXRMROOT,FLDS)
 Q
 ;
 ;======================================================================
TERM ;Do term inquiry.
 N BY,DC,DHD,FLDS,FROM,IENN,NOW,PXRMFVPL,PXRMROOT,TO
 ;Build the finding variable pointer information
 D BLDRLIST^PXRMVPTR(811.52,.01,.PXRMFVPL)
 S FLDS="[PXRM TERM INQUIRY]"
 S IENN=0
 S PXRMROOT="^PXRMD(811.5,"
 F  Q:IENN=-1  D
 . S IENN=$$SELECT(PXRMROOT,"Select Reminder Term: ","")
 . I IENN=-1 Q
 . D SET(IENN,"REMINDER TERM INQUIRY")
 . D DISP(PXRMROOT,FLDS)
 Q
 ;
