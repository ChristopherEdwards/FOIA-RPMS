AMHLEFP3  ; IHS/TUCSON/LAB -VISIT DISPLAY ;     
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
S(Y,F,C,T) ;set up array
 I '$G(F) S F=0
 I '$G(T) S T=0
 ;blank lines
 F F=1:1:F S X="" D S1
 S X=Y
 I $G(C) S L=$L(Y),T=(80-L)/2 D  D S1 Q
 .F %=1:1:(T-1) S X=" "_X
 F %=1:1:T S X=" "_Y
 D S1
 Q
S1 ;
 S %=$P(^TMP("AMHS",$J,"DCS",0),U)+1,$P(^TMP("AMHS",$J,"DCS",0),U)=%
 S ^TMP("AMHS",$J,"DCS",%)="  "_X
 Q
TIUDSP ;EP
 S AMHSTR="" D S(AMHSTR)
 I '+$$CANDO^TIULP(AMHDOC,"PRINT RECORD",DUZ) Q  ;S AMHSTR="You do not have security clearance to display the TIU NOTE." D S(AMHSTR) Q
 ; Extract specified note
 S AMHGBL=$NA(^TMP("AMHOENPS",$J)),AMHHLF=IOM\2
 K @AMHGBL
 D EXTRACT^TIULQ(AMHDOC,AMHGBL,.AMHERR,".01;.02;.03;.05;.07;.08;1202;1203;1205;1208;1209;1301;1307;1402;1501:1505;1507:1513;1701","",1,"E")
 M AMHTIU=^TMP("AMHOENPS",$J,AMHDOC)
 K ^TMP("AMHOENPS",$J)
 S AMHSTR="TIU DOCUMENT:  "_AMHTIU(.01,"E") D S(AMHSTR)
 S AMHSTR="AUTHOR: "_AMHTIU(1202,"E") D S(AMHSTR)
 S AMHSTR="SIGNED BY: "_AMHTIU(1502,"E")_"               STATUS: "_AMHTIU(.05,"E") D S(AMHSTR)
 S AMHSTR="LOCATION: "_AMHTIU(1205,"E") D S(AMHSTR)
 F AMHX=0:0 S AMHX=$O(AMHTIU("TEXT",AMHX)) Q:'AMHX  S AMHSTR=AMHTIU("TEXT",AMHX,0) D S(AMHSTR)
 I $L($G(AMHTIU(1501,"E"))) D
 .S AMHSTR="/es/ "_$G(AMHTIU(1503,"E")) D S(AMHSTR)
 .S AMHSTR="Signed: "_$G(AMHTIU(1501,"E")) D S(AMHSTR)
 ;NOW GET ADDENDA USING "DAD" XREF
 I $O(^TIU(8925,"DAD",AMHDOC,0)) S AMHSTR="" D S(AMHSTR)   ;S AMHSTR="This document has addenda." D S(AMHSTR)
 S AMHX1=0 F  S AMHX1=$O(^TIU(8925,"DAD",AMHDOC,AMHX1)) Q:AMHX1'=+AMHX1  D
 .I '+$$CANDO^TIULP(AMHX1,"PRINT RECORD",DUZ) Q  ;S AMHSTR="You do not have security clearance to display the addendum." D S(AMHSTR) Q
 .S AMHGBL=$NA(^TMP("AMHOENPS",$J))
 .K @AMHGBL
 .K AMHTIU
 .D EXTRACT^TIULQ(AMHX1,AMHGBL,.AMHERR,".01;.02;.03;.05;.07;.08;1202;1203;1205;1208;1209;1301;1307;1402;1501:1505;1507:1513;1701","",1,"E")
 .M AMHTIU=^TMP("AMHOENPS",$J,AMHX1)
 .K ^TMP("AMHOENPS",$J)
 .S AMHSTR="" D S(AMHSTR)
 .S AMHSTR=AMHTIU(.01,"E") D S(AMHSTR)
 .S AMHSTR="AUTHOR: "_AMHTIU(1202,"E") D S(AMHSTR)
 .S AMHSTR="SIGNED BY: "_AMHTIU(1502,"E")_"               STATUS: "_AMHTIU(.05,"E") D S(AMHSTR)
 .S AMHSTR="LOCATION: "_AMHTIU(1205,"E") D S(AMHSTR)
 .F AMHX=0:0 S AMHX=$O(AMHTIU("TEXT",AMHX)) Q:'AMHX  S AMHSTR=AMHTIU("TEXT",AMHX,0) D S(AMHSTR)
 .I $L($G(AMHTIU(1501,"E"))) D
 ..S AMHSTR="/es/ "_$G(AMHTIU(1503,"E")) D S(AMHSTR)
 ..S AMHSTR="Signed: "_$G(AMHTIU(1501,"E")) D S(AMHSTR)
 ;
 Q
