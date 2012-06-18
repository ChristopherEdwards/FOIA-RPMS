PXRMEXLR ; SLC/PKR/PJH - List Manager routines for existing repository entries. ;05/04/2001
 ;;1.5;CLINICAL REMINDERS;**5**;Jun 19, 2000
 ;======================================================================
CHF ;Create a host file containing repository entries.
 N IND,FILE,LENH2,PATH,SUCCESS,TEMP,VALMY
 ;Get the list to store.
 D EN^VALM2(XQORNOD(0))
 ;If there is no list quit.
 I '$D(VALMY) Q
 ;Get the host file to use.
 D CLEAR^VALM1
 S TEMP=$$GETHFS^PXRMEXHF
 I TEMP=0 S VALMBCK="R" Q
 S PATH=$P(TEMP,U,1)
 S FILE=$P(TEMP,U,2)
 D CHF^PXRMEXHF(.SUCCESS,.VALMY,PATH,FILE)
 S IND=""
 S VALMHDR(1)="Successfully stored entries"
 S VALMHDR(2)="Failed to store entries"
 S LENH2=$L(VALMHDR(2))
 F  S IND=$O(SUCCESS(IND)) Q:+IND=0  D
 . I SUCCESS(IND) S VALMHDR(1)=VALMHDR(1)_" "_IND
 . E  S VALMHDR(2)=VALMHDR(2)_" "_IND
 I $L(VALMHDR(2))=LENH2 K VALMHDR(2)
 S VALMBCK="R"
 Q
 ;
 ;======================================================================
CMM ;Create a MailMan message containing packed reminders.
 N SUCCESS,TEMP,VALMY
 ;Get the list to store.
 D EN^VALM2(XQORNOD(0))
 ;If there is no list quit.
 I '$D(VALMY) Q
 ;Get a new message number to store the entries in.
 D CMM^PXRMEXMM(.SUCCESS,.VALMY)
 I $D(SUCCESS("XMZ")) S VALMHDR(1)="Successfully stored entries in message "_SUCCESS("XMZ")_"."
 E  S VALMHDR(1)="Failed to store entries"
 S VALMBCK="R"
 Q
 ;
 ;======================================================================
DELETE ;Get a list of repository entries and delete them.
 N COUNT,DELLIST,IEN,IND,RELIST,VALMY
 ;Get the list to delete.
 D MIENLIST(.DELLIST)
 S COUNT=+$G(DELLIST("COUNT"))
 I COUNT=0 Q
 D DELETE^PXRMEXU1(.DELLIST)
 ;Rebuild the list for List Manager to display.
 K ^TMP("PXRMEXLR",$J)
 D RE^PXRMLIST(.RELIST,.IEN)
 M ^TMP("PXRMEXLR",$J)=RELIST
 S VALMCNT=RELIST("VALMCNT")
 F IND=1:1:VALMCNT D
 . S ^TMP("PXRMEXLR",$J,"IDX",IND,IND)=IEN(IND)
 ;
 S VALMHDR(1)="Deleted "_DELLIST("COUNT")_" Exchange File"
 I COUNT>1 S VALMHDR(1)=VALMHDR(1)_" entries."
 I COUNT=1 S VALMHDR(1)=VALMHDR(1)_" entry."
 I COUNT=0 S VALMHDR(1)="No entries selected."
 S VALMHDR(2)=" "
 S VALMBCK="R"
 Q
 ;
 ;======================================================================
DELHIST ;Get a list of repository installation entries and delete them.
 ;Save the original list, it contains the selected repository entries.
 N VALMYO
 M VALMYO=VALMY
 N IHIND,IND,RIEN,TEMP,VALMY
 N VALMBG,VALMLST
 ;
 S VALMBG=1,VALMLST=+$O(^TMP("PXRMEXIH",$J,"IDX",""),-1)
 ;Get the list to delete.
 D EN^VALM2(XQORNOD(0))
 ;If there is no list quit.
 I '$D(VALMY) Q
 S IND=""
 F  S IND=$O(VALMY(IND)) Q:IND=""  D
 . S TEMP=^TMP("PXRMEXIH",$J,"SEL",IND)
 . S RIEN=$P(TEMP,U,1)
 . S IHIND=$P(TEMP,U,2)
 . D DELHIST^PXRMEXU1(RIEN,IHIND)
 ;Rebuild the display list.
 D HISTLIST^PXRMEXLC(.VALMYO,.VALMCNT)
 S VALMBCK="R"
 Q
 ;
 ;======================================================================
