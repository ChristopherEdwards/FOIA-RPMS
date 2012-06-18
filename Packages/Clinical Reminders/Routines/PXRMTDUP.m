PXRMTDUP ; SLC/PJH - Update Taxonomy Dialog Selectable codes.;03/05/2001
 ;;1.5;CLINICAL REMINDERS;**2**;Jun 19, 2000
 ;
 ;
 ;Build the list of codes for one taxonomy
 ;----------------------------------------
BUILD(TIEN) ;
 N CODELIST,IC,FINDING,FILE,HIGH,LOW,NCE,TEMP
 ;
 ;Setup file names for indirection, these will hold the taxonomy lists.
 N ICD9IEN,ICPTIEN
 S ICD9IEN="^TMP(""PXRM"",$J,""ICD9IEN"")"
 S ICPTIEN="^TMP(""PXRM"",$J,""ICPTIEN"")"
 ;
 S NCE=0
 F FILE=80,81 D
 .S IC=0
 .F  S IC=$O(^PXD(811.2,TIEN,FILE,IC)) Q:+IC=0  D
 ..S TEMP=$G(^PXD(811.2,TIEN,FILE,IC,0))
 ..;Append the taxonomy and finding information to CODELIST.
 ..S NCE=NCE+1
 ..S CODELIST(NCE)=TEMP_U_FILE
 ;CODELIST is LOW_U_HIGH_U_FILE
 ;Go through the standard coded list and get the file IEN for each entry.
 F IC=1:1:NCE D
 .S LOW=$P(CODELIST(IC),U,1)
 .S HIGH=$P(CODELIST(IC),U,2)
 .S FILE=$P(CODELIST(IC),U,3)
 .I FILE=80 D ICD9(LOW,HIGH) Q
 .I FILE=81 D ICPT(LOW,HIGH) Q
 ;
 ;Store the results.
 D STORE(TIEN)
 K ^TMP("PXRM",$J,"ICD9IEN")
 K ^TMP("PXRM",$J,"ICPTIEN")
 Q
 ;
 ;Error Handler
 ;-------------
ERR N ERROR,IC,REF
 S ERROR(1)="Unable to build selectable codes for taxonomy : "
 S ERROR(2)=NAME
 S ERROR(3)="Error in UPDATE^DIE, needs further investigation"
 ;Move MSG into ERROR
 S REF="MSG"
 F IC=4:1 S REF=$Q(@REF) Q:REF=""  S ERROR(IC)=REF_"="_@REF
 ;Screen message
 D BMES^XPDUTL(.ERROR)
 Q
 ;
 ;Build the list of internal entries for ICD9 (File 80)
 ;-----------------------------------------------------
ICD9(LOW,HIGH) ;
 N END,IEN,IND,TMP
 S IND=LOW_" "
 S END=HIGH_" "
 F  Q:(IND]END)!(+IND>+END)!(IND="")  D
 .S IEN=$O(^ICD9("BA",IND,""))
 .I (+IEN>0) D
 ..;Ignore both invalid and inactive codes
 ..S TMP=$$CODE^PXRMVAL($TR(IND," "),80) Q:'TMP  Q:$P(TMP,U,9)=1
 ..S ^TMP("PXRM",$J,"ICD9IEN",IND)=IEN
 .S IND=$O(^ICD9("BA",IND))
 Q
 ;
 ;Build the list of internal entries for ICPT (File 81)
 ;-----------------------------------------------------
ICPT(LOW,HIGH) ;
 N IEN,IND,TMP
 S IND=LOW
 F  Q:(IND]HIGH)!(+IND>+HIGH)!(IND="")  D
 .S IEN=$O(^ICPT("B",IND,""))
 .I (+IEN>0) D
 ..;Ignore both invalid and inactive codes
 ..S TMP=$$CODE^PXRMVAL($TR(IND," "),81) Q:'TMP  Q:$P(TMP,U,9)=1
 ..S ^TMP("PXRM",$J,"ICPTIEN",IND)=IEN
 .S IND=$O(^ICPT("B",IND))
 Q
 ;
 ;Store selectable codes in taxonomy
 ;----------------------------------
STORE(TIEN) ;
 K ^TMP("PXRMTDUP",$J)
 N FDA,FDAIEN,FITEM,I2N,IEN,IND,MSG,NAME,SEQ,SUB,TEMP
 ;
 S NAME=$P(^PXD(811.2,TIEN,0),U)
 ;
 S FDAIEN(1)=TIEN
 ;
 S SUB="",IND=1,SEQ=0
 F  S SUB=$O(^TMP("PXRM",$J,"ICD9IEN",SUB)) Q:SUB=""  D
 .S IEN=^TMP("PXRM",$J,"ICD9IEN",SUB)
 .S IND=IND+1,SEQ=SEQ+1
 .S I2N="+"_IND_","_FDAIEN(1)_","
 .S ^TMP("PXRMTDUP",$J,811.23102,I2N,.01)=IEN
 ;
 S SEQ=0
 F  S SUB=$O(^TMP("PXRM",$J,"ICPTIEN",SUB)) Q:SUB=""  D
 .S IEN=^TMP("PXRM",$J,"ICPTIEN",SUB)
 .S IND=IND+1,SEQ=SEQ+1
 .S I2N="+"_IND_","_FDAIEN(1)_","
 .S ^TMP("PXRMTDUP",$J,811.23104,I2N,.01)=IEN
 ;
 ;None found
 I IND=1 Q
 ;
 S TEMP="^TMP(""PXRMTDUP"","_$J_")"
 D UPDATE^DIE("",TEMP,"FDAIEN","MSG")
 I $D(MSG) D ERR
 K ^TMP("PXRMTDUP",$J)
 Q
 ;
 ;Check for and purge inactive or invalid selectable codes
 ;--------------------------------------------------------
PURGE(TXIEN) ;
 N CODE,DATA,FILE,IEN,NODE,SUB
 F NODE="SPR","SDX" D
 .S SUB=0
 .F  S SUB=$O(^PXD(811.2,TXIEN,NODE,SUB)) Q:'SUB  D
 ..S DATA=$G(^PXD(811.2,TXIEN,NODE,SUB,0)) Q:DATA=""
 ..;Get ien of code
 ..S IEN=$P(DATA,U) Q:IEN=""
 ..;Translate ien to code
 ..I NODE="SDX" S CODE=$P($G(^ICD9(IEN,0)),U),FILE=80
 ..I NODE="SPR" S CODE=$P($$CPT^ICPTCOD(IEN),U,2),FILE=90
 ..;Ignore codes which are both valid and active
 ..S DATA=$$CODE^PXRMVAL(CODE,FILE) I $P(DATA,U)&'$P(DATA,U,9) Q
 ..;Kill Inactive or Invalid codes
 ..N DIK,DA
 ..S DA(1)=TXIEN,DA=SUB,DIK="^PXD(811.2,"_DA(1)_","""_NODE_""","
 ..D ^DIK
 Q
