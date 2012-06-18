ABSPOSS1 ; IHS/FCS/DRS - report what's in POS tables ;  
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 ;
 ; Enter at top - option ABSP SETUP DETAIL
 ;
 ; ABSPOSS1 is for file 9002313.99 (SETUP)
 ; ABSPOSS2 is for file 9002313.4  (ABSP INSURER)
 ; and ABSPOSS7 too.
 ; ABSPOSS3 is for file 9002313.53 (PRICING)
 ; ABSPOSS4 is for file 9002313.54 (MODEM TYPES)
 ; ABSPOSS5 is for file 9002313.55 (DIAL OUT)
 ; ABSPOSS6 is for file 9002313.515 (USER PREFERENCES)
 ;         and for file 9002313.56 (PHARMACIES)
 ; ABSPOSS8 has some specialized setup programs called from menus.
 ; ABSPOSS9 is an integrity check of selected items
 N POP D ^%ZIS Q:$G(POP)
 N REF S REF="^TMP("_$J_")"
 N FILENUM
 D REPORT^ABSPOSS9 ; integrity check
 S FILENUM=9002313.99 D GET99(REF),PRINT99(REF)
 Q
GET99(TARGET) N FILE,IENS,FIELD,FLAGS,MSG,ANY
 S FILE=9002313.99
 S IENS="1,"
 S FIELD="**"
 S FLAGS="EI"
 D GETS^DIQ(FILE,IENS,FIELD,FLAGS,TARGET,"MSG")
 I $D(MSG) W "Problem in GET99^",$T(+0),! D ZWRITE^ABSPOS("MSG")
 Q
DASHES N X S X=$J("",$S($G(IOM):IOM-1,1:79)),X=$TR(X," ","-") W X,! Q
SUBTITLE(X) W !,"----- ",X," -----",!! Q
SUBTITL2(X) W "  ~   ",X,"   ~  ",! Q
TITLE(FILENUM) W !,"===== File ",FILENUM," ",$P(^DIC(FILENUM,0),U)," =====",!!
 Q
EXPLAIN(X)         W ?5,"(",X,")",! Q
ILCAR() Q $$ISILCAR^ABSPOSB ; is it ILC A/R (Version 1 or 2)?
IHS3PB() Q $$ISABMAR^ABSPOSB ; is it IHS 3rd Party Billing?
HEADING ;
 W "Point of Sale - Detailed Configuration Report"
 W ?60,$$NOWEXT^ABSPOSU1,!
 W !
 Q
PRINT99(REF) D HEADING
 W $$VERSION^ABSPOS," ",$$VARIANT^ABSPOS,!
 W "Shutdown flag = ",$$SHUTDOWN^ABSPOSQ3,!
 W "Maximum transmitter/receiver jobs = ",$$MAXJOBS^ABSPOSQ3,!
 D TITLE(FILENUM)
 D FIELDS(FILENUM,.01)
 D FIELDS(FILENUM,440.01) ; default dial-out
 D FIELDS(FILENUM,170.01) ; A/R Package
 ;D FIELDS(FILENUM,.04)
 ;D FIELDS(FILENUM,2.01)
 D SUBTITLE("Input settings")
 D FIELDS(FILENUM,941)
 D FIELDS(FILENUM,943)
 D SUBTITLE("Miscellaneous insurance parameters")
 D FIELDS(FILENUM,951)
 I $G(@REF@(FILENUM,"1,",951,"I"))="" D
 . D EXPLAIN("Grace period - the default default is 30 days")
 . I $$ANY^ABSPOSS2("GRACE") D
 . . D EXPLAIN("A list of insurers with grace period override")
 . . D EXPLAIN("   appears later in this report.")
 . E  D
 . . D EXPLAIN("All insurers are using the same grace period.")
 I $$ANYINUSE^ABSPOSS8 D
 . D EXPLAIN("A report of in-use insurance rules, if any, appears later in this report.")
 D PRESSANY^ABSPOSU5() ; - - - - - - - - - - - - - - - - - - -
 D SUBTITLE("Unbillable Items (system default settings)")
 I $$ANY^ABSPOSS2("UN/BILLABLE") D
 . D EXPLAIN("A list of insurers with specific settings for")
 . D EXPLAIN("billable/unbillable items appears later in this report.")
 D FIELDS(FILENUM,2128.13) ; OTC
 D FIELDS(FILENUM,2128.11) ; NDC #
 D FIELDS(FILENUM,2128.12) ; drug name
 I '$$ILCAR G NOTILCAR ; but then the rest of this is ILC only
 D SUBTITLE("Rules for Creating Accounts Receivable")
 D FIELDS(FILENUM,170.01)
 D EXPLAIN("Certain visit-related data is automatically filled in")
 D EXPLAIN("at the time A/R is created.  These SUPPRESS fields can")
 D EXPLAIN("prevent such behavior.")
 D FIELDS(FILENUM,370.01,370.99)
 D EXPLAIN("The PREBILL fields control which forms are printed.")
 D EXPLAIN("If not present, the default default to print NCPDP forms.")
 D FIELDS(FILENUM,667.01,667.99)
 I $$ANY^ABSPOSS2("PREBILL") D
 . D EXPLAIN("A list of insurers with different prebill settings")
 . D EXPLAIN("   appears later in this report.")
 E  D
 . D EXPLAIN("All insurers are using these prebill settings.")
 W !
 D EXPLAIN("The A/R type assigned to new accounts can be set")
 D EXPLAIN("to something else on a pharmacy basis.")
 D FIELDS(FILENUM,1801) ; A/R TYPE
 D SUBTITLE("Default parameters for printing NCPDP forms")
 D FIELDS(FILENUM,665.01,665.04)
 I $$ANY^ABSPOSS2("NCPDP") D
 . D EXPLAIN("A list of insurers with changed settings for printing")
 . D EXPLAIN("   NCPDP forms appears later in this report.")
 E  D
 . D EXPLAIN("All insurers are using these NCPDP settings.")
 ; (Workers Comp in the original Sitka way)
 ;D SUBTITLE("Insurances to be used only for Workers Comp")
 ;D FIELDS(FILENUM+.0001,.01,.99)
 D SUBTITLE("Insurers which lead to automatic writeoff")
 D FIELDS(FILENUM+.002388,.01,.99)
 D SUBTITLE("Beneficiary codes leading to auto-writeoff of SELF PAY")
 D FIELDS(FILENUM+.002389,.01,.99)
 D SUBTITLE("Special write-off rules; usually site-specific")
 D FIELDS(FILENUM,2387.01,2387.99)
 D SUBTITLE("Last time EOB screen input was done")
 D FIELDS(FILENUM,577.01,577.99)
 D SUBTITLE("Last time Writeoff screen input was done")
 D FIELDS(FILENUM,2270.01,2270.99)
 D SUBTITL2("For A/R types:")
 D FIELDS(FILENUM+.002271,.01,.99)
 D FIELDS(FILENUM,2272.01)
 D SUBTITL2("For Clinics:")
 D FIELDS(FILENUM+.002273,.01,.99)
 D SUBTITL2("For Diagnoses:")
 D FIELDS(FILENUM+.002274,.01,.99)
 D SUBTITL2("For Insurers:")
 D FIELDS(FILENUM+.002279,.01,.99)
