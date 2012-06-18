PXRMEXPR ; SLC/PKR/PJH - Routines to create packed reminder definitions. ;08/31/2001
 ;;1.5;CLINICAL REMINDERS;**5,7**;Jun 19, 2000
 ;======================================================================
ADDFILE(FLIST,ROOT,FILENAME) ;Add a file to the list of finding files.
 N DIC,DO,FILENUM
 S DIC="^"_ROOT
 K DO
 D DO^DIC1
 S FILENUM=+DO(2)
 S FILENAME=$P(DO,U,1)
 S FLIST(FILENAME)=FILENUM
 Q
 ;
 ;======================================================================
ADDFIND(FLIST,FILENAME,IEN) ;Add a finding to the list of findings.
 S FLIST(FILENAME,"F",IEN)=""
 ;Make sure categories are included for any health factors and they
 ;come first in the list of health factors.
 I FILENAME="HEALTH FACTORS" D
 . N CAT
 . S CAT=$P(^AUTTHF(IEN,0),U,3)
 . S FLIST(FILENAME,"C",CAT)=""
 Q
 ;
 ;======================================================================
BLDSPON(RIEN,FINDLIST,SPONLIST) ;Build the sponsor list.
 N DIEN,IEN,IND,IND0
 ;Start with the definition.
 D GETSPON(811.9,RIEN,.SPONLIST)
 ;If there is a dialog add it.
 S DIEN=+$P($G(^PXD(811.9,RIEN,51)),U,1)
 I DIEN>0 D GETSPON(801.41,DIEN,.SPONLIST)
 ;Go through the finding list to find additional sponsors.
 S IND=""
 F  S IND=$O(FINDLIST(IND)) Q:IND=""  D
 . S FILENUM=FINDLIST(IND)
 . I (FILENUM'<800)&(FILENUM'>811.9) D
 .. S IND0=""
 .. F  S IND0=$O(FINDLIST(IND,IND0)) Q:IND0=""  D
 ... S IEN=""
 ... F  S IEN=+$O(FINDLIST(IND,IND0,IEN)) Q:IEN=0  D
 .... D GETSPON(FILENUM,IEN,.SPONLIST)
 ;Add any associated sponsors to the begining of the list.
 S IND=""
 F  S IND=$O(SPONLIST("S",IND)) Q:IND=""  D
 . S IND0=0
 . F  S IND0=+$O(^PXRMD(811.6,IND,2,IND0)) Q:IND0=0  D
 .. S IEN=+^PXRMD(811.6,IND,2,IND0,0)
 .. S SPONLIST("A",IEN)=""
 Q
 ;
 ;======================================================================
BLDTEXT(TMPIND) ;Combine the source information and the users input into the
 ;"TEXT" array.
 N IC,IND
 S (IC,IND)=0
 F  S IC=$O(^TMP(TMPIND,$J,"SRC",IC)) Q:+IC=0  D
 . S IND=IND+1
 . S ^TMP(TMPIND,$J,"TEXT",1,IND)=^TMP(TMPIND,$J,"SRC",IC)
 ;
 S IC=0
 F  S IC=$O(^TMP(TMPIND,$J,"TXT",1,IC)) Q:+IC=0  D
 . S IND=IND+1
 . S ^TMP(TMPIND,$J,"TEXT",1,IND)=^TMP(TMPIND,$J,"TXT",1,IC,0)
 Q
 ;
 ;======================================================================
GETDFIND(RIEN,FLIST) ;Build the list of definition findings.
 ;FLIST has the format FLIST(FILENAME)=file number, and for each
 ;finding from the file FLIST(FILENAME,"F",IEN)="". For Health Factors
 ;category entries are FLIST(FILENAME,"C",IEN)="".
 N FILENAME,IEN,ROOT
 S ROOT=""
 F  S ROOT=$O(^PXD(811.9,RIEN,20,"E",ROOT)) Q:ROOT=""  D
 . D ADDFILE(.FLIST,ROOT,.FILENAME)
 . S IEN=0
 . F  S IEN=$O(^PXD(811.9,RIEN,20,"E",ROOT,IEN)) Q:+IEN=0  D
 .. D ADDFIND(.FLIST,FILENAME,IEN)
 Q
 ;
 ;======================================================================
