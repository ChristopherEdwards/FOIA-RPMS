PXRMAGE ; SLC/PKR - Utilities for age calculations. ;07-Jun-2012 09:58;DU
 ;;2.0;CLINICAL REMINDERS;**4,1001**;Feb 04, 2005;Build 21
 ;IHS/MSC/MGH Make changes for babies and toddlers
 ;===========================================
AGE(DOB,DOD,DATE) ;Given a date of birth, date of death, and a date
 ;return the age on that date. If the date of death is not null the
 ;return the age on the date of death. All dates should be in VA
 ;Fileman format.
 ;IHS/MSC/MGH patch 1001 was not returning correct data for babies
 N CDATE,BAGE,VADM
 S CDATE=$S(DOD="":DATE,DOD'="":DOD)
 S BAGE=(CDATE-DOB)\10000
 I BAGE<2 D
 .D DEM^VADPT
 .S BAGE=VADM(4)
 Q BAGE
 ;
 ;===========================================
AGECHECK(AGE,MINAGE,MAXAGE) ;Given an AGE, MINimumAGE, and MAXimumAGE
 ;return true if age lies within the range.
 ;Special values of NULL or 0 mean there are no limits.
 ;
 ;IHS/MSC/MGH Put back in age check patch 1001
 ;S MAXAGE=+MAXAGE
 ;S MINAGE=+MINAGE
 N PTAGE
 S AGE=$$DECAGE(AGE)
 S MAXAGE=$$DECODE(MAXAGE)
 S MINAGE=$$DECODE(MINAGE)
 ;See if too old.
 I (AGE>MAXAGE)&(MAXAGE>0) Q 0
 ;
 ;See if too young.
 I MINAGE=0 Q 1
 I AGE<MINAGE Q 0
 Q 1
 ;
 ;===========================================
DECAGE(AGEVALUE) ; Put age from VADPT into format for reminders
 ; IHS/MSC/MGH - 2/28/2012 PATCH 1001 Added function to change age into days or months
 N NUM,CODE,MULT
 S NUM=$P(AGEVALUE," ",1),CODE=$P(AGEVALUE," ",2)
 S MULT=1.0
 I CODE="MOS" S MULT=30.42
 I CODE=""!(CODE="YRS") S MULT=365.25
 Q +(MULT*NUM)
 ;====================================================================
DECODE(AGEVALUE) ;Determine the age in years or months
 ; IHS/MSC/MGH - 2/28/2012 PATCH 1001 Added function to change reminder
 N CODE,LEN,MULT,NUM
 S LEN=$L(AGEVALUE)
 S NUM=$E(AGEVALUE,1,LEN-1)
 S CODE=$E(AGEVALUE,LEN,LEN)
 S MULT=1.0
 I CODE="M" S MULT=30.42
 I CODE="Y"!(CODE="") S MULT=365.25
 Q +(MULT*NUM)
 ;==================================================================
FMTAGE(MINAGE,MAXAGE) ;Format the minimum age and maximum age for display.
 N STR
 I $L(MINAGE)!$L(MAXAGE) D
 . I $L(MINAGE)&$L(MAXAGE) S STR=" for ages "_MINAGE_" to "_MAXAGE Q
 . I $L(MINAGE) S STR=" for ages "_MINAGE_" and older" Q
 . I $L(MAXAGE) S STR=" for ages "_MAXAGE_" and younger" Q
 E  S STR=" for all ages"
 Q STR
 ;
 ;===========================================
FMTFREQ(FREQ) ;Format the frequency for display.
 N FREQT,STR
 S STR="Frequency: "
 S FREQT=$$FREQ^PXRMPTD2(FREQ)
 I FREQ=-1 Q STR_FREQT
 Q STR_"Due every "_FREQT
 ;
 ;===========================================
MMF(DEFARR,PXRMPDEM,MINAGE,MAXAGE,FREQ,FIEVAL) ;Set the baseline minimum age,
 ;maximum age, and frequency.  If there are multiple intervals they
 ;cannot overlap.
 N FR,IC,INDEX,MATCH,MAXA,MINA,NAR,TEMP
 ;Initialize MINAGE, MAXAGE, and FREQ.
 S (MINAGE,MAXAGE,FREQ)=""
 S (IC,NAR)=0
 F  S IC=$O(DEFARR(7,IC)) Q:+IC=0  D
 . S NAR=NAR+1
 . S TEMP=DEFARR(7,IC,0)
 . S FR(NAR)=$$UP^XLFSTR($P(TEMP,U,1))
 . S MINA(NAR)=$P(TEMP,U,2)
 . S MAXA(NAR)=$P(TEMP,U,3)
 . S INDEX(NAR)=IC
 . S FIEVAL("AGE",IC)=0
 I NAR=0 Q
 ;
 ;Make sure that none of the age ranges overlap.
 I $D(PXRMDEBG),$$OVERLAP(NAR,.MINA,.MAXA) Q
 ;
 ;Look for an age range match.
 S FREQ=-1
 S MATCH=0
 F IC=1:1:NAR Q:MATCH  D
 . I $$AGECHECK(PXRMPDEM("AGE"),MINA(IC),MAXA(IC)) D
 .. S MATCH=1
 .. S MINAGE=MINA(IC)
 .. S MAXAGE=MAXA(IC)
 .. S FREQ=FR(IC)
 .. S FIEVAL("AGE",INDEX(IC))=1
 Q
 ;
 ;===========================================
OVERLAP(NAR,MINA,MAXA) ;Check age ranges for overlap.  Return an error message
 ;if an overlap is found.
 ;IHS/MSC/MGH Decode added for IHS ages
 I NAR'>1 Q 0
 N IC,IN,JC,MAXI,MAXJ,MINI,MINJ,OVRLAP,TEXT
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
 ... S TEXT=MINA(IC)_" to "_MAXA(IC)_" and "_MINA(JC)_" to "_MAXA(JC)
 ... I $D(PXRMPID) S ^TMP(PXRMPID,$J,PXRMITEM,"FERROR","AGE OVERLAP",OVRLAP)=TEXT
 ... E  S ^TMP($J,"OVERLAP",OVRLAP)=TEXT
 I OVRLAP>1 S OVRLAP=1
 Q OVRLAP
 ;
 ;===========================================
OVLAP() ;Check age ranges for overlap. Called from definition editor after
 ;input of baseline frequency/age ranges.
 N IC,NAR,MAXA,MINA,OVERLAP,TEMP
 S (IC,NAR)=0
 F  S IC=$O(^PXD(811.9,DA,7,IC)) Q:+IC=0  D
 . S NAR=NAR+1
 . S TEMP=^PXD(811.9,DA,7,IC,0)
 . S MINA(NAR)=$P(TEMP,U,2)
 . S MAXA(NAR)=$P(TEMP,U,3)
 S OVERLAP=$$OVERLAP^PXRMAGE(NAR,.MINA,.MAXA)
 I OVERLAP D
 . W !,"Error - the following age ranges overlap:"
 . S IC=0
 . F  S IC=$O(^TMP($J,"OVERLAP",IC)) Q:IC=""  W !,?2,^TMP($J,"OVERLAP",IC)
 . K ^TMP($J,"OVERLAP")
 . W !,"Please correct this problem."
 Q OVERLAP
 ;
