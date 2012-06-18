ABSPDB1 ; IHS/OIT/CASSevern/Pieran ran 1/19/2011 - Handling of outgoing NCPDP Billing "B1" and Reversal "B2" Claims for D.0
 ;;1.0;PHARMACY POINT OF SALE;**42**;JUN 21, 2001
 ;
 ; This routine will replace the ABSPOSCF for D.0, so that we no
 ; longer need to use the formats file.
 ; This will go through and get the data for each and every segment and field
 ; format it and place it in the CLAIM file ^ABSPC(CLAIMIEN
 ; The ABSP() Array is already set up in: GETINFO^ABSPOSCC before we get here.
 ;INPUT = ACTION
 ;		  "CLAIMHD" = Set up only the claim header for creating ^ABSPC entry
 ;		  "CLAIMRST" = Set up Rest of Claim info and fill in ^ABSPC entry
 ;		  "OUTHD"	= Create the actual Output HEADER Record
 ;		  "OUTRST"  = Create the actual Output Rest of the Record.
EN(ACTION,MEDN,IEN) ;EP
 N INSARRAY,DO,SPECIAL,SUPRESF
 S RECORD=$G(RECORD)
 I ACTION["CLAIM" D
 . S DO=ABSP("Insurer","IEN")_","
 ELSE  D
 . S DO=IEN("9002313.4")_","
 D GETS^DIQ(9002313.4,DO,"100.15;100.16;100.17;200.01;210*;215*;220*","","INSARRAY")
 I $D(INSARRAY(9002313.42)) D SETSPEC
 I $D(INSARRAY(9002313.48)) D SETSUPRSG
 I $D(INSARRAY(9002313.46)) D SETSUPRF
 D CHECKOVER^ABSPDB1F(D0,.SPECIAL) ;Check for Manual Over-Rides for this Claim
 D CHKDUROVR^ABSPDB1F(D0,.SPECIAL) ;Don't forget the DUR over-rides
 D CHKDIAGOVR^ABSPDB1F(D0,.SPECIAL) ;Don't forget the DUR over-rides
 I $D(SPECIAL) D ADDSEG^ABSPDB1F(.SPECIAL,.ADDSEG) ;Figure out based on Special fields which segments we need
 I (ACTION="CLAIMHD")!(ACTION="OUTHD") D
 . D HEADER^ABSPDB1G ;Every time
 . D INSURANCE^ABSPDB1G ;Every time
 . D PATIENT^ABSPDB1G ;Every time
 I (ACTION="CLAIMRST")!(ACTION="OUTRST") D
 . I +$G(IEN(9002313.01))=0 S IEN(9002313.01)=1
 . D CLAIM^ABSPDB1A ;Every time
 . D PRICING^ABSPDB1B ;Pretty much every time
 . I $D(ADDSEG("PROVIDER")) D PROVIDER^ABSPDB1B ;Almost never (Currently 2 formats)
 . D PRESCRIBER^ABSPDB1B ;Pretty much every time
 . I $D(ADDSEG("COB")) D COB^ABSPDB1C ;Not Currently implemented
 . I $D(ADDSEG("WORKCOMP")) D WORKCOMP^ABSPDB1C ;Not Currently implemented
 . I $D(ADDSEG("DURRPPS")) D DURRPPS^ABSPDB1D ;Very common...but for over-rides only
 . I $D(ADDSEG("COUPON")) D COUPON^ABSPDB1D ;Not Currently implemented
 . I $D(ADDSEG("COMPOUND")) D COMPOUND^ABSPDB1D ;Not currently implemented
 . I $D(ADDSEG("CLINICAL")) D CLINICAL^ABSPDB1D ;Fairly rarely  (Currently 57 formats for Over-ride only)
 . I $D(ADDSEG("ADDOC")) D ADDDOC^ABSPDB1E ;Not Currently implemented
 . I $D(ADDSEG("FACILITY")) D FACILITY^ABSPDB1E ;Not Currently implemented
 . I $D(ADDSEG("NARRATIVE")) D NARRATIVE^ABSPDB1E ;Not Currently implemented
 Q
SETSPEC ;SET UP SPECIAL CODE ARRAY HERE.
 N D1,NCODE,MUMPS
 S D1=""
 F  S D1=$O(INSARRAY(9002313.42,D1)) Q:D1=""  D
 . S NCODE=$G(INSARRAY(9002313.42,D1,.01))
 . S MUMPS=$G(INSARRAY(9002313.42,D1,.02))
 . S:MUMPS["ABSP(""X"")" MUMPS=$TR(MUMPS,"|","^") ;If we stripped out caret (^) during conversion....put back in here
 . I MUMPS'["ABSP(""X"")" S MUMPS="S ABSP(""X"")="""_MUMPS_""""
 . S SPECIAL(NCODE)=MUMPS
 Q
SETSUPRSG ;SET UP SUPPRESS SEGMENT ARRAY HERE.
 N D1,SCODE
 S D1=""
 F  S D1=$O(INSARRAY(9002313.48,D1)) Q:D1=""  D
 . S SCODE=$G(INSARRAY(9002313.48,D1,.01))
 . S SUPRESSG(SCODE)=""
 Q
SETSUPRF ;SET UP SUPPRESS FIELD CODE ARRAY HERE.
 N D1,SCODE
 S D1=""
 F  S D1=$O(INSARRAY(9002313.46,D1)) Q:D1=""  D
 . S SCODE=$G(INSARRAY(9002313.46,D1,.01))
 . S SUPRESF(SCODE)=""
 Q
