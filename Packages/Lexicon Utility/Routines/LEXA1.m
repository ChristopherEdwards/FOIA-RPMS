LEXA1 ;ISA/CJE-Lexicon Look-up (Loud) ;01-13-00
 ;;2.0;LEXICON UTILITY;**3,4,6,11,15**;Sep 23, 1996
 ; CJE; Force quit when user enters '^' at search prompt.
 ; JPK; Display code attached to a selected term
 ;
EN ; Initialize
 D:$D(XRTL) T0^%ZOSV K LEX S LEXQ=0
 ;-------------------------------------------------------------
 ;
 ;
 ; LEXSUB  Special variable from version 1.0 specifying the
 ;         vocabulary subset to use during the search.  It is
 ;         a three character mnemonic taken from the Subset
 ;         Definition file #757.2.  The default is "WRD"
 ;
 S:'$L($G(LEXSUB)) LEXSUB="WRD"
 ;
 ; LEXAP   Special variable from version 1.0 specifying the
 ;         application using the Lexicon.  It is a pointer
 ;         value to the Subset Definition file #757.2.
 ;         The default is 1 (Lexicon)
 ;
 S:'$L($G(LEXAP))&($L($G(^TMP("LEXSCH",$J,"APP",0)))) LEXAP=^TMP("LEXSCH",$J,"APP",0)
 S:'$L($G(LEXAP)) LEXAP=1
 ;
 ; LEXLL  Special variable (new) specifying the length of the
 ;        displayable list the user is to select from.  Default
 ;        is 5 (display 5 at a time until the entire list has 
 ;        been reviewed)
 ;
 S:'$L($G(LEXLL)) LEXLL=5
 ;
 ; Check the DIC variables new LEXUR "user response"
 N LEXDICA,LEXDICB D CHK N LEXUR
 ;
 ; Save the value of X if "Ask" is not specified in DIC(0)
 ;
 I DIC(0)'["A",$L($G(X)) S LEXSAVE=X K X
 ;
 ; Save the prompt
 ;
 I $L($G(DIC("A"))) S LEXDICA=DIC("A")
 ;
 ; Continue to lookup until the dialog with the application 
 ; ends.  If there is nothing to lookup (X="") or an uparrow
 ; is detected, the Lexicon shuts down killing LEX.
 ;
 F  D LK Q:'$D(LEX)!($D(LEX("SEL")))
 ;
 G EXIT
 ;-------------------------------------------------------------
LK ; Start Look-up
 ; X not provided
 D:'$D(LEXSAVE) ASK
 ; X provided
 S:$D(LEXSAVE) X=LEXSAVE K LEXSAVE
 ; X was null with a default provided
 S:$D(DIC("B"))&($G(X)="") X=DIC("B")
 ; Lookup X
 ;W:$L(X)&(X'["^")&($E(X,1)'=" ") !,"Searching for ",X  ; PCH 4 - Do not display X
 D LOOK^LEXA(X,LEXAP,LEXLL) K DIC("B")
 ;
 ;--------------------------------------------------------------------
