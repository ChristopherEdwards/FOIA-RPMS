BINDC1 ;IHS/CMI/MWR - EDIT NDC NUMBERS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**9**;OCT 01,2014
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EDIT NDC NUMBER FIELDS.
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
 K ^TMP("BINDC",$J),BINDC,BITMP
 N BIENT,BILINE,BITMP S BIENT=0,BILINE=0
 ;---> BICOLL=Order of Listing (see linelabel CHGORDR below.
 S:'$G(BICOLL) BICOLL=1
 ;---> Exclude inactive NDCs unless BIINACT=1.  vvv83
 S:'$G(BIINACT) BIINACT=0
 ;
 N BIIEN S BIIEN=0
 F  S BIIEN=$O(^BINDC(BIIEN)) Q:'BIIEN  D
 .I '$D(^BINDC(BIIEN,0)) K ^BINDC(BIIEN) Q
 .N BINDC,BIVACP,BIVNAM,BICVX,BIMAN,BIPROD,BIACT,W,X,Y,Z
 .S Y=^BINDC(BIIEN,0),BINDC=$P(Y,U),BIVACP=+$P(Y,U,2)
 .S BIVNAM=$$VNAME^BIUTL2(BIVACP)
 .S BICVX=$$CODE^BIUTL2(BIVACP,6) S:BICVX="" BICVX=999
 .S BIPROD=$E($P(Y,U,4),1,12) S:BIPROD="" BIPROD="Not Recorded"
 .S BIMAN=+$P(Y,U,3),BIMAN=$$MNAME^BIUTL2(BIMAN)
 .S BIACT=+$P(Y,U,6) ;1=inactive
 .;---> Quit if excluding Inactive NDCs.
 .Q:('BIINACT&BIACT=1)
 .;---> If no Exp Date, set Exp Date=last in list.
 .;Future, if Exp Date: S BIEXP=+$P(Y,U,?) S:'BIEXP BIEXP=9999999
 .D
 ..I BICOLL=2 S W=BIVNAM,X=BINDC,Y=BIPROD,Z=BIMAN Q
 ..S W=BINDC,X=BIVNAM,Y=BIPROD,Z=BIMAN Q
 ..;---> Other possible orders:
 ..;I BICOLL=3 S W=BINDC,X=BIVNAM,Y=BIEXP,Z=BICVX Q
 ..;I BICOLL=4 S W=BIVNAM,X=BICVX,Y=BIEXP,Z=BINDC Q
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
 .;
 .;---> Display number of NDCs in list.
 .N Y S Y=VALMCNT S:$G(BIINACT) Y=Y-1
 .S VALMSG=Y_" NDCs: Scroll down to view more, or type ??."
 Q
 ;
 ;
 ;----------
LINE(BIIEN,BILINE,BIENT) ;EP
 ;---> Gather data for each NDC and write to ^TMP.
 ;---> Parameters:
 ;     1 - BIIEN  (req) IEN of NDC.
 ;     2 - BILINE (ret) Last line# written.
 ;     3 - BIENT  (opt) Entry Number for LM selection in VALMY
 ;
 N BI0,X,Y
 S BI0=^BINDC(BIIEN,0)
 ;
 ;---> Set Item# and build Item# array=IEN of Vaccine.
 S BIENT=BIENT+1,BINDC(BIENT)=BIIEN
 ;
 ;---> Item#.
 S X=" "_$S(BIENT<10:" "_BIENT,1:BIENT)
 ;
 ;---> NDC Code.
 S X=X_"  "_$P(BI0,U)
 S X=$$PAD^BIUTL5(X,21,".")
 ;
 ;---> Vaccine.
 N BIVACP S BIVACP=+$P(BI0,U,2)
 D
 .I 'BIVACP S X=X_"UNKNOWN" Q
 .S X=X_$$VNAME^BIUTL2(BIVACP)
 S X=$$PAD^BIUTL5(X,32,".")
 ;
 ;---> CVX.
 N BICVX S BICVX=$$CODE^BIUTL2(BIVACP,6) S:('BICVX) BICVX="UNK"
 S:($L(BICVX))=1 BICVX=".."_BICVX  S:($L(BICVX))=2 BICVX="."_BICVX
 S X=X_BICVX
 S X=$$PAD^BIUTL5(X,38,".")
 ;
 ;---> Product.
 N BIPROD S BIPROD=$E($P(BI0,U,4),1,12) S:BIPROD="" BIPROD="Not Recorded"
 S X=X_BIPROD
 S X=$$PAD^BIUTL5(X,53,".")
 ;
 ;---> Manufacturer.
 N BIMAN D
 .S BIMAN=+$P(BI0,U,3)
 .I 'BIMAN S BIMAN="Not Recorded" Q
 .S BIMAN=$E($$MNAME^BIUTL2(BIMAN),1,16)
 S X=X_BIMAN
 S X=$$PAD^BIUTL5(X,71,".")
 ;
 ;---> Active/Inactive Status.
 S X=X_$S($P(BI0,U,6)=1:"Inactive",1:"Active")
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
 D WL^BIW(.BILINE,"BINDC",$G(BIVAL),$G(BIBLNK),$G(BIENT))
 Q
 ;
 ;
 ;----------
EDITNDC(BINEW) ;EP
 ;---> Add or Edit an NDC Number.
 ;---> Parameters:
 ;     2 - BINEW (opt) 1=new NDC number being added; 0/""=edit.
 ;
 N BIDA
 ;---> If BINEW, add a new NDC Number and quit.
 ;I $G(BINEW) D EDITSCR(,1) D RESET Q
 I $G(BINEW) D  Q
 .D ADDFM
 .D FULL^VALM1,RESET
 ;
 ;---> This is an Edit, so continue.
 ;---> Call the Listmanager Generic Selector of items displayed.
 N VALMY
 D EN^VALM2(XQORNOD(0),"OS")
 ;
 ;---> Check that a Listman Item was passed.
 I '$D(VALMY) D ERRCD^BIUTL2(406,,1) D RESET Q
 ;---> Now set Y=Item# selected from the list.
 N Y S Y=$O(VALMY(0))
 I '$G(Y) D ERRCD^BIUTL2(406,,1) D RESET Q
 I $G(BINDC(Y))="" D ERRCD^BIUTL2(511,,1) D RESET Q
 N BIDA S BIDA=+BINDC(Y)
 I $G(^BINDC(BIDA,0))="" D ERRCD^BIUTL2(515,,1) D RESET Q
 ;---> Use next line and called code if you want to use Screenman.
 ;D EDITSCR(+BINDC(Y))
 D EDITFM(BIDA)
 D FULL^VALM1
 D RESET
 Q
 ;
 ;
 ;----------
ADDFM ;EP
 ;---> Add a new NDC Code by Fileman (not Screenman).
 ;
 D SETVARS^BIUTL5
 N BIDA,DIR,Y
 F  D  Q:($G(Y)=-1)
 .D TITLE^BIUTL5("ADD A NEW NDC CODE")
 .D TEXT1
 .;
 .N DIR S DIR(0)="FOA",DIR("A")="     Enter NDC Code: "
 .S DIR("?")="     Entry must contain 10 or 11 digits and 2 dashes."
 .D ^DIR
 .I $D(DIRUT) S Y=-1 Q
 .S BIENTRY=Y
 .;---> Pattern match for NDC format. ALT: I $L($P(X,"-")),$L($P(X,"-",2)),$L($P(X,"-",3))
 .I ($L(BIENTRY)>13)!($L(BIENTRY)<12)!(BIENTRY'?.N1"-".N1"-".N) D  Q
 ..W !!?5,"Entry must contain 10 or 11 digits and 2 dashes.  Try again."
 ..N BIPOP D DIRZ^BIUTL3(.BIPOP) S:$G(BIPOP) Y=-1
 .;
 .;---> Pattern match is good, now check for duplicate.
 .;---> If this "new" NDC Number already exists, give opportunity to edit.
 .I $D(^BINDC("B",BIENTRY)) D  Q
 ..S BIDA=$O(^BINDC("B",BIENTRY,0))
 ..D CLEAR^VALM1,FULL^VALM1,TITLE^BIUTL5("ADD A NEW NDC CODE")
 ..W !!?5,"The NDC Number you entered, ",BIENTRY,", already exists!"
 ..W !!?5,"NOTE: It may be Inactive. Try displaying Inactive NDC Numbers"
 ..W !?11,"as well as Active ones."
 ..W !!?5,"Would you like to edit this NDC Code?"
 ..S DIR("?")="     Enter YES to edit this NDC Code, or NO to try again."
 ..S DIR(0)="Y",DIR("A")="     Enter Yes or No",DIR("B")="Yes"
 ..D ^DIR W !
 ..I $D(DIRUT)!'Y K BIDA Q
 ..;---> Edit this NDC, then quit Add loop.
 ..D EDITFM(BIDA) S Y=-1 Q
 .;
 .;---> Okay, so this is a valid NEW NDC Code.  Now get Vaccine/CVX.
 .D CLEAR^VALM1,FULL^VALM1,TITLE^BIUTL5("ADD A NEW NDC CODE")
 .W !!?5,"New NDC Code: ",BIENTRY
 .W !!,"     Please choose the Vaccine/CVX Code associated with this NDC Code.",!
 .D DIC^BIFMAN(9999999.14,"QEMA",.Y,"     Select Vaccine: ")
 .I Y<0 K Y Q
 .N BIVAC S BIVAC=+Y K Y
 .;---> Now file new NDC Code.
 .D FILE^BIFMAN(9002084.95,BIENTRY,"ML",".02////"_BIVAC,,.Y)
 .;---> IF Y<0, CHECK PERMISSIONS.
 .I Y<0 D ERRCD^BIUTL2(517,,1) S Y=-1 Q
 .;---> New entry successful, now edit.
 .S BIDA=+Y
 .D EDITFM(+BIDA) S Y=-1 Q
 ;
 Q
 ;
 ;
 ;----------
EDITFM(BIDA) ;EP
 ;---> Edit the fields of am NDC Code by Fileman.
 ;---> Parameters:
 ;     1 - BINDC (req) NDC Code IEN.
 ;
 ;---> Check that IEN of NDC Code is present.
 I '$G(BIDA) D ERRCD^BIUTL2(515,,1) Q
 I '$D(^BINDC(BIDA,0)) D ERRCD^BIUTL2(516,,1) Q
 N BI0 S BI0=^BINDC(BIDA,0)
 N BIVACP S BIVACP=+$P(BI0,U,2)
 D TITLE^BIUTL5("EDIT NDC CODE")
 W !?5,"     NDC Code: ",$P(BI0,U)
 W !?5,"      Vaccine: ",$S(BIVACP:$$VNAME^BIUTL2(BIVACP),1:"Not recorded")
 W !?5,"          CVX: ",$S(BIVACP:$$CODE^BIUTL2(BIVACP,6),1:"")
 W !?5,"      Product: ",$P(BI0,U,4)
 W !?5," Manufacturer: " W:+$P(BI0,U,3) $$MNAME^BIUTL2(+$P(BI0,U,3))
 W !?5,"Active Status: ",$S($P(BI0,U,6):"Inactive",1:"Active"),!!!
 ;
 S DR=".02;.04;.03;.06"
 D DIE^BIFMAN(9002084.95,DR,+BIDA,.BIPOP)
 Q
 ;
 ;
 ;----------
RESET ;EP
 ;---> Update partition for return to Listmanager.
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT^BINDC,HDR^BINDC()
 Q
 ;
 ;
 ;----------
CHGORDR ;EP
 ;
 D CHGORDR^BINDC2
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;The National Drug Code (NDC) is a unique ten- or eleven-digit
 ;;3-segment numeric identifier, which serves as a universal product
 ;;identifier for drugs in commercial distribution.
 ;;
 ;;The format for an NDC contains three segments of digits,
 ;;separated by dashes: labeler code - product code - package code.
 ;;NDC codes occur in the following grouping of digits:
 ;;   5-4-2, 4-4-2, 5-3-2, or 5-4-1
 ;;
 ;;To enter a new NDC code into the Immunization NDC Table, your entry
 ;;can take any of the above forms; however, it must contain a total of
 ;;ten or eleven digits and two dashes.
 ;;
 ;;
 D PRINTX("TEXT1")
 Q
 ;
 ;
 ;----------
TEXT2 ;EP
 ;;
 ;;The NDC Number Table will always be listed with the group of
 ;;all ACTIVE NDC Numbers first, followed by all INACTIVE NDC Numbers.
 ;;However, within those two groups you may select the order in which
 ;;the NDC Numbers are displayed, as follows:
 ;;
 ;;   1) By NDC Code (alphanumeric)
 ;;   2) By Vaccine Name, then by NDC Code
 ;;
 D PRINTX("TEXT2")
 Q
 ;
 ;
 ;----------
INACTA ;EP
 ;---> Automatically Inactivate old NDC Numbers that either have expired
 ;---> or have no Expiration Date.
 ;
 D FULL^VALM1,TITLE^BIUTL5("INACTIVATE OLD NDC NUMBERS"),TEXT3^BINDC
 N DIR,Y D INACTA1
 D ^DIR
 S:$D(DIRUT) BIPOP=1
 I Y'=1 D  Q
 .W !!?5,"Okay.  NO changes made!"  D DIRZ^BIUTL3()
 .D RESET
 ;
 D TITLE^BIUTL5("INACTIVATE OLD NDC NUMBERS"),TEXT33^BINDC,INACTA1
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
 S DIR("?",1)="     Enter YES to automatically Inactivate NDC Numbers, "
 S DIR("?")="     enter NO to make no changes."
 Q
 ;
 ;
 ;----------
INACTLN ;EP
 ;---> Inactivate all NDC Numbers that either have expired or have
 ;---> no Expiration Date.
 ;
 D ^XBKVAR
 N M,N S M=0,N=0
 F  S N=$O(^BINDC(N)) Q:'N  D
 .Q:'$D(^BINDC(N,0))
 .;---> Do not Inactivate if Exp Date is later than Today.
 .Q:($P(^BINDC(N,0),"^",9)>$G(DT))
 .;---> Quit if this NDC Number is already Inactive.
 .Q:($P(^BINDC(N,0),"^",3)=1)
 .;---> Inactivate this NDC Number.
 .S $P(^BINDC(N,0),"^",3)=1,M=M+1
 W !!?5,"Done.  ",M," NDC Numbers have been Inactivated." D DIRZ^BIUTL3()
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
