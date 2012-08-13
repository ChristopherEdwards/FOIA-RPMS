INSY201 ;slt;19 Aug 1994@090357;compiled gis system data
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
 ;
EN F I=1:2 S %ODD=$E($T(EN+I),4,999) Q:%ODD=""  S %EVEN=$E($T(EN+(I+1)),4,999) S X="^UTILITY(""INHSYS"","_$J_","_$P(%ODD,",",2,99),@X=%EVEN
 ;;^UTILITY(562037788,"TT",20,0)
 ;;HL RAD RESULTS^^^^1^^^O
 Q
