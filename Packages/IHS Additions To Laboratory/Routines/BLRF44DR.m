BLRF44DR ; IHS/MSC/MKK - Hospital Locations (# 44) File Duplicate Abbreviation(s) Report ;   [ February 29, 2012 8:00 AM ]
 ;;5.2;IHS LABORATORY;**1031**;NOV 01, 1997
 ;
EEP ; EP - Ersatz Entry Point
 D EEP^BLRGMENU
 Q
 ;
PEP ; EP 
EP ; EP 
 NEW ABBREV,BLRVERN,CNT,CURUCI,IEN,IEN2
 NEW HD1,HEADER,LINES,MAXLINES,PG,QFLG
 ;
 Q:$$INITVARS()="Q"
 D REPORT
 ;
 Q
 ;
INITVARS() ; EP
 S BLRVERN=$$TRIM^XLFSTR($P($T(+1),";"),"R"," ")
 ;
 S HEADER(1)="Hospital Location (# 44) File"
 S HEADER(2)="Duplicate Abbreviation Report"
 S HEADER(3)=" "
 ;
 D HEADERDT^BLRGMENU
 D ^%ZIS
 I POP D  Q "Q"
 . W !,?4,"Device Not Available. Routine Ends.",!!
 . D PRESSKEY^BLRGMENU(9)
 U IO
 ;
 I IOST["C-VT" D HEADONE2^BLRLUAC2(.HD1)  W !
 ;
 S MAXLINES=IOSL-4
 S LINES=MAXLINES+10
 S HEADER(4)=$TR($$CJ^XLFSTR("@HOSPITAL@LOCATION@",51)," @","= ")
 S $E(HEADER(4),55)=$TR($$CJ^XLFSTR("@INSTITUTION@",26)," @","= ")
 S HEADER(5)="IEN"
 S $E(HEADER(5),10)="Description"
 S $E(HEADER(5),45)="Abbrev"
 S $E(HEADER(5),55)="IEN"
 S $E(HEADER(5),65)="Description"
 ;
 S (CNT,PG)=0,QFLG="NO"
 ;
 Q "OK"
 ;
REPORT ; EP
 S ABBREV=""
 F  S ABBREV=$O(^SC("C",ABBREV))  Q:ABBREV=""!(QFLG="Q")  D
 . S IEN=0
 . S IEN=+$O(^SC("C",ABBREV,IEN))
 . S IEN2=+$O(^SC("C",ABBREV,IEN))
 . Q:IEN2<1
 . ;
 . D DUPLINE    ; There are duplicates
 ;
 W:QFLG'="Q" !!,?4,"Number of Distinct Duplicate Abbreviations = ",CNT,!
 ;
 D ^%ZISC
 ;
 D:QFLG'="Q"&(IOST["VT") PRESSKEY^BLRGMENU(4)
 ;
 Q
 ;
DUPLINE ; EP
 S:CNT<1 CNT=CNT+1
 S:$L($TR(ABBREV," ")) CNT=CNT+1
 S IEN=0
 F  S IEN=$O(^SC("C",ABBREV,IEN))  Q:IEN<1!(QFLG="Q")  D
 . I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,HD1)  Q:QFLG="Q"
 . W IEN
 . W ?9,$E($P($G(^SC(IEN,0)),"^"),1,38)
 . W ?44,$S($L($TR(ABBREV," "))>0:ABBREV,1:"<BLANK>")
 . W ?54,$P($G(^SC(IEN,0)),"^",4)
 . W ?64,$E($P($G(^DIC(4,+$P($G(^SC(IEN,0)),"^",4),0)),"^"),1,16)
 . W !
 . S LINES=LINES+1
 Q
 ;
HEADONE(HD1) ; EP -- Asks if user wants only 1 header line
 D ^XBFMK
 S DIR("A")="One Header Line ONLY"
 S DIR("B")="NO"
 S DIR(0)="YO"
 D ^DIR
 S HD1=$S(+$G(Y)=1:"YES",1:"NO")
 Q
 ;
TASKREPT ; EP - Task the report
 NEW BLRDUZ,IOP,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK
 ;
 S ZTRTN="TASKIT^BLRF44DR"
 S ZTDESC="BLRF44DR Tasked Compilation"
 ;
 M BLRDUZ=DUZ
 S ZTSAVE("*")=""
 S ZTDTH=$H
 S ZTIO=""
 S IOP="Q"
 D ^%ZTLOAD
 W !,?4,"Job ",ZTSK," Queued",!
 D PRESSKEY^BLRGMENU(9)
 Q
 ;
TASKIT ; EP - Tasked Report
 NEW ABBREV,BLRVERN,CNT,IEN,IEN2,LINE,MMSGSTR
 ;
 I $D(ZTQUEUED) S ZTREQ="@"
 ;
 D TASKITIN
 ;
 S ABBREV=""
 F  S ABBREV=$O(^SC("C",ABBREV))  Q:ABBREV=""  D
 . S IEN=0
 . S IEN=+$O(^SC("C",ABBREV,IEN))
 . S IEN2=+$O(^SC("C",ABBREV,IEN))
 . Q:IEN2<1
 . ;
 . D TASKLINE
 ;
 D:CNT>0 TROUBLE
 ;
 Q
 ;
TASKITIN ; EP - Tasked Initialization of variables
 K MMSGSTR
 ;
 S MMSGSTR(1)="Duplicate Abbreviations Exist in HOSPITAL LOCATION (# 44) File."
 S MMSGSTR(2)=" "
 S MMSGSTR(3)="    The potential for erroneous Hospital Location statistics is high."
 S MMSGSTR(4)="    Report follows:"
 S MMSGSTR(5)=" "
 ;
 ; Header of Report
 S MMSGSTR(6)=$$TRIM^XLFSTR($$CJ^XLFSTR($$LOC^XBFUNC,80),"R"," ")
 S MMSGSTR(7)=$$TRIM^XLFSTR($$CJ^XLFSTR("Hospital Location (# 44) File",80),"R"," ")
 S MMSGSTR(8)=$$TRIM^XLFSTR($$CJ^XLFSTR("Duplicate Abbreviation Report",80),"R"," ")
 ;
 S MMSGSTR(9)=" "
 S MMSGSTR(10)=$TR($$CJ^XLFSTR("@HOSPITAL@LOCATION@",51)," @","= ")
 S $E(MMSGSTR(10),55)=$TR($$CJ^XLFSTR("@INSTITUTION@",25)," @","= ")
 S MMSGSTR(11)="IEN"
 S $E(MMSGSTR(11),10)="Description"
 S $E(MMSGSTR(11),45)="Abbrev"
 S $E(MMSGSTR(11),55)="IEN"
 S $E(MMSGSTR(11),65)="Description"
 S MMSGSTR(12)=$TR($J("",IOM)," ","-")
 ;
 S LINE=13
 ;
 S CNT=0
 ;
 Q
 ;
TASKLINE ; EP
 S:CNT<1 CNT=CNT+1
 S:$L($TR(ABBREV," ")) CNT=CNT+1
 S IEN=0
 F  S IEN=$O(^SC("C",ABBREV,IEN))  Q:IEN<1  D
 . S MMSGSTR(LINE)=IEN
 . S $E(MMSGSTR(LINE),10)=$E($P($G(^SC(IEN,0)),"^"),1,28)
 . ; S $E(MMSGSTR(LINE),40)=CNT
 . S $E(MMSGSTR(LINE),45)=$S($L($TR(ABBREV," "))>0:ABBREV,1:"<BLANK>")
 . S $E(MMSGSTR(LINE),55)=$P($G(^SC(IEN,0)),"^",4)
 . S $E(MMSGSTR(LINE),65)=$E($P($G(^DIC(4,+$P($G(^SC(IEN,0)),"^",4),0)),"^"),1,14)
 . S LINE=LINE+1
 Q
 ;
 ;
TROUBLE(WOT) ; EP - There are duplicate Abbreviations, which are trouble.  Send Alert & MailMan message.
 ; D SNDALERT^BLRUTIL3(CNT_" Duplicate Abbreviations Exist in HOSPITAL LOCATION (# 44) File.")
 ;
 D SENDMAIL^BLRUTIL3("Duplicate Abbreviations Exist in HOSPITAL LOCATION (# 44) File",.MMSGSTR,"BLRF44DR")
 Q
