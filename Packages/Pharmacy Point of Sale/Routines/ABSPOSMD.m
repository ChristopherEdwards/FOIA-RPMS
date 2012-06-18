ABSPOSMD ; IHS/FCS/DRS - General Inquiry/Report .57; [ 09/12/2002  10:14 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 Q
 ; Things which are one per page - does DHIT="W @IOF" work?
 ;  that is, will you get the page header?
 ;  Which would be nice to have as a standard transaction header.
 ;
ACTION ; EP - given ACTION = one of the codes for an action
 ; as selected from the list in ABSPOSMZ
 ; Also the ABSPOSMA() array is still there
 ; All of the EN1^DIP variables have been NEWed by the caller
 I $T(@ACTION)="" D NOLABEL
 N TEMPLATE,IENLIST
 S IENLIST=$$IENLIST^ABSPOSMC
 G @ACTION
DIP ; and each one rejoins here (G DIP) to set up for call to EN1^DIP
 ; with TEMPLATE=[template name]
 K L,DIC,FLDS,BY,FR,TO,DHD,DIASKHD,DIPCRIT,PG,DHIT,DIOEND,DIOBEG
 K DCOPIES,IOP,DQTIME,DIS,DISUPNO,DISTOP,DISPAR
 S L=0
 S DIC=9002313.57
 S FLDS=TEMPLATE
 S BY="@-NUMBER"
 S FR=0
 S TO=$O(@IENLIST@(""),-1)
 I $D(TEMPLATE("HEADER")) D
 . S DHD=TEMPLATE("HEADER")
 . I $D(TEMPLATE("TRAILER")) S DHD=DHD_"-"_TEMPLATE("TRAILER")
 ; DIASKHD ; no, don't ask user
 ; DIPCRIT ; no, don't print sort criteria
 ; PG ; starting page number
 ; DHIT ; maybe formfeed for each new patient, for certain things?
 I 1 D  ; based on ACTION and ABSPOSMA(), maybe each claim on sep. page
 . S DHIT="F  Q:$Y+2'<IOSL  W !"
 ; DIOEND
 ; DIOBEG
 ; DCOPIES
 ; IOP - prompt for device
 ; DQTIME
 ; DIS - no screens
 ; DISUPNO
 S DISTOP="I 1"
 ;
 S BY(0)=$$OPEN^ABSPOSMC(IENLIST)
 S L(0)=1
 ;
 D EN1^DIP
 I ABSPOSMA("MODE")="INQUIRY" D PRESSANY^ABSPOSU5()
 Q
TEMPLATE(TNAMESFX) ;
 ; Look for site-specific version of the print template.
 ; The template name ends in TNAMESFX.
 ; Otherwise, use the standard print template for TNAMESFX.
 ;
 ; Example:  at tag S, xxxxx TRANSACTION SUMMARY
 ;
 ; If there's a site-specific version, a pointer to the template is at
 ;   $P(^ABSP(9002313.99,1,"DIPT TRANSACTION SUMMARY"),U)
 ;   and from that pointer, we can find the print template name.
 ;   Such site-specific templates should be name spaced, but we don't
 ;   enforce that here.  We leave the naming as a local decision.
 ;
 ; Otherwise, we use the template named ABSP57 TRANSACTION SUMMARY
 ;
 ; Return value is the template name in [brackets]
 ;
 N TNAME,TNUM
 S TNUM=$P($G(^ABSP(9002313.99,1,"DIPT "_TNAMESFX)),U)
 I TNUM S TNAME=$P($G(^DIPT(TNUM,0)),U)
 E  S TNAME=""
 I TNAME="" S TNAME="ABSP57 "_TNAMESFX
 ; Make sure the template exists
 S TNUM=$O(^DIPT("B",TNAME,0))
 I 'TNUM D IMPOSS^ABSPOSUE("DB","TI","Missing print template "_TNAME,,"TEMPLATE",$T(+0))
 S TNAME="["_TNAME_"]"
 Q TNAME
TRANSHDR() ; $$ returns template name for transaction header
 Q $$TEMPLATE("TRANSACTION HEADER")
 ;
S ; Transaction Summary ;
 S TEMPLATE=$$TEMPLATE("TRANSACTION SUMMARY")
 G DIP
C ; Claim - Basic info ; 
 S TEMPLATE("HEADER")=$$TEMPLATE("TRANSACTION SUMMARY")
 S TEMPLATE=$$TEMPLATE("CLAIM BASIC INFO")
 G DIP
R ; Response Detail
 S TEMPLATE("HEADER")=$$TEMPLATE("TRANSACTION SUMMARY")
 S TEMPLATE=$$TEMPLATE("RESPONSE INFO")
 G DIP
F ; Financial Detail ; $$TEMPLATE("FINANCIAL DETAIL")
 S TEMPLATE("HEADER")=$$TEMPLATE("TRANSACTION SUMMARY")
 S TEMPLATE=$$TEMPLATE("FINANCIAL INFO")
 G DIP
J ; Rejection Detail 
 S TEMPLATE("HEADER")=$$TEMPLATE("TRANSACTION SUMMARY")
 S TEMPLATE=$$TEMPLATE("REJECT INFO")
 G DIP
T ; Total Comprehensive Detail ; $$TEMPLATE("COMPREHENSIVE DETAIL")
 D NOTIM("T")
 G DIP
REC ; Summary Receipt ; $$TEMPLATE("SUMMARY RECEIPT")
 D NOTIM("REC")
 G DIP
D ; DUR Info Only ; $$TEMPLATE("DUR INFO ONLY")
 S TEMPLATE("HEADER")=$$TEMPLATE("TRANSACTION SUMMARY")
 S TEMPLATE=$$TEMPLATE("DUR INFO")
 G DIP
PT ; Print Template selection ; Prompt user for a print template
 ; Let EN1^DIP do it.  Just print instructions here to alert user
 ; as to what to do.
 D NOTIM("PT")
 G DIP
FM ; Fileman to customize output ; EN1^DIP will prompt user for fields
 ; to be printed.
 D NOTIM("FM")
 G DIP
NOLABEL(X) ;
 D IMPOSS^ABSPOSUE("P","TI","Missing label "_X,,"NOLABEL",$T(+0))
 Q
NOTIM(X) ;
 D IMPOSS^ABSPOSUE("P","I","Not implemented at label "_X,,"NOTIM",$T(+0))
 Q
