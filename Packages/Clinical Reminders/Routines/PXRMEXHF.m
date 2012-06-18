PXRMEXHF ; SLC/PKR - Routines to select and deal with host files. ;09/24/2001
 ;;1.5;CLINICAL REMINDERS;**5,7**;Jun 19, 2000
 ;======================================================================
CHF(SUCCESS,LIST,PATH,FILE) ;Put the repository entries in LIST into the
 ;host file specified by PATH and FILE.
 N GBL,LIEN,RIEN
 S SUCCESS=1
 S LIEN=$O(LIST(""))
 I LIEN="" Q
 S RIEN=$$RIEN^PXRMEXU1(LIEN)
 S GBL="^PXD(811.8,"_RIEN_",100,1,0)"
 ;Save the first entry.
 S SUCCESS(LIEN)=$$GTF^%ZISH(GBL,4,PATH,FILE)
 I SUCCESS(LIEN)=0 Q
 ;Append any remaining entries.
 F  S LIEN=$O(LIST(LIEN)) Q:+LIEN=0  D
 . S RIEN=$$RIEN^PXRMEXU1(LIEN)
 . S GBL="^PXD(811.8,"_RIEN_",100,1,0)"
 . S SUCCESS(LIEN)=$$GATF^%ZISH(GBL,4,PATH,FILE)
 Q
 ;
 ;======================================================================
GETEHF() ;Get an existing host file.
 ;Build a list of all .PRD files in the current directory.
 N FILESPEC,FILELIST,PATH
 S FILESPEC("*.PRD")=""
 S PATH=$$PWD^%ZISH
 N DIR,X,Y
 K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="FAU"_U_"1:32"
 S DIR("A")="Enter a path: "
 S DIR("B")=PATH
 S DIR("?",1)="A host file is a file on your host system."
 S DIR("?",2)="A complete host file consists of a path, file name, and extension"
 S DIR("?",3)="A path consists of a device and directory name."
 S DIR("?",4)="The default extension is prd (Packed Reminder Definition)."
 S DIR("?")="The default path is "_PATH
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 I $D(DIRUT) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) Q ""
 S PATH=Y
 S Y=$$LIST^%ZISH(PATH,"FILESPEC","FILELIST")
 I Y D
 . W !,"The following PRD files were found in ",PATH
 . S FILE=""
 . F  S FILE=$O(FILELIST(FILE)) Q:FILE=""  D
 .. W !,?2,FILE
 E  W !,"No PRD files were found in path ",PATH
 ;
 K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="FAOU"_U_"1:32"
 S DIR("A")="Enter a file name: "
 S DIR("?",1)="A file name has the format NAME.EXTENSION, the default extension is PRD"
 S DIR("?",2)="Therefore if you type in FILE for the file name, the host file will be"
 S DIR("?")="  "_PATH_"FILE.PRD"
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 I $D(DIRUT) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) Q ""
 S FILE=Y
 ;Add the default extension if there isn't one.
 I FILE'["." S FILE=FILE_".PRD"
 Q PATH_U_FILE
 ;
 ;======================================================================
GETHFS() ;Get the name of a host file to store repository entries in.
 N DIROUT,DIRUT,DTOUT,DUOUT,FILE,HFNAME,PATH
GETHF ;As a default set the path to the current directory.
 S PATH=$$PWD^%ZISH
 N DIR,X,Y
 K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="FAU"_U_"1:32"
 S DIR("A")="Enter a path: "
 S DIR("B")=PATH
 S DIR("?",1)="A host file is a file on your host system."
 S DIR("?",2)="A complete host file consists of a path, file name, and extension"
 S DIR("?",3)="A path consists of a device and directory name."
 S DIR("?",4)="The default extension is prd (Packed Reminder Definition)."
 S DIR("?")="The default path is "_PATH
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 I $D(DIRUT) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) Q 0
 S PATH=Y
 K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="FAU"_U_"1:32"
 S DIR("A")="Enter a file name: "
 S DIR("?",1)="A file name has the format NAME.EXTENSION, the default extension is PRD"
 S DIR("?",2)="Therefore if you type in FILE for the file name, the host file will be"
 S DIR("?")="  "_PATH_"FILE.PRD"
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 I $D(DIRUT) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) Q 0
 S FILE=Y
 ;Add the default extension if there isn't one.
 I FILE'["." S FILE=FILE_".PRD"
 S HFNAME=PATH_FILE
 K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="YAO"
 S DIR("A")="Will save selected entries to host file "_HFNAME_"?: "
 S DIR("B")="Y"
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 I $D(DIRUT) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) Q 0
 I 'Y G GETHF
 Q PATH_U_FILE
 ;
 ;======================================================================
