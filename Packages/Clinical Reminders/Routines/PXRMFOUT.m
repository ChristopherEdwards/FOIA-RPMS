PXRMFOUT ; SLC/PKR - Prepare the final reminder output. ;01/16/2001
 ;;1.5;CLINICAL REMINDERS;**2**;Jun 19, 2000
 ;
 ;=======================================================================
FINAL(PCLOGIC,RESLOGIC,DUE,DUEDATE,RESDATE,FREQ,FIEVAL) ;
 ;Produce the final output.
 ; 
 ;Temporarily set CMB=CM
 I PXRHM=4 S PXRHM=5
 ;
 ;If the component is CR (Reminders Due) and the reminder is not due
 ;we are done.
 I (PXRHM=0)&(DUE'["DUE") Q
 ;
 ;If the reminder is N/A do the N/A part for the summary and maintenance
 ;components.
 N NOOUTPUT
 S NOOUTPUT=0
 I 'PCLOGIC D
 .;IGNORE ON N/A applies only to the Clinical Maintenance component.
 . I PXRHM=5 D IGNNA(.NOOUTPUT)
 . I 'NOOUTPUT D NAOUTPUT(RESDATE)
 I NOOUTPUT Q
 ;
 ;If the reminder is applicable produce the due information.
 I PCLOGIC D DUE(DUE,DUEDATE,RESDATE,FREQ)
 ;
 ;Produce the clinical maintenance output.
 I PXRHM=5 D OUTPUT^PXRMOPT(PCLOGIC,RESLOGIC,RESDATE,.FIEVAL)
 ;
 ;If there is any information stored in ^TMP("PXRHM") Health Summary
 ;will not display it unless ^TMP("PXRHM",$J,PXRMITEM,PXRMRNAM) has
 ;data in it.
 I $D(^TMP("PXRHM",$J,PXRMITEM,PXRMRNAM))=10 S ^TMP("PXRHM",$J,PXRMITEM,PXRMRNAM)=" "
 Q
 ;
 ;=======================================================================
DUE(DUE,DUEDATE,RESDATE,FREQ) ;Create the due information.
 ;
 N LDATE,LDATEF,TEMP,TXT
 ;
 I RESDATE["E" S LDATEF=+RESDATE_U_"E"
 I RESDATE["X" D
 . S LDATEF=+RESDATE_U_"X"
 . S LDATE=0
 E  S LDATE=+RESDATE
 I (+RESDATE)'>0 S LDATEF="unknown"
 I '$D(LDATEF) S LDATEF=LDATE
 ;
 ;Immunizations may be marked as contraindicated. If that is the case
 ;they are never due.
 I $G(^TMP(PXRMPID,$J,"CONTRAINDICATED"))=1 D  Q
 . S ^TMP("PXRHM",$J,PXRMITEM,PXRMRNAM)="NEVER"_U_DUEDATE_U_LDATEF
 ;
 ;A reminder frequency of 0Y is a special case that means never show as
 ;due.
 I (FREQ="0Y") D  Q
 . S ^TMP("PXRHM",$J,PXRMITEM,PXRMRNAM)="N/A"_U_U_LDATEF
 ;
 ;A reminder frequency of 99Y means do once in a lifetime. In this
 ;case display null for the due date.
 I
 I (LDATE>0)&(FREQ="99Y") D  Q
 . S ^TMP("PXRHM",$J,PXRMITEM,PXRMRNAM)="DONE"_U_""_U_LDATEF
 ;
 S ^TMP("PXRHM",$J,PXRMITEM,PXRMRNAM)=DUE_U_DUEDATE_U_LDATEF
 Q
 ;
 ;=======================================================================
IGNNA(NOOUTPUT) ;The reminder is N/A, determine if there is no Clinical
 ;Maintenance output.
 ;
 S NOOUTPUT=1
 ;
 ;Get the IGNORE ON N/A information.
 N IGNORE
 S IGNORE=$P(^PXD(811.9,PXRMITEM,0),U,8)
 ;
 ;If the reminder is N/A and the ignore wildcard is set we are done.
 I ($D(^TMP(PXRMPID,$J,PXRMITEM,"N/A")))&(IGNORE["*") Q
 ;
 ;Look for specific ignore codes.
 I ($D(^TMP(PXRMPID,$J,PXRMITEM,"N/A","AGE")))&(IGNORE["A") Q
 I ($D(^TMP(PXRMPID,$J,PXRMITEM,"N/A","INACTIVE")))&(IGNORE["I") Q
 I $D(^TMP(PXRMPID,$J,PXRMITEM,"N/A","INACTIVE")) D  Q
 . S ^TMP("PXRHM",$J,PXRMITEM,PXRMRNAM)=""
 . S ^TMP("PXRHM",$J,PXRMITEM,PXRMRNAM,"TXT",1)=^TMP(PXRMPID,$J,PXRMITEM,"N/A","INACTIVE")
 I ($D(^TMP(PXRMPID,$J,PXRMITEM,"N/A","RACE")))&(IGNORE["R") Q
 I ($D(^TMP(PXRMPID,$J,PXRMITEM,"N/A","SEX")))&(IGNORE["S") Q
 ;If we got to here there are no ignore codes so return the N/A
 ;information and turn the output on.
 S NOOUTPUT=0
 Q
 ;
 ;=======================================================================
NAOUTPUT(RESDATE) ;Prepare the N/A output.
 N DDATE
 I RESDATE["E" S DDATE=+RESDATE_U_"E"
 I RESDATE["X" S DDATE=+RESDATE_U_"X"
 I '$D(DDATE) S DDATE=+RESDATE
 I DDATE=0 S DDATE=""
 S ^TMP("PXRHM",$J,PXRMITEM,PXRMRNAM)="N/A"_U_U_DDATE
 Q
 ;
