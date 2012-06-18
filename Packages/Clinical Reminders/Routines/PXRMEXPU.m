PXRMEXPU ; SLC/PKR - Utilities for packing and unpacking repository entries. ;24-Mar-2006 13:12;MGH
 ;;1.5;CLINICAL REMINDERS;**5,7,1002,1004**;Jun 19, 2000
 ;IHS/CIA/MGH Added line to only send .01 field on patient educaiton
 ;======================================================================
ASSAF(LIENS,LASTI) ;Assemble the stored pieces of the IENS.
 N IENSA,IND
 S IENSA=""
 F IND=LIENS:-1:1 D
 . S IENSA=IENSA_LASTI(IND)
 Q IENSA
 ;
 ;======================================================================
CONTOFDA(DIQOUT,IENROOT,IEN,SIEN) ;Convert the iens from the form
 ;returned by GETS^DIQ to the FDA laygo form used by UPDATE^DIE.
 ;DIQOUT contains the GETS^DIQ output. If any of the fields are
 ;variable pointers change them to the resolved form.
 N ABBR,IENS,IENSA,INTERNAL,FIELD,FILENUM
 N LASTI,LIENS,LINE,PTRTO,ROOT,TEMP,TYPE,VLIST,VPTRLIST,WPLCNT
 S LASTI(1)="+"_IEN_","
 S LASTI(2)=+$G(SIEN)
 S FILENUM=""
 F  S FILENUM=$O(DIQOUT(FILENUM)) Q:FILENUM=""  D
 . K TYPE,VPTRLIST
 . S IENS=""
 . F  S IENS=$O(DIQOUT(FILENUM,IENS)) Q:IENS=""  D
 .. S LIENS=$L(IENS,",")-1
 .. D SETLASTI(LIENS,.LASTI)
 ..;Assemble the adding form of the IENS.
 .. S IENSA=$$ASSAF(LIENS,.LASTI)
 ..;Save IENROOT for UPDATE^DIE so all nodes will be installed at
 ..;their original locations.
 .. I LIENS>1 S IENROOT(+LASTI(LIENS))=$P(IENS,",",1)
 .. S FIELD=""
 .. F  S FIELD=$O(DIQOUT(FILENUM,IENS,FIELD)) Q:FIELD=""  D
 ...;If there is no data then don't keep this entry.
 ... I DIQOUT(FILENUM,IENS,FIELD)="" K DIQOUT(FILENUM,IENS,FIELD) Q
 ...;Get the field type, if it is a variable-pointer then set up
 ...;the resolved form.
 ... I '$D(TYPE(FILENUM,FIELD)) S TYPE(FILENUM,FIELD)=$$GET1^DID(FILENUM,FIELD,"","TYPE")
 ... I TYPE(FILENUM,FIELD)="POINTER" S PTRTO=$$GET1^DID(FILENUM,FIELD,"","POINTER")
 ... E  S PTRTO=""
 ...;If the field's type is COMPUTED then don't transport it.
 ... I TYPE(FILENUM,FIELD)="COMPUTED" K DIQOUT(FILENUM,IENS,FIELD) Q
 ... I TYPE(FILENUM,FIELD)="VARIABLE-POINTER" D
 .... I '$D(VPTRLIST(FILENUM,FIELD)) D
 ..... K VLIST
 ..... D BLDRLIST^PXRMVPTR(FILENUM,FIELD,.VLIST)
 ..... M VPTRLIST(FILENUM,FIELD)=VLIST
 .... S INTERNAL=$$GET1^DIQ(FILENUM,IENS,FIELD,"I")
 .... S (PTRTO,ROOT)=$P(INTERNAL,";",2)
 .... S ABBR=$P(VPTRLIST(FILENUM,FIELD,ROOT),U,4)
 .... S DIQOUT(FILENUM,IENS,FIELD)=ABBR_"."_DIQOUT(FILENUM,IENS,FIELD)
 ... I TYPE(FILENUM,FIELD)="WORD-PROCESSING" D
 .... S (LINE,WPLCNT)=0
 .... F  S LINE=$O(DIQOUT(FILENUM,IENS,FIELD,LINE)) Q:LINE=""  D
 ..... S WPLCNT=WPLCNT+1
 ..... S DIQOUT(FILENUM,IENSA,FIELD,LINE)=DIQOUT(FILENUM,IENS,FIELD,LINE)
 .... I WPLCNT>0 S DIQOUT(FILENUM,IENS,FIELD)="WP-start~"_WPLCNT
 .... E  K DIQOUT(FILENUM,IENS,FIELD)
 ...;Done processing, save the adding form.
 ... S TEMP=DIQOUT(FILENUM,IENS,FIELD)
 ...;For fields that point to files 80 and 80.1 we have to append a space
 ...;so FileMan can resolve the pointers when installing a component.
 ... I PTRTO["ICD" S TEMP=TEMP_" "
 ... S DIQOUT(FILENUM,IENSA,FIELD)=TEMP
 ... K DIQOUT(FILENUM,IENS,FIELD)
 Q
 ;
 ;======================================================================
GDIQF(LIST,NUM,TMPIND,SERROR) ;Save file entries into ^TMP(TMPIND,$J).
 N DIQOUT,IENROOT,IND,FIELD,FILENAME,IENS,MSG,PT01,TEMP
 S ^TMP(TMPIND,$J,"NUMF")=NUM
 F IND=1:1:NUM D
 . S TEMP=LIST(IND)
 . S FILENAME=$P(TEMP,U,1)
 . S FILENUM=$P(TEMP,U,2)
 . S IEN=$P(TEMP,U,3)
 . K DIQOUT,IENROOT
 .;If the file entry is ok to install then get the entire entry,
 .;otherwise just get the .01.
 . I $$FOKTI^PXRMEXFI(FILENUM) S FIELD="**"
 . E  S FIELD=.01
 .;For PCE education topics VA- entries cannot be transported.
 .;IHS/CIA/MGH Since education topics are national, setup only sending .01 field
 . I FILENUM=9999999.09 D
 .. S PT01=$$GET1^DIQ(FILENUM,IEN,.01)
 .. S FIELD=.01
 .. ;B  I PT01["VA-" S FIELD=.01
 .. ;End modification
 . D GETS^DIQ(FILENUM,IEN,FIELD,"","DIQOUT","MSG")
 . I $D(MSG) D  Q
 .. S SERROR=1,IND=NUM
 .. N ETEXT
 .. S ETEXT="GETS^DIQ failed for "_FILENAME_", it returned the following error message:"
 .. W !,ETEXT
 .. D AWRITE^PXRMUTIL("MSG")
 .. H 2
 .. K MSG
 .;Remove edit history from all reminder files.
 . D RMEH(FILENUM,.DIQOUT)
 .;Convert the iens to the FDA adding form.
 . D CONTOFDA(.DIQOUT,.IENROOT,IEN)
 .;Load the converted DIQOUT into TMP.
 . M ^TMP(TMPIND,$J,IND,FILENAME)=DIQOUT
 . M ^TMP(TMPIND,$J,IND,FILENAME_"_IENROOT")=IENROOT
 Q
 ;
 ;======================================================================
GETREM(ACTION) ;Get the reminder to save.
 N DIC,Y
 S DIC="^PXD(811.9,"
 S DIC(0)="AEMQ"
 S DIC("A")="Select Reminder Definition to "_ACTION_": "
 D ^DIC
 G:Y=-1 END
END ;
 Q Y
 ;
 ;======================================================================
GRTN(LIST,NUM,TMPIND,SERROR) ;Save routines into ^TMP(TMPIND,$J).
 N DIF,IEN,IND,TEMP,X,XCNP
 S ^TMP(TMPIND,$J,"NUMR")=NUM
 S X=""
 F IND=1:1:NUM D
 .;Make sure the routine exists.
 . S X=LIST(IND)
 . X ^%ZOSF("TEST")
 . I $T D
 .. S DIF="^TMP(TMPIND,$J,""ROUTINE"","""_X_""","
 .. S XCNP=0
 .. X ^%ZOSF("LOAD")
 . E  D
 .. S SERROR=1
 .. W !,"Warning could not find routine ",X
 .. H 2
 Q
 ;
 ;======================================================================
RMEH(FILENUM,DIQOUT) ;Clear the edit history from all reminder files.
 ;Leave a stub so it can be filled in when the file is installed.
 I (FILENUM<800)!(FILENUM>811.9) Q
 N IEN,SFN,TARGET
 ;Edit History is stored in node 110 for all files, get the
 ;subfile number.
 D FIELD^DID(FILENUM,110,"","SPECIFIER","TARGET")
 S SFN=+$G(TARGET("SPECIFIER"))
 I SFN=0 Q
 ;Clean out the history.
 S IENS=""
 F  S IENS=$O(DIQOUT(SFN,IENS)) Q:IENS=""  K DIQOUT(SFN,IENS)
 ;Create a stub for the install.
 S IENS="1,"_$O(DIQOUT(FILENUM,""))
 S DIQOUT(SFN,IENS,.01)=$$FMTE^XLFDT($$NOW^XLFDT,"5Z")
 S DIQOUT(SFN,IENS,1)=$$GET1^DIQ(200,DUZ,.01)
 S DIQOUT(SFN,IENS,2)="DIQOUT("_SFN_","_IENS_"2)"
 S DIQOUT(SFN,IENS,2,1)="Exchange Stub"
 Q
 ;
 ;======================================================================
SETLASTI(LIENS,LASTI) ;Assemble the pieces of the IENS for the
 ;FDA in the adding form. Note in this scheme we go from right to left.
 ;The first index is fixed don't do anything with it.
 I LIENS=1 Q
 ;The second index is just incremented.
 I LIENS=2 D  Q
 . N T2
 . S T2=+LASTI(LIENS)+1
 . I T2=+LASTI(1) S T2=T2+1
 . S LASTI(LIENS)="+"_T2_","
 ;For the third and higher index make sure it is one higher than the
 ;previous index.
 I $G(LASTI(LIENS))<LASTI(LIENS-1) S LASTI(LIENS)="+"_(LASTI(LIENS-1)+1)_","
 E  S LASTI(LIENS)="+"_(LASTI(LIENS)+1)_","
 Q
 ;
 ;======================================================================
UPDATE(SUCCESS,FDA,FDAIEN) ;Call to add new entries to the repository.
 N MSG
 ;Try to eliminate gaps in the repository.
 S $P(^PXD(811.8,0),U,3)=0
 D UPDATE^DIE("E","FDA","FDAIEN","MSG")
 I $D(MSG) D
 . N DATE,RNAME
 . S SUCCESS=0
 . W !,"The update failed, UPDATE^DIE returned the following error message:"
 . D AWRITE^PXRMUTIL("MSG")
 . S RNAME=FDA(811.8,"+1,",.01)
 . S DATE=FDA(811.8,"+1,",.03)
 . W !!,"Exchange File entry ",RNAME," date packed ",DATE," did not get stored!"
 . W !,"Examine the above error message for the reason.",!
 . H 2
 E  S SUCCESS=1
 Q
 ;
