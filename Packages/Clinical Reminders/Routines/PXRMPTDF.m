PXRMPTDF ; SLC/PKR/PJH - Routines for definition print templates ;01/16/2002
 ;;1.5;CLINICAL REMINDERS;**2,5,8**;Jun 19, 2000
 ;
 ;======================================================================
AFREQ ; Print baseline FREQUENCY/AGE RANGE.
 N PXAMAX,PXAMIN,PXF,PXF0,PXW
 S PXF0=$G(^PXD(811.9,D0,7,D1,0))
 S PXF=$P(PXF0,U,1)
 S PXAMIN=$P(PXF0,U,2)
 S PXAMAX=$P(PXF0,U,3)
 I PXF="" S PXW="MISSING FREQUENCY"
 S PXW=$$FREQ(PXF)
 S PXW=PXW_$$FMTAGE^PXRMAGE(PXAMIN,PXAMAX)
 W "  ",PXW
 Q
 ;
 ;======================================================================
DUEWI ;Print DO WITHIN time frame
 N PXF,PXW
 S PXF=$P($G(^PXD(811.9,D0,0)),U,4)
 I (PXF="")!(+PXF=0) W "  Wait until actually DUE" Q
 S PXW=$$FREQ(PXF)
 W "  Do if DUE within "_PXW
 Q
 ;
 ;======================================================================
EDIT ;Print latest entry in edit history
 N CNT,DIWF,DIWL,DIWR,ECOM,EDATA,EIEN,ESUB,ETIME,FIRST,IC,MAX,UIEN,USER,X
 K ^UTILITY($J,"W")
 ;Get edit history count
 S MAX=$G(^PXRM(800,1,"EDIT HISTORY COUNT")) I MAX="" S MAX=2
 ;Last N lines
 S CNT=0,EIEN="A",FIRST=1
 F  S EIEN=$O(^PXD(811.9,D0,110,EIEN),-1) Q:'EIEN  Q:CNT=MAX  D
 .;Edit date and edit by fields
 .S EDATA=$G(^PXD(811.9,D0,110,EIEN,0)) Q:EDATA=""
 .S ETIME=$P(EDATA,U),UIEN=$P(EDATA,U,2) Q:'UIEN
 .S USER=$P($G(^VA(200,UIEN,0)),U),CNT=CNT+1
 .;Comments
 .S DIWF="C50",DIWL=20,DIWR=78
 .S IC=0
 .F  S IC=$O(^PXD(811.9,D0,110,EIEN,1,IC)) Q:'IC  D
 ..S X=$G(^PXD(811.9,D0,110,EIEN,1,IC,0))
 ..D ^DIWP
 .;Output
 .;Header
 .I FIRST S FIRST=0 W "Edit History:",!!
 .W ?4,"Edit date:",?16,$$FMTE^XLFDT(ETIME,"1")
 .W ?40,"Edit by:",?52,USER
 .W !,?4,"Edit Comments:"
 .S IC=0
 .F  S IC=$O(^UTILITY($J,"W",DIWL,IC)) Q:IC=""  D
 ..W ?20,^UTILITY($J,"W",DIWL,IC,0),!
 .K ^UTILITY($J,"W")
 .W !!
 Q
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
FREQ(FREQ) ;Format frequency.
 N STR
 I +FREQ=0 S STR=FREQ_" - Not Indicated" Q STR
 I FREQ?1"99Y" S STR="99Y - Once"
 E  S STR=+FREQ_($S(FREQ?1N.N1"D":" day",FREQ?1N.N1"M":" month",FREQ?1N.N1"Y":" year",1:""))_$S(+FREQ>1:"s",1:"")
 Q STR
 ;
 ;======================================================================
FTYPE(VPTR) ;Return finding type.
 N FTYPE,ROOT
 S ROOT=$P(VPTR,";",2)
 I '$D(PXRMFVPL) N PXRMFVPL D BLDRLIST^PXRMVPTR(811.902,.01,.PXRMFVPL)
 S FTYPE=$P(PXRMFVPL(ROOT),U,2)
 Q FTYPE
 ;
 ;======================================================================
