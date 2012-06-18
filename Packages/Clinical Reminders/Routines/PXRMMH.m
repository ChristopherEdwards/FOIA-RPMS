PXRMMH ; SLC/PKR - Handle mental health findings. ;05/10/2002
 ;;1.5;CLINICAL REMINDERS;**2,7,8**;Jun 19, 2000
 ;
 ;=======================================================================
EVALFI(DFN,FIEVAL) ;Evaluate mental health instrument findings.
 N FIND0,FIND3,FINDING,MHIEN,YS
 S YS("DFN")=DFN
 S YS("LIMIT")=1
 S MHIEN=""
 F  S MHIEN=$O(^PXD(811.9,PXRMITEM,20,"E","YTT(601,",MHIEN)) Q:+MHIEN=0  D
 . S FINDING=""
 . F  S FINDING=$O(^PXD(811.9,PXRMITEM,20,"E","YTT(601,",MHIEN,FINDING)) Q:+FINDING=0  D
 .. S FIND0=^PXD(811.9,PXRMITEM,20,FINDING,0)
 .. S FIND3=$G(^PXD(811.9,PXRMITEM,20,FINDING,3))
 .. D FIEVAL(DFN,MHIEN,FIND0,FIND3,"","",FINDING,.FIEVAL,.YS)
 Q
 ;
 ;=======================================================================
EVALTERM(DFN,FINDING,TERMIEN,TFIEVAL) ;Evaluate mental health instrument terms.
 N FIND0,FIND3,MHIEN,TFIND0,TFIND3,TFINDING,YS
 S FIND0=^PXD(811.9,PXRMITEM,20,FINDING,0)
 S FIND3=$G(^PXD(811.9,PXRMITEM,20,FINDING,3))
 S YS("DFN")=DFN
 S YS("LIMIT")=1
 S MHIEN=""
 F  S MHIEN=$O(^PXRMD(811.5,TERMIEN,20,"E","YTT(601,",MHIEN)) Q:+MHIEN=0  D
 . S TFINDING=""
 . F  S TFINDING=$O(^PXRMD(811.5,TERMIEN,20,"E","YTT(601,",MHIEN,TFINDING)) Q:+TFINDING=0  D
 .. S TFIND0=^PXRMD(811.5,TERMIEN,20,TFINDING,0)
 .. S TFIND3=$G(^PXRMD(811.5,TERMIEN,20,TFINDING,3))
 .. D FIEVAL(DFN,MHIEN,FIND0,FIND3,TFIND0,TFIND3,TFINDING,.TFIEVAL,.YS)
 Q
 ;
 ;=======================================================================