GETSPON(FILENUM,IEN,SPONLIST) ;Add sponsors to the sponsor list.
 N ENTRY,ROOT,SPONSOR
 S ROOT=$$GET1^DID(FILENUM,"","","GLOBAL NAME")
 S ENTRY=ROOT_IEN_",100)"
 S ENTRY=$G(@ENTRY)
 S SPONSOR=$P(ENTRY,U,2)
 I SPONSOR'="" S SPONLIST("S",SPONSOR)=""
 Q
 ;
 ;======================================================================
GETTFIND(FLIST) ;If there are any terms in the list of findings go through
 ;them and add the mapped findings to the list of findings.
 I '$D(FLIST("REMINDER TERM")) Q
 N FILENAME,ROOT,TIEN
 S TIEN=0
 F  S TIEN=$O(FLIST("REMINDER TERM","F",TIEN)) Q:+TIEN=0  D
 . S ROOT=""
 . F  S ROOT=$O(^PXRMD(811.5,TIEN,20,"E",ROOT)) Q:ROOT=""  D
 .. D ADDFILE(.FLIST,ROOT,.FILENAME)
 .. S IEN=0
 .. F  S IEN=$O(^PXRMD(811.5,TIEN,20,"E",ROOT,IEN)) Q:+IEN=0  D
 ... D ADDFIND(.FLIST,FILENAME,IEN)
 Q
 ;
 ;======================================================================
