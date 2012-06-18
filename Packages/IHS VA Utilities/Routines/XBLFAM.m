XBLFAM ;IHS/SET/GTH - LISTS FILE ATTRIBUTES FOR MODELING ; [ 04/18/2003  9:05 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ;IHS/SET/GTH XB*3*9 10/29/2002 New routine.
 ; This routine lists the following file attributes, useful for
 ; moving to a spreadsheet, or other desktop ap, for database
 ; modeling activities:
 ;
 ; File #, File Name, Field #, Field Label, Field type, Desc/Help.,
 ;    Min Length, Max Length
 ; The output is one line of data per field, semi-colon delimited.
 ;
 ; NOTE:  Fields marked for deletion with a "*" preceeding the label
 ;        are -not- processed.
 ;
 ; Thanks to George T. Huggins for the original routine.
 ;
START ;
 ; --- Display routine description.
 D HOME^%ZIS,DT^DICRW
 KILL ^UTILITY($J)
 S ^UTILITY($J,"XBLFAM")=""
 D EN^XBRPTL
 KILL ^UTILITY($J)
 ;
 ; --- Start processing.
 NEW QFLG
 S QFLG=0
 ;
 ; --- Get file(s).
 D ^XBDSET
 Q:'$D(^UTILITY("XBDSET",$J))
 ;
 ; --- Select device.
 W !
 S %ZIS="Q",ZTSAVE("^UTILITY(""XBDSET"",$J,")=""
 D EN^XUTMDEVQ("EN^XBLFAM","List Attributes for Modeling",.ZTSAVE,.%ZIS)
 D EN^XBVK("ZT")
 Q
 ;
EN ;EP - From TaskMan.
 ;
 ; --- Main loop:  thru selected file(s).
 NEW F,X
 ;
 ; F:File #
 ;
 S F=0
 F  S F=$O(^UTILITY("XBDSET",$J,F)) Q:F'=+F  D PAGE Q:QFLG  D FIELDS(F) Q:QFLG
 D ^%ZISC
 Q
 ; --- End main loop.
FIELDS(F) ; Process fields in File F.
 ; Field #, File #, File Name, Field Label, Field type, Desc/Help.
 NEW X,XB
 S X=""
 F XB=0:0 S XB=$O(^DD(F,XB)) Q:'(XB=+XB)  D  D:$Y>(IOSL-3) PAGE Q:QFLG
 . I $E($P($G(^DD(F,XB,0)),"^",1))="*" Q  ; field is deprecated.
 . I $P(^DD(F,XB,0),"^",2) W $$OUTLINE,! D FIELDS(+$P(^DD(F,XB,0),"^",2)) Q  ; Recurse sub-file.
 . W $$OUTLINE,!
 . Q
 Q
 ; -------------------------------------------------------
OUTLINE() ;
 ; File #, File Name, Field #, Field Label, Field type, Desc/Help.,
 ;    Min Length, Max Length
 Q F_";"_$$FNAME^XBFUNC(F)_";"_XB_";"_$P($G(^DD(F,XB,0)),"^",1)_";"_$$TYPE($P($G(^DD(F,XB,0)),"^",2))_";"_$$HP(F,XB)_$$DESC(F,XB)_$$TDESC(F,XB)_";"_$$MINL(F,XB)_";"_$$MAXL(F,XB)_";"
 ; -------------------------------------------------------
PAGE ; PAGE BREAK
 NEW F,G,N,X
 I IO=IO(0),$E(IOST,1,2)="C-" S QFLG='$$DIR^XBDIR("E") I 'QFLG W @IOF
 Q
 ; -------------------------------------------------------
MINL(N,F) ; Return minimum length
 NEW X
 S X=$P(^DD(N,F,0),"^",2)
 I X Q "-"
 I '(X["F") Q "-"
 S X=$P(^DD(N,F,0),"^",5,99)
 Q +$E(X,$F(X,"$L(X)<"),$L(X))
 ; -------------------------------------------------------
MAXL(N,F) ; Return maximum length
 NEW X
 S X=$P(^DD(N,F,0),"^",2)
 I X Q "-"
 I '(X["F") Q "-"
 S X=$P(^DD(N,F,0),"^",5,99)
 Q +$E(X,$F(X,"$L(X)>"),$L(X))
 ; -------------------------------------------------------
NUMBER(F) ;;.001;NUMBER
 Q F  ; well, duh
 ; -------------------------------------------------------
LABEL(N,F) ;;.01;LABEL
 Q $P($G(^DD(N,F,0)),"^",1)
 ; -------------------------------------------------------
TITLE(N,F) ;;.1;TITLE
 Q $P($G(^DD(N,F,.1)),"^",1)
 ; -------------------------------------------------------
 ;;.12;VARIABLE POINTER  (multiple)
 ; -------------------------------------------------------
 ;;.2;SPECIFIER
 ; -------------------------------------------------------
 ;;.23;LENGTH
 ; -------------------------------------------------------
 ;;.24;DECIMAL DEFAULT
 ; -------------------------------------------------------
TYPE(P) ;PEP;.25;TYPE
 ; Return TYPE of field. Input is the 2nd piece of the 0th node.
 I P Q "<SUBFILE>"
 NEW W
 F W="BOOLEAN","COMPUTED","FREE TEXT","SET","DATE","NUMBER","POINTER","WORD-PROCESSING","K","Z" I P[$E(W) Q
 I W="SET" S W=W_" <"_$TR($P($G(^DD(F,XB,0)),"^",3),";","|")_">"
 I W="POINTER" S W=W_" to "_$$FNAME^XBFUNC(+$P(P,"P",2))_" file"
 Q $S(W'="Z":W,1:"??")
 ; -------------------------------------------------------
 ;;.26;COMPUTE ALGORITHM
 ; -------------------------------------------------------
 ;;.27;SUB-FIELDS
 ; -------------------------------------------------------
 ;;.28;MULTIPLE-VALUED
 ; -------------------------------------------------------
 ;;.29;DEPTH OF SUB-FIELD
 ; -------------------------------------------------------
 ;;.3;POINTER
 ; -------------------------------------------------------
GSL(N,F) ;;.4;GLOBAL SUBSCRIPT LOCATION
 Q 0
 ; -------------------------------------------------------
IT(N,F) ;;.5;INPUT TRANSFORM
 Q $P($G(^DD(N,F,0)),"^",5,99)
 ; -------------------------------------------------------
 ;;1;CROSS-REFERENCE  (multiple)
 ; -------------------------------------------------------
AUDIT(N,F) ;;1.1;AUDIT
 Q $G(^DD(N,F,"AUDIT"))
 ; -------------------------------------------------------
 ;;1.2;AUDIT CONDITION
 ; -------------------------------------------------------
OT(N,F) ;;2;OUTPUT TRANSFORM
 Q $G(^DD(N,F,2.1))
 ; -------------------------------------------------------
HP(N,F) ;;3;'HELP'-PROMPT
 NEW X
 S X=$G(^DD(N,F,3))
 I '$L(X) Q ""
 Q "HELP-PROMPT("_$G(^DD(N,F,3))_")"
 ; -------------------------------------------------------
XH(N,F) ;;4;XECUTABLE 'HELP'
 Q $G(^DD(N,F,4))
 ; -------------------------------------------------------
RA(N,F) ;;8;READ ACCESS (OPTIONAL)
 Q $G(^DD(N,F,8))
 ; -------------------------------------------------------
DA(N,F) ;;8.5;DELETE ACCESS (OPTIONAL)
 Q $G(^DD(N,F,8.5))
 ; -------------------------------------------------------
WA(N,F) ;;9;WRITE ACCESS (OPTIONAL)
 Q $G(^DD(N,F,9))
 ; -------------------------------------------------------
 ;;9.01;COMPUTED FIELDS USED
 ; -------------------------------------------------------
SRC(N,F) ;;10;SOURCE
 Q $G(^DD(N,F,10))
 ; -------------------------------------------------------
 ;;11;DESTINATION  (multiple)
 ; -------------------------------------------------------
 ;;12;POINTER SCREEN
 ; -------------------------------------------------------
 ;;12.1;CODE TO SET POINTER SCREEN
 ; -------------------------------------------------------
 ;;12.2;EXPRESSION FOR POINTER SCREEN
 ; -------------------------------------------------------
 ;;20;GROUP  (multiple)
 ; -------------------------------------------------------
DESC(N,F) ;;21;DESCRIPTION  (word-processing)
 ; Field DESCRIPTION and Help-Prompt. N=File, F=Field
 NEW X,XB
 S X=""
 F XB=0:0 S XB=$O(^DD(N,F,21,XB)) Q:'XB  S X=X_$G(^(XB,0))
 I '$L(X) Q ""
 Q "DESCRIPTION("_X_")"
 ; -------------------------------------------------------
TDESC(N,F) ;;23;TECHNICAL DESCRIPTION  (word-processing)
 NEW X,XB
 S X=""
 F XB=0:0 S XB=$O(^DD(N,F,23,XB)) Q:'XB  S X=X_$G(^(XB,0))
 I '$L(X) Q ""
 Q "TECH_DESCRIPTION("_X_")"
 ; -------------------------------------------------------
DFLE(N,F) ;;50;DATE FIELD LAST EDITED
 Q $$FMTE^XLFDT($G(^DD(N,F,"DT")))
 ; -------------------------------------------------------
 ;;999;TRIGGERED-BY POINTER  (multiple)
 ; -------------------------------------------------------
 ;
