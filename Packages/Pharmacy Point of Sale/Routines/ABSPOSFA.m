ABSPOSFA ; IHS/FCS/DRS - Print NCPDP claim ;   [ 09/12/2002  10:08 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;
 ; This is the main routine for printing NCPDP forms.
 ;
 ; First, it calls ABSPOSFB (which calls ABSPOSFC, ABSPOSFD)
 ;   to build an ABSP() array, just like is done for live claims.
 ; Then, it calls ABSPOS__ to do the actual printing.
 ;
 Q
SORT ;EP - from ABSPOSF - Sort prescriptions into
 ; input: ^TMP("ABSPOSF",$J,1,ien57)="" or = insien
 ; output:
 ;   ^TMP("ABSPOSF",$J,2,inskey)=insien^name^address^^city^state^zip
 ;   ^TMP("ABSPOSF",$J,2,inskey,patkey,pharm,visitien,ien57)=""
 W !,"Sorting..."
 N IEN57 S IEN57=0
 F  S IEN57=$O(^TMP("ABSPOSF",$J,1,IEN57)) Q:'IEN57  D
 . N INSNAME,INSIEN,PATIEN,PATNAME,PHARM,VISIT,INSKEY,PATKEY
 . I '$D(^ABSPTL(IEN57)) Q  ; transaction record disappeared?!
 . ;
 . ; Insurance information:
 . ;
 . S INSIEN=^TMP("ABSPOSF",$J,1,IEN57)
 . N PCNDFN S PCNDFN=$P(^ABSPTL(IEN57,0),U,3) ; posted to ILC A/R?
 . I PCNDFN S INSIEN=$$ILCINS^ABSPOSF(PCNDFN) ; use ILC insurer instead
 . I 'INSIEN S INSIEN=$P(^ABSPTL(IEN57,1),U,6)
 . I 'INSIEN S INSIEN=0,INSNAME="ZZZZZ NO INSURANCE"
 . E  S INSNAME=$P(^AUTNINS(INSIEN,0),U)
 . S INSKEY=$E(INSNAME,1,20)_"#"_INSIEN
 . I '$D(^TMP("ABSPOSF",$J,2,INSKEY)) D
 . . N INSADDR,INSCITY,INSSTATE,INSZIP
 . . I $$UNINS^ABSPOSF(INSNAME) D  Q  ; Bill these on statements? 
 . . . S INSNAME="ZZZZZ NO INSURANCE"
 . . . S (INSADDR,INSCITY,INSSTATE,INSZIP)=""
 . . S INSADDR=$P(^AUTNINS(INSIEN,0),U,2)
 . . S INSCITY=$P(^AUTNINS(INSIEN,0),U,3)
 . . S INSSTATE=$P(^AUTNINS(INSIEN,0),U,4)
 . . I INSSTATE S INSSTATE=$P(^DIC(5,INSSTATE,0),U,2)
 . . S INSZIP=$P(^AUTNINS(INSIEN,0),U,5)
 . . S ^TMP("ABSPOSF",$J,2,INSKEY)=INSIEN_U_INSNAME_U_INSADDR_U_U_INSCITY_U_INSSTATE_U_INSZIP
 . S PATIEN=$P(^ABSPTL(IEN57,0),U,6)
 . S PATNAME=$P(^DPT(PATIEN,0),U)
 . S VISIT=+$P(^ABSPTL(IEN57,0),U,7)
 . S PHARM=+$P(^ABSPTL(IEN57,1),U,7)
 . S PATKEY=$E(PATNAME,1,20)_"#"_PATIEN
 . S ^TMP("ABSPOSF",$J,2,INSKEY,PATKEY,PHARM,VISIT,IEN57)=""
 W !
 Q
PRINT ; EP - from ABSPOSF 
 W !,"Print on which device?",!
 N POP D ^%ZIS Q:$G(POP)
 U IO
 ;
 ; Build array TRANSACT(ien)=""
 ; of pointers to 9002313.57
 ; for the transactions for which to print forms.
 ;
 ; then for each pair, D PRINT^ABSPOSFP
 N INSNAME,PATNAME,PHARM,VISITIEN,IEN57
 S INSNAME=""
 F  S INSNAME=$O(^TMP("ABSPOSF",$J,2,INSNAME)) Q:INSNAME=""  D
 . Q:INSFIRST]INSNAME  ; EPILC needs this test here
 . I '$$TOSCREEN^ABSPOSU5 D
 . . U $P
 . . W "Printing for ",INSNAME,!
 . . U IO
 . S PATNAME=""
 . F  S PATNAME=$O(^TMP("ABSPOSF",$J,2,INSNAME,PATNAME)) Q:PATNAME=""  D
 . . S PHARM=""
 . . F  S PHARM=$O(^TMP("ABSPOSF",$J,2,INSNAME,PATNAME,PHARM)) Q:PHARM=""  D
 . . .  D VISITS
 D ^%ZISC
 Q