NOTILCAR ; Branched here if not ILC A/R
 D SUBTITLE("Miscellaneous other settings")
 ;D FIELDS(FILENUM,1490) ; NULL FILE
 D FIELDS(FILENUM,1501) ; OUTSIDE LINE (what to dial to get one)
 I $$ILCAR D FIELDS(FILENUM,1660.01) ; POSTAGE CPT
 I $$ILCAR D FIELDS(FILENUM,1980.01,1980.99) ; STARTUP
 W !
 W "Also included in this report:",!
 I $$ANYINUSE^ABSPOSS8 D
 . W "   A printout of insurance selection rules.",!
 F FILE=9002313.56:-.01:9002313.53 D
 . W "   A printout of file ",FILE,": ",$P(^DIC(FILE,0),U),!
 S FILE=9002313.515 I $$ANY^ABSPOSS2("USERS") D
 . W "   A printout of file ",FILE,": ",$P(^DIC(FILE,0),U),!
 E  D
 . W "   (There are no specific settings for individual users.)",!
 I $$ANYINUSE^ABSPOSS8 D RPTINUSE^ABSPOSS8 ; insurance selection rules
 I $$ANY^ABSPOSS2("GRACE") D TEMPLATE^ABSPOSS2("ABSP GRACE")
 I $$ANY^ABSPOSS2("PREBILL") D TEMPLATE^ABSPOSS2("ABSP PREBILL")
 I $$ANY^ABSPOSS2("NCPDP") D TEMPLATE^ABSPOSS2("ABSP NCPDP")
 I $$ANY^ABSPOSS2("UN/BILLABLE") D TEMPLATE^ABSPOSS2("ABSP UN/BILLABLE")
 I $$ANY^ABSPOSS2("WCOMP") D TEMPLATE^ABSPOSS2("ABSP WORKERS COMP")
 D PHARMACY^ABSPOSS6 ; 9002313.56 PHARMACIES
 D ABSPOSS1^ABSPOSS5 ; 9002313.55 DIAL OUT
 D ABSPOSS1^ABSPOSS4 ; 9002313.54 MODEM TYPES
 D ABSPOSS1^ABSPOSS3 ; 9002313.53 PRICING
 I $$ANY^ABSPOSS2("USERS") D ABSPOSS1^ABSPOSS6 ; 9002313.515 USER SETS
 D INUSE^ABSPOSS2 ; 9002313.4 ABSP INSURERs set up for e-claims
 Q
FIELDS(FILENUM,LOW,HIGH)     ;
 I '$D(HIGH) S HIGH=LOW
 N IENS S IENS=$O(@REF@(FILENUM,""))
 I IENS="" D  Q
 . W "<no entries>",!
 N ONLYONE S ONLYONE=($O(@REF@(FILENUM,IENS))="")
 F  D  S IENS=$O(@REF@(FILENUM,IENS)) Q:IENS=""
 . N F S F=LOW
 . I '$D(^DD(FILENUM,F)) S F=$O(^DD(FILENUM,F)) ; be sure 1st one's def
 . I 'F D  Q  ; no fields in this range?
 . . W "<no fields in file ",FILENUM," range ",LOW,"-",HIGH," ?!>",!
 . F  D  S F=$O(^DD(FILENUM,F)) Q:F>HIGH!'F
 . . N FNAME I $D(^DD(FILENUM,F,0)) S FNAME=$P(^(0),U)
 . . E  S FNAME="<field #"_F_" undefined?!>"
 . . N IVALUE S IVALUE=$G(@REF@(FILENUM,IENS,F,"I"))
 . . N EVALUE S EVALUE=$G(@REF@(FILENUM,IENS,F,"E"))
 . . I 'ONLYONE W IENS," "
 . . I ONLYONE,F=.01  ; don't print field number & name if only .01
 . . E  D
 . . . N X,Y S X=$J(F\1,5),Y=F#1 I 'Y S Y=""
 . . . F  Q:$L(Y)'<3  S Y=Y_" "
 . . . W X,Y," "
 . . . W FNAME,": "
 . . W IVALUE
 . . I IVALUE'=EVALUE W " (",EVALUE,")"
 . . W !
 Q
