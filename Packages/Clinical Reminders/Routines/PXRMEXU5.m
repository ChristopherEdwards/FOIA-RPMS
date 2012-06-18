PXRMEXU5 ; SLC/PKR - Reminder exchange KIDS utilities, #5. ;02/12/2002
 ;;1.5;CLINICAL REMINDERS;**7,8**;Jun 19, 2000
 ;======================================================================
MERGE(FILENUM,IEN,FIELD,FDA,IENROOT,MODE) ;Merge or replace portions of
 ;an FDA.
 ;FILENUM - the file number
 ;IEN - internal entry number
 ;FIELD - semicolon separated list of fields.
 ;This are arguments for GETS^DIQ, see that documentation for 
 ;more information.
 ;FDA and IENROOT are the FDA and IENROOT for UPDATE^DIE. These
 ;are already setup with the contents of the packed reminder before
 ;this routine is called.
 ;The default is to merge any existing nodes of the FDA with the nodes
 ;already existing at the site. If MODE="R" then the existing nodes
 ;will be replaced with the nodes already in the FDA.
 N DIQOUT,IENS,IND,IND1,IND2,IND3,MSG,SIEN,SPEC,TIENROOT
 S IENS=IEN_","
 D GETS^DIQ(FILENUM,IENS,FIELD,"","DIQOUT","MSG")
 I $D(MSG) D  Q
 . N ETEXT,FILENAME
 . S FILENAME=$$GET1^DID(FILENUM,"","","NAME")
 . S ETEXT="GETS^DIQ failed for "_FILENAME_" entry "_IEN_", it returned the following error message:"
 . W !,ETEXT
 . D AWRITE^PXRMUTIL("MSG")
 . H 2
 . K MSG
 ;Make sure that the FDA ien is compatible with the site ien.
 S IND1=$O(FDA(""),-1)
 ;Set the starting ien to be the last one in the FDA.
 S SIEN=+$O(FDA(IND1,""),-1)
 ;Convert the iens to the FDA adding form.
 D CONTOFDA^PXRMEXPU(.DIQOUT,.TIENROOT,IEN,SIEN)
 ;Remove any duplicates and make the indexes compatible.
 D RMDUP(IEN,.DIQOUT,.FDA)
 S IND1=""
 F  S IND1=$O(DIQOUT(IND1)) Q:IND1=""  D
 .;Get the start for IENROOT.
 . S SPEC=$$GET1^DID(IND1,".01","","SPECIFIER")
 . I SPEC["M",MODE="R" K FDA(IND1)
 . S IND2=$O(FDA(IND1,""))
 . S SIEN=+IND2
 . S IND2=""
 . F  S IND2=$O(DIQOUT(IND1,IND2)) Q:IND2=""  D
 .. S IND3=+IND2
 ..;Add the offset, if there is one, to get the correct IENROOT.
 .. I $D(TIENROOT(IND3)) S IENROOT(IND3)=TIENROOT(IND3)+SIEN
 .. S IND3=""
 .. F  S IND3=$O(DIQOUT(IND1,IND2,IND3)) Q:IND3=""  D
 ... S FDA(IND1,IND2,IND3)=DIQOUT(IND1,IND2,IND3)
 Q
 ;
 ;======================================================================
NONULL(PXRMRIEN) ;Set any lines with a length of 0 equal to a space
 ;so KIDS will not delete them.
 N IND
 S IND=0
 F  S IND=+$O(^PXD(811.8,PXRMRIEN,100,IND)) Q:IND=0  D
 . I $L(^PXD(811.8,PXRMRIEN,100,IND,0))=0 S ^PXD(811.8,PXRMRIEN,100,IND,0)=" "
 Q
 ;
 ;======================================================================
POSTKIDS(PXRMRIEN) ;Change all ACK characters in node 100 of Exchange
 ;File entry PXRMRIEN back to "^".
 N ACK,UPA
 S ACK=$C(6)
 S UPA="^"
 D REPCHAR(PXRMRIEN,ACK,UPA)
 Q
 ;
 ;======================================================================
PREKIDS(PXRMRIEN) ;Change all "^" characters in node 100 of Exchange
 ;File entry PXRMRIEN so that KIDS does not truncate lines when it
 ;installs the file.
 N ACK,UPA
 S ACK=$C(6)
 S UPA="^"
 D REPCHAR(PXRMRIEN,UPA,ACK)
 D NONULL(PXRMRIEN)
 Q
 ;
 ;======================================================================
REPCHAR(PXRMRIEN,CHAR1,CHAR2) ;Replace CHAR1 with CHAR2 for all lines in node
 ;100 of entry PXRMRIEN of the Exchange File.
 N IND,LINE
 S IND=0
 F  S IND=+$O(^PXD(811.8,PXRMRIEN,100,IND)) Q:IND=0  D
 . S LINE=$TR(^PXD(811.8,PXRMRIEN,100,IND,0),CHAR1,CHAR2)
 . S ^PXD(811.8,PXRMRIEN,100,IND,0)=LINE
 Q
 ;
 ;======================================================================
RMDUP(IEN,DIQOUT,FDA) ;Remove any entries that are in both DIQOUT and FDA
 ;from FDA so the site version is presevered.
 N DIQOUTS,DLIST,FLIST,IND1,IND2,IND2S,IND3,IENS,OIENS
 S IENS="+"_IEN_","
 S IND1=$O(FDA("")),OIENS=$O(FDA(IND1,""))
 S IND1=""
 F  S IND1=$O(DIQOUT(IND1)) Q:IND1=""  D
 . S IND2=""
 . F  S IND2=$O(DIQOUT(IND1,IND2)) Q:IND2=""  D
 .. S IND2S=$$STRREP^PXRMUTIL(IND2,IENS,OIENS)
 .. S IND3=""
 .. F  S IND3=$O(DIQOUT(IND1,IND2,IND3)) Q:IND3=""  D
 ... S DIQOUTS(IND1,IND2S,IND3)=DIQOUT(IND1,IND2,IND3)
 ... I IND3=.01 S DLIST(DIQOUT(IND1,IND2,IND3))=IND1_U_IND2_U_IND3 Q
 ;
 S IND1=""
 F  S IND1=$O(FDA(IND1)) Q:IND1=""  D
 . S IND2=""
 . F  S IND2=$O(FDA(IND1,IND2)) Q:IND2=""  D
 .. S IND3=""
 .. F  S IND3=$O(FDA(IND1,IND2,IND3)) Q:IND3=""  D
 ... I IND3=.01 S FLIST(FDA(IND1,IND2,IND3))=IND1_U_IND2_U_IND3 Q
 ;
 S IND3=""
 F  S IND3=$O(DLIST(IND3)) Q:IND3=""  D
 . I $D(FLIST(IND3)) D
 .. S IND1=$P(FLIST(IND3),U,1)
 .. S IND2=$P(FLIST(IND3),U,2)
 .. K FDA(IND1,IND2)
 K DIQOUT
 M DIQOUT=DIQOUTS
 Q
 ;
