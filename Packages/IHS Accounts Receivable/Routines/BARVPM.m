BARVPM ; IHS/SD/LSL - MAP VP FIELDS TO TARGET FILES DEC 4,1996 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**16**;OCT 22,2008
 ;;
 ; IHS/SD/LSL - 02/25/2002 - V1.6 Patch 2 - NOIS LTA-0202-160141
 ;     Modified VALI line tag to find NON-BENEFICIARY insurer type on
 ;     A/R Patient accounts.  Similar to what is done in VAL.
 ;
 ; M2 TMM 01/13/2010 (BAR 1.8*16) - HEAT 8163. Resolve error <SYNTAX>EN+21^BARPTR
 ; 
 ; *********************************************************************
 ;
VAL(X) ;EP
 N Y,V,P,F,I,Z
 ; P-Pt value; F-Field
 ; V-VP File, Y-Internal of .01
 ; L-Line
 S Y=$P($G(^BARAC(DUZ(2),D0,0)),U)
 S P=$P(Y,";"),V=$P(Y,";",2)
 ; Resolve/Redirect remote pointers
 I V="AUPNPAT(" S V="DPT("
 ;
 F I=1:1 S L=$P($T(FILES+I),";;",2,999) Q:L=""  Q:(V=$P(L,U))
 I L="" Q ""
 S L=$P(L,U,2),F=$P(L,";",X)
 I X'=8,F="" Q ""
 S V="^"_V
 ;I V="^DPT(",X=8 D                              ;M2*DEL*TMM
 I "^DPT(_^VA(200,"[V,X=8 D                      ;M2*ADD*TMM
 . S V="^AUTNINS("
 . S P=$O(^AUTNINS("B","NON-BENEFICIARY PATIENT",0))
 . S F=".21"
 S Z=$$VAL^XBDIQ1(V,P,F)
 Q Z
 ; *********************************************************************
 ;
VALI(X) ;EP
 N Y,V,P,F,I,Z
 ; P-Pt value; F-Field
 ; V-VP File, Y-Internal of .01
 ; L-Line
 S Y=$P($G(^BARAC(DUZ(2),D0,0)),U)
 S P=$P(Y,";"),V=$P(Y,";",2)
 ; Resolve/Redirect remote pointers
 I V="AUPNPAT(" S V="DPT("
 ;
 F I=1:1 S L=$P($T(FILES+I),";;",2,999) Q:L=""  Q:(V=$P(L,U))
 I L="" Q ""
 S L=$P(L,U,2),F=$P(L,";",X)
 I X'=8,F="" Q ""
 S V="^"_V
 ;I V="^DPT(",X=8 D                              ;M2*DEL*TMM
 I "^DPT(_^VA(200,"[V,X=8 D                      ;M2*ADD*TMM
 . S V="^AUTNINS("
 . S P=$O(^AUTNINS("B","NON-BENEFICIARY PATIENT",0))
 . S F=".21"
 S Z=$$VALI^XBDIQ1(V,P,F)
 Q Z
 ; *********************************************************************
 ;
 ; dd field modified ($T ref)
FILES ;global^
 ;;AUTNINS(^.02;;;.03;.04;.05;.06;.21
 ;;VA(200,^.111;.112;.113;.114;.115;.116;.131
 ;;DPT(^.111;.112;.113;.114;.115;.116;.131
 ;;AUTTVNDR(^1306;1310;;1307;1308;1309;1109
END ;;
DIC() ;EP
 Q $P($$VALI^XBDIQ1(90050.02,D0,.01),";",2)
 ; *********************************************************************
 ;
IEN() ;EP
 Q +$$VALI^XBDIQ1(90050.02,D0,.01)
 ; *********************************************************************
 ;
NUM() ;EP
 S Z="^"_$$DIC^BARVPM()_"0)"
 S Z=$P(@Z,"^",2),Z=+Z
 Q Z
 ; *********************************************************************
 ;
 ; dd field modified ($T ref)
DOC ;document pieces
1 ;;STREET ADDRESS 1
2 ;;STREET ADDRESS 2
3 ;;STREET ADDRESS 3
4 ;;CITY
5 ;;STATE
6 ;;ZIP
7 ;;PHONE
8 ;;VP INSURER TYPE