GENFREQ(PXF0) ;Print age range frequency set for findings.
 N PXF,PXW,PXAMIN,PXAMAX
 S PXF=$P(PXF0,U,4)
 I PXF="" Q ""
 S PXAMIN=$P(PXF0,U,2)
 S PXAMAX=$P(PXF0,U,3)
 S PXW=$$FREQ(PXF)
 S PXW=PXW_$$FMTAGE^PXRMAGE(PXAMIN,PXAMAX)
 Q PXW
 ;
 ;======================================================================
GENIEN(FINDING) ;Return internal entry number for findings.
 N F0,IEN,PREFIX,ROOT,VPTR
 S ROOT="^PXD(811.9,D0,20,FINDING,0)"
 S F0=@ROOT
 S VPTR=$P(F0,U,1)
 S IEN=$P(VPTR,";",1)
 S ROOT=$P(VPTR,";",2)
 I '$D(PXRMFVPL) N PXRMFVPL D BLDRLIST^PXRMVPTR(811.902,.01,.PXRMFVPL)
 S VPTR=PXRMFVPL(ROOT)
 S PREFIX=$P(VPTR,U,4)
 Q " (FI("_+FINDING_")="_PREFIX_"("_IEN_"))"
 ;
 ;======================================================================
PFIND ;Print the reminder definition finding multiple.
 N DIWF,FIELD,FINDING,FIND0,IND,PAD,PADS,RJC,XEXT
 ;If called by a FileMan print build the variable pointer list.
 I '$D(PXRMFVPL) N PXRMFVPL D BLDRLIST^PXRMVPTR(811.902,.01,.PXRMFVPL)
 ;Because of the way DIWP works we need to format all the found and
 ;not found text first and store it in ^TMP.
 K ^TMP($J,"W")
 S RJC=29
 S PAD=" "
 S PADS=""
 F IND=1:1:(RJC+2) S PADS=PADS_PAD
 S FINDING=0
 F  S FINDING=$O(^PXD(811.9,D0,20,FINDING)) Q:+FINDING=0  D
 . D WPFORMAT(FINDING,RJC,1)
 . D WPFORMAT(FINDING,RJC,2)
 S DIWF="C80",DIWL=2
 K ^UTILITY($J,"W")
 S FINDING=0
 F  S FINDING=$O(^PXD(811.9,D0,20,FINDING)) Q:+FINDING=0  D
 . S FIND0=^PXD(811.9,D0,20,FINDING,0)
 . S FIELD=$P(FIND0,U,1)
 . S X=" "
 . D ^DIWP
 . S X=$$RJ^XLFSTR("Finding Item:",RJC,PAD)
 . S X=X_" "_$$ENTRYNAM(FIELD)
 . S X=X_" "_$$GENIEN(FINDING)
 . D ^DIWP
 .;
 . S X=$$RJ^XLFSTR("Finding Type:",RJC,PAD)
 . S X=X_" "_$$FTYPE(FIELD)
 . D ^DIWP
 .;
 . S FIELD=$P(FIND0,U,4)
 . I $L(FIELD)>0 D
 .. S X=$$RJ^XLFSTR("Match Frequency/Age:",RJC,PAD)
 .. S X=X_" "_$$GENFREQ(FIND0)
 .. D ^DIWP
 .;
 . D SFDISP(FIND0,5,6,"Rank Frequency:",RJC,PAD)
 . D SFDISP(FIND0,6,7,"Use in Resolution Logic:",RJC,PAD)
 . D SFDISP(FIND0,7,8,"Use in Patient Cohort Logic:",RJC,PAD)
 . D SFDISP(FIND0,8,9,"Effective Period:",RJC,PAD)
 . D SFDISP(FIND0,11,12,"Effective Date:",RJC,PAD)
 . D SFDISP(FIND0,9,10,"Use Inactive Problems:",RJC,PAD)
 . D SFDISP(FIND0,10,11,"Within Category Rank:",RJC,PAD)
 . D SFDISP(FIND0,12,13,"MH Scale:",RJC,PAD)
 . D SFDISP(FIND0,13,16,"Rx Type:",RJC,PAD)
 .;
 . S FIND0=$G(^PXD(811.9,D0,20,FINDING,3))
 . D SFDISP(FIND0,1,14,"Condition:",RJC,PAD)
 . D SFDISP(FIND0,2,15,"Condition Case Sensitive:",RJC,PAD)
 .;
 . D WPOUT(FINDING,"Found Text:",RJC,PAD,PADS,1)
 . D WPOUT(FINDING,"Not Found Text:",RJC,PAD,PADS,2)
 .;
 ;
 K ^TMP($J,"W")
 ;^UTILITY($J,"W") will be killed by ^DIWW in the print template.
 Q
 ;
 ;======================================================================
