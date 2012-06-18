ABSPOSMB ; IHS/FCS/DRS - General Inquiry/Report .57; [ 09/12/2002  10:14 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 Q
JOIN ;EP - various options from ABSPOSMA join here
 N X,DEFDATES
A ;S X=$$MODE^ABSPOSMZ
 S X="I" ; always Inquiry mode?
 I X="I" S ABSPOSMA("MODE")="INQUIRY"
 E  I X="R" S ABSPOSMA("MODE")="REPORT"
 E  Q
B I '$D(ABSPOSMA("SORT")) G D     ;if doing a Fileman sort, skip date range
 D DEFDATES ; set default sort dates
 S X=$$SORTDATE^ABSPOSMZ I X="" G A
 I X="T" D
 . S ABSPOSMA("BY WHICH DATE")="TRANSACTION"
 . K ABSPOSMA("SORT",9999.95)
 E  I X="R" D
 . S ABSPOSMA("BY WHICH DATE")="RELEASED"
 E  Q
C S X=$$DATES^ABSPOSMZ(DEFDATES) G:'X B
 I ABSPOSMA("BY WHICH DATE")="TRANSACTION" D
 . S ABSPOSMA("SORT",7,"FR")=$P(X,U)
 . S ABSPOSMA("SORT",7,"TO")=$P(X,U,2)
 . K ABSPOSMA("SORT",9999.95)
 . D AUTO^ABSPOSM1() ; have to do this because of "AE" screen
 E  D  ; released dates:  compute equivalent transaction dates
 . S ABSPOSMA("SORT",9999.95,"FR")=$P(X,U)
 . S ABSPOSMA("SORT",9999.95,"TO")=$P(X,U,2)
 . S X=$$FILE61(X)
 . I 'X D
 . . W !,"No transactions in this range of released dates?!",!
 . S ABSPOSMA("SORT",7,"FR")=$P(X,U)
 . S ABSPOSMA("SORT",7,"TO")=$P(X,U,2)
 I 'ABSPOSMA("SORT",7,"FR") G B
D ; If in report mode, then get the type of output right now
 I ABSPOSMA("MODE")="REPORT" D  G:X="" C
 . S X=$$OUTPUT^ABSPOSMZ Q:X=""
 . S ABSPOSMA("OUTPUT TYPE")=X
 W ! G CONTINUE^ABSPOSMC
FILE61(X) ; given X = low^high date range of released dates
 ; figure out range of transaction dates needed to include all of them
 ; This will make the sort efficient.
 ; return low^high range of transaction dates
 D AUTO^ABSPOSM1() ; update last couple days of 9002313.61
 N TLO,THI S TLO=9999999,THI=-1
 N RLO,RHI S RLO=$P(X,U)\1,RHI=$P(X,U,2)\1 ; stored w/o time in .61
 N RDT S RDT=RLO
 N IEN61 S IEN61=0
 F  D  S RDT=$O(^ABSPECX("RPT","B",RDT)) Q:'RDT  Q:RDT>RHI  D
 . ; loop through all released on this date
 . S IEN61=0 F  S IEN61=$O(^ABSPECX("RPT","B",RDT,IEN61)) Q:'IEN61  D
 . . N IEN57 S IEN57=$P(^ABSPECX("RPT",IEN61,0),U,3)
 . . N X S X=$P($G(^ABSPTL(IEN57,0)),U,8) ; transaction date
 . . S:X<TLO TLO=X S:X>THI THI=X
 I TLO>THI Q "" ; none?!
 Q TLO_U_THI
DEFDATES ; set DEFDATES=start^end default sort dates
 N X S X=$O(ABSPOSMA("SORT"," ")) ; what are we sorting on?
 ; by Patient or by Claim ID, we go back a year
 I X="PATIENT"!(X="CLAIM:Claim ID") S DEFDATES=DT-10000
 E  S DEFDATES=DT ; for others, it's today only
 I $P(DEFDATES,U,2)="" S $P(DEFDATES,U,2)=DT
 ; If start date default is today and there are no transactions,
 ; set the default start date to yesterday
 I $P(DEFDATES,U)=DT,'$O(^ABSPTL("AH",DT)) S $P(DEFDATES,U)=$$YESTER
 Q
YESTER() Q $$TADD^ABSPOSUD(DT,-1) ; yesterday
