PXRMLIST ; SLC/PKR - Clinical Reminders list functions. ;06/05/2001
 ;;1.5;CLINICAL REMINDERS;**5**;Jun 19, 2000
 ;Used in the reminder exchange utility.
 ;======================================================================
FRDEF(NAME,PNAME) ;Format the reminder name and print name.
 N IND,LEN,TEMP
 S TEMP=$$LJ^XLFSTR(NAME,40," ")
 S TEMP=TEMP_PNAME
 Q TEMP
 ;
 ;======================================================================
FRE(NUMBER,NAME,SOURCE,DATE) ;Format  entry number, name, source,
 ;and date packed.
 N TEMP,TNAME,TSOURCE
 S TEMP=$$RJ^XLFSTR(NUMBER,4," ")
 S TNAME=$E(NAME,1,27)
 S TEMP=TEMP_"  "_$$LJ^XLFSTR(TNAME,29," ")
 S TSOURCE=$E($P(SOURCE,",",1),1,12)_"@"_$E($P(SOURCE," at ",2),1,12)
 S TEMP=TEMP_$$LJ^XLFSTR(TSOURCE,23," ")
 S DATE=$$FMTE^XLFDT(DATE,"5Z")
 S TEMP=TEMP_"  "_$$LJ^XLFSTR(DATE,30," ")
 Q TEMP
 ;
 ;======================================================================
MRKINACT(TEXT) ;Append the inactive mark to TEXT in column 77.
 N IC,NSPA
 S NSPA=77-$L(TEXT)
 F IC=1:1:NSPA S TEXT=TEXT_" "
 S TEXT=TEXT_"X"
 Q TEXT
 ;
 ;======================================================================
QUERYAO() ;See if the user wants only active reminders listed.
 N X,Y
 K DIRUT,DTOUT,DUOUT
 S DIR(0)="YA"
 S DIR("A")="List active reminders only? "
 S DIR("B")="Y"
 W !
 D ^DIR K DIR
 Q Y
 ;
 ;======================================================================
RDEF(DEFLIST,ARO) ;Build a list of the name and print name of all
 ;reminder definitions.
 N INACTIVE,IEN,NAME,PNAME,REMINDER
 S INACTIVE=""
 ;Build the list of reminders in alphabetical order.
 S VALMCNT=0
 S NAME=""
 F  S NAME=$O(^PXD(811.9,"B",NAME)) Q:NAME=""  D
 . S IEN=$O(^PXD(811.9,"B",NAME,""))
 . S REMINDER=^PXD(811.9,IEN,0)
 . S INACTIVE=$P(REMINDER,U,6)
 . I (ARO)&(INACTIVE) Q
 . S VALMCNT=VALMCNT+1
 . S PNAME=$P(REMINDER,U,3)
 . S DEFLIST(VALMCNT,0)=$$FRDEF(NAME,PNAME)
 . I INACTIVE D
 .. S DEFLIST(VALMCNT,0)=$$MRKINACT(DEFLIST(VALMCNT,0))
 S DEFLIST("VALMCNT")=VALMCNT
 Q
 ;
 ;======================================================================
RE(RLIST,IEN) ;Build a list of repository entries.
 N DATE,IND,NAME,SOURCE
 ;Build the list in alphabetical order.
 S VALMCNT=0
 S NAME=""
 F  S NAME=$O(^PXD(811.8,"B",NAME)) Q:NAME=""  D
 . S DATE=""
 . F  S DATE=$O(^PXD(811.8,"B",NAME,DATE)) Q:DATE=""  D
 .. S IND=$O(^PXD(811.8,"B",NAME,DATE,""))
 .. S SOURCE=$P(^PXD(811.8,IND,0),U,2)
 .. S VALMCNT=VALMCNT+1
 .. S RLIST(VALMCNT,0)=$$FRE(VALMCNT,NAME,SOURCE,DATE)
 .. S IEN(VALMCNT)=IND
 S RLIST("VALMCNT")=VALMCNT
 Q
 ;
 ;======================================================================
SPONSOR ;Print a list of Sponsors.
 N BY,DIC,FLDS,FR,L,PXRMEDOK
 S PXRMEDOK=1
 S BY=".01"
 S DIC="^PXRMD(811.6,"
 S FLDS="[PXRM SPONSOR LIST]"
 S FR=""
 S L=0
 D EN1^DIP
 Q
 ;
