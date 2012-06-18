PXRMV1ID ; SLC/PJH - Build selectable code lists ;10/25/1999
 ;;1.5;CLINICAL REMINDERS;;Jun 19, 2000
 ;
 ;Implementation utility
 ;----------------------
START ;Lock entire taxonomy file
 I $$LOCK D
 .D BMES^XPDUTL("Generating selectable codes from taxonomy file")
 .K ^TMP("PXRM",$J)
 .N TAXIND
 .S TAXIND=0
 .F  S TAXIND=$O(^PXD(811.2,TAXIND)) Q:'TAXIND  D
 ..;Remove any existing entries
 ..D DEL(TAXIND)
 ..;Build new list of selectable codes
 ..D BCL(TAXIND)
 .D BMES^XPDUTL("Generation completed")
 D UNLOCK
 Q
 ;
 ;Build the list of codes for one taxonomy
 ;----------------------------------------
BCL(TAXIND) ;
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
 .F  S IC=$O(^PXD(811.2,TAXIND,FILE,IC)) Q:+IC=0  D
 ..S TEMP=$G(^PXD(811.2,TAXIND,FILE,IC,0))
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
 D STORE(TAXIND)
 K ^TMP("PXRM",$J,"ICD9IEN")
 K ^TMP("PXRM",$J,"ICPTIEN")
 Q
 ;
 ;=======================================================================
DEL(TAXIND) ;Delete existing entry
 K ^PXD(811.2,TAXIND,"SDX")
 K ^PXD(811.2,TAXIND,"SPR")
 Q
 ;
 ;Build the list of internal entries for ICD9 (File 80)
 ;-----------------------------------------------------
ICD9(LOW,HIGH) ;
 N END,IEN,IND
 S IND=LOW_" "
 S END=HIGH_" "
 F  Q:(IND]END)!(+IND>+END)!(IND="")  D
 .S IEN=$O(^ICD9("BA",IND,""))
 .I (+IEN>0),$$CODE^PXRMVAL($TR(IND," "),80) D
 ..S ^TMP("PXRM",$J,"ICD9IEN",IND)=IEN
 .S IND=$O(^ICD9("BA",IND))
 Q
 ;
 ;Build the list of internal entries for ICPT (File 81)
 ;-----------------------------------------------------
ICPT(LOW,HIGH) ;
 N IEN,IND
 S IND=LOW
 F  Q:(IND]HIGH)!(+IND>+HIGH)!(IND="")  D
 .S IEN=$O(^ICPT("B",IND,""))
 .I (+IEN>0),$$CODE^PXRMVAL($TR(IND," "),81) D
 ..S ^TMP("PXRM",$J,"ICPTIEN",IND)=IEN
 .S IND=$O(^ICPT("B",IND))
 Q
 ;
 ;Lock the taxonomy file
LOCK() N IND,LOCK
 S LOCK=0
 F IND=1:1:30 Q:LOCK  D
 .L +^PXD(811.2):1
 .S LOCK=$T
 ;If we can't get lock generate an error and quit.
 I 'LOCK D  Q 0
 .D BMES^XPDUTL("Could not get lock for taxonomy file ")
 Q 1
 ;
 ;Store selectable codes in taxonomy
 ;----------------------------------
STORE(TAXIND) ;
 K ^TMP("PXRMV1ID",$J)
 N FDA,FDAIEN,FITEM,I2N,IEN,IND,MSG,NAME,SEQ,SUB,TEMP
 ;
 S NAME=$P(^PXD(811.2,TAXIND,0),U)
 ;
 S FDAIEN(1)=TAXIND
 ;
 S SUB="",IND=1,SEQ=0
 F  S SUB=$O(^TMP("PXRM",$J,"ICD9IEN",SUB)) Q:SUB=""  D
 .S IEN=^TMP("PXRM",$J,"ICD9IEN",SUB)
 .S IND=IND+1,SEQ=SEQ+1
 .S I2N="+"_IND_","_FDAIEN(1)_","
 .S ^TMP("PXRMV1ID",$J,811.23102,I2N,.01)=IEN
 .;S ^TMP("PXRMV1ID",$J,811.23102,I2N,.01)=SEQ
 .;S ^TMP("PXRMV1ID",$J,811.23102,I2N,1)=IEN
 .;S ^TMP("PXRMV1ID",$J,811.23102,I2N,3)=1
 ;
 S SEQ=0
 F  S SUB=$O(^TMP("PXRM",$J,"ICPTIEN",SUB)) Q:SUB=""  D
 .S IEN=^TMP("PXRM",$J,"ICPTIEN",SUB)
 .S IND=IND+1,SEQ=SEQ+1
 .S I2N="+"_IND_","_FDAIEN(1)_","
 .S ^TMP("PXRMV1ID",$J,811.23104,I2N,.01)=IEN
 .;S ^TMP("PXRMV1ID",$J,811.23104,I2N,.01)=SEQ
 .;S ^TMP("PXRMV1ID",$J,811.23104,I2N,1)=IEN
 .;S ^TMP("PXRMV1ID",$J,811.23104,I2N,3)=1
 ;
 ;None found
 I IND=1 Q
 ;
 S TEMP="^TMP(""PXRMV1ID"","_$J_")"
 D UPDATE^DIE("",TEMP,"FDAIEN","MSG")
 I $D(MSG) D ERR
 K ^TMP("PXRMV1ID",$J)
 Q
 ;
 ;Unlock the taxonomy
 ;-------------------
UNLOCK L -^PXD(811.2)
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
 ;Mail Message
 D ERR^PXRMV1IE(.ERROR)
 Q