GETTEXT(RIEN,TMPIND,INDEX) ;Let the user input some text.
 N DIC,DWLW,DWPK
 ;If this is the description text, load the reminder description as
 ;the default.
 S RIEN=+RIEN
 I RIEN>0 M ^TMP(TMPIND,$J,INDEX,1)=^PXD(811.9,RIEN,1)
 S DIC="^TMP(TMPIND,$J,"""_INDEX_""",1,"
 S DWLW=72
 S DWPK=1
 D EN^DIWE
 Q
 ;
 ;======================================================================
PACK(RTP,TMPIND) ;Create the packed reminder, store it in
 ;^TMP(TMPIND,$J). TMPIND should be namespaced and set by the caller.
 ;Save the source information
 I +RTP'>0 Q
 K ^TMP(TMPIND,$J)
 D PUTSRC(RTP,TMPIND)
 ;
 ;Have the user input text that describes the reminder.
 W !,"Enter a description of the reminder you are packing." H 3
 D GETTEXT(RTP,TMPIND,"DESC")
 ;
 ;Have the user input keywords for indexing the reminder.
 W !,"Enter keywords or phrases to help index the reminder you are packing."
 W !,"Separate the keywords or phrases on each line with commas." H 3
 D GETTEXT(0,TMPIND,"KEYWORD")
 ;
 ;Combine the source and input text into the "TEXT" array.
 D BLDTEXT(TMPIND)
 ;
 W !,"Packing the reminder ... "
 ;Build lists of the various reminder components.
 N CF,IEN,IND0,FINDLIST,FILELIST,FILENAME,FILENUM,DLGLIST
 N NUMF,NUMR,OBJLIST,RIEN,ROUTINE,RTNLIST
 N SERROR,SPONLIST,TEMLIST
 S RIEN=$P(RTP,U,1)
 ;
 ;Get the list of definition findings and start the sponsor list.
 D GETDFIND(RIEN,.FINDLIST)
 ;
 ;Add term findings to the list.
 D GETTFIND(.FINDLIST)
 ;
 ;If a dialog exists for this reminder add it and its findings to the
 ;list. Also collect any embedded TIU objects or templates
 D DIALOG^PXRMEXDG(RIEN,.DLGLIST,.FINDLIST,.OBJLIST,.TEMLIST)
 ;
 ;The finding list is complete, search the definition, dialog and
 ;all the findings for sponsors.
 D BLDSPON(RIEN,.FINDLIST,.SPONLIST)
 ;
 ;Put sponsors first on the file list.
 S NUMF=0
 S IND0=0
 F  S IND0=$O(SPONLIST(IND0)) Q:IND0=""  D
 . S IEN=0
 . F  S IEN=$O(SPONLIST(IND0,IEN)) Q:IEN=""  D
 .. S NUMF=NUMF+1
 .. S FILELIST(NUMF)="REMINDER SPONSOR"_U_811.6_U_IEN
 ;
 ;Look for any computed findings and put the associated routines
 ;on the routine list.
 S (IEN,NUMR)=0
 F  S IEN=$O(FINDLIST("REMINDER COMPUTED FINDINGS","F",IEN)) Q:IEN=""  D
 . S ROUTINE=$P(^PXRMD(811.4,IEN,0),U,2)
 . S NUMR=NUMR+1
 . S RTNLIST(NUMR)=ROUTINE
 ;
 ;Go through the finding list and create the file list in the same
 ;order as the finding list.
 S FILENAME=""
 F  S FILENAME=$O(FINDLIST(FILENAME)) Q:FILENAME=""  D
 . S FILENUM=FINDLIST(FILENAME)
 . S IND0=""
 . F  S IND0=$O(FINDLIST(FILENAME,IND0)) Q:IND0=""  D
 .. S IEN=0
 .. F  S IEN=$O(FINDLIST(FILENAME,IND0,IEN)) Q:IEN=""  D
 ... S NUMF=NUMF+1
 ... S FILELIST(NUMF)=FILENAME_U_FILENUM_U_IEN
 ;
 ;Add TIU templates to the file list.
 S IND0=0
 F  S IND0=$O(TEMLIST(IND0)) Q:IND0=""  D
 . S IEN=$$EXISTS^PXRMEXIU(8927.1,TEMLIST(IND0))
 . S NUMF=NUMF+1
 . S FILELIST(NUMF)="TIU TEMPLATE FIELD"_U_8927.1_U_IEN
 ;
 ;Put the reminder at next to last.
 S NUMF=NUMF+1
 S FILELIST(NUMF)="REMINDER DEFINITION"_U_811.9_U_RIEN
 ;
 ;Put dialogs last on the file list.
 S FILENUM=$G(DLGLIST("DIALOG"))
 S IND0=""
 F  S IND0=$O(DLGLIST("DIALOG",IND0)) Q:IND0=""  D
 . S IEN=""
 . F  S IEN=$O(DLGLIST("DIALOG",IND0,IEN)) Q:IEN=""  D
 .. S NUMF=NUMF+1
 .. S FILELIST(NUMF)="REMINDER DIALOG"_U_FILENUM_U_IEN
 ;
 S SERROR=0
 ;Put any routines into the ^TMP array.
 D GRTN^PXRMEXPU(.RTNLIST,NUMR,TMPIND,.SERROR)
 ;Put the GETS^DIQ extracts of the findings, dialogs, and
 ;reminder definition into the ^TMP array.
 D GDIQF^PXRMEXPU(.FILELIST,NUMF,TMPIND,.SERROR)
 ;
 ;If there were any errors saving the data kill the ^TMP array.
 I SERROR K ^TMP(TMPIND,$J)
 Q
 ;
 ;======================================================================
PUTSRC(RTP,TMPIND) ;Save the source information
 N LOC
 S LOC=$$SITE^VASITE
 S ^TMP(TMPIND,$J,"SRC","REMINDER")=$P(RTP,U,2)
 S ^TMP(TMPIND,$J,"SRC","USER")=$P(^VA(200,DUZ,0),U,1)
 S ^TMP(TMPIND,$J,"SRC","SITE")=$P(LOC,U,2)
 S ^TMP(TMPIND,$J,"SRC","DATE")=$$FMTE^XLFDT($$NOW^XLFDT,"5Z")
 Q
 ;
