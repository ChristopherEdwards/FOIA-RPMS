BILOT1 ;IHS/CMI/MWR - EDIT LOT NUMBERS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EDIT LOT NUMBER FIELDS.
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 ;
 S VALMSG="Enter ?? for more actions."
 S VALM("TITLE")=$$LMVER^BILOGO
 ;
 ;---> Build Listmanager array.
 K ^TMP("BILOT",$J),BILOT,BITMP
 N BIENT,BILINE,BITMP S BIENT=0,BILINE=0
 ;---> BICOLL=Order of Listing (see linelabel CHGORDR below.
 S:'$G(BICOLL) BICOLL=1
 ;---> Exclude inactive lots unless BIINACT=1.  vvv83
 S:'$G(BIINACT) BIINACT=0
 ;
 N BIIEN S BIIEN=0
 F  S BIIEN=$O(^AUTTIML(BIIEN)) Q:'BIIEN  D
 .I '$D(^AUTTIML(BIIEN,0)) K ^AUTTIML(BIIEN) Q
 .N BIACT,BIEXP,BILOT,BIVNAM,BIUNSD,Y,X,Z
 .S Y=^AUTTIML(BIIEN,0),BILOT=$P(Y,U),BIACT=+$P(Y,U,3)
 .S BIUNSD=$P(Y,U,12) S:BIUNSD="" BIUNSD="NA"
 .;---> Quit if excluding Inactive Lots.
 .Q:('BIINACT&BIACT=1)
 .S:BILOT="" BILOT="UNKNOWN"
 .;---> If no Exp Date, set Exp Date=last in list.
 .S BIEXP=+$P(Y,U,9) S:'BIEXP BIEXP=9999999
 .S BIVNAM=+$P(Y,U,4),BIVNAM=$$VNAME^BIUTL2(BIVNAM)
 .D
 ..I BICOLL=2 S W=BIEXP,X=BIVNAM,Y=BIUNSD,Z=BILOT Q  ;vvv83
 ..I BICOLL=3 S W=BILOT,X=BIVNAM,Y=BIEXP,Z=BIUNSD Q
 ..I BICOLL=4 S W=BIVNAM,X=BIUNSD,Y=BIEXP,Z=BILOT Q
 ..I BICOLL=5 S W=BIVNAM,X=BIEXP,Y=BIUNSD,Z=BILOT Q
 ..I BICOLL=6 S W=BIVNAM,X=BILOT,Y=BIEXP,Z=BILOT Q
 ..           S W=BIUNSD,X=BIVNAM,Y=BIEXP,Z=BILOT Q
 .S BITMP(BIACT,W,X,Y,Z,BIIEN)=BIIEN
 ;
 N N S N="" F  S N=$O(BITMP(N)) Q:(N="")  D
 .;---> Place a linefeed between Active and Inactive.
 .I N D WRITE(.BILINE,,,BIENT)
 .;
 .N M S M="" F  S M=$O(BITMP(N,M)) Q:(M="")  D
 ..N L S L="" F  S L=$O(BITMP(N,M,L)) Q:(L="")  D
 ...N K S K="" F  S K=$O(BITMP(N,M,L,K)) Q:(K="")  D
 ....N J S J="" F  S J=$O(BITMP(N,M,L,K,J)) Q:(J="")  D
 .....N P S P="" F  S P=$O(BITMP(N,M,L,K,J,P)) Q:(P="")  D
 ......D LINE(BITMP(N,M,L,K,J,P),.BILINE,.BIENT)
 ;
 ;---> Finish up Listmanager List Count.
 S VALMCNT=BILINE
 I VALMCNT>12 D
 .S VALMSG="Scroll down to view more. Type ?? for more actions."
 Q
 ;
 ;
 ;----------
LINE(BIIEN,BILINE,BIENT) ;EP
 ;---> Gather data for each Lot and write to ^TMP.
 ;---> Parameters:
 ;     1 - BIIEN  (req) IEN of Lot.
 ;     2 - BILINE (ret) Last line# written.
 ;     3 - BIENT  (opt) Entry Number for LM selection in VALMY
 ;
 N BI0,X,Y
 S BI0=^AUTTIML(BIIEN,0)
 ;
 ;---> Set Item# and build Item# array=IEN of Vaccine.
 S BIENT=BIENT+1,BILOT(BIENT)=BIIEN
 ;
 ;---> Item#.
 S X=" "_$S(BIENT<10:" "_BIENT,1:BIENT)
 ;
 ;---> Lot Number.
 S X=X_"  "_$P(BI0,U)
 S X=$$PAD^BIUTL5(X,27,".")
 ;
 ;---> Vaccine.
 S X=X_$$VNAME^BIUTL2($P(BI0,U,4))
 S X=$$PAD^BIUTL5(X,39,".")
 ;
 ;---> Manufacturer MVX.
 ;I $P(BI0,U,2) S X=X_$$MNAME^BIUTL2($P(BI0,U,2),1)
 ;S X=$$PAD^BIUTL5(X,36,".")
 ;
 ;---> Active/Inactive.
 S X=X_$S($P(BI0,U,3)=1:"Inactive",1:"Active")
 S X=$$PAD^BIUTL5(X,47,".")
 ;
 ;---> Expiration Date.
 I $P(BI0,U,9) S X=X_$$LOTEXP^BIRPC3(BIIEN,1)
 S X=$$PAD^BIUTL5(X,57,".")
 ;
 ;---> Starting Count.
 I $P(BI0,U,11) S X=X_$J($P(BI0,U,11),5)
 S X=$$PAD^BIUTL5(X,64,".")
 ;
 ;---> Doses Unused (amount left).
 I $P(BI0,U,11) S X=X_$J($$LOTRBAL^BIRPC3(BIIEN),5)
 S X=$$PAD^BIUTL5(X,71,".")
 ;
 ;---> Facility (if entered).
 I $P(BI0,U,14) S X=X_$E($$INSTTX^BIUTL6($P(BI0,U,14)),1,8)
 S X=$$PAD^BIUTL5(X,80,".")
 ;
 ;---> Set this Vaccine display row and index in ^TMP.
 D WRITE(.BILINE,X,,BIENT)
 Q
 ;
 ;
 ;----------
WRITE(BILINE,BIVAL,BIBLNK,BIENT) ;EP
 ;---> Write lines to ^TMP (see documentation in ^BIW).
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line# written.
 ;     2 - BIVAL  (opt) Value/text of line (Null=blank line).
 ;     3 - BIBLNK (opt) Number of blank lines to add after line sent.
 ;     4 - BIENT  (opt) Entry Number for LM selection in VALMY
 ;
 Q:'$D(BILINE)
 D WL^BIW(.BILINE,"BILOT",$G(BIVAL),$G(BIBLNK),$G(BIENT))
 Q
 ;
 ;
 ;----------
EDITLOT(BINEW) ;EP
 ;---> Edit a Lot Number.
 ;---> Parameters:
 ;     2 - BINEW (opt) 1=new lot number being added; 0/""=edit.
 ;
 ;---> Steps:
 ;            1) This entry point is called by the Protocol:
 ;               BI LOT NUMBER SELECT, an action on the
 ;               List Manager menu protocol: BI MENU LOT NUMBER EDIT.
 ;
 ;            2) This code calls ScreenMan form:
 ;               BI FORM-LOT NUMBER EDIT to build BI local array
 ;               of data for add/edit of a Lot Number.
 ;               Data already stored in the BI local array is loaded
 ;               into the form by LOADLOT^BILOT1, which is called
 ;               by the Pre-Action of Block for Vaccine Edit.
 ;
 ;            3) Use BI local array to send data to FDIE^BIFMAN.
 ;
 ;---> If BINEW, add a new Lot Number and quit.
 I $G(BINEW) D EDITSCR(,1) D RESET Q
 ;
 ;---> Call the Listmanager Generic Selector of items displayed.
 N VALMY
 D EN^VALM2(XQORNOD(0),"OS")
 ;
 ;---> Check that a Listman Item was passed.
 I '$D(VALMY) D ERRCD^BIUTL2(406,,1) D RESET Q
 ;---> Now set Y=Item# selected from the list.
 N Y S Y=$O(VALMY(0))
 I '$G(Y) D ERRCD^BIUTL2(406,,1) D RESET Q
 I $G(BILOT(Y))="" D ERRCD^BIUTL2(511,,1) D RESET Q
 D EDITSCR(+BILOT(Y))
 D FULL^VALM1
 D RESET
 Q
 ;
 ;
 ;----------
