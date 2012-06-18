PXRMDATE ; SLC/PKR - Clinical Reminders date utilities. ;13-Jul-2009 12:46;MGH
 ;;1.5;CLINICAL REMINDERS;**2,7,1007**;Jun 19, 2000
 ;
 ;=======================================================================
DUE(RESDATE,FREQ,DUE,DUEDATE) ;Determine if the reminder is
 ;due now. Compute the due date.  This will be the date of the
 ;resolution finding + the reminder frequency. Subtract the due in
 ;advance time to see if the reminder should be marked as due.
 ;
 N DATE,DIAT,DIATOK,LDATE,TDDUE,TODAY
 I FREQ="" D  Q
 . S ^TMP(PXRMPID,$J,PXRMITEM,"FERROR","INCMPLT")="Incomplete reminder definition see the Clinical Reminder coordinator."
 . S ^TMP(PXRMPID,$J,PXRMITEM,"FERROR","FREQ")="No reminder frequency - cannot compute due date!"
 ;
 ;If the final frequency is 0Y then the reminder is not due.
 I FREQ="0Y" D  Q
 . S DUE=0
 . S DUEDATE=""
 ;
 I RESDATE["X" S LDATE=0
 E  S LDATE=+RESDATE
 S TODAY=$$NOW
 S DUE=""
 I LDATE=0 D  Q
 . S DUE="DUE NOW"
 . S DUEDATE="DUE NOW"
 ;
 S DATE=$$FULLDATE(LDATE)
 S DUEDATE=$$NEWDATE(DATE,FREQ)
 ;
 ;If the due date is less than or equal to today's date the reminder
 ;is due.
 I DUEDATE'>TODAY D  Q
 . S DUE="DUE NOW"
 ;
 S DIAT="-"_$P($G(^PXD(811.9,PXRMITEM,0)),U,4)
 I (+DIAT)=0 D
 . S DIATOK=0
 . S ^TMP(PXRMPID,$J,PXRMITEM,"WARNING","DIAT")="Warning no do in advance time"
 E  S DIATOK=1
 ;
 I DIATOK S TDDUE=$$NEWDATE(DUEDATE,DIAT)
 E  S TDDUE=DUEDATE
 I TDDUE'>TODAY S DUE="DUE SOON"
 E  S DUE="RESOLVED"
 Q
 ;
 ;=======================================================================
EDATE(DATE) ;Check for an historical (event) date, format as appropriate.
 N TEMP
 S TEMP=$$FMTE^XLFDT(DATE,"5DZ")
 I DATE["E" S TEMP=TEMP_" (E)"
 Q TEMP
 ;
 ;=======================================================================
FMDFINVL(INVDT,DATE) ;Convert an inverse date (LABORATORY format
 ;9999999-date) to Fileman format.
 I $L(INVDT)=0 Q INVDT
 N TEMP
 S TEMP=9999999-INVDT
 ;If DATE is TRUE return only the date portion.
 I DATE S TEMP=$P(TEMP,".",1)
 Q TEMP
 ;
 ;=======================================================================
FMDFINVR(INVDT,DATE) ;Convert an inverse date (RADIOLOGY format
 ;9999999.9999-date) to Fileman format.
 I $L(INVDT)=0 Q INVDT
 N TEMP
 S TEMP=9999999.9999-INVDT
 ;If DATE is TRUE return only the date portion.
 I DATE S TEMP=$P(TEMP,".",1)
 Q TEMP
 ;
 ;=======================================================================
FULLDATE(DATE) ;See if DATE is a full date, i.e., it has a month and
 ;a day. If the month is missing assume Jan. If the day is missing
 ;assume the first. Issue a warning so the user knows what happened.
 ;We assume the date is in Fileman format.
 N DAY,MISSING,MONTH,TDATE,YEAR
 S TDATE=DATE
 S MISSING=0
 S DAY=$E(DATE,6,7)
 S MONTH=$E(DATE,4,5)
 S YEAR=$E(DATE,1,3)
 I +DAY=0 D
 . S DAY=1
 . S MISSING=1
 . S ^TMP("PXRM",$J,"WA","INFO",PXRMITEM,"NO DAY")="Encounter date missing day, using the first for the date due calculation."
 I +MONTH=0 D
 . S MONTH=1
 . S MISSING=1
 . S ^TMP("PXRM",$J,"WA","INFO",PXRMITEM,"NO MONTH")="Encounter date missing month, using January for the date due calculation."
 I MISSING D
 . S TDATE=(YEAR*1E4)+(MONTH*1E2)+DAY
 . I DATE["E" S TDATE=TDATE_"E"
 Q TDATE
 ;
 ;=======================================================================
INVFFMDL(DT,DATE) ;Convert a Fileman date to its inverse (LABORATORY
 ;format 9999999-date) to Fileman format.
 I $L(DT)=0 Q DT
 N TEMP
 S TEMP=9999999-DT
 ;If DATE is true the return only the date portion.
 I DATE S TEMP=$P(TEMP,".",1)
 Q TEMP
 ;
 ;=======================================================================
FRQINDAY(FREQ) ;Given a frequency in the form ND, NM, or NY where N is a
 ;number and D stands for days, M for months, and Y for years return
 ;the value in days.
 N CODE,LEN,MULT,NUM
 S LEN=$L(FREQ)
 S NUM=$E(FREQ,1,LEN-1)
 S CODE=$E(FREQ,LEN,LEN)
 S MULT=1.0
 I CODE="M" S MULT=30.42
 I CODE="Y" S MULT=365.25
 Q +(MULT*NUM)
 ;
 ;=======================================================================
NDAYS(INT) ;Given an interval in the form ND, NM, or NY where D stands
 ;for days, M for months, and Y for years convert to days and return
 ;that value.
 N LEN,NUM,UNIT
 S LEN=$L(INT)
 I LEN=0 Q 0
 S NUM=$E(INT,1,LEN-1)
 S UNIT=$E(INT,LEN)
 I UNIT="D" Q NUM
 I UNIT="M" Q 30.42*NUM
 I UNIT="Y" Q 365.25*NUM
 Q INT
 ;
 ;=======================================================================
NEWDATE(VADATE,OFFSET) ;Given a date in VA Fileman format (VADATE) and an
 ;offset of the form NY, NM, ND where N is a number and Y stands for
 ;years, M for months, and D for days return the new date in VA Fileman
 ;format.
 N LEN,NEWDATE,NUM,UNIT
 S LEN=$L(OFFSET)
 S NUM=+$E(OFFSET,1,LEN-1)
 S UNIT=$E(OFFSET,LEN)
 I UNIT="D" G DAY
 I UNIT="M" G MONTH
 I UNIT="Y" G YEAR
 ;Unknown unit just return the original date
 Q VADATE
DAY ;
 S NEWDATE=+$$FMADD^XLFDT(VADATE,NUM)
 Q NEWDATE
MONTH ;
 ;Convert the months to days and then add the days using the DAY code.
 ;Multiply the number of months by the average number of days in a month.
 N INT,FRAC
 S NUM=30.42*NUM
 ;Round the number of days, FMADD^XLFDT has problems with non-integer
 ;days.
 S INT=+$P(NUM,".",1)
 S FRAC=NUM-INT
 I FRAC<0.5 S NUM=INT
 E  S NUM=INT+1
 G DAY
 Q
YEAR ;
 ;IHS/MSC/MGH 1007 UPDATED FOR LEAP YEAR
 N LEAP
 S LEAP=$E(VADATE,4,7)
 I LEAP="0229" S VADATE=VADATE-1
 Q VADATE+(10000*NUM)
 ;
 ;=======================================================================
NOW() ;If PXRMDATE has a date return it, otherwise return the current date.
 N NOW
 I +$G(PXRMDATE)>0 S NOW=PXRMDATE
 E  S NOW=$$NOW^XLFDT
 Q NOW
 ;
 ;=======================================================================
VALID(FIND0,TFINDO,DATE) ;Given the date determine if the finding is
 ;valid. FIND0 is the 0 node of the finding multiple, TFIND0 is the
 ;0 node of the term finding.
 N EFP,EFD,EXPDATE,VALID
 ;First check the EFFECTIVE PERIOD.
 S EFP=$P(TFIND0,U,8)
 I EFP="" S EFP=$P(FIND0,U,8)
 S VALID=1
 I EFP'="" D
 . S EXPDATE=$$NEWDATE(DATE,EFP)
 . I $$NOW>EXPDATE S VALID=0
 I 'VALID Q VALID
 ;If the finding is still valid check the EFFECTIVE DATE.
 S EFD=$P(TFIND0,U,11)
 I EFD="" S EFD=$P(FIND0,U,11)
 I EFD'="" D
 . I DATE<EFD S VALID=0
 Q VALID
 ;
 ;=======================================================================
VDATE(VIEN) ;Given a visit ien return the visit date.
 N DATE
 I +VIEN>0 S DATE=$P($G(^AUPNVSIT(VIEN,0)),U,1)
 E  S DATE=0
 I $L(DATE)=0 S DATE=0
 ;Check for historical encounter.
 I $$ISHIST^PXRMVSIT(VIEN) D
 . S DATE=DATE_"E"
 Q DATE
 ;
