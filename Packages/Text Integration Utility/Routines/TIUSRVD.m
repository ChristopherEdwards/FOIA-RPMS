TIUSRVD ; SLC/JER - RPC's for document definition ; 04/23/2003
 ;;1.0;TEXT INTEGRATION UTILITIES;**1,7,22,47,103,100,115,164**;Jun 20, 1997
 ;IHS/ITSC/LJF 12/16/2003 CIA/DKM - TIU ignores alternate setting of TIUY
 ;
NOTES(TIUY) ; Get list of PN Titles
 D LIST(.TIUY,3)
 Q
SUMMARY(TIUY) ; Get list of DS Titles
 D LIST(.TIUY,244)
 Q
LIST(TIUY,CLASS,TYPE,TIUK) ; Get list of document titles
 N TIUDFLT
 ; TIUK is STATIC
 S TIUK=+$G(TIUK)
 I $G(TYPE)']"" S TYPE="DOC"
 ; If the user has a preferred list of titles for the CLASS, get it
 I +$O(^TIU(8925.98,"AC",DUZ,CLASS,0)) D PERSLIST(.TIUY,DUZ,CLASS,.TIUK,1)
 S TIUK=+$G(TIUK)+1 S TIUY(TIUK)="~LONG LIST"
 D TRAVERSE(.TIUY,CLASS,$G(TYPE),.TIUK)
 S TIUDFLT=$$PERSDOC^TIULE(DUZ,+CLASS)
 I +TIUDFLT S TIUK=+$G(TIUK)+1,TIUY(TIUK)="d"_$P(TIUDFLT,U,2)
 Q
TRAVERSE(TIUY,CLASS,TYPE,TIUK) ; Get all selectable titles for the CLASS
 N I,J,X,CURTYP,Y,TIUI,TIUC,TYPMATCH S (TIUC,TIUI)=0
 S TIUK=+$G(TIUK)
 I $S(+$$CANENTR^TIULP(CLASS)'>0:1,+$$CANPICK^TIULP(CLASS)'>0:1,1:0) Q
 S CURTYP=$P(^TIU(8925.1,+CLASS,0),U,4)
 S TYPMATCH=$$TYPMATCH^TIULA1(TYPE,CURTYP)
 I +TYPMATCH S TIUK=+$G(TIUK)+1
 I  S TIUY(TIUK)="i"_+CLASS_U_$$PNAME^TIULC1(+CLASS)
 S I=0 F  S I=$O(^TIU(8925.1,+CLASS,10,I)) Q:+I'>0  D
 . N J
 . S J=+$G(^TIU(8925.1,+CLASS,10,+I,0)) Q:+J'>0
 . D TRAVERSE(.TIUY,+J,TYPE,.TIUK)
 Q