EDITSCR(BILOT,BINEW) ;EP
 ;---> Add or edit the fields of a Lot Number.
 ;---> (Make this an RPC in the future?)
 ;---> Parameters:
 ;     1 - BILOT (opt) Lot Number IEN.
 ;     2 - BINEW (opt) 1=new lot number being added; 0=edit.
 ;
 ;---> If this is an edit, check that IEN of Lot Number.
 I '$G(BINEW),$G(^AUTTIML(+$G(BILOT),0))="" D ERRCD^BIUTL2(511,,1) Q
 ;
 ;---> If this is an edit, preload existing values for Screenman form.
 N BI D:$G(BILOT)
 .N Y S Y=^AUTTIML(BILOT,0)
 .S BI("AS")=$P(Y,U,1)     ;Full Lot Number Text.
 .S BI("A")=$P(BI("AS"),"*")      ;Lot Number Text.
 .S BI("S")=$P(BI("AS"),"*",2)      ;Lot Number Text.
 .S BI("B")=$P(Y,U,4)      ;Vaccine.
 .S BI("C")=+$P(Y,U,3)     ;Status Active/Inactive.
 .S BI("D")=$P(Y,U,9)      ;Expiration Date.
 .S BI("E")=$P(Y,U,11)     ;Starting Count.
 .S BI("F")=$P(Y,U,12)     ;Doses Unused.
 .S BI("G")=$P(Y,U,15)     ;Low Supply Alert.
 .S BI("H")=$P(Y,U,13)     ;Source VFC or NON-VFC.
 .S BI("M")=$P(Y,U,2)      ;Manufacturer.
 .S BI("N")=$P(Y,U,14)     ;Facility.
 .S BI("O")=$P(Y,U,17)     ;NDC Code.
 ;
 ;---> Call Screenman to build BI local array of data by user.
 N BISAVE
 N DR S DR="[BI FORM-LOT NUMBER EDIT]"
 D DDS^BIFMAN(9999999.41,DR,$G(BILOT),"S",.BISAVE,.BIPOP)
 ;
 ;---> Quit if user did not save this data.
 Q:('$G(BISAVE))
 ;
 ;---> Build local array for this Lot Number.
 N BIERR,BIFLD
 S BI("AS")=BI("A")
 I $G(BI("S"))]"" S BI("AS")=BI("AS")_"*"_BI("S")
 ;
 ;---> v8.5: If Active Status="", set it to 0, so PCC will be happy.
 I $G(BI("C"))="" S BI("C")=0
 ;
 S BIFLD(.01)=$G(BI("AS")),BIFLD(.03)=$G(BI("C")),BIFLD(.09)=$G(BI("D"))
 S BIFLD(.11)=$G(BI("E")),BIFLD(.12)=$G(BI("F")),BIFLD(.15)=$G(BI("G"))
 S BIFLD(.13)=$G(BI("H")),BIFLD(.02)=$G(BI("M")),BIFLD(.14)=$G(BI("N"))
 S BIFLD(.16)=$G(BI("A")),BIFLD(.17)=$G(BI("O"))
 ;---> If this is a new Lot Number, include the Vaccine.
 S:$G(BINEW) BIFLD(.04)=$G(BI("B"))
 ;
 ;
 ;---> If this is a new Lot Number and it already exists (not a sub-lot),
 ;---> then display error and quit.
 I $G(BINEW),$D(^AUTTIML("B",BI("AS"))) D  Q
 .D CLEAR^VALM1,FULL^VALM1,TITLE^BIUTL5("EDIT LOT NUMBER FIELDS")
 .W !!?23,"This Lot Number already exists!"
 .W !!?18,"Please exit and select it from the list."
 .W !!!!?5,"NOTE: It It may be Inactive. Try displaying Inactive Lot Numbers"
 .W !?11,"as well as Active ones.",!
 .D DIRZ^BIUTL3()
 ;
 ;
 ;---> Add/update the Lot Number.
 D
 .I $G(BINEW) D UPDATE^BIFMAN(9999999.41,.BILOT,.BIFLD,.BIERR) Q
 .D FDIE^BIFMAN(9999999.41,BILOT,.BIFLD,.BIERR)
 ;
 ;---> If there was an error, display it.
 I $G(BIERR)]"" D  Q
 .D CLEAR^VALM1,FULL^VALM1,TITLE^BIUTL5("EDIT LOT NUMBER FIELDS")
 .W !!?3,BIERR D DIRZ^BIUTL3()
 ;
 Q
 ;
 ;
 ;----------
