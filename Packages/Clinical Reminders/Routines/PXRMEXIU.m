PXRMEXIU ; SLC/PKR/PJH - Utilities for installing repository entries. ;01/03/2002
 ;;1.5;CLINICAL REMINDERS;**5,7**;Jun 19, 2000
 ;======================================================================
DEF(FDA,NAMECHG) ;Check the reminder definition to make sure the related
 ;reminder exists and all the findings exist.
 N ABBR,ALIST,IEN,IENS,FILENUM,FINDING,LRD,OFINDING,PT01
 N RRG,SPONSOR,TEXT
 S IENS=$O(FDA(811.9,""))
 ;
 ;Related reminder guideline field 1.4.
 I $D(FDA(811.9,IENS,1.4)) D
 . S RRG=FDA(811.9,IENS,1.4)
 . S IEN=$$EXISTS^PXRMEXIU(811.9,RRG)
 . I IEN=0 D
 ..;Get replacement.
 .. N DIC,X,Y
 .. S TEXT(1)=" "
 .. S TEXT(2)="The Related Reminder Guideline does not exist on your system!"
 .. S TEXT(3)="It is "_RRG_" input a replacement or ^ to leave it empty."
 .. D MES^XPDUTL(.TEXT)
 ..;If this is being called during a KIDS install we need echoing on.
 .. I $D(XPDNM) X ^%ZOSF("EON")
 .. S DIC=811.9,DIC(0)="AEMQ"
 .. D ^DIC
 .. I $D(XPDNM) X ^%ZOSF("EOFF")
 .. I Y=-1 K FDA(811.9,IENS,1.4)
 .. E  S FDA(811.9,IENS,1.4)=$P(Y,U,2)
 ;
 ;Sponsor field 101.
 I $D(FDA(811.9,IENS,101)) D
 . S SPONSOR=FDA(811.9,IENS,101)
 . S IEN=$$FIND1^DIC(811.6,"","",SPONSOR)
 . I IEN=0 D
 ..;Get replacement.
 .. N DIC,X,Y
 .. S TEXT(1)=" "
 .. S TEXT(2)="The Sponsor does not exist on your system!"
 .. S TEXT(3)="It is "_SPONSOR_" input a replacement or ^ to leave it empty."
 .. D MES^XPDUTL(.TEXT)
 ..;If this is being called during a KIDS install we need echoing on.
 .. I $D(XPDNM) X ^%ZOSF("EON")
 .. S DIC=811.6,DIC(0)="AEMQ"
 .. D ^DIC
 .. I $D(XPDNM) X ^%ZOSF("EOFF")
 .. I Y=-1 K FDA(811.9,IENS,101)
 .. E  S FDA(811.9,IENS,101)=$P(Y,U,2)
 ;
 ;Linked reminder dialog field 51.
 S LRD=+$G(FDA(811.9,IENS,51))
 S IEN=$$EXISTS^PXRMEXIU(801.41,LRD)
 I IEN=0 K FDA(811.9,IENS,51)
 ;
 ;Search the finding multiple for replacements and missing findings.
 D BLDALIST^PXRMVPTR(811.902,.01,.ALIST)
 S IENS=""
 F  S IENS=$O(FDA(811.902,IENS)) Q:IENS=""  D
 . S (FINDING,OFINDING)=FDA(811.902,IENS,.01)
 . S ABBR=$P(FINDING,".",1)
 . S PT01=$P(FINDING,".",2)
 . S FILENUM=$P(ALIST(ABBR),U,1)
 . I $D(NAMECHG(FILENUM,PT01)) D
 .. S FINDING=ABBR_"."_NAMECHG(FILENUM,PT01)
 .. S FDA(811.902,IENS,.01)=FINDING
 . S IEN=+$$VFIND1(FINDING,.ALIST)
 . I IEN=0 D
 ..;Get replacement
 .. N DIC,DUOUT,TEXT,X,Y
 .. S TEXT="Finding "_FINDING_" does not exist input a replacement or ^ to quit the install."
 .. D BMES^XPDUTL(TEXT)
 .. S DIC=FILENUM
 .. S DIC(0)="AEMNQ"
 .. S Y=-1
 .. F  Q:+Y'=-1  D
 ...;If this is being called during a KIDS install we need echoing on.
 ... I $D(XPDNM) X ^%ZOSF("EON")
 ... D ^DIC
 ... I $D(XPDNM) X ^%ZOSF("EOFF")
 ... I $D(DUOUT) D
 .... S Y=""
 .... K FDA
 .. I Y="" K FDA(811.902,IENS)
 .. E  D
 ... S FINDING=ABBR_"."_$P(Y,U,2)
 ... S FDA(811.902,IENS,.01)=FINDING
 .;Save the finding information for the history.
 . S ^TMP("PXRMEXIA",$J,"DEFF",$P(IENS,",",1),OFINDING)=FINDING
 .;Save changes to Orderable items for dialog
 .I FILENUM=101.43,OFINDING'=FINDING
 . S NAMECHG(FILENUM,$P(OFINDING,".",2))=$P(FINDING,".",2)
 Q
 ;
 ;======================================================================
