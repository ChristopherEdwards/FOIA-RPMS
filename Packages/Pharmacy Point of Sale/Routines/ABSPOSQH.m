ABSPOSQH ; IHS/FCS/DRS - JWS 10:46 AM 7 Jan 1997 ;
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 ;prepare claims for transmission (eg assemble into ASCII record format)
 ; Called from ABSPOSQG, usually from ABSPOSQ2
 ; Also used by certification, called from ABSPOSC2
 ;
 ; You have CLAIMIEN(*), array of pointers to 9002313.02 claims
 ;
 ;Creates the following scratch global:
 ;   ^ABSPECX($J,"C",0) = <number of claims>
 ;   ^ABSPECX($J,"C",CLAIMIEN,0) = <number of nodes>
 ;   ^ABSPECX($J,"C",CLAIMIEN,1) = <ASCII record 1-245 chars>
 ;   ^ABSPECX($J,"C",CLAIMIEN,2) = <ASCII record 246-490 chars>
 ;                            N) = <..........................>
 ;----------------------------------------------------------------------
PASCII(DIALOUT) ;EP - from ABSPOSQG
 ;Manage local variables
 N AREC,COUNT
 S COUNT=0
 ;
 K ^ABSPECX($J,"C")
 ;
 ; Coming into this, ABS????? has 
 ; set up CLAIMIEN(*) = a list of CLAIMIENs that were generated from
 ; all the prescriptions that might have been bundled together.
 ; So we must loop through that list.
 S CLAIMIEN=""
 F  S CLAIMIEN=$O(CLAIMIEN(CLAIMIEN)) Q:CLAIMIEN=""  D PASCII1
 Q
 ;
PASCII1 ;EP - from above and also ABSPOSC2 ;
 ; Assemble NCPDP Ascii formatted record
 S AREC=$$ASCII^ABSPECA1(CLAIMIEN)
 Q:AREC=""
 ;
 ;Store NCPDP Ascii formatted record in ^ABSPECX($J,"C",CLAIMIEN,..)
 ;transmission scratch global
 N PREFIX S PREFIX=$P($G(^ABSP(9002313.55,DIALOUT,"NDC")),U,2)
 ; If test mode for NDC, then change that prefix from HN* to HN.
 ; (Actually, I don't understand when or where that test mode really
 ;  means anything.)
 D SVEAREC^ABSPECX4(PREFIX_AREC,CLAIMIEN,"C") ;production mode
 ;
 ; And save a copy of the original transmitted record in
 ; ^ABSPC(CLAIMIEN,"M")
 N WP,I F I=1:100:$L(AREC) S WP(I/100+1,0)=$E(AREC,I,I+99)
 D WP^DIE(9002313.02,CLAIMIEN_",",9999,"","WP")
 ;
 ;Increment claim counter
 S COUNT=COUNT+1
 ;
 ;S ^ABSPECX($J,"C",0)=COUNT
 Q
