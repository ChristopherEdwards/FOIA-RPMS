INHUTIL1 ;FRW ; 10 Feb 92 07:56; GIS Functions 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
SYS() ;Get curent system
 ;OUTPUT
 ;  function - VA, SC, or NULL (error)
 ;
 N %
 S %=$G(^DIW(0)) I $P(%,"^",1)="WINDOW",+$P(%,"^",2)=1.2 Q "SC"
 S %=$G(^DPT(0)) I $P(%,"^",1)="PATIENT",+$P(%,"^",2)=2 Q "VA"
 Q ""
 ;
SYSNAME(%) ;Get system name
 ;INPUT:
 ;  % - type of system (from $$SYS)
 ;
 ;OUTPUT:
 ;  function - system name
 ;
 I %="SC" Q "SAIC-Care"
 I %="VA" Q "DHCP"
 Q ""
 ;
SC() ;Is this system SAIC-Care
 ;Returns 1 if so, 0 otherwise
 ;This function will also return a 0 if the system is an Indian
 ;Health Service (IHS) system. Syntax used within the GIS that
 ;checks $$SC^INHUTIL1 is used for branching logic to use
 ;ScreenMan screens instead of WindowMan screens and for
 ;other IHS/VA specific functionality.
 Q $$SYS="SC"
 ;
 ;
