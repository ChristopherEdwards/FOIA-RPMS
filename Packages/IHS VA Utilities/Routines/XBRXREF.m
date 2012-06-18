XBRXREF ; IHS/ADC/GTH - RE-XREF SELECTED XREFS ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; This routine re-xrefs selected cross references for a file.
 ; The xrefs are killed at the highest level and then reset.
 ; This is very different from what FileMan does when you
 ; RE-INDEX a field.  FileMan does a logical kill and then
 ; sets the new xrefs.  The reason for this is multiple fields
 ; may set the same xref so you would want to kill only the
 ; ones set by the field being RE-INDEXed.
 ;
 ; You must re-xref all fields that set any one of the xrefs
 ; being killed and reset, unless the xref is set the same
 ; from multiple fields.  Very hard to explain.  If you do
 ; not understand the problem, you probably shouldn't be
 ; running this routine.
 ;
 ; This routine executes an entry point in ^DIK to build the
 ; xref logic for all xrefs on the file.  It then deletes the
 ; logic for all xrefs not selected, and executes another
 ; entry point in ^DIK to actually xref the file.
 ;
 ; TRIGGERS are very complex animals, which do not have a
 ; xref to kill plus may be conditional and may have no affect
 ; on the SET side at all.  Because of the uncertainties here
 ; this routine will not do TRIGGERS.
 ;
 ; Xrefs at the multiple level would require a $O through the
 ; data global to kill, therefore, sub-file xrefs are not
 ; selectable unless they are cross-referenced to the whole
 ; file.
 ;
START ;
 D INIT^XBRXREF2 ;            Do initialization
 D GETFILE^XBRXREF2 ;         Get file to be RE-XREFed
 I XBRXREF("QFLG") D EOJ Q
 D BLDXRT^XBRXREF2 ;          Build xref table
 I XBRXREF("QFLG") D EOJ Q
 D CONFIRM^XBRXREF2 ;         Get confirmation from user
 I XBRXREF("QFLG") D EOJ Q
EN ; EXTERNAL ENTRY POINT
 D SETUP ;                    Set up xrefs for ^DIK
 D KILL ;                     Kill xrefs
 D XREF ;                     For each entry, set xrefs
 D EOJ ;                      Clean up
 Q
 ;
SETUP ; SETUP XREFS FOR ^DIK
 S DIK=XBRXREF("GBL"),X=1
 D DD^DIK
 S XBRXREF("DIK FILE")=""
 F XBRXREF("L")=0:0 S XBRXREF("DIK FILE")=$O(^UTILITY("DIK",$J,XBRXREF("DIK FILE"))) Q:XBRXREF("DIK FILE")=""  D SETUPB
 Q
 ;
SETUPB ; KILL OFF DIK FILE/SUB-FILES NOT NEEDED
 I '$D(^TMP("XBRXREF",$J,XBRXREF("DIK FILE"))) KILL ^UTILITY("DIK",$J,XBRXREF("DIK FILE")) Q
 S XBRXREF("DIK FIELD")=""
 F XBRXREF("L")=0:0 S XBRXREF("DIK FIELD")=$O(^UTILITY("DIK",$J,XBRXREF("DIK FILE"),XBRXREF("DIK FIELD"))) Q:XBRXREF("DIK FIELD")=""  D SETUPC
 Q
 ;
SETUPC ; KILL OFF DIK FIELDS NOT NEEDED
 I '$D(^TMP("XBRXREF",$J,XBRXREF("DIK FILE"),XBRXREF("DIK FIELD"))) KILL ^UTILITY("DIK",$J,XBRXREF("DIK FILE"),XBRXREF("DIK FIELD")) Q
 S XBRXREF("DIK XREF")=0
 F XBRXREF("L")=0:0 S XBRXREF("DIK XREF")=$O(^UTILITY("DIK",$J,XBRXREF("DIK FILE"),XBRXREF("DIK FIELD"),XBRXREF("DIK XREF"))) Q:XBRXREF("DIK XREF")=""  D SETUPD
 Q
 ;
SETUPD ; KILL OFF DIK XREFS NOT NEEDED
 I '$D(^TMP("XBRXREF",$J,XBRXREF("DIK FILE"),XBRXREF("DIK FIELD"),XBRXREF("DIK XREF"))) KILL ^UTILITY("DIK",$J,XBRXREF("DIK FILE"),XBRXREF("DIK FIELD"),XBRXREF("DIK XREF")) Q
 Q
 ;
KILL ; KILL XREFS
 S XBRXREF("FILE")=""
 F XBRXREF("L")=0:0 S XBRXREF("FILE")=$O(^TMP("XBRXREF",$J,XBRXREF("FILE"))) Q:XBRXREF("FILE")=""  D KILL2
 Q
 ;
KILL2 ;
 S XBRXREF("FIELD")=""
 F XBRXREF("L")=0:0 S XBRXREF("FIELD")=$O(^TMP("XBRXREF",$J,XBRXREF("FILE"),XBRXREF("FIELD"))) Q:XBRXREF("FIELD")=""  D KILL3
 Q
KILL3 ;
 S XBRXREF("XREF")=""
 F XBRXREF("L")=0:0 S XBRXREF("XREF")=$O(^TMP("XBRXREF",$J,XBRXREF("FILE"),XBRXREF("FIELD"),XBRXREF("XREF"))) Q:XBRXREF("XREF")=""  S X=^(XBRXREF("XREF")) W !,"Killing ",X KILL @(XBRXREF("GBL")_"X)")
 Q
 ;
XREF ; SET XREFS FOR ALL ENTRIES
 D NOW^%DTC
 S Y=%
 X ^DD("DD")
 W !!,"Beginning run at ",$P(Y,"@",2)," <WAIT>"
 S (DA,DCNT)=0
 D CNT^DIK1
 Q
 ;
EOJ ; EOJ HOUSEKEEPING
 I 'XBRXREF("QFLG") D NOW^%DTC S Y=% X ^DD("DD") W !!,"Finished run at ",$P(Y,"@",2)
 KILL XBRXREF,%,%H,%I,DA,DCNT,DIC,DIK,X,Y,^TMP("XBRXREF",$J),^UTILITY("DIK",$J)
 Q
 ;
