TIULA3 ; SLC/JER - Still more interactive functions ;24-FEB-2000 12:22:04
 ;;1.0;TEXT INTEGRATION UTILITIES;**50,79,98**;Jun 20, 1997
TITLE ; Title Look-up
 N TIUI,TYPE,TIUCLASS S TIUI=0
 S TIUTYP=$NA(^TMP("TIUTYP",$J))
 K @TIUTYP
 I +$G(TIUPICT)'>0 Q
 I $P($G(TIUPICT(1)),U,4)="ALL" D
 . S TIUCLASS=+$O(^TIU(8925.1,"AD",+$P(TIUPICT(1),U,2),0))
 . K TIUPICT
 . S TIUPICT=1,TIUPICT(1)="1^"_TIUCLASS_U_$$PNAME^TIULC1(TIUCLASS)
 F  S TIUI=$O(TIUPICT(TIUI)) Q:+TIUI'>0  D
 . S TIUCLASS=$P(TIUPICT(TIUI),U,2)
 . W !!,"For ",$$UP^XLFSTR($$PNAME^TIULC1(TIUCLASS)),":  "
 . D TITLPICK(.TYPE,TIUCLASS)
 M @TIUTYP=TYPE
 S Y="ANY"
 Q
TITLPICK(TIUTYP,CLASS) ; Select multiple titles
 N TIUI,TYPE,TIUPRMT S TIUI=0
 W !!,"Please Select the ",$$UP^XLFSTR($$PNAME^TIULC1(CLASS))
 W " TITLES to search for:",!
 F  D  Q:+$G(TYPE)'>0
 . K TYPE
 . S TIUI=TIUI+1,TIUPRMT=$J(TIUI,3)_")  "
 . D DOCSPICK^TIULA2(.TYPE,CLASS,"A",0,TIUPRMT)
 . I +TYPE>0 S TIUTYP=+$G(TIUTYP)+1,TIUTYP(TIUTYP)=$G(TYPE(1))
 . I  I $P(TYPE(1),U,4)="SINGLE ITEM" D
 . . W !,"There is only one TITLE under ",$$UP^XLFSTR($$PNAME^TIULC1(CLASS))
 . . S TYPE=0
 . I $S($D(DTOUT):1,$D(DUOUT):1,(+TYPE'>0&'$D(TIUTYP)):1,1:0) S TIUQUIT=1
 W !
 Q
ASKTITLE(CLASS,TIUTTL) ; Ask for a different title, same class
 N TIUY,TIUTYP,DFLT,SCREEN,X,Y
 S DFLT=$$RSLVTITL(TIUTTL)
 S SCREEN="I $P(^TIU(8925.1,+Y,0),U,4)=""DOC"",($P(^(0),U)'[""ADDENDUM""),+$$ISA^TIULX(+Y,CLASS),+$$CANPICK^TIULP(+Y),+$$CANENTR^TIULP(+Y)"
 S TIUY=+$$ASKTYP^TIULA2(+CLASS,DFLT,SCREEN,"TITLE: ")
 I +$G(TIUY)'>0 S TIUY=TIUTTL
 Q TIUY
RSLVTITL(TIUTTL) ; Resolve pointers to titles
 Q $P($G(^TIU(8925.1,+TIUTTL,0)),U)
ASKSEQ(TIUDFLT) ; Ask preferred sort sequence
 N TIUPRMT,TIUSET,TIUY S TIUDFLT=$G(TIUDFLT,"D")
 S TIUPRMT="Please Specify Sort Order: "
 S TIUSET="A:ascending (OLDEST FIRST);D:descending (NEWEST FIRST)"
 S TIUY=$$READ^TIUU("SA^"_TIUSET,TIUPRMT,$S(TIUDFLT="A":"ascending",1:"descending"))
 Q TIUY
DATENOTE(X) ; Ask for date/time of note
 N %DT,Y
 ;S TIUPRMT="DATE/TIME OF NOTE"
 ;S TIUY=$$READ^TIUU("D^:NOW:RS",TIUPRMT,$G(DFLT,"NOW"),TIUHLP)
 ;I +TIUY W "     ",$P(TIUY,U,2)
 S %DT="RSX",%DT(0)="-NOW" D ^%DT
 I +Y'>0 D
 . W !,$C(7),"Enter DATE AND TIME of the note [TIME REQUIRED] (future dates prohibited)."
 Q +$G(Y)
SCRCSNR(TIUDA,Y) ; Evaluate whether a person may be selected to cosign
 N TIUI,TIUY,TIUD0,TIUD12 S TIUY=1 ; most people may be selected
 S TIUD0=$G(^TIU(8925,+TIUDA,0)),TIUD12=$G(^TIU(8925,+TIUDA,12))
 ; If he requires cosignature for this document a user may NOT select
 ; himself
 I +$$REQCOSIG^TIULP(+TIUD0,+TIUDA,+$G(DUZ)),(Y=+$G(DUZ)) S TIUY=0 G SCREENX
 ; A TERMINATED User may NOT be selected
 I +$$ACTIVE^XUSER(+Y)'>0 S TIUY=0 G SCREENX
 ; A non-PROVIDER may NOT be selected
 I +$$PROVIDER^TIUPXAP1(+Y,DT)'>0 S TIUY=0 G SCREENX
 ; Author may NOT be selected
 I Y=+$P(TIUD12,U,2) S TIUY=0 G SCREENX
 ; Expected Signer may NOT be selected
 I Y=+$P(TIUD12,U,4) S TIUY=0 G SCREENX
 ; Others who require Cosignature may NOT be selected
 I +$$REQCOSIG^TIULP(+TIUD0,+TIUDA,+Y) S TIUY=0
SCREENX Q +$G(TIUY)
SCRDFCS(USER,Y) ; Screen Default Cosigner selection for USER
 N TIUY S TIUY=1
 S USER=$G(USER,DUZ)
 ; A user may NOT select himself
 I Y=USER S TIUY=0 G SCRDFX
 ; A TERMINATED User may NOT be selected
 I +$$ACTIVE^XUSER(+Y)'>0 S TIUY=0 G SCREENX
 ; A non-PROVIDER may NOT be selected
 I +$$PROVIDER^TIUPXAP1(+Y,DT)'>0 S TIUY=0 G SCREENX
SCRDFX Q TIUY
