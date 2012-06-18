CIAULKP ;MSC/IND/DKM - File lookup utility;14-Aug-2006 09:35;DKM
 ;;1.2;CIA UTILITIES;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Inputs:
 ;   %CIADIC  = Global root or file #
 ;   %CIAOPT  = Options
 ;      A allow automatic selection of exact match
 ;      B sound bell with selection prompt
 ;      C use roll & scroll mode
 ;      D index is in date/time format
 ;      E use line editor
 ;      F forget the entry (i.e., ^DISV not updated)
 ;      G start with prior entry
 ;      H HTML-formatted output
 ;      I show only lookup identifiers
 ;      J show only secondary identifiers
 ;      K null entry at select prompt exits
 ;      L like X, but allows lookup at select prompt
 ;      M allow multiple selection
 ;      O show entry only once
 ;      P partial lookup
 ;      Q silent lookup
 ;      R reverse search through indices
 ;      S start selection list at last selection
 ;      T forget trapped inputs
 ;      U force uppercase translation
 ;      V extended DISV recall (prompt-specific)
 ;      W use multi-term lookup algorithm
 ;      X do not prompt for input
 ;      Y right justify secondary identifiers
 ;      Z perform special formatting of output
 ;      1 automatic selection if one match only
 ;      2-9 # of columns for selection display (default=1)
 ;      * force all indices to be searched
 ;      ^ allow search to be aborted
 ;   %CIAPRMP = Prompt (optional)
 ;   %CIAXRFS  = Cross-references to examine (all "B"'s by default)
 ;   %CIADATA  = Data to lookup (optional)
 ;   %CIASCN   = Screening criteria (optional)
 ;   %CIAMUL   = Local variable or global reference to
 ;              store multiple hits
 ;   %CIAX     = Column position for prompt (optional)
 ;   %CIAY     = Row position for prompt (optional)
 ;   %CIASID   = Piece # of secondary identifier (optional)
 ;              or executable M code to display same
 ;   %CIATRP   = Special inputs to trap (optional)
 ;   %CIAHLP   = Entry point to invoke help
 ; Outputs:
 ;    Return value = index of selected entry or:
 ;      -1 for forced exit by ^
 ;      -2 for forced exit by ^^
 ;       0 for null entry
 ;=================================================================
ENTRY(%CIADIC,%CIAOPT,%CIAPRMP,%CIAXRFS,%CIADATA,%CIASCN,%CIAMUL,%CIAX,%CIAY,%CIASID,%CIATRP,%CIAHLP) ;
 N %,%1,%N,%S,%Z,%CIAPID,%CIAXRF,%CIASCT,%CIAKEY,%CIAKEY1,%CIADISV,%CIASLCT
 N %CIAXALL,%CIAXRN,%CIASMAX,%CIATRNC,%CIAD,%CIAD1,%CIAD2,%CIABEL,%CIANUM
 N %CIADIR,%CIASLT,%CIACOL,%CIALAST,%CIASAME,%CIAEOS,%CIAEOL,%CIAHTML,%CIARS,%CIAQT
 I $$NEWERR^%ZTER N $ET S $ET=""
 S (%CIAOPT,%CIAOPT(0))=$$UP^XLFSTR($G(%CIAOPT)),%CIAPID="%CIALKP"_$J
 S %CIABEL=$S(%CIAOPT["B":$C(7),1:""),%CIADIR=$S(%CIAOPT["R":-1,1:1)
 S %CIASLT=1,%CIACOL=1,%CIAEOS=$C(27,91,74),%CIAEOL=$C(27,91,75),%CIAHTML=0
 S %CIAX=$G(%CIAX,0),%CIAY=$G(%CIAY,3),DTIME=$G(DTIME,99999999)
 S %CIALAST=0,%CIARS=%CIAOPT["C",%CIAQT=%CIAOPT["Q"
 S:%CIARS %CIAEOS="",%CIAY=$Y
 S:%CIAQT %CIAOPT=%CIAOPT_"XHM"
 S:%CIAOPT["H" (%CIABEL,%CIAEOL,%CIAEOS)="",%CIAOPT=%CIAOPT_"X",%CIAHTML=1
 S:%CIAOPT["L" %CIAOPT=%CIAOPT_"X"
 S U="^",DUZ=$G(DUZ,0),IO=$G(IO,$I),IOM=$G(IOM,80),%CIAMUL=$G(%CIAMUL),%CIAHLP=$G(%CIAHLP),%CIATRP=$G(%CIATRP),%CIASCN=$G(%CIASCN),%CIASAME=%CIAOPT["M"&(%CIAMUL'="")
 F %=2:1:9 S:%CIAOPT[% %CIACOL=%
 S:%CIAOPT'["M" %CIAMUL=""
 K:%CIAMUL'="" @%CIAMUL
 S:%CIADIC=+%CIADIC %CIADIC=$$ROOT^DILFD(%CIADIC)
 S:$E(%CIADIC,$L(%CIADIC))="(" %CIADIC=$E(%CIADIC,1,$L(%CIADIC)-1)
 S:$E(%CIADIC,$L(%CIADIC))="," %CIADIC=$E(%CIADIC,1,$L(%CIADIC)-1)
 I %CIADIC["(",$E(%CIADIC,$L(%CIADIC))'=")" S %CIADIC=%CIADIC_")"
 S %CIAPRMP=$G(%CIAPRMP,$S(%CIAOPT["X":"",1:"Enter identifier: "))
 S %CIADISV=$S(%CIADIC[")":$TR(%CIADIC,")",","),1:%CIADIC_"(")_$S(%CIAOPT["V":";"_%CIAPRMP,1:"")
 S %CIASID=$G(%CIASID),%CIAXRFS=$G(%CIAXRFS),%CIADATA=$G(%CIADATA)
 S:%CIASID=+%CIASID %CIASID=$S(%CIASID<0:%CIASID,1:"$P(%Z,U,"_%CIASID_")")
 W:'%CIAHTML $$XY(%CIAX,%CIAY),%CIAEOS,!
 I %CIAOPT["G",$G(^DISV(DUZ,%CIADISV))'="" D
 .S %CIADATA=^(%CIADISV)
 .S:+%CIADATA=%CIADATA %CIADATA=$P($G(@%CIADIC@(%CIADATA,0)),U)
 I %CIAXRFS="" D
 .S (%,%CIAXRFS)="B"
 .F  S %=$O(@%CIADIC@(%)) Q:$E(%)'="B"  S %CIAXRFS=%CIAXRFS_U_%
 F %=1:1:$L(%CIAXRFS,U) S %1=$P(%CIAXRFS,U,%) S:%1'="" %CIAXRFS($P(%1,":"))=$P(%1,":",2),$P(%CIAXRFS,U,%)=$P(%1,":")
 S (%CIAD1,%CIAD2)=""
 D RM(0)
 S %CIAIEN=$$INPUT
 W:'%CIAHTML $$XY(%CIAX+$L(%CIAPRMP),%CIAY),$$TRUNC^CIAU(%CIAD2,IOM-$X),%CIAEOS
 D RM(IOM)
 K ^TMP(%CIAPID)
 Q %CIAIEN
INPUT() ;
INP K ^TMP(%CIAPID)
 D READ
 S:%CIAOPT["U" %CIAD=$$UP^XLFSTR(%CIAD)
 S @$$TRAP^CIAUOS("ERROR^CIAULKP")
 I %CIAD="",%CIATRP'="" S %CIAD=$G(@%CIATRP@(" "))
 Q:"^^"[%CIAD -$L(%CIAD)
 I "?"[%CIAD D HELP1^CIAULK2 G INP
 I %CIAD=" " D SAME G:%CIAD="" INP2
 I %CIATRP'="",$D(@%CIATRP@(%CIAD)) D  Q %CIAD
 .S %CIASAME=1
 .D:%CIAOPT'["T" DISV^CIAULK2(%CIAD)
 .S %CIAD2=$G(@%CIATRP@(%CIAD))
 .S:%CIAD2="" %CIAD2=%CIAD
 S:%CIAD="??" %CIAD=""
 I $E(%CIAD,$L(%CIAD))="*" S %CIAXALL=1,%CIAD=$E(%CIAD,1,$L(%CIAD)-1)
 E  S %CIAXALL=%CIAOPT["*"
 S %CIAIEN=$$LKP^CIAULK2(%CIAD)
INP2 G INP:%CIAIEN=""!$L(%CIAD1)
 Q %CIAIEN
READ S %CIAD=""
 F  Q:%CIAD'=""!(%CIAD1="")  S %CIAD=$P(%CIAD1,";"),%CIAD1=$P(%CIAD1,";",2,999)
 Q:$L(%CIAD)
 S %CIAD=%CIADATA,%CIADATA=""
 W:'%CIAHTML $$XY(0,%CIAY+2),%CIAEOS,$$XY(%CIAX,%CIAY),%CIAPRMP_%CIAEOL
 I %CIAOPT["X" S:%CIAOPT["E" %CIAOPT=$TR(%CIAOPT,"X"),%CIADATA=%CIAD Q
 I %CIAOPT["E" D
 .N %,%1
 .S:%CIAD?1"`"1.N %CIAD=+$E(%CIAD,2,99),%CIAD=$$FMT^CIAULK2(%CIAD,$P($G(@%CIADIC@(%CIAD,0)),U))
 .S %1=0,%=%CIAX+$L(%CIAPRMP),%=$$ENTRY^CIAUEDT(%CIAD,IOM-%-1,%,%CIAY,"","RHV",,,,,.%1)
 .S:%1=3 %=U
 .S:%="?" %CIADATA=%CIAD
 .S %CIAD=%
 E  I '$L(%CIAD) R %CIAD:DTIME S:'$T %CIAD=U
 I %CIAOPT["M",%CIAD[";" S %CIAD1=%CIAD G READ
 Q
SAME S %CIASAME=0,%CIAIEN="",%CIAD="",%CIASCT=0
 I %CIAMUL'="" D
 .S %=""
 .F  S %=$O(^DISV(DUZ,%CIADISV,%)) Q:%=""  D SM1
 E  S %=$G(^DISV(DUZ,%CIADISV)) D:%'="" SM1
 S:%CIAHTML %CIAIEN=%CIASCT
 Q
SM1 I %CIATRP'="",$D(@%CIATRP@(%)) S %CIAIEN=%,%CIAD=%
 E  I $$VALD^CIAULK2(%) S %CIAIEN=%
 I  D DISV^CIAULK2(%CIAIEN) S %CIASCT=%CIASCT+1
 Q
XY(X,Y) Q $$XY^CIAULK2(.X,.Y)
RM(X) X ^%ZOSF("RM")
 Q
ERROR W:'%CIAHTML $$XY(0,%CIAY+1),*7,%CIAEOL,$$EC^%ZOSV
 S (%CIADATA,%CIAD1,%CIAD2)=""
 G INP
