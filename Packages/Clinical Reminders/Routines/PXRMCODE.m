PXRMCODE ; SLC/PKR - Routines for handling standard coded items. ;04/03/2000
 ;;1.5;CLINICAL REMINDERS;;Jun 19, 2000
 ;
 ;=======================================================================
VCICD0 ;This is the screen for ICD0 codes, subfile 811.22102.
 I '$D(X) Q
 N RETVAL
 S RETVAL=$$CODE^PXRMVAL(X,80.1)
 I '(+RETVAL) D
 . D EN^DDIOL($P(RETVAL,U,4))
 . K X
 Q
 ;
 ;=======================================================================
VCICD9 ;This is the screen for ICD9 codes subfile 811.22103.
 I '$D(X) Q
 N RETVAL
 S RETVAL=$$CODE^PXRMVAL(X,80)
 I '(+RETVAL) D
 . D EN^DDIOL($P(RETVAL,U,4))
 . K X
 Q
 ;
 ;=======================================================================
VCICPT ;This is the screen for CPT codes subfile 811.22104.
 I '$D(X) Q
 N RETVAL
 S RETVAL=$$CODE^PXRMVAL(X,81)
 I '(+RETVAL) D
 . D EN^DDIOL($P(RETVAL,U,4))
 . K X
 Q
 ;
