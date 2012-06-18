BQI2ENV ;VNGT/HS/ALA-Environment Check ; 12 Mar 2009  1:48 PM
 ;;2.0;ICARE MANAGEMENT SYSTEM;;May 29, 2009
 ;
ENV ; Environment check
 ; Save off users
 I '$D(^XTMP("BKM 2.0")) M ^XTMP("BKM 2.0",11)=^BKM(90450,1,11)
 ;
 I $$VERSION^XPDUTL("BKM")'="1.0" D  Q
 . I $$VERSION^XPDUTL("BKM")="2.0" Q
 . I $$VERSION^XPDUTL("BKM")="1.1" Q
 . S XPDQUIT=3 D MES^XPDUTL($$CJ^XLFSTR("**HIV Management System must have at least BKM version 1.0 patch 4 or version 1.1 installed.**",IOM))
 ;
 I '$$PATCH^XPDUTL("BKM*1.0*4") S XPDQUIT=3 D MES^XPDUTL($$CJ^XLFSTR("**HIV Management System must have at least BKM version 1.0 patch 4 or version 1.1 installed.**",IOM))
 Q
