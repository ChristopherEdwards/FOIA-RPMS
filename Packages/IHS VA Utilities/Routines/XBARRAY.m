XBARRAY ; IHS/ADC/GTH - BUILD AN ARRAY ; [ 07/08/1999  3:54 PM ]
 ;;3.0;IHS/VA UTILITIES;**7**;JULY 9, 1999
 ;
 ; Thanks to Paul Wesley, DSD/OIRM, for the original
 ; routine.
 ;
 ; This utility provides a word processing format of free
 ; text and local variable references to build an array.
 ;
 ; A file is necessary that has a .01 field for the form
 ; name and a WP field to hold the WP form.
 ;
 ; Please refer to routine XBFORM0 for documentation.
 ;
 Q
 ;
GEN(XBFORM,XBWPDIC,XBWPFLD,XBREF,XBFMT,XBLAST) ;EP  ** generate array 
 NEW XBLLINE
 S XBLLINE=$G(XBLAST)
 I $D(XBFORM(XBFORM)) D ZBUILD,REFBUILD,EXIT Q XBLLINE
 D WPGET,BUILD,ZBUILD
 D REFBUILD
 D EXIT
 Q XBLLINE
 ;
EDIT(XBFORM,XBWPDIC,XBWPFLD) ;EP  Edit a Form
EDIT2 ;
 KILL XBFORM(XBFORM)
 S XBLLINE=0,XBFMT=1
 D EDITWP,WPGET,BUILD,ZBUILD
 D ARRAY^XBLM("XBZ(",XBFORM)
 I $$DIR^XBDIR("S^R:Re-Edit;Q:Quit")="R" KILL XBZ G EDIT2
 D EXIT
 KILL XBLLINE
 Q
 ;
EDITWP ;** edit WP array
 KILL DIE,DIC,DA,DR
 S DIC=XBWPDIC,DR=XBWPFLD,DIC(0)="AEQMLZ"
 I $L($G(XBFORM)) S X=XBFORM,DIC(0)="XL"
 D ^DIC
 I Y'>0 S XBQUIT=1 Q
 S DIE=$$DIC^XBDIQ1(XBWPDIC),DA=+Y,DR=XBWPFLD
 D ^DIE
 Q
 ;
WPGET ;** get WP array
 KILL XBWP,XBL,XBOUT,XBVAR,XBWWP,DIC,DR,DIE,DA
 S X=XBFORM,DIC=XBWPDIC,DR=XBWPFLD,DIC(0)="X"
 D ^DIC
 I Y'>0 S XBWP(1)=XBFORM_"  NOT FOUND",XBQUIT=1
 S DA=+Y
 D ENP^XBDIQ1(XBWPDIC,DA,XBWPFLD,"XBWWP(")
 S %X="XBWWP("_XBWPFLD_",",%Y="XBWP("
 D %XY^%RCR
 KILL XBWWP
 Q
 ;
BUILD ;** scan WP array to build XBL
 S XBWPL="",XBLINE=0
 Q:$D(XBFORM(XBFORM))
 F  S XBWPL=$O(XBWP(XBWPL)) Q:XBWPL'>0  D LINE
 Q
 ;
LINE ;** process one line of the WP array    
 S Z=XBWP(XBWPL)
 S XBLINE=XBLINE+1
 F I=1:1:$L(Z) S A=$E(Z,I) D  Q:$G(XBQUIT)
 . I I=1,A="#" D MAP S I=$L(Z),XBLINE=XBLINE-1,XBQUIT=1 Q
 . I I=1,A="*" D OUT S I=$L(Z),XBLINE=XBLINE-1,XBQUIT=1 Q
 . I I=1,A=";" S I=$L(Z),XBLINE=XBLINE-1,XBQUIT=1 Q
 . I A'=" ",A'="~" D TEXT Q
 . I A="~" D VAR Q
 .Q
 KILL XBQUIT
 Q
 ;
