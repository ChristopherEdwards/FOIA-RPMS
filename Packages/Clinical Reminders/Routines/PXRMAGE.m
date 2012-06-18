PXRMAGE ; SLC/PKR - Utilities for age calculations. ;17-Feb-2006 11:02;MGH
 ;;1.5;CLINICAL REMINDERS;**2,5,1001,1002,1004**;Jun 19, 2000
 ;IHS/CIA/MGH - 5/12/2004 Changes made to calculate ages in months
 ;IHS/CIA/MGH - 5/27/2005 Changes made to use age decode in reminder resolution
 ;
 ;=======================================================================
AGE(DOB,DATE) ;Given a date of birth and a date return the age on that date.
 ;Both dates should be in VA Fileman format.
 Q (DATE-DOB)\10000
 ;
 ;=======================================================================
AGECHECK(AGE,MINAGE,MAXAGE) ;Given an AGE, MINimumAGE, and MAXimumAGE
 ;return true if age lies within the range.
 ;Special values of NULL or 0 mean there are no limits.
 ;
 ; IHS/CIA/MGH - 5/12/2004 PATCH 1001 Changed to function call to calculate age
 ; Two lines changed and one added
 ;S MAXAGE=+MAXAGE
 ;S MINAGE=+MINAGE
 S MAXAGE=$$DECODE(MAXAGE)
 S MINAGE=$$DECODE(MINAGE)
 S AGE=$$DECAGE(AGE)
 ;See if too old.
 I (AGE>MAXAGE)&(MAXAGE>0) Q 0
 ;
 ;See if too young.
 I MINAGE=0 Q 1
 I AGE<MINAGE Q 0
 Q 1
 ;
DECAGE(AGEVALUE) ; Put age from VADPT into format for reminders
 ; IHS/CIA/MGH - 5/12/2004 PATCH 1001 Added function to change age into days
 N NUM,CODE,MULT
 S NUM=$P(AGEVALUE," ",1),CODE=$P(AGEVALUE," ",2)
 S MULT=1.0
 I CODE="MOS" S MULT=30.42
 I CODE=""!(CODE="YRS") S MULT=365.25
 Q +(MULT*NUM)
DECODE(AGEVALUE) ;Determine the age in years or months
 ; IHS/CIA/MGH - 5/12/2004 PATCH 1001 Added function to change reminder defintion ages into days
 N CODE,LEN,MULT,NUM
 S LEN=$L(AGEVALUE)
 S NUM=$E(AGEVALUE,1,LEN-1)
 S CODE=$E(AGEVALUE,LEN,LEN)
 S MULT=1.0
 I CODE="M" S MULT=30.42
 I CODE="Y"!(CODE="") S MULT=365.25
 Q +(MULT*NUM)
 ;=======================================================================
FMTAGE(MINAGE,MAXAGE) ;Format the minimum age and maximum age for display.
 N STR
 I $L(MINAGE)!$L(MAXAGE) D
 . I $L(MINAGE)&$L(MAXAGE) S STR=" for ages "_MINAGE_" to "_MAXAGE Q
 . I $L(MINAGE) S STR=" for ages "_MINAGE_" and older" Q
 . I $L(MAXAGE) S STR=" for ages "_MAXAGE_" and younger" Q
 E  S STR=" for all ages"
 Q STR
 ;
 ;=======================================================================
