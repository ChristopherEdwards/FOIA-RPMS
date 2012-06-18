APCPREXP ;IHS/CMI/LAB -  [ 09/27/99  8:10 AM ]
 ;
 ;
 NEW X
 S X=$$ADD^XPDMENU("APCPMENU","APCP RE-EXPORT MENU","REX",99)
 I 'X W "Attempt to add Re-Export Menu failed." H 3
 Q