EXIT ; Exit code
 D CLEAN^VALM10
 D FULL^VALM1
 S VALMBCK="R"
 K ^TMP("PXRMEXLR",$J)
 Q
 ;
 ;======================================================================
IH ;Get a list of repository entries and show their installation history.
 N VALMCNT,VALMY
 D EN^VALM2(XQORNOD(0))
 ;If there is no list quit.
 I '$D(VALMY) Q
 ;Build a history list.
 D HISTLIST^PXRMEXLC(.VALMY,.VALMCNT)
 D EN^VALM("PXRM EX INSTALLATION HISTORY")
 K ^TMP("PXRMEXIH",$J)
 S VALMBCK="R"
 Q
 ;
 ;======================================================================
INDETAIL ;Output the details of an installation.
 N VALMBG,VALMCNT,VALMHDR,VALMLST,VALMY
 ;
 S VALMBG=1,VALMLST=+$O(^TMP("PXRMEXIH",$J,"IDX",""),-1)
 ;Get the list to display.
 D EN^VALM2(XQORNOD(0))
 ;If there is no list quit.
 I '$D(VALMY) Q
 D INDISP(.VALMY)
 Q
 ;
 ;======================================================================
INDISP(ARRAY) ;Display details list
 N ACTION,CMPNT,DI,DP,ENTRY,IHIND,IND,INDEX,JND,KND
 N NAME,NEWNAME,NLINE,RIEN,TEMP
 K ^TMP("PXRMEXID",$J)
 ;If there are no items then quit.
 I '$D(ARRAY) Q
 S (IND,NLINE)=0
 F  S IND=$O(ARRAY(IND)) Q:IND=""  D
 . S TEMP=^TMP("PXRMEXIH",$J,"SEL",IND)
 . S RIEN=$P(TEMP,U,1)
 . S IHIND=$P(TEMP,U,2)
 . S TEMP=^PXD(811.8,RIEN,0)
 . S ENTRY=$E($P(TEMP,U,1),1,38)
 . S ENTRY=$$LJ^XLFSTR(ENTRY,38," ")
 . S DP=$$FMTE^XLFDT($P(TEMP,U,3),"5Z")
 . S DI=$$FMTE^XLFDT(^PXD(811.8,RIEN,130,IHIND,0),"5Z")
 . I NLINE>1 D
 .. S NLINE=NLINE+1
 .. S ^TMP("PXRMEXID",$J,NLINE,0)="------------------------------------------------------------------------------"
 . S NLINE=NLINE+1
 . S ^TMP("PXRMEXID",$J,NLINE,0)=ENTRY_" "_DP_"  "_DI
 .;Write the header line here.
 . S NLINE=NLINE+1
 . S ^TMP("PXRMEXID",$J,NLINE,0)="     Component                         Action  New Name"
 . S CMPNT=""
 . S JND=0
 . F  S JND=$O(^PXD(811.8,RIEN,130,IHIND,1,JND)) Q:JND=""  D
 .. S TEMP=^PXD(811.8,RIEN,130,IHIND,1,JND,0)
 .. I $P(TEMP,U,2)'=CMPNT D
 ... S NLINE=NLINE+1
 ... S ^TMP("PXRMEXID",$J,NLINE,0)=" "
 ... S CMPNT=$P(TEMP,U,2)
 ... S NLINE=NLINE+1
 ... S ^TMP("PXRMEXID",$J,NLINE,0)=CMPNT
 .. S INDEX=$$RJ^XLFSTR($P(TEMP,U,1),4," ")
 .. S NAME=$E($P(TEMP,U,3),1,36)
 .. S NAME=$$LJ^XLFSTR(NAME,36," ")
 .. S ACTION=$P(TEMP,U,4)
 .. S NEWNAME=$E($P(TEMP,U,5),1,36)
 .. S NEWNAME=$$LJ^XLFSTR(NEWNAME,36," ")
 .. S NLINE=NLINE+1
 .. S ^TMP("PXRMEXID",$J,NLINE,0)=INDEX_" "_NAME_" "_ACTION_"    "_NEWNAME
 ..;If there are Additional Details add them to the display.
 .. S KND=0
 .. F  S KND=$O(^PXD(811.8,RIEN,130,IHIND,1,JND,1,KND)) Q:KND=""  D
 ... S NLINE=NLINE+1
 ... S ^TMP("PXRMEXID",$J,NLINE,0)=^PXD(811.8,RIEN,130,IHIND,1,JND,1,KND,0)
 . S NLINE=NLINE+1
 . S ^TMP("PXRMEXID",$J,NLINE,0)=" "
 S VALMHDR(1)=^PXD(811.8,RIEN,0)_"  "_^TMP("PXRMEXID",$J,1,0)
 S VALMCNT=NLINE
 D EN^VALM("PXRM EX INSTALLATION DETAIL")
 K ^TMP("PXRMEXID",$J)
 S VALMBCK="R"
 Q
 ;
 ;======================================================================