EXISTS(FILENUM,NAME) ;Check for existence of an entry with the same name.
 ;Return the ien if it does, 0 otherwise.
 N IEN
 I FILENUM=0 S IEN=$$EXISTS^PXRMEXCF(NAME) Q
 N FLAGS,RESULT
 S RESULT=NAME
 ;Special lookup for files 80 and 80.1, they do not have a standard "B"
 ;cross-reference.
 I (FILENUM=80)!(FILENUM=80.1) D
 .;Name may or may not have the necessary space appended, make sure
 .;it does.
 . S RESULT=$S($E(NAME,$L(NAME))'=" ":NAME_" ",1:NAME)
 . S FLAGS="MX"
 E  S FLAGS="BX"
 I FILENUM=811.6 S FLAGS=FLAGS_"U"
 ;File 8927.1 only allows upper case .01s.
 I FILENUM=8927.1 S RESULT=$$UP^XLFSTR(NAME)
 S IEN=$$FIND1^DIC(FILENUM,"",FLAGS,RESULT)
 ;If IEN is null then there was an error try FIND^DIC.
 I IEN="" D
 . N FILENAME,LIST,MSG,NENTRIES,TEXT
 . S FILENAME=$$GET1^DID(FILENUM,"","","NAME")
 . D FIND^DIC(FILENUM,"","",FLAGS,NAME,"","","","","LIST","MSG")
 . S NENTRIES=+$P(LIST("DILIST",0),U,1)
 . S TEXT="Warning there are "_NENTRIES_" "_FILENAME_" entries with the name "_NAME_"!"
 . D EN^DDIOL(TEXT)
 . D EN^DDIOL("You should stop and fix this problem now, if you continue")
 . D EN^DDIOL("you will probably get a number of errors.")
 . H 3
 .;Set the IEN to the first entry in the list.
 . S IEN=LIST("DILIST",2,1)
 Q IEN
 ;
 ;======================================================================
GETACT(CHOICES) ;Get the action
 ;If CHOICES is empty the only action is skip.
 I CHOICES="" Q "S"
 K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="S"_U
 I CHOICES["C" S DIR(0)=DIR(0)_"C:Create a new entry by copying to a new name"
 I CHOICES["D" S DIR(0)=DIR(0)_";D:Delete (from the reminder/dialog)"
 I CHOICES["I" S DIR(0)=DIR(0)_";I:Install or Overwrite the current entry"
 I CHOICES["P" S DIR(0)=DIR(0)_";P:Replace (in the reminder/dialog) with an existing entry"
 I CHOICES["Q" S DIR(0)=DIR(0)_";Q:Quit the install"
 I CHOICES["R" S DIR(0)=DIR(0)_";R:Restart"
 I CHOICES["S" S DIR(0)=DIR(0)_";S:Skip, do not install this entry"
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) S Y="S"
 Q Y
 ;
 ;======================================================================
GETNAME(MIN,MAX) ;Get a name to use.
 N X,Y
 K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="FAOU"_U_MIN_":"_MAX
 S DIR("A")="Input the new name: "
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) Q ""
 Q Y
 ;
 ;======================================================================
GETUNAME(ATTR,TA) ;Get a unique name to use.
 ;ATTR holds the attributes, TA is a temporary array holding what is
 ;in the packed reminder.
 N IEN,NEWPT01,SAME,TEXT
GNEW ;
 S NEWPT01=$$GETNAME(ATTR("MIN FIELD LENGTH"),ATTR("FIELD LENGTH"))
 S IEN=+$$EXISTS(ATTR("FILE NUMBER"),NEWPT01)
 ;If an entry with the same name exists, see if the old and new are
 ;identical.
 I IEN>0 D  G GNEW
 . S TEXT(1)=ATTR("FILE NAME")_" entry "_NEWPT01_" already EXISTS,"
 . S SAME=$$SAME(.ATTR,.TA,NEWPT01)
 . I SAME S TEXT(2)="what do you want to do?"
 . I 'SAME S TEXT(2)="but packed routine is different, what do you want to do?"
 . W !,TEXT(1),!,TEXT(2)
 E  S ATTR("NAME")=NEWPT01
 Q NEWPT01
 ;
 ;======================================================================
HF(FDA,NAMECHG) ;Check the health factor to make sure a category does not
 ;have a category.
 N IENS
 S IENS=$O(FDA(9999999.64,""))
 I IENS="" Q
 I FDA(9999999.64,IENS,.1)="CATEGORY" K FDA(9999999.64,IENS,.03)
 Q
 ;
 ;===============================================================
REXISTS(NAME,DATEP) ;See if this Exchange File entry already exists.
 N IEN,LUVALUE
 S LUVALUE(1)=NAME
 S LUVALUE(2)=DATEP
 S IEN=+$$FIND1^DIC(811.8,"","KU",.LUVALUE)
 Q IEN
 ;
 ;======================================================================
SAME(ATTR,TA,NAME) ;Check existing entry and entry in packed reminder
 ;definition to see if they are identical.
 ;Present version only works for computed finding routines, other
 ;types of entries can be added later.
 N SAME
 I ATTR("FILE NAME")="COMPUTED FINDING ROUTINE" S SAME=$$SAME^PXRMEXCF(.ATTR,.TA,NAME)
 E  S SAME=1
 Q SAME
 ;
 ;======================================================================
TERM(FDA,NAMECHG) ;Check the reminder term to make sure all the
 ;findings exist.
 N ABBR,ALIST,IEN,IENS,FILENUM,FINDING,OFINDING,PT01
 ;
 ;Search the finding multiple for replacements and missing findings.
 D BLDALIST^PXRMVPTR(811.52,.01,.ALIST)
 S IENS=""
 F  S IENS=$O(FDA(811.52,IENS)) Q:IENS=""  D
 . S (FINDING,OFINDING)=FDA(811.52,IENS,.01)
 . S ABBR=$P(FINDING,".",1)
 . S PT01=$P(FINDING,".",2)
 . S FILENUM=$P(ALIST(ABBR),U,1)
 . I $D(NAMECHG(FILENUM,PT01)) D
 .. S FINDING=ABBR_"."_NAMECHG(FILENUM,PT01)
 .. S FDA(811.52,IENS,.01)=FINDING
 . S IEN=+$$VFIND1(FINDING,.ALIST)
 . I IEN=0 D
 ..;Get replacement
 .. N DIC,DUOUT,TEXT,X,Y
 .. S TEXT="Finding "_FINDING_" does not exist input a replacement or ^ to quit the install."
 .. D BMES^XPDUTL(TEXT)
 .. S DIC=FILENUM
 .. S DIC(0)="AEMNQ"
 .. S Y=-1
 .. F  Q:+Y'=-1  D
 ...;If this is being called during a KIDS install we need echoing on.
 ... I $D(XPDNM) X ^%ZOSF("EON")
 ... D ^DIC
 ... I $D(XPDNM) X ^%ZOSF("EOFF")
 ... I $D(DUOUT) D
 .... S Y=""
 .... K FDA
 .. I Y="" K FDA(811.52,IENS)
 .. E  D
 ... S FINDING=ABBR_"."_$P(Y,U,2)
 ... S FDA(811.52,IENS,.01)=FINDING
 .;Save the finding information for the history.
 . S ^TMP("PXRMEXIA",$J,"TRMF",$P(IENS,",",1),OFINDING)=FINDING
 Q
 ;
 ;======================================================================
VFIND1(VPTR,ALIST) ;Given a variable pointer of the form ABBR.NAME
 ;and ALIST which contains the link between abbreviations and files
 ;return the IEN if it exists and 0 if no match if found.
 N ABBR,IEN,FILENUM,PT01,RESULT
 S IEN=0
 S ABBR=$P(VPTR,".",1)
 S PT01=$P(VPTR,".",2,99)
 S FILENUM=$P(ALIST(ABBR),U,1)
 S IEN=$$EXISTS(FILENUM,PT01)
 Q IEN
 ;
