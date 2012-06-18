BSDP7PST ;cmi/anch/maw - PIMS Patch 1007 Post Init 2/27/2007 10:32:52 AM
 ;;5.3;PIMS;**1007**;FEB 27,2007;
 ;
 ;
 ;
 ;
EN ;EP - Post Init Entry Point
 D KIDX(2,.082,"AAVABDW4","K")
 D ADDMENU
 D RMLTI("BSDRM FILE ROOM LIST","DOB")
 D MPIS
 Q
 ;
KIDX(FL,FLD,XREF,FLG) ;-- kill of the AAVABDW4 index from file 2 field .082 per LJF 2/23/2007
 D DELIX^DIKD(FL,FLD,XREF,FLG)
 Q
 ;
ADDMENU ;-- add menu items
 N X
 I '$O(^DIC(19,"B","BSD LETTER CUSTOM PRINT",0)) D
 . S X=$$ADD^XPDMENU("BSDMENU","BSD LETTER CUSTOM PRINT","PCL",66)
 . I 'X W !,"Attempt to add BSD LETTER CUSTOM PRINT option failed.." H 3
 I '$O(^DIC(19,"B","BSD ORIGINAL CLINIC DISPLAY",0)) D
 . S X=$$ADD^XPDMENU("BSDMENU","BSD ORIGINAL CLINIC DISPLAY","OAS",55)
 . I 'X W !,"Attempt to add BSD ORIGINAL CLINIC DISPLAY option failed.." H 3
 I '$O(^DIC(19,"B","BSDRM CHECKIN AUTO REFRESH",0)) D
 . S X=$$ADD^XPDMENU("BSDMENU","BSDAM CHECKIN AUTO REFRESH","CHK",25)
 . I 'X W !,"Attempt to add CHECKIN AUTO REFRESH report option failed.." H 3
 Q
 ;
RMLTI(LT,IT) ;-- remove an item from the List Template File
 N LTI,ITI
 S LTI=$O(^SD(409.61,"B",LT,0))
 Q:'LTI
 S ITI=$O(^SD(409.61,LTI,"COL","B",IT,0))
 Q:'ITI
 S DA(1)=LTI,DA=ITI
 S DIK="^SD(409.61,"_LTI_","_"""COL"""_","
 D ^DIK
 Q
 ;
MPIS ;-- stuff parameters so software doesn't try to access MPI via HL7
 ;per linda fels email 4/6/2007
 S DIE=26.18
 S DR="2///0;3///0"
 S DA=1
 D ^DIE
 Q
 ;
