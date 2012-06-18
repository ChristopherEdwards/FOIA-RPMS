ABSPOSS7 ; IHS/FCS/DRS - Summary of POS insurers ; 
 ;;1.0;PHARMACY POINT OF SALE;**16,21**;JUN 21, 2001
 ;IHS/SD/RLT - 3/3/06 - Patch 16
 ;             Created new ABSP INSURERS 2 sort template
 ;             with NDC BIN Number sort level added.
 ;IHS/SD/RLT - 05/22/07 - Patch 21
 ;             Created new ABSP INSURERS 3 sort template
 ;             with INSURER NPI FLAG sort level added.
 Q
ABSPOSS1 ;EP - option ABSP SETUP SUMMARY
 ;D TEMPLATE^ABSPOSS2("ABSP INSURERS",9002313.4)
 ;D TEMPLATE^ABSPOSS2("ABSP INSURERS 2",9002313.4,"ABSP INSURERS")
 D TEMPLATE^ABSPOSS2("ABSP INSURERS 3",9002313.4,"ABSP INSURERS")
 Q