BUILD1 ;
 S AMHSTR=$E(AMHH,1,21)_":",AMHSTR=$$SETSTR^VALM1(AMHV,AMHSTR,24,$L(AMHV))
 D S(AMHSTR)
 Q
SAN ;EP
 Q:$G(AMHEFT)'="F"
 S AMHSTR="=============== "_"BH SAN DATA ITEMS"_" ===============",X=(80-$L(AMHSTR)\2) D S(AMHSTR,1) ;$J("",X)_AMHSTR D S(AMHSTR)
 I $P(^AMHREC(AMHR,0),U,33)="U" D SANU Q
1 ;
 K AMHAR
 D ENP^XBDIQ1(9002011,AMHR,"7701;7702;7703;7704;7706;7707;7901","AMHAR(","E")
 S F=0 F  S F=$O(AMHAR(F)) Q:F'=+F  I AMHAR(F)]"" D
 .S AMHH=$P(^DD(9002011,F,0),U)
 .S AMHV=AMHAR(F)
 .D BUILD1
2 ;
 K AMHAR
 F AMHX=7709,7717,7711,7712 I $D(^DD(9002011,AMHX,0)),$O(^AMHREC(AMHR,AMHX,0)) D
 .S AMHSTR=$P(^DD(9002011,AMHX,0),U) D S(AMHSTR)
 .K AMHAR D ENP^XBDIQ1(9002011,AMHR,AMHX,"AMHAR(","E")
 .S F=0 F  S F=$O(AMHAR(AMHX,F)) Q:F'=+F  S AMHSTR=AMHAR(AMHX,F) D S(AMHSTR)
 .S AMHSTR="" D S(AMHSTR)
 .Q
3 ;
 K AMHAR
 D ENP^XBDIQ1(9002011,AMHR,7713,"AMHAR(","E")
 S F=0 F  S F=$O(AMHAR(F)) Q:F'=+F  I AMHAR(F)]"" D
 .S AMHH=$P(^DD(9002011,F,0),U)
 .S AMHV=AMHAR(F)
 .D BUILD1
4 ;
 K AMHAR
 F AMHX=7715 I $D(^DD(9002011,AMHX,0)),$O(^AMHREC(AMHR,AMHX,0)) D
 .S AMHSTR=$P(^DD(9002011,AMHX,0),U) D S(AMHSTR)
 .K AMHAR D ENP^XBDIQ1(9002011,AMHR,AMHX,"AMHAR(","E")
 .S F=0 F  S F=$O(AMHAR(AMHX,F)) Q:F'=+F  S AMHSTR=AMHAR(AMHX,F) D S(AMHSTR)
 .S AMHSTR="" D S(AMHSTR)
5 ;
 K AMHAR
 D ENP^XBDIQ1(9002011,AMHR,"7902;7719;7721;7722;7903;7904;7905","AMHAR(","E")
 S F=0 F  S F=$O(AMHAR(F)) Q:F'=+F  I AMHAR(F)]"" D
 .S AMHH=$P(^DD(9002011,F,0),U)
 .S AMHV=AMHAR(F)
 .D BUILD1
