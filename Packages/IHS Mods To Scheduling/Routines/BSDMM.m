BSDMM ; IHS/ANMC/LJF - IHS CALLS FROM SDMM ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
GETNXB ;EP; find next biweekly date
 S X1=SDDAT,X2=14 D C^%DTC S POP=0 D INACT^SDMM Q:POP
 S SDDAT=X G:$D(^HOLIDAY(SDDAT,0))&('SDSOH) GETNXB S Y=SDDAT_SDOT
 Q
 ;
GETNXM ;EP; find next month date
 NEW DOW,DOM,NUM,FIRST,FDOW,X
 S DOW=$$DOW^XLFDT(SDDAT,1)            ;day of week of starting date
 S DOM=$E(SDDAT,6,7)                   ;day of month of starting date
 S NUM=DOM\7+$S(DOM#7=0:0,1:1)         ;number of dow in month (1st,2nd)
 ;
 S FIRST=$$FIRST(SDDAT)                ;1st day of next month
 ;
 S FDOW=$$DOW^XLFDT(FIRST,1)           ;dow of first day next month
 S X=$$FMADD^XLFDT(FIRST,(DOW-FDOW))   ;find 1st matching dow new month
 I NUM>1 S X=$$FMADD^XLFDT(X,(7*(NUM-1)))   ;go to correct week
 I $E(X,4,5)'=$E(FIRST,4,5) S POP=1 Q  ;quit if no fifth dow in month
 ;
 S POP=0 D INACT^SDMM Q:POP
 S SDDAT=X G:$D(^HOLIDAY(SDDAT,0))&('SDSOH) GETNXM
 S Y=SDDAT_SDOT
 Q
 ;
FIRST(DATE) ; returns first day of next month
 NEW MON,YR
 S MON=$E(DATE,4,5)+1                       ;get next month
 S YR=$E(DATE,1,3) S:MON=13 MON=1,YR=YR+1   ;check for January
 Q ((YR_"00")+MON)_"01"
