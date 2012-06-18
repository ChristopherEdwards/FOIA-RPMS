KMPUTL1 ;SF/RAK - Capacity Management Date Range Utility ; 11/19/98
 ;;1.0
DATERNG(KMPUY,KMPUSTR,KMPUEND) ;-- date range
 ;---------------------------------------------------------------------
 ; KMPUY..... Value returned in four pieces:
 ;            fmstartdate^fmenddate^ouputstartdate^outputenddate
 ;
 ;            Piece one and two are the date ranges in fileman format.
 ;            Piece three and four are the same dates in output format:
 ;                             dy-Mon-yr
 ;
 ;                               ********
 ;                               * NOTE *
 ;                               ********
 ;          - The first piece will always be the earliest date entered.
 ;
 ;  Optional Parameters:
 ;
 ; KMPUSTR... If defined, the earliest date that may be selected.
 ;            (must be in fileman format)
 ;
 ; KMPUEND... If defined, the latest date that may be selected.
 ;            (must be in fileman format)
 ;-----------------------------------------------------------------------
 ;
 N DATE1,DATE2,DIR,DIRUT,LINE,X,Y
 ;
 S KMPUY="",KMPUSTR=$G(KMPUSTR),KMPUEND=$G(KMPUEND)
 ;
RANGE ;-- Ask date ranges
 S DIR(0)="DOA^"_$S(KMPUSTR:KMPUSTR,1:"")_":"_$S(KMPUEND:KMPUEND,1:"")_":E)"
 S DIR("A")="Start with Date: "
 S:KMPUSTR DIR("B")=$$FMTE^XLFDT(KMPUSTR,2)
 S DIR("?")=" "
 S DIR("?",1)="Enter the starting date.",LINE=2
 ; if starting date.
 I KMPUSTR D 
 .S DIR("?",LINE)="Date must not precede "_$$FMTE^XLFDT(KMPUSTR)
 .S LINE=LINE+1
 ; if ending date.
 I KMPUEND S DIR("?",LINE)="Date must not follow "_$$FMTE^XLFDT(KMPUEND)
 W ! D ^DIR I $D(DIRUT) S KMPUY="" Q
 S DATE1=Y
 S DIR("A")="  End with Date: "
 S:KMPUEND DIR("B")=$$FMTE^XLFDT(KMPUEND,2)
 S DIR("?",1)="Enter the ending date."
 D ^DIR G:Y="" RANGE I Y="^" S KMPUY="" Q
 S DATE2=Y
 ; Set earliest date into first piece.
 S KMPUY=$S(DATE2<DATE1:DATE2,1:DATE1)_U_$S(DATE2>DATE1:DATE2,1:DATE1)
 S $P(KMPUY,U,3)=$$FMTE^XLFDT($P(KMPUY,U))
 S $P(KMPUY,U,4)=$$FMTE^XLFDT($P(KMPUY,U,2))
 Q
