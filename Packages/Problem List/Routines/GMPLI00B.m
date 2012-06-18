GMPLI00B	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	Q:'DIFQ(125.99)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(125.99,0,"GL")
	;;=^GMPL(125.99,
	;;^DIC("B","PROBLEM LIST SITE PARAMETERS",125.99)
	;;=
	;;^DIC(125.99,"%D",0)
	;;=^^4^4^2940517^^^^
	;;^DIC(125.99,"%D",1,0)
	;;=This file controls the behavior of the Problem List application for each
	;;^DIC(125.99,"%D",2,0)
	;;=site where it is installed.
	;;^DIC(125.99,"%D",3,0)
	;;=  
	;;^DIC(125.99,"%D",4,0)
	;;=There should be only one entry in this file!!
	;;^DD(125.99,0)
	;;=FIELD^^.001^6
	;;^DD(125.99,0,"DDA")
	;;=N
	;;^DD(125.99,0,"DT")
	;;=2940310
	;;^DD(125.99,0,"IX","B",125.99,.01)
	;;=
	;;^DD(125.99,0,"NM","PROBLEM LIST SITE PARAMETERS")
	;;=
	;;^DD(125.99,.001,0)
	;;=NUMBER^NJ1,0^^ ^K:+X'=X!(X>1)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(125.99,.001,3)
	;;=Type a Number between 1 and 1, 0 Decimal Digits
	;;^DD(125.99,.001,21,0)
	;;=^^1^1^2940310^
	;;^DD(125.99,.001,21,1,0)
	;;=This is the internal number of this file entry.
	;;^DD(125.99,.001,"DT")
	;;=2940310
	;;^DD(125.99,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!(X?.N)!($L(X)<3)!'(X'?1P.E) X
	;;^DD(125.99,.01,1,0)
	;;=^.1
	;;^DD(125.99,.01,1,1,0)
	;;=125.99^B
	;;^DD(125.99,.01,1,1,1)
	;;=S ^GMPL(125.99,"B",$E(X,1,30),DA)=""
	;;^DD(125.99,.01,1,1,2)
	;;=K ^GMPL(125.99,"B",$E(X,1,30),DA)
	;;^DD(125.99,.01,3)
	;;=NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
	;;^DD(125.99,.01,21,0)
	;;=^^1^1^2930401^
	;;^DD(125.99,.01,21,1,0)
	;;=This is the name of the site, commonly HOSPITAL or VAMC.
	;;^DD(125.99,1,0)
	;;=VERIFY TRANSCRIBED PROBLEMS^S^1:YES;0:NO;^0;2^Q
	;;^DD(125.99,1,3)
	;;=Enter YES to flag transcribed entries for clinician verification.
	;;^DD(125.99,1,21,0)
	;;=^^3^3^2930401^
	;;^DD(125.99,1,21,1,0)
	;;=This is a toggle which determines whether the PL application will
	;;^DD(125.99,1,21,2,0)
	;;=flag entries made by a non-clinical user, and allow for subsequent
	;;^DD(125.99,1,21,3,0)
	;;=confirmation of the entry by a clinician.
	;;^DD(125.99,1,"DT")
	;;=2930324
	;;^DD(125.99,2,0)
	;;=PROMPT FOR CHART COPY^S^1:YES, ASK;0:NO, DON'T ASK;^0;3^Q
	;;^DD(125.99,2,3)
	;;=Enter YES to be prompted to print a new copy before exiting the patient's list, if it has been updated.
	;;^DD(125.99,2,21,0)
	;;=^^4^4^2931102^^
	;;^DD(125.99,2,21,1,0)
	;;=This is a toggle which determines whether the PL application will
	;;^DD(125.99,2,21,2,0)
	;;=prompt the user to print a new chartable copy of the patient's list
	;;^DD(125.99,2,21,3,0)
	;;=when exiting the application or changing patients, if the current
	;;^DD(125.99,2,21,4,0)
	;;=patient's list has been modified.
	;;^DD(125.99,2,"DT")
	;;=2930701
	;;^DD(125.99,3,0)
	;;=USE CLINICAL LEXICON^S^1:YES;0:NO;^0;4^Q
	;;^DD(125.99,3,3)
	;;=Enter YES to allow the user to search the Clinical Lexicon when adding to or editing a problem list; NO will bypass the search, capturing ONLY the free text.
	;;^DD(125.99,3,21,0)
	;;=^^13^13^2931102^
	;;^DD(125.99,3,21,1,0)
	;;=This is a toggle which determines whether the PL application will
	;;^DD(125.99,3,21,2,0)
	;;=allow the user to search the Clinical Lexicon when adding or editing
	;;^DD(125.99,3,21,3,0)
	;;=a problem; if a term is selected from the CL Utility, the standardized
	;;^DD(125.99,3,21,4,0)
	;;=text will be displayed on the problem list, otherwise the text entered
	;;^DD(125.99,3,21,5,0)
	;;=by the user to search on will be displayed.  Problems which are taken
	;;^DD(125.99,3,21,6,0)
	;;=from the CLU may already be coded to ICD9, and this code is returned 
	;;^DD(125.99,3,21,7,0)
	;;=to the PL application if available.  Duplicate problems can be screened
	;;^DD(125.99,3,21,8,0)
	;;=out, and searches by problem performed when this link to the CLU exists.
