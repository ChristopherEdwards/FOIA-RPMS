BMCRPC5 ; IHS/CAS/AU - GUI REFERRED CARE INFO SYSTEM (4/4);     
 ;;4.0;REFERRED CARE INFO SYSTEM;**7,8**;JUL 11, 2016;Build 51
 ;
 ; RPC code for RCIS GUI Application
 ; Routines contains code for saving Business office and Medical History/Finding in RCIS Referral table.
SETWP(FN,WPFN,IEN,NOTES,ISAPPEND,ISDELETE) ;Set WordProcessing Data based on file, field and IEN information!
 S FileNumber=$G(FN),WpFieldNumber=$G(WPFN),RowId=$G(IEN),Notes=$G(NOTES),IsAppend=$G(ISAPPEND),IsDelete=$G(ISDELETE)
 I +$G(RowId)<1,+$G(FileNumber)<1,+$G(WpFieldNumber)<1,$L($G(Notes))<1 Q "0^Required Data missing"
 I $G(Notes)["2@%Library.GlobalBinaryStream" Q "-2^GlobalBinaryStream error"
 N err,wproot,wp,i,OrigCharCount,RunningCharCount
 S OrigCharCount=$L($G(Notes))
 I IsDelete S wproot="@"
 I 'IsDelete  D
 . S Notes=$LISTFROMSTRING(Notes,$c(13))
 . S wproot="wp",i=0,RunningCharCount=0
 . F i=1:1:$ll(Notes) S wp(i)=$lg(Notes,i)
 I IsAppend D WP^DIE(FileNumber,RowId_",",WpFieldNumber,"AK",wproot,"err")
 I 'IsAppend D WP^DIE(FileNumber,RowId_",",WpFieldNumber,"K",wproot,"err")
 I $D(err) Q "-1^"_$G(err("DIERR",1,"TEXT",1))
 K err,wproot,wp,i,OrigCharCount,RunningCharCount,Notes,RowId,FileNumber,WpFieldNumber
 Q "1"
 ;
