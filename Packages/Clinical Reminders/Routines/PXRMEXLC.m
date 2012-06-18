PXRMEXLC ; SLC/PKR/PJH - Routines to display repository entry components. ;08/30/2001
 ;;1.5;CLINICAL REMINDERS;**5,7**;Jun 19, 2000
 ;======================================================================
BLDLIST(FORCE) ;Build a list of all repository entries.
 ;If FORCE is true then force rebuilding of the list.
 I FORCE K ^TMP("PXRMEXLR",$J)
 I $D(^TMP("PXRMEXLR",$J,"VALMCNT")) S VALMCNT=^TMP("PXRMEXLR",$J,"VALMCNT")
 E  D
 . N IEN,RELIST
 . D RE^PXRMLIST(.RELIST,.IEN)
 . M ^TMP("PXRMEXLR",$J)=RELIST
 . S VALMCNT=RELIST("VALMCNT")
 . F IND=1:1:VALMCNT D
 .. S ^TMP("PXRMEXLR",$J,"IDX",IND,IND)=IEN(IND)
 Q
 ;
 ;======================================================================
CDISP(IEN) ;Format component list for display.
 N CAT,CMPNT,END,EOKTI,EXISTS,FILENUM,FOKTI,IND,INDEX,JND,JNDS,KND
 N MSG,NCMPNT,NDLINE,NDSEL,NITEMS,NLINE,NSEL,PT01,START,TEMP,TEMP0,TYPE
 K ^TMP("PXRMEXLC",$J)
 K ^TMP("PXRMEXLD",$J)
 S (NDLINE,NLINE)=0
 S (NDSEL,NSEL)=1
 ;Load the description.
 F IND=1:1:$P(^PXD(811.8,IEN,110,0),U,4) D
 . S NLINE=NLINE+1
 . S ^TMP("PXRMEXLC",$J,NLINE,0)=^PXD(811.8,IEN,110,IND,0)
 . S ^TMP("PXRMEXLC",$J,"IDX",NLINE,NSEL)=""
 S NLINE=NLINE+1
 S ^TMP("PXRMEXLC",$J,NLINE,0)=" "
 S ^TMP("PXRMEXLC",$J,"IDX",NLINE,NSEL)=""
 S NCMPNT=^PXD(811.8,IEN,119)
 ;Load the text for display.
 F IND=1:1:NCMPNT D
 . S NLINE=NLINE+1
 . S TEMP=^PXD(811.8,IEN,120,IND,0)
 . S ^TMP("PXRMEXLC",$J,NLINE,0)=$P(TEMP,U,1)
 . S ^TMP("PXRMEXLC",$J,"IDX",NLINE,NSEL)=""
 . S FILENUM=$P(TEMP,U,2)
 . S FOKTI=$$FOKTI^PXRMEXFI(FILENUM)
 . S NITEMS=$P(TEMP,U,3)
 . I $P(TEMP,U,1)="REMINDER DIALOG" D
 ..;Save details of the dialog in ^TMP("PXRMEXTMP")
 .. S JNDS=NITEMS D DBUILD^PXRMEXLB(IND,NITEMS,FILENUM)
 . E  S JNDS=1
 . F JND=JNDS:1:NITEMS D
 .. S TEMP=^PXD(811.8,IEN,120,IND,1,JND,0)
 .. S EOKTI=FOKTI
 .. S PT01=$P(TEMP,U,1)
 .. I FILENUM=0 S EXISTS=$$EXISTS^PXRMEXCF(PT01)
 .. E  S EXISTS=$$EXISTS^PXRMEXIU(FILENUM,PT01)
 ..;If this is an education topic and it starts with VA- it
 ..;cannot be transported.
 .. I (FILENUM=9999999.09)&(PT01["VA-") S EOKTI=0
 ..;If this is a health factor see if it is a category.
 .. S CAT=""
 .. I (FILENUM=9999999.64) D
 ... S TYPE=""
 ... S START=$P(TEMP,U,2)
 ... S END=$P(TEMP,U,3)
 ... F KND=START:1:END D
 .... S TEMP0=$P(^PXD(811.8,IEN,100,KND,0),";",3)
 .... I $P(TEMP0,"~",1)=.1 S TYPE=$P(TEMP0,"~",2)
 ... I TYPE="CATEGORY" S CAT="X"
 .. S NLINE=NLINE+1
 .. I IND=1,JND=1 S NSEL=1,INDEX=$S(EOKTI:NSEL,1:"")
 .. E  D
 ...;If entries in this file are ok to install add them to the
 ...;selectable list. Make sure the first selectable entry exists
 ...;before incrementing NSEL.
 ... I EOKTI S NSEL=$S($D(^TMP("PXRMEXLC",$J,"SEL",1)):NSEL+1,1:NSEL),INDEX=NSEL
 ... E  S INDEX=""
 .. S ^TMP("PXRMEXLC",$J,NLINE,0)=$$FMTDATA(INDEX,PT01,CAT,EXISTS)
 .. S ^TMP("PXRMEXLC",$J,"IDX",NLINE,NSEL)=""
 ..;Store the file number, node 120 indexes and the ien if it exists.
 .. I INDEX=NSEL S ^TMP("PXRMEXLC",$J,"SEL",NSEL)=FILENUM_U_IND_U_JND_U_EXISTS
 . S NLINE=NLINE+1
 . S ^TMP("PXRMEXLC",$J,NLINE,0)=""
 . S ^TMP("PXRMEXLC",$J,"IDX",NLINE,NSEL)=""
 Q
 ;
 ;======================================================================
DDISP(IND,NITEMS,FILENUM) ;Setup dialog display list.
 N JND,NLINE,NSEL,TEMP
 S (NLINE,NSEL)=0
 F JND=1:1:NITEMS D
 . S TEMP=^PXD(811.8,IEN,120,IND,1,JND,0)
 . S PT01=$P(TEMP,U,1)
 . S EXISTS=$$EXISTS^PXRMEXIU(FILENUM,PT01)
 . S NLINE=NLINE+1
 . S NSEL=NSEL+1
 . S ^TMP("PXRMEXLD",$J,NLINE,0)=$$FMTDATA(NSEL,PT01,CAT,EXISTS)
 . S ^TMP("PXRMEXLD",$J,"IDX",NLINE,NSEL)=""
 .;Store the file number, start and stop line in the repository.
 . S ^TMP("PXRMEXLD",$J,"SEL",NSEL)=FILENUM_U_$P(TEMP,U,2,3)
 Q
 ;
 ;======================================================================
FMTDATA(NSEL,PT01,CAT,EXISTS) ;Format items for display.
 N NSTI,TEMP
 S TEMP=$$RJ^XLFSTR(NSEL,4," ")_"  "_$E(PT01,1,54)
 I CAT="X" D
 . S NSTI=63-$L(TEMP)
 . S TEMP=TEMP_$$INSCHR(NSTI," ")_"X"
 I EXISTS D
 . S NSTI=75-$L(TEMP)
 . S TEMP=TEMP_$$INSCHR(NSTI," ")_"X"
 Q TEMP
 ;
 ;======================================================================
HISTLIST(LIST,VALMCNT) ;Build a list of install histories in
 ;^TMP("PXRMEXIH",$J).
 N DATE,DC,ENTRY,IHIND,IND,INDONE,NLINE,NSEL,RIEN,SOURCE,TEMP,USER
 K ^TMP("PXRMEXIH",$J)
 S (NLINE,NSEL)=0
 S IND=""
 F  S IND=$O(LIST(IND)) Q:IND=""  D
 . S RIEN=^TMP("PXRMEXLR",$J,"IDX",IND,IND)
 . I $D(^PXD(811.8,RIEN,130)) S INDONE=1
 . E  S INDONE=0
 . S TEMP=^PXD(811.8,RIEN,0)
 . S ENTRY=$P(TEMP,U,1)
 . S SOURCE=$P(TEMP,U,2)
 . S DATE=$P(TEMP,U,3)
 . S NLINE=NLINE+1
 . I INDONE S NSEL=NSEL+1
 . S ^TMP("PXRMEXIH",$J,NLINE,0)=$$FRE^PXRMLIST(" ",ENTRY,SOURCE,DATE)
 . I INDONE S ^TMP("PXRMEXIH",$J,"IDX",NLINE,NSEL)=""
 . S NLINE=NLINE+1
 . S ^TMP("PXRMEXIH",$J,NLINE,0)="     Installation Date       Installed By"
 . I INDONE S ^TMP("PXRMEXIH",$J,"IDX",NLINE,NSEL)=""
 . S NLINE=NLINE+1
 . S ^TMP("PXRMEXIH",$J,NLINE,0)="     -----------------       ------------"
 . I INDONE S ^TMP("PXRMEXIH",$J,"IDX",NLINE,NSEL)=""
 . I 'INDONE D  Q
 .. S NLINE=NLINE+1
 .. S ^TMP("PXRMEXIH",$J,NLINE,0)="      none"
 .. S NLINE=NLINE+1
 .. S ^TMP("PXRMEXIH",$J,NLINE,0)=" "
 . S DATE=""
 . S DC=0
 . F  S DATE=$O(^PXD(811.8,RIEN,130,"B",DATE)) Q:DATE=""  D
 .. S NLINE=NLINE+1
 .. S DC=DC+1
 .. I DC>1 S NSEL=NSEL+1
 .. S IHIND=$O(^PXD(811.8,RIEN,130,"B",DATE,""))
 .. S TEMP=^PXD(811.8,RIEN,130,IHIND,0)
 .. S ^TMP("PXRMEXIH",$J,NLINE,0)=$$RJ^XLFSTR(NSEL,4," ")_" "_$$FMTE^XLFDT($P(TEMP,U,1),"5Z")_"   "_$P(TEMP,U,2)
 .. S ^TMP("PXRMEXIH",$J,"IDX",NLINE,NSEL)=""
 .. S ^TMP("PXRMEXIH",$J,"SEL",NSEL)=RIEN_U_IHIND
 . S NLINE=NLINE+1
 . S ^TMP("PXRMEXIH",$J,NLINE,0)=" "
 . S ^TMP("PXRMEXIH",$J,"IDX",NLINE,NSEL)=""
 S VALMCNT=NLINE
 Q
 ;
 ;======================================================================
INSCHR(NUM,CHR) ;Return a string of NUM characters (CHR).
 N IND,TEMP
 S TEMP=""
 I NUM<1 Q TEMP
 F IND=1:1:NUM S TEMP=TEMP_CHR
 Q TEMP
 ;
