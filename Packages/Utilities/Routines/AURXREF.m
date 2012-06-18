AURXREF ; RE-XREF SELECTED XREFS [ 10/27/87  8:31 AM ]
 ; EDE/10-12-87
 ;
 ; This routine re-xrefs selected cross references for
 ; a file.  The xrefs are killed at the highest level and
 ; then reset.  This is very different from what FileMan does when
 ; you RE-INDEX a field.  FileMan does a logical kill and then sets
 ; the new xrefs.  The reason for this is multiple fields may set the
 ; same xref so you would want to kill only the ones set by the
 ; field being RE-INDEXed.
 ;
 ; You must re-xref all fields that set any one of the xrefs being
 ; killed and reset, unless the xref is set the same from multiple
 ; fields.  Very hard to explain.  If you do not understand the
 ; problem, you probably shouldn't be running this routine.
 ;
 ; This routine executes an entry point in ^DIK to build the xref
 ; logic for all xrefs on the file.  It then deletes the logic
 ; for all xrefs not selected, and executes another entry point
 ; in ^DIK to actually xref the file.
 ;
 ; TRIGGERS are very complex animals, which do not have a xref to kill
 ; plus may be conditional and may have no affect on the SET side
 ; at all.  Because of the uncertainties here this routine will not
 ; do TRIGGERS.
 ;
 ; Xrefs at the multiple level would require a $O through the data
 ; global to kill, therefore, sub-file xrefs are not selectable
 ; unless they are cross-referenced to the whole file.
 ;
START ;
 D INIT^AURXREF2 ;            Do initialization
 D GETFILE^AURXREF2 ;         Get file to be RE-XREFed
 I AURXREF("QFLG") D EOJ Q
 D BLDXRT^AURXREF2 ;          Build xref table
 I AURXREF("QFLG") D EOJ Q
 D CONFIRM^AURXREF2 ;         Get confirmation from user
 I AURXREF("QFLG") D EOJ Q
 D SETUP ;                    Set up xrefs for ^DIK
 D KILL ;                     Kill xrefs
 D XREF ;                     For each entry, set xrefs
 D EOJ ;                      Clean up
 Q
 ;
SETUP ; SETUP XREFS FOR ^DIK
 S DIK=AURXREF("GBL"),X=1 D DD^DIK
 S AURXREF("DIK FILE")="" F AURXREF("L")=0:0 S AURXREF("DIK FILE")=$O(^UTILITY("DIK",$J,AURXREF("DIK FILE"))) Q:AURXREF("DIK FILE")=""  D SETUPB
 Q
 ;
SETUPB ; KILL OFF DIK FILE/SUB-FILES NOT NEEDED
 I '$D(^UTILITY("AURXREF",$J,AURXREF("DIK FILE"))) K ^UTILITY("DIK",$J,AURXREF("DIK FILE")) Q
 S AURXREF("DIK FIELD")="" F AURXREF("L")=0:0 S AURXREF("DIK FIELD")=$O(^UTILITY("DIK",$J,AURXREF("DIK FILE"),AURXREF("DIK FIELD"))) Q:AURXREF("DIK FIELD")=""  D SETUPC
 Q
 ;
SETUPC ; KILL OFF DIK FIELDS NOT NEEDED
 I '$D(^UTILITY("AURXREF",$J,AURXREF("DIK FILE"),AURXREF("DIK FIELD"))) K ^UTILITY("DIK",$J,AURXREF("DIK FILE"),AURXREF("DIK FIELD")) Q
 S AURXREF("DIK XREF")=0  F AURXREF("L")=0:0 S AURXREF("DIK XREF")=$O(^UTILITY("DIK",$J,AURXREF("DIK FILE"),AURXREF("DIK FIELD"),AURXREF("DIK XREF"))) Q:AURXREF("DIK XREF")=""  D SETUPD
 Q
 ;
SETUPD ; KILL OFF DIK XREFS NOT NEEDED
 I '$D(^UTILITY("AURXREF",$J,AURXREF("DIK FILE"),AURXREF("DIK FIELD"),AURXREF("DIK XREF"))) K ^UTILITY("DIK",$J,AURXREF("DIK FILE"),AURXREF("DIK FIELD"),AURXREF("DIK XREF")) Q
 Q
 ;
KILL ; KILL XREFS
 S AURXREF("FILE")="" F AURXREF("L")=0:0 S AURXREF("FILE")=$O(^UTILITY("AURXREF",$J,AURXREF("FILE"))) Q:AURXREF("FILE")=""  D KILL2
 Q
 ;
KILL2 ;
 S AURXREF("FIELD")="" F AURXREF("L")=0:0 S AURXREF("FIELD")=$O(^UTILITY("AURXREF",$J,AURXREF("FILE"),AURXREF("FIELD"))) Q:AURXREF("FIELD")=""  D KILL3
 Q
KILL3 ;
 S AURXREF("XREF")="" F AURXREF("L")=0:0 S AURXREF("XREF")=$O(^UTILITY("AURXREF",$J,AURXREF("FILE"),AURXREF("FIELD"),AURXREF("XREF"))) Q:AURXREF("XREF")=""  D KILL4
 Q
 ;
KILL4 ;
 S X=^(AURXREF("XREF"))
 W !,"Killing ",X K @(AURXREF("GBL")_"X)")
 Q
 ;
XREF ; SET XREFS FOR ALL ENTRIES
 D NOW^%DTC S Y=% X ^DD("DD") W !!,"Beginning run at ",$P(Y,"@",2)," <WAIT>"
 S (DA,DCNT)=0 D CNT^DIK1
 Q
 ;
EOJ ; EOJ HOUSEKEEPING
 I 'AURXREF("QFLG") D NOW^%DTC S Y=% X ^DD("DD") W !!,"Finished run at ",$P(Y,"@",2)
 K AURXREF
 K %,%H,%I,DA,DIC,DIK,X,Y
 K ^UTILITY("AURXREF",$J),^UTILITY("DIK",$J)
 Q
