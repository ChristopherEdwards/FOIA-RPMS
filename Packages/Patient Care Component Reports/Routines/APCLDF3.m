APCLDF3 ; IHS/CMI/LAB -IHS ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
DATE ; - ENTRY POINT - from APCLDF2
 I BOOL="=" D EQUAL
 I BOOL=">" D GREATER
 I BOOL="<" D LESSTHAN
 I BOOL="<>" D GREATER,LESSTHAN
 I COND="LAST" D INVDATE
 Q
 ;
EQUAL ; Save nodes equal to visit date
 S %=0 F  S %=$O(^TMP("APCLDF",$J,"TMP",%)) Q:'%  I DATE'=% K ^(%)
 Q
 ;
GREATER ; Kill nodes less than indicated visit date plus 1
 ; e.g., if not "<>", after 1/1/87 kills nodes less than 2870102
 ; if =">", then kills nodes less than 2870101
 NEW TMPDATE
 I BOOL=">" S TMPDATE=DATE_.9999 S %="" F  S %=$O(^TMP("APCLDF",$J,"TMP",%)) Q:'%!(%>TMPDATE)  K ^(%)
 I BOOL="<>" S TMPDATE=STDATE-.0001 S %="" F  S %=$O(^TMP("APCLDF",$J,"TMP",%)) Q:'%!(%>TMPDATE)  K ^(%)
 Q
 ;
LESSTHAN ; Kill nodes greater than indicated visit date minus .0001
 ; e.g., less than 1/1/87 kills nodes greater than 2870100.9999
 S X=$S(BOOL="<>":EDATE+.9999,1:DATE-.0001)
 F  S X=$O(^TMP("APCLDF",$J,"TMP",X)) Q:'X  K ^(X)
 Q
 ;
INVDATE ; If COND is 'LAST', then invert date to have in latest to earliest
 S %="" F  S %=$O(^TMP("APCLDF",$J,"TMP",%)) Q:$E(%)>3!'%  F D=0:0 S D=$O(^TMP("APCLDF",$J,"TMP",%,D)) Q:'D  S ^TMP("APCLDF",$J,"TMP",9999999-%,D)=^(D) K ^TMP("APCLDF",$J,"TMP",%,D)
 Q
 ;
VISIT ; - ENTRY POINT - Evaluate visits
 S N=0
 I COND'="FIRST",DATE="" F D=0:0 S D=$O(^AUPNVSIT("AA",PAT,D)) Q:'D!(N>NUM)  F E=0:0 S E=$O(^(D,E)) Q:'E!(N>NUM)  S N=N+1 I N'>NUM S @(APCLY_N_")")=9999999-$P(D,".")_"^^VISIT^^"_E
 I COND="FIRST"!(DATE]"") S C=0 F D=0:0 S D=$O(^AUPNVSIT("AA",PAT,D)) D:'D DATE:DATE]"",VISRES Q:'D  F E=0:0 S E=$O(^AUPNVSIT("AA",PAT,D,E)) Q:'E  S C=C+1,^TMP("APCLDF",$J,"TMP",9999999-$P(D,"."),C)=9999999-$P(D,".")_"^^VISIT^^"_E
 K ^TMP("APCLDF",$J,"TMP")
 Q
 ;
VISRES ; Finds first n visits or visits as a result of date entered
 N D
 S I=0,%="" F  S %=$O(^TMP("APCLDF",$J,"TMP",%)) Q:'%  F D=0:0 S D=$O(^TMP("APCLDF",$J,"TMP",%,D)) S:D I=I+1 Q:'D!(I>NUM)  D
 . S @(APCLY_I_")")=^TMP("APCLDF",$J,"TMP",%,D)
 Q
 ;
