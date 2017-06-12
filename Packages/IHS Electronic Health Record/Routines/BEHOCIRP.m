BEHOCIRP ;MSC/IND/MGH - CCD calls ;13-Sep-2013 13:41;MGH
 ;;1.1;BEH COMPONENTS;**066001**;March 12, 2008;Build 6
 ;=================================================================
POST ;Add type to imaging file
 N FDA,FNUM,IEN,IEN2,ERR,IENS
 S FNUM=2005.86
 ;Don't store again
 S IEN="" S IEN=$O(^MAG(2005.86,"B","CCD STORED",IEN))
 Q:+IEN
 S IENS="+1,"
 S FDA=$NA(FDA(FNUM,IENS))
 S @FDA@(.01)="CCD STORED"
 S @FDA@(1)="YES"
 S @FDA@(2)="LOAD"
 S @FDA@(3)="BEHOCIR1"
 S @FDA@(4)="Load data into the reconciliation file after CCDA is loaded"
 D UPDATE^DIE("E","FDA","IEN2","ERR")
 I $G(ERR("DIERR",1)) S RET=-ERR("DIERR",1)_U_ERR("DIERR",1,"TEXT",1) Q
 S IEN=IEN2(1)
 K FDA,IEN2,ERR,IENS
 S IENS="+1,"_IEN_","
 S FNUM=2005.865
 S FDA=$NA(FDA(FNUM,IENS))
 S @FDA@(.01)="CCD-SUMMARY"
 D UPDATE^DIE("E","FDA","IEN2","ERR")
 I $G(ERR("DIERR",1)) S RET=-ERR("DIERR",1)_U_ERR("DIERR",1,"TEXT",1)
 Q
