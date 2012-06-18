BIREP ;IHS/CMI/MWR - REPORT, GENERIC DISPLAYS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  GENERIC DISPLAY TEXT FOR REPORTS.
 ;
 ;
 ;----------
DISP(BILINE,BINOD,BIAR,BIITEM,BIMENU,BINDX,BIAL,BINDNT,BITAB2,BIITEM2,BIAPP) ;EP
 ;---> Display Report Parameter Setting on report menu.
 ;---> Parameters:
 ;     1 - BILINE  (ret) Last line# written.
 ;     2 - BINOD   (req) Node in ^TMP to store lines under.
 ;     3 - BIAR    (opt) Local array of IEN's for this parameter
 ;                       (BICC, BIHCF, etc.)
 ;     4 - BIITEM  (req) Generic name of item.
 ;     5 - BIMENU  (req) The Menu Number of this parameter.
 ;     6 - BINDX   (req) The index of call (below) for text of a single entry.
 ;     7 - BIAL    (opt) Add additional linefeeds after paramter
 ;                       display. (Default is 1.)
 ;     8 - BINDNT  (opt) Left indent (default=4).
 ;     9 - BITAB2  (opt) Second tab postion where ":" occurs (default=36).
 ;    10 - BIITEM2 (opt) Generic item name in "# Items Selected" prompt.
 ;    11 - BIAPP   (opt) Text to append to display line (such as date range)
 ;                       or on new line below at same ":" tab.
 ;
 I '$D(BILINE)!('$D(BINOD))!('$D(BIITEM))!('$D(BIMENU)) D  Q
 .D ERRCD^BIUTL2(669,,1)
 ;
 N BIAR1,BIITEMS,I,X S BIAR1=""
 S:'$G(BINDX) BINDX=0
 S:'$G(BINDNT) BINDNT=4
 S:'$G(BITAB2) BITAB2=36
 ;---> Get plural form of item name.
 D PLURAL^BISELECT(BIITEM,.BIITEMS)
 D
 .S:'$D(BIAR) BIAR("ALL")=""
 .I $D(BIAR("ALL")) S BIAR1="ALL" Q
 .N I,M,N,P S (N,P)=0
 .F I=0:1 S N=$O(BIAR(N)) Q:'N  S M=N,P=P+1
 .;---> If only one item, get the text of its name.
 .I I=1&(BINDX=1) S BIAR1=$$CCTX^BIUTL6(M) Q
 .I I=1&(BINDX=2) S BIAR1=$$INSTTX^BIUTL6(M) Q
 .I I=1&(BINDX=3) S BIAR1=$$PERSON^BIUTL1(M) Q
 .I I=1&(BINDX=4) S BIAR1=$$BENTX^BIUTL6(M) Q
 .I I=1&(BINDX=5) S BIAR1=$$CCTX^BIUTL6(M) Q
 .I I=1&(BINDX=6) S BIAR1=$$VNAME^BIUTL2(M) Q
 .I I=1&(BINDX=7) S BIAR1=$$LOTTX^BIUTL6(M) Q
 .;---> Prototype line for new calls:
 .;I I=1&(BINDX=6) S BIAR1=$$CALL^ROUTINE(M) Q
 .S BIAR1=P_" "_$S(I=1:BIITEM,$D(BIITEM2):BIITEM2,1:BIITEMS)_" selected."
 ;
 S X="" F I=1:1:BINDNT S X=X_" "
 S X=X_$S(BIMENU>9:"",1:" ")_BIMENU_" - "_BIITEM
 S X=$$PAD^BIUTL5(X,BITAB2,".")_": "_BIAR1
 ;
 ;---> If there's something to append and it fits, append it; if the resulting
 ;---> line would be too long, then write the append on a second line after.
 ;---> Killing BIAPP signals that it was appended and does not need another line.
 I $G(BIAPP)]"",$L(X_BIAPP)<78 S X=X_BIAPP K BIAPP
 ;
 ;---> If additional blank lines were to be added, add them to the append.
 I $G(BIAPP)]"",$G(BIAL) N BIAL1 S BIAL1=BIAL,BIAL=0
 ;
 D WL^BIW(.BILINE,BINOD,X,$S($D(BIAL):+BIAL,1:1))
 ;---> If there's something to append and it did not fit, write a second line.
 I $G(BIAPP)]"" S X=BIAPP,X=$$SP^BIUTL5(BITAB2+1)_X D WL^BIW(.BILINE,BINOD,X,$G(BIAL1))
 Q
 ;
 ;
 ;----------
