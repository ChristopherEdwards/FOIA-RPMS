BISELECT ;IHS/CMI/MWR - GENERIC SELECTION UTILITY ; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  UTILITY TO PROMPT FOR MULTIPLE SELECTIONS FROM A FILE AND STORE
 ;;  THEM IN A LOCAL ARRAY FOR CALLING PROGRAM.
 ;
 ;
 ;---> Executable example selecting Entries from a File.
 D SEL(9999999.14,"BIZZ")
 Q
 ;
 ;---> Executable example selecting Codes from a Set of Codes in a Field.
 ;---> Key element is 11th Parameter, the Field# (must be a Set of Codes).
 N BINAM S BINAM="Visit Type"
 N BICOL S BICOL="    #  Visit Type                     Code"
 D SEL^BISELECT(9000010,"BIVT",BINAM,,,,,BICOL,.BIPOP,,".03")
 Q
 ;
 ;
 ;----------
SEL(BIFILE,BIARR1,BIITEM,BISCRN,BIDFLT,BIPC,BIID,BICOL,BIPOP,BINONE,BIFLD,BIDFA,BITITEM) ;EP
 ;---> Generic utility to prompt user for selections from a file.
 ;---> Returns local array with subscripts of IENs selected.
 ;---> Parameters:
 ;     1 - BIFILE  (req) File Number from which selection will be made.
 ;
 ;     2 - BIARR1  (req) Selection Array.
 ;                       Local array in which selections will be stored.
 ;                       May not be a global.
 ;                       The Selection Array MUST BE UNSUBSCRIPTED--
 ;                       may not contain "(", commas, or subscripts.
 ;                       If ALL entries in the file are selected and
 ;                       the array would be more than 300 entries, then
 ;                       BIARR1_"(""ALL"")" is returned.
 ;                       NOTE: This CANNOT be "BIARR1" or it will
 ;                             kill the variable, BIARR1, that stores
 ;                             the local array name!
 ;
 ;     3 - BIITEM  (opt) Catagoric name of Items being selected.
 ;     4 - BISCRN  (opt) Screen used in selection lookup.
 ;                       NO NAKED REFERENCES.  Use full global refs.
 ;     5 - BIDFLT  (opt) Default first selection (if no previous).
 ;     6 - BIPC    (opt) Piece of zero node to display as ItemName.
 ;                       (Default is 1.)
 ;
 ;     7 - BIID    (opt) Identifier: Three pieces delimited by ";".
 ;                       1st piece = the "^" piece of 0 node to get X.
 ;                       2nd piece = Code to set X=text of identifier.
 ;                                   If null, raw data in the piece of
 ;                                   0 node (as specified above) will
 ;                                   be displayed.
 ;                       3rd piece = Tab for identfier.
 ;
 ;                       Examples:
 ;                         Display 3rd pc of 0 node:  S BIID="3"
 ;
 ;                         Display 3rd pc of 0 node,
 ;                                 tabbed out to 40:  S BIID="3;;40"
 ;
 ;                         Set X=3rd pc of 0 node, use it as an IEN in
 ;                         the STATE file, set X=text of State, tab out
 ;                         to column 25 in Listman display:
 ;
 ;                 S BIID="3;I $G(X) S:$D(^DIC(5,X,0)) X=$P(^(0),U);25"
 ;
 ;
 ;     8 - BICOL   (opt) Line of text that will be column headers.
 ;
 ;     9 - BIPOP   (ret) BIPOP=1 if quit or error.
 ;
 ;    10 - BINONE  (opt) If BINONE=1 and NO selections were made,
 ;                          do not return any BIARR1.
 ;                       If '$G(BINONE) and NO selections were made,
 ;                          return BIARR1_("ALL").
 ;                       If user selects "Entire File", then "ALL" will
 ;                          be returned regardless of BINONE.
 ;
 ;    11 - BIFLD   (opt) BIFLD=Field# If BIFLD has a value, it indicates
 ;                       that this is NOT a selection from a file; rather
 ;                       it is a selection of Codes from a field in BIFILE.
 ;
 ;    12 - BIDFA   (opt) BIDFA=Default Array of choices.
 ;    13 - BITITEM (opt) Catagoric name of Title Items being selected.
 ;                       This might be a specific name for the items chosen,
 ;                       as opposed to the generic name (e.g,. "ER Doctors"
 ;                       as opposed to "Doctors").
 ;
 ;
 ;---> Examples of calls:
 ;
 ;  Simple call: Select one or more Vaccines and store
 ;               in the local array BIZZ:
 ;
 ;   D SEL^BISELECT(9999999.14,"BIZZ")
 ;
 ;
 ;  Complex call: Select one or more Active Vaccines and store
 ;                in the local array BIZZ.  Also, display Current
 ;                Lot Number, tabbed to column 20 in Listman display.
 ;
 ;   S SCRN="I '$P(^AUTTIMM(Y,0),U,7)"
 ;   S IDEN="4;I $G(X) S:$D(^AUTTIML(X,0)) X=$P(^(0),U);20"
 ;   D SEL^BISELECT(9999999.14,"BIZZ","Vaccine",SCRN,,2,IDEN,,.BIPOP)
 ;
 ;
 ;---> Example use of Selection Array in calling routine:
 ;       I '$D(BIARR("ALL")) Q:'$D(BIARR($P(Y,U,4)))
 ;       "If not selecting all, then quit if the fourth piece of
 ;        this entry (Y) is not one of the items selected."
 ;
 ;
 N BIDUZF,BIGBL,BIITEMS,BITITEMS,DIC,DIK,DIR,I,X,Y,Z
 S BIPOP=0
 ;
 ;---> Check/set required variables.
 I $$CHECK() S BIPOP=1 Q
 ;
 ;---> BIDUZF=User-File# identifier to store and retrieve
 ;---> previous lists of selections from this file.
 S BIDUZF=DUZ_"-"_BIFILE
 ;---> If this is a Set of Codes, concat Field#.
 S:$G(BIFLD) BIDUZF=BIDUZF_"-"_BIFLD
 ;
 ;---> Clear "ALL" node.
 K @(BIARR1_"(""ALL"")")
 ;
 ;---> If a Default Local Array of selections was passed, set them now.
 ;---> NOTE: This passed default array will OVERRIDE a previously selected
 ;---> and stored array in ^BISELECT.
 D:$O(BIDFA(0))
 .N N S N=0
 .F  S N=$O(BIDFA(N)) Q:'N  S @(BIARR1_"(N)")=""
 ;
 ;---> If previously stored selections exist for this user,
 ;---> pre-load these into the Selection Array that Listmanager
 ;---> will be processing.
 I $D(^BISELECT("B",BIDUZF)) D
 .;---> Quit if a local array of selections already exists.
 .Q:$O(@(BIARR1_"(0)"))
 .N BIDA S BIDA=$O(^BISELECT("B",BIDUZF,0))
 .Q:'BIDA  Q:$G(^BISELECT(BIDA,0))=""
 .Q:'$O(^BISELECT(BIDA,1,0))
 .N Y S Y=0
 .F  S Y=$O(^BISELECT(BIDA,1,Y)) Q:Y=""  D
 ..;---> If this is a Set of Codes, set the Value of the stored node
 ..;---> (rather than the subscript) into the Selection Array.
 ..I $G(BIFLD) D  Q
 ...N Z S Z=^BISELECT(BIDA,1,Y,0),@(BIARR1_"(Z)")=""
 ..S @(BIARR1_"(Y)")=""
 ;
 ;
 ;---> If there are no previous selections and a default
 ;---> was passed, load the default into the Selection Array.
 I '$O(@(BIARR1_"(0)")) I BIDFLT S @(BIARR1_"(+BIDFLT)")=""
 ;
 ;
 ;---> * Listmanager call to add/delete Items in the Selection Array.
 D START^BISELEC1(.BIARR1,BIGBL,BIITEMS,BITITEMS,BIPC,BISCRN,BIID,BICOL,BIFLD,.BIPOP)
 ;
 ;---> If All were selected, remove any specific IENs from array.
 ;---> Also leave intact user's previous selection (don't store "Entire").
 I $D(@(BIARR1_"(""ALL"")")) K @(BIARR1) S @(BIARR1_"(""ALL"")")="" Q
 ;
 ;---> If none were selected BINONE'=1, Set (return) BIARR1_"ALL"
 I '$D(@(BIARR1)),'$G(BINONE) S @(BIARR1_"(""ALL"")")=""
 Q:BIPOP
 ;
 ;
 ;---> Now store list of Items selected in this file for next time.
 ;
 ;---> If the user selected nothing or Entire, leave previous selection intact.
 Q:$O(@(BIARR1_"(0)"))=""
 ;
 ;---> Clear any previous selection this user had for this file.
 I $D(^BISELECT("B",BIDUZF)) D
 .N DA,DIK S DA=$O(^BISELECT("B",BIDUZF,0)),DIK="^BISELECT("
 .D ^DIK
 .S $P(^BISELECT(0),U,3)=1
 ;
 ;---> Now store the selections for this user.
 N Y
 D FILE^BIFMAN(9002084.61,BIDUZF,"ML",,,.Y)
 Q:Y<1
 D
 .;---> If this is a Set of Codes, assign IEN's.
 .I +$G(BIFLD) D  Q
 ..N I,N S N=0,Y=+Y
 ..F I=1:1 S N=$O(@(BIARR1_"(N)")) Q:N=""  D
 ...S ^BISELECT(Y,1,I,0)=N
 .;
 .;---> Store IEN's of a File.
 .N N S N=0,Y=+Y
 .F  S N=$O(@(BIARR1_"(N)")) Q:'N  D
 ..S ^BISELECT(Y,1,N,0)=N
 ;
 Q
 ;
 ;
 ;----------
