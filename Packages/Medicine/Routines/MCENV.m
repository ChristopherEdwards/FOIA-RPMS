MCENV ; HISC/NCA - Environment Check Routine For Patch 5 ;9/29/95  14:14
 ;;2.3;Medicine;**5**;09/13/1996
CHECK ; Check For Version and exclude Routine Install.
 Q:$$VERSION^XPDUTL("MC")=2.3
 D MES^XPDUTL("Site Not Running Medicine Version 2.3.")
 Q:'$$RTNUP^XPDUTL("MCARPCS1",2)
 Q:'$$RTNUP^XPDUTL("MCBPFTP1",2)
 Q