DATE(BILINE,BINOD,BIMENU,BIDT,BIDTTX,BIAL,BINDNT,BITAB2,BISL) ;EP
 ;---> Display Report Parameter Date Range.
 ;---> Parameters:
 ;     1 - BILINE  (ret) Last line# written.
 ;     2 - BINOD   (req) Node in ^TMP to store lines under.
 ;     3 - BIMENU  (req) The Menu Number of this parameter.
 ;     4 - BIDT    (opt) Date.
 ;     5 - BIDTTX  (opt) Text describing date.
 ;     6 - BIAL    (opt) Add additional linefeeds after paramter
 ;                       display. (Default is 1.)
 ;     7 - BINDNT  (opt) Left indent (default=4).
 ;     8 - BITAB2  (opt) Second tab postion where ":" occurs (default=36).
 ;     9 - BISL    (opt) If BISL=1 return slash dates.
 ;
 I '$D(BILINE)!('$D(BINOD))!('$D(BIMENU)) D  Q
 .D ERRCD^BIUTL2(669,,1)
 ;
 S:'$G(BINDNT) BINDNT=4 S:'$G(BITAB2) BITAB2=36
 N X D WL^BIW(.BILINE,BINOD)
 S X="" F I=1:1:BINDNT S X=X_" "
 S X=X_$S(BIMENU>9:"",1:" ")_BIMENU_" - "_$G(BIDTTX)
 S X=$$PAD^BIUTL5(X,BITAB2,".")_": "
 S:$G(BIDT) X=X_$S($G(BISL):$$SLDT1^BIUTL5(BIDT),1:$$TXDT1^BIUTL5(BIDT))
 D WL^BIW(.BILINE,BINOD,X,$S($D(BIAL):+BIAL,1:1))
 Q
 ;
 ;
 ;----------
DATERNG(BILINE,BINOD,BIMENU,BIBEGDT,BIENDDT,BIAL,BIONELN,BISL) ;EP
 ;---> Display Report Parameter Date Range.
 ;---> Parameters:
 ;     1 - BILINE  (ret) Last line# written.
 ;     2 - BINOD   (req) Node in ^TMP to store lines under.
 ;     3 - BIMENU  (req) The Menu Number of this parameter.
 ;     4 - BIBEGDT (opt) Begin date of report.
 ;     5 - BIENDDT (opt) End date of report.
 ;     6 - BIAL    (opt) Add additional linefeeds after paramter
 ;                       display. (Default is 1.)
 ;     7 - BIONELN (opt) Write beginning and end date on one line.
 ;     8 - BISL    (opt) If BISL=1 return slash dates.
 ;
 I '$D(BILINE)!('$D(BINOD))!('$D(BIMENU)) D  Q
 .D ERRCD^BIUTL2(669,,1)
 ;
 D WL^BIW(.BILINE,BINOD,,1)
 S:'$G(BIBEGDT) BIBEGDT="" S:'$G(BIENDDT) BIENDDT=""
 N X S X="    "_$S(BIMENU>9:"",1:" ")_BIMENU_" - Date Range............."
 ;
 ;---> If not "one line" display, split Date Range into two lines.
 D
 .I '$G(BIONELN) D  Q
 ..S X=X_"from: "_$S($G(BISL):$$SLDT1^BIUTL5(BIBEGDT),1:$$TXDT1^BIUTL5(BIBEGDT))
 ..D WL^BIW(.BILINE,BINOD,X)
 ..S X="                                  to: "
 .S X=X_"....: "_$S($G(BISL):$$SLDT1^BIUTL5(BIBEGDT),1:$$TXDT1^BIUTL5(BIBEGDT))
 .S X=X_" - "
 S X=X_$S($G(BISL):$$SLDT1^BIUTL5(BIENDDT),1:$$TXDT1^BIUTL5(BIENDDT))
 D WL^BIW(.BILINE,BINOD,X,$S($D(BIAL):+BIAL,1:1))
 Q
 ;
 ;
 ;----------
VTYPE(BILINE,BINOD,BIAR,BIMENU,BIAL) ;EP
 ;---> Display Report Parameter Visit Type.
 ;---> Parameters:
 ;     1 - BILINE  (ret) Last line# written.
 ;     2 - BINOD   (req) Node in ^TMP to store lines under.
 ;     3 - BIAR    (opt) Local array of pieces of Visit Type (set of codes).
 ;     4 - BIMENU  (req) The Menu Number of this parameter.
 ;     5 - BIAL    (opt) Add additional linefeeds after paramter
 ;                       display. (Default is 1.)
 ;
 I '$D(BILINE)!('$D(BINOD)!('$D(BIMENU))) D  Q
 .D ERRCD^BIUTL2(669,,1)
 ;
 N BIAR1,BIITEM,BIITEMS,X S BIAR1="",BIITEM="Visit Type"
 ;---> Get plural form of item name.
 D PLURAL^BISELECT(BIITEM,.BIITEMS)
 D
 .S:'$D(BIAR) BIAR("ALL")=""
 .I $D(BIAR("ALL")) S BIAR1="ALL" Q
 .N I,M,N,P
 .S (N,P)=0
 .F I=0:1 S N=$O(BIAR(N)) Q:N=""  S M=N,P=P+1
 .I I=1 D  Q
 ..N BISET S BISET=$P(^DD(9000010,.03,0),U,3)
 ..S BIAR1=$P($P(BISET,M_":",2),";") Q
 .S BIAR1=P_" "_$S(I=1:BIITEM,1:BIITEMS)_" selected."
 ;
 S X="    "_$S(BIMENU>9:"",1:" ")_BIMENU_" - "_BIITEM
 S X=$$PAD^BIUTL5(X,36,".")_": "_BIAR1
 D WL^BIW(.BILINE,BINOD,X,$S($D(BIAL):+BIAL,1:1))
 Q
 ;
 ;
EXAMPLES ;EP
 ;---> Include Historical.
 N BIHIST1 S BIHIST1=""
 S:'$D(BIHIST) BIHIST=1
 S BIHIST1=$S(BIHIST:"YES",1:"NO")
 S X="     7 - Include Historical..: "_BIHIST1
 D WRITE(.BILINE,X)
 K X
 ;
 ;
 ;---> Finish up Listmanager List Count.
 S VALMCNT=BILINE
 S BIRTN="BIREPA"
 Q
 ;
 ;
 ;----------
PPFILTR(BIDFN,BIHCF,BIQDT,BIUP) ;EP
 ;---> Patient Population Filter.
 ;---> Return 1 if Patient should be included; otherwise return 0.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient IEN.
 ;     2 - BIQDT  (req) Quarter Ending Date.
 ;     3 - BIHCF  (req) Health Care Facility array.
 ;     4 - BIUP   (req) User Population/Group (All, Imm, User, Active).
 ;
 ;---> Example:
 ;---> Filter for standard Patient Population parameter.
 ;Q:'$$PPFILTR^BIREP(BIDFN,.BIHCF,BIQDT,BIUP)
 ;
 ;
 Q:'$G(BIDFN) 0
 Q:'$G(BIQDT) 0
 Q:'$D(BIHCF) 0
 Q:'$D(BIUP) 0
 ;
 ;I BIDFN=4 X ^O
 ;---> If patient died before the Quarter Ending Date, return 0.
 N X S X=$$DECEASED^BIUTL1(BIDFN,1) I X Q:X<BIQDT 0
 ;
 ;---> If patient does not have an Active HRCN at one or more
 ;---> of the Health Care Facilities selected (BIUP="r"), return 0.
 Q:$$HRCN^BIEXPRT2(BIDFN,.BIHCF) 0
 ;
 ;---> If Patient Pop filter is for patients Active in the Imm Register,
 ;---> and patient became Inactive before the Quarter Ending Date, return 0.
 ;---> (Return 0 for patients whose "Inactive Date"="Not in Register.")
 I BIUP="i" N X S X=$$INACT^BIUTL1(BIDFN) I X]"" Q:X<BIQDT 0
 ;
 ;---> Quit if patient is not in selected User Population Group.
 ;---> Comment out next 2 lines for TESTING PURPOSES - MWRZZZ.
 I BIUP="u" Q $$USERPOP^BIUTL6(BIDFN,BIQDT)
 I BIUP="a" Q $$ACTCLIN^BIUTL6(BIDFN,BIQDT)
 ;
 ;---> No reason to exclude patient.
 Q 1
 ;
 ;
 ;----------
WRITE(BILINE,BINOD,BIVAL,BIBLNK) ;EP
 ;---> Write lines to ^TMP (see documentation in ^BIW).
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line# written.
 ;     2 - BINOD  (req) Node in ^TMP to store lines under.
 ;     2 - BIVAL  (opt) Value/text of line (Null=blank line).
 ;
 Q:'$D(BILINE)  Q:'$D(BINOD)
 D WL^BIW(.BILINE,BINOD,$G(BIVAL),$G(BIBLNK))
 Q
