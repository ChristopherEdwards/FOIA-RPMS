BLRLRRP1 ;IHS/MSC/MKK - INTERIM REPORTS IHS Utilities ; 22-Oct-2013 09:22 ; MKK
 ;;5.2;LAB SERVICE;**1033**;NOV 01, 1997
 ;
EEP ; Ersatz EP
 D EEP^BLRGMENU
 Q
 ;
 ;from LRRP1,LRRP2
 ;
LRREFS ; EP - Reference Range
 I $L(LRREFS)<16 D
 . W ?43,$E(LRREFS,1,15),?55,$S(LRTHER:"(TR)",1:"")
 . W ?55,$S(LRTHER:"(TR)",1:"")
 . I LRPLS'="" W ?59,$J("["_LRPLS_"]",6)
 . W ?66,$$GETCOMPD^BLRUTIL4
 I $L(LRREFS)>15 D REFWRAP^BLRLRRP1
 K LRREFS
 Q
 ;
REFWRAP ; EP - Have to "wrap" the Reference Range string
 NEW LINE,LM,MAX,TAB
 ;
 S TAB=43,MAX=15
 ;
 ; Use FileMan DIWP routine to "wrap" string, if necessary.
 S X=LRREFS
 K ^UTILITY($J,"W")
 S LM=2
  S DIWL=LM,DIWR="",DIWF="C"_MAX
 D ^DIWP
 ;
 ; Use loop to output result without extra line feed
 S LINE=0
 F  S LINE=$O(^UTILITY($J,"W",LM,LINE))  Q:LINE<1  D
 . W:LINE=1 ?TAB
 . W:LINE>1 !,?TAB
 . W $$TRIM^XLFSTR($G(^UTILITY($J,"W",LM,LINE,0)),"L",$C(9))
 . I LINE=1 D
 .. W ?55,$S(LRTHER:"(TR)",1:"")
 .. I LRPLS'="" W ?59,$J("["_LRPLS_"]",6)
 .. W ?66,$$GETCOMPD^BLRUTIL4
 K ^UTILITY($J,"W")
 Q
 ;
CONDSPEC() ; EP - Specimen Condition
 S SPMCOND=$P($G(^LR(+LRDFN,"CH",+LRIDT,"IHS")),"^")
 W:$L(SPMCOND) !,?46,"Specimen Condition:",SPMCOND
 Q
