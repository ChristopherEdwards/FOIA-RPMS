XBLFSETS ;IHS/SET/GTH - LISTS FILE SETS ; [ 04/18/2003  9:06 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ;IHS/SET/GTH XB*3*9 10/29/2002 New Routine.
 ; This routine lists the following file information, useful for
 ; moving to a spreadsheet, or other desktop ap, for database
 ; Reference Terminology Modeling (RTM) activities:
 ; CodeSetID;Acronym;Name;Requirement;Source;Information;
 ;        Note;DataType;MinSize;MaxSize;File #;Field #
 ; The output is one line of data per field, semi-colon delimited.
 ; Only fields of type SET are reported.  Y/N fields are skipped.
 ; (See routine for more info.)
MORE ;
 ; CodeSetID: This is an identifier that is used to uniquely identify
 ;            the codeset.  Some of these codeset ids are the formal
 ;            standard identifier such as "ICD 9-CM" or "ISO 3166";
 ;            others have been assigned an unofficial codeset id.
 ; Acronym:   This is an abbreviated name for the codeset.
 ; Name:      This is the name of the codeset.
 ; Requirement: This is an indicator that specifies the codeset is
 ;            required by regulation.  An "H" denotes that the codeset
 ;            is required for HIPAA; an "O" denotes a requirement by
 ;            the Office of Management and Budget (OMB).
 ; Source:    This is the originating source of the codeset.
 ; Information: This is information about the codeset or the location
 ;            of information about the codeset.
 ; Note:      This contains notes that may assist in locating, using,
 ;            documenting, etc., the codeset.
 ; DateType:  This is the datatype of the codeset.
 ; MinSize:   This is the maximum character size of the coded value.
 ; MaxSize:   This is the minimum character size of the coded value.
 ;
START ;
 ; --- Display routine description.
 D HOME^%ZIS,DT^DICRW
 KILL ^UTILITY($J)
 S ^UTILITY($J,"XBLFSETS")=""
 D EN^XBRPTL
 KILL ^UTILITY($J)
 ; --- Get file(s).
 D ^XBDSET
 Q:'$D(^UTILITY("XBDSET",$J))
 S XBIHS=$$DIR^XBDIR("N^500:999:0","Enter the beginning CodeSet ID number",500,"The response must be a number")
 Q:Y="^"
 ; --- Select device.
 W !
 S %ZIS="Q",ZTSAVE("^UTILITY(""XBDSET"",$J,")="",ZTSAVE("XBIHS")=""
 D EN^XUTMDEVQ("EN^XBLFSETS","List File Sets",.ZTSAVE,.%ZIS)
 D EN^XBVK("ZT")
 Q
 ;
EN ;EP - from TaskMan.
VARS ;;F,N,X,W;Single-char work vars.
 ; F:File #
 NEW XBQFLG,@($P($T(VARS),";",3))
 S (XBQFLG,F)=0
 F  S F=$O(^UTILITY("XBDSET",$J,F)) Q:F'=+F  D PAGE Q:XBQFLG  D FIELDS(F) Q:XBQFLG
 D ^%ZISC
 Q
 ;
FIELDS(F) ; Process fields in File F.
 NEW X,XB
 S XB=0
 F  S XB=$O(^DD(F,XB)) Q:'(XB=+XB)  D  D:$Y>(IOSL-3) PAGE Q:XBQFLG
 . I $E($P($G(^DD(F,XB,0)),"^",1))="*" Q  ; field is deprecated.
 . I $P(^DD(F,XB,0),"^",2) D FIELDS($P(^(0),"^",2)) Q  ; Recurse sub-file.
 . S X=$$TYPE($P($G(^DD(F,XB,0)),"^",2))
 . I X'="SET" Q  ; Process only SETs.
 . I $P($$FINFO(F,XB),"<",2)="1:YES|0:NO|>" Q  ; Skip Y/N fields.
 . ; CodeSetID;Acronym;Name;Requirement;Source
 . S XBIHS=XBIHS+1
 . W "IHS"_$J(XBIHS,3,0)_";;"_$P($G(^DD(F,XB,0)),"^",1)_";;;"
 . ; Information;Note;DataType;MinSize;MaxSize;File #;Field #
 . W $$DESC(F,XB)_";"_$$FINFO(F,XB)_";"_$$TYPE($P($G(^DD(F,XB,0)),"^",2))_";;;"_F_";"_XB_";"
 . W !
 . Q
 Q
 ;
DESC(N,F) ; Field DESCRIPTION and Help-Prompt. N=File, F=Field
 NEW X,XB
 S X=""
 S X="File Number "_N_", '"_$$FNAME^XBFUNC(N)_"', Field # "_F_", In Global "_$$FGLOB^XBFUNC(N)_", DESCRIPTION <"
 F XB=0:0 S XB=$O(^DD(N,F,21,XB)) Q:'XB  S X=X_$G(^(XB,0))
 S X=X_"> HELP-PROMPT <"_$G(^DD(N,F,3))_">"
 Q X
 ;
TYPE(P) ; Return TYPE of field. Input is the 2nd piece of the 0th node.
 NEW W
 F W="BOOLEAN","COMPUTED","FREE TEXT","SET","DATE","NUMBER","POINTER","K","Z" I P[$E(W) Q
 Q $S(W'="Z":W,1:"?")
 ;
FINFO(N,F) ; Return SET values, or Pointed-To. N=File, F=Field
 NEW T
 S T=$$TYPE($P(^DD(N,F,0),"^",2))
 I T="SET" Q "Values <"_$TR($P($G(^DD(N,F,0)),"^",3),";","|")_">"
 I T="POINTER" Q " Points to "_$$FNAME^XBFUNC(+$P($P(^DD(N,F,0),"^",2),"P",2))_" file"
 Q "?"
 ;
PAGE ; PAGE BREAK
 NEW F,G,N,X
 I IO=IO(0),$E(IOST,1,2)="C-" S XBQFLG='$$DIR^XBDIR("E") I 'XBQFLG W @IOF
 Q
 ;
