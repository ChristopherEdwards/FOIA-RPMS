PXRMPTTR ;SLC/PKR - Routines for term print templates ;06/07/2001
 ;;1.5;CLINICAL REMINDERS;**2,5**;Jun 19, 2000
 ;
 ;======================================================================
GENIEN(FINDING) ;Return internal entry number for findings.
 N F0,IEN,PREFIX,ROOT,VPTR
 S ROOT="^PXRMD(811.5,D0,20,FINDING,0)"
 S F0=@ROOT
 S VPTR=$P(F0,U,1)
 S IEN=$P(VPTR,";",1)
 S ROOT=$P(VPTR,";",2)
 I '$D(PXRMFVPL) N PXRMFVPL D BLDRLIST^PXRMVPTR(811.52,.01,.PXRMFVPL)
 S VPTR=PXRMFVPL(ROOT)
 S PREFIX=$P(VPTR,U,4)
 Q " (FI("_+FINDING_")="_PREFIX_"("_IEN_"))"
 ;
 ;======================================================================
ENTRYNAM(VPTR) ;Given the variable pointer return the entry name. The
 ;variable pointer list contains the information necessary to do the
 ;look up.
 N IEN,FILENUM,NAME,ROOT
 S IEN=$P(VPTR,";",1)
 S ROOT=$P(VPTR,";",2)
 S FILENUM=$P(PXRMFVPL(ROOT),U,1)
 S NAME=$$GET1^DIQ(FILENUM,IEN,.01,"","","")
 Q NAME
 ;
 ;======================================================================
PFIND ;Print the reminder term finding multiple.
 N FIELD,FINDING,FIND0,PAD,PXRMFVPL,RJC,TEXT
 ;If called by a FileMan print build the variable pointer list.
 I '$D(PXRMFVPL) N PXRMFVPL D BLDRLIST^PXRMVPTR(811.52,.01,.PXRMFVPL)
 S PAD=" ",RJC=31
 S FINDING=0
 F  S FINDING=$O(^PXRMD(811.5,D0,20,FINDING)) Q:+FINDING=0  D
 . S FIND0=^PXRMD(811.5,D0,20,FINDING,0)
 . S FIELD=$P(FIND0,U,1)
 . S TEXT=$$RJ^XLFSTR("Finding Item:",RJC,PAD)
 . S TEXT=TEXT_"  "_$$ENTRYNAM(FIELD)
 . S TEXT=TEXT_" "_$$TRMIEN(FINDING)
 . W !!,TEXT
 .;
 . S TEXT=$$RJ^XLFSTR("Finding Type:",RJC,PAD)
 . S TEXT=TEXT_"  "_$$TFTYPE(FIELD)
 . W !,TEXT
 .;
 . S FIELD=$P(FIND0,U,4)
 . I $L(FIELD)>0 D
 .. S TEXT=$$RJ^XLFSTR("Match Frequency/Age:",RJC,PAD)
 .. S TEXT=TEXT_"  "_$$GENFREQ^PXRMPTDF(FIND0)
 .. W !,TEXT
 .;
 . D SFDISP(FIND0,8,9,"Effective Period:",RJC,PAD)
 . D SFDISP(FIND0,9,10,"Use Inactive Problems:",RJC,PAD)
 . D SFDISP(FIND0,10,11,"Within Category Rank:",RJC,PAD)
 . D SFDISP(FIND0,11,12,"Effective Date:",RJC,PAD)
 . D SFDISP(FIND0,12,13,"MH Scale:",RJC,PAD)
 . D SFDISP(FIND0,13,16,"Rx Type:",RJC,PAD)
 .;
 . S FIND0=$G(^PXRMD(811.5,D0,20,FINDING,3))
 . D SFDISP(FIND0,1,14,"Condition:",RJC,PAD)
 . D SFDISP(FIND0,2,15,"Condition Case Sensitive:",RJC,PAD)
 Q
 ;
 ;======================================================================
SFDISP(FIND0,PIECE,FLDNUM,TITLE,RJC,PAD) ;Standard finding multiple
 ;field display.
 N FIELD,TEXT
 S FIELD=$P(FIND0,U,PIECE)
 I $L(FIELD)>0 D
 . S TEXT=$$RJ^XLFSTR(TITLE,RJC,PAD)
 . S TEXT=TEXT_"  "_$$EXTERNAL^DILFD(811.52,FLDNUM,"",FIELD,"")
 . W !,TEXT
 Q
 ;
 ;====================================================================
TFTYPE(VPTR) ;Return Term finding type
 N ROOT,TFTYPE
 S ROOT=$P(VPTR,";",2)
 I '$D(PXRMFVPL) N PXRMFVPL D BLDRLIST^PXRMVPTR(811.52,.01,.PXRMFVPL)
 S TFTYPE=$P(PXRMFVPL(ROOT),U,2)
 Q TFTYPE
 ;
 ;======================================================================
TRMIEN(FINDING) ;Return internal entry number for TERM findings.
 N F0,IEN,PREFIX,ROOT,VPTR
 S ROOT="^PXRMD(811.5,D0,20,FINDING,0)"
 S F0=@ROOT
 S VPTR=$P(F0,U,1)
 S IEN=$P(VPTR,";",1)
 S ROOT=$P(VPTR,";",2)
 I '$D(PXRMFVPL) N PXRMFVPL D BLDRLIST^PXRMVPTR(811.52,.01,.PXRMFVPL)
 S VPTR=PXRMFVPL(ROOT)
 S PREFIX=$P(VPTR,U,4)
 Q " (FI("_+FINDING_")="_PREFIX_"("_IEN_"))"
 ;