LOADLOT ;EP
 ;---> Code to load Lot Number data for ScreenMan Edit form.
 ;---> Called by Pre Action of Block BI BLK-LOT NUMBER EDIT on
 ;---> Form BI FORM-LOT NUMBER EDIT.
 ;
 ;---> If this is a NEW Lot Number, enable editing of Vaccine, Field 2.
 I $G(BINEW) D UNED^DDSUTL(2,,,0)
 ;
 ;---> Load Lot Number.
 I $G(BI("A"))]"" D PUT^DDSVALF(1,,,BI("A"),"I")
 ;
 ;---> Load Sub-lot, if it exists.
 I $G(BI("S"))]"" D PUT^DDSVALF(1.5,,,BI("S"),"I")
 ;
 ;---> Load Vaccine Name (.01).
 I $G(BI("B"))]"" D PUT^DDSVALF(2,,,BI("B"),"I")
 ;
 ;---> Load Vaccine Short Name (.02).
 I $G(BI("B"))]"" D PUT^DDSVALF(2.5,,,"("_$$VNAME^BIUTL2(BI("B"))_")")
 ;
 ;---> Load Lot Number Status Active/Inactive.
 I $G(BI("C"))]"" D PUT^DDSVALF(3,,,BI("C"),"I")
 ;
 ;---> Load Lot Number Expiration Date.
 I $G(BI("D"))]"" D PUT^DDSVALF(4,,,BI("D"),"I")
 ;
 ;---> Load the Starting Count.
 I $G(BI("E"))]"" D PUT^DDSVALF(5,,,BI("E"),"I")
 ;
 ;---> Load the Doses Unused.
 I $G(BI("F"))]"" D PUT^DDSVALF(6,,,BI("F"),"I")
 ;
 ;---> Load the Low Supply Alert.
 I $G(BI("G"))]"" D PUT^DDSVALF(7,,,BI("G"),"I")
 ;
 ;---> Load the Source (VFC or NON-VFC).
 I $G(BI("H"))]"" D PUT^DDSVALF(11,,,BI("H"),"I")
 ;
 ;---> Load Manufacturer.
 I $G(BI("M"))]"" D PUT^DDSVALF(10,,,BI("M"),"I")
 ;
 ;---> Load Facility.
 I $G(BI("N"))]"" D PUT^DDSVALF(9,,,BI("N"),"I")
 ;
 ;---> Load NDC Code.
 I $G(BI("O"))]"" D PUT^DDSVALF(4.5,,,BI("O"),"I")
 ;
 ;---> Calculate the number of doses that have been used.
 D CALCDOS($G(BI("E")),$G(BI("F")))
 Q
 ;
 ;
 ;----------