FMTFREQ(FREQ) ;Format the frequency for display.
 ;This is based on FREQ^PXRMPT.
 N STR
 I +FREQ=0 S STR=FREQ_" - Not Indicated" Q STR
 I FREQ?1"99Y" S STR="99Y - Once"
 E  S STR=+FREQ_($S(FREQ["D":" day",FREQ["M":" month",FREQ["Y":" year",1:""))_$S(+FREQ>1:"s",1:"")
 Q STR
 ;
 ;=======================================================================
MMF(MINAGE,MAXAGE,FREQ,FIEVAL) ;Set the baseline minimum age, maximum
 ;age, and frequency.  If there are multiple intervals they cannot
 ;overlap.
 N FR,IC,INDEX,MATCH,MAXA,MINA,NAR,TEMP
 ;
 ;Initialize MINAGE, MAXAGE, and FREQ.
 S (MINAGE,MAXAGE,FREQ)=""
 ;
 S IC=0
 S NAR=0
 F  S IC=$O(^PXD(811.9,PXRMITEM,7,IC)) Q:+IC=0  D
 . S NAR=NAR+1
 . S TEMP=$G(^PXD(811.9,PXRMITEM,7,IC,0))
 . S FR(NAR)=$$UP^XLFSTR($P(TEMP,U,1))
 . S MINA(NAR)=$P(TEMP,U,2)
 . S MAXA(NAR)=$P(TEMP,U,3)
 . S INDEX(NAR)=IC
 . S FIEVAL("AGE",IC)=0
 I NAR=0 Q
 ;
 ;Make sure that none of the age ranges overlap.
 I $$OVERLAP(NAR,.MINA,.MAXA) Q
 ;
 ;Look for an age range match.
 S FREQ=-1
 S MATCH=0
 F IC=1:1:NAR Q:MATCH  D
 . I $$AGECHECK(PXRMAGE,MINA(IC),MAXA(IC)) D
 .. S MATCH=1
 .. S MINAGE=MINA(IC)
 .. S MAXAGE=MAXA(IC)
 .. S FREQ=FR(IC)
 .. S FIEVAL("AGE",INDEX(IC))=1
 Q
 ;
 ;=======================================================================
MNMT(NLINES,FIEVAL) ;Output the AGE match/no match text.
 N IC,IND,LC,TEXT
 I '$D(FIEVAL("AGE")) Q
 S IC=""
 F  S IC=$O(FIEVAL("AGE",IC)) Q:IC=""  D
 . I FIEVAL("AGE",IC)=1 S IND=1
 . E  S IND=2
 . S LC=0
 . F  S LC=$O(^PXD(811.9,PXRMITEM,7,IC,IND,LC)) Q:LC=""  D
 .. S TEXT=$G(^PXD(811.9,PXRMITEM,7,IC,IND,LC,0))
 .. D ADDTXT^PXRMOPT(.NLINES,TEXT)
 . I $D(PXRMDEV) D
 .. N DES,UID
 .. S DES="AGE"_IC_IND
 .. S UID=DES_$$NTOAN^PXRMUTIL(LC)
 .. S ^TMP(PXRMPID,$J,PXRMITEM,UID)=FIEVAL("AGE",IC)
 Q
 ;
 ;=======================================================================
OVERLAP(NAR,MINA,MAXA) ;Check age ranges for overlap.  Return an error message
 ;if an overlap is found.
 ;IHS/CIA/MGH Changes made to decode the ages into numeric results
 I NAR'>1 Q 0
 N IC,IN,JC,MAXI,MAXJ,MINI,MINJ,OVRLAP
 S OVRLAP=0
 F IC=1:1:NAR-1 D
 . S MAXI=$$DECODE(MAXA(IC))
 . I MAXI="" S MAXI=1000
 . S MINI=$$DECODE(MINA(IC))
 . I MINI="" S MINI=0
 . F JC=IC+1:1:NAR D
 .. S MAXJ=$$DECODE(MAXA(JC))
 .. I MAXJ="" S MAXJ=1000
 .. S MINJ=$$DECODE(MINA(JC))
 .. I MINJ="" S MINJ=0
 .. S IN=0
 .. I (MINJ'<MINI)&(MINJ'>MAXI) S IN=1
 .. I (MAXJ'<MINI)&(MAXJ'>MAXI) S IN=1
 .. I IN D
 ... S OVRLAP=OVRLAP+1
 ... S ^TMP(PXRMPID,$J,PXRMITEM,"FERROR","AGE OVERLAP",OVRLAP)=MINA(IC)_" to "_MAXA(IC)_" and "_MINA(JC)_" to "_MAXA(JC)
 I OVRLAP>1 S OVRLAP=1
 Q OVRLAP
 ;
 ;=======================================================================
RESTORE(SOURCE,INDEX,FREQ,MINAGE,MAXAGE) ;Restore FREQ, MINAGE, and
 ;MAXAGE back to the original form.
 N IND,TEMP
 I SOURCE="CFIND" D
 . S IND=$O(^PXD(811.9,PXRMITEM,10,"B",INDEX,""))
 . S TEMP=^PXD(811.9,PXRMITEM,10,IND,0)
 ;
 I SOURCE="HFIND" D
 . S IND=$O(^PXD(811.9,PXRMITEM,6,"B",INDEX,""))
 . S TEMP=^PXD(811.9,PXRMITEM,6,IND,0)
 ;
 I SOURCE="TFIND" D
 . S IND=$O(^PXD(811.9,PXRMITEM,4,"B",INDEX,""))
 . S TEMP=^PXD(811.9,PXRMITEM,4,IND,0)
 ;
 S MINAGE=$P(TEMP,U,2)
 S MAXAGE=$P(TEMP,U,3)
 S FREQ=$P(TEMP,U,4)
 Q
 ;
