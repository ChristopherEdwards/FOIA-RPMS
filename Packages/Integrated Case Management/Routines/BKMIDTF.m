BKMIDTF ;PRXM/HC/CJS - BKMV UTILITY PROGRAM; [ 1/19/2005 7:16 PM ] ; 15 Jul 2005
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
 ;PRXM/HC/CJS 07/14/2005 -- This function can be replaced by a call to FMTE^XLFDT.
 ;Since this one is called by so many BKM* routines, we will place a call to FMTE here.
DATE(BKMIDT) ;EP - Returns MM/DD/YYYY from internal FILEMAN date
 N BKMDT
 S BKMDT=$$FMTE^XLFDT(BKMIDT,"5Z")
 Q BKMDT
