ABSPOSMA ; IHS/FCS/DRS - General Inquiry/Report .57; [ 08/28/2002  3:01 PM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 Q
 ; General inquiry and reporting on the Transaction File, 9002313.57.
 ; First menu selection determines whether you're doing an inquiry
 ;   or a report.
 ; Second menu selection determines how to select transactions.
 ; If you're doing an inquiry, do the search only.  Then display
 ;  a list of the claims.  Select one or more and then you get the
 ;  prompt for what kind of output to generate.
 ; Third menu selection determines what kind of output to generate.
 ;  You get this right away if you're operating in report mode.
 ;
 ; Primary sort is always by date/time, usually transaction date/time.
 ; If sorting by released date  (date only, can't do it by time),
 ;   for efficiency, pre-scan 9002313.61 Report Master file and 
 ;   determine a range of transaction date/time to search by.
 ;
 ; Transaction date/time means the LAST UPDATE field.
 ;
 ; Local array ABSPOSMA() contains the parameters:
 ; ABSPOSMA("BY WHICH DATE")="TRANSACTION" or "RELEASED"
 ; ABSPOSMA("MODE")="INQUIRY" or "REPORT"
 ; ABSPOSMA("SORT",7,"FR")=transaction date/time, start value
 ; ABSPOSMA("SORT",7,"TO")=transaction date/time, to value
 ;   Released date/time - 9999.95 - is applicable 
 ;   only if ABSPOSMA("BY WHICH DATE")="RELEASED"
 ; ABSPOSMA("SORT",9999.95,"FR")=released date/time, start value
 ; ABSPOSMA("SORT",9999.95,"TO")=released date/time, to value
 ;   Other sort fields are always field name, not field number.
 ;   This way, you can $O(ABSPOSMA("SORT"," ")) to find out
 ;   what kind of a sort is being done.
 ; ABSPOSMA("SORT",field name,"FR")=other field sort, start value
 ; ABSPOSMA("SORT",field name,"TO")=other field sort, to value
 ; 
 ; ABSPOSMA("SCREEN",n)=screens, to be copied to DIS(n)
 ; ABSPOSMA("OUTPUT TYPE")=see list of codes in ABSPOSMZ
 ;
 ;-----------------------------------------------------------
 ;IHS/SD/lwj 8/28/02 Cache cannot handle a reverse $O of an 
 ; array, so the logic used to retrieve the last entry in 
 ; ABSPOSMA("SCREEN") had to be altered somewhat. (subroutine
 ;  ADDSCREE
 ;-----------------------------------------------------------
 ;
INIT ; EP - init ABSPOSMA
 ; Nice idea for future - retain settings on user-by-user basis
 K ABSPOSMA
 S ABSPOSMA("BY WHICH DATE")="TRANSACTION"
 S (ABSPOSMA("SORT",7,"FR"),ABSPOSMA("SORT",7,"TO"))="?"
 S ABSPOSMA("MODE")="INQUIRY"
 S ABSPOSMA("OUTPUT TYPE")=$$DEFOUT^ABSPOSMZ
 S ABSPOSMA("SCREEN",0)="I $D(^ABSPECX(""RPT"",""AE"",D0))" ; only the most recent transaction for any one given presc. ; 1" ; easier to fill in a dummy here
 Q
KILLSORT ; EP - kill all sort fields except the date/time ones
 N A S A=0 F  S A=$O(ABSPOSMA("SORT",A)) Q:A=""  D
 . Q:A=7  Q:A=9999.95&(ABSPOSMA("BY WHICH DATE"))="RELEASED"
 . K ABSPOSMA("SORT",A)
 Q
ADDSCREE(X) ; store the screen, xecutable code stored in X
 ;IHS/SD/lwj 8/28/02 Cache cannot do a reverse $O on an array
 ; so we had to change the logic used to retrieve the last
 ; array entry in ABSPOSMA - nxt line remarked out and 
 ; the two following were added
 ;S ABSPOSMA("SCREEN",$O(ABSPOSMA("SCREEN",""),-1)+1)=X Q
 N ABSPL,ABSPLST
 S ABSPL=""
 F  S ABSPL=$O(ABSPOSMA("SCREEN",ABSPL)) Q:ABSPL=""  S ABSPLST=ABSPL
 S ABSPOSMA("SCREEN",ABSPLST+1)=X Q
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; Handling for each of the ABSP INQUIRY options
 ; Each of these does the following:
 ;     D INIT ; init ABSPOSMA()
 ;     ; then its own specific setup
 ;     G JOIN
 ; And at JOIN, then all go to JOIN^ABSPOSMB
 ; Eventually, EN1^DIP will do all the work for us, 
 ; both sorting and printing.
JOIN G JOIN^ABSPOSMB
 ;
PHARM ; EP - Option ABSP INQUIRY BY PHARMACY
 D INIT
 N PHARM S PHARM=$$ASKPHARM^ABSPOSMZ
 Q:'PHARM
 S ABSPOSMA("SORT","PHARMACY","FR")=$P(^ABSP(9002313.56,PHARM,0),U)
 S ABSPOSMA("SORT","PHARMACY","TO")=$P(^ABSP(9002313.56,PHARM,0),U)
 Q
PATIENT ; EP - Option ABSP INQUIRY BY PATIENT
 ; Select a list of patients.
 ; Build screens corresponding to the list (i.e., it's not a sort item)
 ; I $P(^ABSPTL(D0,0),U,6)=patient ien
 D INIT
 N PAT F  S PAT=$$ASKPAT^ABSPOSMZ Q:'PAT  D
 . D ADDSCREE("I $P(^ABSPTL(D0,0),U,6)="_PAT)
 G JOIN
RESTYPE ; EP - Option ABSP INQUIRY BY RESULT TYPE
 ; Select from the entries in file 9002313.83
 ; Build screens corresponding to the list (i.e., it's not a sort item)
 D INIT
 N R F  S R=$$ASKRTYPE^ABSPOSMZ Q:R=""  D
 . D ADDSCREE("I $$GET1^DIQ(9002313.57,D0_"","",""RESULT WITH REVERSAL"")="""_R_"""")
 G JOIN
CLAIMID ; EP - Option ABSP INQUIRY BY CLAIM ID
 ; A sort criterion.  Prompt for FR and TO.
 ; Lookup on file 9002313.02 now?
 D INIT
 D KILLSORT
 S ABSPOSMA("SORT","CLAIM:Claim ID","FR")="?"
 S ABSPOSMA("SORT","CLAIM:Claim ID","TO")="?"
 G JOIN
INSURER ; EP - Option ABSP INQUIRY BY INSURER
 D INIT
 S ABSPOSMA("SORT","INSURER","FR")="?"
 S ABSPOSMA("SORT","INSURER","TO")="?"
 G JOIN
NDC ; EP - Option ABSP INQUIRY BY NDC NUMBER
 D INIT
 W !,"When prompted for NDC number, use the 11-digit form "
 W "with no hyphens.",! H 2
 S ABSPOSMA("SORT","ABSBNDC","FR")="?"
 S ABSPOSMA("SORT","ABSBNDC","TO")="?"
 G JOIN
PRICE ; EP - Option ABSP INQUIRY BY PRICE
 D INIT
 S ABSPOSMA("SORT","TOTAL PRICE","FR")="?"
 S ABSPOSMA("SORT","TOTAL PRICE","TO")="?"
 G JOIN
FM ; EP - Option ABSP INQUIRY BY FILEMAN
 ; we will leave the BY undefined
 D INIT
 K ABSPOSMA("SORT")
 G JOIN
ONLY ; EP - Option ABSP INQUIRY BY DATE ONLY
 D INIT
 D KILLSORT
 G JOIN
TEST D ONLY Q
