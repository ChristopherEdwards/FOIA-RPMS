XBCSPC ; IHS/ADC/GTH - CHECK POTENTIAL SPECIFIER FIELDS ; [ 11/04/97  10:26 AM ]
 ;;3.0;IHS/VA UTILITIES;**5**;FEB 07, 1997
 ; XB*3*5 IHS/ADC/GTH 10-30-97 Fix bug in count of duplicate values.
 ;
 ; This routine checks selected field to see what percent of
 ; the time it exists in the entries in a file, and if it
 ; should be unique, it makes sure it is unique.
 ;
START ;
 NEW CTRD,CTRT,CTRU,CTRX,ENTRY,FGBL,FIELD,FILE,NODE,PIECE,UNIQUE,XREF
 D ^XBKVAR
 F  D FILE Q:Y<1
 D EOJ
 Q
 ;
FILE ;
 W !
 I '$G(EXTERNAL) D  Q:Y<1
 . S DIC=1,DIC(0)="AEMQ"
 . D ^DIC
 . KILL DIC
 . Q:Y<1
 . S FILE=+Y
 .Q
 S FGBL=^DIC(FILE,0,"GL"),X=$O(@(FGBL_"0)"))
 I X'=+X W "  No data in file",*7 Q
 F  D FIELD Q:Y<0
 S Y=1
 Q
 ;
FIELD ;
 I '$G(EXTERNAL) D  Q:Y<0
 . S DIC="^DD("_FILE_",",DIC(0)="AEMQ"
 . D ^DIC
 . KILL DIC
 . Q:Y<0
 . S FIELD=+Y
 .Q
 D FLD^XBFDINFO(FILE,FIELD,.X)
 I '$D(X("NODE")) W *7 Q
 I X("NODE")="" W *7 Q
 S NODE=X("NODE"),PIECE=X("PIECE")
 KILL DIRUT,X
 I '$G(EXTERNAL) S UNIQUE=$$DIR^XBDIR("YO","Should field be unique","NO")
 Q:$D(DIRUT)
 D:UNIQUE CHKXREF
 D CHKDATA
 D LIST
 S:$G(EXTERNAL) Y=-1
 Q
 ;
LIST ;
 W !!,CTRT," entries in file.",!,$FN(CTRD/CTRT*100,"T",2)," percent of entries have data.  ",$S(CTRT'=CTRD:CTRT-CTRD_" without data.",1:"")
 I UNIQUE,XREF'="" D
 . I CTRX=0 W !,"All entries with data have xref."
 . E  W !,CTRD-CTRX," entr",$S(CTRD-CTRX=1:"y",1:"ies"),", ",$FN(CTRX/CTRD*100,"T",2)," percent of entries with data have no xref."
 . Q
 I UNIQUE D
 . I CTRU=0 W !,"All ",$P(^DD(FILE,FIELD,0),U,1)," field values are unique."
 . E  W !,CTRU,$S(CTRU=1:" entry has a value that is ",1:" entries have values that are "),"not unique."
 . I '$G(EXTERNAL),CTRU W !,"If you want to see duplicate values select global ^TMP(""XBCSPC"",",$J,"," KILL ^TMP("XBCSPC",$J,1) D ^%G
 . Q
 W !
 Q
 ;
CHKXREF ; SEE IF UNIQUE SPECIFIER HAS REGULAR XREF
 Q:$G(XREF)'=""
 S XREF=""
 D XREF^XBGXREFS(FILE,FIELD,.X)
 F I=0:0 S I=$O(X(FIELD,I)) Q:I'=+I  I $P(X(FIELD,I),"^",3)="" S XREF=$P(X(FIELD,I),"^",2),XREF=""""_XREF_"""" Q
 KILL X
 I 'I W !,"The ",FIELD," field does not have a REGULAR xref."
 E  W !,"Using the ",XREF," xref on the ",FIELD," field."
 Q
 ;
CHKDATA ; CHECK DATA IN SELECTED FIELD
 W !,"Checking data.  Please wait. "
 KILL ^TMP("XBCSPC",$J)
 S (CTRT,CTRD,CTRU,CTRX)=0
 F ENTRY=0:0 S ENTRY=$O(@(FGBL_ENTRY_")")) Q:ENTRY'=+ENTRY  D
 . S CTRT=CTRT+1
 . Q:'$D(@(FGBL_ENTRY_","_NODE_")"))
 . S X=$P(@(FGBL_ENTRY_","_NODE_")"),"^",PIECE)
 . Q:X=""
 . S CTRD=CTRD+1
 . I UNIQUE,XREF'="",'$D(@(FGBL_XREF_","""_X_""","_ENTRY_")")) S CTRX=CTRX+1
 . I UNIQUE D
 .. ; I $D(^TMP("XBCSPC",$J,1,X)) S CTRU=CTRU+1,^TMP("XBCSPC",$J,2,X)=cCTRX ; XB*3*5 IHS/ADC/GTH 10-30-97 Fix bug in count of duplicate values.
 .. I $D(^TMP("XBCSPC",$J,1,X)) S CTRU=CTRU+1,^(X)=$S($G(^TMP("XBCSPC",$J,2,X)):^(X)+1,1:2) ; XB*3*5 IHS/ADC/GTH 10-30-97 Fix bug in count of duplicate values.
 .. E  S ^TMP("XBCSPC",$J,1,X)=0
 .. Q
 . Q
 Q
 ;
EN(FILE,FIELD,XREF,UNIQUE) ; EXTERNAL ENTRY POINT TO ALLOW SPECIFID FILE/FIELD
 ; pass by value  *** will abort if values not passed ***
 NEW CTRD,CTRT,CTRU,CTRX,ENTRY,EXTERNAL,FGBL,NODE,PIECE
 S EXTERNAL=1
 I FILE,FIELD,XREF'="",UNIQUE'=""
 E  Q
 S XREF=""""_XREF_""""
 D FILE
 KILL DIRUT,I,X,Y
 Q
 ;
EOJ ;
 KILL DIRUT,I,X,Y
 KILL ^TMP("XBCSPC",$J)
 Q
 ;
