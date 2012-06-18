BKM2ENV ;VNGT/HS/ALA-Environment check program ; 12 Mar 2009  2:31 PM
 ;;2.0;HIV MANAGEMENT SYSTEM;;May 29, 2009
 ;
ENV ; Environment check
 ;
 ; Check for versions
 I $$VERSION^XPDUTL("BKM")'="1.0" D  Q
 . I $$VERSION^XPDUTL("BKM")="2.0" Q
 . I $$VERSION^XPDUTL("BKM")="1.1" Q
 . S XPDQUIT=3
 ;
 I '$$PATCH^XPDUTL("BKM*1.0*4") S XPDQUIT=3
 Q
