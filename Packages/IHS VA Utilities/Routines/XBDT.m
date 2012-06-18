XBDT ;IHS/HQW/JDH - date/time utilities ;[ 06/19/1998  11:11 AM ]
 ;;3.0;IHS/VA UTILITIES;**6**;JUNE 17, 1998
 ;             
 ;FISCAL
 ;  usage:  S %=$$FISCAL^XBDT(XBDT,XBFYMTH,XBADJ)
 ;
 ;  Input: (all parameters are optional)
 ;      XBDT Date in either fileman of horlog format.  If not defined,
 ;           default is today.
 ;      XBFYMT Month beginning fiscal year.  The definition of this 
 ;           variable can be assigned in the parameter list.  If it 
 ;           is not and Beginning fiscal year month field in the 
 ;           PCC MASTER CONTROL file is valued for the current locaton,
 ;           its value is used. The default is 10. 
 ;      XBADJ  The value of this variable allows the adjustment of the
 ;             FY value
 ;
 ;   Output: current fiscal year^star date of FY^end date of FY 
 ;
 ;LEAP
 ; input: (optional) date in Fileman, yyyy or horlog
 ; output: boolean 1=yes 0=no
 ; uses algorithm defined for leap year in the RPMS Y2000 Compliance Plan
 ;
FISCAL(XBDT,XBFYMTH,XBADJ) ; return current fiscal year
 ; 
 N %,T,T1,T2,XBFY,XBFYBEG,XBFYEND
 S XBADJ=$G(XBADJ) ; adjustment variable
 S:'$G(XBDT) XBDT=$$NOW^XLFDT
 S:XBDT["," XBDT=$$HTFM^XLFDT(XBDT) ; horolog to fileman
 S T=$P($G(^APCCCTRL(DUZ(2),0)),U,8) ; beg, FY month for location from PCC MASTER CONTROL file
 S:'$G(XBFYMTH) XBFYMTH=$S(T:T,1:10) ; use month entered, as in MSTR file or 10
 S XBFYMTH=$E("0",XBFYMTH<10)_XBFYMTH ; if month is less then 10 make it two digits
 S T1=XBFYMTH-1<$E(XBDT,4,5) ; boolean.  month before or after FY start month
 S T2=XBDT\10000-'T1 ; current year in FM 3 digit year format plus 1 or 0 determined by T1 calculation
 S XBFY=XBDT\10000+T1 ; fiscal Year in external 4 digit format
 S XBFYBEG=T2_XBFYMTH_"01" ; beginning of fiscal year
 S %=T2+1_XBFYMTH_"01"
 S XBFYEND=$$FMADD^XLFDT(%,-1) ;get the beginning date of the fiscal year
 Q XBFY+1700+XBADJ_U_XBFYBEG_U_XBFYEND
 ;
 ;
 ;
LEAP(XBDT) ; is the year a leap year? 
 ;
 S:'$G(XBDT) XBDT=$$NOW^XLFDT
 S:XBDT["," XBDT=$$HTFM^XLFDT(XBDT) ; horolog to fileman
 S:$L(XBDT)>4 XBDT=XBDT\10000+1700 ; 4 digit date
 Q '(XBDT#4)&(XBDT#100)!('(XBDT#100)&'(XBDT#400)) ; leap year algorithm
 ;
