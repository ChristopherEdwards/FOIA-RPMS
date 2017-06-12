BEHBUSA ; MSC/JS - BUSA Audit for Info Button ;29-Aug-2013 19:42;du
 ;;1.1;BEH COMPONENTS;**054001**;Mar 20, 2007;Build 23
 ;
 ; BUSA audit for MSC rpc CIAVMCFG GETTEMPL
 ; Called from BUSA AUDIT RPC DEFINITION file entry field #.06 ENTRY DESCRIPTION EXECUTABLE (FX), [0;6]
 ;
 ; Searches the content of the layout template looking
 ; for the BEHIPL.IPL, BEHMEDS.MEDMANAGEMENT, and BEHLAB.LABVIEW prog ids.
 ; Stores the result of this search into the BUSA Summary field #1 ENTRY DESCRIPTION using
 ; the following pattern:
 ;
 ;      IPL = <0 or 1>
 ;     MEDS = <0 or 1>
 ;      LAB = <0 or 1>
 ;
 ; where 1 indicates that the prog id is present in the layout template.
 ;
 ;Return template data
BUSACK() ;
 I $G(DUZ)="" Q "-1^DUZ not set"
 S U="^"
 S TMPL=$$GETPAR()
 I $G(TMPL)="" Q "-1^Missing VueCentric Template File IEN"
 S DATA=$$TMPGBL
 M:TMPL @DATA=^CIAVTPL(TMPL,1)
 I $G(@DATA@(0))="" Q "-1^Template Data Not Found"
 NEW IPL,MEDS,LAB
 D PROGID
 K STRING
 S STRING="MSC - "_"IPL="_$G(IPL)_"/"_"MEDS="_$G(MEDS)_"/"_"LAB="_$G(LAB)
 K ^TMP("BEHBUSA",$J)
 K IPL,MEDS,LAB,DATA,TMPL
 Q STRING
 ;
 ;Return template data - interactive
TMCHEK() ;
 I $G(DUZ)="" Q "-1^DUZ not set"
 S U="^"
 S TMPL=$$GETPAR()
 I $G(TMPL)="" Q "-1^Missing VueCentric Template File IEN"
 S DATA=$$TMPGBL
 M:TMPL @DATA=^CIAVTPL(TMPL,1)
 I $G(@DATA@(0))="" Q "-1^Template Data Not Found"
 NEW IPL,MEDS,LAB
 D PROGID
 W !,"IPL VALUE:",?15,IPL
 W !,"MEDS VALUE:",?15,MEDS
 W !,"LAB VALUE:",?15,LAB
 K STRING
 S STRING="MSC - "_"IPL="_$G(IPL)_"/"_"MEDS="_$G(MEDS)_"/"_"LAB="_$G(LAB)
 K ^TMP("BEHBUSA",$J)
 K IPL,MEDS,LAB,DATA,TMPL
 Q STRING
 ;
 ;Return temp global reference
TMPGBL() ;
 NEW GBL
 S GBL=$NA(^TMP("BEHBUSA",$J))
 K @GBL
 Q GBL
 ;
PROGID ; -- Search thru Template for BEHIPL.IPL, BEHMEDS.MEDMANAGEMENT, and BEHLAB.LABVIEW
 ;          0/not present, 1/present
 S (IPL,MEDS,LAB)=0
 NEW A
 S A=""
 F  S A=$O(^TMP("BEHBUSA",$J,A)) Q:A=""  D
 .NEW TMDATA
 .S TMDATA=$G(^TMP("BEHBUSA",$J,A,0))
 .Q:TMDATA=""
 .;
 .;W !!,"TEMPLATE LINE ",A,!?2,TMDATA   <<<< UNCOMMENT TO TEST
 .;
 .I TMDATA["PROGID=""BEHIPL.IPL""" S IPL=1
 .I TMDATA["PROGID=""BEHMEDS.MEDMANAGEMENT""" S MEDS=1
 .I TMDATA["PROGID=""BEHLAB.LABVIEW""" S LAB=1
 Q
 ;
 ;Return user's default template IEN
GETPAR() ;
 S TMPL=$$GET^XPAR("ALL","CIAVM DEFAULT TEMPLATE")
 Q TMPL
