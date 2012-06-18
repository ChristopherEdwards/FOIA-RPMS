DG53293D ;AR/BP - ALS Extract; 9/27/00  14:54PM
 ;;5.3;Registration;**293**;Aug 13,  1993
 ;
 ;Description:
 ;Patient data will be extracted from the Patient file (#2) for all 
 ;hospital sites.  Station numbers and SSN's have been provided and 
 ;stored in file^XTMP.
 ;
 ;
EN N DGARY
 I $D(DUZ)'=11 DO  Q
 . D BMES^XPDUTL("     Missing DUZ variables.")
 . S DGARY(1)=("     To set up the DUZ variables do:")
 . S DGARY(2)=("")
 . S DGARY(3)=("     >D ^XUP")
 . S DGARY(4)=("")
 . S DGARY(5)=("     Setting up programmer environment")
 . S DGARY(6)=("     Access Code: <enter your access code>")
 . S DGARY(7)=("")
 . S DGARY(8)=("     Terminal Type set to: C-VT320")
 . S DGARY(9)=("")
 . S DGARY(10)=("     Select OPTION NAME: <press the return key>")
 . S DGARY(11)=("")
 . S DGARY(12)=("     >D EN^DG53293A")
 . S DGARY(13)=("")
 . D MES^XPDUTL(.DGARY)
 ;
 ;Description:
 ;  Retrive the site station number, if not found display message
 ;  If found queue this routine to run which will load the data.
 ;
 N DGARY,XMDUZ,XMSUB,XMY,XMZ,ZTDESC,ZTIO,ZTSK,ZTQUEUED,ZTRTN
 ;
 S DGTATION=+$P($$SITE^VASITE(),U,3)
 I 'DGTATION DO  Q
 . D BMES^XPDUTL("Station number not defined in Division file") Q
 ;
 D BMES^XPDUTL()
 S DGARY(1)=("       >>> ALS Extract <<< ")
 S DGARY(2)=("   Please queue to run at a non peak time.")
 S DGARY(3)=("   This extract will generate 2 mail messages to you.")
 S DGARY(4)=("   One of the messsages will contain the data extracted")
 S DGARY(5)=("   and the second message will contain any errors that")
 S DGARY(6)=("   may have occurred during the ALS extract.")
 D MES^XPDUTL(.DGARY)
 ;
 ;Queue routine to run NOW
 S ZTIO="",ZTRTN="START^DG53293A"
 S ZTDESC="DG*5.3*293 - VA Patient Survey"
 D ^%ZTLOAD,HOME^%ZIS
 I $G(ZTSK) D BMES^XPDUTL("               Task Number = "_ZTSK)
 Q
