BTPW1PSU ;VNGT/HS/BEE-Post Installation Overflow for CMET ; 24 Apr 2008  7:46 PM
 ;;1.0;CARE MANAGEMENT EVENT TRACKING;;Feb 07, 2011
 ;
 Q
 ;
TPS ;EP - Set tooltips
 N BI,TEXT
 F BI=1:1 S TEXT=$P($T(TIP+BI),";;",2) Q:TEXT=""  D
 . N CODE,IEN,BJ,TXT,HELP,ERROR
 . S CODE=$P(TEXT,"~",1)
 . S IEN=$O(^BQI(90506.1,"B",CODE,"")) I IEN="" Q
 . F BJ=1:1 S TXT=$P($T(@CODE+BJ),";;",2) Q:TXT=""  D
 .. S HELP(BJ)=TXT
 . D WP^DIE(90506.1,IEN_",",4,"","HELP","ERROR")
 K BI,TEXT
 ;
 Q
 ;
TIP ;  Tooltips
 ;;BTPWNCAT
 ;;BTPWNEDT
 ;;BTPWNENM
 ;;BTPWNPEV
 ;;BTPWQCAT
 ;;BTPWQEDT
 ;;BTPWQENM
 ;;BTPWQRES
 ;;BTPWQSTS
 ;;BTPWTCAT
 ;;BTPWTEDT
 ;;BTPWTENM
 ;;BTPWTFDA
 ;;BTPWTFND
 ;;BTPWTFUA
 ;;BTPWTFUP
 ;;BTPWTNOA
 ;;BTPWTNOT
 ;;BTPWTSTA
 Q
 ;
BTPWNCAT ;
 ;;Events are categorized into Breast; Cervical; Colon; and Skeletal.
 Q
 ;
BTPWNEDT ;
 ;;The date by which the recommended Follow-up is to occur.
 Q
 ;
BTPWNENM ;
 ;;This is the recommended Follow-up entered in CMET.
 Q
 ;
BTPWNPEV ;
 ;;The event date of the preceding event.
 Q
 ;
BTPWQCAT ;
 ;;Events are categorized into Breast; Cervical; Colon; and Skeletal.
 Q
 ;
BTPWQEDT ;
 ;;The date the event was performed.  Access the visit by clicking on the
 ;;link.
 Q
 ;
BTPWQENM ;
 ;;Events are procedures, exams or tests that have been documented in RPMS.
 ;;Events are predefined. See the CMET Glossary for a list of events.
 Q
 ;
BTPWQRES ;
 ;;Access available results by clicking on the link.
 Q
 ;
BTPWQSTS ;
 ;;Statuses include Pending, Tracked, or Not Tracked.
 Q
 ;
BTPWTCAT ;
 ;;Events are categorized into Breast; Cervical; Colon; and Skeletal.
 Q
 ;
BTPWTEDT ;
 ;;The date the event was performed.  Access the visit by clicking on the
 ;;link.
 Q
 ;
BTPWTENM ;
 ;;Events are procedures, exams or tests that have been documented in RPMS.
 ;;Events are predefined. See the CMET Glossary for a list of events.
 Q
 ;
BTPWTFDA ;
 ;;The finding information associated with this event: Finding; Finding Interpretation; Finding Date; Finding Comments;
 ;;Last Modified By; Last Modified Date
 Q
 ;
BTPWTFND ;
 ;;The Feather icon  indicates entry of the Finding is past due based on
 ;;Tickler Timeframes.  The Checkmark icon indicates the Finding has been
 ;;entered.  An empty cell indicates that a finding has not been entered and
 ;;is not past due.
 Q
 ;
BTPWTFUA ;
 ;;The follow-up information associated with this event: Follow-up; Follow-up Entered By; Follow-up Entered Date;
 ;;Follow-up Due By; Next Follow-up
 Q
 ;
BTPWTFUP ;
 ;;The Feather icon indicates entry of the recommended Follow-up is past due
 ;;based on Tickler Timeframes.  The Checkmark icon indicates the Follow-up
 ;;has been entered.  An empty cell indicates that a decision regarding the
 ;;Follow-up has not been entered and is not past due.
 Q
 ;
BTPWTNOA ;
 ;;The notification information associated with this event: Notification Date; Notification Type; Notification Entered Date;
 ;;Notification Entered By; Notification Document; Notification Notes
 Q
 ;
BTPWTNOT ;
 ;;The Feather icon indicates entry of the type of Patient Notification is
 ;;past due based on Tickler Timeframes.  The Checkmark icon indicates the
 ;;type of Patient Notification has been entered.  An empty cell indicates
 ;;that the type of Patient Notification has not been entered but is not
 ;;past due.
 Q
 ;
BTPWTSTA ;
 ;;The state of a CMET is either Open or Closed.
 Q