6 ;
 K AMHAR
 F AMHX=7724 I $D(^DD(9002011,AMHX,0)),$O(^AMHREC(AMHR,AMHX,0)) D
 .S AMHSTR=$P(^DD(9002011,AMHX,0),U) D S(AMHSTR)
 .K AMHAR D ENP^XBDIQ1(9002011,AMHR,AMHX,"AMHAR(","E")
 .S F=0 F  S F=$O(AMHAR(AMHX,F)) Q:F'=+F  S AMHSTR=AMHAR(AMHX,F) D S(AMHSTR)
 .S AMHSTR="" D S(AMHSTR)
 .Q
 S AMHSTR="" D S(AMHSTR)
 Q
SANU ;
 K AMHAR
 F AMHX=7801 I $D(^DD(9002011,AMHX,0)),$O(^AMHREC(AMHR,AMHX,0)) D
 .S AMHSTR=$P(^DD(9002011,AMHX,0),U) D S(AMHSTR)
 .K AMHAR D ENP^XBDIQ1(9002011,AMHR,AMHX,"AMHAR(","E")
 .S F=0 F  S F=$O(AMHAR(AMHX,F)) Q:F'=+F  S AMHSTR=AMHAR(AMHX,F) D S(AMHSTR)
 .S AMHSTR="" D S(AMHSTR)
 .Q
78 ;
 K AMHAR
 D ENP^XBDIQ1(9002011,AMHR,7802,"AMHAR(","E")
 S F=0 F  S F=$O(AMHAR(F)) Q:F'=+F  I AMHAR(F)]"" D
 .S AMHH=$P(^DD(9002011,F,0),U)
 .S AMHV=AMHAR(F)
 .D BUILD1
783 ;
 K AMHAR
 F AMHX=7803:1:7805 I $D(^DD(9002011,AMHX,0)),$O(^AMHREC(AMHR,AMHX,0)) D
 .S AMHSTR=$P(^DD(9002011,AMHX,0),U) D S(AMHSTR)
 .K AMHAR D ENP^XBDIQ1(9002011,AMHR,AMHX,"AMHAR(","E")
 .S F=0 F  S F=$O(AMHAR(AMHX,F)) Q:F'=+F  S AMHSTR=AMHAR(AMHX,F) D S(AMHSTR)
 .S AMHSTR="" D S(AMHSTR)
 .Q
786 ; 
 K AMHAR
 D ENP^XBDIQ1(9002011,AMHR,7806,"AMHAR(","E")
 S F=0 F  S F=$O(AMHAR(F)) Q:F'=+F  I AMHAR(F)]"" D
 .S AMHH=$P(^DD(9002011,F,0),U)
 .S AMHV=AMHAR(F)
 .D BUILD1
787 ;
 K AMHAR
 F AMHX=7808:1:7809 I $D(^DD(9002011,AMHX,0)),$O(^AMHREC(AMHR,AMHX,0)) D
 .S AMHSTR=$P(^DD(9002011,AMHX,0),U) D S(AMHSTR)
 .K AMHAR D ENP^XBDIQ1(9002011,AMHR,AMHX,"AMHAR(","E")
 .S F=0 F  S F=$O(AMHAR(AMHX,F)) Q:F'=+F  S AMHSTR=AMHAR(AMHX,F) D S(AMHSTR)
 .S AMHSTR="" D S(AMHSTR)
 .Q
7811 ;
 K AMHAR
 D ENP^XBDIQ1(9002011,AMHR,"7811;7812","AMHAR(","E")
 S F=0 F  S F=$O(AMHAR(F)) Q:F'=+F  I AMHAR(F)]"" D
 .S AMHH=$P(^DD(9002011,F,0),U)
 .S AMHV=AMHAR(F)
 .D BUILD1
7813 ;
 K AMHAR
 F AMHX=7813 I $D(^DD(9002011,AMHX,0)),$O(^AMHREC(AMHR,AMHX,0)) D
 .S AMHSTR=$P(^DD(9002011,AMHX,0),U) D S(AMHSTR)
 .K AMHAR D ENP^XBDIQ1(9002011,AMHR,AMHX,"AMHAR(","E")
 .S F=0 F  S F=$O(AMHAR(AMHX,F)) Q:F'=+F  S AMHSTR=AMHAR(AMHX,F) D S(AMHSTR)
 .S AMHSTR="" D S(AMHSTR)
 .Q
XIT ;
 Q