PERSLIST(TIUY,DUZ,CLASS,TIUC,TIUFLG) ; Get personal list for a user
 N TIUI,TIUDA,TIUDFLT,NOTINLST S NOTINLST=0
 S TIUDA=+$O(^TIU(8925.98,"AC",DUZ,CLASS,0))
 Q:+TIUDA'>0
 I +$G(TIUFLG) S TIUC=1,TIUY(TIUC)="~SHORT LIST"
 S TIUI=0,TIUC=+$G(TIUC)
 F  S TIUI=$O(^TIU(8925.98,TIUDA,10,TIUI)) Q:+TIUI'>0  D
 . N TIUPL,TIUTNM,TIUDTYP,TIUSEQ
 . S TIUPL=$G(^TIU(8925.98,TIUDA,10,TIUI,0))
 . S TIUDTYP=$P(TIUPL,U)
 . I $S(+$$CANENTR^TIULP(TIUDTYP)'>0:1,+$$CANPICK^TIULP(TIUDTYP)'>0:1,1:0) Q
 . S TIUTNM=$S($P(TIUPL,U,3)]"":$P(TIUPL,U,3),1:$$PNAME^TIULC1(+TIUDTYP))
 . S TIUSEQ=+$P(TIUPL,U,2),TIUC=+$G(TIUC)+1
 . S TIUSEQ=$S(+TIUSEQ:$S('$D(TIUY(TIUSEQ)):TIUSEQ,1:(TIUSEQ+1)),1:TIUC)
 . S TIUY(TIUSEQ)="i"_TIUDTYP_U_TIUTNM,TIUC=+TIUSEQ
 I +$G(TIUFLG) Q
 S TIUDFLT=$$PERSDOC^TIULE(DUZ,+CLASS)
 S (TIUI,TIUC)=0
 F  S TIUI=$O(TIUY(TIUI)) Q:+TIUI'>0  D
 . S TIUC=TIUI
 . I +TIUDFLT,($P($G(TIUY(TIUI)),U)=("i"_+TIUDFLT)) S $P(TIUDFLT,U,2)=$P(TIUY(TIUI),U,2),NOTINLST=0
 . E  S NOTINLST=1
 I +TIUDFLT D
 . ;if default isn't in list, append it as an item
 . I NOTINLST S TIUC=+$G(TIUC)+1,TIUY(TIUC)="i"_TIUDFLT
 . ;otherwise, just append as default
 . S TIUC=+$G(TIUC)+1,TIUY(TIUC)="d"_TIUDFLT
 Q
BLRSHELL(TIUY,TITLE,DFN,VSTR) ; Shell for boilerplate RPC
 K ^TMP("TIUBOIL",$J)
 D BLRPLT(.TIUY,TITLE,DFN,$G(VSTR))
 K ^TMP("TIUBOIL",$J,0)
 Q
BLRPLT(TIUY,TITLE,DFN,VSTR,ROOT) ; Load/Execute the Boilerplate for TITLE
 ;                                 or ROOT
 N TIU,TIUI,TIUJ,TIUK,TIUL,VADM,VAIN,VA,VAERR S TIUI=0
 ;
 ;IHS/ITSC/LJF 12/16/2003 per CIA
 ;S:'$D(TIUY) TIUY=$NA(^TMP("TIUBOIL",$J))
 S TIUY=$NA(^TMP("TIUBOIL",$J))
 ;
 S:'$D(ROOT) ROOT=$NA(^TIU(8925.1,+TITLE,"DFLT")) ; **47**
 I $L($G(VSTR)) D PATVADPT^TIULV(.TIU,DFN,"",$G(VSTR)) ; **47**
 S TIUJ=+$P($G(^TMP("TIUBOIL",$J,0)),U,3)+1
 ; --- Set component header ---
 I ROOT["^TIU(8925.1," D
 . S ^TMP("TIUBOIL",$J,TIUJ,0)=$S($P($G(^TIU(8925.1,+TITLE,0)),U,4)="CO":$P(^TIU(8925.1,+TITLE,0),U)_":   ",1:"")
 I +TIUJ=1,($G(^TMP("TIUBOIL",$J,TIUJ,0))']"") K ^TMP("TIUBOIL",$J,TIUJ,0) S TIUJ=0
 S ^TMP("TIUBOIL",$J,0)="^^"_TIUJ_U_TIUJ_U_DT_"^^"
 F  S TIUI=$O(@ROOT@(TIUI)) Q:+TIUI'>0  D
 . S TIUJ=TIUJ+1,X=$G(@ROOT@(TIUI,0))
 . I $L($T(DOLMLINE^TIUSRVF1)),'$D(XWBOS),(X["{FLD:") S X=$$DOLMLINE^TIUSRVF1(X)
 . I X["|" S X=$$BOIL(X,TIUJ)
 . I X["~@" D INSMULT(X,"^TMP(""TIUBOIL"",$J)",.TIUJ) I 1
 . E  S ^TMP("TIUBOIL",$J,TIUJ,0)=X
 . S ^TMP("TIUBOIL",$J,0)="^^"_TIUJ_U_TIUJ_U_DT_"^^"
 I ROOT["^TIU(8925.1,",+$O(^TIU(8925.1,+TITLE,10,0)) D
 . N TIUFITEM,TIUI D ITEMS^TIUFLT(+TITLE)
 . S TIUI=0 F  S TIUI=$O(TIUFITEM(TIUI)) Q:+TIUI'>0  D
 . . S TIUL=+$G(TIUFITEM(+TIUI)) D BLRPLT(.TIUY,TIUL,DFN,$G(VSTR))
 Q
BOIL(LINE,COUNT) ; Execute Boilerplates
 N TIUI,DIC,X,Y,TIUFPRIV S TIUFPRIV=1
 S DIC=8925.1,DIC(0)="FMXZ"
 S DIC("S")="I $P($G(^TIU(8925.1,+Y,0)),U,4)=""O"""
 F TIUI=2:2:$L(LINE,"|") S X=$P(LINE,"|",TIUI) D
 . D ^DIC
 . I +Y'>0 S X="The OBJECT "_X_" was NOT found...Contact IRM."
 . I +Y>0 D
 . . I $D(^TIU(8925.1,+Y,9)),+$$CANXEC(+Y) X ^(9) S:$E(X,1,2)="~@" X=X_"~@" I 1
 . . E  S X="The OBJECT "_X_" is INACTIVE...Contact IRM."
 . S LINE=$$REPLACE(LINE,X,TIUI)
 Q $TR(LINE,"|","")
CANXEC(TIUODA) ; Evaluate Object Status
 N TIUOST,TIUY S TIUOST=+$P($G(^TIU(8925.1,+TIUODA,0)),U,7)
 S TIUY=$S(TIUOST=11:1,+$G(NOSAVE):1,1:0)
 Q +$G(TIUY)
REPLACE(LINE,X,TIUI) ; Replace the TIUIth object in LINE w/X
 S $P(LINE,"|",TIUI)=X
 Q LINE
INSMULT(LINE,TARGET,TIULCNT) ; Mult-valued results
 N TIUPC,TIULGTH
 ; TIU*1*164 ;
 S TIULGTH=73 ; 2 replacements of 73 below for TIULGTH
 S:$$BROKER^XWBLIB TIULGTH=80
 F TIUPC=2:2:$L(LINE,"~@") D
 . N TIUI,TIULINE,TIUX,TIUSRC,TIUSCNT,TIUTAIL
 . S TIUSRC=$P(LINE,"~@",TIUPC)
 . S TIUTAIL=$P(LINE,"~@",TIUPC+1)
 . S TIULINE=$P(LINE,"~@",(TIUPC-1)),(TIUI,TIUSCNT)=0
 . I $E(TIULINE)=" ",(TIUPC>2) S $E(TIULINE)=""
 . F  S TIUI=$O(@TIUSRC@(TIUI)) Q:+TIUI'>0  D
 . . N TIUSLINE
 . . S TIUSCNT=TIUSCNT+1
 . . S TIUSLINE=$G(@TIUSRC@(TIUI,0))
 . . S:'+$O(@TIUSRC@(TIUI))&(TIUPC+2>$L(LINE,"~@")) TIUSLINE=TIUSLINE_TIUTAIL
 . . I TIUSCNT=1,($L(TIULINE_TIUSLINE)>TIULGTH) D  Q
 . . . S:$D(@TARGET@(TIULCNT,0)) TIULCNT=TIULCNT+1
 . . . S @TARGET@(TIULCNT,0)=TIULINE
 . . . S TIULCNT=TIULCNT+1
 . . . S @TARGET@(TIULCNT,0)=TIUSLINE
 . . I TIUSCNT=1,($L(TIULINE_TIUSLINE)'>TIULGTH) D  Q
 . . . S:$D(@TARGET@(TIULCNT,0)) TIULCNT=TIULCNT+1
 . . . S @TARGET@(TIULCNT,0)=TIULINE_TIUSLINE
 . . S:$D(@TARGET@(TIULCNT,0)) TIULCNT=TIULCNT+1
 . . S @TARGET@(TIULCNT,0)=$G(TIUSLINE)
 . K @TIUSRC
 Q
LNGCNSLT(Y,FROM,DIR) ; Handle long list of titles for CONSULTS
 N CLASS S CLASS=+$$CLASS^TIUCNSLT Q:+CLASS'>0
 D LONGLIST(.Y,CLASS,$G(FROM),$G(DIR,1))
 Q
LONGLIST(Y,CLASS,FROM,DIR,IDNOTE) ; long list of titles for a class
 ; .Y=returned list, CLASS=ptr to class in 8925.1, FROM=text to $O from,
 ; DIR=$O direction, IDNOTE=flag to indicate selection for ID Entry
 N I,DA,CNT S I=0,CNT=44,DIR=$G(DIR,1)
 F  Q:I'<CNT  S FROM=$O(^TIU(8925.1,"ACL",CLASS,FROM),DIR) Q:FROM=""  D
 . S DA=0
 . F  Q:I'<CNT  S DA=$O(^TIU(8925.1,"ACL",CLASS,FROM,DA)) Q:+DA'>0  D
 . . I $S(+$$CANENTR^TIULP(DA)'>0:1,+$$CANPICK^TIULP(DA)'>0:1,1:0) Q
 . . I +$L($T(CANLINK^TIULP)),+$G(IDNOTE),(+$$CANLINK^TIULP(DA)'>0) Q
 . . S I=I+1,Y(I)=DA_"^"_FROM
 Q
CNSLCLAS(Y) ; RPC to identify class CONSULTS
 S Y=$$CLASS^TIUCNSLT
 Q