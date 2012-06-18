TIULA ; SLC/JER - Interactive Library functions ;04:32 PM  27 Oct 1999
 ;;1.0;TEXT INTEGRATION UTILITIES;**79**;Jun 20, 1997
PATIENT(TIUSSN) ; Select a patient
 N X,DIC,Y S:$G(TIUSSN)]"" X=TIUSSN
 S DIC=2,DIC(0)=$S($G(TIUSSN)']"":"AEMQ",1:"MX") D ^DIC
 Q Y
SELSTAT(Y,PARM,DEF) ; Select Signature status
 N I,XQORM,X,TIUY
 S XQORM=+$O(^ORD(101,"B","TIU STATUS MENU",0))_";ORD(101,"
 I +XQORM'>0 W !,"Status selection unavailable." S TIUY=-1 G STATX
 S XQORM(0)=$G(PARM),XQORM("A")="Select Status: "
 I $S(PARM="F":1,PARM="R":1,1:0) S X=DEF
 S XQORM("B")=DEF D ^XQORM
 S TIUY=$G(Y)
 I +$G(Y)=1,(+$G(Y(1))=7) S Y=2,Y(2)="8^4843^amended^8"
STATX Q TIUY
SELSCRN(DEF) ; Select Review Screen
 N DIC,XQORM,X
 S DIC=101,DIC(0)="X",X="TIU REVIEW SCREEN MENU" D ^DIC
 I +Y>0 D
 . S XQORM=+Y_";ORD(101,",XQORM(0)="1A",XQORM("A")="Select Category: "
 . S XQORM("S")="I 1 X:$D(^ORD(101,+$P(^ORD(101,DA(1),10,DA,0),U),24)) ^(24)"
 . S XQORM("B")=DEF D ^XQORM
 . I +Y,($D(Y)>9) D
 . . S Y=$S(Y(1)["Author":"AAU",Y(1)["Patient":"APT",Y(1)["Spec":"ATS",Y(1)["Transcrip":"ATC",Y(1)["All":"ALL",Y(1)["Subject":"ASUB",Y(1)["Service":"ASVC",Y(1)["Location":"ALOC",1:"")
 . . I +$G(Y(1))'>0,(X'="^^"),(X'="^") D  Q
 . . . W !,"^^-jumps not allowed from this prompt." S Y=-1
 . . S:Y'="ALL" Y=Y_U_$$SELPAR(Y)
 . . S:Y="ALL" Y=Y_U_"ANY"
 Q Y
SELPAR(DEF) ; Select an author or patient or... 
 N DIC,X,Y
 I DEF="ASUB" S Y=$$ASKSUBJ^TIULA1 G SELPARX
 S DIC=$S(DEF="APT":2,DEF="ATS":45.7,DEF="ASVC":123.5,1:200)
 S DIC(0)="AEMQ"
 S DIC("A")="Select "_$S(DEF="APT":"PATIENT",DEF="AAU":"AUTHOR",DEF="ATS":"TREATING SPECIALTY",DEF="ATC":"TRANSCRIPTIONIST",DEF="ASVC":"SERVICE",1:"ATTENDING PHYSICIAN")_": "
 I DEF="ARP" S DIC("S")="I $$ISA^USRLA(+$G(Y),""PROVIDER"")"
 D ^DIC K DIC("S") I +Y>0 D
 . I $S(DEF="APT"&'$D(^TIU(8925,"C",+Y)):1,DEF="AAU"&'$D(^TIU(8925,"CA",+Y)):1,DEF="ARP"&'$D(^TIU(8925,"CR",+Y)):1,1:0) W !,"No entries for ",$P(Y,U,2) S Y=0
SELPARX Q Y
EDATE(PRMPT,STATUS,DFLT) ; Get early date
 N X,Y,TIUPRMT,TIUDFLT
 I $G(STATUS)=4 S Y=1 Q Y
 S TIUPRMT=" Start "_$S($L($G(PRMPT)):PRMPT_" ",1:"")_"Date [Time]: "
 S TIUDFLT=$S($L($G(DFLT)):DFLT,1:"T-30")
 S Y=$$READ^TIUU("DOA^::AET",TIUPRMT,TIUDFLT)
 Q Y
LDATE(PRMPT,STATUS,DFLT) ; Get late date
 N X,Y,TIUPRMT,TIUDFLT
 I $G(STATUS)=4 S Y=9999999 Q Y
 S TIUPRMT="Ending "_$S($L($G(PRMPT)):PRMPT_" ",1:"")_"Date [Time]: "
 S TIUDFLT=$S($L($G(DFLT)):DFLT,1:"NOW")
 S Y=$$READ^TIUU("DOA^::AET",TIUPRMT,TIUDFLT)
 Q Y
CATEGORY() ; Select Service Category
 N DIR,X,Y
 S DIR(0)="9000010,.07",DIR("A")="Select SERVICE CATEGORY"
 D ^DIR
 Q Y_U_Y(0)
SELTYP(DA,RETURN,PARM,DFLT,TYPE,MODE,DCLASS,PICK) ; Select Document Types
 N I,J,X,XQORM,CURTYP,Y
 I '$D(RETURN) S RETURN=$NA(^TMP("TIUTYP",$J)) K @RETURN
 ; TIUK is STATIC
 ;I +MODE D DOCLIST^TIULA1(DA,.RETURN,PARM,DFLT) Q:+RETURN'<0
 ; *** ADD CALL TO PERSONAL DOCUMENT LISTER HERE
 N:'$D(TIUK) TIUK S TIUK=+$G(TIUK)
 I $G(DFLT)="LAST" D
 . S DFLT=$O(^DISV(DUZ,"XQORM",DA_";TIU(8925.1,",0))
 . S DFLT=$S(+DFLT:$G(^DISV(DUZ,"XQORM",DA_";TIU(8925.1,",DFLT)),1:"")
 I $G(TYPE)']"" S TYPE="DOC"
 I $G(MODE)']"" S MODE=1 ; Default is ASK
 S XQORM=DA_";TIU(8925.1,",XQORM(0)=$S(+$P($G(^TIU(8925.1,+DA,10,0)),U,3)=1:"F",1:$G(PARM,"AD"))
 I XQORM(0)["D" S XQORM("H")="W !!,$$CENTER^TIULS(""--- ""_$P(^TIU(8925.1,+DA,0),U,3)_"" ---""),!"
 I $S(XQORM(0)="F":1,XQORM(0)="R":1,1:0) S X=$S(DFLT]"":DFLT,1:"ALL")
 S:$G(DFLT)]"" XQORM("B")=DFLT
 S XQORM("A")="Select "_$S(XQORM(0)["D":"Document",1:$P(^TIU(8925.1,+DA,0),U,3))_$S($P(^TIU(8925.1,+DA,0),U,4)="DOC":" Component",1:" Type")_$S(+XQORM(0)'=1:"(s)",1:"")_": "
 ; If screening inactive titles proves to be correct, remove comment
 ; from the line below:
 ; S XQORM("S")="I +$$CANPICK^TIULP(+$G(^TIU(8925.1,+DA(1),10,+DA,0)))>0"
 D EN^XQORM
 I +Y'>0,($D(@RETURN)'>9) S @RETURN=Y Q
 I (PARM["A"),(+$G(@RETURN)'>0) M PICK=Y
 S I=0 F  S I=$O(Y(I)) Q:+I'>0  D
 . N TYPMATCH
 . S J=+$P(Y(I),U,2),CURTYP=$P($G(^TIU(8925.1,+J,0)),U,4)
 . I CURTYP="DC" S DCLASS=+$G(DCLASS)+1,DCLASS(DCLASS)=J
 . I  I TYPE="DOC",(PARM["A"),(+$O(^TIU(8925.1,+J,10,0))'>0) W !!,"The Document Class ",$P(^TIU(8925.1,+J,0),U)," has no active titles at present..."
 . S TYPMATCH=$$TYPMATCH^TIULA1(TYPE,CURTYP)
 . I +TYPMATCH>0 D
 . . S TIUK=+$G(TIUK)+1,@RETURN@(TIUK)=Y(I),@RETURN=TIUK
 . I $S('+$G(TYPMATCH):1,CURTYP="CL":1,1:0),+$O(^TIU(8925.1,+J,10,0))>0 D SELTYP(+J,.RETURN,$S(MODE=1:$G(PARM),1:"F"),$S(MODE=1:"LAST",1:"ALL"),TYPE,MODE,.DCLASS,.PICK)
 Q
