PXRMSAPG ; SLC/PKR - Set Clinical Reminders application group. ;05/17/2000
 ;;1.5;CLINICAL REMINDERS;;Jun 19, 2000
 ;===============================================================
SAPP ;
 D BMES^XPDUTL("Add ""PXRS"" Application Group to file 80, 80.1, 81")
 D MES^XPDUTL("This is done only if it is not already there.")
 N DA,DD,DIC,DO,FN
 F FN=80,80.1,81 I '$D(^DIC(FN,"%","B","PXRS")) D
 . S DIC="^DIC("_FN_",""%"","
 . S DIC(0)="L"
 . S DA(1)=FN
 . S X="PXRS"
 . S DIC("P")=$P(^DD(1,10,0),"^",2)
 . D FILE^DICN
 . K DA,DD,DIC,DO
 . D:+Y>0 BMES^XPDUTL("Adding ""PXRS"" Application Group to ^DIC("_FN_",")
 Q
 ;