VISITS ; at ^TMP("ABSPOSF",$J,2,INSNAME,PATNAME,PHARM)
 S VISITIEN=""
 F  S VISITIEN=$O(^TMP("ABSPOSF",$J,2,INSNAME,PATNAME,PHARM,VISITIEN)) Q:VISITIEN=""  D
 . N TRANSACT
 . M TRANSACT=^TMP("ABSPOSF",$J,2,INSNAME,PATNAME,PHARM,VISITIEN)
 . D PRINTV(^TMP("ABSPOSF",$J,2,INSNAME))
 Q
PRINTV(INSINFO) ; we have TRANSACT(ien57)="" for a bunch of prescriptions
 ; INSINFO=INSIEN^NAME^ADDR 1^ADDR 2^CITY^STATE^ZIP
 N ABSP,NCPDP
 Q:$$ABSP^ABSPOSFB'=0  ; builds ABSP() array for these transactions
 ; augment ABSP() with insurance name and address
 S ABSP("Insurer","Name")=$P(INSINFO,U,2)
 S ABSP("Insurer","Addr 1")=$P(INSINFO,U,3)
 S ABSP("Insurer","Addr 2")=$P(INSINFO,U,4)
 S ABSP("Insurer","City")=$P(INSINFO,U,5)
 S ABSP("Insurer","State")=$P(INSINFO,U,6)
 S ABSP("Insurer","Zip")=$P(INSINFO,U,7)
 D NCPDP ; builds NCPDP() array ; with overrides as appropriate
 ;      NCPDP(field #)=value ; NCPDP("RX",rxn,field#)=value
 D PRINT^ABSPOSFP ; output the ABSP(*) and NCPDP(*) arrays onto form(s)
 Q
NCPDP ; Build NCPDP(field #)=value
 ;       NCPDP("RX",rxn,field #)=value
 ; Loop through every NCPDP field and Xecute the "Get" code.
 ; (checking for overrides, in which case the "Get" doesn't happen)
 ; Then store the result in the NCPDP array, as above.
 ; Note that we will have EVERY field defined, even if value is null.
 N RXN,FIELDNUM,FIELDIEN S FIELDNUM=0
 F  S FIELDNUM=$O(^ABSPF(9002313.91,"B",FIELDNUM)) Q:'FIELDNUM  D
 . I FIELDNUM<200 Q  ; BIN, Version, Transaction Code are n/a
 . S FIELDIEN=$O(^ABSPF(9002313.91,"B",FIELDNUM,0))
 . I FIELDNUM<400 D  ; Claim Header field - just once for all
 . . I $D(ABSP("OVERRIDE",FIELDNUM)) D
 . . . S ABSP("X")=ABSP("OVERRIDE",FIELDNUM)
 . . E  D
 . . . D NCPDP1
 . . S NCPDP(FIELDNUM)=ABSP("X")
 . . K ABSP("X")
 . E  D  ; Claim Information field - once per prescription
 . . N RXN S RXN=0
 . . F  S RXN=$O(ABSP("RX",RXN)) Q:'RXN  D
 . . . I $D(ABSP("OVERRIDE","RX",RXN,FIELDNUM)) D
 . . . . S ABSP("X")=ABSP("OVERRIDE","RX",RXN,FIELDNUM)
 . . . E  D
 . . . . S ABSP(9002313.0201)=RXN
 . . . . D NCPDP1
 . . . S NCPDP("RX",RXN,FIELDNUM)=ABSP("X")
 . . K ABSP(9002313.0201),ABSP("X")
 Q
NCPDP1 ;
 N D1 S D1=0,ABSP("X")=""
 F  S D1=$O(^ABSPF(9002313.91,FIELDIEN,10,D1)) Q:'D1  D
 . X ^ABSPF(9002313.91,FIELDIEN,10,D1,0)
 Q  ; with ABSP("X") set up
TEST ; a test - find a bunch of recent transactions 
 ; and set up ^TMP("ABSPOSF",$J,1,IEN57)
 K ^TMP("ABSPOSF",$J)
 N IEN57 S IEN57=$P(^ABSPTL(0),U,3)+1 ; setup for $O in reverse
 N NTRANS S NTRANS=2 ; take two transactions
 F  D  Q:'NTRANS  Q:'IEN57
 . S IEN57=$O(^ABSPTL(IEN57),-1) Q:'IEN57
 . ; don't take ones that went electronic transactions
 . ; (though there's no real reason we couldn't)
 . I $$GET1^DIQ(9002313.57,IEN57_",","RESULT WITH REVERSAL")?1"E ".E Q
 . N INS S INS=$P(^ABSPTL(IEN57,1),U,6)
 . Q:'INS  Q:$$UNINS^ABSPOSF($P(^AUTNINS(INS,0),U))  ;
 . S ^TMP("ABSPOSF",$J,1,IEN57)="",NTRANS=NTRANS-1 ; YES  add to list
 W "Sorting..." D SORT W !
 D
 . W "results of SORT:",!
 . N TMP M TMP=^TMP("ABSPOSF",$J) D ZWRITE^ABSPOS("TMP")
 W "Printing..." W ! D PRINT W ! ; print to current device; capture
 Q