CHECK() ;EP
 ;---> Check required variables.
 ;
 I $G(DUZ)="" D ERRCD^BIUTL2(106,,1) Q 1
 ;
 ;---> Check that the File Number was passed and is legitimate.
 I '$G(BIFILE) D ERRCD^BIUTL2(607,,1) Q 1
 I '$D(^DD(BIFILE)) D ERRCD^BIUTL2(608,,1) Q 1
 I '$D(^DIC(BIFILE,0,"GL")) D ERRCD^BIUTL2(608,,1) Q 1
 ;
 ;---> Check that Selection Array name for Item storage is present.
 I $G(BIARR1)="" D ERRCD^BIUTL2(602,,1) Q 1
 ;---> Check valid form of Selection Array root.
 I BIARR1["(" D ERRCD^BIUTL2(605,,1) Q 1
 I $E(BIARR1)="^" D ERRCD^BIUTL2(606,,1) Q 1
 ;
 ;---> Set lookup global.
 D:$G(BIGBL)=""
 .S BIGBL=^DIC(BIFILE,0,"GL")
 .;
 .;---> If .01 field is a pointer, reset global to get text from
 .;---> pointed-to global.
 .I $P(^DD(BIFILE,.01,0),U,2)["P" S BIGBL="^"_$P(^(0),U,3)
 ;
 ;---> Check that the global for Item selection is legitimate.
 I '$D(@(BIGBL_"0)")) D ERRCD^BIUTL2(601,,1) Q 1
 ;
 ;---> Check that variable for Item name is present.
 I $G(BIITEM)="" S BIITEM=$P($G(^DD(BIFILE,.01,0)),U)
 S:BIITEM="" BIITEM="Item"
 S:'$D(BITITEM) BITITEM=BIITEM
 ;
 ;---> Check for plural form of Item Name.
 I $G(BIITEMS)="" D PLURAL(BIITEM,.BIITEMS)
 I $G(BITITEMS)="" D PLURAL(BITITEM,.BITITEMS)
 ;
 ;---> Check for existence and value of optional input parameters.
 S:'$G(BIPC) BIPC=1
 S:$G(BISCRN)="" BISCRN=""
 S:'$G(BIDFLT) BIDFLT=""
 S:$G(BIID)="" BIID=""
 S:$G(BICOL)="" BICOL=""
 S:$G(BIFLD)="" BIFLD=""
 ;
 Q 0
 ;
 ;
 ;----------
PLURAL(BIITEM,BIITEMS) ;EP
 ;---> Add "s" for plural.
 ;---> If necessary change "y" to "i" and add "es".
 ;---> Parameters:
 ;     1 - BIITEM  (req) Item name, singular form.
 ;     2 - BIITEMS (ret) Item name, plural form.
 ;
 I $G(BIITEM)="" S BIITEMS="" Q
 ;
 I "Yy"[$E(BIITEM,$L(BIITEM)) D  Q
 .S BIITEMS=$E(BIITEM,1,($L(BIITEM)-1))_"ies"
 ;
 I "Xx"[$E(BIITEM,$L(BIITEM)) D  Q
 .S BIITEMS=BIITEM_"es"
 ;
 S BIITEMS=BIITEM_"s"
 Q
 ;
 ;
 ;----------
SELCODE(BIFILE,BIARR1,BIITEM,BISCRN,BIDFLT,BIPC,BIID,BICOL,BIPOP,BINONE) ;EP
 ;---> Generic utility to prompt user for selections from a file.
 ;---> Returns local array with subscripts of IENs selected.
 ;---> Parameters:
 ;     1 - BIFILE  (req) File Number from which selection will be made.
 Q