ZBUILD ;** build Z array from XBL
 KILL Z
 I '$G(XBFMT) F XBL=1:1 D  Q:('$O(XBFORM(XBFORM,XBL)))
 . I '$D(XBFORM(XBFORM,XBL)),$O(XBFORM(XBFORM,XBL)) S XBZ(XBL+XBLLINE)=" " Q
 . D FILL
 .Q
 I $G(XBFMT)=1 F XBL=1:1 D  Q:('$O(XBFORM(XBFORM,XBL)))
 . I '$D(XBFORM(XBFORM,XBL)),$O(XBFORM(XBFORM,XBL)) S XBZ(XBL+XBLLINE,0)=" " Q
 . D FILL
 .Q
 Q
 ;
REFBUILD ; %RCR BACK TO CALL
 S %Y=XBREF,%X="XBZ("
 D %XY^%RCR
 S XBLLINE=XBLLINE+XBL
 Q
 ;
FILL ;** fill one line
 S XBCOL=0,T=""
 F  S XBCOL=$O(XBFORM(XBFORM,XBL,XBCOL)) Q:XBCOL'>0  D
 . S X=XBFORM(XBFORM,XBL,XBCOL),XBCOLX=XBCOL
 . I XBCOL#1 S XBCOLX=XBCOL\1,X="S X="_X X X
 . S XBXL=$L(X)
 . Q:X=""
 . S T=$$SETSTR^VALM1(X,T,XBCOLX,XBXL)
 .Q
 I T="" S XBLLINE=$G(XBLLINE)-1 Q
 S:'$G(XBFMT) XBZ(XBL+XBLLINE)=T
 S:($G(XBFMT)=1) XBZ(XBL+XBLLINE,0)=T
 Q
 ;
TEXT ;**    
 NEW W
 S XBCOL=I
 F W=I:1:$L(Z) S A=$E(Z,W) Q:A="~"
 I W'=$L(Z) S W=W-1
 S XBT=$E(Z,I,W),XBFORM(XBFORM,XBLINE,XBCOL)=XBT,I=W
 Q
 ;
VAR ;** add .5 to column count to indicate a variable vs text
 S XBCOL=I
 F W=I+1:1:$L(Z) S A=$E(Z,W) I A="~" Q
 S XBT=$E(Z,I+1,W-1),XBFORM(XBFORM,XBLINE,XBCOL+.5)=XBT,I=W
 I XBT'["|" D  Q
 . Q:'$D(XBOUT(XBT))
 . S O=XBOUT(XBT),XBT=$P(O,"X")_XBT_$P(O,"X",2)
 . S XBFORM(XBFORM,XBLINE,XBCOL+.5)=XBT
 .Q
 S XBV=$P(XBT,"|"),XBV=XBVAR(XBV),XBS=$P(XBT,"|",2)
 I $L(XBS) S XBS="("_XBS_")"
 S XBFORM(XBFORM,XBLINE,XBCOL+.5)=XBV_XBS
 I $D(XBOUT(XBT)) D
 . S O=XBOUT(XBT),XBT=XBV_XBS,XBT=$P(O,"X")_XBT_$P(O,"X",2)
 . S XBFORM(XBFORM,XBLINE,XBCOL+.5)=XBT
 .Q
 Q
 ;
MAP ;** map shorthand for variables      
 ;#xx1|yyy1*xx2|yyy2*
 S Z=$E(Z,2,999)
 I Z'["*" S XBVSUB=$P(Z,"|"),XBVAL=$P(Z,"|",2),XBVAR(XBVSUB)=XBVAL Q
 F I=1:1 S P=$P(Z,"*",I) Q:P=""  S XBVSUB=$P(P,"|"),XBVAL=$P(P,"|",2),XBVAR(XBVSUB)=XBVAL
 Q
 ;
OUT ;** output tranform of data field
 ;*field|mumps output transform f(x)*
 S Z=$E(Z,2,999)
 I Z'["*" S XBVSUB=$P(Z,"!"),XBVAL=$P(Z,"!",2),XBOUT(XBVSUB)=XBVAL Q
 F I=1:1 S P=$P(Z,"*",I) Q:P=""  S XBVSUB=$P(P,"!"),XBVAL=$P(P,"!",2),XBOUT(XBVSUB)=XBVAL
 Q
 ;
TABS ;
 W #
 F %=0:1:7 W ?%*10,%*10
 F %=1:1:66 W !?1,%,?3,"..^...." F X=1:1:7 W "|....^...."
 Q
 ;
EXIT ;
 KILL %X,%Y,A,I,L,O,P,T,W,X
 KILL XBZ,XBFMT,XBCOL,XBCOLX,XBF,XBL,XBLINE,XBLN,XBLOAD,XBOUT,XBQUIT,XBROU,XBS,XBT,XBTAG,XBTAGE,XBV,XBVAL,XBVAR,XBVSUB,XBWP,XBWPDA,XBWPDIC,XBWPFLD,XBWPL,XBWPNODE,XBWPSUB,XBWWP,XBX,XBXL
 Q
 ;
MDY(X) ;external date to mm/dd/yy    x :: var or ~"NOW"~ or ~"TODAY"~
 S %DT="TS"
 D ^%DT
 ;begin Y2K fix block
 ;Q $E(Y,4,5)_"/"_$E(Y,6,7)_"/"_$E(Y,2,3)
 Q $E(Y,4,5)_"/"_$E(Y,6,7)_"/"_($E(Y,1,3)+1700) ;Y2000
 ;end Y2K fix block
 ;
WP(X) ;build wp entry   X #:: WP(FLD,n)=TEXTn
 NEW I,W
 S XBLWP=$G(XBLLINE),W=$P(X,")")
 F I=0:1 S X=$Q(@X) Q:X=""  Q:(W'=$P(X,","))  D
 . S T=@X,XBLLINE=XBLWP+I
 . S:'$G(XBFMT) XBZ(XBL+XBLLINE)=T
 . S:($G(XBFMT)=1) XBZ(XBL+XBLLINE,0)=T
 Q ""
 ;