INVOFF(BIZ) ;EP
 ;---> Trigger Popup that Doses Unused cannot be greater than
 ;---> the Starting Count.
 ;---> Called from Fields 5 & 6 on Form BI FORM-LOT NUMBER EDIT.
 ;---> Parameters:
 ;     1 - BIZ (req) Field triggered from: 1=Starting Count
 ;                                         2=Doses Unused
 ;
 Q:'$G(BIZ)
 S DDSSTACK="BI PAGE-INVENTORY OFF"
 I BIZ=1 D PUT^DDSVALF(5,,,$G(DDSOLD),"I") Q
 I BIZ=2 D PUT^DDSVALF(6,,,$G(DDSOLD),"I") Q
 Q
 ;
 ;
 ;----------
CALCDOS(E,F) ;EP
 ;---> Calculate the number of doses of a Lot Number that have been used.
 ;---> Called from Fields 5 & 6 on Form BI FORM-LOT NUMBER EDIT.
 ;---> Parameters:
 ;     1 - E (req) Starting Count
 ;     2 - F (req) Doses Unused
 ;
 Q:($G(E)="")  Q:($G(F)="")
 D PUT^DDSVALF(8,,,(E-F),"I")
 Q
 ;
 ;
 ;----------
VACINA1 ;EP
 ;---> Trigger Popup that says vaccine must be Active.
 ;---> Called from Fields 2 on Form BI FORM-LOT NUMBER EDIT.
 ;
 ;---> If this vaccine is Inactive, display popup.
 ;---> Ex
 I $P($G(^AUTTIMM(+X,0)),U,7) D  Q
 .S DDSSTACK="BI PAGE-INACTIVE VACCINE"
 ;
 S BINEW(1)=1 S DDSBR=10
 I $G(X) S BI("B")=X D PUT^DDSVALF(2.5,,,"("_$$VNAME^BIUTL2(X)_")")
 Q
 ;
 ;
 ;----------
VACINA2 ;EP
 ;---> Called from Fields 3 on Form BI FORM-LOT NUMBER EDIT.
 ;---> If no vaccine was selected, send user back to Field 2 (vaccine).
 I '$G(BI("B")) S DDSBR=2 D  Q
 .;D HLP^DDSUTL("Select  the Vaccine that corresponds to this Lot Number.")
 ;
 N BIT S BIT="Select whether this Lot Number should be Active or Inactive."
 S BIT=BIT_"  Note that users will not be able to select an Inactive Lot "
 S BIT=BIT_"Number if the Category is Ambulatory."
 D HLP^DDSUTL(BIT)
 Q
 ;
 ;
 ;----------