SFDISP(FIND0,PIECE,FLDNUM,TITLE,RJC,PAD) ;Standard finding multiple
 ;field display.
 N FIELD,X
 S FIELD=$P(FIND0,U,PIECE)
 I $L(FIELD)>0 D
 . S X=$$RJ^XLFSTR(TITLE,RJC,PAD)
 . S X=X_" "_$$EXTERNAL^DILFD(811.902,FLDNUM,"",FIELD,"")
 . D ^DIWP
 Q
 ;
 ;======================================================================
USAGE ;Format usage string
 W ?30,$$XFORM($P($G(^PXD(811.9,D0,100)),U,4))
 Q
 ;
 ;======================================================================
WPFORMAT(FINDING,RJC,INDEX) ;Format found/not found word processing text.
 I '$D(^PXD(811.9,D0,20,FINDING,INDEX,1,0)) Q
 ;Save the title using the current format for DIWP.
 N DIWF,DIWL,DIWR,IND,NLINES,SC,TEXT,X
 K ^UTILITY($J,"W")
 S DIWF="|",DIWL=RJC+2,DIWR=78
 S IND=0
 F  S IND=$O(^PXD(811.9,D0,20,FINDING,INDEX,IND)) Q:+IND=0  D
 . S X=$G(^PXD(811.9,D0,20,FINDING,INDEX,IND,0))
 . D ^DIWP
 ;Find where this stuff went.
 S SC=$O(^UTILITY($J,"W",""))
 ;Save into ^TMP.
 S NLINES=^UTILITY($J,"W",SC)
 S ^TMP($J,"W",FINDING,INDEX)=NLINES
 F IND=1:1:NLINES D
 . S ^TMP($J,"W",FINDING,INDEX,IND)=^UTILITY($J,"W",SC,IND,0)
 K ^UTILITY($J,"W")
 Q
 ;
 ;======================================================================
WPOUT(FINDING,TITLE,RJC,PAD,PADS,INDEX) ;Output found/not found word processing
 ;text.
 I $D(^TMP($J,"W",FINDING,INDEX)) D
 . N IND,X
 . S X=$$RJ^XLFSTR(TITLE,RJC,PAD)_" "_^TMP($J,"W",FINDING,INDEX,1)
 . D ^DIWP
 . F IND=2:1:^TMP($J,"W",FINDING,INDEX) D
 .. S X=PADS_^TMP($J,"W",FINDING,INDEX,IND)
 .. D ^DIWP
 Q
 ;
 ;=======================================================================
XFORM(Y) ;Print transform for field 103 in file #811.9
 ;If ALL
 I Y["*" Q "CPRS, DATA EXTRACT, REPORTS"
 ;Otherwise
 N ARRAY,IC,LIT,OUTPUT,X
 F IC=1:1:$L(Y) D
 .S X=$E(Y,IC)
 .S LIT=$S(X="C":"CPRS",X="X":"DATA EXTRACT",X="R":"REPORTS",1:"")
 .I LIT'="" S ARRAY(LIT)=""
 ;
 S LIT="",OUTPUT=""
 F  S LIT=$O(ARRAY(LIT)) Q:LIT=""  D
 .S OUTPUT=OUTPUT_", "_LIT
 ;
 Q $E(OUTPUT,3,$L(OUTPUT))