LHF(SUCCESS,PATH,FILE) ;Load a host file containing repository entries into
 ;the repository.
 N CURRL,CSUM,DATEP,DONE,FDA,GBL,IENROOT,IND,LINE,MSG,NENTRY,NLINES
 N RETMP,RNAME,SITE,SOURCE,SSOURCE,US,USER,VRSN
 K ^TMP("PXRMEXHF",$J)
 S GBL="^TMP(""PXRMEXHF"",$J,1,0)"
 S GBL=$NA(@GBL)
 S SUCCESS=$$FTG^%ZISH(PATH,FILE,GBL,3)
 I 'SUCCESS Q
 ;Make sure it has the correct format.
 I (^TMP("PXRMEXHF",$J,1,0)'["xml")!(^TMP("PXRMEXHF",$J,2,0)'="<REMINDER_EXCHANGE_FILE_ENTRY>") D  Q
 . W !,"This host file does not have the correct format!"
 . H 2
 . S SUCCESS=0
 . K ^TMP("PXRMEXHF",$J)
 W !,"Loading host file ",PATH,FILE
 S RETMP="^TMP(""PXRMEXLHF"",$J)"
 S (CURRL,DONE,NENTRY,NLINES,SSOURCE)=0
 F  Q:DONE  D
 . S CURRL=CURRL+1
 . I '$D(^TMP("PXRMEXHF",$J,CURRL,0)) S DONE=1 Q
 . S LINE=^TMP("PXRMEXHF",$J,CURRL,0)
 . S NLINES=NLINES+1
 . S ^TMP("PXRMEXLHF",$J,NLINES,0)=LINE
 . I LINE["<PACKAGE_VERSION>" S VRSN=$$GETTAGV^PXRMEXU3(LINE,"<PACKAGE_VERSION>")
 . I LINE="<SOURCE>" S SSOURCE=1
 . I SSOURCE D
 .. I LINE["<NAME>" S RNAME=$$GETTAGV^PXRMEXU3(LINE,"<NAME>")
 .. I LINE["<USER>" S USER=$$GETTAGV^PXRMEXU3(LINE,"<USER>")
 .. I LINE["<SITE>" S SITE=$$GETTAGV^PXRMEXU3(LINE,"<SITE>")
 .. I LINE["<DATE_PACKED>" S DATEP=$$GETTAGV^PXRMEXU3(LINE,"<DATE_PACKED>")
 . I LINE="</SOURCE>" D
 .. S SSOURCE=0
 .. S SOURCE=USER_" at "_SITE
 .;See if the entry is loaded into the temporary storage.
 . I LINE="</REMINDER_EXCHANGE_FILE_ENTRY>" D
 .. S NLINES=0
 .. S NENTRY=NENTRY+1
 ..;Make sure it has the correct format.
 .. I (^TMP("PXRMEXLHF",$J,1,0)'["xml")!(^TMP("PXRMEXLHF",$J,2,0)'="<REMINDER_EXCHANGE_FILE_ENTRY>") D  Q
 ... W !,"There is a problem reading this host file try a new copy of it."
 ... S SUCCESS=0
 ... H 2
 ..;Make sure this entry does not already exist.
 .. I $$REXISTS^PXRMEXIU(RNAME,DATEP) D
 ... W !,RNAME," with a date packed of ",DATEP
 ... W !,"is already in the Exchange File."
 ... S SUCCESS(NENTRY)=0
 ... H 2
 .. E  D
 ... K FDA,IENROOT
 ... S FDA(811.8,"+1,",.01)=RNAME
 ... S FDA(811.8,"+1,",.02)=SOURCE
 ... S FDA(811.8,"+1,",.03)=DATEP
 ... D UPDATE^PXRMEXPU(.US,.FDA,.IENROOT)
 ... S SUCCESS(NENTRY)=US
 ...;Create the description and save the data.
 ... N DESCT,KEYWORDT
 ... D DESC^PXRMEXU3(RETMP,.DESCT)
 ... D KEYWORD^PXRMEXU3(RETMP,.KEYWORDT)
 ... D DESC^PXRMEXU1(IENROOT(1),RNAME,SOURCE,DATEP,"DESCT","KEYWORDT")
 ... M ^PXD(811.8,IENROOT(1),100)=^TMP("PXRMEXLHF",$J)
 .. K ^TMP("PXRMEXLHF",$J)
 ;
 ;Check the success of the entry installs.
 S SUCCESS=1
 S IND=""
 F  S IND=$O(SUCCESS(IND)) Q:+IND=0  D
 . I 'SUCCESS(IND) S SUCCESS=0 Q
 K ^TMP("PXRMEXHF",$J)
 K ^TMP("PXRMEXLHF",$J)
 Q
 ;
