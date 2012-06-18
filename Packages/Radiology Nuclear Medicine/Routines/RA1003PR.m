RA1003PR ; ; 08 Dec 2010  9:17 AM
 ;
 ;Pre-Init Environment Check routine for VA Radiology patch 1003
 ;
 F X="XPM1","XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 ;
 K XPDQUIT
 ;
 Q
 ;
