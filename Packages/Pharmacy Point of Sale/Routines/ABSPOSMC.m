ABSPOSMC ; IHS/FCS/DRS - General Inquiry/Report .57; [ 09/12/2002  10:14 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 Q
 ; Local array ABSPOSMA() contains the parameters:
 ; ABSPOSMA("BY WHICH DATE")="TRANSACTION" or "RELEASED"
 ; ABSPOSMA("MODE")="INQUIRY" or "REPORT"
 ; ABSPOSMA("SORT",7,"FR")=transaction date/time, start value
 ; ABSPOSMA("SORT",7,"TO")=transaction date/time, to value
 ; ABSPOSMA("SORT",9999.95,"FR")=released date/time, start value
 ; ABSPOSMA("SORT",9999.95,"TO")=released date/time, to value
 ; ABSPOSMA("SORT",field #,"FR")=other field sort, start value
 ; ABSPOSMA("SORT",field #,"TO")=other field sort, to value
 ; ABSPOSMA("OUTPUT TYPE")=one of the codes (see ABSPOSMZ for list)
CONTINUE ;EP - continued (via GOTO) from ABSPOSMB
 N L,DIC,FLDS,BY,FR,TO,DHD,DIASKHD,DIPCRIT,PG,DHIT,DIOEND,DIOBEG
 N DCOPIES,IOP,DQTIME,DIS,DISUPNO,DISTOP,DISPAR
 N SELECT,ANSCOUNT,X,ACTION
A ;
 D DIPSETUP
 I ABSPOSMA("MODE")="INQUIRY" D INILIST,INIANS
 ; - - - - - - - - - - sort and print - - - - - - - - - - - -
 I ABSPOSMA("MODE")="INQUIRY" W "Searching...",!
 D EN1^DIP
 I ABSPOSMA("MODE")="REPORT" Q  ; If in Report mode, we're finished
 ; - - - - -  Inquiry mode  - - - - - display list and select - - - - -
 I '@$$LIST@(0) D  Q  ; If empty list, quit.
 . W "No transactions found with these criteria."
 W "Found ",@$$LIST@(0)," transactions.",! H 2
SELECT S SELECT=$$SELECT1 ; we expect to get back "^"
 Q:(SELECT="^^")!(SELECT=-1)
 S X=0 F ANSCOUNT=0:1 S X=$O(@$$ANSLIST@(X)) Q:X=""
 W !,"Selected ",ANSCOUNT," item",$S(ANSCOUNT=1:"",1:"s"),! H 2
 D IEN57
 I 'ANSCOUNT H 2 Q
ACTION S ACTION=$$OUTPUT^ABSPOSMZ
 I ACTION="" H 2 G SELECT ;Q
 D ACTION^ABSPOSMD
 G ACTION ; otherwise, branch back for more inquiry
SELECT1() ;
 N TYPE,LROOT,AROOT,STITLE,PROMPT,OPT,PGLEN,TIMEOUT
 S TYPE="M" ; multiple selection
 S LROOT=$$OPEN($$LIST)
 S AROOT=$$OPEN($$ANSLIST)
 S STITLE="Pharmacy Point of Sale - Inquiry Screen"
 ;S PROMPT(1)="Select line number(s)"
 S OPT=1 ; optional response
 S PGLEN=12 ; 
 S TIMEOUT=600
 D INIANS ; erase any previous answers
 N X
 S X=$$LIST^ABSPOSU4(TYPE,LROOT,AROOT,STITLE,,OPT,PGLEN,TIMEOUT)
 Q X
OPEN(X) ;EP -
 Q $E(X,1,$L(X)-1)_"," ; convert to open root
LIST() ;EP
 Q "^TMP("""_$T(+0)_""","_$J_",""LIST"")"
ANSLIST() ; EP
 Q "^TMP("""_$T(+0)_""","_$J_",""ANS"")"
ANSCOUNT() Q @$$ANSLIST@(0)
IENLIST() ; EP
 Q "^TMP("""_$T(+0)_""","_$J_",""IEN57"")"
IEN57 ; build IEN57 list based on ANSLIST
 N A,B,C S A=$$ANSLIST,B=$$IENLIST,C=$$LIST K @B
 N X,IEN57 S X=0
 F  S X=$O(@A@(X)) Q:'X  D
 . S IEN57=@C@(X,"I")
 . S @B@(IEN57)=""
 Q
INILIST K @$$LIST
 S @$$LIST@(0)=0
 S @$$LIST@("Column HEADERs")="2|Presc/Fill:12,Trans. Date:11,Stat:5,Patient and Drug:35"
 Q
INIANS K @$$ANSLIST Q
 ;
DIPSETUP ; This routine sets up the call to EN1^DIP
 S L=0
 S DIC=9002313.57
 D FLDS
 D BY
 D FR ; FR and TO
 D DHD ; header
 K DIASKHD ; do not prompt user for a header
 S DIPCRIT=1 ; SORT criteria will print in the header of first page
 K PG ; start at page 1
 I ABSPOSMA("MODE")="INQUIRY" D  ; build the list
 . S DHIT="D DHIT^"_$T(+0)
 E  K DHIT
 ; DIOEND ; executed at end of printout
 ; DIOBEG ; executed before printing begins
 ; DCOPIES
 ; IOP
 I ABSPOSMA("MODE")="INQUIRY" S IOP="HOME;80"
 ; DQTIME
 D DIS ; screens
 ; S DISUPNO=1
 S DISTOP="I 1" ; allow user to stop queued print
 ; DISTOP("C")
 Q
FLDS ; Which fields to print?  If inquiry mode:  print no fields
 I ABSPOSMA("MODE")="INQUIRY" S FLDS="""""" Q
 ; Report mode:  set to the appropriate template.
 ; Temporary - just to put something in there.
 S FLDS="[CAPTIONED]"
 Q
BY ; Which fields to sort on?
 I '$D(ABSPOSMA("SORT")) K BY Q  ; doing Fileman sort; leave BY undef
 ; Always primary sort is on transaction date.
 S BY="@-LAST UPDATE"
 I ABSPOSMA("BY WHICH DATE")="RELEASED" S BY=BY_",@9999.95"
 N F S F=""
 F  S F=$O(ABSPOSMA("SORT",F)) Q:F=""  D
 . Q:F=7  Q:F=9999.95  ; one of the date fields we already have
 . S BY=BY_",@"_F ; append
 S BY=BY_",@NUMBER" ; tie breaker
 Q
FR ; FR and TO range of sort
 ; order must correspond with order of BY fields
 S (FR,TO)=""
 N F F F=7,9999.95 D FR1
 S F=""
 F  S F=$O(ABSPOSMA("SORT",F)) Q:F=""  I F'=7,F'=9999.95 D FR1
 S FR=FR_",",TO=TO_"," ; NUMBER sort
 Q
FR1 ;
 Q:'$D(ABSPOSMA("SORT",F))
 S:FR]"" FR=FR_"," S FR=FR_ABSPOSMA("SORT",F,"FR")
 S:TO]"" TO=TO_"," S TO=TO_ABSPOSMA("SORT",F,"TO")
 Q
DHD ; Header
 I ABSPOSMA("MODE")="INQUIRY" S DHD="W !,""Searching..."""
 Q
DIS ; screens
 K DIS
 N I F I=0:1 Q:'$D(ABSPOSMA("SCREEN",I))  S DIS(I)=ABSPOSMA("SCREEN",I)
 Q
DHIT ;EP - called here indirectly when in Inquiry mode and a hit is found
 ;W "." W:$X>70 !
 N IEN57,NLINE,DATA,X S IEN57=D0 ; D0 points to the entry
 S (NLINE,@$$LIST@(0))=@$$LIST@(0)+1
 ; Line number - comes automatically, we don't need to put it in.
 S DATA="" ;$J(NLINE,4)_" "
 ; Prescription and fill number
 S DATA=DATA_$J("`"_$$RXI^ABSPOS57,9)
 S X=$$RXR^ABSPOS57
 I X D
 . S DATA=DATA_"/"_X
 . I X<10 S DATA=DATA_" "
 E  S DATA=DATA_"   "
 S DATA=DATA_"  "
 ; Transaction date
 S X=$P(^ABSPTL(IEN57,0),U,8)
 N XD,XT S XD=$P(X,"."),XT=$P(X,".",2)
 N SY S SY=$E(X,2,3)=$E(DT,2,3) ; SY = same year?
 I DT=XD S XD="T"
 E  I DT-1=XD S XD="T-1"
 E  I DT-2=XD S XD="T-2"
 E  S XD=+$E(XD,4,5)_"/"_+$E(XD,6,7)_$S(SY:"",1:"/"_$E(XD,2,3))
 S XD=XD_"@"_+$E(XT,1,2)
 I $L(XD)<9 S XD=XD_":"_$E(XT,3,4)
 S DATA=DATA_$E(XD_"       ",1,11)_"  "
 ; Result
 S X=$$GET1^DIQ(9002313.57,IEN57_",","RESULT WITH REVERSAL")
 I X]"" D
 . N Y S Y=$O(^ABSPF(9002313.83,"B",X,0))
 . I Y S Y=$P(^ABSPF(9002313.83,Y,0),U,2)
 . I Y]"" S X=Y
 S X=$E(X_"     ",1,5)
 S DATA=DATA_X_"  "
 ; Patient and drug
 S X=$$PATIENT^ABSPOS57
 I X S X=$P($G(^DPT(X,0)),U) ; just last,first
 I X[" " S X=$P(X," ")_" "_$E($P(X," ",2)) ; and middle initial
 S X=X_" / "_$$DRGNAME^ABSPOS57
 S DATA=DATA_$E(X_$J("",35),1,35)
 S @$$LIST@(NLINE,"E")=DATA
 S @$$LIST@(NLINE,"I")=IEN57
 Q