VACINA3 ;EP
 ;---> After code from popup, going back to Form BI FORM-LOT NUMBER EDIT.
 ;---> To get there: Get to the form (above), press F1-P,  then page 5,
 ;---> then F1-V, tab to BI BLK-..., spacebar, F4, Post Action at the bottom.
 ;
 ;---> Kill the vaccine node, null out the display of vaccine names.
 K BI("B") D PUT^DDSVALF(2,2,1,,"E"),PUT^DDSVALF(2.5,2,1,,"E")
 Q
 ;
 ;
 ;----------
RESET ;EP
 ;---> Update partition for return to Listmanager.
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT^BILOT,HDR^BILOT()
 Q
 ;
 ;
 ;----------
CHGORDR ;EP
 ;
 D CHGORDR^BILOT2
 Q
 ;
 ;
 ;----------
TEXT2 ;EP
 ;;
 ;;The Lot Number Table will always be listed with the group of
 ;;all ACTIVE Lot Numbers first, followed by all INACTIVE Lot Numbers.
 ;;However, within those two groups you may select the order in which
 ;;the Lot Numbers are displayed, as follows:
 ;;
 ;;   1) By Unused Doses (least first)
 ;;   2) By Expiration Date
 ;;   3) By Lot Number
 ;;   4) By Vaccine Name, then by Unused Doses
 ;;   5) By Vaccine Name, then by Exp Date
 ;;   6) By Vaccine Name, then by Lot Number
 ;;
 D PRINTX("TEXT2")
 Q
 ;
 ;
 ;----------
INACTA ;EP
 ;---> Automatically Inactivate old Lot Numbers that either have expired
 ;---> or have no Expiration Date.
 ;
 D FULL^VALM1,TITLE^BIUTL5("INACTIVATE OLD LOT NUMBERS"),TEXT3^BILOT
 N DIR,Y D INACTA1
 D ^DIR
 S:$D(DIRUT) BIPOP=1
 I Y'=1 D  Q
 .W !!?5,"Okay.  NO changes made!"  D DIRZ^BIUTL3()
 .D RESET
 ;
 D TITLE^BIUTL5("INACTIVATE OLD LOT NUMBERS"),TEXT33^BILOT,INACTA1
 D ^DIR
 S:$D(DIRUT) BIPOP=1
 I Y'=1 D  Q
 .W !!?5,"Okay.  NO changes made!"  D DIRZ^BIUTL3()
 .D RESET
 ;
 D INACTLN
 D RESET
 Q
 ;
 ;
 ;----------
INACTA1 ;EP
 ;---> Set DIR values for linelabel INACTA.
 S DIR(0)="YA"
 S DIR("A")="     Please answer either YES or NO: ",DIR("B")="NO"
 S DIR("?",1)="     Enter YES to automatically Inactivate Lot Numbers, "
 S DIR("?")="     enter NO to make no changes."
 Q
 ;
 ;
 ;----------
INACTLN ;EP
 ;---> Inactivate all Lot Numbers that either have expired or have
 ;---> no Expiration Date.
 ;
 D ^XBKVAR
 N M,N S M=0,N=0
 F  S N=$O(^AUTTIML(N)) Q:'N  D
 .Q:'$D(^AUTTIML(N,0))
 .;---> Do not Inactivate if Exp Date is later than Today.
 .Q:($P(^AUTTIML(N,0),"^",9)>$G(DT))
 .;---> Quit if this Lot Number is already Inactive.
 .Q:($P(^AUTTIML(N,0),"^",3)=1)
 .;---> Inactivate this Lot Number.
 .S $P(^AUTTIML(N,0),"^",3)=1,M=M+1
 W !!?5,"Done.  ",M," Lot Numbers have been Inactivated." D DIRZ^BIUTL3()
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
 ;
 ;
 ;----------
NULLACT ;EP
 ;---> Activate all Lot Numbers that have a Status=null.
 ;---> Call by postinit for Imm v8.5.
 ;
 D ^XBKVAR
 W !!?5,"Checking Lot Numbers for null Status..."
 N M,N S M=0,N=0
 F  S N=$O(^AUTTIML(N)) Q:'N  D
 .Q:'$D(^AUTTIML(N,0))
 .;---> Quit if this lot number has a Status .
 .Q:($P(^AUTTIML(N,0),"^",3)'="")
 .;---> Okay, Status must be null, so set it to Active.
 .S $P(^AUTTIML(N,0),"^",3)=0,M=M+1
 W !!?5,"Done.  ",M," Lot Numbers have been fixed." D DIRZ^BIUTL3()
 Q
