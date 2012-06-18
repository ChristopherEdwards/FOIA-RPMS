BEHORXIN ;MSC/IND/DKM - Installation Support for Med Management;13-Oct-2011 14:53;PLS
 ;;1.1;BEH COMPONENTS;**009002,009005,009007**;Mar 20, 2007
 ;=================================================================
PREINIT ;EP - Preinitialization
 D RNMFMT
 Q
POSTINIT ;EP - Postinitialization
 D REGNMSP^CIAURPC("APSP","CIAV VUECENTRIC")
 Q
 ;
 N CMFDLG
 S CMFDLG=$$FIND1^DIC(101.41,,"XQ","OR GTX CMF")
 I 'CMFDLG D
 .N FDA,IEN
 .S FDA=$NA(FDA(101.41,"+1,"))
 .S @FDA@(.01)="OR GTX CMF"
 .S @FDA@(2)="Chronic Med?"
 .S @FDA@(4)="P"
 .S @FDA@(11)="S"
 .S @FDA@(12)="Y:YES;N:NO"
 .S @FDA@(13)="CMF"
 .D UPDATE^DIE("","FDA","IEN")
 .S CMFDLG=+$G(IEN(1))
 I 'CMFDLG D
 .D BMES^XPDUTL("Unable to add chronic med prompt to ORDER DIALOG file.")
 E  D ADDCMF("PS MEDS"),ADDCMF("PSO OERR")
 D REGNMSP^CIAURPC("APSP","CIAV VUECENTRIC")
 D REGMENU^BEHUTIL("BEHORX MAIN",,"MED")
 Q
 ; Add CMF prompt to order dialog
ADDCMF(DLGNAME) ;
 N ORDLG,FDA,IEN
 S ORDLG=$$FIND1^DIC(101.41,,"XQ",DLGNAME)
 Q:'ORDLG
 Q:$O(^ORD(101.41,ORDLG,10,"D",CMFDLG,0))
 S FDA=$NA(FDA(101.412,"+1,"_ORDLG_","))
 S @FDA@(.01)=4.7
 S @FDA@(2)=CMFDLG
 S @FDA@(9)="*"
 S @FDA@(21)=10
 S @FDA@(24)="Chronic Med:"
 D UPDATE^DIE("","FDA","IEN")
 D:'$G(IEN(1)) BMES^XPDUTL("Unable to add chronic med prompt to "_DLGNAME_" order dialog.")
 Q
 ;Change name of print formats
RNMFMT ;EP-
 N NM,IEN,DIK,TMPL,LP
 F LP=0:1 S TMPL=$P($T(LTMPL+LP),";;",2) Q:'$L(TMPL)  D
 .S IEN=$O(^BEHORX(90460.07,"B",TMPL,0)) Q:'IEN  D
 ..S NM=$P(^BEHORX(90460.07,IEN,0),U)
 ..Q:$E(NM,$L(NM)-7,$L(NM))="(SAMPLE)"
 ..S NM=NM_"(SAMPLE)"
 ..S $P(^BEHORX(90460.07,IEN,0),U)=NM
 K ^BEHORX(90460.07,"B")
 S DIK="^BEHORX(90460.07,",DIK(1)=".01"
 D ENALL^DIK
 Q
LTMPL ;;ORDER FOR SIGNATURE (CII)
 ;;ORDER FOR SIGNATURE (NON-CII)
 ;;PRESCRIPTION (CII)
 ;;PRESCRIPTION (NON-CII)
 ;;RECEIPT (CII)
 ;;RECEIPT (NON-CII)
 ;;
