GMTSY64 ; SLC/dcm - Health Summary Patch 64 Post init ; 01/06/2003
 ;;2.7;Health Summary;**64**;Oct 20, 1995
 ;
EN ; Add an occurrance limit of 50 to Remote HS Progress Notes Reports
 N IFN,IFN1,NAME,PN
 S PN=$O(^GMT(142.1,"B","PROGRESS NOTES",0))
 Q:'PN
 S NAME="REMOTE"
 F  S NAME=$O(^GMT(142,"B",NAME)) Q:NAME=""!(NAME]"REMOTEZ")  D
 . S IFN=$O(^GMT(142,"B",NAME,0))
 . Q:'IFN  Q:'$O(^GMT(142,IFN,1,0))
 . S IFN1=0
 . F  S IFN1=$O(^GMT(142,IFN,1,IFN1)) Q:'IFN1  I $P(^(IFN1,0),"^",2)=PN D
 .. S $P(^GMT(142,IFN,1,IFN1,0),"^",3)=50
 Q
