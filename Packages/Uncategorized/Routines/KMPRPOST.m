KMPRPOST ;SF/RAK - RUM Post Install Routine ;3/27/00  10:56 [ 03/13/2003  1:31 PM ]
 ;;1.0;CAPACITY MANAGEMENT - RUM;**1,2**;Dec 09, 1998
 ;;
 ;
 ; This post install routine is for RUM patch KMPR*1.0*2
 ;
EN ;-- entry point.
 ;
 N IEN
 ; get ien for backgroung job.
 S IEN=$O(^DIC(19,"B","KMPR BACKGROUND DRIVER",0)) Q:'IEN
 ; get ien for background driver from 'option scheduling' file.
 S IEN=$O(^DIC(19.2,"B",+IEN,0))
 ; if scheduled then no further action necessary
 Q:IEN
 ; if OptenM/Cache then schedule background driver
 D:$P($G(^%ZOSF("OS")),"^")["OpenM" QUEBKG^KMPRUTL1
 ;
 Q