FIEVAL(DFN,MHIEN,FIND0,FIND3,TFIND0,TFIND3,FINDING,FIEVAL,YS) ;
 N CONVAL,MHTEST,SCALE,SCNAME,SCORE,TEMP,TSCORE
 N X,Y,VALID,YSDATA,YTT0
 S YTT0=^YTT(601,MHIEN,0)
 S MHTEST=$P(YTT0,U,1)
 S SCALE=$P(TFIND0,U,12)
 I SCALE="" S SCALE=$P(FIND0,U,12)
 S YS("CODE")=MHTEST
 ;The scale can be either the name or the number.
 I (SCALE'=""),(+SCALE=0) D
 . S SCALE=$O(^YTT(601,MHIEN,"S","C",SCALE,""))
 S YS("DFN")=DFN
 S YS("SCALE")=SCALE
 K YSDATA
 D LISTONE^YTAPI(.YSDATA,.YS)
 ;The most recent results will be in YSDATA(2)
 S TEMP=$G(YSDATA(2))
 S X=$P(TEMP,U,1)
 I (X="")!(X="no psych pt") S FIEVAL(FINDING)=0 Q
 ;Save the rest of the finding information.
 S FIEVAL(FINDING)=1
 S FIEVAL(FINDING,"DATE")=$P(TEMP,U,1)
 S DATE=$P(TEMP,U,1)
 S FIEVAL(FINDING,"FINDING")=MHIEN_";YTT(601,"
 S FIEVAL(FINDING,"SCALE")=SCALE
 S FIEVAL(FINDING,"TEST")=MHTEST
 ;If this is being called as part of a term evaluation we are done.
 I TFIND0'="" Q
 ;Determine if the finding has expired.
  S VALID=$$VALID^PXRMDATE(FIND0,TFIND0,DATE)
  I 'VALID D  Q
 . S FIEVAL(FINDING)=0
 . S FIEVAL(FINDING,"EXPIRED")=""
 ;If a scale was specified save the scoring information and check
 ;for an action.
 I SCALE'="" D
 . S FIEVAL(FINDING,"SCNAME")=$P(TEMP,U,4)
 . S SCORE=$P(TEMP,U,5)
 . S FIEVAL(FINDING,"SCORE")=SCORE
 . S FIEVAL(FINDING,"VALUE")=SCORE
 . S TSCORE=$P(TEMP,U,6)
 . I TSCORE'="" S FIEVAL(FINDING,"TSCORE")=TSCORE
 .;If there is a condition for this finding evaluate it.
 . S CONVAL=$$COND^PXRMUTIL(FIND3,TFIND3,SCORE)
 . I CONVAL'="" D
 .. I CONVAL D
 ... S FIEVAL(FINDING)=CONVAL
 ... S FIEVAL(FINDING,"CONDITION")=CONVAL
 .. E  D
 ... K FIEVAL(FINDING)
 ... S FIEVAL(FINDING)=0
 Q
 ;
 ;=======================================================================
OUTPUT(NLINES,TEXT,FINDING,FIEVAL) ;Produce the clinical
 ;maintenance output.
 N DATE,MHTEST,TEMP
 S DATE=FIEVAL(FINDING,"DATE")
 S TEMP=$$EDATE^PXRMDATE(DATE)
 S TEMP=TEMP_" Mental Health Instrument: "
 S MHTEST=FIEVAL(FINDING,"TEST")
 S TEMP=TEMP_MHTEST
 ;If there is scoring information give it.
 I $D(FIEVAL(FINDING,"SCNAME")) D
 . S TEMP=TEMP_"; Scale name - "_FIEVAL(FINDING,"SCNAME")
 . I $D(FIEVAL(FINDING,"VALUE")) S TEMP=TEMP_"; Raw score - "_FIEVAL(FINDING,"VALUE")
 . I $D(FIEVAL(FINDING,"TSCORE")) S TEMP=TEMP_" Transformed score - "_FIEVAL(FINDING,"TSCORE")
 ;If the finding has expired add "EXPIRED"
 I $D(FIEVAL(FINDING,"EXPIRED")) S TEMP=TEMP_" - EXPIRED"
 ;If the finding is false because of the value add the reason.
 I $G(FIEVAL(FINDING,"CONDITION"))=0 S TEMP=TEMP_$$ACTFT^PXRMOPT
 S NLINES=NLINES+1
 S TEXT(NLINES)=TEMP
 I $D(PXRMDEV) D
 . N UID
 . S UID="MHTEST "_MHTEST
 . S ^TMP(PXRMPID,$J,PXRMITEM,UID)=TEMP
 Q
 ;
 ;=======================================================================
SCHELP(MHIEN) ;Xecutable help for MH SCALE
 N IND,JND,NUM,SCALE,TEMP,TEMP1
 I MHIEN=0 D  Q
 . S SCALE(1)="This is not a valid Mental Health finding, selecting an MH scale does"
 . S SCALE(2)="not make sense"
 . D EN^DDIOL(.SCALE)
 S SCALE(1)="SCALE NUMBER  SCALE NAME"
 S SCALE(2)="------------------------"
 S IND=0
 S JND=2
 F  S IND=$O(^YTT(601,MHIEN,"S",IND)) Q:+IND=0  D
 . S TEMP=^YTT(601,MHIEN,"S",IND,0)
 . S JND=JND+1
 . S TEMP1=$P(TEMP,U,1)
 . S NUM=6-$L(TEMP1)
 . S SCALE(JND)=$$INSCHR^PXRMEXLC(NUM," ")_TEMP1_"        "_$P(TEMP,U,2)
 D EN^DDIOL(.SCALE)
 Q
 ;
 ;=======================================================================
SCHELPF ;Xecutable help for MH SCALE in 811.9 findings.
 N FIND0,MHIEN
 S FIND0=^PXD(811.9,DA(1),20,DA,0)
 I FIND0["YTT(601" S MHIEN=$P(FIND0,";",1)
 E  S MHIEN=0
 D SCHELP(MHIEN)
 Q
 ;
 ;=======================================================================
SCHELPT ;Xecutable help for MH SCALE in 811.5 findings.
 N MHIEN,TFIND0
 S TFIND0=^PXRMD(811.5,DA(1),20,DA,0)
 I TFIND0["YTT(601" S MHIEN=$P(TFIND0,";",1)
 E  S MHIEN=0
 D SCHELP(MHIEN)
 Q
 ;
 ;=======================================================================
VSCALE(FIND0) ;Make sure that mental health scale is valid.
 ;Either the scale number or the scale name can be used.
 N MHIEN,MHTEST
 S MHTEST=$P(FIND0,U,1)
 S MHIEN=$P(MHTEST,";",1)
 I +X>0 D
 . I '$D(^YTT(601,MHIEN,"S",X)) K X
 E  D
 . S SCALE=$O(^YTT(601,MHIEN,"S","C",X,""))
 . I SCALE="" K X
 Q
 ;
 ;=======================================================================
VSCALEF ;Make sure that mental health scale is valid for a finding.
 I X="" Q
 ;Do not execute as part of a verify fields.
 I $G(DIUTIL)="VERIFY FIELDS" Q 1
 ;Do not execute as part of exchange.
 I $G(PXRMEXCH) Q 1
 N FIND0
 S FIND0=^PXD(811.9,DA(1),20,DA,0)
 D VSCALE(FIND0)
 Q
 ;
 ;=======================================================================
VSCALET ;Make sure that mental health scale is valid for a term finding.
 I X="" Q
 ;Do not execute as part of a verify fields.
 I $G(DIUTIL)="VERIFY FIELDS" Q
 ;Do not execute as part of exchange.
 I $G(PXRMEXCH) Q
 N TFIND0
 S TFIND0=^PXRMD(811.5,DA(1),20,DA,0)
 D VSCALE(TFIND0)
 Q
 ;
