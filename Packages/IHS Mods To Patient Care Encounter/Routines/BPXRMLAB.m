BPXRMLAB ; IHS/CIA/MGH - Use V Labs in reminder resolution. ;20-May-2009 08:55;MGH
 ;;1.5;CLINICAL REMINDERS;**1003,1004,1006**;Jun 19, 2000
 ;===================================================================
VLAB(DFN,LABIEN,COUNT) ;EP  Find a patients labs in the V LAB file
 ;Get up to ten results of the specified lab test
 ;If the result has an associated LR ACCESSION NUMBER quit
 ;If not, add it to the array to be used in the reminder
 ;The list is kept in
 ;^TMP("LRRR",$J,DFN,"CH",INVDATE,SEQ)=TEST_U_RESULT_U_FLAG_U_UNITS
 ;Added check, if site is using a unidirectional lab interface, use items with
 ;a LR ACCESSION NUMBER
 ;===================================================================
 N ORDER,VLIEN,LABNUM,SEARCH,INVDATE,TEMP,TEMP1,UINTER
 S INVDATE="",COUNT=0
 S UINTER=$$GET^XPAR("ALL","BPXRM LAB UNI INTERFACE")
 F  S INVDATE=$O(^AUPNVLAB("AA",DFN,LABIEN,INVDATE)) Q:INVDATE=""!(COUNT>10)  D
 .S VLIEN="" F  S VLIEN=$O(^AUPNVLAB("AA",DFN,LABIEN,INVDATE,VLIEN)) Q:VLIEN=""  D
 ..S TEMP=$G(^AUPNVLAB(VLIEN,0))
 ..;If the sixth field which should have the lab accession number is blank,
 ..;this entry was entered through PCC and should be counted
 ..I UINTER=1 D STORE
 ..E  I $P(TEMP,U,6)="" D STORE
 Q
STORE ;Store the needed data into TMP for use in reminders
 N TEST,VALUE,FLAG,UNITS,SEQ,TEMP1,TEMP2
 S SEQ=1,COUNT=COUNT+1
 S TEMP1=$G(^AUPNVLAB(VLIEN,11))
 S VALUE=$P(TEMP,U,4) I VALUE="" S VALUE="pending"
 S FLAG=$P(TEMP,U,5)
 S UNITS=$P(TEMP1,U,1)
 S TEMP2=LABIEN_U_VALUE_U_FLAG_U_UNITS
 S $P(TEMP2,U,15)=$P($G(^LAB(60,LABIEN,.1)),"^")
 S ^TMP("LRRR",$J,DFN,"CH",INVDATE,LABIEN)=TEMP2
 Q
