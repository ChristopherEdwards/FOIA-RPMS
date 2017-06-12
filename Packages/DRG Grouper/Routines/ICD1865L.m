ICD1865L ;ALB/JDG - UPDATE DX & PX CODES ; 10/5/11 3:23pm
 ;;18.0;DRG Grouper;**65**;Oct 20,2000;Build 7
 ;
 Q
 ;
 ; Update Dx code(s)
 ;
CODENOCC ;entry point to add 'CODE NOT CC WITH' to Dx code 482.42
 ;
 N SDA,SDB,ICDA,ICDA1,LINE,LINEXX,ICDTXT,ICDEDXIEN
 S ICDA=0,ICDA1="",ICDEDXIEN=14734
 F  S ICDA=$O(^ICD9(ICDEDXIEN,2,ICDA)) Q:ICDA=""!(ICDA1=9119)  D
 .S ICDA1=$P(^ICD9(ICDEDXIEN,2,ICDA,0),U,1)
 I ICDA1=9119 D MESSTWO Q
 S SDA(1)="",SDA(2)=" Adding missing diagnosis code to CODE NOT CC WITH sub-file "
 S SDA(3)=" (#80.03) in the ICD DIAGNOSIS file (#80) for Dx code 482.42 "  D MESSONE
 F LINE=1:1 S LINEXX=$T(PROCUP1+LINE) S ICDTXT=$P(LINEXX,";;",2) Q:ICDTXT="EXIT"  D
 .S ICDFDA(80.03,"?+1,"_ICDEDXIEN_",",.01)=ICDTXT
 D UPDATE^DIE("","ICDFDA") K ICDFDA
 Q
 ;
 ;
MESSONE ;
 D MES^XPDUTL(.SDA) K SDA
 Q
 ;
 ;
MESSTWO ;
 S SDB(1)="",SDB(2)=" Diagnosis code 487.0 already exists. "
 S SDB(3)=" Nothing added to CODE NOT CC WITH sub-file (#80.03) "
 S SDB(4)=" in the ICD DIAGNOSIS file (#80) for Dx code 482.42 "
 D MES^XPDUTL(.SDB) K SDB
 Q
 ;
 ;
PROCUP1 ; IEN's of the missing Dx codes being added to CODE NOT CC WITH sub-file (#80.03) in the ICD DIAGNOSIS file (#80) for code 482.42
 ;;9119
 ;;EXIT
