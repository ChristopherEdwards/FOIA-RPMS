ADEPENDN ; IHS/HQT/MJL  - ENDO REPORT NOTES ;  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;
 ;STEP 1:  Get template with dfns of all tooth access visits
 ;Get Date range into ADEDATE
 ;Zero out ADEPROV,ADESTP,ADEAGE,ADELOC,ADEHYG screens
 ;Set ADEADA(1) to look for all accessed teeth
 ;Setup template ADEQA ENDO to store visit hits
 ;Call ADEPQA to run search with no printout
 ;STEP 2:
 ;Set ADESTP=ADEQA ENDO
 ;Set ADEPROV for a dentist (zero out other screens)
 ;For each dentist loop thru following
 ;Set ADEADA(1) for accessed, accessed + extracted,
 ; +completed, +alloy restored, +crown restored
 ;Kill ADEUTL("ADEPQA")
 ;Call ADEPQA with each value of ADEADA(1)
 ;After search, count entries in ADEUTL("ADEPQA")
 ;Set results array ADEREP as follows:
 ;ADEREP(DENTIST NAME")="Total Accessed^+extracted^+completed^+alloy restored^+crown restored"
 ;STEP 3: Call DIP to print out the results array
 ;STEP 4: Delete templates
 ;
PRINT ;
 ;NOTE:  Have to call %ZIS because Fileman tries
 ;to write to device before opening it (+32^DIP).
 ;(Only seems to be a problem when queueing to HFS.)
 ;Then have to restore IOP and %ZIS("IOPAR") because
 ;Fileman later (DIP3) calls %ZIS to open the device,
 ;and he needs to have IOP and %ZIS("IOPAR") then.
