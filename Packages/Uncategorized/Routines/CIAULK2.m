CIAULK2 ;MSC/IND/DKM - Continuation of CIAULKP;04-May-2006 08:19;DKM
 ;;1.2;CIA UTILITIES;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
LKP(%CIADX) ;
 N %CIAD,%CIAZ,%CIAN
 S %CIAXRN=0,%CIATRNC=0,%CIAIEN="",%CIASCT=0,%CIAD=%CIADX
 W:'%CIAHTML $$XY(%CIAX+$L(%CIAPRMP),%CIAY),$S(%CIAOPT["X":"",1:%CIAD),%CIAEOS,!,"Searching"_$S(%CIAOPT[U:" (press ^ to abort)",1:"")_"...",*13
 I $E(%CIAD)="`" S %CIASLCT=%CIAD G:'%CIAHTML NR5 D SHOW($E(%CIAD,2,999)) Q 1
NXTREF S %CIAXRN=%CIAXRN+1,%CIAXRF=$P(%CIAXRFS,U,%CIAXRN),%CIAD=%CIADX
 I %CIAXRF="" G:%CIASCT NR3 W:'%CIAHTML *7,*13,%CIAEOL,"Not found"_$S(%CIAD="":".",1:": ")_$S(%CIAD'=+%CIAD:%CIAD,%CIAOPT["D":$$ENTRY^CIAUDT(%CIAD),1:%CIAD) S %CIAD1=$S(%CIAOPT["X":U,1:"") Q ""
 S %CIAOPT(0)=%CIAOPT_%CIAXRFS(%CIAXRF)
 I %CIAOPT(0)["D",$L(%CIADX) D  G:%CIAD<1 NXTREF
 .S %CIAD=$$DT^CIAU(%CIADX)
 I %CIAOPT(0)["W" D MTL G NXTREF
 S %CIAKEY=$S(%CIAOPT(0)["P":$P(%CIAD," "),1:%CIAD)_$S(%CIADIR<0:$C(255),1:""),%CIANUM=$S(%CIAKEY=+%CIAKEY:%CIAKEY,1:"")
 I %CIAD'="",$D(@%CIADIC@(%CIAXRF,%CIAD)) S %=%CIASCT+1 D ADD(%CIAD) I %CIASCT=%,%CIAOPT(0)["A" D SLCT(%CIASCT) Q %CIAIEN
NR2 I %CIAOPT(0)[U R %#1:0 I %=U S %CIATRNC=1 G NR3:%CIASCT Q ""
 S %CIAKEY=$O(@%CIADIC@(%CIAXRF,%CIAKEY),%CIADIR)
 I (%CIANUM="")=(%CIAKEY=+%CIAKEY),%CIAD'="" S %CIAKEY=""
 I %CIAKEY'="",%CIAOPT(0)["P",%CIAKEY'=%CIAD S %=$$PARTIAL(%CIAD,%CIAKEY) D ADD(%CIAKEY):%>0 G:%'<0 NR2:%CIASCT<100
 I %CIAKEY'="",%CIAOPT(0)'["P",$E(%CIAKEY,1,$L(%CIAD))=%CIAD D ADD(%CIAKEY) G:%CIASCT<100 NR2
 I %CIANUM'="" S %CIAKEY=%CIANUM_$C($S(%CIADIR<0:255,1:1)),%CIANUM="" G NR2
 I %CIASCT'<100 W:'%CIAHTML *7 S %CIAXALL=0,%CIATRNC=1
 G:'%CIASCT!%CIAXALL NXTREF
NR3 I %CIASCT=1,%CIAOPT(0)[1,'%CIATRNC D SLCT(1) Q %CIAIEN
 S %CIAKEY=%CIASLT,%CIASLT=1,%CIASMAX=$S(%CIAHTML!%CIARS:99999,1:17-%CIAY)
NR4 W:'%CIAHTML $$XY(0,%CIAY+1),%CIAEOS,!
 F %CIAN=%CIAKEY:1:%CIAKEY+%CIASMAX-1 D  Q:%CIAN=%CIASCT
 .F %CIAZ=0:1:%CIACOL-1 D
 ..S %1=IOM/%CIACOL*%CIAZ\1,%CIALAST=%CIAZ*%CIASMAX+%CIAN
 ..Q:%CIALAST>%CIASCT
 ..W:'%CIAHTML $$XY(%1,$Y),%CIAEOL,%CIALAST,?5
 ..D SHOW(^TMP(%CIAPID,%CIALAST),%1+4)
 .W:'%CIAQT !
 Q:%CIAHTML $S(%CIATRNC:-%CIASCT,1:%CIASCT)
 W:%CIALAST<%CIASCT !,%CIASCT-%CIALAST," more choice(s)..."
 W:%CIATRNC "  (list was truncated)",!
 W %CIAEOS_%CIABEL,!!
 R "Enter selection: ",%CIASLCT:DTIME
 S:'$T %CIASLCT=U
 W *13
 I %CIAOPT["K",%CIASLCT="" Q -1
 I "Nn"[%CIASLCT S %CIAKEY=$S(%CIALAST<%CIASCT:%CIALAST+1,1:1) G NR4
 I "Bb"[%CIASLCT S %CIAKEY=$S(%CIAKEY=1:%CIASCT-%CIASMAX+1,%CIAKEY'>%CIASMAX:1,1:%CIAKEY-%CIASMAX) S:%CIAKEY<1 %CIAKEY=1 G NR4
 I "?"[%CIASLCT D HELP2 G NR4
 I "^^"[%CIASLCT S %CIAD2="",%CIAD1=$S(%CIAOPT(0)["X":%CIASLCT,%CIASLCT="^^":%CIASLCT,1:"") Q ""
NR5 F  D  Q:%CIASLCT=""
 .I %CIAOPT(0)["M" S %CIAD=$P(%CIASLCT,";"),%CIASLCT=$P(%CIASLCT,";",2,999)
 .E  S %CIAD=%CIASLCT,%CIASLCT=""
 .Q:'$L(%CIAD)
 .I %CIAD?1.N D SLCT(%CIAD) Q
 .I %CIAOPT(0)["M",%CIAD?1.N1"-".N D  Q
 ..N %1,%2
 ..S %1=+%CIAD,%2=+$P(%CIAD,"-",2)
 ..S:'%2 %2=%CIASCT
 ..S:%1>%2 %CIAD=%1,%1=%2,%2=%CIAD
 ..S:%2>%CIASCT %2=%CIASCT
 ..F %=%1:1:%2 D SLCT(%)
 .I %CIAOPT["X",%CIAOPT'["L" S (%CIASLCT,%CIAD1,%CIAIEN)="" Q
 .I $E(%CIAD)="`" D  Q
 ..S %CIAD=+$E(%CIAD,2,999)
 ..I $$VALD(%CIAD) D DISV(%CIAD) S %CIAIEN=%CIAD
 .S %CIAD1=%CIAD1_";"_%CIAD
 W $$XY(0,%CIAY+1),%CIAEOS,!
 Q %CIAIEN
 ; Add list selection to output
SLCT(%CIASLCT) ;
 I %CIASLCT>0,%CIASLCT'>%CIASCT D
 .S %CIAIEN=+^TMP(%CIAPID,+%CIASLCT)
 .D DISV(%CIAIEN)
 Q
 ; Add IEN to output
DISV(%CIAIEN) ;
 Q:%CIAIEN=""
 I %CIAMUL'="",'$D(@%CIAMUL@(%CIAIEN)) S @%CIAMUL@(%CIAIEN)="" D:'%CIAQT APP(%CIAIEN)
 D:%CIAMUL="" APP(%CIAIEN)
 Q:%CIAOPT(0)["F"
 K:%CIASAME ^DISV(DUZ,%CIADISV)
 S %CIASAME=0,^DISV(DUZ,%CIADISV)=%CIAIEN,^(%CIADISV,%CIAIEN)=""
 Q
 ; Append primary key to key list
APP(%CIAIEN) ;
 N %CIAKEY
 S %CIAKEY=$S(%CIAIEN=+%CIAIEN:$P($G(@%CIADIC@(%CIAIEN,0)),U),1:%CIAIEN)
 S %CIAKEY=$$FMT(%CIAIEN,%CIAKEY)
 Q:'$L(%CIAKEY)!($L(%CIAKEY)+$L(%CIAD2)'<250)
 S %CIAD2=%CIAD2_$S($L(%CIAD2):";",1:"")_%CIAKEY
 I %CIAOPT(0)'["J",%CIAOPT(0)'["M" S %CIAD2=%CIAD2_"  "_$$SID(%CIAIEN)
 Q
 ; Multi-term lookup
MTL N %
 S %=$S(%CIADIC[")":$TR(%CIADIC,")",","),1:%CIADIC_"(")_"%CIAXRF)"
 S %=$$LKP^CIAUMTL(%,%CIAD,"^TMP(""MTL"",%CIAPID)",%CIAOPT(0)[U)
 S:%<0 %CIATRNC=1
 D:% ADD(%CIAPID,"^TMP","MTL")
 K ^TMP("MTL",%CIAPID)
 Q
 ; Add key to selection list
ADD(%CIAKEY,%CIAIDX,%CIASUB) ;
 N %S
 S:'$D(%CIAIDX) %CIAIDX=%CIADIC,%CIASUB=%CIAXRF
 F %S=0:0 S %S=$O(@%CIAIDX@(%CIASUB,%CIAKEY,%S)) Q:'%S  D
 .I %CIAOPT(0)["O",$D(^TMP(%CIAPID,0,%S)) Q
 .I $$VALD(%S) D
 ..S %CIASCT=%CIASCT+1,^TMP(%CIAPID,%CIASCT)=%S_U_$S(%CIAOPT(0)["W":"",1:%CIAKEY),^(0,%S)=""
 ..I %CIAOPT(0)["S",$G(^DISV(DUZ,%CIADISV))=%S S %CIASLT=%CIASCT
 Q
 ; Check entry against screening criteria
VALD(%S) Q:'$D(@%CIADIC@(%S))!'%S 0
 Q:%CIASCN="" 1
 N %,%1
 S %1=1,@$$TRAP^CIAUOS("V3^CIAULK2")
 F %=0:0 S %=$O(@%CIASCN@(%)) Q:'%  D  Q:%1
 .S %1=0,@$$TRAP^CIAUOS("V2^CIAULK2")
 .X "S %1="_@%CIASCN@(%)
V2 .Q
 Q %1
V3 Q 0
 ; Show the specified selection
SHOW(%CIASLCT,%CIACOL1,%CIACOL2) ;
 N %S,%Z,%P,%I
 S %S=+%CIASLCT,%Z=$G(@%CIADIC@(%S,0)),%P=$$FMT(%S,$S(%CIAOPT["I":$P(%CIASLCT,U,2),1:$P(%Z,U)))
 ;S %I=$$SID(%S,$P(%CIASLCT,U,2)),%I=$S(%I="":%P,1:%I)
 S %I=$$SID(%S,%P),%I=$S(%I="":%P,1:%I)
 I %CIAHTML D  Q
 .I '%CIAQT W $$MSG^CIAU(%CIAPRMP,"|"),!
 .E  D DISV(%S)
 S %CIACOL1=+$G(%CIACOL1,$X)
 I %CIAOPT(0)["Y" S %CIACOL2=+$G(%CIACOL2,IOM\%CIACOL+%CIACOL1-8-$L(%I))
 E  S %CIACOL2=+$G(%CIACOL2,IOM\%CIACOL\$S(%CIAOPT(0)["D":3,1:2)-3+%CIACOL1)
 W $$XY(%CIACOL1,$Y)
 I %CIAOPT(0)'["J",%I'=%P W $$TRUNC^CIAU(%P,IOM\%CIACOL-6),?%CIACOL2," "_$$TRUNC^CIAU(%I,IOM-%CIACOL2-2)
 E  W $$TRUNC^CIAU(%I,IOM\%CIACOL-6)
 Q
 ; Return external form of result
FMT(%S,%CIAKEY) ;
 Q:%CIAKEY="" %CIAKEY
 I %CIATRP'="",$D(@%CIATRP@(%CIAKEY)) Q @%CIATRP@(%CIAKEY)
 S:%CIAOPT(0)["D" %CIAKEY=$$ENTRY^CIAUDT(%CIAKEY)
 I %CIAOPT(0)["Z",%CIASCN'="",$G(@%CIASCN)'="" S @("%CIAKEY="_@%CIASCN)
 S:%CIAOPT["J" %CIAKEY=$$SID(%S,%CIAKEY)
 Q %CIAKEY
 ; Return secondary identifier
SID(%S,%CIAKEY) ;
 S %CIAKEY=$G(%CIAKEY)
 N %Z
 S %Z=$G(@%CIADIC@(%S,0)),@("%Z="_$S(%CIASID<0:$S(%CIAKEY=$$UP^XLFSTR($P(%Z,U)):"""""",1:"%CIAKEY"),%CIASID="":"%CIASID",1:%CIASID))
 Q %Z
 ; Partial key lookup
PARTIAL(%CIAD,%CIAKEY) ;
 N %,%1,%2
 S (%(1),%(2))=0,%1(1)=%CIAD,%1(2)=%CIAKEY
 F %=1,2 S %1(%)=$TR(%1(%),".,;:?/!-","        ")
P1 S (%2(1),%2(2))=""
 F %=1,2 D
 .F %(%)=%(%)+1:1:$L(%1(%)," ") S %2(%)=$P(%1(%)," ",%(%)) Q:%2(%)'=""
 Q:%2(1)="" 1
 Q:%2(1)'=$E(%2(2),1,$L(%2(1))) -(%(1)=1)
 G P1
HELP(X) ; Application-specific help
 N %
 S %=""
 F  S %=$O(X(%)) Q:%=""  D:$Y>20 PAUSE W $G(X(%)),!
 Q
 ; Generic help
HELP1 N %
 W !!
 D:%CIAHLP'="" @%CIAHLP
 W !,"Enter a blank line for default action.",!
 D:$Y>20 PAUSE
 W:%CIAOPT'["W" "Enter ?? to see all possible selections.",!
 D:$Y>20 PAUSE
 W "Enter a space to retrieve previous selection.",!
 D:$Y>20 PAUSE
 W "Enter a valid identifier for lookup."
 W:(%CIAOPT'["*")&(%CIAXRFS[U) "  Append a * to include all indices."
 W !
 I %CIAOPT["M" D
 .D:$Y>20 PAUSE
 .W "Separate multiple selections by semicolons."
 R !!,"Press any key to continue...",*%:DTIME
 Q
 ; Help at choice prompt
HELP2 N %
 W $$XY(0,16),%CIAEOS,!
 W $S(%CIAOPT(0)["K":"Enter N for next choices.",1:"Press RETURN for more choices.")
 W ?35,"Enter B for previous choices.",!
 W "Enter ^ to abort lookup.",?35,"Enter choice number to select.",!
 W "Any other entry = new lookup."
 W:%CIAOPT(0)["M" ?35,"Separate multiple selections by semicolons."
 R !!,"Press any key to continue...",*%:DTIME
 Q
PAUSE Q:%CIARS
 N %
 R !,"Press any key for more...",*%:DTIME
 W $$XY(0,%CIAY+2),%CIAEOS
 Q
XY(X,Y) ;I %CIARS W:'X *13 S $X=X,$Y=Y Q ""
 S:%CIARS Y=$Y
 Q $$XY^CIAU(X,Y)
