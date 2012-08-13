CIAUDIC ;MSC/IND/DKM - Encapsulated FileMan API;15-Feb-2007 10:32;DKM
 ;;1.2;CIA UTILITIES;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Parameterized routine to add/edit/extract an entry in a
 ; FileMan file.  Encapsulates global structure info so no
 ; need to specify this directly.
 ; Inputs:
 ;    %CIADIC = Global root, file number, or bookmark
 ;    %CIACMD = n    : IEN of entry to process
 ;             0    : Process last IEN referenced
 ;             +n   : Move down to subfile n
 ;             -    : Move up to parent file
 ;             @n   : Delete IEN #n (or last referenced if missing)
 ;             =x;y : Lookup y at current level using options in x
 ;             ?x;y ; Lookup y using CIAULKP utility with options in x
 ;             >x;y : Read fields specified in y using options in x
 ;             <x;y : Write fields specified in y using options in x
 ;             ~x;y : Same as <, but creates new entry
 ;             %n   : Force DINUM to n
 ; Outputs:
 ;     Returns in the first piece the IEN of the entry or...
 ;      0 = Entry was deleted
 ;     -1 = Entry was rejected
 ;     -2 = Entry locked by another process
 ;     -3 = Unexpected error
 ;=================================================================
ENTRY(%CIADIC,%CIACMD) ;
 S %CIADIC(0)=+$G(DUZ)
 N DUZ,DIC,DINUM,DIE,DIQ,DIQUIET,DIK,%CIAX,%CIAIEN,%CIAARG,%CIAN1,%CIAN2,%CIAZ,X,Y
 N DA,DC,DD,DG,DH,DK,DL,DO,DQ,DR,DU,DV,DW,DY
 S DUZ=%CIADIC(0),DUZ(0)="@",@$$TRAP^CIAUOS("ERROR^CIAUDIC"),%CIACMD=$G(%CIACMD),%CIAIEN="",DIQUIET=1
 ; Build the bookmark if a global reference or file # passed
 I %CIADIC'[U D
 .S:%CIADIC'=+%CIADIC %CIADIC=+$O(^DIC("B",%CIADIC,0))
 .S %CIADIC=$$ROOT^DILFD(%CIADIC)_U_U_%CIADIC
 I $P(%CIADIC,U,4)="" D
 .S %CIAZ=U_$P(%CIADIC,U,2),%CIAZ=$E(%CIAZ,1,$L(%CIAZ)-1),%CIAZ=%CIAZ_$S(%CIAZ["(":")",1:"")
 .S $P(%CIADIC,U,4)=$P(@%CIAZ@(0),U,2)
 F %CIAN1=1:1:$L(%CIACMD,"|") S %CIAARG=$P(%CIACMD,"|",%CIAN1),%CIAZ=$E(%CIAARG) D  Q:%CIAIEN<0
 .S %CIAN2=$F("-+=@><~?%",%CIAZ)
 .S:%CIAN2 %CIAN2=%CIAN2-1,%CIAARG=$E(%CIAARG,2,999)
 .D DA,@%CIAN2
 .S:%CIAIEN>0 $P(%CIADIC,U,3)=%CIAIEN
 S $P(%CIADIC,U)=%CIAIEN
 Q %CIADIC
 ; Set IEN
0 S:%CIAARG'<0 %CIAIEN=$S($D(@%CIADIC(2)@(+%CIAARG)):+%CIAARG,1:0),$P(%CIADIC,U,3)=%CIAIEN
 Q
 ; Move up to parent file
1 N %CIAX,%CIAY
 S $P(%CIADIC,U,4)=$P($P(%CIADIC,U,4),"|",2,999)
 S %CIAY=$P(%CIADIC,U,2),%CIAX=$L(%CIAY,"|"),$P(%CIADIC,U,2)=$P(%CIAY,"|",1,%CIAX-1)
 S %CIAIEN=+$P(%CIAY,"|",%CIAX),$P(%CIADIC,U,3)=%CIAIEN
 D DA
 Q
 ; Move down to subfile
2 N %CIAX,%CIAY,%CIAZ
 I $P(%CIADIC,U,3)'>0 S %CIAIEN=-1 Q
 S %CIAY=+$P(%CIADIC,U,4)
 S:%CIAARG'=+%CIAARG %CIAARG=+$O(^DD(%CIAY,"B",%CIAARG,0)),%CIAARG=+$P($G(^DD(%CIAY,%CIAARG,0)),U,2)
 S %CIAX=+%CIAARG,%CIAZ=+$O(^DD(%CIAY,"SB",%CIAX,0)),%CIAZ=$P($P(^DD(%CIAY,%CIAZ,0),U,4),";"),%CIAX=$P(^(0),U,2)
 S:%CIAZ'=+%CIAZ %CIAZ=""""_%CIAZ_""""
 S $P(%CIADIC,U,4)=%CIAX_"|"_$P(%CIADIC,U,4),$P(%CIADIC,U,2)=$P(%CIADIC,U,2)_"|"_$P(%CIADIC,U,3)_","_%CIAZ_","
 S %CIAIEN="",$P(%CIADIC,U,3)=""
 D DA
 Q
 ; Lookup an entry
3 N X,Y
 I %CIAARG[";" S DIC(0)=$P(%CIAARG,";"),%CIAARG=$P(%CIAARG,";",2,999)
 E  S DIC(0)="XMF"
 S DIC=%CIADIC(1),X=%CIAARG
 D ^DIC
 S %CIAIEN=+Y
 Q
 ; Delete an entry
4 N X,Y
 S:%CIAARG DA=%CIAARG
 S DIK=%CIADIC(1),%CIAIEN=0
 D ^DIK
 Q
 ; Extract data
5 N %CIAZ,%CIAZ1,%CIAX,%CIAY
 I '%CIAIEN S %CIAIEN=-1 Q
 S DR=""
 F %CIAX=2:1:$L(%CIAARG,";") D
 .S %CIAY=$P(%CIAARG,";",%CIAX)
 .I %CIAY["=" S %CIAZ=$$FLD($P(%CIAY,"=",2)),%CIAZ1(%CIAZ,$P(%CIAY,"="))="",%CIAY=%CIAZ
 .S DR=DR_$S($L(DR):";",1:"")_%CIAY
 S DIC=%CIADIC(1),DIQ(0)=$P(%CIAARG,";")
 S:DIQ(0)="" DIQ(0)="E"
 K ^UTILITY("DIQ1",$J)
 D
 .N X,Y
 .D EN^DIQ1
 F %CIAX=0:0 S %CIAX=$O(%CIAZ1(%CIAX)),%CIAZ="" Q:'%CIAX  D
 .F  S %CIAZ=$O(%CIAZ1(%CIAX,%CIAZ)),%CIAZ1="" Q:%CIAZ=""  D
 ..F %CIAY="E","I" D
 ...S:$D(^UTILITY("DIQ1",$J,+$P(%CIADIC,U,4),%CIAIEN,%CIAX,%CIAY)) %CIAZ1=%CIAZ1_$S($L(%CIAZ1):U,1:"")_^(%CIAY)
 ..S @%CIAZ=%CIAZ1
 Q
 ; Edit existing entry
6 S DIC(0)=$P(%CIAARG,";"),DIC("P")=$P($P(%CIADIC,U,4),"|"),%CIAARG=$P(%CIAARG,";",2,999)
 I %CIAIEN'>0 S %CIAIEN=-1 Q
 S DIE=%CIADIC(1),DR=%CIAARG
 L +@%CIADIC(2)@(%CIAIEN):$S(DIC(0)["!":9999999,1:0)
 E  S %CIAIEN=-2 Q
 D ^DIE
 L -@%CIADIC(2)@(%CIAIEN)
 S %CIAIEN=+$G(DA)
 Q
 ; Create new entry
7 N X,Y,DD,DO,DLAYGO
 S DIC=%CIADIC(1),DIC(0)=$P(%CIAARG,";")_"L",DIC("P")=$P($P(%CIADIC,U,4),"|"),Y=$P(%CIAARG,";",2),%CIAARG=DIC(0)_";"_$P(%CIAARG,";",3,999),DLAYGO=DIC("P")\1
 I +Y'=.01 S %CIAIEN=-1 Q
 S X=$P(Y,"/",4)
 S:X="" X=$P(Y,"/",5)
 X:$E(X)=U $E(X,2,999)
 I $P(^DD(+DIC("P"),.01,0),U,2)["W" D
 .D WP
 E  D ^DIC:DIC(0)'["U",FILE^DICN:DIC(0)["U"
 S %CIAIEN=+Y
 I %CIAIEN>0,$P(%CIAARG,";",2,99)'="" D DA,6
 K DINUM
 Q
8 ; Lookup entry
 N %CIAOPT,%CIAP,CIAFN
 S %CIAOPT=$P(%CIAARG,";"),%CIAARG=$P(%CIAARG,";",2,999),CIAFN=+$P(%CIADIC,U,4)
 S %CIAP=+$P(%CIADIC,U,4),%CIAP=$P($G(^DD(%CIAP,.01,0)),U)
 S:$L(%CIAP) %CIAP=%CIAP_": "
 S %CIAIEN=$$ENTRY^CIAULKP(%CIADIC(2),%CIAOPT,%CIAP,"",%CIAARG,"","",$X,$Y,"","","HLP^CIAUDIC")
 Q
 ; Force DINUM
9 S DINUM=%CIAARG
 Q
HLP W $G(^DD(+CIAFN,.01,3)),!
 Q
 ; Word processing field (special case of #7)
WP N %CIAZ,%CIAZ1
 I X="@" D
 .K @%CIADIC(2)
 .S Y=0
 E  D
 .S %CIAZ=$G(@%CIADIC(2)@(0)),Y=$G(DINUM,1+$O(^($C(1)),-1))
 .S %CIAZ1=+$P(%CIAZ,U,4),%CIAZ=+$P(%CIAZ,U,3)
 .S:Y>%CIAZ %CIAZ=Y
 .S:'$D(^(Y)) %CIAZ1=%CIAZ1+1
 .S ^(0)=U_U_%CIAZ_U_%CIAZ1_U_$G(DT),^(Y,0)=X
 Q:$P(^DD(+DIC("P"),.01,0),U,2)'["a"
 S %CIAIEN=Y
 D DA,WPAUDIT^CCCODAUD(+DIC("P"),.DA,X,"")
 Q
 ; Trap unexpected error
ERROR S $P(%CIADIC,U)=-3
 Q %CIADIC
 ; Return field #
FLD(X) Q $S(X=+X:X,1:+$O(^DD(+$P(%CIADIC,U,4),"B",X,0)))
 ; Set up DA array
DA N %CIAZ,%CIAZ1,%CIAZ2
 K DA
 S:'$G(%CIAIEN) %CIAIEN=$P(%CIADIC,U,3)
 S %CIAZ=$P(%CIADIC,U,2),%CIAZ2=$L(%CIAZ,"|"),DA=%CIAIEN
 F %CIAZ1=2:1:%CIAZ2 S DA(%CIAZ2-%CIAZ1+1)=+$P(%CIAZ,"|",%CIAZ1)
 S %CIADIC(1)=U_$TR($P(%CIADIC,U,2),"|"),%CIADIC(2)=$E(%CIADIC(1),1,$L(%CIADIC(1))-1),%CIADIC(2)=%CIADIC(2)_$S(%CIADIC(2)["(":")",1:"")
 Q
