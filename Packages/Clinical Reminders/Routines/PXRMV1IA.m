PXRMV1IA ; SLC/PJH - Inits for new REMINDER package. ;04/10/2000
 ;;1.5;CLINICAL REMINDERS;;Jun 19, 2000
 ;
 Q
 ;
 ;Copy Health Factor findings, Target Findings, Taxonomies
 ;to new sub-file FINDINGS 
 ;---------------------------------------------------------
RBLD N CNT,DATA,IEN,FDAIEN,FDA,IND,MAP,NAME,PXRMCVRT,STRING
 N SUB,SUB1,SUB2,WPTMP
 S PXRMCVRT=1
 ; Get each reminder in turn
 S IEN=0
 F  S IEN=$O(^PXD(811.9,IEN)) Q:'IEN  D  Q:$D(MSG)
 .I $D(REDO) Q:IEN'=REMINDER
 .K MAP,WPTMP
 .S NAME=$P($G(^PXD(811.9,IEN,0)),U)
 .;For testing
 .;Skip VA-reminders - these will be broadcast
 .I '$D(PXRMINST)&(NAME["VA-") Q
 .;If reminder is converted skip - unless called from REDO^PXRMV1I
 .I $$CONVDONE(IEN),'$D(REDO) D  Q
 ..S STRING="Skipping conversion - reminder "_NAME
 ..D BMES^XPDUTL(" "),BMES^XPDUTL(STRING)
 .;Remove existing entries
 .D RMONE(IEN)
 .;Build FDA array
 .K FDAIEN,FDA
 .S FDAIEN(1)=IEN,CNT=1
 .S FDA(811.9,"?1,",.01)="`"_IEN
 .S STRING="Converting findings in reminder "_NAME
 .D BMES^XPDUTL(" "),BMES^XPDUTL(STRING)
 .;Target findings 
 .D TARG(3)
 .;Taxonomies
 .D FIND(4)
 .;Health Factor findings
 .D FIND(6)
 .;Computed findings
 .D FIND(10)
 .;Apply logic conversion
 .D APPL(811.9,30)
 .;Update ^PXD(811.9
 .D UPDATE^DIE("S","FDA","FDAIEN","MSG")
 .I $D(MSG) D ERR
 Q
 ;
 ;Save Target findings to FDA
 ;---------------------------
TARG(TYP) ;
 N IND,SUB1,DATA
 S IND=0
 F  S IND=$O(^PXD(811.9,IEN,3,IND)) Q:'IND  D
 .;Target result finding item => findings item
 .S SUB1=0
 .F  S SUB1=$O(^PXD(811.9,IEN,3,IND,2,SUB1)) Q:'SUB1  D
 ..S DATA=$G(^PXD(811.9,IEN,3,IND,2,SUB1,0)) Q:DATA=""
 ..S CNT=CNT+1,FDA(811.902,"+"_CNT_",?1,",.01)=DATA
 ..;Target result found text => finding found text 
 ..D WFDA(3,3,811.902,4)
 ..;Target result not found text => finding not found text
 ..D WFDA(3,4,811.902,5)
 ..; Default 'Use in resolution logic' to OR
 ..D DFDA(811.902,7,"!")
 Q
 ;
 ;Save other findings to FDA
 ;--------------------------
FIND(TYP) ;
 N INC,IND,POINTER,OFFSET
 ;Computed findings record has an extra field (short desc.)
 ;INC is used to amend the PIECE variable when extracting CF data
 S INC=0
 ; Taxonomies
 I TYP=4 S POINTER="PXD(811.2,"
 ; Health Factors
 I TYP=6 S POINTER="AUTTHF("
 ; Computed Findings
 I TYP=10 S POINTER="PXRMD(811.4,",INC=1
 ;Move data entries into FDA
 S IND=0
 F  S IND=$O(^PXD(811.9,IEN,TYP,IND)) Q:'IND  D
 .;pointer => findings item
 .D SFDA(TYP,1,811.902,.01,POINTER)
 .;Minimum age => minimum age
 .D SFDA(TYP,2,811.902,1)
 .;Maximum age => maximum age
 .D SFDA(TYP,3,811.902,2)
 .;Reminder frequency => reminder frequency
 .D SFDA(TYP,4,811.902,3)
 .;found text => finding found text 
 .D WFDA(TYP,1,811.902,4)
 .;not found text => finding not found text
 .D WFDA(TYP,2,811.902,5)
 .;Rank frequency => rank frequency
 .D SFDA(TYP,5+INC,811.902,6)
 .;Use in date due => use in resolution logic (YES becomes OR) 
 .D SFDA(TYP,6+INC,811.902,7)
 .;Use in apply logic => use in patient cohort logic
 .D SFDA(TYP,7+INC,811.902,8)
 .;Effective period => effective period
 .D SFDA(TYP,8+INC,811.902,9)
 .;Use inactive problems => use inactive problems
 .D SFDA(TYP,9+INC,811.902,10)
 Q
 ;
 ;Insert Defaults for new fields
 ;------------------------------
DFDA(FILE,FIELD,DATA) ;
 S FDA(FILE,"+"_CNT_",?1,",FIELD)=DATA
 Q
 ;
 ;Store multiple field entries in FDA
 ;-----------------------------------
MFDA(INODE,IND1,FILE,FIELD) ;
 ;
 ;Requires IEN and IND defined
 ;
 N SUB1,DATA S SUB1=0
 ; Assemble fields into FDA array
 F  S SUB1=$O(^PXD(811.9,IEN,INODE,IND,IND1,SUB1)) Q:'SUB1  D
 .S DATA=$G(^PXD(811.9,IEN,INODE,IND,IND1,SUB1,0)) Q:DATA=""
 .S CNT=CNT+1,FDA(FILE,"+"_CNT_",?1,",FIELD)=DATA
 Q
 ;
 ;Store single field entries in FDA
 ;---------------------------------
SFDA(INODE,PIECE,FILE,FIELD,POINTER) ;
 ;
 ;Requires IEN and IND defined
 ;
 N DATA
 S DATA=$G(^PXD(811.9,IEN,INODE,IND,0)) Q:DATA=""
 ;Extract data item from string
 S DATA=$P(DATA,U,PIECE)
 ;If computed finding convert ROUTINE to CF IEN
 I PIECE=1,INODE=10 S DATA=$$CHECK(DATA) Q:DATA=""
 ;The first piece must be converted to a variable pointer
 I PIECE=1 D
 .S CNT=CNT+1
 .;Build mapping for Apply logic conversion
 .I TYP'=10 S MAP(TYP,DATA)=CNT-1
 .;For CF's store actual routine name
 .I TYP=10 D
 ..N PROG,REF S REF=$P($G(^PXRMD(811.4,DATA,0)),U,2,3) Q:REF=""
 ..S PROG=$P(REF,U,2)_";"_$P(REF,U)
 ..S MAP(TYP,PROG)=CNT-1
 .;Assemble pointer
 .S DATA=DATA_";"_POINTER
 ;If Use in Date Due (Resolution) field - convert 1 to OR and 0 to null
 I FIELD=7 S DATA=$S(DATA=1:"!",1:"")
 ;Store in FDA
 S FDA(FILE,"+"_CNT_",?1,",FIELD)=DATA
 Q
 ;
 ;Store WP entries in array WPTMP (create pointer from FDA)
 ;-------------------------------
WFDA(INODE,IND1,FILE,FIELD) ;
 ;
 ;Requires IEN,IND and TYP defined
 ;
 N SUB1,DATA,FOUND
 S SUB1=0,FOUND=0
 ; Assemble fields into FDA array
 F  S SUB1=$O(^PXD(811.9,IEN,INODE,IND,IND1,SUB1)) Q:'SUB1  D
 .S DATA=$G(^PXD(811.9,IEN,INODE,IND,IND1,SUB1,0)) Q:DATA=""
 .S:'FOUND FOUND=1
 .S WPTMP(TYP,IND,IND1,SUB1)=DATA
 I FOUND D
 .S FDA(FILE,"+"_CNT_",?1,",FIELD)="WPTMP("_TYP_","_IND_","_IND1_")"
 Q
 ;
 ;Convert Apply logic
 ;-------------------
APPL(FILE,FIELD) ;
 ;
 ; Requires IEN and MAP array
 ;
 N DATA,CONV,NSUB,SUB,STR
 ;Get existing apply logic
 S DATA=$G(^PXD(811.9,IEN,9)) Q:DATA=""
 ;Search for CF(nn),HF(nn) or TF(nn) entries and replace with FI(nnn)
 ;
 N TYP,TXT,DONE
 F TYP=4,6,10 D
 .I TYP=4 S TXT="TF("
 .I TYP=6 S TXT="HF("
 .I TYP=10 S TXT="CF("
 .S DONE=0
 .F  D  Q:DONE
 ..I (TYP=4)!(TYP=6) D  Q:DONE
 ...S SUB=+$P(DATA,TXT,2) I 'SUB S DONE=1
 ..I TYP=10 D  Q:DONE
 ...S SUB=$P($P(DATA,TXT,2),")") I SUB="" S DONE=1
 ..S NSUB=+$G(MAP(TYP,SUB))
 ..I SUB="OBESE;PXRMOBES" S NSUB=+$G(MAP(TYP,"BMI;PXRMBMI"))
 ..S STR=TXT_SUB_")"
 ..I NSUB S DATA=$P(DATA,STR)_"FI("_NSUB_")"_$P(DATA,STR,2,99)
 ..I 'NSUB S DATA=$P(DATA,STR)_"FI(NOT FOUND)"_$P(DATA,STR,2,99)
 ;
 ;Give warning if unable to convert
 I DATA["NOT FOUND" D  Q
 .N ERROR
 .S ERROR(1)="Reminder : "_$P($G(^PXD(811.9,IEN,0)),U)
 .S ERROR(2)="Unable to convert APPLY LOGIC due to finding not found"
 .S ERROR(3)="APPLY LOGIC :"
 .S ERROR(4)=$G(^PXD(811.9,IEN,9))
 .S ERROR(5)="COHORT LOGIC:"
 .S ERROR(6)=DATA
 .;Screen message
 .D BMES^XPDUTL(.ERROR)
 .;Mail message
 .D ERR^PXRMV1IE(.ERROR)
 ;
 ;Save modified apply logic in new field - cohort logic
 S FDA(FILE,"?1,",FIELD)=DATA
 Q
 ;
 ;Remove FINDING entries for one reminder
 ;---------------------------------------
RMONE(IEN) ;
 N DA,IND,NAME
 S NAME=$P(^PXD(811.9,IEN,0),U,1)
 S DA(1)=IEN
 S IND=""
 F  S IND=$O(^PXD(811.9,IEN,20,"B",IND)) Q:IND=""  D
 .S DA=0
 .F  S DA=$O(^PXD(811.9,IEN,20,"B",IND,DA)) Q:+DA=0  D
 ..S DIK="^PXD(811.9,"_IEN_","_20_"," D ^DIK
 Q
 ;
 ;See if conversion has already been done
 ;---------------------------------------
CONVDONE(IEN) ;
 ;If no finding entries exist conversion has not been done
 I +$D(^PXD(811.9,IEN,20))=0 Q 0
 Q 1
 ;Count finding file entries
 ;N FIND,IC
 ;S FIND=0,IC=0
 ;F  S IC=$O(^PXD(811.9,IEN,20,IC)) Q:'IC  D
 ;.S FIND=FIND+1
 ;;Count Target Findings
 ;N SUB,PRIOR
 ;S PRIOR=0,SUB=0
 ;F  S SUB=$O(^PXD(811.9,IEN,3,SUB)) Q:'SUB  D
 ;.S IC=0
 ;.F  S IC=$O(^PXD(811.9,IEN,3,SUB,2,IC)) Q:'IC  D
 ;..S PRIOR=PRIOR+1
 ;;Count Taxonomies,Health Factors and Computed Findings
 ;F SUB=4,6,10 D
 ;.S IC=0
 ;.F  S IC=$O(^PXD(811.9,IEN,SUB,IC)) Q:'IC  D
 ;..S PRIOR=PRIOR+1
 ;;Check if count of findings matches prior entries conversion complete
 ;I PRIOR=0 Q 1
 ;I (PRIOR>0)&(PRIOR=FIND) Q 1
 ;Otherwise not complete and must be re-run
 Q 0
 ;
 ;Search for routine entry point in the new computed findings file
 ;----------------------------------------------------------------
CHECK(ROUTINE) ;
 N BMI,SUB,TAG,FOUND
 ;Convert PXRMOBES to VA-BMI
 S BMI=$O(^PXRMD(811.4,"B","VA-BMI",""))
 I (ROUTINE="OBESE;PXRMOBES"),BMI Q BMI
 ;Otherwise get ien of CF
 S SUB=0,FOUND=""
 F  S SUB=$O(^PXRMD(811.4,SUB)) Q:'SUB  D  Q:FOUND]""
 .S TAG=$P($G(^PXRMD(811.4,SUB,0)),U,2,3)
 .I $P(TAG,U,2)_";"_$P(TAG,U)=ROUTINE S FOUND=SUB
 Q FOUND
 ;
 ;Error Handler
 ;-------------
ERR N ERROR,IC,REF
 S ERROR(1)="Unable to convert reminder : "_$P($G(^PXD(811.9,IEN,0)),U)
 S ERROR(2)="Error in UPDATE^DIE, needs further investigation"
 ;Move MSG into ERROR
 S REF="MSG"
 F IC=3:1 S REF=$Q(@REF) Q:REF=""  S ERROR(IC)=REF_"="_@REF
 ;Screen message
 D BMES^XPDUTL(.ERROR)
 ;Mail Message
 D ERR^PXRMV1IE(.ERROR)
 Q