NOTFND ; PCH 3
 ;
 ; If X was not found
 ;
 ;    Write "??"
 ;
 ;    If the calling application uses Unresolved Narratives
 ;        Prompt to "accept or reject" the narrative
 ;        If no selection is made continue the search
 ;
 ;    If the calling application does not use Unresolved Narratives
 ;        Display help
 ;        Re-prompt
 ;        Continue search
 ;
 I '$D(LEX("LIST")),+($G(LEX))=0,$L(X),X'["^",$E(X,1)'=" " D  I '$D(LEX("SEL")) K LEX S LEX=0 Q
 . K DIC("B"),LEX("SEL")
 . I +($G(^TMP("LEXSCH",$J,"UNR",0)))=0 W "  ??" D:$D(LEX("HLP")) DH^LEXA3 W ! Q
 . I +($G(^TMP("LEXSCH",$J,"UNR",0)))=1 W "  ??" D EN^LEXA4 W !
 ;
 ;--------------------------------------------------------------------
FOUND ; PCH 3
 ;
 ; If X was found
 ;
 ;    Begin user selection
 ;
 ;    Continue to display the list until the dialog with the
 ;    user is terminated.  The dialog with the user is 
 ;    considered to be terminated if:
 ;
 ;       the selection list does not exist    '$D(LEX("LIST"))
 ;
 ;       or the user has made a selection     $D(LEX("SEL")
 ; 
 I $D(LEX("LIST")) F  Q:+($G(LEX))=0  D SELECT^LEXA2
 Q:$D(LEX("SEL"))
 I '$L($G(LEX)) K LEX Q  ;PCH 6 quit if LEX=""
 I $L($G(LEX)),'$D(LEX("SEL")),$D(^TMP("LEXSCH",$J)) D
 . D EN^LEXA4 S:'$D(LEX("SEL")) LEX=0  ; PCH 6 rebuild list if no SEL
 ;
 Q
EXIT ; Kill variables
 S:$D(XRT0) XRTN=$T(+0) D:$D(XRT0) T1^%ZOSV
 S:$L($G(LEXDICA)) DIC("A")=LEXDICA S:$L($G(LEXDICB)) DIC("B")=LEXDICB
 ; Set Y, Y(0,0) Y(1) from LEX("SEL")
 S:'$D(LEX("SEL","EXP",1)) Y=-1 K Y(1)
 I $D(LEX("SEL","EXP",1)) S Y=LEX("SEL","EXP",1) D Y1,SSBR S:DIC(0)["Z" Y(0)=^LEX(757.01,+(LEX("SEL","EXP",1)),0),Y(0,0)=$P(^LEX(757.01,+(LEX("SEL","EXP",1)),0),"^",1)
 K LEX,LEXSUB,LEXAP,LEXLL
 K ^TMP("LEXSCH",$J),^TMP("LEXFND",$J),^TMP("LEXHIT",$J)
 Q
Y1 ; ICD in Y(1)
 N LEXVAS S LEXVAS=0,Y(1)=""
 F  S LEXVAS=$O(LEX("SEL","VAS","B",80,LEXVAS)) Q:+LEXVAS=0!(Y(1)'="")  D
 . S Y(1)=$P($G(LEX("SEL","VAS",LEXVAS)),"^",3)
 K:Y(1)="" Y(1)
 I $D(Y(1)) D
 .W !!,">>>  Code  :  "
 .I $D(IOINHI)&($D(IOINORM)) W IOINHI,Y(1),IOINORM,! Q 
 .W Y(1),!
 Q
ASK ; Get user input
 N DIR,DIRUT,DIROUT S:$L($G(LEXDICA)) DIC("A")=LEXDICA
 S DIR("A")=DIC("A") W:'$L($G(X))&('$L($G(LEXDICB))) !
 I '$L($G(X)),$L($G(LEXDICB)) S DIR("B")=LEXDICB
 S DIR("?")="    "_$$SQ^LEXHLP  ; PCH 11
 S DIR("??")="^D INPHLP^LEXA1" N Y S DIR(0)="FAO^0:245" K X
 D ^DIR
 K DIC("B") D:$E(X,1)=" " RSBR
 W:$E(X,1)'=" " !   ; PCH 4
 F  Q:$E(X,1)'=" "  S X=$E(X,2,$L(X))
 W:$D(DTOUT) !,"Try later.",!
 ; If '^' typed or read timed out, set X="" to force quit.
 I $D(DTOUT)!(X="^") S X=""
 S:X[U DUOUT=1 K DIRUT,DIROUT Q
INPHLP ; Look-up help  PCH 11
 N X S X="" S:$L($G(DIR("?"))) X=$G(DIR("?")) S:'$L(X) X="    "_$$SQ^LEXHLP
 W:$L(X) !!,X,!
 W !,"    Best results occur using one to three full or partial words without"
 W !,"    a suffix (i.e., ""DIABETES"",""DIAB MELL"",""DIAB MELL INSUL"") or"
 W !,"    a classification code (ICD, CPT, HCPCS, etc)"
 Q
CLR K ^TMP("LEXSCH",$J),^TMP("LEXHIT",$J),^TMP("LEXFND",$J) Q
CHK ; Check Fileman look-up variables
 K DIC("DR"),DIC("P"),DIC("V"),DLAYGO,DINUM
 S:$L($G(X)) LEXSAVE=X S:$L($G(DIC("B"))) LEXDICB=DIC("B") K DIC("B")
 I $L($G(DIC(0))) D
 . F  Q:DIC(0)'["L"  S DIC(0)=$P(DIC(0),"L",1)_$P(DIC(0),"L",2)
 . F  Q:DIC(0)'["I"  S DIC(0)=$P(DIC(0),"I",1)_$P(DIC(0),"I",2)
 S:'$L($G(DIC(0))) DIC(0)="QEAMF" S:'$L($G(DIC)) DIC="^LEX(757.01,"
 S:DIC(0)'["F" DIC(0)=DIC(0)_"F" S:'$L($G(DIC("A"))) DIC("A")="Enter Term/Concept:  "
 S LEXDICA=DIC("A")
 Q
SSBR ; Store data for Space Bar Return
 ; PCH 3 discontinue saving unresolved narrative
 Q:'$L($G(DUZ))  Q:+($G(DUZ))=0  Q:'$L($G(DIC))  Q:$G(DIC)'["757.01,"
 Q:$G(DIC(0))'["F"  Q:+($G(Y))'>2  Q:$E($G(X),1)=" "  S ^DISV(DUZ,DIC)=+($G(Y))
 Q
RSBR ; Retrieve onSpace Bar Return
 ; PCH 3 discontinue retrieving unresolved narrative
 Q:'$L($G(DUZ))  Q:$G(DIC)'="^LEX(757.01,"  Q:$G(DIC(0))'["F"
 Q:$E($G(X),1)'=" "  S:+($G(^DISV(DUZ,DIC)))>2 X=@(DIC_+($G(^DISV(DUZ,DIC)))_",0)")
 Q