INSTALL ;Get a list of repository entries and install them.
 N IND,PXRMRIEN,VALMY
 D EN^VALM2(XQORNOD(0))
 ;If there is no list quit.
 I '$D(VALMY) Q
 ;PXRMDONE is newed in PXRMEXLM
 S PXRMDONE=0
 S IND=""
 F  S IND=$O(VALMY(IND)) Q:(+IND=0)!(PXRMDONE)  D
 .;Get the repository ien.
 . S PXRMRIEN=^TMP("PXRMEXLR",$J,"IDX",IND,IND)
 .;The list template calls INSTALL^PXRMEXLI
 . D EN^VALM("PXRM EX LIST COMPONENTS")
 . K ^TMP("PXRMEXLC",$J)
 Q
 ;
 ;======================================================================
HDR ; Header code
 S VALMHDR(1)=""
 D CHGCAP^VALM("RNAME","Reminder Name")
 D CHGCAP^VALM("PNAME","Date Loaded")
 Q
 ;
 ;======================================================================
HELP ; Help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
 ;======================================================================
IS ;Get a list of packed reminders and print the installation summary.
 N VALMY
 D EN^VALM2(XQORNOD(0))
 ;If there is no list quit.
 I '$D(VALMY) Q
 Q
 ;
 ;======================================================================
MIENLIST(LIST) ;Get a list of List Manager repository entries and turn it
 ;into iens.
 N COUNT,IEN,VALMY
 D EN^VALM2(XQORNOD(0))
 ;If there is no list quit.
 I '$D(VALMY) Q
 S COUNT=0
 S IND=""
 F  S IND=$O(VALMY(IND)) Q:+IND=0  D
 . S COUNT=COUNT+1
 . S IEN=^TMP("PXRMEXLR",$J,"IDX",IND,IND)
 . S LIST(IEN)=""
 S LIST("COUNT")=COUNT
 Q
 ;
PEXIT ;PXRM EXCH INSTALLATION MENU protocol exit code
 S VALMSG="+ Next Screen   - Prev Screen   ?? More Actions"
 ;Reset after page up/down etc
 D XQORM
 Q
 ;
XQORM S XQORM("#")=$O(^ORD(101,"B","PXRM EXCH SELECT HISTORY",0))_U_"1:"_VALMCNT
 S XQORM("A")="Select Action: "
 Q
 ;
XSEL ;PXRM EXCH SELECT HISTORY validation
 N ARRAY,CNT,SELECT,SEL
 S SELECT=$P(XQORNOD(0),"=",2)
 I '$$VALID^PXRMEXLD(SELECT) S VALMBCK="R" Q
 ;
 ;Build array of selected items
 F CNT=1:1 S SEL=$P(SELECT,",",CNT) Q:'SEL  D
 .S ARRAY(SEL)=""
 ;
 ;Display Selected Histories
 D INDISP(.ARRAY)
 Q
